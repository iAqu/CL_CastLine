-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "AddWeather",
	Description = "Adds a global weather event",
	Group = "DefaultAdmin",
	Aliases = { "aw" },
	Args = {
		{
			Type = "weatherEvent",
			Name = "Event Name",
			Description = "Chosen Event"
		},
		{
			Type = "number",
			Name = "Duration",
			Description = "The duration of the event to be (in seconds)"
		}
	}
}