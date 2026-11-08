-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "onboardingQuestline",
    Description = "Drives the onboarding questline A/B feature for testing.",
    Group = "Admin",
    Aliases = { "" },
    Args = {
        {
            Type = "players",
            Name = "Players",
            Description = "The players to act on."
        },
        {
            Type = "string",
            Name = "Action",
            Description = "enroll | reset | fill | completeSet | expire | status"
        }
    }
}
