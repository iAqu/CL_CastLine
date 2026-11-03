-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observers = require(ReplicatedStorage.Packages.Observers)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
task.spawn(function() --[[ Line: 7 | Upvalues: Observers (copy), GuiControl (copy) ]]
	Observers.observeTag("ServerLuckExpand", function(p1) --[[ Line: 8 | Upvalues: GuiControl (ref) ]]
		local v1 = p1.Parent.Parent:WaitForChild("Server Bundle")
		local v2 = GuiControl:Hook("Hold Button", p1)
		v2.Clicked:Connect(function() --[[ Line: 13 | Upvalues: p1 (copy), v1 (copy), v2 (copy) ]]
			p1.Visible = false
			v1.Visible = true
			v2:Destroy()
		end)
		return function() --[[ Line: 20 | Upvalues: v2 (copy) ]]
			v2:Destroy()
		end
	end)
end)
return {}