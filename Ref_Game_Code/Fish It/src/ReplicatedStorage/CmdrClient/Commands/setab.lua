-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "setab",
	Description = "Set your AB variant",
	Group = "DefaultDeveloper",
	Aliases = { "abvariant", "abtest" },
	Args = {
		{
			Type = "string",
			Name = "Test",
			Description = "tutorialshop | spawnrod | all"
		},
		{
			Type = "string",
			Name = "Variant",
			Description = "A | B | random"
		}
	}
}