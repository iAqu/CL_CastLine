-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1

local function acquireRunnerThreadAndCallEventHandler(p1, ...) -- line: 53
    -- upvalues: v1 (ref)
    local v2 = v1

    v1 = nil
    p1(...)
    v1 = v2
end

local function runEventHandlerInFreeThread(...) -- line: 64
    -- upvalues: acquireRunnerThreadAndCallEventHandler (copy)
    acquireRunnerThreadAndCallEventHandler(...)

    while true do
        acquireRunnerThreadAndCallEventHandler(coroutine.yield())
    end
end

local t1 = {}

t1.__index = t1

function t1.new(p2, p3) -- line: 90
    -- upvalues: t1 (copy)
    return (setmetatable({
        Connected = true,
        _next = false,
        _signal = p2,
        _fn = p3
    }, t1))
end

function t1.Disconnect(p4) -- line: 99
    if p4.Connected then
        p4.Connected = false

        if p4._signal._handlerListHead == p4 then
            p4._signal._handlerListHead = p4._next
        else
            local v3 = p4._signal._handlerListHead

            while v3 and v3._next ~= p4 do
                v3 = v3._next
            end

            if v3 then
                v3._next = p4._next
            end
        end
    end
end

t1.Destroy = t1.Disconnect
setmetatable(t1, {
    __index = function(_, p6) -- __index | line: 126
        error(("Attempt to get Connection::%s (not a valid member)"):format((tostring(p6))), 2)
    end,
    __newindex = function(_, p8, _) -- __newindex | line: 129
        error(("Attempt to set Connection::%s (not a valid member)"):format((tostring(p8))), 2)
    end
})

local t4 = {}

t4.__index = t4

function t4.new() -- line: 165
    -- upvalues: t4 (copy)
    return (setmetatable({
        _handlerListHead = false,
        _proxyHandler = nil
    }, t4))
end

function t4.Wrap(p10) -- line: 186
    -- upvalues: t4 (copy)
    assert(typeof(p10) == "RBXScriptSignal", "Argument #1 to Signal.Wrap must be a RBXScriptSignal; got " .. typeof(p10))

    local v6 = t4.new()

    v6._proxyHandler = p10:Connect(function(...) -- line: 192
        -- upvalues: v6 (copy)
        v6:Fire(...)
    end)

    return v6
end

function t4.Is(p11) -- line: 204
    -- upvalues: t4 (copy)
    if type(p11) == "table" then
        return getmetatable(p11) == t4
    end

    return false
end

function t4.Connect(p12, p13) -- line: 221
    -- upvalues: t1 (copy)
    local v7 = t1.new(p12, p13)

    if p12._handlerListHead then
        v7._next = p12._handlerListHead
    end

    p12._handlerListHead = v7

    return v7
end

function t4.ConnectOnce(p14, p15) -- line: 237
    return p14:Once(p15)
end

function t4.Once(p16, p17) -- line: 256
    local connection
    local v8 = false

    connection = p16:Connect(function(...) -- line: 259
        -- upvalues: p17 (copy), connection (ref), v8 (ref)
        if v8 then
            return
        end

        v8 = true
        connection:Disconnect()
        p17(...)
    end)

    return connection
end

function t4.GetConnections(p18) -- line: 270
    local t6 = {}
    local v9 = p18._handlerListHead

    while v9 do
        table.insert(t6, v9)
        v9 = v9._next
    end

    return t6
end

function t4.DisconnectAll(p19) -- line: 288
    local v10 = p19._handlerListHead

    while v10 do
        v10.Connected = false
        v10 = v10._next
    end

    p19._handlerListHead = false
end

function t4.Fire(p20, ...) -- line: 312
    -- upvalues: v1 (ref), runEventHandlerInFreeThread (copy)
    local v11 = p20._handlerListHead

    while v11 do
        if v11.Connected then
            v1 = v1 or coroutine.create(runEventHandlerInFreeThread)
            task.spawn(v1, v11._fn, ...)
        end

        v11 = v11._next
    end
end

function t4.FireDeferred(p21, ...) -- line: 333
    local v12 = p21._handlerListHead

    while v12 do
        task.defer(v12._fn, ...)
        v12 = v12._next
    end
end

function t4.Wait(p22) -- line: 356
    local thread = coroutine.running()
    local connection
    local v13 = false

    connection = p22:Connect(function(...) -- line: 360
        -- upvalues: thread (copy), connection (ref), v13 (ref)
        if v13 then
            return
        end

        v13 = true
        connection:Disconnect()
        task.spawn(thread, ...)
    end)

    return coroutine.yield()
end

function t4.Destroy(p23) -- line: 383
    p23:DisconnectAll()

    local _proxyHandler = rawget(p23, "_proxyHandler")

    if _proxyHandler then
        _proxyHandler:Disconnect()
    end
end

setmetatable(t4, {
    __index = function(_, p25) -- __index | line: 393
        error(("Attempt to get Signal::%s (not a valid member)"):format((tostring(p25))), 2)
    end,
    __newindex = function(_, p27, _) -- __newindex | line: 396
        error(("Attempt to set Signal::%s (not a valid member)"):format((tostring(p27))), 2)
    end
})

return {
    new = t4.new,
    Wrap = t4.Wrap,
    Is = t4.Is
}
