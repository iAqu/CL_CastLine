-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, HttpService, Players, ReplicatedStorage = services.CollectionService, services.HttpService, services.Players, services.ReplicatedStorage
local Workspace = services.Workspace
local LocalCharacterVisibilityFilter = RuntimeLib.import(script, script.Parent.Parent, "local-character-visibility-filter").LocalCharacterVisibilityFilter
local events = RuntimeLib.import(script, script.Parent.Parent, "network").events
local vfx = RuntimeLib.import(script, script.Parent.Parent, "vfx")
local playClonedSound, playClonedVfxWithSound = vfx.playClonedSound, vfx.playClonedVfxWithSound
local v1 = RuntimeLib.import(script, script.Parent.Parent, "rgl-countdown-atom")
local clearRglCountdown, pulseRglCountdown = v1.clearRglCountdown, v1.pulseRglCountdown
local rglActiveAtom = RuntimeLib.import(script, script.Parent.Parent, "rgl-active-atom").rglActiveAtom
local rewardPresentationQueue = RuntimeLib.import(script, script.Parent.Parent, "reward-presentation-queue").rewardPresentationQueue
local v2 = RuntimeLib.import(script, script.Parent.Parent, "rgl-light-presentation-atom")
local clearRglLightPresentation, presentRglLight = v2.clearRglLightPresentation, v2.presentRglLight
local rglConfig = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "rgl-config").rglConfig
local resolveDollVisual, getLightForRglPhase, resolveAdornee, createRglBillboard, createRglTimerLabel, formatRglClock
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 29
        return "RglController"
    end
})

self.__index = self

function self.new(...) -- line: 34
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 38
    p1._characterController = p2
    p1._hasFinishedRgl = false
    p1._participantUserIds = {}
    p1._phaseEndsAt = 0
    p1._roundEndsAt = 0
    p1._hiddenDollParts = {}
    p1._hiddenDollGuis = {}
    p1._queuePlayerCount = 0
    p1._isGameOngoing = false
    p1._canPresentLights = false
end

function self.onStart(p3) -- line: 50
    -- upvalues: CollectionService (copy), HttpService (copy), LocalCharacterVisibilityFilter (copy), events (copy), playClonedSound (copy), pulseRglCountdown (copy), rglActiveAtom (copy), rewardPresentationQueue (copy), rglConfig (copy), resolveDollVisual (ref)
    p3:_setStartBoundaryCollision(false)
    p3:_setFinishBoundaryCollision(false)
    p3:_ensureLobbyBillboard()
    CollectionService:GetInstanceAddedSignal("RglFinishBounds"):Connect(function() -- line: 54
        -- upvalues: p3 (copy)
        p3:_setFinishBoundaryCollision(p3._hasFinishedRgl)
    end)
    CollectionService:GetInstanceAddedSignal("RglFinish"):Connect(function() -- line: 57
        -- upvalues: p3 (copy)
        p3:_ensureFinishTimer()
    end)
    CollectionService:GetInstanceAddedSignal("RglStartBounds"):Connect(function() -- line: 60
        -- upvalues: p3 (copy)
        p3:_setStartBoundaryCollision(p3._phase == "starting")
    end)
    CollectionService:GetInstanceAddedSignal("RglBeratur"):Connect(function() -- line: 63
        -- upvalues: p3 (copy)
        return p3:_ensureLobbyBillboard()
    end)
    CollectionService:GetInstanceAddedSignal("RglDoll"):Connect(function(p4) -- line: 66
        -- upvalues: p3 (copy), resolveDollVisual (ref)
        if p3._sessionId == nil then
            return nil
        end

        local v5 = resolveDollVisual(p4)

        if v5 then
            p3:_hideSourceDoll(v5)
        end
    end)
    events.rglQueueUpdated:connect(function(p5, p6, p7) -- line: 75
        -- upvalues: p3 (copy)
        p3._queuePlayerCount = p5
        p3._queueEndsAt = p6
        p3._isGameOngoing = p7
    end)
    events.rglPublicDollTransition:connect(function(p8) -- line: 80
        -- upvalues: p3 (copy), rglConfig (copy)
        if rglConfig.allowMultipleLobbies then
            return nil
        end

        p3._publicDollTransition = p8

        if p8 == nil then
            p3:_restorePublicDollOrientation()
        end
    end)
    events.rglSessionStarted:connect(function(p9) -- line: 89
        -- upvalues: p3 (copy), LocalCharacterVisibilityFilter (copy), playClonedSound (copy), rglActiveAtom (copy), rglConfig (copy)
        p3:_cleanupSessionPresentation()
        p3._sessionId = p9.sessionId
        rglActiveAtom(true)
        p3._canPresentLights = true
        p3._participantUserIds = p9.participantUserIds
        p3._phase = p9.phase
        p3._phaseEndsAt = p9.phaseEndsAt
        p3._roundEndsAt = p9.roundEndsAt
        p3._dollTransition = p9.dollTransition

        if rglConfig.allowMultipleLobbies then
            p3._visibilityFilter = LocalCharacterVisibilityFilter.new(p9.participantUserIds)
        end

        p3:_createLocalDoll(p9.sessionId, p9.dollAnchorCFrame)
        p3:_handlePhase(p9.phase)
        playClonedSound(rglConfig.preRaceSoundName)
    end)
    events.rglSessionPhaseChanged:connect(function(p10, p11, p12, p13, p14) -- line: 106
        -- upvalues: p3 (copy)
        if p10 ~= p3._sessionId then
            return nil
        end

        p3._phase = p11
        p3._phaseEndsAt = p12
        p3._roundEndsAt = p13
        p3._dollTransition = p14
        p3:_handlePhase(p11)
    end)
    events.rglSessionRosterChanged:connect(function(p15, p16) -- line: 116
        -- upvalues: p3 (copy)
        if p15 ~= p3._sessionId then
            return nil
        end

        p3._participantUserIds = p16

        local _visibilityFilter = p3._visibilityFilter

        if _visibilityFilter ~= nil then
            _visibilityFilter:setAllowedUserIds(p16)
        end
    end)
    events.rglSessionEnded:connect(function(p17) -- line: 126
        -- upvalues: p3 (copy), rglActiveAtom (copy)
        if p17 ~= p3._sessionId then
            return nil
        end

        rglActiveAtom(false)
        p3:_cleanupSessionPresentation()
    end)
    events.rglCountdown:connect(function(p18) -- line: 133
        -- upvalues: playClonedSound (copy), pulseRglCountdown (copy), rglConfig (copy)
        if p18 ~= "GO" then
            playClonedSound(rglConfig.countdownCountSoundName)
        end

        pulseRglCountdown(p18)
    end)
    events.rglEliminated:connect(function() -- line: 139
        -- upvalues: p3 (copy)
        p3:_stopLightPresentation()
        p3._characterController:_disableMovement()
    end)
    events.rglPlayerWon:connect(function() -- line: 143
        -- upvalues: p3 (copy)
        p3._hasFinishedRgl = true
        p3:_stopLightPresentation()
        p3:_setFinishBoundaryCollision(true)
        p3:_handleWin()
    end)
    events.rglRewardGranted:connect(function(p19) -- line: 149
        -- upvalues: HttpService (copy), rewardPresentationQueue (copy)
        rewardPresentationQueue:enqueue({
            kind = "rgl",
            id = HttpService:GenerateGUID(false),
            reward = p19
        })
    end)
end

function self.onRender(p20) -- line: 157
    -- upvalues: Workspace (copy)
    local ServerTimeNow = Workspace:GetServerTimeNow()

    p20:_updateDoll(ServerTimeNow)
    p20:_updatePublicDoll(ServerTimeNow)
    p20:_updateBillboards(ServerTimeNow)
    p20:_updateStopPhaseMovement()
end

function self._handlePhase(p21, p22) -- line: 164
    p21:_setStartBoundaryCollision(p22 == "starting")
    p21:_presentLightForPhase(p22)
    p21._wasInsideStartDuringStop = nil

    if p22 == "stop" then
        p21:_updateStopPhaseMovement()
    else
        p21._characterController:_enableMovement()
    end
end

function self._presentLightForPhase(p23, p24) -- line: 175
    -- upvalues: playClonedSound (copy), clearRglLightPresentation (copy), presentRglLight (copy), rglConfig (copy), getLightForRglPhase (ref)
    if not p23._canPresentLights then
        return nil
    end

    local v6 = getLightForRglPhase(p24)

    if v6 == p23._presentedLight then
        return nil
    end

    p23._presentedLight = v6

    if v6 == nil then
        clearRglLightPresentation()

        return nil
    end

    presentRglLight(v6)
    playClonedSound(if v6 == "green" then rglConfig.greenLightSoundName else rglConfig.redLightSoundName, {
        volume = if v6 == "green" then rglConfig.greenLightSoundVolume else rglConfig.redLightSoundVolume
    })
end

function self._stopLightPresentation(p25) -- line: 193
    -- upvalues: clearRglLightPresentation (copy)
    p25._canPresentLights = false
    p25._presentedLight = nil
    clearRglLightPresentation()
end

function self._updateStopPhaseMovement(p26) -- line: 198
    if p26._phase ~= "stop" then
        return nil
    end

    local v8 = p26:_isLocalPlayerInsideStart()

    if v8 == p26._wasInsideStartDuringStop then
        return nil
    end

    p26._wasInsideStartDuringStop = v8

    if v8 then
        p26._characterController:_enableMovement()
    else
        p26._characterController:_disableMovement()
    end
end

function self._isLocalPlayerInsideStart(_) -- line: 213
    -- upvalues: CollectionService (copy), Players (copy), Workspace (copy), resolveAdornee (ref)
    local RglStart = CollectionService:GetTagged("RglStart")

    local function v9(p28) -- line: 216
        -- upvalues: Workspace (copy)
        return p28:IsDescendantOf(Workspace)
    end

    local v10

    for v11, v12 in RglStart do
        local _ = v11 - 1

        if v12:IsDescendantOf(Workspace) == true then
            v10 = v12
            break
        end

        v10 = nil
    end

    local v13 = resolveAdornee(v10)
    local Character = Players.LocalPlayer.Character

    if Character ~= nil then
        Character = Character:FindFirstChild("HumanoidRootPart")
    end

    local v14 = not v13

    if not v14 then
        v14 = not (if Character == nil then Character else Character:IsA("BasePart"))
    end

    if v14 then
        return false
    end

    local v15 = v13.CFrame:PointToObjectSpace(Character.Position)

    if not (math.abs(v15.X) <= v13.Size.X / 2) then
        return false
    end

    return math.abs(v15.Z) <= v13.Size.Z / 2
end

function self._createLocalDoll(p29, p30, p31) -- line: 248
    -- upvalues: CollectionService (copy), Players (copy), ReplicatedStorage (copy), Workspace (copy), resolveDollVisual (ref)
    local RglDoll = CollectionService:GetTagged("RglDoll")

    local function v16(p32) -- line: 251
        -- upvalues: Workspace (copy)
        return p32:IsDescendantOf(Workspace)
    end

    local v17

    for v18, v19 in RglDoll do
        local _ = v18 - 1

        if v19:IsDescendantOf(Workspace) == true then
            v17 = v19
            break
        end

        v17 = nil
    end

    local v20 = resolveDollVisual(v17)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")

    if Assets ~= nil then
        Assets = Assets:FindFirstChild("RglDoll")
    end

    if not (if Assets == nil then Assets else Assets:IsA("Model")) and not (if Assets == nil then Assets else Assets:IsA("BasePart")) then
        Assets = v20
    end

    local v21

    if p31 ~= nil then
        v21 = p31
    elseif if v20 == nil then v20 else v20:IsA("Model") then
        v21 = v20:GetPivot()
    elseif if v20 == nil then v20 else v20:IsA("BasePart") then
        v21 = v20.CFrame
    end

    if not Assets or not v21 then
        return nil
    end

    task.spawn(function() -- line: 303
        -- upvalues: v21 (ref), Players (copy)
        return Players.LocalPlayer:RequestStreamAroundAsync(v21.Position, 5)
    end)
    task.defer(function() -- line: 306
        -- upvalues: p29 (copy), p30 (copy), v20 (copy), Assets (ref), v21 (ref), CollectionService (copy), Workspace (copy)
        if p29._sessionId ~= p30 then
            return nil
        end

        local clone = Assets:Clone()

        clone.Name = ("RglClientDoll-%*"):format(p30)

        if CollectionService:HasTag(clone, "RglDoll") then
            CollectionService:RemoveTag(clone, "RglDoll")
        end

        for _, descendant in clone:GetDescendants() do
            if descendant:IsA("Script") or descendant:IsA("LocalScript") or descendant:IsA("ModuleScript") then
                descendant:Destroy()
            elseif descendant:IsA("BasePart") then
                descendant.Anchored = true
                descendant.CanCollide = false
                descendant.CanQuery = false
                descendant.CanTouch = false
            end
        end

        if clone:IsA("BasePart") then
            clone.Anchored = true
            clone.CanCollide = false
            clone.CanQuery = false
            clone.CanTouch = false
        end

        clone.Parent = Workspace

        if clone:IsA("Model") then
            clone:PivotTo(v21)
        else
            clone.CFrame = v21
        end

        p29._localDoll = clone
        p29._dollBasePivot = v21

        if v20 then
            p29:_hideSourceDoll(v20)
        end
    end)
end

function self._hideSourceDoll(p33, p34) -- line: 346
    local t5 = {
        p34
    }
    local v22 = #t5
    local Descendants = p34:GetDescendants()

    table.move(Descendants, 1, #Descendants, v22 + 1, t5)

    for _, v23 in t5 do
        if v23:IsA("BasePart") then
            if p33._hiddenDollParts[v23] == nil then
                p33._hiddenDollParts[v23] = v23.LocalTransparencyModifier
            end

            v23.LocalTransparencyModifier = 1
        elseif v23:IsA("BillboardGui") or v23:IsA("SurfaceGui") then
            if p33._hiddenDollGuis[v23] == nil then
                p33._hiddenDollGuis[v23] = v23.Enabled
            end

            v23.Enabled = false
        end
    end
end

function self._updateDoll(p35, p36) -- line: 370
    local _localDoll, _dollBasePivot, _dollTransition = p35._localDoll, p35._dollBasePivot, p35._dollTransition

    if not (_localDoll and _dollBasePivot and _dollTransition) then
        return nil
    end

    local v25 = math.max(0.001, _dollTransition.endsAt - _dollTransition.startsAt)
    local v27 = math.clamp((p36 - _dollTransition.startsAt) / v25, 0, 1)
    local v28 = _dollTransition.startYawDegrees + (_dollTransition.targetYawDegrees - _dollTransition.startYawDegrees) * v27
    local v29 = _dollBasePivot * CFrame.Angles(0, math.rad(v28), 0)

    if _localDoll:IsA("Model") then
        _localDoll:PivotTo(v29)
    else
        _localDoll.CFrame = v29
    end
end

function self._updatePublicDoll(p37, p38) -- line: 388
    -- upvalues: rglConfig (copy)
    if rglConfig.allowMultipleLobbies or not p37._publicDollTransition then
        return nil
    end

    local v30 = p37:_getWorkspaceDoll()

    if not v30 then
        return nil
    end

    if p37._publicDollBasePivot == nil then
        if v30:IsA("Model") then
            p37._publicDollBasePivot = v30:GetPivot()
        else
            p37._publicDollBasePivot = v30.CFrame
        end
    end

    local _publicDollTransition = p37._publicDollTransition
    local v32 = math.max(0.001, _publicDollTransition.endsAt - _publicDollTransition.startsAt)
    local v34 = math.clamp((p38 - _publicDollTransition.startsAt) / v32, 0, 1)
    local v35 = _publicDollTransition.startYawDegrees + (_publicDollTransition.targetYawDegrees - _publicDollTransition.startYawDegrees) * v34
    local v36 = p37._publicDollBasePivot * CFrame.Angles(0, math.rad(v35), 0)

    if v30:IsA("Model") then
        v30:PivotTo(v36)
    else
        v30.CFrame = v36
    end
end

function self._restorePublicDollOrientation(p39) -- line: 412
    local v37 = p39:_getWorkspaceDoll()
    local _publicDollBasePivot = p39._publicDollBasePivot

    if v37 and _publicDollBasePivot then
        if v37:IsA("Model") then
            v37:PivotTo(_publicDollBasePivot)
        else
            v37.CFrame = _publicDollBasePivot
        end
    end

    p39._publicDollBasePivot = nil
end

function self._getWorkspaceDoll(_) -- line: 424
    -- upvalues: CollectionService (copy), Workspace (copy), resolveDollVisual (ref)
    local RglDoll = CollectionService:GetTagged("RglDoll")

    local function v38(p41) -- line: 427
        -- upvalues: Workspace (copy)
        return p41:IsDescendantOf(Workspace)
    end

    local v39

    for v40, v41 in RglDoll do
        local _ = v40 - 1

        if v41:IsDescendantOf(Workspace) == true then
            v39 = v41
            break
        end

        v39 = nil
    end

    return resolveDollVisual(v39)
end

function self._ensureLobbyBillboard(p42) -- line: 440
    -- upvalues: CollectionService (copy), rglConfig (copy), resolveAdornee (ref), createRglBillboard (ref)
    local _lobbyBillboard = p42._lobbyBillboard

    if _lobbyBillboard ~= nil then
        _lobbyBillboard = _lobbyBillboard.Parent
    end

    if _lobbyBillboard ~= nil then
        return nil
    end

    local v42 = CollectionService:GetTagged("RglBeratur")[1]
    local v43 = resolveAdornee(v42)

    if not v43 then
        return nil
    end

    local v44 = createRglBillboard("RglLobbyBillboard", v43, rglConfig.lobbyBillboardOffsetY, true)
    local v45 = v44[1]
    local v46 = v44[2]
    local v47 = v44[3]

    p42._lobbyBillboard = v45
    p42._lobbyTimer = v46
    p42._lobbyPlayers = v47
end

function self._ensureFinishTimer(p43) -- line: 461
    -- upvalues: CollectionService (copy), Workspace (copy), createRglTimerLabel (ref)
    local _finishBillboard = p43._finishBillboard

    if _finishBillboard ~= nil then
        _finishBillboard = _finishBillboard.Parent
    end

    local v48 = _finishBillboard ~= nil

    if v48 then
        local _roundTimer = p43._roundTimer

        if _roundTimer ~= nil then
            _roundTimer = _roundTimer.Parent
        end

        v48 = _roundTimer ~= nil
    end

    if v48 then
        return nil
    end

    local RglFinish = CollectionService:GetTagged("RglFinish")

    local function v49(p44) -- line: 479
        -- upvalues: Workspace (copy)
        return p44:IsDescendantOf(Workspace)
    end

    local v50

    for v51, v52 in RglFinish do
        local _ = v51 - 1

        if v52:IsDescendantOf(Workspace) == true then
            v50 = v52
            break
        end

        v50 = nil
    end

    if v50 ~= nil then
        v50 = v50:FindFirstChildWhichIsA("BillboardGui", true)
    end

    if not v50 then
        return nil
    end

    local RglTimer = v50:FindFirstChild("RglTimer")

    if not (if RglTimer == nil then RglTimer else RglTimer:IsA("TextLabel")) then
        RglTimer = createRglTimerLabel("RglTimer", false)
    end

    RglTimer.Parent = v50
    p43._finishBillboard = v50
    p43._roundTimer = RglTimer
end

function self._updateBillboards(p45, p46) -- line: 509
    -- upvalues: rglConfig (copy), formatRglClock (ref)
    p45:_ensureLobbyBillboard()
    p45:_ensureFinishTimer()

    local v53 = p45._sessionId ~= nil
    local v54 = if v53 then p45:_getRoundSecondsRemaining(p46) else nil
    local v55 = not rglConfig.allowMultipleLobbies and p45._isGameOngoing
    local v56 = v53 and (rglConfig.allowMultipleLobbies or p45._isGameOngoing)

    if p45._lobbyTimer then
        local v57 = if v56 and not v55 then v54 elseif p45._queueEndsAt ~= nil then math.max(0, (math.ceil(p45._queueEndsAt - p46))) else nil
        local _lobbyTimer = p45._lobbyTimer

        if v55 then
            _lobbyTimer.Text = rglConfig.lobbyGameOngoingText
        elseif v57 ~= nil then
            _lobbyTimer.Text = formatRglClock(v57)
        else
            _lobbyTimer.Text = ""
        end

        local _lobbyTimer2 = p45._lobbyTimer

        if v55 then
            _lobbyTimer2.TextColor3 = rglConfig.lobbyGameOngoingTextColor
        else
            _lobbyTimer2.TextColor3 = rglConfig.lobbyBillboardDefaultTextColor
        end

        p45._lobbyTimer.Visible = v55 or v57 ~= nil
    end

    if p45._lobbyPlayers then
        local v62 = if v56 then #p45._participantUserIds else p45._queuePlayerCount

        p45._lobbyPlayers.Text = ("%*/%* players"):format(v62, rglConfig.maximumPlayers)
        p45._lobbyPlayers.TextColor3 = rglConfig.lobbyBillboardDefaultTextColor
        p45._lobbyPlayers.Visible = not v55
    end

    if p45._roundTimer then
        local _roundTimer = p45._roundTimer

        if v54 ~= nil then
            _roundTimer.Text = formatRglClock(v54)
        else
            _roundTimer.Text = ""
        end

        p45._roundTimer.Visible = v53
    end
end

function self._getRoundSecondsRemaining(p47, p48) -- line: 533
    -- upvalues: rglConfig (copy)
    if p47._phase == "starting" then
        return rglConfig.roundTimeLimitSeconds
    end

    return (math.max(0, (math.ceil(p47._roundEndsAt - p48))))
end

function self._handleWin(p49) -- line: 539
    -- upvalues: Players (copy), playClonedSound (copy), playClonedVfxWithSound (copy), rglConfig (copy)
    local Character = Players.LocalPlayer.Character

    if Character ~= nil then
        Character = Character:FindFirstChild("HumanoidRootPart")
    end

    p49._characterController:_enableMovement()
    playClonedSound(rglConfig.winSoundName)
    p49._characterController:playAnimation(rglConfig.danceAnimationId, Enum.AnimationPriority.Action, nil, true)

    if if Character == nil then Character else Character:IsA("BasePart") then
        playClonedVfxWithSound(rglConfig.winVfxName, rglConfig.winSoundName, {
            playSound = false,
            targetPart = Character
        })
    end
end

function self._cleanupSessionPresentation(p50) -- line: 559
    -- upvalues: clearRglCountdown (copy), clearRglLightPresentation (copy), rglConfig (copy)
    clearRglCountdown()
    clearRglLightPresentation()

    local _visibilityFilter = p50._visibilityFilter

    if _visibilityFilter ~= nil then
        _visibilityFilter:destroy()
    end

    p50._visibilityFilter = nil

    local _localDoll = p50._localDoll

    if _localDoll ~= nil then
        _localDoll:Destroy()
    end

    p50._localDoll = nil
    p50._dollBasePivot = nil
    p50._finishBillboard = nil
    p50._roundTimer = nil

    for v65, v66 in p50._hiddenDollParts do
        if v65.Parent ~= nil then
            v65.LocalTransparencyModifier = v66
        end
    end

    for v67, v68 in p50._hiddenDollGuis do
        if v67.Parent ~= nil then
            v67.Enabled = v68
        end
    end

    table.clear(p50._hiddenDollParts)
    table.clear(p50._hiddenDollGuis)
    p50._sessionId = nil
    p50._participantUserIds = {}
    p50._phase = nil
    p50._phaseEndsAt = 0
    p50._roundEndsAt = 0
    p50._dollTransition = nil
    p50._hasFinishedRgl = false
    p50._wasInsideStartDuringStop = nil
    p50._presentedLight = nil
    p50._canPresentLights = false
    p50:_setStartBoundaryCollision(false)
    p50:_setFinishBoundaryCollision(false)
    p50._characterController:stopAnimationsById({
        rglConfig.danceAnimationId
    })
    p50._characterController:_enableMovement()
end

function self._setFinishBoundaryCollision(p51, p52) -- line: 602
    p51:_setTaggedBoundaryCollision("RglFinishBounds", p52)
end

function self._setStartBoundaryCollision(p53, p54) -- line: 605
    p53:_setTaggedBoundaryCollision("RglStartBounds", p54)
end

function self._setTaggedBoundaryCollision(_, p56, p57) -- line: 608
    -- upvalues: CollectionService (copy)
    for _, v69 in CollectionService:GetTagged(p56) do
        local t6 = {}

        if v69:IsA("BasePart") then
            table.insert(t6, v69)
        end

        for _, descendant in v69:GetDescendants() do
            if descendant:IsA("BasePart") then
                table.insert(t6, descendant)
            end
        end

        for _, v70 in t6 do
            v70.CanCollide = p57
        end
    end
end

Reflect.defineMetadata(self, "identifier", "client/controllers/rgl-controller@RglController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/character-controller@CharacterController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnRender" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

function getLightForRglPhase(p58) -- line: 633
    if p58 == "go" or p58 == "postStopBuffer" then
        return "green"
    end

    return if p58 == "stopWarning" or p58 == "stop" then "red" else nil
end

function resolveAdornee(p59) -- line: 642
    if if p59 == nil then p59 else p59:IsA("BasePart") then
        return p59
    end

    return if if p59 == nil then p59 else p59:IsA("Model") then p59.PrimaryPart or p59:FindFirstChildWhichIsA("BasePart", true) else nil
end

function resolveDollVisual(p60) -- line: 659
    if if p60 == nil then p60 else p60:IsA("Model") then
        return p60
    end

    return if if p60 == nil then p60 else p60:IsA("BasePart") then p60:FindFirstAncestorOfClass("Model") or p60 else nil
end

function createRglBillboard(p61, p62, p63, p64) -- line: 676
    -- upvalues: Players (copy), rglConfig (copy), createRglTimerLabel (ref)
    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = p61
    BillboardGui.Size = UDim2.fromOffset(240, p64 and 90 or 70)
    BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, p63, 0)
    BillboardGui.AlwaysOnTop = true
    BillboardGui.MaxDistance = rglConfig.lobbyBillboardMaxDistance
    BillboardGui.Adornee = p62
    BillboardGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    local v71 = createRglTimerLabel("RglTimer", p64)

    v71.Parent = BillboardGui

    local TextLabel

    if p64 then
        TextLabel = Instance.new("TextLabel")
        TextLabel.BackgroundTransparency = 1
        TextLabel.Size = UDim2.fromScale(1, 0.25)
        TextLabel.Font = Enum.Font.FredokaOne
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.TextStrokeTransparency = 0
        TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        TextLabel.TextScaled = true
        TextLabel.Parent = BillboardGui
    end

    return { BillboardGui, v71, TextLabel }
end

function createRglTimerLabel(p65, p66) -- line: 701
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = p65
    TextLabel.BackgroundTransparency = 1

    if p66 then
        TextLabel.Position = UDim2.fromScale(0, 0.2)
        TextLabel.Size = UDim2.fromScale(1, 0.8)
    else
        TextLabel.Position = UDim2.fromScale(0, 0)
        TextLabel.Size = UDim2.fromScale(1, 1)
    end

    TextLabel.Font = Enum.Font.FredokaOne
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextStrokeTransparency = 0
    TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.TextScaled = true

    return TextLabel
end

function formatRglClock(p67) -- line: 714
    local v73 = math.floor(p67 / 60)
    local v74 = p67 % 60

    return (("%*%*:%*%*"):format(if v73 < 10 then "0" else "", v73, if v74 < 10 then "0" else "", v74))
end

return {
    RglController = self
}
