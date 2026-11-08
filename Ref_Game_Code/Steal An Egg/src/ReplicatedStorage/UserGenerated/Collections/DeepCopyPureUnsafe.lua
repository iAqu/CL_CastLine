-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

function DeepCopyPureUnsafe(p1) -- line: 31
    if type(p1) ~= "table" then
        return p1
    end

    local t1 = {}

    for v1, v2 in next, p1 do
        t1[DeepCopyPureUnsafe(v1)] = DeepCopyPureUnsafe(v2)
    end

    return t1
end

return DeepCopyPureUnsafe
