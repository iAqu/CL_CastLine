-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "afkTestGroup",
    Description = "Forces the AFK treadmill A/B test group. Applies on next join or server hop.",
    Group = "Admin",
    Aliases = { "" },
    Args = {
        {
            Type = "players",
            Name = "Player",
            Description = "The players whose group to set."
        },
        {
            Type = "string",
            Name = "Group",
            Description = "Control, Variant, or Clear to return to normal enrollment."
        }
    }
}
