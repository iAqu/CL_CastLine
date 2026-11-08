-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.intersection(t.integer, t.numberMin(0))
local t1 = {
    Counts = t.strictInterface({
        Green = v1,
        Blue = v1,
        Purple = v1,
        Golden = v1
    })
}

t1.State = t.strictInterface({
    NetClaimed = t.boolean,
    Counts = t1.Counts,
    Essence = v1,
    TotalCaught = v1
})

function t1.Blank() -- line: 39
    return {
        NetClaimed = false,
        Essence = 0,
        TotalCaught = 0,
        Counts = {
            Green = 0,
            Blue = 0,
            Purple = 0,
            Golden = 0
        }
    }
end

return table.freeze(t1)
