-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function onError(p1) -- line: 3
    return debug.traceback(tostring(p1), 2)
end

return function(p2, ...) -- line: 7
    -- upvalues: onError (copy)
    local v1 = table.pack(xpcall(p2, onError, ...))

    if v1[1] then
        return true, table.unpack(v1, 2, v1.n)
    end

    warn("protected call failed: " .. tostring(v1[2]))

    return false, v1[2]
end
