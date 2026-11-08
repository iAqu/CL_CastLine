-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "halloween",
    Description = "Halloween dimension controls for this server; enable/disable apply everywhere.",
    Group = "Admin",
    Args = {
        {
            Type = "halloweenAction",
            Name = "Action",
            Description = "status, enable/disable (live event flag, every server), reset (rebuild the dimension), enter, leave, batch (respawn eggs), monsters (respawn monsters), event, tokens, buy (a Halloween Dimension Egg), progress, resetprogress, tutorial (show the dimension tutorial again on next entry)",
            Default = "status"
        },
        {
            Type = "string",
            Name = "Value",
            Description = "event: bloodmoon/pumpkin/none; tokens: amount",
            Optional = true
        }
    }
}
