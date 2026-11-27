-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Zones = require(script.Parent:WaitForChild("Zones"))
local t1 = {
    BORDER = 40,
    MIN = 60
}
local DEPTH = Zones.DEPTH
local v1 = #Zones.NAMES

function t1.Band(p1) -- line: 16
    -- upvalues: t1 (copy), DEPTH (copy), v1 (copy)
    local v2 = math.clamp(p1, 1, v1)
    local v3 = (v2 - 1) * DEPTH + t1.BORDER
    local v4 = v2 * DEPTH - t1.BORDER

    if v2 == 1 then
        v3 = t1.MIN
    end

    if v2 == v1 then
        v4 = v1 * DEPTH
    end

    return v3, v4
end

function t1.Snap(p2) -- line: 24
    -- upvalues: t1 (copy), v1 (copy)
    for i = 1, v1 - 1 do
        local _, v5 = t1.Band(i)
        local v6 = t1.Band(i + 1)

        if v5 < p2 and p2 < v6 then
            return p2 - v5 <= v6 - p2 and v5 or v6
        end
    end

    return p2
end

return t1
