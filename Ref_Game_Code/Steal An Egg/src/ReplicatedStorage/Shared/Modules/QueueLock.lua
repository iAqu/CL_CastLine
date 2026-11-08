-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

t1.__index = t1

local t2 = {}

t2.__index = t2

local function newLease(p1) -- line: 28
    -- upvalues: t2 (copy)
    return (setmetatable({
        lock = p1,
        takenAt = os.clock()
    }, t2))
end

local function nextInLine(p2) -- line: 34
    local line = p2.line
    local v1

    while true do
        if p2.head < p2.tail then
            v1 = line[p2.head]
            line[p2.head] = nil
            p2.head += 1

            if coroutine.status(v1) == "suspended" then
                break
            end

            continue
        end

        p2.head = 1
        p2.tail = 1

        return nil
    end

    return v1
end

local function failureReport(p3) -- line: 48
    return debug.traceback(("QueueLock body raised: %*"):format((tostring(p3))), 2)
end

local function settle(p4, p5, ...) -- line: 52
    p4:GiveBack()

    if not p5 then
        error(..., 0)
    end

    return ...
end

function t1.new() -- line: 60
    -- upvalues: t1 (copy)
    return (setmetatable({
        occupant = nil,
        head = 1,
        tail = 1,
        line = {}
    }, t1))
end

function t1.TryTake(p6) -- line: 66
    -- upvalues: t2 (copy)
    if p6.occupant then
        return nil
    end

    local v2 = setmetatable({
        lock = p6,
        takenAt = os.clock()
    }, t2)

    p6.occupant = v2

    return v2
end

function t1.Take(p7) -- line: 76
    local v3 = p7:TryTake()

    if v3 then
        return v3
    end

    p7.line[p7.tail] = coroutine.running()
    p7.tail += 1

    return coroutine.yield()
end

function t1.WithLock(p8, p9, ...) -- line: 88
    -- upvalues: failureReport (copy), settle (copy)
    return settle(p8:Take(), xpcall(p9, failureReport, ...))
end

function t1.Destroy(p10) -- line: 94
    if not p10.occupant then
        table.clear(p10)
        setmetatable(p10, nil)
    end
end

function t2.GiveBack(p11) -- line: 104
    -- upvalues: t2 (copy), nextInLine (copy)
    local lock = p11.lock

    if lock.occupant ~= p11 then
        error("GiveBack: this lease does not hold its lock", 2)
    end

    local v5 = nextInLine(lock)

    if v5 ~= nil then
        local v6 = setmetatable({
            lock = lock,
            takenAt = os.clock()
        }, t2)

        lock.occupant = v6
        task.defer(v5, v6)
    else
        lock.occupant = nil
    end
end

return t1
