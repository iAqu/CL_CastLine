-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "trainEvent",
    Description = "Studio/DEV/Testing Train Event journey review: start, station, depart, return, expire, stop, status, hunt, rewardson, rewardsoff.",
    Group = "Admin",
    Args = {
        {
            Type = "string",
            Name = "Action",
            Description = "start / station / depart / return / expire / stop / status / hunt / rewardson / rewardsoff",
            Default = "start"
        },
        {
            Type = "positiveInteger",
            Name = "Seconds",
            Description = "Boarding window for start (1..600); defaults to the TrainEvent FastFlag.",
            Optional = true
        }
    }
}
