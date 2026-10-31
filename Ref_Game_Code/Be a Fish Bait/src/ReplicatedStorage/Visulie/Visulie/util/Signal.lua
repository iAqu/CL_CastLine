-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1

local function acquireRunnerThreadAndCallEventHandler(p1, ...) -- line: 16
    -- upvalues: v1 (ref)
    local v2 = v1

    v1 = nil
    p1(...)
    v1 = v2
end

local function runEventHandlerInFreeThread() -- line: 27
    -- upvalues: acquireRunnerThreadAndCallEventHandler (copy)
    while true do
        acquireRunnerThreadAndCallEventHandler(coroutine.yield())
    end
end

local t1 = {}

t1.__index = t1

function t1.new(p2, p3) -- line: 51
    -- upvalues: t1 (copy)
    return (setmetatable({
        _Connected = true,
        _Next = false,
        _Signal = p2,
        _Callback = p3
    }, t1))
end

function t1.Disconnect(p4) -- line: 59
    p4._Connected = false

    if p4._Signal._HandlerListHead == p4 then
        p4._Signal._HandlerListHead = p4._Next
    else
        local v3 = p4._Signal._HandlerListHead

        while v3 and v3._Next ~= p4 do
            v3 = v3._Next
        end

        if v3 then
            v3._Next = p4._Next
        end
    end
end

local t3 = {}

t3.__index = t3

function t3.new() -- line: 94
    -- upvalues: t3 (copy)
    return (setmetatable({
        _HandlerListHead = false,
        _Destroyed = false
    }, t3))
end

function t3.Connect(p5, p6) -- line: 100
    -- upvalues: t1 (copy)
    if p5._Destroyed then
        error("Cannot connect to a destroyed signal")
    end

    local v4 = t1.new(p5, p6)

    if p5._HandlerListHead then
        v4._Next = p5._HandlerListHead
    end

    p5._HandlerListHead = v4

    return v4
end

function t3.Fire(p7, ...) -- line: 113
    -- upvalues: v1 (ref), runEventHandlerInFreeThread (copy)
    local v5 = p7._HandlerListHead

    while v5 do
        if v5._Connected then
            if not v1 then
                v1 = coroutine.create(runEventHandlerInFreeThread)
                coroutine.resume(v1)
            end

            task.spawn(v1, v5._Callback, ...)
        end

        v5 = v5._Next
    end
end

function t3.FireDeferred(p8, ...) -- line: 127
    task.defer(function(p9, ...) -- line: 128
        p9:Fire(...)
    end, p8, ...)
end

function t3.Wait(p10) -- line: 132
    local thread = coroutine.running()
    local connection

    connection = p10:Connect(function(...) -- line: 135
        -- upvalues: thread (copy), connection (ref)
        connection:Disconnect()
        task.spawn(thread, ...)
    end)

    return coroutine.yield()
end

function t3.Once(p11, p12) -- line: 141
    local connection

    connection = p11:Connect(function(...) -- line: 143
        -- upvalues: p12 (copy), connection (ref)
        if connection._Connected then
            connection:Disconnect()
        end

        p12(...)
    end)

    return connection
end

function t3.DisconnectAll(p13) -- line: 151
    p13._HandlerListHead = false
end

function t3.Destroy(p14) -- line: 154
    p14._HandlerListHead = false
    p14._Destroyed = true
end

return t3
