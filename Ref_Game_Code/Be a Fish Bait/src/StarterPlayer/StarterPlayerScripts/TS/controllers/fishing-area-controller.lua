-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local v1 = RuntimeLib.import(script, script.Parent.Parent, "fishing-phase-atom")
local currentFishingZoneAtom, hookHrpAtom, hookZoneProgressAtom = v1.currentFishingZoneAtom, v1.hookHrpAtom, v1.hookZoneProgressAtom
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "fishing-zones-utils")
local fishingZoneCount, getFishingZoneIndex = v2.fishingZoneCount, v2.getFishingZoneIndex
local resolveZoneContaining = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "fishing-zone-detection-utils").resolveZoneContaining
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 18
        return "FishingAreaController"
    end
})

self.__index = self

function self.new(...) -- line: 23
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2, p3) -- line: 27
    p1._components = p2
    p1._detectableController = p3
end

function self.onInit(p4) -- line: 31
    -- upvalues: subscribe (copy), clientProducer (copy)
    local v5 = p4._detectableController:getInsideOfComponentsAtom(function() -- line: 32
        -- upvalues: p4 (copy)
        return p4._components:getAllComponents("client/components/fishing-area-component@FishingAreaComponent")
    end, function(p5) -- line: 34
        return p5.detectableComponent
    end, "client/components/fishing-area-component@FishingAreaComponent")
    local v6

    subscribe(v5, function(p6) -- line: 38
        -- upvalues: v6 (ref), clientProducer (copy)
        local v7 = #p6 > 0

        if v7 == v6 then
            return nil
        end

        v6 = v7
        clientProducer.setInFishingArea({
            isInFishingArea = v7
        })
    end)
end

function self.onStart(p7) -- line: 49
    -- upvalues: clientProducer (copy)
    task.defer(function() -- line: 52
        -- upvalues: p7 (copy), clientProducer (copy)
        local v8 = p7._components:getAllComponents("client/components/fishing-area-component@FishingAreaComponent")

        if #v8 > 0 then
            clientProducer.setFishingAreaCenter({
                fishingAreaCenter = v8[1].instance.DetectableArea.Position
            })
        end
    end)
end

function self.onRender(p8) -- line: 61
    -- upvalues: currentFishingZoneAtom (copy), hookHrpAtom (copy), hookZoneProgressAtom (copy), fishingZoneCount (copy), getFishingZoneIndex (copy), resolveZoneContaining (copy)
    local v9 = hookHrpAtom()

    if not v9 then
        if currentFishingZoneAtom() ~= nil then
            currentFishingZoneAtom(nil)
        end

        if hookZoneProgressAtom() ~= 0 then
            hookZoneProgressAtom(0)
        end

        return nil
    end

    p8:_ensureZoneCache()

    local v10 = p8._zoneComponents or {}
    local v12 = resolveZoneContaining(p8._zoneParts or {}, v9.Position, true)
    local v13 = if v12 == nil then v12 else v12.zone

    if v12 ~= nil then
        v12 = v12.part
    end

    if currentFishingZoneAtom() ~= v13 then
        currentFishingZoneAtom(v13)
    end

    if v13 ~= nil and v12 ~= nil then
        local v14 = getFishingZoneIndex(v13)
        local v15 = p8:_getTraversalDir(v10)
        local v17 = (Vector3.new(v9.Position.X, 0, v9.Position.Z) - Vector3.new(v12.Position.X, 0, v12.Position.Z)):Dot(v15)
        local v18 = v12.CFrame:VectorToObjectSpace(v15)
        local v20 = math.abs(v18.X) * (v12.Size.X / 2) + math.abs(v18.Z) * (v12.Size.Z / 2)

        hookZoneProgressAtom((v14 + (if v20 > 0 then math.clamp((v17 + v20) / (2 * v20), 0, 1) else 0.5)) / fishingZoneCount)
    end
end

function self._ensureZoneCache(p9) -- line: 106
    -- upvalues: getFishingZoneIndex (copy)
    if p9._zoneComponents ~= nil and p9._zoneParts ~= nil then
        return nil
    end

    local v23 = p9._components:getAllComponents("client/components/fishing-zone-component@FishingZoneComponent")
    local t4 = {}

    for _, v24 in v23 do
        local detectableComponent = v24.detectableComponent

        if detectableComponent ~= nil then
            detectableComponent = detectableComponent.instance
        end

        if detectableComponent then
            table.insert(t4, {
                zone = v24.attributes.zoneId,
                part = detectableComponent
            })
        end
    end

    table.sort(t4, function(p10, p11) -- line: 126
        -- upvalues: getFishingZoneIndex (copy)
        return getFishingZoneIndex(p10.zone) > getFishingZoneIndex(p11.zone)
    end)
    p9._zoneComponents = v23
    p9._zoneParts = t4
end

function self._getTraversalDir(p12, p13) -- line: 132
    if p12._traversalDir ~= nil then
        return p12._traversalDir
    end

    for _, v25 in p13 do
        local detectableComponent = v25.detectableComponent

        if detectableComponent ~= nil then
            detectableComponent = detectableComponent.instance
        end

        if detectableComponent then
            local LookVector = detectableComponent.CFrame.LookVector
            local v28 = Vector3.new(-LookVector.X, 0, -LookVector.Z)

            if v28.Magnitude > 0.001 then
                p12._traversalDir = v28.Unit

                return p12._traversalDir
            end
        end
    end

    p12._traversalDir = Vector3.new(0, 0, 1)

    return p12._traversalDir
end

Reflect.defineMetadata(self, "identifier", "client/controllers/fishing-area-controller@FishingAreaController")
Reflect.defineMetadata(self, "flamework:parameters", { "$c:components@Components", "client/controllers/detectable-controller@DetectableController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnInit", "$:flamework@OnStart", "$:flamework@OnRender" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    FishingAreaController = self
}
