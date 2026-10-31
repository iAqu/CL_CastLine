return {
    Name = "setMoveSpeedLevel";
    Aliases = { "sMSL" };
    Description = "Set a player's move speed upgrade level";
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
            Description = "The non-negative move speed upgrade level";
        },
    };
}
