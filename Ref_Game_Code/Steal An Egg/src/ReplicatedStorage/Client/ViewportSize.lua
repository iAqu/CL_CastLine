-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Signal = require(ReplicatedStorage.Packages.Signal)
local v1 = table.freeze({
    Floor = 0.3,
    Ceiling = 2.4
})
local t1 = {
    Changed = Signal.new()
}

local function scaleFor(p1) -- line: 20
    -- upvalues: v1 (copy)
    return (math.clamp(math.min(p1.X, p1.Y) / 1100, v1.Floor, v1.Ceiling))
end

local function snapshotOf(p2) -- line: 25
    -- upvalues: v1 (copy)
    return {
        Size = p2,
        Scale = math.clamp(math.min(p2.X, p2.Y) / 1100, v1.Floor, v1.Ceiling)
    }
end

local CurrentCamera = Workspace.CurrentCamera
local v4 = if CurrentCamera then CurrentCamera.ViewportSize else Vector2.one * 1100
local t3 = {}
local t4 = t3

t3.Size = v4
t3.Scale = math.clamp(math.min(v4.X, v4.Y) / 1100, v1.Floor, v1.Ceiling)

local v6 = false
local connection

local function flush() -- line: 34
    -- upvalues: Workspace (copy), v1 (copy), t1 (copy), t4 (ref), v6 (ref)
    v6 = false

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera ~= nil then
        local ViewportSize = CurrentCamera.ViewportSize

        if ViewportSize ~= t4.Size then
            t4 = {
                Size = ViewportSize,
                Scale = math.clamp(math.min(ViewportSize.X, ViewportSize.Y) / 1100, v1.Floor, v1.Ceiling)
            }
            t1.Changed:Fire(t4.Size, t4.Scale)
        end
    end
end

local function queueFlush() -- line: 51
    -- upvalues: v6 (ref), flush (copy)
    if not v6 then
        v6 = true
        task.defer(flush)
    end
end

local function follow(p3) -- line: 59
    -- upvalues: v6 (ref), connection (ref), flush (copy), queueFlush (copy)
    if connection ~= nil then
        connection:Disconnect()
        connection = nil
    end

    if p3 ~= nil then
        connection = p3:GetPropertyChangedSignal("ViewportSize"):Connect(queueFlush)

        if not v6 then
            v6 = true
            task.defer(flush)
        end
    end
end

function t1.Get() -- line: 71
    -- upvalues: t4 (ref)
    return t4.Size
end

function t1.ReadScale() -- line: 75
    -- upvalues: t4 (ref)
    return t4.Scale
end

function t1.Observe(p4) -- line: 81
    -- upvalues: t1 (copy), t4 (ref)
    local connection = t1.Changed:Connect(p4)

    p4(t4.Size, t4.Scale)

    return function() -- line: 84
        -- upvalues: connection (copy)
        connection:Disconnect()
    end
end

Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 89
    -- upvalues: Workspace (copy), v6 (ref), connection (ref), flush (copy), queueFlush (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if connection ~= nil then
        connection:Disconnect()
        connection = nil
    end

    if CurrentCamera ~= nil then
        connection = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(queueFlush)

        if not v6 then
            v6 = true
            task.defer(flush)
        end
    end
end)

if connection ~= nil then
    connection:Disconnect()
    connection = nil
end

if CurrentCamera ~= nil then
    connection = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(queueFlush)

    if not v6 then
        v6 = true
        task.defer(flush)
    end
end

return table.freeze(t1)
