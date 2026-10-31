local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Constants = require(ReplicatedStorage.Modules.Constants)
local Template = require(ReplicatedStorage.PlayerData.Template)
local HGAnalyticsService = require(ServerScriptService.Services.HGAnalyticsService)
local Signal = require(ReplicatedStorage.Packages.Signal)

local AreaService = Knit.CreateService {
    Name = "AreaService",
    Client = {
        -- Client -> Server
        UpdatePlayerCurrentArea = Knit.CreateSignal(),
        ResetCharacter = Knit.CreateSignal(),

        -- Server -> Client
        ResetAreas = Knit.CreateSignal(),
    },

    UpdatePlayerLocationServerEvent = Signal.new(),

    _CurrentAreaPerPlayer = {},
    _ProfileLoadedHandled = {},
}

function AreaService:GetCurrentArea(player: Player)
    if self._CurrentAreaPerPlayer[player] == nil then
        self._CurrentAreaPerPlayer[player] = Template.DEFAULT_AREA
    end
    return self._CurrentAreaPerPlayer[player]
end

function AreaService:ResetAreas(player: Player)
    self._CurrentAreaPerPlayer[player] = Template.DEFAULT_AREA

    local profile = PlayerDataService:GetProfile(player)
    if not profile then return end

    profile.Data.PlayerLocation = Template.DEFAULT_AREA
    profile.Data.Areas = Template.DEFAULT_AREAS
    profile.Data.NewestArea = Template.DEFAULT_AREA

    self.Client.ResetAreas:Fire(player)
end

function AreaService:KnitInit()
    Players.PlayerAdded:Connect(function(player: Player)
        self._CurrentAreaPerPlayer[player] = Template.DEFAULT_AREA
    end)

    Players.PlayerRemoving:Connect(function(player: Player)
        self._CurrentAreaPerPlayer[player] = nil
        self._ProfileLoadedHandled[player] = nil
    end)

    self.Client.ResetCharacter:Connect(function(player: Player)
        player:LoadCharacter()
    end)
end

function AreaService:KnitStart()
    self.Client.UpdatePlayerCurrentArea:Connect(function(player: Player, area: string)
        local profile = PlayerDataService:GetProfile(player)
        if not profile then warn("No Profile found!") return end
        local plotSlotService = Knit.GetService("PlotSlotService")
        local slotId = plotSlotService:EnsurePlayerSlot(player)
        if slotId and area == Template.DEFAULT_AREA then
            profile.Data.LastPlotSlotId = slotId
        end

        self._CurrentAreaPerPlayer[player] = area
        self.UpdatePlayerLocationServerEvent:Fire(player, area)
        profile.Data.PlayerLocation = area
    end)

    local function handleProfileLoaded(player: Player, playerData)
        if self._ProfileLoadedHandled[player] then
            return
        end
        self._ProfileLoadedHandled[player] = true

        playerData.PlayerLocation = Template.DEFAULT_AREA
        self._CurrentAreaPerPlayer[player] = Template.DEFAULT_AREA
        local plotSlotService = Knit.GetService("PlotSlotService")
        local slotId = plotSlotService:EnsurePlayerSlot(player)
        if slotId then
            playerData.LastPlotSlotId = slotId
        end

        HGAnalyticsService:LogWorldProgress(player, Constants.AREA_NAME.Area_1)
    end

    PlayerDataService.ProfileLoaded:Connect(handleProfileLoaded)

    for _, player in ipairs(Players:GetPlayers()) do
        local profile = PlayerDataService:GetProfile(player)
        if profile then
            handleProfileLoaded(player, profile.Data)
        end
    end
end

return AreaService
