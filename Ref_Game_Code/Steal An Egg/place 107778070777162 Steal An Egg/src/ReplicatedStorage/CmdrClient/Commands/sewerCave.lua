-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "sewerCave",
    Description = "Sewer cave test tools. enter: play the whirlpool transition into the cave from anywhere. exit: leave through the pipe to the manor. status: where the cave, whirlpool and exit marker are at.",
    Group = "Admin",
    Args = {
        {
            Type = "string",
            Name = "Action",
            Description = "enter, exit or status",
            Default = "status"
        },
        {
            Type = "players",
            Name = "Players",
            Description = "Players to move. Defaults to you.",
            Optional = true
        }
    }
}
