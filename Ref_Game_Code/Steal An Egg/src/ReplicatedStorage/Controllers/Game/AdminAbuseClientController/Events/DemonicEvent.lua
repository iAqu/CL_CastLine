-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local LocalPlayer = Players.LocalPlayer
local v1 = false
local v2

local function resolveMarker() -- line: 39
    -- upvalues: Workspace (copy)
    local World = Workspace:FindFirstChild("World")
    local Areas = World and World:FindFirstChild("Areas")
    local AdminAbuseEggSpawn = Areas and Areas:FindFirstChild("AdminAbuseEggSpawn")

    return if AdminAbuseEggSpawn ~= nil and AdminAbuseEggSpawn:IsA("BasePart") then AdminAbuseEggSpawn else nil
end

local function restoreCamera() -- line: 50
    -- upvalues: Workspace (copy), LocalPlayer (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil then
        return
    end

    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.FieldOfView = 70

    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if Humanoid ~= nil then
        CurrentCamera.CameraSubject = Humanoid
    end
end

local function stopCutscene() -- line: 66
    -- upvalues: Workspace (copy), LocalPlayer (copy), v1 (ref), v2 (ref)
    if not v1 then
        return
    end

    v1 = false

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera ~= nil then
        CurrentCamera.CameraType = Enum.CameraType.Custom
        CurrentCamera.FieldOfView = 70

        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

        if Humanoid ~= nil then
            CurrentCamera.CameraSubject = Humanoid
        end
    end

    local v3 = v2

    v2 = nil

    if v3 ~= nil then
        v3()
    end
end

local function resolveEggShot(p1) -- line: 80
    local Facing = p1:GetAttribute("Facing")
    local Finish = p1:GetAttribute("Finish")

    if typeof(Facing) ~= "Vector3" or typeof(Finish) ~= "Vector3" then
        return nil
    end

    local v4 = Vector3.new(Facing.X, 0, Facing.Z)

    if v4.Magnitude <= 0 then
        return nil
    end

    local BoundingBox, BoundingBox2 = p1:GetBoundingBox()
    local v5 = Finish + (BoundingBox.Position - p1:GetPivot().Position)
    local v6 = BoundingBox2.Y / 0.8 * 0.5 / 0.22169466264293988
    local v7 = (v4.Unit * 0.9945218953682733 + Vector3.new(0, 0.104528464, 0)) * v6

    return CFrame.lookAt(v5 + v7, v5)
end

local function startCutscene() -- line: 103
    -- upvalues: RunService (copy), TweenService (copy), Workspace (copy), HiddenUIHandler (copy), v1 (ref), v2 (ref), resolveEggShot (copy)
    if v1 then
        return
    end

    local World = Workspace:FindFirstChild("World")
    local Areas = World and World:FindFirstChild("Areas")
    local AdminAbuseEggSpawn = Areas and Areas:FindFirstChild("AdminAbuseEggSpawn")

    if AdminAbuseEggSpawn == nil or not AdminAbuseEggSpawn:IsA("BasePart") then
        AdminAbuseEggSpawn = nil
    end

    local CurrentCamera = Workspace.CurrentCamera

    if AdminAbuseEggSpawn == nil or CurrentCamera == nil then
        return
    end

    v2 = HiddenUIHandler.Acquire()
    v1 = true
    CurrentCamera.CameraType = Enum.CameraType.Scriptable
    TweenService:Create(CurrentCamera, TweenInfo.new(2), {
        FieldOfView = 80
    }):Play()

    local v8 = AdminAbuseEggSpawn.Position + Vector3.new(0, 165, 0)
    local v9 = AdminAbuseEggSpawn.Position + Vector3.new(-200, 25, 0)
    local v10 = CFrame.lookAt(v9, v8)

    CurrentCamera.CFrame = v10
    task.spawn(function() -- line: 126
        -- upvalues: CurrentCamera (copy), v10 (copy), RunService (copy), Workspace (copy), v1 (ref), resolveEggShot (copy)
        while v1 do
            local v11 = RunService.RenderStepped:Wait()

            if not v1 then
                break
            end

            CurrentCamera.CameraType = Enum.CameraType.Scriptable

            local AdminAbuseEggDrop = Workspace:FindFirstChild("AdminAbuseEggDrop")

            if AdminAbuseEggDrop ~= nil then
                if AdminAbuseEggDrop:IsA("Model") then
                    local v12 = resolveEggShot(AdminAbuseEggDrop)

                    if v12 ~= nil then
                        if AdminAbuseEggDrop:GetAttribute("Done") then
                            local v14 = math.clamp(v11 * 2.5, 0, 1)

                            CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(v12, v14)
                            CurrentCamera.FieldOfView += (25 - CurrentCamera.FieldOfView) * v14
                        else
                            local Position = AdminAbuseEggDrop:GetPivot().Position
                            local Start = AdminAbuseEggDrop:GetAttribute("Start")
                            local Finish = AdminAbuseEggDrop:GetAttribute("Finish")
                            local v15 = Start.Y - Finish.Y
                            local v16 = if v15 > 0 then 1 - (Position.Y - Finish.Y) / v15 else 1

                            CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(CFrame.lookAt(v12.Position, Position), (math.clamp(v11 * 2, 0, 1)))
                            CurrentCamera.FieldOfView = math.lerp(80, 25, (math.clamp(v16, 0, 1)))
                        end
                    else
                        CurrentCamera.CFrame = v10
                    end
                else
                    CurrentCamera.CFrame = v10
                end
            else
                CurrentCamera.CFrame = v10
            end
        end
    end)
end

local function onPhaseChanged() -- line: 170
    -- upvalues: Workspace (copy), LocalPlayer (copy), v1 (ref), v2 (ref), startCutscene (copy)
    if Workspace:GetAttribute("AdminAbusePhase") == "Cutscene" then
        startCutscene()
    elseif v1 then
        v1 = false

        local CurrentCamera = Workspace.CurrentCamera

        if CurrentCamera ~= nil then
            CurrentCamera.CameraType = Enum.CameraType.Custom
            CurrentCamera.FieldOfView = 70

            local Character = LocalPlayer.Character
            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

            if Humanoid ~= nil then
                CurrentCamera.CameraSubject = Humanoid
            end
        end

        local v20 = v2

        v2 = nil

        if v20 ~= nil then
            v20()
        end
    end
end

local t1 = {
    StartEvent = function(_, _, _) -- StartEvent | line: 182
    end,
    StopEvent = function(_) -- StopEvent | line: 184
        -- upvalues: Workspace (copy), LocalPlayer (copy), v1 (ref), v2 (ref)
        if not v1 then
            return
        end

        v1 = false

        local CurrentCamera = Workspace.CurrentCamera

        if CurrentCamera ~= nil then
            CurrentCamera.CameraType = Enum.CameraType.Custom
            CurrentCamera.FieldOfView = 70

            local Character = LocalPlayer.Character
            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

            if Humanoid ~= nil then
                CurrentCamera.CameraSubject = Humanoid
            end
        end

        local v21 = v2

        v2 = nil

        if v21 ~= nil then
            v21()
        end
    end
}

Workspace:GetAttributeChangedSignal("AdminAbusePhase"):Connect(onPhaseChanged)
LocalPlayer.CharacterAdded:Connect(function() -- line: 187
    -- upvalues: Workspace (copy), LocalPlayer (copy), v1 (ref)
    if v1 then
        return
    end

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil then
        return
    end

    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.FieldOfView = 70

    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if Humanoid ~= nil then
        CurrentCamera.CameraSubject = Humanoid
    end
end)

if Workspace:GetAttribute("AdminAbusePhase") == "Cutscene" then
    startCutscene()
elseif v1 then
    v1 = false

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera ~= nil then
        CurrentCamera.CameraType = Enum.CameraType.Custom
        CurrentCamera.FieldOfView = 70

        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

        if Humanoid ~= nil then
            CurrentCamera.CameraSubject = Humanoid
        end
    end

    local v22 = v2

    v2 = nil

    if v22 ~= nil then
        v22()
    end
end

return t1
