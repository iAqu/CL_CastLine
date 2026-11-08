-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.strictInterface({
    TransactionId = t.string,
    EggUid = t.string,
    CompletedAt = t.number
})
local t1 = {
    State = t.map(t.string, t.union(t.literal(false), v1)),
    Blank = function() -- Blank | line: 17
        return {
            Divine = false,
            Eternal = false
        }
    end
}

return table.freeze(t1)
