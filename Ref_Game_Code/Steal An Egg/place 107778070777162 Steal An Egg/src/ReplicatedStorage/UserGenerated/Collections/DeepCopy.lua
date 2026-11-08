-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

function DeepCopyWithMetatables(p1, p2) -- line: 33
    if type(p1) ~= "table" then
        return p1
    end

    p2 = p2 or {}

    local v2 = p2[p1]

    if v2 then
        return v2
    end

    local t1 = {}

    p2[p1] = t1

    for v3, v4 in next, p1 do
        t1[DeepCopyWithMetatables(v3, p2)] = DeepCopyWithMetatables(v4, p2)
    end

    local mt = getmetatable(p1)

    if mt then
        setmetatable(t1, mt)
    end

    return t1
end

return DeepCopyWithMetatables
