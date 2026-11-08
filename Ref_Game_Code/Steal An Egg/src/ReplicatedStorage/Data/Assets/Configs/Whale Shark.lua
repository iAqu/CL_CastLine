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
    _id = "Whale Shark",
    DisplayName = "Whale Shark",
    Icon = "rbxassetid://133745688279874",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 7E+05,
    IndexSpeedReward = 108000,
    DropWeight = 0.25,
    VisualOdds = 14504941186.087273,
    ModelWeight = 2000,
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
        DisplayName = "Whale Shark Egg",
        Icon = "rbxassetid://93013491848495",
        GrowthTime = 600,
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
local v1 = "rbxassetid://96079428169602"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://96079428169602 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://94460509562960"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://94460509562960 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Cosmic
t1.BaseModelColor = Color3.new(0, 0.125490203499794, 0.3764705955982208)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0, 0.125490203499794, 0.3764705955982208),
        680
    }),
    table.freeze({
        Color3.new(0.09803921729326248, 0.16862745583057404, 0.21176470816135406),
        160
    }),
    table.freeze({
        Color3.new(0.14509804546833038, 0.16862745583057404, 0.1764705926179886),
        110
    }),
    table.freeze({
        Color3.new(0.14901961386203766, 0.16078431904315948, 0.16078431904315948),
        35
    }),
    table.freeze({
        Color3.new(0.09803921729326248, 0.13725490868091583, 0.1764705926179886),
        15
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        10
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 76545999037742,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
