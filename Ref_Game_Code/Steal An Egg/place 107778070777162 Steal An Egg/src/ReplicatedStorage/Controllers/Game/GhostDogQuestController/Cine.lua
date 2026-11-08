-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Fx = require(script.Parent.Fx)

require(ReplicatedStorage.Packages.Trove)

local LocalPlayer = Players.LocalPlayer
local t1 = {
    DialogueFov = 50
}
local v1

local function flatUnit(p1, p2) -- line: 33
    local v2 = p1 * Vector3.new(1, 0, 1)

    if v2.Magnitude > 0.05 then
        return v2.Unit
    end

    return p2
end

function t1.Unclip(p3, p4, p5) -- line: 38
    -- upvalues: Workspace (copy), LocalPlayer (copy)
    local v3 = RaycastParams.new()

    v3.FilterType = Enum.RaycastFilterType.Exclude

    local t2 = {}

    if LocalPlayer.Character then
        table.insert(t2, LocalPlayer.Character)
    end

    for _, v4 in p5 or {} do
        table.insert(t2, v4)
    end

    v3.FilterDescendantsInstances = t2

    local v5 = p4 - p3
    local v6 = Workspace:Raycast(p3, v5, v3)

    if v6 == nil then
        return p4
    end

    local v8 = math.max((v6.Position - p3).Magnitude - 0.6, 1)

    return p3 + v5.Unit * v8
end

function t1.OverShoulder(p6, p7, p8) -- line: 58
    -- upvalues: t1 (copy)
    p8 = p8 or {}

    local v10 = (p7 - p6) * Vector3.new(1, 0, 1)
    local v11 = if v10.Magnitude > 0.05 then v10.Unit else Vector3.new(0, 0, 1)
    local v12 = v11:Cross((Vector3.new(0, 1, 0)))
    local v15 = p6 - v11 * (p8.Back or 6) + v12 * (p8.Side or 2) + Vector3.new(0, p8.Lift or 0.6, 0)
    local v16 = t1.Unclip(p6 + Vector3.new(0, 0.5, 0), v15, p8.Exclude)

    return CFrame.lookAt(v16, p7)
end

function t1.Close(p9, p10, p11, p12, p13, p14) -- line: 70
    -- upvalues: t1 (copy)
    local v17 = (p10 - p9) * Vector3.new(1, 0, 1)
    local v18 = if v17.Magnitude > 0.05 then v17.Unit else Vector3.new(0, 0, 1)
    local v19 = p9 + v18:Cross((Vector3.new(0, 1, 0))) * p11 + v18 * p12 + Vector3.new(0, p13, 0)
    local v20 = t1.Unclip(p9, v19, p14)

    return CFrame.lookAt(v20, p10)
end

function t1.TwoShot(p15, p16, p17, p18, p19, p20) -- line: 85
    -- upvalues: t1 (copy)
    local v21 = (p16 - p15) * Vector3.new(1, 0, 1)
    local v22 = (if v21.Magnitude > 0.05 then v21.Unit else Vector3.new(0, 0, 1)):Cross((Vector3.new(0, 1, 0)))
    local v23 = (p15 + p16) * 0.5
    local v24 = v23 + v22 * p17 * p18 + Vector3.new(0, p19, 0)
    local v25 = t1.Unclip(v23, v24, p20)

    return CFrame.lookAt(v25, v23)
end

function t1.Hold() -- line: 101
    -- upvalues: v1 (ref)
    v1 = 70
end

function t1.RestingFov() -- line: 105
    -- upvalues: v1 (ref)
    return v1 or 70
end

function t1.Settle(p21) -- line: 109
    -- upvalues: Workspace (copy), Fx (copy), v1 (ref)
    local v26 = v1

    v1 = nil

    if v26 == nil then
        return
    end

    local CurrentCamera = Workspace.CurrentCamera
    local v27 = p21 <= 0
    local v28 = if not v27 then math.abs(CurrentCamera.FieldOfView - v26) < 0.05 else nil

    if v27 or v28 then
        CurrentCamera.FieldOfView = v26
    else
        Fx.Tween(CurrentCamera, p21, {
            FieldOfView = v26
        }, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    end
end

function t1.Blend(p22, p23, p24) -- line: 129
    -- upvalues: Workspace (copy), Fx (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local CFrame, FieldOfView = CurrentCamera.CFrame, CurrentCamera.FieldOfView

    p24 = p24 or FieldOfView

    local elapsed = os.clock()

    while true do
        local v32 = math.min((os.clock() - elapsed) / p23, 1)
        local v33 = Fx.Ease(v32, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

        CurrentCamera.CFrame = CFrame:Lerp(p22, v33)
        CurrentCamera.FieldOfView = FieldOfView + (p24 - FieldOfView) * v33

        if v32 >= 1 then
            break
        end

        task.wait()
    end
end

function t1.Cut(p25, p26) -- line: 147
    -- upvalues: Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera

    CurrentCamera.CFrame = p25

    if p26 then
        CurrentCamera.FieldOfView = p26
    end
end

function t1.SpeedLens(p27, p28, p29) -- line: 155
    local v34
    local n1 = 0
    local v35 = p29 or 8

    return function(p30, p31, p32) -- line: 163
        -- upvalues: p27 (copy), p28 (copy), v34 (ref), n1 (ref), v35 (copy)
        local v36 = if not (v34 and p31 > 0) then 0 else (p30 - v34).Magnitude / p31

        v34 = p30

        local v38 = math.min(v36 * p27, p28)
        local v39 = n1

        n1 = v39 + (v38 - n1) * (1 - math.exp(-math.max(p31, 0) * v35))

        return p32 + n1
    end
end

function t1.Take(p33) -- line: 172
    -- upvalues: Workspace (copy), t1 (copy)
    local CurrentCamera = Workspace.CurrentCamera

    CurrentCamera.CameraType = Enum.CameraType.Scriptable
    p33:Add(function() -- line: 175
        -- upvalues: CurrentCamera (copy), t1 (copy)
        CurrentCamera.FieldOfView = t1.RestingFov()
    end)

    return CurrentCamera
end

function t1.Release(p34, p35) -- line: 181
    -- upvalues: Workspace (copy), t1 (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local v42 = p35.CFrame.LookVector * Vector3.new(1, 0, 1)
    local v43 = if v42.Magnitude > 0.05 then v42.Unit else Vector3.new(0, 0, 1)
    local v44 = CFrame.lookAt(p35.Position - v43 * 12 + Vector3.new(0, 4.5, 0), p35.Position + Vector3.new(0, 1.5, 0))

    t1.Blend(v44, 0.6, t1.RestingFov())
    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.CameraSubject = p34
    CurrentCamera.CFrame = v44
end

return table.freeze(t1)
