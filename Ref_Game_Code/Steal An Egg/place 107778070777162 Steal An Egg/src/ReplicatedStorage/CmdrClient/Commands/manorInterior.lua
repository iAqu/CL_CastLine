-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "manorInterior",
    Description = "Manor interior test tools. enter: play the door transition into the manor from anywhere. exit: leave through the front door to the realm. status: interior, doors, exit marker, key and gate state.",
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
