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
local v1 = FlagUtil.getUserFlag("UserPlayerScriptsCCLIntegrationD") or FlagUtil.getUserFlag("UserPlayerScriptsCCLIntegrationDGA")
local UserPlayerScriptsBindActivateOnIAS = FlagUtil.getUserFlag("UserPlayerScriptsBindActivateOnIAS")
local v2 = FlagUtil.getUserFlag("UserPlayerScriptsPlayerControlState2") or FlagUtil.getUserFlag("UserPlayerScriptsPlayerControlState2GA")
local UserPlayerScriptsTaskDeferSimulation = FlagUtil.getUserFlag("UserPlayerScriptsTaskDeferSimulation")
local UserPlayerScriptsFixSAuthRenderStepMove = FlagUtil.getUserFlag("UserPlayerScriptsFixSAuthRenderStepMove")
local UserPlayerScriptsSupportMicroGamepad = FlagUtil.getUserFlag("UserPlayerScriptsSupportMicroGamepad")
local UserAbilitiesUserInterfaceA = FlagUtil.getUserFlag("UserAbilitiesUserInterfaceA")
local UserAbilitiesUserInterfaceC = FlagUtil.getUserFlag("UserAbilitiesUserInterfaceC")
local UserPSUseBindToAnimation = FlagUtil.getUserFlag("UserPSUseBindToAnimation")
local UserServerAuthorityDontSetAutoRotate = FlagUtil.getUserFlag("UserServerAuthorityDontSetAutoRotate")
local UserPlayerModuleEngineAPI = FlagUtil.getUserFlag("UserPlayerModuleEngineAPI")
local UserControlModuleDisabledUpdate = FlagUtil.getUserFlag("UserControlModuleDisabledUpdate")
local t2 = {
    SERVER_AUTHORITY_CHANGED = "SERVER_AUTHORITY_CHANGED"
}
local ActionController = require(script:WaitForChild("ActionController"))
local v3 = if v1 or v2 then require(script:WaitForChild("InputReplication")) else nil
local v4 = if v1 then require(script:WaitForChild("InputSlots")) else nil
local DynamicThumbstick, DynamicThumbstick2

if RunService:IsClient() then
    local DynamicThumbstick3 = require(script:WaitForChild("DynamicThumbstick"))

    DynamicThumbstick2 = DynamicThumbstick3
    DynamicThumbstick = DynamicThumbstick3
end

local ClassicThumbstick = require(script:WaitForChild("ClassicThumbstick"))
local ClickToMoveController = require(script:WaitForChild("ClickToMoveController"))
local TouchJump = require(script:WaitForChild("TouchJump"))
local v5, v6, v7

if v1 then
    v5 = require(script:WaitForChild("TouchAbilities"))
    v6 = require(script:WaitForChild("AbilitiesOverflowMenu"))
    v7 = require(script:WaitForChild("AbilitiesKeybindBar"))
end

local VehicleController = require(script:WaitForChild("VehicleController"))
local AvatarAbilitiesInterface, v8

if v1 then
    local AvatarAbilitiesInterface2 = require(script:WaitForChild("AvatarAbilitiesInterface"))

    AvatarAbilitiesInterface = AvatarAbilitiesInterface2
    v8 = AvatarAbilitiesInterface2.get(Players.LocalPlayer)
end

local CameraRotationAction = script.Parent:WaitForChild("InputContexts"):WaitForChild("CameraContext"):WaitForChild("CameraRotationAction")
local v9 = Enum.ContextActionPriority.Medium.Value
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

function t1.new() -- line: 123
    -- upvalues: t1 (copy), Players (copy), RunService (copy), UserInputService (copy), GuiService (copy), UserGameSettings (copy), ContextActionService (copy), UserPlayerScriptsBindActivateOnIAS (copy), UserPlayerModuleEngineAPI (copy), VehicleController (copy), v8 (ref), v1 (copy)
    local self = setmetatable({}, t1)

    if not RunService:IsServer() then
        self.controllers = {}
        self.activeControlModule = nil
        self.activeController = nil
        self.touchJumpController = nil
        self.touchAbilitiesController = nil
        self.abilitiesOverflowController = nil
        self.abilitiesKeybindBarController = nil
        self.moveFunction = Players.LocalPlayer.Move
        self.humanoid = nil
        self.controlsEnabled = true
        self.enabled = false
        self.humanoidSeatedConn = nil
        self.vehicleController = nil
        self.touchControlFrame = nil
        self.abilitiesGui = nil
        self.abilitiesFrame = nil
        self.currentTorsoAngle = 0
        self.inputMoveVector = Vector3.new(0, 0, 0)
        self.renderedRotationOverride = nil
        self.vehicleController = VehicleController.new()

        if not UserPlayerModuleEngineAPI then
            Players.LocalPlayer.CharacterAdded:Connect(function(p1) -- line: 161
                -- upvalues: self (copy)
                self:OnCharacterAdded(p1)
            end)
            Players.LocalPlayer.CharacterRemoving:Connect(function(p2) -- line: 164
                -- upvalues: self (copy)
                self:OnCharacterRemoving(p2)
            end)

            if Players.LocalPlayer.Character then
                self:OnCharacterAdded(Players.LocalPlayer.Character)
            end
        end

        UserGameSettings:GetPropertyChangedSignal("TouchMovementMode"):Connect(function() -- line: 172
            -- upvalues: self (copy)
            self:UpdateMovementMode()
        end)
        Players.LocalPlayer:GetPropertyChangedSignal("DevTouchMovementMode"):Connect(function() -- line: 175
            -- upvalues: self (copy)
            self:UpdateMovementMode()
        end)
        UserGameSettings:GetPropertyChangedSignal("ComputerMovementMode"):Connect(function() -- line: 179
            -- upvalues: self (copy)
            self:UpdateMovementMode()
        end)
        Players.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function() -- line: 182
            -- upvalues: self (copy)
            self:UpdateMovementMode()
        end)

        if v1 then
            v8:GetEnabledChangedSignal():Connect(function() -- line: 186
                -- upvalues: self (copy)
                self:UpdateAbilitiesControllers()
            end)
        end

        self.playerGui = nil
        self.touchGui = nil
        self.playerGuiAddedConn = nil
        GuiService:GetPropertyChangedSignal("TouchControlsEnabled"):Connect(function() -- line: 197
            -- upvalues: self (copy)
            self:UpdateMovementMode()
            self:UpdateActiveControlModuleEnabled()
        end)
        UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 202
            -- upvalues: self (copy)
            self:UpdateMovementMode()
        end)
        self.playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

        if not self.playerGui then
            self.playerGuiAddedConn = Players.LocalPlayer.ChildAdded:Connect(function(p3) -- line: 208
                -- upvalues: self (copy), v1 (copy)
                if not p3:IsA("PlayerGui") then
                    return
                end

                self.playerGui = p3
                self.playerGuiAddedConn:Disconnect()
                self.playerGuiAddedConn = nil
                self:UpdateMovementMode()

                if v1 then
                    self:UpdateAbilitiesControllers()
                end
            end)
        end

        if UserPlayerScriptsBindActivateOnIAS then
            ContextActionService:BindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
        end
    end

    return self
end

local function _fireCustomInputs(p4) -- line: 229
    -- upvalues: UserGameSettings (copy), UserControlModuleDisabledUpdate (copy)
    assert(not UserControlModuleDisabledUpdate)

    local InputContexts = p4:FindFirstChild("InputContexts")

    if InputContexts ~= nil then
        local CharacterContext = InputContexts:FindFirstChild("CharacterContext")

        if CharacterContext ~= nil then
            local RotationAction = CharacterContext:FindFirstChild("RotationAction")
            local RotationScriptableBinding, v12

            if RotationAction then
                RotationScriptableBinding = RotationAction:FindFirstChild("RotationScriptableBinding")

                if RotationScriptableBinding then
                    v12 = UserGameSettings.RotationType == Enum.RotationType.CameraRelative
                    RotationScriptableBinding:Fire(v12)
                end
            end
        end
    end
end

function t1:restoreSimulatedRotation() -- line: 250
    local renderedRotationOverride = self.renderedRotationOverride

    if renderedRotationOverride ~= nil then
        if renderedRotationOverride.rootPart.Parent ~= nil then
            renderedRotationOverride.rootPart.CFrame = CFrame.new(renderedRotationOverride.rootPart.CFrame.Position) * renderedRotationOverride.simulatedRotation
        end

        self.renderedRotationOverride = nil
    end
end

function t1:applyRenderedRotation() -- line: 261
    -- upvalues: Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local humanoid = self.humanoid
    local v13 = humanoid and humanoid.RootPart

    if CurrentCamera == nil
        or v13 == nil
        or humanoid.Sit
        or humanoid.SeatPart ~= nil
        or v13:IsGrounded()
        or humanoid:GetState() == Enum.HumanoidStateType.Swimming then
        return
    end

    local LookVector = CurrentCamera.CFrame.LookVector
    local v14 = Vector3.new(LookVector.X, 0, LookVector.Z)

    if v14.Magnitude < 0.001 then
        return
    end

    if self.renderedRotationOverride ~= nil and self.renderedRotationOverride.rootPart ~= v13 then
        self:restoreSimulatedRotation()
    end

    if self.renderedRotationOverride == nil then
        self.renderedRotationOverride = {
            rootPart = v13,
            simulatedRotation = v13.CFrame.Rotation
        }
    end

    local CFramePosition = v13.CFrame.Position

    v13.CFrame = CFrame.lookAt(CFramePosition, CFramePosition + v14)
end

local function _cloneInputs(p7) -- line: 293
    -- upvalues: StarterPlayer (copy)
    local clone = StarterPlayer.PlayerModule.InputContexts:Clone()

    clone.CharacterContext.Enabled = true
    clone.CameraContext.Enabled = true
    clone.Parent = p7
end

function t1:InitializeServerAuthority() -- line: 300
    -- upvalues: Players (copy), RunService (copy), StarterPlayer (copy), UserGameSettings (copy), UserPlayerScriptsTaskDeferSimulation (copy), UserPSUseBindToAnimation (copy), UserServerAuthorityDontSetAutoRotate (copy), UserControlModuleDisabledUpdate (copy), AvatarAbilitiesInterface (ref), v8 (ref), _fireCustomInputs (copy), _cloneInputs (copy), v1 (copy), v2 (copy), v3 (copy)
    if RunService:IsServer() then
        if v1 then
            for v15, player in Players:GetPlayers() do
                v3.CloneInputsIfAbsent(player)
            end

            Players.PlayerAdded:Connect(v3.CloneInputsIfAbsent)
        else
            for v16, player in Players:GetPlayers() do
                local clone = StarterPlayer.PlayerModule.InputContexts:Clone()

                clone.CharacterContext.Enabled = true
                clone.CameraContext.Enabled = true
                clone.Parent = player
            end

            Players.PlayerAdded:Connect(_cloneInputs)
        end

        if v2 then
            for v17, player in Players:GetPlayers() do
                v3.createPlayerControlState(player)
            end

            Players.PlayerAdded:Connect(v3.createPlayerControlState)
        end

        if v1 and UserPlayerScriptsTaskDeferSimulation then
            for v18, player in Players:GetPlayers() do
                AvatarAbilitiesInterface.get(player)
            end

            Players.PlayerAdded:Connect(function(p9) -- line: 325
                -- upvalues: AvatarAbilitiesInterface (ref)
                AvatarAbilitiesInterface.get(p9)
            end)
        end

        if UserPSUseBindToAnimation then
            RunService:BindToAnimation(function(p10) -- line: 331
                -- upvalues: self (copy), Players (copy)
                for v19, player in Players:GetPlayers() do
                    self:ProcessInputs(player, p10)
                end
            end, Enum.StepFrequency.Hz60)
        else
            RunService:BindToSimulation(function(p11) -- line: 337
                -- upvalues: self (copy), Players (copy)
                for v20, player in Players:GetPlayers() do
                    self:ProcessInputs(player, p11)
                end
            end, Enum.StepFrequency.Hz60)
        end
    else
        if v2 then
            v3.watchForPlayerControlState(Players.LocalPlayer)
        end

        if UserServerAuthorityDontSetAutoRotate then
            RunService.PreAnimation:Connect(function() -- line: 349
                -- upvalues: self (copy)
                self:restoreSimulatedRotation()
            end)
        end

        RunService:BindToRenderStep("CameraInput", Enum.RenderPriority.Last.Value, function() -- line: 354
            -- upvalues: self (copy), Players (copy), UserGameSettings (copy), UserServerAuthorityDontSetAutoRotate (copy), UserControlModuleDisabledUpdate (copy), v8 (ref), _fireCustomInputs (copy), v1 (copy), v2 (copy), v3 (copy)
            if not UserControlModuleDisabledUpdate then
                if v2 then
                    v3.writeInputToCS(Players.LocalPlayer, self)
                elseif v1 then
                    v3.FireCustomInputs(Players.LocalPlayer)
                else
                    _fireCustomInputs(Players.LocalPlayer)
                end
            end

            if not (not UserServerAuthorityDontSetAutoRotate or UserGameSettings.RotationType ~= Enum.RotationType.CameraRelative or v1 and v8:isEnabled()) then
                self:applyRenderedRotation()
            end
        end)

        if UserPSUseBindToAnimation then
            RunService:BindToAnimation(function(p12) -- line: 374
                -- upvalues: self (copy), Players (copy)
                self:ProcessInputs(Players.LocalPlayer, p12)
            end, Enum.StepFrequency.Hz60)
        else
            RunService:BindToSimulation(function(p13) -- line: 378
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

local function NormalizeAngle(p14) -- line: 390
    local v21 = (p14 + 12.566370614359172) % 6.283185307179586

    if v21 > 3.141592653589793 then
        v21 -= 6.283185307179586
    end

    return v21
end

local function AverageAngle(p15, p16) -- line: 398
    local v22 = (p16 - p15 + 12.566370614359172) % 6.283185307179586

    if v22 > 3.141592653589793 then
        v22 -= 6.283185307179586
    end

    local v23 = (p15 + v22 / 2 + 12.566370614359172) % 6.283185307179586

    if v23 > 3.141592653589793 then
        v23 -= 6.283185307179586
    end

    return v23
end

function t1:GetEstimatedVRTorsoFrame() -- line: 403
    -- upvalues: VRService (copy)
    local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
    local v24, v25 = UserCFrame:ToEulerAnglesYXZ()
    local v26 = -v25

    if not VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) or not VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand) then
        self.currentTorsoAngle = v26

        return CFrame.new(UserCFrame.Position) * CFrame.fromEulerAnglesYXZ(0, -self.currentTorsoAngle, 0)
    end

    local UserCFrame2 = VRService:GetUserCFrame(Enum.UserCFrame.LeftHand)
    local UserCFrame3 = VRService:GetUserCFrame(Enum.UserCFrame.RightHand)
    local v27 = UserCFrame.Position - UserCFrame2.Position
    local v28 = UserCFrame.Position - UserCFrame3.Position
    local v29 = -math.atan2(v27.X, v27.Z)
    local v30 = (-math.atan2(v28.X, v28.Z) - v29 + 12.566370614359172) % 6.283185307179586

    if v30 > 3.141592653589793 then
        v30 -= 6.283185307179586
    end

    local v31 = (v29 + v30 / 2 + 12.566370614359172) % 6.283185307179586

    if v31 > 3.141592653589793 then
        v31 -= 6.283185307179586
    end

    local v32 = (v26 - self.currentTorsoAngle + 12.566370614359172) % 6.283185307179586

    if v32 > 3.141592653589793 then
        v32 -= 6.283185307179586
    end

    local v33 = (v31 - self.currentTorsoAngle + 12.566370614359172) % 6.283185307179586

    if v33 > 3.141592653589793 then
        v33 -= 6.283185307179586
    end

    if not (v33 > -1.5707963267948966 and v33 < 1.5707963267948966) then
        v33 = v32
    end

    local v34 = math.min(v33, v32)
    local v35 = math.max(v33, v32)

    if not (v34 > 0) then
        v34 = if v35 < 0 then v35 else 0
    end

    self.currentTorsoAngle = v34 + self.currentTorsoAngle

    return CFrame.new(UserCFrame.Position) * CFrame.fromEulerAnglesYXZ(0, -self.currentTorsoAngle, 0)
end

function t1:GetActiveController() -- line: 448
    return self.activeController
end

function t1:UpdateAbilitiesControllers() -- line: 452
    -- upvalues: UserInputService (copy), UserAbilitiesUserInterfaceA (copy), UserAbilitiesUserInterfaceC (copy), DynamicThumbstick (ref), ClassicThumbstick (copy), ClickToMoveController (copy), TouchJump (copy), v8 (ref), v5 (ref), v6 (ref), v7 (ref)
    local enabled = self.enabled and self.touchControlFrame and UserInputService.PreferredInput == Enum.PreferredInput.Touch and (self.activeControlModule == ClickToMoveController or self.activeControlModule == ClassicThumbstick or self.activeControlModule == DynamicThumbstick)
    local v36 = enabled

    if enabled then
        v36 = not v8:isEnabled()
        enabled = v8:isEnabled()
    end

    if v36 then
        if not self.controllers[TouchJump] then
            self.controllers[TouchJump] = TouchJump.new(self.data)
        end

        self.touchJumpController = self.controllers[TouchJump]
        self.touchJumpController:Enable(true, self.touchControlFrame)
    elseif self.touchJumpController then
        if enabled then
            self.touchJumpController:Destroy()
            self.controllers[TouchJump] = nil
            self.touchJumpController = nil
        else
            self.touchJumpController:Enable(false)
        end
    end

    if enabled then
        if not self.controllers[v5] then
            self.controllers[v5] = v5.new(self.touchControlFrame)
        end

        self.touchAbilitiesController = self.controllers[v5]
        self.touchAbilitiesController:Enable(true)
    elseif self.touchAbilitiesController then
        if v36 then
            self.touchAbilitiesController:Destroy()
            self.controllers[v5] = nil
            self.touchAbilitiesController = nil
        else
            self.touchAbilitiesController:Enable(false)
        end
    end

    local enabled2 = self.enabled

    if enabled2 then
        enabled2 = UserAbilitiesUserInterfaceA

        if UserAbilitiesUserInterfaceA then
            enabled2 = UserAbilitiesUserInterfaceC and v8:isEnabled()
        end
    end

    if enabled2 then
        if not self.abilitiesGui then
            self:CreateAbilitiesGuiContainer()
        end

        if self.abilitiesGui then
            if not self.controllers[v6] then
                self.controllers[v6] = v6.new(self.abilitiesFrame)
            end

            self.abilitiesOverflowController = self.controllers[v6]
            self.abilitiesOverflowController:Enable(true)

            if v7 then
                if not self.controllers[v7] then
                    self.controllers[v7] = v7.new(self.abilitiesGui)
                end

                self.abilitiesKeybindBarController = self.controllers[v7]
                self.abilitiesKeybindBarController:Enable(true)
            end

            self.abilitiesGui.Enabled = true
        end
    else
        if self.abilitiesOverflowController then
            self.abilitiesOverflowController:Enable(false)
        end

        if self.abilitiesKeybindBarController then
            self.abilitiesKeybindBarController:Enable(false)
        end

        if self.abilitiesGui then
            self.abilitiesGui.Enabled = false
        end
    end
end

function t1:UpdateActiveControlModuleEnabled() -- line: 533
    -- upvalues: Players (copy), UserInputService (copy), GuiService (copy), DynamicThumbstick (ref), ClassicThumbstick (copy), ClickToMoveController (copy), TouchJump (copy), v8 (ref), v1 (copy)
    local function v37() -- line: 535
        -- upvalues: self (copy), Players (copy), v8 (ref), v1 (copy)
        if v1 then
            self.enabled = false
        end

        self.activeController:Enable(false)

        if v1 then
            self:UpdateAbilitiesControllers()
        elseif self.touchJumpController then
            self.touchJumpController:Enable(false)
        end

        if not (not self.moveFunction or v1 and v8:isEnabled()) then
            self.moveFunction(Players.LocalPlayer, Vector3.new(0, 0, 0), true)
        end
    end

    local function v38() -- line: 555
        -- upvalues: self (copy), Players (copy), UserInputService (copy), DynamicThumbstick (ref), ClassicThumbstick (copy), ClickToMoveController (copy), TouchJump (copy), v1 (copy)
        if v1 then
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
            v37()
        else
            v38()
        end
    end
end

function t1:Enable(p22) -- line: 628
    -- upvalues: UserControlModuleDisabledUpdate (copy)
    if UserControlModuleDisabledUpdate then
        warn("ControlModule:Enable() and ControlModule:Disable() are deprecated and will be removed soon; set require(\"@rbx/PlayerModule\").ControlModule.Enabled instead")
    else
        local v39 = p22 == nil or p22

        if self.controlsEnabled ~= v39 then
            self.controlsEnabled = v39

            if self.activeController then
                self:UpdateActiveControlModuleEnabled()
            end
        end
    end
end

function t1.Disable(p23) -- line: 651
    p23:Enable(false)
end

function t1.SelectComputerMovementModule(p24) -- line: 656
    -- upvalues: Players (copy), UserInputService (copy), UserGameSettings (copy), UserPlayerScriptsSupportMicroGamepad (copy), ActionController (copy), ClickToMoveController (copy), t3 (copy)
    local v40 = false

    if UserPlayerScriptsSupportMicroGamepad then
        local function v41() -- line: 659
            -- upvalues: v40 (ref), UserInputService (copy)
            v40 = UserInputService.PreferredInput == Enum.PreferredInput.MicroGamepad
        end

        pcall(v41)
    end

    if UserInputService.PreferredInput ~= Enum.PreferredInput.KeyboardAndMouse and UserInputService.PreferredInput ~= Enum.PreferredInput.Gamepad and not v40 then
        return nil, false
    end

    local v42 = ActionController
    local DevComputerMovementMode = Players.LocalPlayer.DevComputerMovementMode

    if DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice then
        if UserGameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove then
            v42 = ClickToMoveController
        end
    else
        v42 = t3[DevComputerMovementMode]

        if not v42 and DevComputerMovementMode ~= Enum.DevComputerMovementMode.Scriptable then
            warn("No character control module is associated with DevComputerMovementMode ", DevComputerMovementMode)
        end
    end

    if v42 then
        return v42, true
    end

    if DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable then
        return nil, true
    end

    return nil, false
end

function t1.SelectTouchModule(p25) -- line: 705
    -- upvalues: Players (copy), UserGameSettings (copy), t3 (copy)
    local DevTouchMovementMode = Players.LocalPlayer.DevTouchMovementMode
    local v43

    if DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice then
        v43 = t3[UserGameSettings.TouchMovementMode]
    else
        if DevTouchMovementMode == Enum.DevTouchMovementMode.Scriptable then
            return nil, true
        end

        v43 = t3[DevTouchMovementMode]
    end

    return v43, true
end

function t1:calculateRawMoveVector(p27, p28) -- line: 718
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

        local v44 = Vector3.new(p28.X, 0, p28.Z)

        if v44.Magnitude < 0.01 then
            return (Vector3.new(0, 0, 0))
        end

        local v45 = if CameraRotationAction and CameraRotationAction.Enabled then -CameraRotationAction:GetState().Y / 2.31 else 0
        local v48 = math.atan2(-v44.X, -v44.Z)
        local v49, v50 = _CFrame:ToEulerAnglesYXZ()
        local v51 = v48 + v50

        return CFrame.fromEulerAnglesYXZ(v45, v51, 0).LookVector
    end

    local v52, v53, v54, Components, Components2, Components3, v55, v56, Components4, v57, v58, Components5 = _CFrame:GetComponents()

    if not (Components4 < 1 and Components4 > -1) then
        Components3 = -Components2 * math.sign(Components4)
    else
        Components = Components5
    end

    local v60 = math.sqrt(Components * Components + Components3 * Components3)

    return (Vector3.new((Components * p28.X + Components3 * p28.Z) / v60, 0, (Components * p28.Z - Components3 * p28.X) / v60))
end

function t1:initialize(p30) -- line: 779
    -- upvalues: UserPlayerModuleEngineAPI (copy), ActionController (copy), v1 (copy), v4 (copy)
    self.data = p30
    self:UpdateMovementMode()

    if not UserPlayerModuleEngineAPI then
        ActionController.initializeActions(self.data)
    end

    if v1 then
        v4.setupSlotActions(self.data.engineInterface.player, self.data.isServerAuthority, self.data.eventBus)
    end
end

function t1:Update(p32, p33) -- line: 792
    -- upvalues: VRService (copy), UserPlayerModuleEngineAPI (copy), UserControlModuleDisabledUpdate (copy), ActionController (copy)
    assert(p32.engineInterface.player)

    local controlModule = p32.controlModule
    local ControlModule = p32.playerModule.ControlModule
    local engineInterface = p32.engineInterface

    if UserPlayerModuleEngineAPI then
        local humanoid = engineInterface.humanoid

        if engineInterface.characterChanged then
            self:OnCharacterChanged(humanoid)
        end

        if not UserControlModuleDisabledUpdate and not humanoid then
            return
        end
    else
        assert(engineInterface.character)

        if not UserControlModuleDisabledUpdate and not self.humanoid then
            return
        end
    end

    local Enabled = ControlModule.Enabled

    if UserControlModuleDisabledUpdate then
        controlModule.enabled = Enabled

        if Enabled == self.controlsEnabled then
            if not Enabled then
                return
            end
        else
            self.controlsEnabled = Enabled
            self:UpdateActiveControlModuleEnabled()
        end
    end

    if Enabled then
        if not UserControlModuleDisabledUpdate or self.humanoid then
            ActionController.initializeActions(p32)

            if not (not UserControlModuleDisabledUpdate or controlModule.actions.MoveAction and controlModule.actions.JumpAction) then
                return
            end

            if self.activeController and self.activeController.enabled and self.humanoid then
                ActionController.update(p32)
                self:GetClickToMoveController():Update(p32, p33)

                local v64 = Vector3.new(controlModule.moveVector.X, 0, -controlModule.moveVector.Y)

                if self.vehicleController then
                    local v65

                    v64, v65 = self.vehicleController:Update(v64, true)
                    _ = v65
                end

                local v66 = self:calculateRawMoveVector(self.humanoid, v64)

                self.inputMoveVector = v66
                controlModule.worldMoveVector = if VRService.VREnabled then self:updateVRMoveVector(v66) else v66
                self:characterMove(p32)
            end
        end
    else
        controlModule.isJumping = false
        controlModule.moveVector = Vector2.new()
        controlModule.worldMoveVector = Vector3.new()
        ActionController.update(p32)
        self.inputMoveVector = Vector3.new()

        if self.vehicleController then
            self.vehicleController:Update(Vector3.new(), true)
        end

        self:characterMove(p32)
    end
end

function t1:characterMove(p35) -- line: 883
    -- upvalues: Players (copy), UserPlayerScriptsFixSAuthRenderStepMove (copy), UserControlModuleDisabledUpdate (copy), v8 (ref), v1 (copy), v2 (copy), v3 (copy)
    if not UserControlModuleDisabledUpdate or self.humanoid then
        local controlModule = p35.controlModule

        if v2 then
            if not p35.isServerAuthority then
                if not (v1 and v8:isEnabled()) then
                    self.moveFunction(Players.LocalPlayer, controlModule.worldMoveVector, false)
                    self.humanoid.Jump = controlModule.isJumping
                elseif not UserControlModuleDisabledUpdate then
                    v3.writeInputToCS(Players.LocalPlayer, self)
                end
            end
        elseif not (UserPlayerScriptsFixSAuthRenderStepMove and p35.isServerAuthority or v1 and v8:isEnabled()) then
            self.moveFunction(Players.LocalPlayer, controlModule.worldMoveVector, false)
            self.humanoid.Jump = controlModule.isJumping
        end
    end
end

function t1:updateVRMoveVector(p37) -- line: 913
    -- upvalues: VRService (copy), UserVRFixCameraCloseArticulation (copy), VRFirstPersonState (copy)
    local CurrentCamera = workspace.CurrentCamera
    local v67 = CurrentCamera.Focus.Position - CurrentCamera.CFrame.Position
    local v68 = if UserVRFixCameraCloseArticulation then VRFirstPersonState.inFirstPerson else v67.Magnitude < 5

    if p37.Magnitude ~= 0 or not v68 or not VRService.AvatarGestures or not self.humanoid or self.humanoid.Sit then
        return p37
    end

    local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
    local v69 = UserCFrame.Rotation + UserCFrame.Position * CurrentCamera.HeadScale
    local v70 = -0.7 * self.humanoid.RootPart.Size.Y / 2
    local v71 = (CurrentCamera.CFrame * v69 * CFrame.new(0, v70, 0)).Position - self.humanoid.RootPart.CFrame.Position
    local v72 = Vector3.new(v71.x, 0, v71.z)
    local v73 = if UserVRFixCameraCloseArticulation then (CurrentCamera.Focus.Position - CurrentCamera.CFrame.Position).Magnitude > math.max(4 * CurrentCamera.HeadScale, 1) else nil

    if not UserVRFixCameraCloseArticulation or not v73 then
        return v72
    end

    return p37
end

function t1:OnHumanoidSeated(p39, p40) -- line: 963
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

if UserPlayerModuleEngineAPI then
    function t1:OnCharacterChanged(p42) -- line: 979
        self.humanoid = p42
        self:UpdateMovementMode()

        if not p42 then
            return
        end

        if self.humanoidSeatedConn then
            self.humanoidSeatedConn:Disconnect()
            self.humanoidSeatedConn = nil
        end

        self.humanoidSeatedConn = p42.Seated:Connect(function(p43, p44) -- line: 990
            -- upvalues: self (copy)
            self:OnHumanoidSeated(p43, p44)
        end)
    end
else
    function t1:OnCharacterAdded(p46) -- line: 995
        self.humanoid = p46:FindFirstChildOfClass("Humanoid")

        while not self.humanoid do
            p46.ChildAdded:wait()
            self.humanoid = p46:FindFirstChildOfClass("Humanoid")
        end

        if self.humanoidSeatedConn then
            self.humanoidSeatedConn:Disconnect()
            self.humanoidSeatedConn = nil
        end

        self.humanoidSeatedConn = self.humanoid.Seated:Connect(function(p47, p48) -- line: 1006
            -- upvalues: self (copy)
            self:OnHumanoidSeated(p47, p48)
        end)
        self:UpdateMovementMode()
    end

    function t1:OnCharacterRemoving(p50) -- line: 1013
        self.humanoid = nil
        self:UpdateMovementMode()
    end
end

function t1:UpdateTouchGuiVisibility() -- line: 1020
    -- upvalues: UserInputService (copy), GuiService (copy)
    local humanoid = self.humanoid and GuiService.TouchControlsEnabled and UserInputService.PreferredInput == Enum.PreferredInput.Touch

    if humanoid and not self.touchGui then
        self:CreateTouchGuiContainer()
    end

    if self.touchGui then
        self.touchGui.Enabled = not not humanoid
    end
end

function t1:SwitchToController(p53) -- line: 1041
    if p53 then
        if not self.controllers[p53] then
            self.controllers[p53] = p53.new(self.data)
        end

        if self.activeController ~= self.controllers[p53] then
            if self.activeController then
                self.activeController:Enable(false)
            end

            self.activeController = self.controllers[p53]
            self.activeControlModule = p53
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

function t1:UpdateMovementMode() -- line: 1081
    -- upvalues: UserInputService (copy)
    self:UpdateTouchGuiVisibility()

    if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
        local v75, v76 = self:SelectTouchModule()

        if v76 and self.touchControlFrame then
            self:SwitchToController(v75)
        end
    else
        self:SwitchToController((self:SelectComputerMovementModule()))
    end
end

function t1:CreateTouchGuiContainer() -- line: 1097
    -- upvalues: UserAbilitiesUserInterfaceC (copy), v1 (copy)
    if self.playerGui then
        if self.touchGui then
            self.touchGui:Destroy()
        end

        self.touchGui = Instance.new("ScreenGui")
        self.touchGui.Name = "TouchGui"
        self.touchGui.ResetOnSpawn = false
        self.touchGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        if v1 and UserAbilitiesUserInterfaceC then
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

function t1:CreateAbilitiesGuiContainer() -- line: 1128
    if self.playerGui then
        if self.abilitiesGui then
            self.abilitiesGui:Destroy()
        end

        self.abilitiesGui = Instance.new("ScreenGui")
        self.abilitiesGui.Name = "AbilitiesGui"
        self.abilitiesGui.ResetOnSpawn = false
        self.abilitiesGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        self.abilitiesGui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
        self.abilitiesGui.ClipToDeviceSafeArea = false
        self.abilitiesFrame = Instance.new("Frame")
        self.abilitiesFrame.Name = "AbilitiesFrame"
        self.abilitiesFrame.Size = UDim2.new(1, 0, 1, 0)
        self.abilitiesFrame.BackgroundTransparency = 1
        self.abilitiesFrame.Parent = self.abilitiesGui
        self.abilitiesGui.Parent = self.playerGui
    end
end

function t1:GetClickToMoveController() -- line: 1153
    -- upvalues: ClickToMoveController (copy)
    if not self.controllers[ClickToMoveController] then
        self.controllers[ClickToMoveController] = ClickToMoveController.new()
    end

    return self.controllers[ClickToMoveController]
end

function t1.ProcessInputs(p58, p59, p60) -- line: 1160
    -- upvalues: AvatarAbilitiesInterface (ref), v1 (copy), v2 (copy), v3 (copy)
    local v77

    if v1 then
        v77 = AvatarAbilitiesInterface.get(p59):isEnabled()
    else
        if v2 then
            v3.processPCSInputs(p59)

            return
        end

        local Character = p59.Character

        if Character == nil then
            return
        end

        local Humanoid = Character:FindFirstChild("Humanoid")

        if Humanoid == nil then
            return
        end

        local InputContexts = p59:FindFirstChild("InputContexts")

        if InputContexts == nil then
            return
        end

        local CharacterContext = InputContexts:FindFirstChild("CharacterContext")

        if CharacterContext == nil then
            return
        end

        local MoveAction, RotationAction, JumpAction = CharacterContext.MoveAction, CharacterContext.RotationAction, CharacterContext.JumpAction

        local function isValidInput2D(p61) -- line: 1196
            return not (p61.X ~= p61.X or p61.Y ~= p61.Y or p61.X == 1e999 or p61.Y == 1e999)
        end

        local function isValidInput3D(p62) -- line: 1205
            return not (p62.X ~= p62.X
                or p62.Y ~= p62.Y
                or p62.Z ~= p62.Z
                or p62.X == 1e999
                or p62.Y == 1e999
                or p62.Z == 1e999)
        end

        local v78 = if MoveAction == nil then Vector2.new(0, 0) else MoveAction:GetState()
        local LookVector = p59:GetCameraState().CFrame.LookVector

        if v78.X == v78.X and v78.Y == v78.Y and v78.X ~= 1e999 and v78.Y ~= 1e999 and LookVector.X == LookVector.X and LookVector.Y == LookVector.Y and LookVector.Z == LookVector.Z and LookVector.X ~= 1e999 and LookVector.Y ~= 1e999 and LookVector.Z ~= 1e999 and LookVector.Magnitude > 0 then
            if Humanoid:GetState() ~= Enum.HumanoidStateType.Swimming then
                LookVector = Vector3.new(LookVector.X, 0, LookVector.Z).Unit
            end

            local Unit = LookVector:Cross((Vector3.new(0, 1, 0))).Unit

            Humanoid:Move(LookVector * v78.Y + Unit * v78.X)

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

    if not (v1 and v77 or not v1) then
        if v2 then
            v3.processPCSInputs(p59)
        else
            v3.SendInputToHumanoidForServerAuth(p59)
        end
    end
end

if RunService:IsClient() then
    return t1.new()
end

return t1
