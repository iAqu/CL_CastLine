-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1 = table.clone(require(script.Parent.ArchAngel))

v1._id = "Aetheron"
v1.DisplayName = "Aetheron"
v1.Icon = "rbxassetid://116718586319869"
v1.EarningRate = 6.9E+09
v1.ModelWeight = 120000

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
local v2 = "rbxassetid://97205108103704"

local function setAnimationId() -- line: 12
    -- upvalues: Animation (copy), v2 (copy)
    Animation.AnimationId = v2
end

if not pcall(setAnimationId) then
    warn("Animation rbxassetid://97205108103704 is not shared with this experience")
end

t1.Idle = Animation

local Animation2 = Instance.new("Animation")
local v3 = "rbxassetid://81153625252167"

local function setAnimationId2() -- line: 12
    -- upvalues: Animation2 (copy), v3 (copy)
    Animation2.AnimationId = v3
end

if not pcall(setAnimationId2) then
    warn("Animation rbxassetid://81153625252167 is not shared with this experience")
end

t1.Walk = Animation2
v1.Animations = freeze(t1)
v1.BaseModelColor = Color3.fromRGB(255, 48, 12)
v1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.fromRGB(255, 48, 12),
        850
    }),
    table.freeze({
        Color3.fromRGB(255, 120, 30),
        90
    }),
    table.freeze({
        Color3.fromRGB(158, 28, 28),
        48
    }),
    table.freeze({
        Color3.fromRGB(255, 255, 255),
        12
    })
})

local v4 = table.clone(v1.Egg)

v4.DisplayName = "Aetheron Egg"
v4.ModelName = "Aetheron"
v4.Icon = "rbxassetid://98329267204643"
v1.Egg = table.freeze(v4)
v1.DropWeight = 0
v1.DontRoll = true
v1.WalkSound = table.freeze({
    SoundId = 89464015548692,
    Data = table.freeze({
        Looped = true,
        MaxDistance = 20,
        Speed = 1,
        Volume = 1.5
    })
})
v1.RandomIdleSound = table.freeze({
    SoundId = 120804583549199,
    Data = table.freeze({
        MaxDistance = 20,
        Volume = 1.5
    })
})

return table.freeze(v1)
