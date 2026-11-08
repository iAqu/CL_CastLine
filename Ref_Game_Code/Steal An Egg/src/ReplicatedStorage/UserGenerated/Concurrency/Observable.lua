-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DeepEquals = require(ReplicatedStorage.UserGenerated.Collections.DeepEquals)
local Bindable = require(ReplicatedStorage.UserGenerated.Concurrency.Bindable)

local function Get(p1) -- line: 45
    return p1.Value
end

local function Set(p2, p3) -- line: 60
    -- upvalues: DeepEquals (copy)
    local v1 = if p2.Assertion then p2.Assertion(p3) else p3
    local Value = p2.Value

    p2.Value = v1

    if not DeepEquals(v1, Value) then
        p2.Changed:Fire(v1, Value)
    end

    return Value
end

local v2 = table.freeze({
    Get = Get,
    Set = Set
})
local v3 = table.freeze({
    __index = v2
})

local function new(p4, p5) -- line: 79
    -- upvalues: Bindable (copy), v3 (copy)
    assert(type(p4) == "function")

    local v5 = p4(p5)
    local t1 = {
        Changed = Bindable.new(),
        Assertion = p4,
        Value = v5
    }

    t1.Readonly = t1

    return (setmetatable(t1, v3))
end

local function Unasserted(p6) -- line: 92
    -- upvalues: Bindable (copy), v3 (copy)
    local t2 = {
        Changed = Bindable.new(),
        Value = p6
    }

    t2.Readonly = t2

    return (setmetatable(t2, v3))
end

return table.freeze({
    new = new,
    Unasserted = Unasserted
})
