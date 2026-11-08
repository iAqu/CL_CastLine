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
local CommonUtils = script.Parent:WaitForChild("CommonUtils")
local Keyboard = require(script:WaitForChild("Keyboard"))
local Gamepad = require(script:WaitForChild("Gamepad"))
local DynamicThumbstick = require(script:WaitForChild("DynamicThumbstick"))
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"))

local function v1() -- line: 42
    return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickSafeAreaUpdate")
end

local ok, result = pcall(v1)
local v2 = ok and result
local UserPreferredInputPlayerScripts2 = FlagUtil.getUserFlag("UserPreferredInputPlayerScripts2")
local UserPSRemoveTouchEnabled = FlagUtil.getUserFlag("UserPSRemoveTouchEnabled")
local TouchThumbstick = require(script:WaitForChild("TouchThumbstick"))
local ClickToMoveController = require(script:WaitForChild("ClickToMoveController"))
local TouchJump = require(script:WaitForChild("TouchJump"))
local VehicleController = require(script:WaitForChild("VehicleController"))
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
local t3 = {
    [Enum.UserInputType.Keyboard] = Keyboard,
    [Enum.UserInputType.MouseButton1] = Keyboard,
    [Enum.UserInputType.MouseButton2] = Keyboard,
    [Enum.UserInputType.MouseButton3] = Keyboard,
    [Enum.UserInputType.MouseWheel] = Keyboard,
    [Enum.UserInputType.MouseMovement] = Keyboard,
    [Enum.UserInputType.Gamepad1] = Gamepad,
    [Enum.UserInputType.Gamepad2] = Gamepad,
    [Enum.UserInputType.Gamepad3] = Gamepad,
    [Enum.UserInputType.Gamepad4] = Gamepad
}
local v3 = nil

function t1.new() -- line: 106
    -- upvalues: t1 (copy), Players (copy), RunService (copy), UserInputService (copy), GuiService (copy), UserGameSettings (copy), UserPreferredInputPlayerScripts2 (copy), VehicleController (copy), Value (copy)
    local self = setmetatable({}, t1)

    self.controllers = {}
    self.activeControlModule = nil
    self.activeController = nil
    self.touchJumpController = nil
    self.moveFunction = Players.LocalPlayer.Move
    self.humanoid = nil

    if not UserPreferredInputPlayerScripts2 then
        self.lastInputType = Enum.UserInputType.None
    end

    self.controlsEnabled = true
    self.humanoidSeatedConn = nil
    self.vehicleController = nil
    self.touchControlFrame = nil
    self.currentTorsoAngle = 0
    self.inputMoveVector = Vector3.new(0, 0, 0)
    self.vehicleController = VehicleController.new(Value)
    Players.LocalPlayer.CharacterAdded:Connect(function(p1) -- line: 134
        -- upvalues: self (copy)
        self:OnCharacterAdded(p1)
    end)
    Players.LocalPlayer.CharacterRemoving:Connect(function(p2) -- line: 135
        -- upvalues: self (copy)
        self:OnCharacterRemoving(p2)
    end)

    if Players.LocalPlayer.Character then
        self:OnCharacterAdded(Players.LocalPlayer.Character)
    end

    RunService:BindToRenderStep("ControlScriptRenderstep", Enum.RenderPriority.Input.Value, function(p3) -- line: 140
        -- upvalues: self (copy)
        self:OnRenderStepped(p3)
    end)

    if not UserPreferredInputPlayerScripts2 then
        UserInputService.LastInputTypeChanged:Connect(function(p4) -- line: 145
            -- upvalues: self (copy)
            self:OnLastInputTypeChanged(p4)
        end)
    end

    UserGameSettings:GetPropertyChangedSignal("TouchMovementMode"):Connect(function() -- line: 150
        -- upvalues: self (copy), UserPreferredInputPlayerScripts2 (copy)
        if UserPreferredInputPlayerScripts2 then
            self:UpdateMovementMode()
        else
            self:OnTouchMovementModeChange()
        end
    end)
    Players.LocalPlayer:GetPropertyChangedSignal("DevTouchMovementMode"):Connect(function() -- line: 157
        -- upvalues: self (copy), UserPreferredInputPlayerScripts2 (copy)
        if UserPreferredInputPlayerScripts2 then
            self:UpdateMovementMode()
        else
            self:OnTouchMovementModeChange()
        end
    end)
    UserGameSettings:GetPropertyChangedSignal("ComputerMovementMode"):Connect(function() -- line: 165
        -- upvalues: self (copy), UserPreferredInputPlayerScripts2 (copy)
        if UserPreferredInputPlayerScripts2 then
            self:UpdateMovementMode()
        else
            self:OnComputerMovementModeChange()
        end
    end)
    Players.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function() -- line: 172
        -- upvalues: self (copy), UserPreferredInputPlayerScripts2 (copy)
        if UserPreferredInputPlayerScripts2 then
            self:UpdateMovementMode()
        else
            self:OnComputerMovementModeChange()
        end
    end)
    self.playerGui = nil
    self.touchGui = nil
    self.playerGuiAddedConn = nil
    GuiService:GetPropertyChangedSignal("TouchControlsEnabled"):Connect(function() -- line: 185
        -- upvalues: self (copy), UserPreferredInputPlayerScripts2 (copy)
        if UserPreferredInputPlayerScripts2 then
            self:UpdateMovementMode()
        else
            self:UpdateTouchGuiVisibility()
        end

        self:UpdateActiveControlModuleEnabled()
    end)

    if UserPreferredInputPlayerScripts2 then
        UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 195
            -- upvalues: self (copy)
            self:UpdateMovementMode()
        end)
        self.playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

        if not self.playerGui then
            self.playerGuiAddedConn = Players.LocalPlayer.ChildAdded:Connect(function(p5) -- line: 201
                -- upvalues: self (copy)
                if not p5:IsA("PlayerGui") then
                    return
                end

                self.playerGui = p5
                self.playerGuiAddedConn:Disconnect()
                self.playerGuiAddedConn = nil
                self:UpdateMovementMode()
            end)
        end

        self:UpdateMovementMode()
    elseif UserInputService.TouchEnabled then
        self.playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

        if self.playerGui then
            self:CreateTouchGuiContainer()
            self:OnLastInputTypeChanged(UserInputService:GetLastInputType())
        else
            self.playerGuiAddedConn = Players.LocalPlayer.ChildAdded:Connect(function(p6) -- line: 219
                -- upvalues: self (copy), UserInputService (copy)
                if not p6:IsA("PlayerGui") then
                    return
                end

                self.playerGui = p6
                self:CreateTouchGuiContainer()
                self.playerGuiAddedConn:Disconnect()
                self.playerGuiAddedConn = nil
                self:OnLastInputTypeChanged(UserInputService:GetLastInputType())
            end)
        end
    else
        self:OnLastInputTypeChanged(UserInputService:GetLastInputType())
    end

    return self
end

function t1:GetMoveVector() -- line: 240
    if self.activeController then
        return self.activeController:GetMoveVector()
    end

    return (Vector3.new(0, 0, 0))
end

local function NormalizeAngle(p8) -- line: 247
    local v5 = (p8 + 12.566370614359172) % 6.283185307179586

    if v5 > 3.141592653589793 then
        v5 -= 6.283185307179586
    end

    return v5
end

local function AverageAngle(p9, p10) -- line: 255
    local v6 = (p10 - p9 + 12.566370614359172) % 6.283185307179586

    if v6 > 3.141592653589793 then
        v6 -= 6.283185307179586
    end

    local v7 = (p9 + v6 / 2 + 12.566370614359172) % 6.283185307179586

    if v7 > 3.141592653589793 then
        v7 -= 6.283185307179586
    end

    return v7
end

function t1:GetEstimatedVRTorsoFrame() -- line: 260
    -- upvalues: VRService (copy)
    local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
    local _, v8 = UserCFrame:ToEulerAnglesYXZ()
    local v9 = -v8

    if not VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) or not VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand) then
        self.currentTorsoAngle = v9

        return CFrame.new(UserCFrame.Position) * CFrame.fromEulerAnglesYXZ(0, -self.currentTorsoAngle, 0)
    end

    local UserCFrame2 = VRService:GetUserCFrame(Enum.UserCFrame.LeftHand)
    local UserCFrame3 = VRService:GetUserCFrame(Enum.UserCFrame.RightHand)
    local v10 = UserCFrame.Position - UserCFrame2.Position
    local v11 = UserCFrame.Position - UserCFrame3.Position
    local v12 = -math.atan2(v10.X, v10.Z)
    local v13 = (-math.atan2(v11.X, v11.Z) - v12 + 12.566370614359172) % 6.283185307179586

    if v13 > 3.141592653589793 then
        v13 -= 6.283185307179586
    end

    local v14 = (v12 + v13 / 2 + 12.566370614359172) % 6.283185307179586

    if v14 > 3.141592653589793 then
        v14 -= 6.283185307179586
    end

    local v15 = (v9 - self.currentTorsoAngle + 12.566370614359172) % 6.283185307179586

    if v15 > 3.141592653589793 then
        v15 -= 6.283185307179586
    end

    local v16 = (v14 - self.currentTorsoAngle + 12.566370614359172) % 6.283185307179586

    if v16 > 3.141592653589793 then
        v16 -= 6.283185307179586
    end

    if not (v16 > -1.5707963267948966 and v16 < 1.5707963267948966) then
        v16 = v15
    end

    local v17 = math.min(v16, v15)
    local v18 = math.max(v16, v15)

    if not (v17 > 0) then
        v17 = if v18 < 0 then v18 else 0
    end

    self.currentTorsoAngle = v17 + self.currentTorsoAngle

    return CFrame.new(UserCFrame.Position) * CFrame.fromEulerAnglesYXZ(0, -self.currentTorsoAngle, 0)
end

function t1:GetActiveController() -- line: 304
    return self.activeController
end

function t1:UpdateActiveControlModuleEnabled() -- line: 309
    -- upvalues: Players (copy), UserInputService (copy), GuiService (copy), DynamicThumbstick (copy), UserPreferredInputPlayerScripts2 (copy), TouchThumbstick (copy), ClickToMoveController (copy), TouchJump (copy)
    local function v19() -- line: 322
        -- upvalues: self (copy), Players (copy), UserInputService (copy), DynamicThumbstick (copy), UserPreferredInputPlayerScripts2 (copy), TouchThumbstick (copy), ClickToMoveController (copy), TouchJump (copy)
        if self.touchControlFrame and (not UserPreferredInputPlayerScripts2 or UserInputService.PreferredInput == Enum.PreferredInput.Touch) and (self.activeControlModule == ClickToMoveController or self.activeControlModule == TouchThumbstick or self.activeControlModule == DynamicThumbstick) then
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
        if self.controlsEnabled then
            local v20 = if UserPreferredInputPlayerScripts2 then UserInputService.PreferredInput == Enum.PreferredInput.Touch else UserInputService.TouchEnabled

            if not GuiService.TouchControlsEnabled and v20 and (self.activeControlModule == ClickToMoveController or self.activeControlModule == TouchThumbstick or self.activeControlModule == DynamicThumbstick) then
                self.activeController:Enable(false)

                if self.touchJumpController then
                    self.touchJumpController:Enable(false)
                end

                if self.moveFunction then
                    self.moveFunction(Players.LocalPlayer, Vector3.new(0, 0, 0), true)
                end
            else
                v19()
            end
        else
            self.activeController:Enable(false)

            if self.touchJumpController then
                self.touchJumpController:Enable(false)
            end

            if self.moveFunction then
                self.moveFunction(Players.LocalPlayer, Vector3.new(0, 0, 0), true)
            end
        end
    end
end

function t1:Enable(p15) -- line: 388
    local v21 = p15 == nil or p15

    if self.controlsEnabled ~= v21 then
        self.controlsEnabled = v21

        if self.activeController then
            self:UpdateActiveControlModuleEnabled()
        end
    end
end

function t1.Disable(p16) -- line: 403
    p16:Enable(false)
end

function t1.SelectComputerMovementModule(_) -- line: 409
    -- upvalues: Players (copy), UserInputService (copy), UserGameSettings (copy), Keyboard (copy), Gamepad (copy), UserPreferredInputPlayerScripts2 (copy), ClickToMoveController (copy), t2 (copy), t3 (copy), v3 (ref)
    if not UserInputService.KeyboardEnabled and not UserInputService.GamepadEnabled then
        return nil, false
    end

    local DevComputerMovementMode = Players.LocalPlayer.DevComputerMovementMode
    local v22

    if DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice then
        if UserPreferredInputPlayerScripts2 then
            if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
                v22 = Gamepad
            elseif UserInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse then
                v22 = Keyboard
            end
        else
            v22 = t3[v3]
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

function t1.SelectTouchModule(_) -- line: 456
    -- upvalues: Players (copy), UserInputService (copy), UserGameSettings (copy), UserPSRemoveTouchEnabled (copy), t2 (copy)
    if UserPSRemoveTouchEnabled or UserInputService.TouchEnabled then
        local DevTouchMovementMode = Players.LocalPlayer.DevTouchMovementMode
        local v23

        if DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice then
            v23 = t2[UserGameSettings.TouchMovementMode]
        else
            if DevTouchMovementMode == Enum.DevTouchMovementMode.Scriptable then
                return nil, true
            end

            v23 = t2[DevTouchMovementMode]
        end

        return v23, true
    end

    return nil, false
end

local function getGamepadRightThumbstickPosition() -- line: 474
    -- upvalues: UserInputService (copy)
    local GamepadState = UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1)

    for _, v24 in pairs(GamepadState) do
        if v24.KeyCode == Enum.KeyCode.Thumbstick2 then
            return v24.Position
        end
    end

    return (Vector3.new(0, 0, 0))
end

function t1:calculateRawMoveVector(p20, p21) -- line: 484
    -- upvalues: Workspace (copy), VRService (copy), getGamepadRightThumbstickPosition (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if not CurrentCamera then
        return p21
    end

    local _CFrame = CurrentCamera.CFrame

    if VRService.VREnabled and p20.RootPart then
        VRService:GetUserCFrame(Enum.UserCFrame.Head)

        local EstimatedVRTorsoFrame = self:GetEstimatedVRTorsoFrame()

        if (CurrentCamera.Focus.Position - _CFrame.Position).Magnitude < 3 then
            _CFrame *= EstimatedVRTorsoFrame
        else
            _CFrame = CurrentCamera.CFrame * (EstimatedVRTorsoFrame.Rotation + EstimatedVRTorsoFrame.Position * CurrentCamera.HeadScale)
        end
    end

    if p20:GetState() == Enum.HumanoidStateType.Swimming then
        if not VRService.VREnabled then
            return _CFrame:VectorToWorldSpace(p21)
        end

        local v25 = Vector3.new(p21.X, 0, p21.Z)

        if v25.Magnitude < 0.01 then
            return (Vector3.new(0, 0, 0))
        end

        local v26 = -getGamepadRightThumbstickPosition().Y * 1.3962634015954636
        local v29 = math.atan2(-v25.X, -v25.Z)
        local _, v30 = _CFrame:ToEulerAnglesYXZ()
        local v31 = v29 + v30

        return CFrame.fromEulerAnglesYXZ(v26, v31, 0).LookVector
    end

    local _, _, _, Components, Components2, Components3, _, _, Components4, _, _, Components5 = _CFrame:GetComponents()

    if not (Components4 < 1 and Components4 > -1) then
        Components3 = -Components2 * math.sign(Components4)
    else
        Components = Components5
    end

    local v33 = math.sqrt(Components * Components + Components3 * Components3)

    return (Vector3.new((Components * p21.X + Components3 * p21.Z) / v33, 0, (Components * p21.Z - Components3 * p21.X) / v33))
end

function t1:OnRenderStepped(p23) -- line: 543
    -- upvalues: Players (copy), VRService (copy), Gamepad (copy)
    if self.activeController and self.activeController.enabled and self.humanoid then
        local MoveVector = self.activeController:GetMoveVector()
        local v36 = self.activeController:IsMoveVectorCameraRelative()
        local ClickToMoveController = self:GetClickToMoveController()

        if self.activeController == ClickToMoveController then
            ClickToMoveController:OnRenderStepped(p23)
        elseif MoveVector.magnitude > 0 then
            ClickToMoveController:CleanupPath()
        else
            ClickToMoveController:OnRenderStepped(p23)
            MoveVector = ClickToMoveController:GetMoveVector()
            v36 = ClickToMoveController:IsMoveVectorCameraRelative()
        end

        local v37 = if self.vehicleController then self.vehicleController:Update(MoveVector, v36, self.activeControlModule == Gamepad) else MoveVector

        if v36 then
            v37 = self:calculateRawMoveVector(self.humanoid, v37)
        end

        self.inputMoveVector = v37

        if VRService.VREnabled then
            v37 = self:updateVRMoveVector(v37)
        end

        self.moveFunction(Players.LocalPlayer, v37, false)
        self.humanoid.Jump = self.activeController:GetIsJumping() or self.touchJumpController and self.touchJumpController:GetIsJumping()
    end
end

function t1:updateVRMoveVector(p25) -- line: 592
    -- upvalues: VRService (copy)
    local CurrentCamera = workspace.CurrentCamera
    local v38 = (CurrentCamera.Focus.Position - CurrentCamera.CFrame.Position).Magnitude < 5

    if p25.Magnitude ~= 0 or not v38 or not VRService.AvatarGestures or not self.humanoid or self.humanoid.Sit then
        return p25
    end

    local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
    local v39 = UserCFrame.Rotation + UserCFrame.Position * CurrentCamera.HeadScale
    local v40 = -0.7 * self.humanoid.RootPart.Size.Y / 2
    local v41 = (CurrentCamera.CFrame * v39 * CFrame.new(0, v40, 0)).Position - self.humanoid.RootPart.CFrame.Position

    return (Vector3.new(v41.x, 0, v41.z))
end

function t1:OnHumanoidSeated(p27, p28) -- line: 617
    -- upvalues: Value (copy)
    if p27 then
        if p28 and p28:IsA("VehicleSeat") then
            if not self.vehicleController then
                self.vehicleController = self.vehicleController.new(Value)
            end

            self.vehicleController:Enable(true, p28)
        end
    elseif self.vehicleController then
        self.vehicleController:Enable(false, p28)
    end
end

function t1:OnCharacterAdded(p30) -- line: 632
    -- upvalues: UserPreferredInputPlayerScripts2 (copy)
    self.humanoid = p30:FindFirstChildOfClass("Humanoid")

    while not self.humanoid do
        p30.ChildAdded:wait()
        self.humanoid = p30:FindFirstChildOfClass("Humanoid")
    end

    if not UserPreferredInputPlayerScripts2 then
        self:UpdateTouchGuiVisibility()
    end

    if self.humanoidSeatedConn then
        self.humanoidSeatedConn:Disconnect()
        self.humanoidSeatedConn = nil
    end

    self.humanoidSeatedConn = self.humanoid.Seated:Connect(function(p31, p32) -- line: 647
        -- upvalues: self (copy)
        self:OnHumanoidSeated(p31, p32)
    end)

    if UserPreferredInputPlayerScripts2 then
        self:UpdateMovementMode()
    end
end

function t1:OnCharacterRemoving(_) -- line: 656
    -- upvalues: UserPreferredInputPlayerScripts2 (copy)
    self.humanoid = nil

    if UserPreferredInputPlayerScripts2 then
        self:UpdateMovementMode()
    else
        self:UpdateTouchGuiVisibility()
    end
end

function t1:UpdateTouchGuiVisibility() -- line: 666
    -- upvalues: UserInputService (copy), GuiService (copy), UserPreferredInputPlayerScripts2 (copy)
    local humanoid

    if UserPreferredInputPlayerScripts2 then
        humanoid = self.humanoid and GuiService.TouchControlsEnabled and UserInputService.PreferredInput == Enum.PreferredInput.Touch

        if humanoid and not self.touchGui then
            self:CreateTouchGuiContainer()
        end
    else
        humanoid = self.humanoid and GuiService.TouchControlsEnabled
    end

    if self.touchGui then
        self.touchGui.Enabled = not not humanoid
    end
end

function t1:SwitchToController(p37) -- line: 690
    -- upvalues: Value (copy)
    if p37 then
        if not self.controllers[p37] then
            self.controllers[p37] = p37.new(Value)
        end

        if self.activeController ~= self.controllers[p37] then
            if self.activeController then
                self.activeController:Enable(false)
            end

            self.activeController = self.controllers[p37]
            self.activeControlModule = p37
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

function t1:UpdateMovementMode() -- line: 729
    -- upvalues: UserInputService (copy)
    self:UpdateTouchGuiVisibility()

    if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
        local v42, v43 = self:SelectTouchModule()

        if v43 and self.touchControlFrame then
            self:SwitchToController(v42)
        end
    else
        self:SwitchToController((self:SelectComputerMovementModule()))
    end
end

function t1:OnLastInputTypeChanged(p40) -- line: 746
    -- upvalues: t3 (copy), v3 (ref)
    if v3 == p40 then
        warn("LastInputType Change listener called with current type.")
    end

    v3 = p40

    if v3 == Enum.UserInputType.Touch then
        local v45, v46 = self:SelectTouchModule()

        if v46 then
            while not self.touchControlFrame do
                wait()
            end

            self:SwitchToController(v45)
        end
    elseif t3[v3] ~= nil then
        local v47 = self:SelectComputerMovementModule()

        if v47 then
            self:SwitchToController(v47)
        end
    end

    self:UpdateTouchGuiVisibility()
end

function t1:OnComputerMovementModeChange() -- line: 774
    local v48, v49 = self:SelectComputerMovementModule()

    if v49 then
        self:SwitchToController(v48)
    end
end

function t1:OnTouchMovementModeChange() -- line: 782
    local v50, v51 = self:SelectTouchModule()

    if v51 then
        while not self.touchControlFrame do
            wait()
        end

        self:SwitchToController(v50)
    end
end

function t1:CreateTouchGuiContainer() -- line: 792
    -- upvalues: v2 (copy), UserPreferredInputPlayerScripts2 (copy)
    if UserPreferredInputPlayerScripts2 and not self.playerGui then
        return
    end

    if self.touchGui then
        self.touchGui:Destroy()
    end

    self.touchGui = Instance.new("ScreenGui")
    self.touchGui.Name = "TouchGui"
    self.touchGui.ResetOnSpawn = false
    self.touchGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    if not UserPreferredInputPlayerScripts2 then
        self:UpdateTouchGuiVisibility()
    end

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

function t1:GetClickToMoveController() -- line: 823
    -- upvalues: ClickToMoveController (copy), Value (copy)
    if not self.controllers[ClickToMoveController] then
        self.controllers[ClickToMoveController] = ClickToMoveController.new(Value)
    end

    return self.controllers[ClickToMoveController]
end

return t1.new()
