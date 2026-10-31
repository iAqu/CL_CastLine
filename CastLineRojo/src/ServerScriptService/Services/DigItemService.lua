local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")

local ConditionsData = require(ReplicatedFirst.Data.ConditionsData)
local ItemsData = require(ReplicatedFirst.Data.ItemsData)
local ShovelsData = require(ReplicatedFirst.Data.ShovelsData)
local ZonesData = require(ReplicatedFirst.Data.ZonesData)
local ItemRollUtil = require(ReplicatedStorage.Modules.ItemRollUtil)
local ItemStatUtil = require(ReplicatedStorage.Modules.ItemStatUtil)
local ItemToolUtil = require(ReplicatedStorage.Modules.ItemToolUtil)
local GamePassEffectUtil = require(ReplicatedStorage.Modules.GamePassEffectUtil)
local EventStateUtil = require(ReplicatedStorage.Modules.EventStateUtil)
local Knit = require(ReplicatedStorage.Packages.Knit)
local MutationDataUtil = require(ReplicatedStorage.Modules.MutationDataUtil)
local PlayerLuckUtil = require(ReplicatedStorage.Modules.PlayerLuckUtil)
local ShovelToolUtil = require(ReplicatedStorage.Modules.ShovelToolUtil)
local TutorialConfig = require(ReplicatedStorage.Modules.TutorialConfig)
local WaterSurfaceUtil = require(ReplicatedStorage.Modules.WaterSurfaceUtil)
local ItemGrantUtil = require(ServerScriptService.Services.ItemGrantUtil)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)

local GENERATED_FOLDER_NAME = "GeneratedItems"
local TUTORIAL_FOLDER_NAME = "TutorialGeneratedItems"
local GENERATED_ATTRIBUTE = "GeneratedDigItem"
local TUTORIAL_OWNER_ATTRIBUTE = "TutorialOwnerUserId"
local SURFACE_POSITION_ATTRIBUTE = "DigSurfacePosition"
local DIG_INTERVAL = 0.6
local MAX_DIG_DISTANCE = 14
local EDGE_PADDING = 20
local MIN_SPACING = 12
local MODEL_SPACING_PADDING = 2
local MAX_MODEL_CLEARANCE_RADIUS = 20
local MAX_POSITION_ATTEMPTS = 60
local DEFAULT_CONDITION_ID = "Codition_1"
local BATCH_MUTATION_ID_ATTRIBUTE = "BatchMutationId"
local BATCH_MUTATION_CHANCE_ATTRIBUTE = "BatchMutationChance"

type ResolvedRoll = {
	item: any,
	itemId: string,
	rarity: string,
	weight: number,
	basePrice: number,
	horizontalFootprint: Vector2,
	bounds: Vector3,
	maxHealth: number,
	currentHealth: number,
	luck: number,
	mutationId: string?,
}

type Reservation = { player: Player, hitIndex: number, roll: ResolvedRoll }

local DigItemService = Knit.CreateService({
	Name = "DigItemService",
	Client = {
		DigStep = Knit.CreateSignal(),
		DigEnded = Knit.CreateSignal(),
		DigSitesInitialized = Knit.CreateSignal(),
		OtherPlayerDigRevealed = Knit.CreateSignal(),
		LuckChanged = Knit.CreateSignal(),
	},
	_Reservations = {} :: { [Model]: Reservation },
	_PlayerReservations = {} :: { [Player]: Model },
	_ResolvedRolls = {} :: { [Model]: { [number]: ResolvedRoll } },
	_ItemTemplates = nil :: Folder?,
	_PlayerLuck = {} :: { [Player]: number },
	_Random = Random.new(),
})

local function getItemTemplates(): Folder?
	local models = ReplicatedStorage:FindFirstChild("Models")
	local items = models and models:FindFirstChild("Items")
	if items and items:IsA("Folder") then return items end
	warn("DigItemService: ReplicatedStorage.Models.Items is missing")
	return nil
end

local function getGeneratedFolder(zone: Instance): Folder
	local folder = zone:FindFirstChild(GENERATED_FOLDER_NAME)
	if folder and folder:IsA("Folder") then return folder end
	folder = Instance.new("Folder")
	folder.Name = GENERATED_FOLDER_NAME
	folder.Parent = zone
	return folder
end

local function getTutorialFolder(zone: Instance): Folder
	local folder = zone:FindFirstChild(TUTORIAL_FOLDER_NAME)
	if folder and folder:IsA("Folder") then return folder end
	folder = Instance.new("Folder")
	folder.Name = TUTORIAL_FOLDER_NAME
	folder.Parent = zone
	return folder
end

local function getPlayerRoot(player: Player): BasePart?
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not humanoid or humanoid.Health <= 0 or not root or not root:IsA("BasePart") then return nil end
	return root
end

local function getEquippedShovelConfig(player: Player)
	local character = player.Character
	local tool = character and ShovelToolUtil.FindShovelTool(character)
	local shovelId = tool and ShovelToolUtil.GetShovelId(tool) or nil
	return shovelId and ShovelsData[shovelId] or nil
end

local function getSelectedShovelConfig(profileData)
	local shovelId = profileData and profileData.EquippedShovelId
	if typeof(shovelId) ~= "string" or not ShovelsData[shovelId] then
		shovelId = ShovelToolUtil.DEFAULT_SHOVEL_ID
	end
	return ShovelsData[shovelId]
end

local function getEquippedShovelPower(player: Player): number?
	local config = getEquippedShovelConfig(player)
	local power = config and tonumber(config.Power) or nil
	if not power or power <= 0 then
		return nil
	end
	local profile = PlayerDataService:GetProfile(player)
	return power * GamePassEffectUtil.GetDigPowerMultiplier(profile and profile.Data)
end

local function getPlayerRollLuck(player: Player): number?
	local profile = PlayerDataService:GetProfile(player)
	local shovel = profile and getSelectedShovelConfig(profile.Data) or nil
	if not profile or not shovel then
		return nil
	end
	local placedItemLuck = PlayerLuckUtil.GetPlacedItemLuck(profile.Data, ItemsData, ConditionsData)
	local discoveryLuck = Knit.GetService("IndexService"):GetDiscoveryLuck(player)
	return PlayerLuckUtil.CombineRollLuck(
		placedItemLuck,
		shovel.Luck,
		discoveryLuck,
		GamePassEffectUtil.GetItemLuckMultiplier(profile.Data)
	)
end

function DigItemService:GetPlayerRollLuck(player: Player): number?
	return getPlayerRollLuck(player)
end

function DigItemService:RefreshPlayerLuck(player: Player)
	local luck = self:GetPlayerRollLuck(player)
	if typeof(luck) ~= "number" then
		return
	end
	if self._PlayerLuck[player] == luck then
		return
	end
	self._PlayerLuck[player] = luck
	self.Client.LuckChanged:Fire(player, luck)
end

local function getDigInterval(player: Player): number
	local profile = PlayerDataService:GetProfile(player)
	return GamePassEffectUtil.GetDigInterval(profile and profile.Data, DIG_INTERVAL)
end

local function isGeneratedItem(model: unknown): boolean
	return typeof(model) == "Instance"
		and model:IsA("Model")
		and model:GetAttribute(GENERATED_ATTRIBUTE) == true
		and model.Parent ~= nil
		and (model.Parent.Name == GENERATED_FOLDER_NAME or model.Parent.Name == TUTORIAL_FOLDER_NAME)
end

local function isTutorialItemForPlayer(model: Model, player: Player): boolean
	local ownerUserId = model:GetAttribute(TUTORIAL_OWNER_ATTRIBUTE)
	return typeof(ownerUserId) == "number" and ownerUserId == player.UserId
end

local function getSurfacePosition(model: Model): Vector3?
	local position = model:GetAttribute(SURFACE_POSITION_ATTRIBUTE)
	return if typeof(position) == "Vector3" then position else nil
end

local function isItemSubmerged(model: Model): boolean
	local surfacePosition = getSurfacePosition(model)
	return surfacePosition ~= nil and WaterSurfaceUtil.IsPointSubmerged(surfacePosition)
end

local function isNearItem(player: Player, model: Model): boolean
	local root = getPlayerRoot(player)
	local surface = getSurfacePosition(model)
	return root ~= nil and surface ~= nil and (root.Position - surface).Magnitude <= MAX_DIG_DISTANCE
end

local function findExistingItemTool(player: Player, instanceId: string): Tool?
	for _, container in ipairs({ player:FindFirstChildOfClass("Backpack"), player.Character }) do
		if container then
			for _, child in ipairs(container:GetChildren()) do
				if child:IsA("Tool") and ItemToolUtil.GetInstanceId(child) == instanceId then return child end
			end
		end
	end
	return nil
end

local function isPlacedOnPlot(profileData, instanceId: string): boolean
	if typeof(profileData.PlotPlacements) ~= "table" then
		return false
	end
	for _, placedUid in pairs(profileData.PlotPlacements) do
		if placedUid == instanceId then
			return true
		end
	end
	return false
end

local function normalizeStoredItem(record, item)
	local weight = tonumber(record.Weight)
	if not weight then return nil end
	local conditionId = if typeof(record.ConditionId) == "string" and ConditionsData[record.ConditionId]
		then record.ConditionId
		else DEFAULT_CONDITION_ID
	local condition = ConditionsData[conditionId]
	if not condition then return nil end
	local mutationId = MutationDataUtil.NormalizeMutationId(record.MutationId)
	local price = tonumber(record.Price) or ItemStatUtil.CalculatePrice(
		item,
		weight,
		condition.ValueMult,
		MutationDataUtil.GetPriceRate(mutationId)
	)
	record.Weight = weight
	record.ConditionId = conditionId
	record.Price = price
	record.MutationId = mutationId
	return { Weight = weight, ConditionId = conditionId, Price = price, MutationId = mutationId }
end

function DigItemService:_restoreItemTools(player: Player)
	local profile = PlayerDataService:GetProfile(player)
	if not profile then return end
	if typeof(profile.Data.Items) ~= "table" then
		profile.Data.Items = {}
	end
	local backpack = player:FindFirstChildOfClass("Backpack") or player:WaitForChild("Backpack", 5)
	if not backpack or not backpack:IsA("Backpack") then return end
	for instanceId, record in pairs(profile.Data.Items) do
		if typeof(instanceId) ~= "string"
			or typeof(record) ~= "table"
			or isPlacedOnPlot(profile.Data, instanceId)
			or findExistingItemTool(player, instanceId)
		then
			continue
		end
		local itemId = record.ItemId
		local item = typeof(itemId) == "string" and ItemsData[itemId] or nil
		local instanceData = item and normalizeStoredItem(record, item) or nil
		if not item or not instanceData then
			warn("DigItemService: invalid stored item", tostring(instanceId))
			continue
		end
		local tool = ItemToolUtil.Create(instanceId, item, instanceData)
		if tool then
			tool.Parent = backpack
		end
	end
end

local function getPlacementCFrame(model: Model, surfacePosition: Vector3, normal: Vector3, yaw: number): CFrame
	local bboxCFrame, size = model:GetBoundingBox()
	local pivotOffset = model:GetPivot():ToObjectSpace(bboxCFrame).Position
	local xAxis = Vector3.new(1, 0, 0)
	local zAxis = Vector3.new(0, 0, 1)
	local tangent = xAxis - normal * xAxis:Dot(normal)
	if tangent.Magnitude < 0.01 then
		tangent = zAxis - normal * zAxis:Dot(normal)
	end
	local right = tangent.Unit
	local forward = normal:Cross(right).Unit
	local orientation = CFrame.fromMatrix(Vector3.zero, right, normal, forward) * CFrame.Angles(0, yaw, 0)
	local pivotPosition = surfacePosition + normal * (math.max(size.X, size.Y, size.Z) * 0.5 + 0.05)
	return CFrame.new(pivotPosition) * orientation * CFrame.new(-pivotOffset)
end

local function getHorizontalClearanceRadius(model: Model): number
	local _, size = model:GetBoundingBox()
	return Vector2.new(size.X, size.Z).Magnitude * 0.5
end

local function getHorizontalFootprint(model: Model): Vector2
	local _, size = model:GetBoundingBox()
	local dimensions = { size.X, size.Y, size.Z }
	table.sort(dimensions)
	return Vector2.new(dimensions[1], dimensions[2])
end

local function isItemModelAvailable(templates: Folder, item): boolean
	local template = templates:FindFirstChild(item.Model)
	return template ~= nil and template:IsA("Model")
end

local function getRaritySizing(templates: Folder, rarity: string, zoneId: string)
	local bounds = Vector3.new(2, 2, 2)
	local clearanceRadius = MIN_SPACING * 0.5
	local candidates = ItemRollUtil.GetCandidates(ItemsData, rarity, zoneId, function(item)
		return isItemModelAvailable(templates, item)
	end)
	for _, item in ipairs(candidates) do
		if (tonumber(item.RollChance) or 0) <= 0 then
			continue
		end
		local template = templates:FindFirstChild(item.Model)
		if not template or not template:IsA("Model") then
			continue
		end
		local model = template:Clone()
		ItemStatUtil.ScaleModel(model, item, item.MaxWeight, template:GetScale())
		local _, candidateBounds = model:GetBoundingBox()
		bounds = Vector3.new(
			math.max(bounds.X, candidateBounds.X),
			math.max(bounds.Y, candidateBounds.Y),
			math.max(bounds.Z, candidateBounds.Z)
		)
		clearanceRadius = math.max(clearanceRadius, getHorizontalClearanceRadius(model))
		model:Destroy()
	end
	return bounds, math.clamp(clearanceRadius, MIN_SPACING * 0.5, MAX_MODEL_CLEARANCE_RADIUS)
end

local function createDigSiteProxy(bounds: Vector3): Model
	local model = Instance.new("Model")
	local part = Instance.new("Part")
	part.Name = "DigSiteProxy"
	part.Size = Vector3.new(
		math.max(0.1, bounds.X),
		math.max(0.1, bounds.Y),
		math.max(0.1, bounds.Z)
	)
	part.Transparency = 1
	part.Anchored = true
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Parent = model
	model.PrimaryPart = part
	return model
end

function DigItemService:_spawnZoneItems(zoneId: string, zoneData, templates: Folder, random: Random, batchEffect)
	local areas = Workspace:FindFirstChild("Areas")
	local zone = areas and areas:FindFirstChild(zoneId)
	local mainPart = zone and zone:FindFirstChild("MainPart")
	if not zone or not mainPart or not mainPart:IsA("BasePart") then
		warn("DigItemService: missing zone or MainPart", zoneId)
		return
	end
	local folder = getGeneratedFolder(zone)
	for _, child in ipairs(folder:GetChildren()) do
		child:Destroy()
	end
	local itemCountMultiplier = 1
	if batchEffect and EventStateUtil.NormalizeEventType(batchEffect.EventType) == "moreitem" then
		itemCountMultiplier += math.max(0, tonumber(batchEffect.EffectValue) or 0)
	end
	local targetCount = math.max(0, math.floor((tonumber(zoneData.ItemCount) or 0) * itemCountMultiplier))
	local batchMutationId: string? = nil
	local batchMutationChance = 0
	if batchEffect and EventStateUtil.NormalizeEventType(batchEffect.EventType) == "mutation" then
		batchMutationId = MutationDataUtil.NormalizeMutationId(batchEffect.MutationId)
		batchMutationChance = math.clamp(tonumber(batchEffect.EffectValue) or 0, 0, 1)
	end
	local halfX = math.max(0, mainPart.Size.X * 0.5 - EDGE_PADDING)
	local halfZ = math.max(0, mainPart.Size.Z * 0.5 - EDGE_PADDING)
	local topY = mainPart.Size.Y * 0.5
	local normal = mainPart.CFrame.UpVector

	local sizingByRarity = {}
	local rolledSites = {}
	for _ = 1, targetCount do
		local rarity = ItemRollUtil.RollRarity(ItemsData, zoneData, zoneId, function(item)
			return isItemModelAvailable(templates, item)
		end, random)
		if not rarity then
			warn("DigItemService: no valid rarity candidate for", zoneId)
			break
		end
		local sizing = sizingByRarity[rarity]
		if not sizing then
			local bounds, clearanceRadius = getRaritySizing(templates, rarity, zoneId)
			sizing = {
				bounds = bounds,
				clearanceRadius = clearanceRadius,
			}
			sizingByRarity[rarity] = sizing
		end
		table.insert(rolledSites, {
			rarity = rarity,
			bounds = sizing.bounds,
			clearanceRadius = sizing.clearanceRadius,
		})
	end

	local points = {}
	local reportedInvalidPoint = false
	for slot, rolled in ipairs(rolledSites) do
		local placed = false
		for _ = 1, MAX_POSITION_ATTEMPTS do
			local localPosition = Vector3.new(random:NextNumber(-halfX, halfX), topY, random:NextNumber(-halfZ, halfZ))
			local surfacePosition = mainPart.CFrame:PointToWorldSpace(localPosition)
			local overlaps = false
			for _, otherPoint in ipairs(points) do
				if typeof(otherPoint) ~= "table"
					or typeof(otherPoint.surfacePosition) ~= "Vector3"
					or typeof(otherPoint.clearanceRadius) ~= "number"
				then
					if not reportedInvalidPoint then
						warn("DigItemService: invalid placed point while spawning", zoneId)
						reportedInvalidPoint = true
					end
					continue
				end
				local requiredSpacing = math.max(
					MIN_SPACING,
					rolled.clearanceRadius + otherPoint.clearanceRadius + MODEL_SPACING_PADDING
				)
				if (surfacePosition - otherPoint.surfacePosition).Magnitude < requiredSpacing then
					overlaps = true
					break
				end
			end
			if not overlaps then
				table.insert(points, {
					localPosition = localPosition,
					surfacePosition = surfacePosition,
					clearanceRadius = rolled.clearanceRadius,
				})
				placed = true
				break
			end
		end
		if not placed then
			warn("DigItemService: could not place item", slot, "in", zoneId)
		end
	end

	table.sort(rolledSites, function(left, right)
		return ItemRollUtil.GetRarityRank(left.rarity) < ItemRollUtil.GetRarityRank(right.rarity)
	end)
	table.sort(points, function(left, right)
		if left.localPosition.Z ~= right.localPosition.Z then return left.localPosition.Z < right.localPosition.Z end
		return left.localPosition.X < right.localPosition.X
	end)

	for index, rolled in ipairs(rolledSites) do
		local point = points[index]
		if not point then
			continue
		end
		local model = createDigSiteProxy(rolled.bounds)
		model.Name = "DigSite_" .. HttpService:GenerateGUID(false)
		model:SetAttribute(GENERATED_ATTRIBUTE, true)
		model:SetAttribute("Rarity", rolled.rarity)
		model:SetAttribute("ZoneId", zoneId)
		local defaultHealth = math.max(1, math.ceil(tonumber(zoneData.RecommendedPower) or 1))
		model:SetAttribute("MaxHealth", defaultHealth)
		model:SetAttribute("CurrentHealth", defaultHealth)
		model:SetAttribute("ItemInstanceId", HttpService:GenerateGUID(false))
		model:SetAttribute(SURFACE_POSITION_ATTRIBUTE, point.surfacePosition)
		model:SetAttribute("DigReserved", false)
		model:SetAttribute(BATCH_MUTATION_ID_ATTRIBUTE, batchMutationId)
		model:SetAttribute(BATCH_MUTATION_CHANCE_ATTRIBUTE, batchMutationChance)
		model:PivotTo(getPlacementCFrame(model, point.surfacePosition, normal, random:NextNumber(0, math.pi * 2)))
		model.Destroying:Connect(function()
			self._ResolvedRolls[model] = nil
		end)
		model.Parent = folder
	end
end

local function getHealthSnapshot(player: Player, roll: ResolvedRoll)
	local profile = PlayerDataService:GetProfile(player)
	return {
		ItemId = roll.itemId,
		Weight = roll.weight,
		Rarity = roll.rarity,
		BasePrice = roll.basePrice,
		Price = roll.basePrice,
		Footprint = roll.horizontalFootprint,
		Bounds = roll.bounds,
		CurrentHealth = roll.currentHealth,
		MaxHealth = roll.maxHealth,
		Interval = getDigInterval(player),
		DigSpeedMultiplier = GamePassEffectUtil.GetDigSpeedMultiplier(profile and profile.Data),
		MutationId = roll.mutationId,
	}
end

local function getSiteId(model: Model): string?
	local siteId = model:GetAttribute("ItemInstanceId")
	return if typeof(siteId) == "string" then siteId else nil
end

local function getGeneratedModels(): { Model }
	local models = {}
	local areas = Workspace:FindFirstChild("Areas")
	if not areas then
		return models
	end
	for _, zone in areas:GetChildren() do
		for _, folderName in ipairs({ GENERATED_FOLDER_NAME, TUTORIAL_FOLDER_NAME }) do
			local folder = zone:FindFirstChild(folderName)
			if folder and folder:IsA("Folder") then
				for _, child in folder:GetChildren() do
					if child:IsA("Model") and isGeneratedItem(child) then
						table.insert(models, child)
					end
				end
			end
		end
	end
	table.sort(models, function(left, right)
		return (getSiteId(left) or left.Name) < (getSiteId(right) or right.Name)
	end)
	return models
end

local function getInitializedSnapshot(model: Model, roll: ResolvedRoll)
	return {
		Site = model,
		SiteId = getSiteId(model),
		Weight = roll.weight,
		Rarity = roll.rarity,
		IsRareReward = roll.item.IsRareReward == 1,
		BasePrice = roll.basePrice,
		Price = roll.basePrice,
		Footprint = roll.horizontalFootprint,
		Bounds = roll.bounds,
		CurrentHealth = roll.currentHealth,
		MaxHealth = roll.maxHealth,
		MutationId = roll.mutationId,
	}
end

function DigItemService:_createResolvedRoll(model: Model, luck: number, player: Player): ResolvedRoll?
	local rollsByUserId = self._ResolvedRolls[model]
	if not rollsByUserId then
		rollsByUserId = {}
		self._ResolvedRolls[model] = rollsByUserId
	end

	local templates = self._ItemTemplates
	local rarity = model:GetAttribute("Rarity")
	local zoneId = model:GetAttribute("ZoneId")
	local zoneData = typeof(zoneId) == "string" and ZonesData[zoneId] or nil
	if not templates
		or not templates.Parent
		or typeof(rarity) ~= "string"
		or typeof(zoneId) ~= "string"
		or not zoneData
	then
		return nil
	end

	local tutorialOwnerUserId = model:GetAttribute(TUTORIAL_OWNER_ATTRIBUTE)
	if typeof(tutorialOwnerUserId) == "number" and tutorialOwnerUserId ~= player.UserId then
		return nil
	end
	local tutorialItemId = model:GetAttribute("TutorialItemId")
	local item = if isTutorialItemForPlayer(model, player) and typeof(tutorialItemId) == "string"
		then ItemsData[tutorialItemId]
		else ItemRollUtil.RollItemInRarity(ItemsData, rarity, zoneId, function(candidate)
			return isItemModelAvailable(templates, candidate)
		end, luck, self._Random)
	if not item then
		return nil
	end
	local weight = if isTutorialItemForPlayer(model, player)
		then tonumber(item.DefaultWeight)
		else ItemStatUtil.RollWeight(item, self._Random)
	if not weight or weight <= 0 then
		return nil
	end
	local template = templates:FindFirstChild(item.Model)
	if not template or not template:IsA("Model") then
		return nil
	end
	local visual = template:Clone()
	ItemStatUtil.ScaleModel(visual, item, weight, template:GetScale())
	local horizontalFootprint = getHorizontalFootprint(visual)
	local _, bounds = visual:GetBoundingBox()
	visual:Destroy()
	local maxHealth = ItemStatUtil.CalculateMaxHealth(item, weight, zoneData.RecommendedPower)
	local mutationId: string? = nil
	if not isTutorialItemForPlayer(model, player) then
		local batchMutationId = MutationDataUtil.NormalizeMutationId(model:GetAttribute(BATCH_MUTATION_ID_ATTRIBUTE))
		local batchMutationChance = model:GetAttribute(BATCH_MUTATION_CHANCE_ATTRIBUTE)
		if batchMutationId
			and typeof(batchMutationChance) == "number"
			and batchMutationChance > 0
			and self._Random:NextNumber() <= batchMutationChance
		then
			mutationId = batchMutationId
		end
	end
	local roll: ResolvedRoll = {
		item = item,
		itemId = item.ItemID,
		rarity = rarity,
		weight = weight,
		basePrice = ItemStatUtil.CalculatePrice(item, weight, 1, MutationDataUtil.GetPriceRate(mutationId)),
		horizontalFootprint = horizontalFootprint,
		bounds = bounds,
		maxHealth = maxHealth,
		currentHealth = maxHealth,
		luck = luck,
		mutationId = mutationId,
	}
	return roll
end

function DigItemService:EnsureTutorialSite(player: Player): Model?
	local templates = self._ItemTemplates
	local areas = Workspace:FindFirstChild("Areas")
	local zone = areas and areas:FindFirstChild("Zone_1")
	local mainPart = zone and zone:FindFirstChild("MainPart")
	local item = ItemsData.Duck
	local template = templates and item and templates:FindFirstChild(item.Model)
	if not zone or not mainPart or not mainPart:IsA("BasePart")
		or not templates or not template or not template:IsA("Model")
	then
		warn("DigItemService: tutorial Duck resources are missing")
		return nil
	end

	local folder = getTutorialFolder(zone)
	local modelName = "TutorialDigSite_" .. tostring(player.UserId)
	local existing = folder:FindFirstChild(modelName)
	if existing and existing:IsA("Model") then
		if not self:_getResolvedRoll(existing, player) then
			local luck = getPlayerRollLuck(player)
			if luck then
				local rolls = self._ResolvedRolls[existing] or {}
				self._ResolvedRolls[existing] = rolls
				rolls[player.UserId] = self:_createResolvedRoll(existing, luck, player)
			end
		end
		local roll = self:_getResolvedRoll(existing, player)
		if roll then
			self.Client.DigSitesInitialized:Fire(player, self:_getPlayerSnapshots(player))
		end
		return existing
	elseif existing then
		existing:Destroy()
	end

	local visual = template:Clone()
	ItemStatUtil.ScaleModel(visual, item, item.DefaultWeight, template:GetScale())
	local _, bounds = visual:GetBoundingBox()
	visual:Destroy()
	local model = createDigSiteProxy(bounds)
	model.Name = modelName
	model:SetAttribute(GENERATED_ATTRIBUTE, true)
	model:SetAttribute(TUTORIAL_OWNER_ATTRIBUTE, player.UserId)
	model:SetAttribute("TutorialItemId", item.ItemID)
	model:SetAttribute("Rarity", item.Rarity)
	model:SetAttribute("ZoneId", "Zone_1")
	model:SetAttribute("ItemInstanceId", HttpService:GenerateGUID(false))
	model:SetAttribute("DigReserved", false)
	local shoreInset = math.clamp(TutorialConfig.GUIDED_SHORE_INSET, EDGE_PADDING, mainPart.Size.Z * 0.5)
	local surfacePosition = mainPart.CFrame:PointToWorldSpace(Vector3.new(
		0,
		mainPart.Size.Y * 0.5,
		-mainPart.Size.Z * 0.5 + shoreInset
	))
	model:SetAttribute(SURFACE_POSITION_ATTRIBUTE, surfacePosition)
	model:PivotTo(getPlacementCFrame(model, surfacePosition, mainPart.CFrame.UpVector, 0))
	model.Destroying:Connect(function()
		self._ResolvedRolls[model] = nil
	end)
	model.Parent = folder

	local luck = getPlayerRollLuck(player)
	local roll = luck and self:_createResolvedRoll(model, luck, player) or nil
	if not roll then
		model:Destroy()
		return nil
	end
	self._ResolvedRolls[model] = self._ResolvedRolls[model] or {}
	self._ResolvedRolls[model][player.UserId] = roll
	model:SetAttribute("MaxHealth", roll.maxHealth)
	model:SetAttribute("CurrentHealth", roll.currentHealth)
	self.Client.DigSitesInitialized:Fire(player, self:_getPlayerSnapshots(player))
	return model
end

function DigItemService:RemoveTutorialSite(player: Player)
	local areas = Workspace:FindFirstChild("Areas")
	local zone = areas and areas:FindFirstChild("Zone_1")
	local folder = zone and zone:FindFirstChild(TUTORIAL_FOLDER_NAME)
	local model = folder and folder:FindFirstChild("TutorialDigSite_" .. tostring(player.UserId))
	if model and model:IsA("Model") then
		local reservation = self._Reservations[model]
		if reservation then
			self:_endReservation(model, reservation, "TutorialStepChanged", true, true)
		end
		model:Destroy()
	end
end

function DigItemService:_getPlayerSnapshots(player: Player)
	local snapshots = {}
	local tutorialOnly = Knit.GetService("TutorialService"):IsPrimaryActive(player)
	for _, model in getGeneratedModels() do
		if tutorialOnly and not isTutorialItemForPlayer(model, player) then
			continue
		end
		local rollsByUserId = self._ResolvedRolls[model]
		local roll = rollsByUserId and rollsByUserId[player.UserId] or nil
		if roll then
			table.insert(snapshots, getInitializedSnapshot(model, roll))
		end
	end
	return snapshots
end

function DigItemService:_initializePlayerRolls(player: Player, notifyClient: boolean): boolean
	local luck = getPlayerRollLuck(player)
	if typeof(luck) ~= "number" then
		return false
	end
	local tutorialOnly = Knit.GetService("TutorialService"):IsPrimaryActive(player)
	for _, model in getGeneratedModels() do
		local tutorialOwnerUserId = model:GetAttribute(TUTORIAL_OWNER_ATTRIBUTE)
		if typeof(tutorialOwnerUserId) == "number" and tutorialOwnerUserId ~= player.UserId then
			continue
		end
		local rollsByUserId = self._ResolvedRolls[model]
		if tutorialOnly and not isTutorialItemForPlayer(model, player) then
			if rollsByUserId then
				rollsByUserId[player.UserId] = nil
			end
			continue
		end
		if not rollsByUserId then
			rollsByUserId = {}
			self._ResolvedRolls[model] = rollsByUserId
		end
		if not rollsByUserId[player.UserId] then
			local roll = self:_createResolvedRoll(model, luck, player)
			if roll then
				rollsByUserId[player.UserId] = roll
			else
				warn("DigItemService: failed to initialize personal item", player.UserId, getSiteId(model))
			end
		end
	end
	if notifyClient and player.Parent then
		self.Client.DigSitesInitialized:Fire(player, self:_getPlayerSnapshots(player))
	end
	return true
end

function DigItemService:RefreshPlayerSites(player: Player)
	if not PlayerDataService:GetProfile(player) then
		return
	end
	self:_initializePlayerRolls(player, false)
	if player.Parent then
		self.Client.DigSitesInitialized:Fire(player, self:_getPlayerSnapshots(player))
	end
end

function DigItemService:_getResolvedRoll(model: Model, player: Player): ResolvedRoll?
	local rollsByUserId = self._ResolvedRolls[model]
	return rollsByUserId and rollsByUserId[player.UserId] or nil
end

function DigItemService:_endReservation(
	model: Model,
	reservation: Reservation,
	reason: string,
	notify: boolean,
	restoreHealth: boolean
)
	if self._Reservations[model] ~= reservation then return end
	self._Reservations[model] = nil
	if self._PlayerReservations[reservation.player] == model then
		self._PlayerReservations[reservation.player] = nil
	end
	if restoreHealth then
		reservation.roll.currentHealth = reservation.roll.maxHealth
		if model.Parent then
			model:SetAttribute("CurrentHealth", reservation.roll.currentHealth)
		end
	end
	if model.Parent then
		model:SetAttribute("DigReserved", false)
	end
	if notify and reservation.player.Parent then
		self.Client.DigEnded:Fire(reservation.player, model, { Completed = false, Reason = reason })
	end
	if reservation.player.Parent then
		Knit.GetService("MovementSpeedService"):RefreshPlayer(reservation.player)
	end
end

function DigItemService:_completeItem(model: Model, reservation: Reservation): boolean
	local player = reservation.player
	local profile = PlayerDataService:GetProfile(player)
	local roll = reservation.roll
	local itemId = roll.itemId
	local weight = roll.weight
	local item = ItemsData[itemId]
	if not profile or not item then return false end
	local carryCapacityService = Knit.GetService("CarryCapacityService")
	if not carryCapacityService:CanCarry(player, weight) then
		carryCapacityService:Reject(player)
		return false
	end

	local grant = ItemGrantUtil.Grant(player, itemId, {
		Random = self._Random,
		Weight = weight,
		CountTowardTotalWeight = true,
		MutationId = roll.mutationId,
	})
	if not grant then return false end
	local isTutorialSite = isTutorialItemForPlayer(model, player)
	local conditionId = grant.ConditionId
	local condition = grant.Condition
	local basePrice = grant.BasePrice
	local finalPrice = grant.Price
	local itemLuck = ItemStatUtil.CalculateLuck(item, grant.Weight, condition.LuckMult)
	local groundPosition = getSurfacePosition(model)
	local revealCFrame = model:GetPivot()
	self:_endReservation(model, reservation, "Completed", false, false)
	self._ResolvedRolls[model] = nil
	self.Client.DigEnded:Fire(player, model, {
		Completed = true,
		ItemId = itemId,
		Weight = weight,
		Rarity = roll.rarity,
		ConditionId = conditionId,
		ConditionName = condition.DisplayName,
		BasePrice = basePrice,
		Price = finalPrice,
		ItemLuck = itemLuck,
		IsFirstItemAcquisition = grant.IsFirstItemAcquisition == true,
		MutationId = grant.MutationId,
	})
	Knit.GetService("TutorialService"):OnItemDug(player, itemId, grant.InstanceId, isTutorialSite)
	if not isTutorialSite and groundPosition then
		self.Client.OtherPlayerDigRevealed:FireAll({
			Player = player,
			ItemId = itemId,
			Weight = weight,
			Rarity = roll.rarity,
			GroundPosition = groundPosition,
			RevealCFrame = revealCFrame,
			MutationId = grant.MutationId,
		})
	end
	task.delay(0.2, function()
		if model.Parent then
			model:Destroy()
		end
	end)
	return true
end

function DigItemService:_runDigLoop(model: Model, reservation: Reservation)
	while self._Reservations[model] == reservation do
		task.wait(getDigInterval(reservation.player))
		if self._Reservations[model] ~= reservation then return end
		local player = reservation.player
		if isItemSubmerged(model) then
			self:_endReservation(model, reservation, "Underwater", true, true)
			return
		end
		if isTutorialItemForPlayer(model, player)
			and not Knit.GetService("TutorialService"):CanDigTutorialSite(player)
		then
			self:_endReservation(model, reservation, "TideUnavailable", true, true)
			return
		end
		local power = getEquippedShovelPower(player)
		if not isGeneratedItem(model) or not isNearItem(player, model) or not power then
			self:_endReservation(model, reservation, "InvalidState", true, true)
			return
		end
		local roll = reservation.roll
		local maxHealth = roll.maxHealth
		local currentHealth = math.clamp(roll.currentHealth, 0, maxHealth)
		local damage = math.min(currentHealth, power)
		currentHealth = math.max(0, currentHealth - power)
		roll.currentHealth = currentHealth
		reservation.hitIndex += 1
		model:SetAttribute("CurrentHealth", currentHealth)
		local profile = PlayerDataService:GetProfile(player)
		self.Client.DigStep:Fire(player, model, {
			CurrentHealth = currentHealth,
			MaxHealth = maxHealth,
			Damage = damage,
			ShovelPower = power,
			HitIndex = reservation.hitIndex,
			Interval = getDigInterval(player),
			DigSpeedMultiplier = GamePassEffectUtil.GetDigSpeedMultiplier(profile and profile.Data),
		})
		if currentHealth <= 0 then
			if not self:_completeItem(model, reservation) then
				self:_endReservation(model, reservation, "CompletionFailed", true, true)
			end
			return
		end
	end
end

function DigItemService.Client:BeginDig(player: Player, model: Model)
	return self.Server:BeginDig(player, model)
end

function DigItemService.Client:GetDigSiteSnapshots(player: Player)
	self.Server:_initializePlayerRolls(player, false)
	return self.Server:_getPlayerSnapshots(player)
end

function DigItemService.Client:GetPlayerRollLuck(player: Player)
	return self.Server:GetPlayerRollLuck(player)
end

function DigItemService:BeginDig(player: Player, model: Model)
	if not isGeneratedItem(model) or not isNearItem(player, model) or not getEquippedShovelPower(player) then return { Accepted = false } end
	if isItemSubmerged(model) then
		return { Accepted = false, Reason = "Underwater" }
	end
	local tutorialService = Knit.GetService("TutorialService")
	local isTutorialSite = isTutorialItemForPlayer(model, player)
	if tutorialService:IsPrimaryActive(player) then
		if not isTutorialSite then
			return { Accepted = false, Reason = "TutorialRestricted" }
		end
		if not tutorialService:CanDigTutorialSite(player) then
			return { Accepted = false, Reason = "TideUnavailable" }
		end
	end
	local tutorialOwnerUserId = model:GetAttribute(TUTORIAL_OWNER_ATTRIBUTE)
	if typeof(tutorialOwnerUserId) == "number" and tutorialOwnerUserId ~= player.UserId then
		return { Accepted = false }
	end
	local current = self._Reservations[model]
	if current then
		if current.player == player then
			local snapshot = getHealthSnapshot(player, current.roll)
			snapshot.Accepted = true
			return snapshot
		end
		return { Accepted = false }
	end
	local previous = self._PlayerReservations[player]
	local previousReservation = previous and self._Reservations[previous] or nil
	if previous and previousReservation then
		return { Accepted = false, Reason = "AlreadyDigging" }
	elseif previous then
		self._PlayerReservations[player] = nil
	end
	local roll = self:_getResolvedRoll(model, player)
	if not roll then
		return { Accepted = false, Reason = "RollUnavailable" }
	end
	local carryCapacityService = Knit.GetService("CarryCapacityService")
	if not carryCapacityService:CanCarry(player, roll.weight) then
		carryCapacityService:Reject(player)
		return { Accepted = false, Reason = "Not enough carry weight" }
	end
	local reservation = { player = player, hitIndex = 0, roll = roll }
	self._Reservations[model] = reservation
	self._PlayerReservations[player] = model
	model:SetAttribute("MaxHealth", roll.maxHealth)
	model:SetAttribute("CurrentHealth", roll.currentHealth)
	model:SetAttribute("DigReserved", true)
	task.spawn(function()
		self:_runDigLoop(model, reservation)
	end)
	local snapshot = getHealthSnapshot(player, roll)
	snapshot.Accepted = true
	return snapshot
end

function DigItemService.Client:CancelDig(player: Player, model: Model)
	self.Server:CancelDig(player, model)
end

function DigItemService:CancelDig(player: Player, model: Model)
	local reservation = self._Reservations[model]
	if reservation and reservation.player == player then
		self:_endReservation(model, reservation, "Cancelled", false, true)
	end
end

function DigItemService:InterruptPlayer(player: Player)
	local model = self._PlayerReservations[player]
	local reservation = model and self._Reservations[model] or nil
	if model and reservation then
		self:_endReservation(model, reservation, "Interrupted", true, true)
	end
end

function DigItemService:IsPlayerDigging(player: Player): boolean
	local model = self._PlayerReservations[player]
	return model ~= nil and self._Reservations[model] ~= nil
end

function DigItemService:RefreshAllZones(applyActiveEvent: boolean?)
	local templates = self._ItemTemplates
	if not templates or not templates.Parent then
		warn("DigItemService: cannot refresh items before templates are ready")
		return
	end

	local reservations: { { model: Model, reservation: Reservation } } = {}
	for model, reservation in pairs(self._Reservations) do
		table.insert(reservations, { model = model, reservation = reservation })
	end
	for _, entry in reservations do
		self:_endReservation(entry.model, entry.reservation, "TideRefresh", true, true)
	end
	self._ResolvedRolls = {}

	local batchEffect = if applyActiveEvent == false
		then nil
		else Knit.GetService("EventService"):GetActiveItemEffect()
	for zoneId, zoneData in pairs(ZonesData) do
		self:_spawnZoneItems(zoneId, zoneData, templates, self._Random, batchEffect)
	end
	for _, player in Players:GetPlayers() do
		if PlayerDataService:GetProfile(player) then
			self:RefreshPlayerLuck(player)
			self:_initializePlayerRolls(player, true)
			if Knit.GetService("TutorialService"):IsAtStep(player, TutorialConfig.STEP.DIG_DUCK) then
				self:EnsureTutorialSite(player)
			end
		end
	end
end

function DigItemService:KnitStart()
	local templates = getItemTemplates()
	if templates then
		self._ItemTemplates = templates
		-- Initial server population is the pre-event batch; item events begin at the next completed rise.
		self:RefreshAllZones(false)
	end
	PlayerDataService.ProfileLoaded:Connect(function(player: Player)
		self:RefreshPlayerLuck(player)
		self:_initializePlayerRolls(player, true)
		task.spawn(function()
			self:_restoreItemTools(player)
		end)
		player.CharacterAdded:Connect(function()
			task.defer(function()
				self:_restoreItemTools(player)
			end)
		end)
	end)
	for _, player in Players:GetPlayers() do
		if PlayerDataService:GetProfile(player) then
			self:_initializePlayerRolls(player, true)
		end
	end
	Players.PlayerRemoving:Connect(function(player: Player)
		self:InterruptPlayer(player)
		self:RemoveTutorialSite(player)
		self._PlayerLuck[player] = nil
		for _, rollsByUserId in pairs(self._ResolvedRolls) do
			rollsByUserId[player.UserId] = nil
		end
	end)
end

return DigItemService
