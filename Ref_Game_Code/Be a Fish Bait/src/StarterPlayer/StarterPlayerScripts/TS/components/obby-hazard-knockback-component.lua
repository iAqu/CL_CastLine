-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out")
local BaseComponent, Component = out.BaseComponent, out.Component
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local handleLocalObbyHazardTouched = RuntimeLib.import(script, script.Parent, "obby-utils").handleLocalObbyHazardTouched
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 19
        return "ObbyHazardKnockbackComponent"
    end,
    __index = BaseComponent
})

self.__index = self

function self.new(...) -- line: 25
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, ...) -- line: 29
    -- upvalues: BaseComponent (copy), Maid (copy)
    BaseComponent.constructor(p1, ...)
    p1._maid = Maid.new()
end

function self.destroy(p2) -- line: 33
    -- upvalues: BaseComponent (copy)
    BaseComponent.destroy(p2)
    p2._maid:Destroy()
end

function self.onStart(p3) -- line: 37
    -- upvalues: handleLocalObbyHazardTouched (copy)
    for _, v3 in p3:_getHazardParts() do
        p3._maid:GiveTask(v3.Touched:Connect(function(p4) -- line: 39
            -- upvalues: handleLocalObbyHazardTouched (copy)
            return handleLocalObbyHazardTouched(p4)
        end))
    end
end

function self._getHazardParts(p5) -- line: 44
    if p5.instance:IsA("BasePart") then
        return { p5.instance }
    end

    local t4 = {}

    for _, descendant in p5.instance:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(t4, descendant)
        end
    end

    return t4
end

Reflect.defineMetadata(self, "identifier", "client/components/obby-hazard-knockback-component@ObbyHazardKnockbackComponent")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "ObbyObstacle",
        attributes = {}
    }
})

return {
    ObbyHazardKnockbackComponent = self
}
