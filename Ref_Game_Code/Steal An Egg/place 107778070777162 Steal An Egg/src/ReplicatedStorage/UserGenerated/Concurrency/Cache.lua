-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Bindable = require(ReplicatedStorage.UserGenerated.Concurrency.Bindable)
local DeepFreeze = require(game.ReplicatedStorage.UserGenerated.Collections.DeepFreeze)
local Lock = require(game.ReplicatedStorage.UserGenerated.Concurrency.Lock)
local Asserts = require(game.ReplicatedStorage.UserGenerated.Lang.Asserts)

local function ValueAge(p1, p2) -- line: 38
    local RetrievedAt = p1.RetrievedAt

    return if RetrievedAt then p2 - RetrievedAt else nil
end

local function AttemptAge(p3, p4) -- line: 43
    local AttemptedAt = p3.AttemptedAt

    if AttemptedAt then
        return p4 - AttemptedAt
    end

    return 1e999
end

local t1 = {}

function t1.RemoveUsedAt(_, _) -- line: 83
end

function t1.InsertUsedAt(_, _) -- line: 87
end

function t1.SetUsedAt(p9, p10, p11) -- line: 91
    p9:RemoveUsedAt(p10)
    p10.UsedAt = p11
    p9:InsertUsedAt(p10)
end

function t1.Get(p12, p13) -- line: 100
    local v1 = p12.AssertKey(p13)
    local v2 = p12.Cache[v1]

    if not v2 then
        return nil
    end

    local elapsed = os.clock()
    local RetrievedAt = v2.RetrievedAt
    local v3 = if RetrievedAt then elapsed - RetrievedAt else nil

    if not v3 or p12.MaxAge <= v3 and not p12.ReturnStale then
        return nil
    end

    p12:SetUsedAt(v2, elapsed)

    return v2.Value
end

function AsyncCallback(p14, p15, p16, p17) -- line: 115
    -- upvalues: DeepFreeze (copy)
    local RetrievedAt = p15.RetrievedAt
    local v4 = if RetrievedAt then p17 - RetrievedAt else nil

    if v4 and v4 < p14.MaxAge then
        return p15.Value
    end

    local AttemptedAt = p15.AttemptedAt

    if not ((if AttemptedAt then p17 - AttemptedAt else 1e999) < p14.FailureRetryDelay) then
        p15.AttemptedAt = p17

        local Callback = p14.Callback
        local ok, result = pcall(Callback, p16)
        local elapsed = os.clock()

        p15.AttemptedAt = elapsed
        p14:SetUsedAt(p15, elapsed)

        if ok then
            if p14.Freeze then
                result = DeepFreeze(result)
            end

            p15.Value = result
            p15.RetrievedAt = elapsed
            p14.Updated:Fire(p16)

            return result
        end
    end

    return if p14.ReturnStale then p15.Value else nil
end

function t1.GetAsync(p18, p19) -- line: 142
    -- upvalues: Lock (copy)
    local elapsed = os.clock()
    local v5 = p18.AssertKey(p19)
    local v6 = p18.Cache[v5]

    if v6 then
        p18:SetUsedAt(v6, elapsed)
    else
        v6 = {
            Lock = Lock.new(),
            UsedAt = elapsed
        }
        p18.Cache[v5] = v6
        p18:InsertUsedAt(v6)
    end

    return v6.Lock:Call(AsyncCallback, p18, v6, p19, elapsed)
end

function t1.Delete(p20, p21) -- line: 160
    local v7 = p20.AssertKey(p21)

    if p20.Cache[v7] then
        p20.Cache[v7] = nil
        p20.Deleted:Fire(p21)
    end
end

local v8 = table.freeze({
    __index = table.freeze(t1)
})
local v9 = Asserts.Table({
    Callback = Asserts.Function,
    AssertKey = Asserts.Function,
    MaxAge = Asserts.Optional(Asserts.NonNegative),
    FailureRetryDelay = Asserts.Optional(Asserts.NonNegative),
    ReturnStale = Asserts.Optional(Asserts.Boolean),
    Freeze = Asserts.Optional(Asserts.Boolean)
})
local t2 = {
    new = function(p22) -- new | line: 196
        -- upvalues: Bindable (copy), v8 (copy), v9 (copy)
        v9(p22)

        local v10 = setmetatable({
            Updated = Bindable.new(),
            Deleted = Bindable.new(),
            Callback = p22.Callback,
            AssertKey = p22.AssertKey,
            MaxAge = p22.MaxAge or 1e999,
            FailureRetryDelay = p22.FailureRetryDelay or 300,
            ReturnStale = p22.ReturnStale == nil or p22.ReturnStale,
            Freeze = p22.Freeze == nil or p22.Freeze,
            Cache = {}
        }, v8)

        table.freeze(v10)

        return v10
    end
}

return table.freeze(t2)
