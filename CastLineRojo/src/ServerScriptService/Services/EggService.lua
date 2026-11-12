local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Knit = require(ReplicatedStorage.Packages.Knit)
local EggsData = require(ReplicatedFirst.Data.EggsData)
local PetInventory = require(ReplicatedStorage.Modules.PetInventory)
local EggInventory = require(ReplicatedStorage.Modules.EggInventory)
local EggToolUtil = require(ReplicatedStorage.Modules.EggToolUtil)
local Placement = require(ReplicatedStorage.Modules.EggPlacementUtil)
local ItemBoundsUtil = require(ReplicatedStorage.Modules.ItemBoundsUtil)
local PlayerDataService = require(script.Parent.PlayerDataService)

local EggService = Knit.CreateService({
	Name = "EggService",
	Client = {
		InventoryChanged = Knit.CreateSignal(),
		Hatched = Knit.CreateSignal(),
	},
})
local random = Random.new()
local geometry = {}

local function metrics(eggId)
	if geometry[eggId] then
		return geometry[eggId]
	end
	local config = EggsData[eggId]
	local template = config and EggToolUtil.GetTemplate(config.Model or eggId)
	if not template then
		return nil
	end
	local frame, size = ItemBoundsUtil.GetWorldAxisBounds(template)
	local result = {
		template = template,
		size = size,
		radius = math.max(size.X, size.Z) / 2,
		offset = template:GetPivot():ToObjectSpace(frame),
	}
	geometry[eggId] = result
	return result
end

local function context(player)
	local profile = PlayerDataService:GetProfile(player)
	local plot = Knit.GetService("PlotSlotService"):GetPlayerPlot(player)
	local ground = plot and plot:FindFirstChild("Ground")
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if
		not profile
		or not plot
		or plot:GetAttribute("OwnerUserId") ~= player.UserId
		or not ground
		or not ground:IsA("BasePart")
		or not root
	then
		return nil
	end
	return { data = profile.Data, plot = plot, ground = ground, root = root }
end

local function placedFrame(ground, placement, shape)
	return ground.CFrame
		* CFrame.new(placement.X, ground.Size.Y / 2 + shape.size.Y / 2, placement.Z)
		* CFrame.Angles(0, placement.Yaw, 0)
		* shape.offset:Inverse()
end

local function removeTool(player, uuid)
	for _, container in ipairs({ player:FindFirstChildOfClass("Backpack"), player.Character }) do
		if container then
			for _, tool in ipairs(container:GetChildren()) do
				if EggToolUtil.GetInstanceId(tool) == uuid then
					tool:Destroy()
				end
			end
		end
	end
end

function EggService:GetState(player)
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return nil
	end
	local eggs = {}
	for uuid, record in pairs(profile.Data.Eggs) do
		eggs[uuid] = table.clone(record)
		if record.Placement then
			eggs[uuid].Placement = table.clone(record.Placement)
		end
	end
	return { Eggs = eggs, MaxPlaced = EggInventory.MAX_PLACED }
end

function EggService:_changed(player)
	local state = self:GetState(player)
	if state then
		self.Client.InventoryChanged:Fire(player, state)
	end
end

function EggService:_giveTool(player, uuid)
	local profile = PlayerDataService:GetProfile(player)
	local record = profile and profile.Data.Eggs[uuid]
	local backpack = player:FindFirstChildOfClass("Backpack")
	if not record or record.Placement or not backpack then
		return
	end
	removeTool(player, uuid)
	local tool = EggToolUtil.Create(uuid, EggsData[record.EggId])
	if tool then
		tool.Parent = backpack
	end
end

function EggService:GiveEgg(player, eggId)
	local profile = PlayerDataService:GetProfile(player)
	if not profile or not EggsData[eggId] or not metrics(eggId) then
		return nil, "Egg is unavailable"
	end
	local uuid = HttpService:GenerateGUID(false)
	profile.Data.Eggs[uuid] = { EggId = eggId }
	self:_giveTool(player, uuid)
	self:_changed(player)
	return uuid
end

function EggService:_renderEgg(player, uuid)
	local ctx = context(player)
	if not ctx then
		return
	end
	local folder = ctx.plot:FindFirstChild("PlacedEggs")
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = "PlacedEggs"
		folder.Parent = ctx.plot
	end
	local existing = folder:FindFirstChild(uuid)
	if existing then
		existing:Destroy()
	end
	local record = ctx.data.Eggs[uuid]
	if not record or not record.Placement then
		return
	end
	local shape = metrics(record.EggId)
	if not shape then
		return
	end
	local model = shape.template:Clone()
	model.Name = uuid
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BaseScript") then
			part:Destroy()
		elseif part:IsA("BasePart") then
			part.Anchored, part.CanCollide, part.CanTouch = true, false, false
		end
	end
	model:PivotTo(placedFrame(ctx.ground, record.Placement, shape))
	model:SetAttribute("EggId", record.EggId)
	model:SetAttribute("OwnerUserId", player.UserId)
	model:SetAttribute("ReadyAt", record.Placement.ReadyAt)
	local timer = Instance.new("BillboardGui")
	timer.Name, timer.Size, timer.StudsOffset =
		"EggTimer", UDim2.fromOffset(180, 50), Vector3.new(0, shape.size.Y / 2 + 1, 0)
	timer.AlwaysOnTop, timer.MaxDistance = true, 80
	local label = Instance.new("TextLabel")
	label.Name, label.Size, label.BackgroundTransparency = "TimeLabel", UDim2.fromScale(1, 1), 1
	label.Font, label.TextScaled, label.TextColor3, label.TextStrokeTransparency =
		Enum.Font.GothamBold, true, Color3.new(1, 1, 1), 0.3
	label.Text = "Growing..."
	label.Parent, timer.Parent = timer, model.PrimaryPart
	for _, action in ipairs({ "Hatch", "Pick Up" }) do
		local prompt = Instance.new("ProximityPrompt")
		prompt.Name = if action == "Hatch" then "HatchPrompt" else "PickupPrompt"
		prompt.ActionText, prompt.ObjectText = action, EggsData[record.EggId].DisplayName or record.EggId
		prompt.KeyboardKeyCode = if action == "Hatch" then Enum.KeyCode.E else Enum.KeyCode.F
		prompt.HoldDuration = if action == "Hatch" then 0.2 else 0.5
		prompt.MaxActivationDistance, prompt.RequiresLineOfSight = 10, false
		prompt.Parent = model.PrimaryPart
		prompt.Triggered:Connect(function(visitor)
			if visitor ~= player then
				return
			end
			local result = if action == "Hatch" then self:HatchEgg(player, uuid) else self:PickupEgg(player, uuid)
			if not result.ok then
				self.Client.InventoryChanged:Fire(player, self:GetState(player), result.message)
			end
		end)
	end
	model.Parent = folder
end

function EggService:PlaceEgg(player, uuid, worldPosition, yaw)
	if typeof(uuid) ~= "string" or typeof(worldPosition) ~= "Vector3" or not Placement.IsFinite(yaw) then
		return { ok = false, message = "Invalid placement" }
	end
	if
		not Placement.IsFinite(worldPosition.X)
		or not Placement.IsFinite(worldPosition.Y)
		or not Placement.IsFinite(worldPosition.Z)
	then
		return { ok = false, message = "Invalid position" }
	end
	local ctx = context(player)
	if not ctx then
		return { ok = false, message = "Your home is unavailable" }
	end
	local record = ctx.data.Eggs[uuid]
	local shape = record and metrics(record.EggId)
	if not shape then
		return { ok = false, message = "Egg not found" }
	end
	local point = ctx.ground.CFrame:PointToObjectSpace(worldPosition)
	local projected = ctx.ground.CFrame:PointToWorldSpace(Vector3.new(point.X, ctx.ground.Size.Y / 2, point.Z))
	if (ctx.root.Position - projected).Magnitude > Placement.MAX_DISTANCE then
		return { ok = false, message = "Move closer to place the egg" }
	end
	local neighbors = {}
	for id, egg in pairs(ctx.data.Eggs) do
		if id ~= uuid and egg.Placement then
			local other = metrics(egg.EggId)
			if other then
				table.insert(neighbors, { X = egg.Placement.X, Z = egg.Placement.Z, Radius = other.radius })
			end
		end
	end
	local ok, message =
		Placement.Check(point.X, point.Z, shape.radius, ctx.ground.Size.X / 2, ctx.ground.Size.Z / 2, neighbors)
	if not ok then
		return { ok = false, message = message }
	end
	ok, message = EggInventory.Place(
		ctx.data.Eggs,
		uuid,
		point.X,
		point.Z,
		yaw % (2 * math.pi),
		Workspace:GetServerTimeNow(),
		EggsData[record.EggId].HatchTime
	)
	if ok then
		removeTool(player, uuid)
		self:_renderEgg(player, uuid)
		self:_changed(player)
	end
	return { ok = ok, message = message }
end

local function interactContext(player, uuid)
	if typeof(uuid) ~= "string" then
		return nil
	end
	local ctx = context(player)
	local record = ctx and ctx.data.Eggs[uuid]
	local shape = record and record.Placement and metrics(record.EggId)
	if not shape then
		return nil
	end
	if
		(ctx.root.Position - placedFrame(ctx.ground, record.Placement, shape).Position).Magnitude
		> Placement.INTERACT_DISTANCE
	then
		return nil
	end
	return ctx, record
end

function EggService:PickupEgg(player, uuid)
	local ctx = interactContext(player, uuid)
	if not ctx then
		return { ok = false, message = "Move closer to your egg" }
	end
	local ok, message = EggInventory.Pickup(ctx.data.Eggs, uuid, Workspace:GetServerTimeNow())
	if ok then
		self:_renderEgg(player, uuid)
		self:_giveTool(player, uuid)
		self:_changed(player)
	end
	return { ok = ok, message = message }
end

function EggService:HatchEgg(player, uuid)
	local ctx, record = interactContext(player, uuid)
	if not ctx then
		return { ok = false, message = "Move closer to your egg" }
	end
	if not EggInventory.IsReady(record, Workspace:GetServerTimeNow()) then
		return { ok = false, message = "This egg is still growing" }
	end
	if PetInventory.Count(ctx.data.Pets) >= PetInventory.MAX_STORED then
		return { ok = false, message = "Pet storage is full" }
	end
	local petId = EggInventory.ChoosePet(EggsData[record.EggId], random)
	if not petId then
		return { ok = false, message = "This egg has no valid pets" }
	end
	-- No yielding between reservation, grant and commit: one egg can only hatch once.
	ctx.data.Eggs[uuid] = nil
	local pet, message = Knit.GetService("PetService"):GivePet(player, petId)
	if not pet then
		ctx.data.Eggs[uuid] = record
		return { ok = false, message = message }
	end
	self:_renderEgg(player, uuid)
	self:_changed(player)
	self.Client.Hatched:Fire(player, { EggId = record.EggId, Pet = table.clone(pet) })
	return { ok = true, petId = petId }
end

function EggService.Client:GetState(player)
	return self.Server:GetState(player)
end
function EggService.Client:PlaceEgg(player, uuid, position, yaw)
	return self.Server:PlaceEgg(player, uuid, position, yaw)
end
function EggService.Client:PickupEgg(player, uuid)
	return self.Server:PickupEgg(player, uuid)
end
function EggService.Client:HatchEgg(player, uuid)
	return self.Server:HatchEgg(player, uuid)
end

function EggService:_restore(player)
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return
	end
	for uuid, egg in pairs(profile.Data.Eggs) do
		if egg.Placement then
			self:_renderEgg(player, uuid)
		else
			self:_giveTool(player, uuid)
		end
	end
	self:_changed(player)
end

function EggService:KnitStart()
	local slots = Knit.GetService("PlotSlotService")
	slots.SlotAssigned:Connect(function(player)
		self:_restore(player)
	end)
	slots.SlotReleased:Connect(function(plot)
		local folder = plot:FindFirstChild("PlacedEggs")
		if folder then
			folder:Destroy()
		end
	end)
	PlayerDataService.ProfileLoaded:Connect(function(player)
		self:_restore(player)
	end)
	local function bind(player)
		player.CharacterAdded:Connect(function()
			task.spawn(function()
				player:WaitForChild("Backpack", 10)
				self:_restore(player)
			end)
		end)
		self:_restore(player)
	end
	Players.PlayerAdded:Connect(bind)
	for _, player in ipairs(Players:GetPlayers()) do
		bind(player)
	end
end

return EggService
