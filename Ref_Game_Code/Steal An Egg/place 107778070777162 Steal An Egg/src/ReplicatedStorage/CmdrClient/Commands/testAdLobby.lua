-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "testAdLobby",
    Description = "Temporarily test expanded lobby with ad variants in a reserved server. Clear returns to normal matchmaking.",
    Group = "Admin",
    Aliases = { "rvTestLobby" },
    Args = {
        {
            Type = "string",
            Name = "Variant",
            Description = "Both (default), Cash, Eggs, Control, 1-4, or Clear.",
            Optional = true
        }
    }
}
