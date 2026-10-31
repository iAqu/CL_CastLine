-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local atom = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").atom

return {
    flightTriggerGateSurfScoreAtom = atom(0),
    flightTriggerGateCumulativeSurfScoreAtom = atom(0),
    flightTriggerGatePityScoreAtom = atom(0),
    flightTriggerGatePityThresholdAtom = atom(300),
    flightTriggerGatePityTierAtom = atom("hoola1"),
    flightTriggerGatePityImpactVersionAtom = atom(0),
    flightTriggerGatePityResetVersionAtom = atom(0),
    flightTriggerGatePityBaselineReadyAtom = atom(false)
}
