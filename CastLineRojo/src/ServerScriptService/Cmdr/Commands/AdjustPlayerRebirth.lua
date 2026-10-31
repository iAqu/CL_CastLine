return {
    Name = "adjustPlayerRebirth";
    Aliases  = {"aPR"};
    Description = "Adjust Player‘s Rebirth";
    Group = "Admin";
    Args = {
        {
            Type = "player";
            Name = "Player";
            Description = "The player";
        },
        {
            Type = "number";
            Name = "Amount of Rebirth";
            Description = "The amount of Rebirth you want to adjust of a player";
        }
    }
}