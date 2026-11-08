-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rarity = require(ReplicatedStorage.Data.Rarity)
local v1 = Color3.fromRGB(255, 255, 255)

local function makeAnimation(p1) -- line: 6
    local Animation = Instance.new("Animation")

    local function setAnimationId() -- line: 8
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
    _id = "Spirit Panda",
    DisplayName = "Spirit Panda",
    Icon = "rbxassetid://130775352945186",
    EarningRate = 9E+07,
    IndexSpeedReward = 1.6E+07,
    DropWeight = 0,
    VisualOdds = 22.93577981651376,
    ModelWeight = 2000,
    BaseModelScale = 1,
    LimitedEggViewportScale = 1,
    LimitedEggViewportVerticalOffset = 0,
    DontRoll = true,
    AlbinosColorFullWhite = true,
    Egg = table.freeze({
        DisplayName = "Spirit Panda Egg",
        Icon = "rbxassetid://131111647963702",
        ModelName = "Spirit Panda",
        GrowthTime = 10800,
        WeightKg = 8
    })
}
local freeze2 = table.freeze
local t2 = {}
local Animation = Instance.new("Animation")
local v2 = "rbxassetid://115211469719705"

local function setAnimationId() -- line: 8
    -- upvalues: Animation (copy), v2 (copy)
    Animation.AnimationId = v2
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://115211469719705 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v3 = "rbxassetid://110027629838208"

local function setAnimationId2() -- line: 8
    -- upvalues: Animation2 (copy), v3 (copy)
    Animation2.AnimationId = v3
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://110027629838208 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Cosmic
t1.BaseModelColor = v1
t1.PossibleModelColors = table.freeze({ table.freeze({ v1, 1 }) })

return (freeze(t1))
