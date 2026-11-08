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
    _id = "Catfish",
    DisplayName = "Catfish",
    Icon = "rbxassetid://137813424891388",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 12,
    IndexSpeedReward = 2500,
    DropWeight = 0.5,
    VisualOdds = 262.769001,
    ModelWeight = 35,
    WalkAnimationReferenceSpeed = nil,
    BaseModelScale = 1,
    LimitedEggViewportScale = 1,
    LimitedEggViewportVerticalOffset = 0,
    PlaceSound = nil,
    WalkSound = nil,
    LuckyBlockDropTable = nil,
    LuckyBlockDropTableType = nil,
    LuckyBlockLevelRange = nil,
    LuckyBlockOpenDuration = nil,
    DontRoll = nil,
    CannotFuse = nil,
    GenderLocked = nil,
    AlbinosColorFullWhite = nil,
    Egg = table.freeze({
        DisplayName = "Catfish Egg",
        Icon = "rbxassetid://120156933101223",
        GrowthTime = 30,
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
local v1 = "rbxassetid://77531242643307"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://77531242643307 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://97654952506163"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://97654952506163 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Uncommon
t1.BaseModelColor = Color3.new(0.01568627543747425, 0.686274528503418, 0.9254902005195618)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.01568627543747425, 0.686274528503418, 0.9254902005195618),
        470
    }),
    table.freeze({
        Color3.new(0.25882354378700256, 0.2705882489681244, 0.250980406999588),
        230
    }),
    table.freeze({
        Color3.new(0.2549019753932953, 0.23529411852359772, 0.19607843458652496),
        150
    }),
    table.freeze({
        Color3.new(0.45490196347236633, 1, 0.5921568870544434),
        100
    }),
    table.freeze({
        Color3.new(0.13725490868091583, 0.13725490868091583, 0.13725490868091583),
        50
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        15
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 131342808703780,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
