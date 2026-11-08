-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local LightDarkPlaceholder = require(script.Parent.Parent.LightDarkPlaceholder)
local v1 = table.clone(LightDarkPlaceholder.FromTemplate("Shadow Dragon", {
    _id = "Dark Gargoyle",
    DisplayName = "Gargoyle",
    Rarity = "Secret",
    EarningRate = 2.25E+08,
    IndexSpeedReward = 3E+07,
    VisualOdds = 22.935779816513758
}))

local function makeAnimation(p1) -- line: 14
    local Animation = Instance.new("Animation")

    local function setAnimationId() -- line: 16
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
    TransitionFadeDuration = nil
}
local Animation = Instance.new("Animation")
local v2 = "rbxassetid://116878464800621"

local function setAnimationId() -- line: 16
    -- upvalues: Animation (copy), v2 (copy)
    Animation.AnimationId = v2
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://116878464800621 is not shared with this experience")
end

t1.Idle = Animation

local Animation2 = Instance.new("Animation")
local v3 = "rbxassetid://72168860461322"

local function setAnimationId2() -- line: 16
    -- upvalues: Animation2 (copy), v3 (copy)
    Animation2.AnimationId = v3
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://72168860461322 is not shared with this experience")
end

t1.Walk = Animation2
v1.Animations = freeze(t1)

local v4 = table.clone(v1.Egg)

v4.Icon = "rbxassetid://119732629571247"
v4.GrowthTime = 10800
v1.Egg = table.freeze(v4)
v1.Icon = "rbxassetid://99077940722686"
v1.WalkSound = table.freeze({
    SoundId = 140567909859107,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
v1.RandomIdleSound = table.freeze({
    SoundId = 89807033480950,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return table.freeze(v1)
