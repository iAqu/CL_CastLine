-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local createBroadcastReceiver = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createBroadcastReceiver
local events = RuntimeLib.import(script, script.Parent.Parent, "network").events
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 11
        return "ReflexController"
    end
})

self.__index = self

function self.new(...) -- line: 16
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1) -- line: 20
    -- upvalues: createBroadcastReceiver (copy), events (copy)
    p1._receiver = createBroadcastReceiver({
        start = function() -- start | line: 22
            -- upvalues: events (copy)
            events.startReflexBroadcaster:fire()
        end
    })
end

function self.onInit(p2) -- line: 27
    -- upvalues: events (copy), clientProducer (copy)
    events.dispatchReflexActions:connect(function(p3) -- line: 28
        -- upvalues: p2 (copy)
        p2._receiver:dispatch(p3)
    end)
    clientProducer:applyMiddleware(p2._receiver.middleware)
end

function self.getClientProducer(_) -- line: 36
    -- upvalues: clientProducer (copy)
    return clientProducer
end

Reflect.defineMetadata(self, "identifier", "client/controllers/reflex-controller@ReflexController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnInit" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    ReflexController = self
}
