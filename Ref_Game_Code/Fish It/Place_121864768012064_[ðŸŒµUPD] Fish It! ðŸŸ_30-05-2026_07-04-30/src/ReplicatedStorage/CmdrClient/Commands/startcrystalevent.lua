-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Name = "startcrystalevent",
	Description = "Start the Crystal Extraction event.",
	Aliases = { "crystalevent" },
	Group = if require(ReplicatedStorage.Shared.UserPriority).IsValidTestSession() then "DefaultSeniorStaff" else "DefaultDeveloper",
	Args = {}
}