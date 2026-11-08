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
    _id = "Crab",
    DisplayName = "Crustacia",
    Icon = "rbxassetid://76352927219607",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 130000,
    IndexSpeedReward = 2748096,
    DropWeight = 0,
    VisualOdds = 1.35E+11,
    ModelWeight = 1000,
    WalkAnimationReferenceSpeed = nil,
    BaseModelScale = 1,
    LimitedEggViewportScale = 1,
    LimitedEggViewportVerticalOffset = 0,
    PlaceSound = nil,
    WalkSound = nil,
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
        DisplayName = "Crustacia Egg",
        Icon = "rbxassetid://126728057663017",
        GrowthTime = 360,
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
local v1 = "rbxassetid://117215283003119"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://117215283003119 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://126728107034943"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://126728107034943 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Legendary
t1.BaseModelColor = Color3.new(1, 0.8980392217636108, 0.8980392217636108)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(1, 0.8980392217636108, 0.8980392217636108),
        850
    }),
    table.freeze({
        Color3.new(1, 0.7843137383460999, 0.8627451062202454),
        90
    }),
    table.freeze({
        Color3.new(0.8823529481887817, 0.8823529481887817, 0.9215686321258545),
        48
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        12
    })
})

return (freeze(t1))
