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
    _id = "Finned Thresher",
    DisplayName = "Shark",
    Icon = "rbxassetid://125497863961128",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 15000,
    IndexSpeedReward = 90000,
    DropWeight = 0,
    VisualOdds = 9.5E+09,
    ModelWeight = 450,
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
        DisplayName = "Shark Egg",
        Icon = "rbxassetid://71615245424079",
        GrowthTime = 240,
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
local v1 = "rbxassetid://127775181505316"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://127775181505316 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://76392180822636"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://76392180822636 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Legendary
t1.BaseModelColor = Color3.new(0, 0.27843138575553894, 0.4274509847164154)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0, 0.27843138575553894, 0.4274509847164154),
        610
    }),
    table.freeze({
        Color3.new(0.1764705926179886, 0.29411765933036804, 0.3529411852359772),
        190
    }),
    table.freeze({
        Color3.new(0.0784313753247261, 0.1764705926179886, 0.27450981736183167),
        70
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        10
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 71821986721113,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
