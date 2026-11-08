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
    _id = "Royal Skywhale",
    DisplayName = "Royal Skywhale",
    Icon = "rbxassetid://140420688307546",
    EarningRate = 8E+09,
    IndexSpeedReward = 6E+07,
    DropWeight = 0,
    VisualOdds = 5000,
    ModelWeight = 190000,
    BaseModelScale = 1,
    LimitedEggViewportScale = 1,
    LimitedEggViewportVerticalOffset = 0,
    DontRoll = true,
    AlbinosColorFullWhite = true,
    Egg = table.freeze({
        DisplayName = "Royal Skywhale Egg",
        Icon = "rbxassetid://121358694277567",
        ModelName = "Royal Skywhale",
        GrowthTime = 64800,
        WeightKg = 8
    })
}
local freeze2 = table.freeze
local t2 = {}
local Animation = Instance.new("Animation")
local v2 = "rbxassetid://72475549070227"

local function setAnimationId() -- line: 8
    -- upvalues: Animation (copy), v2 (copy)
    Animation.AnimationId = v2
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://72475549070227 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v3 = "rbxassetid://83615732104417"

local function setAnimationId2() -- line: 8
    -- upvalues: Animation2 (copy), v3 (copy)
    Animation2.AnimationId = v3
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://83615732104417 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Divine
t1.BaseModelColor = v1
t1.PossibleModelColors = table.freeze({ table.freeze({ v1, 1 }) })

return (freeze(t1))
