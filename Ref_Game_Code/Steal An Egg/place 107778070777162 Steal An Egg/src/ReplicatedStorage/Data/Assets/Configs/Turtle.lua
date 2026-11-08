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
    _id = "Turtle",
    DisplayName = "Turtle",
    Icon = "rbxassetid://90736612624734",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 60,
    IndexSpeedReward = 2750,
    DropWeight = 0.3333333333333333,
    VisualOdds = 349.30572063219404,
    ModelWeight = 100,
    WalkAnimationReferenceSpeed = nil,
    BaseModelScale = 1,
    LimitedEggViewportScale = 1,
    LimitedEggViewportVerticalOffset = 0,
    PlaceSound = nil,
    RandomIdleSound = nil,
    LuckyBlockDropTable = nil,
    LuckyBlockDropTableType = nil,
    LuckyBlockLevelRange = nil,
    LuckyBlockOpenDuration = nil,
    DontRoll = nil,
    CannotFuse = nil,
    GenderLocked = nil,
    AlbinosColorFullWhite = nil,
    Egg = table.freeze({
        DisplayName = "Turtle Egg",
        Icon = "rbxassetid://132237234794333",
        GrowthTime = 50,
        WeightKg = 2,
        HideRarity = nil,
        IgnoreSizeGrowthMultiplier = nil
    })
}
local freeze2 = table.freeze
local t2 = {
    TransitionFadeDuration = nil
}
local Animation = Instance.new("Animation")
local v1 = "rbxassetid://79398133579699"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://79398133579699 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://116555747328509"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://116555747328509 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Rare
t1.BaseModelColor = Color3.new(0.364705890417099, 0.5254902243614197, 0.239215686917305)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.364705890417099, 0.5254902243614197, 0.239215686917305),
        560
    }),
    table.freeze({
        Color3.new(0.3529411852359772, 0.3137255012989044, 0.1764705926179886),
        220
    }),
    table.freeze({
        Color3.new(0.23529411852359772, 0.37254902720451355, 0.21568627655506134),
        120
    }),
    table.freeze({
        Color3.new(0.5490196347236633, 0.45098039507865906, 0.2549019753932953),
        75
    }),
    table.freeze({
        Color3.new(0.1764705926179886, 0.19607843458652496, 0.13725490868091583),
        25
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        15
    })
})
t1.WalkSound = table.freeze({
    SoundId = 129596767024447,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})

return (freeze(t1))
