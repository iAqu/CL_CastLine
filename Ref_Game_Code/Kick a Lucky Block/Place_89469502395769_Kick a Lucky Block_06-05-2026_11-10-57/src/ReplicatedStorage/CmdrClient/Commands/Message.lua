-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "Announce",
	Description = "Sends a global message",
	Group = "DefaultAdmin",
	Aliases = { "n" },
	Args = {
		{
			Type = "string",
			Name = "Text",
			Description = "Add your text."
		}
	}
}