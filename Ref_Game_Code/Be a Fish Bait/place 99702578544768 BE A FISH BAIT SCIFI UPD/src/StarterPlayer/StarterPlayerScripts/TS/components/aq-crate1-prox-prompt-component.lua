-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out")
local BaseComponent, Component = out.BaseComponent, out.Component
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 14
        return "AqCrate1ProxPromptComponent"
    end,
    __index = BaseComponent
})

self.__index = self

function self.new(...) -- line: 20
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, ...) -- line: 24
    -- upvalues: BaseComponent (copy)
    BaseComponent.constructor(p1, ...)
end

function self.onStart(p2) -- line: 27
    -- upvalues: Players (copy), clientProducer (copy)
    p2.instance.Triggered:Connect(function(p3) -- line: 28
        -- upvalues: Players (copy), clientProducer (copy)
        if p3 ~= Players.LocalPlayer then
            return nil
        end

        clientProducer.windowOpened({
            currentWindow = "aquariumShop",
            aquariumShopSection = "crates"
        })
    end)
end

Reflect.defineMetadata(self, "identifier", "client/components/aq-crate1-prox-prompt-component@AqCrate1ProxPromptComponent")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "AqCrate1ProxPrompt",
        attributes = {},
        instanceGuard = t.instanceIsA("ProximityPrompt")
    }
})

return {
    AqCrate1ProxPromptComponent = self
}
