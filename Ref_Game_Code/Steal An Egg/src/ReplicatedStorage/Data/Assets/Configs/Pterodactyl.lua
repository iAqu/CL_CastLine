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
    _id = "Pterodactyl",
    DisplayName = "Pterodactyl",
    Icon = "rbxassetid://92643140066500",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 22000,
    IndexSpeedReward = 270000,
    DropWeight = 0.5,
    VisualOdds = 215470.581098,
    ModelWeight = 180,
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
        DisplayName = "Pterodactyl Egg",
        Icon = "rbxassetid://88209726148785",
        GrowthTime = 180,
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
local v1 = "rbxassetid://139638551129821"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://139638551129821 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://92715712978388"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://92715712978388 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Legendary
t1.BaseModelColor = Color3.new(0.33725491166114807, 0.3137255012989044, 0.30588236451148987)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.33725491166114807, 0.3137255012989044, 0.30588236451148987),
        520
    }),
    table.freeze({
        Color3.new(0.47058823704719543, 0.37254902720451355, 0.2549019753932953),
        180
    }),
    table.freeze({
        Color3.new(0.5882353186607361, 0.5098039507865906, 0.37254902720451355),
        130
    }),
    table.freeze({
        Color3.new(0.21568627655506134, 0.21568627655506134, 0.23529411852359772),
        100
    }),
    table.freeze({
        Color3.new(0.37254902720451355, 0.4117647111415863, 0.45098039507865906),
        70
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        10
    })
})
t1.WalkSound = table.freeze({
    SoundId = 137006206175690,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 106521441079177,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
