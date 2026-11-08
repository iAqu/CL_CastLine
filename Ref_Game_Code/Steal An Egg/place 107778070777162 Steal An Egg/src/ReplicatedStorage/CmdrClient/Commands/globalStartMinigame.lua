-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "globalStartMinigame",
    Description = "Start an admin abuse minigame in all servers, or queue it behind each server's same minigame. Choose the egg it awards and its mutation.",
    Group = "Moderator",
    Args = {
        {
            Type = "minigameName",
            Name = "Minigame",
            Description = "Which minigame to start."
        },
        {
            Type = "assetDisplayName",
            Name = "Egg",
            Description = "The animal the minigame egg hatches into. Defaults to the minigame's own egg.",
            Optional = true
        },
        {
            Type = "mutation",
            Name = "Mutation",
            Description = "Mutation forced onto the minigame egg. None when omitted.",
            Optional = true
        }
    }
}
