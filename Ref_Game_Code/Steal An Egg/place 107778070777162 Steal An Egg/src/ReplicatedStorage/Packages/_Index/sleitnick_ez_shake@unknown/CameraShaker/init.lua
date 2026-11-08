-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")

game:GetService("ReplicatedStorage")

local t = require(game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("t"))
local CameraShakeInstance = require(script.CameraShakeInstance)
local CameraShakePresets = require(script.CameraShakePresets)
local profilebegin, profileend = debug.profilebegin, debug.profileend
local n1 = 0
local new, new2, Angles, rad = Vector3.new, CFrame.new, CFrame.Angles, math.rad
local v1 = new()
local CameraShakeState = CameraShakeInstance.CameraShakeState
local Value = Enum.RenderPriority.Last.Value
local CurrentCamera = workspace.CurrentCamera
local t1 = {}

t1.__index = t1
t1.CameraShakeInstance = CameraShakeInstance
t1.Presets = CameraShakePresets

local function defaultCallback(p1) -- line: 85
    -- upvalues: CurrentCamera (copy)
    CurrentCamera.CFrame *= p1
end

function t1.new(p2, p3, p4) -- line: 121
    -- upvalues: t (copy), v1 (copy), Value (copy), t1 (copy), defaultCallback (copy)
    t.strict(t.optional(t.number))(p2)
    t.strict(t.optional(t.callback))(p3)

    return (setmetatable({
        _running = false,
        _driftConn = nil,
        _renderName = t1.NextRenderName(),
        _renderPriority = p2 or Value,
        _posAddShake = v1,
        _rotAddShake = v1,
        _camShakeInstances = {},
        _removeInstances = {},
        _callback = p3 or defaultCallback,
        _optimizeDrift = p4 or false,
        _renderBindings = {},
        _renderDriftConnections = {}
    }, t1))
end

function t1.NextRenderName() -- line: 153
    -- upvalues: n1 (ref)
    n1 += 1

    return ("__shake_%.4i__"):format(n1)
end

function t1.Start(p5, p6) -- line: 158
    -- upvalues: RunService (copy), t (copy), profilebegin (copy), profileend (copy), CurrentCamera (copy)
    if p5._running then
        return
    end

    t.strict(t.optional(t.string))(p6)
    p5._running = true
    p6 = p6 or p5._renderName

    local _callback = p5._callback
    local CFrame

    RunService:BindToRenderStep(p6, p5._renderPriority, function(p7) -- line: 170
        -- upvalues: p5 (copy), _callback (copy), CFrame (ref), profilebegin (copy), profileend (copy), CurrentCamera (copy)
        CFrame = CurrentCamera.CFrame
        profilebegin("CameraShakerUpdate")

        local v3 = p5:Update(p7)

        profileend()
        _callback(v3)
    end)
    p5._renderBindings[p6] = true

    if p5._optimizeDrift then
        p5._renderDriftConnections[p6] = RunService.Heartbeat:Connect(function() -- line: 186
            -- upvalues: CFrame (ref), CurrentCamera (copy)
            if CFrame then
                CurrentCamera.CFrame = CFrame
            end
        end)
    end
end

function t1.StopByRenderName(p8, p9) -- line: 194
    -- upvalues: RunService (copy), t (copy)
    t.strict(t.string)(p9)
    assert(p8._renderBindings[p9], (("Attempt to remove an unBinded render name: \"%*\""):format(p9)))

    local v6 = p8._renderDriftConnections[p9]

    if v6 then
        v6:Disconnect()
        p8._renderDriftConnections[p9] = nil
    end

    p8._renderBindings[p9] = nil
    RunService:UnbindFromRenderStep(p9)
end

function t1.Stop(p10) -- line: 208
    if p10._running then
        p10._running = false

        for v7 in p10._renderBindings do
            p10:StopByRenderName(v7)
        end
    end
end

function t1.StopSustained(p11, p12) -- line: 219
    for _, v8 in pairs(p11._camShakeInstances) do
        if v8.fadeOutDuration == 0 then
            v8:StartFadeOut(p12 or v8.fadeInDuration)
        end
    end
end

function t1.Update(p13, p14) -- line: 227
    -- upvalues: new2 (copy), Angles (copy), rad (copy), v1 (copy), CameraShakeState (copy)
    local v9 = v1
    local v10 = v1
    local _camShakeInstances = p13._camShakeInstances

    for i = 1, #_camShakeInstances do
        local v11 = _camShakeInstances[i]
        local State = v11:GetState()

        if State == CameraShakeState.Inactive and v11.DeleteOnInactive then
            p13._removeInstances[#p13._removeInstances + 1] = i
        elseif State ~= CameraShakeState.Inactive then
            local v12 = v11:UpdateShake(p14)

            v9 += v12 * v11.PositionInfluence
            v10 += v12 * v11.RotationInfluence
        end
    end

    for i = #p13._removeInstances, 1, -1 do
        local v13 = p13._removeInstances[i]

        table.remove(_camShakeInstances, v13)
        p13._removeInstances[i] = nil
    end

    return new2(v9) * Angles(0, rad(v10.Y), 0) * Angles(rad(v10.X), 0, (rad(v10.Z)))
end

function t1.Shake(p15, p16) -- line: 257
    assert(type(p16) == "table" and p16._camShakeInstance, "ShakeInstance must be of type CameraShakeInstance")
    p15._camShakeInstances[#p15._camShakeInstances + 1] = p16

    return p16
end

function t1.ShakeFromPresetName(p17, p18) -- line: 268
    -- upvalues: t (copy), CameraShakePresets (copy)
    t.strict(t.string)(p18)

    return p17:Shake(CameraShakePresets[p18])
end

function t1.ShakeSustain(p19, p20) -- line: 278
    assert(type(p20) == "table" and p20._camShakeInstance, "ShakeInstance must be of type CameraShakeInstance")
    p19._camShakeInstances[#p19._camShakeInstances + 1] = p20
    p20:StartFadeIn(p20.fadeInDuration)

    return p20
end

function t1.ShakeOnce(p21, p22, p23, p24, p25, p26, p27) -- line: 290
    -- upvalues: CameraShakeInstance (copy)
    local v19 = CameraShakeInstance.new(p22, p23, p24, p25)

    if typeof(p26) ~= "Vector3" or not p26 then
        v19.PositionInfluence = Vector3.new(0.15, 0.15, 0.15)
    else
        v19.PositionInfluence = p26
    end

    if typeof(p27) ~= "Vector3" or not p27 then
        v19.RotationInfluence = Vector3.new(1, 1, 1)
    else
        v19.RotationInfluence = p27
    end

    p21._camShakeInstances[#p21._camShakeInstances + 1] = v19

    return v19
end

function t1.StartShake(p28, p29, p30, p31, p32, p33) -- line: 308
    -- upvalues: CameraShakeInstance (copy)
    local v20 = CameraShakeInstance.new(p29, p30, p31)

    if typeof(p32) ~= "Vector3" or not p32 then
        v20.PositionInfluence = Vector3.new(0.15, 0.15, 0.15)
    else
        v20.PositionInfluence = p32
    end

    if typeof(p33) ~= "Vector3" or not p33 then
        v20.RotationInfluence = Vector3.new(1, 1, 1)
    else
        v20.RotationInfluence = p33
    end

    v20:StartFadeIn(p31)
    p28._camShakeInstances[#p28._camShakeInstances + 1] = v20

    return v20
end

return t1
