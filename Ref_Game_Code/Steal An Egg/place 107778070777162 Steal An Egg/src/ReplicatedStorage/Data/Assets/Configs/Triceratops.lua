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
    _id = "Triceratops",
    DisplayName = "Triceratops",
    Icon = "rbxassetid://127014885618024",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 1200000,
    IndexSpeedReward = 360000,
    DropWeight = 0.3333333333333333,
    VisualOdds = 13901.327813000002,
    ModelWeight = 3500,
    WalkAnimationReferenceSpeed = nil,
    BaseModelScale = 1,
    LimitedEggViewportScale = 1,
    LimitedEggViewportVerticalOffset = 0,
    PlaceSound = nil,
    LuckyBlockDropTable = nil,
    LuckyBlockDropTableType = nil,
    LuckyBlockLevelRange = nil,
    LuckyBlockOpenDuration = nil,
    DontRoll = nil,
    CannotFuse = nil,
    GenderLocked = nil,
    AlbinosColorFullWhite = nil,
    Egg = table.freeze({
        DisplayName = "Triceratops Egg",
        Icon = "rbxassetid://73329615832715",
        GrowthTime = 480,
        WeightKg = 3,
        HideRarity = nil,
        IgnoreSizeGrowthMultiplier = nil
    })
}
local freeze2 = table.freeze
local t2 = {
    TransitionFadeDuration = nil
}
local Animation = Instance.new("Animation")
local v1 = "rbxassetid://87496654880154"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://87496654880154 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://122861021000342"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://122861021000342 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Cosmic
t1.BaseModelColor = Color3.new(0.35686275362968445, 0.30588236451148987, 0.2823529541492462)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.35686275362968445, 0.30588236451148987, 0.2823529541492462),
        520
    }),
    table.freeze({
        Color3.new(0.4313725531101227, 0.37254902720451355, 0.2549019753932953),
        180
    }),
    table.freeze({
        Color3.new(0.3333333432674408, 0.4117647111415863, 0.2549019753932953),
        130
    }),
    table.freeze({
        Color3.new(0.5098039507865906, 0.47058823704719543, 0.37254902720451355),
        110
    }),
    table.freeze({
        Color3.new(0.23529411852359772, 0.21568627655506134, 0.19607843458652496),
        60
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        10
    })
})
t1.WalkSound = table.freeze({
    SoundId = 117490508431150,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 103866172195808,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
