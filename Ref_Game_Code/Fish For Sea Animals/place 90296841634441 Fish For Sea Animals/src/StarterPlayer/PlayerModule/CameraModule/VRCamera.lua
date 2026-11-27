-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local VRService = game:GetService("VRService")

require(script.Parent:WaitForChild("CameraInput"))
require(script.Parent:WaitForChild("CameraUtils"))

local VRCameraTeleportDetector = require(script.Parent:WaitForChild("VRCameraTeleportDetector"))
local FlagUtil = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil")
local UserVRRecenterOnExternalTeleport = FlagUtil.getUserFlag("UserVRRecenterOnExternalTeleport")
local UserVRSkipOcclusionInFirstPerson = FlagUtil.getUserFlag("UserVRSkipOcclusionInFirstPerson")
local UserFixVRImmersionAutoRotate = FlagUtil.getUserFlag("UserFixVRImmersionAutoRotate")
local VRBaseCamera = require(script.Parent:WaitForChild("VRBaseCamera"))
local self = setmetatable({}, VRBaseCamera)

self.__index = self

function self.new() -- line: 36
    -- upvalues: VRBaseCamera (copy), self (copy)
    local v3 = setmetatable(VRBaseCamera.new(), self)

    v3.lastUpdate = tick()
    v3.focusOffset = CFrame.new()
    v3:Reset()
    v3.controlModule = require(script.Parent.Parent:WaitForChild("ControlModule"))
    v3.savedAutoRotate = true
    v3.autoRotateOverridden = false

    return v3
end

function self.Reset(p1) -- line: 50
    -- upvalues: VRBaseCamera (copy)
    p1.needsReset = true
    p1.needsBlackout = true
    p1.motionDetTime = 0
    p1.blackOutTimer = 0
    p1.lastCameraResetPosition = nil
    VRBaseCamera.Reset(p1)
end

function self.Update(p2, p3) -- line: 59
    -- upvalues: Players (copy), VRService (copy), UserVRSkipOcclusionInFirstPerson (copy)
    local CurrentCamera = workspace.CurrentCamera
    local CFrame, Focus = CurrentCamera.CFrame, CurrentCamera.Focus
    local LocalPlayer = Players.LocalPlayer

    if p2.lastUpdate == nil or p3 > 1 then
        p2.lastCameraTransform = nil
    end

    p2:UpdateFadeFromBlack(p3)

    local lastSubjectPosition = p2.lastSubjectPosition
    local SubjectPosition = p2:GetSubjectPosition()

    if p2.needsBlackout then
        p2:StartFadeFromBlack()

        local v4 = math.clamp(p3, 1E-04, 0.1)

        p2.blackOutTimer += v4

        if p2.blackOutTimer > 0.1 and game:IsLoaded() then
            p2.needsBlackout = false
            p2.needsReset = true
        end
    end

    local v5, v6

    if SubjectPosition and LocalPlayer and CurrentCamera then
        local VRFocus = p2:GetVRFocus(SubjectPosition, p3)

        if UserVRSkipOcclusionInFirstPerson then
            p2.skipOcclusion = p2:IsInFirstPerson() and LocalPlayer.DevCameraOcclusionMode ~= Enum.DevCameraOcclusionMode.Invisicam
        end

        if p2:IsInFirstPerson() then
            if VRService.AvatarGestures then
                v5, v6 = p2:UpdateImmersionCamera(p3, CFrame, VRFocus, lastSubjectPosition, SubjectPosition)
            else
                v5, v6 = p2:UpdateFirstPersonTransform(p3, CFrame, VRFocus, lastSubjectPosition, SubjectPosition)
            end
        elseif VRService.ThirdPersonFollowCamEnabled then
            v5, v6 = p2:UpdateThirdPersonFollowTransform(p3, CFrame, VRFocus, lastSubjectPosition, SubjectPosition)
        else
            v5, v6 = p2:UpdateThirdPersonComfortTransform(p3, CFrame, VRFocus, lastSubjectPosition, SubjectPosition)
        end

        p2.lastCameraTransform = v5
        p2.lastCameraFocus = v6
    else
        v6 = Focus
        v5 = CFrame
    end

    p2.lastUpdate = tick()

    return v5, v6
end

function self.GetAvatarFeetWorldYValue(_) -- line: 142
    local CameraSubject = workspace.CurrentCamera.CameraSubject

    if not CameraSubject then
        return nil
    end

    if CameraSubject:IsA("Humanoid") and CameraSubject.RootPart then
        local RootPart = CameraSubject.RootPart

        return RootPart.Position.Y - RootPart.Size.Y / 2 - CameraSubject.HipHeight
    end

    return nil
end

function self.UpdateFirstPersonTransform(p5, p6, _, p8, _, _) -- line: 157
    if p5.needsReset then
        p5:StartFadeFromBlack()
        p5.needsReset = false
    end

    local Position = p8.Position
    local CameraLookVector = p5:GetCameraLookVector()
    local Unit = Vector3.new(CameraLookVector.X, 0, CameraLookVector.Z).Unit
    local v7 = p5:getRotation(p6)
    local v8 = p5:CalculateNewLookVectorFromArg(Unit, Vector2.new(v7, 0))

    return CFrame.new(Position - 0.5 * v8, Position), p8
end

function self.UpdateImmersionCamera(p11, p12, _, _, p15, p16) -- line: 177
    -- upvalues: Players (copy), VRService (copy), VRCameraTeleportDetector (copy), UserVRRecenterOnExternalTeleport (copy), UserFixVRImmersionAutoRotate (copy)
    local SubjectCFrame = p11:GetSubjectCFrame()
    local CurrentCamera = workspace.CurrentCamera
    local Character = Players.LocalPlayer.Character
    local Humanoid = p11:GetHumanoid()

    if not Humanoid then
        return CurrentCamera.CFrame, CurrentCamera.Focus
    end

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return CurrentCamera.CFrame, CurrentCamera.Focus
    end

    local v9 = if not UserVRRecenterOnExternalTeleport then nil elseif p15 then Vector3.new(p16.X - p15.X, 0, p16.Z - p15.Z).Magnitude else 0

    p11.characterOrientation = HumanoidRootPart:FindFirstChild("CharacterAlignOrientation")

    if not p11.characterOrientation then
        local RootAttachment = HumanoidRootPart:FindFirstChild("RootAttachment")

        if not RootAttachment then
            return
        end

        p11.characterOrientation = Instance.new("AlignOrientation")
        p11.characterOrientation.Name = "CharacterAlignOrientation"
        p11.characterOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
        p11.characterOrientation.Attachment0 = RootAttachment
        p11.characterOrientation.RigidityEnabled = true
        p11.characterOrientation.Parent = HumanoidRootPart
    end

    if p11.characterOrientation.Enabled == false then
        p11.characterOrientation.Enabled = true
    end

    if p11.needsReset then
        p11.needsReset = false

        if UserFixVRImmersionAutoRotate then
            p11:updateImmersionAutoRotate()
        else
            p11.savedAutoRotate = Humanoid.AutoRotate
            Humanoid.AutoRotate = false
        end

        if UserVRRecenterOnExternalTeleport then
            VRService:RecenterUserHeadCFrame()
            p11.lastTeleportRecenter = tick()
        end

        p11:StartFadeFromBlack()
    elseif not Humanoid.Sit then
        local EstimatedVRTorsoFrame = p11.controlModule:GetEstimatedVRTorsoFrame()

        p11.characterOrientation.CFrame = CurrentCamera.CFrame * EstimatedVRTorsoFrame

        if p11.controlModule.inputMoveVector.Magnitude > 0 then
            p11.motionDetTime = 0.1
        end

        if p11.controlModule.inputMoveVector.Magnitude > 0 or p11.motionDetTime > 0 then
            p11.motionDetTime -= p12

            local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
            local v12 = UserCFrame.Rotation + UserCFrame.Position * CurrentCamera.HeadScale
            local HumanoidRootPart = Character.HumanoidRootPart
            local v13 = -0.7 * HumanoidRootPart.Size.Y / 2
            local v14 = CurrentCamera.CFrame * v12 * CFrame.new(0, v13, 0)
            local LookVector = HumanoidRootPart.CFrame.LookVector
            local v15 = p16 - (v14 - Vector3.new(LookVector.X, 0, LookVector.Z).Unit * HumanoidRootPart.Size.Y * 0.125).Position + CurrentCamera.CFrame.Position
            local v16 = Vector3.new(v15.X, p16.Y, v15.Z)

            SubjectCFrame = CurrentCamera.CFrame.Rotation + v16
        elseif not (UserVRRecenterOnExternalTeleport and VRCameraTeleportDetector.shouldRecenter(p11.prevSubjStep, v9, p11.lastTeleportRecenter, tick())) then
            SubjectCFrame = CurrentCamera.CFrame.Rotation + Vector3.new(CurrentCamera.CFrame.Position.X, p16.Y, CurrentCamera.CFrame.Position.Z)
        else
            local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
            local v17 = UserCFrame.Rotation + UserCFrame.Position * CurrentCamera.HeadScale
            local HumanoidRootPart = Character.HumanoidRootPart
            local v18 = -0.7 * HumanoidRootPart.Size.Y / 2
            local v19 = CurrentCamera.CFrame * v17 * CFrame.new(0, v18, 0)
            local LookVector = HumanoidRootPart.CFrame.LookVector
            local v20 = p16 - (v19 - Vector3.new(LookVector.X, 0, LookVector.Z).Unit * HumanoidRootPart.Size.Y * 0.125).Position + CurrentCamera.CFrame.Position
            local v21 = Vector3.new(v20.X, p16.Y, v20.Z)

            SubjectCFrame = CurrentCamera.CFrame.Rotation + v21
            VRService:RecenterUserHeadCFrame()
            p11:StartFadeFromBlack()
            p11.lastTeleportRecenter = tick()
        end

        local v22 = p11:getRotation(p12)

        if math.abs(v22) > 0 then
            local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
            local v23 = UserCFrame.Rotation + UserCFrame.Position * CurrentCamera.HeadScale
            local v24 = SubjectCFrame * v23

            SubjectCFrame = CFrame.new(v24.Position) * CFrame.Angles(0, -math.rad(v22 * 90), 0) * v24.Rotation * v23:Inverse()
        end
    end

    if UserVRRecenterOnExternalTeleport then
        p11.prevSubjStep = v9
    end

    return SubjectCFrame, SubjectCFrame * CFrame.new(0, 0, -0.5)
end

function self.UpdateThirdPersonComfortTransform(p17, p18, p19, p20, p21, p22) -- line: 339
    -- upvalues: VRService (copy)
    local CameraToSubjectDistance = p17:GetCameraToSubjectDistance()

    if CameraToSubjectDistance < 0.5 then
        CameraToSubjectDistance = 0.5
    end

    local v27

    if p21 == nil or p17.lastCameraFocus == nil then
        v27 = p19
    else
        local v28 = p21 - p22
        local inputMoveVector = p17.controlModule.inputMoveVector
        local v29 = v28.magnitude > 0.01 or inputMoveVector.magnitude > 0.01

        if v29 then
            p17.motionDetTime = 0.1
        end

        p17.motionDetTime -= p18

        if p17.motionDetTime > 0 then
            v29 = true
        end

        if v29 and not p17.needsReset then
            local lastCameraFocus = p17.lastCameraFocus

            p17.VRCameraFocusFrozen = true

            return p19, lastCameraFocus
        end

        local v30 = p17.lastCameraResetPosition == nil or (p22 - p17.lastCameraResetPosition).Magnitude > 1
        local v31 = p17:getRotation(p18)
        local v32 = p19

        if math.abs(v31) > 0 then
            local v33 = p20:ToObjectSpace(p19)

            v32 = p20 * CFrame.Angles(0, -v31, 0) * v33
        end

        if p17.VRCameraFocusFrozen and v30 or p17.needsReset then
            VRService:RecenterUserHeadCFrame()
            p17.VRCameraFocusFrozen = false
            p17.needsReset = false
            p17.lastCameraResetPosition = p22
            p17:ResetZoom()
            p17:StartFadeFromBlack()

            local Humanoid = p17:GetHumanoid()
            local lookVector = Humanoid.Torso and Humanoid.Torso.CFrame.lookVector or Vector3.new(1, 0, 0)
            local v34 = Vector3.new(lookVector.X, 0, lookVector.Z)
            local v35 = p20.Position - v34 * CameraToSubjectDistance
            local v36 = Vector3.new(p20.Position.X, v35.Y, p20.Position.Z)

            v27 = CFrame.new(v35, v36)
        else
            v27 = v32
        end
    end

    return v27, p20
end

function self.UpdateThirdPersonFollowTransform(p23, p24, _, _, p27, p28) -- line: 412
    -- upvalues: VRService (copy)
    local CurrentCamera = workspace.CurrentCamera
    local CameraToSubjectDistance = p23:GetCameraToSubjectDistance()
    local VRFocus = p23:GetVRFocus(p28, p24)

    if p23.needsReset then
        p23.needsReset = false
        VRService:RecenterUserHeadCFrame()
        p23:ResetZoom()
        p23:StartFadeFromBlack()
    end

    if p23.recentered then
        local SubjectCFrame = p23:GetSubjectCFrame()

        if not SubjectCFrame then
            return CurrentCamera.CFrame, CurrentCamera.Focus
        end

        local v37 = VRFocus * SubjectCFrame.Rotation * CFrame.new(0, 0, CameraToSubjectDistance)

        p23.focusOffset = VRFocus:ToObjectSpace(v37)
        p23.recentered = false

        return v37, VRFocus
    end

    local v38 = VRFocus:ToWorldSpace(p23.focusOffset)
    local v39 = p27 - p28
    local controlModule = p23.controlModule
    local inputMoveVector = controlModule.inputMoveVector

    if v39.magnitude > 0.01 or inputMoveVector.magnitude > 0 then
        local EstimatedVRTorsoFrame = controlModule:GetEstimatedVRTorsoFrame()
        local v40 = EstimatedVRTorsoFrame.Rotation + EstimatedVRTorsoFrame.Position * CurrentCamera.HeadScale
        local v41 = CurrentCamera.CFrame * v40
        local LookVector = v41.LookVector
        local v42 = Vector3.new(LookVector.X, 0, LookVector.Z).Unit * CameraToSubjectDistance
        local v43 = VRFocus.Position - v42

        v38 = v38:Lerp(CFrame.new(CurrentCamera.CFrame.Position + v43 - v41.Position) * v38.Rotation, 0.01)
    end

    local v44 = p23:getRotation(p24)

    if math.abs(v44) > 0 then
        local v45 = VRFocus:ToObjectSpace(v38)

        v38 = VRFocus * CFrame.Angles(0, -v44, 0) * v45
    end

    p23.focusOffset = VRFocus:ToObjectSpace(v38)

    return v38, v38 * CFrame.new(0, 0, -CameraToSubjectDistance)
end

function self.updateImmersionAutoRotate(p29) -- line: 491
    -- upvalues: VRService (copy)
    local Humanoid = p29:GetHumanoid()

    if Humanoid then
        if p29:IsInFirstPerson() and VRService.AvatarGestures then
            if not p29.autoRotateOverridden then
                p29.savedAutoRotate = Humanoid.AutoRotate
                p29.autoRotateOverridden = true
            end

            Humanoid.AutoRotate = false
        elseif p29.autoRotateOverridden then
            Humanoid.AutoRotate = p29.savedAutoRotate
            p29.autoRotateOverridden = false
        end
    end
end

function self.OnEnabledChanged(p30) -- line: 511
    -- upvalues: VRService (copy), UserFixVRImmersionAutoRotate (copy), VRBaseCamera (copy)
    VRBaseCamera.OnEnabledChanged(p30)

    if UserFixVRImmersionAutoRotate then
        if p30.enabled then
            if not p30.avatarGesturesChangedConn then
                p30.avatarGesturesChangedConn = VRService:GetPropertyChangedSignal("AvatarGestures"):Connect(function() -- line: 520
                    -- upvalues: p30 (copy)
                    p30:updateImmersionAutoRotate()
                end)
            end
        elseif p30.avatarGesturesChangedConn then
            p30.avatarGesturesChangedConn:Disconnect()
            p30.avatarGesturesChangedConn = nil
        end
    end
end

function self.LeaveFirstPerson(p31) -- line: 530
    -- upvalues: UserFixVRImmersionAutoRotate (copy), VRBaseCamera (copy)
    VRBaseCamera.LeaveFirstPerson(p31)
    p31.needsReset = true

    if p31.VRBlur then
        p31.VRBlur.Visible = false
    end

    if p31.characterOrientation then
        p31.characterOrientation.Enabled = false
    end

    if UserFixVRImmersionAutoRotate then
        p31:updateImmersionAutoRotate()
    else
        local Humanoid = p31:GetHumanoid()

        if Humanoid then
            Humanoid.AutoRotate = p31.savedAutoRotate
        end
    end
end

return self
