-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local UserInputService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").UserInputService
local events = RuntimeLib.import(script, script.Parent.Parent, "network").events
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 12
        return "AfkTeleportController"
    end
})

self.__index = self

function self.new(...) -- line: 17
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1) -- line: 21
    p1._idleSeconds = 0
    p1._teleportFired = false
end

function self.onStart(p2) -- line: 25
    -- upvalues: UserInputService (copy)
    UserInputService.InputBegan:Connect(function() -- line: 26
        -- upvalues: p2 (copy)
        return p2:_resetTimer()
    end)
    UserInputService.InputChanged:Connect(function() -- line: 29
        -- upvalues: p2 (copy)
        return p2:_resetTimer()
    end)
end

function self.onTick(p3, p4) -- line: 33
    -- upvalues: events (copy)
    if p3._teleportFired then
        return nil
    end

    p3._idleSeconds += p4

    if p3._idleSeconds >= 900 then
        p3._teleportFired = true
        events.requestAfkTeleport:fire()
    end
end

function self._resetTimer(p5) -- line: 43
    p5._idleSeconds = 0
    p5._teleportFired = false
end

Reflect.defineMetadata(self, "identifier", "client/controllers/afk-teleport-controller@AfkTeleportController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnTick" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    AfkTeleportController = self
}
