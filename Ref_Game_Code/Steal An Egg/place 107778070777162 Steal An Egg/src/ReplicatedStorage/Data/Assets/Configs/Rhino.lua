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
    _id = "Rhino",
    DisplayName = "Rhinotaur",
    Icon = "rbxassetid://137684641039927",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 17500000,
    IndexSpeedReward = 3091608,
    DropWeight = 0,
    VisualOdds = 2.5E+12,
    ModelWeight = 35000,
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
        DisplayName = "Rhinotaur Egg",
        Icon = "rbxassetid://117685498595422",
        GrowthTime = 1740,
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
local v1 = "rbxassetid://100647587597239"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://100647587597239 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://98517843584316"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://98517843584316 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Cosmic
t1.BaseModelColor = Color3.new(0.23137255012989044, 0.21960784494876862, 0.23137255012989044)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.23137255012989044, 0.21960784494876862, 0.23137255012989044),
        850
    }),
    table.freeze({
        Color3.new(0.27450981736183167, 0.21568627655506134, 0.1764705926179886),
        90
    }),
    table.freeze({
        Color3.new(0.19607843458652496, 0.2549019753932953, 0.21568627655506134),
        48
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        12
    })
})

return (freeze(t1))
