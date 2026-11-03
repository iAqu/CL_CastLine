-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "Night",
	Icon = "rbxassetid://107109194903076",
	Duration = 4320000,
	AreaConfiguration = {
		Fish = {
			["Sisyphus Statue"] = { "Depthseeker Ray" },
			["Pirate Treasure Room"] = { "Pirate Starfish" }
		},
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
			Variants = {
				["Disco Party"] = { "Disco" }
			}
		},
		Modifiers = {}
	},
	Modifiers = {
		BaseLuck = 0
	}
}