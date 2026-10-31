-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, Players, Workspace = services.CollectionService, services.Players, services.Workspace
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer

local function getTriggerBounds(p1) -- line: 12
    if p1:IsA("BasePart") then
        return {
            cframe = p1.CFrame,
            size = p1.Size
        }
    end

    if p1:IsA("Model") then
        local BoundingBox, BoundingBox2 = p1:GetBoundingBox()

        return {
            cframe = BoundingBox,
            size = BoundingBox2
        }
    end

    local v1 = p1:FindFirstChildWhichIsA("BasePart", true)

    return if if v1 == nil then v1 else v1:IsA("BasePart") then {
        cframe = v1.CFrame,
        size = v1.Size
    } else nil
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 42
        return "AquariumCrateDisplayController"
    end
})

self.__index = self

function self.new(...) -- line: 47
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p2) -- line: 51
    p2._taggedInstances = {}
    p2._enteredInstances = {}
    p2._overlapParams = OverlapParams.new()
    p2._accumulatedTime = 0
end

function self.onStart(p3) -- line: 57
    -- upvalues: CollectionService (copy)
    p3._overlapParams.FilterType = Enum.RaycastFilterType.Include
    p3._overlapParams.MaxParts = 1

    for _, v4 in CollectionService:GetTagged("DrawAquariumSkin") do
        p3._taggedInstances[v4] = true
    end

    CollectionService:GetInstanceAddedSignal("DrawAquariumSkin"):Connect(function(p4) -- line: 63
        -- upvalues: p3 (copy)
        local _taggedInstances = p3._taggedInstances

        _taggedInstances[p4] = true

        return _taggedInstances
    end)
    CollectionService:GetInstanceRemovedSignal("DrawAquariumSkin"):Connect(function(p5) -- line: 69
        -- upvalues: p3 (copy)
        return p3:_removeInstance(p5)
    end)
end

function self.onTick(p6, p7) -- line: 73
    -- upvalues: Players (copy), clientProducer (copy), getTriggerBounds (copy)
    p6._accumulatedTime += p7

    if not (p6._accumulatedTime < 0.1) then
        p6._accumulatedTime %= 0.1

        local Character = Players.LocalPlayer.Character

        if Character ~= nil then
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

            if HumanoidRootPart ~= nil then
                HumanoidRootPart = HumanoidRootPart:IsA("BasePart")
            end

            if HumanoidRootPart then
                for v5 in p6._taggedInstances do
                    local v6 = getTriggerBounds(v5)

                    if v6 ~= nil then
                        local v7 = p6:_doesCharacterOverlapTrigger(Character, v6)
                        local v8 = p6._enteredInstances[v5] ~= nil

                        if v7 then
                            if not v8 then
                                p6._enteredInstances[v5] = true
                                clientProducer.windowOpened({
                                    aquariumShopSection = "crates",
                                    currentWindow = "aquariumShop"
                                })
                            end
                        elseif v8 then
                            p6._enteredInstances[v5] = nil

                            local n1 = 0

                            for _ in p6._enteredInstances do
                                n1 += 1
                            end

                            if n1 == 0 and clientProducer:getState().currentWindow.currentWindow == "aquariumShop" then
                                clientProducer.windowClosed({})
                            end
                        end
                    end
                end

                return
            end
        end

        table.clear(p6._enteredInstances)
    end

    return nil
end

function self._doesCharacterOverlapTrigger(p8, p9, p10) -- line: 124
    -- upvalues: Workspace (copy)
    p8._overlapParams.FilterDescendantsInstances = { p9 }

    local v9 = p10.size + Vector3.new(0, 4, 0)

    return #Workspace:GetPartBoundsInBox(p10.cframe, v9, p8._overlapParams) > 0
end

function self._removeInstance(p11, p12) -- line: 131
    p11._taggedInstances[p12] = nil
    p11._enteredInstances[p12] = nil
end

Reflect.defineMetadata(self, "identifier", "client/controllers/aquarium-crate-display-controller@AquariumCrateDisplayController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnTick" })
Reflect.decorate(self, "$:flamework@Controller", Controller, { {} })

return {
    AquariumCrateDisplayController = self
}
