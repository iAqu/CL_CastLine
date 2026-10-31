-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, Players = services.CollectionService, services.Players
local volcanicAquariumSkinProductId = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-utils").volcanicAquariumSkinProductId
local attemptStorePurchase = RuntimeLib.import(script, script.Parent.Parent, "store-purchase-utils").attemptStorePurchase

local function getPrimaryOrFirstPart(p1) -- line: 12
    if p1:IsA("Model") then
        return p1.PrimaryPart or p1:FindFirstChildWhichIsA("BasePart", true)
    end

    if p1:IsA("BasePart") then
        return p1
    end

    return p1:FindFirstChildWhichIsA("BasePart", true)
end

local function attachPrompt(p2) -- line: 21
    local v1 = if p2:IsA("Model") then p2.PrimaryPart or p2:FindFirstChildWhichIsA("BasePart", true) elseif p2:IsA("BasePart") then p2 else p2:FindFirstChildWhichIsA("BasePart", true)

    if not v1 then
        return nil
    end

    local ProximityPrompt = v1:FindFirstChildOfClass("ProximityPrompt")

    if ProximityPrompt then
        return ProximityPrompt
    end

    local ProximityPrompt2 = Instance.new("ProximityPrompt")

    ProximityPrompt2.ActionText = "Buy R$349"
    ProximityPrompt2.ObjectText = "Volcanic Aquarium"
    ProximityPrompt2.MaxActivationDistance = 20
    ProximityPrompt2.HoldDuration = 0
    ProximityPrompt2.RequiresLineOfSight = false
    ProximityPrompt2.UIOffset = Vector2.new(0, -58)
    ProximityPrompt2.Parent = v1

    return ProximityPrompt2
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 43
        return "VolcanicAquariumDisplayController"
    end
})

self.__index = self

function self.new(...) -- line: 48
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p3) -- line: 52
    p3._connections = {}
    p3._prompts = {}
end

function self.onStart(p4) -- line: 56
    -- upvalues: CollectionService (copy), Players (copy)
    for _, v4 in CollectionService:GetTagged("VolcanicAquariumDisplay") do
        p4:_setup(v4)
    end

    CollectionService:GetInstanceAddedSignal("VolcanicAquariumDisplay"):Connect(function(p5) -- line: 60
        -- upvalues: p4 (copy)
        return p4:_setup(p5)
    end)
    CollectionService:GetInstanceRemovedSignal("VolcanicAquariumDisplay"):Connect(function(p6) -- line: 63
        -- upvalues: p4 (copy)
        return p4:_teardown(p6)
    end)
    Players.LocalPlayer:GetAttributeChangedSignal("QaFreePurchaseModeEnabled"):Connect(function() -- line: 68
        -- upvalues: p4 (copy)
        return p4:_applyLabels()
    end)
end

function self._applyLabels(p7) -- line: 72
    -- upvalues: Players (copy)
    local v5 = Players.LocalPlayer:GetAttribute("QaFreePurchaseModeEnabled") == true

    for _, v6 in p7._prompts do
        v6.ActionText = v5 and "FREE" or "Buy R$349"
    end
end

function self._track(p8, p9, p10) -- line: 78
    p8._prompts[p9] = p10
    p8:_applyLabels()
end

function self._setup(p11, p12) -- line: 85
    -- upvalues: volcanicAquariumSkinProductId (copy), attemptStorePurchase (copy), attachPrompt (copy)
    local v7 = attachPrompt(p12)
    local v8 = v7

    if not v7 then
        task.delay(2, function() -- line: 89
            -- upvalues: p11 (copy), p12 (copy), v8 (ref), volcanicAquariumSkinProductId (copy), attemptStorePurchase (copy), attachPrompt (copy)
            if p11._connections[p12] ~= nil then
                return
            end

            v8 = attachPrompt(p12)

            if v8 then
                local connection = v8.Triggered:Connect(function() -- line: 95
                    -- upvalues: volcanicAquariumSkinProductId (copy), attemptStorePurchase (copy)
                    attemptStorePurchase(volcanicAquariumSkinProductId)
                end)

                p11._connections[p12] = connection
                p11:_track(p12, v8)
            end
        end)

        return nil
    end

    local connection = v7.Triggered:Connect(function() -- line: 107
        -- upvalues: volcanicAquariumSkinProductId (copy), attemptStorePurchase (copy)
        attemptStorePurchase(volcanicAquariumSkinProductId)
    end)

    p11._connections[p12] = connection
    p11:_track(p12, v7)
end

function self._teardown(p13, p14) -- line: 115
    local v10 = p13._connections[p14]

    if v10 ~= nil then
        v10:Disconnect()
    end

    p13._connections[p14] = nil
    p13._prompts[p14] = nil
end

Reflect.defineMetadata(self, "identifier", "client/controllers/volcanic-aquarium-display-controller@VolcanicAquariumDisplayController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    VolcanicAquariumDisplayController = self
}
