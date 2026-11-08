-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameFlags = require(ReplicatedStorage.Shared.Flags.GameFlags)
local t1 = {}

function t1.HasBloomUnlocked(p1, p2) -- line: 14
    -- upvalues: GameFlags (copy)
    if GameFlags.GreatBloomEnabled:Get() and p1 and p2 ~= nil then
        return p2.Sakura.Unlocked == true
    end

    return false
end

function t1.CanShowBloom(p3, p4, p5) -- line: 21
    -- upvalues: t1 (copy)
    return p3 and t1.HasBloomUnlocked(p4, p5)
end

return table.freeze(t1)
