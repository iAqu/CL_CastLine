-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local VRService = game:GetService("VRService")

UserSettings():GetService("UserGameSettings")
require(script.Parent:WaitForChild("CameraInput"))
require(script.Parent:WaitForChild("CameraUtils"))

local VRBaseCamera = require(script.Parent:WaitForChild("VRBaseCamera"))
local self = setmetatable({}, VRBaseCamera)

self.__index = self

function self.new() -- line: 28
    -- upvalues: Players (copy), VRBaseCamera (copy), self (copy)
    local v3 = setmetatable(VRBaseCamera.new(), self)

    v3.lastUpdate = tick()
    v3.focusOffset = CFrame.new()
    v3:Reset()
    v3.controlModule = require(Players.LocalPlayer:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule"))
    v3.savedAutoRotate = true

    return v3
end

function self.Reset(p1) -- line: 41
    -- upvalues: VRBaseCamera (copy)
    p1.needsReset = true
    p1.needsBlackout = true
    p1.motionDetTime = 0
    p1.blackOutTimer = 0
    p1.lastCameraResetPosition = nil
    VRBaseCamera.Reset(p1)
end

function self.Update(p2, p3) -- line: 50
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
    p2:UpdateEdgeBlur(LocalPlayer, p3)

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

function self.GetAvatarFeetWorldYValue(_) -- line: 112
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

function self.UpdateFirstPersonTransform(p5, p6, _, p8, p9, p10) -- line: 127
    -- upvalues: Players (copy)
    if p5.needsReset then
        p5:StartFadeFromBlack()
        p5.needsReset = false
    end

    local LocalPlayer = Players.LocalPlayer

    if (p9 - p10).magnitude > 0.01 then
        p5:StartVREdgeBlur(LocalPlayer)
    end

    local p = p8.p
    local CameraLookVector = p5:GetCameraLookVector()
    local Unit = Vector3.new(CameraLookVector.X, 0, CameraLookVector.Z).Unit
    local v9 = p5:getRotation(p6)
    local v10 = p5:CalculateNewLookVectorFromArg(Unit, Vector2.new(v9, 0))

    return CFrame.new(p - 0.5 * v10, p), p8
end

function self.UpdateImmersionCamera(p11, p12, _, _, _, p16) -- line: 153
    -- upvalues: Players (copy), VRService (copy)
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
        p11.savedAutoRotate = Humanoid.AutoRotate
        Humanoid.AutoRotate = false

        if p11.NoRecenter then
            p11.NoRecenter = false
            VRService:RecenterUserHeadCFrame()
        end

        p11:StartFadeFromBlack()
    elseif Humanoid.Sit then
        if (SubjectCFrame.Position - CurrentCamera.CFrame.Position).Magnitude > 0.01 then
            p11:StartVREdgeBlur(Players.LocalPlayer)
        end
    else
        local EstimatedVRTorsoFrame = p11.controlModule:GetEstimatedVRTorsoFrame()

        p11.characterOrientation.CFrame = CurrentCamera.CFrame * EstimatedVRTorsoFrame

        if p11.controlModule.inputMoveVector.Magnitude > 0 then
            p11.motionDetTime = 0.1
        end

        if p11.controlModule.inputMoveVector.Magnitude > 0 or p11.motionDetTime > 0 then
            p11.motionDetTime -= p12
            p11:StartVREdgeBlur(Players.LocalPlayer)

            local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
            local v11 = UserCFrame.Rotation + UserCFrame.Position * CurrentCamera.HeadScale
            local HumanoidRootPart = Character.HumanoidRootPart
            local v12 = -0.7 * HumanoidRootPart.Size.Y / 2
            local v13 = CurrentCamera.CFrame * v11 * CFrame.new(0, v12, 0)
            local LookVector = HumanoidRootPart.CFrame.LookVector
            local v14 = p16 - (v13 - Vector3.new(LookVector.X, 0, LookVector.Z).Unit * HumanoidRootPart.Size.Y * 0.125).Position + CurrentCamera.CFrame.Position
            local v15 = Vector3.new(v14.X, p16.Y, v14.Z)

            SubjectCFrame = CurrentCamera.CFrame.Rotation + v15
        else
            SubjectCFrame = CurrentCamera.CFrame.Rotation + Vector3.new(CurrentCamera.CFrame.Position.X, p16.Y, CurrentCamera.CFrame.Position.Z)
        end

        local v16 = p11:getRotation(p12)

        if math.abs(v16) > 0 then
            local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
            local v17 = UserCFrame.Rotation + UserCFrame.Position * CurrentCamera.HeadScale
            local v18 = SubjectCFrame * v17

            SubjectCFrame = CFrame.new(v18.Position) * CFrame.Angles(0, -math.rad(v16 * 90), 0) * v18.Rotation * v17:Inverse()
        end
    end

    return SubjectCFrame, SubjectCFrame * CFrame.new(0, 0, -0.5)
end

function self.UpdateThirdPersonComfortTransform(p17, p18, p19, p20, p21, p22) -- line: 265
    -- upvalues: Players (copy), VRService (copy)
    local CameraToSubjectDistance = p17:GetCameraToSubjectDistance()

    if CameraToSubjectDistance < 0.5 then
        CameraToSubjectDistance = 0.5
    end

    local v21

    if p21 == nil or p17.lastCameraFocus == nil then
        v21 = p19
    else
        local _ = Players.LocalPlayer
        local v22 = p21 - p22
        local MoveVector = p17.controlModule:GetMoveVector()
        local v23 = v22.magnitude > 0.01 or MoveVector.magnitude > 0.01

        if v23 then
            p17.motionDetTime = 0.1
        end

        p17.motionDetTime -= p18

        if p17.motionDetTime > 0 then
            v23 = true
        end

        if v23 and not p17.needsReset then
            local lastCameraFocus = p17.lastCameraFocus

            p17.VRCameraFocusFrozen = true

            return p19, lastCameraFocus
        end

        local v24 = p17.lastCameraResetPosition == nil or (p22 - p17.lastCameraResetPosition).Magnitude > 1
        local v25 = p17:getRotation(p18)
        local v26 = p19

        if math.abs(v25) > 0 then
            local v27 = p20:ToObjectSpace(p19)

            v26 = p20 * CFrame.Angles(0, -v25, 0) * v27
        end

        if p17.VRCameraFocusFrozen and v24 or p17.needsReset then
            VRService:RecenterUserHeadCFrame()
            p17.VRCameraFocusFrozen = false
            p17.needsReset = false
            p17.lastCameraResetPosition = p22
            p17:ResetZoom()
            p17:StartFadeFromBlack()

            local Humanoid = p17:GetHumanoid()
            local lookVector = Humanoid.Torso and Humanoid.Torso.CFrame.lookVector or Vector3.new(1, 0, 0)
            local v28 = Vector3.new(lookVector.X, 0, lookVector.Z)
            local v29 = p20.Position - v28 * CameraToSubjectDistance
            local v30 = Vector3.new(p20.Position.X, v29.Y, p20.Position.Z)

            v21 = CFrame.new(v29, v30)
        else
            v21 = v26
        end
    end

    return v21, p20
end

function self.UpdateThirdPersonFollowTransform(p23, p24, _, _, p27, p28) -- line: 332
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

        local v31 = VRFocus * SubjectCFrame.Rotation * CFrame.new(0, 0, CameraToSubjectDistance)

        p23.focusOffset = VRFocus:ToObjectSpace(v31)
        p23.recentered = false

        return v31, VRFocus
    end

    local v32 = VRFocus:ToWorldSpace(p23.focusOffset)
    local _ = Players.LocalPlayer
    local v33 = p27 - p28
    local controlModule = p23.controlModule
    local MoveVector = controlModule:GetMoveVector()

    if v33.magnitude > 0.01 or MoveVector.magnitude > 0 then
        local EstimatedVRTorsoFrame = controlModule:GetEstimatedVRTorsoFrame()
        local v34 = EstimatedVRTorsoFrame.Rotation + EstimatedVRTorsoFrame.Position * CurrentCamera.HeadScale
        local v35 = CurrentCamera.CFrame * v34
        local LookVector = v35.LookVector
        local v36 = Vector3.new(LookVector.X, 0, LookVector.Z).Unit * CameraToSubjectDistance
        local v37 = VRFocus.Position - v36

        v32 = v32:Lerp(CFrame.new(CurrentCamera.CFrame.Position + v37 - v35.Position) * v32.Rotation, 0.01)
    end

    local v38 = p23:getRotation(p24)

    if math.abs(v38) > 0 then
        local v39 = VRFocus:ToObjectSpace(v32)

        v32 = VRFocus * CFrame.Angles(0, -v38, 0) * v39
    end

    p23.focusOffset = VRFocus:ToObjectSpace(v32)

    local v40 = v32 * CFrame.new(0, 0, -CameraToSubjectDistance)

    if (v40.Position - CurrentCamera.Focus.Position).Magnitude > 0.01 then
        p23:StartVREdgeBlur(Players.LocalPlayer)
    end

    return v32, v40
end

function self.LeaveFirstPerson(p29) -- line: 410
    -- upvalues: VRBaseCamera (copy)
    VRBaseCamera.LeaveFirstPerson(p29)
    p29.needsReset = true

    if p29.VRBlur then
        p29.VRBlur.Visible = false
    end

    if p29.characterOrientation then
        p29.characterOrientation.Enabled = false
    end

    local Humanoid = p29:GetHumanoid()

    if Humanoid then
        Humanoid.AutoRotate = p29.savedAutoRotate
    end
end

return self
