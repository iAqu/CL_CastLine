-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "Easter Event",
	Icon = "rbxassetid://99628932799890",
	Description = "Boosted fishing odds!",
	Duration = 3600,
	AreaConfiguration = {
		Fish = {
			["Easter Island"] = { "Easter Eel", "Easter Blobfish", "Easter Pufferfish", "Pastel Rainbow Sardine" }
		},
		Variants = {},
		Modifiers = {
			["Easter Island"] = {
				MutationMultiplier = 4
			}
		}
	}
}