return {
    Name = "givePotion";
    Aliases  = {"gP"};
    Description = "Give a player a potion";
    Group = "Admin";
    Args = {
        {
            Type = "player";
            Name = "Player";
            Description = "The player";
        },
        {
            Type = "potion";
            Name = "PotionID";
            Description = "The potion you want to give to a player";
        },
        {
            Type = "number";
            Name = "Amount";
            Description = "The amount of potion you want to give to a player";
        }
    }
}