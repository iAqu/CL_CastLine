return {
    Name = "adjustPlayerDiamond";
    Aliases  = {"aPD"};
    Description = "Adjust Player‘s Diamond";
    Group = "Admin";
    Args = {
        {
            Type = "player";
            Name = "Player";
            Description = "The player";
        },
        {
            Type = "number";
            Name = "Amount ofDiamond";
            Description = "The amount of Diamond you want to adjust of a player";
        }
    }
}