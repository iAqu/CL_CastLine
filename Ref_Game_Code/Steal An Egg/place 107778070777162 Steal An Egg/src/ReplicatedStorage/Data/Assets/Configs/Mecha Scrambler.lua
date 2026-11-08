-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rarity = require(ReplicatedStorage.Data.Rarity)

local function makeAnimation(p1) -- line: 4
    local Animation = Instance.new("Animation")

    local function v1() -- line: 6
        -- upvalues: p1 (copy), Animation (copy)
        Animation.AnimationId = p1
    end

    if not pcall(v1) then
        warn((("Animation %* is not shared with this experience"):format(p1)))
    end

    return Animation
end

local freeze = table.freeze
local t1 = {
    _id = "Mecha Scrambler",
    DisplayName = "Mecha Scrambler",
    Icon = "rbxassetid://92101779058721",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 7.5E+09,
    IndexSpeedReward = 0,
    DropWeight = 0,
    VisualOdds = 0,
    ModelWeight = 30000,
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
    DontRoll = true,
    CannotFuse = nil,
    GenderLocked = nil,
    AlbinosColorFullWhite = nil,
    Egg = table.freeze({
        DisplayName = "Mecha Scrambler Egg",
        Icon = "rbxassetid://121178065227483",
        GrowthTime = 60,
        WeightKg = 1,
        HideRarity = nil,
        IgnoreSizeGrowthMultiplier = nil
    })
}
local freeze2 = table.freeze
local t2 = {
    TransitionFadeDuration = nil
}
local Animation = Instance.new("Animation")
local v2 = "rbxassetid://120484795823977"

local function v3() -- line: 6
    -- upvalues: Animation (copy), v2 (copy)
    Animation.AnimationId = v2
end

if not pcall(v3) then
    warn("Animation rbxassetid://120484795823977 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v4 = "rbxassetid://107270328959157"

local function v5() -- line: 6
    -- upvalues: Animation2 (copy), v4 (copy)
    Animation2.AnimationId = v4
end

if not pcall(v5) then
    warn("Animation rbxassetid://107270328959157 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Divine
t1.BaseModelColor = Color3.fromRGB(81, 226, 36)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.fromRGB(81, 226, 36),
        1
    })
})

return (freeze(t1))
