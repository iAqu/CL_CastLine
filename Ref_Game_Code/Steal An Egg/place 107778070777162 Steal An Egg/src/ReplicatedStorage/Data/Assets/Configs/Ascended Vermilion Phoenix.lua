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
    _id = "Ascended Vermilion Phoenix",
    DisplayName = "Phoenix",
    Icon = "rbxassetid://118067990008425",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 8.5E+07,
    IndexSpeedReward = 48000,
    DropWeight = 0.1111111111111111,
    VisualOdds = 1077352905.49,
    ModelWeight = 2500,
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
        DisplayName = "Phoenix Egg",
        Icon = "rbxassetid://108172622989366",
        GrowthTime = 16200,
        WeightKg = 5,
        HideRarity = nil,
        IgnoreSizeGrowthMultiplier = nil
    })
}
local freeze2 = table.freeze
local t2 = {
    TransitionFadeDuration = nil
}
local Animation = Instance.new("Animation")
local v1 = "rbxassetid://85057156715276"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://85057156715276 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://104273848115084"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://104273848115084 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Eternal
t1.BaseModelColor = Color3.new(0.6392157077789307, 0.33725491166114807, 0.16470588743686676)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.6392157077789307, 0.33725491166114807, 0.16470588743686676),
        440
    }),
    table.freeze({
        Color3.new(1, 0.48235294222831726, 0.18431372940540314),
        210
    }),
    table.freeze({
        Color3.new(0.5098039507865906, 0.2549019753932953, 0.10588235408067703),
        150
    }),
    table.freeze({
        Color3.new(0.7176470756530762, 0.30588236451148987, 0.07058823853731155),
        120
    }),
    table.freeze({
        Color3.new(1, 0, 0),
        80
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        10
    })
})
t1.WalkSound = table.freeze({
    SoundId = 74222673189312,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 78009543684733,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
