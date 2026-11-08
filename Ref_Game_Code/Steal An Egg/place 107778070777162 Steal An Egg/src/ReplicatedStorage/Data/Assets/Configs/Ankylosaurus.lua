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
    _id = "Ankylosaurus",
    DisplayName = "Ankylosaurus",
    Icon = "rbxassetid://71901208958017",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 120000,
    IndexSpeedReward = 330000,
    DropWeight = 0.5,
    VisualOdds = 7778.721339,
    ModelWeight = 2500,
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
        DisplayName = "Ankylosaurus Egg",
        Icon = "rbxassetid://103179713771844",
        GrowthTime = 300,
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
local v1 = "rbxassetid://71910623791893"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://71910623791893 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://115768568703296"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://115768568703296 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Mythic
t1.BaseModelColor = Color3.new(0.3843137323856354, 0.3450980484485626, 0.364705890417099)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.3843137323856354, 0.3450980484485626, 0.364705890417099),
        450
    }),
    table.freeze({
        Color3.new(0.37254902720451355, 0.3137255012989044, 0.23529411852359772),
        210
    }),
    table.freeze({
        Color3.new(0.3137255012989044, 0.37254902720451355, 0.2549019753932953),
        150
    }),
    table.freeze({
        Color3.new(0.5098039507865906, 0.45098039507865906, 0.3529411852359772),
        120
    }),
    table.freeze({
        Color3.new(0.21568627655506134, 0.21568627655506134, 0.21568627655506134),
        70
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        10
    })
})
t1.WalkSound = table.freeze({
    SoundId = 129507085485558,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 73050793707525,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
