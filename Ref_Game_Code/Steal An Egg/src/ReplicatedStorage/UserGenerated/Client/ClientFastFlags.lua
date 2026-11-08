-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

game:GetService("Players")
assert(RunService:IsClient())

local Bindable = require(ReplicatedStorage.UserGenerated.Concurrency.Bindable)
local SharedFastFlags = require(ReplicatedStorage.UserGenerated.FastFlags.SharedFastFlags)
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts)
local DeepEqualsPureUnsafe = require(ReplicatedStorage.UserGenerated.Collections.DeepEqualsPureUnsafe)
local DeepCopyPureUnsafe = require(ReplicatedStorage.UserGenerated.Collections.DeepCopyPureUnsafe)
local DeepFreezeUnsafe = require(ReplicatedStorage.UserGenerated.Collections.DeepFreezeUnsafe)
local ObjectPaths = require(ReplicatedStorage.UserGenerated.Strings.ObjectPaths)
local t1 = {}
local v1 = table.freeze({
    __index = t1
})

function t1.Get(p1) -- line: 45
    return p1.Value
end

function t1.GetAsync(p2) -- line: 48
    if p2.ValueLoaded then
        return p2.Value
    end

    local thread = coroutine.running()
    local connection = p2.Loaded:Connect(function() -- line: 53
        -- upvalues: thread (copy)
        task.spawn(thread)
    end)

    coroutine.yield()
    connection:Disconnect()

    return p2.Value
end

function t1.IsLoaded(p3) -- line: 60
    return p3.ValueLoaded
end

local function IsA(p4) -- line: 64
    -- upvalues: v1 (copy)
    if type(p4) == "table" then
        return getmetatable(p4) == v1
    end

    return false
end

local function Assert(p5) -- line: 68
    -- upvalues: v1 (copy)
    if type(p5) ~= "table" or getmetatable(p5) ~= v1 then
        error("FastFlag", 2)
    end

    return p5
end

table.freeze(t1)

local NullValue, UpdateRemote = SharedFastFlags.NullValue, SharedFastFlags.UpdateRemote
local t2 = {}
local v2 = false
local v3 = {}
local v4 = Bindable.new()

local function DecodeValue(p6) -- line: 86
    -- upvalues: NullValue (copy)
    return if p6 ~= NullValue then p6 else nil
end

local function SetContent(p7, p8) -- line: 90
    -- upvalues: DeepEqualsPureUnsafe (copy), DeepFreezeUnsafe (copy), NullValue (copy), t2 (copy), v2 (ref), v3 (ref), v4 (copy)
    local v5 = table.clone(v3)

    for v6, v7 in pairs(p7) do
        v5[v6] = v7
    end

    DeepFreezeUnsafe(v5)
    v3 = v5

    local t3 = {}
    local t4 = {}

    for v8, v9 in pairs(p7) do
        local v10 = t2[v8]

        if v10 then
            local v11 = if v9 == NullValue then nil else v9
            local Value = v10.Value

            if not DeepEqualsPureUnsafe(v11, Value) then
                v10.Value = v11
                table.insert(t4, {
                    instance = v10,
                    value = v11,
                    prevValue = Value
                })
            end

            if p8 and not v10.ValueLoaded then
                v10.ValueLoaded = true
                table.insert(t3, v10)
            end
        end
    end

    local v12 = p8 and not v2

    if v12 then
        v2 = true
    end

    for _, v13 in ipairs(t3) do
        v13.Loaded:Fire()
    end

    if v12 then
        v4:Fire()
    end

    for _, v14 in ipairs(t4) do
        v14.instance.Changed:Fire(v14.value, v14.prevValue)
    end
end

local function Create(p9, p10, p11) -- line: 141
    -- upvalues: Bindable (copy), Asserts (copy), DeepCopyPureUnsafe (copy), DeepFreezeUnsafe (copy), ObjectPaths (copy), v1 (copy), NullValue (copy), t2 (copy), v2 (ref), v3 (ref)
    Asserts.String(p9)
    Asserts.Function(p10)
    p10(p11)
    Asserts.Optional(Asserts.Storable)(p11)

    local v15 = DeepCopyPureUnsafe(p11)

    DeepFreezeUnsafe(v15)
    assert(not t2[p9], (("ConflictingKeys: %*, %*"):format(p9, p9)))

    for v18, _ in pairs(t2) do
        if ObjectPaths.HasHierarchicalOverlap(p9, v18) then
            error((("ConflictingKeys: %*, %*"):format(p9, v18)))
        end
    end

    local v19 = v3[p9]
    local v20, v21

    if v19 ~= nil then
        v21 = if v19 == NullValue then nil else v19
        v20 = v2
    else
        v21 = v15
        v20 = false
    end

    local v22 = setmetatable({
        Replicated = true,
        Changed = Bindable.new(),
        Loaded = Bindable.new(),
        Key = p9,
        DefaultValue = v15,
        Assertion = p10,
        ValueLoaded = v20,
        Value = v21
    }, v1)

    t2[p9] = v22

    return v22
end

local t7 = {
    Loaded = v4,
    IsA = IsA,
    Assert = Assert,
    Replicated = function(p12, p13, p14) -- Replicated | line: 193
        -- upvalues: Create (copy)
        return (Create(p12, p13, p14))
    end
}

function t7.Private(_, _, _) -- line: 197
    error("ServerOnly")
end

function t7.Get(p18) -- line: 201
    -- upvalues: Asserts (copy), t2 (copy)
    local v23 = t2[p18]

    if v23 then
        return v23
    end

    Asserts.String(p18)
    error((("UnknownKey: '%*'"):format(p18)))
end

function t7.IsLoaded() -- line: 210
    -- upvalues: v2 (ref)
    return v2
end

UpdateRemote.OnClientEvent:Connect(SetContent)
table.freeze(t7)

return t7
