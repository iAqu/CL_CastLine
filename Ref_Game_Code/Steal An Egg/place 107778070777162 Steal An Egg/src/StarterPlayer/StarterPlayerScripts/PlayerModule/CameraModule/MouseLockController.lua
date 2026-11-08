-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local CameraUtils = require(script.Parent.CameraUtils)
local FlagUtil = require(script.Parent.Parent.CommonUtils.FlagUtil)

require(ReplicatedStorage.Shared.Globals.Constants)

local Log = require(ReplicatedStorage.Packages.Log)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Signal = require(ReplicatedStorage.Packages.Signal)
local t1 = {}

t1.__index = t1
t1.__class = "MouseLockController"

local Value = Enum.ContextActionPriority.Medium.Value
local UserPreferredInputPlayerScripts2 = FlagUtil.getUserFlag("UserPreferredInputPlayerScripts2")
local GameSettings = UserSettings().GameSettings
local LocalPlayer = Players.LocalPlayer
local v1 = Log.new()
local v2 = false

function t1.new() -- line: 48
    -- upvalues: Signal (copy), t1 (copy)
    local self = setmetatable({}, t1)

    self.boundKeys = {
        Enum.KeyCode.LeftShift,
        Enum.KeyCode.RightShift
    }
    self.enabled = false
    self.isMouseLocked = false
    self.mouseLockToggledEvent = Signal.new()
    self:_init()

    return self
end

function t1:_updateMouseLockAvailability() -- line: 64
    -- upvalues: UserInputService (copy), UserPreferredInputPlayerScripts2 (copy), GameSettings (copy), LocalPlayer (copy), v1 (copy), v2 (ref)
    local DevEnableMouseLock = LocalPlayer.DevEnableMouseLock
    local v4 = LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable
    local v5 = GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch
    local v6 = GameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove
    local v7 = UserInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse
    local v8 = not v2

    v5 = if not UserPreferredInputPlayerScripts2 or v7 then DevEnableMouseLock and v5 and not v6 and not v4 and v8 else v7

    if v5 ~= self.enabled then
        if not v8 then
            v1:AtDebug():Log("PlayerModule mouse lock suppressed by a gameplay lock")
        end

        self:EnableMouseLock(v5)
    end
end

function t1:_onBoundKeysObjectChanged(p3) -- line: 86
    local t3 = {}

    for match in string.gmatch(p3, "[^%s,]+") do
        for _, v9 in Enum.KeyCode:GetEnumItems() do
            if v9.Name == match then
                table.insert(t3, v9)
                break
            end
        end
    end

    self.boundKeys = t3
    self:_unbindContextActions()

    if self.enabled then
        self:_bindContextActions()
    end
end

function t1:_onMouseLockToggled() -- line: 103
    -- upvalues: CameraUtils (copy)
    self.isMouseLocked = not self.isMouseLocked

    if self.isMouseLocked then
        local v10 = "rbxasset://textures/MouseLockedCursor.png"
        local CursorImage = script:FindFirstChild("CursorImage")

        if CursorImage ~= nil and CursorImage:IsA("StringValue") then
            v10 = CursorImage.Value
        end

        CameraUtils.setMouseIconOverride(v10)
    else
        CameraUtils.restoreMouseIcon()
    end

    self.mouseLockToggledEvent:Fire()
end

function t1._doMouseLockSwitch(p5, _, p7, _) -- line: 120
    if p7 ~= Enum.UserInputState.Begin then
        return Enum.ContextActionResult.Pass
    end

    p5:_onMouseLockToggled()

    return Enum.ContextActionResult.Sink
end

function t1:_bindContextActions() -- line: 133
    -- upvalues: ContextActionService (copy), Value (copy)
    ContextActionService:BindActionAtPriority("MouseLockSwitchAction", function(p10, p11, p12) -- line: 136
        -- upvalues: self (copy)
        return self:_doMouseLockSwitch(p10, p11, p12)
    end, false, Value, table.unpack(self.boundKeys))
end

function t1._unbindContextActions(_) -- line: 145
    -- upvalues: ContextActionService (copy)
    ContextActionService:UnbindAction("MouseLockSwitchAction")
end

function t1:GetIsMouseLocked() -- line: 153
    return self.isMouseLocked
end

function t1:GetBindableToggleEvent() -- line: 157
    return self.mouseLockToggledEvent
end

function t1.GetMouseLockOffset(_) -- line: 161
    return (Vector3.new(1.75, 0, 0))
end

function t1:IsMouseLocked() -- line: 165
    return self.enabled and self.isMouseLocked
end

function t1:EnableMouseLock(p19) -- line: 169
    -- upvalues: CameraUtils (copy)
    if p19 == self.enabled then
        return
    end

    self.enabled = p19

    if p19 then
        self:_bindContextActions()
    else
        CameraUtils.restoreMouseIcon()
        self:_unbindContextActions()

        if self.isMouseLocked then
            self.isMouseLocked = false
            self.mouseLockToggledEvent:Fire()
        end
    end
end

function t1._init(p20) -- line: 192
    -- upvalues: UserInputService (copy), Remotes (copy), UserPreferredInputPlayerScripts2 (copy), GameSettings (copy), LocalPlayer (copy), v2 (ref)
    local BoundKeys = script:FindFirstChild("BoundKeys")

    if BoundKeys ~= nil and BoundKeys:IsA("StringValue") then
        BoundKeys.Changed:Connect(function(p21) -- line: 195
            -- upvalues: p20 (copy)
            p20:_onBoundKeysObjectChanged(p21)
        end)
        p20:_onBoundKeysObjectChanged(BoundKeys.Value)
    end

    GameSettings.Changed:Connect(function(p22) -- line: 201
        -- upvalues: p20 (copy)
        if p22 == "ControlMode" or p22 == "ComputerMovementMode" then
            p20:_updateMouseLockAvailability()
        end
    end)
    LocalPlayer:GetPropertyChangedSignal("DevEnableMouseLock"):Connect(function() -- line: 206
        -- upvalues: p20 (copy)
        p20:_updateMouseLockAvailability()
    end)
    LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function() -- line: 209
        -- upvalues: p20 (copy)
        p20:_updateMouseLockAvailability()
    end)

    if UserPreferredInputPlayerScripts2 then
        UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 213
            -- upvalues: p20 (copy)
            p20:_updateMouseLockAvailability()
        end)
    end

    Remotes.Treadmill.AssignedBeltShifted.OnClientEvent:Connect(function(p23) -- line: 217
        -- upvalues: p20 (copy), v2 (ref)
        v2 = p23 ~= nil
        p20:_updateMouseLockAvailability()
    end)
    p20:_updateMouseLockAvailability()
end

return t1
