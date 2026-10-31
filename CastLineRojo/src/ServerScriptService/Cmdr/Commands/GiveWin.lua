return {
    Name = "giveWin";
    Aliases  = {"gW"};
    Description = "Give Player Win";
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
            Description = "The amount of win you want to give to a player";
        }
    }
}