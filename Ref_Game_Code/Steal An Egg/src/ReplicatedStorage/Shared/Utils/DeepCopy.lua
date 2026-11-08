-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function replicate(p1) -- line: 7
    local t1 = {}
    local t2 = {}

    local function shadow(p2) -- line: 11
        -- upvalues: t1 (copy), t2 (copy)
        if type(p2) ~= "table" then
            return p2
        end

        local v1 = t1[p2]

        if v1 == nil then
            v1 = {}
            t1[p2] = v1
            table.insert(t2, p2)
        end

        return v1
    end

    local v2 = p1

    if type(p1) == "table" then
        v2 = t1[p1]

        if v2 == nil then
            v2 = {}
            t1[p1] = v2
            table.insert(t2, p1)
        end
    end

    while #t2 > 0 do
        local v3 = table.remove(t2)
        local v4 = t1[v3]

        for v5, v6 in v3 do
            local v7 = v5

            if type(v5) == "table" then
                v7 = t1[v5]

                if v7 == nil then
                    v7 = {}
                    t1[v5] = v7
                    table.insert(t2, v5)
                end
            end

            local v8 = v6

            if type(v6) == "table" then
                v8 = t1[v6]

                if v8 == nil then
                    v8 = {}
                    t1[v6] = v8
                    table.insert(t2, v6)
                end
            end

            v4[v7] = v8
        end
    end

    return v2
end

return function(p3) -- line: 35
    -- upvalues: replicate (copy)
    if type(p3) == "table" then
        return (replicate(p3))
    end

    return p3
end
