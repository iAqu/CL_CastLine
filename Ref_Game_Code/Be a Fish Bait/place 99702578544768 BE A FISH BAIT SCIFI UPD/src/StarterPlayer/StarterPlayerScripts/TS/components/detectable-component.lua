-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out")
local Component, BaseComponent = out.Component, out.BaseComponent
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local isPartOnAnotherPart = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "detectable-utils").isPartOnAnotherPart
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 19
        return "DetectableComponent"
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
    -- upvalues: BaseComponent (copy)
    BaseComponent.constructor(p1, ...)
end

function self.onStart(p2) -- line: 32
    p2.instance.Anchored = true
    p2.instance.CanCollide = false
    p2.instance.CanQuery = true
end

function self.isPlayerInside(p3) -- line: 38
    -- upvalues: Players (copy)
    local Character = Players.LocalPlayer.Character

    if Character then
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart then
            return p3:isBasePartInside(HumanoidRootPart, (Vector3.new(0, 0.5, 0)))
        end
    end

    return false
end

function self.isBasePartInside(p4, p5, p6) -- line: 49
    -- upvalues: isPartOnAnotherPart (copy)
    local v3 = if p6 == nil then Vector3.new() else p6

    return isPartOnAnotherPart(p5, p4.instance, v3)
end

function self._getDebugPrefix(p7) -- line: 55
    return (("DetectableComponent %*:"):format((p7.instance:GetFullName())))
end

Reflect.defineMetadata(self, "identifier", "client/components/detectable-component@DetectableComponent")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "Detectable",
        attributes = {},
        instanceGuard = t.instanceIsA("BasePart")
    }
})

return {
    DetectableComponent = self
}
