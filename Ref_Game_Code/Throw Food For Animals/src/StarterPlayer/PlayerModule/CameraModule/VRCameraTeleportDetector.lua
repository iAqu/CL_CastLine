-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    JUMP_STUDS = 4,
    SETTLED_STUDS = 1,
    DEBOUNCE_SECONDS = 0.25
}

function t1.shouldRecenter(p1, p2, p3, p4) -- line: 29
    -- upvalues: t1 (copy)
    if p2 <= t1.JUMP_STUDS or p1 ~= nil and t1.SETTLED_STUDS <= p1 then
        return false
    end

    return not (p3 ~= nil and p4 - p3 < t1.DEBOUNCE_SECONDS)
end

return t1
