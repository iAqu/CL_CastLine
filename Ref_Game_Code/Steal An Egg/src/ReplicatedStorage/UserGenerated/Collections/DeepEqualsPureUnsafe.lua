-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

function DeepEqualsPureUnsafe(p1, p2) -- line: 33
    if rawequal(p1, p2) then
        return true
    end

    if type(p1) ~= "table" or type(p2) ~= "table" then
        return not (p1 == p1 or p2 == p2)
    end

    if rawlen(p1) ~= rawlen(p2) or getmetatable(p1) ~= getmetatable(p2) then
        return false
    end

    for v1, v2 in next, p1 do
        local v3 = rawget(p2, v1)

        if v3 == nil or not DeepEqualsPureUnsafe(v2, v3) then
            return false
        end
    end

    for v4, _ in next, p2 do
        if rawget(p1, v4) == nil then
            return false
        end
    end

    return true
end

return DeepEqualsPureUnsafe
