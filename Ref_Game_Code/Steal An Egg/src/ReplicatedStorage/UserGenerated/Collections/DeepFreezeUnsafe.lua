-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

function DeepFreezeUnsafe(p1) -- line: 31
    if type(p1) ~= "table" then
        return p1
    end

    if not table.isfrozen(p1) then
        table.freeze(p1)
    end

    for v1, v2 in next, p1 do
        DeepFreezeUnsafe(v1)
        DeepFreezeUnsafe(v2)
    end

    return p1
end

return DeepFreezeUnsafe
