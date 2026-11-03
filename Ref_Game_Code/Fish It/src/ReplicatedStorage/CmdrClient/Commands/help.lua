-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "help",
	Description = "Displays a list of all commands, or inspects one command.",
	Group = "Help",
	Args = {
		{
			Type = "command",
			Name = "Command",
			Description = "The command to view information on",
			Optional = true
		}
	},
	ClientRun = function(p1, p2) --[[ ClientRun | Line: 14 ]]
		if p2 then
			local v1 = p1.Cmdr.Registry:GetCommand(p2)
			p1:Reply(("Command: %s"):format(v1.Name), Color3.fromRGB(230, 126, 34))
			if v1.Aliases and #v1.Aliases > 0 then
				p1:Reply(("Aliases: %s"):format(table.concat(v1.Aliases, ", ")), Color3.fromRGB(230, 230, 230))
			end
			p1:Reply(v1.Description, Color3.fromRGB(230, 230, 230))
			for i, v in ipairs(v1.Args) do
				p1:Reply(("#%d %s%s: %s - %s"):format(i, v.Name, if v.Optional == true then "?" else "", v.Type, v.Description))
			end
		else
			for k, v in pairs((p1.Cmdr.Registry:GetCommands())) do
				if p1.Dispatcher:CanViewCommand("BeforeRun", v.Group) then
					p1:Reply(("%s - %s"):format(v.Name, v.Description))
				end
			end
		end
		return ""
	end
}