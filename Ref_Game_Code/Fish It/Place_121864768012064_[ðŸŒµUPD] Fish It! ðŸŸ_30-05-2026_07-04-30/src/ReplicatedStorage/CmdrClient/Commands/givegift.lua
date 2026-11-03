-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = {}
for v1, v2 in require(ReplicatedStorage.Shared.GiftProducts) do
	if v2.product then
		table.insert(t, v2.product)
	end
end
return {
	Name = "giveGift",
	Description = "Give this Player a gift",
	Group = "DefaultSeniorStaff",
	Aliases = { "product", "gift", "gamepass" },
	Args = {
		{
			Type = "player",
			Name = "Player",
			Description = "Player to gift"
		},
		{
			Type = "string",
			Name = "Product Name",
			Description = table.concat(t, ", ")
		}
	}
}