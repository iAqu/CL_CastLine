-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 9
        return "CoinController"
    end
})

self.__index = self

function self.new(...) -- line: 14
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 18
    p1._components = p2
end

function self.onTick(p3) -- line: 21
    -- upvalues: Players (copy)
    local Character = Players.LocalPlayer.Character

    if Character ~= nil then
        Character = Character:FindFirstChild("HumanoidRootPart")
    end

    for _, v3 in p3._components:getAllComponents("client/components/collectable-coin-component@CollectableCoinComponent") do
        v3:updateAnimation(Character)
    end
end

Reflect.defineMetadata(self, "identifier", "client/controllers/coin-controller@CoinController")
Reflect.defineMetadata(self, "flamework:parameters", { "$c:components@Components" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnTick" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    CoinController = self
}
