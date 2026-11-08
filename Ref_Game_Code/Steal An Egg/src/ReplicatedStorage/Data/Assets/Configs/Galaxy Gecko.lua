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
    _id = "Galaxy Gecko",
    DisplayName = "Cosmic Gecko",
    Icon = "rbxassetid://115834854015858",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 30000,
    IndexSpeedReward = 1080000,
    DropWeight = 0,
    VisualOdds = 2.5E+12,
    ModelWeight = 18,
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
        DisplayName = "Cosmic Gecko Egg",
        Icon = "rbxassetid://107132653319667",
        GrowthTime = 240,
        WeightKg = 8,
        HideRarity = nil,
        IgnoreSizeGrowthMultiplier = nil
    })
}
local freeze2 = table.freeze
local t2 = {
    TransitionFadeDuration = nil
}
local Animation = Instance.new("Animation")
local v1 = "rbxassetid://138853141977630"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://138853141977630 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://99128282956160"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://99128282956160 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Legendary
t1.BaseModelColor = Color3.new(0.24313725531101227, 0.3294117748737335, 0.40392157435417175)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.24313725531101227, 0.3294117748737335, 0.40392157435417175),
        900
    }),
    table.freeze({
        Color3.new(0.0784313753247261, 0.11764705926179886, 0.21568627655506134),
        100
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        15
    })
})
t1.WalkSound = table.freeze({
    SoundId = 85688845524024,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 130520753193462,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
