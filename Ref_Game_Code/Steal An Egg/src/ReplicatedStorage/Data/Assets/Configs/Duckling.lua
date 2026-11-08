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
    _id = "Duckling",
    DisplayName = "Duckling",
    Icon = "rbxassetid://81116137079823",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 4,
    IndexSpeedReward = 2250,
    DropWeight = 0,
    VisualOdds = 190,
    ModelWeight = 3,
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
        DisplayName = "Duckling Egg",
        Icon = "rbxassetid://120651022174989",
        GrowthTime = 20,
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
local v1 = "rbxassetid://118496144381000"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://118496144381000 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://121924503798489"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://121924503798489 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Common
t1.BaseModelColor = Color3.new(0.5098039507865906, 0.4941176474094391, 0.32156863808631897)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.5098039507865906, 0.4941176474094391, 0.32156863808631897),
        360
    }),
    table.freeze({
        Color3.new(1, 0.7921568751335144, 0.47843137383461),
        480
    }),
    table.freeze({
        Color3.new(0.37254902720451355, 0.29411765933036804, 0.1764705926179886),
        80
    }),
    table.freeze({
        Color3.new(0.9607843160629272, 0.9215686321258545, 0.7058823704719543),
        60
    }),
    table.freeze({
        Color3.new(0.23529411852359772, 0.21568627655506134, 0.1764705926179886),
        20
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        20
    })
})
t1.WalkSound = table.freeze({
    SoundId = 108170229428604,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.9
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 99745906196706,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
