-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local atom = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").atom

return {
    waterMovementHintVisibleAtom = atom(false),
    waterMovementTouchControlsVisibleAtom = atom(false),
    waterMovementTouchVerticalDirectionAtom = atom(0)
}
