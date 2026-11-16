return {
	Name = "giveFish";
	Description = "Give a configured fish directly to a player's backpack";
	Group = "Admin";
	Args = {
		{
			Type = "player";
			Name = "Player";
			Description = "The player receiving the fish";
		},
		{
			Type = "item";
			Name = "FishID";
			Description = "The fish to give";
		},
		{
			Type = "number";
			Name = "Amount";
			Description = "How many fish to give";
			Default = 1;
		},
	}
}
