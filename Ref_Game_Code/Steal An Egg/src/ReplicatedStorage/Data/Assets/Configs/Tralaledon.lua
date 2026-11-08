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
    _id = "Tralaledon",
    DisplayName = "Tralaledon",
    Icon = "rbxassetid://130012248199145",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 3.2E+07,
    IndexSpeedReward = 480000,
    DropWeight = 0.5,
    VisualOdds = 4788235.136,
    ModelWeight = 1000,
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
        DisplayName = "Tralaledon Egg",
        Icon = "rbxassetid://73956313512014",
        GrowthTime = 10800,
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
local v1 = "rbxassetid://76232355786894"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://76232355786894 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://106459098297164"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://106459098297164 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Secret
t1.BaseModelColor = Color3.new(0.33725491166114807, 0.6274510025978088, 0.239215686917305)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.33725491166114807, 0.6274510025978088, 0.239215686917305),
        1
    }),
    table.freeze({
        Color3.new(0.3764705955982208, 0.46666666865348816, 0.32156863808631897),
        1
    }),
    table.freeze({
        Color3.new(0.3529411852359772, 0.3921568691730499, 0.4117647111415863),
        1
    }),
    table.freeze({
        Color3.new(0.364705890417099, 0.3294117748737335, 0.26274511218070984),
        1
    }),
    table.freeze({
        Color3.new(0.5686274766921997, 0.47843137383461, 0.33725491166114807),
        1
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        12
    })
})
t1.WalkSound = table.freeze({
    SoundId = 102782721780407,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 111240888016649,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
