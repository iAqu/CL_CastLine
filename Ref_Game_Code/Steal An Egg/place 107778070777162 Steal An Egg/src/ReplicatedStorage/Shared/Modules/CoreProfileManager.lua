-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Promise = require(ReplicatedStorage.Packages.Promise)
local Log = require(ReplicatedStorage.Packages.Log)
local Signal = require(ReplicatedStorage.Packages.Signal)
local t = require(ReplicatedStorage.Packages.t)
local v1 = Log.new()
local t1

local function defaultKeyOf(p1) -- line: 35
    -- upvalues: t (copy)
    t.strict(t.instanceIsA("Player"))(p1)

    return p1.UserId
end

local function locate(p2, p3) -- line: 40
    local v3 = assert(p2.keyOf(p3), "the key parser produced nothing for this player")

    return p2.store[v3], v3
end

t1 = {
    ProfileRemoving = Signal.new(),
    ProfileAdded = Signal.new(),
    is = function(p4) -- is | line: 49
        -- upvalues: t1 (ref)
        return typeof(p4) == "table" and getmetatable(p4) == t1
    end,
    new = function(p5, p6) -- new | line: 54
        -- upvalues: HttpService (copy), t (copy), t1 (ref), defaultKeyOf (copy)
        t.strict(t.optional(t.callback))(p6)
        t.strict(t.optional(t.table))(p5)

        return (setmetatable({
            id = HttpService:GenerateGUID(false):gsub("-", ""):lower(),
            store = p5 or {},
            keyOf = p6 or defaultKeyOf
        }, t1))
    end,
    Get = function(p7, p8) -- Get | line: 62
        -- upvalues: Promise (copy)
        local v5 = assert(p7.keyOf(p8), "the key parser produced nothing for this player")
        local v6 = p7.store[v5]

        if v6 == nil then
            return Promise.reject("no profile is registered under that lookup"), false
        end

        return Promise.resolve(v6), true
    end,
    GetAll = function(p9) -- GetAll | line: 71
        return table.clone(p9.store)
    end,
    GetAssert = function(p10, p11) -- GetAssert | line: 73
        return p10:Get(p11):expect()
    end,
    GetAsync = function(p12, p13) -- GetAsync | line: 75
        -- upvalues: Promise (copy), t1 (ref), locate (copy)
        local v8 = assert(p12.keyOf(p13), "the key parser produced nothing for this player")
        local v9 = p12.store[v8]

        if v9 then
            return v9
        end

        local v10 = select(2, locate(p12, p13))

        local function mine(p14, p15, _) -- line: 86
            -- upvalues: p12 (copy), v10 (copy)
            if p14 == p12.id then
                return p15 == v10
            end

            return false
        end

        local v11 = Promise.fromEvent(t1.ProfileAdded, mine):andThen(function(_, _, p19) -- line: 91
            return p19
        end)
        local v12 = Promise.fromEvent(t1.ProfileRemoving, mine):andThen(function() -- line: 93
            -- upvalues: v10 (copy), Promise (copy)
            return Promise.reject((("player %* left before a profile arrived"):format(v10)))
        end)

        return Promise.race({ v11, v12 }):expect()
    end,
    IsProfileRegistered = function(p20, p21) -- IsProfileRegistered | line: 99
        local v14 = assert(p20.keyOf(p21), "the key parser produced nothing for this player")

        return not not p20.store[v14]
    end,
    Set = function(p22, p23, ...) -- Set | line: 103
        -- upvalues: t1 (ref)
        local v16 = assert(p22.keyOf(p23), "the key parser produced nothing for this player")
        local v17 = p22.store[v16]

        p22.store[v16] = ...

        if not v17 then
            t1.ProfileAdded:Fire(p22.id, v16, ...)
        end
    end,
    Remove = function(p24, p25) -- Remove | line: 112
        -- upvalues: v1 (copy), t1 (ref)
        local v19 = assert(p24.keyOf(p25), "the key parser produced nothing for this player")
        local v20 = p24.store[v19]

        if v20 == nil then
            return false, v1:AtWarning():Log((("nothing to remove for an unloaded player: %*"):format(v19)))
        end

        t1.ProfileRemoving:Fire(p24.id, v19, v20)
        p24.store[v19] = nil

        return true
    end
}
t1.__index = t1

return t1
