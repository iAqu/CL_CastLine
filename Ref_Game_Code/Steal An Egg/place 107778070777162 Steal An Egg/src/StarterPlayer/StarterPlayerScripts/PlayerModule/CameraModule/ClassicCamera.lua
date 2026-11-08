-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

Vector2.new(0, 0)

local n1 = 0
local v1 = CFrame.fromOrientation(-0.2617993877991494, 0, 0)
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"))
local UserCameraInputDt = FlagUtil.getUserFlag("UserCameraInputDt")
local UserFixCameraFPError = FlagUtil.getUserFlag("UserFixCameraFPError")
local Players = game:GetService("Players")
local CameraInput = require(script.Parent:WaitForChild("CameraInput"))
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"))
local BaseCamera = require(script.Parent:WaitForChild("BaseCamera"))
local self = setmetatable({}, BaseCamera)

self.__index = self

function self.new() -- line: 40
    -- upvalues: CameraUtils (copy), BaseCamera (copy), self (copy)
    local v4 = setmetatable(BaseCamera.new(), self)

    v4.isFollowCamera = false
    v4.isCameraToggle = false
    v4.lastUpdate = tick()
    v4.cameraToggleSpring = CameraUtils.Spring.new(5, 0)

    return v4
end

function self.GetCameraToggleOffset(p1, p2) -- line: 51
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

function self.SetCameraMovementMode(p3, p4) -- line: 69
    -- upvalues: BaseCamera (copy)
    BaseCamera.SetCameraMovementMode(p3, p4)
    p3.isFollowCamera = p4 == Enum.ComputerCameraMovementMode.Follow
    p3.isCameraToggle = p4 == Enum.ComputerCameraMovementMode.CameraToggle
end

function self.Update(p5, p6) -- line: 76
    -- upvalues: n1 (ref), v1 (copy), UserCameraInputDt (copy), UserFixCameraFPError (copy), Players (copy), CameraInput (copy), CameraUtils (copy)
    local v9 = tick()
    local v10 = v9 - p5.lastUpdate

    if UserCameraInputDt then
        v10 = p6
    end

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
    local v11, v12

    if CameraSubject then
        v11 = CameraSubject:IsA("VehicleSeat")
        v12 = CameraSubject:IsA("SkateboardPlatform")
    else
        v12 = CameraSubject
        v11 = CameraSubject
    end

    local v13 = Humanoid and Humanoid:GetState() == Enum.HumanoidStateType.Climbing

    if p5.lastUpdate == nil or v10 > 1 then
        p5.lastCameraTransform = nil
    end

    local v14 = CameraInput.getRotation(v10)

    p5:StepZoom()

    local CameraHeight = p5:GetCameraHeight()

    if v14 ~= Vector2.new() then
        n1 = 0
        p5.lastUserPanCamera = tick()
    end

    local v15 = v9 - p5.lastUserPanCamera < 2
    local SubjectPosition = p5:GetSubjectPosition()
    local v16, v17

    if SubjectPosition and LocalPlayer and CurrentCamera then
        local CameraToSubjectDistance = p5:GetCameraToSubjectDistance()

        if CameraToSubjectDistance < 0.5 then
            CameraToSubjectDistance = 0.5
        end

        local v18, MouseLockOffset, v19

        if not p5:GetIsMouseLocked() or p5:IsInFirstPerson() then
            v19 = true
        else
            v18 = p5:CalculateNewLookCFrameFromArg(lookVector, v14)
            MouseLockOffset = p5:GetMouseLockOffset()

            if Humanoid then
                MouseLockOffset += Humanoid.CameraOffset
            end

            v19 = false
        end

        local v20 = v14
        local v21 = SubjectPosition

        if v19 then
            if v14 ~= Vector2.new() then
            elseif p5.lastCameraTransform then
                local v22 = p5:IsInFirstPerson()

                if (v11 or v12 or p5.isFollowCamera and v13) and p5.lastUpdate and Humanoid and Humanoid.Torso then
                    if v22 then
                        if p5.lastSubjectCFrame and (v11 or v12) and CameraSubject:IsA("BasePart") then
                            local v23 = -CameraUtils.GetAngleBetweenXZVectors(p5.lastSubjectCFrame.lookVector, CameraSubject.CFrame.lookVector)

                            v20 = if CameraUtils.IsFinite(v23) then v14 + Vector2.new(v23, 0) else v14
                            n1 = 0
                        end
                    elseif not v15 then
                        local lookVector = Humanoid.Torso.CFrame.lookVector
                        local v25 = n1

                        n1 = math.clamp(v25 + 3.839724354387525 * v10, 0, 4.363323129985824)

                        local v27 = math.clamp(n1 * v10, 0, 1)

                        if p5:IsInFirstPerson() and (not p5.isFollowCamera or not p5.isClimbing) then
                            v27 = 1
                        end

                        local v28 = CameraUtils.GetAngleBetweenXZVectors(lookVector, p5:GetCameraLookVector())

                        if CameraUtils.IsFinite(v28) and math.abs(v28) > 1E-04 then
                            v20 = v14 + Vector2.new(v28 * v27, 0)
                        end
                    end
                elseif p5.isFollowCamera and not v22 and not v15 then
                    local v29 = -(p5.lastCameraTransform.p - SubjectPosition)
                    local v30 = CameraUtils.GetAngleBetweenXZVectors(v29, p5:GetCameraLookVector())

                    if CameraUtils.IsFinite(v30) and math.abs(v30) > 1E-04 and math.abs(v30) > 0.4 * v10 then
                        v20 = v14 + Vector2.new(v30, 0)
                    end
                end
            end
        else
            local v31 = MouseLockOffset.X * v18.RightVector + MouseLockOffset.Y * v18.UpVector + MouseLockOffset.Z * v18.LookVector

            if CameraUtils.IsFiniteVector3(v31) then
                v21 = SubjectPosition + v31
            end
        end

        local v32, v33

        if p5.isFollowCamera then
            local v34 = p5:CalculateNewLookVectorFromArg(lookVector, v20)

            v32 = CFrame.new(v21)
            v33 = if UserFixCameraFPError then CFrame.lookAlong(v32.p - CameraToSubjectDistance * v34, v34) else CFrame.new(v32.p - CameraToSubjectDistance * v34, v32.p) + Vector3.new(0, CameraHeight, 0)
        else
            v32 = CFrame.new(v21)

            local p = v32.p
            local v35 = p5:CalculateNewLookVectorFromArg(lookVector, v20)

            v33 = if UserFixCameraFPError then CFrame.lookAlong(p - CameraToSubjectDistance * v35, v35) else CFrame.new(p - CameraToSubjectDistance * v35, p)
        end

        local CameraToggleOffset = p5:GetCameraToggleOffset(v10)

        v16 = v32 + CameraToggleOffset
        v17 = v33 + CameraToggleOffset
        p5.lastCameraTransform = v17
        p5.lastCameraFocus = v16

        if (v11 or v12) and CameraSubject:IsA("BasePart") then
            p5.lastSubjectCFrame = CameraSubject.CFrame
        else
            p5.lastSubjectCFrame = nil
        end
    else
        v16 = Focus
        v17 = _CFrame
    end

    p5.lastUpdate = v9

    return v17, v16
end

return self
