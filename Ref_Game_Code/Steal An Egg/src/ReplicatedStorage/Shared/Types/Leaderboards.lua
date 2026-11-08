-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.interface({
    UserId = t.number,
    Name = t.string,
    ValueText = t.string
})
local v2 = t.array(v1)

return {
    SchemaValidation = {
        Entry = v1,
        Leaderboard = v2,
        LeaderboardsByKey = t.map(t.string, v2)
    }
}
