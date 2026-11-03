-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = {}
for v1 in require(ReplicatedStorage.Pets) do
	table.insert(t, v1)
end
table.sort(t)
return {
	Name = "givepet",
	Description = "Give a pet",
	Group = "DefaultDeveloper",
	Aliases = { "pet", "givepet" },
	Args = {
		{
			Type = "player",
			Name = "Player",
			Description = "The player to give"
		},
		{
			Type = "string",
			Name = "Pet",
			Description = table.concat(t, " | ")
		}
	}
}