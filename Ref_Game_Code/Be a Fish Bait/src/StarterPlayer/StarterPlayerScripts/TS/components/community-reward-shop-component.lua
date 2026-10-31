-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local Component = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out").Component
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local isPartOnAnotherPart = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "detectable-utils").isPartOnAnotherPart
local WithDetectableComponent = RuntimeLib.import(script, script.Parent, "with-detectable-component").WithDetectableComponent
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 13
        return "CommunityRewardShopComponent"
    end,
    __index = WithDetectableComponent
})

self.__index = self

function self.new(...) -- line: 19
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 23
    -- upvalues: WithDetectableComponent (copy)
    WithDetectableComponent.constructor(p1, p2)
    p1._components = p2
end

function self.onStart(p3) -- line: 27
    -- upvalues: WithDetectableComponent (copy)
    WithDetectableComponent.onStart(p3)
end

function self.isPlayerInside(p4) -- line: 30
    -- upvalues: Players (copy), isPartOnAnotherPart (copy)
    local Character = Players.LocalPlayer.Character

    if Character then
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart then
            return isPartOnAnotherPart(HumanoidRootPart, p4.instance.DetectableArea, (Vector3.new(0, 0.5, 0)))
        end
    end

    return false
end

function self._getDebugPrefix(p5) -- line: 41
    return (("CommunityRewardShopComponent %*:"):format((p5.instance:GetFullName())))
end

Reflect.defineMetadata(self, "identifier", "client/components/community-reward-shop-component@CommunityRewardShopComponent")
Reflect.defineMetadata(self, "flamework:parameters", { "$c:components@Components" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "CommunityRewardShop",
        attributes = {},
        instanceGuard = t.intersection(t.instanceIsA("Model"), t.children({
            DetectableArea = t.instanceIsA("Part")
        }))
    }
})

return {
    CommunityRewardShopComponent = self
}
