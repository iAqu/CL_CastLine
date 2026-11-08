-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return ((function()
    local DeepEquals

    function DeepEquals(p1, p2, p3) -- line: 31
        -- upvalues: DeepEquals (ref)
        if rawequal(p1, p2) then
            return true
        end

        if type(p1) ~= "table" or type(p2) ~= "table" then
            return not (p1 == p1 or p2 == p2)
        end

        if rawlen(p1) ~= rawlen(p2) then
            return false
        end

        local mt = getmetatable(p1)

        if mt ~= getmetatable(p2) then
            return false
        end

        if mt ~= nil and mt.__eq then
            return p1 == p2
        end

        p3 = p3 or {}
        p3[p1] = p3[p1] or {}
        p3[p2] = p3[p2] or {}

        if not p3[p1][p2] then
            p3[p1][p2] = true
            p3[p2][p1] = true

            for v3, v4 in next, p1 do
                local v5 = rawget(p2, v3)

                if v5 == nil or not DeepEquals(v4, v5, p3) then
                    return false
                end
            end

            for v6, _ in next, p2 do
                if rawget(p1, v6) == nil then
                    return false
                end
            end
        end

        return true
    end

    return DeepEquals
end)())
