-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "Day",
	Icon = "rbxassetid://114264573242328",
	Duration = 4320000,
	AreaConfiguration = {
		Fish = {},
		Variants = {},
		Modifiers = {}
	},
	LinkedEvents = {
		Fish = {
			["Jungle - Hourglass Diamond"] = { "Hourglass Diamond Artifact" },
			["Jungle - Arrow"] = { "Arrow Artifact" },
			["Jungle - Crescent"] = { "Crescent Artifact" },
			["Jungle - Diamond"] = { "Diamond Artifact" },
			["Travis Fish"] = { "Trav Grupper" },
			["OG Fish"] = { "OG Snail" },
			["Christmas Express"] = { "Train Wheel" }
		},
		Variants = {
			["Disco Party"] = { "Disco" }
		},
		Modifiers = {}
	},
	Fish = {},
	Variants = {},
	Modifiers = {
		BaseLuck = 0
	}
}