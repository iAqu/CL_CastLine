-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

function DeepCopyPure(p1, p2) -- line: 31
    if type(p1) ~= "table" then
        return p1
    end

    assert(not getmetatable(p1))
    p2 = p2 or {}
    assert(not p2[p1])
    p2[p1] = true

    local t1 = {}

    for v4, v5 in next, p1 do
        t1[DeepCopyPure(v4, p2)] = DeepCopyPure(v5, p2)
    end

    p2[p1] = nil

    return t1
end

return DeepCopyPure
