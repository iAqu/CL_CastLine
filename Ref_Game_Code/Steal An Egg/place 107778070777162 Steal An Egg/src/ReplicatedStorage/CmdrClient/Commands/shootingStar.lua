-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "shootingStar",
    Description = "Drop a shooting star in this server now",
    Group = "Moderator",
    Args = {
        {
            Type = "boolean",
            Name = "Everyone",
            Description = "true: everyone here can claim it (default). false: only players present since this day began",
            Optional = true
        }
    }
}
