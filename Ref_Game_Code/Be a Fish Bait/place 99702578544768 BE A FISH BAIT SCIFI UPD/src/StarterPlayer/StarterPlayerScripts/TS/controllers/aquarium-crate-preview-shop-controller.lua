-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local CollectionService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").CollectionService
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 10
        return "AquariumCratePreviewShopController"
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
end

function self.onInit(_) -- line: 25
end

function self.onTick(p4) -- line: 27
    -- upvalues: CollectionService (copy), clientProducer (copy)
    if p4._detectable == nil then
        local v3 = CollectionService:GetTagged("AqCrate1DetectArea")[1]

        if (if v3 == nil then v3 else v3:IsA("BasePart")) ~= true then
            return nil
        end

        p4._detectable = p4._components:getComponent(v3, "client/components/detectable-component@DetectableComponent")

        if p4._detectable == nil then
            return nil
        end
    end

    if os.clock() - p4._timeLastChecked < p4._checkInterval then
        return nil
    end

    p4._timeLastChecked = os.clock()

    local v4 = p4._detectable:isPlayerInside()

    if v4 == p4._wasInside then
        return nil
    end

    p4._wasInside = v4

    local currentWindow = clientProducer:getState().currentWindow

    if v4 then
        clientProducer.windowOpened({
            currentWindow = "aquariumShop",
            aquariumShopSection = "crates"
        })
    elseif currentWindow.currentWindow == "aquariumShop" and currentWindow.aquariumShopSection == "crates" then
        clientProducer.windowClosed({})
    end
end

Reflect.defineMetadata(self, "identifier", "client/controllers/aquarium-crate-preview-shop-controller@AquariumCratePreviewShopController")
Reflect.defineMetadata(self, "flamework:parameters", { "$c:components@Components" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnInit", "$:flamework@OnTick" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    AquariumCratePreviewShopController = self
}
