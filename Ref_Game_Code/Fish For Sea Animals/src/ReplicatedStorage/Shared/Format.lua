-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}
local t2 = {
    "",
    "K",
    "M",
    "B",
    "T",
    "Qa",
    "Qi",
    "Sx",
    "Sp",
    "Oc",
    "No",
    "De"
}

local function trim(p1) -- line: 5
    if p1:find("%.") then
        return (p1:gsub("0+$", ""):gsub("%.$", ""))
    end

    return p1
end

function t1.short(p2) -- line: 14
    -- upvalues: t2 (copy)
    local v1 = tonumber(p2) or 0
    local v2 = if v1 < 0 then "-" else ""
    local v3 = math.abs(v1)

    if v3 < 1000 then
        local v5 = string.format("%.1f", math.floor(v3 * 10) / 10)

        if v5:find("%.") then
            v5 = v5:gsub("0+$", ""):gsub("%.$", "")
        end

        return v2 .. v5
    end

    local n1 = 1

    while v3 >= 1000 and n1 < #t2 do
        v3 /= 1000
        n1 += 1
    end

    local v6

    if v3 >= 100 then
        v6 = tostring((math.floor(v3)))
    else
        v6 = if v3 >= 10 then string.format("%.1f", math.floor(v3 * 10) / 10) else string.format("%.2f", math.floor(v3 * 100) / 100)

        if v6:find("%.") then
            v6 = v6:gsub("0+$", ""):gsub("%.$", "")
        end
    end

    return v2 .. v6 .. t2[n1]
end

function t1.money(p3) -- line: 37
    -- upvalues: t1 (copy)
    return "$" .. t1.short(p3)
end

return t1
