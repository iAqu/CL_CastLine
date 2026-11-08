-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rarity = require(ReplicatedStorage.Data.Rarity)
local v1 = Color3.fromRGB(255, 255, 255)

local function makeAnimation(p1) -- line: 12
    local Animation = Instance.new("Animation")

    local function setAnimationId() -- line: 14
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
    _id = "Skeletal Glyptodon",
    DisplayName = "Skeletal Glyptodon",
    Icon = "rbxassetid://137150555377286",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 5.5E+08,
    IndexSpeedReward = 0,
    DropWeight = 0,
    VisualOdds = 253.84615384615384,
    ModelWeight = 3000,
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
    AlbinosColorFullWhite = true,
    Egg = table.freeze({
        DisplayName = "Skeletal Glyptodon Egg",
        Icon = "rbxassetid://104417876555018",
        ModelName = "Skeletal Egg",
        GrowthTime = 10,
        WeightKg = 6,
        HideRarity = true,
        IgnoreSizeGrowthMultiplier = true
    })
}
local freeze2 = table.freeze
local t2 = {
    TransitionFadeDuration = nil
}
local Animation = Instance.new("Animation")
local v2 = "rbxassetid://128679262525657"

local function setAnimationId() -- line: 14
    -- upvalues: Animation (copy), v2 (copy)
    Animation.AnimationId = v2
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://128679262525657 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v3 = "rbxassetid://75699353375259"

local function setAnimationId2() -- line: 14
    -- upvalues: Animation2 (copy), v3 (copy)
    Animation2.AnimationId = v3
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://75699353375259 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Secret
t1.BaseModelColor = v1
t1.PossibleModelColors = table.freeze({ table.freeze({ v1, 1 }) })
t1.WalkSound = table.freeze({
    SoundId = 121073248603129,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 131656477054750,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
