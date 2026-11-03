-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = {
	DeviceChanged = require(ReplicatedStorage.Shared.Packages.Signal).new(),
	Device = nil,
	DeviceTypes = {
		Mobile = "Mobile",
		Console = "Console",
		PC = "PC"
	}
}
function SetDevice(p1) --[[ SetDevice | Line: 18 | Upvalues: t (copy) ]]
	if p1 ~= t.Device then
		t.Device = p1
		t.DeviceChanged:Fire(p1)
	end
end
function DetectPlatform() --[[ DetectPlatform | Line: 27 | Upvalues: UserInputService (copy), GuiService (copy) ]]
	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
		SetDevice("Mobile")
	elseif UserInputService.GamepadEnabled or GuiService:IsTenFootInterface() then
		SetDevice("Console")
	else
		SetDevice("PC")
	end
end
function InitDevice() --[[ InitDevice | Line: 37 | Upvalues: UserInputService (copy) ]]
	DetectPlatform()
	UserInputService.LastInputTypeChanged:Connect(DetectPlatform)
	UserInputService.GamepadConnected:Connect(DetectPlatform)
	UserInputService.GamepadDisconnected:Connect(DetectPlatform)
end
function t._init() --[[ _init | Line: 45 ]]
	InitDevice()
end
return t