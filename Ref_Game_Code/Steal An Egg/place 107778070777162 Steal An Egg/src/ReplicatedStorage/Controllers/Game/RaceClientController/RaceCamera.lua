-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CameraShaker = require(ReplicatedStorage.Packages.CameraShaker)
local CameraShakerDriver = require(ReplicatedStorage.Client.CameraShakerDriver)
local MountRaceFlags = require(ReplicatedStorage.Shared.Flags.MountRaceFlags)

require(script.Parent.MountController)
require(ReplicatedStorage.Packages.Trove)

local function cameraModule() -- line: 33
    -- upvalues: Players (copy)
    local PlayerScripts = Players.LocalPlayer:FindFirstChild("PlayerScripts")
    local PlayerModule = if PlayerScripts then PlayerScripts:FindFirstChild("PlayerModule") else nil

    if PlayerModule == nil or not PlayerModule:IsA("ModuleScript") then
        return nil
    end

    return require(PlayerModule):GetCameras()
end

local function flatYaw(p1) -- line: 43
    local v1 = Vector3.new(p1.X, 0, p1.Z)

    return if not (v1.Magnitude < 0.3) then math.atan2(-v1.X, -v1.Z) else nil
end

local function wrapAngle(p2) -- line: 52
    return (p2 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
end

local t1 = {}

t1.__index = t1

function t1.Run(p3, p4, p5) -- line: 69
    -- upvalues: RunService (copy), Workspace (copy), CameraShaker (copy), CameraShakerDriver (copy), MountRaceFlags (copy), cameraModule (copy), t1 (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local CameraType, FieldOfView = CurrentCamera.CameraType, CurrentCamera.FieldOfView

    CurrentCamera.CameraType = Enum.CameraType.Custom
    p3:Add(function() -- line: 77
        -- upvalues: CurrentCamera (copy), CameraType (copy), FieldOfView (copy)
        CurrentCamera.CameraType = CameraType
        CurrentCamera.FieldOfView = FieldOfView
    end)

    local v4 = setmetatable({
        Punch = 0,
        Shaker = CameraShaker.new()
    }, t1)

    CameraShakerDriver.Start(v4.Shaker, Enum.RenderPriority.Last.Value)
    p3:Add(function() -- line: 84
        -- upvalues: v4 (copy), CameraShakerDriver (copy)
        CameraShakerDriver.Stop(v4.Shaker)
    end)

    local function faceHeading() -- line: 88
        -- upvalues: p4 (copy), p5 (copy), CurrentCamera (copy), cameraModule (copy)
        local Heading = p4.Heading
        local v5 = Vector3.new(Heading.X, 0, Heading.Z)
        local v6 = if not (v5.Magnitude < 0.3) then math.atan2(-v5.X, -v5.Z) else nil

        if v6 == nil then
            return
        end

        local v9 = cameraModule()
        local v10 = (if v9 then v9:GetCameraSubjectPosition(Enum.CameraType.Custom) else nil) or p5.Root.Position
        local v11 = CFrame.Angles(0, v6, 0) * CFrame.Angles(-0.24434609527920614, 0, 0)
        local v12 = CFrame.lookAlong(v10 - v11.LookVector * 14, v11.LookVector)

        CurrentCamera.CFrame = v12

        if v9 then
            v9:CommitCameraCFrame(v12, Enum.CameraType.Custom)
        end
    end

    faceHeading()

    local v13
    local n1 = (-1e999)
    local RootPosition = p5.Root.Position

    RunService:BindToRenderStep("MountRaceCamera", Enum.RenderPriority.Camera.Value + 1, function(p6) -- line: 116
        -- upvalues: p4 (copy), p5 (copy), CurrentCamera (copy), v4 (copy), faceHeading (copy), v13 (ref), n1 (ref), RootPosition (ref), MountRaceFlags (copy)
        local RootPosition2 = p5.Root.Position
        local v15 = (RootPosition2 - RootPosition).Magnitude > 80

        RootPosition = RootPosition2

        if v15 then
            faceHeading()

            local LookVector = CurrentCamera.CFrame.LookVector
            local v16 = Vector3.new(LookVector.X, 0, LookVector.Z)

            v13 = if v16.Magnitude < 0.3 then nil else math.atan2(-v16.X, -v16.Z)
            n1 = (-1e999)
        else
            local LookVector = CurrentCamera.CFrame.LookVector
            local v19 = Vector3.new(LookVector.X, 0, LookVector.Z)
            local v20 = if not (v19.Magnitude < 0.3) then math.atan2(-v19.X, -v19.Z) else nil

            if v20 ~= nil and v13 ~= nil and math.abs((v20 - v13 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) > 0.0008726646259971648 then
                n1 = os.clock()
            end

            local Heading = p4.Heading
            local v24 = Vector3.new(Heading.X, 0, Heading.Z)
            local v25 = if not (v24.Magnitude < 0.3) then math.atan2(-v24.X, -v24.Z) else nil

            if v20 ~= nil and v25 ~= nil and os.clock() - n1 > 1.25 then
                local v30 = ((v25 - v20 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * (1 - math.exp(p6 * -4))

                if math.abs(v30) > 1E-05 then
                    local FocusPosition = CurrentCamera.Focus.Position

                    CurrentCamera.CFrame = CFrame.new(FocusPosition) * CFrame.Angles(0, v30, 0) * CFrame.new(-FocusPosition) * CurrentCamera.CFrame
                    v20 += v30
                end
            end

            v13 = v20
        end

        v4.Punch = math.max(0, v4.Punch - v4.Punch * 2.5 * p6)

        local v32 = MountRaceFlags.FovBase:Get()
        local v35 = v32 + (MountRaceFlags.FovMax:Get() - v32) * math.min(p4:SpeedRatio(), 1) + v4.Punch

        CurrentCamera.FieldOfView = CurrentCamera.FieldOfView + (v35 - CurrentCamera.FieldOfView) * math.min(1, p6 * 5)
    end)
    p3:Add(function() -- line: 162
        -- upvalues: RunService (copy)
        RunService:UnbindFromRenderStep("MountRaceCamera")
    end)

    return v4
end

function t1.PunchFov(p7, p8) -- line: 169
    p7.Punch = math.max(p7.Punch, p8)
end

function t1.Shake(p9, p10) -- line: 173
    p9.Shaker:ShakeOnce(p10, 12, 0, 0.45)
end

return t1
