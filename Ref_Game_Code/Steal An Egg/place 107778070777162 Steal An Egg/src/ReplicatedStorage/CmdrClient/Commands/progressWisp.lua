-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "progressWisp",
    Description = "Add progress to the current Wisp quest. Complete quests must still be claimed in the Wisp menu.",
    Group = "Admin",
    Aliases = { "wispProgress" },
    Args = {
        {
            Type = "players",
            Name = "Players",
            Description = "The players whose current Wisp quest to progress."
        },
        {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "Progress to add, capped at the current quest goal. Defaults to 1.",
            Optional = true,
            Default = 1
        }
    }
}
