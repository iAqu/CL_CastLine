-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out")
local BaseComponent, Component = out.BaseComponent, out.Component
local ReplicatedStorage = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local v1 = t.interface({})
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 14
        return "SoundGroupComponent"
    end,
    __index = BaseComponent
})

self.__index = self

function self.constructor(p1, ...) -- line: 20
    -- upvalues: BaseComponent (copy)
    BaseComponent.constructor(p1, ...)
end

function self.onStart(p2) -- line: 23
    p2:_validateDescendants()
end

function self._validateDescendants(p3) -- line: 26
    local Descendants = p3.instance:GetDescendants()
    local t3 = {}

    local function v3(p4) -- line: 30
        return p4:IsA("Sound")
    end

    local n1 = 0

    for v4, v5 in Descendants do
        local _ = v4 - 1

        if v5:IsA("Sound") == true then
            n1 += 1
            t3[n1] = v5
        end
    end

    local function v6(p5) -- line: 42
        -- upvalues: p3 (copy)
        if not p5:HasTag("Sound") then
            error("[src/shared/components/sound-group-component.ts:30]" .. ("%* Sound tag not found for descendant %* in sound group %*."):format(p3:_getDebugPrefix(), p5:GetFullName(), (p3.instance:GetFullName())))
        end
    end

    for v7, v8 in t3 do
        v6(v8, v7 - 1, t3)
    end
end

function self._getDebugPrefix(p6) -- line: 52
    return (("SoundGroupComponent %*:"):format((p6.instance:GetFullName())))
end

Reflect.defineMetadata(self, "identifier", "shared/components/sound-group-component@SoundGroupComponent")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "SoundGroup",
        ancestorWhitelist = { ReplicatedStorage },
        attributes = {},
        instanceGuard = t.instanceIsA("SoundGroup")
    }
})

return {
    soundGroupAttributesGuard = v1,
    SoundGroupComponent = self
}
