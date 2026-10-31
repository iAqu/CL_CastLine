-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local atom = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").atom

return {
    rareFishTransitionDurationSec = 1.6,
    hookLandedPositionAtom = atom(nil),
    hookCastDistanceAtom = atom(0),
    fishingMovementLockedAtom = atom(false),
    currentFishingZoneAtom = atom(nil),
    hookHrpAtom = atom(nil),
    hookZoneProgressAtom = atom(0),
    apexDropAtom = atom(nil),
    apexRevealAtom = atom(nil),
    apexAfterRareFishCutsceneAtom = atom(false),
    rareFishTransitionAtom = atom(nil),
    catchFadeAtom = atom(nil),
    apexSkillCheckAtom = atom(nil),
    bossWeakSpotsAtom = atom({}),
    bossActivePromptAtom = atom(nil),
    bossScreenBorderAtom = atom(nil),
    powerValueHiddenAtom = atom(false),
    castIsPerfectAtom = atom(false),
    statDisplayHiddenAtom = atom(false)
}
