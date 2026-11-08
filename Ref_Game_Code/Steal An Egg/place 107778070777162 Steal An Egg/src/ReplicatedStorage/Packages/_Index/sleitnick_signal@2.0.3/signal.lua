-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1
local t = require(game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("t"))

local function acquireRunnerThreadAndCallEventHandler(p1, ...) -- line: 47
    -- upvalues: v1 (ref)
    local v2 = v1

    v1 = nil
    p1(...)
    v1 = v2
end

local function runEventHandlerInFreeThread(...) -- line: 58
    -- upvalues: acquireRunnerThreadAndCallEventHandler (copy)
    acquireRunnerThreadAndCallEventHandler(...)

    while true do
        acquireRunnerThreadAndCallEventHandler(coroutine.yield())
    end
end

local function getOrCreateReusableRunnerThread(...) -- line: 65
    -- upvalues: v1 (ref), runEventHandlerInFreeThread (copy)
    v1 = v1 or coroutine.create(runEventHandlerInFreeThread)
    task.spawn(v1, ...)
end

local t1 = {}

t1.__index = t1

function t1.Disconnect(p2) -- line: 91
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
    __index = function(_, p4) -- __index | line: 118
        error(("Attempt to get Connection::%s (not a valid member)"):format((tostring(p4))), 2)
    end,
    __newindex = function(_, p6, _) -- __newindex | line: 121
        error(("Attempt to set Connection::%s (not a valid member)"):format((tostring(p6))), 2)
    end
})

local t3 = {}

t3.__index = t3

function t3._deployStickyBehavior(p8, p9) -- line: 158
    -- upvalues: getOrCreateReusableRunnerThread (copy)
    local _stickyBehavior = rawget(p8, "_stickyBehavior")

    if _stickyBehavior then
        getOrCreateReusableRunnerThread(_stickyBehavior, p9)
    end
end

function t3.new(p10) -- line: 172
    -- upvalues: t (copy), t3 (copy)
    t.strict(t.optional(t.callback))(p10)

    return (setmetatable({
        _handlerListHead = false,
        _proxyHandler = nil,
        _yieldedThreads = nil,
        _stickyBehavior = p10
    }, t3))
end

function t3.Wrap(p11) -- line: 198
    -- upvalues: t3 (copy)
    assert(typeof(p11) == "RBXScriptSignal", "Argument #1 to Signal.Wrap must be a RBXScriptSignal; got " .. typeof(p11))

    local v6 = t3.new()

    v6._proxyHandler = p11:Connect(function(...) -- line: 205
        -- upvalues: v6 (copy)
        v6:Fire(...)
    end)

    return v6
end

function t3.Is(p12) -- line: 218
    -- upvalues: t3 (copy)
    if type(p12) == "table" then
        return getmetatable(p12) == t3
    end

    return false
end

function t3.Connect(p13, p14) -- line: 235
    -- upvalues: t1 (copy)
    local v7 = setmetatable({
        Connected = true,
        _next = false,
        _signal = p13,
        _fn = p14
    }, t1)

    if p13._handlerListHead then
        v7._next = p13._handlerListHead
    end

    p13._handlerListHead = v7
    p13:_deployStickyBehavior(p14)

    return v7
end

function t3.ConnectOnce(p15, p16) -- line: 259
    return p15:Once(p16)
end

function t3.Once(p17, p18) -- line: 278
    local connection
    local v8 = false

    connection = p17:Connect(function(...) -- line: 282
        -- upvalues: p18 (copy), connection (ref), v8 (ref)
        if v8 then
            return
        end

        v8 = true
        connection:Disconnect()
        p18(...)
    end)

    return connection
end

function t3.GetConnections(p19) -- line: 295
    local t6 = {}
    local v9 = p19._handlerListHead

    while v9 do
        table.insert(t6, v9)
        v9 = v9._next
    end

    return t6
end

function t3.DisconnectAll(p20) -- line: 315
    local v10 = p20._handlerListHead

    while v10 do
        v10.Connected = false
        v10 = v10._next
    end

    p20._handlerListHead = false

    local _yieldedThreads = rawget(p20, "_yieldedThreads")

    if _yieldedThreads then
        for v11 in _yieldedThreads do
            if coroutine.status(v11) == "suspended" then
                warn(debug.traceback(v11, "signal disconnected; yielded thread cancelled", 2))
                task.cancel(v11)
            end
        end

        table.clear(p20._yieldedThreads)
    end
end

function t3.Fire(p21, ...) -- line: 350
    -- upvalues: getOrCreateReusableRunnerThread (copy)
    local v12 = p21._handlerListHead

    while v12 do
        if v12.Connected then
            getOrCreateReusableRunnerThread(v12._fn, ...)
        end

        v12 = v12._next
    end
end

function t3.FireDeferred(p22, ...) -- line: 368
    local v13 = p22._handlerListHead

    while v13 do
        local defer = task.defer
        local v14 = v13

        defer(function(...) -- line: 372
            -- upvalues: v14 (copy)
            if v14.Connected then
                v14._fn(...)
            end
        end, ...)
        v13 = v13._next
    end
end

function t3.Wait(p23) -- line: 396
    local _yieldedThreads = rawget(p23, "_yieldedThreads")

    if not _yieldedThreads then
        _yieldedThreads = {}
        rawset(p23, "_yieldedThreads", _yieldedThreads)
    end

    local thread = coroutine.running()

    _yieldedThreads[thread] = true
    p23:Once(function(...) -- line: 406
        -- upvalues: _yieldedThreads (ref), thread (copy)
        _yieldedThreads[thread] = nil

        if coroutine.status(thread) == "suspended" then
            task.spawn(thread, ...)
        end
    end)

    return coroutine.yield()
end

function t3.Destroy(p24, p25) -- line: 429
    p24:DisconnectAll()

    local _proxyHandler = rawget(p24, "_proxyHandler")

    if _proxyHandler then
        _proxyHandler:Disconnect()
    end

    if p25 then
        setmetatable(p24, nil)
        table.clear(p24)
    end
end

setmetatable(t3, {
    __index = function(_, p27) -- __index | line: 446
        error(("Attempt to get Signal::%s (not a valid member)"):format((tostring(p27))), 2)
    end,
    __newindex = function(_, p29, _) -- __newindex | line: 449
        error(("Attempt to set Signal::%s (not a valid member)"):format((tostring(p29))), 2)
    end
})

return table.freeze({
    new = t3.new,
    Wrap = t3.Wrap,
    Is = t3.Is
})
