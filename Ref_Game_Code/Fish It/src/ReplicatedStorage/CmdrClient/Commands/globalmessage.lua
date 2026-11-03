-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("ReplicatedStorage")
return {
	Name = "globalmessage",
	Description = "Send a message to all servers",
	Group = "DefaultAdmin",
	Aliases = { "message", "globalmessage" },
	Args = {
		{
			Type = "string",
			Name = "Unfiltered Message",
			Description = "Do not abuse this!"
		}
	}
}