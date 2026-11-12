local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Knit = require(ReplicatedStorage.Packages.Knit)
local EggsData = require(ReplicatedFirst.Data.EggsData)
local EggToolUtil = require(ReplicatedStorage.Modules.EggToolUtil)
local Placement = require(ReplicatedStorage.Modules.EggPlacementUtil)
local GameplayInputGate = require(ReplicatedStorage.Modules.GameplayInputGate)
local EggInventory = require(ReplicatedStorage.Modules.EggInventory)
local ItemBoundsUtil = require(ReplicatedStorage.Modules.ItemBoundsUtil)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local PlotWorkspaceUtil = require(ReplicatedStorage.Modules.PlotWorkspaceUtil)

local player = Players.LocalPlayer
local Controller = Knit.CreateController({ Name = "EggPlacementController" })

function Controller:_clearPreview()
	if self._preview then
		self._preview:Destroy()
	end
	self._preview, self._uuid, self._position = nil, nil, nil
	self._valid = false
end

function Controller:_updatePreview(screenPosition)
	local character = player.Character
	local tool = character and character:FindFirstChildOfClass("Tool")
	local uuid = EggToolUtil.GetInstanceId(tool)
	local plot = PlotWorkspaceUtil.getPlotBySlot(player:GetAttribute("PlotSlotId"))
	local ground = plot and plot:FindFirstChild("Ground")
	local record = uuid and self._eggs[uuid]
	local config = record and EggsData[record.EggId]
	local template = config and EggToolUtil.GetTemplate(config.Model)
	if not template or not ground or record.Placement then
		self:_clearPreview()
		return
	end
	if self._uuid ~= uuid then
		self:_clearPreview()
		local model = template:Clone()
		model.Name = "EggPlacementPreview"
		for _, part in ipairs(model:GetDescendants()) do
			if part:IsA("BaseScript") then
				part:Destroy()
			elseif part:IsA("BasePart") then
				part.Anchored, part.CanCollide, part.CanTouch, part.CanQuery = true, false, false, false
				part.Transparency = math.max(part.Transparency, 0.45)
			end
		end
		local frame, size = ItemBoundsUtil.GetWorldAxisBounds(template)
		self._shape =
			{ size = size, offset = template:GetPivot():ToObjectSpace(frame), radius = math.max(size.X, size.Z) / 2 }
		local highlight = Instance.new("Highlight")
		highlight.FillTransparency, highlight.OutlineTransparency, highlight.Parent = 0.5, 0, model
		self._highlight = highlight
		self._preview, self._uuid = model, uuid
	end
	self._position, self._valid = nil, false
	local camera = Workspace.CurrentCamera
	if not camera then
		self._preview.Parent = nil
		return
	end
	local pointer = screenPosition or self._touchPosition or UserInputService:GetMouseLocation()
	local ray = camera:ScreenPointToRay(pointer.X, pointer.Y)
	local params = RaycastParams.new()
	params.FilterType, params.FilterDescendantsInstances = Enum.RaycastFilterType.Include, { ground }
	local hit = Workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
	if not hit then
		self._preview.Parent = nil
		return
	end
	local position = ground.CFrame:PointToObjectSpace(hit.Position)
	local neighbors = {}
	for _, egg in pairs(self._eggs) do
		if egg.Placement then
			local other = EggToolUtil.GetTemplate(EggsData[egg.EggId].Model)
			if other then
				local _, size = ItemBoundsUtil.GetWorldAxisBounds(other)
				table.insert(
					neighbors,
					{ X = egg.Placement.X, Z = egg.Placement.Z, Radius = math.max(size.X, size.Z) / 2 }
				)
			end
		end
	end
	local root = character:FindFirstChild("HumanoidRootPart")
	self._valid = root ~= nil
		and (root.Position - hit.Position).Magnitude <= Placement.MAX_DISTANCE
		and EggInventory.PlacedCount(self._eggs) < EggInventory.MAX_PLACED
		and Placement.Check(position.X, position.Z, self._shape.radius, ground.Size.X / 2, ground.Size.Z / 2, neighbors)
	self._position = hit.Position
	self._preview:PivotTo(
		ground.CFrame
			* CFrame.new(position.X, ground.Size.Y / 2 + self._shape.size.Y / 2, position.Z)
			* self._shape.offset:Inverse()
	)
	local color = if self._valid then Color3.fromRGB(90, 255, 130) else Color3.fromRGB(255, 85, 85)
	self._highlight.FillColor, self._highlight.OutlineColor = color, color
	if self._preview.Parent ~= Workspace then
		self._preview.Parent = Workspace
	end
end

function Controller:_place(screenPosition)
	if self._busy or not GameplayInputGate.IsPlacementActionAllowed() then
		return
	end
	self:_updatePreview(screenPosition)
	if not self._valid or not self._position or not self._uuid then
		return
	end
	self._busy = true
	self._service
		:PlaceEgg(self._uuid, self._position, 0)
		:andThen(function(result)
			self._busy = false
			if not result.ok then
				NotificationClient.RedNotify(result.message)
			end
		end)
		:catch(function(err)
			self._busy = false
			warn("EggPlacementController: " .. tostring(err))
		end)
end

function Controller:_updateWorld()
	local now = Workspace:GetServerTimeNow()
	for _, plot in ipairs(PlotWorkspaceUtil.getSortedPlots()) do
		local folder = plot:FindFirstChild("PlacedEggs")
		if folder then
			for _, model in ipairs(folder:GetChildren()) do
				local readyAt = model:GetAttribute("ReadyAt")
				local primary = model:IsA("Model") and model.PrimaryPart
				if primary and type(readyAt) == "number" then
					local remaining = math.max(0, math.ceil(readyAt - now))
					local timer = primary:FindFirstChild("EggTimer")
					local label = timer and timer:FindFirstChild("TimeLabel")
					if label then
						label.Text = if remaining == 0 then "Ready to Hatch!" else "Hatching: " .. remaining .. "s"
					end
					for _, prompt in ipairs(primary:GetChildren()) do
						if prompt:IsA("ProximityPrompt") then
							prompt.Enabled = GameplayInputGate.IsWorldActionAllowed()
								and model:GetAttribute("OwnerUserId") == player.UserId
								and (prompt.Name ~= "HatchPrompt" or remaining == 0)
						end
					end
				end
			end
		end
	end
end

function Controller:KnitStart()
	self._eggs = {}
	self._service = Knit.GetService("EggService")
	local received = false
	local function apply(state, message)
		if state then
			self._eggs = state.Eggs
		end
		if message then
			NotificationClient.RedNotify(message)
		end
	end
	self._service.InventoryChanged:Connect(function(state, message)
		received = true
		apply(state, message)
	end)
	self._service
		:GetState()
		:andThen(function(state)
			if not received then
				apply(state)
			end
		end)
		:catch(function(err)
			warn(tostring(err))
		end)
	UserInputService.InputBegan:Connect(function(input, processed)
		if not processed and input.UserInputType == Enum.UserInputType.MouseButton1 then
			self:_place()
		end
	end)
	UserInputService.TouchTap:Connect(function(points, processed)
		if not processed and points[1] then
			self._touchPosition = points[1]
			self:_place(points[1])
		end
	end)
	player.CharacterRemoving:Connect(function()
		self:_clearPreview()
	end)
	local nextWorldUpdate = 0
	RunService.RenderStepped:Connect(function()
		self:_updatePreview()
		if os.clock() >= nextWorldUpdate then
			self:_updateWorld()
			nextWorldUpdate = os.clock() + 0.2
		end
	end)
end

return Controller
