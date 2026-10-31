return {
    Name = "removeLeaderboard";
    Aliases  = {"rlb"};
    Description = "Remove Player‘s Leaderboard";
    Group = "Admin";
    Args = {
        {
            Type = "number";
            Name = "Player Id";
            Description = "The player Id";
        },
    }
}