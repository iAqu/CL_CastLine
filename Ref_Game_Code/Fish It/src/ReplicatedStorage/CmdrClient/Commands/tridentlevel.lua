-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Name = "tridentlevel",
	Description = "Set Overlord\'s Trident level",
	Aliases = { "tridentlevel" },
	Group = if require(ReplicatedStorage.Shared.UserPriority).IsValidTestSession() then "DefaultStaff" else "DefaultAdmin",
	Args = {
		{
			Type = "number",
			Name = "Progress",
			Description = "1 - 7"
		}
	}
}