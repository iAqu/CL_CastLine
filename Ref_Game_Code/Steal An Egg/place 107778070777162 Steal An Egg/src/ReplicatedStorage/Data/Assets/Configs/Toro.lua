-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local LightDarkPlaceholder = require(script.Parent.Parent.LightDarkPlaceholder)
local v1 = table.clone(LightDarkPlaceholder.FromTemplate("Hellhound", {
    _id = "Toro",
    DisplayName = "Toro",
    Rarity = "Mythic",
    EarningRate = 1250000,
    IndexSpeedReward = 4E+06,
    VisualOdds = 3.806623524933384
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
local v2 = "rbxassetid://91059320033092"

local function setAnimationId() -- line: 16
    -- upvalues: Animation (copy), v2 (copy)
    Animation.AnimationId = v2
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://91059320033092 is not shared with this experience")
end

t1.Idle = Animation

local Animation2 = Instance.new("Animation")
local v3 = "rbxassetid://134951177250078"

local function setAnimationId2() -- line: 16
    -- upvalues: Animation2 (copy), v3 (copy)
    Animation2.AnimationId = v3
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://134951177250078 is not shared with this experience")
end

t1.Walk = Animation2
v1.Animations = freeze(t1)
v1.Icon = "rbxassetid://81140344970127"

local v4 = table.clone(v1.Egg)

v4.Icon = "rbxassetid://79033215990120"
v4.GrowthTime = 480
v1.Egg = table.freeze(v4)
v1.WalkSound = table.freeze({
    SoundId = 131750573366000,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
v1.RandomIdleSound = table.freeze({
    SoundId = 82666189995615,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return table.freeze(v1)
