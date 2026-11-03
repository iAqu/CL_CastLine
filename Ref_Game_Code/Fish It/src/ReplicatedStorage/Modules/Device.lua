-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CurrentCamera = workspace.CurrentCamera
local PlayerGui = Players.LocalPlayer.PlayerGui
local Trove = require(ReplicatedStorage.Packages.Trove)
local t = {}
t.__index = t
function t.new() --[[ new | Line: 37 | Upvalues: t (copy), Trove (copy) ]]
	local v2 = setmetatable({
		Device = t:_getDevice(),
		Cleaner = Trove.new(),
		DeviceCallbacks = {}
	}, t)
	v2:_init()
	return v2
end
function t.IsMobile(p1) --[[ IsMobile | Line: 49 | Upvalues: t (copy) ]]
	local v1 = t:_getDevice()
	p1.Device = v1
	return if v1 == "Tablet" then true else v1 == "Phone"
end
function t.RegisterDeviceChanged(p1, p2) --[[ RegisterDeviceChanged | Line: 56 ]]
	table.insert(p1.DeviceCallbacks, p2)
	return p2
end
function t.Remove(p1, p2) --[[ Remove | Line: 62 ]]
	local v1 = table.find(p1.DeviceCallbacks, p2)
	if not v1 then
		return
	end
	table.remove(p1.DeviceCallbacks, v1)
end
function t._getDevice(p1) --[[ _getDevice | Line: 69 | Upvalues: UserInputService (copy), GuiService (copy) ]]
	local v1 = UserInputService:GetLastInputType()
	if GuiService:IsTenFootInterface() or v1.Name:find("Gamepad") then
		return "Console"
	end
	if not UserInputService.TouchEnabled or UserInputService.MouseEnabled then
		return "PC"
	end
	if workspace.CurrentCamera.ViewportSize.Y > 600 then
		return "Tablet"
	else
		return "Phone"
	end
end
function t._onDeviceChanged(p1) --[[ _onDeviceChanged | Line: 89 ]]
	local v1 = p1:_getDevice()
	if v1 == p1.Device then
		return
	end
	p1.Device = v1
	for i, v in ipairs(p1.DeviceCallbacks) do
		task.spawn(v, v1)
	end
end
function t._init(p1) --[[ _init | Line: 102 | Upvalues: UserInputService (copy), CurrentCamera (copy), PlayerGui (copy) ]]
	p1.Cleaner:Add(UserInputService.InputChanged:Connect(function() --[[ Line: 103 | Upvalues: p1 (copy) ]]
		p1:_onDeviceChanged()
	end))
	p1.Cleaner:Add(UserInputService.InputBegan:Connect(function() --[[ Line: 107 | Upvalues: p1 (copy) ]]
		p1:_onDeviceChanged()
	end))
	p1.Cleaner:Add(UserInputService.LastInputTypeChanged:Connect(function() --[[ Line: 111 | Upvalues: p1 (copy) ]]
		p1:_onDeviceChanged()
	end))
	p1.Cleaner:Add(CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() --[[ Line: 115 | Upvalues: p1 (copy) ]]
		p1:_onDeviceChanged()
	end))
	p1.Cleaner:Add(PlayerGui:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(function() --[[ Line: 119 | Upvalues: p1 (copy) ]]
		p1:_onDeviceChanged()
	end))
	p1.Cleaner:Add(UserInputService:GetPropertyChangedSignal("MouseEnabled"):Connect(function() --[[ Line: 123 | Upvalues: p1 (copy) ]]
		p1:_onDeviceChanged()
	end))
	p1.Cleaner:Add(UserInputService:GetPropertyChangedSignal("TouchEnabled"):Connect(function() --[[ Line: 127 | Upvalues: p1 (copy) ]]
		p1:_onDeviceChanged()
	end))
	p1.Cleaner:Add(UserInputService:GetPropertyChangedSignal("GamepadEnabled"):Connect(function() --[[ Line: 131 | Upvalues: p1 (copy) ]]
		p1:_onDeviceChanged()
	end))
end
return t.new()