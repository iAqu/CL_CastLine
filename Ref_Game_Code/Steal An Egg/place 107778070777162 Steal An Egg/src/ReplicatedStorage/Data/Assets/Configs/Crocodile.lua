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
    _id = "Crocodile",
    DisplayName = "Crocodile",
    Icon = "rbxassetid://122868974506056",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 420,
    IndexSpeedReward = 9000,
    DropWeight = 0.5,
    VisualOdds = 215470.581098,
    ModelWeight = 400,
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
        DisplayName = "Crocodile Egg",
        Icon = "rbxassetid://122378249879058",
        GrowthTime = 60,
        WeightKg = 3,
        HideRarity = nil,
        IgnoreSizeGrowthMultiplier = nil
    })
}
local freeze2 = table.freeze
local t2 = {
    TransitionFadeDuration = nil
}
local Animation = Instance.new("Animation")
local v1 = "rbxassetid://90280232778597"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://90280232778597 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://127622983417455"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://127622983417455 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Epic
t1.BaseModelColor = Color3.new(0.3607843220233917, 0.40784314274787903, 0.23529411852359772)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.3607843220233917, 0.40784314274787903, 0.23529411852359772),
        560
    }),
    table.freeze({
        Color3.new(0.21568627655506134, 0.29411765933036804, 0.1764705926179886),
        210
    }),
    table.freeze({
        Color3.new(0.3529411852359772, 0.3137255012989044, 0.21568627655506134),
        130
    }),
    table.freeze({
        Color3.new(0.13725490868091583, 0.1764705926179886, 0.125490203499794),
        25
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        2
    })
})
t1.WalkSound = table.freeze({
    SoundId = 82231882756292,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 77086186021615,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
