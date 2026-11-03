-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local Icon = require(ReplicatedStorage.Shared.Packages.Icon)
local MusicController = require(ReplicatedStorage.Modules.ControllerLoader.MusicController)
local NewInventory = require(ReplicatedStorage.Modules.UILoader.NewInventory)
local t = {}
function CreateMusicIcon() --[[ CreateMusicIcon | Line: 15 | Upvalues: Icon (copy), MusicController (copy) ]]
	local t = {
		[true] = "90997861213158",
		[false] = "115740111785187"
	}
	local v1 = Icon.new()
	v1:align("Right")
	v1:oneClick(false)
	v1:setImage(t[false])
	v1:bindEvent("toggled", function(p1) --[[ Line: 25 | Upvalues: MusicController (ref) ]]
		MusicController:Toggle()
	end)
	MusicController.MuteChanged:Connect(function(p1) --[[ Line: 29 | Upvalues: v1 (copy), t (copy) ]]
		v1:setImage(t[p1])
	end)
end
function CreateInvIcon() --[[ CreateInvIcon | Line: 34 | Upvalues: Icon (copy), GuiService (copy), NewInventory (copy) ]]
	local t = {
		[false] = "91920926026387",
		[true] = "103942928230530"
	}
	local v1 = Icon.new()
	v1:align("Left")
	v1:oneClick(true)
	v1:setImage(t[false])
	v1:setIndicator(Enum.KeyCode.DPadLeft)
	v1:bindToggleKey(Enum.KeyCode.DPadLeft)
	v1:setCaption("Toggle")
	v1:bindEvent("deselected", function() --[[ Line: 47 | Upvalues: v1 (copy), GuiService (ref), NewInventory (ref) ]]
		v1:debounce(0.1)
		GuiService.SelectedObject = nil
		NewInventory.ToggleBackpack()
	end)
	NewInventory.GUI.InventoryFrame.Backpack:GetPropertyChangedSignal("Visible"):Connect(function() --[[ Line: 53 | Upvalues: v1 (copy), t (copy), NewInventory (ref) ]]
		v1:setImage(t[NewInventory.GUI.InventoryFrame.Backpack.Visible])
	end)
end
function t._init(p1) --[[ _init | Line: 59 ]]
	CreateMusicIcon()
	CreateInvIcon()
end
return t