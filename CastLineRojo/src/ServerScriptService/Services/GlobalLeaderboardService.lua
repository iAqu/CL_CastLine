local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local DataStoreService = game:GetService("DataStoreService")
local Workspace = game:GetService("Workspace")
local ServerStorage = game:GetService("ServerStorage")
local UserService = game:GetService("UserService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local Constants = require(ReplicatedStorage.Modules.Constants)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local GuiUtil = require(ReplicatedStorage.Modules.GuiUtil)
local WeightFormat = require(ReplicatedStorage.Modules.WeightFormat)

local MAX_ITEMS_COUNT = 50
local MIN_VALUE_DISPLAY = 1
local MAX_VALUE_DISPLAY = 10e30
local ORDERED_DATA_STORE_MAX = 9223372036854775807

type LeaderboardType = "Wins" | "Weight"

local LEADERBOARD_TYPES: {LeaderboardType} = {"Wins", "Weight"}
local DATA_STORES: {[LeaderboardType]: OrderedDataStore} = {
    Wins = DataStoreService:GetOrderedDataStore("GlobalLeaderboard_CashEarned_V2"),
    Weight = DataStoreService:GetOrderedDataStore("GlobalLeaderboard_ItemWeightTenths_V1"),
}

local PROFILE_TOTAL_FIELDS: {[LeaderboardType]: string} = {
    Wins = "TotalCashEarned",
    Weight = "TotalItemWeightTenths",
}

local VALUE_LABELS: {[LeaderboardType]: string} = {
    Wins = "Cash",
    Weight = "Weight",
}

local COLUMN_LABELS: {[LeaderboardType]: string} = {
    Wins = "Cash",
    Weight = "Weight",
}

local LeadboardGui = ServerStorage.Gui.LeaderboardGui
local leaderboardModels = {}

local GlobalLeaderboardService = Knit.CreateService {
    Name = "GlobalLeaderboardService",
    Client = {
        UpdateMyBestData = Knit.CreateSignal(),
        UpdatePlayersInLeaderboard = Knit.CreateSignal(),
    },

    _LeaderboardCache = {
        Wins = {},
        Weight = {},
    },
    _TopPageCache = {
        Wins = nil,
        Weight = nil,
    },
    _DanceAnimTracks = {},
}

local function isLeaderboardType(value: any): boolean
    return DATA_STORES[value] ~= nil
end

local function sanitizeOrderedDataStoreValue(rawValue: any): number
    local numericValue = tonumber(rawValue)
    if numericValue == nil or numericValue ~= numericValue then
        return 0
    end
    if numericValue == math.huge or numericValue == -math.huge then
        return 0
    end

    local integerValue = math.floor(numericValue + 0.5)
    if integerValue < 0 then
        return 0
    end
    if integerValue > ORDERED_DATA_STORE_MAX then
        return ORDERED_DATA_STORE_MAX
    end
    return integerValue
end

local function formatLeaderboardValue(leaderboardType: LeaderboardType, value: number): string
    if leaderboardType == "Wins" then
        return NumberUtil.FormatWinsAmount(value, 2)
    elseif leaderboardType == "Weight" then
        return WeightFormat.FormatKg(value / 10)
    end
    return NumberUtil.FormatNumberStartKWithDecimal(value, 2)
end

local function getProfileTotal(profileData, leaderboardType: LeaderboardType): number
    local fieldName = PROFILE_TOTAL_FIELDS[leaderboardType]
    return sanitizeOrderedDataStoreValue(profileData[fieldName])
end

local function getLeaderboardLayout(leaderboardGui: Instance): (Instance?, ScrollingFrame?, TextLabel?, TextLabel?)
    local container = leaderboardGui:FindFirstChild("Frame") or leaderboardGui
    local listFrame = container:FindFirstChild("ListFrame")
    local columnLabel = container:FindFirstChild("ValueLabel")
    local bestLabel = container:FindFirstChild("BestLabel")
    local bestValueLabel = bestLabel and bestLabel:FindFirstChild("ValueLabel")

    if not listFrame or not listFrame:IsA("ScrollingFrame") then return nil, nil, nil, nil end
    if not columnLabel or not columnLabel:IsA("TextLabel") then return nil, nil, nil, nil end
    if not bestValueLabel or not bestValueLabel:IsA("TextLabel") then return nil, nil, nil, nil end
    return container, listFrame, columnLabel, bestValueLabel
end

function GlobalLeaderboardService:InitLeaderboardGui()
    LeadboardGui.Adornee = nil
    local _, templateListFrame = getLeaderboardLayout(LeadboardGui)
    if not templateListFrame then
        warn("LeaderboardGui template is missing ListFrame, ValueLabel, or BestLabel.ValueLabel")
        return
    end

    for _, template in pairs(templateListFrame:GetChildren()) do
        if template:IsA("Frame") then
            template.Visible = false
            template.NameLabel.Text = "Loading..."
            template.RankLabel.Text = "#"
            template.ValueLabel.Text = "Loading..."
        end
    end

    for _, leaderboard in Workspace.Leaderboards:GetChildren() do
        local leaderboardType = leaderboard:GetAttribute("Type")
        if leaderboardType == nil then continue end
        if not isLeaderboardType(leaderboardType) then
            warn("Leaderboard has invalid Type attribute", leaderboardType)
            continue
        end

        table.insert(leaderboardModels, leaderboard)

        local leaderboardGui = LeadboardGui:Clone()
        leaderboardGui.Parent = leaderboard
        if not leaderboard.PrimaryPart then warn("Leaderboard has no PrimaryPart") continue end

        leaderboardGui.Adornee = leaderboard.PrimaryPart
        leaderboardGui.Name = "LeaderboardGui"
        leaderboardGui.Enabled = true
        local _, listFrame, columnLabel, bestValueLabel = getLeaderboardLayout(leaderboardGui)
        if not listFrame or not columnLabel or not bestValueLabel then
            warn("LeaderboardGui clone is missing ListFrame, ValueLabel, or BestLabel.ValueLabel")
            leaderboardGui:Destroy()
            continue
        end
        columnLabel.Text = COLUMN_LABELS[leaderboardType]
        bestValueLabel.Text = "Loading..."

        GuiUtil.AutoResizeScrollingFrame(leaderboardGui)

        for index = 1, MAX_ITEMS_COUNT do
            local template = templateListFrame:FindFirstChild("Template")
            if not template then
                warn("LeaderboardGui template is missing ListFrame.Template")
                break
            end
            local entryGui = template:Clone()
            entryGui.Parent = listFrame
            entryGui.Visible = true
            entryGui.LayoutOrder = index
            entryGui.Name = index

            if index == 1 then
                entryGui.RankLabel.TextColor3 = Constants.COLOR.YELLOW
            elseif index == 2 then
                entryGui.RankLabel.TextColor3 = Constants.COLOR.PURPLE
            elseif index == 3 then
                entryGui.RankLabel.TextColor3 = Constants.COLOR.BLUE_LIGHT
            end
        end
    end
end

function GlobalLeaderboardService.Client:GetMyBestData(player: Player, leaderboardType: LeaderboardType): number
    return GlobalLeaderboardService:GetMyBestData(player, leaderboardType)
end

function GlobalLeaderboardService:GetMyBestData(player: Player, leaderboardType: LeaderboardType): number
    if not isLeaderboardType(leaderboardType) then return 0 end
    return self._LeaderboardCache[leaderboardType][player.UserId] or 0
end

function GlobalLeaderboardService:LoadPlayerLeaderboardData(player: Player)
    local profile = PlayerDataService:GetProfile(player)
    if not profile then return end

    for _, leaderboardType in ipairs(LEADERBOARD_TYPES) do
        local dataStore = DATA_STORES[leaderboardType]
        local cachedValue = 0
        local success, storedValue = pcall(function()
            return dataStore:GetAsync(tostring(player.UserId))
        end)

        if success and storedValue then
            cachedValue = sanitizeOrderedDataStoreValue(storedValue)
        else
            cachedValue = 0
        end

        self._LeaderboardCache[leaderboardType][player.UserId] = cachedValue
        self.Client.UpdateMyBestData:Fire(player, leaderboardType, math.max(cachedValue, getProfileTotal(profile.Data, leaderboardType)))
    end
end

function GlobalLeaderboardService:SyncPlayerLeaderboardData(player: Player)
    if PlayerDataService:IsStudioOnboardingTest() then return end
    local profile = PlayerDataService:GetProfile(player)
    if not profile then return end

    local GameOperationService = Knit.GetService("GameOperationService")
    local blackList = GameOperationService:GetBlackList()
    if blackList and blackList[tostring(player.UserId)] then return end

    for _, leaderboardType in ipairs(LEADERBOARD_TYPES) do
        local profileTotal = getProfileTotal(profile.Data, leaderboardType)
        local cachedValue = sanitizeOrderedDataStoreValue(self._LeaderboardCache[leaderboardType][player.UserId])
        if profileTotal > cachedValue then
            local success = pcall(function()
                DATA_STORES[leaderboardType]:SetAsync(tostring(player.UserId), profileTotal)
            end)
            if success then
                self._LeaderboardCache[leaderboardType][player.UserId] = profileTotal
                self.Client.UpdateMyBestData:Fire(player, leaderboardType, profileTotal)
            end
        end
    end
end

function GlobalLeaderboardService:UpdateDataStore()
    for _, player in pairs(Players:GetPlayers()) do
        self:SyncPlayerLeaderboardData(player)
    end
end

function GlobalLeaderboardService:UpdateLeaderboard(leaderboardType: LeaderboardType, topPage: table)
    if not topPage then warn("topPage is nil") return end

    for _, leaderboard in pairs(leaderboardModels) do
        if not leaderboard:IsDescendantOf(workspace) then continue end
        if leaderboard:GetAttribute("Type") ~= leaderboardType then continue end

        local leaderboardGui = leaderboard:FindFirstChild("LeaderboardGui")
        if not leaderboardGui then warn("LeaderboardGui not found") continue end
        local _, listFrame = getLeaderboardLayout(leaderboardGui)
        if not listFrame then
            warn("LeaderboardGui is missing ListFrame, ValueLabel, or BestLabel.ValueLabel")
            continue
        end

        for index, entry in ipairs(topPage) do
            local userId = tonumber(entry.key)
            local value = entry.value
            local entryGui = listFrame:FindFirstChild(index)
            if not entryGui then continue end

            local success, result = pcall(function()
                return UserService:GetUserInfosByUserIdsAsync({userId})
            end)
            if success and result and result[1] then
                entryGui.NameLabel.Text = result[1].DisplayName
            else
                entryGui.NameLabel.Text = "Loading..."
            end

            entryGui.RankLabel.Text = "#" .. index
            entryGui.ValueLabel.Text = formatLeaderboardValue(leaderboardType, value)
            task.wait()
        end
    end
end

function GlobalLeaderboardService:UpdateDancingPlayers(leaderboardType: LeaderboardType, topPage: table)
    local dancingPlayers = Workspace.Leaderboards:FindFirstChild("DancingPlayers")
    if not dancingPlayers then return end

    local holders = dancingPlayers:FindFirstChild(leaderboardType)
    if not holders then return end

    for index, entry in ipairs(topPage) do
        local playerAvatarHolder = holders:FindFirstChild(tostring(index))
        if not playerAvatarHolder then continue end

        task.spawn(function()
            self:PlayerDance(leaderboardType, playerAvatarHolder, tonumber(entry.key), index, entry.value)
        end)
        task.wait(1)
    end
end

function GlobalLeaderboardService:UpdateLeaderboards()
    for _, leaderboardType in ipairs(LEADERBOARD_TYPES) do
        local success, pages = pcall(function()
            return DATA_STORES[leaderboardType]:GetSortedAsync(false, MAX_ITEMS_COUNT, MIN_VALUE_DISPLAY, MAX_VALUE_DISPLAY)
        end)

        if success and pages then
            local topPage = pages:GetCurrentPage()
            self._TopPageCache[leaderboardType] = topPage
            self:UpdateLeaderboard(leaderboardType, topPage)
            self:UpdateDancingPlayers(leaderboardType, topPage)
        end
    end

    self:UpdatePlayersInLeaderboard()
end

function GlobalLeaderboardService:UpdatePlayersInLeaderboard()
    task.spawn(function()
        local playersInLeaderboard = {}

        for _, player in pairs(Players:GetPlayers()) do
            local playerData = {}

            for _, leaderboardType in ipairs(LEADERBOARD_TYPES) do
                local topPage = self._TopPageCache[leaderboardType]
                if topPage then
                    for index, entry in ipairs(topPage) do
                        if entry.key == tostring(player.UserId) then
                            playerData[leaderboardType] = index
                            break
                        end
                    end
                end
            end

            playersInLeaderboard[tostring(player.UserId)] = playerData
        end

        for _, player in pairs(Players:GetPlayers()) do
            self.Client.UpdatePlayersInLeaderboard:Fire(player, playersInLeaderboard)
        end
    end)
end

function GlobalLeaderboardService:PlayerDance(leaderboardType: LeaderboardType, playerAvatarHolder: Model, userId: number, index: number, value: number)
    if not playerAvatarHolder then return end
    LogHelper.Print("PlayerDance")

    local success, description = pcall(function()
        return Players:GetHumanoidDescriptionFromUserId(userId)
    end)
    if not success then return end

    local avatarModel = playerAvatarHolder:FindFirstChild("Avatar")
    if not avatarModel then warn("avatarModel not found"); return end

    local modelScale = avatarModel:GetScale()
    description.HeadScale *= modelScale
    description.DepthScale *= modelScale
    description.HeightScale *= modelScale
    description.WidthScale *= modelScale

    playerAvatarHolder.Avatar.Humanoid:ApplyDescription(description)
    playerAvatarHolder.Avatar:WaitForChild("HumanoidRootPart").Anchored = true

    for _, child in pairs(playerAvatarHolder.Avatar:GetChildren()) do
        if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
            child.Anchored = false
        end
    end

    for _, child in pairs(playerAvatarHolder.Avatar:GetDescendants()) do
        if child:IsA("BasePart") then
            child.CastShadow = false
        end
    end

    if #playerAvatarHolder.Avatar.Humanoid:GetPlayingAnimationTracks() <= 0 then
        local animTrack = self:GetDanaceAnimTrack(playerAvatarHolder)
        animTrack:Play()
    end

    local userInfoSuccess, result = pcall(function()
        return UserService:GetUserInfosByUserIdsAsync({tonumber(userId)})
    end)
    if userInfoSuccess and result and result[1] then
        playerAvatarHolder.Part.BillboardGui.Frame.PlayerName.Text = "#" .. index .. " " .. result[1].DisplayName
    else
        playerAvatarHolder.Part.BillboardGui.Frame.PlayerName.Text = "#" .. index .. " Loading"
    end

    playerAvatarHolder.Part.BillboardGui.Frame.WinsAmount.Text =
        VALUE_LABELS[leaderboardType] .. ": " .. formatLeaderboardValue(leaderboardType, value)
end

function GlobalLeaderboardService:GetDanaceAnimTrack(playerAvatarHolder: Model): AnimationTrack
    local key = playerAvatarHolder
    local track = self._DanceAnimTracks[key]
    if not track then
        local animator = playerAvatarHolder.Avatar.Humanoid:WaitForChild("Animator")
        track = animator:LoadAnimation(playerAvatarHolder.Avatar.Animation)
        self._DanceAnimTracks[key] = track
    end
    return track
end

function GlobalLeaderboardService:RemoveLeaderboard(playerId: number)
    local playerKey = tostring(playerId)
    for _, dataStore in pairs(DATA_STORES) do
        dataStore:RemoveAsync(playerKey)
    end
end

function GlobalLeaderboardService:KnitInit()
    Players.PlayerAdded:Connect(function(player: Player)
        task.defer(function()
            self:LoadPlayerLeaderboardData(player)
        end)
    end)

    Players.PlayerRemoving:Connect(function(player: Player)
        for _, leaderboardType in ipairs(LEADERBOARD_TYPES) do
            self._LeaderboardCache[leaderboardType][player.UserId] = nil
        end
    end)
end

function GlobalLeaderboardService:KnitStart()
    self:InitLeaderboardGui()

    PlayerDataService.ProfileLoaded:Connect(function(player: Player)
        self:LoadPlayerLeaderboardData(player)
        task.delay(5, function()
            self:UpdatePlayersInLeaderboard()
        end)
    end)

    task.spawn(function()
        while true do
            self:UpdateDataStore()
            self:UpdateLeaderboards()
            task.wait(Constants.LEADERBOARD_UPDATE_INTERVAL)
        end
    end)
end

return GlobalLeaderboardService
