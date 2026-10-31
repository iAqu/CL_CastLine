-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out")
local Component, BaseComponent = out.Component, out.BaseComponent
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, Players, RunService, Workspace = services.CollectionService, services.Players, services.RunService, services.Workspace
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local animations = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "animation-utils").animations
local vfx = RuntimeLib.import(script, script.Parent.Parent, "vfx")
local emitVFX, setVFXEnabled = vfx.emitVFX, vfx.setVFXEnabled
local PerfectVFX = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "Visulie", "PerfectVFX")
local playVisulie = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "Visulie", "visulie-utils").playVisulie
local fishingRodsData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fishing-rods").fishingRodsData
local fishingRodSkinsData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fishing-rod-skins").fishingRodSkinsData
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectEquippedFishingRodSkinId, selectPlayerBaitAuras, selectPlayerInventory = selectors.selectEquippedFishingRodSkinId, selectors.selectPlayerBaitAuras, selectors.selectPlayerInventory
local collisionGroups = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "collision-groups").collisionGroups
local src = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "ripple", "src")
local baseFov = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "fishing-hook-utils").baseFov
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "bait-aura-vfx-utils")
local applyBaitAuraVfx, clearBaitAuraVfx = v1.applyBaitAuraVfx, v1.clearBaitAuraVfx
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 37
        return "CastCutSceneComponent"
    end,
    __index = BaseComponent
})

self.__index = self

function self.new(...) -- line: 43
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 47
    -- upvalues: BaseComponent (copy), Maid (copy), src (copy), baseFov (copy)
    BaseComponent.constructor(p1)
    p1._soundController = p2
    p1._maid = Maid.new()
    p1._time = 0
    p1._animTime = 0
    p1._isPerfect = false
    p1._pendingSounds = {}
    p1._fovMotion = src.createMotion(baseFov, {
        start = false
    })
end

function self._playAnimation(_, p4, p5) -- line: 59
    local Animation = Instance.new("Animation")

    Animation.AnimationId = p5

    return p4:LoadAnimation(Animation)
end

function self.onStart(p6) -- line: 64
    -- upvalues: Players (copy), RunService (copy), Workspace (copy), clientProducer (copy), animations (copy), PerfectVFX (copy), playVisulie (copy), fishingRodsData (copy), fishingRodSkinsData (copy), selectEquippedFishingRodSkinId (copy), selectPlayerBaitAuras (copy), selectPlayerInventory (copy), collisionGroups (copy), applyBaitAuraVfx (copy)
    print((("[CastDebug] CastCutSceneComponent.onStart for %*"):format((p6.instance:GetFullName()))))
    p6._soundController:pauseBackgroundMusic()

    local CurrentCamera = game.Workspace.CurrentCamera

    if CurrentCamera then
        CurrentCamera.CameraType = Enum.CameraType.Scriptable
    end

    p6._maid:GiveTask(p6.instance.MiniPlayerRigR15)
    p6._isPerfect = p6.attributes.IsPerfect

    if p6._isPerfect then
        local MiniPlayerRigR15 = p6.instance.MiniPlayerRigR15
        local Model = Instance.new("Model")

        Model.Name = "PerfectVFXVisulie"
        Model.Parent = Workspace
        playVisulie(PerfectVFX, CFrame.new(MiniPlayerRigR15.Head.Position), Model)
        p6._maid:GiveTask(RunService.RenderStepped:Connect(function() -- line: 80
            -- upvalues: MiniPlayerRigR15 (copy), Model (copy)
            if not MiniPlayerRigR15.Parent then
                Model:Destroy()

                return nil
            end

            Model:PivotTo(CFrame.new(MiniPlayerRigR15.Head.Position))
        end))
        p6._maid:GiveTask(task.delay(2.85, function() -- line: 88
            -- upvalues: Model (copy)
            Model:Destroy()
        end))
    end

    p6._activeCamera = if p6._isPerfect then p6.instance.PerfectCamera else p6.instance.NonPerfectCamera
    p6:_setupSounds(if p6._isPerfect then p6.instance.PerfectSounds else p6.instance.NonPerfectSounds)

    local v6 = if p6._isPerfect then animations.castCutscenePerfectMiniPlayerRig else animations.castCutsceneMiniPlayerRig
    local v7 = if p6._isPerfect then animations.castCutscenePerfectPlayerRig else animations.castCutscenePlayerRig

    p6.instance.MiniPlayerRigR15.Humanoid.AutomaticScalingEnabled = false

    local v8 = tostring(Players.LocalPlayer.UserId)
    local v9 = selectPlayerBaitAuras(v8)(clientProducer:getState())

    if v9 ~= nil then
        v9 = v9.slots[v9.equippedSlotIndex + 1]
    end

    applyBaitAuraVfx(p6.instance.MiniPlayerRigR15, v9)

    local v10 = p6:_playAnimation(p6.instance.MiniPlayerRigR15.Humanoid.Animator, v6)

    p6:_listenToVFX(v10)
    v10:Play()
    print((("[CastDebug] miniTrack.Play() called for animId=%* isPlaying=%* length=%*"):format(v6, v10.IsPlaying, v10.Length)))

    local v11 = selectPlayerInventory(v8)(clientProducer:getState())
    local itemName

    if v11 then
        for _, v12 in v11 do
            if v12.itemType == "fishingRod" and v12.isInToolbar then
                itemName = v12.itemName
                break
            end
        end
    end

    if itemName ~= nil then
        local v13 = fishingRodsData[itemName]
        local v14 = selectEquippedFishingRodSkinId(v8)(clientProducer:getState())
        local v15 = if v14 == "" or not v14 then nil else fishingRodSkinsData[v14]

        if v15 ~= nil then
            v15 = v15.model
        end

        local v16 = if v15 ~= nil then v15 elseif v13 == nil then v13 else v13.model

        if v16 then
            print((("[CastDebug] resolved rod=%* model=%*"):format(itemName, (v16:GetFullName()))))

            local clone = v16:Clone()

            for _, descendant in clone:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.CollisionGroup = collisionGroups.toolParts
                    descendant.CanCollide = false
                    descendant.Massless = true
                    descendant.Anchored = false
                end
            end

            clone.Parent = p6.instance
            p6._maid:GiveTask(clone)

            local Handle = clone.Handle
            local Beam = clone.RodModel.MainHandle.Beam
            local v17 = p6:_playAnimation(p6.instance.PlayerRigR15.Humanoid.Animator, v7)

            v17.KeyframeReached:Connect(function(p7) -- line: 173
                -- upvalues: Beam (copy), clientProducer (copy)
                print((("[CastDebug] playerTrack KeyframeReached eventName=%*"):format(p7)))

                if p7 == "StopCutscene" then
                    clientProducer.castCutsceneAnimationEnded({})
                elseif p7 == "AttachLine" then
                    Beam.Enabled = true
                end
            end)
            v17.Stopped:Connect(function() -- line: 181
                -- upvalues: p6 (copy), v17 (copy)
                print((("[CastDebug] playerTrack STOPPED — timePosition=%* instanceParent=%* rigParent=%*"):format(v17.TimePosition, p6.instance.Parent, p6.instance.PlayerRigR15.Parent)))
            end)
            v17.Ended:Connect(function() -- line: 184
                -- upvalues: v17 (copy)
                print((("[CastDebug] playerTrack ENDED — timePosition=%*"):format(v17.TimePosition)))
            end)
            v17:Play()
            print((("[CastDebug] playerTrack.Play() called for animId=%* isPlaying=%* length=%*"):format(v7, v17.IsPlaying, v17.Length)))

            for _, v18 in { 0.5, 1.5, 3 } do
                p6._maid:GiveTask(task.delay(v18, function() -- line: 190
                    -- upvalues: p6 (copy), v17 (copy), v18 (copy)
                    print((("[CastDebug] +%*s poll — timePosition=%* isPlaying=%* instanceParent=%* rigParent=%* humanoidParent=%*"):format(v18, v17.TimePosition, v17.IsPlaying, p6.instance.Parent, p6.instance.PlayerRigR15.Parent, p6.instance.PlayerRigR15.Humanoid.Parent)))
                end))
            end

            p6._soundClockTrack = v17

            local RightHand = p6.instance.PlayerRigR15.RightHand

            Handle.CFrame = RightHand.CFrame

            local WeldConstraint = Instance.new("WeldConstraint")

            WeldConstraint.Part0 = RightHand
            WeldConstraint.Part1 = Handle
            WeldConstraint.Parent = Handle
            Beam.Attachment1 = p6.instance.MiniPlayerRigR15.Head.HatAttachment
            Beam.Enabled = false
            p6.instance.PlayerRigR15.Humanoid.ApplyDescriptionFinished:Connect(function() -- line: 198
                -- upvalues: p6 (copy), Beam (copy)
                Beam.Attachment1 = p6.instance.MiniPlayerRigR15.Head.HatAttachment
            end)

            return
        end

        warn("[src/client/components/cast-cutscene-component.ts:205]", "[CastDebug] Fishing rod model not found — playerTrack will never play, StopCutscene keyframe will never fire")
    else
        warn("[src/client/components/cast-cutscene-component.ts:195]", "[CastDebug] No fishing rod in toolbar — playerTrack will never play, StopCutscene keyframe will never fire")
    end

    return nil
end

function self._setupSounds(p8, p9) -- line: 202
    for _, child in p9:GetChildren() do
        if child:IsA("StringValue") then
            local Value = child.Value
            local Start = child:GetAttribute("Start")

            if Start == nil then
                Start = 0
            end

            local Offset = child:GetAttribute("Offset")

            if Offset == nil then
                Offset = 0
            end

            local Volume = child:GetAttribute("Volume")

            if Volume == nil then
                Volume = 1
            end

            local End = child:GetAttribute("End")

            if End == nil then
                End = 0
            end

            local v19 = p8._soundController:getRegisteredSound(Value)

            if v19 then
                v19.Volume = Volume
                table.insert(p8._pendingSounds, {
                    triggered = false,
                    name = child.Name,
                    sound = v19,
                    start = Start,
                    offset = Offset,
                    stopAt = End
                })
            else
                warn("[src/client/components/cast-cutscene-component.ts:292]", (("[CastCutScene] sound \"%*\" not pre-registered — skipping"):format(child.Name)))
            end
        end
    end
end

function self._listenToVFX(p10, p11) -- line: 246
    -- upvalues: emitVFX (copy), setVFXEnabled (copy)
    local VFX = p10.instance:FindFirstChild("VFX")

    if not (if VFX == nil then VFX else VFX:IsA("Folder")) then
        VFX = nil
    end

    if VFX == nil then
        warn("[src/client/components/cast-cutscene-component.ts:312]", "[CastCutScene] VFX folder is missing; continuing without cast VFX")

        return nil
    end

    local _isPerfect = p10._isPerfect

    p11.KeyframeReached:Connect(function(p12) -- line: 258
        -- upvalues: p10 (copy), VFX (ref), _isPerfect (copy), emitVFX (copy), setVFXEnabled (copy)
        if p12 == "Fart" then
            emitVFX(VFX.Fart)
        elseif p12 == "Impact" then
            emitVFX(VFX.Impact)
        elseif p12 == "Impact (HighFive)" then
            emitVFX(VFX.HighFiveImpact)
        elseif p12 == "JumpSmoke" then
            emitVFX(VFX.JumpSmoke)
        elseif p12 == "ChargingWind, Sprinkles" then
            setVFXEnabled(VFX.ChargingWind, true)
            setVFXEnabled(VFX.Sprinkles, true)
            setVFXEnabled(VFX.ChargingWindCam, true)
        elseif p12 == "STOP BWLightning, ChargingWind & Cam Lightning" then
            setVFXEnabled(VFX.BWLightning, true)
            setVFXEnabled(VFX.ChargingWind, false)
            setVFXEnabled(VFX.ChargingWindCam, false)

            if not _isPerfect then
                setVFXEnabled(VFX.Lightning, true)
                p10._maid:GiveTask(task.delay(2, function() -- line: 277
                    -- upvalues: VFX (ref), setVFXEnabled (copy)
                    return setVFXEnabled(VFX.Lightning, false)
                end))
            end

            p10._maid:GiveTask(task.delay(2, function() -- line: 281
                -- upvalues: VFX (ref), setVFXEnabled (copy)
                return setVFXEnabled(VFX.BWLightning, false)
            end))
        elseif p12 == "START FlyingWind" then
            setVFXEnabled(VFX.FlyingWind, true)
        elseif p12 == "STOP Sprinkles" then
            setVFXEnabled(VFX.Sprinkles, false)
        elseif p12 == "STOP FlyingWind" then
            setVFXEnabled(VFX.FlyingWind, false)
        elseif p12 == "START Lightning" then
            setVFXEnabled(VFX.Lightning, true)
        elseif p12 == "STOP Lightning" then
            setVFXEnabled(VFX.Lightning, false)
        elseif p12 == "START ShootingStars" then
            setVFXEnabled(VFX.ShootingStars, true)
        elseif p12 == "STOP ShootingStars" then
            setVFXEnabled(VFX.ShootingStars, false)
        end
    end)
end

function self.onRender(p13, p14) -- line: 301
    -- upvalues: clientProducer (copy)
    if not p13.instance.Parent then
        return nil
    end

    p13._animTime += p14

    local v20 = if p13._soundClockTrack == nil or not p13._soundClockTrack.IsPlaying then p13._animTime else p13._soundClockTrack.TimePosition

    for _, v21 in p13._pendingSounds do
        if not v21.triggered and v21.start <= v20 then
            v21.triggered = true
            print((("[CastCutScene] sound triggered: \"%*\" at clock=%*"):format(v21.name, v20)))

            if v21.name == "SingleSwing" then
                p13._fovMotion:spring(100, {
                    frequency = 2.5
                })
            end

            v21.sound.TimePosition = v21.offset
            v21.sound:Play()

            if v21.stopAt > 0 then
                p13._maid:GiveTask(task.delay(v21.stopAt - v21.offset, function() -- line: 325
                    -- upvalues: v21 (copy)
                    return v21.sound:Stop()
                end))
            end
        end
    end

    local CurrentCamera = game.Workspace.CurrentCamera

    if CurrentCamera then
        CurrentCamera.FieldOfView = p13._fovMotion:step(p14)
    end

    if not p13._activeCamera then
        return nil
    end

    p13._time += p14 * 60

    local v24 = p13._activeCamera.Frames:FindFirstChild((tostring((math.ceil(p13._time)))))

    if v24 then
        local CurrentCamera = game.Workspace.CurrentCamera

        if CurrentCamera then
            CurrentCamera.CFrame = p13.instance.CameraPart.CFrame * v24.Value
        end
    end

    local VFX = p13.instance:FindFirstChild("VFX")

    if VFX ~= nil then
        VFX = VFX:FindFirstChild("FlyingWind")
    end

    if VFX ~= nil and VFX:IsA("Attachment") then
        VFX.WorldCFrame = p13.instance.MiniPlayerRigR15.Head.CFrame
    end

    clientProducer.castCutsceneMiniRigEndSet({
        cframe = p13.instance.MiniPlayerRigR15.Head.CFrame
    })
end

function self.destroy(p15) -- line: 363
    -- upvalues: BaseComponent (copy), CollectionService (copy), baseFov (copy), clearBaitAuraVfx (copy)
    print((("[CastDebug] CastCutSceneComponent.destroy() called for %* — instanceParent=%* hasTag=%*"):format(p15.instance:GetFullName(), p15.instance.Parent, (CollectionService:HasTag(p15.instance, "CastCutScene")))))
    BaseComponent.destroy(p15)

    local MiniPlayerRigR15 = p15.instance:FindFirstChild("MiniPlayerRigR15")

    if MiniPlayerRigR15 then
        clearBaitAuraVfx(MiniPlayerRigR15)
    end

    p15._maid:Destroy()

    local CurrentCamera = game.Workspace.CurrentCamera

    if CurrentCamera then
        CurrentCamera.FieldOfView = baseFov
    end

    p15._fovMotion:destroy()
end

Reflect.defineMetadata(self, "identifier", "client/components/cast-cutscene-component@CastCutSceneComponent")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/sound-controller@SoundController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnRender" })
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "CastCutScene",
        attributes = {
            IsPerfect = t.boolean
        },
        instanceGuard = t.intersection(t.instanceIsA("Folder"), t.children({
            CameraPart = t.instanceIsA("BasePart"),
            MiniPlayerRigR15 = t.intersection(t.instanceIsA("Model"), t.children({
                Head = t.intersection(t.instanceIsA("BasePart"), t.children({
                    HatAttachment = t.instanceIsA("Attachment")
                })),
                Humanoid = t.intersection(t.instanceIsA("Humanoid"), t.children({
                    Animator = t.instanceIsA("Animator")
                })),
                HumanoidRootPart = t.instanceIsA("BasePart")
            })),
            NonPerfectCamera = t.intersection(t.instanceIsA("Folder"), t.children({
                FOV = t.instanceIsA("Folder"),
                Frames = t.instanceIsA("Folder")
            })),
            NonPerfectSounds = t.instanceIsA("Folder"),
            PerfectCamera = t.intersection(t.instanceIsA("Folder"), t.children({
                FOV = t.instanceIsA("Folder"),
                Frames = t.instanceIsA("Folder")
            })),
            PerfectSounds = t.instanceIsA("Folder"),
            PlayerRigR15 = t.intersection(t.instanceIsA("Model"), t.children({
                Humanoid = t.intersection(t.instanceIsA("Humanoid"), t.children({
                    Animator = t.instanceIsA("Animator")
                })),
                RightHand = t.instanceIsA("BasePart")
            })),
            VFX = t.optional(t.intersection(t.instanceIsA("Folder"), t.children({
                BWLightning = t.instanceIsA("Attachment"),
                ChargingWind = t.instanceIsA("Attachment"),
                ChargingWindCam = t.instanceIsA("Attachment"),
                Fart = t.instanceIsA("Attachment"),
                FlyingWind = t.instanceIsA("Attachment"),
                HighFiveImpact = t.instanceIsA("Attachment"),
                Impact = t.instanceIsA("Attachment"),
                JumpSmoke = t.instanceIsA("Attachment"),
                Lightning = t.instanceIsA("Attachment"),
                ShootingStars = t.instanceIsA("Part"),
                Sprinkles = t.instanceIsA("Attachment")
            })))
        }))
    }
})

return {
    CastCutSceneComponent = self
}
