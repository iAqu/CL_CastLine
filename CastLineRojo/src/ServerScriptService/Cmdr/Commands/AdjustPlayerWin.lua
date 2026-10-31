return {
    Name = "adjustPlayerWin";
    Aliases  = {"aPW"};
    Description = "Adjust Player‘s Win";
    Group = "Admin";
    Args = {
        {
            Type = "player";
            Name = "Player";
            Description = "The player";
        },
        {
            Type = "number";
            Name = "Amount of Win";
            Description = "The amount of win you want to adjust of a player";
        }
    }
}