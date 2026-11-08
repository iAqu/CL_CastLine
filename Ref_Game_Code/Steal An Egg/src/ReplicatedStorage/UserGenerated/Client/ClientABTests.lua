-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedABTests = require(ReplicatedStorage.UserGenerated.ABTests.SharedABTests)
local DeepFreezeUnsafe = require(ReplicatedStorage.UserGenerated.Collections.DeepFreezeUnsafe)
local Bindable = require(ReplicatedStorage.UserGenerated.Concurrency.Bindable)
local LocalPlayer = Players.LocalPlayer
local v1 = false
local v2 = Bindable.new()

local function IsLoaded() -- line: 31
    -- upvalues: v1 (ref)
    return v1
end

local v3

local function GetAssignmentsAsync(p1, p2) -- line: 36
    -- upvalues: LocalPlayer (copy), v3 (ref)
    assert(typeof(p1) == "Instance" and p1:IsA("Player"))
    assert(type(p2) == "boolean")

    if p1 ~= LocalPlayer then
        return nil
    end

    local v6

    while true do
        v6 = v3

        if v6 then
            break
        end

        if not p2 or not p1.Parent then
            return nil
        end

        task.wait()
    end

    return v6
end

local v7

local function GetAttributes(p3) -- line: 58
    -- upvalues: LocalPlayer (copy), v7 (ref)
    if p3 == LocalPlayer then
        return v7
    end

    assert(typeof(p3) == "Instance" and p3:IsA("Player"))

    return nil
end

local function GetAttribute(p4, p5, p6) -- line: 65
    -- upvalues: LocalPlayer (copy), v7 (ref)
    assert(type(p5) == "string")

    local v10

    if p4 == LocalPlayer then
        v10 = v7
    else
        assert(typeof(p4) == "Instance" and p4:IsA("Player"))
    end

    local v12 = v10 and v10[p5]

    if v12 == nil then
        return p6, false
    end

    return v12, true
end

local function GetAttributeAsync(p7, p8, p9) -- line: 74
    -- upvalues: GetAssignmentsAsync (copy), GetAttribute (copy)
    assert(type(p8) == "string")

    if GetAssignmentsAsync(p7, true) then
        return GetAttribute(p7, p8, p9)
    end

    return p9, false
end

local function GetJobAttributes() -- line: 82
    -- upvalues: LocalPlayer (copy), v7 (ref)
    if LocalPlayer == LocalPlayer then
        return v7
    end

    assert(typeof(LocalPlayer) == "Instance" and LocalPlayer:IsA("Player"))

    return nil
end

local function GetJobAttribute(p10, p11) -- line: 85
    -- upvalues: LocalPlayer (copy), GetAttribute (copy)
    return GetAttribute(LocalPlayer, p10, p11)
end

local function GetJobAttributeAsync(p12, p13) -- line: 88
    -- upvalues: LocalPlayer (copy), GetAttributeAsync (copy)
    return GetAttributeAsync(LocalPlayer, p12, p13)
end

local function GetJobAssignments() -- line: 91
    -- upvalues: v3 (ref)
    return v3
end

local function GetJobAssignmentsAsync(p14) -- line: 94
    -- upvalues: LocalPlayer (copy), GetAssignmentsAsync (copy)
    return GetAssignmentsAsync(LocalPlayer, p14)
end

local v15 = Bindable.new()
local v16 = Bindable.new()

SharedABTests.UpdateRemote.OnClientEvent:Connect(function(p15, p16) -- line: 102
    -- upvalues: DeepFreezeUnsafe (copy), LocalPlayer (copy), v1 (ref), v2 (copy), v3 (ref), v7 (ref), v15 (copy), v16 (copy)
    DeepFreezeUnsafe(p15)
    DeepFreezeUnsafe(p16)
    v7 = p15
    v3 = p16
    v1 = true
    v2:Fire()
    v15:Fire(LocalPlayer)
    v16:Fire()
end)

return table.freeze({
    GetAttributes = GetAttributes,
    GetAttribute = GetAttribute,
    GetAttributeAsync = GetAttributeAsync,
    GetAssignmentsAsync = GetAssignmentsAsync,
    GetJobAttributes = GetJobAttributes,
    GetJobAttribute = GetJobAttribute,
    GetJobAttributeAsync = GetJobAttributeAsync,
    GetJobAssignments = GetJobAssignments,
    GetJobAssignmentsAsync = GetJobAssignmentsAsync,
    IsLoaded = IsLoaded,
    Loaded = v2,
    PlayerUpdated = v15,
    JobUpdated = v16
})
