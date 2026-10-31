-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    __mode = "k"
}

local function isCallable(p1) -- line: 10
    if type(p1) == "function" then
        return true
    end

    if type(p1) == "table" then
        local mt = getmetatable(p1)

        if mt and type((rawget(mt, "__call"))) == "function" then
            return true
        end
    end

    return false
end

local function makeEnum(p2, p3) -- line: 28
    local t2 = {}

    for _, v1 in ipairs(p3) do
        t2[v1] = v1
    end

    return (setmetatable(t2, {
        __index = function(_, p5) -- __index | line: 36
            -- upvalues: p2 (copy)
            error(string.format("%s is not in %s!", p5, p2), 2)
        end,
        __newindex = function() -- __newindex | line: 39
            -- upvalues: p2 (copy)
            error(string.format("Creating new members in %s is not allowed!", p2), 2)
        end
    }))
end

local t4 = {
    Kind = makeEnum("Promise.Error.Kind", { "ExecutionError", "AlreadyCancelled", "NotResolvedInTime", "TimedOut" })
}

t4.__index = t4

function t4.new(p6, p7) -- line: 64
    -- upvalues: t4 (copy)
    p6 = p6 or {}

    return (setmetatable({
        error = tostring(p6.error) or "[This error has no error text.]",
        trace = p6.trace,
        context = p6.context,
        kind = p6.kind,
        parent = p7,
        createdTick = os.clock(),
        createdTrace = debug.traceback()
    }, t4))
end

function t4.is(p8) -- line: 77
    if type(p8) == "table" then
        local mt = getmetatable(p8)

        if type(mt) == "table" then
            return rawget(p8, "error") ~= nil and type((rawget(mt, "extend"))) == "function"
        end
    end

    return false
end

function t4.isKind(p9, p10) -- line: 89
    -- upvalues: t4 (copy)
    assert(p10 ~= nil, "Argument #2 to Promise.Error.isKind must not be nil")

    return t4.is(p9) and p9.kind == p10
end

function t4.extend(p11, p12) -- line: 95
    -- upvalues: t4 (copy)
    p12 = p12 or {}
    p12.kind = p12.kind or p11.kind

    return t4.new(p12, p11)
end

function t4.getErrorChain(p13) -- line: 103
    local t6 = {
        p13
    }

    while t6[#t6].parent do
        table.insert(t6, t6[#t6].parent)
    end

    return t6
end

function t4.__tostring(p14) -- line: 113
    local t7 = { string.format("-- Promise.Error(%s) --", p14.kind or "?") }

    for _, v6 in ipairs(p14:getErrorChain()) do
        table.insert(t7, table.concat({
            v6.trace or v6.error,
            v6.context
        }, "\n"))
    end

    return table.concat(t7, "\n")
end

local function pack(...) -- line: 137
    return select("#", ...), { ... }
end

local function packResult(p15, ...) -- line: 144
    return p15, select("#", ...), { ... }
end

local function makeErrorHandler(p16) -- line: 148
    -- upvalues: t4 (copy)
    assert(p16 ~= nil, "traceback is nil")

    return function(p17) -- line: 151
        -- upvalues: p16 (copy), t4 (copy)
        if type(p17) == "table" then
            return p17
        end

        return t4.new({
            error = p17,
            kind = t4.Kind.ExecutionError,
            trace = debug.traceback(tostring(p17), 2),
            context = "Promise created at:\n\n" .. p16
        })
    end
end

local function runExecutor(p18, p19, ...) -- line: 171
    -- upvalues: t4 (copy), packResult (copy)
    assert(p18 ~= nil, "traceback is nil")

    local function v10(p20) -- line: 151
        -- upvalues: p18 (copy), t4 (copy)
        if type(p20) == "table" then
            return p20
        end

        return t4.new({
            error = p20,
            kind = t4.Kind.ExecutionError,
            trace = debug.traceback(tostring(p20), 2),
            context = "Promise created at:\n\n" .. p18
        })
    end

    return packResult(xpcall(p19, v10, ...))
end

local function createAdvancer(p21, p22, p23, p24) -- line: 179
    -- upvalues: runExecutor (copy)
    return function(...) -- line: 180
        -- upvalues: p21 (copy), p22 (copy), p23 (copy), p24 (copy), runExecutor (copy)
        local v11, v12, v13 = runExecutor(p21, p22, ...)

        if v11 then
            p23(unpack(v13, 1, v12))
        else
            p24(v13[1])
        end
    end
end

local function isEmpty(p25) -- line: 191
    return next(p25) == nil
end

local t9 = {
    Error = t4,
    Status = makeEnum("Promise.Status", { "Started", "Resolved", "Rejected", "Cancelled" }),
    _getTime = os.clock,
    _timeEvent = game:GetService("RunService").Heartbeat,
    _unhandledRejectionCallbacks = {},
    prototype = {}
}

t9.__index = t9.prototype

function t9._new(p26, p27, p28) -- line: 230
    -- upvalues: t1 (copy), runExecutor (copy), t9 (copy)
    if p28 ~= nil and not t9.is(p28) then
        error("Argument #2 to Promise.new must be a promise or nil", 2)
    end

    local t10 = {
        _thread = nil,
        _values = nil,
        _valuesLength = -1,
        _unhandledRejection = true,
        _cancellationHook = nil,
        _source = p26,
        _status = t9.Status.Started,
        _queuedResolve = {},
        _queuedReject = {},
        _queuedFinally = {},
        _parent = p28,
        _consumers = setmetatable({}, t1)
    }

    if p28 and p28._status == t9.Status.Started then
        p28._consumers[t10] = true
    end

    setmetatable(t10, t9)

    local function resolve(...) -- line: 278
        -- upvalues: t10 (copy)
        t10:_resolve(...)
    end

    local function reject(...) -- line: 282
        -- upvalues: t10 (copy)
        t10:_reject(...)
    end

    local function onCancel(p29) -- line: 286
        -- upvalues: t10 (copy), t9 (copy)
        if p29 then
            if t10._status == t9.Status.Cancelled then
                p29()
            else
                t10._cancellationHook = p29
            end
        end

        return t10._status == t9.Status.Cancelled
    end

    t10._thread = coroutine.create(function() -- line: 298
        -- upvalues: p27 (copy), t10 (copy), resolve (copy), reject (copy), onCancel (copy), runExecutor (copy)
        local v14, _, v15 = runExecutor(t10._source, p27, resolve, reject, onCancel)

        if not v14 then
            reject(v15[1])
        end
    end)
    task.spawn(t10._thread)

    return t10
end

function t9.new(p30) -- line: 349
    -- upvalues: t9 (copy)
    return t9._new(debug.traceback(nil, 2), p30)
end

function t9.__tostring(p31) -- line: 353
    return string.format("Promise(%s)", p31._status)
end

function t9.defer(p32) -- line: 375
    -- upvalues: runExecutor (copy), t9 (copy)
    local v16 = debug.traceback(nil, 2)

    return (t9._new(v16, function(p33, p34, p35) -- line: 378
        -- upvalues: p32 (copy), v16 (copy), runExecutor (copy), t9 (copy)
        local connection

        connection = t9._timeEvent:Connect(function() -- line: 380
            -- upvalues: p33 (copy), p34 (copy), p35 (copy), connection (ref), p32 (copy), v16 (copy), runExecutor (copy)
            connection:Disconnect()

            local v17, _, v18 = runExecutor(v16, p32, p33, p34, p35)

            if not v17 then
                p34(v18[1])
            end
        end)
    end))
end

t9.async = t9.defer

function t9.resolve(...) -- line: 418
    -- upvalues: pack (copy), t9 (copy)
    local v19, v20 = pack(...)

    return t9._new(debug.traceback(nil, 2), function(p36) -- line: 420
        -- upvalues: v19 (copy), v20 (copy)
        p36(unpack(v20, 1, v19))
    end)
end

function t9.reject(...) -- line: 435
    -- upvalues: pack (copy), t9 (copy)
    local v21, v22 = pack(...)

    return t9._new(debug.traceback(nil, 2), function(_, p38) -- line: 437
        -- upvalues: v21 (copy), v22 (copy)
        p38(unpack(v22, 1, v21))
    end)
end

function t9._try(p39, p40, ...) -- line: 446
    -- upvalues: pack (copy), t9 (copy)
    local v23, v24 = pack(...)

    return t9._new(p39, function(p41) -- line: 449
        -- upvalues: p40 (copy), v23 (copy), v24 (copy)
        p41(p40(unpack(v24, 1, v23)))
    end)
end

function t9.try(p42, ...) -- line: 477
    -- upvalues: t9 (copy)
    return t9._try(debug.traceback(nil, 2), p42, ...)
end

function t9._all(p43, p44, p45) -- line: 486
    -- upvalues: t9 (copy)
    if type(p44) ~= "table" then
        error(string.format("Please pass a list of promises to %s", "Promise.all"), 3)
    end

    for v25, v26 in pairs(p44) do
        if not t9.is(v26) then
            error(string.format("Non-promise value passed into %s at index %s", "Promise.all", (tostring(v25))), 3)
        end
    end

    if #p44 == 0 or p45 == 0 then
        return t9.resolve({})
    end

    return t9._new(p43, function(p46, p47, p48) -- line: 504
        -- upvalues: p44 (copy), p45 (copy)
        local t12 = {}
        local t13 = {}
        local n1 = 0
        local n2 = 0
        local v27 = false

        local function cancel() -- line: 515
            -- upvalues: t13 (copy)
            for _, v28 in ipairs(t13) do
                v28:cancel()
            end
        end

        local function resolveOne(p49, ...) -- line: 522
            -- upvalues: p46 (copy), t12 (copy), t13 (copy), n1 (ref), v27 (ref), p44 (copy), p45 (copy)
            if v27 then
                return
            end

            n1 += 1

            if p45 ~= nil then
                local v29 = n1

                t12[v29] = ...
            else
                t12[p49] = ...
            end

            local v30 = n1

            if not ((p45 or #p44) <= v30) then
                return
            end

            v27 = true
            p46(t12)

            for _, v31 in ipairs(t13) do
                v31:cancel()
            end
        end

        p48(cancel)

        for v32, v33 in ipairs(p44) do
            t13[v32] = v33:andThen(function(...) -- line: 547
                -- upvalues: resolveOne (copy), v32 (copy)
                resolveOne(v32, ...)
            end, function(...) -- line: 549
                -- upvalues: p47 (copy), t13 (copy), n2 (ref), v27 (ref), p44 (copy), p45 (copy)
                n2 += 1

                if p45 == nil or #p44 - n2 < p45 then
                    for _, v35 in ipairs(t13) do
                        v35:cancel()
                    end

                    v27 = true
                    p47(...)
                end
            end)
        end

        if v27 then
            for _, v36 in ipairs(t13) do
                v36:cancel()
            end
        end
    end)
end

function t9.all(p50) -- line: 591
    -- upvalues: t9 (copy)
    return t9._all(debug.traceback(nil, 2), p50)
end

function t9.fold(p51, p52, p53) -- line: 620
    -- upvalues: t9 (copy)
    assert(type(p51) == "table", "Bad argument #1 to Promise.fold: must be a table")

    local v38

    if type(p52) == "function" then
        v38 = true
    else
        local v39 = false

        if type(p52) == "table" then
            local mt = getmetatable(p52)

            if mt then
                v39 = type((rawget(mt, "__call"))) == "function"
            end
        end

        v38 = not not v39
    end

    assert(v38, "Bad argument #2 to Promise.fold: must be a function")

    local v40 = t9.resolve(p53)

    return t9.each(p51, function(p54, p55) -- line: 625
        -- upvalues: p52 (copy), v40 (ref)
        v40 = v40:andThen(function(p56) -- line: 626
            -- upvalues: p54 (copy), p55 (copy), p52 (copy)
            return p52(p56, p54, p55)
        end)
    end):andThen(function() -- line: 629
        -- upvalues: v40 (ref)
        return v40
    end)
end

function t9.some(p57, p58) -- line: 653
    -- upvalues: t9 (copy)
    assert(type(p58) == "number", "Bad argument #2 to Promise.some: must be a number")

    return t9._all(debug.traceback(nil, 2), p57, p58)
end

function t9.any(p59) -- line: 677
    -- upvalues: t9 (copy)
    return t9._all(debug.traceback(nil, 2), p59, 1):andThen(function(p60) -- line: 678
        return p60[1]
    end)
end

function t9.allSettled(p61) -- line: 699
    -- upvalues: t9 (copy)
    if type(p61) ~= "table" then
        error(string.format("Please pass a list of promises to %s", "Promise.allSettled"), 2)
    end

    for v43, v44 in pairs(p61) do
        if not t9.is(v44) then
            error(string.format("Non-promise value passed into %s at index %s", "Promise.allSettled", (tostring(v43))), 2)
        end
    end

    if #p61 == 0 then
        return t9.resolve({})
    end

    return t9._new(debug.traceback(nil, 2), function(p62, _, p64) -- line: 717
        -- upvalues: p61 (copy)
        local t14 = {}
        local t15 = {}
        local n3 = 0

        local function resolveOne(p65, ...) -- line: 727
            -- upvalues: p62 (copy), t14 (copy), n3 (ref), p61 (copy)
            n3 += 1
            t14[p65] = ...

            local v45 = n3

            if v45 >= #p61 then
                p62(t14)
            end
        end

        p64(function() -- line: 737
            -- upvalues: t15 (copy)
            for _, v46 in ipairs(t15) do
                v46:cancel()
            end
        end)

        for v47, v48 in ipairs(p61) do
            t15[v47] = v48:finally(function(...) -- line: 746
                -- upvalues: resolveOne (copy), v47 (copy)
                resolveOne(v47, ...)
            end)
        end
    end)
end

function t9.race(p66) -- line: 777
    -- upvalues: t9 (copy)
    assert(type(p66) == "table", string.format("Please pass a list of promises to %s", "Promise.race"))

    for v50, v51 in pairs(p66) do
        assert(t9.is(v51), string.format("Non-promise value passed into %s at index %s", "Promise.race", (tostring(v50))))
    end

    return t9._new(debug.traceback(nil, 2), function(p67, p68, p69) -- line: 784
        -- upvalues: p66 (copy)
        local t16 = {}
        local v54 = false

        local function cancel() -- line: 788
            -- upvalues: t16 (copy)
            for _, v55 in ipairs(t16) do
                v55:cancel()
            end
        end

        local function finalize(p70) -- line: 794
            -- upvalues: t16 (copy), v54 (ref)
            return function(...) -- line: 795
                -- upvalues: p70 (copy), t16 (copy), v54 (ref)
                for _, v56 in ipairs(t16) do
                    v56:cancel()
                end

                v54 = true

                return p70(...)
            end
        end

        if not p69(function(...) -- line: 795
            -- upvalues: p68 (copy), t16 (copy), v54 (ref)
            for _, v57 in ipairs(t16) do
                v57:cancel()
            end

            v54 = true

            return p68(...)
        end) then
            for v58, v59 in ipairs(p66) do
                t16[v58] = v59:andThen(function(...) -- line: 795
                    -- upvalues: p67 (copy), t16 (copy), v54 (ref)
                    for _, v61 in ipairs(t16) do
                        v61:cancel()
                    end

                    v54 = true

                    return p67(...)
                end, function(...) -- line: 795
                    -- upvalues: p68 (copy), t16 (copy), v54 (ref)
                    for _, v62 in ipairs(t16) do
                        v62:cancel()
                    end

                    v54 = true

                    return p68(...)
                end)
            end

            if v54 then
                for _, v63 in ipairs(t16) do
                    v63:cancel()
                end
            end
        end
    end)
end

function t9.each(p71, p72) -- line: 872
    -- upvalues: t4 (copy), t9 (copy)
    assert(type(p71) == "table", string.format("Please pass a list of promises to %s", "Promise.each"))

    local v65

    if type(p72) == "function" then
        v65 = true
    else
        local v66 = false

        if type(p72) == "table" then
            local mt = getmetatable(p72)

            if mt then
                v66 = type((rawget(mt, "__call"))) == "function"
            end
        end

        v65 = not not v66
    end

    assert(v65, string.format("Please pass a handler function to %s!", "Promise.each"))

    return t9._new(debug.traceback(nil, 2), function(p73, p74, p75) -- line: 876
        -- upvalues: p71 (copy), p72 (copy), t4 (copy), t9 (copy)
        local t17 = {}
        local t18 = {}
        local v67 = false

        local function cancel() -- line: 882
            -- upvalues: t18 (copy)
            for _, v68 in ipairs(t18) do
                v68:cancel()
            end
        end

        p75(function() -- line: 888
            -- upvalues: t18 (copy), v67 (ref)
            v67 = true

            for _, v69 in ipairs(t18) do
                v69:cancel()
            end
        end)

        local t19 = {}

        for v70, v71 in ipairs(p71) do
            if t9.is(v71) then
                if v71:getStatus() == t9.Status.Cancelled then
                    for _, v72 in ipairs(t18) do
                        v72:cancel()
                    end

                    return p74(t4.new({
                        error = "Promise is cancelled",
                        kind = t4.Kind.AlreadyCancelled,
                        context = string.format("The Promise that was part of the array at index %d passed into Promise.each was already cancelled when Promise.each began.\n\nThat Promise was created at:\n\n%s", v70, v71._source)
                    }))
                end

                if v71:getStatus() == t9.Status.Rejected then
                    for _, v73 in ipairs(t18) do
                        v73:cancel()
                    end

                    return p74(select(2, v71:await()))
                end

                local v74 = v71:andThen(function(...) -- line: 921
                    return ...
                end)

                table.insert(t18, v74)
                t19[v70] = v74
                continue
            end

            t19[v70] = v71
        end

        for v75, v76 in ipairs(t19) do
            local v77 = v76

            if t9.is(v76) then
                local v78

                v78, v77 = v76:await()

                if not v78 then
                    for _, v79 in ipairs(t18) do
                        v79:cancel()
                    end

                    return p74(v77)
                end
            end

            if v67 then
                return
            end

            local v80 = t9.resolve(p72(v77, v75))

            table.insert(t18, v80)

            local v81, v82 = v80:await()

            if not v81 then
                for _, v83 in ipairs(t18) do
                    v83:cancel()
                end

                return p74(v82)
            end

            t17[v75] = v82
        end

        p73(t17)
    end)
end

function t9.is(p76) -- line: 971
    -- upvalues: t9 (copy)
    if type(p76) ~= "table" then
        return false
    end

    local mt = getmetatable(p76)

    if mt == t9 then
        return true
    end

    if mt ~= nil then
        if type(mt) == "table" and type((rawget(mt, "__index"))) == "table" then
            local andThen = rawget(rawget(mt, "__index"), "andThen")
            local v84

            if type(andThen) == "function" then
                v84 = true
            else
                v84 = false

                if type(andThen) == "table" then
                    local mt = getmetatable(andThen)

                    if mt then
                        v84 = type((rawget(mt, "__call"))) == "function"
                    end
                end
            end

            if v84 then
                return true
            end
        end
    else
        local andThen = p76.andThen

        if type(andThen) == "function" then
            return true
        end

        if type(andThen) == "table" then
            local mt = getmetatable(andThen)

            if mt and type((rawget(mt, "__call"))) == "function" then
                return true
            end
        end
    end

    return false
end

function t9.promisify(p77) -- line: 1020
    -- upvalues: t9 (copy)
    return function(...) -- line: 1021
        -- upvalues: p77 (copy), t9 (copy)
        return t9._try(debug.traceback(nil, 2), p77, ...)
    end
end

local v85 = nil
local connection

function t9.delay(p78) -- line: 1051
    -- upvalues: t9 (copy), v85 (ref), connection (ref)
    local v86 = p78

    assert(type(p78) == "number", "Bad argument #1 to Promise.delay, must be a number.")

    if not (p78 >= 0.016666666666666666) or p78 == 1e999 then
        v86 = 0.016666666666666666
    end

    return t9._new(debug.traceback(nil, 2), function(p79, _, p81) -- line: 1059
        -- upvalues: v86 (ref), t9 (copy), v85 (ref), connection (ref)
        local v88 = t9._getTime()
        local v89 = v88 + v86
        local t20 = {
            resolve = p79,
            startTime = v88,
            endTime = v89
        }

        if connection ~= nil then
            if v85.endTime < v89 then
                local v92 = v85
                local next = v92.next

                while next ~= nil and next.endTime < v89 do
                    v92 = next
                    next = next.next
                end

                v92.next = t20
                t20.previous = v92

                if next ~= nil then
                    t20.next = next
                    next.previous = t20
                end
            else
                t20.next = v85
                v85.previous = t20
                v85 = t20
            end
        else
            v85 = t20
            connection = t9._timeEvent:Connect(function() -- line: 1071
                -- upvalues: t9 (copy), v85 (ref), connection (ref)
                local v90 = t9._getTime()

                while v85 ~= nil and v85.endTime < v90 do
                    local v91 = v85

                    v85 = v91.next

                    if v85 ~= nil then
                        v85.previous = nil
                    else
                        connection:Disconnect()
                        connection = nil
                    end

                    v91.resolve(t9._getTime() - v91.startTime)
                end
            end)
        end

        p81(function() -- line: 1116
            -- upvalues: t20 (copy), v85 (ref), connection (ref)
            local next = t20.next

            if v85 == t20 then
                if next ~= nil then
                    next.previous = nil
                else
                    connection:Disconnect()
                    connection = nil
                end

                v85 = next
            else
                local previous = t20.previous

                previous.next = next

                if next ~= nil then
                    next.previous = previous
                end
            end
        end)
    end)
end

function t9.prototype.timeout(p82, p83, p84) -- line: 1180
    -- upvalues: t4 (copy), t9 (copy)
    local v93 = debug.traceback(nil, 2)

    return t9.race({
        t9.delay(p83):andThen(function() -- line: 1184
            -- upvalues: p83 (copy), p84 (copy), v93 (copy), t4 (copy), t9 (copy)
            return t9.reject(p84 == nil and t4.new({
                error = "Timed out",
                kind = t4.Kind.TimedOut,
                context = string.format("Timeout of %d seconds exceeded.\n:timeout() called at:\n\n%s", p83, v93)
            }) or p84)
        end),
        p82
    })
end

function t9.prototype.getStatus(p85) -- line: 1204
    return p85._status
end

function t9.prototype._andThen(p86, p87, p88, p89) -- line: 1213
    -- upvalues: runExecutor (copy), t9 (copy)
    p86._unhandledRejection = false

    if p86._status ~= t9.Status.Cancelled then
        return t9._new(p87, function(p90, p91, p92) -- line: 1225
            -- upvalues: p86 (copy), p87 (copy), p88 (copy), p89 (copy), runExecutor (copy), t9 (copy)
            local v94 = p90
            local v95

            if p88 then
                v95 = function(...) -- line: 180
                    -- upvalues: p90 (copy), p91 (copy), p87 (copy), p88 (copy), runExecutor (copy)
                    local v96, v97, v98 = runExecutor(p87, p88, ...)

                    if v96 then
                        p90(unpack(v98, 1, v97))
                    else
                        p91(v98[1])
                    end
                end

                v94 = v95
            else
                v95 = p90
            end

            local v99 = p91
            local v100

            if p89 then
                v100 = function(...) -- line: 180
                    -- upvalues: p90 (copy), p91 (copy), p87 (copy), p89 (copy), runExecutor (copy)
                    local v101, v102, v103 = runExecutor(p87, p89, ...)

                    if v101 then
                        p90(unpack(v103, 1, v102))
                    else
                        p91(v103[1])
                    end
                end

                v99 = v100
            else
                v100 = p91
            end

            if p86._status == t9.Status.Started then
                table.insert(p86._queuedResolve, v95)
                table.insert(p86._queuedReject, v100)
                p92(function() -- line: 1244
                    -- upvalues: v94 (ref), v99 (ref), p86 (copy), t9 (copy)
                    if p86._status == t9.Status.Started then
                        table.remove(p86._queuedResolve, table.find(p86._queuedResolve, v94))
                        table.remove(p86._queuedReject, table.find(p86._queuedReject, v99))
                    end
                end)
            elseif p86._status == t9.Status.Resolved then
                v95(unpack(p86._values, 1, p86._valuesLength))
            elseif p86._status == t9.Status.Rejected then
                v100(unpack(p86._values, 1, p86._valuesLength))
            end
        end, p86)
    end

    local v104 = t9.new(function() -- line: 1218
    end)

    v104:cancel()

    return v104
end

function t9.prototype.andThen(p93, p94, p95) -- line: 1283
    local v105

    if p94 == nil or type(p94) == "function" then
        v105 = true
    else
        local v106 = false

        if type(p94) == "table" then
            local mt = getmetatable(p94)

            if mt then
                v106 = type((rawget(mt, "__call"))) == "function"
            end
        end

        v105 = not not v106
    end

    assert(v105, string.format("Please pass a handler function to %s!", "Promise:andThen"))

    local v107

    if p95 == nil or type(p95) == "function" then
        v107 = true
    else
        local v108 = false

        if type(p95) == "table" then
            local mt = getmetatable(p95)

            if mt then
                v108 = type((rawget(mt, "__call"))) == "function"
            end
        end

        v107 = not not v108
    end

    assert(v107, string.format("Please pass a handler function to %s!", "Promise:andThen"))

    return p93:_andThen(debug.traceback(nil, 2), p94, p95)
end

function t9.prototype.catch(p96, p97) -- line: 1310
    local v109

    if p97 == nil or type(p97) == "function" then
        v109 = true
    else
        local v110 = false

        if type(p97) == "table" then
            local mt = getmetatable(p97)

            if mt then
                v110 = type((rawget(mt, "__call"))) == "function"
            end
        end

        v109 = not not v110
    end

    assert(v109, string.format("Please pass a handler function to %s!", "Promise:catch"))

    return p96:_andThen(debug.traceback(nil, 2), nil, p97)
end

function t9.prototype.tap(p98, p99) -- line: 1331
    -- upvalues: pack (copy), t9 (copy)
    local v111

    if type(p99) == "function" then
        v111 = true
    else
        local v112 = false

        if type(p99) == "table" then
            local mt = getmetatable(p99)

            if mt then
                v112 = type((rawget(mt, "__call"))) == "function"
            end
        end

        v111 = not not v112
    end

    assert(v111, string.format("Please pass a handler function to %s!", "Promise:tap"))

    return p98:_andThen(debug.traceback(nil, 2), function(...) -- line: 1333
        -- upvalues: p99 (copy), pack (copy), t9 (copy)
        local v113 = p99(...)

        if not t9.is(v113) then
            return ...
        end

        local v114, v115 = pack(...)

        return v113:andThen(function() -- line: 1338
            -- upvalues: v114 (copy), v115 (copy)
            return unpack(v115, 1, v114)
        end)
    end)
end

function t9.prototype.andThenCall(p100, p101, ...) -- line: 1366
    -- upvalues: pack (copy)
    local v116

    if type(p101) == "function" then
        v116 = true
    else
        local v117 = false

        if type(p101) == "table" then
            local mt = getmetatable(p101)

            if mt then
                v117 = type((rawget(mt, "__call"))) == "function"
            end
        end

        v116 = not not v117
    end

    assert(v116, string.format("Please pass a handler function to %s!", "Promise:andThenCall"))

    local v118, v119 = pack(...)

    return p100:_andThen(debug.traceback(nil, 2), function() -- line: 1369
        -- upvalues: p101 (copy), v118 (copy), v119 (copy)
        return p101(unpack(v119, 1, v118))
    end)
end

function t9.prototype.andThenReturn(p102, ...) -- line: 1396
    -- upvalues: pack (copy)
    local v120, v121 = pack(...)

    return p102:_andThen(debug.traceback(nil, 2), function() -- line: 1398
        -- upvalues: v120 (copy), v121 (copy)
        return unpack(v121, 1, v120)
    end)
end

function t9.prototype.cancel(p103) -- line: 1414
    -- upvalues: t9 (copy)
    if p103._status ~= t9.Status.Started then
        return
    end

    p103._status = t9.Status.Cancelled

    if p103._cancellationHook then
        p103._cancellationHook()
    end

    coroutine.close(p103._thread)

    if p103._parent then
        p103._parent:_consumerCancelled(p103)
    end

    for v122 in pairs(p103._consumers) do
        v122:cancel()
    end

    p103:_finalize()
end

function t9.prototype._consumerCancelled(p104, p105) -- line: 1442
    -- upvalues: t9 (copy)
    if p104._status == t9.Status.Started then
        p104._consumers[p105] = nil

        if next(p104._consumers) == nil then
            p104:cancel()
        end
    end
end

function t9.prototype._finally(p106, p107, p108) -- line: 1458
    -- upvalues: t9 (copy)
    p106._unhandledRejection = false

    return (t9._new(p107, function(p109, p110, p111) -- line: 1461
        -- upvalues: p106 (copy), p108 (copy), t9 (copy)
        local v123

        p111(function() -- line: 1464
            -- upvalues: v123 (ref), p106 (copy)
            p106:_consumerCancelled(p106)

            if v123 then
                v123:cancel()
            end
        end)

        local v124

        if p108 then
            v124 = function(...) -- line: 1477
                -- upvalues: p109 (copy), p110 (copy), v123 (ref), p106 (copy), p108 (copy), t9 (copy)
                local v125 = p108(...)

                if t9.is(v125) then
                    v123 = v125
                    v125:finally(function(p112) -- line: 1484
                        -- upvalues: p109 (copy), p106 (copy), t9 (copy)
                        if p112 ~= t9.Status.Rejected then
                            p109(p106)
                        end
                    end):catch(function(...) -- line: 1489
                        -- upvalues: p110 (copy)
                        p110(...)
                    end)
                else
                    p109(p106)
                end
            end
        else
            v124 = p109
        end

        if p106._status == t9.Status.Started then
            table.insert(p106._queuedFinally, v124)
        else
            v124(p106._status)
        end
    end))
end

function t9.prototype.finally(p113, p114) -- line: 1559
    local v126

    if p114 == nil or type(p114) == "function" then
        v126 = true
    else
        local v127 = false

        if type(p114) == "table" then
            local mt = getmetatable(p114)

            if mt then
                v127 = type((rawget(mt, "__call"))) == "function"
            end
        end

        v126 = not not v127
    end

    assert(v126, string.format("Please pass a handler function to %s!", "Promise:finally"))

    return p113:_finally(debug.traceback(nil, 2), p114)
end

function t9.prototype.finallyCall(p115, p116, ...) -- line: 1573
    -- upvalues: pack (copy)
    local v128

    if type(p116) == "function" then
        v128 = true
    else
        local v129 = false

        if type(p116) == "table" then
            local mt = getmetatable(p116)

            if mt then
                v129 = type((rawget(mt, "__call"))) == "function"
            end
        end

        v128 = not not v129
    end

    assert(v128, string.format("Please pass a handler function to %s!", "Promise:finallyCall"))

    local v130, v131 = pack(...)

    return p115:_finally(debug.traceback(nil, 2), function() -- line: 1576
        -- upvalues: p116 (copy), v130 (copy), v131 (copy)
        return p116(unpack(v131, 1, v130))
    end)
end

function t9.prototype.finallyReturn(p117, ...) -- line: 1599
    -- upvalues: pack (copy)
    local v132, v133 = pack(...)

    return p117:_finally(debug.traceback(nil, 2), function() -- line: 1601
        -- upvalues: v132 (copy), v133 (copy)
        return unpack(v133, 1, v132)
    end)
end

function t9.prototype.awaitStatus(p118) -- line: 1613
    -- upvalues: t9 (copy)
    p118._unhandledRejection = false

    if p118._status == t9.Status.Started then
        local thread = coroutine.running()

        p118:finally(function() -- line: 1620
            -- upvalues: thread (copy)
            task.spawn(thread)
        end):catch(function() -- line: 1626
        end)
        coroutine.yield()
    end

    if p118._status == t9.Status.Resolved then
        return p118._status, unpack(p118._values, 1, p118._valuesLength)
    end

    if p118._status ~= t9.Status.Rejected then
        return p118._status
    end

    return p118._status, unpack(p118._values, 1, p118._valuesLength)
end

local function awaitHelper(p119, ...) -- line: 1641
    -- upvalues: t9 (copy)
    return p119 == t9.Status.Resolved, ...
end

function t9.prototype.await(p120) -- line: 1666
    -- upvalues: awaitHelper (copy)
    return awaitHelper(p120:awaitStatus())
end

local function expectHelper(p121, ...) -- line: 1670
    -- upvalues: t9 (copy)
    if p121 ~= t9.Status.Resolved then
        error(if ... == nil then "Expected Promise rejected with no value." else ..., 3)
    end

    return ...
end

function t9.prototype.expect(p122) -- line: 1703
    -- upvalues: expectHelper (copy)
    return expectHelper(p122:awaitStatus())
end

t9.prototype.awaitValue = t9.prototype.expect

function t9.prototype._unwrap(p123) -- line: 1717
    -- upvalues: t9 (copy)
    if p123._status == t9.Status.Started then
        error("Promise has not resolved or rejected.", 2)
    end

    return p123._status == t9.Status.Resolved, unpack(p123._values, 1, p123._valuesLength)
end

function t9.prototype._resolve(p124, ...) -- line: 1727
    -- upvalues: t4 (copy), pack (copy), t9 (copy)
    if p124._status == t9.Status.Started then
        if t9.is((...)) then
            if select("#", ...) > 1 then
                local v135 = string.format("When returning a Promise from andThen, extra arguments are discarded! See:\n\n%s", p124._source)

                warn(v135)
            end

            local v136 = ...
            local v138 = v136:andThen(function(...) -- line: 1748
                -- upvalues: p124 (copy)
                p124:_resolve(...)
            end, function(...) -- line: 1750
                -- upvalues: p124 (copy), v136 (copy), t4 (copy)
                local v139 = v136._values[1]

                if v136._error then
                    v139 = t4.new({
                        context = "[No stack trace available as this Promise originated from an older version of the Promise library (< v2)]",
                        error = v136._error,
                        kind = t4.Kind.ExecutionError
                    })
                end

                if t4.isKind(v139, t4.Kind.ExecutionError) then
                    return p124:_reject(v139:extend({
                        error = "This Promise was chained to a Promise that errored.",
                        trace = "",
                        context = string.format("The Promise at:\n\n%s\n...Rejected because it was chained to the following Promise, which encountered an error:\n", p124._source)
                    }))
                end

                p124:_reject(...)
            end)

            if v138._status == t9.Status.Cancelled then
                p124:cancel()
            elseif v138._status == t9.Status.Started then
                p124._parent = v138
                v138._consumers[p124] = true
            end
        else
            p124._status = t9.Status.Resolved

            local v140, v141 = pack(...)

            p124._valuesLength = v140
            p124._values = v141

            for _, v142 in ipairs(p124._queuedResolve) do
                coroutine.wrap(v142)(...)
            end

            p124:_finalize()
        end
    elseif t9.is((...)) then
        (...):_consumerCancelled(p124)
    end
end

function t9.prototype._reject(p125, ...) -- line: 1798
    -- upvalues: pack (copy), t9 (copy)
    if p125._status ~= t9.Status.Started then
        return
    end

    p125._status = t9.Status.Rejected

    local v143, v144 = pack(...)

    p125._valuesLength = v143
    p125._values = v144

    local _queuedReject = p125._queuedReject

    if next(_queuedReject) ~= nil then
        for _, v149 in ipairs(p125._queuedReject) do
            coroutine.wrap(v149)(...)
        end
    else
        local v146 = tostring((...))

        coroutine.wrap(function() -- line: 1820
            -- upvalues: p125 (copy), v146 (copy), t9 (copy)
            t9._timeEvent:Wait()

            if p125._unhandledRejection then
                local v147 = string.format("Unhandled Promise rejection:\n\n%s\n\n%s", v146, p125._source)

                for _, v148 in ipairs(t9._unhandledRejectionCallbacks) do
                    task.spawn(v148, p125, unpack(p125._values, 1, p125._valuesLength))
                end

                if not t9.TEST then
                    warn(v147)
                end
            end
        end)()
    end

    p125:_finalize()
end

function t9.prototype._finalize(p126) -- line: 1852
    -- upvalues: t9 (copy)
    for _, v150 in ipairs(p126._queuedFinally) do
        coroutine.wrap(v150)(p126._status)
    end

    p126._queuedFinally = nil
    p126._queuedReject = nil
    p126._queuedResolve = nil

    if not t9.TEST then
        p126._parent = nil
        p126._consumers = nil
    end

    task.defer(coroutine.close, p126._thread)
end

function t9.prototype.now(p127, p128) -- line: 1889
    -- upvalues: t4 (copy), t9 (copy)
    local v151 = debug.traceback(nil, 2)

    if p127._status == t9.Status.Resolved then
        return p127:_andThen(v151, function(...) -- line: 1892
            return ...
        end)
    end

    return t9.reject(p128 == nil and t4.new({
        error = "This Promise was not resolved in time for :now()",
        kind = t4.Kind.NotResolvedInTime,
        context = ":now() was called at:\n\n" .. v151
    }) or p128)
end

function t9.retry(p129, p130, ...) -- line: 1934
    -- upvalues: t9 (copy)
    local v152

    if type(p129) == "function" then
        v152 = true
    else
        local v153 = false

        if type(p129) == "table" then
            local mt = getmetatable(p129)

            if mt then
                v153 = type((rawget(mt, "__call"))) == "function"
            end
        end

        v152 = not not v153
    end

    assert(v152, "Parameter #1 to Promise.retry must be a function")
    assert(type(p130) == "number", "Parameter #2 to Promise.retry must be a number")

    local t21 = { ... }
    local v155 = select("#", ...)

    return t9.resolve(p129(...)):catch(function(...) -- line: 1940
        -- upvalues: p129 (copy), p130 (copy), t21 (copy), v155 (copy), t9 (copy)
        if p130 > 0 then
            return t9.retry(p129, p130 - 1, unpack(t21, 1, v155))
        end

        return t9.reject(...)
    end)
end

function t9.retryWithDelay(p131, p132, p133, ...) -- line: 1962
    -- upvalues: t9 (copy)
    local v157

    if type(p131) == "function" then
        v157 = true
    else
        local v158 = false

        if type(p131) == "table" then
            local mt = getmetatable(p131)

            if mt then
                v158 = type((rawget(mt, "__call"))) == "function"
            end
        end

        v157 = not not v158
    end

    assert(v157, "Parameter #1 to Promise.retry must be a function")
    assert(type(p132) == "number", "Parameter #2 (times) to Promise.retry must be a number")
    assert(type(p133) == "number", "Parameter #3 (seconds) to Promise.retry must be a number")

    local t22 = { ... }
    local v161 = select("#", ...)

    return t9.resolve(p131(...)):catch(function(...) -- line: 1969
        -- upvalues: p131 (copy), p132 (copy), p133 (copy), t22 (copy), v161 (copy), t9 (copy)
        if p132 > 0 then
            t9.delay(p133):await()

            return t9.retryWithDelay(p131, p132 - 1, p133, unpack(t22, 1, v161))
        end

        return t9.reject(...)
    end)
end

function t9.fromEvent(p134, p135) -- line: 2004
    -- upvalues: t9 (copy)
    local v163 = p135 or function() -- line: 2005
        return true
    end

    return t9._new(debug.traceback(nil, 2), function(p136, _, p138) -- line: 2009
        -- upvalues: v163 (copy), p134 (copy)
        local connection
        local v164 = false

        local function disconnect() -- line: 2013
            -- upvalues: connection (ref)
            connection:Disconnect()
            connection = nil
        end

        connection = p134:Connect(function(...) -- line: 2022
            -- upvalues: p136 (copy), connection (ref), v164 (ref), v163 (copy)
            local v165 = v163(...)

            if v165 == true then
                p136(...)

                if connection then
                    connection:Disconnect()
                    connection = nil
                else
                    v164 = true
                end
            elseif type(v165) ~= "boolean" then
                error("Promise.fromEvent predicate should always return a boolean")
            end
        end)

        if v164 and connection then
            return disconnect()
        end

        p138(disconnect)
    end)
end

function t9.onUnhandledRejection(p139) -- line: 2056
    -- upvalues: t9 (copy)
    table.insert(t9._unhandledRejectionCallbacks, p139)

    return function() -- line: 2059
        -- upvalues: p139 (copy), t9 (copy)
        local v166 = table.find(t9._unhandledRejectionCallbacks, p139)

        if v166 then
            table.remove(t9._unhandledRejectionCallbacks, v166)
        end
    end
end

return t9
