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
    _id = "Swordfish",
    DisplayName = "Swordfish",
    Icon = "rbxassetid://103426699196063",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 1100,
    IndexSpeedReward = 81000,
    DropWeight = 0.5,
    VisualOdds = 4910446705.478001,
    ModelWeight = 250,
    WalkAnimationReferenceSpeed = nil,
    BaseModelScale = 1,
    LimitedEggViewportScale = 1,
    LimitedEggViewportVerticalOffset = 0,
    PlaceSound = nil,
    WalkSound = nil,
    LuckyBlockDropTable = nil,
    LuckyBlockDropTableType = nil,
    LuckyBlockLevelRange = nil,
    LuckyBlockOpenDuration = nil,
    DontRoll = nil,
    CannotFuse = nil,
    GenderLocked = nil,
    AlbinosColorFullWhite = nil,
    Egg = table.freeze({
        DisplayName = "Swordfish Egg",
        Icon = "rbxassetid://108314641239947",
        GrowthTime = 120,
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
local v1 = "rbxassetid://79570633151364"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://79570633151364 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://103930506176496"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://103930506176496 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Epic
t1.BaseModelColor = Color3.new(0.22745098173618317, 0.2980392277240753, 0.38823530077934265)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.22745098173618317, 0.2980392277240753, 0.38823530077934265),
        650
    }),
    table.freeze({
        Color3.new(0.4313725531101227, 0.572549045085907, 0.7098039388656616),
        170
    }),
    table.freeze({
        Color3.new(0.13725490868091583, 0.21568627655506134, 0.3333333432674408),
        120
    }),
    table.freeze({
        Color3.new(0.09803921729326248, 0.13725490868091583, 0.21568627655506134),
        15
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        10
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 96287155757786,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
