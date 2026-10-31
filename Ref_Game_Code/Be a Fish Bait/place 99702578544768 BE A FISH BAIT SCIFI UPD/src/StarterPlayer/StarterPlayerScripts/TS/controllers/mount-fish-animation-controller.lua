-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local charm = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm")
local atom, effect, subscribe = charm.atom, charm.effect, charm.subscribe
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, Players, Workspace = services.CollectionService, services.Players, services.Workspace
local reflexStateToAtom = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "reflex-utils").reflexStateToAtom
local selectPlayerMounts = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerMounts
local animations = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "animation-utils").animations
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent, "utils").localPlayerUserId
local fishingMovementLockedAtom = RuntimeLib.import(script, script.Parent.Parent, "fishing-phase-atom").fishingMovementLockedAtom
local getMountFishData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "mount-fish").getMountFishData
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 23
        return "MountFishAnimationController"
    end
})

self.__index = self

function self.new(...) -- line: 28
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2, p3) -- line: 32
    -- upvalues: atom (copy), Maid (copy)
    p1._characterController = p2
    p1._reflexController = p3
    p1._maid = Maid.new()
    p1._retryToken = 0
    p1._mountPresenceVersion = atom(0)
end

function self.onStart(p4) -- line: 39
    -- upvalues: effect (copy), subscribe (copy), CollectionService (copy), Players (copy), reflexStateToAtom (copy), selectPlayerMounts (copy), localPlayerUserId (copy), fishingMovementLockedAtom (copy)
    local v3 = reflexStateToAtom(p4._reflexController:getClientProducer(), selectPlayerMounts(localPlayerUserId))
    local v4 = v3[1]
    local v5 = v3[2]

    p4._maid:GiveTask(v5)

    local function v6() -- line: 44
        -- upvalues: p4 (copy)
        p4._mountPresenceVersion(function(p5) -- line: 45
            return p5 + 1
        end)
    end

    p4._maid:GiveTask(CollectionService:GetInstanceAddedSignal("MountableFish"):Connect(v6))
    p4._maid:GiveTask(CollectionService:GetInstanceRemovedSignal("MountableFish"):Connect(v6))
    p4._maid:GiveTask(Players.LocalPlayer.CharacterAdded:Connect(function() -- line: 51
        -- upvalues: p4 (copy)
        p4._mountPresenceVersion(function(p6) -- line: 45
            return p6 + 1
        end)
    end))
    p4._maid:GiveTask(Players.LocalPlayer.CharacterRemoving:Connect(function() -- line: 54
        -- upvalues: p4 (copy)
        p4._mountPresenceVersion(function(p7) -- line: 45
            return p7 + 1
        end)
        p4:_stopLocalTrack()
    end))
    p4._maid:GiveTask(subscribe(fishingMovementLockedAtom, function(p8, p9) -- line: 58
        -- upvalues: p4 (copy)
        if p8 or p9 ~= true then
            return nil
        end

        p4._retryToken += 1

        local _retryToken = p4._retryToken

        task.defer(function() -- line: 67
            -- upvalues: _retryToken (copy), p4 (copy)
            return p4:_restoreLocalMountAfterFishing(_retryToken)
        end)

        for _, v7 in { 0.25, 1, 2 } do
            task.delay(v7, function() -- line: 71
                -- upvalues: _retryToken (copy), p4 (copy)
                return p4:_restoreLocalMountAfterFishing(_retryToken)
            end)
        end
    end))
    p4._maid:GiveTask(effect(function() -- line: 76
        -- upvalues: p4 (copy), v4 (copy)
        local v8 = p4._characterController.humanoid()
        local v9 = v4()
        local v10 = p4._mountPresenceVersion()
        local v11 = p4:_findLocalMount()
        local v12 = v8 ~= nil

        v12 = v12 and (if v9 == nil then v9 else v9.isMounted) == true and v11 ~= nil

        if not v12 or v8 == nil then
            p4._retryToken += 1
            p4:_stopLocalTrack()

            return nil
        end

        p4._retryToken += 1

        local _retryToken = p4._retryToken

        p4:_ensureLocalMountAnimationPlaying(v8, _retryToken)

        for _, v13 in { 0.25, 1, 2, 4 } do
            task.delay(v13, function() -- line: 102
                -- upvalues: v8 (copy), v10 (copy), _retryToken (copy), p4 (copy)
                if _retryToken ~= p4._retryToken or v10 ~= p4._mountPresenceVersion() then
                    return nil
                end

                p4:_ensureLocalMountAnimationPlaying(v8, _retryToken)
            end)
        end
    end))
end

function self._findLocalMount(_) -- line: 114
    -- upvalues: CollectionService (copy), localPlayerUserId (copy)
    for _, v14 in CollectionService:GetTagged("MountableFish") do
        if v14:IsA("Model") and tostring((v14:GetAttribute("ownerUserId"))) == localPlayerUserId then
            return v14
        end
    end

    return nil
end

function self._ensureLocalMountAnimationPlaying(p11, p12, p13) -- line: 122
    -- upvalues: animations (copy)
    if p13 ~= p11._retryToken or p11._characterController.humanoid() ~= p12 or p11:_findLocalMount() == nil then
        return nil
    end

    if p11._localTrackHumanoid ~= p12 then
        p11:_stopLocalTrack()
    end

    local _localTrack = p11._localTrack

    if _localTrack ~= nil then
        _localTrack = _localTrack.IsPlaying
    end

    if _localTrack == true then
        return nil
    end

    local Animator = p12:FindFirstChildOfClass("Animator")

    if Animator == nil then
        Animator = Instance.new("Animator")
        Animator.Parent = p12
    end

    local Animation = Instance.new("Animation")

    Animation.AnimationId = animations.playerMount

    local track = Animator:LoadAnimation(Animation)

    track.Looped = true
    track.Priority = Enum.AnimationPriority.Action
    track:Play()
    Animation:Destroy()
    p11._localTrack = track
    p11._localTrackHumanoid = p12
end

function self._restoreLocalMountAfterFishing(p14, p15) -- line: 157
    -- upvalues: Players (copy), Workspace (copy), selectPlayerMounts (copy), localPlayerUserId (copy), getMountFishData (copy)
    if p15 ~= p14._retryToken then
        return nil
    end

    local Character = Players.LocalPlayer.Character
    local v15 = p14._characterController.humanoid()
    local v16 = selectPlayerMounts(localPlayerUserId)(p14._reflexController:getClientProducer():getState())

    if Character ~= nil then
        Character = Character.Parent
    end

    local v17 = Character ~= Workspace
    local v18

    if v17 then
        v18 = v17
    else
        local v19 = v15 == nil

        v18 = v19 or (if v16 == nil then v16 else v16.isMounted) ~= true or v16.activeMountName == nil
    end

    if v18 then
        return nil
    end

    local v20 = getMountFishData(v16.activeMountName)

    if v20 == nil then
        return nil
    end

    v15.HipHeight = v20.hipHeight
    p14:_ensureLocalMountAnimationPlaying(v15, p15)
end

function self._stopLocalTrack(p16) -- line: 192
    local _localTrack = p16._localTrack

    if _localTrack ~= nil then
        _localTrack:Stop()
    end

    local _localTrack2 = p16._localTrack

    if _localTrack2 ~= nil then
        _localTrack2:Destroy()
    end

    p16._localTrack = nil
    p16._localTrackHumanoid = nil
end

Reflect.defineMetadata(self, "identifier", "client/controllers/mount-fish-animation-controller@MountFishAnimationController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/character-controller@CharacterController", "client/controllers/reflex-controller@ReflexController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, { {} })

return {
    MountFishAnimationController = self
}
