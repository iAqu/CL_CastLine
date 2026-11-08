-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local LightDarkPlaceholder = require(script.Parent.Parent.LightDarkPlaceholder)
local v1 = table.clone(LightDarkPlaceholder.FromTemplate("Stag", {
    _id = "Centaur",
    DisplayName = "Centaur",
    Rarity = "Secret",
    EarningRate = 3.5E+08,
    IndexSpeedReward = 9E+07,
    VisualOdds = 135.13513513513513
}))

v1.ModelWeight = 12000

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
local v2 = "rbxassetid://103579027390419"

local function setAnimationId() -- line: 17
    -- upvalues: Animation (copy), v2 (copy)
    Animation.AnimationId = v2
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://103579027390419 is not shared with this experience")
end

t1.Idle = Animation

local Animation2 = Instance.new("Animation")
local v3 = "rbxassetid://87256504987743"

local function setAnimationId2() -- line: 17
    -- upvalues: Animation2 (copy), v3 (copy)
    Animation2.AnimationId = v3
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://87256504987743 is not shared with this experience")
end

t1.Walk = Animation2
v1.Animations = freeze(t1)

local v4 = table.clone(v1.Egg)

v4.Icon = "rbxassetid://94996357404675"
v4.GrowthTime = 12600
v1.Egg = table.freeze(v4)
v1.Icon = "rbxassetid://136114731886336"
v1.WalkSound = table.freeze({
    SoundId = 90865226033557,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
v1.RandomIdleSound = table.freeze({
    SoundId = 138591041806731,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return table.freeze(v1)
