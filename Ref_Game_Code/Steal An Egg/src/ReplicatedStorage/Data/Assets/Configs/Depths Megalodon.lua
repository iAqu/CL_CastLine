-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rarity = require(ReplicatedStorage.Data.Rarity)

local function makeAnimation(p1) -- line: 8
    local Animation = Instance.new("Animation")

    local function setAnimationId() -- line: 10
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
    _id = "Depths Megalodon",
    DisplayName = "Luminous Abyss Shark",
    Icon = "rbxassetid://77248630151797",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 6E+08,
    IndexSpeedReward = 0,
    DropWeight = 0,
    VisualOdds = 550,
    ModelWeight = 60000,
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
    AlbinosColorFullWhite = true,
    Egg = table.freeze({
        DisplayName = "Luminous Abyss Shark Egg",
        Icon = "rbxassetid://103020287697704",
        ModelName = "Depths Reroll Egg",
        GrowthTime = 10,
        WeightKg = 6,
        HideRarity = true,
        IgnoreSizeGrowthMultiplier = true
    })
}
local freeze2 = table.freeze
local t2 = {
    TransitionFadeDuration = nil
}
local Animation = Instance.new("Animation")
local v1 = "rbxassetid://116326288517814"

local function setAnimationId() -- line: 10
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://116326288517814 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://87231380690296"

local function setAnimationId2() -- line: 10
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://87231380690296 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Secret
t1.BaseModelColor = Color3.fromRGB(65, 34, 117)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.fromRGB(65, 34, 117),
        80
    }),
    table.freeze({
        Color3.fromRGB(82, 49, 126),
        19
    }),
    table.freeze({
        Color3.fromRGB(255, 255, 255),
        1
    })
})
t1.WalkSound = table.freeze({
    SoundId = 88170653538559,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 70884310215762,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
