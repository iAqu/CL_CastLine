-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local Util = require(script.Parent.Util)
local Command = require(script.Parent.Command)
local v1 = false
local t1 = {
    Cmdr = nil,
    Registry = nil
}

function t1.Evaluate(p1, p2, p3, p4, p5) -- line: 15
    -- upvalues: RunService (copy), Players (copy), Util (copy), Command (copy)
    if RunService:IsClient() == true and p3 ~= Players.LocalPlayer then
        error("Can't evaluate a command that isn't sent by the local player.")
    end

    local v2 = Util.SplitString(p2)
    local v3 = table.remove(v2, 1)
    local Command2 = p1.Registry:GetCommand(v3)

    if not Command2 then
        return false, ("%q is not a valid command name. Use the help command to see all available commands."):format((tostring(v3)))
    end

    local v4 = Util.MashExcessArguments(v2, #Command2.Args)
    local v5 = Command.new({
        Dispatcher = p1,
        Text = p2,
        CommandObject = Command2,
        Alias = v3,
        Executor = p3,
        Arguments = v4,
        Data = p5
    })
    local v6, v7 = v5:Parse(p4)

    if v6 then
        return v5
    end

    return false, v7
end

function t1.EvaluateAndRun(p6, p7, p8, p9) -- line: 48
    -- upvalues: RunService (copy), Players (copy)
    p8 = p8 or Players.LocalPlayer
    p9 = p9 or {}

    if RunService:IsClient() and p9.IsHuman then
        p6:PushHistory(p7)
    end

    local v10, v11 = p6:Evaluate(p7, p8, nil, p9.Data)

    if not v10 then
        return v11
    end

    local function v12() -- line: 62
        -- upvalues: v10 (copy)
        local v13, v14 = v10:Validate(true)

        if v13 then
            return v10:Run() or "Command executed."
        end

        return v14
    end

    local function v15(p10) -- line: 70
        return debug.traceback((tostring(p10)))
    end

    local v16, v17 = xpcall(v12, v15)

    if not v16 then
        warn(("Error occurred while evaluating command string %q\n%s"):format(p7, (tostring(v17))))
    end

    if not v16 or not v17 then
        v17 = "An error occurred while running this command. Check the console for more information."
    end

    return v17
end

function t1.Send(p11, p12, p13) -- line: 81
    -- upvalues: RunService (copy)
    if RunService:IsClient() == false then
        error("Dispatcher:Send can only be called from the client.")
    end

    return p11.Cmdr.RemoteFunction:InvokeServer(p12, {
        Data = p13
    })
end

function t1.Run(p14, ...) -- line: 91
    -- upvalues: Players (copy)
    if not Players.LocalPlayer then
        error("Dispatcher:Run can only be called from the client.")
    end

    local t2 = { ... }
    local v18 = t2[1]

    for i = 2, #t2 do
        v18 ..= " " .. tostring(t2[i])
    end

    local v20, v21 = p14:Evaluate(v18, Players.LocalPlayer)

    if not v20 then
        error(v21)
    end

    local v22, v23 = v20:Validate(true)

    if not v22 then
        error(v23)
    end

    return v20:Run()
end

function t1.RunHooks(p15, p16, p17, ...) -- line: 118
    -- upvalues: RunService (copy), v1 (ref)
    if not p15.Registry.Hooks[p16] then
        error(("Invalid hook name: %q"):format(p16), 2)
    end

    if p16 == "BeforeRun" and #p15.Registry.Hooks[p16] == 0 and p17.Group ~= "DefaultUtil" and p17.Group ~= "UserAlias" and p17:HasImplementation() then
        if not RunService:IsStudio() then
            return "Command blocked for security as no BeforeRun hook is configured."
        end

        if v1 == false then
            p17:Reply((RunService:IsServer() and "<Server>" or "<Client>") .. " Commands will not run in-game if no BeforeRun hook is configured. Learn more: https://eryn.io/Cmdr/guide/Hooks.html", Color3.fromRGB(255, 228, 26))
            v1 = true
        end
    end

    for _, v24 in ipairs(p15.Registry.Hooks[p16]) do
        local v25 = v24.callback(p17, ...)

        if v25 ~= nil then
            return (tostring(v25))
        end
    end
end

function t1.PushHistory(p18, p19) -- line: 149
    -- upvalues: RunService (copy), TeleportService (copy), Util (copy)
    assert(RunService:IsClient(), "PushHistory may only be used from the client.")

    local History = p18:GetHistory()

    if Util.TrimString(p19) ~= "" and p19 ~= History[#History] then
        History[#History + 1] = p19
        TeleportService:SetTeleportSetting("CmdrCommandHistory", History)
    end
end

function t1.GetHistory(_) -- line: 163
    -- upvalues: RunService (copy), TeleportService (copy)
    assert(RunService:IsClient(), "GetHistory may only be used from the client.")

    return TeleportService:GetTeleportSetting("CmdrCommandHistory") or {}
end

return function(p21) -- line: 169
    -- upvalues: t1 (copy)
    t1.Cmdr = p21
    t1.Registry = p21.Registry

    return t1
end
