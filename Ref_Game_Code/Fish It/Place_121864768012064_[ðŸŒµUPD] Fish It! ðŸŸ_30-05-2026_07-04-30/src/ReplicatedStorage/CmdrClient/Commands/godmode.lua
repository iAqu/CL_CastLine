-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Name = "godmode",
	Description = "Enable god mode",
	Aliases = { "god", "godmode" },
	Group = if require(ReplicatedStorage.Shared.UserPriority).IsValidTestSession() then "DefaultStaff" else "DefaultAdmin",
	Args = {
		{
			Type = "boolean",
			Name = "Enabled",
			Description = "true or false"
		}
	}
}