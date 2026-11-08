-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "globalShootingStar",
    Description = "Drop a shooting star in every server now",
    Group = "Admin",
    Args = {
        {
            Type = "boolean",
            Name = "Everyone",
            Description = "true: everyone in each server can claim it (default). false: only players present since that server's day began",
            Optional = true
        }
    }
}
