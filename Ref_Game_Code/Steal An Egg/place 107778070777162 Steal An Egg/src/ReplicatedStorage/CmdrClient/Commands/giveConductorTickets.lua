-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "giveConductorTickets",
    Description = "Give saved Conductor's Tickets for the Train Event prototype; does not unlock boarding.",
    Group = "Admin",
    Args = {
        {
            Type = "players",
            Name = "Player",
            Description = "Players to give tickets to."
        },
        {
            Type = "positiveInteger",
            Name = "Amount",
            Description = "How many tickets to give (limited by Game.TrainEvent.AdminTicketGrantMax).",
            Default = 1
        }
    }
}
