-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local events = RuntimeLib.import(script, script.Parent.Parent, "network").events
local selectTutorialStep = RuntimeLib.import(script, script.Parent.Parent, "reflex", "slices", "tutorial.selectors").selectTutorialStep
local tutorialSteps = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "tutorial-utils").tutorialSteps
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 14
        return "PlotInteractableAreaController"
    end
})

self.__index = self

function self.new(...) -- line: 19
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2, p3) -- line: 23
    -- upvalues: Players (copy)
    p1._components = p2
    p1._detectableController = p3
    p1._localUserId = tostring(Players.LocalPlayer.UserId)
    p1._hasFiredAquariumWindowOpened = false
    p1._hasFiredAquariumWindowOpenedAfterMoney = false
end

function self.onInit(p4) -- line: 30
    -- upvalues: subscribe (copy), clientProducer (copy), events (copy), selectTutorialStep (copy), tutorialSteps (copy)
    local v3 = false
    local v4 = p4._detectableController:getInsideOfComponentsAtom(function() -- line: 32
        -- upvalues: p4 (copy)
        local t4 = {}
        local n1 = 0

        for v5, v6 in (p4._components:getAllComponents("client/components/plot-interactable-area-component@PlotInteractableAreaComponent")) do
            local _ = v5 - 1

            if v6.attributes.ownerUserId == p4._localUserId == true then
                n1 += 1
                t4[n1] = v6
            end
        end

        return t4
    end, function(p5) -- line: 48
        return p5.detectableComponent
    end, "client/components/plot-interactable-area-component@PlotInteractableAreaComponent")

    subscribe(v4, function(p6) -- line: 51
        -- upvalues: p4 (copy), v3 (ref), clientProducer (copy), events (copy), selectTutorialStep (copy), tutorialSteps (copy)
        local v7 = #p6 > 0
        local currentWindow = clientProducer:getState().currentWindow.currentWindow

        if v7 then
            if not (v3 or currentWindow ~= "none" and currentWindow ~= "aquarium") then
                clientProducer.windowOpened({
                    currentWindow = "aquarium"
                })

                local v8 = selectTutorialStep(clientProducer:getState())

                if not p4._hasFiredAquariumWindowOpened and tutorialSteps.addFishToAquarium <= v8 then
                    p4._hasFiredAquariumWindowOpened = true
                    events.analyticsAquariumWindowOpened:fire()
                end

                if not p4._hasFiredAquariumWindowOpenedAfterMoney and tutorialSteps.levelUpFish <= v8 then
                    p4._hasFiredAquariumWindowOpenedAfterMoney = true
                    events.analyticsAquariumWindowOpenedAfterMoney:fire()
                end
            end
        else
            v3 = false

            if currentWindow == "aquarium" then
                clientProducer.windowClosed({})
            end
        end
    end)
    clientProducer:subscribe(function(p7) -- line: 77
        return p7.currentWindow.currentWindow
    end, function(p8, p9) -- line: 79
        -- upvalues: v3 (ref), v4 (copy)
        if p9 == "aquarium" and p8 == "none" and #v4() > 0 then
            v3 = true
        end
    end)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/plot-interactable-area-controller@PlotInteractableAreaController")
Reflect.defineMetadata(self, "flamework:parameters", { "$c:components@Components", "client/controllers/detectable-controller@DetectableController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnInit" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    PlotInteractableAreaController = self
}
