-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1

local function acquireRunnerThreadAndCallEventHandler(p1, ...) -- line: 45
    -- upvalues: v1 (ref)
    local v2 = v1

    v1 = nil
    p1(...)
    v1 = v2
end

local function runEventHandlerInFreeThread(...) -- line: 56
    -- upvalues: acquireRunnerThreadAndCallEventHandler (copy)
    acquireRunnerThreadAndCallEventHandler(...)

    while true do
        acquireRunnerThreadAndCallEventHandler(coroutine.yield())
    end
end

local t1 = {}

t1.__index = t1

function t1.Disconnect(p2) -- line: 82
    if p2.Connected then
        p2.Connected = false

        if p2._signal._handlerListHead == p2 then
            p2._signal._handlerListHead = p2._next
        else
            local v3 = p2._signal._handlerListHead

            while v3 and v3._next ~= p2 do
                v3 = v3._next
            end

            if v3 then
                v3._next = p2._next
            end
        end
    end
end

t1.Destroy = t1.Disconnect
setmetatable(t1, {
    __index = function(_, p4) -- __index | line: 109
        error(("Attempt to get Connection::%s (not a valid member)"):format((tostring(p4))), 2)
    end,
    __newindex = function(_, p6, _) -- __newindex | line: 112
        error(("Attempt to set Connection::%s (not a valid member)"):format((tostring(p6))), 2)
    end
})

local t3 = {}

t3.__index = t3

function t3.new() -- line: 154
    -- upvalues: t3 (copy)
    return (setmetatable({
        _handlerListHead = false,
        _proxyHandler = nil,
        _yieldedThreads = nil
    }, t3))
end

function t3.Wrap(p8) -- line: 177
    -- upvalues: t3 (copy)
    assert(typeof(p8) == "RBXScriptSignal", "Argument #1 to Signal.Wrap must be a RBXScriptSignal; got " .. typeof(p8))

    local v6 = t3.new()

    v6._proxyHandler = p8:Connect(function(...) -- line: 184
        -- upvalues: v6 (copy)
        v6:Fire(...)
    end)

    return v6
end

function t3.Is(p9) -- line: 197
    -- upvalues: t3 (copy)
    if type(p9) == "table" then
        return getmetatable(p9) == t3
    end

    return false
end

function t3.Connect(p10, p11) -- line: 214
    -- upvalues: t1 (copy)
    local v7 = setmetatable({
        Connected = true,
        _next = false,
        _signal = p10,
        _fn = p11
    }, t1)

    if p10._handlerListHead then
        v7._next = p10._handlerListHead
    end

    p10._handlerListHead = v7

    return v7
end

function t3.ConnectOnce(p12, p13) -- line: 237
    return p12:Once(p13)
end

function t3.Once(p14, p15) -- line: 256
    local connection
    local v8 = false

    connection = p14:Connect(function(...) -- line: 260
        -- upvalues: p15 (copy), connection (ref), v8 (ref)
        if v8 then
            return
        end

        v8 = true
        connection:Disconnect()
        p15(...)
    end)

    return connection
end

function t3.GetConnections(p16) -- line: 273
    local t6 = {}
    local v9 = p16._handlerListHead

    while v9 do
        table.insert(t6, v9)
        v9 = v9._next
    end

    return t6
end

function t3.DisconnectAll(p17) -- line: 293
    local v10 = p17._handlerListHead

    while v10 do
        v10.Connected = false
        v10 = v10._next
    end

    p17._handlerListHead = false

    local _yieldedThreads = rawget(p17, "_yieldedThreads")

    if _yieldedThreads then
        for v11 in _yieldedThreads do
            if coroutine.status(v11) == "suspended" then
                warn(debug.traceback(v11, "signal disconnected; yielded thread cancelled", 2))
                task.cancel(v11)
            end
        end

        table.clear(p17._yieldedThreads)
    end
end

function t3.Fire(p18, ...) -- line: 328
    -- upvalues: v1 (ref), runEventHandlerInFreeThread (copy)
    local v12 = p18._handlerListHead

    while v12 do
        if v12.Connected then
            v1 = v1 or coroutine.create(runEventHandlerInFreeThread)
            task.spawn(v1, v12._fn, ...)
        end

        v12 = v12._next
    end
end

function t3.FireDeferred(p19, ...) -- line: 349
    local v13 = p19._handlerListHead

    while v13 do
        local defer = task.defer
        local v14 = v13

        defer(function(...) -- line: 353
            -- upvalues: v14 (copy)
            if v14.Connected then
                v14._fn(...)
            end
        end, ...)
        v13 = v13._next
    end
end

function t3.Wait(p20) -- line: 377
    local _yieldedThreads = rawget(p20, "_yieldedThreads")

    if not _yieldedThreads then
        _yieldedThreads = {}
        rawset(p20, "_yieldedThreads", _yieldedThreads)
    end

    local thread = coroutine.running()

    _yieldedThreads[thread] = true
    p20:Once(function(...) -- line: 387
        -- upvalues: _yieldedThreads (ref), thread (copy)
        _yieldedThreads[thread] = nil

        if coroutine.status(thread) == "suspended" then
            task.spawn(thread, ...)
        end
    end)

    return coroutine.yield()
end

function t3.Destroy(p21) -- line: 410
    p21:DisconnectAll()

    local _proxyHandler = rawget(p21, "_proxyHandler")

    if _proxyHandler then
        _proxyHandler:Disconnect()
    end
end

setmetatable(t3, {
    __index = function(_, p23) -- __index | line: 421
        error(("Attempt to get Signal::%s (not a valid member)"):format((tostring(p23))), 2)
    end,
    __newindex = function(_, p25, _) -- __newindex | line: 424
        error(("Attempt to set Signal::%s (not a valid member)"):format((tostring(p25))), 2)
    end
})

return table.freeze({
    new = t3.new,
    Wrap = t3.Wrap,
    Is = t3.Is
})
