-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = if require(ReplicatedStorage.Shared.UserPriority).IsValidTestSession() then "DefaultSeniorStaff" else "DefaultDeveloper"
local t = {}
for v2 in require(ReplicatedStorage.Shared.ItemUtility).GetAllItems() do
	if not table.find(t, v2) then
		table.insert(t, v2)
	end
end
return {
	Name = "additem",
	Description = "Add item",
	Aliases = { "add", "item", "items", "giveitem" },
	Group = v1,
	Args = {
		{
			Type = "string",
			Name = "Item Type",
			Description = table.concat(t, " | ")
		},
		{
			Type = "string",
			Name = "Metadata",
			Description = "Optional JSON table"
		},
		{
			Type = "player",
			Name = "Player",
			Description = "The player to give"
		},
		{
			Type = "string",
			Name = "Item Name",
			Description = "Requires exact item name!"
		}
	}
}