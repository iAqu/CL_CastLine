-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rarity = require(ReplicatedStorage.Data.Rarity)

local function makeAnimation(p1) -- line: 7
    local Animation = Instance.new("Animation")

    local function setAnimationId() -- line: 9
        -- upvalues: p1 (copy), Animation (copy)
        Animation.AnimationId = p1
    end

    if not pcall(setAnimationId) then
        warn((("Animation %* is not shared with this experience"):format(p1)))
    end

    return Animation
end

local freeze = table.freeze
local t1 = {
    _id = "Mire Fox",
    DisplayName = "Fox",
    Icon = "rbxassetid://96639152572865",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 180,
    IndexSpeedReward = 720,
    DropWeight = 0.14285714285714285,
    VisualOdds = 10.773529,
    ModelWeight = 28,
    WalkAnimationReferenceSpeed = nil,
    BaseModelScale = 1,
    LimitedEggViewportScale = 1,
    LimitedEggViewportVerticalOffset = 0,
    PlaceSound = nil,
    LuckyBlockDropTable = nil,
    LuckyBlockDropTableType = nil,
    LuckyBlockLevelRange = nil,
    LuckyBlockOpenDuration = nil,
    DontRoll = nil,
    CannotFuse = nil,
    GenderLocked = nil,
    AlbinosColorFullWhite = nil,
    Egg = table.freeze({
        DisplayName = "Fox Egg",
        Icon = "rbxassetid://122218902574805",
        GrowthTime = 90,
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
local v1 = "rbxassetid://115440197758670"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://115440197758670 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://107607987905386"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://107607987905386 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Epic
t1.BaseModelColor = Color3.new(1, 0.2823529541492462, 0)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(1, 0.2823529541492462, 0),
        760
    }),
    table.freeze({
        Color3.new(0.48627451062202454, 0.3137255012989044, 0.18431372940540314),
        120
    }),
    table.freeze({
        Color3.new(0.9215686321258545, 0.8235294222831726, 0.6470588445663452),
        70
    }),
    table.freeze({
        Color3.new(0.1764705926179886, 0.16470588743686676, 0.14901961386203766),
        35
    }),
    table.freeze({
        Color3.new(0.9607843160629272, 0.9607843160629272, 0.9215686321258545),
        15
    })
})
t1.WalkSound = table.freeze({
    SoundId = 124821449139609,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 140069693056979,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
