-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StableExp10 = require(ReplicatedStorage.UserGenerated.Math.StableExp10)

local function RoundFigures(p1, p2, p3, p4) -- line: 40
    -- upvalues: StableExp10 (copy)
    assert(type(p1) == "number")
    assert(p2 == nil or type(p2) == "number")
    assert(p3 == nil or type(p3) == "number")
    assert(p4 == nil or type(p4) == "function")

    local v5, v6, v7

    if p1 ~= p1 or p1 == 1e999 or p1 == (-1e999) then
        return p1
    else
        v5 = p2 or 3
        v6 = p3 or 1
        v7 = p4 or math.round
    end

    local v9 = math.sign(p1)

    if v9 == 0 then
        return 0
    end

    local v10 = p1 * v9
    local v12 = math.floor((math.log10(v10))) - v5 + 1

    if v6 ~= 1 then
        v10 /= v6
    end

    return StableExp10(v7((StableExp10(v10, -v12))) * v6, v12) * v9
end

return RoundFigures
