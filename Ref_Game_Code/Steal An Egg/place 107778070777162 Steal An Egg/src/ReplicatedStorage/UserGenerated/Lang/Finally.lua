-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function ErrorHandler(p1) -- line: 20
    warn((("%*\nStack Begin\n%*Stack End"):format(tostring(p1), (debug.traceback(nil, 3)))))
end

local function Handle(p2, p3, ...) -- line: 24
    -- upvalues: ErrorHandler (copy)
    xpcall(p2, ErrorHandler)

    if not p3 then
        error((select(1, ...)))
    end

    return ...
end

local function Finally(p4, p5, ...) -- line: 32
    -- upvalues: ErrorHandler (copy), Handle (copy)
    return Handle(p5, xpcall(p4, ErrorHandler, ...))
end

return Finally
