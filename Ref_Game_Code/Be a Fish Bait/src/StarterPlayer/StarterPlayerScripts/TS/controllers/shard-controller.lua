-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local HttpService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").HttpService
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local events = RuntimeLib.import(script, script.Parent.Parent, "network").events
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 11
        return "ShardController"
    end
})

self.__index = self

function self.new(...) -- line: 16
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(_) -- line: 20
end

function self.onStart(_) -- line: 22
    -- upvalues: HttpService (copy), clientProducer (copy), events (copy)
    events.shardRewardGranted:connect(function(p3, p4) -- line: 23
        -- upvalues: HttpService (copy), clientProducer (copy)
        clientProducer.shardRewardReceived({
            amount = p4,
            id = HttpService:GenerateGUID(false),
            shardType = p3
        })
    end)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/shard-controller@ShardController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    ShardController = self
}
