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
    _id = "TyrannosaurusRex",
    DisplayName = "TRex",
    Icon = "rbxassetid://123124934383954",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 2.5E+07,
    IndexSpeedReward = 420000,
    DropWeight = 0.3333333333333333,
    VisualOdds = 134669113.186,
    ModelWeight = 7500,
    WalkAnimationReferenceSpeed = 16,
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
        DisplayName = "TRex Egg",
        Icon = "rbxassetid://124390268104324",
        GrowthTime = 9000,
        WeightKg = 5,
        HideRarity = nil,
        IgnoreSizeGrowthMultiplier = nil
    })
}
local freeze2 = table.freeze
local t2 = {
    TransitionFadeDuration = nil
}
local Animation = Instance.new("Animation")
local v1 = "rbxassetid://85804925095766"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://85804925095766 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://117274313338090"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://117274313338090 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Secret
t1.BaseModelColor = Color3.fromRGB(214, 107, 22)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.fromRGB(214, 107, 22),
        470
    }),
    table.freeze({
        Color3.new(0.37254902720451355, 0.29411765933036804, 0.1764705926179886),
        210
    }),
    table.freeze({
        Color3.new(0.27450981736183167, 0.37254902720451355, 0.21568627655506134),
        140
    }),
    table.freeze({
        Color3.new(0.5686274766921997, 0.47058823704719543, 0.27450981736183167),
        100
    }),
    table.freeze({
        Color3.new(0.4431372582912445, 0.40392157435417175, 0.33725491166114807),
        60
    }),
    table.freeze({
        Color3.new(0.16862745583057404, 0.25882354378700256, 0.35686275362968445),
        60
    }),
    table.freeze({
        Color3.new(0.6274510025978088, 0.27450981736183167, 0.1764705926179886),
        20
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        10
    })
})
t1.WalkSound = table.freeze({
    SoundId = 114165406336338,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 81004933444699,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
