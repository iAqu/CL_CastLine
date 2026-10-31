-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local events = RuntimeLib.import(script, script.Parent.Parent, "network").events
local v1 = RuntimeLib.import(script, script.Parent.Parent, "flight-trigger-gate-events")
local flightTriggerGateRingMissed, flightTriggerGateRingPassed, flightTriggerGateScorePopup, flightTriggerGateRunEnded = v1.flightTriggerGateRingMissed, v1.flightTriggerGateRingPassed, v1.flightTriggerGateScorePopup, v1.flightTriggerGateRunEnded
local flightTriggerGateRunStarted = v1.flightTriggerGateRunStarted
local v2 = RuntimeLib.import(script, script.Parent.Parent, "flight-trigger-gate-score-atoms")
local flightTriggerGateCumulativeSurfScoreAtom, flightTriggerGatePityScoreAtom, flightTriggerGatePityImpactVersionAtom, flightTriggerGatePityResetVersionAtom = v2.flightTriggerGateCumulativeSurfScoreAtom, v2.flightTriggerGatePityScoreAtom, v2.flightTriggerGatePityImpactVersionAtom, v2.flightTriggerGatePityResetVersionAtom
local flightTriggerGatePityBaselineReadyAtom, flightTriggerGatePityThresholdAtom, flightTriggerGatePityTierAtom, flightTriggerGateSurfScoreAtom = v2.flightTriggerGatePityBaselineReadyAtom, v2.flightTriggerGatePityThresholdAtom, v2.flightTriggerGatePityTierAtom, v2.flightTriggerGateSurfScoreAtom
local v3 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "hoola-system-utils")
local getSurfScoreForRing, isHoolaMutationName = v3.getSurfScoreForRing, v3.isHoolaMutationName
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 28
        return "HoolaController"
    end
})

self.__index = self

function self.new(...) -- line: 33
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1) -- line: 37
    p1._active = false
    p1._currentCombo = 0
    p1._highestCombo = 0
    p1._ringsHit = 0
    p1._runScore = 0
    p1._offeredRings = 0
end

function self.onStart(p2) -- line: 45
    -- upvalues: events (copy), flightTriggerGateRingMissed (copy), flightTriggerGateRingPassed (copy), flightTriggerGateScorePopup (copy), flightTriggerGateRunEnded (copy), flightTriggerGateRunStarted (copy), flightTriggerGateCumulativeSurfScoreAtom (copy), flightTriggerGatePityScoreAtom (copy), flightTriggerGatePityImpactVersionAtom (copy), flightTriggerGatePityResetVersionAtom (copy), flightTriggerGatePityBaselineReadyAtom (copy), flightTriggerGatePityThresholdAtom (copy), flightTriggerGatePityTierAtom (copy), flightTriggerGateSurfScoreAtom (copy), getSurfScoreForRing (copy), isHoolaMutationName (copy)
    flightTriggerGateRunStarted:Connect(function(p3) -- line: 46
        -- upvalues: p2 (copy), flightTriggerGateSurfScoreAtom (copy)
        p2._offeredRings = p3
        p2._active = true
        p2._currentCombo = 0
        p2._highestCombo = 0
        p2._ringsHit = 0
        p2._runScore = 0
        flightTriggerGateSurfScoreAtom(0)
    end)
    flightTriggerGateRingPassed:Connect(function() -- line: 55
        -- upvalues: p2 (copy), flightTriggerGateScorePopup (copy), flightTriggerGatePityImpactVersionAtom (copy), flightTriggerGateSurfScoreAtom (copy), getSurfScoreForRing (copy)
        if not p2._active then
            return nil
        end

        p2._currentCombo += 1
        p2._highestCombo = math.max(p2._highestCombo, p2._currentCombo)
        p2._ringsHit += 1

        local v6 = getSurfScoreForRing(p2._currentCombo)

        p2._runScore += v6
        flightTriggerGateSurfScoreAtom(p2._runScore)
        flightTriggerGatePityImpactVersionAtom(function(p4) -- line: 65
            return p4 + 1
        end)
        flightTriggerGateScorePopup:Fire(v6)
    end)
    flightTriggerGateRingMissed:Connect(function() -- line: 70
        -- upvalues: p2 (copy)
        if p2._active then
            p2._currentCombo = 0
        end
    end)
    flightTriggerGateRunEnded:Connect(function() -- line: 75
        -- upvalues: p2 (copy), events (copy), flightTriggerGatePityBaselineReadyAtom (copy)
        if not p2._active then
            return nil
        end

        p2._active = false
        flightTriggerGatePityBaselineReadyAtom(false)
        events.hoolaRunCompleted:fire(p2._runScore, p2._highestCombo, p2._ringsHit, p2._offeredRings)
    end)
    events.hoolaPityStateUpdated:connect(function(p5, p6, p7) -- line: 83
        -- upvalues: flightTriggerGateCumulativeSurfScoreAtom (copy), flightTriggerGatePityScoreAtom (copy), flightTriggerGatePityResetVersionAtom (copy), flightTriggerGatePityBaselineReadyAtom (copy), flightTriggerGatePityThresholdAtom (copy), flightTriggerGatePityTierAtom (copy), flightTriggerGateSurfScoreAtom (copy), isHoolaMutationName (copy)
        flightTriggerGateSurfScoreAtom(0)
        flightTriggerGatePityScoreAtom(p5)
        flightTriggerGateCumulativeSurfScoreAtom(p5)

        if isHoolaMutationName(p6) then
            flightTriggerGatePityTierAtom(p6)
        end

        flightTriggerGatePityThresholdAtom(p7)
        flightTriggerGatePityResetVersionAtom(function(p8) -- line: 91
            return p8 + 1
        end)
        flightTriggerGatePityBaselineReadyAtom(true)
    end)
    events.hoolaRunResolved:connect(function(_, p10, _, p12, p13) -- line: 96
        -- upvalues: flightTriggerGateCumulativeSurfScoreAtom (copy), flightTriggerGatePityScoreAtom (copy), flightTriggerGatePityResetVersionAtom (copy), flightTriggerGatePityBaselineReadyAtom (copy), flightTriggerGatePityThresholdAtom (copy), flightTriggerGatePityTierAtom (copy), flightTriggerGateSurfScoreAtom (copy), isHoolaMutationName (copy)
        flightTriggerGateSurfScoreAtom(0)
        flightTriggerGatePityScoreAtom(p10)
        flightTriggerGateCumulativeSurfScoreAtom(p10)

        if p12 ~= nil and isHoolaMutationName(p12) then
            flightTriggerGatePityTierAtom(p12)
        end

        if p13 ~= nil then
            flightTriggerGatePityThresholdAtom(p13)
        end

        flightTriggerGatePityResetVersionAtom(function(p14) -- line: 106
            return p14 + 1
        end)
        flightTriggerGatePityBaselineReadyAtom(false)
    end)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/hoola-controller@HoolaController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    HoolaController = self
}
