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
    _id = "Baby Aurora Dragon",
    DisplayName = "Baby Aurora Dragon",
    Icon = "rbxassetid://93373306453881",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 5E+06,
    IndexSpeedReward = 10000,
    DropWeight = 0,
    VisualOdds = 100,
    ModelWeight = 8000,
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
local v1 = "rbxassetid://94341479254631"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://94341479254631 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://133547081058201"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://133547081058201 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Legendary
t1.BaseModelColor = Color3.new(0.9137254953384399, 0.8549019694328308, 0.8549019694328308)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.9137254953384399, 0.8549019694328308, 0.8549019694328308),
        700
    }),
    table.freeze({
        Color3.new(0.5882353186607361, 0.615686297416687, 0.8588235378265381),
        180
    }),
    table.freeze({
        Color3.new(1, 0.48235294222831726, 0.4901960790157318),
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
        Speed = 1.12,
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
