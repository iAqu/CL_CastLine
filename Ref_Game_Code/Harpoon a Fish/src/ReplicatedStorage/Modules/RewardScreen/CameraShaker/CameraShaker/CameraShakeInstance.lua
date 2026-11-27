-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

t1.__index = t1

local new, noise = Vector3.new, math.noise

t1.CameraShakeState = {
    FadingIn = 0,
    FadingOut = 1,
    Sustained = 2,
    Inactive = 3
}

function t1.new(p1, p2, p3, p4) -- line: 21
    -- upvalues: t1 (copy), new (copy)
    local v1 = if p3 == nil then 0 else p3
    local v2 = if p4 == nil then 0 else p4

    assert(type(p1) == "number", "Magnitude must be a number")
    assert(type(p2) == "number", "Roughness must be a number")
    assert(type(v1) == "number", "FadeInTime must be a number")
    assert(type(v2) == "number", "FadeOutTime must be a number")

    return (setmetatable({
        DeleteOnInactive = true,
        roughMod = 1,
        magnMod = 1,
        _camShakeInstance = true,
        Magnitude = p1,
        Roughness = p2,
        PositionInfluence = new(),
        RotationInfluence = new(),
        fadeOutDuration = v2,
        fadeInDuration = v1,
        sustain = v1 > 0,
        currentFadeTime = v1 > 0 and 0 or 1,
        tick = Random.new():NextNumber(-100, 100)
    }, t1))
end

function t1.UpdateShake(p5, p6) -- line: 52
    -- upvalues: new (copy), noise (copy)
    local tick, currentFadeTime = p5.tick, p5.currentFadeTime
    local v10 = new(noise(tick, 0) * 0.5, noise(0, tick) * 0.5, noise(tick, tick) * 0.5)

    if p5.fadeInDuration > 0 and p5.sustain then
        if currentFadeTime < 1 then
            currentFadeTime += p6 / p5.fadeInDuration
        elseif p5.fadeOutDuration > 0 then
            p5.sustain = false
        end
    end

    if not p5.sustain then
        currentFadeTime -= p6 / p5.fadeOutDuration
    end

    if p5.sustain then
        p5.tick = tick + p6 * p5.Roughness * p5.roughMod
    else
        p5.tick = tick + p6 * p5.Roughness * p5.roughMod * currentFadeTime
    end

    p5.currentFadeTime = currentFadeTime

    return v10 * p5.Magnitude * p5.magnMod * currentFadeTime
end

function t1.StartFadeOut(p7, p8) -- line: 88
    if p8 == 0 then
        p7.currentFadeTime = 0
    end

    p7.fadeOutDuration = p8
    p7.fadeInDuration = 0
    p7.sustain = false
end

function t1.StartFadeIn(p9, p10) -- line: 98
    if p10 == 0 then
        p9.currentFadeTime = 1
    end

    p9.fadeInDuration = p10 or p9.fadeInDuration
    p9.fadeOutDuration = 0
    p9.sustain = true
end

function t1.GetScaleRoughness(p11) -- line: 108
    return p11.roughMod
end

function t1.SetScaleRoughness(p12, p13) -- line: 113
    p12.roughMod = p13
end

function t1.GetScaleMagnitude(p14) -- line: 118
    return p14.magnMod
end

function t1.SetScaleMagnitude(p15, p16) -- line: 123
    p15.magnMod = p16
end

function t1.GetNormalizedFadeTime(p17) -- line: 128
    return p17.currentFadeTime
end

function t1.IsShaking(p18) -- line: 133
    if p18.currentFadeTime > 0 then
        return true
    end

    return p18.sustain
end

function t1.IsFadingOut(p19) -- line: 138
    return not p19.sustain and p19.currentFadeTime > 0
end

function t1.IsFadingIn(p20) -- line: 143
    if p20.currentFadeTime < 1 then
        return p20.sustain and p20.fadeInDuration > 0
    end

    return false
end

function t1.GetState(p21) -- line: 148
    -- upvalues: t1 (copy)
    if p21:IsFadingIn() then
        return t1.CameraShakeState.FadingIn
    end

    if p21:IsFadingOut() then
        return t1.CameraShakeState.FadingOut
    end

    if p21:IsShaking() then
        return t1.CameraShakeState.Sustained
    end

    return t1.CameraShakeState.Inactive
end

return t1
