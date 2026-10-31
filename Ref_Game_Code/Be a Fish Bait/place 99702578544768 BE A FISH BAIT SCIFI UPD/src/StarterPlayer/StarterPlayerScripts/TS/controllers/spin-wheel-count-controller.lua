-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, Workspace = services.Players, services.Workspace
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local selectPlayerStat = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerStat
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 23
        return "SpinWheelCountController"
    end
})

self.__index = self

function self.new(...) -- line: 28
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1) -- line: 32
    p1._timeSinceLastUpdate = 0
    p1._currentSpinCount = 0
end

function self.onStart(p2) -- line: 36
    -- upvalues: Players (copy), clientProducer (copy), selectPlayerStat (copy)
    local spinWheelSpins = selectPlayerStat(tostring(Players.LocalPlayer.UserId), "spinWheelSpins")
    local v4 = spinWheelSpins(clientProducer:getState())

    if v4 == nil then
        v4 = 0
    end

    p2._currentSpinCount = math.max(0, v4)
    p2:_updateSpinText()
    clientProducer:subscribe(spinWheelSpins, function(p3) -- line: 45
        -- upvalues: p2 (copy)
        p2._currentSpinCount = math.max(0, if p3 == nil then 0 else p3)
        p2:_updateSpinText()
    end)
end

function self.onTick(p4, p5) -- line: 54
    p4._timeSinceLastUpdate += p5

    if p4._timeSinceLastUpdate < 0.25 then
        return nil
    end

    p4._timeSinceLastUpdate = 0
    p4:_updateSpinText()
end

function self._computeSpinText(p6) -- line: 62
    local _currentSpinCount = p6._currentSpinCount

    return (("YOU HAVE <font color=\"#FFD23F\">%*</font> %*!"):format(_currentSpinCount, if _currentSpinCount == 1 then "SPIN" else "SPINS"))
end

function self._updateSpinText(p7) -- line: 67
    local v6 = p7:_getSpinText()

    if not v6 then
        return nil
    end

    local v7 = p7:_computeSpinText()

    if v7 == p7._lastText and v6.Text == v7 then
        return nil
    end

    p7._lastText = v7
    v6.RichText = true
    v6.Text = v7
end

function self._getSpinText(p8) -- line: 80
    -- upvalues: Workspace (copy)
    local _spinText = p8._spinText

    if _spinText ~= nil then
        _spinText = _spinText.Parent
    end

    if _spinText == nil then
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
            Map = Map:FindFirstChild("SpinLabel")

            if Map ~= nil then
                Map = Map:FindFirstChild("SpinText", true)
            end
        end

        p8._spinText = if not (if Map == nil then Map else Map:IsA("TextLabel")) then nil else Map
    end

    return p8._spinText
end

Reflect.defineMetadata(self, "identifier", "client/controllers/spin-wheel-count-controller@SpinWheelCountController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnTick" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    SpinWheelCountController = self
}
