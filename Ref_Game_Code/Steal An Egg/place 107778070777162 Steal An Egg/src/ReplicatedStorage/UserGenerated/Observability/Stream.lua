-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observability = require(ReplicatedStorage.UserGenerated.Observability)
local Codec = require(ReplicatedStorage.UserGenerated.Observability.Codec)
local Op = Observability.Op
local t1 = {}

t1.__index = t1

function t1.new(p1, p2) -- line: 28
    -- upvalues: Codec (copy), t1 (copy)
    local v1 = setmetatable({
        Init = false,
        LastTime = 0,
        Records = 0,
        Main = nil,
        StageTime = 0,
        StageStart = 0,
        BatchBytes = p1,
        OnBatch = p2,
        W = Codec.newWriter(p1 + 1024),
        Scratch = Codec.newWriter(16384),
        Staged = {}
    }, t1)

    v1:_writeTime()

    return v1
end

function t1._writeTime(p3) -- line: 46
    -- upvalues: Op (copy)
    local W = p3.W

    W:u8(Op.Time)
    W:u32(p3.LastTime)
end

function t1.Time(p4, p5) -- line: 52
    -- upvalues: Codec (copy), Op (copy)
    local v3 = math.clamp(math.floor(p5), 0, 4294967295)

    if p4.Main then
        p4.StageTime = v3
    elseif p4.LastTime < v3 then
        local W = p4.W

        W:u8(Op.TimeDelta)
        Codec.varuint(W, v3 - p4.LastTime)
        p4.LastTime = v3
    end
end

function t1.BeginStage(p6) -- line: 65
    assert(not p6.Main, "stage already open")
    p6.Main = p6.W
    p6.W = p6.Scratch
    p6.W.len = 0
    p6.StageStart = 0
    p6.StageTime = p6.LastTime
    table.clear(p6.Staged)
end

function t1.CommitStage(p7) -- line: 75
    local W = p7.W

    p7.W = p7.Main
    p7.Main = nil

    local Staged = p7.Staged

    table.sort(Staged, function(p8, p9) -- line: 80
        if p8.T == p9.T then
            return p8.Index < p9.Index
        end

        return p8.T < p9.T
    end)

    for _, v5 in Staged do
        p7:Time(v5.T)

        local W2 = p7.W
        local v6 = v5.Finish - v5.Start

        W2:_ensure(v6)
        buffer.copy(W2.buf, W2.len, W.buf, v5.Start, v6)
        W2.len += v6
        p7:EndRecord()
    end

    table.clear(Staged)
end

function t1.EndRecord(p10) -- line: 99
    if p10.Main then
        local Staged = p10.Staged
        local len = p10.W.len

        table.insert(Staged, {
            T = p10.StageTime,
            Start = p10.StageStart,
            Finish = len,
            Index = #Staged + 1
        })
        p10.StageStart = len
    else
        p10.Records += 1

        if p10.W.len >= p10.BatchBytes then
            p10:Cut()
        end
    end
end

function t1.Cut(p11) -- line: 114
    -- upvalues: Codec (copy)
    if p11.Records == 0 then
        return
    end

    local v7 = p11.W:finish()

    p11.W = Codec.newWriter(p11.BatchBytes + 1024)
    p11.Records = 0
    p11:_writeTime()
    p11.OnBatch(v7, p11.Init)
end

function t1.ClockSync(p12, p13) -- line: 126
    -- upvalues: Op (copy)
    local W = p12.W

    W:u8(Op.ClockSync)
    W:f64(p13)
    p12:EndRecord()
end

return t1
