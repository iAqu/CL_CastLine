-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Original SourceAssetId: https://assetdelivery.roblox.com/v1/asset/?id=5888513160

-- ! Source from the asset above; the game may have edited it since.

--[[
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Settings = UserSettings()
local GameSettings = Settings.GameSettings
local ShiftLockController = {}
while not Players.LocalPlayer do
	wait()
end
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ScreenGui, ShiftLockIcon, InputCn
local IsShiftLockMode = true
local IsShiftLocked = true
local IsActionBound = false
local IsInFirstPerson = false
ShiftLockController.OnShiftLockToggled = Instance.new("BindableEvent")
local function isShiftLockMode()
	return LocalPlayer.DevEnableMouseLock and GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch and LocalPlayer.DevComputerMovementMode ~= Enum.DevComputerMovementMode.ClickToMove and GameSettings.ComputerMovementMode ~= Enum.ComputerMovementMode.ClickToMove and LocalPlayer.DevComputerMovementMode ~= Enum.DevComputerMovementMode.Scriptable
end
if not UserInputService.TouchEnabled then
	IsShiftLockMode = isShiftLockMode()
end
local function onShiftLockToggled()
	IsShiftLocked = not IsShiftLocked
	ShiftLockController.OnShiftLockToggled:Fire()
end
local initialize = function()
	print("enabled")
end
function ShiftLockController:IsShiftLocked()
	return IsShiftLockMode and IsShiftLocked
end
function ShiftLockController:SetIsInFirstPerson(isInFirstPerson)
	IsInFirstPerson = isInFirstPerson
end
local function mouseLockSwitchFunc(actionName, inputState, inputObject)
	if IsShiftLockMode then
		onShiftLockToggled()
	end
end
local function disableShiftLock()
	if ScreenGui then
		ScreenGui.Parent = nil
	end
	IsShiftLockMode = false
	Mouse.Icon = ""
	if InputCn then
		InputCn:disconnect()
		InputCn = nil
	end
	IsActionBound = false
	ShiftLockController.OnShiftLockToggled:Fire()
end
local onShiftInputBegan = function(inputObject, isProcessed)
	if isProcessed then
		return
	end
	if inputObject.UserInputType ~= Enum.UserInputType.Keyboard or inputObject.KeyCode == Enum.KeyCode.LeftShift or inputObject.KeyCode == Enum.KeyCode.RightShift then
	end
end
local function enableShiftLock()
	IsShiftLockMode = isShiftLockMode()
	if IsShiftLockMode then
		if ScreenGui then
			ScreenGui.Parent = PlayerGui
		end
		if IsShiftLocked then
			ShiftLockController.OnShiftLockToggled:Fire()
		end
		if not IsActionBound then
			InputCn = UserInputService.InputBegan:connect(onShiftInputBegan)
			IsActionBound = true
		end
	end
end
GameSettings.Changed:connect(function(property)
	if property == "ControlMode" then
		if GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch then
			enableShiftLock()
		else
			disableShiftLock()
		end
	elseif property == "ComputerMovementMode" then
		if GameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove then
			disableShiftLock()
		else
			enableShiftLock()
		end
	end
end)
LocalPlayer.Changed:connect(function(property)
	if property == "DevEnableMouseLock" then
		if LocalPlayer.DevEnableMouseLock then
			enableShiftLock()
		else
			disableShiftLock()
		end
	elseif property == "DevComputerMovementMode" then
		if LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.ClickToMove or LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable then
			disableShiftLock()
		else
			enableShiftLock()
		end
	end
end)
LocalPlayer.CharacterAdded:connect(function(character)
	if not UserInputService.TouchEnabled then
		initialize()
	end
end)
if not UserInputService.TouchEnabled then
	initialize()
	if isShiftLockMode() then
		InputCn = UserInputService.InputBegan:connect(onShiftInputBegan)
		IsActionBound = true
	end
end
enableShiftLock()
return ShiftLockController

]]

-- https://lua.expert

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local GameSettings = UserSettings().GameSettings
local t1 = {}

while not Players.LocalPlayer do
    wait()
end

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

LocalPlayer:WaitForChild("PlayerGui")

local v1
local v2 = true
local v3 = true
local v4 = false
local v5 = false

t1.OnShiftLockToggled = Instance.new("BindableEvent")

local function isShiftLockMode() -- line: 18
    -- upvalues: GameSettings (copy), LocalPlayer (copy)
    return LocalPlayer.DevEnableMouseLock and GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch and LocalPlayer.DevComputerMovementMode ~= Enum.DevComputerMovementMode.ClickToMove and GameSettings.ComputerMovementMode ~= Enum.ComputerMovementMode.ClickToMove and LocalPlayer.DevComputerMovementMode ~= Enum.DevComputerMovementMode.Scriptable
end

if not UserInputService.TouchEnabled then
    local DevEnableMouseLock = LocalPlayer.DevEnableMouseLock

    v2 = DevEnableMouseLock

    if DevEnableMouseLock then
        v2 = false

        if GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch then
            v2 = false

            if LocalPlayer.DevComputerMovementMode ~= Enum.DevComputerMovementMode.ClickToMove then
                v2 = false

                if GameSettings.ComputerMovementMode ~= Enum.ComputerMovementMode.ClickToMove then
                    v2 = LocalPlayer.DevComputerMovementMode ~= Enum.DevComputerMovementMode.Scriptable
                end
            end
        end
    end
end

local function onShiftLockToggled() -- line: 28
    -- upvalues: t1 (copy), v3 (ref)
    v3 = not v3
    t1.OnShiftLockToggled:Fire()
end

local function v6() -- line: 32
end

function t1.IsShiftLocked(_) -- line: 35
    -- upvalues: v2 (ref), v3 (ref)
    return v2 and v3
end

function t1.SetIsInFirstPerson(_, p3) -- line: 36
    -- upvalues: v5 (ref)
    v5 = p3
end

local function mouseLockSwitchFunc(_, _, _) -- line: 37
    -- upvalues: t1 (copy), v2 (ref), v3 (ref)
    if v2 then
        v3 = not v3
        t1.OnShiftLockToggled:Fire()
    end
end

local function disableShiftLock() -- line: 42
    -- upvalues: t1 (copy), Mouse (copy), v1 (ref), v2 (ref), v4 (ref)
    v2 = false
    Mouse.Icon = ""

    if v1 then
        v1:disconnect()
        v1 = nil
    end

    v4 = false
    t1.OnShiftLockToggled:Fire()
end

local function v7(p7, p8) -- line: 55
    if not p8 and p7.UserInputType == Enum.UserInputType.Keyboard and (p7.KeyCode == Enum.KeyCode.LeftShift or p7.KeyCode == Enum.KeyCode.RightShift) then
    end
end

local function enableShiftLock() -- line: 66
    -- upvalues: UserInputService (copy), GameSettings (copy), t1 (copy), LocalPlayer (copy), v1 (ref), v2 (ref), v3 (ref), v4 (ref), v7 (copy)
    local DevEnableMouseLock = LocalPlayer.DevEnableMouseLock and GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch and LocalPlayer.DevComputerMovementMode ~= Enum.DevComputerMovementMode.ClickToMove and GameSettings.ComputerMovementMode ~= Enum.ComputerMovementMode.ClickToMove and LocalPlayer.DevComputerMovementMode ~= Enum.DevComputerMovementMode.Scriptable

    v2 = DevEnableMouseLock

    if v2 then
        if v3 then
            t1.OnShiftLockToggled:Fire()
        end

        if not v4 then
            v1 = UserInputService.InputBegan:connect(v7)
            v4 = true
        end
    end
end

GameSettings.Changed:connect(function(p9) -- line: 81
    -- upvalues: UserInputService (copy), GameSettings (copy), t1 (copy), LocalPlayer (copy), Mouse (copy), v1 (ref), v2 (ref), v3 (ref), v4 (ref), v7 (copy)
    if p9 == "ControlMode" then
        if GameSettings.ControlMode ~= Enum.ControlMode.MouseLockSwitch then
            v2 = false
            Mouse.Icon = ""

            if v1 then
                v1:disconnect()
                v1 = nil
            end

            v4 = false
            t1.OnShiftLockToggled:Fire()
        else
            local DevEnableMouseLock = LocalPlayer.DevEnableMouseLock and GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch and LocalPlayer.DevComputerMovementMode ~= Enum.DevComputerMovementMode.ClickToMove and GameSettings.ComputerMovementMode ~= Enum.ComputerMovementMode.ClickToMove and LocalPlayer.DevComputerMovementMode ~= Enum.DevComputerMovementMode.Scriptable

            v2 = DevEnableMouseLock

            if v2 then
                if v3 then
                    t1.OnShiftLockToggled:Fire()
                end

                if not v4 then
                    v1 = UserInputService.InputBegan:connect(v7)
                    v4 = true
                end
            end
        end
    elseif p9 == "ComputerMovementMode" then
        if GameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove then
            v2 = false
            Mouse.Icon = ""

            if v1 then
                v1:disconnect()
                v1 = nil
            end

            v4 = false
            t1.OnShiftLockToggled:Fire()
        else
            local DevEnableMouseLock = LocalPlayer.DevEnableMouseLock and GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch and LocalPlayer.DevComputerMovementMode ~= Enum.DevComputerMovementMode.ClickToMove and GameSettings.ComputerMovementMode ~= Enum.ComputerMovementMode.ClickToMove and LocalPlayer.DevComputerMovementMode ~= Enum.DevComputerMovementMode.Scriptable

            v2 = DevEnableMouseLock

            if v2 then
                if v3 then
                    t1.OnShiftLockToggled:Fire()
                end

                if not v4 then
                    v1 = UserInputService.InputBegan:connect(v7)
                    v4 = true
                end
            end
        end
    end
end)
LocalPlayer.Changed:connect(function(p10) -- line: 96
    -- upvalues: UserInputService (copy), GameSettings (copy), t1 (copy), LocalPlayer (copy), Mouse (copy), v1 (ref), v2 (ref), v3 (ref), v4 (ref), v7 (copy)
    if p10 == "DevEnableMouseLock" then
        if not LocalPlayer.DevEnableMouseLock then
            v2 = false
            Mouse.Icon = ""

            if v1 then
                v1:disconnect()
                v1 = nil
            end

            v4 = false
            t1.OnShiftLockToggled:Fire()
        else
            local DevEnableMouseLock = LocalPlayer.DevEnableMouseLock and GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch and LocalPlayer.DevComputerMovementMode ~= Enum.DevComputerMovementMode.ClickToMove and GameSettings.ComputerMovementMode ~= Enum.ComputerMovementMode.ClickToMove and LocalPlayer.DevComputerMovementMode ~= Enum.DevComputerMovementMode.Scriptable

            v2 = DevEnableMouseLock

            if v2 then
                if v3 then
                    t1.OnShiftLockToggled:Fire()
                end

                if not v4 then
                    v1 = UserInputService.InputBegan:connect(v7)
                    v4 = true
                end
            end
        end
    elseif p10 == "DevComputerMovementMode" then
        if LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.ClickToMove or LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable then
            v2 = false
            Mouse.Icon = ""

            if v1 then
                v1:disconnect()
                v1 = nil
            end

            v4 = false
            t1.OnShiftLockToggled:Fire()
        else
            local DevEnableMouseLock = LocalPlayer.DevEnableMouseLock and GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch and LocalPlayer.DevComputerMovementMode ~= Enum.DevComputerMovementMode.ClickToMove and GameSettings.ComputerMovementMode ~= Enum.ComputerMovementMode.ClickToMove and LocalPlayer.DevComputerMovementMode ~= Enum.DevComputerMovementMode.Scriptable

            v2 = DevEnableMouseLock

            if v2 then
                if v3 then
                    t1.OnShiftLockToggled:Fire()
                end

                if not v4 then
                    v1 = UserInputService.InputBegan:connect(v7)
                    v4 = true
                end
            end
        end
    end
end)
LocalPlayer.CharacterAdded:connect(function(_) -- line: 114
    -- upvalues: UserInputService (copy)
    if UserInputService.TouchEnabled then
    end
end)

if not UserInputService.TouchEnabled then
    local DevEnableMouseLock = LocalPlayer.DevEnableMouseLock and GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch and LocalPlayer.DevComputerMovementMode ~= Enum.DevComputerMovementMode.ClickToMove and GameSettings.ComputerMovementMode ~= Enum.ComputerMovementMode.ClickToMove and LocalPlayer.DevComputerMovementMode ~= Enum.DevComputerMovementMode.Scriptable

    if DevEnableMouseLock then
        v1 = UserInputService.InputBegan:connect(v7)
        v4 = true
    end
end

v2 = LocalPlayer.DevEnableMouseLock

if v2 then
    v2 = false

    if GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch then
        v2 = false

        if LocalPlayer.DevComputerMovementMode ~= Enum.DevComputerMovementMode.ClickToMove then
            v2 = false

            if GameSettings.ComputerMovementMode ~= Enum.ComputerMovementMode.ClickToMove then
                v2 = LocalPlayer.DevComputerMovementMode ~= Enum.DevComputerMovementMode.Scriptable
            end
        end
    end
end

if v2 then
    if v3 then
        t1.OnShiftLockToggled:Fire()
    end

    if not v4 then
        v1 = UserInputService.InputBegan:connect(v7)
        v4 = true
    end
end

return t1
