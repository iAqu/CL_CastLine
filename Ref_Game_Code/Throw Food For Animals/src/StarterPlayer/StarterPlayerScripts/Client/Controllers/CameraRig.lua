-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local t1 = {}
local CurrentCamera = Workspace.CurrentCamera
local v1 = false
local v2
local n1 = 0
local v3
local n2 = 0
local n3 = 0
local n4 = 0
local v4 = Enum.EasingStyle.Quart
local n5 = 0.6
local t2 = {}
local n6 = 70
local n7 = 0
local n8 = 70
local v5 = math.random() * 100
local v6 = CFrame.new()
local v7 = false

local function ease(p1, p2) -- line: 36
    -- upvalues: TweenService (copy)
    return TweenService:GetValue(p1, p2 or Enum.EasingStyle.Quart, Enum.EasingDirection.InOut)
end

local function evalShot(p3, p4, p5) -- line: 40
    -- upvalues: v6 (ref)
    local v8 = p5 - p4
    local v9, v10, v11 = pcall(p3, v8)

    if not v9 or typeof(v10) ~= "CFrame" then
        return v6, nil
    end

    return v10, v11
end

local function update() -- line: 48
    -- upvalues: TweenService (copy), CurrentCamera (ref), v1 (ref), v2 (ref), n1 (ref), v3 (ref), n2 (ref), n3 (ref), n4 (ref), v4 (ref), n5 (ref), t2 (ref), n6 (ref), n7 (ref), v5 (copy), v6 (ref)
    if v1 and v2 then
        local elapsed = os.clock()
        local v12 = v2
        local v13 = elapsed - n1
        local v14, v15, v16 = pcall(v12, v13)

        if not v14 or typeof(v15) ~= "CFrame" then
            v15 = v6
            v16 = nil
        end

        local v17
        local v18 = v16

        if v3 then
            local v22 = math.clamp((elapsed - n3) / math.max(n4, 0.001), 0, 1)
            local v23 = v3
            local v24 = elapsed - n2
            local v25, v26, v27 = pcall(v23, v24)

            if not v25 or typeof(v26) ~= "CFrame" then
                v26 = v6
                v27 = nil
            end

            local Value = TweenService:GetValue(v22, v4 or Enum.EasingStyle.Quart, Enum.EasingDirection.InOut)

            v17 = v26:Lerp(v15, Value)

            if not v16 or not v27 then
                if v27 then
                    v18 = v16 or v27 + (n6 - v27) * Value
                end
            else
                v18 = v27 + (v16 - v27) * Value
            end

            if v22 >= 1 then
                v3 = nil
            end
        else
            v17 = v15
        end

        if n5 > 0 then
            local v29 = elapsed * 0.35
            local v30 = (math.noise(v29, v5) - 0) * 0.02 * n5
            local v31 = (math.noise(v29 + 10, v5) - 0) * 0.025 * n5
            local v32 = (math.noise(v29 + 20, v5) - 0) * 0.008 * n5
            local v33 = math.noise(v29 * 0.7 + 30, v5) * 0.15 * n5
            local v34 = math.noise(v29 * 0.7 + 40, v5) * 0.12 * n5

            v17 = v17 * CFrame.new(v33, v34, 0) * CFrame.Angles(v30, v31, v32)
        end

        local v35 = #t2
        local n9 = 0
        local n10 = 0
        local n11 = 0
        local n12 = 0
        local n13 = 0

        for i = v35, 1, -1 do
            local v36 = t2[i]
            local v37 = elapsed - v36.Start

            if v36.Duration <= v37 then
                table.remove(t2, i)
            else
                local v38 = 1 - v37 / v36.Duration
                local v39 = v38 * v38
                local v40 = v36.Intensity * v39
                local v41 = elapsed * v36.Frequency

                n9 += math.noise(v41, v36.Seed) * 0.06 * v40
                n10 += math.noise(v41, v36.Seed + 5) * 0.06 * v40
                n11 += math.noise(v41, v36.Seed + 9) * 0.04 * v40
                n12 += math.noise(v41, v36.Seed + 13) * 0.5 * v40
                n13 += math.noise(v41, v36.Seed + 17) * 0.5 * v40
            end
        end

        local v42 = if n9 == 0 and n10 == 0 and n11 == 0 and n12 == 0 and n13 == 0 then v17 else v17 * CFrame.new(n12, n13, 0) * CFrame.Angles(n9, n10, n11)

        v6 = v42
        CurrentCamera.CFrame = v42

        local CurrentCamera2 = CurrentCamera

        CurrentCamera2.Focus = v42 * CFrame.new(0, 0, -10)

        local CurrentCamera3 = CurrentCamera

        CurrentCamera3.FieldOfView = (v18 or n6) + n7
    end
end

function t1.Take() -- line: 102
    -- upvalues: RunService (copy), Workspace (copy), CurrentCamera (ref), v1 (ref), n6 (ref), n7 (ref), n8 (ref), v7 (ref), update (copy)
    CurrentCamera = Workspace.CurrentCamera

    if not v1 then
        n8 = CurrentCamera.FieldOfView
        n6 = 70
        n7 = 0
    end

    v1 = true
    CurrentCamera.CameraType = Enum.CameraType.Scriptable

    if v7 then
        return
    end

    v7 = true
    RunService:BindToRenderStep("CinematicCamera", Enum.RenderPriority.Camera.Value + 1, update)
end

function t1.IsActive() -- line: 117
    -- upvalues: v1 (ref)
    return v1
end

function t1.Release() -- line: 121
    -- upvalues: RunService (copy), Workspace (copy), CurrentCamera (ref), v1 (ref), v2 (ref), v3 (ref), t2 (ref), n8 (ref), v7 (ref)
    if not v1 then
        return
    end

    v1 = false
    v2 = nil
    v3 = nil
    t2 = {}

    if v7 then
        v7 = false
        RunService:UnbindFromRenderStep("CinematicCamera")
    end

    CurrentCamera = Workspace.CurrentCamera
    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.FieldOfView = n8
end

function t1.SetShot(p6) -- line: 137
    -- upvalues: v2 (ref), n1 (ref), v3 (ref), update (copy)
    v2 = p6
    n1 = os.clock()
    v3 = nil
    update()
end

function t1.BlendTo(p7, p8, p9) -- line: 145
    -- upvalues: t1 (copy), CurrentCamera (ref), v2 (ref), n1 (ref), v3 (ref), n2 (ref), n3 (ref), n4 (ref), v4 (ref), n7 (ref), v6 (ref)
    if not v2 then
        t1.SetShot(p7)

        return
    end

    local elapsed = os.clock()

    if v3 then
        local v44 = v6
        local v45 = CurrentCamera.FieldOfView - n7

        v3 = function() -- line: 155
            -- upvalues: v44 (copy), v45 (copy)
            return v44, v45
        end

        n2 = elapsed
    else
        v3 = v2
        n2 = n1
    end

    v2 = p7
    n1 = elapsed
    n3 = elapsed
    n4 = p8 or 0.8
    v4 = p9 or Enum.EasingStyle.Quart
end

function t1.GetCFrame() -- line: 169
    -- upvalues: v6 (ref)
    return v6
end

function t1.SetHandheld(p10) -- line: 173
    -- upvalues: n5 (ref)
    n5 = p10 or 0.6
end

function t1.SetBaseFOV(p11) -- line: 177
    -- upvalues: n6 (ref)
    n6 = p11
end

function t1.Shake(p12, p13, p14) -- line: 181
    -- upvalues: t2 (ref)
    local t3 = t2

    table.insert(t3, {
        Intensity = p12 or 1,
        Duration = p13 or 0.4,
        Frequency = p14 or 18,
        Start = os.clock(),
        Seed = math.random() * 50
    })
end

function t1.PunchFOV(p15, p16, p17) -- line: 192
    -- upvalues: RunService (copy), TweenService (copy), Workspace (copy), v1 (ref), n7 (ref)
    local v46 = p17
    local v47 = p16 or 0.08

    v46 = p17 or 0.45

    local elapsed = os.clock()
    local connection

    connection = RunService.RenderStepped:Connect(function() -- line: 197
        -- upvalues: v47 (copy), v46 (ref), p15 (copy), elapsed (copy), connection (ref), TweenService (copy), Workspace (copy), v1 (ref), n7 (ref)
        local v48 = os.clock() - elapsed
        local n14 = 0

        if v48 < v47 then
            n14 = p15 * (v48 / v47)
        elseif v48 < v47 + v46 then
            n14 = p15 * (1 - TweenService:GetValue((v48 - v47) / v46, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
        else
            connection:Disconnect()
        end

        if v1 then
            n7 = n14
        else
            Workspace.CurrentCamera.FieldOfView = 70 + n14
        end
    end)
end

function t1.SetFOVOffset(p18) -- line: 218
    -- upvalues: n7 (ref)
    n7 = p18
end

return t1
