-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local State = require(script.Parent.State)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local v1 = Trove.new()
local n1 = 0
local v2 = false
local v3 = false
local v4
local t1 = {
    Shake = function(p1) -- Shake | line: 27
        -- upvalues: n1 (ref)
        n1 = math.min(n1 + p1, 1)
    end
}

function t1.ShakeAt(p2, p3, p4) -- line: 31
    -- upvalues: Workspace (copy), t1 (copy)
    local Magnitude = (Workspace.CurrentCamera.CFrame.Position - p2).Magnitude

    if Magnitude < p4 then
        t1.Shake(p3 * (1 - Magnitude / p4))
    end
end

function t1.Kick(p5) -- line: 39
    -- upvalues: TweenService (copy), Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local FieldOfView = CurrentCamera.FieldOfView

    CurrentCamera.FieldOfView = FieldOfView + p5
    TweenService:Create(CurrentCamera, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {
        FieldOfView = FieldOfView
    }):Play()
end

function t1.Reveal(p6) -- line: 46
    -- upvalues: TweenService (copy), Workspace (copy), State (copy), LocalPlayer (copy), v2 (ref)
    local CurrentCamera = Workspace.CurrentCamera
    local Character = LocalPlayer.Character
    local HumanoidRootPart = if Character then Character:FindFirstChild("HumanoidRootPart") else nil

    if HumanoidRootPart == nil then
        return
    end

    v2 = true

    local v6 = State.Island()
    local Y = if v6 then v6:GetPivot().Y else HumanoidRootPart.Position.Y
    local v7 = Vector3.new(HumanoidRootPart.CFrame.LookVector.X, 0, HumanoidRootPart.CFrame.LookVector.Z)
    local v11 = Vector3.new(HumanoidRootPart.Position.X, math.max(HumanoidRootPart.Position.Y + 8, Y + 45), HumanoidRootPart.Position.Z) - v7 * 4
    local Unit = v7.Unit

    if v6 then
        local Position = v6:GetPivot().Position

        Unit = Vector3.new(Position.X - HumanoidRootPart.Position.X, 0, Position.Z - HumanoidRootPart.Position.Z).Unit
    end

    CurrentCamera.CameraType = Enum.CameraType.Scriptable

    local tween = TweenService:Create(CurrentCamera, TweenInfo.new(2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
        CFrame = CFrame.lookAt(v11, p6)
    })

    tween:Play()
    tween.Completed:Wait()
    task.wait(2.6)

    local v14 = HumanoidRootPart.Position + Vector3.new(0, 4, 0) - Unit * 12
    local tween2 = TweenService:Create(CurrentCamera, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
        CFrame = CFrame.lookAt(v14, v14 + Unit * 10 - Vector3.new(0, 1.5, 0))
    })

    tween2:Play()
    tween2.Completed:Wait()
    CurrentCamera.CameraType = Enum.CameraType.Custom
    v2 = false
end

local function pickSubject() -- line: 80
    -- upvalues: State (copy), LocalPlayer (copy)
    local v15 = State.Me()
    local Character = LocalPlayer.Character
    local Humanoid = if Character then Character:FindFirstChildOfClass("Humanoid") else nil

    if v15 and v15.State == "Alive" then
        return Humanoid
    end

    local Snapshot = State.Snapshot

    if Snapshot and v15 and v15.State == "Down" then
        local v16 = Snapshot.Crystals[v15.Team]

        if v16 and v16.Health > 0 then
            return v16.Model.Crystal.Pivot
        end
    end

    local v17

    for _, v18 in State.Entries() do
        local Model = v18.Model
        local Humanoid = if Model and v18.State == "Alive" then Model:FindFirstChildOfClass("Humanoid") else nil

        if Humanoid then
            if v15 == nil or v18.Team == v15.Team then
                return Humanoid
            end

            v17 = v17 or Humanoid
        end
    end

    return v17 or Humanoid
end

function t1.Start(p7) -- line: 108
    -- upvalues: RunService (copy), Workspace (copy), State (copy), LocalPlayer (copy), v1 (ref), n1 (ref), v2 (ref), v3 (ref), v4 (ref), pickSubject (copy)
    v1 = p7:Extend()
    n1 = 0
    v2 = false
    v3 = false
    v4 = nil
    RunService:BindToRenderStep("CursedIslandWarsShake", Enum.RenderPriority.Camera.Value + 1, function(p8) -- line: 114
        -- upvalues: Workspace (copy), State (copy), n1 (ref), v2 (ref), v3 (ref), v4 (ref), pickSubject (copy)
        local CurrentCamera = Workspace.CurrentCamera
        local v19 = State.Island()
        local v20 = State.Me()

        if not v2 and v19 then
            if State.Phase() == "SuddenDeath" and (v20 == nil or v20.State ~= "Alive") then
                local Position = v19:GetPivot().Position
                local v21 = os.clock() * 0.12

                CurrentCamera.CameraType = Enum.CameraType.Scriptable
                CurrentCamera.CFrame = CFrame.lookAt(Position + Vector3.new(math.cos(v21) * 420, 220, math.sin(v21) * 420), Position - Vector3.new(0, 10, 0))
                v3 = true
            else
                if v3 then
                    v3 = false
                    v4 = nil
                    CurrentCamera.CameraType = Enum.CameraType.Custom
                end

                local v24 = pickSubject()

                if v24 ~= v4 and v24 then
                    v4 = v24
                    CurrentCamera.CameraSubject = v24
                end
            end
        end

        if State.Phase() == "SuddenDeath" then
            n1 = math.max(n1, 0.22)
        end

        if n1 <= 0 then
            return
        end

        local v26 = n1 * n1
        local v28 = os.clock() * 30

        CurrentCamera.CFrame = CurrentCamera.CFrame * CFrame.Angles(math.rad(math.noise(v28, 1) * 3 * v26), math.rad(math.noise(v28, 2) * 3 * v26), (math.rad(math.noise(v28, 3) * 2 * v26)))

        local v35 = n1

        n1 = math.max(v35 - p8 * 1.6, 0)
    end)
    v1:Add(function() -- line: 156
        -- upvalues: RunService (copy), Workspace (copy), LocalPlayer (copy)
        RunService:UnbindFromRenderStep("CursedIslandWarsShake")

        local CurrentCamera = Workspace.CurrentCamera

        CurrentCamera.CameraType = Enum.CameraType.Custom

        local Character = LocalPlayer.Character
        local Humanoid = if Character then Character:FindFirstChildOfClass("Humanoid") else nil

        if Humanoid then
            CurrentCamera.CameraSubject = Humanoid
        end
    end)
end

return t1
