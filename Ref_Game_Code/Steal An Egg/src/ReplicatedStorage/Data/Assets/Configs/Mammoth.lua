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
    _id = "Mammoth",
    DisplayName = "Mammoth",
    Icon = "rbxassetid://127045436214447",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 42000,
    IndexSpeedReward = 19200,
    DropWeight = 0,
    VisualOdds = 1.2E+07,
    ModelWeight = 2000,
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
        DisplayName = "Mammoth Egg",
        Icon = "rbxassetid://99020285854980",
        GrowthTime = 300,
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
local v1 = "rbxassetid://96559517682950"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://96559517682950 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://71037817684116"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://71037817684116 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Mythic
t1.BaseModelColor = Color3.new(0.20392157137393951, 0.13333334028720856, 0.09019608050584793)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.20392157137393951, 0.13333334028720856, 0.09019608050584793),
        620
    }),
    table.freeze({
        Color3.new(0.3529411852359772, 0.23529411852359772, 0.13725490868091583),
        210
    }),
    table.freeze({
        Color3.new(0.529411792755127, 0.37254902720451355, 0.21568627655506134),
        120
    }),
    table.freeze({
        Color3.new(0.7450980544090271, 0.6470588445663452, 0.4901960790157318),
        40
    }),
    table.freeze({
        Color3.new(0.10980392247438431, 0.09803921729326248, 0.08627451211214066),
        10
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        10
    })
})
t1.WalkSound = table.freeze({
    SoundId = 87980387017956,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 98423116392516,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
