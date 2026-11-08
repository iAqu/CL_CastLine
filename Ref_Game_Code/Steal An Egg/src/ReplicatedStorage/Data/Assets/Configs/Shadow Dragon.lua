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
    _id = "Shadow Dragon",
    DisplayName = "Shadow Dragon",
    Icon = "rbxassetid://95217633876957",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 2.5E+07,
    IndexSpeedReward = 20000,
    DropWeight = 0,
    VisualOdds = 500,
    ModelWeight = 10000,
    WalkAnimationReferenceSpeed = nil,
    BaseModelScale = 1,
    LimitedEggViewportScale = 1,
    LimitedEggViewportVerticalOffset = 0,
    PlaceSound = nil,
    LuckyBlockDropTable = nil,
    LuckyBlockDropTableType = nil,
    LuckyBlockLevelRange = nil,
    LuckyBlockOpenDuration = nil,
    DontRoll = true,
    CannotFuse = nil,
    GenderLocked = nil,
    AlbinosColorFullWhite = nil,
    Egg = table.freeze({
        DisplayName = "Dragon Egg",
        Icon = "rbxassetid://124581147164560",
        GrowthTime = 60,
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
local v1 = "rbxassetid://131290563384917"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://131290563384917 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://125181480859908"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://125181480859908 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Mythic
t1.BaseModelColor = Color3.new(0.33725491166114807, 0.32549020648002625, 0.3333333432674408)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.33725491166114807, 0.32549020648002625, 0.3333333432674408),
        650
    }),
    table.freeze({
        Color3.new(0.21568627655506134, 0.20392157137393951, 0.23529411852359772),
        230
    }),
    table.freeze({
        Color3.new(0.07058823853731155, 0.07058823853731155, 0.08627451211214066),
        108
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        12
    })
})
t1.WalkSound = table.freeze({
    SoundId = 95640392463828,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1.05,
        Volume = 1.5
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 99984406249141,
    Data = table.freeze({
        MaxDistance = 30,
        Volume = 1.5
    })
})

return (freeze(t1))
