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
    _id = "Bronto",
    DisplayName = "Bronto",
    Icon = "rbxassetid://97379364436568",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 1500000,
    IndexSpeedReward = 3E+05,
    DropWeight = 0.25,
    VisualOdds = 10773529.055,
    ModelWeight = 35000,
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
        DisplayName = "Bronto Egg",
        Icon = "rbxassetid://102498197407436",
        GrowthTime = 660,
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
local v1 = "rbxassetid://99676847051723"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://99676847051723 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://93614636566946"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://93614636566946 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Cosmic
t1.BaseModelColor = Color3.new(0.4117647111415863, 0.41960784792900085, 0.4745098054409027)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.4117647111415863, 0.41960784792900085, 0.4745098054409027),
        440
    }),
    table.freeze({
        Color3.new(0.4313725531101227, 0.37254902720451355, 0.27450981736183167),
        210
    }),
    table.freeze({
        Color3.new(0.37254902720451355, 0.45098039507865906, 0.29411765933036804),
        150
    }),
    table.freeze({
        Color3.new(0.5686274766921997, 0.5098039507865906, 0.37254902720451355),
        120
    }),
    table.freeze({
        Color3.new(0.2549019753932953, 0.2549019753932953, 0.27450981736183167),
        80
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        10
    })
})
t1.WalkSound = table.freeze({
    SoundId = 104739285394756,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 90507633553833,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
