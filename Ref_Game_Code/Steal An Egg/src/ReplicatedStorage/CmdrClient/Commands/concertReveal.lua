-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "concertReveal",
    Description = "Concert banner reveal: play (replay it on your screen), reset (forget you saw it), now (reveal this server in N seconds), clear (back to the real time), status.",
    Group = "Admin",
    Args = {
        {
            Type = "concertRevealAction",
            Name = "Action",
            Description = "play, reset, now, clear, status",
            Default = "play"
        },
        {
            Type = "number",
            Name = "Seconds",
            Description = "now: seconds until the reveal (default 5)",
            Optional = true
        }
    }
}
