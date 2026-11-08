-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local LightDarkPlaceholder = require(script.Parent.Parent.LightDarkPlaceholder)
local v1 = table.clone(LightDarkPlaceholder.FromTemplate("Crane", {
    _id = "Lamb",
    DisplayName = "Winged Lamb",
    Rarity = "Mythic",
    EarningRate = 1250000,
    IndexSpeedReward = 4E+06,
    VisualOdds = 3.806623524933384
}))

v1.ModelWeight = 72000

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
local v2 = "rbxassetid://111816188642783"

local function setAnimationId() -- line: 17
    -- upvalues: Animation (copy), v2 (copy)
    Animation.AnimationId = v2
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://111816188642783 is not shared with this experience")
end

t1.Idle = Animation

local Animation2 = Instance.new("Animation")
local v3 = "rbxassetid://79560565269439"

local function setAnimationId2() -- line: 17
    -- upvalues: Animation2 (copy), v3 (copy)
    Animation2.AnimationId = v3
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://79560565269439 is not shared with this experience")
end

t1.Walk = Animation2
v1.Animations = freeze(t1)
v1.Icon = "rbxassetid://75083238388813"

local v4 = table.clone(v1.Egg)

v4.Icon = "rbxassetid://135085221683245"
v4.GrowthTime = 480
v1.Egg = table.freeze(v4)
v1.WalkSound = table.freeze({
    SoundId = 122963672192307,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
v1.RandomIdleSound = table.freeze({
    SoundId = 83228840270934,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return table.freeze(v1)
