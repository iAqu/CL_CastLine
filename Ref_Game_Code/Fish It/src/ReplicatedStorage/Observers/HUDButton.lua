-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observers = require(ReplicatedStorage.Packages.Observers)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local ToolTip = require(ReplicatedStorage.Modules.ToolTip)
Observers.observeTag("HUDButton", function(p1) --[[ Line: 12 | Upvalues: GuiControl (copy), ToolTip (copy) ]]
	local v1 = p1.Name
	local v2 = GuiControl:Hook("Hold Button", p1)
	local v3 = p1:GetAttribute("Description")
	if v3 then
		ToolTip.observe(p1, v2.Cleaner, function() --[[ Line: 18 | Upvalues: v3 (copy) ]]
			return {
				Style = "Label",
				Text = v3
			}
		end)
	end
	v2.Clicked:Connect(function() --[[ Line: 26 | Upvalues: GuiControl (ref), v1 (copy) ]]
		if GuiControl:IsOpen(v1) then
			GuiControl:Close()
		else
			GuiControl:Open(v1)
		end
	end)
	return function() --[[ Line: 34 | Upvalues: v2 (copy) ]]
		v2:Destroy()
	end
end)
return {}