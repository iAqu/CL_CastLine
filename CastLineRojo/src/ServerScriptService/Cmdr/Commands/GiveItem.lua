return {
	Name = "giveItem";
	Aliases = { "giveFish" };
	Description = "Give a configured item directly to a player's backpack";
	Group = "Admin";
	Args = {
		{
			Type = "player";
			Name = "Player";
			Description = "The player receiving the items";
		},
		{
			Type = "item";
			Name = "ItemID";
			Description = "The item to give";
		},
		{
			Type = "number";
			Name = "Amount";
			Description = "How many items to give";
			Default = 1;
		},
	}
}
