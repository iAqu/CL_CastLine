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
    _id = "World Spirit",
    DisplayName = "Spirit World Guardian",
    Icon = "rbxassetid://72974611437454",
    EarningRate = 1.5E+10,
    IndexSpeedReward = 0,
    DropWeight = 0,
    VisualOdds = 0,
    ModelWeight = 40000,
    BaseModelScale = 1,
    LimitedEggViewportScale = 1,
    LimitedEggViewportVerticalOffset = 0,
    DontRoll = true,
    AlbinosColorFullWhite = true,
    Egg = table.freeze({
        DisplayName = "Spirit World Guardian Egg",
        Icon = "rbxassetid://121251394844117",
        ModelName = "World Spirit",
        GrowthTime = 64800,
        WeightKg = 8
    })
}
local freeze2 = table.freeze
local t2 = {}
local Animation = Instance.new("Animation")
local v2 = "rbxassetid://93961573132593"

local function setAnimationId() -- line: 8
    -- upvalues: Animation (copy), v2 (copy)
    Animation.AnimationId = v2
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://93961573132593 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v3 = "rbxassetid://120772797371025"

local function setAnimationId2() -- line: 8
    -- upvalues: Animation2 (copy), v3 (copy)
    Animation2.AnimationId = v3
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://120772797371025 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Divine
t1.BaseModelColor = v1
t1.PossibleModelColors = table.freeze({ table.freeze({ v1, 1 }) })

return (freeze(t1))
