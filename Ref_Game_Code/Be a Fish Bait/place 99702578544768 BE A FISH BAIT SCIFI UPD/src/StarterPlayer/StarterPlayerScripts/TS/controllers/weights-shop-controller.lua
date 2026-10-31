-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local events = RuntimeLib.import(script, script.Parent.Parent, "network").events
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 10
        return "WeightsShopController"
    end
})

self.__index = self

function self.new(...) -- line: 15
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 19
    p1._components = p2
    p1._wasInside = false
    p1._timeLastChecked = 0
    p1._checkInterval = 0.2
    p1._hasFiredfAnalyticsOpen = false
end

function self.onInit(_) -- line: 26
end

function self.onTick(p4) -- line: 28
    -- upvalues: clientProducer (copy), events (copy)
    if os.clock() - p4._timeLastChecked < p4._checkInterval then
        return nil
    end

    p4._timeLastChecked = os.clock()

    local v3 = p4._components:getAllComponents("client/components/weights-shop-component@WeightsShopComponent")
    local v4 = #v3 - 1
    local v5 = false

    for i = 0, v4 do
        if v3[i + 1]:isPlayerInside() == true then
            v5 = true
            break
        end
    end

    if v5 == p4._wasInside then
        return nil
    end

    p4._wasInside = v5

    if v5 then
        clientProducer.windowOpened({
            currentWindow = "weightsShop"
        })

        if not p4._hasFiredfAnalyticsOpen then
            p4._hasFiredfAnalyticsOpen = true
            events.analyticsWeightShopOpened:fire()
        end
    elseif clientProducer:getState().currentWindow.currentWindow == "weightsShop" then
        clientProducer.windowClosed({})
    end
end

Reflect.defineMetadata(self, "identifier", "client/controllers/weights-shop-controller@WeightsShopController")
Reflect.defineMetadata(self, "flamework:parameters", { "$c:components@Components" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnInit", "$:flamework@OnTick" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    WeightsShopController = self
}
