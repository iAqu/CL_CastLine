-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local Util = require(script.Shared:WaitForChild("Util"))

if RunService:IsServer() == false then
    error("Cmdr server module is somehow running on a client!")
end

local v2 = setmetatable({
    ReplicatedRoot = nil,
    RemoteFunction = nil,
    RemoteEvent = nil,
    Util = Util,
    DefaultCommandsFolder = script.BuiltInCommands
}, {
    __index = function(p1, p2) -- __index | line: 16
        local v1 = p1.Registry[p2]

        if v1 and type(v1) == "function" then
            return function(_, ...) -- line: 19
                -- upvalues: p1 (copy), v1 (copy)
                return v1(p1.Registry, ...)
            end
        end
    end
})

v2.Registry = require(script.Shared.Registry)(v2)
v2.Dispatcher = require(script.Shared.Dispatcher)(v2)
require(script.Initialize)(v2)

v2.RemoteFunction.OnServerInvoke = function(p4, p5, p6) -- line: 33
    -- upvalues: v2 (copy)
    if #p5 > 1E+05 then
        return "Input too long"
    end

    return v2.Dispatcher:EvaluateAndRun(p5, p4, p6)
end

return v2
