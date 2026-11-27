-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

t1.__index = t1

local profilebegin, profileend, new, new2 = debug.profilebegin, debug.profileend, Vector3.new, CFrame.new
local Angles, rad = CFrame.Angles, math.rad
local v1 = new()
local CameraShakeInstance = require(script.CameraShakeInstance)
local CameraShakeState = CameraShakeInstance.CameraShakeState

t1.CameraShakeInstance = CameraShakeInstance
t1.Presets = require(script.CameraShakePresets)

function t1.new(p1, p2) -- line: 30
    -- upvalues: t1 (copy), v1 (copy)
    assert(type(p1) == "number", "RenderPriority must be a number (e.g.: Enum.RenderPriority.Camera.Value)")
    assert(type(p2) == "function", "Callback must be a function")

    return (setmetatable({
        _running = false,
        _renderName = "CameraShaker",
        _renderPriority = p1,
        _posAddShake = v1,
        _rotAddShake = v1,
        _camShakeInstances = {},
        _removeInstances = {},
        _callback = p2
    }, t1))
end

function t1.Start(p3) -- line: 51
    -- upvalues: profilebegin (copy), profileend (copy)
    if p3._running then
        return
    end

    p3._running = true

    local _callback = p3._callback

    game:GetService("RunService"):BindToRenderStep(p3._renderName, p3._renderPriority, function(p4) -- line: 55
        -- upvalues: p3 (copy), _callback (copy), profilebegin (copy), profileend (copy)
        profilebegin("CameraShakerUpdate")

        local v4 = p3:Update(p4)

        profileend()
        _callback(v4)
    end)
end

function t1.Stop(p5) -- line: 64
    if p5._running then
        game:GetService("RunService"):UnbindFromRenderStep(p5._renderName)
        p5._running = false
    end
end

function t1.StopSustained(p6, p7) -- line: 71
    for _, v5 in pairs(p6._camShakeInstances) do
        if v5.fadeOutDuration == 0 then
            v5:StartFadeOut(p7 or v5.fadeInDuration)
        end
    end
end

function t1.Update(p8, p9) -- line: 80
    -- upvalues: new2 (copy), Angles (copy), rad (copy), v1 (copy), CameraShakeState (copy)
    local v6 = v1
    local v7 = v1
    local _camShakeInstances = p8._camShakeInstances

    for i = 1, #_camShakeInstances do
        local v8 = _camShakeInstances[i]
        local State = v8:GetState()

        if State == CameraShakeState.Inactive and v8.DeleteOnInactive then
            p8._removeInstances[#p8._removeInstances + 1] = i
        elseif State ~= CameraShakeState.Inactive then
            local v9 = v8:UpdateShake(p9)

            v6 += v9 * v8.PositionInfluence
            v7 += v9 * v8.RotationInfluence
        end
    end

    for i = #p8._removeInstances, 1, -1 do
        local v10 = p8._removeInstances[i]

        table.remove(_camShakeInstances, v10)
        p8._removeInstances[i] = nil
    end

    return new2(v6) * Angles(0, rad(v7.Y), 0) * Angles(rad(v7.X), 0, (rad(v7.Z)))
end

function t1.Shake(p10, p11) -- line: 117
    assert(type(p11) == "table" and p11._camShakeInstance, "ShakeInstance must be of type CameraShakeInstance")
    p10._camShakeInstances[#p10._camShakeInstances + 1] = p11

    return p11
end

function t1.ShakeSustain(p12, p13) -- line: 124
    assert(type(p13) == "table" and p13._camShakeInstance, "ShakeInstance must be of type CameraShakeInstance")
    p12._camShakeInstances[#p12._camShakeInstances + 1] = p13
    p13:StartFadeIn(p13.fadeInDuration)

    return p13
end

function t1.ShakeOnce(p14, p15, p16, p17, p18, p19, p20) -- line: 132
    -- upvalues: CameraShakeInstance (copy)
    local v16 = CameraShakeInstance.new(p15, p16, p17, p18)

    if typeof(p19) ~= "Vector3" or not p19 then
        v16.PositionInfluence = Vector3.new(0.15, 0.15, 0.15)
    else
        v16.PositionInfluence = p19
    end

    if typeof(p20) ~= "Vector3" or not p20 then
        v16.RotationInfluence = Vector3.new(1, 1, 1)
    else
        v16.RotationInfluence = p20
    end

    p14._camShakeInstances[#p14._camShakeInstances + 1] = v16

    return v16
end

function t1.StartShake(p21, p22, p23, p24, p25, p26) -- line: 141
    -- upvalues: CameraShakeInstance (copy)
    local v17 = CameraShakeInstance.new(p22, p23, p24)

    if typeof(p25) ~= "Vector3" or not p25 then
        v17.PositionInfluence = Vector3.new(0.15, 0.15, 0.15)
    else
        v17.PositionInfluence = p25
    end

    if typeof(p26) ~= "Vector3" or not p26 then
        v17.RotationInfluence = Vector3.new(1, 1, 1)
    else
        v17.RotationInfluence = p26
    end

    v17:StartFadeIn(p24)
    p21._camShakeInstances[#p21._camShakeInstances + 1] = v17

    return v17
end

return t1
