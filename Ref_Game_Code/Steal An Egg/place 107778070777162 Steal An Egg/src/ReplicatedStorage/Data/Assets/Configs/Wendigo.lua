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
    _id = "Wendigo",
    DisplayName = "Wendigo",
    Icon = "rbxassetid://134637186116583",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 1.5E+07,
    IndexSpeedReward = 40000,
    DropWeight = 0,
    VisualOdds = 5E+06,
    ModelWeight = 12000,
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
        DisplayName = "Riftborn Egg",
        Icon = "rbxassetid://136340085637939",
        ModelName = "Riftborn Egg",
        GrowthTime = 60,
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
local v1 = "rbxassetid://72535019019919"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://72535019019919 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://105460764927533"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://105460764927533 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Secret
t1.BaseModelColor = Color3.fromRGB(83, 60, 255)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.fromRGB(83, 60, 255),
        850
    }),
    table.freeze({
        Color3.fromRGB(105, 77, 220),
        90
    }),
    table.freeze({
        Color3.fromRGB(42, 40, 61),
        48
    }),
    table.freeze({
        Color3.fromRGB(72, 52, 102),
        12
    })
})
t1.WalkSound = table.freeze({
    SoundId = 122192452632506,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 82387086630378,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
