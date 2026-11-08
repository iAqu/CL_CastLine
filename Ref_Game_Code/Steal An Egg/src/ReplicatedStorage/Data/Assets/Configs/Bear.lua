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
    _id = "Bear",
    DisplayName = "Bear",
    Icon = "rbxassetid://99309954423391",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 240,
    IndexSpeedReward = 820,
    DropWeight = 0.3333333333333333,
    VisualOdds = 56.702784,
    ModelWeight = 220,
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
        DisplayName = "Bear Egg",
        Icon = "rbxassetid://75135783493246",
        GrowthTime = 120,
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
local v1 = "rbxassetid://117105848139359"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://117105848139359 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://112971811958973"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://112971811958973 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Epic
t1.BaseModelColor = Color3.new(0.32549020648002625, 0.23529411852359772, 0.125490203499794)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.32549020648002625, 0.23529411852359772, 0.125490203499794),
        640
    }),
    table.freeze({
        Color3.new(0.1764705926179886, 0.14901961386203766, 0.125490203499794),
        180
    }),
    table.freeze({
        Color3.new(0.364705890417099, 0.26274511218070984, 0.1725490242242813),
        120
    }),
    table.freeze({
        Color3.new(0.8235294222831726, 0.7450980544090271, 0.5882353186607361),
        45
    }),
    table.freeze({
        Color3.new(0.9215686321258545, 0.9019607901573181, 0.843137264251709),
        15
    })
})
t1.WalkSound = table.freeze({
    SoundId = 84881266793081,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 88584063816692,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
