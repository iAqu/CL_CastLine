-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local FlagUtil = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil")
local MouseLockSwitchAction = script.Parent.Parent:WaitForChild("InputContexts"):WaitForChild("CameraContext"):WaitForChild("MouseLockSwitchAction")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local GameSettings = UserSettings().GameSettings
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"))
local UserFixStuckShiftLock = FlagUtil.getUserFlag("UserFixStuckShiftLock")
local t1 = {}

t1.__index = t1

function t1.new() -- line: 33
    -- upvalues: MouseLockSwitchAction (copy), Players (copy), UserInputService (copy), GameSettings (copy), t1 (copy)
    local self = setmetatable({}, t1)

    self.isMouseLocked = false
    self.savedMouseCursor = nil
    self.enabled = false
    self.mouseLockToggledEvent = Instance.new("BindableEvent")
    GameSettings.Changed:Connect(function(p1) -- line: 43
        -- upvalues: self (copy)
        if p1 == "ControlMode" or p1 == "ComputerMovementMode" then
            self:UpdateMouseLockAvailability()
        end
    end)
    Players.LocalPlayer:GetPropertyChangedSignal("DevEnableMouseLock"):Connect(function() -- line: 50
        -- upvalues: self (copy)
        self:UpdateMouseLockAvailability()
    end)
    Players.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function() -- line: 55
        -- upvalues: self (copy)
        self:UpdateMouseLockAvailability()
    end)
    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 59
        -- upvalues: self (copy)
        self:UpdateMouseLockAvailability()
    end)
    self:UpdateMouseLockAvailability()
    MouseLockSwitchAction.Pressed:Connect(function() -- line: 65
        -- upvalues: self (copy)
        self:OnMouseLockToggled()
    end)

    return self
end

function t1:GetIsMouseLocked() -- line: 72
    return self.isMouseLocked
end

function t1:GetBindableToggleEvent() -- line: 76
    return self.mouseLockToggledEvent.Event
end

function t1.GetMouseLockOffset(_) -- line: 80
    return (Vector3.new(1.75, 0, 0))
end

function t1:UpdateMouseLockAvailability() -- line: 84
    -- upvalues: Players (copy), UserInputService (copy), GameSettings (copy)
    local DevEnableMouseLock = Players.LocalPlayer.DevEnableMouseLock
    local v2 = Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable
    local v3 = GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch
    local v4 = GameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove

    v3 = UserInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse and DevEnableMouseLock and v3 and not v4 and not v2

    if v3 ~= self.enabled then
        self:EnableMouseLock(v3)
    end
end

function t1:OnMouseLockToggled() -- line: 98
    -- upvalues: CameraUtils (copy)
    self.isMouseLocked = not self.isMouseLocked

    if self.isMouseLocked then
        local CursorImage = script:FindFirstChild("CursorImage")

        if CursorImage and CursorImage:IsA("StringValue") and CursorImage.Value then
            CameraUtils.setMouseIconOverride(CursorImage.Value)
        else
            if CursorImage then
                CursorImage:Destroy()
            end

            local StringValue = Instance.new("StringValue")

            assert(StringValue, "")
            StringValue.Name = "CursorImage"
            StringValue.Value = "rbxasset://textures/MouseLockedCursor.png"
            StringValue.Parent = script
            CameraUtils.setMouseIconOverride("rbxasset://textures/MouseLockedCursor.png")
        end
    else
        CameraUtils.restoreMouseIcon()
    end

    self.mouseLockToggledEvent:Fire()
end

function t1:IsMouseLocked() -- line: 123
    return self.enabled and self.isMouseLocked
end

function t1:EnableMouseLock(p9) -- line: 127
    -- upvalues: MouseLockSwitchAction (copy), CameraUtils (copy), UserFixStuckShiftLock (copy)
    if p9 == self.enabled then
        return
    end

    self.enabled = p9

    if self.enabled then
        MouseLockSwitchAction.Enabled = true
    else
        CameraUtils.restoreMouseIcon()
        MouseLockSwitchAction.Enabled = false

        if UserFixStuckShiftLock then
            if self.isMouseLocked then
                self.isMouseLocked = false
                self.mouseLockToggledEvent:Fire()
            end
        else
            if self.isMouseLocked then
                self.mouseLockToggledEvent:Fire()
            end

            self.isMouseLocked = false
        end
    end
end

return t1
