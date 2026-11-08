-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1 = table.clone(require(script.Parent.Pegasus))

v1._id = "Equinox"
v1.DisplayName = "Equinox"
v1.Icon = "rbxassetid://92079543818607"
v1.EarningRate = 1.8E+09
v1.ModelWeight = 65000

local function makeAnimation(p1) -- line: 10
    local Animation = Instance.new("Animation")

    local function setAnimationId() -- line: 12
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
local v2 = "rbxassetid://84399470387824"

local function setAnimationId() -- line: 12
    -- upvalues: Animation (copy), v2 (copy)
    Animation.AnimationId = v2
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://84399470387824 is not shared with this experience")
end

t1.Idle = Animation

local Animation2 = Instance.new("Animation")
local v3 = "rbxassetid://102707946124614"

local function setAnimationId2() -- line: 12
    -- upvalues: Animation2 (copy), v3 (copy)
    Animation2.AnimationId = v3
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://102707946124614 is not shared with this experience")
end

t1.Walk = Animation2
v1.Animations = freeze(t1)
v1.BaseModelColor = Color3.fromRGB(240, 194, 77)
v1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.fromRGB(240, 194, 77),
        850
    }),
    table.freeze({
        Color3.fromRGB(255, 223, 142),
        90
    }),
    table.freeze({
        Color3.fromRGB(196, 140, 56),
        48
    }),
    table.freeze({
        Color3.fromRGB(255, 255, 255),
        12
    })
})

local v4 = table.clone(v1.Egg)

v4.DisplayName = "Equinox Egg"
v4.ModelName = "Equinox"
v4.Icon = "rbxassetid://73572093043918"
v1.Egg = table.freeze(v4)
v1.DropWeight = 0
v1.DontRoll = true
v1.WalkSound = table.freeze({
    SoundId = 127024805236306,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
v1.RandomIdleSound = table.freeze({
    SoundId = 105229098897232,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return table.freeze(v1)
