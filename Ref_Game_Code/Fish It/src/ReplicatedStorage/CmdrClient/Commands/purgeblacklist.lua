-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Name = "purgeblacklist",
	Description = "Remove blacklisted-item GUIDs from all online players (uses Game.Security.BlacklistedItemGUIDs FFlag)",
	Aliases = { "purgeblacklist" },
	Group = if require(ReplicatedStorage.Shared.UserPriority).IsValidTestSession() then "DefaultSeniorStaff" else "DefaultDeveloper",
	Args = {}
}