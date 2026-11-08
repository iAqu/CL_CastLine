-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Signal = require(ReplicatedStorage.Packages.Signal)
local environment = require(ReplicatedStorage.Shared.environment)
local v1 = RunService:IsServer()

assert(RunService:IsRunning(), "Networking should not be required outside of a runtime context (got Studio edit mode).")

local name, env

local function ErrorSignal(p1) -- line: 68
    -- upvalues: Signal (copy)
    local v3 = Signal.new()

    v3.Connect = function() -- line: 70
        -- upvalues: p1 (copy)
        error(p1)
    end

    return v3
end

local function WarnOnInvoked(p2) -- line: 76
    return function() -- line: 77
        -- upvalues: p2 (copy)
        warn(p2)
    end
end

local function ErrorOnInvoked(p3) -- line: 82
    return function() -- line: 83
        -- upvalues: p3 (copy)
        error(p3)
    end
end

local function WaitFor(p4, p5) -- line: 88
    local v4 = false

    task.delay(3, function() -- line: 90
        -- upvalues: p4 (copy), v4 (ref)
        if not v4 then
            warn((("Waited longer than %* second for Networking.%* to exist."):format(3, p4)))
        end
    end)

    local v5 = script:WaitForChild(p4, p5)

    v4 = true

    return v5
end

local function ExtendRemoteEvent(p6) -- line: 101
    -- upvalues: Players (copy)
    local t1 = {
        OnServerEvent = p6.OnServerEvent,
        OnClientEvent = p6.OnClientEvent
    }

    function t1.FireClient(_, p8, ...) -- line: 107
        -- upvalues: p6 (copy)
        p6:FireClient(p8, ...)
    end

    function t1.FireAllClients(_, ...) -- line: 111
        -- upvalues: p6 (copy)
        p6:FireAllClients(...)
    end

    function t1.FireServer(_, ...) -- line: 115
        -- upvalues: p6 (copy)
        p6:FireServer(...)
    end

    function t1.FireAllExcept(_, p12, ...) -- line: 119
        -- upvalues: p6 (copy), Players (copy)
        assert(typeof(p12) == "Instance" and p12:IsA("Player"), (("invalid player to ignore \"%*\""):format(p12)))

        for _, player in Players:GetPlayers() do
            if player ~= p12 then
                p6:FireClient(player, ...)
            end
        end
    end

    return t1
end

local function AssertNamespaceOpen(p13, p14) -- line: 132
    -- upvalues: name (ref), env (ref)
    assert(type(name) == "string" and type(env) == "string", (("Networking.%*(\"%*\") called outside of an open namespace -- did you forget Networking.namespace({{...}}) above?"):format(p13, p14)))
end

local function RemoteEvent(p15) -- line: 140
    -- upvalues: Signal (copy), environment (copy), v1 (copy), name (ref), env (ref), ExtendRemoteEvent (copy)
    assert(type(name) == "string" and type(env) == "string", (("Networking.remoteEvent(\"%*\") called outside of an open namespace -- did you forget Networking.namespace({{...}}) above?"):format(p15)))

    local v12 = ("RE/%*/%*"):format(name, p15)

    if v1 then
        local RemoteEvent = Instance.new("RemoteEvent")

        RemoteEvent.Name = v12
        RemoteEvent.Parent = script

        if env == "all" or environment.placeType == env then
            return (ExtendRemoteEvent(RemoteEvent))
        end

        local v13 = ("tried to FireClient with mock remote %*"):format(v12)
        local t2 = {}

        t2.FireClient = function() -- line: 77
            -- upvalues: v13 (copy)
            warn(v13)
        end

        local v14 = ("tried to FireAllClients with mock remote %*"):format(v12)

        t2.FireAllClients = function() -- line: 77
            -- upvalues: v14 (copy)
            warn(v14)
        end

        local v15 = ("tried to FireAllExcept with mock remote %*"):format(v12)

        t2.FireAllExcept = function() -- line: 77
            -- upvalues: v15 (copy)
            warn(v15)
        end

        t2.OnServerEvent = Signal.new()

        local v16 = Signal.new()
        local v17 = "tried to use OnClientEvent on the server on a mock remote."

        v16.Connect = function() -- line: 70
            -- upvalues: v17 (copy)
            error(v17)
        end

        t2.OnClientEvent = v16

        local v18 = ("tried to FireServer %* on the server"):format(v12)

        t2.FireServer = function() -- line: 83
            -- upvalues: v18 (copy)
            error(v18)
        end

        RemoteEvent.OnServerEvent:Connect(function(p16) -- line: 163
            -- upvalues: v12 (copy)
            error((("Remote invocation from %* for remote %* was filtered."):format(p16, v12)))
        end)

        return t2
    end

    local v19 = false

    task.delay(3, function() -- line: 90
        -- upvalues: v12 (copy), v19 (ref)
        if not v19 then
            warn((("Waited longer than %* second for Networking.%* to exist."):format(3, v12)))
        end
    end)

    local v20 = script:WaitForChild(v12, 10)

    v19 = true
    assert(v20, (("Server did not create RemoteEvent \"%*\""):format(v12)))

    return v20
end

local function UnreliableRemoteEvent(p17) -- line: 175
    -- upvalues: environment (copy), v1 (copy), name (ref), env (ref), ExtendRemoteEvent (copy)
    assert(type(name) == "string" and type(env) == "string", (("Networking.unreliableRemoteEvent(\"%*\") called outside of an open namespace -- did you forget Networking.namespace({{...}}) above?"):format(p17)))

    local v24 = ("URE/%*/%*"):format(name, p17)

    if v1 then
        local UnreliableRemoteEvent = Instance.new("UnreliableRemoteEvent")

        UnreliableRemoteEvent.Name = v24
        UnreliableRemoteEvent.Parent = script

        if env == "all" or environment.placeType == env then
            return (ExtendRemoteEvent(UnreliableRemoteEvent))
        end

        local UnreliableRemoteEvent2 = Instance.new("UnreliableRemoteEvent")

        UnreliableRemoteEvent2.Name = v24

        return (ExtendRemoteEvent(UnreliableRemoteEvent2))
    end

    local v25 = false

    task.delay(3, function() -- line: 90
        -- upvalues: v24 (copy), v25 (ref)
        if not v25 then
            warn((("Waited longer than %* second for Networking.%* to exist."):format(3, v24)))
        end
    end)

    local v26 = script:WaitForChild(v24, 10)

    v25 = true
    assert(v26, (("Server did not create UnreliableRemoteEvent \"%*\""):format(v24)))

    return v26
end

local function RemoteFunction(p18) -- line: 199
    -- upvalues: environment (copy), v1 (copy), name (ref), env (ref)
    assert(type(name) == "string" and type(env) == "string", (("Networking.remoteFunction(\"%*\") called outside of an open namespace -- did you forget Networking.namespace({{...}}) above?"):format(p18)))

    local v30 = ("RF/%*/%*"):format(name, p18)

    if v1 then
        local RemoteFunction = Instance.new("RemoteFunction")

        RemoteFunction.Name = v30
        RemoteFunction.Parent = script

        if env == "all" or environment.placeType == env then
            return RemoteFunction
        end

        local RemoteFunction2 = Instance.new("RemoteFunction")

        RemoteFunction2.Name = v30

        return RemoteFunction2
    end

    local v31 = false

    task.delay(3, function() -- line: 90
        -- upvalues: v30 (copy), v31 (ref)
        if not v31 then
            warn((("Waited longer than %* second for Networking.%* to exist."):format(3, v30)))
        end
    end)

    local v32 = script:WaitForChild(v30, 10)

    v31 = true
    assert(v32, (("Server did not create RemoteFunction \"%*\""):format(v30)))

    return v32
end

return table.freeze({
    namespace = function(p19) -- namespace | line: 224
        -- upvalues: name (ref), env (ref)
        name = p19.name
        env = p19.env
    end,
    close = function() -- close | line: 228
        -- upvalues: name (ref), env (ref)
        name = nil
        env = nil
    end,
    remoteEvent = RemoteEvent,
    unreliableRemoteEvent = UnreliableRemoteEvent,
    remoteFunction = RemoteFunction
})
