-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local t1 = {
    State = t.strictInterface({
        Met = t.boolean,
        KeyClaimed = t.boolean,
        GateUnlocked = t.boolean
    }),
    Blank = function() -- Blank | line: 14
        return {
            Met = false,
            KeyClaimed = false,
            GateUnlocked = false
        }
    end
}

return table.freeze(t1)
