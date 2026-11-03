-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local Observers = require(ReplicatedStorage.Packages.Observers)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
Observers.observeTag("AutomaticCloseButton", function(p1) --[[ Line: 15 | Upvalues: GuiControl (copy) ]]
	p1:SetAttribute("Ignore2D", true)
	local v1 = GuiControl:Hook("Hold Button", p1)
	local v2 = v1.Clicked:Connect(function() --[[ Line: 20 | Upvalues: p1 (copy), GuiControl (ref) ]]
		if p1:GetAttribute("Unlock") == true then
			GuiControl:Unlock()
		end
		GuiControl:Close()
	end)
	return function() --[[ Line: 28 | Upvalues: v2 (copy), v1 (copy) ]]
		v2:Disconnect()
		v1:Destroy()
	end
end, { PlayerGui })
return {}