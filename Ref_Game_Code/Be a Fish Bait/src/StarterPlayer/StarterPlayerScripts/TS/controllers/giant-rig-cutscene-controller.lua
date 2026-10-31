-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, ContentProvider, HttpService, Players = services.CollectionService, services.ContentProvider, services.HttpService, services.Players
local ReplicatedStorage, RunService, SoundService, StarterGui = services.ReplicatedStorage, services.RunService, services.SoundService, services.StarterGui
local TweenService, Workspace = services.TweenService, services.Workspace
local emitVFX = RuntimeLib.import(script, script.Parent.Parent, "vfx").emitVFX
local events = RuntimeLib.import(script, script.Parent.Parent, "network").events
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local copyLiveCharacterAppearanceToRig = RuntimeLib.import(script, script.Parent.Parent, "react", "hooks", "use-apply-local-character-appearance-to-rig").copyLiveCharacterAppearanceToRig
local giantRigCutsceneConfig = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "giant-rig-cutscene-config").giantRigCutsceneConfig
local t1 = {
    "PlayerRig1R15",
    "PlayerRig2R15",
    "PlayerRig3R15",
    "PlayerRig4R15",
    "PlayerRig5R15",
    "PlayerRig6R15"
}
local t2 = {
    KneelImpactOn = "KneelImpact",
    HitOn = "Hit",
    Hit2On = "Hit2",
    SalivaOn = "Saliva",
    FartOn = "Fart",
    BaitOpenOn = "BaitOpen",
    GoldenSparkOn = "GoldenSpark"
}
local t3 = {
    SlashOn = {
        enabled = true,
        targetName = "Slash"
    },
    SlashOff = {
        enabled = false,
        targetName = "Slash"
    },
    WindOn = {
        enabled = true,
        targetName = "Wind"
    },
    WindOff = {
        enabled = false,
        targetName = "Wind"
    },
    Wind2On = {
        enabled = true,
        targetName = "Wind2"
    },
    Wind2Off = {
        enabled = false,
        targetName = "Wind2"
    },
    PortalOn = {
        enabled = true,
        targetName = "EventPortal"
    },
    PortalOff = {
        enabled = false,
        targetName = "EventPortal"
    }
}
local t4 = {
    StopCutscene = true,
    CutsceneEnd = true,
    EndCutscene = true
}
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 74
        return "GiantRigCutsceneController"
    end
})

self.__index = self

function self.new(...) -- line: 79
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2, p3) -- line: 83
    p1._characterController = p2
    p1._soundController = p3
end

function self.onStart(p4) -- line: 87
    -- upvalues: HttpService (copy), events (copy), clientProducer (copy)
    p4:_primeSceneCache(1)
    events.prepareGiantRigCutscene:connect(function(p5, p6) -- line: 91
        -- upvalues: p4 (copy)
        p4:_beginPreparation(p5, p6)
    end)
    events.giantRigCutscenePreparationCancelled:connect(function(p7) -- line: 94
        -- upvalues: p4 (copy)
        p4:_cancelPreparation(p7)
    end)
    events.giantRigCutsceneTeleportFailed:connect(function(p8) -- line: 97
        -- upvalues: p4 (copy), HttpService (copy), clientProducer (copy)
        if p4._teleportLoadingSessionId ~= p8 then
            return nil
        end

        p4._teleportLoadingSessionId = nil

        if clientProducer:getState().currentWindow.currentWindow == "eventLoadingScreen" then
            clientProducer.windowClosed({})
        end

        clientProducer.onScreenFeedbackAdded({
            message = "Could not teleport to Party Island.",
            type = "error",
            id = HttpService:GenerateGUID(false)
        })
    end)
    events.abortGiantRigCutscene:connect(function(p9) -- line: 111
        -- upvalues: p4 (copy), clientProducer (copy)
        p4:_cancelPreparation(p9)

        if p4._teleportLoadingSessionId == p9 then
            p4._teleportLoadingSessionId = nil

            if clientProducer:getState().currentWindow.currentWindow == "eventLoadingScreen" then
                clientProducer.windowClosed({})
            end
        end

        p4:_finishActiveCutscene(p9, false)
    end)
    events.startGiantRigCutscene:connect(function(p10, p11, p12) -- line: 121
        -- upvalues: p4 (copy)
        p4:_startPreparedCutscene(p10, p11, p12):catch(function(p13) -- line: 122
            -- upvalues: p10 (copy), p4 (copy)
            warn(("[GiantRigCutscene] Failed to start session %*:"):format(p10), p13)
            p4:_finishActiveCutscene(p10)
        end)
    end)
end

function self.onRender(p14) -- line: 128
    -- upvalues: Workspace (copy)
    local _active = p14._active
    local v3, v4

    if _active ~= nil then
        if _active.animationStarted then
            v3 = if _active.masterTrack == nil then math.max(0, Workspace:GetServerTimeNow() - _active.startedAt) elseif _active.masterTrack.IsPlaying then _active.masterTrack.TimePosition else math.max(0, Workspace:GetServerTimeNow() - _active.startedAt)
            v4 = false
        else
            v4 = true
        end
    else
        v4 = true
    end

    if v4 then
        return nil
    end

    p14:_updateFlyPlaybackSpeed(_active, v3)
    p14:_updateSounds(_active, v3)
    p14:_updateCamera(_active.cameraPlayback, v3)
    p14:_updateObjectPlayback(_active.objectPlayback, v3)
    p14:_updateParticipantRigVisibility(_active, v3)
    p14:_updateEndingFade(_active)
end

function self._applyAppearanceToRig(p15, p16, p17) -- line: 141
    -- upvalues: RuntimeLib (copy), Players (copy), copyLiveCharacterAppearanceToRig (copy)
    local PlayerByUserId = Players:GetPlayerByUserId(p17)

    if PlayerByUserId ~= nil then
        PlayerByUserId = PlayerByUserId.Character
    end

    if PlayerByUserId == nil then
        return RuntimeLib.Promise.new(function(p18) -- line: 152
            -- upvalues: p15 (copy), p16 (copy), p17 (copy)
            task.spawn(function() -- line: 153
                -- upvalues: p18 (copy), p15 (copy), p16 (copy), p17 (copy)
                local Humanoid = p16:FindFirstChildOfClass("Humanoid")

                if Humanoid == nil then
                    warn((("[GiantRigCutscene] %* has no Humanoid"):format(p16.Name)))
                    p18()

                    return nil
                end

                local v7 = p15:_getPlayerDescription(p17)

                if v7 == nil then
                    warn((("[GiantRigCutscene] Could not resolve appearance for %*"):format(p17)))
                    p18()

                    return nil
                end

                Humanoid.AutomaticScalingEnabled = false
                p15:_applyAuthoredScales(Humanoid, v7)

                local function v8() -- line: 168
                    -- upvalues: Humanoid (copy), v7 (copy)
                    return Humanoid:ApplyDescriptionAsync(v7)
                end

                local ok, result = pcall(v8)

                if not ok then
                    warn(("[GiantRigCutscene] ApplyDescriptionAsync failed for %*:"):format(p17), result)
                end

                p15:_configureRigPhysics(p16)
                p18()
            end)
        end)
    end

    copyLiveCharacterAppearanceToRig(PlayerByUserId, p16)
    p15:_configureRigPhysics(p16)

    return RuntimeLib.Promise.resolve()
end

function self._applyAuthoredScales(_, p20, p21) -- line: 179
    for _, child in p20:GetChildren() do
        if child:IsA("NumberValue") then
            local Value = child.Value

            if child.Name == "BodyDepthScale" then
                p21.DepthScale = Value
            elseif child.Name == "BodyHeightScale" then
                p21.HeightScale = Value
            elseif child.Name == "BodyProportionScale" then
                p21.ProportionScale = Value
            elseif child.Name == "BodyTypeScale" then
                p21.BodyTypeScale = Value
            elseif child.Name == "BodyWidthScale" then
                p21.WidthScale = Value
            elseif child.Name == "HeadScale" then
                p21.HeadScale = Value
            end
        end
    end
end

function self._beginPreparation(p22, p23, p24) -- line: 200
    -- upvalues: RuntimeLib (copy), Players (copy)
    local UserId = Players.LocalPlayer.UserId

    if table.find(p24, UserId) == nil then
        p22:_cancelPreparation()

        return nil
    end

    local _prepared = p22._prepared

    if _prepared ~= nil and _prepared.sessionId == p23 and p22:_sameUserIds(_prepared.participantUserIds, p24) then
        return nil
    end

    p22:_cancelPreparation()

    local t8 = {
        building = true,
        cancelled = false,
        clone = nil
    }
    local t9 = {}
    local v9 = #t9

    table.move(p24, 1, #p24, v9 + 1, t9)
    t8.participantUserIds = t9
    t8.ready = RuntimeLib.Promise.resolve(nil)
    t8.sessionId = p23
    t8.ready = p22:_buildPreparedScene(t8)
    p22._prepared = t8
end

self._buildPreparedScene = RuntimeLib.async(function(p25, p26) -- line: 228
    -- upvalues: RuntimeLib (copy), events (copy), giantRigCutsceneConfig (copy), t1 (copy)
    local v10 = RuntimeLib.await(p25:_takeCachedScene())

    if v10 == nil then
        p26.building = false

        return nil
    end

    p26.clone = v10

    if p26.cancelled then
        p26.building = false
        p25:_recyclePreparedScene(p26, v10)

        return nil
    end

    v10.Name = ("%*_%*"):format(giantRigCutsceneConfig.sourceName, p26.sessionId)

    local t10 = {}
    local participantUserIds = p26.participantUserIds

    local function v11(p27, p28) -- line: 244
        -- upvalues: p25 (copy), v10 (copy), t10 (copy), t1 (copy)
        local v12 = v10:FindFirstChild(t1[p28 + 1], true)

        if v12 == nil or not v12:IsA("Model") then
            warn((("[GiantRigCutscene] %* is missing"):format(t1[p28 + 1])))

            return nil
        end

        table.insert(t10, (p25:_applyAppearanceToRig(v12, p27)))
    end

    for v14, v15 in participantUserIds do
        v11(v15, v14 - 1, participantUserIds)
    end

    RuntimeLib.await(RuntimeLib.Promise.all(t10))
    p26.building = false

    if p26.cancelled or v10.Parent == nil then
        p25:_recyclePreparedScene(p26, v10)

        return nil
    end

    for v16, _ in p26.participantUserIds do
        local v18 = v10:FindFirstChild(t1[v16 - 1 + 1], true)

        if v18 ~= nil then
            p25:_showParticipatingRig(v18)
        end
    end

    for i = #p26.participantUserIds, #t1 - 1 do
        local v19 = v10:FindFirstChild(t1[i + 1], true)

        if v19 ~= nil then
            p25:_hideInstance(v19)
        end
    end

    events.giantRigCutscenePrepared:fire(p26.sessionId, p26.participantUserIds)

    return v10
end)
self._createCachedScene = RuntimeLib.async(function(p29, p30) -- line: 284
    -- upvalues: RuntimeLib (copy), ReplicatedStorage (copy), giantRigCutsceneConfig (copy)
    if p30 > 0 then
        task.wait(p30)
    end

    local v20 = ReplicatedStorage:FindFirstChild(giantRigCutsceneConfig.templateName) or ReplicatedStorage:WaitForChild(giantRigCutsceneConfig.templateName, 10)

    if v20 == nil then
        warn((("[GiantRigCutscene] ReplicatedStorage.%* is missing"):format(giantRigCutsceneConfig.templateName)))

        return nil
    end

    local clone = v20:Clone()

    clone.Name = ("%*_Prewarmed"):format(giantRigCutsceneConfig.sourceName)
    clone.Parent = ReplicatedStorage
    p29:_stripLocalAppearanceTags(clone)
    p29:_restoreWeldConstraintReferences(clone)
    p29:_configureScenePhysics(clone)
    p29:_disableAllAuthoredEffects(clone)
    RuntimeLib.await(p29:_preloadSceneContent(clone))

    return clone
end)

function self._primeSceneCache(p31, p32) -- line: 303
    if p31._cachedScene ~= nil then
        return nil
    end

    p31._cachedScene = p31:_createCachedScene(p32)
end

self._takeCachedScene = RuntimeLib.async(function(p33) -- line: 309
    p33:_primeSceneCache(0)

    local _cachedScene = p33._cachedScene

    p33._cachedScene = nil

    return _cachedScene
end)

function self._cancelPreparation(p34, p35) -- line: 315
    local _prepared = p34._prepared

    if _prepared == nil or p35 ~= nil and _prepared.sessionId ~= p35 then
        return nil
    end

    _prepared.cancelled = true

    local clone = _prepared.clone

    if clone ~= nil and not _prepared.building then
        p34:_recyclePreparedScene(_prepared, clone)
    end

    p34._prepared = nil

    if not _prepared.building then
        p34:_primeSceneCache(1)
    end
end

function self._recyclePreparedScene(p36, p37, p38) -- line: 333
    -- upvalues: RuntimeLib (copy), giantRigCutsceneConfig (copy)
    if p37.clone ~= p38 then
        return nil
    end

    p37.clone = nil

    if p38.Parent == nil then
        return nil
    end

    p38.Name = ("%*_Prewarmed"):format(giantRigCutsceneConfig.sourceName)

    if p36._cachedScene == nil then
        p36._cachedScene = RuntimeLib.Promise.resolve(p38)

        return nil
    end

    p38:Destroy()
end

function self._configureRigPhysics(_, p40) -- line: 349
    -- upvalues: giantRigCutsceneConfig (copy)
    local Humanoid = p40:FindFirstChildOfClass("Humanoid")

    if Humanoid ~= nil then
        Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end

    for _, descendant in p40:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
            descendant.CollisionGroup = giantRigCutsceneConfig.collisionGroupName
            descendant.Massless = true
        end
    end

    local HumanoidRootPart = p40:FindFirstChild("HumanoidRootPart")

    if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
        HumanoidRootPart = p40.PrimaryPart or p40:FindFirstChildWhichIsA("BasePart", true)
    end

    if HumanoidRootPart ~= nil then
        HumanoidRootPart.Anchored = true
        HumanoidRootPart.Massless = false
    end
end

function self._restoreWeldConstraintReferences(_, p42) -- line: 371
    -- upvalues: giantRigCutsceneConfig (copy)
    local t11 = {}
    local t12 = {
        p42
    }
    local v21 = #t12
    local Descendants = p42:GetDescendants()

    table.move(Descendants, 1, #Descendants, v21 + 1, t12)

    for _, v22 in t12 do
        if v22:IsA("BasePart") then
            local Attribute = v22:GetAttribute(giantRigCutsceneConfig.weldPartIdAttribute)

            if type(Attribute) == "string" then
                t11[Attribute] = v22
            end
        end
    end

    for _, descendant in p42:GetDescendants() do
        if descendant:IsA("WeldConstraint") then
            descendant.Enabled = false

            local Attribute = descendant:GetAttribute(giantRigCutsceneConfig.weldPart0IdAttribute)
            local Attribute2 = descendant:GetAttribute(giantRigCutsceneConfig.weldPart1IdAttribute)

            if type(Attribute) == "string" then
                descendant.Part0 = t11[Attribute]
            end

            if type(Attribute2) == "string" then
                descendant.Part1 = t11[Attribute2]
            end

            local v23 = descendant:GetAttribute(giantRigCutsceneConfig.weldCrossRigAttribute) == true
            local Attribute3 = descendant:GetAttribute(giantRigCutsceneConfig.weldInitiallyEnabledAttribute)

            if not v23 then
                descendant.Enabled = Attribute3 ~= false
            end
        end
    end
end

function self._setBambooRodAnchored(_, p44, p45) -- line: 406
    local v24 = p44:FindFirstChild("BambooRod", true)

    if v24 == nil then
        return nil
    end

    if not v24:IsA("BasePart") then
        v24 = if v24:IsA("Model") then v24.PrimaryPart or v24:FindFirstChild("Handle") or v24:FindFirstChildWhichIsA("BasePart", true) else v24:FindFirstChildWhichIsA("BasePart", true)
    end

    if v24 ~= nil and v24:IsA("BasePart") then
        v24.Anchored = p45
    end
end

function self._configureScenePhysics(p46, p47) -- line: 416
    -- upvalues: t1 (copy)
    local t13 = {}
    local v25 = #t13
    local v26 = #t1

    table.move(t1, 1, v26, v25 + 1, t13)
    t13[v25 + v26 + 1] = "GiantRigR15"

    for _, v27 in t13 do
        local v28 = p47:FindFirstChild(v27, true)

        if v28 ~= nil and v28:IsA("Model") then
            p46:_configureRigPhysics(v28)
        end
    end

    local v29 = p47:FindFirstChild("BambooRod", true)

    if v29 == nil then
        return nil
    end

    local t14 = {
        v29
    }
    local v30 = #t14
    local Descendants = v29:GetDescendants()

    table.move(Descendants, 1, #Descendants, v30 + 1, t14)

    for _, v31 in t14 do
        if v31:IsA("BasePart") then
            v31.Anchored = false
            v31.CanCollide = false
            v31.CanQuery = false
            v31.CanTouch = false
            v31.Massless = true
        end
    end

    p46:_setBambooRodAnchored(p47, true)
end

function self._disableAllAuthoredEffects(p48, p49) -- line: 449
    for _, descendant in p49:GetDescendants() do
        if p48:_isToggleableEffect(descendant) then
            descendant.Enabled = false
        end
    end
end

function self._getPlayerDescription(_, p51) -- line: 456
    -- upvalues: Players (copy)
    local PlayerByUserId = Players:GetPlayerByUserId(p51)

    if PlayerByUserId ~= nil then
        PlayerByUserId = PlayerByUserId.Character

        if PlayerByUserId ~= nil then
            PlayerByUserId = PlayerByUserId:FindFirstChildOfClass("Humanoid")
        end
    end

    local v32 = PlayerByUserId == nil
    local ok, result

    if not v32 then
        local PlayerByUserId2 = PlayerByUserId

        local function v33() -- line: 467
            -- upvalues: PlayerByUserId2 (copy)
            return PlayerByUserId2:GetAppliedDescription()
        end

        ok, result = pcall(v33)
    end

    if not v32 and ok then
        return result:Clone()
    end

    local function v34() -- line: 474
        -- upvalues: p51 (copy), Players (copy)
        return Players:GetHumanoidDescriptionFromUserId(p51)
    end

    local ok2, result2 = pcall(v34)

    if ok2 then
        return result2:Clone()
    end

    return nil
end

function self._hideInstance(p52, p53) -- line: 482
    local t15 = {
        p53
    }
    local v35 = #t15
    local Descendants = p53:GetDescendants()

    table.move(Descendants, 1, #Descendants, v35 + 1, t15)

    for _, v36 in t15 do
        if v36:IsA("BasePart") then
            v36.Transparency = 1
            v36.CanCollide = false
            v36.CanQuery = false
            v36.CanTouch = false
            v36.Massless = true
        elseif v36:IsA("Decal") or v36:IsA("Texture") then
            v36.Transparency = 1
        elseif p52:_isToggleableEffect(v36) then
            v36.Enabled = false
        end
    end
end

function self._showParticipatingRig(_, p55) -- line: 502
    local t16 = {
        p55
    }
    local v37 = #t16
    local Descendants = p55:GetDescendants()

    table.move(Descendants, 1, #Descendants, v37 + 1, t16)

    for _, v38 in t16 do
        if v38:IsA("BasePart") then
            v38.Transparency = v38.Name == "HumanoidRootPart" and 1 or 0
            v38.CanCollide = false
            v38.CanQuery = false
            v38.CanTouch = false
        elseif v38:IsA("Decal") or v38:IsA("Texture") then
            v38.Transparency = 0
        end
    end
end

function self._captureParticipantRigVisibility(_, p57, p58) -- line: 518
    -- upvalues: t1 (copy)
    local t17 = {}
    local n1 = 0
    local v39 = false

    while true do
        if v39 then
            n1 += 1
        else
            v39 = true
        end

        if n1 < p58 then
            local v40 = p57:FindFirstChild(t1[n1 + 1], true)

            if v40 ~= nil then
                local t18 = {}
                local t19 = {
                    v40
                }
                local v41 = #t19
                local Descendants = v40:GetDescendants()

                table.move(Descendants, 1, #Descendants, v41 + 1, t19)

                for _, v42 in t19 do
                    if v42:IsA("BasePart") or v42:IsA("Decal") or v42:IsA("Texture") then
                        t18[v42] = v42.Transparency
                    end
                end

                table.insert(t17, {
                    transparencies = t18
                })
            end

            continue
        end

        break
    end

    return t17
end

function self._setParticipantRigsVisible(_, p60, p61, p62) -- line: 555
    local v43 = p62 ~= nil and p62

    for _, v44 in p60 do
        for v45, v46 in v44.transparencies do
            if v45.Parent ~= nil then
                local v47 = v45.Name == "Head" or string.lower(v45.Name) == "face"

                if p61 then
                    if v43 and v47 then
                        v45.Transparency = 0
                    else
                        v45.Transparency = v46
                    end
                else
                    v45.Transparency = 1
                end
            end
        end
    end
end

function self._updateParticipantRigVisibility(p63, p64, p65) -- line: 568
    -- upvalues: giantRigCutsceneConfig (copy)
    local v48 = p65 * giantRigCutsceneConfig.authoredFramesPerSecond
    local v49 = v48 < giantRigCutsceneConfig.participantHideFrame or giantRigCutsceneConfig.participantShowFrame <= v48

    if v49 == p64.participantRigsVisible then
        if v49 and giantRigCutsceneConfig.participantShowFrame <= v48 then
            p63:_forceParticipantFacesVisible(p64.participantRigVisibility)
        end

        return nil
    end

    p64.participantRigsVisible = v49
    p63:_setParticipantRigsVisible(p64.participantRigVisibility, v49, giantRigCutsceneConfig.participantShowFrame <= v48)
end

function self._forceParticipantFacesVisible(_, p67) -- line: 580
    for _, v50 in p67 do
        for v51 in v50.transparencies do
            local v52 = string.lower(v51.Name)
            local v53 = string.find(v52, "face", 1, true)

            if v52 == "head" or v53 ~= nil then
                v51.Transparency = 0

                if v51:IsA("BasePart") then
                    v51.LocalTransparencyModifier = 0
                end
            end
        end
    end
end

function self._isToggleableEffect(_, p69) -- line: 595
    local ParticleEmitter = p69:IsA("ParticleEmitter")

    ParticleEmitter = ParticleEmitter
        or p69:IsA("Beam")
        or p69:IsA("Trail")
        or p69:IsA("Smoke")
        or p69:IsA("Fire")
        or p69:IsA("Sparkles")
        or p69:IsA("PointLight")
        or p69:IsA("SpotLight")
        or p69:IsA("SurfaceLight")

    return ParticleEmitter
end

self._preloadSceneContent = RuntimeLib.async(function(p70, p71) -- line: 598
    -- upvalues: ContentProvider (copy), ReplicatedStorage (copy), giantRigCutsceneConfig (copy), t1 (copy)
    local t21 = {}
    local t22 = {}
    local v54 = #t22
    local v55 = #t1

    table.move(t1, 1, v55, v54 + 1, t22)
    t22[v54 + v55 + 1] = "GiantRigR15"

    for _, v56 in t22 do
        local v57 = p71:FindFirstChild(v56, true)

        if v57 ~= nil then
            local v58 = p70:_resolveCutsceneAnimation(p71, v57)

            if v58 ~= nil then
                table.insert(t21, v58)
            end
        end
    end

    local v59 = ReplicatedStorage:FindFirstChild(giantRigCutsceneConfig.soundFolderName)

    if v59 ~= nil then
        for _, child in v59:GetChildren() do
            if child:IsA("StringValue") then
                table.insert(t21, (p70._soundController:registerSound(child.Value)))
            end
        end
    end

    if #t21 == 0 then
        return nil
    end

    local function v61() -- line: 629
        -- upvalues: t21 (copy), ContentProvider (copy)
        return ContentProvider:PreloadAsync(t21)
    end

    local ok, result = pcall(v61)

    if not ok then
        warn("[GiantRigCutscene] Content preload failed:", result)
    end
end)

function self._sameUserIds(_, p73, p74) -- line: 636
    if #p73 ~= #p74 then
        return false
    end

    for v62, v63 in p73 do
        if v63 ~= p74[v62 - 1 + 1] then
            return false
        end
    end

    return true
end

self._startPreparedCutscene = RuntimeLib.async(function(p75, p76, p77, p78) -- line: 654
    -- upvalues: RuntimeLib (copy), Players (copy), events (copy)
    local UserId = Players.LocalPlayer.UserId

    if table.find(p77, UserId) ~= nil then
        if p75._active ~= nil then
            warn((("[GiantRigCutscene] Ignoring session %*; session %* is already active"):format(p76, p75._active.sessionId)))
        else
            local _prepared = p75._prepared
            local _prepared2, v64

            if _prepared ~= nil then
                if _prepared.sessionId == p76 and p75:_sameUserIds(_prepared.participantUserIds, p77) then
                    _prepared2 = _prepared
                    v64 = true
                else
                    v64 = false
                end
            else
                v64 = false
            end

            if not v64 then
                p75:_beginPreparation(p76, p77)
                _prepared2 = p75._prepared
            end

            if _prepared2 ~= nil then
                local v65 = RuntimeLib.await(_prepared2.ready)

                if v65 ~= nil and not _prepared2.cancelled and p75._prepared == _prepared2 then
                    p75._prepared = nil

                    if not RuntimeLib.await(p75:_activateCutscene(v65, p76, p78, #p77)) then
                        v65:Destroy()
                        events.giantRigCutsceneFinished:fire(p76)
                    end

                    return
                end
            end
        end

        events.giantRigCutsceneFinished:fire(p76)
    end

    return nil
end)
self._activateCutscene = RuntimeLib.async(function(p79, p80, p81, p82, p83) -- line: 686
    -- upvalues: Maid (copy), Workspace (copy), giantRigCutsceneConfig (copy), t1 (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil then
        warn("[GiantRigCutscene] Workspace.CurrentCamera is missing")

        return false
    end

    p80.Parent = Workspace
    p79:_showBambooRodVisuals(p80)

    local v66 = p79:_hideWorldCharacters()
    local v67 = p79:_hideIdleDisplay()
    local v68 = p79._characterController:acquireMovementLock()
    local v69 = p79._soundController:pauseBackgroundMusic()
    local v70 = Maid.new()
    local v71 = p79:_captureParticipantRigVisibility(p80, p83)
    local t23 = {
        animationStarted = false,
        cutsceneMusic = nil,
        endingFadeFrame = nil,
        endingFadeGui = nil,
        endingFadeStarted = false,
        endingTrack = nil,
        masterTrack = nil,
        participantRigsVisible = true,
        flySlowdownApplied = false,
        backgroundMusicWasPlaying = v69,
        cameraPlayback = p79:_readCameraPlayback(p80),
        cameraSnapshot = {
            cameraSubject = CurrentCamera.CameraSubject,
            cameraType = CurrentCamera.CameraType,
            cframe = CurrentCamera.CFrame,
            fieldOfView = CurrentCamera.FieldOfView
        },
        characterParents = v66,
        clone = p80,
        idleDisplaySnapshot = v67,
        maid = v70,
        objectPlayback = p79:_readObjectPlayback(p80),
        participantRigVisibility = v71,
        releaseMovementLock = v68,
        sessionId = p81,
        sounds = {},
        startedAt = p82,
        tracks = {}
    }

    p79._active = t23

    local v72 = p79:_createEndingFadeOverlay()

    t23.endingFadeGui = if v72 == nil then v72 else v72.gui
    t23.endingFadeFrame = if v72 ~= nil then v72.frame else v72
    CurrentCamera.CameraType = Enum.CameraType.Scriptable
    p79:_updateCamera(t23.cameraPlayback, 0)
    p79:_setParticipantRigsVisible(t23.participantRigVisibility, true)

    local v73 = p79:_setupContinuousVfx(p80)
    local v74 = p79:_resolveRodAttachmentWelds(p80)

    p79:_setRodAttachment(v74, "back")

    local t24 = {}
    local t25 = {}
    local v75 = #t25
    local v76 = #t1

    table.move(t1, 1, v76, v75 + 1, t25)
    t25[v75 + v76 + 1] = "GiantRigR15"

    local v77, v78

    for _, v79 in t25 do
        local v80 = p80:FindFirstChild(v79, true)

        if v80 ~= nil then
            local v81 = p79:_loadRigTrack(p80, v80)

            if v81 ~= nil then
                table.insert(t24, v81)
                v70:GiveTask(function() -- line: 768
                    -- upvalues: v81 (copy)
                    v81:Stop(0)
                    v81:Destroy()
                end)

                if v79 == "PlayerRig1R15" then
                    v77 = v81
                elseif v79 == "GiantRigR15" then
                    v78 = v81
                end
            end
        else
            warn((("[GiantRigCutscene] %* is missing from the runtime clone"):format(v79)))
        end
    end

    if #t24 == 0 then
        warn("[GiantRigCutscene] No rig animations were configured; add CutsceneAnimation Animation instances or animation-id attributes")
        p79:_finishActiveCutscene(p81, false)

        return false
    end

    if v77 ~= nil then
        p79:_listenToPlayerRigEvents(v77, p80, v73, p81, v70)
    else
        warn("[GiantRigCutscene] PlayerRig1R15 has no animation; VFX markers and the preferred SFX clock are unavailable")
    end

    if v78 ~= nil then
        p79:_listenToGiantRigEvents(v78, p80, v74, p81, v70)
    else
        warn("[GiantRigCutscene] GiantRigR15 has no animation; BambooRod marker events are unavailable")
    end

    t23.masterTrack = v77 or v78 or t24[1]
    t23.tracks = t24
    t23.sounds = p79:_setupSounds(v70)
    t23.cutsceneMusic = p79:_setupCutsceneMusic(v70)

    local v82 = v77 or t24[1]

    if v77 == nil then
        for _, v84 in t24 do
            if v84.Length > v82.Length then
                v82 = v84
            end
        end
    end

    t23.endingTrack = v82
    v70:GiveTask(v82.Ended:Once(function() -- line: 806
        -- upvalues: p79 (copy), p81 (copy)
        p79:_finishActiveCutscene(p81)
    end))

    local v85 = p82 - Workspace:GetServerTimeNow()

    if v85 > 0 then
        task.wait(v85)
    end

    if p79._active ~= t23 then
        return false
    end

    p79:_setBambooRodAnchored(p80, false)

    local v87 = math.max(0, Workspace:GetServerTimeNow() - p82)
    local v88 = v87 + giantRigCutsceneConfig.cutsceneStartFrame / giantRigCutsceneConfig.authoredFramesPerSecond

    for _, v89 in t24 do
        v89:Play(0)
        v89.TimePosition = v88
    end

    if t23.cutsceneMusic ~= nil then
        t23.cutsceneMusic.TimePosition = v88
        t23.cutsceneMusic:Play()
    end

    if v87 > 0.1 then
        warn((("[GiantRigCutscene] Playback began %*s late"):format(v87)))
    end

    t23.animationStarted = true
    t23.startedAt = Workspace:GetServerTimeNow() - v88

    local n2 = 0

    for _, v90 in t24 do
        n2 = math.max(n2, v90.Length)
    end

    local v91 = if n2 > 0 then n2 + 3 else giantRigCutsceneConfig.sessionTimeoutSeconds

    v70:GiveTask(task.delay(v91, function() -- line: 838
        -- upvalues: p79 (copy), p81 (copy)
        warn((("[GiantRigCutscene] Session %* reached its client timeout"):format(p81)))
        p79:_finishActiveCutscene(p81)
    end))

    return true
end)

function self._finishActiveCutscene(p84, p85, p86) -- line: 844
    -- upvalues: Players (copy), RunService (copy), Workspace (copy)
    local v92 = p86 == nil or p86
    local _active = p84._active
    local v93 = true

    if _active ~= nil then
        if _active.sessionId == p85 then
            p84._active = nil

            if v92 and _active.endingFadeFrame ~= nil then
                _active.endingFadeFrame.BackgroundTransparency = 0
            end

            v93 = false
        end
    end

    if v93 then
        if v92 then
            p84:_showTeleportLoadingScreenAndNotifyServer(p85)
        end

        return nil
    end

    _active.maid:Destroy()
    _active.clone:Destroy()
    p84:_restoreIdleDisplay(_active.idleDisplaySnapshot)
    p84:_restoreWorldCharacters(_active.characterParents, not v92)
    _active.releaseMovementLock()

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera ~= nil then
        CurrentCamera.CameraType = _active.cameraSnapshot.cameraType
        CurrentCamera.CFrame = _active.cameraSnapshot.cframe
        CurrentCamera.FieldOfView = _active.cameraSnapshot.fieldOfView

        local cameraSubject = _active.cameraSnapshot.cameraSubject

        if cameraSubject == nil or cameraSubject.Parent == nil then
            local Character = Players.LocalPlayer.Character

            if Character ~= nil then
                Character = Character:FindFirstChildOfClass("Humanoid")
            end

            if Character ~= nil then
                CurrentCamera.CameraSubject = Character
            end
        else
            CurrentCamera.CameraSubject = cameraSubject
        end
    end

    if _active.backgroundMusicWasPlaying then
        p84._soundController:resumeBackgroundMusic()
    end

    if v92 then
        p84:_showTeleportLoadingScreenAndNotifyServer(p85)

        local endingFadeGui = _active.endingFadeGui

        if endingFadeGui ~= nil then
            task.defer(function() -- line: 893
                -- upvalues: endingFadeGui (copy), RunService (copy)
                RunService.RenderStepped:Wait()
                endingFadeGui:Destroy()
            end)
        end
    else
        local endingFadeGui = _active.endingFadeGui

        if endingFadeGui ~= nil then
            endingFadeGui:Destroy()
        end
    end

    p84:_primeSceneCache(1)
end

function self._createEndingFadeOverlay(_) -- line: 906
    -- upvalues: Players (copy)
    local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

    if PlayerGui == nil then
        return nil
    end

    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.DisplayOrder = 10000
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Name = "GiantRigCutsceneEndFade"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ScreenInsets = Enum.ScreenInsets.None
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    local Frame = Instance.new("Frame")

    Frame.BackgroundColor3 = Color3.new(0, 0, 0)
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.ZIndex = 1
    Frame.Parent = ScreenGui
    ScreenGui.Parent = PlayerGui

    return {
        frame = Frame,
        gui = ScreenGui
    }
end

function self._updateEndingFade(_, p89) -- line: 931
    -- upvalues: TweenService (copy), giantRigCutsceneConfig (copy)
    if p89.endingFadeStarted then
        return nil
    end

    local endingFadeFrame, endingTrack = p89.endingFadeFrame, p89.endingTrack

    if endingFadeFrame ~= nil and endingTrack ~= nil and not (endingTrack.Length <= 0) then
        local v95 = math.max(0, endingTrack.Length - endingTrack.TimePosition)
        local v96 = giantRigCutsceneConfig.cutsceneEndFadeLeadFrames / giantRigCutsceneConfig.authoredFramesPerSecond

        if v96 < v95 then
            return nil
        end

        p89.endingFadeStarted = true

        local v98 = math.max(math.abs(endingTrack.Speed), 0.01)
        local v99 = TweenService:Create(endingFadeFrame, TweenInfo.new(v96 / v98, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0
        })

        p89.maid:GiveTask(v99)
        v99:Play()

        return
    end

    return nil
end

function self._showTeleportLoadingScreenAndNotifyServer(p90, p91) -- line: 953
    -- upvalues: events (copy), clientProducer (copy), giantRigCutsceneConfig (copy)
    p90._teleportLoadingSessionId = p91
    clientProducer.windowOpened({
        currentWindow = "eventLoadingScreen"
    })
    task.delay(giantRigCutsceneConfig.teleportLoadingLeadSeconds, function() -- line: 958
        -- upvalues: p90 (copy), p91 (copy), events (copy)
        if p90._teleportLoadingSessionId ~= p91 then
            return nil
        end

        events.giantRigCutsceneFinished:fire(p91)
    end)
end

function self._hideWorldCharacters(_) -- line: 965
    -- upvalues: Players (copy)
    local t26 = {}

    for _, player in Players:GetPlayers() do
        local Character = player.Character

        if Character ~= nil then
            table.insert(t26, {
                character = Character,
                parent = Character.Parent,
                player = player
            })
            Character.Parent = nil
        end
    end

    return t26
end

function self._hideIdleDisplay(_) -- line: 982
    -- upvalues: Players (copy), StarterGui (copy), Workspace (copy), giantRigCutsceneConfig (copy)
    local t28 = {}
    local t29 = {}
    local t30 = {}
    local t31 = {}
    local t32 = {}
    local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

    if PlayerGui ~= nil then
        local t33 = {
            PlayerGui
        }
        local v100 = #t33
        local Descendants = PlayerGui:GetDescendants()

        table.move(Descendants, 1, #Descendants, v100 + 1, t33)

        for _, v101 in t33 do
            if v101:IsA("ScreenGui") then
                t31[v101] = v101.Enabled
                v101.Enabled = false
            end
        end
    end

    for _, v102 in Enum.CoreGuiType:GetEnumItems() do
        if v102 ~= Enum.CoreGuiType.All then
            local function v103() -- line: 1007
                -- upvalues: v102 (copy), StarterGui (copy)
                return StarterGui:GetCoreGuiEnabled(v102)
            end

            local ok, result = pcall(v103)

            if ok and type(result) == "boolean" then
                t32[v102] = result

                local function v104() -- line: 1014
                    -- upvalues: v102 (copy), StarterGui (copy)
                    return StarterGui:SetCoreGuiEnabled(v102, false)
                end

                pcall(v104)
            end
        end
    end

    local v105 = Workspace:FindFirstChild(giantRigCutsceneConfig.sourceName)

    if v105 ~= nil then
        local v106 = v105:FindFirstChild("PlayerStartPlate", true)

        if v106 ~= nil then
            local t34 = {
                v106
            }
            local v107 = #t34
            local Descendants = v106:GetDescendants()

            table.move(Descendants, 1, #Descendants, v107 + 1, t34)

            for _, v108 in t34 do
                if v108:IsA("BasePart") then
                    t28[v108] = v108.LocalTransparencyModifier
                    v108.LocalTransparencyModifier = 1
                elseif v108:IsA("BillboardGui") or v108:IsA("SurfaceGui") then
                    t29[v108] = v108.Enabled
                    v108.Enabled = false
                end
            end
        end

        for _, v109 in { "GiantRigR15", "BambooRod" } do
            local v110 = v105:FindFirstChild(v109, true)

            if v110 ~= nil then
                t30[v110] = v110.Parent
                v110.Parent = nil
            end
        end
    end

    return {
        coreGuis = t32,
        guis = t29,
        localTransparencies = t28,
        parents = t30,
        screenGuis = t31
    }
end

function self._restoreIdleDisplay(_, p95) -- line: 1063
    -- upvalues: StarterGui (copy)
    for v111, v112 in p95.localTransparencies do
        if v111.Parent ~= nil then
            v111.LocalTransparencyModifier = v112
        end
    end

    for v113, v114 in p95.guis do
        if v113.Parent ~= nil then
            v113.Enabled = v114
        end
    end

    for v115, v116 in p95.screenGuis do
        if v115.Parent ~= nil then
            v115.Enabled = v116
        end
    end

    for v117, v118 in p95.coreGuis do
        local function v119() -- line: 1080
            -- upvalues: v117 (copy), v118 (copy), StarterGui (copy)
            return StarterGui:SetCoreGuiEnabled(v117, v118)
        end

        pcall(v119)
    end

    for v120, v121 in p95.parents do
        if v120.Parent == nil then
            v120.Parent = v121
        end
    end
end

function self._restoreWorldCharacters(_, p97, p98) -- line: 1090
    -- upvalues: Players (copy)
    local v122 = p98 == nil or p98

    for _, v123 in p97 do
        if (v122 or v123.player ~= Players.LocalPlayer) and v123.player.Character == v123.character and v123.character.Parent == nil and v123.parent ~= nil then
            v123.character.Parent = v123.parent
        end
    end
end

function self._showBambooRodVisuals(_, p100) -- line: 1106
    local v124 = p100:FindFirstChild("BambooRod", true)

    if v124 ~= nil then
        v124 = v124:FindFirstChild("RodModel", true)
    end

    if v124 == nil then
        return nil
    end

    local t35 = {
        v124
    }
    local v125 = #t35
    local Descendants = v124:GetDescendants()

    table.move(Descendants, 1, #Descendants, v125 + 1, t35)

    for _, v126 in t35 do
        if v126:IsA("BasePart") then
            v126.Transparency = 0
            v126.LocalTransparencyModifier = 0
        end
    end
end

function self._captureContinuousVfx(_, p102) -- line: 1127
    local t36 = {}
    local t37 = {
        p102
    }
    local v127 = #t37
    local Descendants = p102:GetDescendants()

    table.move(Descendants, 1, #Descendants, v127 + 1, t37)

    for _, v128 in t37 do
        if v128:IsA("BasePart") or v128:IsA("Decal") or v128:IsA("Texture") then
            t36[v128] = v128.Transparency
        end
    end

    return {
        root = p102,
        transparencies = t36
    }
end

function self._connectAnimationEvents(_, p104, p105, p106, p107) -- line: 1144
    local t38 = {}

    local function v129(p108) -- line: 1146
        -- upvalues: p104 (copy), p105 (copy), p106 (copy), t38 (copy)
        if p105[p108] == nil then
            return nil
        end

        local TimePosition = p104.TimePosition
        local v130 = t38[p108]
        local v131 = v130 == nil
        local v132 = if not v131 then math.abs(TimePosition - v130) < 0.05 else nil

        if not v131 and v132 then
            return nil
        end

        t38[p108] = TimePosition
        p106(p108)
    end

    for v134 in p105 do
        p107:GiveTask(p104:GetMarkerReachedSignal(v134):Connect(function() -- line: 1163
            -- upvalues: v129 (copy), v134 (copy)
            return v129(v134)
        end))
    end

    p107:GiveTask(p104.KeyframeReached:Connect(v129))
end

function self._createRuntimeAnimation(p109, p110, p111) -- line: 1169
    local v135 = p109:_normalizeAnimationId(p111)

    if v135 == nil then
        return nil
    end

    local Animation = Instance.new("Animation")

    Animation.Name = "RuntimeCutsceneAnimation"
    Animation.AnimationId = v135
    Animation.Parent = p110

    return Animation
end

function self._findVfxTarget(_, p113, p114) -- line: 1180
    local v136 = p113:FindFirstChild("VFX", true)
    local v137 = if v136 == nil then v136 else v136:FindFirstChild(p114)

    if v137 ~= nil then
        return v137
    end

    local v138 = if v136 == nil then v136 else v136:FindFirstChild(p114, true)

    if v138 == nil then
        return (p113:FindFirstChild(p114, true))
    end

    return v138
end

function self._findObjectTrackTarget(p115, p116, p117) -- line: 1199
    if p117 ~= "BambooRodBeam" then
        return (p115:_findVfxTarget(p116, p117))
    end

    local v139 = p116:FindFirstChild("BambooRod", true)

    if v139 ~= nil then
        v139 = v139:FindFirstChild("Beam", true)
    end

    return v139
end

function self._getObjectTrackValue(_, p119) -- line: 1210
    return if (if p119 == nil then p119 else p119:IsA("CFrameValue")) or (if p119 == nil then p119 else p119:IsA("Color3Value")) or (if p119 == nil then p119 else p119:IsA("NumberValue")) or (if p119 == nil then p119 else p119:IsA("Vector3Value")) or (if p119 == nil then p119 else p119:IsA("BoolValue")) then p119.Value else nil
end

function self._readObjectPlayback(p120, p121) -- line: 1248
    local ObjectTracks = p121:FindFirstChild("ObjectTracks")

    if ObjectTracks == nil then
        return nil
    end

    local ReferenceCFrame = ObjectTracks:GetAttribute("ReferenceCFrame")
    local v140 = p121:FindFirstChild("CameraPart", true)
    local v141 = if typeof(ReferenceCFrame) == "CFrame" and v140 ~= nil and v140:IsA("BasePart") then v140.CFrame * ReferenceCFrame:Inverse() else CFrame.identity
    local FPS = ObjectTracks:GetAttribute("FPS")

    if type(FPS) ~= "number" or not (FPS > 0) then
        FPS = 60
    end

    local t39 = {}

    for _, child in ObjectTracks:GetChildren() do
        local v142 = p120:_findObjectTrackTarget(p121, child.Name)

        if v142 ~= nil then
            for _, child in child:GetChildren() do
                local Keyframes = child:FindFirstChild("Keyframes")

                if Keyframes ~= nil then
                    local t40 = {}
                    local v143 = Keyframes:FindFirstChild("0") ~= nil
                    local v144 = p120:_getObjectTrackValue(child:FindFirstChild("Default"))

                    if not v143 and v144 ~= nil then
                        table.insert(t40, {
                            easingDirection = "In",
                            easingStyle = "Constant",
                            frame = 0,
                            value = v144
                        })
                    end

                    for _, child in Keyframes:GetChildren() do
                        local v145 = tonumber(child.Name)
                        local v146 = p120:_getObjectTrackValue(child:FindFirstChild("Value"))

                        if v145 ~= nil and v146 ~= nil then
                            local EasingDirection = child:GetAttribute("EasingDirection")

                            if EasingDirection == nil then
                                EasingDirection = "In"
                            end

                            local t42 = {}

                            t42.easingDirection = EasingDirection

                            local EasingStyle = child:GetAttribute("EasingStyle")

                            t42.easingStyle = if EasingStyle == nil then "Linear" else EasingStyle
                            t42.frame = v145
                            t42.value = v146
                            table.insert(t40, t42)
                        end
                    end

                    table.sort(t40, function(p122, p123) -- line: 1312
                        return p122.frame < p123.frame
                    end)

                    if #t40 > 0 then
                        local ActiveStartFrame = child:GetAttribute("ActiveStartFrame")

                        if type(ActiveStartFrame) ~= "number" then
                            ActiveStartFrame = nil
                        end

                        table.insert(t39, {
                            activeStartFrame = ActiveStartFrame,
                            keyframes = t40,
                            propertyName = child.Name,
                            releaseAfterLastFrame = child:GetAttribute("ReleaseAfterLastFrame") == true,
                            target = v142
                        })
                    end
                end
            end
        end
    end

    return {
        fps = FPS,
        properties = t39,
        referenceTransform = v141
    }
end

function self._easeObjectTrackAlpha(_, p125, p126, p127) -- line: 1334
    -- upvalues: TweenService (copy)
    if p126 == "Constant" then
        return 0
    end

    local v147

    for v148, v149 in (Enum.EasingStyle:GetEnumItems()) do
        local _ = v148 - 1

        if v149.Name == p126 == true then
            v147 = v149
            break
        end

        v147 = nil
    end

    if v147 == nil then
        v147 = Enum.EasingStyle.Linear
    end

    local v150

    for v151, v152 in (Enum.EasingDirection:GetEnumItems()) do
        local _ = v151 - 1

        if v152.Name == p127 == true then
            v150 = v152
            break
        end

        v150 = nil
    end

    if v150 == nil then
        v150 = Enum.EasingDirection.In
    end

    return TweenService:GetValue(p125, v147, v150)
end

function self._interpolateObjectTrackValue(_, p129, p130, p131) -- line: 1376
    if type(p129) == "number" and type(p130) == "number" then
        return p129 + (p130 - p129) * p131
    end

    if (type(p129) ~= "boolean" or type(p130) ~= "boolean") and (typeof(p129) == "CFrame" and typeof(p130) == "CFrame" or typeof(p129) == "Color3" and typeof(p130) == "Color3" or typeof(p129) == "Vector3" and typeof(p130) == "Vector3") then
        return p129:Lerp(p130, p131)
    end

    return p129
end

function self._updateObjectPlayback(p132, p133, p134) -- line: 1424
    if p133 == nil then
        return nil
    end

    local v153 = p134 * p133.fps

    for _, v154 in p133.properties do
        if v154.activeStartFrame == nil or not (v153 < v154.activeStartFrame) then
            local v155 = v154.keyframes[#v154.keyframes]

            if not v154.releaseAfterLastFrame or not (v155.frame < v153) then
                local v165 = v154.keyframes[1]
                local v166 = #v154.keyframes - 1
                local v167 = v165

                for j = 1, v166 do
                    v165 = v154.keyframes[j + 1]

                    if v153 < v165.frame then
                        break
                    end

                    v167 = v165
                end

                local v168 = v165.frame - v167.frame
                local v171 = p132:_easeObjectTrackAlpha(if v168 > 0 then math.clamp((v153 - v167.frame) / v168, 0, 1) else 0, v167.easingStyle, v167.easingDirection)
                local v172 = p132:_interpolateObjectTrackValue(v167.value, v165.value, v171)

                if v154.propertyName == "CFrame" and typeof(v172) == "CFrame" then
                    local v173 = p133.referenceTransform * v172

                    if v154.target:IsA("BasePart") then
                        v154.target.CFrame = v173
                    elseif v154.target:IsA("Model") then
                        v154.target:PivotTo(v173)
                    end
                elseif v154.propertyName == "Color" and typeof(v172) == "Color3" and v154.target:IsA("BasePart") then
                    v154.target.Color = v172
                elseif v154.propertyName == "Size" and typeof(v172) == "Vector3" and v154.target:IsA("BasePart") then
                    v154.target.Size = v172
                elseif v154.propertyName == "Transparency" and type(v172) == "number" and v154.target:IsA("BasePart") then
                    v154.target.Transparency = v172
                elseif v154.propertyName == "Enabled" and type(v172) == "boolean" and p132:_isToggleableEffect(v154.target) then
                    v154.target.Enabled = v172
                end
            end
        end
    end
end

function self._findAnimator(_, p136) -- line: 1470
    local v174 = p136:FindFirstChildWhichIsA("Animator", true)

    if v174 ~= nil then
        return v174
    end

    local v175 = p136:FindFirstChildWhichIsA("Humanoid", true)

    if v175 == nil then
        local v176 = p136:FindFirstChildWhichIsA("AnimationController", true)

        if v176 == nil then
            return nil
        end

        local Animator = Instance.new("Animator")

        Animator.Parent = v176

        return Animator
    end

    local Animator = Instance.new("Animator")

    Animator.Parent = v175

    return Animator
end

function self._findNamedRodWeld(_, p138, p139) -- line: 1489
    local v177 = p138:FindFirstChild("BambooRod", true)
    local Attribute = p138:GetAttribute(p139)
    local v178 = if Attribute ~= nil then Attribute elseif v177 == nil then v177 else v177:GetAttribute(p139)

    if type(v178) ~= "string" then
        return nil
    end

    local v179 = p138:FindFirstChild(v178, true)

    return if v179 ~= nil and v179:IsA("WeldConstraint") then v179 else nil
end

function self._isDescendantOrSelf(_, p141, p142) -- line: 1506
    if p141 == p142 then
        return true
    end

    return (p141:IsDescendantOf(p142))
end

function self._listenToGiantRigEvents(p143, p144, p145, p146, p147, p148) -- line: 1509
    -- upvalues: RunService (copy), giantRigCutsceneConfig (copy), t4 (copy)
    local v180 = p145:FindFirstChild("GiantRigR15", true)
    local v181

    if v180 ~= nil then
        local Descendants = v180:GetDescendants()

        local function v182(p149) -- line: 1515
            local v183 = p149:IsA("Motor6D") and p149.Name == "Root"

            if not v183 then
                return v183
            end

            local Part1 = p149.Part1

            if Part1 ~= nil then
                Part1 = Part1.Name
            end

            return Part1 == "LowerTorso"
        end

        for v184, v185 in Descendants do
            local _ = v184 - 1
            local v186 = v185:IsA("Motor6D") and v185.Name == "Root"

            if v186 then
                local Part1 = v185.Part1

                if Part1 ~= nil then
                    Part1 = Part1.Name
                end

                v186 = Part1 == "LowerTorso"
            end

            if v186 == true then
                v181 = v185
                break
            end

            v181 = nil
        end
    else
        v181 = v180
    end

    local v187 = if v180 == nil then v180 else v180:FindFirstChild("HumanoidRootPart")
    local v188 = if v180 == nil then v180 else v180:FindFirstChild("LeftFoot")

    if v180 ~= nil then
        v180 = v180:FindFirstChild("RightFoot")
    end

    local v189 = if v181 == nil then v181 else v181.Transform
    local v190

    if v181 ~= nil then
        local PreSimulation = RunService.PreSimulation
        local v191 = v181

        p148:GiveTask(PreSimulation:Connect(function() -- line: 1559
            -- upvalues: p144 (copy), v189 (ref), v190 (ref), v191 (copy), giantRigCutsceneConfig (copy)
            if p144.TimePosition * giantRigCutsceneConfig.authoredFramesPerSecond < giantRigCutsceneConfig.giantPositionLockFrame then
                v189 = v191.Transform

                return nil
            end

            if v190 == nil then
                local v192 = v189

                if v192 ~= nil then
                    v192 += Vector3.new(0, giantRigCutsceneConfig.giantPositionYOffset, 0)
                end

                v190 = v192
            end

            if v190 ~= nil then
                v191.Transform = v190
            end
        end))
    end

    if v187 ~= nil and v187:IsA("BasePart") and v188 ~= nil and v188:IsA("BasePart") and v180 ~= nil and v180:IsA("BasePart") then
        local v193
        local n3 = 0
        local RenderStepped = RunService.RenderStepped
        local v194 = v180

        p148:GiveTask(RenderStepped:Connect(function() -- line: 1584
            -- upvalues: p143 (copy), p144 (copy), v187 (copy), v188 (copy), v193 (ref), n3 (ref), v194 (copy), giantRigCutsceneConfig (copy)
            local v195 = p144.TimePosition * giantRigCutsceneConfig.authoredFramesPerSecond
            local v197 = math.min(p143:_getPartBottomY(v188), p143:_getPartBottomY(v194))

            if v195 <= giantRigCutsceneConfig.giantGroundReferenceEndFrame then
                v193 = v197
                n3 = 0

                return nil
            end

            if v195 < giantRigCutsceneConfig.giantPositionLockFrame or v193 == nil then
                return nil
            end

            local v198 = v197 - n3
            local v200 = math.max(0, v193 - v198)
            local v201 = v200 - n3

            if math.abs(v201) > 0.001 then
                v187.CFrame = v187.CFrame + Vector3.new(0, v201, 0)
            end

            n3 = v200
        end))
    end

    local t44 = {}
    local t45 = {
        "AttachRodToBack",
        "DetachRod",
        "AttachRodToLeftHand"
    }
    local v203 = #t45

    for v204 in t4 do
        v203 += 1
        t45[v203] = v204
    end

    for _, v205 in t45 do
        t44[v205] = true
    end

    p143:_connectAnimationEvents(p144, t44, function(p150) -- line: 1620
        -- upvalues: p143 (copy), p146 (copy), p147 (copy), t4 (copy)
        if t4[p150] ~= nil then
            p143:_finishActiveCutscene(p147)

            return nil
        end

        if p150 == "AttachRodToBack" then
            p143:_setRodAttachment(p146, "back")
        elseif p150 == "AttachRodToLeftHand" then
            p143:_setRodAttachment(p146, "leftHand")
        elseif p150 == "DetachRod" then
            p143:_setRodAttachment(p146, "detached")
        end
    end, p148)
end

function self._listenToPlayerRigEvents(p151, p152, p153, p154, p155, p156) -- line: 1635
    -- upvalues: emitVFX (copy), t2 (copy), t3 (copy), t4 (copy)
    local t46 = {}

    for v206 in t2 do
        t46[v206] = true
    end

    for v207 in t3 do
        t46[v207] = true
    end

    for v208 in t4 do
        t46[v208] = true
    end

    p151:_connectAnimationEvents(p152, t46, function(p157) -- line: 1646
        -- upvalues: p151 (copy), p153 (copy), p154 (copy), p155 (copy), emitVFX (copy), t2 (copy), t3 (copy), t4 (copy)
        if t4[p157] ~= nil then
            p151:_finishActiveCutscene(p155)

            return nil
        end

        local v209 = t2[p157]

        if v209 == nil then
            local v210 = t3[p157]

            if v210 == nil then
                return nil
            end

            local v211 = p154[v210.targetName]

            if v211 ~= nil then
                p151:_setContinuousVfxEnabled(v211, v210.enabled)
            else
                warn((("[GiantRigCutscene] Continuous VFX target %* is missing for %*"):format(v210.targetName, p157)))
            end

            return
        end

        local v212 = p151:_findVfxTarget(p153, v209)

        if v212 ~= nil then
            emitVFX(v212)
        else
            warn((("[GiantRigCutscene] VFX target %* is missing for %*"):format(v209, p157)))
        end

        return nil
    end, p156)
end

function self._getPartBottomY(_, p159) -- line: 1678
    local v213 = p159.Size / 2
    local CFrame = p159.CFrame
    local v216 = math.abs(CFrame.XVector.Y) * v213.X + math.abs(CFrame.YVector.Y) * v213.Y + math.abs(CFrame.ZVector.Y) * v213.Z

    return CFrame.Position.Y - v216
end

function self._loadRigTrack(p160, p161, p162) -- line: 1684
    local v217 = p160:_findAnimator(p162)

    if v217 ~= nil then
        local v218 = p160:_resolveCutsceneAnimation(p161, p162)

        if v218 ~= nil then
            local function v219() -- line: 1695
                -- upvalues: v217 (copy), v218 (copy)
                return v217:LoadAnimation(v218)
            end

            local ok, result = pcall(v219)

            if ok then
                result.Looped = false
                result.Priority = Enum.AnimationPriority.Action4

                return result
            end

            warn(("[GiantRigCutscene] Failed to load %* animation:"):format(p162.Name), result)
        else
            warn((("[GiantRigCutscene] %* has no configured cutscene Animation"):format(p162.Name)))
        end
    else
        warn((("[GiantRigCutscene] %* has no Animator, Humanoid, or AnimationController"):format(p162.Name)))
    end

    return nil
end

function self._normalizeAnimationId(_, p164) -- line: 1707
    if type(p164) ~= "number" then
        if type(p164) ~= "string" or p164 == "" then
            return nil
        end

        if string.match(p164, "^%d+$") == nil then
            return p164
        end
    end

    return (("rbxassetid://%*"):format(p164))
end

function self._resolveCutsceneAnimation(p165, p166, p167) -- line: 1725
    local RuntimeCutsceneAnimation = p167:FindFirstChild("RuntimeCutsceneAnimation")

    if RuntimeCutsceneAnimation ~= nil and RuntimeCutsceneAnimation:IsA("Animation") then
        return RuntimeCutsceneAnimation
    end

    local v220 = p166:FindFirstChild("Animations", true)

    if v220 ~= nil then
        v220 = v220:FindFirstChild(p167.Name, true)
    end

    if v220 ~= nil then
        if v220:IsA("Animation") then
            return v220
        end

        if v220:IsA("StringValue") then
            return p165:_createRuntimeAnimation(p167, v220.Value)
        end
    end

    local CutsceneAnimationId = p167:GetAttribute("CutsceneAnimationId")
    local Attribute = p166:GetAttribute((("%*AnimationId"):format(p167.Name)))

    if CutsceneAnimationId ~= nil then
        Attribute = CutsceneAnimationId
    end

    local v221 = p165:_normalizeAnimationId(Attribute)

    if v221 ~= nil then
        return p165:_createRuntimeAnimation(p167, v221)
    end

    local v222 = p167:FindFirstChild("CutsceneAnimation", true)

    if v222 ~= nil and v222:IsA("Animation") then
        return v222
    end

    local Descendants = p167:GetDescendants()
    local t47 = {}

    local function v223(p168) -- line: 1762
        return p168:IsA("Animation")
    end

    local n4 = 0

    for v224, v225 in Descendants do
        local _ = v224 - 1

        if v225:IsA("Animation") == true then
            n4 += 1
            t47[n4] = v225
        end
    end

    return if #t47 == 1 then t47[1] else nil
end

function self._resolveRodAttachmentWelds(p169, p170) -- line: 1776
    local v226 = p170:FindFirstChild("BambooRod", true)
    local v227 = p170:FindFirstChild("GiantRigR15", true)
    local RodBackWeldName = p169:_findNamedRodWeld(p170, "RodBackWeldName")
    local RodLeftHandWeldName = p169:_findNamedRodWeld(p170, "RodLeftHandWeldName")

    if v226 ~= nil and v227 ~= nil then
        local v228 = v226:FindFirstChild("Wrap", true)
        local v229 = v226:FindFirstChild("Handle", true)
        local v230 = v227:FindFirstChild("UpperTorso", true)
        local v231 = v227:FindFirstChild("LeftHand", true)
        local v232 = if RodBackWeldName ~= nil then RodBackWeldName
            elseif v228 == nil then RodBackWeldName
            elseif not v228:IsA("BasePart") then RodBackWeldName
            elseif v230 == nil then RodBackWeldName
            elseif v230:IsA("BasePart") then p169:_findOrCreateAttachmentWeld(v228, v230, "RodBackWeld")
            else RodBackWeldName

        if RodLeftHandWeldName == nil and v229 ~= nil and v229:IsA("BasePart") and v231 ~= nil and v231:IsA("BasePart") then
            RodLeftHandWeldName = p169:_findOrCreateAttachmentWeld(v229, v231, "RodLeftHandWeld")
        end

        for _, descendant in p170:GetDescendants() do
            if descendant:IsA("WeldConstraint") then
                local Part0, Part1 = descendant.Part0, descendant.Part1

                if Part0 ~= nil and Part1 ~= nil then
                    local v233 = p169:_isDescendantOrSelf(Part0, v226)
                    local v234 = p169:_isDescendantOrSelf(Part1, v226)
                    local v235 = p169:_isDescendantOrSelf(Part0, v227)
                    local v236 = p169:_isDescendantOrSelf(Part1, v227)

                    if v233 and v236 then
                        if not v235 then
                            Part0 = Part1
                        end

                        local v237 = string.lower((("%* %*"):format(descendant.Name, Part0.Name)))

                        if RodLeftHandWeldName ~= nil then
                            if v232 == nil and (string.match(v237, "back") ~= nil or Part0.Name == "UpperTorso" or Part0.Name == "LowerTorso" or Part0.Name == "Torso") then
                                v232 = descendant
                            end
                        elseif Part0.Name == "LeftHand" then
                            RodLeftHandWeldName = descendant
                        elseif string.match(v237, "left") ~= nil then
                            RodLeftHandWeldName = descendant
                        elseif v232 == nil and (string.match(v237, "back") ~= nil or Part0.Name == "UpperTorso" or Part0.Name == "LowerTorso" or Part0.Name == "Torso") then
                            v232 = descendant
                        end
                    elseif v234 and v235 then
                        local v238 = string.lower((("%* %*"):format(descendant.Name, Part0.Name)))

                        if RodLeftHandWeldName ~= nil then
                            if v232 == nil and (string.match(v238, "back") ~= nil or Part0.Name == "UpperTorso" or Part0.Name == "LowerTorso" or Part0.Name == "Torso") then
                                v232 = descendant
                            end
                        elseif Part0.Name == "LeftHand" then
                            RodLeftHandWeldName = descendant
                        elseif string.match(v238, "left") ~= nil then
                            RodLeftHandWeldName = descendant
                        elseif v232 == nil and (string.match(v238, "back") ~= nil or Part0.Name == "UpperTorso" or Part0.Name == "LowerTorso" or Part0.Name == "Torso") then
                            v232 = descendant
                        end
                    end
                end
            end
        end

        if v232 == nil then
            warn("[GiantRigCutscene] BambooRod back WeldConstraint was not found; name it with 'Back' or set RodBackWeldName")
        end

        if RodLeftHandWeldName == nil then
            warn("[GiantRigCutscene] BambooRod left-hand WeldConstraint was not found; connect it to LeftHand or set RodLeftHandWeldName")
        end

        return {
            back = v232,
            bambooRod = v226,
            leftHand = RodLeftHandWeldName
        }
    end

    warn("[GiantRigCutscene] BambooRod or GiantRigR15 is missing")

    return {
        back = RodBackWeldName,
        bambooRod = v226,
        leftHand = RodLeftHandWeldName
    }
end

function self._findOrCreateAttachmentWeld(_, p172, p173, p174) -- line: 1835
    local BambooRod = p172:FindFirstAncestor("BambooRod")

    if BambooRod ~= nil then
        BambooRod = BambooRod:GetDescendants()
    end

    if BambooRod == nil then
        BambooRod = {}
    end

    for _, v239 in BambooRod do
        if v239:IsA("WeldConstraint") and (v239.Part0 == p172 and v239.Part1 == p173 or v239.Part1 == p172 and v239.Part0 == p173) then
            return v239
        end
    end

    local WeldConstraint = Instance.new("WeldConstraint")

    WeldConstraint.Name = p174
    WeldConstraint.Enabled = false
    WeldConstraint.Part0 = p172
    WeldConstraint.Part1 = p173
    WeldConstraint.Parent = p172

    return WeldConstraint
end

function self._setContinuousVfxEnabled(p175, p176, p177) -- line: 1860
    local t48 = {
        p176.root
    }
    local v240 = #t48
    local Descendants = p176.root:GetDescendants()

    table.move(Descendants, 1, #Descendants, v240 + 1, t48)

    for _, v241 in t48 do
        if p175:_isToggleableEffect(v241) then
            v241.Enabled = p177
        end
    end

    for v242, v243 in p176.transparencies do
        if p177 then
            v242.Transparency = v243
        else
            v242.Transparency = 1
        end
    end
end

function self._setRodAttachment(p178, p179, p180) -- line: 1874
    if p180 == "detached" then
        p178:_setRodInstanceAnchored(p179.bambooRod, true)
    end

    if p179.back ~= nil then
        p179.back.Enabled = false
    end

    if p179.leftHand ~= nil then
        p179.leftHand.Enabled = false
    end

    if p179.bambooRod ~= nil then
        local t49 = {
            p179.bambooRod
        }
        local v244 = #t49
        local Descendants = p179.bambooRod:GetDescendants()

        table.move(Descendants, 1, #Descendants, v244 + 1, t49)

        for _, v245 in t49 do
            if v245:IsA("BasePart") then
                v245.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                v245.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
        end
    end

    if p180 == "back" then
        if p179.back ~= nil then
            p178:_enableWeldAtCurrentPose(p179.back)
        else
            warn("[GiantRigCutscene] AttachRodToBack fired without a back weld")
        end
    elseif p180 == "leftHand" then
        if p179.leftHand ~= nil then
            p178:_enableWeldAtCurrentPose(p179.leftHand)
        else
            warn("[GiantRigCutscene] AttachRodToLeftHand fired without a left-hand weld")
        end
    end

    if p180 ~= "detached" then
        p178:_setRodInstanceAnchored(p179.bambooRod, false)
    end
end

function self._enableWeldAtCurrentPose(_, p182) -- line: 1914
    local Part0, Part1 = p182.Part0, p182.Part1

    if Part0 == nil or Part1 == nil then
        warn((("[GiantRigCutscene] %* has a missing part reference"):format(p182.Name)))

        return nil
    end

    p182.Enabled = false
    p182.Part0 = nil
    p182.Part1 = nil
    p182.Part0 = Part0
    p182.Part1 = Part1
    p182.Enabled = true
end

function self._updateFlyPlaybackSpeed(_, p184, p185) -- line: 1931
    -- upvalues: giantRigCutsceneConfig (copy)
    if p184.flySlowdownApplied or p185 * giantRigCutsceneConfig.authoredFramesPerSecond < giantRigCutsceneConfig.flySlowdownStartFrame then
        return nil
    end

    p184.flySlowdownApplied = true

    for _, v246 in p184.tracks do
        if v246.IsPlaying then
            v246:AdjustSpeed(giantRigCutsceneConfig.flyPlaybackSpeed)
        end
    end
end

function self._setRodInstanceAnchored(_, p187, p188) -- line: 1946
    if p187 == nil then
        return nil
    end

    local PrimaryPart = if p187:IsA("BasePart") then p187 elseif p187:IsA("Model") then p187.PrimaryPart or p187:FindFirstChild("Handle") or p187:FindFirstChildWhichIsA("BasePart", true) else p187:FindFirstChildWhichIsA("BasePart", true)

    if PrimaryPart ~= nil and PrimaryPart:IsA("BasePart") then
        PrimaryPart.Anchored = p188
    end
end

function self._setupContinuousVfx(p189, p190) -- line: 1955
    -- upvalues: t3 (copy)
    local t50 = {}
    local t51 = {}

    for _, v247 in t3 do
        t51[v247.targetName] = true
    end

    for v248 in t51 do
        local v249 = p189:_findVfxTarget(p190, v248)

        if v249 ~= nil then
            local v250 = p189:_captureContinuousVfx(v249)

            t50[v248] = v250
            p189:_setContinuousVfxEnabled(v250, false)
        end
    end

    return t50
end

function self._getFrameNumber(_, p192) -- line: 1973
    local v251 = tonumber(p192.Name)

    if v251 ~= nil then
        return v251
    end

    local Parent = p192.Parent

    if Parent ~= nil then
        Parent = Parent.Name
    end

    return (tonumber(Parent))
end

function self._getNumberAttribute(_, p194, p195, p196) -- line: 1984
    local Attribute = p194:GetAttribute(p195)

    if type(Attribute) == "number" then
        return Attribute
    end

    return p196
end

function self._readCameraPlayback(p197, p198) -- line: 1988
    -- upvalues: ReplicatedStorage (copy), Workspace (copy), giantRigCutsceneConfig (copy)
    local v252 = p198:FindFirstChild("CameraPart", true)

    if v252 == nil or not v252:IsA("BasePart") then
        v252 = nil
    end

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera ~= nil then
        CurrentCamera = CurrentCamera:FindFirstChild(giantRigCutsceneConfig.sourceName)
    end

    local v253 = ReplicatedStorage:FindFirstChild(giantRigCutsceneConfig.sourceName)

    if v253 ~= nil then
        v253 = v253:FindFirstChild("Camera")
    end

    local Descendants = (CurrentCamera or v253 or p198):GetDescendants()

    local function v254(p199) -- line: 2004
        return p199:IsA("Folder") and p199.Name == "Frames"
    end

    local v255

    for v256, v257 in Descendants do
        local _ = v256 - 1

        if v254(v257) == true then
            v255 = v257
            break
        end

        v255 = nil
    end

    local Parent, v258

    if v255 ~= nil and v255:IsA("Folder") then
        Parent = v255.Parent
        v258 = if Parent ~= nil then Parent:FindFirstChild("FOV") else Parent

        if Parent ~= nil then
            Parent = Parent:FindFirstChild("Settings")
        end

        if Parent ~= nil then
            Parent = Parent:FindFirstChild("FPS")
        end

        local v259 = p197:_getNumberAttribute(p198, "CameraFPS", 60)

        if Parent ~= nil and Parent:IsA("NumberValue") then
            v259 = Parent.Value
        end

        local t52 = {}

        for _, descendant in v255:GetDescendants() do
            if descendant:IsA("CFrameValue") then
                local v260 = p197:_getFrameNumber(descendant)

                if v260 ~= nil then
                    table.insert(t52, {
                        cframe = descendant.Value,
                        frame = v260
                    })
                end
            end
        end

        table.sort(t52, function(p200, p201) -- line: 2059
            return p200.frame < p201.frame
        end)

        local t54 = {}

        if v258 ~= nil then
            for _, descendant in v258:GetDescendants() do
                if descendant:IsA("NumberValue") then
                    local v261 = p197:_getFrameNumber(descendant)

                    if v261 ~= nil then
                        table.insert(t54, {
                            fov = descendant.Value,
                            frame = v261
                        })
                    end
                end
            end
        end

        table.sort(t54, function(p202, p203) -- line: 2078
            return p202.frame < p203.frame
        end)

        if #t52 == 0 then
            warn("[GiantRigCutscene] Camera/Frames contains no CFrameValue keyframes")
        end

        return {
            fovKeyframes = t54,
            fps = v259,
            keyframes = t52,
            referencePart = v252
        }
    end

    warn("[GiantRigCutscene] Moon Animator Camera/Frames export is missing; using CameraPart without authored camera motion")

    return if v252 ~= nil then {
        fps = 60,
        fovKeyframes = {},
        keyframes = {},
        referencePart = v252
    } else nil
end

function self._sampleCameraCFrame(_, p205, p206) -- line: 2091
    if #p205 == 0 then
        return nil
    end

    if #p205 == 1 or p206 <= p205[1].frame then
        return p205[1].cframe
    end

    local v262 = p205[#p205]

    if not (v262.frame <= p206) then
        for i = 0, #p205 - 2 do
            local v263 = p205[i + 1]
            local v264 = p205[i + 2]

            if not (p206 < v263.frame or v264.frame < p206) then
                local v265 = v264.frame - v263.frame
                local v266 = if v265 > 0 then math.clamp((p206 - v263.frame) / v265, 0, 1) else 0

                return v263.cframe:Lerp(v264.cframe, v266)
            end
        end
    end

    return v262.cframe
end

function self._sampleFov(_, p208, p209) -- line: 2117
    if #p208 == 0 then
        return nil
    end

    if #p208 == 1 or p209 <= p208[1].frame then
        return p208[1].fov
    end

    local v268 = p208[#p208]

    if not (v268.frame <= p209) then
        for i = 0, #p208 - 2 do
            local v269 = p208[i + 1]
            local v270 = p208[i + 2]

            if not (p209 < v269.frame or v270.frame < p209) then
                local v271 = v270.frame - v269.frame
                local v272 = if v271 > 0 then math.clamp((p209 - v269.frame) / v271, 0, 1) else 0

                return v269.fov + (v270.fov - v269.fov) * v272
            end
        end
    end

    return v268.fov
end

function self._setupSounds(p210, p211) -- line: 2143
    -- upvalues: ReplicatedStorage (copy), SoundService (copy), giantRigCutsceneConfig (copy)
    local v274 = ReplicatedStorage:FindFirstChild(giantRigCutsceneConfig.soundFolderName)

    if v274 == nil then
        return {}
    end

    local t56 = {}

    for _, child in v274:GetChildren() do
        if child:IsA("StringValue") then
            local v275 = p210._soundController:getRegisteredSound(child.Value) or p210._soundController:registerSound(child.Value)
            local clone = v275:Clone()

            clone.Name = ("GiantRigCutscene_%*"):format(child.Name)
            clone.SoundGroup = v275.SoundGroup
            clone.Volume = p210:_getNumberAttribute(child, "Volume", 1)
            clone.Parent = SoundService
            p211:GiveTask(function() -- line: 2159
                -- upvalues: clone (copy)
                clone:Stop()
                clone:Destroy()
            end)
            table.insert(t56, {
                triggered = false,
                offset = p210:_getNumberAttribute(child, "Offset", 0),
                sound = clone,
                start = p210:_getNumberAttribute(child, "Start", 0),
                stopAt = p210:_getNumberAttribute(child, "End", 0)
            })
        end
    end

    return t56
end

function self._setupCutsceneMusic(_, p213) -- line: 2174
    -- upvalues: ReplicatedStorage (copy), SoundService (copy), giantRigCutsceneConfig (copy)
    local Sounds = ReplicatedStorage:FindFirstChild("Sounds")

    if Sounds ~= nil then
        Sounds = Sounds:FindFirstChild("music")
    end

    if Sounds ~= nil then
        Sounds = Sounds:FindFirstChild(giantRigCutsceneConfig.musicSoundName)
    end

    if Sounds == nil or not Sounds:IsA("Sound") then
        warn((("[GiantRigCutscene] ReplicatedStorage.Sounds.music.%* was not found"):format(giantRigCutsceneConfig.musicSoundName)))

        return nil
    end

    local clone = Sounds:Clone()

    clone.Name = "GiantRigCutscene_GrampsMusic"
    clone.Looped = true
    clone.Parent = SoundService
    p213:GiveTask(function() -- line: 2194
        -- upvalues: clone (copy)
        clone:Stop()
        clone:Destroy()
    end)

    return clone
end

function self._updateCamera(p214, p215, p216) -- line: 2200
    -- upvalues: Workspace (copy)
    if p215 == nil then
        return nil
    end

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil then
        return nil
    end

    CurrentCamera.CameraType = Enum.CameraType.Scriptable

    local v276 = p216 * p215.fps
    local v277 = p214:_sampleCameraCFrame(p215.keyframes, v276)

    if v277 ~= nil then
        if p215.referencePart ~= nil then
            CurrentCamera.CFrame = p215.referencePart.CFrame * v277
        else
            CurrentCamera.CFrame = v277
        end
    elseif p215.referencePart ~= nil then
        CurrentCamera.CFrame = p215.referencePart.CFrame
    end

    local v278 = p214:_sampleFov(p215.fovKeyframes, v276)

    if v278 ~= nil then
        CurrentCamera.FieldOfView = v278
    end
end

function self._updateSounds(_, p218, p219) -- line: 2221
    for _, v279 in p218.sounds do
        if not v279.triggered and not (p219 < v279.start) then
            v279.triggered = true

            local v281 = math.max(0, p219 - v279.start)
            local v283 = math.max(0, v279.offset + v281)

            if v279.stopAt > 0 then
                if not (v279.stopAt <= v283) then
                    v279.sound.TimePosition = v283
                    v279.sound:Play()

                    local v284 = v279.stopAt - v279.sound.TimePosition

                    if v279.stopAt > 0 and v284 > 0 then
                        p218.maid:GiveTask(task.delay(v284, function() -- line: 2236
                            -- upvalues: v279 (copy)
                            return v279.sound:Stop()
                        end))
                    end
                end
            else
                v279.sound.TimePosition = v283
                v279.sound:Play()

                local v285 = v279.stopAt - v279.sound.TimePosition

                if v279.stopAt > 0 and v285 > 0 then
                    p218.maid:GiveTask(task.delay(v285, function() -- line: 2236
                        -- upvalues: v279 (copy)
                        return v279.sound:Stop()
                    end))
                end
            end
        end
    end
end

function self._stripLocalAppearanceTags(_, p221) -- line: 2242
    -- upvalues: CollectionService (copy)
    for _, descendant in p221:GetDescendants() do
        if CollectionService:HasTag(descendant, "ApplyLocalCharacterAppearance") then
            CollectionService:RemoveTag(descendant, "ApplyLocalCharacterAppearance")
        end
    end
end

Reflect.defineMetadata(self, "identifier", "client/controllers/giant-rig-cutscene-controller@GiantRigCutsceneController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/character-controller@CharacterController", "client/controllers/sound-controller@SoundController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnRender", "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, { {} })

return {
    GiantRigCutsceneController = self
}
