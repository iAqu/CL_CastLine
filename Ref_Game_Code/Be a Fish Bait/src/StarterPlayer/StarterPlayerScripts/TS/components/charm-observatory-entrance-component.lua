-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out")
local BaseComponent, Component = out.BaseComponent, out.Component
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, Workspace = services.Players, services.Workspace
local events = RuntimeLib.import(script, script.Parent.Parent, "network").events
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 16
        return "CharmObservatoryEntranceComponent"
    end,
    __index = BaseComponent
})

self.__index = self

function self.new(...) -- line: 22
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, ...) -- line: 26
    -- upvalues: BaseComponent (copy)
    BaseComponent.constructor(p1, ...)
    p1._logged = false
end

function self.onStart(p2) -- line: 30
    -- upvalues: Players (copy), events (copy)
    p2._touchedConnection = p2.instance.Touched:Connect(function(p3) -- line: 31
        -- upvalues: p2 (copy), Players (copy), events (copy)
        if p2._logged or p3.Parent ~= Players.LocalPlayer.Character then
            return nil
        end

        p2._logged = true
        events.analyticsCharmObservatoryEntered:fire()
    end)
end

function self.onDestroy(p4) -- line: 39
    local _touchedConnection = p4._touchedConnection

    if _touchedConnection ~= nil then
        _touchedConnection:Disconnect()
    end
end

Reflect.defineMetadata(self, "identifier", "client/components/charm-observatory-entrance-component@CharmObservatoryEntranceComponent")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "CharmObservatoryEntrance",
        ancestorWhitelist = { Workspace },
        defaults = {},
        attributes = {},
        instanceGuard = t.instanceIsA("BasePart")
    }
})

return {
    CharmObservatoryEntranceComponent = self
}
