-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function FormatMultiplier(p1, p2) -- line: 20
    assert(type(p1) == "number")
    assert(p2 == nil or type(p2) == "number" and p2 >= 0 and math.floor(p2) == p2)

    if p1 ~= p1 then
        return "NaN"
    end

    if p1 == 1e999 then
        return "Infinity"
    end

    if p1 == (-1e999) then
        return "-Infinity"
    end

    p2 = p2 or 2

    if p2 > 0 then
        return string.format(("%%0.%*f"):format(p2), p1):gsub("(%d)%.?0+$", "%1")
    end

    return (tostring((math.round(p1))))
end

return FormatMultiplier
