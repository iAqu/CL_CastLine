-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local BeeEffectController = require(script.Parent.BeeEffectController)
local TrainVisuals = require(script.Parent.TrainVisuals)
local t1 = {}
local t2 = nil
local v1 = false
local v2 = false

local function humanoid() -- line: 14
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character

    return Character and Character:FindFirstChildOfClass("Humanoid")
end

local function restoreCamera(p1, p2, p3) -- line: 18
    -- upvalues: LocalPlayer (copy)
    if not (p1 and p1.Parent) then
        return
    end

    local Character = LocalPlayer.Character
    local v3 = Character and Character:FindFirstChildOfClass("Humanoid")

    if p3 then
        p1.CameraType = Enum.CameraType.Custom
    else
        if p2.Subject and p2.Subject.Parent then
            v3 = p2.Subject
        end

        p1.CameraType = p2.Type
    end

    p1.FieldOfView = p2.Fov

    if v3 then
        p1.CameraSubject = v3
    end
end

function t1.Stop(p4, p5) -- line: 26
    -- upvalues: RunService (copy), Workspace (copy), LocalPlayer (copy), BeeEffectController (copy), TrainVisuals (copy), t2 (ref), v2 (ref)
    local t3 = t2

    if not t3 or p4 and p4 ~= t3.Id then
        return
    end

    t2 = nil
    TrainVisuals.EndRide(t3.Id)

    if p5 then
        v2 = true
    end

    RunService:UnbindFromRenderStep("TrainEventRideCamera")

    if t3.Death then
        t3.Death:Disconnect()
    end

    local Camera, Saved = t3.Camera, t3.Saved
    local v4 = p5 == true

    if Camera and Camera.Parent then
        local Character = LocalPlayer.Character
        local v5 = Character and Character:FindFirstChildOfClass("Humanoid")

        if v4 then
            Camera.CameraType = Enum.CameraType.Custom
        else
            if Saved.Subject and Saved.Subject.Parent then
                v5 = Saved.Subject
            end

            Camera.CameraType = Saved.Type
        end

        Camera.FieldOfView = Saved.Fov

        if v5 then
            Camera.CameraSubject = v5
        end
    end

    local CurrentCamera = Workspace.CurrentCamera
    local t4, Humanoid

    if CurrentCamera ~= t3.Camera then
        t4 = {
            Type = Enum.CameraType.Custom,
            Fov = t3.Saved.Fov
        }

        if CurrentCamera and CurrentCamera.Parent then
            local Character = LocalPlayer.Character

            Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
            CurrentCamera.CameraType = Enum.CameraType.Custom
            CurrentCamera.FieldOfView = t4.Fov

            if Humanoid then
                CurrentCamera.CameraSubject = Humanoid
            end
        end
    end

    BeeEffectController.SetTrainCameraActive(false)
end

function t1.Begin(p6) -- line: 39
    -- upvalues: RunService (copy), Workspace (copy), LocalPlayer (copy), BeeEffectController (copy), TrainVisuals (copy), t1 (copy), t2 (ref)
    local Humanoid, v6

    if typeof(p6) == "table" then
        if typeof(p6.Id) == "string" then
            if typeof(p6.StartFocus) == "Vector3" then
                if typeof(p6.EndFocus) == "Vector3" then
                    if typeof(p6.Character) == "Instance" and p6.Character == LocalPlayer.Character then
                        local Character = LocalPlayer.Character

                        Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
                        v6 = false
                    else
                        v6 = true
                    end
                else
                    v6 = true
                end
            else
                v6 = true
            end
        else
            v6 = true
        end
    else
        v6 = true
    end

    if v6 then
        return
    end

    local CurrentCamera = Workspace.CurrentCamera
    local v7, v8

    if not Humanoid or Humanoid.Health <= 0 then
        v8 = true
    elseif CurrentCamera then
        t1.Stop()
        BeeEffectController.SetTrainCameraActive(true)
        v7 = if type(p6.Duration) == "number" then math.clamp(p6.Duration, 1, 60) else 15
        v8 = false
    else
        v8 = true
    end

    if v8 then
        return
    end

    local v9 = if p6.Mode == "Departure" then 0.5 else 1.5
    local StartFocus = p6.StartFocus
    local v10 = if p6.Mode == "Departure" then Vector3.new(70, 12, -90) else Vector3.new(74, 12, -65)
    local v11 = if p6.Mode == "Departure" then Vector3.new(74, 12, -65) else Vector3.new(70, 11, 125)

    if typeof(p6.CameraStartOffset) == "Vector3" then
        v11 = p6.CameraStartOffset
    end

    if typeof(p6.CameraEndOffset) == "Vector3" then
        v10 = p6.CameraEndOffset
    end

    local v12 = if typeof(p6.ViewRotation) == "CFrame" then p6.ViewRotation else CFrame.identity
    local v13 = v12:VectorToWorldSpace(v10)
    local v14 = v12:VectorToWorldSpace(v11)
    local v15 = p6.EndFocus + v13
    local v16 = CFrame.lookAt(StartFocus + v14, StartFocus)
    local t5 = {
        Id = p6.Id,
        Character = p6.Character,
        Camera = CurrentCamera,
        Saved = {
            Type = CurrentCamera.CameraType,
            Subject = CurrentCamera.CameraSubject,
            Fov = CurrentCamera.FieldOfView
        },
        Started = os.clock(),
        Duration = v7,
        Focus = StartFocus,
        Shot = v16,
        Fixed = v16
    }

    if p6.Private then
        t5.Visual = TrainVisuals.BeginRide(p6)
    end

    t2 = t5
    CurrentCamera.CameraType = Enum.CameraType.Scriptable
    CurrentCamera.FieldOfView = 60
    CurrentCamera.CFrame = v16
    CurrentCamera.Focus = CFrame.new(StartFocus)
    t5.Death = Humanoid.Died:Connect(function() -- line: 67
        -- upvalues: t5 (copy), t1 (copy)
        t1.Stop(t5.Id, true)
    end)
    RunService:BindToRenderStep("TrainEventRideCamera", Enum.RenderPriority.Camera.Value + 1, function(p7) -- line: 68
        -- upvalues: p6 (copy), CurrentCamera (copy), Humanoid (ref), StartFocus (copy), v14 (copy), v15 (copy), t5 (copy), v7 (ref), v9 (copy), Workspace (copy), LocalPlayer (copy), t1 (copy), t2 (ref)
        if t2 ~= t5 then
            return
        end

        if LocalPlayer.Character ~= t5.Character or Humanoid.Health <= 0 or Workspace.CurrentCamera ~= CurrentCamera or os.clock() - t5.Started > v7 + 10 then
            t1.Stop(t5.Id, true)

            return
        end

        if CurrentCamera.CameraType ~= Enum.CameraType.Scriptable then
            t1.Stop(t5.Id)

            return
        end

        local v18 = os.clock() - t5.Started
        local v19 = t5.Visual or p6.Train

        if typeof(v19) ~= "Instance" or not v19:IsA("Model") or not v19.Parent then
            local TrainEventRuntime = Workspace:FindFirstChild("TrainEventRuntime")

            v19 = TrainEventRuntime and TrainEventRuntime:FindFirstChild(p6.TrainName or "GhostTrainArrival")
        end

        local v21 = p6.StartFocus:Lerp(p6.EndFocus, (math.clamp(v18 / v7, 0, 1)))
        local TrainEventVisuals = Workspace:FindFirstChild("TrainEventVisuals")
        local v22 = TrainEventVisuals and TrainEventVisuals:FindFirstChild(p6.TrainName or "GhostTrainArrival")

        if not p6.Private and v22 and v22:IsA("Model") then
            v19 = v22
        end

        if v19 and v19:IsA("Model") and v19.PrimaryPart then
            v21 = v19.PrimaryPart.Position + Vector3.new(0, 6, 0)
        end

        local v24 = 1 - math.exp(-math.min(p7, 0.1) * 5)

        t5.Focus = t5.Focus:Lerp(v21, v24)

        local v26 = math.clamp(v18 / v7, 0, 1)
        local v27 = (StartFocus + v14):Lerp(v15, v26)
        local v28 = CFrame.lookAt(v27, t5.Focus)
        local v30 = math.clamp((v18 - v9) / 1.2, 0, 1)
        local v31 = v30 * v30 * (3 - v30 * 2)

        CurrentCamera.CFrame = t5.Fixed:Lerp(v28, v31)
        CurrentCamera.Focus = CFrame.new(if v31 == 0 then StartFocus else t5.Focus)
    end)
end

function t1.Start() -- line: 95
    -- upvalues: Workspace (copy), LocalPlayer (copy), t1 (copy), t2 (ref), v1 (ref), v2 (ref)
    if v1 then
        return
    end

    v1 = true
    LocalPlayer.CharacterRemoving:Connect(function() -- line: 97
        -- upvalues: t1 (copy)
        t1.Stop(nil, true)
    end)
    LocalPlayer.CharacterAdded:Connect(function(p8) -- line: 98
        -- upvalues: Workspace (copy), LocalPlayer (copy), t1 (copy), t2 (ref), v2 (ref)
        t1.Stop(nil, true)

        if not v2 then
            return
        end

        v2 = false
        task.spawn(function() -- line: 102
            -- upvalues: p8 (copy), Workspace (copy), LocalPlayer (copy), t2 (ref)
            local v33 = p8:WaitForChild("Humanoid", 5)
            local CurrentCamera = Workspace.CurrentCamera

            if v33 and LocalPlayer.Character == p8 and not t2 and CurrentCamera then
                CurrentCamera.CameraType = Enum.CameraType.Custom
                CurrentCamera.CameraSubject = v33
            end
        end)
    end)
    LocalPlayer:GetAttributeChangedSignal("TrainEventPhase"):Connect(function() -- line: 111
        -- upvalues: LocalPlayer (copy), t1 (copy)
        if LocalPlayer:GetAttribute("TrainEventPhase") == nil then
            t1.Stop()
        end
    end)
    Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 114
        -- upvalues: Workspace (copy), t1 (copy), t2 (ref)
        if t2 and Workspace.CurrentCamera ~= t2.Camera then
            t1.Stop(nil, true)
        end
    end)
    script.Destroying:Connect(function() -- line: 117
        -- upvalues: t1 (copy)
        t1.Stop(nil, true)
    end)
end

return t1
