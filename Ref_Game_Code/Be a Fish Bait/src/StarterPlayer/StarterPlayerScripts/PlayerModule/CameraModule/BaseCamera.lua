-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")

game:GetService("UserInputService")

local VRService = game:GetService("VRService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local ConnectionUtil = require(CommonUtils:WaitForChild("ConnectionUtil"))

require(CommonUtils:WaitForChild("FlagUtil"))

local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"))
local ZoomController = require(script.Parent:WaitForChild("ZoomController"))
local CameraToggleStateController = require(script.Parent:WaitForChild("CameraToggleStateController"))
local CameraInput = require(script.Parent:WaitForChild("CameraInput"))
local CameraUI = require(script.Parent:WaitForChild("CameraUI"))
local LocalPlayer = Players.LocalPlayer

Vector2.new(0, 0)

local _ = {
    CHARACTER_ADDED = "CHARACTER_ADDED",
    CAMERA_MODE_CHANGED = "CAMERA_MODE_CHANGED",
    CAMERA_MIN_DISTANCE_CHANGED = "CAMERA_MIN_DISTANCE_CHANGED",
    CAMERA_MAX_DISTANCE_CHANGED = "CAMERA_MAX_DISTANCE_CHANGED"
}
local t1 = {}

t1.__index = t1

function t1.new() -- line: 70
    -- upvalues: UserGameSettings (copy), ConnectionUtil (copy), LocalPlayer (copy), t1 (copy)
    local self = setmetatable({}, t1)

    self._connections = ConnectionUtil.new()
    self.gamepadZoomLevels = { 0, 10, 20 }
    self.FIRST_PERSON_DISTANCE_THRESHOLD = 1
    self.cameraType = nil
    self.cameraMovementMode = nil
    self.lastCameraTransform = nil
    self.lastUserPanCamera = tick()
    self.humanoidRootPart = nil
    self.humanoidCache = {}
    self.lastSubject = nil
    self.lastSubjectPosition = Vector3.new(0, 5, 0)
    self.lastSubjectCFrame = CFrame.new(self.lastSubjectPosition)
    self.currentSubjectDistance = math.clamp(12.5, LocalPlayer.CameraMinZoomDistance, LocalPlayer.CameraMaxZoomDistance)
    self.inFirstPerson = false
    self.inMouseLockedMode = false
    self.resetCameraAngle = true
    self.enabled = false
    self.cameraChangedConn = nil
    self.shouldUseVRRotation = false
    self.VRRotationIntensityAvailable = false
    self.lastVRRotationIntensityCheckTime = 0
    self.lastVRRotationTime = 0
    self.vrRotateKeyCooldown = {}
    self.cameraTranslationConstraints = Vector3.new(1, 1, 1)
    self.humanoidJumpOrigin = nil
    self.trackingHumanoid = nil
    self.cameraFrozen = false
    self.subjectStateChangedConn = nil
    self.gamepadZoomPressConnection = nil
    self.mouseLockOffset = Vector3.new(0, 0, 0)
    UserGameSettings:SetCameraYInvertVisible()
    UserGameSettings:SetGamepadCameraSensitivityVisible()

    return self
end

function t1.GetModuleName(_) -- line: 130
    return "BaseCamera"
end

function t1:_setUpConfigurations() -- line: 134
    -- upvalues: LocalPlayer (copy)
    self._connections:trackConnection("CHARACTER_ADDED", LocalPlayer.CharacterAdded:Connect(function(p3) -- line: 135
        -- upvalues: self (copy)
        self:OnCharacterAdded(p3)
    end))
    self.humanoidRootPart = nil
    self._connections:trackConnection("CAMERA_MODE_CHANGED", LocalPlayer:GetPropertyChangedSignal("CameraMode"):Connect(function() -- line: 140
        -- upvalues: self (copy)
        self:OnPlayerCameraPropertyChange()
    end))
    self._connections:trackConnection("CAMERA_MIN_DISTANCE_CHANGED", LocalPlayer:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(function() -- line: 143
        -- upvalues: self (copy)
        self:OnPlayerCameraPropertyChange()
    end))
    self._connections:trackConnection("CAMERA_MAX_DISTANCE_CHANGED", LocalPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function() -- line: 146
        -- upvalues: self (copy)
        self:OnPlayerCameraPropertyChange()
    end))
    self:OnPlayerCameraPropertyChange()
end

function t1:OnCharacterAdded(_) -- line: 152
    self.resetCameraAngle = self.resetCameraAngle or self:GetEnabled()
    self.humanoidRootPart = nil
end

function t1:GetHumanoidRootPart() -- line: 159
    -- upvalues: LocalPlayer (copy)
    if not self.humanoidRootPart and LocalPlayer.Character then
        local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            self.humanoidRootPart = Humanoid.RootPart
        end
    end

    return self.humanoidRootPart
end

function t1.GetBodyPartToFollow(_, p8, _) -- line: 171
    if p8:GetState() == Enum.HumanoidStateType.Dead then
        local Parent = p8.Parent
        local v2

        if Parent and Parent:IsA("Model") then
            v2 = Parent:FindFirstChild("Head") or p8.RootPart

            return v2
        end
    end

    return p8.RootPart
end

function t1:GetSubjectCFrame() -- line: 183
    local lastSubjectCFrame = self.lastSubjectCFrame
    local CurrentCamera = workspace.CurrentCamera
    local v3 = CurrentCamera and CurrentCamera.CameraSubject

    if not v3 then
        return lastSubjectCFrame
    end

    local v4 = lastSubjectCFrame

    if v3:IsA("Humanoid") then
        local v5 = v3:GetState() == Enum.HumanoidStateType.Dead
        local CameraOffset = v3.CameraOffset

        if self:GetIsMouseLocked() then
            CameraOffset = Vector3.new()
        end

        local RootPart = v3.RootPart

        if v5 then
            RootPart = v3.Parent and v3.Parent:IsA("Model") and v3.Parent:FindFirstChild("Head") or RootPart
        end

        if RootPart and RootPart:IsA("BasePart") then
            local v6

            if v3.RigType == Enum.HumanoidRigType.R15 then
                if v3.AutomaticScalingEnabled then
                    local RootPart2 = v3.RootPart

                    v6 = if RootPart == RootPart2 then Vector3.new(0, 1.5, 0) + Vector3.new(0, (RootPart2.Size.Y - 2) / 2, 0) else Vector3.new(0, 1.5, 0)
                else
                    v6 = Vector3.new(0, 2, 0)
                end
            else
                v6 = Vector3.new(0, 1.5, 0)
            end

            if v5 then
                v6 = Vector3.new(0, 0, 0)
            end

            v4 = RootPart.CFrame * CFrame.new(v6 + CameraOffset)
        end
    elseif v3:IsA("BasePart") then
        v4 = v3.CFrame
    elseif v3:IsA("Model") then
        v4 = if v3.PrimaryPart then v3:GetPrimaryPartCFrame() else CFrame.new()
    end

    if v4 then
        self.lastSubjectCFrame = v4
    end

    return v4
end

function t1.GetSubjectVelocity(_) -- line: 257
    local CurrentCamera = workspace.CurrentCamera
    local v8 = CurrentCamera and CurrentCamera.CameraSubject

    if v8 then
        if v8:IsA("BasePart") then
            return v8.Velocity
        end

        if v8:IsA("Humanoid") then
            local RootPart = v8.RootPart

            if RootPart then
                return RootPart.Velocity
            end
        elseif v8:IsA("Model") then
            local PrimaryPart = v8.PrimaryPart

            if PrimaryPart then
                return PrimaryPart.Velocity
            end
        end
    end

    return (Vector3.new(0, 0, 0))
end

function t1.GetSubjectRotVelocity(_) -- line: 286
    local CurrentCamera = workspace.CurrentCamera
    local v9 = CurrentCamera and CurrentCamera.CameraSubject

    if v9 then
        if v9:IsA("BasePart") then
            return v9.RotVelocity
        end

        if v9:IsA("Humanoid") then
            local RootPart = v9.RootPart

            if RootPart then
                return RootPart.RotVelocity
            end
        elseif v9:IsA("Model") then
            local PrimaryPart = v9.PrimaryPart

            if PrimaryPart then
                return PrimaryPart.RotVelocity
            end
        end
    end

    return (Vector3.new(0, 0, 0))
end

function t1:StepZoom() -- line: 315
    -- upvalues: ZoomController (copy), CameraInput (copy)
    local currentSubjectDistance = self.currentSubjectDistance
    local v10 = CameraInput.getZoomDelta()

    if math.abs(v10) > 0 then
        local v11 = if v10 > 0 then math.max(currentSubjectDistance + v10 * (currentSubjectDistance * 0.5 + 1), self.FIRST_PERSON_DISTANCE_THRESHOLD) else math.max((currentSubjectDistance + v10) / (1 - v10 * 0.5), 0.5)

        if v11 < self.FIRST_PERSON_DISTANCE_THRESHOLD then
            v11 = 0.5
        end

        self:SetCameraToSubjectDistance(v11)
    end

    return ZoomController.GetZoomRadius()
end

function t1:GetSubjectPosition() -- line: 340
    local lastSubjectPosition = self.lastSubjectPosition
    local CurrentCamera = game.Workspace.CurrentCamera
    local v14 = CurrentCamera and CurrentCamera.CameraSubject

    if not v14 then
        return nil
    end

    local v15 = lastSubjectPosition

    if v14:IsA("Humanoid") then
        local v16 = v14:GetState() == Enum.HumanoidStateType.Dead
        local CameraOffset = v14.CameraOffset

        if self:GetIsMouseLocked() then
            CameraOffset = Vector3.new()
        end

        local RootPart = v14.RootPart

        if v16 then
            RootPart = v14.Parent and v14.Parent:IsA("Model") and v14.Parent:FindFirstChild("Head") or RootPart
        end

        if RootPart and RootPart:IsA("BasePart") then
            local v17 = if v14.RigType ~= Enum.HumanoidRigType.R15 then Vector3.new(0, 1.5, 0)
                elseif not v14.AutomaticScalingEnabled then Vector3.new(0, 2, 0)
                elseif RootPart == v14.RootPart then Vector3.new(0, 1.5, 0) + Vector3.new(0, v14.RootPart.Size.Y / 2 - 1, 0)
                else Vector3.new(0, 1.5, 0)

            if v16 then
                v17 = Vector3.new(0, 0, 0)
            end

            v15 = RootPart.CFrame.p + RootPart.CFrame:vectorToWorldSpace(v17 + CameraOffset)
        end
    elseif v14:IsA("VehicleSeat") then
        v15 = v14.CFrame.p + v14.CFrame:vectorToWorldSpace((Vector3.new(0, 5, 0)))
    elseif v14:IsA("SkateboardPlatform") then
        v15 = v14.CFrame.p + Vector3.new(0, 5, 0)
    elseif v14:IsA("BasePart") then
        v15 = v14.CFrame.p
    elseif v14:IsA("Model") then
        v15 = if v14.PrimaryPart then v14:GetPrimaryPartCFrame().p else v14:GetModelCFrame().p
    end

    self.lastSubject = v14
    self.lastSubjectPosition = v15

    return v15
end

function t1:OnCurrentCameraChanged() -- line: 418
    if self.cameraSubjectChangedConn then
        self.cameraSubjectChangedConn:Disconnect()
        self.cameraSubjectChangedConn = nil
    end

    local CurrentCamera = game.Workspace.CurrentCamera

    if not CurrentCamera then
        return
    end

    self.cameraSubjectChangedConn = CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function() -- line: 427
        -- upvalues: self (copy)
        self:OnNewCameraSubject()
    end)
    self:OnNewCameraSubject()
end

function t1:OnPlayerCameraPropertyChange() -- line: 434
    self:SetCameraToSubjectDistance(self.currentSubjectDistance)
end

function t1.InputTranslationToCameraAngleChange(_, p18, p19) -- line: 439
    return p18 * p19
end

function t1:GamepadZoomPress() -- line: 445
    -- upvalues: LocalPlayer (copy)
    local CameraToSubjectDistance = self:GetCameraToSubjectDistance()
    local v19 = LocalPlayer.CameraMaxZoomDistance

    for i = #self.gamepadZoomLevels, 1, -1 do
        local v20 = self.gamepadZoomLevels[i]

        if not (v19 < v20) then
            local v21 = v20 < LocalPlayer.CameraMinZoomDistance
            local CameraMinZoomDistance, v22

            if v21 then
                CameraMinZoomDistance = LocalPlayer.CameraMinZoomDistance
                v22 = v19 == CameraMinZoomDistance
            end

            if v21 and v22 then
                break
            end

            if v21 then
                v20 = CameraMinZoomDistance
            end

            if v20 + (v19 - v20) / 2 < CameraToSubjectDistance then
                self:SetCameraToSubjectDistance(v20)

                return
            end

            v19 = v20
        end
    end

    self:SetCameraToSubjectDistance(self.gamepadZoomLevels[#self.gamepadZoomLevels])
end

function t1:Enable(p22) -- line: 482
    if self.enabled ~= p22 then
        self.enabled = p22
        self:OnEnabledChanged()
    end
end

function t1:OnEnabledChanged() -- line: 490
    -- upvalues: CameraInput (copy), LocalPlayer (copy)
    if self.enabled then
        self:_setUpConfigurations()
        CameraInput.setInputEnabled(true)
        self.gamepadZoomPressConnection = CameraInput.gamepadZoomPress:Connect(function() -- line: 496
            -- upvalues: self (copy)
            self:GamepadZoomPress()
        end)

        if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
            self.currentSubjectDistance = 0.5

            if not self.inFirstPerson then
                self:EnterFirstPerson()
            end
        end

        if self.cameraChangedConn then
            self.cameraChangedConn:Disconnect()
            self.cameraChangedConn = nil
        end

        self.cameraChangedConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 508
            -- upvalues: self (copy)
            self:OnCurrentCameraChanged()
        end)
        self:OnCurrentCameraChanged()
    else
        self._connections:disconnectAll()
        CameraInput.setInputEnabled(false)

        if self.gamepadZoomPressConnection then
            self.gamepadZoomPressConnection:Disconnect()
            self.gamepadZoomPressConnection = nil
        end

        self:Cleanup()
    end
end

function t1:GetEnabled() -- line: 526
    return self.enabled
end

function t1:Cleanup() -- line: 530
    -- upvalues: CameraUtils (copy)
    if self.subjectStateChangedConn then
        self.subjectStateChangedConn:Disconnect()
        self.subjectStateChangedConn = nil
    end

    if self.cameraChangedConn then
        self.cameraChangedConn:Disconnect()
        self.cameraChangedConn = nil
    end

    self.lastCameraTransform = nil
    self.lastSubjectCFrame = nil
    CameraUtils.restoreMouseBehavior()
end

function t1:UpdateMouseBehavior() -- line: 547
    -- upvalues: UserGameSettings (copy), CameraUtils (copy), CameraToggleStateController (copy), CameraInput (copy), CameraUI (copy)
    local v23 = UserGameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove

    if not self.isCameraToggle or v23 ~= false then
        CameraUI.setCameraModeToastEnabled(false)
        CameraInput.disableCameraToggleInput()

        if self.inFirstPerson or self.inMouseLockedMode then
            CameraUtils.setRotationTypeOverride(Enum.RotationType.CameraRelative)
            CameraUtils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCenter)
        else
            CameraUtils.restoreRotationType()

            if CameraInput.getRotationActivated() then
                CameraUtils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCurrentPosition)
            else
                CameraUtils.restoreMouseBehavior()
            end
        end
    else
        CameraUI.setCameraModeToastEnabled(true)
        CameraInput.enableCameraToggleInput()
        CameraToggleStateController(self.inFirstPerson)
    end
end

function t1:UpdateForDistancePropertyChange() -- line: 575
    self:SetCameraToSubjectDistance(self.currentSubjectDistance)
end

function t1:SetCameraToSubjectDistance(p29) -- line: 581
    -- upvalues: ZoomController (copy), LocalPlayer (copy)
    local currentSubjectDistance = self.currentSubjectDistance

    if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        self.currentSubjectDistance = 0.5

        if not self.inFirstPerson then
            self:EnterFirstPerson()
        end
    else
        local v24 = math.clamp(p29, LocalPlayer.CameraMinZoomDistance, LocalPlayer.CameraMaxZoomDistance)

        if v24 < 1 then
            self.currentSubjectDistance = 0.5

            if not self.inFirstPerson then
                self:EnterFirstPerson()
            end
        else
            self.currentSubjectDistance = v24

            if self.inFirstPerson then
                self:LeaveFirstPerson()
            end
        end
    end

    ZoomController.SetZoomParameters(self.currentSubjectDistance, (math.sign(p29 - currentSubjectDistance)))

    return self.currentSubjectDistance
end

function t1:SetCameraType(p31) -- line: 615
    self.cameraType = p31
end

function t1:GetCameraType() -- line: 620
    return self.cameraType
end

function t1:SetCameraMovementMode(p34) -- line: 625
    self.cameraMovementMode = p34
end

function t1:GetCameraMovementMode() -- line: 629
    return self.cameraMovementMode
end

function t1:SetIsMouseLocked(p37) -- line: 633
    self.inMouseLockedMode = p37
end

function t1:GetIsMouseLocked() -- line: 637
    return self.inMouseLockedMode
end

function t1:SetMouseLockOffset(p40) -- line: 641
    self.mouseLockOffset = p40
end

function t1:GetMouseLockOffset() -- line: 645
    return self.mouseLockOffset
end

function t1:InFirstPerson() -- line: 649
    return self.inFirstPerson
end

function t1:EnterFirstPerson() -- line: 653
    self.inFirstPerson = true
    self:UpdateMouseBehavior()
end

function t1:LeaveFirstPerson() -- line: 658
    self.inFirstPerson = false
    self:UpdateMouseBehavior()
end

function t1:GetCameraToSubjectDistance() -- line: 664
    return self.currentSubjectDistance
end

function t1.GetMeasuredDistanceToFocus(_) -- line: 671
    local CurrentCamera = game.Workspace.CurrentCamera

    return if CurrentCamera then (CurrentCamera.CoordinateFrame.p - CurrentCamera.Focus.p).magnitude else nil
end

function t1.GetCameraLookVector(_) -- line: 679
    return game.Workspace.CurrentCamera and game.Workspace.CurrentCamera.CFrame.LookVector or Vector3.new(0, 0, 1)
end

function t1:CalculateNewLookCFrameFromArg(p49, p50) -- line: 683
    p49 = p49 or self:GetCameraLookVector()

    local v27 = math.asin(p49.Y)
    local v30 = math.clamp(p50.Y, v27 + -1.3962634015954636, v27 + 1.3962634015954636)
    local v31 = Vector2.new(p50.X, v30)
    local v32 = CFrame.new(Vector3.new(0, 0, 0), p49)

    return CFrame.Angles(0, -v31.X, 0) * v32 * CFrame.Angles(-v31.Y, 0, 0)
end

function t1:CalculateNewLookVectorFromArg(p52, p53) -- line: 693
    return self:CalculateNewLookCFrameFromArg(p52, p53).LookVector
end

function t1:CalculateNewLookVectorVRFromArg(p55) -- line: 698
    local unit = ((self:GetSubjectPosition() - game.Workspace.CurrentCamera.CFrame.p) * Vector3.new(1, 0, 1)).unit
    local v33 = Vector2.new(p55.X, 0)
    local v34 = CFrame.new(Vector3.new(0, 0, 0), unit)

    return ((CFrame.Angles(0, -v33.X, 0) * v34 * CFrame.Angles(-v33.Y, 0, 0)).LookVector * Vector3.new(1, 0, 1)).unit
end

function t1:GetHumanoid() -- line: 708
    -- upvalues: LocalPlayer (copy)
    local v35 = LocalPlayer and LocalPlayer.Character

    if not v35 then
        return nil
    end

    local v36 = self.humanoidCache[LocalPlayer]

    if v36 and v36.Parent == v35 then
        return v36
    end

    self.humanoidCache[LocalPlayer] = nil

    local Humanoid = v35:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        self.humanoidCache[LocalPlayer] = Humanoid
    end

    return Humanoid
end

function t1.GetHumanoidPartToFollow(_, p58, p59) -- line: 726
    if p59 ~= Enum.HumanoidStateType.Dead then
        return p58.Torso
    end

    local Parent = p58.Parent

    return Parent and Parent:FindFirstChild("Head") or p58.Torso
end

function t1:OnNewCameraSubject() -- line: 740
    if self.subjectStateChangedConn then
        self.subjectStateChangedConn:Disconnect()
        self.subjectStateChangedConn = nil
    end
end

function t1:IsInFirstPerson() -- line: 747
    return self.inFirstPerson
end

function t1.Update(_, _) -- line: 751
    error("BaseCamera:Update() This is a virtual function that should never be getting called.", 2)
end

function t1:GetCameraHeight() -- line: 755
    -- upvalues: VRService (copy)
    if not VRService.VREnabled or self.inFirstPerson then
        return 0
    end

    return 0.25881904510252074 * self.currentSubjectDistance
end

return t1
