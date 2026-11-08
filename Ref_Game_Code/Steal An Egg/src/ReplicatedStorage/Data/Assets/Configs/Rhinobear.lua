-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rarity = require(ReplicatedStorage.Data.Rarity)

local function makeAnimation(p1) -- line: 6
    local Animation = Instance.new("Animation")

    local function v1() -- line: 8
        -- upvalues: p1 (copy), Animation (copy)
        Animation.AnimationId = p1
    end

    if not pcall(v1) then
        warn((("Animation %* is not shared with this experience"):format(p1)))
    end

    return Animation
end

local freeze = table.freeze
local t1 = {
    _id = "Rhinobear",
    DisplayName = "Rhinobear",
    Icon = "rbxassetid://129250605173124",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 1E+09,
    IndexSpeedReward = 0,
    DropWeight = 0,
    VisualOdds = 0,
    ModelWeight = 20000,
    WalkAnimationReferenceSpeed = nil,
    BaseModelScale = 1,
    LimitedEggViewportScale = 1,
    LimitedEggViewportVerticalOffset = 0,
    PlaceSound = nil,
    LuckyBlockDropTable = nil,
    LuckyBlockDropTableType = nil,
    LuckyBlockLevelRange = nil,
    LuckyBlockOpenDuration = nil,
    DontRoll = true,
    CannotFuse = nil,
    GenderLocked = nil,
    AlbinosColorFullWhite = nil,
    Egg = table.freeze({
        DisplayName = "Rhinobear Egg",
        Icon = "rbxassetid://121178065227483",
        ModelName = "Unstable",
        GrowthTime = 60,
        WeightKg = 1,
        HideRarity = nil,
        IgnoreSizeGrowthMultiplier = nil
    })
}
local freeze2 = table.freeze
local t2 = {
    TransitionFadeDuration = nil
}
local Animation = Instance.new("Animation")
local v2 = "rbxassetid://120649405734325"

local function v3() -- line: 8
    -- upvalues: Animation (copy), v2 (copy)
    Animation.AnimationId = v2
end

if not pcall(v3) then
    warn("Animation rbxassetid://120649405734325 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v4 = "rbxassetid://78295402076410"

local function v5() -- line: 8
    -- upvalues: Animation2 (copy), v4 (copy)
    Animation2.AnimationId = v4
end

if not pcall(v5) then
    warn("Animation rbxassetid://78295402076410 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Eternal
t1.BaseModelColor = Color3.fromRGB(234, 203, 144)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.fromRGB(234, 203, 144),
        1
    })
})
t1.WalkSound = table.freeze({
    SoundId = 90060394622485,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 104589623511260,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
