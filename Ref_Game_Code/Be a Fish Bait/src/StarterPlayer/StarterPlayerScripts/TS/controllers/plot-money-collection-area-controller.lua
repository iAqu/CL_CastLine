-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, ReplicatedStorage = services.Players, services.ReplicatedStorage
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local functions = RuntimeLib.import(script, script.Parent.Parent, "network").functions
local emitVFX = RuntimeLib.import(script, script.Parent.Parent, "vfx").emitVFX
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 15
        return "PlotMoneyCollectionAreaController"
    end
})

self.__index = self

function self.new(...) -- line: 20
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2, p3, p4) -- line: 24
    -- upvalues: Players (copy)
    p1._components = p2
    p1._detectableController = p3
    p1._soundController = p4
    p1._localUserId = tostring(Players.LocalPlayer.UserId)
    p1._lastCollectTime = 0
    p1._collectionCoolDown = 1
end

function self._emitCollectMoneyVFX(p5) -- line: 32
    -- upvalues: Players (copy), ReplicatedStorage (copy), emitVFX (copy)
    local Character = Players.LocalPlayer.Character

    if Character ~= nil then
        Character = Character:FindFirstChild("HumanoidRootPart")
    end

    if not Character then
        return nil
    end

    local CollectMoneyVFX = Character:FindFirstChild("CollectMoneyVFX")
    local v3

    if CollectMoneyVFX then
        v3 = CollectMoneyVFX
    else
        local VFX = ReplicatedStorage:FindFirstChild("VFX")

        if VFX ~= nil then
            VFX = VFX:FindFirstChild("CollectMoneyVFX")
        end

        if not VFX then
            return nil
        end

        v3 = VFX:Clone()
        v3.Parent = Character
    end

    emitVFX(v3)
    p5._soundController:playSound("MoneyPickup")
end

function self.onInit(p6) -- line: 57
    -- upvalues: subscribe (copy), functions (copy)
    subscribe(p6._detectableController:getInsideOfComponentsAtom(function() -- line: 58
        -- upvalues: p6 (copy)
        local t4 = {}
        local n1 = 0

        for v5, v6 in (p6._components:getAllComponents("client/components/plot-money-collection-area-component@PlotMoneyCollectionAreaComponent")) do
            local _ = v5 - 1

            if v6.attributes.ownerUserId == p6._localUserId == true then
                n1 += 1
                t4[n1] = v6
            end
        end

        return t4
    end, function(p7) -- line: 74
        return p7.detectableComponent
    end, "client/components/plot-money-collection-area-component@PlotMoneyCollectionAreaComponent"), function(p8) -- line: 77
        -- upvalues: p6 (copy), functions (copy)
        if not (#p8 > 0) then
            return
        end

        local elapsed = os.clock()

        if elapsed - p6._lastCollectTime >= p6._collectionCoolDown then
            p6._lastCollectTime = elapsed
            functions.collectPlotMoney(p6._localUserId)
            p6:_emitCollectMoneyVFX()
        end
    end)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/plot-money-collection-area-controller@PlotMoneyCollectionAreaController")
Reflect.defineMetadata(self, "flamework:parameters", { "$c:components@Components", "client/controllers/detectable-controller@DetectableController", "client/controllers/sound-controller@SoundController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnInit" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    PlotMoneyCollectionAreaController = self
}
