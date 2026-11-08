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
    _id = "El Maja",
    DisplayName = "El Maja",
    Icon = "rbxassetid://77518688092604",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 1.3E+08,
    IndexSpeedReward = 180000,
    DropWeight = 0.125,
    VisualOdds = 66391535236.3381,
    ModelWeight = 90000,
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
    GenderLocked = "Male",
    AlbinosColorFullWhite = nil,
    Egg = table.freeze({
        DisplayName = "El Maja Egg",
        Icon = "rbxassetid://123897639279253",
        GrowthTime = 19800,
        WeightKg = 6,
        HideRarity = nil,
        IgnoreSizeGrowthMultiplier = nil
    })
}
local freeze2 = table.freeze
local t2 = {
    TransitionFadeDuration = nil
}
local Animation = Instance.new("Animation")
local v1 = "rbxassetid://132181117287223"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://132181117287223 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://75800532076044"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://75800532076044 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Eternal
t1.BaseModelColor = Color3.new(0, 0.6000000238418579, 1)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0, 0.6000000238418579, 1),
        900
    }),
    table.freeze({
        Color3.new(0, 0.1764705926179886, 0.37254902720451355),
        100
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        12
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 115062059439564,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
