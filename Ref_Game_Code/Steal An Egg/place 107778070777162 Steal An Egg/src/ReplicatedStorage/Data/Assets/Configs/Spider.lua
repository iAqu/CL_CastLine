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
    _id = "Spider",
    DisplayName = "Spider",
    Icon = "rbxassetid://132010793204072",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 22000,
    IndexSpeedReward = 12600,
    DropWeight = 0.16666666666666666,
    VisualOdds = 861882.324392,
    ModelWeight = 120,
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
        DisplayName = "Spider Egg",
        Icon = "rbxassetid://85241307147394",
        GrowthTime = 270,
        WeightKg = 4,
        HideRarity = nil,
        IgnoreSizeGrowthMultiplier = nil
    })
}
local freeze2 = table.freeze
local t2 = {
    TransitionFadeDuration = nil
}
local Animation = Instance.new("Animation")
local v1 = "rbxassetid://117459506499807"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://117459506499807 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://71117255441251"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://71117255441251 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Mythic
t1.BaseModelColor = Color3.new(0.21568627655506134, 0.21960784494876862, 0.24313725531101227)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.21568627655506134, 0.21960784494876862, 0.24313725531101227),
        520
    }),
    table.freeze({
        Color3.new(0.1764705926179886, 0.13725490868091583, 0.11764705926179886),
        180
    }),
    table.freeze({
        Color3.new(0.3333333432674408, 0.27450981736183167, 0.1764705926179886),
        130
    }),
    table.freeze({
        Color3.new(0.13725490868091583, 0.1764705926179886, 0.13725490868091583),
        100
    }),
    table.freeze({
        Color3.new(0.5098039507865906, 0.37254902720451355, 0.1764705926179886),
        50
    }),
    table.freeze({
        Color3.new(0.09803921729326248, 0.09803921729326248, 0.09803921729326248),
        20
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        12
    })
})
t1.WalkSound = table.freeze({
    SoundId = 131115341364194,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 134280584978628,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
