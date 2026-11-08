-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    EventDisplayName = "Capture The Egg Event",
    EggDisplayName = "Event Egg",
    CarryCategory = "Baby Aurora Dragon",
    RewardCategory = "Baby Aurora Dragon",
    EggScale = 2,
    RewardScale = 1,
    CutsceneFallSeconds = 4,
    LandingSinkStuds = 0.35,
    LandingRotationDegrees = Vector3.new(-5, 28, 4),
    StarterRigName = "CaptureTheEggStarterRig",
    EggUidAttribute = "Event_CaptureTheEggUid",
    EggHighlightColor = Color3.fromRGB(255, 214, 89),
    BroadcastIconImage = "rbxassetid://116524274262912",
    SpawnMarkerName = "CaptureTheEggSpawn",
    FallbackMarkerName = "AdminAbuseEggSpawn",
    DanceAnimationId = "rbxassetid://507771019",
    R6DanceAnimationId = "rbxassetid://182435998",
    ScoreboardVisibleRows = 3
}

return (require(game:GetService("ReplicatedStorage").Shared.Flags.BalanceConfig).Bind("Game.Balance.CaptureTheEgg", t1, {
    EggScale = true,
    RewardScale = true
}, false, function(p1) -- line: 39
    assert(p1.EggScale > 0 and p1.RewardScale > 0)
end))
