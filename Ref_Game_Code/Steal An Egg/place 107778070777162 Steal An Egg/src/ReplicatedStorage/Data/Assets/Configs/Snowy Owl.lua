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
    _id = "Snowy Owl",
    DisplayName = "Snowy Owl",
    Icon = "rbxassetid://123321230182882",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 7500000,
    IndexSpeedReward = 3778632,
    DropWeight = 0,
    VisualOdds = 1.724E+12,
    ModelWeight = 20,
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
        DisplayName = "Snowy Owl Egg",
        Icon = "rbxassetid://110224614368360",
        GrowthTime = 900,
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
local v1 = "rbxassetid://89629292005887"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://89629292005887 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://131028384806119"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://131028384806119 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Cosmic
t1.BaseModelColor = Color3.new(0.8156862854957581, 0.7921568751335144, 0.7215686440467834)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.8156862854957581, 0.7921568751335144, 0.7215686440467834),
        850
    }),
    table.freeze({
        Color3.new(0.6666666865348816, 0.529411792755127, 0.37254902720451355),
        90
    }),
    table.freeze({
        Color3.new(0.47058823704719543, 0.47058823704719543, 0.4901960790157318),
        48
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        12
    })
})
t1.WalkSound = table.freeze({
    SoundId = 96920277869957,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})

return (freeze(t1))
