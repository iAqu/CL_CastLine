-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = {}
for v1 in require(ReplicatedStorage.Pets) do
	table.insert(t, v1)
end
table.sort(t)
return {
	Name = "equippet",
	Description = "Equip latest owned pet by name",
	Group = "DefaultDeveloper",
	Aliases = { "equippet" },
	Args = {
		{
			Type = "player",
			Name = "Player",
			Description = "The player"
		},
		{
			Type = "string",
			Name = "Pet",
			Description = table.concat(t, " | ")
		}
	}
}