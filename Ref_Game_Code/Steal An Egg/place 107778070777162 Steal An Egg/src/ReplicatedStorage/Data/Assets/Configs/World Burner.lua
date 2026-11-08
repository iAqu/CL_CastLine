-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local LightDarkPlaceholder = require(script.Parent.Parent.LightDarkPlaceholder)
local v1 = table.clone(LightDarkPlaceholder.FromTemplate("Archdemon Dragon", {
    _id = "World Burner",
    DisplayName = "World Burner",
    Rarity = "Divine",
    EarningRate = 5E+09,
    IndexSpeedReward = 6E+08,
    VisualOdds = 5000
}))

local function makeAnimation(p1) -- line: 13
    local Animation = Instance.new("Animation")

    local function setAnimationId() -- line: 15
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
local v2 = "rbxassetid://105908120568207"

local function setAnimationId() -- line: 15
    -- upvalues: Animation (copy), v2 (copy)
    Animation.AnimationId = v2
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://105908120568207 is not shared with this experience")
end

t1.Idle = Animation

local Animation2 = Instance.new("Animation")
local v3 = "rbxassetid://134098549938118"

local function setAnimationId2() -- line: 15
    -- upvalues: Animation2 (copy), v3 (copy)
    Animation2.AnimationId = v3
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://134098549938118 is not shared with this experience")
end

t1.Walk = Animation2
v1.Animations = freeze(t1)
v1.Icon = "rbxassetid://74345431327000"

local v4 = table.clone(v1.Egg)

v4.Icon = "rbxassetid://117970605290776"
v4.GrowthTime = 64800
v1.Egg = table.freeze(v4)
v1.WalkSound = table.freeze({
    SoundId = 107316499206585,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
v1.RandomIdleSound = table.freeze({
    SoundId = 112126857388298,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return table.freeze(v1)
