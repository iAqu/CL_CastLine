-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out")
local BaseComponent, Component = out.BaseComponent, out.Component
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 16
        return "BestFishModelComponent"
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
    p1._angle = 0
end

function self.onTick(p2, p3) -- line: 30
    p2._angle = (p2._angle - 1.0471975511965976 * p3) % 6.283185307179586

    local v3 = CFrame.Angles(0, p2._angle, 0)
    local v5 = Vector3.new(p2.attributes.basePivotX, p2.attributes.headY + 30, p2.attributes.basePivotZ)

    p2.instance:PivotTo(CFrame.new(v5) * v3)
end

Reflect.defineMetadata(self, "identifier", "client/components/best-fish-model-component@BestFishModelComponent")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnTick" })
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "BestFishModel",
        defaults = {
            basePivotX = 0,
            basePivotZ = 0,
            headY = 0
        },
        attributes = {
            basePivotX = t.number,
            basePivotZ = t.number,
            headY = t.number
        },
        instanceGuard = t.instanceIsA("Model")
    }
})

return {
    BestFishModelComponent = self
}
