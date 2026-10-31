-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 11
        return "NearBaseController"
    end
})

self.__index = self

function self.new(...) -- line: 16
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2, p3) -- line: 20
    -- upvalues: Players (copy)
    p1._components = p2
    p1._detectableController = p3
    p1._localUserId = tostring(Players.LocalPlayer.UserId)
end

function self.onInit(p4) -- line: 25
    -- upvalues: subscribe (copy), clientProducer (copy)
    local v3 = p4._detectableController:getInsideOfComponentsAtom(function() -- line: 26
        -- upvalues: p4 (copy)
        local t4 = {}
        local n1 = 0

        for v4, v5 in (p4._components:getAllComponents("client/components/plot-component@PlotComponent")) do
            local _ = v4 - 1

            if v5.attributes.ownerUserId == p4._localUserId == true then
                n1 += 1
                t4[n1] = v5
            end
        end

        return t4
    end, function(p5) -- line: 42
        return p5.detectableComponent
    end, "client/components/plot-component@PlotComponent")
    local v6 = false

    subscribe(v3, function(p6) -- line: 46
        -- upvalues: v6 (ref), clientProducer (copy)
        local v7 = #p6 > 0

        if v7 == v6 then
            return nil
        end

        v6 = v7
        clientProducer.setIsNearBase({
            isNearBase = v7
        })
    end)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/near-base-controller@NearBaseController")
Reflect.defineMetadata(self, "flamework:parameters", { "$c:components@Components", "client/controllers/detectable-controller@DetectableController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnInit" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    NearBaseController = self
}
