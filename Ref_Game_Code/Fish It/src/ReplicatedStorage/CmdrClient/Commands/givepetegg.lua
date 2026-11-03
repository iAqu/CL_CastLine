-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = {}
for v1 in require(ReplicatedStorage.PetEggs) do
	table.insert(t, v1)
end
table.sort(t)
return {
	Name = "givepetegg",
	Description = "Give pet eggs",
	Group = "DefaultDeveloper",
	Aliases = { "petegg", "givepetegg" },
	Args = {
		{
			Type = "player",
			Name = "Player",
			Description = "The player to give"
		},
		{
			Type = "string",
			Name = "Egg",
			Description = table.concat(t, " | ")
		},
		{
			Type = "integer",
			Name = "Amount",
			Description = "Egg count"
		}
	}
}