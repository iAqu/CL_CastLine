-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out")
local BaseComponent, Component = out.BaseComponent, out.Component
local effect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").effect
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local reflexStateToAtom = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "reflex-utils").reflexStateToAtom
local selectCurrentWindow = RuntimeLib.import(script, script.Parent.Parent, "reflex", "slices", "selectors", "current-window.selectors").selectCurrentWindow
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 17
        return "ZoneTokenTraderNpcComponent"
    end,
    __index = BaseComponent
})

self.__index = self

function self.new(...) -- line: 23
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, ...) -- line: 27
    -- upvalues: BaseComponent (copy)
    BaseComponent.constructor(p1, ...)
end

function self.onStart(p2) -- line: 30
    -- upvalues: effect (copy), Players (copy), clientProducer (copy), reflexStateToAtom (copy), selectCurrentWindow (copy)
    p2.instance.Triggered:Connect(function(p3) -- line: 31
        -- upvalues: Players (copy), clientProducer (copy)
        if p3 ~= Players.LocalPlayer then
            return nil
        end

        clientProducer.windowOpened({
            currentWindow = "zoneTokenTrader"
        })
    end)

    local v3 = reflexStateToAtom(clientProducer, selectCurrentWindow)
    local v4 = v3[1]

    p2._disposeAtom = v3[2]
    p2._disposeEffect = effect(function() -- line: 44
        -- upvalues: p2 (copy), v4 (copy)
        p2.instance.Enabled = v4() ~= "zoneTokenTrader"
    end)
end

function self.destroy(p4) -- line: 48
    -- upvalues: BaseComponent (copy)
    local _disposeEffect = p4._disposeEffect

    if _disposeEffect ~= nil then
        _disposeEffect()
    end

    local _disposeAtom = p4._disposeAtom

    if _disposeAtom ~= nil then
        _disposeAtom()
    end

    BaseComponent.destroy(p4)
end

Reflect.defineMetadata(self, "identifier", "client/components/zone-token-trader-npc-component@ZoneTokenTraderNpcComponent")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "ZoneTokenTraderNpc",
        attributes = {},
        instanceGuard = t.instanceIsA("ProximityPrompt")
    }
})

return {
    ZoneTokenTraderNpcComponent = self
}
