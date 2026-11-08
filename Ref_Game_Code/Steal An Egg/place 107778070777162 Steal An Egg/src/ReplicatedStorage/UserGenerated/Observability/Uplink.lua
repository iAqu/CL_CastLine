-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observability = require(ReplicatedStorage.UserGenerated.Observability)

local function newQueue() -- line: 29
    return {
        Head = 1,
        Tail = 0,
        Bytes = 0,
        Items = {},
        Times = {}
    }
end

local function push(p1, p2, p3) -- line: 33
    p1.Tail += 1
    p1.Items[p1.Tail] = p2
    p1.Times[p1.Tail] = p3
    p1.Bytes += buffer.len(p2)
end

local function peek(p4) -- line: 40
    return p4.Items[p4.Head]
end

local function pop(p5) -- line: 44
    local v1 = p5.Items[p5.Head]

    p5.Items[p5.Head] = nil
    p5.Times[p5.Head] = nil
    p5.Head += 1
    p5.Bytes -= buffer.len(v1)

    if p5.Head > p5.Tail then
        p5.Head = 1
        p5.Tail = 0
    end
end

local t1 = {}

t1.__index = t1

function t1.new(p6, p7, p8) -- line: 59
    -- upvalues: newQueue (copy), t1 (copy)
    return (setmetatable({
        SentBytes = 0,
        Elapsed = 0,
        BurstLeft = 0,
        Stopped = false,
        Config = p6,
        Send = p7,
        OnStop = p8,
        Stream = newQueue(),
        Init = newQueue(),
        StreamTokens = p6.StreamBytesPerSecond,
        InitTokens = p6.InitBytesPerSecond
    }, t1))
end

function t1.Push(p9, p10, p11) -- line: 80
    -- upvalues: Observability (copy)
    if p9.Stopped then
        return
    end

    if p11 then
        local Init, Elapsed = p9.Init, p9.Elapsed

        Init.Tail += 1
        Init.Items[Init.Tail] = p10
        Init.Times[Init.Tail] = Elapsed
        Init.Bytes += buffer.len(p10)
    else
        local Stream, Elapsed = p9.Stream, p9.Elapsed

        Stream.Tail += 1
        Stream.Items[Stream.Tail] = p10
        Stream.Times[Stream.Tail] = Elapsed
        Stream.Bytes += buffer.len(p10)

        if p9.Stream.Bytes > p9.Config.QueueDropBytes then
            p9:Stop(Observability.StopReason.Dropped)
        end
    end
end

function t1.Burst(p12, p13) -- line: 96
    p12.BurstLeft = p13
end

function t1._drain(p14, p15, p16, p17, p18) -- line: 101
    -- upvalues: Observability (copy)
    local v3 = math.min(p16 + p17 * p18, p17)

    while true do
        local v4 = p15.Items[p15.Head]

        if not v4 then
            return v3
        end

        local v5 = buffer.len(v4)

        if v3 < math.min(v5, p17) then
            return v3
        end

        if p14.SentBytes + v5 > p14.Config.SessionCapBytes then
            break
        end

        local v6 = p15.Items[p15.Head]

        p15.Items[p15.Head] = nil
        p15.Times[p15.Head] = nil
        p15.Head += 1
        p15.Bytes -= buffer.len(v6)

        if p15.Head > p15.Tail then
            p15.Head = 1
            p15.Tail = 0
        end

        v3 -= v5
        p14.SentBytes += v5
        p14.Send(v4)
    end

    p14:Stop(Observability.StopReason.Capped)

    return v3
end

function t1.Step(p19, p20) -- line: 125
    -- upvalues: Observability (copy)
    if p19.Stopped then
        return
    end

    p19.Elapsed += p20
    p19.InitTokens = p19:_drain(p19.Init, p19.InitTokens, p19.Config.InitBytesPerSecond, p20)

    if p19.Stopped then
        return
    end

    local Stream, Init = p19.Stream, p19.Init

    if Init.Items[Init.Head] then
        for i = Stream.Head, Stream.Tail do
            Stream.Times[i] = p19.Elapsed
        end
    else
        local StreamBytesPerSecond = p19.Config.StreamBytesPerSecond

        if p19.BurstLeft > 0 then
            p19.BurstLeft -= p20
            StreamBytesPerSecond = p19.Config.BurstBytesPerSecond
        end

        p19.StreamTokens = p19:_drain(Stream, p19.StreamTokens, StreamBytesPerSecond, p20)

        if not p19.Stopped then
            local v7 = Stream.Times[Stream.Head]

            if v7 and p19.Elapsed - v7 > p19.Config.QueueMaxLagSeconds then
                p19:Stop(Observability.StopReason.Dropped)
            end
        end
    end
end

function t1.Stop(p21, p22) -- line: 158
    -- upvalues: newQueue (copy)
    if p21.Stopped then
        return
    end

    p21.Stopped = true
    p21.Stream = newQueue()
    p21.Init = newQueue()
    p21.OnStop(p22)
end

return t1
