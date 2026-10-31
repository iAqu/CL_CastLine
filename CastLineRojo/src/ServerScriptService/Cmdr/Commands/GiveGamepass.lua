return {
    Name = "giveGamepass";
    Aliases  = {"gGP"};
    Description = "Give a player a gamepass";
    Group = "Admin";
    Args = {
        {
            Type = "player";
            Name = "Player";
            Description = "The player";
        },
        {
            Type = "gamepass";
            Name = "GamepassID";
            Description = "The gamepass you want to give to a player";
        }
    }
}