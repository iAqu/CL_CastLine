-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Name = "wipedata",
	Description = "Reset your data",
	Aliases = { "reset", "wipe", "data", "wipedata" },
	Group = if require(ReplicatedStorage.Shared.UserPriority).IsValidTestSession() then "DefaultStaff" else "DefaultSeniorStaff",
	Args = {}
}