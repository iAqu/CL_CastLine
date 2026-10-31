local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Template = require(ReplicatedStorage.PlayerData.Template)
local ProfileService = require(ServerScriptService.Libs.ProfileService)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local PlotPlacementUtil = require(ReplicatedStorage.Modules.PlotPlacementUtil)
local TimeUtil = require(ReplicatedStorage.Modules.TimeUtil)
local TutorialConfig = require(ReplicatedStorage.Modules.TutorialConfig)
local ShovelsData = require(ReplicatedFirst.Data.ShovelsData)

local DATA_BASE_NAME = "RELEASE_230724"
local ProfileStore = ProfileService.GetProfileStore(DATA_BASE_NAME, Template)

local KICK_MESSAGE = "Data issue, try again shortly. If issue persists, contact us!"
local LOAD_PROFILE_MAX_ATTEMPTS = 5
local LOAD_PROFILE_RETRY_BASE_DELAY = 1.5
local DEFAULT_SHOVEL_ID = "Shovel_101"
local EARLY_DATA_REMOTE_NAME = "RequestPlayerDataEarly"

local function sanitizeHotbarLayout(playerData)
    if typeof(playerData.HotbarLayout) ~= "table" then
        playerData.HotbarLayout = {}
        return
    end

    local sanitized = {}
    for slotKey, entry in pairs(playerData.HotbarLayout) do
        if typeof(entry) == "table"
            and (entry.Kind == "Potion" or entry.Kind == "Item")
            and typeof(entry.Id) == "string"
        then
            sanitized[slotKey] = entry
        end
    end
    playerData.HotbarLayout = sanitized
end

local function sanitizeEquippedShovel(playerData)
    local equippedShovelId = playerData.EquippedShovelId
    if typeof(equippedShovelId) ~= "string" or not ShovelsData[equippedShovelId] then
        equippedShovelId = DEFAULT_SHOVEL_ID
        playerData.EquippedShovelId = equippedShovelId
    end

    local ownedShovelIds = {}
    if typeof(playerData.OwnedShovelIds) == "table" then
        for shovelId, isOwned in pairs(playerData.OwnedShovelIds) do
            if isOwned == true and typeof(shovelId) == "string" and ShovelsData[shovelId] then
                ownedShovelIds[shovelId] = true
            end
        end
    end
    ownedShovelIds[DEFAULT_SHOVEL_ID] = true
    ownedShovelIds[equippedShovelId] = true
    playerData.OwnedShovelIds = ownedShovelIds
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
    "Pets",
    "PetIndex",
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
end

local function migrateLegacyTutorial(playerData)
    if playerData.TutorialVersion ~= nil then
        return
    end

	playerData.TutorialComplete = {}
	-- 缺少版本号的是旧存档；保留为旧版，避免 V2 上线后强制老玩家重走教程。
	playerData.TutorialVersion = TutorialConfig.VERSION - 1
end

local function migrateTutorialReturnToDigZone(playerData)
    if playerData.TutorialReturnedToDigZone ~= nil then
        return
    end

    playerData.TutorialReturnedToDigZone = playerData.TutorialVersion ~= TutorialConfig.VERSION
        or TutorialConfig.IsComplete(playerData)
end

local function migrateTutorialCashCollection(playerData)
    if playerData.TutorialCashCollected ~= nil then
        return
    end

    -- Existing V2 profiles predate this follow-up. Keep their current tutorial progress unchanged.
    playerData.TutorialCashCollected = true
end

local function migratePlotHome(playerData)
    if playerData.LastPlotSlotId == nil and typeof(playerData.LastFarmSlotId) == "number" then
        playerData.LastPlotSlotId = playerData.LastFarmSlotId
    end
    if typeof(playerData.PlotPlacements) ~= "table" then
        playerData.PlotPlacements = {}
    else
        playerData.PlotPlacements = PlotPlacementUtil.CoerceNumericKeys(playerData.PlotPlacements)
    end
    if typeof(playerData.PlotCashPools) ~= "table" then
        playerData.PlotCashPools = {}
    else
        playerData.PlotCashPools = PlotPlacementUtil.CoerceNumericKeys(playerData.PlotCashPools)
    end
end

function PlayerDataService:GetProfile(player: Player)
    return self._Profiles[player]
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

function PlayerDataService:_ReleasePlayerProfile(player: Player)
	local profile = self._Profiles[player] or self._PendingProfiles[player]
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
    migrateLegacyTutorial(profile.Data)
    migrateTutorialReturnToDigZone(profile.Data)
    migrateTutorialCashCollection(profile.Data)
    profile:Reconcile()
    migrateRemovedLegacyFields(profile.Data)
    migratePlotHome(profile.Data)
    sanitizeHotbarLayout(profile.Data)
    sanitizeEquippedShovel(profile.Data)
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
	self:CreateLeaderstats(player)
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
        if isLive then
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
