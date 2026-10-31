-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, Workspace = services.Players, services.Workspace
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local selectPlayerMetadata = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerMetadata
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "playtime-spin-wheel-config")
local getSecondsUntilNextSpinWheelSpin, getSpinWheelDailyPlaytimeSeconds = v1.getSecondsUntilNextSpinWheelSpin, v1.getSpinWheelDailyPlaytimeSeconds
local getDayKey = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "metadata-utils").getDayKey

local function formatHms(p1) -- line: 15
    local v3 = math.max(0, (math.floor(p1)))
    local v5 = math.floor(v3 / 3600)
    local v7 = math.floor(v3 % 3600 / 60)
    local v8 = v3 % 60

    local function v9(p2) -- line: 20
        if p2 < 10 then
            return (("0%*"):format(p2))
        end

        return (tostring(p2))
    end

    return (("%*:%*:%*"):format(if v5 < 10 then ("0%*"):format(v5) else tostring(v5), if v7 < 10 then ("0%*"):format(v7) else tostring(v7), if v8 < 10 then ("0%*"):format(v8) else tostring(v8)))
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 34
        return "SpinWheelTimerController"
    end
})

self.__index = self

function self.new(...) -- line: 39
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p3) -- line: 43
    p3._timeSinceLastUpdate = 0
end

function self.onStart(_) -- line: 46
end

function self.onTick(p5, p6) -- line: 48
    p5._timeSinceLastUpdate += p6

    if p5._timeSinceLastUpdate < 0.25 then
        return nil
    end

    p5._timeSinceLastUpdate = 0

    local v12 = p5:_getTimerText()

    if not v12 then
        return nil
    end

    v12.Text = p5:_computeTimerText()
end

function self._computeTimerText(_) -- line: 60
    -- upvalues: Players (copy), Workspace (copy), clientProducer (copy), selectPlayerMetadata (copy), getSecondsUntilNextSpinWheelSpin (copy), getSpinWheelDailyPlaytimeSeconds (copy), getDayKey (copy), formatHms (copy)
    local v14 = selectPlayerMetadata((tostring(Players.LocalPlayer.UserId)))(clientProducer:getState())

    if not v14 then
        return "NEXT SPIN: --:--:--"
    end

    local ServerTimeNow = Workspace:GetServerTimeNow()
    local v15, v16

    if v14.spinWheelDayKey == getDayKey(ServerTimeNow) then
        v16 = getSpinWheelDailyPlaytimeSeconds(ServerTimeNow, v14.spinWheelSavedPlaytime, v14.spinWheelStartTime, v14.timeLastSaved)
        v15 = v14.spinWheelSpinsGrantedToday
    else
        v16 = 0
        v15 = 0
    end

    local v17 = getSecondsUntilNextSpinWheelSpin(v16, v15)

    if v17 == nil then
        return "Come back tomorrow for more SPINS!"
    end

    return (("NEXT SPIN: %*"):format((formatHms(v17))))
end

function self._getTimerText(p8) -- line: 77
    -- upvalues: Workspace (copy)
    local _timerText = p8._timerText

    if _timerText ~= nil then
        _timerText = _timerText.Parent
    end

    if _timerText == nil then
        local Map = Workspace:FindFirstChild("Map")

        if Map ~= nil then
            Map = Map:FindFirstChild("Shops")
        end

        if Map ~= nil then
            Map = Map:FindFirstChild("SpinWheel")
        end

        if Map == nil then
            Map = Workspace:FindFirstChild("SpinWheel", true)
        end

        if Map ~= nil then
            Map = Map:FindFirstChild("TimerLabel")

            if Map ~= nil then
                Map = Map:FindFirstChild("TimerBillboardGui")

                if Map ~= nil then
                    Map = Map:FindFirstChild("TimerText")
                end
            end
        end

        p8._timerText = if not (if Map == nil then Map else Map:IsA("TextLabel")) then nil else Map
    end

    return p8._timerText
end

Reflect.defineMetadata(self, "identifier", "client/controllers/spin-wheel-timer-controller@SpinWheelTimerController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnTick" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    SpinWheelTimerController = self
}
