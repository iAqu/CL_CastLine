return {
    Name = "adjustPlayerTrophy";
    Aliases  = {"aPT"};
    Description = "Adjust Player‘s Trophy";
    Group = "Admin";
    Args = {
        {
            Type = "player";
            Name = "Player";
            Description = "The player";
        },
        {
            Type = "number";
            Name = "Amount of Trophy";
            Description = "The amount of trophy you want to adjust of a player";
        }
    }
}