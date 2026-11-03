-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
return {
	Name = "hover",
	Description = "Returns the name of the player you are hovering over.",
	Group = "DefaultUtil",
	Args = {},
	ClientRun = function() --[[ ClientRun | Line: 9 | Upvalues: Players (copy) ]]
		local Target = Players.LocalPlayer:GetMouse().Target
		if Target then
			local v1 = Players:GetPlayerFromCharacter(Target:FindFirstAncestorOfClass("Model"))
			return if v1 then v1.Name or "" else ""
		else
			return ""
		end
	end
}