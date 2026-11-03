-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Name = "globalcutscene",
	Description = "Add global cutscene",
	Aliases = { "globalcutscene", "cutscene" },
	Group = if require(ReplicatedStorage.Shared.UserPriority).IsValidTestSession() then "DefaultStaff" else "DefaultAdmin",
	Args = {
		{
			Type = "string",
			Name = "Cutscene",
			Description = "Name of the cutscene"
		}
	}
}