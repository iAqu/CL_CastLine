-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuardMovement = require(game:GetService("ReplicatedStorage").Shared.Flags.GameplayBalance).GuardMovement
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local CollisionGroups = require(ReplicatedStorage.Shared.Types.CollisionGroups)
local GuardChasePolicy = require(script.Parent.GuardChasePolicy)
local GuardDistance = require(script.Parent.GuardDistance)
local GuardEggRetrievalComponent = require(script.Parent.GuardEggRetrievalComponent)
local GuardReturnHomeDistanceResolver = require(script.Parent.GuardReturnHomeDistanceResolver)
local GuardMovementRecovery = require(script.Parent.GuardMovementRecovery)
local GuardPresentationComponent = require(script.Parent.GuardPresentationComponent)

require(ReplicatedStorage.Data.Guards)

local Log = require(ReplicatedStorage.Packages.Log)
local Player = require(ReplicatedStorage.Shared.Player)
local t = require(ReplicatedStorage.Packages.t)

require(script.Parent.Types.Interface)

local WaitFor = require(ReplicatedStorage.Packages.WaitFor)
local t1 = {}

t1.__index = t1
t1.__class = "GuardComponent"
t1.ATTACK_MIN_INTERVAL = GuardMovement.ATTACK_MIN_INTERVAL
require(ReplicatedStorage.Shared.Flags.BalanceConfig).Changed:Connect(function() -- line: 33
    -- upvalues: GuardMovement (copy), t1 (copy)
    t1.ATTACK_MIN_INTERVAL = GuardMovement.ATTACK_MIN_INTERVAL
end)

local v1 = Log.new()

function t1.new(p1, p2, p3, p4, p5, p6, p7) -- line: 103
    -- upvalues: Constants (copy), CollisionGroups (copy), GuardEggRetrievalComponent (copy), GuardMovementRecovery (copy), GuardPresentationComponent (copy), t (copy), WaitFor (copy), t1 (copy)
    local self = setmetatable({}, t1)

    t.strict(t.string)(p1)
    t.strict(t.instanceIsA("Model"))(p2)
    t.strict(t.instanceIsA("BasePart"))(p3)
    t.strict(t.instanceIsA("BasePart"))(p4)
    t.strict(t.table)(p5)
    t.strict(t.callback)(p6)
    t.strict(t.table)(p7)
    t.strict(t.callback)(p7.Attack)
    t.strict(t.boolean)(p7.ServerOwnsPhysics)
    t.strict(t.callback)(p7.Wake)

    local v3, v4 = WaitFor.Descendant(p2, "Humanoid", Constants.STUDIO_YIELD_TIMEOUT):await()
    local v5, v6 = WaitFor.Descendant(p2, "Animator", Constants.STUDIO_YIELD_TIMEOUT):await()
    local v7 = p2:WaitForChild("HumanoidRootPart", Constants.STUDIO_YIELD_TIMEOUT)
    local v8 = p2:WaitForChild("Collider", Constants.STUDIO_YIELD_TIMEOUT)
    local v9, v10 = WaitFor.Descendant(p2, "Head", Constants.STUDIO_YIELD_TIMEOUT):await()

    assert(v3, (("Failed to resolve Humanoid under %*: %*"):format(p2:GetFullName(), (tostring(v4)))))
    assert(v5, (("Failed to resolve Animator under %*: %*"):format(p2:GetFullName(), (tostring(v6)))))
    assert(v7, (("Failed to resolve HumanoidRootPart under %*: %*"):format(p2:GetFullName(), (tostring(v7)))))
    assert(v8, (("Failed to resolve Collider under %*"):format((p2:GetFullName()))))
    assert(v9, (("Failed to resolve Head under %*: %*"):format(p2:GetFullName(), (tostring(v10)))))
    assert(v4:IsA("Humanoid"), (("%*.Humanoid must be a Humanoid"):format((p2:GetFullName()))))
    assert(v6:IsA("Animator"), (("%*.Animator must be an Animator"):format((p2:GetFullName()))))
    assert(v7:IsA("BasePart"), (("%*.HumanoidRootPart must be a BasePart"):format((p2:GetFullName()))))
    assert(v8:IsA("BasePart"), (("%*.Collider must be a BasePart"):format((p2:GetFullName()))))

    if Constants.IS_STUDIO and v6.Parent == v4 and not p2:FindFirstChild("Model") then
        error((("Animator has to be parented to the animation controller for %*"):format((p2:GetFullName()))))
    end

    local CurrentPhysicalProperties = v8.CurrentPhysicalProperties

    v8.CustomPhysicalProperties = PhysicalProperties.new(0.01, CurrentPhysicalProperties.Friction, CurrentPhysicalProperties.Elasticity, CurrentPhysicalProperties.FrictionWeight, CurrentPhysicalProperties.ElasticityWeight)

    local v20 = p7.ServerOwnsPhysics and p2:GetAttribute("Hidden") == true

    for _, descendant in p2:GetDescendants() do
        if descendant:IsA("BasePart") then
            if not v20 then
                descendant.Anchored = false
            end

            descendant.CollisionGroup = CollisionGroups.GUARD_COLLISION_GROUP
        end
    end

    local Attachment = Instance.new("Attachment")

    Attachment.Name = "UprightAttachment"
    Attachment.Axis = Vector3.new(0, 1, 0)
    Attachment.SecondaryAxis = Vector3.new(1, 0, 0)

    local AlignOrientation = Instance.new("AlignOrientation")

    AlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
    AlignOrientation.AlignType = Enum.AlignType.PrimaryAxisParallel
    AlignOrientation.PrimaryAxis = Vector3.new(0, 1, 0)
    AlignOrientation.RigidityEnabled = true
    AlignOrientation.Attachment0 = Attachment
    AlignOrientation.Parent = Attachment
    Attachment.Parent = v7
    self._areaId = p1
    self._attackHandler = p7.Attack
    self._bodyRadius = math.max(v8.Size.X, v8.Size.Z) / 2
    self._bounds = p3
    self._config = p5
    self._eggRetrieval = GuardEggRetrievalComponent.new(p2, v7, v7.CFrame)
    self._enabled = true
    self._currentMoveTo = nil
    self._creatorPause = nil
    self._guardModel = p2
    self._homeCFrame = v7.CFrame
    self._humanoid = v4
    self._lastAttackTime = 0
    self._lastNetworkOwnerRetry = (-1e999)
    self._lastTargetRefresh = 0
    self._movementRecovery = GuardMovementRecovery.new(v7, p4)
    self._pinnedSince = nil
    self._attackResumeTime = 0
    self._ragdollEndTime = 0
    self._presentation = GuardPresentationComponent.new(v7, v6, p5)
    self._root = v7
    self._serverOwnsPhysics = p7.ServerOwnsPhysics
    self._sleepTurnConnection = nil
    self._sleepTurnFromCFrame = nil
    self._sleepTurnStartTime = 0
    self._state = "Sleeping"
    self._stolenEggUidByPlayer = {}
    self._stolenPlayerByEggUid = {}
    self._stolenPriorityByEggUid = {}
    self._targetPlayer = nil
    self._targetResolver = p6
    self._uprightAttachment = Attachment
    self._wakeHandler = p7.Wake
    self._wakingStartedAt = 0
    self._walkResumeTime = 0
    p2:SetAttribute("TargetPlayer", "")
    p2:SetAttribute("Sleeping", false)
    p2:SetAttribute("GuardState", "")
    p2:SetAttribute("AreaId", p1)
    p2:SetAttribute("WakeTargetPlayer", "")
    v4.WalkSpeed = p5.WalkSpeed
    v4:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    self:_trySetNetworkOwner(os.clock(), true)
    self:_enterSleepState()

    return self
end

function t1:_setState(p9) -- line: 276
    self._state = p9

    if p9 ~= "Chasing" then
        self._pinnedSince = nil
        self._presentation:CancelAfterWake()
    end
end

function t1:_isHitPaused(p11) -- line: 285
    -- upvalues: t (copy)
    t.strict(t.number)(p11)

    return p11 < math.max(self._walkResumeTime, self._attackResumeTime)
end

function t1:_holdIfHitPaused(p13) -- line: 291
    -- upvalues: t (copy)
    t.strict(t.number)(p13)

    if not self:_isHitPaused(p13) then
        return false
    end

    self._humanoid.WalkSpeed = 0
    self:_stopMovement()
    self._presentation:StopWalkAnimation()
    self._presentation:EnsureIdleAnimation()
    self._presentation:StopFootstepSound()

    return true
end

function t1:_enterSleepState() -- line: 307
    self:_setState("Sleeping")
    self._targetPlayer = nil
    self._currentMoveTo = nil
    self._movementRecovery:Reset()
    self:_cancelSleepTurn()
    self._wakingStartedAt = 0

    if not self._serverOwnsPhysics or self._guardModel:GetAttribute("Hidden") ~= true then
        self._root.Anchored = false
    end

    self._root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    self._root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    self._guardModel:PivotTo(self._homeCFrame * self._root.CFrame:ToObjectSpace(self._guardModel:GetPivot()))
    self._root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    self._root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    self._humanoid.WalkSpeed = 0
    self._humanoid:Move(Vector3.new(0, 0, 0), false)
    self._guardModel:SetAttribute("Sleeping", true)
    self._guardModel:SetAttribute("TargetPlayer", "")
    self._guardModel:SetAttribute("WakeTargetPlayer", "")
    self._guardModel:SetAttribute("GuardState", self._state)
    self._presentation:StopWalkAnimation()
    self._presentation:StopIdleAnimation()
    self._presentation:StopFootstepSound()
    self._presentation:PlaySleep(0.75)
end

function t1:_enterWakingState(p16) -- line: 337
    -- upvalues: t (copy)
    t.strict(t.number)(p16)

    if self._state == "Waking" then
        return
    end

    self:_cancelSleepTurn()
    self:_setTarget(nil)
    self:_setState("Waking")
    self._currentMoveTo = nil
    self._movementRecovery:Reset()
    self._wakingStartedAt = p16
    self._guardModel:SetAttribute("TargetPlayer", "")
    self._guardModel:SetAttribute("GuardState", self._state)
    self:_refreshWakeTarget()
end

function t1:_updateWaking(p18) -- line: 355
    -- upvalues: GuardChasePolicy (copy), t (copy)
    t.strict(t.number)(p18)

    if self:HasStolenEggs() or self._eggRetrieval:HasPending() then
        self:_refreshWakeTarget()

        if not (p18 - self._wakingStartedAt < GuardChasePolicy.GetWakingDuration()) then
            if self._eggRetrieval:HasPending() then
                self:_enterEggRetrievalState(p18)
            else
                self:_enterChaseState(p18)
                self:_updateChase(p18)
            end
        end
    else
        self:_enterSleepState()
    end
end

function t1:_getChaseWalkSpeed(p20) -- line: 378
    -- upvalues: GuardChasePolicy (copy), t (copy)
    t.strict(t.number)(p20)

    return GuardChasePolicy.ResolveWalkSpeed(self._config.WalkSpeed, self._config.FlatRadius, p20)
end

function t1:_getReturnWalkSpeed() -- line: 388
    -- upvalues: GuardMovement (copy)
    return self._config.WalkSpeed * GuardMovement.RETURN_WALK_SPEED_MULTIPLIER
end

function t1:_enterChaseState(p23) -- line: 392
    local v21 = self._state == "Waking"

    self:_cancelSleepTurn()

    if self._state ~= "Chasing" then
        self._wakingStartedAt = 0

        if not self._serverOwnsPhysics or self._guardModel:GetAttribute("Hidden") ~= true then
            self._root.Anchored = false
        end

        self:_trySetNetworkOwner(p23, true)
        self._humanoid.WalkSpeed = self._config.WalkSpeed
        self._guardModel:SetAttribute("Sleeping", false)
        self._guardModel:SetAttribute("GuardState", "Chasing")
        self._guardModel:SetAttribute("WakeTargetPlayer", "")
        self._presentation:StopSleep(0.4)
        self._wakeHandler(self._guardModel)
    end

    self:_setState("Chasing")

    if v21 then
        self._presentation:ScheduleAfterWake(p23)
    end

    if self._walkResumeTime < p23 then
        self._walkResumeTime = p23
    end
end

function t1:_enterEggRetrievalState(p25) -- line: 428
    -- upvalues: t (copy)
    t.strict(t.number)(p25)

    local v22 = self._state == "Waking"

    self:_cancelSleepTurn()
    self:_setTarget(nil)
    self:_setState("RetrievingEgg")
    self._wakingStartedAt = 0

    if not self._serverOwnsPhysics or self._guardModel:GetAttribute("Hidden") ~= true then
        self._root.Anchored = false
    end

    self:_trySetNetworkOwner(p25, true)
    self._guardModel:SetAttribute("Sleeping", false)
    self._guardModel:SetAttribute("GuardState", self._state)
    self._guardModel:SetAttribute("WakeTargetPlayer", "")

    if v22 then
        self._presentation:StopSleep(0.4)
        self._wakeHandler(self._guardModel)
    end
end

function t1:_updateEggRetrieval(p27) -- line: 453
    -- upvalues: GuardChasePolicy (copy), t (copy)
    t.strict(t.number)(p27)

    if self._eggRetrieval:HasPending() then
        local CurrentEggUid = self._eggRetrieval:GetCurrentEggUid()
        local v23 = self._config.EggPickupDistance or GuardChasePolicy.ResolveHitDistance(self._config.HitDistance)
        local v24 = self._eggRetrieval:TryTransition(v23)

        if v24 == nil then
            local MoveTarget = self._eggRetrieval:GetMoveTarget()

            assert(MoveTarget ~= nil, "Pending guard retrieval requires a movement target")

            if not self:_holdIfHitPaused(p27) then
                self._humanoid.WalkSpeed = self:_getReturnWalkSpeed()
                self:_ensureWalkAnimation(p27)
                self:_moveTo(MoveTarget)
            end

            return nil
        end

        assert(CurrentEggUid ~= nil, "Guard retrieval transition requires an egg UID")

        local t3 = {
            AreaId = self._areaId,
            EggUid = CurrentEggUid,
            Kind = v24
        }

        if v24 == "Deposited" then
            if self._eggRetrieval:HasPending() then
                self:_enterEggRetrievalState(p27)
            elseif self:HasStolenEggs() then
                self:_enterChaseState(p27)
                self:_updateChase(p27)
            else
                self:_enterReturnHomeState(p27)
            end
        else
            local MoveTarget = self._eggRetrieval:GetMoveTarget()

            assert(MoveTarget ~= nil, "Attached guard retrieval egg requires a home movement target")

            if not self:_holdIfHitPaused(p27) then
                self._humanoid.WalkSpeed = self:_getReturnWalkSpeed()
                self:_ensureWalkAnimation(p27)
                self:_moveTo(MoveTarget)
            end
        end

        return t3
    end

    if self:HasStolenEggs() then
        self:_enterChaseState(p27)
        self:_updateChase(p27)
    else
        self:_enterReturnHomeState(p27)
    end

    return nil
end

function t1:_enterReturnHomeState(p29) -- line: 522
    if self._eggRetrieval:HasPending() then
        self:_enterEggRetrievalState(p29)
    else
        self:_setState("ReturningHome")
        self._guardModel:SetAttribute("GuardState", "ReturningHome")
        self:_setTarget(nil)
        self:_cancelSleepTurn()

        if not self._serverOwnsPhysics or self._guardModel:GetAttribute("Hidden") ~= true then
            self._root.Anchored = false
        end

        if self:_isHitPaused(p29) then
            self._humanoid.WalkSpeed = 0
            self:_stopMovement()
            self._presentation:StopWalkAnimation()
            self._presentation:EnsureIdleAnimation()
            self._presentation:StopFootstepSound()
        else
            self._humanoid.WalkSpeed = self:_getReturnWalkSpeed()
            self:_moveTo(self._homeCFrame.Position)
        end
    end
end

function t1:_isPinnedInReach(p31, p32) -- line: 551
    -- upvalues: GuardMovement (copy), GuardChasePolicy (copy)
    local AssemblyLinearVelocity = self._root.AssemblyLinearVelocity

    if p32 <= GuardChasePolicy.ResolveHitDistance(self._config.HitDistance) + self._bodyRadius and Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude < self._humanoid.WalkSpeed * GuardMovement.PINNED_SPEED_RATIO then
        local v28 = self._pinnedSince or p31

        self._pinnedSince = v28

        return p31 - v28 >= GuardMovement.PINNED_HIT_DELAY
    end

    self._pinnedSince = nil

    return false
end

function t1:_updateChase(p34) -- line: 569
    -- upvalues: GuardChasePolicy (copy), GuardDistance (copy)
    if self._eggRetrieval:HasPending() then
        self:_enterEggRetrievalState(p34)
    else
        if self:HasStolenEggs() then
            local _targetPlayer = self._targetPlayer
            local v29, v30, v31

            if _targetPlayer ~= nil and self._stolenEggUidByPlayer[_targetPlayer] ~= nil then
                v29, v30 = self:_resolvePlayerTarget(_targetPlayer)
                v31 = self._stolenEggUidByPlayer[_targetPlayer]
            end

            local v32, v33, v34, v35

            if v29 == nil or v30 == nil or p34 - self._lastTargetRefresh >= 0.3 then
                v32, v33, v34, v35 = self:_chooseTargetPlayer()
                self._lastTargetRefresh = p34
            else
                v35 = v31
                v32 = _targetPlayer
                v33 = v29
                v34 = v30
            end

            if v32 ~= nil and v33 ~= nil and v34 ~= nil then
                self:_setTarget(v32)

                local v36 = GuardDistance.XZ(self._root.Position, v33.Position)

                if v36 <= GuardChasePolicy.ResolveHitDistance(self._config.HitDistance) or self:_isPinnedInReach(p34, v36) then
                    self:_attemptAttack(v32, v33, v34, v35, p34)
                else
                    local v37 = self:_getChaseWalkSpeed(GuardDistance.XZ(self._root.Position, v33.Position))

                    self._humanoid.WalkSpeed = v37
                    self:_ensureWalkAnimation(p34)
                    self:_moveThrough(v33.Position)
                end

                return
            end

            self:_setTarget(nil)
        end

        self:_enterReturnHomeState(p34)
    end
end

function t1:_updateReturnHome(p36) -- line: 623
    -- upvalues: GuardReturnHomeDistanceResolver (copy)
    if self._eggRetrieval:HasPending() then
        self:_enterEggRetrievalState(p36)
    elseif self:HasStolenEggs() then
        self:_enterChaseState(p36)
    elseif self._sleepTurnConnection == nil and not self:_updateSleepTurn(p36) then
        if (self._root.Position - self._homeCFrame.Position).Magnitude <= GuardReturnHomeDistanceResolver.Resolve(self._areaId) then
            self:_beginSleepTurn(p36)
        elseif self:_isHitPaused(p36) then
            self._humanoid.WalkSpeed = 0
            self:_stopMovement()
            self._presentation:StopWalkAnimation()
            self._presentation:EnsureIdleAnimation()
            self._presentation:StopFootstepSound()
        else
            self._humanoid.WalkSpeed = self:_getReturnWalkSpeed()
            self:_ensureWalkAnimation(p36)
            self:_moveTo(self._homeCFrame.Position)
        end
    end
end

function t1:_beginSleepTurn(p38) -- line: 664
    -- upvalues: RunService (copy), t (copy)
    t.strict(t.number)(p38)
    self._sleepTurnFromCFrame = self._root.CFrame
    self._sleepTurnStartTime = p38

    if self._sleepTurnConnection == nil then
        self._sleepTurnConnection = RunService.Heartbeat:Connect(function() -- line: 671
            -- upvalues: self (copy)
            self:_updateSleepTurn(os.clock())
        end)
    end

    self._humanoid.WalkSpeed = 0
    self:_stopMovement()
    self._presentation:StopWalkAnimation()
    self._presentation:EnsureIdleAnimation()
    self._presentation:StopFootstepSound()
    self:_updateSleepTurn(p38)
end

function t1:_cancelSleepTurn() -- line: 684
    local _sleepTurnConnection = self._sleepTurnConnection

    if _sleepTurnConnection ~= nil then
        self._sleepTurnConnection = nil
        _sleepTurnConnection:Disconnect()
    end

    self._sleepTurnFromCFrame = nil
    self._sleepTurnStartTime = 0
end

function t1:_updateSleepTurn(p41) -- line: 696
    -- upvalues: t (copy)
    t.strict(t.number)(p41)

    local _sleepTurnFromCFrame = self._sleepTurnFromCFrame

    if _sleepTurnFromCFrame ~= nil then
        if not (self:HasStolenEggs() or self._eggRetrieval:HasPending()) then
            local v39 = math.clamp((p41 - self._sleepTurnStartTime) / 0.3, 0, 1)
            local v40 = Vector3.new(self._homeCFrame.Position.X, self._root.Position.Y, self._homeCFrame.Position.Z)
            local v41 = CFrame.new(v40) * _sleepTurnFromCFrame.Rotation
            local v42 = CFrame.new(v40) * self._homeCFrame.Rotation

            self._guardModel:PivotTo(v41:Lerp(v42, v39) * self._root.CFrame:ToObjectSpace(self._guardModel:GetPivot()))

            if v39 >= 1 then
                self:_enterSleepState()
            end

            return true
        end

        self:_cancelSleepTurn()
    end

    return false
end

function t1:_updateMovementRecovery(p43) -- line: 729
    -- upvalues: t (copy)
    t.strict(t.number)(p43)

    local v43 = self._currentMoveTo ~= nil and (self._state == "Chasing" or self._state == "ReturningHome" or self._state == "RetrievingEgg") and not self:_isHitPaused(p43)

    if self._movementRecovery:Step(p43, v43, self._state == "ReturningHome") then
        return self:_recoverToHome()
    end

    return nil
end

function t1:_recoverToHome() -- line: 745
    self:_stopMovement()

    if self._eggRetrieval:HasPending() then
        self._guardModel:PivotTo(self._homeCFrame * self._root.CFrame:ToObjectSpace(self._guardModel:GetPivot()))
        self:_enterEggRetrievalState(os.clock())

        return self:_updateEggRetrieval(os.clock())
    end

    self:_enterSleepState()

    return nil
end

function t1:_chooseTargetPlayer() -- line: 761
    -- upvalues: Players (copy)
    local v44, v45, v46, v47
    local n1 = (-1e999)
    local n2 = 1e999

    for v48, v49 in pairs(self._stolenPlayerByEggUid) do
        if v49 ~= nil and table.find(Players:GetPlayers(), v49) then
            local v50, v51 = self:_resolvePlayerTarget(v49)

            if v50 ~= nil and v51 ~= nil then
                local v52 = self._stolenPriorityByEggUid[v48] or 0
                local Magnitude = (self._root.Position - v50.Position).Magnitude

                if n1 < v52 or v52 == n1 and Magnitude < n2 then
                    n2 = Magnitude
                    v44 = v49
                    v45 = v50
                    v46 = v51
                    v47 = v48
                    n1 = v52
                end
            end
        end
    end

    return v44, v45, v46, v47
end

function t1:_refreshWakeTarget() -- line: 802
    local v53 = self:_chooseTargetPlayer()
    local v54 = if v53 == nil then "" else tostring(v53.UserId)

    if self._guardModel:GetAttribute("WakeTargetPlayer") ~= v54 then
        self._guardModel:SetAttribute("WakeTargetPlayer", v54)
    end
end

function t1:_resolvePlayerTarget(p48) -- line: 814
    -- upvalues: Player (copy)
    if not self._targetResolver(p48) or Player.FindCharacter(p48) == nil then
        return nil, nil
    end

    local v55 = Player.FindRootPart(p48)
    local v56 = Player.FindHumanoid(p48)

    if v55 == nil or v56 == nil then
        return nil, nil
    end

    assert(v55:IsA("BasePart"), (("%* must be a BasePart"):format((v55:GetFullName()))))

    if v56.Health <= 0 then
        return nil, nil
    end

    return v55, v56
end

function t1:_attemptAttack(p50, p51, p52, p53, p54) -- line: 844
    -- upvalues: GuardMovement (copy), t (copy)
    t.strict(t.instanceIsA("Player"))(p50)
    t.strict(t.instanceIsA("BasePart"))(p51)
    t.strict(t.instanceIsA("Humanoid"))(p52)
    t.strict(t.optional(t.string))(p53)
    t.strict(t.number)(p54)

    if p54 < self._attackResumeTime or p54 < self._ragdollEndTime or p54 - self._lastAttackTime < GuardMovement.ATTACK_MIN_INTERVAL then
        return
    end

    self._lastAttackTime = p54
    self._currentMoveTo = nil
    self._movementRecovery:Reset()

    local v58 = self._presentation:PlayHit()
    local ATTACK_MIN_INTERVAL = GuardMovement.ATTACK_MIN_INTERVAL

    if v58 > 0 then
        ATTACK_MIN_INTERVAL = math.max(ATTACK_MIN_INTERVAL, v58)
    end

    self._walkResumeTime = p54 + ATTACK_MIN_INTERVAL
    self._attackResumeTime = math.max(self._attackResumeTime, p54 + ATTACK_MIN_INTERVAL)
    self._attackHandler({
        AreaId = self._areaId,
        Bounds = self._bounds,
        EggUid = p53,
        GuardHomePosition = self._homeCFrame.Position,
        GuardModel = self._guardModel,
        GuardRoot = self._root,
        GuardWalkSpeed = self._config.WalkSpeed,
        Player = p50,
        PlayerHumanoid = p52,
        PlayerRoot = p51
    })
end

function t1:_moveTo(p56) -- line: 897
    -- upvalues: t (copy)
    t.strict(t.Vector3)(p56)

    local v60 = Vector3.new(p56.X, self._root.Position.Y, p56.Z)

    self._currentMoveTo = v60
    self._humanoid:MoveTo(v60)
end

function t1:_moveThrough(p58) -- line: 906
    -- upvalues: t (copy)
    t.strict(t.Vector3)(p58)
    self:_moveTo(p58 + Vector3.new(p58.X - self._root.Position.X, 0, p58.Z - self._root.Position.Z).Unit * 100)
end

function t1:_stopMovement() -- line: 914
    self._currentMoveTo = nil
    self._movementRecovery:Reset()
    self._humanoid:MoveTo(self._root.Position)
    self._humanoid:Move(Vector3.new(0, 0, 0), false)
end

function t1:_setTarget(p61) -- line: 921
    if self._targetPlayer == p61 then
        return
    end

    self._targetPlayer = p61

    if p61 ~= nil then
        self._guardModel:SetAttribute("TargetPlayer", (tostring(p61.UserId)))
        self._presentation:PlayWake()
    else
        self._guardModel:SetAttribute("TargetPlayer", "")
    end
end

function t1:_ensureWalkAnimation(p63) -- line: 937
    -- upvalues: t (copy)
    t.strict(t.number)(p63)

    if p63 < self._walkResumeTime then
        self._presentation:EnsureIdleAnimation()
    else
        self._presentation:EnsureWalkAnimation(self._humanoid.WalkSpeed)
    end
end

function t1:_trySetNetworkOwner(p65, p66) -- line: 948
    -- upvalues: t (copy), v1 (copy)
    t.strict(t.number)(p65)
    t.strict(t.boolean)(p66)

    if self._serverOwnsPhysics and not self._root.Anchored then
        local v63 = if not p66 then p65 - self._lastNetworkOwnerRetry < 5 else nil

        if p66 or not v63 then
            self._lastNetworkOwnerRetry = p65

            if self._root:CanSetNetworkOwnership() then
                self._root:SetNetworkOwner(nil)
            else
                v1:AtWarning():Log((("Guard root network ownership cannot be set yet: %*"):format((self._root:GetFullName()))))
            end
        end
    end
end

function t1:Destroy() -- line: 975
    self:_setCreatorPaused(false, os.clock())
    self._eggRetrieval:Destroy()
    self:_cancelSleepTurn()
    self:_stopMovement()
    self._presentation:Destroy()
    self._uprightAttachment:Destroy()
    table.clear(self._stolenEggUidByPlayer)
    table.clear(self._stolenPlayerByEggUid)
    table.clear(self._stolenPriorityByEggUid)
end

function t1:RegisterStolenEgg(p69, p70, p71) -- line: 987
    -- upvalues: t (copy)
    t.strict(t.instanceIsA("Player"))(p69)
    t.strict(t.string)(p70)
    t.strict(t.number)(p71)

    local v64 = self._stolenPlayerByEggUid[p70]

    if v64 == p69 then
        return false
    end

    if v64 ~= nil then
        error((("Stolen egg \"%*\" is already registered to %*"):format(p70, v64.Name)))
    end

    local v65 = self._stolenEggUidByPlayer[p69]

    if v65 ~= nil then
        self._stolenPlayerByEggUid[v65] = nil
        self._stolenPriorityByEggUid[v65] = nil
    end

    self._stolenPlayerByEggUid[p70] = p69
    self._stolenEggUidByPlayer[p69] = p70
    self._stolenPriorityByEggUid[p70] = p71

    if self._enabled then
        local elapsed = os.clock()

        if self._eggRetrieval:HasPending() then
            if self._state == "Sleeping" then
                self:_enterWakingState(elapsed)
            end
        elseif self._state == "Sleeping" or self._state == "Waking" then
            self:_enterWakingState(elapsed)
        else
            self:_enterChaseState(elapsed)
            self:_updateChase(elapsed)
        end
    end

    return true
end

function t1:RegisterDroppedEgg(p73) -- line: 1042
    -- upvalues: t (copy)
    t.strict(t.table)(p73)

    if not self._eggRetrieval:Register(p73) then
        return false
    end

    if self._enabled then
        local elapsed = os.clock()

        if self._state == "Sleeping" then
            self:_enterWakingState(elapsed)
        elseif self._state ~= "Waking" then
            self:_enterEggRetrievalState(elapsed)
        end
    end

    return true
end

function t1:ClearDroppedEgg(p75) -- line: 1067
    -- upvalues: t (copy)
    t.strict(t.string)(p75)

    if not self._eggRetrieval:Clear(p75) then
        return false
    end

    if self._state == "RetrievingEgg" and not self._eggRetrieval:HasPending() then
        local elapsed = os.clock()

        if self:HasStolenEggs() then
            self:_enterChaseState(elapsed)
            self:_updateChase(elapsed)
        else
            self:_enterReturnHomeState(elapsed)
        end
    end

    return true
end

function t1:IsDroppedEggAttached(p77) -- line: 1088
    return self._eggRetrieval:IsAttached(p77)
end

function t1:ClearStolenEgg(p79) -- line: 1092
    -- upvalues: t (copy)
    t.strict(t.string)(p79)

    local v66 = self._stolenPlayerByEggUid[p79]

    if v66 == nil then
        return false
    end

    self._stolenPlayerByEggUid[p79] = nil
    self._stolenPriorityByEggUid[p79] = nil

    if self._stolenEggUidByPlayer[v66] == p79 then
        self._stolenEggUidByPlayer[v66] = nil
    end

    if self._targetPlayer == v66 then
        self:_setTarget(nil)
    end

    if not self:HasStolenEggs() then
        if self._eggRetrieval:HasPending() then
            return true
        end

        if self._state == "Waking" or self._state == "Sleeping" then
            self:_enterSleepState()
        else
            self:_enterReturnHomeState(os.clock())
        end
    end

    return true
end

function t1:ClearPlayer(p81) -- line: 1125
    -- upvalues: t (copy)
    t.strict(t.instanceIsA("Player"))(p81)

    local v67 = self._stolenEggUidByPlayer[p81]

    if v67 ~= nil then
        self._stolenEggUidByPlayer[p81] = nil
        self._stolenPlayerByEggUid[v67] = nil
        self._stolenPriorityByEggUid[v67] = nil
    end

    if self._targetPlayer == p81 then
        self:_setTarget(nil)
    end

    if self:HasStolenEggs() or self._eggRetrieval:HasPending() then
        return
    end

    if self._state == "Waking" or self._state == "Sleeping" then
        self:_enterSleepState()
    else
        self:_enterReturnHomeState(os.clock())
    end
end

function t1:HasStolenEggs() -- line: 1151
    return next(self._stolenPlayerByEggUid) ~= nil
end

function t1:IsEnabled() -- line: 1155
    return self._enabled
end

function t1:SetEnabled(p85) -- line: 1159
    -- upvalues: t (copy)
    t.strict(t.boolean)(p85)

    if self._enabled ~= p85 then
        self._enabled = p85

        if not p85 then
            self:_setCreatorPaused(false, os.clock())
            self:_enterSleepState()
        end
    end
end

function t1:_setCreatorPaused(p87, p88) -- line: 1175
    local _creatorPause = self._creatorPause

    if p87 then
        local v68

        if _creatorPause then
            v68 = _creatorPause
        else
            v68 = {
                StartedAt = p88,
                Anchored = self._root.Anchored,
                AutoRotate = self._humanoid.AutoRotate,
                WalkSpeed = self._humanoid.WalkSpeed,
                Tracks = {}
            }
            self._creatorPause = v68
            self:_cancelSleepTurn()
            self:_stopMovement()
            self._presentation:StopFootstepSound()
            self._guardModel:SetAttribute("CreatorPursuitPaused", true)
        end

        self._root.Anchored = true
        self._root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        self._root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        self._humanoid.AutoRotate = false
        self._humanoid.WalkSpeed = 0

        local v69 = self._guardModel:FindFirstChildWhichIsA("Animator", true)

        if v69 then
            for _, v70 in v69:GetPlayingAnimationTracks() do
                if v68.Tracks[v70] == nil then
                    v68.Tracks[v70] = v70.Speed
                end

                v70:AdjustSpeed(0)
            end
        end
    elseif _creatorPause then
        self._creatorPause = nil
        self._guardModel:SetAttribute("CreatorPursuitPaused", nil)
        self._root.Anchored = _creatorPause.Anchored or self._serverOwnsPhysics and self._guardModel:GetAttribute("Hidden") == true
        self._humanoid.AutoRotate = _creatorPause.AutoRotate
        self._humanoid.WalkSpeed = _creatorPause.WalkSpeed

        for v71, v72 in _creatorPause.Tracks do
            v71:AdjustSpeed(v72)
        end

        local v73 = p88 - _creatorPause.StartedAt

        self._wakingStartedAt += v73
        self._walkResumeTime += v73
        self._attackResumeTime += v73
        self._lastAttackTime += v73
        self._lastTargetRefresh = p88
        self._movementRecovery:Reset()
        self:_trySetNetworkOwner(p88, true)
    end
end

function t1:Step(p90) -- line: 1234
    -- upvalues: t (copy)
    t.strict(t.number)(p90)

    if not self._enabled then
        return nil
    end

    local _targetPlayer = self._targetPlayer

    if _targetPlayer == nil and self:HasStolenEggs() then
        _targetPlayer = self:_chooseTargetPlayer()
    end

    local v74 = _targetPlayer ~= nil and self._stolenEggUidByPlayer[_targetPlayer] ~= nil and self:_resolvePlayerTarget(_targetPlayer) ~= nil and (_targetPlayer:GetAttribute("CreatorPauseGuard_all") == true or _targetPlayer:GetAttribute("CreatorPauseGuard_" .. string.gsub(self._areaId, "%W", "")) == true)

    self:_setCreatorPaused(v74, p90)

    if v74 then
        return nil
    end

    if self._movementRecovery:ShouldRecoverFromFall() then
        return self:_recoverToHome()
    end

    self:_trySetNetworkOwner(p90, false)

    if self._state ~= "Waking" and self._state ~= "RetrievingEgg" and self._eggRetrieval:HasPending() then
        self:_enterEggRetrievalState(p90)
    end

    local v75

    if self._state == "Sleeping" then
        if self:HasStolenEggs() then
            self:_enterWakingState(p90)
        end
    elseif self._state == "Waking" then
        self:_updateWaking(p90)
    elseif self._state == "Chasing" then
        self:_updateChase(p90)
    elseif self._state == "ReturningHome" then
        self:_updateReturnHome(p90)
    elseif self._state == "RetrievingEgg" then
        v75 = self:_updateEggRetrieval(p90)
    end

    self._presentation:UpdateAfterWake(p90, self._state == "Chasing")

    if v75 == nil then
        return self:_updateMovementRecovery(p90)
    end

    return v75
end

return t1
