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
    _id = "King Kong",
    DisplayName = "Gorilla King",
    Icon = "rbxassetid://135650224014044",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 8.8E+08,
    IndexSpeedReward = 5496192,
    DropWeight = 0,
    VisualOdds = 2.8729E+13,
    ModelWeight = 1E+05,
    WalkAnimationReferenceSpeed = nil,
    BaseModelScale = 1,
    LimitedEggViewportScale = 1,
    LimitedEggViewportVerticalOffset = 0,
    PlaceSound = nil,
    WalkSound = nil,
    RandomIdleSound = nil,
    LuckyBlockDropTable = nil,
    LuckyBlockDropTableType = nil,
    LuckyBlockLevelRange = nil,
    LuckyBlockOpenDuration = nil,
    DontRoll = nil,
    CannotFuse = nil,
    GenderLocked = nil,
    AlbinosColorFullWhite = nil,
    Egg = table.freeze({
        DisplayName = "Gorilla King Egg",
        Icon = "rbxassetid://140733363307193",
        GrowthTime = 32400,
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
local v1 = "rbxassetid://123822629912237"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://123822629912237 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://131533059911792"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://131533059911792 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Eternal
t1.BaseModelColor = Color3.new(0.8705882430076599, 0.8274509906768799, 0.7568627595901489)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.8705882430076599, 0.8274509906768799, 0.7568627595901489),
        850
    }),
    table.freeze({
        Color3.new(0.9215686321258545, 0.7450980544090271, 0.47058823704719543),
        90
    }),
    table.freeze({
        Color3.new(0.47058823704719543, 0.47058823704719543, 0.5098039507865906),
        48
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        12
    })
})

return (freeze(t1))
