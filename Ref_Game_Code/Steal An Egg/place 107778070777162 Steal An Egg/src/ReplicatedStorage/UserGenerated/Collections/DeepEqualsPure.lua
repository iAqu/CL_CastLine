-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

function DeepEqualsPure(p1, p2, p3) -- line: 33
    if type(p1) == "table" and type(p2) == "table" then
        local v1 = p3 or {}

        if v1[p1] or v1[p2] then
            return false
        end

        if not rawequal(p1, p2) then
            if rawlen(p1) ~= rawlen(p2) or getmetatable(p1) ~= getmetatable(p2) then
                return false
            end

            v1[p1] = true
            v1[p2] = true

            for v2, v3 in next, p1 do
                local v4 = rawget(p2, v2)

                if v4 == nil or not DeepEqualsPure(v3, v4, v1) then
                    return false
                end
            end

            for v5, _ in next, p2 do
                if rawget(p1, v5) == nil then
                    return false
                end
            end

            v1[p1] = nil
            v1[p2] = nil
        end

        return true
    end

    if rawequal(p1, p2) then
        return true
    end

    return not (p1 == p1 or p2 == p2)
end

return DeepEqualsPure
