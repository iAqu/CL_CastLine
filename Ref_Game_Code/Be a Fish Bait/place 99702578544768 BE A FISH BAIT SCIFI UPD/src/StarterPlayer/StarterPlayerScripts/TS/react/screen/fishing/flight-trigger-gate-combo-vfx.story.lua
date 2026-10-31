-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "flight-trigger-gate-score-atoms")
local flightTriggerGatePityBaselineReadyAtom, flightTriggerGatePityScoreAtom, flightTriggerGatePityThresholdAtom, flightTriggerGateSurfScoreAtom = v1.flightTriggerGatePityBaselineReadyAtom, v1.flightTriggerGatePityScoreAtom, v1.flightTriggerGatePityThresholdAtom, v1.flightTriggerGateSurfScoreAtom
local flightTriggerGateComboAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "flight-trigger-gate-combo-atom").flightTriggerGateComboAtom
local hookFlightSteeringActiveAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "hook-flight-steering-atom").hookFlightSteeringActiveAtom
local default2 = RuntimeLib.import(script, script.Parent, "flight-trigger-gate-combo-vfx").default

local function StoryScene() -- line: 16
    -- upvalues: react (copy), useEffect (copy), flightTriggerGatePityBaselineReadyAtom (copy), flightTriggerGatePityScoreAtom (copy), flightTriggerGatePityThresholdAtom (copy), flightTriggerGateSurfScoreAtom (copy), flightTriggerGateComboAtom (copy), hookFlightSteeringActiveAtom (copy), default2 (copy)
    useEffect(function() -- line: 17
        -- upvalues: flightTriggerGatePityBaselineReadyAtom (copy), flightTriggerGatePityScoreAtom (copy), flightTriggerGatePityThresholdAtom (copy), flightTriggerGateSurfScoreAtom (copy), flightTriggerGateComboAtom (copy), hookFlightSteeringActiveAtom (copy)
        hookFlightSteeringActiveAtom(true)
        flightTriggerGatePityScoreAtom(100)
        flightTriggerGatePityThresholdAtom(100)
        flightTriggerGateSurfScoreAtom(0)
        flightTriggerGateComboAtom(3)
        flightTriggerGatePityBaselineReadyAtom(true)

        return function() -- line: 24
            -- upvalues: flightTriggerGatePityBaselineReadyAtom (copy), flightTriggerGatePityScoreAtom (copy), flightTriggerGateSurfScoreAtom (copy), flightTriggerGateComboAtom (copy), hookFlightSteeringActiveAtom (copy)
            hookFlightSteeringActiveAtom(false)
            flightTriggerGatePityBaselineReadyAtom(false)
            flightTriggerGatePityScoreAtom(0)
            flightTriggerGateSurfScoreAtom(0)
            flightTriggerGateComboAtom(0)
        end
    end, {})

    return react.createElement(default2)
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(StoryScene)))
