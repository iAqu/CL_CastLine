-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Finally = require(game.ReplicatedStorage.UserGenerated.Lang.Finally)
local t1 = {}

function t1.Call(p1, p2, ...) -- line: 40
    -- upvalues: Finally (copy)
    assert(type(p2) == "function")

    while p1.Count > 0 do
        task.wait()
    end

    p1.Count += 1

    return Finally(p2, function() -- line: 47
        -- upvalues: p1 (copy)
        p1.Count -= 1
    end, ...)
end

function t1.Try(p3, p4, ...) -- line: 52
    -- upvalues: Finally (copy)
    assert(type(p4) == "function")

    if p3.Count > 0 then
        return false
    end

    p3.Count += 1

    return true, Finally(p4, function() -- line: 59
        -- upvalues: p3 (copy)
        p3.Count -= 1
    end, ...)
end

function t1.IsLocked(p5) -- line: 64
    return p5.Count > 0
end

local v3 = table.freeze({
    __index = table.freeze(t1)
})
local t2 = {
    new = function() -- new | line: 73
        -- upvalues: v3 (copy)
        return (setmetatable({
            Count = 0
        }, v3))
    end
}

return table.freeze(t2)
