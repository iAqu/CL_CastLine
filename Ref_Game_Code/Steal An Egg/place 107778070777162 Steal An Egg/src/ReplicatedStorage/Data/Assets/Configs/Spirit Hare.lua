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
    _id = "Spirit Hare",
    DisplayName = "Astral Jackalope",
    Icon = "rbxassetid://86527506328485",
    EarningRate = 3E+07,
    IndexSpeedReward = 1.6E+07,
    DropWeight = 0,
    VisualOdds = 7.163323782234957,
    ModelWeight = 650,
    BaseModelScale = 1,
    LimitedEggViewportScale = 1,
    LimitedEggViewportVerticalOffset = 0,
    DontRoll = true,
    AlbinosColorFullWhite = true,
    Egg = table.freeze({
        DisplayName = "Astral Jackalope Egg",
        Icon = "rbxassetid://72213445673978",
        ModelName = "Astral Jackalope",
        GrowthTime = 1200,
        WeightKg = 8
    })
}
local freeze2 = table.freeze
local t2 = {}
local Animation = Instance.new("Animation")
local v2 = "rbxassetid://93269559973579"

local function setAnimationId() -- line: 8
    -- upvalues: Animation (copy), v2 (copy)
    Animation.AnimationId = v2
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://93269559973579 is not shared with this experience")
end

t2.Idle = Animation

local Animation2 = Instance.new("Animation")
local v3 = "rbxassetid://130754188752283"

local function setAnimationId2() -- line: 8
    -- upvalues: Animation2 (copy), v3 (copy)
    Animation2.AnimationId = v3
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://130754188752283 is not shared with this experience")
end

t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Cosmic
t1.BaseModelColor = v1
t1.PossibleModelColors = table.freeze({ table.freeze({ v1, 1 }) })

return (freeze(t1))
