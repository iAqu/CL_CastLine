-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, ReplicatedStorage, Workspace = services.Players, services.ReplicatedStorage, services.Workspace
local charm = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm")
local atom, subscribe = charm.atom, charm.subscribe
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local selectPlayerStat = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerStat
local selectHighScoreShown = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-config-snapshot.selectors").selectHighScoreShown
local waterSurfaceY = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "fishing-hook-utils").waterSurfaceY
local v1 = RuntimeLib.import(script, script.Parent.Parent, "fishing-phase-atom")
local fishingMovementLockedAtom, hookHrpAtom, hookLandedPositionAtom = v1.fishingMovementLockedAtom, v1.hookHrpAtom, v1.hookLandedPositionAtom
local HighScoreWall = ReplicatedStorage:FindFirstChild("HighScoreWall")
local v2 = atom(nil)
local v3 = atom({})
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 26
        return "HighScoreMarkerController"
    end
})

self.__index = self

function self.new(...) -- line: 31
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 35
    p1._components = p2
    p1._beamOriginalTransparencies = {}
end

function self.onStart(p3) -- line: 39
    -- upvalues: Players (copy), Workspace (copy), subscribe (copy), clientProducer (copy), selectPlayerStat (copy), selectHighScoreShown (copy), waterSurfaceY (copy), fishingMovementLockedAtom (copy), hookHrpAtom (copy), hookLandedPositionAtom (copy), v2 (copy), v3 (copy)
    local function v6() -- line: 41
        -- upvalues: p3 (copy), v3 (copy)
        return v3(p3._components:getAllComponents("client/components/fishing-zone-component@FishingZoneComponent"))
    end

    v3(p3._components:getAllComponents("client/components/fishing-zone-component@FishingZoneComponent"))
    p3._components:onComponentAdded(v6, "client/components/fishing-zone-component@FishingZoneComponent")
    p3._components:onComponentRemoved(v6, "client/components/fishing-zone-component@FishingZoneComponent")

    local v7 = tostring(Players.LocalPlayer.UserId)
    local highScorePosition = selectPlayerStat(v7, "highScorePosition")
    local v8, v9

    clientProducer:subscribe(highScorePosition, function(p4) -- line: 60
        -- upvalues: p3 (copy), v8 (ref), v9 (ref), waterSurfaceY (copy), fishingMovementLockedAtom (copy), v3 (copy)
        if p4 == nil then
            return nil
        end

        local v10 = Vector3.new(p4.x, waterSurfaceY, p4.z)

        if fishingMovementLockedAtom() then
            v9 = v10
        elseif #v3() > 0 then
            p3:_updateMarker(v10)
        else
            v8 = v10
        end
    end)
    subscribe(fishingMovementLockedAtom, function(p5) -- line: 73
        -- upvalues: p3 (copy), v8 (ref), v9 (ref), v3 (copy)
        if p5 or v9 == nil then
            return
        end

        local v11 = v9

        v9 = nil

        if #v3() > 0 then
            p3:_updateMarker(v11)
        else
            v8 = v11
        end
    end)

    local function v12() -- line: 81
        -- upvalues: p3 (copy), v7 (copy), Workspace (copy), clientProducer (copy), selectHighScoreShown (copy), hookHrpAtom (copy), hookLandedPositionAtom (copy), v2 (copy)
        local v13 = v2()

        if v13 == nil then
            return nil
        end

        local v14 = hookHrpAtom() ~= nil
        local v15 = hookLandedPositionAtom() ~= nil
        local v16 = clientProducer:getState(selectHighScoreShown(v7))

        if v15 or v16 == false then
            v13.Parent = nil
        else
            v13.Parent = Workspace
        end

        p3:_applyBeamTransparency(v14)
    end

    subscribe(hookHrpAtom, v12)
    subscribe(hookLandedPositionAtom, v12)
    clientProducer:subscribe(selectHighScoreShown(v7), v12)
    subscribe(v3, function(p6) -- line: 96
        -- upvalues: p3 (copy), v8 (ref)
        if not (#p6 > 0) or v8 == nil then
            return
        end

        local v17 = v8

        v8 = nil
        p3:_updateMarker(v17)
    end)
end

function self._getZoneCFrame(_) -- line: 104
    -- upvalues: v3 (copy)
    for _, v18 in v3() do
        local detectableComponent = v18.detectableComponent

        if detectableComponent ~= nil then
            detectableComponent = detectableComponent.instance
        end

        if detectableComponent then
            return detectableComponent.CFrame
        end
    end

    return nil
end

function self._updateMarker(p8, p9) -- line: 117
    -- upvalues: Workspace (copy), hookHrpAtom (copy), hookLandedPositionAtom (copy), HighScoreWall (copy), v2 (copy)
    local v19 = v2()

    if v19 ~= nil then
        v19:Destroy()
    end

    table.clear(p8._beamOriginalTransparencies)

    local clone = HighScoreWall:Clone()
    local v20 = p8:_getZoneCFrame()

    if v20 ~= nil then
        local LookVector = v20.LookVector
        local Unit = Vector3.new(-LookVector.X, 0, -LookVector.Z).Unit
        local v23 = Vector3.new(v20.Position.X, 0, v20.Position.Z)
        local v24 = v23 + Unit * (Vector3.new(p9.X, 0, p9.Z) - v23):Dot(Unit)
        local v25 = Vector3.new(v24.X, p9.Y, v24.Z)

        clone.CFrame = CFrame.lookAt(v25, v25 + Unit) * CFrame.Angles(3.141592653589793, 0, 0)
    else
        clone.CFrame = CFrame.new(p9)
    end

    for _, child in clone:GetChildren() do
        if child:IsA("Beam") then
            p8._beamOriginalTransparencies[child] = child.Transparency
        end
    end

    local v26 = hookHrpAtom() ~= nil

    if hookLandedPositionAtom() ~= nil then
        clone.Parent = nil
    else
        clone.Parent = Workspace
    end

    v2(clone)
    p8:_applyBeamTransparency(v26)
end

function self._applyBeamTransparency(p10, p11) -- line: 154
    for v27, v28 in p10._beamOriginalTransparencies do
        local Keypoints = v28.Keypoints
        local v29 = table.create(#Keypoints);

        ({})[1] = p11

        for v30, v31 in Keypoints do
            local _ = v30 - 1
            local v32 = if p11 then v31.Value else math.min(v31.Value * 1.5, 0.95)

            v29[v30] = NumberSequenceKeypoint.new(v31.Time, v32)
        end

        v27.Transparency = NumberSequence.new(v29)
    end
end

Reflect.defineMetadata(self, "identifier", "client/controllers/high-score-marker-controller@HighScoreMarkerController")
Reflect.defineMetadata(self, "flamework:parameters", { "$c:components@Components" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    highScoreMarkerPartAtom = v2,
    HighScoreMarkerController = self
}
