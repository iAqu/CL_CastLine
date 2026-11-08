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
    _id = "FennecFox",
    DisplayName = "Fennec",
    Icon = "rbxassetid://130204625520606",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 18,
    IndexSpeedReward = 8100,
    DropWeight = 0.5,
    VisualOdds = 7778.721339,
    ModelWeight = 8,
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
        DisplayName = "Fennec Egg",
        Icon = "rbxassetid://104249034532190",
        GrowthTime = 30,
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
local v1 = "rbxassetid://97698541539837"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://97698541539837 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://87942495505255"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://87942495505255 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Uncommon
t1.BaseModelColor = Color3.new(0.8392156958580017, 0.729411780834198, 0.5568627715110779)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.8392156958580017, 0.729411780834198, 0.5568627715110779),
        780
    }),
    table.freeze({
        Color3.new(0.9215686321258545, 0.843137264251709, 0.686274528503418),
        130
    }),
    table.freeze({
        Color3.new(0.7058823704719543, 0.529411792755127, 0.3137255012989044),
        70
    }),
    table.freeze({
        Color3.new(1, 0.7333333492279053, 0.501960813999176),
        20
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        15
    })
})
t1.WalkSound = table.freeze({
    SoundId = 100755799211418,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 139113514652602,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
