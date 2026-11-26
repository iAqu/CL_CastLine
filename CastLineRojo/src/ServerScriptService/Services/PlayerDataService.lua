local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Template = require(ReplicatedStorage.PlayerData.Template)
local ProfileService = require(ServerScriptService.Libs.ProfileService)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local PlotFishIncome = require(ReplicatedStorage.Modules.PlotFishIncome)
local PlotPlacementUtil = require(ReplicatedStorage.Modules.PlotPlacementUtil)
local RodInventory = require(ReplicatedStorage.Modules.RodInventory)
local FishingOnboarding = require(ReplicatedStorage.Modules.FishingOnboarding)

local DATA_BASE_NAME = "RELEASE_230724"
local ProfileStore = ProfileService.GetProfileStore(DATA_BASE_NAME, Template)
local isStudio = RunService:IsStudio()
local testArgs = if isStudio and game.PlaceId == 84106335829275
    then game:GetService("StudioTestService"):GetTestArgs()
    else nil
local studioOnboardingTest = type(testArgs) == "table" and testArgs.plugin == "RestartTest" and testArgs.castLineOnboarding == true
local useMockProfiles = studioOnboardingTest or (isStudio and workspace:GetAttribute("StudioUseMockProfiles") == true)
if useMockProfiles then
    ProfileStore = ProfileStore.Mock
end

local KICK_MESSAGE = "Data issue, try again shortly. If issue persists, contact us!"
local LOAD_PROFILE_TIMEOUT = 90
local LOAD_PROFILE_MAX_ATTEMPTS = 5
local LOAD_PROFILE_RETRY_BASE_DELAY = 1.5
local EARLY_DATA_REMOTE_NAME = "RequestPlayerDataEarly"

local function sanitizeSettings(playerData)
    local saved = playerData.Settings
    local settings = table.clone(Template.Settings)
    if type(saved) == "table" then
        for key, default in settings do
            local value = saved[key]
            local validBoolean = type(default) == "boolean" and type(value) == "boolean"
            local validMode = key == "PerformanceMode" and (value == "Auto" or value == "Battery" or value == "Quality")
            if validBoolean or validMode then
                settings[key] = value
            end
        end
    end
    playerData.Settings = settings
end

local function sanitizeHotbarLayout(playerData)
    if typeof(playerData.HotbarLayout) ~= "table" then
        playerData.HotbarLayout = {}
        return
    end

    local sanitized = {}
    for slotKey, entry in pairs(playerData.HotbarLayout) do
        if typeof(entry) == "table"
            and (entry.Kind == "Potion" or entry.Kind == "Item" or entry.Kind == "Egg")
            and typeof(entry.Id) == "string"
        then
            sanitized[slotKey] = entry
        end
    end
    playerData.HotbarLayout = sanitized
end

local function sanitizeIndexLogs(playerData)
    for _, fieldName in ipairs({ "IndexDiscoveryLog", "IndexRewardClaimLog" }) do
        if typeof(playerData[fieldName]) ~= "table" then
            playerData[fieldName] = {}
        else
            local sanitized = {}
            for itemId, value in pairs(playerData[fieldName]) do
                if typeof(itemId) == "string" and value == true then
                    sanitized[itemId] = true
                end
            end
            playerData[fieldName] = sanitized
        end
    end
end

local function sanitizeNewItemTagSeenLog(playerData)
    if typeof(playerData.NewItemTagSeenLog) ~= "table" then
        playerData.NewItemTagSeenLog = {}
        return
    end

    local sanitized = {}
    for itemId, value in pairs(playerData.NewItemTagSeenLog) do
        if typeof(itemId) == "string" and value == true then
            sanitized[itemId] = true
        end
    end
    playerData.NewItemTagSeenLog = sanitized
end

local PlayerDataService = Knit.CreateService {
    Name = "PlayerDataService",
    Client = {
        StrengthChanged = Knit.CreateSignal(),
        RebirthsChanged = Knit.CreateSignal(),
        WinsChanged = Knit.CreateSignal(),
        DiamondsChanged = Knit.CreateSignal(),
        FruitChanged = Knit.CreateSignal(),
        PropChanged = Knit.CreateSignal(),
        DecorChanged = Knit.CreateSignal(),
        CrystalChanged = Knit.CreateSignal(),
        TrophyChanged = Knit.CreateSignal(),
        FavoriteChanged = Knit.CreateSignal(),

        SuperRebirthsChanged = Knit.CreateSignal(),
        SuperRebirthTokensChanged = Knit.CreateSignal(),
        RebirthUpgradeChanged = Knit.CreateSignal(),
        TotalWinsChanged = Knit.CreateSignal(),
        TotalStrengthChanged = Knit.CreateSignal(),
        -- Client to Server

        -- 存档加载完成后主动推送给对应客户端, 避免客户端轮询等待
        DataLoaded = Knit.CreateSignal(),
    },

    RebirthsChangedServerEvent = Signal.new(),
    StrengthChangedServerEvent = Signal.new(),
    WinsChangedServerEvent = Signal.new(),
    TrophyChangedServerEvent = Signal.new(),
    ProfileLoaded = Signal.new(),

    _Profiles = {},
    _LoadingProfiles = {},
	_PendingProfiles = {},
	_EarlyLoadingStarted = false,
	_FrameworkReady = false,
	_BeforeProfileRelease = {},
}

local REMOVED_PROFILE_FIELDS = {
    -- Dig & Build
    "Block",
    "TotalBlock",
    "OfflineBlocks",
    "OfflineStartTime",
    "OfflineWins",
    "Pickaxes",
    "Jetpacks",
    "SelectedBuildingId",
    "UnlockedBuildings",
    "BuildProgress",
    "AutoFight",
    "AutoFightArea",
    "Tutorial_Is_Dig",
    -- 宠物/蛋
    "HatchNum",
    "HatchNumByChallenge",
    "AutoDeletePets",
    "PetsInVoidSlot",
    "PetsInTitanSlot",
    -- 武器/战斗
    "Weapons",
    "RangedStrength",
    "EnemyKills",
    "Crystals",
    -- 马/公主/骑乘/训练
    "Horses",
    "Treadmills",
    "Princesses",
    "PrincessCheckInDate",
    "LapsCompleted",
    "Tutorial_Is_Train",
    "Tutorial_Is_Train_Stop",
    "BestRecord",
    -- 服饰/VIP
    "Clothes",
    "Hats",
    "VipRewardLastClaimTime",
    -- 地牢/活动 Token
    "DungeonTokens",
    "DungeonTokensDaily",
    "ChristmasTokens",
    "ChristmasTokensDaily",
    "JurassicTokens",
    "FruitTokens",
    "FruitToken",
    "TowerLevel",
    "TowerResetDate",
    "TowerFruitBuyLog",
    "FruitAreaLimitedPurchaseHistory",
    -- 旧活动/任务
    "EventRewardAmount",
    "EventTrainAmount",
    "EventKeepTime",
    "QuestRewardClaimLog",
    "QuestProgress",
    "BossSummonTime",
    "Halloween_Task",
    "UGC_WizardHat_Task",
    "UGC_Tasks",
    "UGC_Tasks_Progress",
    -- 已移除货币
    "Heart",
    -- 动物玩法
    "TutorialStarterAnimalUUID",
    "TutorialRollAnimalUUID",
    "TutorialFruitID",
    "Animals",
    "AnimalIndex",
    "CurrentRollSlots",
    "CurrentRollLuckLevel",
    "CurrentMutationUnlockLevel",
    "PendingGuaranteedMutation",
    "TotalAnimalsOwned",
    "Fruits",
    "FruitStock",
    "FruitNextRestock",
    "CashPools",
    "PlotCashPools",
    -- 建造玩法
    "Props",
    "PlacedProps",
    "PropShopSlots",
    "PropStock",
    "PropNextRestock",
    "Decors",
    "PlacedDecors",
    "DecorShopSlots",
    "DecorNextRestock",
    "FarmZones",
    "Favorites",
}

local function migrateRemovedLegacyFields(playerData)
    for _, fieldName in REMOVED_PROFILE_FIELDS do
        playerData[fieldName] = nil
    end
    if typeof(playerData.Upgrades) == "table" then
        playerData.Upgrades.Upgrade_CarryWeight = nil
        playerData.Upgrades.Upgrade_MoveSpeed = nil
    end
    if typeof(playerData.GamePasses) == "table" then
        playerData.GamePasses.FastMove = nil
    end
end

local function migratePlotHome(playerData)
    local upgradeData = require(ReplicatedStorage.Modules.PlotUpgradeData)
    playerData.PlotUpgradeLevel = upgradeData.NormalizeLevel(playerData.PlotUpgradeLevel)
    local capacity = PlotPlacementUtil.GetCapacity(playerData)
    if playerData.LastPlotSlotId == nil and typeof(playerData.LastFarmSlotId) == "number" then
        playerData.LastPlotSlotId = playerData.LastFarmSlotId
    end
    local items = if typeof(playerData.Items) == "table" then playerData.Items else {}
    playerData.PlotPlacements = PlotPlacementUtil.Reconcile(playerData.PlotPlacements, items, capacity)
end

local function reconcileFishingOnboarding(data, seedStudioOnboarding)
	local progress = data.FishingOnboarding
	local seed = seedStudioOnboarding and progress == nil
	if not seed and (not progress or progress.Stage ~= "FirstCatch") then
		return
	end

	local config = require(ReplicatedStorage.Modules.FishingIntroConfig)
	local fishes = require(ReplicatedFirst.Data.FishesData)
	if type(data.Items) ~= "table" then
		data.Items = {}
	end
	local version = if seed then config.Version else math.max(1, tonumber(data.FishingIntroVersion) or 0)
	local uid = config.RewardUidPrefix .. tostring(version)
	if seed then
		data.Items[uid] = { ItemId = config.StarterFishId, Weight = fishes[config.StarterFishId].DefaultWeight }
		data.FishingIntroVersion = config.Version
		data.FishingOnboarding = { Stage = "PlaceFish", FishUid = uid }
		return
	end

	local function isFish(record)
		local weight = type(record) == "table" and tonumber(record.Weight)
		return weight and weight > 0 and weight < math.huge and fishes[record.ItemId] ~= nil
	end
	local starter = data.Items[uid]
	if isFish(starter) and starter.ItemId == config.StarterFishId then
		if PlotPlacementUtil.IsPlaced(data.PlotPlacements, uid) then
			progress.Stage, progress.FishUid = "Train", nil
		else
			progress.Stage, progress.FishUid = "PlaceFish", uid
		end
	else
		progress.Stage, progress.FishUid = "Train", nil
		for itemUid, record in pairs(data.Items) do
			if type(itemUid) == "string" and isFish(record) and not PlotPlacementUtil.IsPlaced(data.PlotPlacements, itemUid) then
				progress.Stage = "PlaceFish"
				break
			end
		end
	end
end

function PlayerDataService:GetProfile(player: Player)
    return self._Profiles[player]
end

function PlayerDataService:IsUsingMockProfiles()
	return useMockProfiles
end

function PlayerDataService:IsStudioOnboardingTest()
	return studioOnboardingTest
end

function PlayerDataService:AdjustStrength(player: Player, amount: number) : boolean
    local profile = self._Profiles[player]
    if not profile then return end
    if amount > 0 then
        self:AdjustTotalStrength(player, amount)
    end
    profile.Data.Strength += amount
    profile.Data.Strength = math.round(profile.Data.Strength)

    if player then
        player:SetAttribute("Strength", profile.Data.Strength)
    end

    self.Client.StrengthChanged:Fire(player, profile.Data.Strength)
    self.StrengthChangedServerEvent:Fire(player, profile.Data.Strength)
    return true
end

function PlayerDataService:AdjustRebirths(player: Player, amount: number) : boolean
    local profile = self._Profiles[player]
    if not profile then return end
    profile.Data.Rebirths += amount
    profile.Data.Rebirths = math.round(profile.Data.Rebirths)
    self.Client.RebirthsChanged:Fire(player, profile.Data.Rebirths)
    self.RebirthsChangedServerEvent:Fire(player, profile.Data.Rebirths)
    return true
end

function PlayerDataService:AdjustTrophy(player: Player, amount: number) : boolean
    local profile = self._Profiles[player]
    if not profile then return end
    if amount > 0 then
        if (profile.Data.TotalTrophy or 0) <= 0 then
            profile.Data.TotalTrophy = math.max(0, profile.Data.Trophy or 0)
        end
        profile.Data.TotalTrophy = (profile.Data.TotalTrophy or 0) + amount
        profile.Data.TotalTrophy = math.round(profile.Data.TotalTrophy)
    end
    profile.Data.Trophy += amount
    profile.Data.Trophy = math.round(profile.Data.Trophy)
    self.Client.TrophyChanged:Fire(player, profile.Data.Trophy)
    self.TrophyChangedServerEvent:Fire(player, profile.Data.Trophy)
    return true
end

function PlayerDataService:AdjustSuperRebirths(player: Player, amount: number) : boolean
    local profile = self._Profiles[player]
    if not profile then return end
    profile.Data.SuperRebirths += amount
    profile.Data.SuperRebirths = math.floor(profile.Data.SuperRebirths)
    self.Client.SuperRebirthsChanged:Fire(player, profile.Data.SuperRebirths)
    return true
end

function PlayerDataService:AdjustSuperRebirthTokens(player: Player, amount: number) : boolean
    local profile = self._Profiles[player]
    if not profile then return end
    profile.Data.SuperRebirthTokens += amount
    profile.Data.SuperRebirthTokens = math.floor(profile.Data.SuperRebirthTokens)
    self.Client.SuperRebirthTokensChanged:Fire(player, profile.Data.SuperRebirthTokens)
    return true
end

function PlayerDataService:AdjustSuperRebirthUpgrade(player: Player, upgradeId: number, amount: number) : boolean
    local profile = self._Profiles[player]
    if not profile then return end
    
    if not profile.Data.RebirthUpgrades[upgradeId] then profile.Data.RebirthUpgrades[upgradeId] = 0 end
    profile.Data.RebirthUpgrades[upgradeId] += amount
    profile.Data.RebirthUpgrades[upgradeId] = math.floor(profile.Data.RebirthUpgrades[upgradeId])
    self.Client.RebirthUpgradeChanged:Fire(player, upgradeId, profile.Data.RebirthUpgrades[upgradeId])
end

function PlayerDataService:AdjustTotalStrength(player: Player, amount: number) : boolean
    if amount <= 0 then return end

    local profile = self._Profiles[player]
    if not profile then return end

    if profile.Data.TotalStrength <= 0 then
        profile.Data.TotalStrength = profile.Data.Strength
    end
    profile.Data.TotalStrength += amount
    profile.Data.TotalStrength = math.round(profile.Data.TotalStrength)
    self.Client.TotalStrengthChanged:Fire(player, profile.Data.TotalStrength)
    return true
end

function PlayerDataService:AdjustTotalWins(player: Player, amount: number) : boolean
    if amount <= 0 then return end

    local profile = self._Profiles[player]
    if not profile then return end

    if profile.Data.TotalWins <= 0 then
        profile.Data.TotalWins = profile.Data.Wins
    end
    profile.Data.TotalWins += amount
    profile.Data.TotalWins = math.round(profile.Data.TotalWins)
    self.Client.TotalWinsChanged:Fire(player, profile.Data.TotalWins)
    return true
end

function PlayerDataService:AdjustTotalCashEarned(player: Player, amount: number): boolean
    if amount <= 0 then return false end

    local profile = self._Profiles[player]
    if not profile then return false end

    profile.Data.TotalCashEarned = math.round((tonumber(profile.Data.TotalCashEarned) or 0) + amount)
    return true
end

function PlayerDataService:AdjustTotalItemWeightTenths(player: Player, amount: number): boolean
    local tenths = math.floor(tonumber(amount) or 0)
    if tenths <= 0 then return false end

    local profile = self._Profiles[player]
    if not profile then return false end

    profile.Data.TotalItemWeightTenths = math.max(0, math.floor(tonumber(profile.Data.TotalItemWeightTenths) or 0)) + tenths

    local leaderstats = player:FindFirstChild("leaderstats")
    local weightStat = leaderstats and leaderstats:FindFirstChild("⚖️Weight")
    if weightStat and weightStat:IsA("NumberValue") then
        weightStat.Value = profile.Data.TotalItemWeightTenths / 10
    end
    return true
end

function PlayerDataService:AdjustWins(player: Player, amount: number, countTowardTotalWins: boolean?) : boolean
    local profile = self._Profiles[player]
    if not profile then return end
    if amount > 0 then
        self:AdjustTotalCashEarned(player, amount)
    end
    if amount > 0 and countTowardTotalWins ~= false then
        self:AdjustTotalWins(player, amount)
    end
    profile.Data.Wins += amount
    profile.Data.Wins = math.round(profile.Data.Wins)
    local leaderstats = player:FindFirstChild("leaderstats")
    local cash = leaderstats and leaderstats:FindFirstChild("💵Cash")
    if cash then
        cash.Value = profile.Data.Wins
    end
    self.Client.WinsChanged:Fire(player, profile.Data.Wins)
    self.WinsChangedServerEvent:Fire(player, profile.Data.Wins)
    return true
end

function PlayerDataService:AdjustDiamonds(player: Player, amount: number) : boolean
    local profile = self._Profiles[player]
    if not profile then return end
    profile.Data.Diamonds += amount
    profile.Data.Diamonds = math.round(profile.Data.Diamonds)
    self.Client.DiamondsChanged:Fire(player, profile.Data.Diamonds)
    return true
end

function PlayerDataService:GetAllData(player: Player)
    local profile = self._Profiles[player]
    if not profile then return end
    return profile.Data
end

function PlayerDataService:GetData(player: Player, directory: string)
    local profile = self._Profiles[player]
    if not profile then return end
    return profile.Data[directory]
end

function PlayerDataService:CreateLeaderstats(player: Player)
    local profile = self._Profiles[player]
    if not profile then return end

    local leaderstats = Instance.new("Folder", player)
    leaderstats.Name = "leaderstats"

    local cash = Instance.new("NumberValue", leaderstats)
    cash.Name = "💵Cash"
    cash.Value = profile.Data.Wins

    local weight = Instance.new("NumberValue", leaderstats)
    weight.Name = "⚖️Weight"
    weight.Value = (tonumber(profile.Data.TotalItemWeightTenths) or 0) / 10

    player:SetAttribute("Strength", profile.Data.Strength)
end

function PlayerDataService:RegisterBeforeProfileRelease(callback)
	table.insert(self._BeforeProfileRelease, callback)
end

local earlyWaiters = {}
local earlySent = {}
local interfaceRequests = {}
local privateFields = {
    DEFAULT_AREAS = true,
    DEFAULT_AREA = true,
    ProductPurchases = true,
    PaidEgg = true,
    FishingProgress = true,
    RedeemedCodesHistory = true,
    IndexDiscoveryLog = true,
    IndexRewardClaimLog = true,
    NewItemTagSeenLog = true,
    Items = true,
    PlotPlacements = true,
    Eggs = true,
    Pets = true,
    PetIndex = true,
}

function PlayerDataService:_SendInterfaceData(player)
    local profile = self._Profiles[player]
    if not profile or interfaceRequests[player] ~= "Pending" then
        return
    end
    interfaceRequests[player] = "Sent"
    local data = {}
    for key in Template do
        if not privateFields[key] then
            data[key] = profile.Data[key]
        end
    end
    -- The template's nil defaults do not appear during iteration.
    data.SpinningWheelLastCheckTime = profile.Data.SpinningWheelLastCheckTime
    data.FirstLoginDate = profile.Data.FirstLoginDate
    data.LoginDate = profile.Data.LoginDate
    data.AdvancedPackTask2FirstDate = profile.Data.AdvancedPackTask2FirstDate
    data.SeasonDailyTaskResetDate = profile.Data.SeasonDailyTaskResetDate
    data.SeasonWeeklyTaskResetDate = profile.Data.SeasonWeeklyTaskResetDate
    self.Client.DataLoaded:Fire(player, data)
end

function PlayerDataService:_ReleasePlayerProfile(player: Player)
	earlySent[player], interfaceRequests[player] = nil, nil
	local waiter = earlyWaiters[player]
	if waiter then
		waiter:Fire()
	end
	local profile = self._Profiles[player] or self._PendingProfiles[player]
	if profile then
		for _, callback in ipairs(self._BeforeProfileRelease) do
			local ok, err = pcall(callback, player, profile.Data)
			if not ok then
				warn("PlayerDataService: profile release callback failed", err)
			end
		end
	end
	self._Profiles[player] = nil
	self._PendingProfiles[player] = nil
	self._LoadingProfiles[player] = nil

	if profile then
		profile.Data.LastOnlineTime = os.time()
		profile:Release()
	end
end

function PlayerDataService:_WaitForEarlyData(player: Player)
	if earlyWaiters[player] or earlySent[player] then
		return nil
	end
	local profile = self._Profiles[player] or self._PendingProfiles[player]
	if not profile then
		local waiter = Instance.new("BindableEvent")
		earlyWaiters[player] = waiter
		task.delay(25, function()
			if earlyWaiters[player] == waiter then
				waiter:Fire()
			end
		end)
		waiter.Event:Wait()
		earlyWaiters[player] = nil
		waiter:Destroy()
		profile = self._Profiles[player] or self._PendingProfiles[player]
	end
	if profile and profile:IsActive() and player:IsDescendantOf(Players) then
		earlySent[player] = true
		return { Wins = profile.Data.Wins, Trophy = profile.Data.Trophy }
	end
	return nil
end

function PlayerDataService:BeginEarlyLoading()
	if self._EarlyLoadingStarted then
		return
	end
	self._EarlyLoadingStarted = true

	local earlyDataRemote = ReplicatedStorage:FindFirstChild(EARLY_DATA_REMOTE_NAME)
	if not earlyDataRemote then
		earlyDataRemote = Instance.new("RemoteFunction")
		earlyDataRemote.Name = EARLY_DATA_REMOTE_NAME
		earlyDataRemote.Parent = ReplicatedStorage
	end
	assert(earlyDataRemote:IsA("RemoteFunction"), EARLY_DATA_REMOTE_NAME .. " must be a RemoteFunction")
	earlyDataRemote.OnServerInvoke = function(player: Player)
		return self:_WaitForEarlyData(player)
	end

	Players.PlayerAdded:Connect(function(player: Player)
		task.spawn(function()
			self:LoadProfile(player)
		end)
	end)
	Players.PlayerRemoving:Connect(function(player: Player)
		self:_ReleasePlayerProfile(player)
	end)

	for _, player in Players:GetPlayers() do
		task.spawn(function()
			self:LoadProfile(player)
		end)
	end
end

function PlayerDataService:MarkFrameworkReady()
	self._FrameworkReady = true
end

-- Paid deliveries use the same profile store without taking over an offline session.
function PlayerDataService:QueuePaidDelivery(userId, kind, order)
	local updates = ProfileStore:GlobalUpdateProfileAsync("Player_" .. userId, function(globalUpdates)
		for _, list in ipairs({ globalUpdates:GetActiveUpdates(), globalUpdates:GetLockedUpdates() }) do
			for _, update in ipairs(list) do
				local value = update[2]
				if type(value) == "table" and value.Kind == kind and value.Order.OrderId == order.OrderId then
					return
				end
			end
		end
		globalUpdates:AddActiveUpdate({ Kind = kind, Order = order })
	end)
	return updates ~= nil
end

function PlayerDataService:QueuePaidEggDelivery(userId, order)
	return self:QueuePaidDelivery(userId, "PaidEggV1", order)
end

function PlayerDataService:MarkPaidEggProfileChanged(profile)
	local state = require(ReplicatedStorage.Modules.PaidEggDelivery).Ensure(profile.Data)
	state.Revision += 1
	profile:SetMetaTag("PaidEggRevision", state.Revision)
	return state.Revision
end

function PlayerDataService:SavePaidEggProfile(player)
	local profile = self:GetProfile(player)
	if not profile or not profile:IsActive() then
		return false
	end
	local revision = self:MarkPaidEggProfileChanged(profile)
	local persistence = require(script.Parent.PurchasePersistence)
	return persistence.Wait(profile, "PaidEggRevision", revision) and self:GetProfile(player) == profile
end

function PlayerDataService:WatchPaidDeliveries(player, kind, callback)
	local profile = self:GetProfile(player)
	if not profile or not profile:IsActive() then
		return {}
	end
	local updates = profile.GlobalUpdates
	local function active(id, value)
		if type(value) == "table" and value.Kind == kind and profile:IsActive() then
			updates:LockActiveUpdate(id)
			profile:Save()
		end
	end
	local function locked(id, value)
		if type(value) == "table" and value.Kind == kind then
			task.spawn(callback, id, value.Order)
		end
	end
	local connections = {
		updates:ListenToNewActiveUpdate(active),
		updates:ListenToNewLockedUpdate(locked),
	}
	for _, update in ipairs(updates:GetLockedUpdates()) do
		locked(update[1], update[2])
	end
	for _, update in ipairs(updates:GetActiveUpdates()) do
		active(update[1], update[2])
	end
	return connections
end

function PlayerDataService:ClearPaidDelivery(player, kind, updateId)
	local profile = self:GetProfile(player)
	if not profile or not profile:IsActive() then
		return
	end
	for _, update in ipairs(profile.GlobalUpdates:GetLockedUpdates()) do
		if update[1] == updateId and update[2].Kind == kind then
			profile.GlobalUpdates:ClearLockedUpdate(updateId)
			profile:Save()
			return
		end
	end
end

function PlayerDataService:WatchPaidEggDeliveries(player, callback)
	return self:WatchPaidDeliveries(player, "PaidEggV1", callback)
end

function PlayerDataService:ClearPaidEggDelivery(player, updateId)
	self:ClearPaidDelivery(player, "PaidEggV1", updateId)
end

function PlayerDataService:LoadProfile(player: Player)
    if self._Profiles[player] or self._PendingProfiles[player] or self._LoadingProfiles[player] then
        return
    end

    local profileKey = "Player_" .. player.UserId
    local loading = { failed = false }
    self._LoadingProfiles[player] = loading
    local function shouldCancel()
        return loading.failed or self._LoadingProfiles[player] ~= loading or not player:IsDescendantOf(Players)
    end
    local function failLoad(reason)
        if shouldCancel() then
            return
        end
        loading.failed = true
        warn(("[PlayerDataService] Could not load %s from %s: %s"):format(profileKey, DATA_BASE_NAME, reason))
        player:Kick(KICK_MESSAGE)
    end
    task.delay(LOAD_PROFILE_TIMEOUT, failLoad, "timed out waiting for player data")

    local profile
    for attempt = 1, LOAD_PROFILE_MAX_ATTEMPTS do
        if shouldCancel() then
            return
        end

        local success, result = pcall(function()
            return ProfileStore:LoadProfileAsync(profileKey, nil, shouldCancel)
        end)

        if shouldCancel() then
            if success and result then
                result:Release()
            end
            return
        end
        if success and result then
            profile = result
            break
        end

        local reason = success and "nil profile" or tostring(result)
        warn(("[PlayerDataService] LoadProfile failed for %s, attempt %d/%d: %s"):format(
            player.Name,
            attempt,
            LOAD_PROFILE_MAX_ATTEMPTS,
            reason
        ))

        if attempt < LOAD_PROFILE_MAX_ATTEMPTS then
            task.wait(LOAD_PROFILE_RETRY_BASE_DELAY * attempt)
        end
    end

    if not profile then
        failLoad("all load attempts failed")
        return
    end

    profile:AddUserId(player.UserId)

    if profile.MetaData.SessionLoadCount > 1 and profile.Data.Wins == nil then
        profile.Data.Wins = 0
    end
    profile:Reconcile()
    require(ReplicatedStorage.Modules.FishingProgression).Ensure(profile.Data, profile.MetaData.SessionLoadCount > 1)
    RodInventory.Reconcile(profile.Data)
    migrateRemovedLegacyFields(profile.Data)
	require(ReplicatedStorage.Modules.PetInventory).Reconcile(profile.Data, require(ReplicatedFirst.Data.PetsData))
	require(ReplicatedStorage.Modules.EggInventory).Reconcile(profile.Data, require(ReplicatedFirst.Data.EggsData))
    migratePlotHome(profile.Data)
	reconcileFishingOnboarding(profile.Data, studioOnboardingTest and profile.MetaData.SessionLoadCount == 1)
	require(ReplicatedStorage.Modules.TrainingProgress).Ensure(
		profile.Data, require(ReplicatedFirst.Data.TrainingData), require(ReplicatedFirst.Data.TrainingLevelsData)
	)
    sanitizeSettings(profile.Data)
    sanitizeHotbarLayout(profile.Data)

    sanitizeIndexLogs(profile.Data)
    sanitizeNewItemTagSeenLog(profile.Data)
	-- Reprice before either the early snapshot or the regular loaded-inventory event.
	require(ReplicatedStorage.Modules.ItemPriceMigration)(profile.Data)
	if shouldCancel() or not profile:IsActive() then
		failLoad("profile session ended before it was ready")
		profile:Release()
		return
	end
	profile:ListenToRelease(function()
		if player:IsDescendantOf(Players) then
			player:Kick(KICK_MESSAGE)
		end
	end)

	-- 数据已经可以先返回客户端；业务 Service 的 ProfileLoaded 广播等待 Knit 就绪。
	self._PendingProfiles[player] = profile
	self._LoadingProfiles[player] = nil
	local waiter = earlyWaiters[player]
	if waiter then
		waiter:Fire()
	end
	while player:IsDescendantOf(Players) and not self._FrameworkReady do
		task.wait()
	end

	if not player:IsDescendantOf(Players) or self._PendingProfiles[player] ~= profile or not profile:IsActive() then
		if self._PendingProfiles[player] == profile then
			self._PendingProfiles[player] = nil
			profile:Release()
		end
		return
	end

	self._PendingProfiles[player] = nil
	self._Profiles[player] = profile
	Knit.GetService("OnboardingAnalyticsService"):Initialize(player, profile)
	self:CreateLeaderstats(player)
	player:SetAttribute("EquippedRodId", profile.Data.EquippedRodId)
	FishingOnboarding.Publish(player, profile.Data)
	local offline = PlotFishIncome.PrepareOffline(profile.Data, os.time())
	player:SetAttribute("PlotOfflineAwaySeconds", offline.away)
	player:SetAttribute("PlotOfflineCountedSeconds", offline.counted)
	player:SetAttribute("PlayerProfileReady", true)
	self.ProfileLoaded:Fire(player, profile.Data)
	self:_SendInterfaceData(player)
end

function PlayerDataService:KnitInit()
    LogHelper.Print("PlayerDataService initialized")
	self:BeginEarlyLoading()
end

function PlayerDataService:KnitStart()
    LogHelper.Print("PlayerDataService started")

    self.Client.DataLoaded:Connect(function(player)
        if not interfaceRequests[player] then
            interfaceRequests[player] = "Pending"
            self:_SendInterfaceData(player)
        end
    end)

    if useMockProfiles then
        local reason = if studioOnboardingTest then "RestartTest onboarding" else "StudioUseMockProfiles"
        warn(("[PlayerDataService] Explicit temporary profiles enabled by %s. Progress lasts for this Studio session."):format(reason))
    end
end

return PlayerDataService
