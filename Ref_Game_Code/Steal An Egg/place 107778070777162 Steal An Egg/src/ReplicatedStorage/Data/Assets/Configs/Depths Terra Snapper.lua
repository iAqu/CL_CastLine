-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rarity = require(ReplicatedStorage.Data.Rarity)

local function makeAnimation(p1) -- line: 9
    local Animation = Instance.new("Animation")

    local function setAnimationId() -- line: 11
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
    _id = "Depths Terra Snapper",
    DisplayName = "Luminous Terra Snapper",
    Icon = "rbxassetid://136624351055651",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 2.5E+09,
    IndexSpeedReward = 0,
    DropWeight = 0,
    VisualOdds = 1523.076923,
    ModelWeight = 60000,
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
    AlbinosColorFullWhite = true,
    Egg = table.freeze({
        DisplayName = "Luminous Terra Snapper Egg",
        Icon = "rbxassetid://103020287697704",
        ModelName = "Depths Reroll Egg",
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
local v1 = "rbxassetid://111704086981326"

local function setAnimationId() -- line: 11
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://111704086981326 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://119158427903872"

local function setAnimationId2() -- line: 11
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://119158427903872 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Eternal
t1.BaseModelColor = Color3.fromRGB(63, 76, 172)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.fromRGB(63, 76, 172),
        80
    }),
    table.freeze({
        Color3.fromRGB(85, 80, 143),
        19
    }),
    table.freeze({
        Color3.fromRGB(255, 255, 255),
        1
    })
})

return (freeze(t1))
