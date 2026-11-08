-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local LightDarkPlaceholder = require(script.Parent.Parent.LightDarkPlaceholder)
local v1 = table.clone(LightDarkPlaceholder.FromTemplate("Swan", {
    _id = "Dove",
    DisplayName = "Light Dove",
    Rarity = "Legendary",
    EarningRate = 225000,
    IndexSpeedReward = 3E+06,
    VisualOdds = 2.6659557451346307
}))

v1.ModelWeight = 45000

local function makeAnimation(p1) -- line: 15
    local Animation = Instance.new("Animation")

    local function setAnimationId() -- line: 17
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
local v2 = "rbxassetid://87026407917685"

local function setAnimationId() -- line: 17
    -- upvalues: Animation (copy), v2 (copy)
    Animation.AnimationId = v2
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://87026407917685 is not shared with this experience")
end

t1.Idle = Animation

local Animation2 = Instance.new("Animation")
local v3 = "rbxassetid://88155121013841"

local function setAnimationId2() -- line: 17
    -- upvalues: Animation2 (copy), v3 (copy)
    Animation2.AnimationId = v3
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://88155121013841 is not shared with this experience")
end

t1.Walk = Animation2
v1.Animations = freeze(t1)
v1.Icon = "rbxassetid://71242072766450"

local v4 = table.clone(v1.Egg)

v4.Icon = "rbxassetid://104459545767438"
v4.GrowthTime = 300
v1.Egg = table.freeze(v4)
v1.WalkSound = table.freeze({
    SoundId = 128632172954714,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
v1.RandomIdleSound = table.freeze({
    SoundId = 118323451396721,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return table.freeze(v1)
