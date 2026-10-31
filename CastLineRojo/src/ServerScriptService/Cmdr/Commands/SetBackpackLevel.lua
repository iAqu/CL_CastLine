return {
    Name = "setBackpackLevel";
    Aliases = { "sBL" };
    Description = "Set a player's backpack carry-weight upgrade level";
    Group = "Admin";
    Args = {
        {
            Type = "player";
            Name = "Player";
            Description = "The player";
        },
        {
            Type = "integer";
            Name = "Level";
            Description = "The non-negative backpack upgrade level";
        },
    };
}
