-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Trove = require(script.Parent.Parent.Trove)
local Signal = require(script.Parent.Parent.Signal)
local UserInputService = game:GetService("UserInputService")
local HapticService = game:GetService("HapticService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

local function ApplyDeadzone(p1, p2) -- line: 13
    if math.abs(p1) < p2 then
        return 0
    end

    return (math.abs(p1) - p2) / (1 - p2) * math.sign(p1)
end

local function GetActiveGamepad() -- line: 20
    -- upvalues: UserInputService (copy)
    local NavigationGamepads = UserInputService:GetNavigationGamepads()
    local v1

    if #NavigationGamepads > 1 then
        local v2

        for _, v3 in ipairs(NavigationGamepads) do
            if v2 == nil or v3.Value < v2.Value then
                v2 = v3
            end

            v1 = v2
        end
    else
        local ConnectedGamepads = UserInputService:GetConnectedGamepads()
        local v4

        for _, v5 in ipairs(ConnectedGamepads) do
            if v4 == nil or v5.Value < v4.Value then
                v4 = v5
            end

            v1 = v4
        end
    end

    if v1 and not UserInputService:GetGamepadConnected(v1) then
        v1 = nil
    end

    return v1
end

local function HeartbeatDelay(p3, p4) -- line: 43
    -- upvalues: RunService (copy)
    local v6 = time()
    local connection

    connection = RunService.Heartbeat:Connect(function() -- line: 46
        -- upvalues: p3 (copy), p4 (copy), v6 (copy), connection (ref)
        if not (time() - v6 >= p3) then
            return
        end

        connection:Disconnect()
        p4()
    end)

    return connection
end

local t1 = {}

t1.__index = t1

function t1.new(p5) -- line: 232
    -- upvalues: Trove (copy), Signal (copy), t1 (copy)
    local self = setmetatable({}, t1)

    self._trove = Trove.new()
    self._gamepadTrove = self._trove:Construct(Trove)
    self.ButtonDown = self._trove:Construct(Signal)
    self.ButtonUp = self._trove:Construct(Signal)
    self.Connected = self._trove:Construct(Signal)
    self.Disconnected = self._trove:Construct(Signal)
    self.GamepadChanged = self._trove:Construct(Signal)
    self.DefaultDeadzone = 0.05
    self.SupportsVibration = false
    self.State = {}
    self:_setupGamepad(p5)
    self:_setupMotors()

    return self
end

function t1:_setupActiveGamepad(p7) -- line: 249
    -- upvalues: UserInputService (copy), HapticService (copy)
    local _gamepad = self._gamepad

    if p7 == _gamepad then
        return
    end

    self._gamepadTrove:Clean()
    table.clear(self.State)
    self.SupportsVibration = if p7 then HapticService:IsVibrationSupported(p7) else false
    self._gamepad = p7

    if not p7 then
        self.Disconnected:Fire()
        self.GamepadChanged:Fire(nil)

        return
    end

    for _, v9 in ipairs(UserInputService:GetGamepadState(p7)) do
        self.State[v9.KeyCode] = v9
    end

    self._gamepadTrove:Add(self, "StopMotors")
    self._gamepadTrove:Connect(UserInputService.InputBegan, function(p8, p9) -- line: 274
        -- upvalues: self (copy), p7 (copy)
        if p8.UserInputType == p7 then
            self.ButtonDown:Fire(p8.KeyCode, p9)
        end
    end)
    self._gamepadTrove:Connect(UserInputService.InputEnded, function(p10, p11) -- line: 280
        -- upvalues: self (copy), p7 (copy)
        if p10.UserInputType == p7 then
            self.ButtonUp:Fire(p10.KeyCode, p11)
        end
    end)

    if _gamepad == nil then
        self.Connected:Fire()
    end

    self.GamepadChanged:Fire(p7)
end

function t1:_setupGamepad(p13) -- line: 292
    -- upvalues: UserInputService (copy), GetActiveGamepad (copy)
    local GamepadConnected

    if p13 then
        self._trove:Connect(UserInputService.GamepadConnected, function(p14) -- line: 296
            -- upvalues: self (copy), p13 (copy)
            if p14 == p13 then
                self:_setupActiveGamepad(p13)
            end
        end)
        self._trove:Connect(UserInputService.GamepadDisconnected, function(p15) -- line: 302
            -- upvalues: self (copy), p13 (copy)
            if p15 == p13 then
                self:_setupActiveGamepad(nil)
            end
        end)
        GamepadConnected = UserInputService:GetGamepadConnected(p13)
    else
        local function CheckToSetupActive() -- line: 314
            -- upvalues: self (copy), GetActiveGamepad (copy)
            local v10 = GetActiveGamepad()

            if v10 ~= self._gamepad then
                self:_setupActiveGamepad(v10)
            end
        end

        self._trove:Connect(UserInputService.GamepadConnected, CheckToSetupActive)
        self._trove:Connect(UserInputService.GamepadDisconnected, CheckToSetupActive)
        self:_setupActiveGamepad((GetActiveGamepad()))
    end

    if (not p13 or GamepadConnected) and p13 then
        self:_setupActiveGamepad(p13)
    end
end

function t1:_setupMotors() -- line: 327
    self._setMotorIds = {}

    for _, v11 in ipairs(Enum.VibrationMotor:GetEnumItems()) do
        self._setMotorIds[v11] = 0
    end
end

function t1:GetThumbstick(p18, p19) -- line: 349
    local Position = self.State[p18].Position

    p19 = p19 or self.DefaultDeadzone

    local new = Vector2.new
    local X = Position.X
    local v13 = if math.abs(X) < p19 then 0 else (math.abs(X) - p19) / (1 - p19) * math.sign(X)
    local Y = Position.Y

    return new(v13, if math.abs(Y) < p19 then 0 else (math.abs(Y) - p19) / (1 - p19) * math.sign(Y))
end

function t1:GetTrigger(p21, p22) -- line: 371
    local Z = self.State[p21].Position.Z

    p22 = p22 or self.DefaultDeadzone

    if math.abs(Z) < p22 then
        return 0
    end

    return (math.abs(Z) - p22) / (1 - p22) * math.sign(Z)
end

function t1:IsButtonDown(p24) -- line: 389
    -- upvalues: UserInputService (copy)
    return UserInputService:IsGamepadButtonDown(self._gamepad, p24)
end

function t1:IsMotorSupported(p26) -- line: 408
    -- upvalues: HapticService (copy)
    return HapticService:IsMotorSupported(self._gamepad, p26)
end

function t1:SetMotor(p28, p29) -- line: 422
    -- upvalues: HapticService (copy)
    self._setMotorIds[p28] += 1

    local v15 = self._setMotorIds[p28]

    HapticService:SetMotor(self._gamepad, p28, p29)

    return v15
end

function t1:PulseMotor(p31, p32, p33) -- line: 454
    -- upvalues: RunService (copy)
    local v16 = self:SetMotor(p31, p32)

    local function v17() -- line: 456
        -- upvalues: self (copy), p31 (copy), v16 (copy)
        if self._setMotorIds[p31] == v16 then
            self:StopMotor(p31)
        end
    end

    local v18 = time()
    local connection

    connection = RunService.Heartbeat:Connect(function() -- line: 46
        -- upvalues: p33 (copy), v17 (copy), v18 (copy), connection (ref)
        if not (time() - v18 >= p33) then
            return
        end

        connection:Disconnect()
        v17()
    end)
    self._gamepadTrove:Add(connection)
end

function t1.StopMotor(p34, p35) -- line: 476
    p34:SetMotor(p35, 0)
end

function t1:StopMotors() -- line: 490
    for _, v19 in ipairs(Enum.VibrationMotor:GetEnumItems()) do
        if self:IsMotorSupported(v19) then
            self:StopMotor(v19)
        end
    end
end

function t1:IsConnected() -- line: 502
    -- upvalues: UserInputService (copy)
    if self._gamepad then
        return (UserInputService:GetGamepadConnected(self._gamepad))
    end

    return false
end

function t1:GetUserInputType() -- line: 511
    return self._gamepad
end

function t1.SetAutoSelectGui(_, p40) -- line: 533
    -- upvalues: GuiService (copy)
    GuiService.AutoSelectGuiEnabled = p40
end

function t1.IsAutoSelectGuiEnabled(_) -- line: 542
    -- upvalues: GuiService (copy)
    return GuiService.AutoSelectGuiEnabled
end

function t1:Destroy() -- line: 549
    self._trove:Destroy()
end

return t1
