-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Name = "globalLuck",
	Description = "Add luck to all servers",
	Aliases = { "globalLuck", "globalServerLuck" },
	Group = if require(ReplicatedStorage.Shared.UserPriority).IsValidTestSession() then "DefaultStaff" else "DefaultAdmin",
	Args = {
		{
			Type = "number",
			Name = "Luck Multiplier",
			Description = "2, 4, 8, 10"
		},
		{
			Type = "number",
			Name = "Duration",
			Description = "Amount of time in hours"
		}
	}
}