-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Name = "setfishtier",
	Description = "Set your next caught fish tier",
	Aliases = { "tier", "nexttier" },
	Group = if require(ReplicatedStorage.Shared.UserPriority):IsValidTestSession() then "DefaultStaff" else "DefaultDeveloper",
	Args = {
		{
			Type = "number",
			Name = "Tier",
			Description = "Tiers 1 -> 7"
		},
		{
			Type = "player",
			Name = "Player",
			Description = "The player to update"
		}
	}
}