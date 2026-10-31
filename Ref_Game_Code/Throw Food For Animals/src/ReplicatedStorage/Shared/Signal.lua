-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

t1.__index = t1

local t2 = {}

t2.__index = t2

function t2.new(p1, p2) -- line: 13
    -- upvalues: t2 (copy)
    return (setmetatable({
        Connected = true,
        _signal = p1,
        _fn = p2
    }, t2))
end

function t2.Disconnect(p3) -- line: 17
    if p3.Connected then
        p3.Connected = false

        local _connections = p3._signal._connections

        for i = #_connections, 1, -1 do
            if _connections[i] == p3 then
                table.remove(_connections, i)

                return
            end
        end
    end
end

function t1.new() -- line: 29
    -- upvalues: t1 (copy)
    return (setmetatable({
        _connections = {}
    }, t1))
end

function t1.Connect(p4, p5) -- line: 33
    -- upvalues: t2 (copy)
    local v1 = t2.new(p4, p5)

    table.insert(p4._connections, v1)

    return v1
end

function t1.Once(p6, p7) -- line: 39
    local connection

    connection = p6:Connect(function(...) -- line: 41
        -- upvalues: p7 (copy), connection (ref)
        connection:Disconnect()
        p7(...)
    end)

    return connection
end

function t1.Wait(p8) -- line: 48
    local thread = coroutine.running()
    local connection

    connection = p8:Connect(function(...) -- line: 51
        -- upvalues: thread (copy), connection (ref)
        connection:Disconnect()
        task.spawn(thread, ...)
    end)

    return coroutine.yield()
end

function t1.Fire(p9, ...) -- line: 58
    local v2 = table.clone(p9._connections)

    for _, v3 in ipairs(v2) do
        if v3.Connected then
            task.spawn(v3._fn, ...)
        end
    end
end

function t1.Destroy(p10) -- line: 67
    for _, v4 in ipairs(p10._connections) do
        v4.Connected = false
    end

    p10._connections = {}
end

return t1
