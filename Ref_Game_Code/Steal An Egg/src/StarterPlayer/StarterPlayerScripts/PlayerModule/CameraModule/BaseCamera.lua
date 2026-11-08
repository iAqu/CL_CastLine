-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local ConnectionUtil = require(CommonUtils:WaitForChild("ConnectionUtil"))
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"))
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"))
local ZoomController = require(script.Parent:WaitForChild("ZoomController"))
local CameraToggleStateController = require(script.Parent:WaitForChild("CameraToggleStateController"))
local CameraInput = require(script.Parent:WaitForChild("CameraInput"))
local CameraUI = require(script.Parent:WaitForChild("CameraUI"))
local LocalPlayer = Players.LocalPlayer

local function v1() -- line: 24
    return UserSettings():IsUserFeatureEnabled("UserFixGamepadMaxZoom")
end

local ok, result = pcall(v1)
local v2 = ok and result
local UserPSRemoveTouchEnabled = FlagUtil.getUserFlag("UserPSRemoveTouchEnabled")

Vector2.new(0, 0)

local _ = {
    CHARACTER_ADDED = "CHARACTER_ADDED",
    CAMERA_MODE_CHANGED = "CAMERA_MODE_CHANGED",
    CAMERA_MIN_DISTANCE_CHANGED = "CAMERA_MIN_DISTANCE_CHANGED",
    CAMERA_MAX_DISTANCE_CHANGED = "CAMERA_MAX_DISTANCE_CHANGED"
}
local t1 = {}

t1.__index = t1

function t1.new() -- line: 80
    -- upvalues: UserGameSettings (copy), ConnectionUtil (copy), LocalPlayer (copy), UserPSRemoveTouchEnabled (copy), t1 (copy)
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

    if not UserPSRemoveTouchEnabled then
        self.portraitMode = false
        self.isSmallTouchScreen = false
    end

    self.resetCameraAngle = true
    self.enabled = false
    self.cameraChangedConn = nil

    if not UserPSRemoveTouchEnabled then
        self.viewportSizeChangedConn = nil
    end

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

function t1.GetModuleName(_) -- line: 147
    return "BaseCamera"
end

function t1:_setUpConfigurations() -- line: 151
    -- upvalues: LocalPlayer (copy)
    self._connections:trackConnection("CHARACTER_ADDED", LocalPlayer.CharacterAdded:Connect(function(p3) -- line: 152
        -- upvalues: self (copy)
        self:OnCharacterAdded(p3)
    end))
    self.humanoidRootPart = nil
    self._connections:trackConnection("CAMERA_MODE_CHANGED", LocalPlayer:GetPropertyChangedSignal("CameraMode"):Connect(function() -- line: 157
        -- upvalues: self (copy)
        self:OnPlayerCameraPropertyChange()
    end))
    self._connections:trackConnection("CAMERA_MIN_DISTANCE_CHANGED", LocalPlayer:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(function() -- line: 160
        -- upvalues: self (copy)
        self:OnPlayerCameraPropertyChange()
    end))
    self._connections:trackConnection("CAMERA_MAX_DISTANCE_CHANGED", LocalPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function() -- line: 163
        -- upvalues: self (copy)
        self:OnPlayerCameraPropertyChange()
    end))
    self:OnPlayerCameraPropertyChange()
end

function t1:OnCharacterAdded(_) -- line: 169
    self.resetCameraAngle = self.resetCameraAngle or self:GetEnabled()
    self.humanoidRootPart = nil
end

function t1:GetHumanoidRootPart() -- line: 176
    -- upvalues: LocalPlayer (copy)
    if not self.humanoidRootPart and LocalPlayer.Character then
        local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            self.humanoidRootPart = Humanoid.RootPart
        end
    end

    return self.humanoidRootPart
end

function t1.GetBodyPartToFollow(_, p8, _) -- line: 188
    if p8:GetState() == Enum.HumanoidStateType.Dead then
        local Parent = p8.Parent
        local v4

        if Parent and Parent:IsA("Model") then
            v4 = Parent:FindFirstChild("Head") or p8.RootPart

            return v4
        end
    end

    return p8.RootPart
end

function t1:GetSubjectCFrame() -- line: 200
    local lastSubjectCFrame = self.lastSubjectCFrame
    local CurrentCamera = workspace.CurrentCamera
    local v5 = CurrentCamera and CurrentCamera.CameraSubject

    if not v5 then
        return lastSubjectCFrame
    end

    local v6 = lastSubjectCFrame

    if v5:IsA("Humanoid") then
        local v7 = v5:GetState() == Enum.HumanoidStateType.Dead
        local CameraOffset = v5.CameraOffset

        if self:GetIsMouseLocked() then
            CameraOffset = Vector3.new()
        end

        local RootPart = v5.RootPart

        if v7 then
            RootPart = v5.Parent and v5.Parent:IsA("Model") and v5.Parent:FindFirstChild("Head") or RootPart
        end

        if RootPart and RootPart:IsA("BasePart") then
            local v8

            if v5.RigType == Enum.HumanoidRigType.R15 then
                if v5.AutomaticScalingEnabled then
                    local RootPart2 = v5.RootPart

                    v8 = if RootPart == RootPart2 then Vector3.new(0, 1.5, 0) + Vector3.new(0, (RootPart2.Size.Y - 2) / 2, 0) else Vector3.new(0, 1.5, 0)
                else
                    v8 = Vector3.new(0, 2, 0)
                end
            else
                v8 = Vector3.new(0, 1.5, 0)
            end

            if v7 then
                v8 = Vector3.new(0, 0, 0)
            end

            v6 = RootPart.CFrame * CFrame.new(v8 + CameraOffset)
        end
    elseif v5:IsA("BasePart") then
        v6 = v5.CFrame
    elseif v5:IsA("Model") then
        v6 = if v5.PrimaryPart then v5:GetPrimaryPartCFrame() else CFrame.new()
    end

    if v6 then
        self.lastSubjectCFrame = v6
    end

    return v6
end

function t1.GetSubjectVelocity(_) -- line: 274
    local CurrentCamera = workspace.CurrentCamera
    local v10 = CurrentCamera and CurrentCamera.CameraSubject

    if v10 then
        if v10:IsA("BasePart") then
            return v10.Velocity
        end

        if v10:IsA("Humanoid") then
            local RootPart = v10.RootPart

            if RootPart then
                return RootPart.Velocity
            end
        elseif v10:IsA("Model") then
            local PrimaryPart = v10.PrimaryPart

            if PrimaryPart then
                return PrimaryPart.Velocity
            end
        end
    end

    return (Vector3.new(0, 0, 0))
end

function t1.GetSubjectRotVelocity(_) -- line: 303
    local CurrentCamera = workspace.CurrentCamera
    local v11 = CurrentCamera and CurrentCamera.CameraSubject

    if v11 then
        if v11:IsA("BasePart") then
            return v11.RotVelocity
        end

        if v11:IsA("Humanoid") then
            local RootPart = v11.RootPart

            if RootPart then
                return RootPart.RotVelocity
            end
        elseif v11:IsA("Model") then
            local PrimaryPart = v11.PrimaryPart

            if PrimaryPart then
                return PrimaryPart.RotVelocity
            end
        end
    end

    return (Vector3.new(0, 0, 0))
end

function t1:StepZoom() -- line: 332
    -- upvalues: ZoomController (copy), CameraInput (copy)
    local currentSubjectDistance = self.currentSubjectDistance
    local v12 = CameraInput.getZoomDelta()

    if math.abs(v12) > 0 then
        local v13 = if v12 > 0 then math.max(currentSubjectDistance + v12 * (currentSubjectDistance * 0.5 + 1), self.FIRST_PERSON_DISTANCE_THRESHOLD) else math.max((currentSubjectDistance + v12) / (1 - v12 * 0.5), 0.5)

        if v13 < self.FIRST_PERSON_DISTANCE_THRESHOLD then
            v13 = 0.5
        end

        self:SetCameraToSubjectDistance(v13)
    end

    return ZoomController.GetZoomRadius()
end

function t1:GetSubjectPosition() -- line: 357
    local lastSubjectPosition = self.lastSubjectPosition
    local CurrentCamera = game.Workspace.CurrentCamera
    local v16 = CurrentCamera and CurrentCamera.CameraSubject

    if not v16 then
        return nil
    end

    local v17 = lastSubjectPosition

    if v16:IsA("Humanoid") then
        local v18 = v16:GetState() == Enum.HumanoidStateType.Dead
        local CameraOffset = v16.CameraOffset

        if self:GetIsMouseLocked() then
            CameraOffset = Vector3.new()
        end

        local RootPart = v16.RootPart

        if v18 then
            RootPart = v16.Parent and v16.Parent:IsA("Model") and v16.Parent:FindFirstChild("Head") or RootPart
        end

        if RootPart and RootPart:IsA("BasePart") then
            local v19 = if v16.RigType ~= Enum.HumanoidRigType.R15 then Vector3.new(0, 1.5, 0)
                elseif not v16.AutomaticScalingEnabled then Vector3.new(0, 2, 0)
                elseif RootPart == v16.RootPart then Vector3.new(0, 1.5, 0) + Vector3.new(0, v16.RootPart.Size.Y / 2 - 1, 0)
                else Vector3.new(0, 1.5, 0)

            if v18 then
                v19 = Vector3.new(0, 0, 0)
            end

            v17 = RootPart.CFrame.p + RootPart.CFrame:vectorToWorldSpace(v19 + CameraOffset)
        end
    elseif v16:IsA("VehicleSeat") then
        v17 = v16.CFrame.p + v16.CFrame:vectorToWorldSpace((Vector3.new(0, 5, 0)))
    elseif v16:IsA("SkateboardPlatform") then
        v17 = v16.CFrame.p + Vector3.new(0, 5, 0)
    elseif v16:IsA("BasePart") then
        v17 = v16.CFrame.p
    elseif v16:IsA("Model") then
        v17 = if v16.PrimaryPart then v16:GetPrimaryPartCFrame().p else v16:GetModelCFrame().p
    end

    self.lastSubject = v16
    self.lastSubjectPosition = v17

    return v17
end

if not UserPSRemoveTouchEnabled then
    function t1:OnViewportSizeChanged() -- line: 435
        -- upvalues: UserInputService (copy)
        local ViewportSize = game.Workspace.CurrentCamera.ViewportSize

        self.portraitMode = ViewportSize.X < ViewportSize.Y

        local TouchEnabled = UserInputService.TouchEnabled and (ViewportSize.Y < 500 or ViewportSize.X < 700)

        self.isSmallTouchScreen = TouchEnabled
    end
end

function t1:OnCurrentCameraChanged() -- line: 444
    -- upvalues: UserInputService (copy), UserPSRemoveTouchEnabled (copy)
    if not UserPSRemoveTouchEnabled and UserInputService.TouchEnabled then
        if self.viewportSizeChangedConn then
            self.viewportSizeChangedConn:Disconnect()
            self.viewportSizeChangedConn = nil
        end

        local CurrentCamera = game.Workspace.CurrentCamera

        if CurrentCamera then
            self:OnViewportSizeChanged()
            self.viewportSizeChangedConn = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 456
                -- upvalues: self (copy)
                self:OnViewportSizeChanged()
            end)
        end
    end

    if self.cameraSubjectChangedConn then
        self.cameraSubjectChangedConn:Disconnect()
        self.cameraSubjectChangedConn = nil
    end

    local CurrentCamera = game.Workspace.CurrentCamera

    if not CurrentCamera then
        return
    end

    self.cameraSubjectChangedConn = CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function() -- line: 471
        -- upvalues: self (copy)
        self:OnNewCameraSubject()
    end)
    self:OnNewCameraSubject()
end

function t1:OnPlayerCameraPropertyChange() -- line: 478
    self:SetCameraToSubjectDistance(self.currentSubjectDistance)
end

function t1.InputTranslationToCameraAngleChange(_, p19, p20) -- line: 483
    return p19 * p20
end

function t1:GamepadZoomPress() -- line: 489
    -- upvalues: LocalPlayer (copy), v2 (copy)
    local CameraToSubjectDistance = self:GetCameraToSubjectDistance()
    local v21 = LocalPlayer.CameraMaxZoomDistance

    for i = #self.gamepadZoomLevels, 1, -1 do
        local v22 = self.gamepadZoomLevels[i]

        if not (v21 < v22) then
            if v22 < LocalPlayer.CameraMinZoomDistance then
                v22 = LocalPlayer.CameraMinZoomDistance

                if v2 and v21 == v22 then
                    break
                end
            end

            if not v2 and v21 == v22 then
                break
            end

            if v22 + (v21 - v22) / 2 < CameraToSubjectDistance then
                self:SetCameraToSubjectDistance(v22)

                return
            end

            v21 = v22
        end
    end

    self:SetCameraToSubjectDistance(self.gamepadZoomLevels[#self.gamepadZoomLevels])
end

function t1:Enable(p23) -- line: 534
    if self.enabled ~= p23 then
        self.enabled = p23
        self:OnEnabledChanged()
    end
end

function t1:OnEnabledChanged() -- line: 542
    -- upvalues: CameraInput (copy), LocalPlayer (copy)
    if self.enabled then
        self:_setUpConfigurations()
        CameraInput.setInputEnabled(true)
        self.gamepadZoomPressConnection = CameraInput.gamepadZoomPress:Connect(function() -- line: 548
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

        self.cameraChangedConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 560
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

function t1:GetEnabled() -- line: 578
    return self.enabled
end

function t1:Cleanup() -- line: 582
    -- upvalues: CameraUtils (copy), UserPSRemoveTouchEnabled (copy)
    if self.subjectStateChangedConn then
        self.subjectStateChangedConn:Disconnect()
        self.subjectStateChangedConn = nil
    end

    if not UserPSRemoveTouchEnabled and self.viewportSizeChangedConn then
        self.viewportSizeChangedConn:Disconnect()
        self.viewportSizeChangedConn = nil
    end

    if self.cameraChangedConn then
        self.cameraChangedConn:Disconnect()
        self.cameraChangedConn = nil
    end

    self.lastCameraTransform = nil
    self.lastSubjectCFrame = nil
    CameraUtils.restoreMouseBehavior()
end

function t1:UpdateMouseBehavior() -- line: 605
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

function t1:UpdateForDistancePropertyChange() -- line: 633
    self:SetCameraToSubjectDistance(self.currentSubjectDistance)
end

function t1:SetCameraToSubjectDistance(p30) -- line: 639
    -- upvalues: ZoomController (copy), LocalPlayer (copy)
    local currentSubjectDistance = self.currentSubjectDistance

    if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        self.currentSubjectDistance = 0.5

        if not self.inFirstPerson then
            self:EnterFirstPerson()
        end
    else
        local v24 = math.clamp(p30, LocalPlayer.CameraMinZoomDistance, LocalPlayer.CameraMaxZoomDistance)

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

    ZoomController.SetZoomParameters(self.currentSubjectDistance, (math.sign(p30 - currentSubjectDistance)))

    return self.currentSubjectDistance
end

function t1:SetCameraType(p32) -- line: 673
    self.cameraType = p32
end

function t1:GetCameraType() -- line: 678
    return self.cameraType
end

function t1:SetCameraMovementMode(p35) -- line: 683
    self.cameraMovementMode = p35
end

function t1:GetCameraMovementMode() -- line: 687
    return self.cameraMovementMode
end

function t1:SetIsMouseLocked(p38) -- line: 691
    self.inMouseLockedMode = p38
end

function t1:GetIsMouseLocked() -- line: 695
    return self.inMouseLockedMode
end

function t1:SetMouseLockOffset(p41) -- line: 699
    self.mouseLockOffset = p41
end

function t1:GetMouseLockOffset() -- line: 703
    return self.mouseLockOffset
end

function t1:InFirstPerson() -- line: 707
    return self.inFirstPerson
end

function t1:EnterFirstPerson() -- line: 711
    self.inFirstPerson = true
    self:UpdateMouseBehavior()
end

function t1:LeaveFirstPerson() -- line: 716
    self.inFirstPerson = false
    self:UpdateMouseBehavior()
end

function t1:GetCameraToSubjectDistance() -- line: 722
    return self.currentSubjectDistance
end

function t1.GetMeasuredDistanceToFocus(_) -- line: 729
    local CurrentCamera = game.Workspace.CurrentCamera

    return if CurrentCamera then (CurrentCamera.CoordinateFrame.p - CurrentCamera.Focus.p).magnitude else nil
end

function t1.GetCameraLookVector(_) -- line: 737
    return game.Workspace.CurrentCamera and game.Workspace.CurrentCamera.CFrame.LookVector or Vector3.new(0, 0, 1)
end

function t1:CalculateNewLookCFrameFromArg(p50, p51) -- line: 741
    p50 = p50 or self:GetCameraLookVector()

    local v27 = math.asin(p50.Y)
    local v30 = math.clamp(p51.Y, v27 + -1.3962634015954636, v27 + 1.3962634015954636)
    local v31 = Vector2.new(p51.X, v30)
    local v32 = CFrame.new(Vector3.new(0, 0, 0), p50)

    return CFrame.Angles(0, -v31.X, 0) * v32 * CFrame.Angles(-v31.Y, 0, 0)
end

function t1:CalculateNewLookVectorFromArg(p53, p54) -- line: 751
    return self:CalculateNewLookCFrameFromArg(p53, p54).LookVector
end

function t1:CalculateNewLookVectorVRFromArg(p56) -- line: 756
    local unit = ((self:GetSubjectPosition() - game.Workspace.CurrentCamera.CFrame.p) * Vector3.new(1, 0, 1)).unit
    local v33 = Vector2.new(p56.X, 0)
    local v34 = CFrame.new(Vector3.new(0, 0, 0), unit)

    return ((CFrame.Angles(0, -v33.X, 0) * v34 * CFrame.Angles(-v33.Y, 0, 0)).LookVector * Vector3.new(1, 0, 1)).unit
end

function t1:GetHumanoid() -- line: 766
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

function t1.GetHumanoidPartToFollow(_, p59, p60) -- line: 784
    if p60 ~= Enum.HumanoidStateType.Dead then
        return p59.Torso
    end

    local Parent = p59.Parent

    return Parent and Parent:FindFirstChild("Head") or p59.Torso
end

function t1:OnNewCameraSubject() -- line: 798
    if self.subjectStateChangedConn then
        self.subjectStateChangedConn:Disconnect()
        self.subjectStateChangedConn = nil
    end
end

function t1:IsInFirstPerson() -- line: 805
    return self.inFirstPerson
end

function t1.Update(_, _) -- line: 809
    error("BaseCamera:Update() This is a virtual function that should never be getting called.", 2)
end

function t1:GetCameraHeight() -- line: 813
    -- upvalues: VRService (copy)
    if not VRService.VREnabled or self.inFirstPerson then
        return 0
    end

    return 0.25881904510252074 * self.currentSubjectDistance
end

return t1
