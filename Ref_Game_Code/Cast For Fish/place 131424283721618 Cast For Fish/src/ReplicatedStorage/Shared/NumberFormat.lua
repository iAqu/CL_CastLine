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
    "Dc",
    "Ud",
    "Dd",
    "Td",
    "Qad",
    "Qid",
    "Sxd",
    "Spd",
    "Ocd",
    "Nod",
    "Vg",
    "Uvg",
    "Dvg",
    "Tvg",
    "Qavg",
    "Qivg"
}

local function trimZeros(p1) -- line: 6
    if not string.find(p1, ".", 1, true) then
        return p1
    end

    local v1 = string.gsub(p1, "0+$", "")

    return (string.gsub(v1, "%.$", ""))
end

function t1.abbr(p2) -- line: 15
    -- upvalues: t2 (copy)
    local v2

    if p2 ~= p2 or p2 == nil then
        return "0"
    else
        v2 = p2 < 0
    end

    local v4 = math.abs(p2)
    local v5

    if v4 < 1000 then
        if not (v4 < 10) or v4 % 1 == 0 then
            v5 = tostring((math.floor(v4 + 1E-06)))
        else
            v5 = string.format("%.1f", math.floor(v4 * 10 + 1E-06) / 10)

            if string.find(v5, ".", 1, true) then
                local v9 = string.gsub(v5, "0+$", "")

                v5 = string.gsub(v9, "%.$", "")
            end
        end
    else
        local v13 = math.min(math.floor(math.log10(v4) / 3 + 1E-09), #t2 - 1)
        local v14 = v4 / 1000 ^ v13

        if v14 >= 1000 then
            v5 = string.format("%.2e", v4)
        else
            local v15 = if v14 < 10 then 2 elseif v14 < 100 then 1 else 0
            local v16 = 10 ^ v15
            local v18 = math.floor(v14 * v16 + 1E-06) / v16
            local v19 = string.format("%." .. v15 .. "f", v18)

            if string.find(v19, ".", 1, true) then
                local v20 = string.gsub(v19, "0+$", "")

                v19 = string.gsub(v20, "%.$", "")
            end

            v5 = v19 .. t2[v13 + 1]
        end
    end

    if v2 then
        return "-" .. v5
    end

    return v5
end

function t1.commas(p3) -- line: 43
    local v23 = tostring((math.floor(math.abs(p3) + 0.5)))

    repeat
        local v24

        v23, v24 = string.gsub(v23, "^(%d+)(%d%d%d)", "%1,%2")
    until v24 == 0

    if p3 < 0 then
        return "-" .. v23
    end

    return v23
end

function t1.money(p4) -- line: 56
    -- upvalues: t1 (copy)
    return "$" .. t1.abbr(p4)
end

function t1.rate(p5) -- line: 60
    -- upvalues: t1 (copy)
    return "$" .. t1.abbr(p5) .. "/s"
end

function t1.odds(p6) -- line: 65
    -- upvalues: t1 (copy)
    local v25 = math.max(1, p6)

    if v25 < 1E+09 then
        return "1 in " .. t1.commas(v25)
    end

    return "1 in " .. t1.abbr(v25)
end

function t1.luck(p7) -- line: 73
    return string.format("%.2fX", p7)
end

function t1.weight(p8) -- line: 77
    -- upvalues: t1 (copy)
    if p8 >= 1000 then
        return t1.abbr(p8) .. " kg"
    end

    local v26 = string.format("%.1f", p8)

    if string.find(v26, ".", 1, true) then
        local v27 = string.gsub(v26, "0+$", "")

        v26 = string.gsub(v27, "%.$", "")
    end

    return v26 .. " kg"
end

return t1
