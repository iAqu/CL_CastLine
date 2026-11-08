-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "flash-id",
    Description = "Flashes every player's own user id on their screen, in every server. Defaults to above the hotbar.",
    Group = "Admin",
    Args = {
        {
            Type = "flashPosition",
            Name = "Position",
            Description = "Where it shows: bottom (above the hotbar), top, center, left or right",
            Optional = true
        }
    }
}
