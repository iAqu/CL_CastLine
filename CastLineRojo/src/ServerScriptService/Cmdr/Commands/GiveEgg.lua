return {
	Name = "giveEgg";
	Description = "Give configured eggs to a player's backpack";
	Group = "Admin";
	Args = {
		{
			Type = "player";
			Name = "Player";
			Description = "The player receiving the eggs";
		},
		{
			Type = "egg";
			Name = "EggID";
			Description = "The egg to give";
		},
		{
			Type = "integer";
			Name = "Amount";
			Description = "How many eggs to give (positive whole number)";
			Default = 1;
		},
	}
}
