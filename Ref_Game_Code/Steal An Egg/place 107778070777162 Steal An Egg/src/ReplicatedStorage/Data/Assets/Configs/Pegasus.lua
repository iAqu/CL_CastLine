-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local LightDarkPlaceholder = require(script.Parent.Parent.LightDarkPlaceholder)
local v1 = table.clone(LightDarkPlaceholder.FromTemplate("Alabaster Whale", {
    _id = "Pegasus",
    DisplayName = "Pegasus",
    Rarity = "Eternal",
    EarningRate = 1.3E+09,
    IndexSpeedReward = 2E+08,
    VisualOdds = 322.5806451612903
}))

v1.ModelWeight = 65000

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
local v2 = "rbxassetid://115495639401411"

local function setAnimationId() -- line: 16
    -- upvalues: Animation (copy), v2 (copy)
    Animation.AnimationId = v2
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://115495639401411 is not shared with this experience")
end

t1.Idle = Animation

local Animation2 = Instance.new("Animation")
local v3 = "rbxassetid://71740487568684"

local function setAnimationId2() -- line: 16
    -- upvalues: Animation2 (copy), v3 (copy)
    Animation2.AnimationId = v3
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://71740487568684 is not shared with this experience")
end

t1.Walk = Animation2
v1.Animations = freeze(t1)

local v4 = table.clone(v1.Egg)

v4.Icon = "rbxassetid://79544542526316"
v4.GrowthTime = 36000
v1.Egg = table.freeze(v4)
v1.Icon = "rbxassetid://112830316982322"
v1.WalkSound = table.freeze({
    SoundId = 100255579453255,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
v1.RandomIdleSound = table.freeze({
    SoundId = 109471556133110,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return table.freeze(v1)
