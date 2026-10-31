-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local HttpService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").HttpService
local events = RuntimeLib.import(script, script.Parent.Parent, "network").events
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 11
        return "ClientStateSnapshotController"
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
    -- upvalues: HttpService (copy), events (copy), clientProducer (copy)
    events.requestClientStateSnapshot:connect(function(p3) -- line: 23
        -- upvalues: HttpService (copy), events (copy), clientProducer (copy)
        local v3 = clientProducer:getState()

        local function v4() -- line: 25
            -- upvalues: v3 (copy), HttpService (copy)
            return HttpService:JSONEncode(v3)
        end

        local ok, result = pcall(v4)

        if not ok or typeof(result) ~= "string" then
            return nil
        end

        events.saveClientStateSnapshot:fire(p3, result)
    end)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/client-state-snapshot-controller@ClientStateSnapshotController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    ClientStateSnapshotController = self
}
