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
    _id = "Cosmic Beetle Blue",
    DisplayName = "Petal Beetle",
    Icon = "rbxassetid://100456581757086",
    EarningRate = 1200000,
    IndexSpeedReward = 6E+06,
    DropWeight = 0,
    VisualOdds = 3.806623524933384,
    ModelWeight = 900,
    BaseModelScale = 1,
    LimitedEggViewportScale = 1,
    LimitedEggViewportVerticalOffset = 0,
    DontRoll = true,
    AlbinosColorFullWhite = true,
    Egg = table.freeze({
        DisplayName = "Petal Beetle Egg",
        Icon = "rbxassetid://74778395132095",
        ModelName = "Petal Beetle",
        GrowthTime = 480,
        WeightKg = 8
    })
}
local freeze2 = table.freeze
local t2 = {}
local Animation = Instance.new("Animation")
local v2 = "rbxassetid://128419183612223"

local function setAnimationId() -- line: 8
    -- upvalues: Animation (copy), v2 (copy)
    Animation.AnimationId = v2
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://128419183612223 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v3 = "rbxassetid://96465486096704"

local function setAnimationId2() -- line: 8
    -- upvalues: Animation2 (copy), v3 (copy)
    Animation2.AnimationId = v3
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://96465486096704 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Mythic
t1.BaseModelColor = v1
t1.PossibleModelColors = table.freeze({ table.freeze({ v1, 1 }) })

return (freeze(t1))
