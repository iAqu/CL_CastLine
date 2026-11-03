-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Name = "speed",
	Description = "Set character walkspeed",
	Aliases = { "speed", "walkspeed" },
	Group = if require(ReplicatedStorage.Shared.UserPriority).IsValidTestSession() then "DefaultStaff" else "DefaultSeniorStaff",
	Args = {
		{
			Type = "number",
			Name = "Speed",
			Description = "Character speed (16 - 200)"
		}
	}
}