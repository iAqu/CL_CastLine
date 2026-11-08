-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function ErrorHandler(p1) -- line: 20
    warn((("%*\nStack Begin\n%*Stack End"):format(tostring(p1), (debug.traceback(nil, 3)))))
end

local function WCall(p2, ...) -- line: 24
    -- upvalues: ErrorHandler (copy)
    return xpcall(p2, ErrorHandler, ...)
end

return WCall
