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
	ClientRun = function(p1, p2) --[[ ClientRun | Line: 31 ]]
		if p2 then
			local v1 = p1.Cmdr.Registry:GetCommand(p2)
			p1:Reply(("Command: %*"):format(v1.Name), Color3.fromRGB(230, 126, 34))
			if v1.Aliases and #v1.Aliases > 0 then
				p1:Reply(("Aliases: %*"):format((table.concat(v1.Aliases, ", "))), Color3.fromRGB(230, 230, 230))
			end
			p1:Reply(v1.Description, Color3.fromRGB(230, 230, 230))
			for i, v in ipairs(v1.Args) do
				p1:Reply((("#%* %*%*: %* - %*"):format(i, v.Name, if v.Optional == true then "?" else "", v.Type, v.Description)))
			end
		else
			p1:Reply("Argument Shorthands\n-------------------\n.   Me/Self\n*   All/Everyone\n**  Others\n?   Random\n?N  List of N random values\n")
			p1:Reply("Tips\n----\n\226\128\162 Utilize the Tab key to automatically complete commands\n\226\128\162 Easily select and copy command output\n")
			local v5 = p1.Cmdr.Registry:GetCommands()
			table.sort(v5, function(p1, p2) --[[ Line: 49 ]]
				if p1.Group and p2.Group then
					return p1.Group < p2.Group
				else
					return p1.Group
				end
			end)
			local v6 = nil
			for i, v in ipairs(v5) do
				v.Group = v.Group or "No Group"
				if v6 ~= v.Group then
					p1:Reply((("\n%*\n%*"):format(v.Group, (string.rep("-", #v.Group)))))
					v6 = v.Group
				end
				local v7
				if v.Description then
					v7 = ("%* - %*"):format(v.Name, v.Description)
					p1:Reply(v7)
				end
				v7 = v.Name
				p1:Reply(v7)
			end
		end
		return ""
	end
}