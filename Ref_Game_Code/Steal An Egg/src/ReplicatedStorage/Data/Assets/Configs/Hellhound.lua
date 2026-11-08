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
    _id = "Hellhound",
    DisplayName = "Hellhound",
    Icon = "rbxassetid://101740580925899",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 1800000,
    IndexSpeedReward = 1400000,
    DropWeight = 0,
    VisualOdds = 3.57,
    ModelWeight = 72000,
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
    DontRoll = true,
    CannotFuse = nil,
    GenderLocked = nil,
    AlbinosColorFullWhite = nil,
    Egg = table.freeze({
        DisplayName = "Demonic Egg",
        Icon = "rbxassetid://109846660752456",
        GrowthTime = 64800,
        WeightKg = 20,
        HideRarity = nil,
        IgnoreSizeGrowthMultiplier = nil
    })
}
local freeze2 = table.freeze
local t2 = {
    TransitionFadeDuration = nil
}
local Animation = Instance.new("Animation")
local v1 = "rbxassetid://99261223641676"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://99261223641676 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://101282719055269"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://101282719055269 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Cosmic
t1.BaseModelColor = Color3.new(0.14901961386203766, 0.11764705926179886, 0.13333334028720856)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.14901961386203766, 0.11764705926179886, 0.13333334028720856),
        1000
    })
})

return (freeze(t1))
