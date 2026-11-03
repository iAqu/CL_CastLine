-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "swapdaysky",
	Description = "Set the active Day sky to old or new",
	Group = "DefaultSeniorStaff",
	Aliases = { "updatedaysky", "daysky", "refreshdaysky" },
	Args = {
		{
			Type = "string",
			Name = "Variant",
			Description = "old | new"
		}
	}
}