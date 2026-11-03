-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Name = "removeQuest",
	Description = "Reset an existing quest or delete a completed quest",
	Aliases = { "removeQuest", "clearQuest", "wipeQuest" },
	Group = if require(ReplicatedStorage.Shared.UserPriority).IsValidTestSession() then "DefaultStaff" else "DefaultAdmin",
	Args = {
		{
			Type = "string",
			Name = "Quest Name",
			Description = "Exact name of the quest"
		}
	}
}