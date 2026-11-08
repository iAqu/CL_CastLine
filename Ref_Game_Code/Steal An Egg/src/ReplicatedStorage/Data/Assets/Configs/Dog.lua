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
    _id = "Dog",
    DisplayName = "Dog",
    Icon = "rbxassetid://128470938015055",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 2,
    IndexSpeedReward = 460,
    DropWeight = 0,
    VisualOdds = 2,
    ModelWeight = 25,
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
        DisplayName = "Dog Egg",
        Icon = "rbxassetid://123926130544109",
        GrowthTime = 15,
        WeightKg = 1,
        HideRarity = nil,
        IgnoreSizeGrowthMultiplier = nil
    })
}
local freeze2 = table.freeze
local t2 = {
    TransitionFadeDuration = nil
}
local Animation = Instance.new("Animation")
local v1 = "rbxassetid://117866633124975"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://117866633124975 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://85471228397160"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://85471228397160 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Common
t1.BaseModelColor = Color3.new(0.6470588445663452, 0.3333333432674408, 0.3333333432674408)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.6470588445663452, 0.3333333432674408, 0.3333333432674408),
        170
    }),
    table.freeze({
        Color3.new(0.8549019694328308, 0.6196078658103943, 0.2823529541492462),
        160
    }),
    table.freeze({
        Color3.new(0.8039215803146362, 0.6666666865348816, 0.4117647111415863),
        145
    }),
    table.freeze({
        Color3.new(0.9333333373069763, 0.8627451062202454, 0.686274528503418),
        115
    }),
    table.freeze({
        Color3.new(0.9607843160629272, 0.9411764740943909, 0.8823529481887817),
        85
    }),
    table.freeze({
        Color3.new(0.4117647111415863, 0.2549019753932953, 0.1568627506494522),
        115
    }),
    table.freeze({
        Color3.new(0.21568627655506134, 0.1764705926179886, 0.14901961386203766),
        90
    }),
    table.freeze({
        Color3.new(0.5882353186607361, 0.529411792755127, 0.45098039507865906),
        55
    }),
    table.freeze({
        Color3.new(0.37254902720451355, 0.3921568691730499, 0.4117647111415863),
        40
    }),
    table.freeze({
        Color3.new(0.7254902124404907, 0.7254902124404907, 0.6980392336845398),
        25
    })
})
t1.WalkSound = table.freeze({
    SoundId = 134795569551185,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})

return (freeze(t1))
