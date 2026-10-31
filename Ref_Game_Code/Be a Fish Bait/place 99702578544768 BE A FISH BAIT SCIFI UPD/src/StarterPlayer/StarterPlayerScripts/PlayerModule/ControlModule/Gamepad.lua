-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local UserPlayerScriptsSupportTVRemoteKeycodes = require(CommonUtils:WaitForChild("FlagUtil")).getUserFlag("UserPlayerScriptsSupportTVRemoteKeycodes")
local None = Enum.UserInputType.None
local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"))
local self = setmetatable({}, BaseCharacterController)

self.__index = self

function self.new(p1) -- line: 26
    -- upvalues: None (copy), BaseCharacterController (copy), self (copy)
    local v3 = setmetatable(BaseCharacterController.new(), self)

    v3.CONTROL_ACTION_PRIORITY = p1
    v3.forwardValue = 0
    v3.backwardValue = 0
    v3.leftValue = 0
    v3.rightValue = 0
    v3.thumbstickVector = Vector3.new(0, 0, 0)
    v3.activeGamepad = None
    v3.gamepadConnectedConn = nil
    v3.gamepadDisconnectedConn = nil

    return v3
end

function self.Enable(p2, p3) -- line: 43
    -- upvalues: None (copy)
    if p3 == p2.enabled then
        return true
    end

    p2.forwardValue = 0
    p2.backwardValue = 0
    p2.leftValue = 0
    p2.rightValue = 0
    p2.thumbstickVector = Vector3.new(0, 0, 0)
    p2.moveVector = Vector3.new(0, 0, 0)
    p2.isJumping = false

    if p3 then
        p2.activeGamepad = p2:GetHighestPriorityGamepad()

        if p2.activeGamepad == None then
            return false
        end

        p2:BindContextActions()
        p2:ConnectGamepadConnectionListeners()
    else
        p2:UnbindContextActions()
        p2:DisconnectGamepadConnectionListeners()
        p2.activeGamepad = None
    end

    p2.enabled = p3

    return true
end

function self.GetHighestPriorityGamepad(_) -- line: 80
    -- upvalues: UserInputService (copy), None (copy)
    local ConnectedGamepads = UserInputService:GetConnectedGamepads()
    local v4 = None

    for _, v5 in pairs(ConnectedGamepads) do
        if v5.Value < v4.Value then
            v4 = v5
        end
    end

    return v4
end

function self.UpdateMovement(p5) -- line: 91
    p5.moveVector = p5.thumbstickVector + Vector3.new(0, 0, p5.forwardValue + p5.backwardValue)
end

function self.BindContextActions(p6) -- line: 95
    -- upvalues: ContextActionService (copy), UserPlayerScriptsSupportTVRemoteKeycodes (copy), None (copy)
    if p6.activeGamepad == None then
        return false
    end

    local function v7(_, p8, _) -- line: 102
        -- upvalues: p6 (copy)
        p6.isJumping = p8 == Enum.UserInputState.Begin

        return Enum.ContextActionResult.Sink
    end

    local function v8(_, p11, p12) -- line: 107
        -- upvalues: p6 (copy), UserPlayerScriptsSupportTVRemoteKeycodes (copy)
        if p11 == Enum.UserInputState.Cancel then
            if UserPlayerScriptsSupportTVRemoteKeycodes then
                p6.thumbstickVector = Vector3.new(0, 0, 0)
                p6:UpdateMovement()
            else
                p6.moveVector = Vector3.new(0, 0, 0)
            end

            return Enum.ContextActionResult.Sink
        end

        if p6.activeGamepad ~= p12.UserInputType then
            return Enum.ContextActionResult.Pass
        end

        if p12.KeyCode == Enum.KeyCode.Thumbstick1 then
            if UserPlayerScriptsSupportTVRemoteKeycodes then
                if p12.Position.magnitude > 0.2 then
                    p6.thumbstickVector = Vector3.new(p12.Position.X, 0, -p12.Position.Y)
                else
                    p6.thumbstickVector = Vector3.new(0, 0, 0)
                end

                p6:UpdateMovement()
            elseif p12.Position.magnitude > 0.2 then
                p6.moveVector = Vector3.new(p12.Position.X, 0, -p12.Position.Y)
            else
                p6.moveVector = Vector3.new(0, 0, 0)
            end

            return Enum.ContextActionResult.Sink
        end
    end

    local function v11(_, p14, p15) -- line: 141
        -- upvalues: p6 (copy)
        if p14 == Enum.UserInputState.Cancel then
            p6.forwardValue = 0
            p6.backwardValue = 0
        else
            local v12 = if p15.Position.magnitude > 0.2 then p15.Position.Z else 0

            if p15.KeyCode == Enum.KeyCode.ButtonUp then
                p6.forwardValue = -v12
            elseif p15.KeyCode == Enum.KeyCode.ButtonDown then
                p6.backwardValue = v12
            end
        end

        p6:UpdateMovement()

        return Enum.ContextActionResult.Sink
    end

    ContextActionService:BindActivate(p6.activeGamepad, Enum.KeyCode.ButtonR2)

    if UserPlayerScriptsSupportTVRemoteKeycodes then
        ContextActionService:BindActionAtPriority("jumpAction", v7, false, p6.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonA, Enum.KeyCode.ButtonCenter)
        ContextActionService:BindActionAtPriority("moveDirectionalButton", v11, false, p6.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonUp, Enum.KeyCode.ButtonDown)
    else
        ContextActionService:BindActionAtPriority("jumpAction", v7, false, p6.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonA)
    end

    ContextActionService:BindActionAtPriority("moveThumbstick", v8, false, p6.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Thumbstick1)

    return true
end

function self.UnbindContextActions(p16) -- line: 180
    -- upvalues: ContextActionService (copy), UserPlayerScriptsSupportTVRemoteKeycodes (copy), None (copy)
    if p16.activeGamepad ~= None then
        ContextActionService:UnbindActivate(p16.activeGamepad, Enum.KeyCode.ButtonR2)
    end

    if UserPlayerScriptsSupportTVRemoteKeycodes then
        ContextActionService:UnbindAction("moveDirectionalButton")
    end

    ContextActionService:UnbindAction("moveThumbstick")
    ContextActionService:UnbindAction("jumpAction")
end

function self.OnNewGamepadConnected(p17) -- line: 191
    -- upvalues: None (copy)
    local HighestPriorityGamepad = p17:GetHighestPriorityGamepad()

    if HighestPriorityGamepad ~= p17.activeGamepad then
        if HighestPriorityGamepad == None then
            warn("Gamepad:OnNewGamepadConnected found no connected gamepads")
            p17:UnbindContextActions()
        else
            if p17.activeGamepad ~= None then
                p17:UnbindContextActions()
            end

            p17.activeGamepad = HighestPriorityGamepad
            p17:BindContextActions()
        end
    end
end

function self.OnCurrentGamepadDisconnected(p18) -- line: 218
    -- upvalues: ContextActionService (copy), None (copy)
    if p18.activeGamepad ~= None then
        ContextActionService:UnbindActivate(p18.activeGamepad, Enum.KeyCode.ButtonR2)
    end

    local HighestPriorityGamepad = p18:GetHighestPriorityGamepad()

    if p18.activeGamepad ~= None and HighestPriorityGamepad == p18.activeGamepad then
        warn("Gamepad:OnCurrentGamepadDisconnected found the supposedly disconnected gamepad in connectedGamepads.")
        p18:UnbindContextActions()
        p18.activeGamepad = None
    elseif HighestPriorityGamepad == None then
        p18:UnbindContextActions()
        p18.activeGamepad = None
    else
        p18.activeGamepad = HighestPriorityGamepad
        ContextActionService:BindActivate(p18.activeGamepad, Enum.KeyCode.ButtonR2)
    end
end

function self.ConnectGamepadConnectionListeners(p19) -- line: 243
    -- upvalues: UserInputService (copy)
    p19.gamepadConnectedConn = UserInputService.GamepadConnected:Connect(function(_) -- line: 244
        -- upvalues: p19 (copy)
        p19:OnNewGamepadConnected()
    end)
    p19.gamepadDisconnectedConn = UserInputService.GamepadDisconnected:Connect(function(p21) -- line: 248
        -- upvalues: p19 (copy)
        if p19.activeGamepad == p21 then
            p19:OnCurrentGamepadDisconnected()
        end
    end)
end

function self.DisconnectGamepadConnectionListeners(p22) -- line: 255
    if p22.gamepadConnectedConn then
        p22.gamepadConnectedConn:Disconnect()
        p22.gamepadConnectedConn = nil
    end

    if p22.gamepadDisconnectedConn then
        p22.gamepadDisconnectedConn:Disconnect()
        p22.gamepadDisconnectedConn = nil
    end
end

return self
