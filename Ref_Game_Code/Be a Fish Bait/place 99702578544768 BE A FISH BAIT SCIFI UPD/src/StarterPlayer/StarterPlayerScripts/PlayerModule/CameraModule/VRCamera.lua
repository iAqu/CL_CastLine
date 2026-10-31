-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local VRService = game:GetService("VRService")

UserSettings():GetService("UserGameSettings")
require(script.Parent:WaitForChild("CameraInput"))
require(script.Parent:WaitForChild("CameraUtils"))

local VRCameraTeleportDetector = require(script.Parent:WaitForChild("VRCameraTeleportDetector"))
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"))
local UserVRRecenterOnExternalTeleport = FlagUtil.getUserFlag("UserVRRecenterOnExternalTeleport")
local UserFixVRImmersionAutoRotate = FlagUtil.getUserFlag("UserFixVRImmersionAutoRotate")
local VRBaseCamera = require(script.Parent:WaitForChild("VRBaseCamera"))
local self = setmetatable({}, VRBaseCamera)

self.__index = self

function self.new() -- line: 34
    -- upvalues: Players (copy), VRBaseCamera (copy), self (copy)
    local v3 = setmetatable(VRBaseCamera.new(), self)

    v3.lastUpdate = tick()
    v3.focusOffset = CFrame.new()
    v3:Reset()
    v3.controlModule = require(Players.LocalPlayer:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule"))
    v3.savedAutoRotate = true
    v3.autoRotateOverridden = false

    return v3
end

function self.Reset(p1) -- line: 48
    -- upvalues: VRBaseCamera (copy)
    p1.needsReset = true
    p1.needsBlackout = true
    p1.motionDetTime = 0
    p1.blackOutTimer = 0
    p1.lastCameraResetPosition = nil
    VRBaseCamera.Reset(p1)
end

function self.Update(p2, p3) -- line: 57
    -- upvalues: Players (copy), VRService (copy)
    local CurrentCamera = workspace.CurrentCamera
    local CFrame, Focus = CurrentCamera.CFrame, CurrentCamera.Focus
    local LocalPlayer = Players.LocalPlayer

    p2:GetHumanoid()

    local _ = CurrentCamera.CameraSubject

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
        local v7, v8

        if p2:IsInFirstPerson() then
            if VRService.AvatarGestures then
                v7, v8 = p2:UpdateImmersionCamera(p3, CFrame, VRFocus, lastSubjectPosition, SubjectPosition)
            else
                v7, v8 = p2:UpdateFirstPersonTransform(p3, CFrame, VRFocus, lastSubjectPosition, SubjectPosition)
            end
        elseif VRService.ThirdPersonFollowCamEnabled then
            v7, v8 = p2:UpdateThirdPersonFollowTransform(p3, CFrame, VRFocus, lastSubjectPosition, SubjectPosition)
        else
            v7, v8 = p2:UpdateThirdPersonComfortTransform(p3, CFrame, VRFocus, lastSubjectPosition, SubjectPosition)
        end

        v6 = v8
        p2.lastCameraTransform = v7
        p2.lastCameraFocus = v8
        v5 = v7
    else
        v6 = Focus
        v5 = CFrame
    end

    p2.lastUpdate = tick()

    return v5, v6
end

function self.GetAvatarFeetWorldYValue(_) -- line: 118
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

function self.UpdateFirstPersonTransform(p5, p6, _, p8, _, _) -- line: 133
    if p5.needsReset then
        p5:StartFadeFromBlack()
        p5.needsReset = false
    end

    local p = p8.p
    local CameraLookVector = p5:GetCameraLookVector()
    local Unit = Vector3.new(CameraLookVector.X, 0, CameraLookVector.Z).Unit
    local v9 = p5:getRotation(p6)
    local v10 = p5:CalculateNewLookVectorFromArg(Unit, Vector2.new(v9, 0))

    return CFrame.new(p - 0.5 * v10, p), p8
end

function self.UpdateImmersionCamera(p11, p12, _, _, p15, p16) -- line: 153
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

    local v11 = if not UserVRRecenterOnExternalTeleport then nil elseif p15 then Vector3.new(p16.X - p15.X, 0, p16.Z - p15.Z).Magnitude else 0

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
            local v14 = UserCFrame.Rotation + UserCFrame.Position * CurrentCamera.HeadScale
            local HumanoidRootPart = Character.HumanoidRootPart
            local v15 = -0.7 * HumanoidRootPart.Size.Y / 2
            local v16 = CurrentCamera.CFrame * v14 * CFrame.new(0, v15, 0)
            local LookVector = HumanoidRootPart.CFrame.LookVector
            local v17 = p16 - (v16 - Vector3.new(LookVector.X, 0, LookVector.Z).Unit * HumanoidRootPart.Size.Y * 0.125).Position + CurrentCamera.CFrame.Position
            local v18 = Vector3.new(v17.X, p16.Y, v17.Z)

            SubjectCFrame = CurrentCamera.CFrame.Rotation + v18
        elseif not (UserVRRecenterOnExternalTeleport and VRCameraTeleportDetector.shouldRecenter(p11.prevSubjStep, v11, p11.lastTeleportRecenter, tick())) then
            SubjectCFrame = CurrentCamera.CFrame.Rotation + Vector3.new(CurrentCamera.CFrame.Position.X, p16.Y, CurrentCamera.CFrame.Position.Z)
        else
            local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
            local v19 = UserCFrame.Rotation + UserCFrame.Position * CurrentCamera.HeadScale
            local HumanoidRootPart = Character.HumanoidRootPart
            local v20 = -0.7 * HumanoidRootPart.Size.Y / 2
            local v21 = CurrentCamera.CFrame * v19 * CFrame.new(0, v20, 0)
            local LookVector = HumanoidRootPart.CFrame.LookVector
            local v22 = p16 - (v21 - Vector3.new(LookVector.X, 0, LookVector.Z).Unit * HumanoidRootPart.Size.Y * 0.125).Position + CurrentCamera.CFrame.Position
            local v23 = Vector3.new(v22.X, p16.Y, v22.Z)

            SubjectCFrame = CurrentCamera.CFrame.Rotation + v23
            VRService:RecenterUserHeadCFrame()
            p11:StartFadeFromBlack()
            p11.lastTeleportRecenter = tick()
        end

        local v24 = p11:getRotation(p12)

        if math.abs(v24) > 0 then
            local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
            local v25 = UserCFrame.Rotation + UserCFrame.Position * CurrentCamera.HeadScale
            local v26 = SubjectCFrame * v25

            SubjectCFrame = CFrame.new(v26.Position) * CFrame.Angles(0, -math.rad(v24 * 90), 0) * v26.Rotation * v25:Inverse()
        end
    end

    if UserVRRecenterOnExternalTeleport then
        p11.prevSubjStep = v11
    end

    return SubjectCFrame, SubjectCFrame * CFrame.new(0, 0, -0.5)
end

function self.UpdateThirdPersonComfortTransform(p17, p18, p19, p20, p21, p22) -- line: 305
    -- upvalues: Players (copy), VRService (copy)
    local CameraToSubjectDistance = p17:GetCameraToSubjectDistance()

    if CameraToSubjectDistance < 0.5 then
        CameraToSubjectDistance = 0.5
    end

    local v29

    if p21 == nil or p17.lastCameraFocus == nil then
        v29 = p19
    else
        local _ = Players.LocalPlayer
        local v30 = p21 - p22
        local MoveVector = p17.controlModule:GetMoveVector()
        local v31 = v30.magnitude > 0.01 or MoveVector.magnitude > 0.01

        if v31 then
            p17.motionDetTime = 0.1
        end

        p17.motionDetTime -= p18

        if p17.motionDetTime > 0 then
            v31 = true
        end

        if v31 and not p17.needsReset then
            local lastCameraFocus = p17.lastCameraFocus

            p17.VRCameraFocusFrozen = true

            return p19, lastCameraFocus
        end

        local v32 = p17.lastCameraResetPosition == nil or (p22 - p17.lastCameraResetPosition).Magnitude > 1
        local v33 = p17:getRotation(p18)
        local v34 = p19

        if math.abs(v33) > 0 then
            local v35 = p20:ToObjectSpace(p19)

            v34 = p20 * CFrame.Angles(0, -v33, 0) * v35
        end

        if p17.VRCameraFocusFrozen and v32 or p17.needsReset then
            VRService:RecenterUserHeadCFrame()
            p17.VRCameraFocusFrozen = false
            p17.needsReset = false
            p17.lastCameraResetPosition = p22
            p17:ResetZoom()
            p17:StartFadeFromBlack()

            local Humanoid = p17:GetHumanoid()
            local lookVector = Humanoid.Torso and Humanoid.Torso.CFrame.lookVector or Vector3.new(1, 0, 0)
            local v36 = Vector3.new(lookVector.X, 0, lookVector.Z)
            local v37 = p20.Position - v36 * CameraToSubjectDistance
            local v38 = Vector3.new(p20.Position.X, v37.Y, p20.Position.Z)

            v29 = CFrame.new(v37, v38)
        else
            v29 = v34
        end
    end

    return v29, p20
end

function self.UpdateThirdPersonFollowTransform(p23, p24, _, _, p27, p28) -- line: 372
    -- upvalues: Players (copy), VRService (copy)
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

        local v39 = VRFocus * SubjectCFrame.Rotation * CFrame.new(0, 0, CameraToSubjectDistance)

        p23.focusOffset = VRFocus:ToObjectSpace(v39)
        p23.recentered = false

        return v39, VRFocus
    end

    local v40 = VRFocus:ToWorldSpace(p23.focusOffset)
    local _ = Players.LocalPlayer
    local v41 = p27 - p28
    local controlModule = p23.controlModule
    local MoveVector = controlModule:GetMoveVector()

    if v41.magnitude > 0.01 or MoveVector.magnitude > 0 then
        local EstimatedVRTorsoFrame = controlModule:GetEstimatedVRTorsoFrame()
        local v42 = EstimatedVRTorsoFrame.Rotation + EstimatedVRTorsoFrame.Position * CurrentCamera.HeadScale
        local v43 = CurrentCamera.CFrame * v42
        local LookVector = v43.LookVector
        local v44 = Vector3.new(LookVector.X, 0, LookVector.Z).Unit * CameraToSubjectDistance
        local v45 = VRFocus.Position - v44

        v40 = v40:Lerp(CFrame.new(CurrentCamera.CFrame.Position + v45 - v43.Position) * v40.Rotation, 0.01)
    end

    local v46 = p23:getRotation(p24)

    if math.abs(v46) > 0 then
        local v47 = VRFocus:ToObjectSpace(v40)

        v40 = VRFocus * CFrame.Angles(0, -v46, 0) * v47
    end

    p23.focusOffset = VRFocus:ToObjectSpace(v40)

    return v40, v40 * CFrame.new(0, 0, -CameraToSubjectDistance)
end

function self.updateImmersionAutoRotate(p29) -- line: 447
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

function self.OnEnabledChanged(p30) -- line: 467
    -- upvalues: VRService (copy), UserFixVRImmersionAutoRotate (copy), VRBaseCamera (copy)
    VRBaseCamera.OnEnabledChanged(p30)

    if UserFixVRImmersionAutoRotate then
        if p30.enabled then
            if not p30.avatarGesturesChangedConn then
                p30.avatarGesturesChangedConn = VRService:GetPropertyChangedSignal("AvatarGestures"):Connect(function() -- line: 476
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

function self.LeaveFirstPerson(p31) -- line: 486
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
