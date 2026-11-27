-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local Util = require(script.Parent.Util)
local t1 = {
    Cmdr = nil,
    TypeMethods = Util.MakeDictionary({
        "Transform",
        "Validate",
        "Autocomplete",
        "Parse",
        "DisplayName",
        "Listable",
        "ValidateOnce",
        "Prefixes",
        "Default",
        "ArgumentOperatorAliases"
    }),
    CommandMethods = Util.MakeDictionary({
        "Name",
        "Aliases",
        "AutoExec",
        "Description",
        "Args",
        "Run",
        "ClientRun",
        "Data",
        "Group"
    }),
    CommandArgProps = Util.MakeDictionary({ "Name", "Type", "Description", "Optional", "Default" }),
    Types = {},
    TypeAliases = {},
    Commands = {},
    CommandsArray = {},
    Hooks = {
        BeforeRun = {},
        AfterRun = {}
    },
    Stores = setmetatable({}, {
        __index = function(p1, p2) -- __index | line: 19
            p1[p2] = {}

            return p1[p2]
        end
    }),
    AutoExecBuffer = {}
}

function t1.RegisterType(p3, p4, p5) -- line: 27
    if not p4 or typeof(p4) ~= "string" then
        error("Invalid type name provided: nil")
    end

    if not p4:find("^[%d%l]%w*$") then
        error(("Invalid type name provided: \"%s\", type names must be alphanumeric and start with a lower-case letter or a digit."):format(p4))
    end

    for v1 in pairs(p5) do
        if p3.TypeMethods[v1] == nil then
            error("Unknown key/method in type \"" .. p4 .. "\": " .. v1)
        end
    end

    if p3.Types[p4] ~= nil then
        error(("Type \"%s\" has already been registered."):format(p4))
    end

    p5.Name = p4
    p5.DisplayName = p5.DisplayName or p4
    p3.Types[p4] = p5

    if p5.Prefixes then
        p3:RegisterTypePrefix(p4, p5.Prefixes)
    end
end

function t1.RegisterTypePrefix(p6, p7, p8) -- line: 56
    if not p6.TypeAliases[p7] then
        p6.TypeAliases[p7] = p7
    end

    p6.TypeAliases[p7] = ("%s %s"):format(p6.TypeAliases[p7], p8)
end

function t1.RegisterTypeAlias(p9, p10, p11) -- line: 64
    assert(p9.TypeAliases[p10] == nil, ("Type alias %s already exists!"):format(p11))
    p9.TypeAliases[p10] = p11
end

function t1.RegisterTypesIn(p12, p13) -- line: 69
    for _, child in pairs(p13:GetChildren()) do
        if child:IsA("ModuleScript") then
            child.Parent = p12.Cmdr.ReplicatedRoot.Types
            require(child)(p12)
        else
            p12:RegisterTypesIn(child)
        end
    end
end

t1.RegisterHooksIn = t1.RegisterTypesIn

function t1.RegisterCommandObject(p14, p15, _) -- line: 83
    -- upvalues: RunService (copy)
    for v3 in pairs(p15) do
        if p14.CommandMethods[v3] == nil then
            error("Unknown key/method in command " .. (p15.Name or "unknown command") .. ": " .. v3)
        end
    end

    if p15.Args then
        for v4, v5 in pairs(p15.Args) do
            if type(v5) == "table" then
                for v6 in pairs(v5) do
                    if p14.CommandArgProps[v6] == nil then
                        error(("Unknown property in command \"%s\" argument #%d: %s"):format(p15.Name or "unknown", v4, v6))
                    end
                end
            end
        end
    end

    if p15.AutoExec and RunService:IsClient() then
        table.insert(p14.AutoExecBuffer, p15.AutoExec)
        p14:FlushAutoExecBufferDeferred()
    end

    local v7 = p14.Commands[p15.Name:lower()]

    if not (v7 and v7.Aliases) then
        if not v7 then
            table.insert(p14.CommandsArray, p15)
        end
    else
        for _, v8 in pairs(v7.Aliases) do
            p14.Commands[v8:lower()] = nil
        end
    end

    p14.Commands[p15.Name:lower()] = p15

    if p15.Aliases then
        for _, v9 in pairs(p15.Aliases) do
            p14.Commands[v9:lower()] = p15
        end
    end
end

function t1.RegisterCommand(p17, p18, p19, p20) -- line: 125
    -- upvalues: RunService (copy)
    local v10 = require(p18)

    assert(typeof(v10) == "table", (("Invalid return value from command script \"%*\" (CommandDefinition expected, got %*)"):format(p18.Name, (typeof(v10)))))

    if p19 then
        assert(RunService:IsServer(), "The commandServerScript parameter is not valid for client usage.")
        v10.Run = require(p19)
    end

    if p20 and not p20(v10) then
        return
    end

    p17:RegisterCommandObject(v10)
    p18.Parent = p17.Cmdr.ReplicatedRoot.Commands
end

function t1.RegisterCommandsIn(p21, p22, p23) -- line: 146
    local t4 = {}
    local t5 = {}

    for _, child in pairs(p22:GetChildren()) do
        if child:IsA("ModuleScript") then
            if child.Name:find("Server") then
                t4[child] = true
            else
                local v14 = p22:FindFirstChild(child.Name .. "Server")

                if v14 then
                    t5[v14] = true
                end

                p21:RegisterCommand(child, v14, p23)
            end
        else
            p21:RegisterCommandsIn(child, p23)
        end
    end

    for v15 in pairs(t4) do
        if not t5[v15] then
            warn("Command script " .. v15.Name .. " was skipped because it has 'Server' in its name, and has no equivalent shared script.")
        end
    end
end

function t1.RegisterDefaultCommands(p24, p25) -- line: 175
    -- upvalues: RunService (copy), Util (copy)
    local v16 = p25

    assert(RunService:IsServer(), "RegisterDefaultCommands cannot be called from the client.")

    local v18 = type(p25) == "table"

    if v18 then
        v16 = Util.MakeDictionary(p25)
    end

    p24:RegisterCommandsIn(p24.Cmdr.DefaultCommandsFolder, v18 and function(p26) -- line: 184
        -- upvalues: v16 (ref)
        return v16[p26.Group] or false
    end or v16)
end

function t1.GetCommand(p27, p28) -- line: 189
    p28 = p28 or ""

    return p27.Commands[p28:lower()]
end

function t1.GetCommands(p29) -- line: 194
    return p29.CommandsArray
end

function t1.GetCommandNames(p30) -- line: 198
    local t6 = {}

    for _, v20 in pairs(p30.CommandsArray) do
        table.insert(t6, v20.Name)
    end

    return t6
end

t1.GetCommandsAsStrings = t1.GetCommandNames

function t1.GetTypeNames(p31) -- line: 210
    local t7 = {}

    for v21 in pairs(p31.Types) do
        table.insert(t7, v21)
    end

    return t7
end

function t1.GetType(p32, p33) -- line: 220
    return p32.Types[p33]
end

function t1.GetTypeName(p34, p35) -- line: 224
    return p34.TypeAliases[p35] or p35
end

function t1.RegisterHook(p36, p37, p38, p39) -- line: 228
    if not p36.Hooks[p37] then
        error(("Invalid hook name: %q"):format(p37), 2)
    end

    table.insert(p36.Hooks[p37], {
        callback = p38,
        priority = p39 or 0
    })
    table.sort(p36.Hooks[p37], function(p40, p41) -- line: 234
        return p40.priority < p41.priority
    end)
end

t1.AddHook = t1.RegisterHook

function t1.GetStore(p42, p43) -- line: 239
    return p42.Stores[p43]
end

function t1.FlushAutoExecBufferDeferred(p44) -- line: 243
    -- upvalues: RunService (copy)
    if not p44.AutoExecFlushConnection then
        p44.AutoExecFlushConnection = RunService.Heartbeat:Connect(function() -- line: 248
            -- upvalues: p44 (copy)
            p44.AutoExecFlushConnection:Disconnect()
            p44.AutoExecFlushConnection = nil
            p44:FlushAutoExecBuffer()
        end)
    end
end

function t1.FlushAutoExecBuffer(p45) -- line: 255
    for _, v23 in ipairs(p45.AutoExecBuffer) do
        for _, v24 in ipairs(v23) do
            p45.Cmdr.Dispatcher:EvaluateAndRun(v24)
        end
    end

    p45.AutoExecBuffer = {}
end

return function(p46) -- line: 265
    -- upvalues: t1 (copy)
    t1.Cmdr = p46

    return t1
end
