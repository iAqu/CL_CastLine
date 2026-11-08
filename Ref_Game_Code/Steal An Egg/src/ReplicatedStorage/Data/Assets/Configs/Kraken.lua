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
    _id = "Kraken",
    DisplayName = "Kraken",
    Icon = "rbxassetid://136429320011912",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 1.5E+07,
    IndexSpeedReward = 144000,
    DropWeight = 0.14285714285714285,
    VisualOdds = 40284267734.10782,
    ModelWeight = 18000,
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
        DisplayName = "Kraken Egg",
        Icon = "rbxassetid://114986552390612",
        GrowthTime = 8100,
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
local v1 = "rbxassetid://77550298467205"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://77550298467205 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://125902579005259"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://125902579005259 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Secret
t1.BaseModelColor = Color3.new(0.7686274647712708, 0.1568627506494522, 0.10980392247438431)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.7686274647712708, 0.1568627506494522, 0.10980392247438431),
        460
    }),
    table.freeze({
        Color3.new(0.47058823704719543, 0.21568627655506134, 0.3333333432674408),
        190
    }),
    table.freeze({
        Color3.new(0.37254902720451355, 0.23529411852359772, 0.1764705926179886),
        140
    }),
    table.freeze({
        Color3.new(0.7254902124404907, 0.4313725531101227, 0.27450981736183167),
        110
    }),
    table.freeze({
        Color3.new(0.21568627655506134, 0.1764705926179886, 0.23529411852359772),
        70
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        10
    })
})
t1.WalkSound = table.freeze({
    SoundId = 91640952661817,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 99264926798032,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
