-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Signal = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "beacon", "out").Signal

return {
    flightTriggerGateRunStarted = Signal.new(),
    flightTriggerGateRingPassed = Signal.new(),
    flightTriggerGateScorePopup = Signal.new(),
    flightTriggerGateRingMissed = Signal.new(),
    flightTriggerGateRunEnded = Signal.new()
}
