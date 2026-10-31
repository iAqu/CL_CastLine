-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out")
local BaseComponent, Component = out.BaseComponent, out.Component
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, Workspace = services.Players, services.Workspace
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "bait-aura-vfx-utils")
local applyBaitAuraVfx, clearBaitAuraVfx = v1.applyBaitAuraVfx, v1.clearBaitAuraVfx
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "bait-aura-showcase")
local auraShowcaseAuraAttribute, auraShowcaseSetAttribute, auraShowcaseSetConfigs, getAuraShowcaseAnimationIds = v2.auraShowcaseAuraAttribute, v2.auraShowcaseSetAttribute, v2.auraShowcaseSetConfigs, v2.getAuraShowcaseAnimationIds
local getAuraShowcaseCycleSeconds, resolveAuraShowcasePlaylist = v2.getAuraShowcaseCycleSeconds, v2.resolveAuraShowcasePlaylist
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 31
        return "AuraShowcasePodiumComponent"
    end,
    __index = BaseComponent
})

self.__index = self

function self.new(...) -- line: 37
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, ...) -- line: 41
    -- upvalues: BaseComponent (copy)
    BaseComponent.constructor(p1, ...)
    p1._characterSpawnQueued = false
    p1._previewRigRetryAttempts = 0
    p1._previewRigWarningEmitted = false
    p1._animationTracks = {}
    p1._animationAssets = {}
    p1._animationPlaylist = {}
    p1._animationIds = {}
    p1._animationIndex = 0
    p1._auraIndex = 0
end

function self.onStart(p2) -- line: 53
    -- upvalues: auraShowcaseSetAttribute (copy), auraShowcaseSetConfigs (copy), getAuraShowcaseAnimationIds (copy), resolveAuraShowcasePlaylist (copy)
    local Attribute = p2.instance:GetAttribute(auraShowcaseSetAttribute)

    if type(Attribute) ~= "string" then
        Attribute = "default"
    end

    p2._showcaseConfig = auraShowcaseSetConfigs[Attribute]

    if p2._showcaseConfig ~= nil then
        p2._animationPlaylist = resolveAuraShowcasePlaylist(p2._showcaseConfig)
        p2._animationIds = getAuraShowcaseAnimationIds(p2._showcaseConfig)
    end

    if not p2:_tryInitializePrompt() then
        p2._promptConnection = p2.instance.DescendantAdded:Connect(function() -- line: 62
            -- upvalues: p2 (copy)
            if not p2:_tryInitializePrompt() then
                return nil
            end

            local _promptConnection = p2._promptConnection

            if _promptConnection ~= nil then
                _promptConnection:Disconnect()
            end

            p2._promptConnection = nil
        end)
    end

    p2._previewRigConnection = p2.instance.DescendantAdded:Connect(function() -- line: 75
        -- upvalues: p2 (copy)
        p2:_tryInitializePreviewRig()
    end)
    p2:_tryInitializePreviewRig()
end

function self._tryInitializePrompt(p3) -- line: 80
    -- upvalues: Players (copy), clientProducer (copy)
    local Descendants = p3.instance:GetDescendants()

    local function v5(p4) -- line: 83
        if p4.Name == "ProximityPart" then
            return (p4:IsA("BasePart"))
        end

        return false
    end

    local v6

    for v7, v8 in Descendants do
        local _ = v7 - 1

        if (v8.Name == "ProximityPart" and v8:IsA("BasePart")) == true then
            v6 = v8
            break
        end

        v6 = nil
    end

    local AuraRerollPrompt, v9

    if v6 ~= nil then
        if v6:IsA("BasePart") then
            AuraRerollPrompt = v6:FindFirstChild("AuraRerollPrompt")

            if AuraRerollPrompt == nil then
                AuraRerollPrompt = Instance.new("ProximityPrompt")
                AuraRerollPrompt.Name = "AuraRerollPrompt"
                AuraRerollPrompt.Parent = v6
            end

            v9 = false
        else
            v9 = true
        end
    else
        v9 = true
    end

    if v9 then
        return false
    end

    if not AuraRerollPrompt:IsA("ProximityPrompt") then
        local v10 = true

        return not v10
    end

    AuraRerollPrompt.ActionText = "Reroll"
    AuraRerollPrompt.ObjectText = "Bait Auras"
    AuraRerollPrompt.HoldDuration = 0.3
    AuraRerollPrompt.KeyboardKeyCode = Enum.KeyCode.E
    AuraRerollPrompt.MaxActivationDistance = 20
    AuraRerollPrompt.RequiresLineOfSight = false

    if AuraRerollPrompt:GetAttribute("AuraRerollPromptConfigured") ~= true then
        AuraRerollPrompt:SetAttribute("AuraRerollPromptConfigured", true)
        AuraRerollPrompt.Triggered:Connect(function(p5) -- line: 115
            -- upvalues: Players (copy), clientProducer (copy)
            if p5 == Players.LocalPlayer then
                clientProducer.windowOpened({
                    currentWindow = "baitAuras"
                })
            end
        end)
    end

    return not false
end

function self._tryInitializePreviewRig(p6) -- line: 125
    if p6._previewPivot ~= nil then
        return nil
    end

    local Descendants = p6.instance:GetDescendants()

    local function v11(p7) -- line: 131
        if p7.Name == "PreviewRig" then
            return (p7:IsA("BasePart"))
        end

        return false
    end

    local v12

    for v13, v14 in Descendants do
        local _ = v13 - 1

        if (v14.Name == "PreviewRig" and v14:IsA("BasePart")) == true then
            v12 = v14
            break
        end

        v12 = nil
    end

    if v12 ~= nil and v12:IsA("BasePart") then
        if p6._previewRigRetryThread ~= nil then
            task.cancel(p6._previewRigRetryThread)
            p6._previewRigRetryThread = nil
        end

        p6._previewRigRetryAttempts = 0
        p6._previewRigWarningEmitted = false

        local _previewRigConnection = p6._previewRigConnection

        if _previewRigConnection ~= nil then
            _previewRigConnection:Disconnect()
        end

        p6._previewRigConnection = nil
        p6:_initializePreviewRig(v12)

        return nil
    end

    p6._previewRigRetryAttempts += 1

    if p6._previewRigRetryAttempts <= 30 then
        if p6._previewRigRetryThread == nil then
            p6._previewRigRetryThread = task.delay(0.1, function() -- line: 164
                -- upvalues: p6 (copy)
                p6._previewRigRetryThread = nil
                p6:_tryInitializePreviewRig()
            end)
        end
    elseif not p6._previewRigWarningEmitted then
        p6._previewRigWarningEmitted = true

        local Descendants = p6.instance:GetDescendants()
        local t4 = {}

        local function v15(p8) -- line: 174
            return p8.Name == "PreviewRig"
        end

        local n1 = 0

        for v16, v17 in Descendants do
            local _ = v16 - 1

            if v17.Name == "PreviewRig" == true then
                n1 += 1
                t4[n1] = v17
            end
        end

        local v18 = table.create(#t4)

        local function v19(p9) -- line: 187
            return (("%* (%*)"):format(p9:GetFullName(), p9.ClassName))
        end

        for v20, v21 in t4 do
            local _ = v20 - 1

            v18[v20] = ("%* (%*)"):format(v21:GetFullName(), v21.ClassName)
        end

        local v22 = table.concat(v18, ", ")
        local _warn = warn
        local v23 = "[src/client/components/aura-showcase-podium-component.ts:156]"
        local v24 = "AuraShowcasePodiumComponent: %* is missing a BasePart named PreviewRig after retries. Found: %*"
        local FullName = p6.instance:GetFullName()

        if v22 == "" then
            v22 = "none"
        end

        _warn(v23, (v24:format(FullName, v22)))
    end
end

function self._initializePreviewRig(p10, p11) -- line: 198
    -- upvalues: Players (copy), auraShowcaseAuraAttribute (copy)
    if p10._previewPivot ~= nil then
        return nil
    end

    p10._previewPivot = p11:GetPivot()

    local LocalPlayer = Players.LocalPlayer

    p10._characterAddedConnection = LocalPlayer.CharacterAdded:Connect(function(p12) -- line: 204
        -- upvalues: p10 (copy)
        p10:_queueCharacterPreview(p12)
    end)
    p10._characterAppearanceLoadedConnection = LocalPlayer.CharacterAppearanceLoaded:Connect(function(p13) -- line: 207
        -- upvalues: p10 (copy)
        return p10:_queueCharacterPreview(p13)
    end)

    local Character = LocalPlayer.Character

    if Character ~= nil then
        p10:_queueCharacterPreview(Character)
    else
        warn("[src/client/components/aura-showcase-podium-component.ts:179]", (("AuraShowcasePodiumComponent: %* is waiting for the local character"):format((p10.instance:GetFullName()))))
    end

    p10._auraAttributeConnection = p10.instance:GetAttributeChangedSignal(auraShowcaseAuraAttribute):Connect(function() -- line: 216
        -- upvalues: p10 (copy)
        return p10:_applyCurrentAura()
    end)
end

function self._queueCharacterPreview(p14, p15) -- line: 220
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer

    if LocalPlayer.Character ~= p15 or p14._previewSourceCharacter == p15 and p14._rig ~= nil then
        return nil
    end

    p14._queuedCharacter = p15

    if p14._characterSpawnQueued then
        return nil
    end

    p14._characterSpawnQueued = true
    task.defer(function() -- line: 233
        -- upvalues: p14 (copy), LocalPlayer (copy)
        p14._characterSpawnQueued = false

        local _queuedCharacter = p14._queuedCharacter

        p14._queuedCharacter = nil

        if _queuedCharacter == nil or LocalPlayer.Character ~= _queuedCharacter or _queuedCharacter.Parent == nil or p14._previewPivot == nil then
            return nil
        end

        p14:_spawnCharacterCopy(_queuedCharacter)
    end)
end

function self._spawnCharacterCopy(p16, p17) -- line: 243
    -- upvalues: clearBaitAuraVfx (copy)
    if p16._previewPivot == nil then
        return nil
    end

    if p16._rig ~= nil then
        p16:_stopShowcaseAnimation()
        clearBaitAuraVfx(p16._rig)
        p16._rig:Destroy()
        p16._rig = nil
    end

    local Archivable = p17.Archivable

    p17.Archivable = true

    local clone = p17:Clone()

    p17.Archivable = Archivable

    if clone == nil then
        warn("[src/client/components/aura-showcase-podium-component.ts:228]", (("AuraShowcasePodiumComponent: failed to clone the local character for %*"):format((p16.instance:GetFullName()))))

        return nil
    end

    p16:_removeHeldItemsFromClone(clone)
    clone.Name = "AuraShowcaseRig"

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BaseScript")
            or descendant:IsA("Tool")
            or descendant:IsA("ForceField")
            or descendant:IsA("BillboardGui")
            or descendant:IsA("SurfaceGui")
            or descendant:IsA("Beam") then
            descendant:Destroy()
        elseif descendant:IsA("BasePart") then
            descendant.CanCollide = false
            descendant.CanTouch = false
            descendant.CanQuery = false
            descendant.Massless = true
            descendant.LocalTransparencyModifier = 0
        end
    end

    local HumanoidRootPart = clone:FindFirstChild("HumanoidRootPart")

    if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then
        HumanoidRootPart.Anchored = true
        clone.PrimaryPart = HumanoidRootPart
    end

    clone:PivotTo(p16._previewPivot)
    clone.Parent = p16.instance
    p16._rig = clone
    p16._previewSourceCharacter = p17
    p16:_playShowcaseAnimation(clone)

    local Humanoid = clone:FindFirstChildOfClass("Humanoid")

    if Humanoid ~= nil then
        Humanoid.AutoRotate = false
        Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        Humanoid.NameDisplayDistance = 0
        Humanoid.HealthDisplayDistance = 0
        Humanoid.DisplayName = ""
    end

    p16:_applyCurrentAura()
end

function self._playShowcaseAnimation(p18, p19) -- line: 297
    local _showcaseConfig = p18._showcaseConfig

    if _showcaseConfig == nil or #p18._animationIds == 0 then
        return nil
    end

    local Humanoid = p19:FindFirstChildOfClass("Humanoid")

    if Humanoid == nil then
        warn("[src/client/components/aura-showcase-podium-component.ts:288]", (("AuraShowcasePodiumComponent: animation playlist requires a Humanoid on %*"):format((p18.instance:GetFullName()))))

        return nil
    end

    local Animator = Humanoid:FindFirstChildOfClass("Animator")

    if Animator == nil then
        Animator = Instance.new("Animator")
        Animator.Parent = Humanoid
    end

    p18._animationIndex = 0
    p18._auraIndex = 0
    p18._animationAnimator = Animator
    p18._animationTracks = {}
    p18._animationAssets = {}

    for _, v25 in p18._animationIds do
        local Animation = Instance.new("Animation")

        Animation.AnimationId = v25
        Animation.Parent = p19

        local track = Animator:LoadAnimation(Animation)

        track.Looped = true
        track.Priority = Enum.AnimationPriority.Action
        table.insert(p18._animationAssets, Animation)
        table.insert(p18._animationTracks, track)
    end

    p18:_playCurrentShowcaseAnimation(_showcaseConfig)
end

function self._playCurrentShowcaseAnimation(p20, p21) -- line: 337
    -- upvalues: auraShowcaseAuraAttribute (copy)
    if p20._animationAnimator == nil or #p20._animationTracks == 0 then
        return nil
    end

    local _animationLoopConnection = p20._animationLoopConnection

    if _animationLoopConnection ~= nil then
        _animationLoopConnection:Disconnect()
    end

    p20._animationLoopConnection = nil

    local v26 = p20._animationTracks[p20._animationIndex + 1]

    for _, v27 in p20._animationTracks do
        if v27 ~= v26 then
            v27:Stop()
        end
    end

    v26:Play()
    p20._animationTrack = v26

    if p21.cycleType == "syncAnimSeconds" then
        p20:_scheduleSynchronizedCycle(p21)

        return nil
    end

    p20._animationLoopConnection = v26.DidLoop:Connect(function() -- line: 358
        -- upvalues: p20 (copy), p21 (copy), auraShowcaseAuraAttribute (copy)
        p20._animationIndex = (p20._animationIndex + 1) % #p20._animationIds

        if p21.cycleType == "waitForAnim" and #p20._animationPlaylist > 0 then
            p20._auraIndex = (p20._auraIndex + 1) % #p20._animationPlaylist
            p20.instance:SetAttribute(auraShowcaseAuraAttribute, p20._animationPlaylist[p20._auraIndex + 1].auraName)
        end

        p20:_playCurrentShowcaseAnimation(p21)
    end)
end

function self._scheduleSynchronizedCycle(p22, p23) -- line: 367
    -- upvalues: auraShowcaseAuraAttribute (copy), getAuraShowcaseCycleSeconds (copy)
    p22._syncAnimationCycleThread = task.delay(getAuraShowcaseCycleSeconds(p23), function() -- line: 368
        -- upvalues: p22 (copy), p23 (copy), auraShowcaseAuraAttribute (copy)
        p22._syncAnimationCycleThread = nil
        p22._animationIndex = (p22._animationIndex + 1) % #p22._animationIds

        if #p22._animationPlaylist > 0 then
            p22._auraIndex = (p22._auraIndex + 1) % #p22._animationPlaylist
            p22.instance:SetAttribute(auraShowcaseAuraAttribute, p22._animationPlaylist[p22._auraIndex + 1].auraName)
        end

        p22:_playCurrentShowcaseAnimation(p23)
    end)
end

function self._removeHeldItemsFromClone(_, p25) -- line: 378
    for _, child in p25:GetChildren() do
        local v29 = child:GetAttribute("itemType") == "fish"
        local ToolbarFish = child:HasTag("ToolbarFish")

        if not ToolbarFish then
            local Descendants = child:GetDescendants()

            local function v30(p26) -- line: 386
                return p26:HasTag("ToolbarFish")
            end

            ToolbarFish = false

            for v31, v32 in Descendants do
                local _ = v31 - 1

                if v32:HasTag("ToolbarFish") then
                    ToolbarFish = true
                    break
                end

                ToolbarFish = false
            end
        end

        if child:HasTag("ToolbarSelectedItem") or v29 or ToolbarFish then
            child:Destroy()
        end
    end
end

function self._stopShowcaseAnimation(p27) -- line: 404
    if p27._syncAnimationCycleThread ~= nil then
        task.cancel(p27._syncAnimationCycleThread)
        p27._syncAnimationCycleThread = nil
    end

    local _animationLoopConnection = p27._animationLoopConnection

    if _animationLoopConnection ~= nil then
        _animationLoopConnection:Disconnect()
    end

    p27._animationLoopConnection = nil

    for _, v33 in p27._animationTracks do
        v33:Stop()
    end

    for _, v34 in p27._animationAssets do
        v34:Destroy()
    end

    p27._animationTracks = {}
    p27._animationAssets = {}
    p27._animationTrack = nil
    p27._animationAnimator = nil
end

function self._applyCurrentAura(p28) -- line: 425
    -- upvalues: applyBaitAuraVfx (copy), auraShowcaseAuraAttribute (copy)
    if p28._rig == nil then
        return nil
    end

    local Attribute = p28.instance:GetAttribute(auraShowcaseAuraAttribute)
    local _rig = p28._rig

    if type(Attribute) ~= "string" then
        Attribute = nil
    end

    applyBaitAuraVfx(_rig, Attribute, 1, false)
end

function self.destroy(p29) -- line: 432
    -- upvalues: BaseComponent (copy), clearBaitAuraVfx (copy)
    local _auraAttributeConnection = p29._auraAttributeConnection

    if _auraAttributeConnection ~= nil then
        _auraAttributeConnection:Disconnect()
    end

    local _characterAddedConnection = p29._characterAddedConnection

    if _characterAddedConnection ~= nil then
        _characterAddedConnection:Disconnect()
    end

    local _characterAppearanceLoadedConnection = p29._characterAppearanceLoadedConnection

    if _characterAppearanceLoadedConnection ~= nil then
        _characterAppearanceLoadedConnection:Disconnect()
    end

    local _previewRigConnection = p29._previewRigConnection

    if _previewRigConnection ~= nil then
        _previewRigConnection:Disconnect()
    end

    local _promptConnection = p29._promptConnection

    if _promptConnection ~= nil then
        _promptConnection:Disconnect()
    end

    if p29._previewRigRetryThread ~= nil then
        task.cancel(p29._previewRigRetryThread)
        p29._previewRigRetryThread = nil
    end

    p29._previewRigRetryAttempts = 0
    p29._queuedCharacter = nil
    p29._characterSpawnQueued = false
    p29._previewPivot = nil
    p29._previewSourceCharacter = nil
    p29:_stopShowcaseAnimation()

    if p29._rig ~= nil then
        clearBaitAuraVfx(p29._rig)
        p29._rig:Destroy()
        p29._rig = nil
    end

    BaseComponent.destroy(p29)
end

Reflect.defineMetadata(self, "identifier", "client/components/aura-showcase-podium-component@AuraShowcasePodiumComponent")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "AuraShowcase",
        ancestorWhitelist = { Workspace },
        defaults = {},
        attributes = {},
        instanceGuard = t.instanceIsA("Model")
    }
})

return {
    AuraShowcasePodiumComponent = self
}
