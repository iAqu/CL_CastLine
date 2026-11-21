local ContextActionService = game:GetService("ContextActionService")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local FishInventoryData = require(ReplicatedStorage.Modules.FishInventoryData)
local FishTitleUtil = require(ReplicatedStorage.Modules.FishTitleUtil)
local Knit = require(ReplicatedStorage.Packages.Knit)
local FishAnimationController = require(ReplicatedStorage.Modules.FishAnimationController)
local GameplayInputGate = require(ReplicatedStorage.Modules.GameplayInputGate)
local DropVFXUtil = require(ReplicatedStorage.Modules.DropVFXUtil)
local ItemTitlePositionUtil = require(ReplicatedStorage.Modules.ItemTitlePositionUtil)
local ItemToolUtil = require(ReplicatedStorage.Modules.ItemToolUtil)
local MutationDataUtil = require(ReplicatedStorage.Modules.MutationDataUtil)
local MutationVisualUtil = require(ReplicatedStorage.Modules.MutationVisualUtil)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local PlotUpgradeData = require(ReplicatedStorage.Modules.PlotUpgradeData)
local PlotFishMotion = require(ReplicatedStorage.Modules.PlotFishMotion)
local PlotWorkspaceUtil = require(ReplicatedStorage.Modules.PlotWorkspaceUtil)

local LOCAL_PLAYER = Players.LocalPlayer
local TITLE_HOME_HEIGHT_OFFSET = 2
local RENDER_DISTANCE = 160
local RENDER_EXIT_DISTANCE = 172
local DISPLAY_RECHECK_SECONDS = 0.25
local GAMEPAD_PLACE_ACTION = "PlacePlotFish"

local PlotFishController = Knit.CreateController({ Name = "PlotFishController" })

local function setDisplayPartProperties(model: Model)
	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.Anchored = true
			descendant.CanCollide = false
			descendant.CanTouch = false
			descendant.CanQuery = false
		end
	end
end

local function makeMarker(name: string): Part
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.CanCollide, part.CanTouch, part.CanQuery = false, false, false
	part.CastShadow = false
	part.Transparency = 1
	return part
end

local function createPreview(): Part
	local marker = makeMarker("FishEntryPreview")
	marker.Size = Vector3.new(0.04, 1.5, 1.5)
	marker.Shape = Enum.PartType.Cylinder
	marker.Material = Enum.Material.Neon
	marker.Color = Color3.fromRGB(136, 235, 255)
	marker.Parent = Workspace
	return marker
end

local function splash(position: Vector3)
	local effects = ReplicatedStorage:FindFirstChild("VFX")
	local fishing = effects and effects:FindFirstChild("Fishing")
	local template = fishing and fishing:FindFirstChild("Splash")
	if not template or not template:IsA("BasePart") then
		warn("PlotFishController: VFX.Fishing.Splash is missing")
		return
	end
	local part = template:Clone()
	part.Anchored = true
	part.CanCollide, part.CanTouch, part.CanQuery = false, false, false
	part.CFrame = CFrame.new(position)
	part.Parent = Workspace
	for _, descendant in part:GetDescendants() do
		if descendant:IsA("ParticleEmitter") then
			descendant.Enabled = false
			descendant:Emit(math.max(1, math.floor((descendant:GetAttribute("BurstCount") or 1) * 0.6)))
		end
	end
	Debris:AddItem(part, 2)
end

local function getHeldTool(): Tool?
	local character = LOCAL_PLAYER.Character
	return character and character:FindFirstChildOfClass("Tool")
end

local function getRoot(): BasePart?
	local character = LOCAL_PLAYER.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local root = character and character:FindFirstChild("HumanoidRootPart")
	return if humanoid and humanoid.Health > 0 and root and root:IsA("BasePart") then root else nil
end

function PlotFishController:KnitStart()
	local service = Knit.GetService("PlotFishService")
	local plotRoot
	local displays = {}
	local nearbyPlots = {}
	local preview = createPreview()
	local requestInFlight = false

	local function request(callback, fallback: string, onSuccess)
		if requestInFlight then
			return
		end
		requestInFlight = true
		callback()
			:andThen(function(response)
				if response and response.ok then
					if onSuccess then
						onSuccess(response)
					end
				else
					NotificationClient.RedNotify((response and response.message) or fallback)
				end
			end)
			:catch(function()
				NotificationClient.RedNotify(fallback)
			end)
			:finally(function()
				requestInFlight = false
			end)
	end

	local function getLocalPlot(): Instance?
		local slot = LOCAL_PLAYER:GetAttribute("PlotSlotId")
		local plot = plotRoot and typeof(slot) == "number" and plotRoot:FindFirstChild("Plot_" .. tostring(slot))
		return if plot and plot:GetAttribute("OwnerUserId") == LOCAL_PLAYER.UserId then plot else nil
	end

	local function getPlacement(tool)
		local uid = ItemToolUtil.GetInstanceId(tool)
		if not uid or not GameplayInputGate.IsPlacementActionAllowed() then
			return nil
		end
		local plot = getLocalPlot()
		local boundary = plot and PlotFishMotion.GetBoundary(plot)
		local root = getRoot()
		local entry = boundary and root and PlotFishMotion.GetEntry(boundary, root)
		if not plot or not boundary or not entry then
			return nil
		end
		local folder = plot:FindFirstChild(PlotFishMotion.FOLDER_NAME)
		local occupied = {}
		if folder and folder:GetAttribute("OwnerUserId") == LOCAL_PLAYER.UserId then
			for _, fish in folder:GetChildren() do
				local slot = fish:GetAttribute("Slot")
				if typeof(slot) == "number" then
					occupied[slot] = true
				end
			end
		end
		local emptySlot
		for slot = 1, PlotUpgradeData.GetCapacity(LOCAL_PLAYER:GetAttribute("PlotUpgradeLevel")) do
			if not occupied[slot] then
				emptySlot = slot
				break
			end
		end
		return uid, boundary, entry, emptySlot
	end

	local function tryPlace(): boolean
		local uid = getPlacement(getHeldTool())
		if not uid then
			return false
		end
		request(
			function()
				return service:RequestPlace(uid)
			end,
			"Could not place this fish.",
			function(response)
				splash(response.position)
				NotificationClient.GreenNotify("Fish placed!")
			end
		)
		return true
	end

	local function addDisplay(fish, plot, boundary, ownerId, now)
		if not fish:IsA("Configuration") then
			return
		end
		local weight, itemId = fish:GetAttribute("Weight"), fish:GetAttribute("ItemId")
		local item = typeof(itemId) == "string" and FishInventoryData[itemId]
		local started = fish:GetAttribute("StartedAt")
		local move = PlotFishMotion.Decode(fish:GetAttribute(PlotFishMotion.MOVE_ATTRIBUTE))
		if not item or typeof(weight) ~= "number" or typeof(started) ~= "number" or not move then
			return
		end
		local mutationId = MutationDataUtil.NormalizeMutationId(fish:GetAttribute("MutationId"))
		local geometry = PlotFishMotion.GetGeometry(item, weight, boundary)
		if not geometry then
			return
		end
		local model = geometry.template:Clone()
		model.Name = "PlotFish_" .. fish.Name
		model:ScaleTo(model:GetScale() * geometry.scale)
		setDisplayPartProperties(model)
		local bodyToPivot = model.PrimaryPart.CFrame:ToObjectSpace(model:GetPivot())
		local floatPhase = PlotFishMotion.GetFloatPhase(fish.Name)
		local pose = PlotFishMotion.Sample(boundary, geometry.height, move, now, floatPhase)
		model:PivotTo(pose * bodyToPivot)
		if ownerId == LOCAL_PLAYER.UserId then
			local outline = Instance.new("Highlight")
			outline.Name = "PlotFishOutline"
			outline.Adornee = model
			outline.FillTransparency = 1
			outline.OutlineColor = Color3.new(0, 0, 0)
			outline.OutlineTransparency = 0
			outline.DepthMode = Enum.HighlightDepthMode.Occluded
			outline.Parent = model
		end
		model.Parent = plot

		MutationVisualUtil.Apply(model, mutationId, geometry.template.Name)
		if item.IsRareReward == 1 then
			DropVFXUtil.AttachRarityPointLight(model, item.Rarity)
		end
		local titleAnchor = makeMarker("FishTitleAnchor")
		titleAnchor.Size = Vector3.new(0.1, 0.1, 0.1)
		titleAnchor.Position = pose.Position
		titleAnchor.Parent = model
		local titleGui = StarterGui:FindFirstChild("TitleGui")
		local owner = Players:GetPlayerByUserId(ownerId)
		local title = FishTitleUtil.Create(titleGui, item, mutationId, owner, weight)
		if title then
			title.Enabled = true
			title.Adornee = titleAnchor
			title.Parent = titleAnchor
			ItemTitlePositionUtil.ApplyBottomOffset(title, model, TITLE_HOME_HEIGHT_OFFSET)
		end

		local display = {
			boundary = boundary,
			bodyToPivot = bodyToPivot,
			model = model,
			ownerId = ownerId,
			mutationId = mutationId,
			height = geometry.height,
			floatPhase = floatPhase,
			move = move,
			started = started,
		}
		displays[fish] = display
		display.moveChanged = fish:GetAttributeChangedSignal(PlotFishMotion.MOVE_ATTRIBUTE):Connect(function()
			local updated = PlotFishMotion.Decode(fish:GetAttribute(PlotFishMotion.MOVE_ATTRIBUTE))
			if updated then
				display.move = updated
			end
		end)
	end

	local function removeDisplay(fish: Instance)
		local display = displays[fish]
		if display then
			displays[fish] = nil
			display.moveChanged:Disconnect()
			if display.animation then
				display.animation:Destroy()
			end
			display.model:Destroy()
		end
	end

	local function reconcileDisplays(now, root, camera)
		local areas = Workspace:FindFirstChild("Areas")
		plotRoot = areas and areas:FindFirstChild("Plot")
		local present, nearby = {}, {}
		for _, plot in if plotRoot then plotRoot:GetChildren() else {} do
			if not PlotWorkspaceUtil.isValidPlot(plot) then
				continue
			end
			local folder = plot:FindFirstChild(PlotFishMotion.FOLDER_NAME)
			local ownerId = plot:GetAttribute("OwnerUserId")
			local boundary = PlotFishMotion.GetBoundary(plot)
			if not boundary or not folder or typeof(ownerId) ~= "number"
				or ownerId == 0 or folder:GetAttribute("OwnerUserId") ~= ownerId
			then
				continue
			end
			local position = boundary.Position
			local distance = if nearbyPlots[plot] then RENDER_EXIT_DISTANCE else RENDER_DISTANCE
			if not ((root and (root.Position - position).Magnitude <= distance)
				or (camera and (camera.CFrame.Position - position).Magnitude <= distance)) then
				continue
			end
			nearby[plot] = true
			for _, fish in folder:GetChildren() do
				present[fish] = true
				local display = displays[fish]
				if display and (display.boundary ~= boundary or display.ownerId ~= ownerId
					or display.model.Parent ~= plot
					or display.mutationId ~= MutationDataUtil.NormalizeMutationId(fish:GetAttribute("MutationId")))
				then
					removeDisplay(fish)
					display = nil
				end
				if not display then
					addDisplay(fish, plot, boundary, ownerId, now)
				end
			end
		end
		nearbyPlots = nearby
		for fish in displays do
			if not present[fish] then
				removeDisplay(fish)
			end
		end
	end

	UserInputService.InputBegan:Connect(function(input, processed)
		if
			not processed
			and input.UserInputType == Enum.UserInputType.MouseButton1
			and UserInputService.PreferredInput ~= Enum.PreferredInput.Touch
		then
			tryPlace()
		end
	end)
	UserInputService.TouchTapInWorld:Connect(function(_, processed)
		if not processed then
			tryPlace()
		end
	end)
	ContextActionService:BindActionAtPriority(GAMEPAD_PLACE_ACTION, function(_, state)
		if state == Enum.UserInputState.Begin and tryPlace() then
			return Enum.ContextActionResult.Sink
		end
		return Enum.ContextActionResult.Pass
	end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.ButtonR2)

	task.spawn(function()
		while LOCAL_PLAYER.Parent do
			reconcileDisplays(Workspace:GetServerTimeNow(), getRoot(), Workspace.CurrentCamera)
			task.wait(DISPLAY_RECHECK_SECONDS)
		end
	end)

	RunService.RenderStepped:Connect(function()
		local now = Workspace:GetServerTimeNow()
		for _, display in displays do
			local pose, swimWeight = PlotFishMotion.Sample(display.boundary, display.height, display.move, now, display.floatPhase)
			display.model:PivotTo(pose * display.bodyToPivot)
			if not display.animation then
				display.animation = FishAnimationController.new(display.model, display.started, nil, "SwimLoop")
			end
			display.animation:Update("Holding", display.started, now, nil, swimWeight)
		end

		local held = getHeldTool()
		if not held then
			if preview.Transparency ~= 1 then
				preview.Transparency = 1
			end
			return
		end
		local _, boundary, entry, slot = getPlacement(held)
		local item = held and FishInventoryData[held:GetAttribute(ItemToolUtil.ITEM_ID_ATTRIBUTE)]
		local weight = held and held:GetAttribute(ItemToolUtil.WEIGHT_ATTRIBUTE)
		local geometry = boundary
			and slot
			and item
			and typeof(weight) == "number"
			and PlotFishMotion.GetGeometry(item, weight, boundary)
		preview.Transparency = if geometry then 0.28 else 1
		if geometry then
			local point = PlotFishMotion.GetSurfacePoint(boundary, entry)
			preview.CFrame = CFrame.new(point) * boundary.CFrame.Rotation * CFrame.Angles(0, 0, math.pi * 0.5)
		end
	end)
end

return PlotFishController
