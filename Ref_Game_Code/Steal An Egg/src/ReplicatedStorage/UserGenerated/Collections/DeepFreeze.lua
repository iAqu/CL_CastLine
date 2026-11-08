-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

function DeepFreeze(p1, p2) -- line: 32
    if type(p1) ~= "table" then
        return p1
    end

    if not table.isfrozen(p1) then
        table.freeze(p1)
    end

    p2 = p2 or {}

    if not p2[p1] then
        p2[p1] = true

        for v2, v3 in next, p1 do
            DeepFreeze(v2, p2)
            DeepFreeze(v3, p2)
        end

        p2[p1] = nil
    end

    return p1
end

return DeepFreeze
