-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

t1.__index = t1

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Workspace = game:GetService("Workspace")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local VRService = game:GetService("VRService")

script.Parent:WaitForChild("CommonUtils")

local Keyboard = require(script:WaitForChild("Keyboard"))
local Gamepad = require(script:WaitForChild("Gamepad"))
local DynamicThumbstick = require(script:WaitForChild("DynamicThumbstick"))

local function v1() -- line: 41
    return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickSafeAreaUpdate")
end

local ok, result = pcall(v1)
local v2 = ok and result
local TouchThumbstick = require(script:WaitForChild("TouchThumbstick"))
local ClickToMoveController = require(script:WaitForChild("ClickToMoveController"))
local TouchJump = require(script:WaitForChild("TouchJump"))
local VehicleController = require(script:WaitForChild("VehicleController"))

local function v3() -- line: 58
    return UserSettings():IsUserFeatureEnabled("UserPlayerScriptsSupportMicroGamepad")
end

local ok2, result2 = pcall(v3)
local v4 = ok2 and result2
local Value = Enum.ContextActionPriority.Medium.Value
local t2 = {
    [Enum.TouchMovementMode.DPad] = DynamicThumbstick,
    [Enum.DevTouchMovementMode.DPad] = DynamicThumbstick,
    [Enum.TouchMovementMode.Thumbpad] = DynamicThumbstick,
    [Enum.DevTouchMovementMode.Thumbpad] = DynamicThumbstick,
    [Enum.TouchMovementMode.Thumbstick] = TouchThumbstick,
    [Enum.DevTouchMovementMode.Thumbstick] = TouchThumbstick,
    [Enum.TouchMovementMode.DynamicThumbstick] = DynamicThumbstick,
    [Enum.DevTouchMovementMode.DynamicThumbstick] = DynamicThumbstick,
    [Enum.TouchMovementMode.ClickToMove] = ClickToMoveController,
    [Enum.DevTouchMovementMode.ClickToMove] = ClickToMoveController,
    [Enum.TouchMovementMode.Default] = DynamicThumbstick,
    [Enum.ComputerMovementMode.Default] = Keyboard,
    [Enum.ComputerMovementMode.KeyboardMouse] = Keyboard,
    [Enum.DevComputerMovementMode.KeyboardMouse] = Keyboard,
    [Enum.DevComputerMovementMode.Scriptable] = nil,
    [Enum.ComputerMovementMode.ClickToMove] = ClickToMoveController,
    [Enum.DevComputerMovementMode.ClickToMove] = ClickToMoveController
}

function t1.new() -- line: 92
    -- upvalues: t1 (copy), Players (copy), RunService (copy), UserInputService (copy), GuiService (copy), UserGameSettings (copy), VehicleController (copy), Value (copy)
    local self = setmetatable({}, t1)

    self.controllers = {}
    self.activeControlModule = nil
    self.activeController = nil
    self.touchJumpController = nil
    self.moveFunction = Players.LocalPlayer.Move
    self.humanoid = nil
    self.controlsEnabled = true
    self.humanoidSeatedConn = nil
    self.vehicleController = nil
    self.touchControlFrame = nil
    self.currentTorsoAngle = 0
    self.inputMoveVector = Vector3.new(0, 0, 0)
    self.vehicleController = VehicleController.new(Value)
    Players.LocalPlayer.CharacterAdded:Connect(function(p1) -- line: 117
        -- upvalues: self (copy)
        self:OnCharacterAdded(p1)
    end)
    Players.LocalPlayer.CharacterRemoving:Connect(function(p2) -- line: 118
        -- upvalues: self (copy)
        self:OnCharacterRemoving(p2)
    end)

    if Players.LocalPlayer.Character then
        self:OnCharacterAdded(Players.LocalPlayer.Character)
    end

    RunService:BindToRenderStep("ControlScriptRenderstep", Enum.RenderPriority.Input.Value, function(p3) -- line: 123
        -- upvalues: self (copy)
        self:OnRenderStepped(p3)
    end)
    UserGameSettings:GetPropertyChangedSignal("TouchMovementMode"):Connect(function() -- line: 127
        -- upvalues: self (copy)
        self:UpdateMovementMode()
    end)
    Players.LocalPlayer:GetPropertyChangedSignal("DevTouchMovementMode"):Connect(function() -- line: 130
        -- upvalues: self (copy)
        self:UpdateMovementMode()
    end)
    UserGameSettings:GetPropertyChangedSignal("ComputerMovementMode"):Connect(function() -- line: 134
        -- upvalues: self (copy)
        self:UpdateMovementMode()
    end)
    Players.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function() -- line: 137
        -- upvalues: self (copy)
        self:UpdateMovementMode()
    end)
    self.playerGui = nil
    self.touchGui = nil
    self.playerGuiAddedConn = nil
    GuiService:GetPropertyChangedSignal("TouchControlsEnabled"):Connect(function() -- line: 146
        -- upvalues: self (copy)
        self:UpdateMovementMode()
        self:UpdateActiveControlModuleEnabled()
    end)
    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 151
        -- upvalues: self (copy)
        self:UpdateMovementMode()
    end)
    self.playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

    if not self.playerGui then
        self.playerGuiAddedConn = Players.LocalPlayer.ChildAdded:Connect(function(p4) -- line: 157
            -- upvalues: self (copy)
            if not p4:IsA("PlayerGui") then
                return
            end

            self.playerGui = p4
            self.playerGuiAddedConn:Disconnect()
            self.playerGuiAddedConn = nil
            self:UpdateMovementMode()
        end)
    end

    self:UpdateMovementMode()

    return self
end

function t1:GetMoveVector() -- line: 175
    if self.activeController then
        return self.activeController:GetMoveVector()
    end

    return (Vector3.new(0, 0, 0))
end

local function NormalizeAngle(p6) -- line: 182
    local v6 = (p6 + 12.566370614359172) % 6.283185307179586

    if v6 > 3.141592653589793 then
        v6 -= 6.283185307179586
    end

    return v6
end

local function AverageAngle(p7, p8) -- line: 190
    local v7 = (p8 - p7 + 12.566370614359172) % 6.283185307179586

    if v7 > 3.141592653589793 then
        v7 -= 6.283185307179586
    end

    local v8 = (p7 + v7 / 2 + 12.566370614359172) % 6.283185307179586

    if v8 > 3.141592653589793 then
        v8 -= 6.283185307179586
    end

    return v8
end

function t1:GetEstimatedVRTorsoFrame() -- line: 195
    -- upvalues: VRService (copy)
    local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
    local _, v9 = UserCFrame:ToEulerAnglesYXZ()
    local v10 = -v9

    if not VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) or not VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand) then
        self.currentTorsoAngle = v10

        return CFrame.new(UserCFrame.Position) * CFrame.fromEulerAnglesYXZ(0, -self.currentTorsoAngle, 0)
    end

    local UserCFrame2 = VRService:GetUserCFrame(Enum.UserCFrame.LeftHand)
    local UserCFrame3 = VRService:GetUserCFrame(Enum.UserCFrame.RightHand)
    local v11 = UserCFrame.Position - UserCFrame2.Position
    local v12 = UserCFrame.Position - UserCFrame3.Position
    local v13 = -math.atan2(v11.X, v11.Z)
    local v14 = (-math.atan2(v12.X, v12.Z) - v13 + 12.566370614359172) % 6.283185307179586

    if v14 > 3.141592653589793 then
        v14 -= 6.283185307179586
    end

    local v15 = (v13 + v14 / 2 + 12.566370614359172) % 6.283185307179586

    if v15 > 3.141592653589793 then
        v15 -= 6.283185307179586
    end

    local v16 = (v10 - self.currentTorsoAngle + 12.566370614359172) % 6.283185307179586

    if v16 > 3.141592653589793 then
        v16 -= 6.283185307179586
    end

    local v17 = (v15 - self.currentTorsoAngle + 12.566370614359172) % 6.283185307179586

    if v17 > 3.141592653589793 then
        v17 -= 6.283185307179586
    end

    if not (v17 > -1.5707963267948966 and v17 < 1.5707963267948966) then
        v17 = v16
    end

    local v18 = math.min(v17, v16)
    local v19 = math.max(v17, v16)

    if not (v18 > 0) then
        v18 = if v19 < 0 then v19 else 0
    end

    self.currentTorsoAngle = v18 + self.currentTorsoAngle

    return CFrame.new(UserCFrame.Position) * CFrame.fromEulerAnglesYXZ(0, -self.currentTorsoAngle, 0)
end

function t1:GetActiveController() -- line: 239
    return self.activeController
end

function t1:UpdateActiveControlModuleEnabled() -- line: 244
    -- upvalues: Players (copy), UserInputService (copy), GuiService (copy), DynamicThumbstick (copy), TouchThumbstick (copy), ClickToMoveController (copy), TouchJump (copy)
    local function v20() -- line: 257
        -- upvalues: self (copy), Players (copy), UserInputService (copy), DynamicThumbstick (copy), TouchThumbstick (copy), ClickToMoveController (copy), TouchJump (copy)
        if self.touchControlFrame and UserInputService.PreferredInput == Enum.PreferredInput.Touch and (self.activeControlModule == ClickToMoveController or self.activeControlModule == TouchThumbstick or self.activeControlModule == DynamicThumbstick) then
            if not self.controllers[TouchJump] then
                self.controllers[TouchJump] = TouchJump.new()
            end

            self.touchJumpController = self.controllers[TouchJump]
            self.touchJumpController:Enable(true, self.touchControlFrame)
        elseif self.touchJumpController then
            self.touchJumpController:Enable(false)
        end

        if self.activeControlModule == ClickToMoveController then
            self.activeController:Enable(true, Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice, self.touchJumpController)
        elseif self.touchControlFrame then
            self.activeController:Enable(true, self.touchControlFrame)
        else
            self.activeController:Enable(true)
        end
    end

    if self.activeController then
        if not self.controlsEnabled or not (GuiService.TouchControlsEnabled or UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or self.activeControlModule ~= ClickToMoveController and self.activeControlModule ~= TouchThumbstick and self.activeControlModule ~= DynamicThumbstick) then
            self.activeController:Enable(false)

            if self.touchJumpController then
                self.touchJumpController:Enable(false)
            end

            if self.moveFunction then
                self.moveFunction(Players.LocalPlayer, Vector3.new(0, 0, 0), true)
            end
        else
            v20()
        end
    end
end

function t1:Enable(p13) -- line: 315
    local v21 = p13 == nil or p13

    if self.controlsEnabled ~= v21 then
        self.controlsEnabled = v21

        if self.activeController then
            self:UpdateActiveControlModuleEnabled()
        end
    end
end

function t1.Disable(p14) -- line: 330
    p14:Enable(false)
end

function t1.SelectComputerMovementModule(_) -- line: 336
    -- upvalues: Players (copy), UserInputService (copy), UserGameSettings (copy), Keyboard (copy), Gamepad (copy), ClickToMoveController (copy), v4 (copy), t2 (copy)
    if not UserInputService.KeyboardEnabled and not UserInputService.GamepadEnabled then
        return nil, false
    end

    local DevComputerMovementMode = Players.LocalPlayer.DevComputerMovementMode
    local v22

    if DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice then
        local v23 = false

        if v4 then
            local function v24() -- line: 347
                -- upvalues: v23 (ref), UserInputService (copy)
                v23 = UserInputService.PreferredInput == Enum.PreferredInput.MicroGamepad
            end

            pcall(v24)
        end

        if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad or v23 then
            v22 = Gamepad
        elseif UserInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse then
            v22 = Keyboard
        end

        if UserGameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove and v22 == Keyboard then
            v22 = ClickToMoveController
        end
    else
        v22 = t2[DevComputerMovementMode]

        if not v22 and DevComputerMovementMode ~= Enum.DevComputerMovementMode.Scriptable then
            warn("No character control module is associated with DevComputerMovementMode ", DevComputerMovementMode)
        end
    end

    if v22 then
        return v22, true
    end

    if DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable then
        return nil, true
    end

    return nil, false
end

function t1.SelectTouchModule(_) -- line: 385
    -- upvalues: Players (copy), UserGameSettings (copy), t2 (copy)
    local DevTouchMovementMode = Players.LocalPlayer.DevTouchMovementMode
    local v25

    if DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice then
        v25 = t2[UserGameSettings.TouchMovementMode]
    else
        if DevTouchMovementMode == Enum.DevTouchMovementMode.Scriptable then
            return nil, true
        end

        v25 = t2[DevTouchMovementMode]
    end

    return v25, true
end

local function getGamepadRightThumbstickPosition() -- line: 398
    -- upvalues: UserInputService (copy)
    local GamepadState = UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1)

    for _, v26 in pairs(GamepadState) do
        if v26.KeyCode == Enum.KeyCode.Thumbstick2 then
            return v26.Position
        end
    end

    return (Vector3.new(0, 0, 0))
end

function t1:calculateRawMoveVector(p18, p19) -- line: 408
    -- upvalues: Workspace (copy), VRService (copy), getGamepadRightThumbstickPosition (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if not CurrentCamera then
        return p19
    end

    local _CFrame = CurrentCamera.CFrame

    if VRService.VREnabled and p18.RootPart then
        VRService:GetUserCFrame(Enum.UserCFrame.Head)

        local EstimatedVRTorsoFrame = self:GetEstimatedVRTorsoFrame()

        if (CurrentCamera.Focus.Position - _CFrame.Position).Magnitude < 3 then
            _CFrame *= EstimatedVRTorsoFrame
        else
            _CFrame = CurrentCamera.CFrame * (EstimatedVRTorsoFrame.Rotation + EstimatedVRTorsoFrame.Position * CurrentCamera.HeadScale)
        end
    end

    if p18:GetState() == Enum.HumanoidStateType.Swimming then
        if not VRService.VREnabled then
            return _CFrame:VectorToWorldSpace(p19)
        end

        local v27 = Vector3.new(p19.X, 0, p19.Z)

        if v27.Magnitude < 0.01 then
            return (Vector3.new(0, 0, 0))
        end

        local v28 = -getGamepadRightThumbstickPosition().Y * 1.3962634015954636
        local v31 = math.atan2(-v27.X, -v27.Z)
        local _, v32 = _CFrame:ToEulerAnglesYXZ()
        local v33 = v31 + v32

        return CFrame.fromEulerAnglesYXZ(v28, v33, 0).LookVector
    end

    local _, _, _, Components, Components2, Components3, _, _, Components4, _, _, Components5 = _CFrame:GetComponents()

    if not (Components4 < 1 and Components4 > -1) then
        Components3 = -Components2 * math.sign(Components4)
    else
        Components = Components5
    end

    local v35 = math.sqrt(Components * Components + Components3 * Components3)

    return (Vector3.new((Components * p19.X + Components3 * p19.Z) / v35, 0, (Components * p19.Z - Components3 * p19.X) / v35))
end

function t1:OnRenderStepped(p21) -- line: 467
    -- upvalues: Players (copy), VRService (copy), Gamepad (copy)
    if self.activeController and self.activeController.enabled and self.humanoid then
        local MoveVector = self.activeController:GetMoveVector()
        local v38 = self.activeController:IsMoveVectorCameraRelative()
        local ClickToMoveController = self:GetClickToMoveController()

        if self.activeController == ClickToMoveController then
            ClickToMoveController:OnRenderStepped(p21)
        elseif MoveVector.magnitude > 0 then
            ClickToMoveController:CleanupPath()
        else
            ClickToMoveController:OnRenderStepped(p21)
            MoveVector = ClickToMoveController:GetMoveVector()
            v38 = ClickToMoveController:IsMoveVectorCameraRelative()
        end

        local v39 = if self.vehicleController then self.vehicleController:Update(MoveVector, v38, self.activeControlModule == Gamepad) else MoveVector

        if v38 then
            v39 = self:calculateRawMoveVector(self.humanoid, v39)
        end

        self.inputMoveVector = v39

        if VRService.VREnabled then
            v39 = self:updateVRMoveVector(v39)
        end

        self.moveFunction(Players.LocalPlayer, v39, false)
        self.humanoid.Jump = self.activeController:GetIsJumping() or self.touchJumpController and self.touchJumpController:GetIsJumping()
    end
end

function t1:updateVRMoveVector(p23) -- line: 516
    -- upvalues: VRService (copy)
    local CurrentCamera = workspace.CurrentCamera
    local v40 = (CurrentCamera.Focus.Position - CurrentCamera.CFrame.Position).Magnitude < 5

    if p23.Magnitude ~= 0 or not v40 or not VRService.AvatarGestures or not self.humanoid or self.humanoid.Sit then
        return p23
    end

    local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
    local v41 = UserCFrame.Rotation + UserCFrame.Position * CurrentCamera.HeadScale
    local v42 = -0.7 * self.humanoid.RootPart.Size.Y / 2
    local v43 = (CurrentCamera.CFrame * v41 * CFrame.new(0, v42, 0)).Position - self.humanoid.RootPart.CFrame.Position

    return (Vector3.new(v43.x, 0, v43.z))
end

function t1:OnHumanoidSeated(p25, p26) -- line: 541
    -- upvalues: Value (copy)
    if p25 then
        if p26 and p26:IsA("VehicleSeat") then
            if not self.vehicleController then
                self.vehicleController = self.vehicleController.new(Value)
            end

            self.vehicleController:Enable(true, p26)
        end
    elseif self.vehicleController then
        self.vehicleController:Enable(false, p26)
    end
end

function t1:OnCharacterAdded(p28) -- line: 556
    self.humanoid = p28:FindFirstChildOfClass("Humanoid")

    while not self.humanoid do
        p28.ChildAdded:wait()
        self.humanoid = p28:FindFirstChildOfClass("Humanoid")
    end

    if self.humanoidSeatedConn then
        self.humanoidSeatedConn:Disconnect()
        self.humanoidSeatedConn = nil
    end

    self.humanoidSeatedConn = self.humanoid.Seated:Connect(function(p29, p30) -- line: 567
        -- upvalues: self (copy)
        self:OnHumanoidSeated(p29, p30)
    end)
    self:UpdateMovementMode()
end

function t1:OnCharacterRemoving(_) -- line: 574
    self.humanoid = nil
    self:UpdateMovementMode()
end

function t1:UpdateTouchGuiVisibility() -- line: 580
    -- upvalues: UserInputService (copy), GuiService (copy)
    local humanoid = self.humanoid and GuiService.TouchControlsEnabled and UserInputService.PreferredInput == Enum.PreferredInput.Touch

    if humanoid and not self.touchGui then
        self:CreateTouchGuiContainer()
    end

    if self.touchGui then
        self.touchGui.Enabled = not not humanoid
    end
end

function t1:SwitchToController(p35) -- line: 599
    -- upvalues: Value (copy)
    if p35 then
        if not self.controllers[p35] then
            self.controllers[p35] = p35.new(Value)
        end

        if self.activeController ~= self.controllers[p35] then
            if self.activeController then
                self.activeController:Enable(false)
            end

            self.activeController = self.controllers[p35]
            self.activeControlModule = p35
            self:UpdateActiveControlModuleEnabled()
        end
    else
        if self.activeController then
            self.activeController:Enable(false)
        end

        self.activeController = nil
        self.activeControlModule = nil
    end
end

function t1:UpdateMovementMode() -- line: 638
    -- upvalues: UserInputService (copy)
    self:UpdateTouchGuiVisibility()

    if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
        local v44, v45 = self:SelectTouchModule()

        if v45 and self.touchControlFrame then
            self:SwitchToController(v44)
        end
    else
        self:SwitchToController((self:SelectComputerMovementModule()))
    end
end

function t1:CreateTouchGuiContainer() -- line: 654
    -- upvalues: v2 (copy)
    if self.playerGui then
        if self.touchGui then
            self.touchGui:Destroy()
        end

        self.touchGui = Instance.new("ScreenGui")
        self.touchGui.Name = "TouchGui"
        self.touchGui.ResetOnSpawn = false
        self.touchGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        if v2 then
            self.touchGui.ClipToDeviceSafeArea = false
        end

        self.touchControlFrame = Instance.new("Frame")
        self.touchControlFrame.Name = "TouchControlFrame"
        self.touchControlFrame.Size = UDim2.new(1, 0, 1, 0)
        self.touchControlFrame.BackgroundTransparency = 1
        self.touchControlFrame.Parent = self.touchGui
        self.touchGui.Parent = self.playerGui
    end
end

function t1:GetClickToMoveController() -- line: 680
    -- upvalues: ClickToMoveController (copy), Value (copy)
    if not self.controllers[ClickToMoveController] then
        self.controllers[ClickToMoveController] = ClickToMoveController.new(Value)
    end

    return self.controllers[ClickToMoveController]
end

return t1.new()
