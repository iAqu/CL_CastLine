-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Name = "setramadangiftboxdonations",
	Description = "Set Ramadan donated giftbox progress",
	Aliases = { "ramadandonations", "setramadanprogress" },
	Group = if require(ReplicatedStorage.Shared.UserPriority).IsValidTestSession() then "DefaultSeniorStaff" else "DefaultDeveloper",
	Args = {
		{
			Type = "player",
			Name = "Player",
			Description = "The player to update"
		},
		{
			Type = "number",
			Name = "Amount",
			Description = "Donated giftboxes"
		}
	}
}