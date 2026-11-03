-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Name = "givepickaxe",
	Description = "Give a player the Pickaxe for crystal extraction",
	Aliases = { "pickaxe" },
	Group = if require(ReplicatedStorage.Shared.UserPriority).IsValidTestSession() then "DefaultSeniorStaff" else "DefaultDeveloper",
	Args = {
		{
			Type = "player",
			Name = "Player",
			Description = "The player to give the Pickaxe to"
		}
	}
}