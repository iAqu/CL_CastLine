-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local events = RuntimeLib.import(script, script.Parent.Parent, "network").events
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 9
        return "ServerRestartController"
    end
})

self.__index = self

function self.new(...) -- line: 14
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 18
    p1.reflexController = p2
end

function self.onStart(p3) -- line: 21
    -- upvalues: events (copy)
    events.serverRestartScheduled:connect(function(p4, p5, p6) -- line: 22
        -- upvalues: p3 (copy)
        p3.reflexController:getClientProducer().serverRestartScheduled({
            endTimestamp = p4,
            closeReason = p5,
            message = p6
        })
    end)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/server-restart-controller@ServerRestartController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/reflex-controller@ReflexController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    ServerRestartController = self
}
