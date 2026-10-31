-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local HttpService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").HttpService
local events = RuntimeLib.import(script, script.Parent.Parent, "network").events
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 10
        return "ServerFeedbackController"
    end
})

self.__index = self

function self.new(...) -- line: 15
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 19
    p1._reflexController = p2
end

function self.onStart(p3) -- line: 22
    -- upvalues: HttpService (copy), events (copy)
    local v3 = p3._reflexController:getClientProducer()

    events.displayFeedbackMessage:connect(function(p4, p5, p6) -- line: 24
        -- upvalues: v3 (copy), HttpService (copy)
        v3.onScreenFeedbackAdded({
            duration = p6,
            id = HttpService:GenerateGUID(false),
            message = p4,
            type = p5
        })
    end)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/server-feedback-controller@ServerFeedbackController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/reflex-controller@ReflexController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    ServerFeedbackController = self
}
