-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

t1.__index = t1

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Workspace = game:GetService("Workspace")
local StarterPlayer = game:GetService("StarterPlayer")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local VRService = game:GetService("VRService")
local ContextActionService = game:GetService("ContextActionService")
local CommonUtils = require(script.Parent:WaitForChild("CommonUtils"))
local FlagUtil = CommonUtils.get("FlagUtil")
local UserVRFixCameraCloseArticulation = FlagUtil.getUserFlag("UserVRFixCameraCloseArticulation")
local UserPlayerScriptsCCLIntegrationD = FlagUtil.getUserFlag("UserPlayerScriptsCCLIntegrationD")
local UserPlayerScriptsBindActivateOnIAS = FlagUtil.getUserFlag("UserPlayerScriptsBindActivateOnIAS")
local UserPlayerScriptsPlayerControlState2 = FlagUtil.getUserFlag("UserPlayerScriptsPlayerControlState2")
local UserPlayerScriptsTaskDeferSimulation = FlagUtil.getUserFlag("UserPlayerScriptsTaskDeferSimulation")
local UserPlayerScriptsFixSAuthRenderStepMove = FlagUtil.getUserFlag("UserPlayerScriptsFixSAuthRenderStepMove")
local UserPlayerScriptsSupportMicroGamepad = FlagUtil.getUserFlag("UserPlayerScriptsSupportMicroGamepad")
local UserAbilitiesUserInterfaceC = FlagUtil.getUserFlag("UserAbilitiesUserInterfaceC")
local UserControlModuleEnabledAPI = FlagUtil.getUserFlag("UserControlModuleEnabledAPI")
local UserPSUseBindToAnimation = FlagUtil.getUserFlag("UserPSUseBindToAnimation")
local UserServerAuthorityDontSetAutoRotate = FlagUtil.getUserFlag("UserServerAuthorityDontSetAutoRotate")
local t2 = {
    SERVER_AUTHORITY_CHANGED = "SERVER_AUTHORITY_CHANGED"
}
local ActionController = require(script:WaitForChild("ActionController"))
local v1 = if UserPlayerScriptsCCLIntegrationD or UserPlayerScriptsPlayerControlState2 then require(script:WaitForChild("InputReplication")) else nil
local v2 = if UserPlayerScriptsCCLIntegrationD then require(script:WaitForChild("InputSlots")) else nil
local DynamicThumbstick, DynamicThumbstick2

if RunService:IsClient() then
    local DynamicThumbstick3 = require(script:WaitForChild("DynamicThumbstick"))

    DynamicThumbstick2 = DynamicThumbstick3
    DynamicThumbstick = DynamicThumbstick3
end

local ClassicThumbstick = require(script:WaitForChild("ClassicThumbstick"))
local ClickToMoveController = require(script:WaitForChild("ClickToMoveController"))
local TouchJump = require(script:WaitForChild("TouchJump"))
local v3 = if UserPlayerScriptsCCLIntegrationD then require(script:WaitForChild("TouchAbilities")) else nil
local VehicleController = require(script:WaitForChild("VehicleController"))
local AvatarAbilitiesInterface, v4

if UserPlayerScriptsCCLIntegrationD then
    local AvatarAbilitiesInterface2 = require(script:WaitForChild("AvatarAbilitiesInterface"))

    AvatarAbilitiesInterface = AvatarAbilitiesInterface2
    v4 = AvatarAbilitiesInterface2.get(Players.LocalPlayer)
end

local CameraRotationAction = script.Parent:WaitForChild("InputContexts"):WaitForChild("CameraContext"):WaitForChild("CameraRotationAction")
local v5 = Enum.ContextActionPriority.Medium.Value
local VRFirstPersonState = CommonUtils.get("VRFirstPersonState")
local t3 = {
    [Enum.TouchMovementMode.DPad] = DynamicThumbstick2,
    [Enum.DevTouchMovementMode.DPad] = DynamicThumbstick2,
    [Enum.TouchMovementMode.Thumbpad] = DynamicThumbstick2,
    [Enum.DevTouchMovementMode.Thumbpad] = DynamicThumbstick2,
    [Enum.TouchMovementMode.Thumbstick] = ClassicThumbstick,
    [Enum.DevTouchMovementMode.Thumbstick] = ClassicThumbstick,
    [Enum.TouchMovementMode.DynamicThumbstick] = DynamicThumbstick2,
    [Enum.DevTouchMovementMode.DynamicThumbstick] = DynamicThumbstick2,
    [Enum.TouchMovementMode.ClickToMove] = ClickToMoveController,
    [Enum.DevTouchMovementMode.ClickToMove] = ClickToMoveController,
    [Enum.TouchMovementMode.Default] = DynamicThumbstick2,
    [Enum.ComputerMovementMode.Default] = ActionController,
    [Enum.ComputerMovementMode.KeyboardMouse] = ActionController,
    [Enum.DevComputerMovementMode.KeyboardMouse] = ActionController,
    [Enum.DevComputerMovementMode.Scriptable] = nil,
    [Enum.ComputerMovementMode.ClickToMove] = ClickToMoveController,
    [Enum.DevComputerMovementMode.ClickToMove] = ClickToMoveController
}

function t1.new() -- line: 106
    -- upvalues: t1 (copy), Players (copy), RunService (copy), UserInputService (copy), GuiService (copy), UserGameSettings (copy), ContextActionService (copy), UserPlayerScriptsCCLIntegrationD (copy), UserPlayerScriptsBindActivateOnIAS (copy), VehicleController (copy), v4 (ref)
    local self = setmetatable({}, t1)

    if not RunService:IsServer() then
        self.controllers = {}
        self.activeControlModule = nil
        self.activeController = nil
        self.touchJumpController = nil
        self.touchAbilitiesController = nil
        self.moveFunction = Players.LocalPlayer.Move
        self.humanoid = nil
        self.controlsEnabled = true
        self.enabled = false
        self.humanoidSeatedConn = nil
        self.vehicleController = nil
        self.touchControlFrame = nil
        self.currentTorsoAngle = 0
        self.inputMoveVector = Vector3.new(0, 0, 0)
        self.renderedRotationOverride = nil
        self.vehicleController = VehicleController.new()
        Players.LocalPlayer.CharacterAdded:Connect(function(p1) -- line: 139
            -- upvalues: self (copy)
            self:OnCharacterAdded(p1)
        end)
        Players.LocalPlayer.CharacterRemoving:Connect(function(p2) -- line: 140
            -- upvalues: self (copy)
            self:OnCharacterRemoving(p2)
        end)

        if Players.LocalPlayer.Character then
            self:OnCharacterAdded(Players.LocalPlayer.Character)
        end

        UserGameSettings:GetPropertyChangedSignal("TouchMovementMode"):Connect(function() -- line: 145
            -- upvalues: self (copy)
            self:UpdateMovementMode()
        end)
        Players.LocalPlayer:GetPropertyChangedSignal("DevTouchMovementMode"):Connect(function() -- line: 148
            -- upvalues: self (copy)
            self:UpdateMovementMode()
        end)
        UserGameSettings:GetPropertyChangedSignal("ComputerMovementMode"):Connect(function() -- line: 152
            -- upvalues: self (copy)
            self:UpdateMovementMode()
        end)
        Players.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function() -- line: 155
            -- upvalues: self (copy)
            self:UpdateMovementMode()
        end)

        if UserPlayerScriptsCCLIntegrationD then
            v4:GetEnabledChangedSignal():Connect(function() -- line: 159
                -- upvalues: self (copy)
                self:UpdateAbilitiesControllers()
            end)
        end

        self.playerGui = nil
        self.touchGui = nil
        self.playerGuiAddedConn = nil
        GuiService:GetPropertyChangedSignal("TouchControlsEnabled"):Connect(function() -- line: 169
            -- upvalues: self (copy)
            self:UpdateMovementMode()
            self:UpdateActiveControlModuleEnabled()
        end)
        UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 174
            -- upvalues: self (copy)
            self:UpdateMovementMode()
        end)
        self.playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

        if not self.playerGui then
            self.playerGuiAddedConn = Players.LocalPlayer.ChildAdded:Connect(function(p3) -- line: 180
                -- upvalues: self (copy)
                if not p3:IsA("PlayerGui") then
                    return
                end

                self.playerGui = p3
                self.playerGuiAddedConn:Disconnect()
                self.playerGuiAddedConn = nil
                self:UpdateMovementMode()
            end)
        end

        if UserPlayerScriptsBindActivateOnIAS then
            ContextActionService:BindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
        end
    end

    return self
end

local function _fireCustomInputs(p4) -- line: 198
    -- upvalues: UserGameSettings (copy)
    local InputContexts = p4:FindFirstChild("InputContexts")

    if InputContexts ~= nil then
        local CharacterContext = InputContexts:FindFirstChild("CharacterContext")

        if CharacterContext ~= nil then
            local RotationAction = CharacterContext:FindFirstChild("RotationAction")
            local RotationScriptableBinding, v7

            if RotationAction then
                RotationScriptableBinding = RotationAction:FindFirstChild("RotationScriptableBinding")

                if RotationScriptableBinding then
                    v7 = UserGameSettings.RotationType == Enum.RotationType.CameraRelative
                    RotationScriptableBinding:Fire(v7)
                end
            end
        end
    end
end

function t1:restoreSimulatedRotation() -- line: 218
    local renderedRotationOverride = self.renderedRotationOverride

    if renderedRotationOverride ~= nil then
        if renderedRotationOverride.rootPart.Parent ~= nil then
            renderedRotationOverride.rootPart.CFrame = CFrame.new(renderedRotationOverride.rootPart.CFrame.Position) * renderedRotationOverride.simulatedRotation
        end

        self.renderedRotationOverride = nil
    end
end

function t1:applyRenderedRotation() -- line: 229
    -- upvalues: Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local humanoid = self.humanoid
    local v8 = humanoid and humanoid.RootPart

    if CurrentCamera == nil
        or v8 == nil
        or humanoid.Sit
        or humanoid.SeatPart ~= nil
        or v8:IsGrounded()
        or humanoid:GetState() == Enum.HumanoidStateType.Swimming then
        return
    end

    local LookVector = CurrentCamera.CFrame.LookVector
    local v9 = Vector3.new(LookVector.X, 0, LookVector.Z)

    if v9.Magnitude < 0.001 then
        return
    end

    if self.renderedRotationOverride ~= nil and self.renderedRotationOverride.rootPart ~= v8 then
        self:restoreSimulatedRotation()
    end

    if self.renderedRotationOverride == nil then
        self.renderedRotationOverride = {
            rootPart = v8,
            simulatedRotation = v8.CFrame.Rotation
        }
    end

    local CFramePosition = v8.CFrame.Position

    v8.CFrame = CFrame.lookAt(CFramePosition, CFramePosition + v9)
end

local function _cloneInputs(p7) -- line: 255
    -- upvalues: StarterPlayer (copy)
    local clone = StarterPlayer.PlayerModule.InputContexts:Clone()

    clone.CharacterContext.Enabled = true
    clone.CameraContext.Enabled = true
    clone.Parent = p7
end

function t1:InitializeServerAuthority() -- line: 262
    -- upvalues: Players (copy), RunService (copy), StarterPlayer (copy), UserGameSettings (copy), UserPlayerScriptsCCLIntegrationD (copy), UserPlayerScriptsPlayerControlState2 (copy), UserPlayerScriptsTaskDeferSimulation (copy), UserPSUseBindToAnimation (copy), UserServerAuthorityDontSetAutoRotate (copy), AvatarAbilitiesInterface (ref), v4 (ref), _fireCustomInputs (copy), _cloneInputs (copy), v1 (copy)
    if RunService:IsServer() then
        if UserPlayerScriptsCCLIntegrationD then
            for v10, player in Players:GetPlayers() do
                v1.CloneInputsIfAbsent(player)
            end

            Players.PlayerAdded:Connect(v1.CloneInputsIfAbsent)
        else
            for v11, player in Players:GetPlayers() do
                local clone = StarterPlayer.PlayerModule.InputContexts:Clone()

                clone.CharacterContext.Enabled = true
                clone.CameraContext.Enabled = true
                clone.Parent = player
            end

            Players.PlayerAdded:Connect(_cloneInputs)
        end

        if UserPlayerScriptsPlayerControlState2 then
            for v12, player in Players:GetPlayers() do
                v1.createPlayerControlState(player)
            end

            Players.PlayerAdded:Connect(v1.createPlayerControlState)
        end

        if UserPlayerScriptsCCLIntegrationD and UserPlayerScriptsTaskDeferSimulation then
            for v13, player in Players:GetPlayers() do
                AvatarAbilitiesInterface.get(player)
            end

            Players.PlayerAdded:Connect(function(p9) -- line: 287
                -- upvalues: AvatarAbilitiesInterface (ref)
                AvatarAbilitiesInterface.get(p9)
            end)
        end

        if UserPSUseBindToAnimation then
            RunService:BindToAnimation(function(p10) -- line: 293
                -- upvalues: self (copy), Players (copy)
                for v14, player in Players:GetPlayers() do
                    self:ProcessInputs(player, p10)
                end
            end, Enum.StepFrequency.Hz60)
        else
            RunService:BindToSimulation(function(p11) -- line: 299
                -- upvalues: self (copy), Players (copy)
                for v15, player in Players:GetPlayers() do
                    self:ProcessInputs(player, p11)
                end
            end, Enum.StepFrequency.Hz60)
        end
    else
        if UserPlayerScriptsPlayerControlState2 then
            v1.watchForPlayerControlState(Players.LocalPlayer)
        end

        if UserServerAuthorityDontSetAutoRotate then
            RunService.PreAnimation:Connect(function() -- line: 311
                -- upvalues: self (copy)
                self:restoreSimulatedRotation()
            end)
        end

        RunService:BindToRenderStep("CameraInput", Enum.RenderPriority.Last.Value, function() -- line: 317
            -- upvalues: self (copy), Players (copy), UserGameSettings (copy), UserPlayerScriptsCCLIntegrationD (copy), UserPlayerScriptsPlayerControlState2 (copy), UserServerAuthorityDontSetAutoRotate (copy), v4 (ref), _fireCustomInputs (copy), v1 (copy)
            if UserPlayerScriptsPlayerControlState2 then
                v1.writeInputToPCS(Players.LocalPlayer, self, true)
            elseif UserPlayerScriptsCCLIntegrationD then
                v1.FireCustomInputs(Players.LocalPlayer)
            else
                _fireCustomInputs(Players.LocalPlayer)
            end

            if not (not UserServerAuthorityDontSetAutoRotate or UserGameSettings.RotationType ~= Enum.RotationType.CameraRelative or UserPlayerScriptsCCLIntegrationD and v4:isEnabled()) then
                self:applyRenderedRotation()
            end
        end)

        if UserPSUseBindToAnimation then
            RunService:BindToAnimation(function(p12) -- line: 332
                -- upvalues: self (copy), Players (copy)
                self:ProcessInputs(Players.LocalPlayer, p12)
            end, Enum.StepFrequency.Hz60)
        else
            RunService:BindToSimulation(function(p13) -- line: 336
                -- upvalues: self (copy), Players (copy)
                self:ProcessInputs(Players.LocalPlayer, p13)
            end, Enum.StepFrequency.Hz60)
        end
    end

    if self.data and self.data.eventBus then
        self.data.isServerAuthority = true
        self.data.eventBus:publish("SERVER_AUTHORITY_CHANGED", true)
    end
end

local function NormalizeAngle(p14) -- line: 349
    local v16 = (p14 + 12.566370614359172) % 6.283185307179586

    if v16 > 3.141592653589793 then
        v16 -= 6.283185307179586
    end

    return v16
end

local function AverageAngle(p15, p16) -- line: 357
    local v17 = (p16 - p15 + 12.566370614359172) % 6.283185307179586

    if v17 > 3.141592653589793 then
        v17 -= 6.283185307179586
    end

    local v18 = (p15 + v17 / 2 + 12.566370614359172) % 6.283185307179586

    if v18 > 3.141592653589793 then
        v18 -= 6.283185307179586
    end

    return v18
end

function t1:GetEstimatedVRTorsoFrame() -- line: 362
    -- upvalues: VRService (copy)
    local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
    local v19, v20 = UserCFrame:ToEulerAnglesYXZ()
    local v21 = -v20

    if not VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) or not VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand) then
        self.currentTorsoAngle = v21

        return CFrame.new(UserCFrame.Position) * CFrame.fromEulerAnglesYXZ(0, -self.currentTorsoAngle, 0)
    end

    local UserCFrame2 = VRService:GetUserCFrame(Enum.UserCFrame.LeftHand)
    local UserCFrame3 = VRService:GetUserCFrame(Enum.UserCFrame.RightHand)
    local v22 = UserCFrame.Position - UserCFrame2.Position
    local v23 = UserCFrame.Position - UserCFrame3.Position
    local v24 = -math.atan2(v22.X, v22.Z)
    local v25 = (-math.atan2(v23.X, v23.Z) - v24 + 12.566370614359172) % 6.283185307179586

    if v25 > 3.141592653589793 then
        v25 -= 6.283185307179586
    end

    local v26 = (v24 + v25 / 2 + 12.566370614359172) % 6.283185307179586

    if v26 > 3.141592653589793 then
        v26 -= 6.283185307179586
    end

    local v27 = (v21 - self.currentTorsoAngle + 12.566370614359172) % 6.283185307179586

    if v27 > 3.141592653589793 then
        v27 -= 6.283185307179586
    end

    local v28 = (v26 - self.currentTorsoAngle + 12.566370614359172) % 6.283185307179586

    if v28 > 3.141592653589793 then
        v28 -= 6.283185307179586
    end

    if not (v28 > -1.5707963267948966 and v28 < 1.5707963267948966) then
        v28 = v27
    end

    local v29 = math.min(v28, v27)
    local v30 = math.max(v28, v27)

    if not (v29 > 0) then
        v29 = if v30 < 0 then v30 else 0
    end

    self.currentTorsoAngle = v29 + self.currentTorsoAngle

    return CFrame.new(UserCFrame.Position) * CFrame.fromEulerAnglesYXZ(0, -self.currentTorsoAngle, 0)
end

function t1:GetActiveController() -- line: 406
    return self.activeController
end

function t1:UpdateAbilitiesControllers() -- line: 410
    -- upvalues: UserInputService (copy), DynamicThumbstick (ref), ClassicThumbstick (copy), ClickToMoveController (copy), TouchJump (copy), v4 (ref), v3 (copy)
    local enabled = self.enabled and self.touchControlFrame and UserInputService.PreferredInput == Enum.PreferredInput.Touch and (self.activeControlModule == ClickToMoveController or self.activeControlModule == ClassicThumbstick or self.activeControlModule == DynamicThumbstick)
    local v31 = enabled

    if enabled then
        v31 = not v4:isEnabled()
        enabled = v4:isEnabled()
    end

    if v31 then
        if not self.controllers[TouchJump] then
            self.controllers[TouchJump] = TouchJump.new(self.data)
        end

        self.touchJumpController = self.controllers[TouchJump]
        self.touchJumpController:Enable(true, self.touchControlFrame)
    elseif self.touchJumpController then
        self.touchJumpController:Enable(false)
    end

    if enabled then
        if not self.controllers[v3] then
            self.controllers[v3] = v3.new(self.touchControlFrame)
        end

        self.touchAbilitiesController = self.controllers[v3]
        self.touchAbilitiesController:Enable(true)
    elseif self.touchAbilitiesController then
        self.touchAbilitiesController:Enable(false)
    end
end

function t1:UpdateActiveControlModuleEnabled() -- line: 446
    -- upvalues: Players (copy), UserInputService (copy), GuiService (copy), UserPlayerScriptsCCLIntegrationD (copy), DynamicThumbstick (ref), ClassicThumbstick (copy), ClickToMoveController (copy), TouchJump (copy), v4 (ref)
    local function v32() -- line: 448
        -- upvalues: self (copy), Players (copy), UserPlayerScriptsCCLIntegrationD (copy), v4 (ref)
        if UserPlayerScriptsCCLIntegrationD then
            self.enabled = false
        end

        self.activeController:Enable(false)

        if UserPlayerScriptsCCLIntegrationD then
            self:UpdateAbilitiesControllers()
        elseif self.touchJumpController then
            self.touchJumpController:Enable(false)
        end

        if not (not self.moveFunction or UserPlayerScriptsCCLIntegrationD and v4:isEnabled()) then
            self.moveFunction(Players.LocalPlayer, Vector3.new(0, 0, 0), true)
        end
    end

    local function v33() -- line: 468
        -- upvalues: self (copy), Players (copy), UserInputService (copy), UserPlayerScriptsCCLIntegrationD (copy), DynamicThumbstick (ref), ClassicThumbstick (copy), ClickToMoveController (copy), TouchJump (copy)
        if UserPlayerScriptsCCLIntegrationD then
            self.enabled = true
            self:UpdateAbilitiesControllers()
        elseif self.touchControlFrame and UserInputService.PreferredInput == Enum.PreferredInput.Touch and (self.activeControlModule == ClickToMoveController or self.activeControlModule == ClassicThumbstick or self.activeControlModule == DynamicThumbstick) then
            if not self.controllers[TouchJump] then
                self.controllers[TouchJump] = TouchJump.new(self.data)
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
        if not self.controlsEnabled or not (GuiService.TouchControlsEnabled or UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or self.activeControlModule ~= ClickToMoveController and self.activeControlModule ~= ClassicThumbstick and self.activeControlModule ~= DynamicThumbstick) then
            v32()
        else
            v33()
        end
    end
end

function t1:Enable(p22) -- line: 533
    local v34 = p22 == nil or p22

    if self.controlsEnabled ~= v34 then
        self.controlsEnabled = v34

        if self.activeController then
            self:UpdateActiveControlModuleEnabled()
        end
    end
end

function t1.Disable(p23) -- line: 548
    p23:Enable(false)
end

function t1.SelectComputerMovementModule(p24) -- line: 554
    -- upvalues: Players (copy), UserInputService (copy), UserGameSettings (copy), UserPlayerScriptsSupportMicroGamepad (copy), ActionController (copy), ClickToMoveController (copy), t3 (copy)
    local v35 = false

    if UserPlayerScriptsSupportMicroGamepad then
        local function v36() -- line: 557
            -- upvalues: v35 (ref), UserInputService (copy)
            v35 = UserInputService.PreferredInput == Enum.PreferredInput.MicroGamepad
        end

        pcall(v36)
    end

    if UserInputService.PreferredInput ~= Enum.PreferredInput.KeyboardAndMouse and UserInputService.PreferredInput ~= Enum.PreferredInput.Gamepad and not v35 then
        return nil, false
    end

    local v37 = ActionController
    local DevComputerMovementMode = Players.LocalPlayer.DevComputerMovementMode

    if DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice then
        if UserGameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove then
            v37 = ClickToMoveController
        end
    else
        v37 = t3[DevComputerMovementMode]

        if not v37 and DevComputerMovementMode ~= Enum.DevComputerMovementMode.Scriptable then
            warn("No character control module is associated with DevComputerMovementMode ", DevComputerMovementMode)
        end
    end

    if v37 then
        return v37, true
    end

    if DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable then
        return nil, true
    end

    return nil, false
end

function t1.SelectTouchModule(p25) -- line: 598
    -- upvalues: Players (copy), UserGameSettings (copy), t3 (copy)
    local DevTouchMovementMode = Players.LocalPlayer.DevTouchMovementMode
    local v38

    if DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice then
        v38 = t3[UserGameSettings.TouchMovementMode]
    else
        if DevTouchMovementMode == Enum.DevTouchMovementMode.Scriptable then
            return nil, true
        end

        v38 = t3[DevTouchMovementMode]
    end

    return v38, true
end

function t1:calculateRawMoveVector(p27, p28) -- line: 611
    -- upvalues: Workspace (copy), VRService (copy), CameraRotationAction (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if not CurrentCamera then
        return p28
    end

    local _CFrame = CurrentCamera.CFrame

    if VRService.VREnabled and p27.RootPart then
        local EstimatedVRTorsoFrame = self:GetEstimatedVRTorsoFrame()

        if (CurrentCamera.Focus.Position - _CFrame.Position).Magnitude < 3 then
            _CFrame *= EstimatedVRTorsoFrame
        else
            _CFrame = CurrentCamera.CFrame * (EstimatedVRTorsoFrame.Rotation + EstimatedVRTorsoFrame.Position * CurrentCamera.HeadScale)
        end
    end

    if p27:GetState() == Enum.HumanoidStateType.Swimming then
        if not VRService.VREnabled then
            return _CFrame:VectorToWorldSpace(p28)
        end

        local v39 = Vector3.new(p28.X, 0, p28.Z)

        if v39.Magnitude < 0.01 then
            return (Vector3.new(0, 0, 0))
        end

        local v40 = if CameraRotationAction and CameraRotationAction.Enabled then -CameraRotationAction:GetState().Y / 2.31 else 0
        local v43 = math.atan2(-v39.X, -v39.Z)
        local v44, v45 = _CFrame:ToEulerAnglesYXZ()
        local v46 = v43 + v45

        return CFrame.fromEulerAnglesYXZ(v40, v46, 0).LookVector
    end

    local v47, v48, v49, Components, Components2, Components3, v50, v51, Components4, v52, v53, Components5 = _CFrame:GetComponents()

    if not (Components4 < 1 and Components4 > -1) then
        Components3 = -Components2 * math.sign(Components4)
    else
        Components = Components5
    end

    local v55 = math.sqrt(Components * Components + Components3 * Components3)

    return (Vector3.new((Components * p28.X + Components3 * p28.Z) / v55, 0, (Components * p28.Z - Components3 * p28.X) / v55))
end

function t1:initialize(p30) -- line: 672
    -- upvalues: UserPlayerScriptsCCLIntegrationD (copy), ActionController (copy), v2 (copy)
    self.data = p30
    self:UpdateMovementMode()
    ActionController.initializeActions(self.data)

    if UserPlayerScriptsCCLIntegrationD then
        v2.setupSlotActions(self.data.player, self.data.isServerAuthority)
    end
end

function t1:Update(p32, p33) -- line: 683
    -- upvalues: Players (copy), VRService (copy), UserPlayerScriptsCCLIntegrationD (copy), UserPlayerScriptsPlayerControlState2 (copy), UserPlayerScriptsFixSAuthRenderStepMove (copy), UserControlModuleEnabledAPI (copy), ActionController (copy), v4 (ref), v1 (copy)
    assert(p32.player)
    assert(p32.character)

    if UserControlModuleEnabledAPI then
        if not self.humanoid then
            return
        end

        if not p32.playerModule.ControlModule.Enabled then
            p32.isJumping = false
            p32.moveVector = Vector2.new()
            p32.worldMoveVector = Vector3.new()
            ActionController.update(p32)
            self.inputMoveVector = Vector3.new()

            if self.vehicleController then
                self.vehicleController:Update(Vector3.new(), true)
            end

            self:characterMove(p32)

            return
        end
    end

    ActionController.initializeActions(p32)

    if not (UserControlModuleEnabledAPI or p32.actions.MoveAction and p32.actions.JumpAction) or not (self.activeController and self.activeController.enabled and self.humanoid) then
        return
    end

    ActionController.update(p32)
    self:GetClickToMoveController():Update(p32, p33)

    local v59 = Vector3.new(p32.moveVector.X, 0, -p32.moveVector.Y)

    if self.vehicleController then
        local v60

        v59, v60 = self.vehicleController:Update(v59, true)
        _ = v60
    end

    local v61 = self:calculateRawMoveVector(self.humanoid, v59)

    self.inputMoveVector = v61

    if VRService.VREnabled then
        v61 = self:updateVRMoveVector(v61)
    end

    if UserControlModuleEnabledAPI then
        p32.worldMoveVector = v61
        self:characterMove(p32)
    elseif UserPlayerScriptsPlayerControlState2 then
        if not p32.isServerAuthority then
            if not (UserPlayerScriptsCCLIntegrationD and v4:isEnabled()) then
                self.moveFunction(Players.LocalPlayer, v61, false)
                self.humanoid.Jump = p32.isJumping
            else
                v1.writeInputToPCS(Players.LocalPlayer, self, false)
            end
        end
    elseif not (UserPlayerScriptsFixSAuthRenderStepMove and p32.isServerAuthority or UserPlayerScriptsCCLIntegrationD and v4:isEnabled()) then
        self.moveFunction(Players.LocalPlayer, v61, false)
        self.humanoid.Jump = p32.isJumping
    end
end

function t1:characterMove(p35) -- line: 764
    -- upvalues: Players (copy), UserPlayerScriptsCCLIntegrationD (copy), UserPlayerScriptsPlayerControlState2 (copy), UserPlayerScriptsFixSAuthRenderStepMove (copy), v4 (ref), v1 (copy)
    if UserPlayerScriptsPlayerControlState2 then
        if not p35.isServerAuthority then
            if not (UserPlayerScriptsCCLIntegrationD and v4:isEnabled()) then
                self.moveFunction(Players.LocalPlayer, p35.worldMoveVector, false)
                self.humanoid.Jump = p35.isJumping
            else
                v1.writeInputToPCS(Players.LocalPlayer, self, false)
            end
        end
    elseif not (UserPlayerScriptsFixSAuthRenderStepMove and p35.isServerAuthority or UserPlayerScriptsCCLIntegrationD and v4:isEnabled()) then
        self.moveFunction(Players.LocalPlayer, p35.worldMoveVector, false)
        self.humanoid.Jump = p35.isJumping
    end
end

function t1:updateVRMoveVector(p37) -- line: 784
    -- upvalues: VRService (copy), UserVRFixCameraCloseArticulation (copy), VRFirstPersonState (copy)
    local CurrentCamera = workspace.CurrentCamera
    local v62 = CurrentCamera.Focus.Position - CurrentCamera.CFrame.Position
    local v63 = if UserVRFixCameraCloseArticulation then VRFirstPersonState.inFirstPerson else v62.Magnitude < 5

    if p37.Magnitude ~= 0 or not v63 or not VRService.AvatarGestures or not self.humanoid or self.humanoid.Sit then
        return p37
    end

    local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
    local v64 = UserCFrame.Rotation + UserCFrame.Position * CurrentCamera.HeadScale
    local v65 = -0.7 * self.humanoid.RootPart.Size.Y / 2
    local v66 = (CurrentCamera.CFrame * v64 * CFrame.new(0, v65, 0)).Position - self.humanoid.RootPart.CFrame.Position
    local v67 = Vector3.new(v66.x, 0, v66.z)
    local v68 = if UserVRFixCameraCloseArticulation then (CurrentCamera.Focus.Position - CurrentCamera.CFrame.Position).Magnitude > math.max(4 * CurrentCamera.HeadScale, 1) else nil

    if not UserVRFixCameraCloseArticulation or not v68 then
        return v67
    end

    return p37
end

function t1:OnHumanoidSeated(p39, p40) -- line: 825
    if p39 then
        if p40 and p40:IsA("VehicleSeat") then
            if not self.vehicleController then
                self.vehicleController = self.vehicleController.new()
            end

            self.vehicleController:Enable(true, p40)
        end
    elseif self.vehicleController then
        self.vehicleController:Enable(false, p40)
    end
end

function t1:OnCharacterAdded(p42) -- line: 840
    self.humanoid = p42:FindFirstChildOfClass("Humanoid")

    while not self.humanoid do
        p42.ChildAdded:wait()
        self.humanoid = p42:FindFirstChildOfClass("Humanoid")
    end

    if self.humanoidSeatedConn then
        self.humanoidSeatedConn:Disconnect()
        self.humanoidSeatedConn = nil
    end

    self.humanoidSeatedConn = self.humanoid.Seated:Connect(function(p43, p44) -- line: 851
        -- upvalues: self (copy)
        self:OnHumanoidSeated(p43, p44)
    end)
    self:UpdateMovementMode()
end

function t1:OnCharacterRemoving(p46) -- line: 858
    self.humanoid = nil
    self:UpdateMovementMode()
end

function t1:UpdateTouchGuiVisibility() -- line: 864
    -- upvalues: UserInputService (copy), GuiService (copy)
    local humanoid = self.humanoid and GuiService.TouchControlsEnabled and UserInputService.PreferredInput == Enum.PreferredInput.Touch

    if humanoid and not self.touchGui then
        self:CreateTouchGuiContainer()
    end

    if self.touchGui then
        self.touchGui.Enabled = not not humanoid
    end
end

function t1:SwitchToController(p49) -- line: 883
    if p49 then
        if not self.controllers[p49] then
            self.controllers[p49] = p49.new(self.data)
        end

        if self.activeController ~= self.controllers[p49] then
            if self.activeController then
                self.activeController:Enable(false)
            end

            self.activeController = self.controllers[p49]
            self.activeControlModule = p49
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

function t1:UpdateMovementMode() -- line: 922
    -- upvalues: UserInputService (copy)
    self:UpdateTouchGuiVisibility()

    if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
        local v70, v71 = self:SelectTouchModule()

        if v71 and self.touchControlFrame then
            self:SwitchToController(v70)
        end
    else
        self:SwitchToController((self:SelectComputerMovementModule()))
    end
end

function t1:CreateTouchGuiContainer() -- line: 938
    -- upvalues: UserPlayerScriptsCCLIntegrationD (copy), UserAbilitiesUserInterfaceC (copy)
    if self.playerGui then
        if self.touchGui then
            self.touchGui:Destroy()
        end

        self.touchGui = Instance.new("ScreenGui")
        self.touchGui.Name = "TouchGui"
        self.touchGui.ResetOnSpawn = false
        self.touchGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        if UserPlayerScriptsCCLIntegrationD and UserAbilitiesUserInterfaceC then
            self.touchGui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
        end

        self.touchGui.ClipToDeviceSafeArea = false
        self.touchControlFrame = Instance.new("Frame")
        self.touchControlFrame.Name = "TouchControlFrame"
        self.touchControlFrame.Size = UDim2.new(1, 0, 1, 0)
        self.touchControlFrame.BackgroundTransparency = 1
        self.touchControlFrame.Parent = self.touchGui
        self.touchGui.Parent = self.playerGui
    end
end

function t1:GetClickToMoveController() -- line: 965
    -- upvalues: ClickToMoveController (copy)
    if not self.controllers[ClickToMoveController] then
        self.controllers[ClickToMoveController] = ClickToMoveController.new()
    end

    return self.controllers[ClickToMoveController]
end

function t1.ProcessInputs(p53, p54, p55) -- line: 972
    -- upvalues: UserPlayerScriptsCCLIntegrationD (copy), UserPlayerScriptsPlayerControlState2 (copy), AvatarAbilitiesInterface (ref), v1 (copy)
    local v72

    if UserPlayerScriptsCCLIntegrationD then
        v72 = AvatarAbilitiesInterface.get(p54):isEnabled()
    else
        if UserPlayerScriptsPlayerControlState2 then
            v1.processPCSInputs(p54)

            return
        end

        local Character = p54.Character

        if Character == nil then
            return
        end

        local Humanoid = Character:FindFirstChild("Humanoid")

        if Humanoid == nil then
            return
        end

        local InputContexts = p54:FindFirstChild("InputContexts")

        if InputContexts == nil then
            return
        end

        local CharacterContext = InputContexts:FindFirstChild("CharacterContext")

        if CharacterContext == nil then
            return
        end

        local MoveAction, RotationAction, JumpAction = CharacterContext.MoveAction, CharacterContext.RotationAction, CharacterContext.JumpAction

        local function isValidInput2D(p56) -- line: 1008
            return not (p56.X ~= p56.X or p56.Y ~= p56.Y or p56.X == 1e999 or p56.Y == 1e999)
        end

        local function isValidInput3D(p57) -- line: 1016
            return not (p57.X ~= p57.X
                or p57.Y ~= p57.Y
                or p57.Z ~= p57.Z
                or p57.X == 1e999
                or p57.Y == 1e999
                or p57.Z == 1e999)
        end

        local v73 = if MoveAction == nil then Vector2.new(0, 0) else MoveAction:GetState()
        local LookVector = p54:GetCameraState().CFrame.LookVector

        if v73.X == v73.X and v73.Y == v73.Y and v73.X ~= 1e999 and v73.Y ~= 1e999 and LookVector.X == LookVector.X and LookVector.Y == LookVector.Y and LookVector.Z == LookVector.Z and LookVector.X ~= 1e999 and LookVector.Y ~= 1e999 and LookVector.Z ~= 1e999 and LookVector.Magnitude > 0 then
            if Humanoid:GetState() ~= Enum.HumanoidStateType.Swimming then
                LookVector = Vector3.new(LookVector.X, 0, LookVector.Z).Unit
            end

            local Unit = LookVector:Cross((Vector3.new(0, 1, 0))).Unit

            Humanoid:Move(LookVector * v73.Y + Unit * v73.X)

            if RotationAction:GetState() then
                Humanoid.AutoRotate = false

                if Humanoid.SeatPart == nil and Humanoid.RootPart ~= nil and not Humanoid.Sit and not Humanoid.RootPart:IsGrounded() then
                    Humanoid.RootPart.CFrame = CFrame.new(Humanoid.RootPart.CFrame.Position, Humanoid.RootPart.CFrame.Position + LookVector)
                end
            else
                Humanoid.AutoRotate = true
            end
        end

        if JumpAction ~= nil then
            Humanoid.Jump = JumpAction:GetState()
        else
            Humanoid.Jump = false
        end
    end

    if not (UserPlayerScriptsCCLIntegrationD and v72 or not UserPlayerScriptsCCLIntegrationD) then
        if UserPlayerScriptsPlayerControlState2 then
            v1.processPCSInputs(p54)
        else
            v1.SendInputToHumanoidForServerAuth(p54)
        end
    end
end

if RunService:IsClient() then
    return t1.new()
end

return t1
