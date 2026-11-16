return {
	Name = "givePet";
	Description = "Give configured pets to a player";
	Group = "Admin";
	Args = {
		{
			Type = "player";
			Name = "Player";
			Description = "The player receiving the pets";
		},
		{
			Type = "pet";
			Name = "PetID";
			Description = "The pet to give";
		},
		{
			Type = "integer";
			Name = "Amount";
			Description = "How many pets to give (positive whole number)";
			Default = 1;
		},
	}
}
