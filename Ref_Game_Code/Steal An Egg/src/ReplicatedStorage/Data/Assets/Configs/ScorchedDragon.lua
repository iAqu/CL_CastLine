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
    _id = "ScorchedDragon",
    DisplayName = "Scorched Dragon",
    Icon = "rbxassetid://71785777924134",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 3.5E+07,
    IndexSpeedReward = 150000,
    DropWeight = 0,
    VisualOdds = 1000,
    ModelWeight = 120000,
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
        DisplayName = "Dragon's Egg",
        Icon = "rbxassetid://114970669202722",
        GrowthTime = 10800,
        WeightKg = 40,
        HideRarity = nil,
        IgnoreSizeGrowthMultiplier = true
    })
}
local freeze2 = table.freeze
local t2 = {
    TransitionFadeDuration = nil
}
local Animation = Instance.new("Animation")
local v1 = "rbxassetid://85591916692734"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://85591916692734 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://95766204290612"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://95766204290612 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Secret
t1.BaseModelColor = Color3.new(0.3529411852359772, 0.2980392277240753, 0.25882354378700256)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.3529411852359772, 0.2980392277240753, 0.25882354378700256),
        700
    }),
    table.freeze({
        Color3.new(0.20000000298023224, 0.18039216101169586, 0.16862745583057404),
        180
    }),
    table.freeze({
        Color3.new(0.6666666865348816, 0.3333333432674408, 0.13725490868091583),
        108
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        12
    })
})
t1.WalkSound = table.freeze({
    SoundId = 140401695659406,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
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
