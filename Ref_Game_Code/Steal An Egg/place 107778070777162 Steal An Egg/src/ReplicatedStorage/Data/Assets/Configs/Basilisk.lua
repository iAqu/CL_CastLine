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
    _id = "Basilisk",
    DisplayName = "Leviathan",
    Icon = "rbxassetid://127583688266170",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 220000,
    IndexSpeedReward = 5000,
    DropWeight = 0.14285714285714285,
    VisualOdds = 1372.3499248948783,
    ModelWeight = 5000,
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
        DisplayName = "Leviathan Egg",
        Icon = "rbxassetid://90075842297994",
        GrowthTime = 1500,
        WeightKg = 2,
        HideRarity = nil,
        IgnoreSizeGrowthMultiplier = nil
    })
}
local freeze2 = table.freeze
local t2 = {
    TransitionFadeDuration = nil
}
local Animation = Instance.new("Animation")
local v1 = "rbxassetid://99945162566289"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://99945162566289 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://134348178448156"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://134348178448156 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Cosmic
t1.BaseModelColor = Color3.new(0.10588235408067703, 0.16470588743686676, 0.2078431397676468)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.10588235408067703, 0.16470588743686676, 0.2078431397676468),
        520
    }),
    table.freeze({
        Color3.new(0.07450980693101883, 0.0941176488995552, 0.05098039284348488),
        210
    }),
    table.freeze({
        Color3.new(0.20392157137393951, 0.16078431904315948, 0.10196078568696976),
        140
    }),
    table.freeze({
        Color3.new(0.12156862765550613, 0.11764705926179886, 0.08235294371843338),
        90
    }),
    table.freeze({
        Color3.new(0.12941177189350128, 0.12941177189350128, 0.12156862765550613),
        40
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        12
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 71506363557317,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
