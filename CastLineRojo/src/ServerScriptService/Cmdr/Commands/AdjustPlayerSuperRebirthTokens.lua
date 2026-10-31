return {
    Name = "adjustPlayerSuperRebirthTokens";
    Aliases  = {"aPSRT"};
    Description = "Adjust Player‘s Super Rebirth Tokens";
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
            Name = "Amount of Super Rebirth Tokens";
            Description = "The amount of token you want to adjust of a player";
            -- Optional = true;
        }
    }
}