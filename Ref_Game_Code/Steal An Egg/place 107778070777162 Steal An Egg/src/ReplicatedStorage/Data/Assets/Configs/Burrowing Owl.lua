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
    _id = "Burrowing Owl",
    DisplayName = "Burrowing Owl",
    Icon = "rbxassetid://123516361239872",
    WhiteImage = nil,
    MutationIcons = nil,
    EarningRate = 35,
    IndexSpeedReward = 560,
    DropWeight = 0.2,
    VisualOdds = 6.484806179286864,
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
        DisplayName = "Burrowing Owl Egg",
        Icon = "rbxassetid://122807946218302",
        GrowthTime = 40,
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
local v1 = "rbxassetid://89419902709935"

local function setAnimationId() -- line: 9
    -- upvalues: Animation (copy), v1 (copy)
    Animation.AnimationId = v1
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://89419902709935 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v2 = "rbxassetid://137489865198011"

local function setAnimationId2() -- line: 9
    -- upvalues: Animation2 (copy), v2 (copy)
    Animation2.AnimationId = v2
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://137489865198011 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Rare
t1.BaseModelColor = Color3.new(0.3450980484485626, 0.2980392277240753, 0.2078431397676468)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.new(0.3450980484485626, 0.2980392277240753, 0.2078431397676468),
        720
    }),
    table.freeze({
        Color3.new(0.4901960790157318, 0.4117647111415863, 0.27450981736183167),
        170
    }),
    table.freeze({
        Color3.new(0.2549019753932953, 0.22745098173618317, 0.1764705926179886),
        75
    }),
    table.freeze({
        Color3.new(0.47058823704719543, 0.4117647111415863, 0.29019609093666077),
        35
    }),
    table.freeze({
        Color3.new(1, 1, 1),
        15
    })
})
t1.WalkSound = table.freeze({
    SoundId = 99892403203037,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
t1.RandomIdleSound = table.freeze({
    SoundId = 87403836085353,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return (freeze(t1))
