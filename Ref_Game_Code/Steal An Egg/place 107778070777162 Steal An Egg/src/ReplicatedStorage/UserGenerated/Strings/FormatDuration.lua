-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = { 0, 2, 2, 2 }

local function FormatDuration(p1) -- line: 22
    -- upvalues: t1 (copy)
    assert(type(p1) == "number")

    if p1 == 1e999 then
        return "Infinity"
    end

    if p1 ~= p1 then
        return "NaN"
    end

    local v3 = math.ceil((math.max(0, p1)))
    local v4 = v3 % 60
    local v5 = v3 // 60
    local v6 = v5 % 60
    local v7 = v5 // 60
    local v8 = v7 % 24
    local t2 = {
        v7 // 24,
        v8,
        v6,
        v4
    }
    local v9 = #t2

    for v10, v11 in ipairs(t2) do
        if v11 > 0 then
            v9 = v10
            break
        end
    end

    if v9 == #t2 then
        return tostring(v4) .. "s"
    end

    local t3 = {
        (tostring(t2[v9]))
    }

    for i = v9 + 1, #t2 do
        local v14 = tostring(t2[i])
        local v15 = t1[i]

        while #v14 < v15 do
            v14 = "0" .. v14
        end

        table.insert(t3, ":" .. v14)
    end

    return table.concat(t3)
end

return FormatDuration
