-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local t1 = {
    State = t.strictInterface({
        Solved = t.boolean,
        Claimed = t.boolean
    }),
    Blank = function() -- Blank | line: 13
        return {
            Solved = false,
            Claimed = false
        }
    end
}

return table.freeze(t1)
