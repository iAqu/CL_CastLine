-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = {}
for v1 in require(ReplicatedStorage.Abilities) do
	table.insert(t, v1)
end
table.sort(t)
return {
	Name = "giveability",
	Description = "Give an ability",
	Group = "DefaultDeveloper",
	Aliases = { "ability", "giveability" },
	Args = {
		{
			Type = "player",
			Name = "Player",
			Description = "The player to give"
		},
		{
			Type = "string",
			Name = "Ability",
			Description = table.concat(t, " | ")
		}
	}
}