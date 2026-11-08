-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(game.ReplicatedStorage.UserGenerated.Randoms.Base)

local Xorshift128 = require(game.ReplicatedStorage.UserGenerated.Randoms.Xorshift128)
local t1 = {
    DefaultXorshift128 = Xorshift128.R,
    Xorshift128 = function(p1) -- Xorshift128 | line: 28
        -- upvalues: Xorshift128 (copy)
        return Xorshift128.new(p1)
    end,
    UniqueXorshift128 = function(p2) -- UniqueXorshift128 | line: 31
        -- upvalues: Xorshift128 (copy)
        return Xorshift128.Unique(p2)
    end
}

return table.freeze(t1)
