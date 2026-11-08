-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function TrimmedNumberString(p1) -- line: 20
    assert(type(p1) == "number")

    if p1 ~= p1 then
        return "NaN"
    end

    if p1 == 1e999 then
        return "Infinity"
    end

    if p1 == (-1e999) then
        return "-Infinity"
    end

    local v2 = string.format("%f", p1)
    local v3, v4 = string.match(v2, "^([^%.]*)%.?(.*)$")

    assert(v3)

    if not v4 then
        return v3
    end

    local v5 = string.gsub(v4, "0+$", "")

    if #v5 == 0 then
        return v3
    end

    return (("%*.%*"):format(v3, v5))
end

return TrimmedNumberString
