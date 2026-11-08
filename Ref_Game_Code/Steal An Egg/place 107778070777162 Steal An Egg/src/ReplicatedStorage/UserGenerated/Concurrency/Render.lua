-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Logging = require(ReplicatedStorage.UserGenerated.Logging)
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts)
local t1 = {}

function t1.Disconnect(p1) -- line: 51
    p1.Connection:Disconnect()
    p1:OnDisconnected()
end

function t1.OnDisconnected(p2) -- line: 56
    if p2.Vars.Disconnected then
        return
    end

    p2.Vars.Disconnected = true

    for _, v1 in ipairs(p2.Callbacks) do
        task.spawn(v1)
    end

    table.clear(p2.Callbacks)
end

function t1.Then(p3, p4) -- line: 67
    -- upvalues: Asserts (copy)
    Asserts.Function(p4)

    if p3.Vars.Disconnected then
        task.spawn(p4)
    else
        table.insert(p3.Callbacks, p4)
    end
end

local v2 = table.freeze({
    __index = table.freeze(t1)
})

function new(p5, p6) -- line: 79
    -- upvalues: RunService (copy), Logging (copy), Asserts (copy), v2 (copy)
    Asserts.FiniteNonNegative(p5)
    Asserts.Function(p6)

    local v3 = setmetatable({
        Connection = nil,
        Callbacks = {},
        Vars = {
            Disconnected = false
        }
    }, v2)
    local n1 = 0
    local connection

    connection = RunService.RenderStepped:Connect(function(p7) -- line: 94
        -- upvalues: p5 (copy), p6 (copy), v3 (copy), n1 (ref), connection (ref), Logging (copy)
        local v4 = n1

        n1 += p7

        local v5

        if n1 >= p5 then
            n1 = p5
            v5 = true
            connection:Disconnect()
        else
            v5 = false
        end

        local v6 = if n1 >= p5 then 1 else n1 / p5
        local v7 = n1
        local v8 = n1 - v4
        local ok, result = pcall(p6, v6, v7, v8)

        if not ok then
            Logging.Warn("RenderError", result)
        end

        if not ok or result ~= nil then
            v5 = true
            connection:Disconnect()
        end

        if v5 then
            v3:OnDisconnected()
        end
    end)
    v3.Connection = connection
    table.freeze(v3)

    return v3
end

return new
