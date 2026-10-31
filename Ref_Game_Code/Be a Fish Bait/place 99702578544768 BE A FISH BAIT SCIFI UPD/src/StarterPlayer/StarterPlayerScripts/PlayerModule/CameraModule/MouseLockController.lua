-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"))
local Value = Enum.ContextActionPriority.Medium.Value
local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local GameSettings = UserSettings().GameSettings
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"))
local UserFixStuckShiftLock = FlagUtil.getUserFlag("UserFixStuckShiftLock")
local t1 = {}

t1.__index = t1

function t1.new() -- line: 33
    -- upvalues: Players (copy), UserInputService (copy), GameSettings (copy), t1 (copy)
    local self = setmetatable({}, t1)

    self.isMouseLocked = false
    self.savedMouseCursor = nil
    self.boundKeys = {
        Enum.KeyCode.LeftShift,
        Enum.KeyCode.RightShift
    }
    self.mouseLockToggledEvent = Instance.new("BindableEvent")

    local BoundKeys = script:FindFirstChild("BoundKeys")
    local StringValue, v2

    if BoundKeys then
        if BoundKeys:IsA("StringValue") then
            StringValue = BoundKeys
            v2 = true
        else
            v2 = false
            BoundKeys:Destroy()
        end
    else
        v2 = false
    end

    if not v2 then
        StringValue = Instance.new("StringValue")
        assert(StringValue, "")
        StringValue.Name = "BoundKeys"
        StringValue.Value = "LeftShift,RightShift"
        StringValue.Parent = script
    end

    if StringValue then
        StringValue.Changed:Connect(function(p1) -- line: 58
            -- upvalues: self (copy)
            self:OnBoundKeysObjectChanged(p1)
        end)
        self:OnBoundKeysObjectChanged(StringValue.Value)
    end

    GameSettings.Changed:Connect(function(p2) -- line: 65
        -- upvalues: self (copy)
        if p2 == "ControlMode" or p2 == "ComputerMovementMode" then
            self:UpdateMouseLockAvailability()
        end
    end)
    Players.LocalPlayer:GetPropertyChangedSignal("DevEnableMouseLock"):Connect(function() -- line: 72
        -- upvalues: self (copy)
        self:UpdateMouseLockAvailability()
    end)
    Players.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function() -- line: 77
        -- upvalues: self (copy)
        self:UpdateMouseLockAvailability()
    end)
    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 81
        -- upvalues: self (copy)
        self:UpdateMouseLockAvailability()
    end)
    self:UpdateMouseLockAvailability()

    return self
end

function t1:GetIsMouseLocked() -- line: 90
    return self.isMouseLocked
end

function t1:GetBindableToggleEvent() -- line: 94
    return self.mouseLockToggledEvent.Event
end

function t1.GetMouseLockOffset(_) -- line: 98
    return (Vector3.new(1.75, 0, 0))
end

function t1:UpdateMouseLockAvailability() -- line: 102
    -- upvalues: Players (copy), UserInputService (copy), GameSettings (copy)
    local DevEnableMouseLock = Players.LocalPlayer.DevEnableMouseLock
    local v3 = Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable
    local v4 = GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch
    local v5 = GameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove

    v4 = UserInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse and DevEnableMouseLock and v4 and not v5 and not v3

    if v4 ~= self.enabled then
        self:EnableMouseLock(v4)
    end
end

function t1:OnBoundKeysObjectChanged(p8) -- line: 115
    self.boundKeys = {}

    for match in string.gmatch(p8, "[^%s,]+") do
        for _, v6 in pairs(Enum.KeyCode:GetEnumItems()) do
            if match == v6.Name then
                self.boundKeys[#self.boundKeys + 1] = v6
                break
            end
        end
    end

    self:UnbindContextActions()
    self:BindContextActions()
end

function t1:OnMouseLockToggled() -- line: 130
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

function t1.DoMouseLockSwitch(p10, _, p12, _) -- line: 155
    if p12 ~= Enum.UserInputState.Begin then
        return Enum.ContextActionResult.Pass
    end

    p10:OnMouseLockToggled()

    return Enum.ContextActionResult.Sink
end

function t1:BindContextActions() -- line: 163
    -- upvalues: Value (copy), ContextActionService (copy)
    ContextActionService:BindActionAtPriority("MouseLockSwitchAction", function(p15, p16, p17) -- line: 164
        -- upvalues: self (copy)
        return self:DoMouseLockSwitch(p15, p16, p17)
    end, false, Value, unpack(self.boundKeys))
end

function t1.UnbindContextActions(_) -- line: 169
    -- upvalues: ContextActionService (copy)
    ContextActionService:UnbindAction("MouseLockSwitchAction")
end

function t1:IsMouseLocked() -- line: 173
    return self.enabled and self.isMouseLocked
end

function t1:EnableMouseLock(p21) -- line: 177
    -- upvalues: CameraUtils (copy), UserFixStuckShiftLock (copy)
    if p21 == self.enabled then
        return
    end

    self.enabled = p21

    if self.enabled then
        self:BindContextActions()
    else
        CameraUtils.restoreMouseIcon()
        self:UnbindContextActions()

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
