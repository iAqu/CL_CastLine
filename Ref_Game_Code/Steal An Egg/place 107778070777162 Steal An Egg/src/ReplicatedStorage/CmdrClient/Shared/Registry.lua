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
        __index = function(p1, p2) -- __index | line: 20
            p1[p2] = {}

            return p1[p2]
        end
    }),
    AutoExecBuffer = {}
}

function t1.RegisterType(p3, p4, p5) -- line: 30
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

function t1.RegisterTypePrefix(p6, p7, p8) -- line: 59
    if not p6.TypeAliases[p7] then
        p6.TypeAliases[p7] = p7
    end

    p6.TypeAliases[p7] = ("%s %s"):format(p6.TypeAliases[p7], p8)
end

function t1.RegisterTypeAlias(p9, p10, p11) -- line: 67
    assert(p9.TypeAliases[p10] == nil, ("Type alias %s already exists!"):format(p11))
    p9.TypeAliases[p10] = p11
end

function t1.RegisterTypesIn(p12, p13) -- line: 73
    for _, child in pairs(p13:GetChildren()) do
        if child:IsA("ModuleScript") then
            child.Parent = p12.Cmdr.ReplicatedRoot.Types

            local function v3() -- line: 78
                -- upvalues: p12 (copy), child (copy)
                require(child)(p12)
            end

            local function v4(p14) -- line: 80
                -- upvalues: child (copy)
                warn(("[CMDR] Type Init Error for %*:"):format(child.Name), p14)
            end

            xpcall(v3, v4)
            continue
        end

        p12:RegisterTypesIn(child)
    end
end

t1.RegisterHooksIn = t1.RegisterTypesIn

function t1.RegisterCommandObject(p15, p16, _) -- line: 94
    -- upvalues: RunService (copy)
    for v5 in pairs(p16) do
        if p15.CommandMethods[v5] == nil then
            error("Unknown key/method in command " .. (p16.Name or "unknown command") .. ": " .. v5)
        end
    end

    if p16.Args then
        for v6, v7 in pairs(p16.Args) do
            if type(v7) == "table" then
                for v8 in pairs(v7) do
                    if p15.CommandArgProps[v8] == nil then
                        error(("Unknown property in command \"%s\" argument #%d: %s"):format(p16.Name or "unknown", v6, v8))
                    end
                end
            end
        end
    end

    if p16.AutoExec and RunService:IsClient() then
        table.insert(p15.AutoExecBuffer, p16.AutoExec)
        p15:FlushAutoExecBufferDeferred()
    end

    local v9 = p15.Commands[p16.Name:lower()]

    if not (v9 and v9.Aliases) then
        if not v9 then
            table.insert(p15.CommandsArray, p16)
        end
    else
        for _, v10 in pairs(v9.Aliases) do
            p15.Commands[v10:lower()] = nil
        end
    end

    p15.Commands[p16.Name:lower()] = p16

    if p16.Aliases then
        for _, v11 in pairs(p16.Aliases) do
            p15.Commands[v11:lower()] = p16
        end
    end
end

function t1.RegisterCommand(p18, p19, p20, p21) -- line: 139
    -- upvalues: RunService (copy)
    local v12 = require(p19)

    assert(typeof(v12) == "table", (("Invalid return value from command script \"%*\" (CommandDefinition expected, got %*)"):format(p19.Name, (typeof(v12)))))

    if p20 then
        assert(RunService:IsServer(), "The commandServerScript parameter is not valid for client usage.")
        v12.Run = require(p20)
    end

    if p21 and not p21(v12) then
        return
    end

    p18:RegisterCommandObject(v12)
    p19.Parent = p18.Cmdr.ReplicatedRoot.Commands
end

function t1.RegisterCommandsIn(p22, p23, p24) -- line: 161
    local t4 = {}
    local t5 = {}

    for _, child in pairs(p23:GetChildren()) do
        if child:IsA("ModuleScript") then
            if child.Name:find("Server") then
                t4[child] = true
            else
                local v16 = p23:FindFirstChild(child.Name .. "Server")

                if v16 then
                    t5[v16] = true
                end

                local function v17() -- line: 174
                    -- upvalues: p22 (copy), p24 (copy), child (copy), v16 (copy)
                    p22:RegisterCommand(child, v16, p24)
                end

                local function v18(p25) -- line: 176
                    -- upvalues: child (copy)
                    warn(("[CMDR] Command Init Error for %*:"):format(child.Name), p25)
                end

                xpcall(v17, v18)
            end
        else
            p22:RegisterCommandsIn(child, p24)
        end
    end

    for v19 in pairs(t4) do
        if not t5[v19] then
            warn("Command script " .. v19.Name .. " was skipped because it has 'Server' in its name, and has no equivalent shared script.")
        end
    end
end

function t1.RegisterDefaultCommands(p26, p27) -- line: 195
    -- upvalues: RunService (copy), Util (copy)
    local v20 = p27

    assert(RunService:IsServer(), "RegisterDefaultCommands cannot be called from the client.")

    local v22 = type(p27) == "table"

    if v22 then
        v20 = Util.MakeDictionary(p27)
    end

    p26:RegisterCommandsIn(p26.Cmdr.DefaultCommandsFolder, v22 and function(p28) -- line: 204
        -- upvalues: v20 (ref)
        return v20[p28.Group] or false
    end or v20)
end

function t1.GetCommand(p29, p30) -- line: 210
    p30 = p30 or ""

    return p29.Commands[p30:lower()]
end

function t1.GetCommands(p31) -- line: 216
    return p31.CommandsArray
end

function t1.GetCommandNames(p32) -- line: 221
    local t6 = {}

    for _, v24 in pairs(p32.CommandsArray) do
        table.insert(t6, v24.Name)
    end

    return t6
end

t1.GetCommandsAsStrings = t1.GetCommandNames

function t1.GetTypeNames(p33) -- line: 234
    local t7 = {}

    for v25 in pairs(p33.Types) do
        table.insert(t7, v25)
    end

    return t7
end

function t1.GetType(p34, p35) -- line: 246
    return p34.Types[p35]
end

function t1.GetTypeName(p36, p37) -- line: 251
    return p36.TypeAliases[p37] or p37
end

function t1.RegisterHook(p38, p39, p40, p41) -- line: 256
    if not p38.Hooks[p39] then
        error(("Invalid hook name: %q"):format(p39), 2)
    end

    table.insert(p38.Hooks[p39], {
        callback = p40,
        priority = p41 or 0
    })
    table.sort(p38.Hooks[p39], function(p42, p43) -- line: 262
        return p42.priority < p43.priority
    end)
end

t1.AddHook = t1.RegisterHook

function t1.GetStore(p44, p45) -- line: 270
    return p44.Stores[p45]
end

function t1.FlushAutoExecBufferDeferred(p46) -- line: 275
    -- upvalues: RunService (copy)
    if not p46.AutoExecFlushConnection then
        p46.AutoExecFlushConnection = RunService.Heartbeat:Connect(function() -- line: 280
            -- upvalues: p46 (copy)
            p46.AutoExecFlushConnection:Disconnect()
            p46.AutoExecFlushConnection = nil
            p46:FlushAutoExecBuffer()
        end)
    end
end

function t1.FlushAutoExecBuffer(p47) -- line: 288
    for _, v27 in ipairs(p47.AutoExecBuffer) do
        for _, v28 in ipairs(v27) do
            p47.Cmdr.Dispatcher:EvaluateAndRun(v28)
        end
    end

    p47.AutoExecBuffer = {}
end

return function(p48) -- line: 298
    -- upvalues: t1 (copy)
    t1.Cmdr = p48

    return t1
end
