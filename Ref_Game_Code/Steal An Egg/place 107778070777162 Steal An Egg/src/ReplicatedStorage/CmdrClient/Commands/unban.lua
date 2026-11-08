-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "unban",
    Description = "Lift a ban placed with the ban command or the creator dashboard.",
    Group = "Admin",
    Args = {
        {
            Type = "banTargets",
            Name = "Players",
            Description = "Who to unban: a username, or #userid."
        }
    }
}
