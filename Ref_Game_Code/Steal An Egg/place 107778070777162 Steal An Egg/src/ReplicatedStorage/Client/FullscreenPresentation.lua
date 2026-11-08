-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local GameAudioMute = require(ReplicatedStorage.Client.GameAudioMute)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local t1 = {}
local LocalPlayer = Players.LocalPlayer
local t2 = nil

local function watchingCFrame(p1, p2) -- line: 17
    local ViewportSize = p1.ViewportSize
    local v2 = math.max(ViewportSize.X, 1) / math.max(ViewportSize.Y, 1)
    local v4 = math.tan(math.rad(p1.FieldOfView) / 2)
    local v7 = math.max(p2.Size.Y / 2 / v4, p2.Size.X / 2 / v4 / v2) * 1.05

    return CFrame.lookAt(p2.Position + p2.CFrame.LookVector * v7, p2.Position)
end

function t1.Open(p3, p4, p5) -- line: 25
    -- upvalues: RunService (copy), TweenService (copy), UserInputService (copy), Workspace (copy), GameAudioMute (copy), HiddenUIHandler (copy), Signal (copy), Tabs (copy), LocalPlayer (copy), t2 (ref), watchingCFrame (copy)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local CurrentCamera = Workspace.CurrentCamera
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")

    if t2
        or not Humanoid
        or Humanoid.Health <= 0
        or not CurrentCamera
        or not PlayerGui
        or not p3:IsDescendantOf(Workspace)
        or not p4:IsDescendantOf(p3)
        or CurrentCamera.CameraType == Enum.CameraType.Scriptable
        or HiddenUIHandler.IsHidden()
        or Tabs.IsActive() then
        return nil
    end

    local t3 = {
        Closed = Signal.new()
    }
    local t4 = {}
    local v8, clone, v9, v10
    local CameraType, CameraSubject, CFrame, Focus = CurrentCamera.CameraType, CurrentCamera.CameraSubject, CurrentCamera.CFrame, CurrentCamera.Focus
    local v11 = false
    local v12 = true
    local v13 = watchingCFrame(CurrentCamera, p4)

    t2 = t3

    function t3.Close() -- line: 60
        -- upvalues: CurrentCamera (copy), t3 (copy), t4 (copy), v8 (ref), clone (ref), v9 (ref), v10 (ref), CameraType (copy), CameraSubject (copy), CFrame (copy), Focus (copy), v11 (ref), v12 (ref), Workspace (copy), t2 (ref)
        if v11 then
            return
        end

        v11 = true

        if t2 == t3 then
            t2 = nil
        end

        for _, v14 in t4 do
            v14:Disconnect()
        end

        if v8 then
            v8:Cancel()
            v8:Destroy()
        end

        if clone then
            clone:Destroy()
        end

        if v12 and CurrentCamera.Parent and Workspace.CurrentCamera == CurrentCamera and CurrentCamera.CameraType == Enum.CameraType.Scriptable and CurrentCamera.CameraSubject == CameraSubject then
            CurrentCamera.CFrame = CFrame
            CurrentCamera.Focus = Focus
            CurrentCamera.CameraType = CameraType
        end

        if v9 then
            v9()
        end

        if v10 then
            v10()
        end

        t3.Closed:Fire()
        t3.Closed:Destroy()
    end

    function t3.IsClosed() -- line: 99
        -- upvalues: v11 (ref)
        return v11
    end

    local function v15() -- line: 103
        -- upvalues: p3 (copy), p4 (copy), p5 (copy), Character (copy), CurrentCamera (copy), PlayerGui (copy), t3 (copy), t4 (copy), v8 (ref), clone (ref), v9 (ref), v10 (ref), CameraSubject (copy), v12 (ref), v13 (ref), Humanoid (copy), RunService (copy), TweenService (copy), UserInputService (copy), Workspace (copy), GameAudioMute (copy), HiddenUIHandler (copy), Tabs (copy), LocalPlayer (copy), watchingCFrame (copy)
        clone = p5:Clone()
        clone.Name = "ForbiddenIslandWatching"
        clone.ResetOnSpawn = false
        clone.DisplayOrder = math.max(p5.DisplayOrder, 100)
        clone.Enabled = true

        local Exit = clone:FindFirstChild("Exit")

        assert(Exit and Exit:IsA("GuiButton"), "ForbiddenIsland exit button is missing")
        table.insert(t4, Exit.Activated:Connect(t3.Close))
        table.insert(t4, clone.Destroying:Connect(t3.Close))
        v9 = GameAudioMute.Acquire()
        v10 = HiddenUIHandler.Acquire()
        clone.Parent = PlayerGui
        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        v8 = TweenService:Create(CurrentCamera, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
            CFrame = v13
        })
        v8:Play()
        table.insert(t4, CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 124
            -- upvalues: p4 (copy), CurrentCamera (copy), v8 (ref), v13 (ref), watchingCFrame (copy)
            v8:Cancel()
            v13 = watchingCFrame(CurrentCamera, p4)
            CurrentCamera.CFrame = v13
        end))
        table.insert(t4, CurrentCamera:GetPropertyChangedSignal("FieldOfView"):Connect(function() -- line: 132
            -- upvalues: p4 (copy), CurrentCamera (copy), v8 (ref), v13 (ref), watchingCFrame (copy)
            v8:Cancel()
            v13 = watchingCFrame(CurrentCamera, p4)
            CurrentCamera.CFrame = v13
        end))
        table.insert(t4, Humanoid.Died:Connect(t3.Close))
        table.insert(t4, LocalPlayer.CharacterRemoving:Connect(t3.Close))
        table.insert(t4, Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(t3.Close))
        table.insert(t4, p3.AncestryChanged:Connect(function() -- line: 143
            -- upvalues: p3 (copy), t3 (copy), Workspace (copy)
            if not p3:IsDescendantOf(Workspace) then
                t3.Close()
            end
        end))
        table.insert(t4, p3.Destroying:Connect(t3.Close))
        table.insert(t4, UserInputService.InputBegan:Connect(function(p6) -- line: 152
            -- upvalues: t3 (copy)
            if p6.KeyCode == Enum.KeyCode.Escape or p6.KeyCode == Enum.KeyCode.ButtonB then
                t3.Close()
            end
        end))
        table.insert(t4, Tabs.Activated:Connect(t3.Close))
        table.insert(t4, RunService.Heartbeat:Connect(function() -- line: 161
            -- upvalues: p3 (copy), p4 (copy), Character (copy), CurrentCamera (copy), PlayerGui (copy), t3 (copy), v8 (ref), clone (ref), CameraSubject (copy), v12 (ref), v13 (ref), Humanoid (copy), Workspace (copy), LocalPlayer (copy)
            local v22 = (CurrentCamera.CFrame.Position - v13.Position).Magnitude > 0.05 or CurrentCamera.CFrame.LookVector:Dot(v13.LookVector) < 0.9999 or CurrentCamera.CFrame.UpVector:Dot(v13.UpVector) < 0.9999

            if v8.PlaybackState == Enum.PlaybackState.Playing or not v22 then
                if not p3:IsDescendantOf(Workspace)
                    or not p4:IsDescendantOf(p3)
                    or clone.Parent ~= PlayerGui
                    or not clone.Enabled
                    or LocalPlayer.Character ~= Character
                    or Humanoid.Health <= 0
                    or Workspace.CurrentCamera ~= CurrentCamera
                    or CurrentCamera.CameraType ~= Enum.CameraType.Scriptable
                    or CurrentCamera.CameraSubject ~= CameraSubject then
                    t3.Close()
                end
            else
                v12 = false
                t3.Close()
            end
        end))
    end

    local traceback = debug.traceback
    local v23, v24 = xpcall(v15, traceback)

    if v23 then
        return t3
    end

    t3.Close()
    warn("ForbiddenIsland fullscreen failed", v24)

    return nil
end

return table.freeze(t1)
