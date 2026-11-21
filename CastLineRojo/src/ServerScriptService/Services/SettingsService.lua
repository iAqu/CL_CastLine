local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local Knit = require(ReplicatedStorage.Packages.Knit)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local Constants = require(ReplicatedStorage.Modules.Constants)

local PERFORMANCE_MODES = {
    Auto = true,
    Battery = true,
    Quality = true,
}

local settingIds = {}
for _, settingId in Constants.SETTINGS_ID do
    settingIds[settingId] = true
end

local function isValidSettingValue(settingId: unknown, value: unknown): boolean
    if type(settingId) ~= "string" or not settingIds[settingId] then
        return false
    end
    if settingId == Constants.SETTINGS_ID.PERFORMANCE_MODE then
        return type(value) == "string" and PERFORMANCE_MODES[value] == true
    end
    return type(value) == "boolean"
end

local SettingsService = Knit.CreateService {
    Name = "SettingsService",
    Client = {
        -- Redeem = Knit.CreateSignal(),
        ChangeSetting = Knit.CreateSignal(),
    
        -- Client to Server
        ReadUpdateLog = Knit.CreateSignal(),
    },
}

function SettingsService.Client:GetAllPlayersTradeSetting(): { [string]: boolean }
    return self.Server:GetAllPlayersTradeSetting()
end

function SettingsService:GetAllPlayersTradeSetting(): { [string]: boolean }
    local result = {}
    for _, player in pairs(Players:GetPlayers()) do
        local profile = PlayerDataService:GetProfile(player)
        if profile then
            result[player.UserId] = profile.Data.Settings[Constants.SETTINGS_ID.TRADE]
        end
    end
    return result
end

function SettingsService:EnableTrade(player: Player, enabled: boolean)
    self:ChangeSetting(player, Constants.SETTINGS_ID.TRADE, enabled)
end

function SettingsService:ChangeSetting(player: Player, settingId: unknown, value: unknown)
    if not isValidSettingValue(settingId, value) then
        return
    end
    local profile = PlayerDataService:GetProfile(player)
    if not profile or profile.Data.Settings[settingId] == value then
        return
    end
    profile.Data.Settings[settingId] = value
    if settingId == Constants.SETTINGS_ID.TRADE then
        self.Client.ChangeSetting:FireAll(player, settingId, value)
    else
        self.Client.ChangeSetting:Fire(player, settingId, value)
    end
end

function SettingsService:KnitInit()
    LogHelper.Print("CodesService initialized")
end

function SettingsService:KnitStart()
    LogHelper.Print("CodesService started")
    self.Client.ChangeSetting:Connect(function(player: Player, settingId: string, settingValue: any)
        self:ChangeSetting(player, settingId, settingValue)
    end)

    -- when new player joins, tell all players to update his equipped greatsword
    PlayerDataService.ProfileLoaded:Connect(function(player: Player, playerData)
        self.Client.ChangeSetting:FireAll(player, Constants.SETTINGS_ID.TRADE, playerData.Settings[Constants.SETTINGS_ID.TRADE])
    end)

    self.Client.ReadUpdateLog:Connect(function(player: Player)
        local profile = PlayerDataService:GetProfile(player)
        if not profile then return end

        if profile.Data.UpdateReadLog[Constants.UPDATE_VERSION] then return end

        profile.Data.UpdateReadLog[Constants.UPDATE_VERSION] = true
    end)
end

return SettingsService
