-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "giveSouls",
    Description = "Give saved Souls for the Train Event Soul Keeper.",
    Group = "Admin",
    Args = {
        {
            Type = "players",
            Name = "Player",
            Description = "Players receiving Souls."
        },
        {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "Souls to grant (Game.TrainEvent.AdminSoulGrantMax).",
            Default = 1000
        }
    }
}
