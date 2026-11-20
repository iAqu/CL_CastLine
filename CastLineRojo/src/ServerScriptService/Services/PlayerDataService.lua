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
local TimeUtil = require(ReplicatedStorage.Modules.TimeUtil)

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
local LOAD_PROFILE_MAX_ATTEMPTS = 5
local LOAD_PROFILE_RETRY_BASE_DELAY = 1.5
local EARLY_DATA_REMOTE_NAME = "RequestPlayerDataEarly"

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
        UpdateLoginDate = Knit.CreateSignal(),

        -- 存档加载完成后主动推送给对应客户端, 避免客户端轮询等待
        DataLoaded = Knit.CreateSignal(),
    },

    RebirthsChangedServerEvent = Signal.new(),
    StrengthChangedServerEvent = Signal.new(),
    WinsChangedServerEvent = Signal.new(),
    TrophyChangedServerEvent = Signal.new(),
    ProfileLoaded = Signal.new(),
    UpdateLoginDateEvent = Signal.new(),

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
    local placements = PlotPlacementUtil.CoerceNumericKeys(playerData.PlotPlacements)
    for slot in pairs(placements) do
        if slot < 1 or slot > capacity then
            placements[slot] = nil
        end
    end
    local items = if typeof(playerData.Items) == "table" then playerData.Items else {}
    local seen = {}
    for slot = 1, capacity do
        local uid = PlotPlacementUtil.GetItemUid(placements, slot)
        if not uid or seen[uid] or typeof(items[uid]) ~= "table" then
            placements[slot] = nil
        else
            seen[uid] = true
        end
    end
    playerData.PlotPlacements = placements
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
    -- leaderstats.Wins.Value = profile.Data.Wins
    leaderstats["💵Cash"].Value = profile.Data.Wins
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

function PlayerDataService.Client:GetAllData(player: Player)
    return self.Server:GetAllData(player)
end

function PlayerDataService:GetAllData(player: Player)
    local profile = self._Profiles[player]
    if not profile then return end
    return profile.Data
end

function PlayerDataService.Client:GetData(player: Player, directory: string)
    return self.Server:GetData(player, directory)
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

function PlayerDataService:_ReleasePlayerProfile(player: Player)
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
	while player:IsDescendantOf(Players) do
		local profile = self._Profiles[player] or self._PendingProfiles[player]
		if profile then
			return profile.Data
		end
		task.wait()
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
function PlayerDataService:QueuePaidEggDelivery(userId, order)
	local updates = ProfileStore:GlobalUpdateProfileAsync("Player_" .. userId, function(globalUpdates)
		for _, list in ipairs({ globalUpdates:GetActiveUpdates(), globalUpdates:GetLockedUpdates() }) do
			for _, update in ipairs(list) do
				local value = update[2]
				if type(value) == "table" and value.Kind == "PaidEggV1" and value.Order.OrderId == order.OrderId then
					return
				end
			end
		end
		globalUpdates:AddActiveUpdate({ Kind = "PaidEggV1", Order = order })
	end)
	return updates ~= nil
end

function PlayerDataService:SavePaidEggProfile(player)
	local profile = self:GetProfile(player)
	if not profile or not profile:IsActive() then
		return false
	end
	local state = require(ReplicatedStorage.Modules.PaidEggDelivery).Ensure(profile.Data)
	state.Revision += 1
	local revision = state.Revision
	profile:SetMetaTag("PaidEggRevision", revision)
	profile:Save()
	local deadline = os.clock() + 10
	repeat
		if not profile:IsActive() or self:GetProfile(player) ~= profile then
			return false
		end
		if (profile.MetaData.MetaTagsLatest.PaidEggRevision or -1) >= revision then
			return true
		end
		task.wait(0.1)
	until os.clock() >= deadline
	return false
end

function PlayerDataService:WatchPaidEggDeliveries(player, callback)
	local profile = self:GetProfile(player)
	if not profile or not profile:IsActive() then
		return {}
	end
	local updates = profile.GlobalUpdates
	local function active(id, value)
		if type(value) == "table" and value.Kind == "PaidEggV1" and profile:IsActive() then
			updates:LockActiveUpdate(id)
			profile:Save()
		end
	end
	local function locked(id, value)
		if type(value) == "table" and value.Kind == "PaidEggV1" then
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

function PlayerDataService:ClearPaidEggDelivery(player, updateId)
	local profile = self:GetProfile(player)
	if not profile or not profile:IsActive() then
		return
	end
	for _, update in ipairs(profile.GlobalUpdates:GetLockedUpdates()) do
		if update[1] == updateId and update[2].Kind == "PaidEggV1" then
			profile.GlobalUpdates:ClearLockedUpdate(updateId)
			profile:Save()
			return
		end
	end
end

function PlayerDataService:LoadProfile(player: Player)
    if self._Profiles[player] or self._PendingProfiles[player] or self._LoadingProfiles[player] then
        return
    end

    self._LoadingProfiles[player] = true
    local profile
    local profileKey = "Player_" .. player.UserId

    for attempt = 1, LOAD_PROFILE_MAX_ATTEMPTS do
        if not player:IsDescendantOf(Players) then
            self._LoadingProfiles[player] = nil
            return
        end

        local success, result = pcall(function()
            return ProfileStore:LoadProfileAsync(profileKey)
        end)

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
        self._LoadingProfiles[player] = nil
        player:Kick(KICK_MESSAGE)
        return
    end

    profile:AddUserId(player.UserId)

    if profile.MetaData.SessionLoadCount > 1 and profile.Data.Wins == nil then
        profile.Data.Wins = 0
    end
    profile:Reconcile()
    if studioOnboardingTest and profile.MetaData.SessionLoadCount == 1 then
        profile.Data.FishingOnboarding = { Stage = "FirstCatch" }
    end
    require(ReplicatedStorage.Modules.FishingProgression).Ensure(profile.Data, profile.MetaData.SessionLoadCount > 1)
    RodInventory.Reconcile(profile.Data)
    migrateRemovedLegacyFields(profile.Data)
	require(ReplicatedStorage.Modules.PetInventory).Reconcile(profile.Data, require(ReplicatedFirst.Data.PetsData))
	require(ReplicatedStorage.Modules.EggInventory).Reconcile(profile.Data, require(ReplicatedFirst.Data.EggsData))
    migratePlotHome(profile.Data)
	require(ReplicatedStorage.Modules.TrainingProgress).Ensure(
		profile.Data, require(ReplicatedFirst.Data.TrainingData), require(ReplicatedFirst.Data.TrainingLevelsData)
	)
    sanitizeHotbarLayout(profile.Data)

    sanitizeIndexLogs(profile.Data)
    sanitizeNewItemTagSeenLog(profile.Data)
    profile:ListenToRelease(function()
		if player:IsDescendantOf(Players) then
			player:Kick(KICK_MESSAGE)
		end
    end)

	if not player:IsDescendantOf(Players) then
		self._LoadingProfiles[player] = nil
		profile:Release()
		return
	end

	-- Reprice before either the early snapshot or the regular loaded-inventory event.
	require(ReplicatedStorage.Modules.ItemPriceMigration)(profile.Data)
	-- 数据已经可以先返回客户端；业务 Service 的 ProfileLoaded 广播等待 Knit 就绪。
	self._PendingProfiles[player] = profile
	self._LoadingProfiles[player] = nil
	while player:IsDescendantOf(Players) and not self._FrameworkReady do
		task.wait()
	end

	if not player:IsDescendantOf(Players) or self._PendingProfiles[player] ~= profile then
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
	self.ProfileLoaded:Fire(player, profile.Data)
	self.Client.DataLoaded:Fire(player, profile.Data)
end

function PlayerDataService:KnitInit()
    LogHelper.Print("PlayerDataService initialized")
	self:BeginEarlyLoading()
end

function PlayerDataService:KnitStart()
    LogHelper.Print("PlayerDataService started")

    task.spawn(function()
        local isLive = ProfileService.IsLive()
        if isLive and not useMockProfiles then
            LogHelper.Print("[PlayerDataService] ProfileService is live. Data will persist.")
        else
            warn("[PlayerDataService] ProfileService is using mock store. Data will NOT persist across Studio restarts.")
        end
    end)

    self.Client.UpdateLoginDate:Connect(function(player: Player, localDate: number)
        if math.abs(TimeUtil.GetUniversalDate() - localDate) > 1 then warn("Time difference is too large") return end
        
        local profile = self._Profiles[player]
        if not profile then return end

        if not profile.Data.FirstLoginDate then
            profile.Data.FirstLoginDate = localDate
        end
        
        if not profile.Data.LoginDate then
            profile.Data.LoginDate = localDate
            profile.Data.ContinueLoginDays = 1
        end

        if localDate == profile.Data.LoginDate then     
            -- do nothing
        elseif localDate - profile.Data.LoginDate == 1 or localDate - profile.Data.LoginDate == 636 then    -- 2023001 - 2022365 - 636
            profile.Data.ContinueLoginDays += 1
            profile.Data.LoginDate = localDate

        else
            profile.Data.ContinueLoginDays = 1
            profile.Data.LoginDate = localDate
        end

        self.UpdateLoginDateEvent:Fire(player)
    end)
end

return PlayerDataService
