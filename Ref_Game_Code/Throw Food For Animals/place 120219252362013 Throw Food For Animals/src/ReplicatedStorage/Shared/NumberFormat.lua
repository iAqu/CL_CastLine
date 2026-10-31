-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

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
    "Vg"
}
local t1 = {}

function t1.Abbreviate(p1, p2) -- line: 12
    -- upvalues: t2 (copy)
    p2 = p2 or 2

    if p1 ~= p1 then
        return "0"
    end

    local v2 = p1 < 0
    local v3 = math.abs(p1)
    local v4

    if v3 < 1000 then
        v4 = if not (v3 < 10) or v3 == math.floor(v3) then tostring((math.floor(v3 + 0.5))) else string.format("%.1f", v3)
    else
        local n1 = 1

        while v3 >= 1000 and n1 < #t2 do
            v3 /= 1000
            n1 += 1
        end

        local v7 = if v3 >= 100 then string.format("%." .. math.max(0, p2 - 2) .. "f", v3) elseif v3 >= 10 then string.format("%." .. math.max(0, p2 - 1) .. "f", v3) else string.format("%." .. p2 .. "f", v3)

        if v7:find("%.") then
            v7 = v7:gsub("0+$", ""):gsub("%.$", "")
        end

        v4 = v7 .. t2[n1]
    end

    return (if v2 then "-" else "") .. v4
end

function t1.Money(p3, p4) -- line: 47
    -- upvalues: t1 (copy)
    return "$" .. t1.Abbreviate(p3, p4)
end

function t1.PerSecond(p5) -- line: 51
    -- upvalues: t1 (copy)
    return "$" .. t1.Abbreviate(p5, 2) .. "/s"
end

function t1.OfBest(p6, p7) -- line: 63
    -- upvalues: t1 (copy)
    local v12 = tostring((math.floor((p6 or 0) * 100 + 0.5))) .. "%"

    if p7 == nil then
        return string.format("<font color=\"%s\">%s</font>", "#FFD84A", v12)
    end

    return string.format("<font color=\"%s\">%s(</font><font color=\"%s\">%s</font><font color=\"%s\">)</font>", "#FFD84A", v12, "#78E65A", t1.PerSecond(p7), "#FFD84A")
end

function t1.Comma(p8) -- line: 73
    local v15 = tostring((math.floor(p8 + 0.5))):reverse():gsub("(%d%d%d)", "%1,"):reverse()

    if v15:sub(1, 1) == "," then
        v15 = v15:sub(2)
    end

    return v15
end

function t1.Xp(p9) -- line: 81
    -- upvalues: t1 (copy)
    if p9 < 1E+05 then
        return t1.Comma(p9)
    end

    return t1.Abbreviate(p9, 2)
end

return t1
