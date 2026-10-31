-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out")
local BaseComponent, Component = out.BaseComponent, out.Component
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local MarketplaceService, Players = services.MarketplaceService, services.Players
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent, "utils").localPlayerUserId
local vipGamepassName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "gamepass-utils").vipGamepassName
local vipGamepassProductId = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-utils").vipGamepassProductId
local selectPlayerOwnsGamepass = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerOwnsGamepass
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 23
        return "VipOnlyPartComponent"
    end,
    __index = BaseComponent
})

self.__index = self

function self.new(...) -- line: 29
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, ...) -- line: 33
    -- upvalues: BaseComponent (copy), Maid (copy)
    BaseComponent.constructor(p1, ...)
    p1._maid = Maid.new()
    p1._lastPromptTime = 0
end

function self.onStart(p2) -- line: 38
    p2._maid:GiveTask(p2.instance.Touched:Connect(function(p3) -- line: 39
        -- upvalues: p2 (copy)
        return p2:_onTouched(p3)
    end))
end

function self.destroy(p4) -- line: 43
    -- upvalues: BaseComponent (copy)
    BaseComponent.destroy(p4)
    p4._maid:Destroy()
end

function self.isPlayerInside(p5) -- line: 47
    -- upvalues: Players (copy)
    local Character = Players.LocalPlayer.Character

    if not Character then
        return false
    end

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return false
    end

    local v3 = p5.instance.CFrame:PointToObjectSpace(HumanoidRootPart.Position)
    local v4 = p5.instance.Size / 2

    if math.abs(v3.X) <= v4.X then
        if not (math.abs(v3.Y) <= v4.Y) then
            return false
        end

        return math.abs(v3.Z) <= v4.Z
    end

    return false
end

function self._onTouched(p6, p7) -- line: 63
    -- upvalues: MarketplaceService (copy), Players (copy), clientProducer (copy), localPlayerUserId (copy), vipGamepassName (copy), vipGamepassProductId (copy), selectPlayerOwnsGamepass (copy)
    if p7.Parent ~= Players.LocalPlayer.Character or selectPlayerOwnsGamepass(localPlayerUserId, vipGamepassName)(clientProducer:getState()) then
        return nil
    end

    local elapsed = os.clock()

    if elapsed - p6._lastPromptTime < 5 then
        return nil
    end

    p6._lastPromptTime = elapsed
    MarketplaceService:PromptGamePassPurchase(Players.LocalPlayer, vipGamepassProductId)
end

Reflect.defineMetadata(self, "identifier", "client/components/vip-only-part-component@VipOnlyPartComponent")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "VipOnlyPart",
        attributes = {},
        instanceGuard = t.instanceIsA("BasePart")
    }
})

return {
    VipOnlyPartComponent = self
}
