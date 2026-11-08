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
    _id = "Eternal Lunar Dragon",
    DisplayName = "Eternal Lunar Dragon",
    Icon = "rbxassetid://93762296316916",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 2.5E+08,
    IndexSpeedReward = 1920000,
    DropWeight = 20,
    VisualOdds = 28729410813070.773,
    ModelWeight = 60000,
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
        DisplayName = "Eternal Lunar Dragon Egg",
        Icon = "rbxassetid://76095389378180",
        GrowthTime = 25200,
        WeightKg = 9,
        HideRarity = nil,
        IgnoreSizeGrowthMultiplier = nil
    })
}
local freeze2 = table.freeze
local t2 = {
    TransitionFadeDuration = nil
}
local Animation = Instance.new("Animation")
local v1 = "rbxassetid://118874129580676"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://118874129580676 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://139537878984191"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://139537878984191 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Eternal
t1.BaseModelColor = Color3.new(0.10588235408067703, 0.16470588743686676, 0.2078431397676468)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.10588235408067703, 0.16470588743686676, 0.2078431397676468),
        700
    }),
    table.freeze({
        Color3.new(0.1921568661928177, 0.2078431397676468, 0.27843138575553894),
        200
    }),
    table.freeze({
        Color3.new(0.20000000298023224, 0.23137255012989044, 0.23529411852359772),
        100
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        12
    })
})
t1.WalkSound = table.freeze({
    SoundId = 95249764844448,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 126402073411522,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
