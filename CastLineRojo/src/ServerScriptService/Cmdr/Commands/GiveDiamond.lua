return {
    Name = "giveDiamond";
    Aliases  = {"gD"};
    Description = "Give Player Diamond";
    Group = "Admin";
    Args = {
        {
            Type = "player";
            Name = "Player";
            Description = "The player";
        },
        {
            Type = "number";
            Name = "Amount of Diamond";
            Description = "The amount of Diamond you want to give to a player";
        }
    }
}