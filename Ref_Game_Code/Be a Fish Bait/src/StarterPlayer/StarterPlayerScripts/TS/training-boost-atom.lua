-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local atom = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").atom

return {
    trainingBoostFillAtom = atom(0),
    trainingIsFrenzyAtom = atom(false),
    trainingSkillcheckHitCounterAtom = atom(0),
    frenzyEndTimeAtom = atom(0),
    latestTrainingPowerFlyIdAtom = atom(nil)
}
