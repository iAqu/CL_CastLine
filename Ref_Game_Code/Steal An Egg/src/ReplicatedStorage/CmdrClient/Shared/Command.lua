-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Argument = require(script.Parent.Argument)
local v1 = RunService:IsServer()
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 12
    -- upvalues: t1 (copy)
    local t2 = {
        Response = nil,
        Dispatcher = p1.Dispatcher,
        Cmdr = p1.Dispatcher.Cmdr,
        Name = p1.CommandObject.Name,
        RawText = p1.Text,
        Object = p1.CommandObject,
        Group = p1.CommandObject.Group,
        State = {},
        Aliases = p1.CommandObject.Aliases,
        Alias = p1.Alias,
        Description = p1.CommandObject.Description,
        Executor = p1.Executor,
        ArgumentDefinitions = p1.CommandObject.Args,
        RawArguments = p1.Arguments,
        Arguments = {},
        Data = p1.Data
    }

    setmetatable(t2, t1)

    return t2
end

function t1.Parse(p2, p3) -- line: 40
    -- upvalues: Argument (copy)
    local v2 = false

    for v3, v4 in ipairs(p2.ArgumentDefinitions) do
        local v5 = v4

        if type(v4) == "function" then
            v5 = v4(p2)

            if v5 == nil then
                break
            end
        end

        local v6 = v5.Default == nil and v5.Optional ~= true

        if v6 then
            if v2 then
                error(("Command %q: Required arguments cannot occur after optional arguments."):format(p2.Name))
            end
        else
            v2 = true
        end

        if p2.RawArguments[v3] == nil and v6 and p3 ~= true then
            return false, ("Required argument #%d %s is missing."):format(v3, v5.Name)
        end

        if p2.RawArguments[v3] or p3 then
            p2.Arguments[v3] = Argument.new(p2, v5, p2.RawArguments[v3] or "")
        end
    end

    return true
end

function t1.Validate(p4, p5) -- line: 72
    p4._Validated = true

    local v7 = ""
    local v8 = true

    for v9, v10 in pairs(p4.Arguments) do
        local v11, v12 = v10:Validate(p5)

        if not v11 then
            v7 = ("%s; #%d %s: %s"):format(v7, v9, v10.Name, v12 or "error")
            v8 = false
        end
    end

    return v8, v7:sub(3)
end

function t1.GetLastArgument(p6) -- line: 91
    for i = #p6.Arguments, 1, -1 do
        if p6.Arguments[i].RawValue then
            return p6.Arguments[i]
        end
    end
end

function t1.GatherArgumentValues(p7) -- line: 100
    local t3 = {}

    for i = 1, #p7.ArgumentDefinitions do
        local v13 = p7.Arguments[i]

        if v13 then
            t3[i] = v13:GetValue()
        elseif type(p7.ArgumentDefinitions[i]) == "table" then
            t3[i] = p7.ArgumentDefinitions[i].Default
        end
    end

    return t3, #p7.ArgumentDefinitions
end

function t1.Run(p8) -- line: 117
    -- upvalues: v1 (copy)
    if p8._Validated == nil then
        error("Must validate a command before running.")
    end

    local v15 = p8.Dispatcher:RunHooks("BeforeRun", p8)

    if v15 then
        return v15
    end

    if not v1 and p8.Object.Data and p8.Data == nil then
        local v16, v17 = p8:GatherArgumentValues()

        p8.Data = p8.Object.Data(p8, unpack(v16, 1, v17))
    end

    if not v1 and p8.Object.ClientRun then
        local v18, v19 = p8:GatherArgumentValues()

        p8.Response = p8.Object.ClientRun(p8, unpack(v18, 1, v19))
    end

    if p8.Response == nil then
        if p8.Object.Run then
            local v20, v21 = p8:GatherArgumentValues()

            p8.Response = p8.Object.Run(p8, unpack(v20, 1, v21))
        elseif v1 then
            if p8.Object.ClientRun then
                warn(p8.Name, "command fell back to the server because ClientRun returned nil, but there is no server implementation! Either return a string from ClientRun, or create a server implementation for this command.")
            else
                warn(p8.Name, "command has no implementation!")
            end

            p8.Response = "No implementation."
        else
            p8.Response = p8.Dispatcher:Send(p8.RawText, p8.Data)
        end
    end

    return p8.Dispatcher:RunHooks("AfterRun", p8) or p8.Response
end

function t1.GetArgument(p9, p10) -- line: 164
    return p9.Arguments[p10]
end

function t1.GetData(p11) -- line: 172
    -- upvalues: v1 (copy)
    if not p11.Data and p11.Object.Data and not v1 then
        p11.Data = p11.Object.Data(p11)
    end

    return p11.Data
end

function t1.SendEvent(p12, p13, p14, ...) -- line: 185
    -- upvalues: Players (copy), v1 (copy)
    assert(typeof(p13) == "Instance", "Argument #1 must be a Player")
    assert(p13:IsA("Player"), "Argument #1 must be a Player")
    assert(type(p14) == "string", "Argument #2 must be a string")

    if v1 then
        p12.Dispatcher.Cmdr.RemoteEvent:FireClient(p13, p14, ...)
    elseif p12.Dispatcher.Cmdr.Events[p14] then
        assert(p13 == Players.LocalPlayer, "Event messages can only be sent to the local player on the client.")
        p12.Dispatcher.Cmdr.Events[p14](...)
    end
end

function t1.BroadcastEvent(p15, ...) -- line: 199
    -- upvalues: v1 (copy)
    if not v1 then
        error("Can't broadcast event messages from the client.", 2)
    end

    p15.Dispatcher.Cmdr.RemoteEvent:FireAllClients(...)
end

function t1.Reply(p16, ...) -- line: 208
    return p16:SendEvent(p16.Executor, "AddLine", ...)
end

function t1.GetStore(p17, ...) -- line: 213
    return p17.Dispatcher.Cmdr.Registry:GetStore(...)
end

function t1.HasImplementation(p18) -- line: 218
    -- upvalues: RunService (copy)
    return not (not (RunService:IsClient() and p18.Object.ClientRun) and not p18.Object.Run)
end

return t1
