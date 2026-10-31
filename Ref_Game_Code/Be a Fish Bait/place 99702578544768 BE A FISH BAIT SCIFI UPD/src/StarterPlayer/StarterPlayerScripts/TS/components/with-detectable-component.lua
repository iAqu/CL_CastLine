-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local BaseComponent = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out").BaseComponent
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 8
        return "WithDetectableComponent"
    end,
    __index = BaseComponent
})

self.__index = self

function self.constructor(p1, p2) -- line: 14
    -- upvalues: BaseComponent (copy)
    BaseComponent.constructor(p1)
    p1._components = p2
end

function self.onStart(p3) -- line: 18
    if p3.instance.ModelStreamingMode ~= Enum.ModelStreamingMode.Atomic and p3.instance.ModelStreamingMode ~= Enum.ModelStreamingMode.Persistent then
        error("[src/client/components/with-detectable-component.ts:20]" .. ("%* is not set to Atomic or Persistent ModelStreamingMode"):format((p3:_getDebugPrefix())))
    end

    p3:_initialiseDetectableComponent()
end

function self._initialiseDetectableComponent(p4) -- line: 24
    local v2 = p4:getDetectableComponentInstances()

    if #v2 ~= 1 then
        if #v2 == 0 then
            error("[src/client/components/with-detectable-component.ts:32]" .. ("%* has no detectable components"):format((p4:_getDebugPrefix())))
        else
            error("[src/client/components/with-detectable-component.ts:34]" .. ("%* has multiple detectable components"):format((p4:_getDebugPrefix())))
        end
    end

    p4.detectableComponent = v2[1]
end

function self.getDetectableComponentInstances(p5) -- line: 35
    local t3 = {}

    for _, descendant in p5.instance:GetDescendants() do
        if descendant:HasTag("Detectable") then
            local v3 = p5._components:getComponent(descendant, "client/components/detectable-component@DetectableComponent")

            if v3 then
                table.insert(t3, v3)
            end
        end
    end

    return t3
end

return {
    WithDetectableComponent = self
}
