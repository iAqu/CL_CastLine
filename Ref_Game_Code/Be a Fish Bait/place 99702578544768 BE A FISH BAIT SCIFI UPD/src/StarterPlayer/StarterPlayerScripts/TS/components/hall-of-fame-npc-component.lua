-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out")
local BaseComponent, Component = out.BaseComponent, out.Component
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 12
        return "HallOfFameNpcComponent"
    end,
    __index = BaseComponent
})

self.__index = self

function self.new(...) -- line: 18
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, ...) -- line: 22
    -- upvalues: BaseComponent (copy)
    BaseComponent.constructor(p1, ...)
end

Reflect.defineMetadata(self, "identifier", "client/components/hall-of-fame-npc-component@HallOfFameNpcComponent")
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "HallOfFameNpc",
        defaults = {
            npcId = ""
        },
        attributes = {
            npcId = t.string
        },
        instanceGuard = t.instanceIsA("BasePart")
    }
})

return {
    HallOfFameNpcComponent = self
}
