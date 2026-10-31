return {
	Name = "giveRandomItem";
	Description = "Give uniformly random configured items directly to a player's backpack";
	Group = "Admin";
	Args = {
		{
			Type = "player";
			Name = "Player";
			Description = "The player receiving the items";
		},
		{
			Type = "number";
			Name = "Amount";
			Description = "How many random items to give";
			Default = 1;
		},
	}
}
