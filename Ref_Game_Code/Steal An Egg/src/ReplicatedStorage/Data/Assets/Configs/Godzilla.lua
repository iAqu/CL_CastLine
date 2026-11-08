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
    _id = "Godzilla",
    DisplayName = "Nightflame",
    Icon = "rbxassetid://102979882140882",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 3E+09,
    IndexSpeedReward = 6870240,
    DropWeight = 0,
    VisualOdds = 1.68336E+14,
    ModelWeight = 160000,
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
        DisplayName = "Nightflame Egg",
        Icon = "rbxassetid://134762388111337",
        GrowthTime = 57600,
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
local v1 = "rbxassetid://105030323854881"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://105030323854881 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://78608369871297"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://78608369871297 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Divine
t1.BaseModelColor = Color3.new(0.8705882430076599, 0.8274509906768799, 0.6549019813537598)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.8705882430076599, 0.8274509906768799, 0.6549019813537598),
        850
    }),
    table.freeze({
        Color3.new(0.9215686321258545, 0.7843137383460999, 0.5490196347236633),
        90
    }),
    table.freeze({
        Color3.new(0.7450980544090271, 0.7450980544090271, 0.7843137383460999),
        48
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        12
    })
})

return (freeze(t1))
