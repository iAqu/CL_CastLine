local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FishingAssets = require(ReplicatedStorage.Modules.FishingAssets)
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local FishInventoryData = require(ReplicatedStorage.Modules.FishInventoryData)
local ItemStatUtil = require(ReplicatedStorage.Modules.ItemStatUtil)
local ItemToolUtil = require(ReplicatedStorage.Modules.ItemToolUtil)
local MutationDataUtil = require(ReplicatedStorage.Modules.MutationDataUtil)
local MutationVisualUtil = require(ReplicatedStorage.Modules.MutationVisualUtil)
local Knit = require(ReplicatedStorage.Packages.Knit)
local PromptUtil = require(ReplicatedStorage.Modules.PromptUtil)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local PaidItemPolicy = require(script.Parent.PaidItemPolicy)

local DROP_FOLDER_NAME = "DrownedItemDrops"
local FLOAT_CLEARANCE = 0.15
local DROP_HEIGHT_SAMPLE_DISTANCE = 1024
local DROP_GROUND_SAMPLE_LIFT = 8
local DROP_GROUND_SEARCH_STEP = 8
local DROP_GROUND_SEARCH_ANGLE_COUNT = 16
local DROP_GROUND_SEARCH_MAX_RADIUS = 128
local DROP_SCATTER_GAP_MIN = 1
local DROP_SCATTER_GAP_MAX = 3
local DROP_SCATTER_ATTEMPTS = 64
local WATER_SUBMERGE_EPSILON = 0.01
local DROP_TILT_MIN_ANGLE = math.rad(5)
local DROP_TILT_MAX_ANGLE = math.rad(10)
local DROP_POSITION_UPDATE_INTERVAL = 0.1

type ItemRecord = {
	ItemId: string,
	Weight: number,
	PaidOrigin: string?,
	Price: number,
	MutationId: string?,
}

type DropCandidate = {
	instanceId: string,
	record: ItemRecord,
	item: any,
	tools: { Tool },
}

type DropState = {
	ownerUserId: number?,
	model: Model,
	prompt: ProximityPrompt,
	instanceId: string,
	record: ItemRecord,
	item: any,
	position: Vector3,
	groundY: number,
	groundCenterOffsetY: number,
	footprintRadius: number,
	boundsRotation: CFrame,
	boundsToPivot: CFrame,
	claimed: boolean,
	promptConnection: RBXScriptConnection?,
}

type ScatterPlacement = {
	position: Vector3,
	footprintRadius: number,
}

local DrownDropService = Knit.CreateService({
	Name = "DrownDropService",
	Client = {},
	_Drops = {} :: { [Model]: DropState },
	_Random = Random.new(),
	_WarnedMissingWater = false,
	_WarnedMissingGround = false,
	_DropPositionElapsed = 0,
})

local function getDropFolder(): Folder
	local folder = Workspace:FindFirstChild(DROP_FOLDER_NAME)
	if folder and folder:IsA("Folder") then
		return folder
	end

	folder = Instance.new("Folder")
	folder.Name = DROP_FOLDER_NAME
	folder.Parent = Workspace
	return folder
end

local function getWaterTop(): BasePart?
	local areas = Workspace:FindFirstChild("Areas")
	local water = areas and areas:FindFirstChild("Water")
	local top = water and water:FindFirstChild("Top")
	if top and top:IsA("BasePart") then
		return top
	end
	return nil
end

local function getWaterSurfaceY(waterTop: BasePart): number
	return waterTop.CFrame:PointToWorldSpace(Vector3.new(0, waterTop.Size.Y * 0.5, 0)).Y
end

local function getPromptPart(model: Model): BasePart?
	local handle = model:FindFirstChild("Handle", true)
	if handle and handle:IsA("BasePart") then
		return handle
	end
	return model:FindFirstChildWhichIsA("BasePart", true)
end

local function normalizeRecord(record: unknown): ItemRecord?
	if typeof(record) ~= "table" then
		return nil
	end
	local itemId = record.ItemId
	local weight = tonumber(record.Weight)
	local price = tonumber(record.Price)
	if typeof(itemId) ~= "string"
		or not weight
		or weight <= 0
		or not price
	then
		return nil
	end
	return {
		ItemId = itemId,
		Weight = weight,
		PaidOrigin = record.PaidOrigin,
		Price = price,
		MutationId = MutationDataUtil.NormalizeMutationId(record.MutationId),
	}
end

local function getCarriedCandidates(player: Player, profile): { DropCandidate }
	if typeof(profile.Data.Items) ~= "table" then
		return {}
	end

	local candidates = {}
	local byInstanceId: { [string]: DropCandidate } = {}
	for _, container in ipairs({ player:FindFirstChildOfClass("Backpack"), player.Character }) do
		if not container then
			continue
		end
		for _, child in ipairs(container:GetChildren()) do
			local instanceId = ItemToolUtil.GetInstanceId(child)
			if not instanceId or not child:IsA("Tool") then
				continue
			end

			local candidate = byInstanceId[instanceId]
			if candidate then
				table.insert(candidate.tools, child)
				continue
			end

			local record = normalizeRecord(profile.Data.Items[instanceId])
			local item = record and FishInventoryData[record.ItemId] or nil
			if not record or not item then
				warn("DrownDropService: carried item has invalid profile data", instanceId)
				continue
			end

			candidate = {
				instanceId = instanceId,
				record = record,
				item = item,
				tools = { child },
			}
			byInstanceId[instanceId] = candidate
			table.insert(candidates, candidate)
		end
	end
	return candidates
end

local function horizontalDistance(left: Vector3, right: Vector3): number
	return Vector2.new(left.X - right.X, left.Z - right.Z).Magnitude
end

local function getShortestBoundsAxis(boundsCFrame: CFrame, size: Vector3): Vector3
	if size.X <= size.Y and size.X <= size.Z then
		return boundsCFrame.XVector
	end
	if size.Y <= size.Z then
		return boundsCFrame.YVector
	end
	return boundsCFrame.ZVector
end

local function rotationBetweenDirections(from: Vector3, to: Vector3): CFrame
	local fromUnit = from.Unit
	local toUnit = to.Unit
	local dot = math.clamp(fromUnit:Dot(toUnit), -1, 1)
	if dot >= 1 - 0.0001 then
		return CFrame.new()
	end

	local axis = fromUnit:Cross(toUnit)
	if axis.Magnitude < 0.0001 then
		return CFrame.fromAxisAngle(Vector3.xAxis, math.pi)
	end
	return CFrame.fromAxisAngle(axis.Unit, math.acos(dot))
end

local function getBoundsWorldHalfExtents(boundsCFrame: CFrame, size: Vector3): Vector3
	local halfSize = size * 0.5
	local xAxis = boundsCFrame.XVector
	local yAxis = boundsCFrame.YVector
	local zAxis = boundsCFrame.ZVector
	return Vector3.new(
		math.abs(xAxis.X) * halfSize.X + math.abs(yAxis.X) * halfSize.Y + math.abs(zAxis.X) * halfSize.Z,
		math.abs(xAxis.Y) * halfSize.X + math.abs(yAxis.Y) * halfSize.Y + math.abs(zAxis.Y) * halfSize.Z,
		math.abs(xAxis.Z) * halfSize.X + math.abs(yAxis.Z) * halfSize.Y + math.abs(zAxis.Z) * halfSize.Z
	)
end

local function getDropPivotCFrame(state: DropState, boundsCenterY: number): CFrame
	return CFrame.new(state.position.X, boundsCenterY, state.position.Z)
		* state.boundsRotation
		* state.boundsToPivot
end

local function getScatterPosition(
	origin: Vector3,
	footprintRadius: number,
	placements: { ScatterPlacement },
	random: Random
): Vector3
	if #placements == 0 then
		return origin
	end

	local angle = random:NextNumber(0, math.pi * 2)
	local gap = random:NextNumber(DROP_SCATTER_GAP_MIN, DROP_SCATTER_GAP_MAX)
	local radius = footprintRadius + gap
	for _ = 1, DROP_SCATTER_ATTEMPTS do
		local candidate = Vector3.new(origin.X + math.cos(angle) * radius, origin.Y, origin.Z + math.sin(angle) * radius)
		local collision = false
		for _, placement in ipairs(placements) do
			local requiredDistance = footprintRadius + placement.footprintRadius + gap
			local distance = horizontalDistance(candidate, placement.position)
			if distance < requiredDistance then
				collision = true
				radius += requiredDistance - distance
			end
		end
		if not collision then
			return candidate
		end
	end

	local fallbackRadius = footprintRadius + gap
	for _, placement in ipairs(placements) do
		fallbackRadius = math.max(
			fallbackRadius,
			horizontalDistance(origin, placement.position) + footprintRadius + placement.footprintRadius + gap
		)
	end
	return Vector3.new(
		origin.X + math.cos(angle) * fallbackRadius,
		origin.Y,
		origin.Z + math.sin(angle) * fallbackRadius
	)
end

function DrownDropService:_getGroundY(
	position: Vector3,
	waterTop: BasePart?,
	dropFolder: Folder,
	sampleLift: number?
): number?
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.IgnoreWater = true
	params.RespectCanCollide = true
	local exclusions: { Instance } = { dropFolder }
	-- The Water folder may also contain the collidable pool floor.
	if waterTop then
		table.insert(exclusions, waterTop)
	end
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character then
			table.insert(exclusions, player.Character)
		end
	end
	params.FilterDescendantsInstances = exclusions

	local origin = position + Vector3.new(0, sampleLift or DROP_GROUND_SAMPLE_LIFT, 0)
	local result = Workspace:Raycast(origin, Vector3.new(0, -DROP_HEIGHT_SAMPLE_DISTANCE, 0), params)
	if result then
		return result.Position.Y
	end
	return nil
end

local function isPlacementClear(
	position: Vector3,
	footprintRadius: number,
	placements: { ScatterPlacement }
): boolean
	for _, placement in ipairs(placements) do
		local requiredDistance = footprintRadius + placement.footprintRadius + DROP_SCATTER_GAP_MIN
		if horizontalDistance(position, placement.position) < requiredDistance then
			return false
		end
	end
	return true
end

function DrownDropService:_resolveGroundedPosition(
	desiredPosition: Vector3,
	footprintRadius: number,
	placements: { ScatterPlacement },
	waterTop: BasePart?,
	dropFolder: Folder,
	maxGroundY: number?
): (Vector3?, number?)
	local function tryPosition(candidate: Vector3, sampleLift: number?): (Vector3?, number?)
		if not isPlacementClear(candidate, footprintRadius, placements) then
			return nil, nil
		end
		local groundY = self:_getGroundY(candidate, waterTop, dropFolder, sampleLift)
		if groundY and maxGroundY and groundY > maxGroundY + WATER_SUBMERGE_EPSILON then
			return nil, nil
		end
		if groundY then
			return candidate, groundY
		end
		return nil, nil
	end

	local position, groundY = tryPosition(desiredPosition, nil)
	if position and groundY then
		return position, groundY
	end

	local startAngle = self._Random:NextNumber(0, math.pi * 2)
	for radius = DROP_GROUND_SEARCH_STEP, DROP_GROUND_SEARCH_MAX_RADIUS, DROP_GROUND_SEARCH_STEP do
		for angleIndex = 0, DROP_GROUND_SEARCH_ANGLE_COUNT - 1 do
			local angle = startAngle + angleIndex * math.pi * 2 / DROP_GROUND_SEARCH_ANGLE_COUNT
			local candidate = Vector3.new(
				desiredPosition.X + math.cos(angle) * radius,
				desiredPosition.Y,
				desiredPosition.Z + math.sin(angle) * radius
			)
			position, groundY = tryPosition(candidate, DROP_GROUND_SEARCH_MAX_RADIUS)
			if position and groundY then
				return position, groundY
			end
		end
	end

	if not self._WarnedMissingGround then
		self._WarnedMissingGround = true
		warn("DrownDropService: could not find valid ground near a drowned item drop")
	end
	return nil, nil
end

function DrownDropService:_removeDrop(state: DropState)
	if self._Drops[state.model] ~= state then
		return
	end
	self._Drops[state.model] = nil
	if state.promptConnection then
		state.promptConnection:Disconnect()
		state.promptConnection = nil
	end
	if state.model.Parent then
		state.model:Destroy()
	end
end

function DrownDropService:_claimDrop(player: Player, state: DropState)
	if self._Drops[state.model] ~= state or state.claimed then
		return
	end
	if state.record.PaidOrigin and player.UserId ~= state.ownerUserId then
		local owner = state.ownerUserId and Players:GetPlayerByUserId(state.ownerUserId)
		if not PaidItemPolicy.CanTransfer(owner, player) then return end
		if self._Drops[state.model] ~= state or state.claimed then return end
	end
	state.claimed = true
	state.prompt.Enabled = false

	local profile = PlayerDataService:GetProfile(player)
	local backpack = player:FindFirstChildOfClass("Backpack")
	if not profile or not backpack or not backpack:IsA("Backpack") then
		state.claimed = false
		state.prompt.Enabled = true
		return
	end
	if typeof(profile.Data.Items) ~= "table" then
		profile.Data.Items = {}
	end
	if profile.Data.Items[state.instanceId] ~= nil then
		warn("DrownDropService: refusing duplicate item instance", state.instanceId)
		state.claimed = false
		state.prompt.Enabled = true
		return
	end
	local tool = ItemToolUtil.Create(state.instanceId, state.item, state.record, player)
	if not tool then
		warn("DrownDropService: could not recreate claimed item", state.instanceId)
		state.claimed = false
		state.prompt.Enabled = true
		return
	end

	profile.Data.Items[state.instanceId] = table.clone(state.record)
	tool.Parent = backpack
	Knit.GetService("PlotFishService"):RefreshInventoryIncome(player)
	self:_removeDrop(state)
end

function DrownDropService:_createDrop(
	candidate: DropCandidate,
	dropOrigin: Vector3,
	placements: { ScatterPlacement },
	owner: Player?
): DropState?
	local template = FishingAssets.GetFish(candidate.item.Model)
	if not template then
		warn("DrownDropService: item model missing", candidate.record.ItemId)
		return nil
	end

	local model = template:Clone()
	ItemStatUtil.ScaleModel(model, candidate.item, candidate.record.Weight, template)
	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.Anchored = true
			descendant.CanCollide = false
			descendant.CanTouch = false
			descendant.CanQuery = false
		end
	end
	local promptPart = getPromptPart(model)
	if not promptPart then
		model:Destroy()
		warn("DrownDropService: item model has no BasePart", candidate.record.ItemId)
		return nil
	end

	model.Name = "DrownedItem_" .. candidate.instanceId
	model:SetAttribute("DrownedItemDrop", true)
	model:SetAttribute("ItemInstanceId", candidate.instanceId)
	model:SetAttribute("ItemId", candidate.record.ItemId)
	model:SetAttribute("Weight", candidate.record.Weight)
	model:SetAttribute("PaidOrigin", candidate.record.PaidOrigin)
	model:SetAttribute("Price", candidate.record.Price)
	model:SetAttribute("MutationId", candidate.record.MutationId)
	MutationVisualUtil.Apply(model, candidate.record.MutationId, template.Name)
	local highlight = Instance.new("Highlight")
	highlight.Name = "DrownedItemHighlight"
	highlight.Adornee = model
	highlight.FillColor = Color3.fromRGB(255, 0, 0)
	highlight.FillTransparency = 0.5
	highlight.OutlineColor = Color3.new(1, 1, 1)
	highlight.OutlineTransparency = 0
	highlight.DepthMode = Enum.HighlightDepthMode.Occluded
	highlight.Enabled = true
	highlight.Parent = model
	local prompt = PromptUtil.Create(promptPart, {
		Name = "DrownedItemPrompt",
		ActionText = "Pick up",
		ObjectText = candidate.item.DisplayName,
		MaxActivationDistance = PromptUtil.PROMPT_MAX_DISTANCE,
	})

	local dropFolder = getDropFolder()
	local authoredPivot = model:GetPivot()
	local boundsCFrame, size = model:GetBoundingBox()
	local shortestAxis = getShortestBoundsAxis(boundsCFrame, size)
	local flattenRotation = rotationBetweenDirections(shortestAxis, Vector3.yAxis)
	local yaw = self._Random:NextNumber(0, math.pi * 2)
	local tiltAxisAngle = self._Random:NextNumber(0, math.pi * 2)
	local tiltAxis = Vector3.new(math.cos(tiltAxisAngle), 0, math.sin(tiltAxisAngle))
	local tiltAngle = self._Random:NextNumber(DROP_TILT_MIN_ANGLE, DROP_TILT_MAX_ANGLE)
	local presentationRotation = CFrame.fromAxisAngle(tiltAxis, tiltAngle)
		* CFrame.Angles(0, yaw, 0)
		* flattenRotation
	model:PivotTo(CFrame.new(Vector3.zero) * presentationRotation * authoredPivot.Rotation)

	boundsCFrame, size = model:GetBoundingBox()
	local boundsToPivot = boundsCFrame:ToObjectSpace(model:GetPivot())
	local boundsHalfExtents = getBoundsWorldHalfExtents(boundsCFrame, size)
	local groundCenterOffsetY = boundsHalfExtents.Y + FLOAT_CLEARANCE
	local footprintRadius = Vector2.new(boundsHalfExtents.X, boundsHalfExtents.Z).Magnitude
	local desiredPosition = getScatterPosition(dropOrigin, footprintRadius, placements, self._Random)
	local waterTop = getWaterTop()
	local maxGroundY = if waterTop then getWaterSurfaceY(waterTop) else nil
	local position, groundY = self:_resolveGroundedPosition(
		desiredPosition,
		footprintRadius,
		placements,
		waterTop,
		dropFolder,
		maxGroundY
	)
	if not position or not groundY then
		model:Destroy()
		return nil
	end
	model.Parent = dropFolder
	local state: DropState = {
		ownerUserId = owner and owner.UserId,
		model = model,
		prompt = prompt,
		instanceId = candidate.instanceId,
		record = candidate.record,
		item = candidate.item,
		position = position,
		groundY = groundY,
		groundCenterOffsetY = groundCenterOffsetY,
		footprintRadius = footprintRadius,
		boundsRotation = boundsCFrame.Rotation,
		boundsToPivot = boundsToPivot,
		claimed = false,
	}
	local waterY = maxGroundY or groundY
	local initialBoundsCenterY = if waterY > groundY + WATER_SUBMERGE_EPSILON then waterY else groundY + state.groundCenterOffsetY
	model:PivotTo(getDropPivotCFrame(state, initialBoundsCenterY))
	self._Drops[model] = state
	state.promptConnection = prompt.Triggered:Connect(function(player: Player)
		self:_claimDrop(player, state)
	end)
	return state
end

function DrownDropService:_updateDropPositions()
	if next(self._Drops) == nil then
		return
	end
	local waterTop = getWaterTop()
	if not waterTop then
		if not self._WarnedMissingWater then
			self._WarnedMissingWater = true
			warn("DrownDropService: Workspace.Areas.Water.Top is missing")
		end
		return
	end
	self._WarnedMissingWater = false
	local waterY = getWaterSurfaceY(waterTop)
	for model, state in pairs(self._Drops) do
		if model.Parent == nil then
			self:_removeDrop(state)
		else
			local groundY = state.groundY
			local targetBoundsCenterY = if waterY > groundY + WATER_SUBMERGE_EPSILON
				then waterY
				else groundY + state.groundCenterOffsetY
			model:PivotTo(getDropPivotCFrame(state, targetBoundsCenterY))
		end
	end
end

function DrownDropService:DropCarriedItems(player: Player, deathPosition: Vector3): number
	local profile = PlayerDataService:GetProfile(player)
	if not profile or typeof(deathPosition) ~= "Vector3" then
		return 0
	end
	local candidates = getCarriedCandidates(player, profile)
	local droppedIds = {}
	local placements: { ScatterPlacement } = {}
	for _, candidate in ipairs(candidates) do
		local state = self:_createDrop(candidate, deathPosition, placements, player)
		if state then
			profile.Data.Items[candidate.instanceId] = nil
			for _, tool in ipairs(candidate.tools) do
				if tool.Parent then
					tool:Destroy()
				end
			end
			table.insert(droppedIds, candidate.instanceId)
			table.insert(placements, {
				position = state.position,
				footprintRadius = state.footprintRadius,
			})
		end
	end

	if #droppedIds > 0 then
		Knit.GetService("PlotFishService"):RefreshInventoryIncome(player)
		local hotbarLayoutService = Knit.GetService("HotbarLayoutService")
		hotbarLayoutService:RemoveItemDescriptors(player, droppedIds)
	end
	return #droppedIds
end

function DrownDropService:KnitStart()
	RunService.Heartbeat:Connect(function(deltaTime)
		if next(self._Drops) == nil then
			self._DropPositionElapsed = 0
			return
		end
		self._DropPositionElapsed += deltaTime
		if self._DropPositionElapsed < DROP_POSITION_UPDATE_INTERVAL then
			return
		end
		self._DropPositionElapsed = 0
		self:_updateDropPositions()
	end)
end

return DrownDropService
