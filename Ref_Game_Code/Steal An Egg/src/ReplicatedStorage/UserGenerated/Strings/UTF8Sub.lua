-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function UTF8Sub(p1, p2, p3) -- line: 20
    p3 = p3 or -1

    local v2 = utf8.offset(p1, p2)

    if not v2 then
        if p2 > 0 then
            return ""
        end

        v2 = 1
    end

    local v3

    if p3 == -1 then
        v3 = #p1
    else
        local v4 = utf8.offset(p1, p3 + 1)

        v3 = if v4 then v4 - 1 elseif p3 < 0 then 0 else #p1
    end

    return (string.sub(p1, v2, v3))
end

return UTF8Sub
