-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

Vector2.new(0, 0)

local n1 = 0
local v1 = CFrame.fromOrientation(-0.2617993877991494, 0, 0)
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local UserFixCameraFPError = require(CommonUtils:WaitForChild("FlagUtil")).getUserFlag("UserFixCameraFPError")
local Players = game:GetService("Players")
local CameraInput = require(script.Parent:WaitForChild("CameraInput"))
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"))
local BaseCamera = require(script.Parent:WaitForChild("BaseCamera"))
local self = setmetatable({}, BaseCamera)

self.__index = self

function self.new() -- line: 39
    -- upvalues: CameraUtils (copy), BaseCamera (copy), self (copy)
    local v4 = setmetatable(BaseCamera.new(), self)

    v4.isFollowCamera = false
    v4.isCameraToggle = false
    v4.lastUpdate = tick()
    v4.cameraToggleSpring = CameraUtils.Spring.new(5, 0)

    return v4
end

function self.GetCameraToggleOffset(p1, p2) -- line: 50
    -- upvalues: CameraInput (copy), CameraUtils (copy)
    if not p1.isCameraToggle then
        return (Vector3.new())
    end

    local currentSubjectDistance = p1.currentSubjectDistance

    if CameraInput.getTogglePan() then
        p1.cameraToggleSpring.goal = math.clamp(CameraUtils.map(currentSubjectDistance, 0.5, p1.FIRST_PERSON_DISTANCE_THRESHOLD, 0, 1), 0, 1)
    else
        p1.cameraToggleSpring.goal = 0
    end

    local v7 = math.clamp(CameraUtils.map(currentSubjectDistance, 0.5, 64, 0, 1), 0, 1) + 1

    return (Vector3.new(0, p1.cameraToggleSpring:step(p2) * v7, 0))
end

function self.SetCameraMovementMode(p3, p4) -- line: 68
    -- upvalues: BaseCamera (copy)
    BaseCamera.SetCameraMovementMode(p3, p4)
    p3.isFollowCamera = p4 == Enum.ComputerCameraMovementMode.Follow
    p3.isCameraToggle = p4 == Enum.ComputerCameraMovementMode.CameraToggle
end

function self.Update(p5, p6) -- line: 75
    -- upvalues: n1 (ref), v1 (copy), UserFixCameraFPError (copy), Players (copy), CameraInput (copy), CameraUtils (copy)
    local v9 = tick()
    local CurrentCamera = workspace.CurrentCamera
    local _CFrame, Focus = CurrentCamera.CFrame, CurrentCamera.Focus
    local lookVector

    if p5.resetCameraAngle then
        local HumanoidRootPart = p5:GetHumanoidRootPart()

        lookVector = if HumanoidRootPart then (HumanoidRootPart.CFrame * v1).lookVector else v1.lookVector
        p5.resetCameraAngle = false
    end

    local LocalPlayer = Players.LocalPlayer
    local Humanoid = p5:GetHumanoid()
    local CameraSubject = CurrentCamera.CameraSubject
    local v10, v11

    if CameraSubject then
        v10 = CameraSubject:IsA("VehicleSeat")
        v11 = CameraSubject:IsA("SkateboardPlatform")
    else
        v11 = CameraSubject
        v10 = CameraSubject
    end

    local v12 = Humanoid and Humanoid:GetState() == Enum.HumanoidStateType.Climbing

    if p5.lastUpdate == nil or p6 > 1 then
        p5.lastCameraTransform = nil
    end

    local v13 = CameraInput.getRotation(p6)

    p5:StepZoom()

    local CameraHeight = p5:GetCameraHeight()

    if v13 ~= Vector2.new() then
        n1 = 0
        p5.lastUserPanCamera = tick()
    end

    local v14 = v9 - p5.lastUserPanCamera < 2
    local SubjectPosition = p5:GetSubjectPosition()
    local v15, v16

    if SubjectPosition and LocalPlayer and CurrentCamera then
        local CameraToSubjectDistance = p5:GetCameraToSubjectDistance()

        if CameraToSubjectDistance < 0.5 then
            CameraToSubjectDistance = 0.5
        end

        local v17, MouseLockOffset, v18

        if not p5:GetIsMouseLocked() or p5:IsInFirstPerson() then
            v18 = true
        else
            v17 = p5:CalculateNewLookCFrameFromArg(lookVector, v13)
            MouseLockOffset = p5:GetMouseLockOffset()

            if Humanoid then
                MouseLockOffset += Humanoid.CameraOffset
            end

            v18 = false
        end

        local v19 = v13
        local v20 = SubjectPosition

        if v18 then
            if v13 ~= Vector2.new() then
            elseif p5.lastCameraTransform then
                local v21 = p5:IsInFirstPerson()

                if (v10 or v11 or p5.isFollowCamera and v12) and p5.lastUpdate and Humanoid and Humanoid.Torso then
                    if v21 then
                        if p5.lastSubjectCFrame and (v10 or v11) and CameraSubject:IsA("BasePart") then
                            local v22 = -CameraUtils.GetAngleBetweenXZVectors(p5.lastSubjectCFrame.lookVector, CameraSubject.CFrame.lookVector)

                            v19 = if CameraUtils.IsFinite(v22) then v13 + Vector2.new(v22, 0) else v13
                            n1 = 0
                        end
                    elseif not v14 then
                        local lookVector = Humanoid.Torso.CFrame.lookVector
                        local v24 = n1

                        n1 = math.clamp(v24 + 3.839724354387525 * p6, 0, 4.363323129985824)

                        local v26 = math.clamp(n1 * p6, 0, 1)

                        if p5:IsInFirstPerson() and (not p5.isFollowCamera or not p5.isClimbing) then
                            v26 = 1
                        end

                        local v27 = CameraUtils.GetAngleBetweenXZVectors(lookVector, p5:GetCameraLookVector())

                        if CameraUtils.IsFinite(v27) and math.abs(v27) > 1E-04 then
                            v19 = v13 + Vector2.new(v27 * v26, 0)
                        end
                    end
                elseif p5.isFollowCamera and not v21 and not v14 then
                    local v28 = -(p5.lastCameraTransform.p - SubjectPosition)
                    local v29 = CameraUtils.GetAngleBetweenXZVectors(v28, p5:GetCameraLookVector())

                    if CameraUtils.IsFinite(v29) and math.abs(v29) > 1E-04 and math.abs(v29) > 0.4 * p6 then
                        v19 = v13 + Vector2.new(v29, 0)
                    end
                end
            end
        else
            local v30 = MouseLockOffset.X * v17.RightVector + MouseLockOffset.Y * v17.UpVector + MouseLockOffset.Z * v17.LookVector

            if CameraUtils.IsFiniteVector3(v30) then
                v20 = SubjectPosition + v30
            end
        end

        local v31, v32

        if p5.isFollowCamera then
            local v33 = p5:CalculateNewLookVectorFromArg(lookVector, v19)

            v31 = CFrame.new(v20)
            v32 = if UserFixCameraFPError then CFrame.lookAlong(v31.p - CameraToSubjectDistance * v33, v33) else CFrame.new(v31.p - CameraToSubjectDistance * v33, v31.p) + Vector3.new(0, CameraHeight, 0)
        else
            v31 = CFrame.new(v20)

            local p = v31.p
            local v34 = p5:CalculateNewLookVectorFromArg(lookVector, v19)

            v32 = if UserFixCameraFPError then CFrame.lookAlong(p - CameraToSubjectDistance * v34, v34) else CFrame.new(p - CameraToSubjectDistance * v34, p)
        end

        local CameraToggleOffset = p5:GetCameraToggleOffset(p6)

        v15 = v31 + CameraToggleOffset
        v16 = v32 + CameraToggleOffset
        p5.lastCameraTransform = v16
        p5.lastCameraFocus = v15

        if (v10 or v11) and CameraSubject:IsA("BasePart") then
            p5.lastSubjectCFrame = CameraSubject.CFrame
        else
            p5.lastSubjectCFrame = nil
        end
    else
        v15 = Focus
        v16 = _CFrame
    end

    p5.lastUpdate = v9

    return v16, v15
end

return self
