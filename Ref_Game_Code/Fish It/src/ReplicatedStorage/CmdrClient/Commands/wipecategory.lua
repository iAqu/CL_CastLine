-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return {
	Name = "wipecategory",
	Description = "Reset a portion of your inventory",
	Aliases = { "wipecategory", "category" },
	Group = if require(ReplicatedStorage.Shared.UserPriority).IsValidTestSession() then "DefaultStaff" else "DefaultSeniorStaff",
	Args = {
		{
			Type = "string",
			Name = "Category",
			Description = ""
		}
	}
}