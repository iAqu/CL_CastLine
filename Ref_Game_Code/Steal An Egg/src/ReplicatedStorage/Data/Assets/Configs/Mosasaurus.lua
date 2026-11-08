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
    _id = "Mosasaurus",
    DisplayName = "Mosasaurus",
    Icon = "rbxassetid://124293259998827",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 1.8E+08,
    IndexSpeedReward = 6E+05,
    DropWeight = 0.55,
    VisualOdds = 2773109151.841,
    ModelWeight = 30000,
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
    AlbinosColorFullWhite = true,
    Egg = table.freeze({
        DisplayName = "Mosasaurus Egg",
        Icon = "rbxassetid://110731551346220",
        GrowthTime = 21600,
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
local v1 = "rbxassetid://130987511514994"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://130987511514994 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://92570452388491"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://92570452388491 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Eternal
t1.BaseModelColor = Color3.new(0.32156863808631897, 0.3686274588108063, 0.4941176474094391)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.32156863808631897, 0.3686274588108063, 0.4941176474094391),
        540
    }),
    table.freeze({
        Color3.new(0.1764705926179886, 0.29411765933036804, 0.37254902720451355),
        190
    }),
    table.freeze({
        Color3.new(0.23529411852359772, 0.3333333432674408, 0.29411765933036804),
        120
    }),
    table.freeze({
        Color3.new(0.1568627506494522, 0.1764705926179886, 0.19607843458652496),
        100
    }),
    table.freeze({
        Color3.new(0.4588235318660736, 0.4000000059604645, 0.21176470816135406),
        120
    }),
    table.freeze({
        Color3.new(0.529411792755127, 0.5490196347236633, 0.529411792755127),
        50
    }),
    table.freeze({
        Color3.new(1, 0, 0),
        10
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        10
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 110377151729054,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
