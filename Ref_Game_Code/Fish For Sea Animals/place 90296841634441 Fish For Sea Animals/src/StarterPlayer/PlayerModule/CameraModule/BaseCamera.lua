-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local VRService = game:GetService("VRService")
local GuiService = game:GetService("GuiService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local CommonUtils = require(script.Parent.Parent:WaitForChild("CommonUtils"))
local ConnectionUtil = CommonUtils.get("ConnectionUtil")

CommonUtils.get("FlagUtil")

local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"))
local ZoomController = require(script.Parent:WaitForChild("ZoomController"))
local CameraToggleStateController = require(script.Parent:WaitForChild("CameraToggleStateController"))
local CameraInput = require(script.Parent:WaitForChild("CameraInput"))
local CameraUI = require(script.Parent:WaitForChild("CameraUI"))
local CameraGamepadZoomAction = script.Parent.Parent:WaitForChild("InputContexts"):WaitForChild("CameraContext"):WaitForChild("CameraGamepadZoomAction")
local LocalPlayer = Players.LocalPlayer
local _ = {
    CHARACTER_ADDED = "CHARACTER_ADDED",
    CAMERA_MODE_CHANGED = "CAMERA_MODE_CHANGED",
    CAMERA_MIN_DISTANCE_CHANGED = "CAMERA_MIN_DISTANCE_CHANGED",
    CAMERA_MAX_DISTANCE_CHANGED = "CAMERA_MAX_DISTANCE_CHANGED",
    SELECTION_MODE_CHANGED = "SELECTION_MODE_CHANGED"
}
local t1 = {}

t1.__index = t1

function t1.new() -- line: 77
    -- upvalues: UserGameSettings (copy), ConnectionUtil (copy), CameraGamepadZoomAction (copy), LocalPlayer (copy), t1 (copy)
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
    self.gamepadZoomPressConnection = CameraGamepadZoomAction.Pressed:Connect(function() -- line: 126
        -- upvalues: self (copy)
        self:GamepadZoomPress()
    end)
    self.mouseLockOffset = Vector3.new(0, 0, 0)
    UserGameSettings:SetCameraYInvertVisible()
    UserGameSettings:SetGamepadCameraSensitivityVisible()

    return self
end

function t1.GetModuleName(_) -- line: 139
    return "BaseCamera"
end

local function onSelectedObjectChanged() -- line: 143
    -- upvalues: GuiService (copy), CameraGamepadZoomAction (copy)
    CameraGamepadZoomAction.Enabled = not GuiService.SelectedObject
end

function t1:_setUpConfigurations() -- line: 147
    -- upvalues: GuiService (copy), CameraGamepadZoomAction (copy), LocalPlayer (copy)
    self._connections:trackConnection("CHARACTER_ADDED", LocalPlayer.CharacterAdded:Connect(function(p3) -- line: 150
        -- upvalues: self (copy)
        self:OnCharacterAdded(p3)
    end))
    self.humanoidRootPart = nil
    self._connections:trackConnection("CAMERA_MODE_CHANGED", LocalPlayer:GetPropertyChangedSignal("CameraMode"):Connect(function() -- line: 158
        -- upvalues: self (copy)
        self:OnPlayerCameraPropertyChange()
    end))
    self._connections:trackConnection("CAMERA_MIN_DISTANCE_CHANGED", LocalPlayer:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(function() -- line: 164
        -- upvalues: self (copy)
        self:OnPlayerCameraPropertyChange()
    end))
    self._connections:trackConnection("CAMERA_MAX_DISTANCE_CHANGED", LocalPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function() -- line: 170
        -- upvalues: self (copy)
        self:OnPlayerCameraPropertyChange()
    end))
    self._connections:trackConnection("SELECTION_MODE_CHANGED", GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function() -- line: 176
        -- upvalues: GuiService (copy), CameraGamepadZoomAction (copy)
        CameraGamepadZoomAction.Enabled = not GuiService.SelectedObject
    end))
    self:OnPlayerCameraPropertyChange()
end

function t1:OnCharacterAdded(_) -- line: 183
    self.resetCameraAngle = self.resetCameraAngle or self:GetEnabled()
    self.humanoidRootPart = nil
end

function t1:GetHumanoidRootPart() -- line: 190
    -- upvalues: LocalPlayer (copy)
    if not self.humanoidRootPart and LocalPlayer.Character then
        local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            self.humanoidRootPart = Humanoid.RootPart
        end
    end

    return self.humanoidRootPart
end

function t1:GetSubjectCFrame() -- line: 202
    local lastSubjectCFrame = self.lastSubjectCFrame
    local CurrentCamera = workspace.CurrentCamera
    local v2 = CurrentCamera and CurrentCamera.CameraSubject

    if not v2 then
        return lastSubjectCFrame
    end

    local v3 = lastSubjectCFrame

    if v2:IsA("Humanoid") then
        local v4 = v2:GetState() == Enum.HumanoidStateType.Dead
        local CameraOffset = v2.CameraOffset

        if self:GetIsMouseLocked() then
            CameraOffset = Vector3.new()
        end

        local RootPart = v2.RootPart

        if v4 then
            RootPart = v2.Parent and v2.Parent:IsA("Model") and v2.Parent:FindFirstChild("Head") or RootPart
        end

        if RootPart and RootPart:IsA("BasePart") then
            local v5

            if v2.RigType == Enum.HumanoidRigType.R15 then
                if v2.AutomaticScalingEnabled then
                    local RootPart2 = v2.RootPart

                    v5 = if RootPart == RootPart2 then Vector3.new(0, 1.5, 0) + Vector3.new(0, (RootPart2.Size.Y - 2) / 2, 0) else Vector3.new(0, 1.5, 0)
                else
                    v5 = Vector3.new(0, 2, 0)
                end
            else
                v5 = Vector3.new(0, 1.5, 0)
            end

            if v4 then
                v5 = Vector3.new(0, 0, 0)
            end

            v3 = RootPart.CFrame * CFrame.new(v5 + CameraOffset)
        end
    elseif v2:IsA("BasePart") then
        v3 = v2.CFrame
    elseif v2:IsA("Model") then
        v3 = if v2.PrimaryPart then v2:GetPrimaryPartCFrame() else CFrame.new()
    end

    if v3 then
        self.lastSubjectCFrame = v3
    end

    return v3
end

function t1.GetSubjectVelocity(_) -- line: 273
    local CurrentCamera = workspace.CurrentCamera
    local v7 = CurrentCamera and CurrentCamera.CameraSubject

    if v7 then
        if v7:IsA("BasePart") then
            return v7.Velocity
        end

        if v7:IsA("Humanoid") then
            local RootPart = v7.RootPart

            if RootPart then
                return RootPart.Velocity
            end
        elseif v7:IsA("Model") then
            local PrimaryPart = v7.PrimaryPart

            if PrimaryPart then
                return PrimaryPart.Velocity
            end
        end
    end

    return (Vector3.new(0, 0, 0))
end

function t1.GetSubjectRotVelocity(_) -- line: 300
    local CurrentCamera = workspace.CurrentCamera
    local v8 = CurrentCamera and CurrentCamera.CameraSubject

    if v8 then
        if v8:IsA("BasePart") then
            return v8.RotVelocity
        end

        if v8:IsA("Humanoid") then
            local RootPart = v8.RootPart

            if RootPart then
                return RootPart.RotVelocity
            end
        elseif v8:IsA("Model") then
            local PrimaryPart = v8.PrimaryPart

            if PrimaryPart then
                return PrimaryPart.RotVelocity
            end
        end
    end

    return (Vector3.new(0, 0, 0))
end

function t1:StepZoom(p11) -- line: 327
    -- upvalues: ZoomController (copy), CameraInput (copy)
    local currentSubjectDistance = self.currentSubjectDistance
    local v9 = CameraInput.getZoomDelta(p11)

    if math.abs(v9) > 0 then
        local v10 = if v9 > 0 then math.max(currentSubjectDistance + v9 * (currentSubjectDistance * 0.5 + 1), self.FIRST_PERSON_DISTANCE_THRESHOLD) else math.max((currentSubjectDistance + v9) / (1 - v9 * 0.5), 0.5)

        if v10 < self.FIRST_PERSON_DISTANCE_THRESHOLD then
            v10 = 0.5
        end

        self:SetCameraToSubjectDistance(v10)
    end

    return ZoomController.GetZoomRadius()
end

function t1:GetSubjectPosition() -- line: 352
    local lastSubjectPosition = self.lastSubjectPosition
    local CurrentCamera = game.Workspace.CurrentCamera
    local v13 = CurrentCamera and CurrentCamera.CameraSubject

    if not v13 then
        return nil
    end

    local v14 = lastSubjectPosition

    if v13:IsA("Humanoid") then
        local v15 = v13:GetState() == Enum.HumanoidStateType.Dead
        local CameraOffset = v13.CameraOffset

        if self:GetIsMouseLocked() then
            CameraOffset = Vector3.new()
        end

        local RootPart = v13.RootPart

        if v15 then
            RootPart = v13.Parent and v13.Parent:IsA("Model") and v13.Parent:FindFirstChild("Head") or RootPart
        end

        if RootPart and RootPart:IsA("BasePart") then
            local v16 = if v13.RigType ~= Enum.HumanoidRigType.R15 then Vector3.new(0, 1.5, 0)
                elseif not v13.AutomaticScalingEnabled then Vector3.new(0, 2, 0)
                elseif RootPart == v13.RootPart then Vector3.new(0, 1.5, 0) + Vector3.new(0, v13.RootPart.Size.Y / 2 - 1, 0)
                else Vector3.new(0, 1.5, 0)

            if v15 then
                v16 = Vector3.new(0, 0, 0)
            end

            v14 = RootPart.CFrame.Position + RootPart.CFrame:vectorToWorldSpace(v16 + CameraOffset)
        end
    elseif v13:IsA("VehicleSeat") then
        v14 = v13.CFrame.Position + v13.CFrame:vectorToWorldSpace((Vector3.new(0, 5, 0)))
    elseif v13:IsA("SkateboardPlatform") then
        v14 = v13.CFrame.Position + Vector3.new(0, 5, 0)
    elseif v13:IsA("BasePart") then
        v14 = v13.CFrame.Position
    elseif v13:IsA("Model") then
        v14 = if v13.PrimaryPart then v13:GetPrimaryPartCFrame().Position else v13:GetModelCFrame().Position
    end

    self.lastSubject = v13
    self.lastSubjectPosition = v14

    return v14
end

function t1:OnCurrentCameraChanged() -- line: 430
    if self.cameraSubjectChangedConn then
        self.cameraSubjectChangedConn:Disconnect()
        self.cameraSubjectChangedConn = nil
    end

    local CurrentCamera = game.Workspace.CurrentCamera

    if not CurrentCamera then
        return
    end

    self.cameraSubjectChangedConn = CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function() -- line: 439
        -- upvalues: self (copy)
        self:OnNewCameraSubject()
    end)
    self:OnNewCameraSubject()
end

function t1:OnPlayerCameraPropertyChange() -- line: 446
    self:SetCameraToSubjectDistance(self.currentSubjectDistance)
end

function t1.InputTranslationToCameraAngleChange(_, p16, p17) -- line: 451
    return p16 * p17
end

function t1:GamepadZoomPress() -- line: 457
    -- upvalues: LocalPlayer (copy)
    local CameraToSubjectDistance = self:GetCameraToSubjectDistance()
    local v18 = LocalPlayer.CameraMaxZoomDistance

    for i = #self.gamepadZoomLevels, 1, -1 do
        local v19 = self.gamepadZoomLevels[i]

        if not (v18 < v19) then
            local v20 = v19 < LocalPlayer.CameraMinZoomDistance
            local CameraMinZoomDistance, v21

            if v20 then
                CameraMinZoomDistance = LocalPlayer.CameraMinZoomDistance
                v21 = v18 == CameraMinZoomDistance
            end

            if v20 and v21 then
                break
            end

            if v20 then
                v19 = CameraMinZoomDistance
            end

            if v19 + (v18 - v19) / 2 < CameraToSubjectDistance then
                self:SetCameraToSubjectDistance(v19)

                return
            end

            v18 = v19
        end
    end

    self:SetCameraToSubjectDistance(self.gamepadZoomLevels[#self.gamepadZoomLevels])
end

function t1:Enable(p20) -- line: 494
    if self.enabled ~= p20 then
        self.enabled = p20
        self:OnEnabledChanged()
    end
end

function t1:OnEnabledChanged() -- line: 502
    -- upvalues: CameraInput (copy), CameraGamepadZoomAction (copy), LocalPlayer (copy)
    if self.enabled then
        self:_setUpConfigurations()
        CameraInput.setInputEnabled(true)
        CameraGamepadZoomAction.Enabled = true

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

        self.cameraChangedConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 521
            -- upvalues: self (copy)
            self:OnCurrentCameraChanged()
        end)
        self:OnCurrentCameraChanged()
    else
        self._connections:disconnectAll()
        CameraInput.setInputEnabled(false)
        CameraGamepadZoomAction.Enabled = false
        self:Cleanup()
    end
end

function t1:GetEnabled() -- line: 536
    return self.enabled
end

function t1:Cleanup() -- line: 540
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

function t1:UpdateMouseBehavior() -- line: 557
    -- upvalues: UserGameSettings (copy), CameraUtils (copy), CameraToggleStateController (copy), CameraInput (copy), CameraUI (copy)
    local v22 = UserGameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove

    if not self.isCameraToggle or v22 ~= false then
        CameraUI.setCameraModeToastEnabled(false)
        CameraInput.disableCameraToggleInput()

        if self.inFirstPerson or self.inMouseLockedMode then
            CameraUtils.setRotationTypeOverride(Enum.RotationType.CameraRelative)
            CameraUtils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCenter)
        else
            CameraUtils.restoreRotationType()

            if CameraInput.getPanActivated() then
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

function t1:UpdateForDistancePropertyChange() -- line: 585
    self:SetCameraToSubjectDistance(self.currentSubjectDistance)
end

function t1:SetCameraToSubjectDistance(p27) -- line: 591
    -- upvalues: ZoomController (copy), LocalPlayer (copy)
    local currentSubjectDistance = self.currentSubjectDistance

    if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        self.currentSubjectDistance = 0.5

        if not self.inFirstPerson then
            self:EnterFirstPerson()
        end
    else
        local v23 = math.clamp(p27, LocalPlayer.CameraMinZoomDistance, LocalPlayer.CameraMaxZoomDistance)

        if v23 < 1 then
            self.currentSubjectDistance = 0.5

            if not self.inFirstPerson then
                self:EnterFirstPerson()
            end
        else
            self.currentSubjectDistance = v23

            if self.inFirstPerson then
                self:LeaveFirstPerson()
            end
        end
    end

    ZoomController.SetZoomParameters(self.currentSubjectDistance, (math.sign(p27 - currentSubjectDistance)))

    return self.currentSubjectDistance
end

function t1:SetCameraType(p29) -- line: 629
    self.cameraType = p29
end

function t1:GetCameraType() -- line: 634
    return self.cameraType
end

function t1:SetCameraMovementMode(p32) -- line: 639
    self.cameraMovementMode = p32
end

function t1:GetCameraMovementMode() -- line: 643
    return self.cameraMovementMode
end

function t1:SetIsMouseLocked(p35) -- line: 647
    self.inMouseLockedMode = p35
end

function t1:GetIsMouseLocked() -- line: 651
    return self.inMouseLockedMode
end

function t1:SetMouseLockOffset(p38) -- line: 655
    self.mouseLockOffset = p38
end

function t1:GetMouseLockOffset() -- line: 659
    return self.mouseLockOffset
end

function t1:InFirstPerson() -- line: 663
    return self.inFirstPerson
end

function t1:EnterFirstPerson() -- line: 667
    self.inFirstPerson = true
    self:UpdateMouseBehavior()
end

function t1:LeaveFirstPerson() -- line: 672
    self.inFirstPerson = false
    self:UpdateMouseBehavior()
end

function t1:GetCameraToSubjectDistance() -- line: 678
    return self.currentSubjectDistance
end

function t1.GetMeasuredDistanceToFocus(_) -- line: 685
    local CurrentCamera = game.Workspace.CurrentCamera

    return if CurrentCamera then (CurrentCamera.CoordinateFrame.Position - CurrentCamera.Focus.Position).magnitude else nil
end

function t1.GetCameraLookVector(_) -- line: 693
    return game.Workspace.CurrentCamera and game.Workspace.CurrentCamera.CFrame.LookVector or Vector3.new(0, 0, 1)
end

function t1:CalculateNewLookCFrameFromArg(p47, p48) -- line: 697
    p47 = p47 or self:GetCameraLookVector()

    local v26 = math.asin(p47.Y)
    local v29 = math.clamp(p48.Y, v26 + -1.3962634015954636, v26 + 1.3962634015954636)
    local v30 = Vector2.new(p48.X, v29)
    local v31 = CFrame.new(Vector3.new(0, 0, 0), p47)

    return CFrame.Angles(0, -v30.X, 0) * v31 * CFrame.Angles(-v30.Y, 0, 0)
end

function t1:CalculateNewLookVectorFromArg(p50, p51) -- line: 709
    return self:CalculateNewLookCFrameFromArg(p50, p51).LookVector
end

function t1:CalculateNewLookVectorVRFromArg(p53) -- line: 714
    local unit = ((self:GetSubjectPosition() - game.Workspace.CurrentCamera.CFrame.Position) * Vector3.new(1, 0, 1)).unit
    local v32 = Vector2.new(p53.X, 0)
    local v33 = CFrame.new(Vector3.new(0, 0, 0), unit)

    return ((CFrame.Angles(0, -v32.X, 0) * v33 * CFrame.Angles(-v32.Y, 0, 0)).LookVector * Vector3.new(1, 0, 1)).unit
end

function t1:GetHumanoid() -- line: 728
    -- upvalues: LocalPlayer (copy)
    local v34 = LocalPlayer and LocalPlayer.Character

    if not v34 then
        return nil
    end

    local v35 = self.humanoidCache[LocalPlayer]

    if v35 and v35.Parent == v34 then
        return v35
    end

    self.humanoidCache[LocalPlayer] = nil

    local Humanoid = v34:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        self.humanoidCache[LocalPlayer] = Humanoid
    end

    return Humanoid
end

function t1:OnNewCameraSubject() -- line: 746
    if self.subjectStateChangedConn then
        self.subjectStateChangedConn:Disconnect()
        self.subjectStateChangedConn = nil
    end
end

function t1:IsInFirstPerson() -- line: 753
    return self.inFirstPerson
end

function t1.Update(_, _) -- line: 757
    error("BaseCamera:Update() This is a virtual function that should never be getting called.", 2)
end

function t1:GetCameraHeight() -- line: 761
    -- upvalues: VRService (copy)
    if not VRService.VREnabled or self.inFirstPerson then
        return 0
    end

    return 0.25881904510252074 * self.currentSubjectDistance
end

return t1
