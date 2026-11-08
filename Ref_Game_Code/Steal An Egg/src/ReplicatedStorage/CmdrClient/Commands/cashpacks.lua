-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "cashpacks",
    Description = "Test-place cash-pack QA: save a cohort across rejoins, use placed pets or simulated income, advance a day, or clear the override.",
    Group = "Admin",
    Args = {
        {
            Type = "string",
            Name = "Context",
            Description = "status, control, a, b, peak, day, live, reset",
            Default = "status"
        },
        {
            Type = "player",
            Name = "Player",
            Description = "Player to test; defaults to you.",
            Optional = true
        },
        {
            Type = "number",
            Name = "Income",
            Description = "Optional simulated cash/second for control/a/b/peak, e.g. 7e9. Omit for placed-pet income; live returns to placed-pet income.",
            Optional = true
        }
    }
}
