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
    _id = "Chimpanzee",
    DisplayName = "Chimpanzee",
    Icon = "rbxassetid://74635759656969",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 90,
    IndexSpeedReward = 7200,
    DropWeight = 0,
    VisualOdds = 190000,
    ModelWeight = 65,
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
        DisplayName = "Chimpanzee Egg",
        Icon = "rbxassetid://112484055753399",
        GrowthTime = 30,
        WeightKg = 3,
        HideRarity = nil,
        IgnoreSizeGrowthMultiplier = nil
    })
}
local freeze2 = table.freeze
local t2 = {
    TransitionFadeDuration = nil
}
local Animation = Instance.new("Animation")
local v1 = "rbxassetid://79828503574644"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://79828503574644 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://118780292967097"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://118780292967097 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Rare
t1.BaseModelColor = Color3.new(0.33725491166114807, 0.2235294133424759, 0.14509804546833038)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.33725491166114807, 0.2235294133424759, 0.14509804546833038),
        650
    }),
    table.freeze({
        Color3.new(0.21568627655506134, 0.16470588743686676, 0.125490203499794),
        180
    }),
    table.freeze({
        Color3.new(0.47058823704719543, 0.3333333432674408, 0.21568627655506134),
        125
    }),
    table.freeze({
        Color3.new(0.6078431606292725, 0.4901960790157318, 0.37254902720451355),
        45
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        10
    })
})
t1.WalkSound = table.freeze({
    SoundId = 123431841520512,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 102428875173675,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
