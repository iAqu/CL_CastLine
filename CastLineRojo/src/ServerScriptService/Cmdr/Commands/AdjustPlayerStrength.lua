return {
    Name = "adjustPlayerStrength";
    Aliases  = {"aPS"};
    Description = "Adjust Player‘s Strength";
    Group = "Admin";
    Args = {
        {
            Type = "player";
            Name = "Player";
            Description = "The player";
            -- Optional = true;
        },
        {
            Type = "number";
            Name = "Amount of Strength";
            Description = "The amount of strength you want to adjust of a player";
            -- Optional = true;
        }
    }
}