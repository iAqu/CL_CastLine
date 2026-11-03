-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "unbind",
	Description = "Unbinds an input previously bound with Bind",
	Group = "DefaultUtil",
	Aliases = {},
	Args = {
		{
			Type = "userInput ! bindableResource @ player",
			Name = "Input/Key",
			Description = "The key or input type you\'d like to unbind."
		}
	},
	ClientRun = function(p1, p2) --[[ ClientRun | Line: 14 ]]
		local v1 = p1:GetStore("CMDR_Binds")
		if v1[p2] then
			v1[p2]:Disconnect()
			v1[p2] = nil
			return "Unbound command from input."
		else
			return "That input wasn\'t bound."
		end
	end
}