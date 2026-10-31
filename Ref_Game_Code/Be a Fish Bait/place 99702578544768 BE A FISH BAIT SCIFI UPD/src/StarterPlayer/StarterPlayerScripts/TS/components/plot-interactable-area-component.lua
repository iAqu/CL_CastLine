-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local Component = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out").Component
local WithDetectableComponent = RuntimeLib.import(script, script.Parent, "with-detectable-component").WithDetectableComponent
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 11
        return "PlotInteractableAreaComponent"
    end,
    __index = WithDetectableComponent
})

self.__index = self

function self.new(...) -- line: 17
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 21
    -- upvalues: WithDetectableComponent (copy)
    WithDetectableComponent.constructor(p1, p2)
    p1._components = p2
end

function self.onStart(p3) -- line: 25
    -- upvalues: WithDetectableComponent (copy)
    WithDetectableComponent.onStart(p3)
end

function self._getDebugPrefix(p4) -- line: 28
    return (("PlotInteractableAreaComponent %*:"):format((p4.instance:GetFullName())))
end

Reflect.defineMetadata(self, "identifier", "client/components/plot-interactable-area-component@PlotInteractableAreaComponent")
Reflect.defineMetadata(self, "flamework:parameters", { "$c:components@Components" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "PlotInteractableArea",
        defaults = {
            ownerUserId = ""
        },
        attributes = {
            ownerUserId = t.string
        },
        instanceGuard = t.intersection(t.instanceIsA("Model"), t.children({
            DetectableArea = t.instanceIsA("Part")
        }))
    }
})

return {
    PlotInteractableAreaComponent = self
}
