local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Constants = require(ReplicatedStorage.Modules.Constants)
local Timer = require(ReplicatedStorage.Packages.Timer)

local WeekendEventService = Knit.CreateService {
    Name = "WeekendEventService",
    Client = {
    },
    _WeekendEventLeftTime = 0,
}

function WeekendEventService:IsWeekendEventEnabled(Type: "Wins" | "Strength"): boolean
    if Type == "Wins" then
        return self._WeekendEventLeftTime > 0 and Constants.WEEKEND_EVENT_WINS_ENABLED
    end

    if Type == "Strength" then
        return self._WeekendEventLeftTime > 0 and Constants.WEEKEND_EVENT_STRENGTH_ENABLED
    end
end

function WeekendEventService.Client:GetWeekendEventLeftTime(): number
    return self.Server:GetWeekendEventLeftTime()
end

function WeekendEventService:GetWeekendEventLeftTime(): number
    return self._WeekendEventLeftTime
end

function WeekendEventService:KnitInit()
end

function WeekendEventService:KnitStart()
    local playTimer = Timer.new(1)
    playTimer.Tick:Connect(function()
        local dayOfWeek = DateTime.now():FormatUniversalTime("d", "en-us")

        if dayOfWeek == "5" or dayOfWeek == "6" or dayOfWeek == "0" then
            self._WeekendEventEnabled = true

            local hour = DateTime.now():FormatUniversalTime("H", "en-us")
            local minute = DateTime.now():FormatUniversalTime("m", "en-us")
            local second = DateTime.now():FormatUniversalTime("s", "en-us")

            if dayOfWeek == "5" then
                self._WeekendEventLeftTime = 24 * 60 * 60 * 3 - (hour * 60 * 60 + minute * 60 + second)
            elseif dayOfWeek == "6" then
                self._WeekendEventLeftTime = 24 * 60 * 60 * 2 - (hour * 60 * 60 + minute * 60 + second)
            elseif dayOfWeek == "0" then
                self._WeekendEventLeftTime = 24 * 60 * 60 - (hour * 60 * 60 + minute * 60 + second)
            end
        else
            self._WeekendEventLeftTime = 0
        end
    end)
    playTimer:Start()
end

return WeekendEventService