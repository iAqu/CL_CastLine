-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AssetItem = require(ReplicatedStorage.Shared.Types.AssetItem)
local Personalities = require(ReplicatedStorage.Data.Assets).Personalities
local Log = require(ReplicatedStorage.Packages.Log)

require(ReplicatedStorage.Data.Assets)

local t = require(ReplicatedStorage.Packages.t)
local AssetMutationWalkSpeed = require(script.Parent.AssetMutationWalkSpeed)
local AssetPersonalityMotion = require(script.Parent.AssetPersonalityMotion)
local AssetRetreatMotion = require(script.Parent.AssetRetreatMotion)
local AssetWanderArea = require(script.Parent.AssetWanderArea)
local AssetWanderMotion = require(script.Parent.AssetWanderMotion)
local v1 = Log.new()
local t1 = {}

t1.__index = t1
t1.__class = "AssetWanderSimulator"

function t1.new(p1, p2, p3, p4, p5, p6, p7) -- line: 118
    -- upvalues: Players (copy), AssetItem (copy), Personalities (copy), t (copy), AssetPersonalityMotion (copy), v1 (copy), t1 (copy)
    t.strict(t.number)(p1)
    t.strict(t.instanceIsA("Player"))(p2)
    t.strict(t.instanceIsA("BasePart"))(p3)
    assert(AssetItem.AssetItemData(p4), "Invalid asset item data")
    t.strict(t.boolean)(p5)
    t.strict(t.number)(p6)
    t.strict(t.number)(p7)

    local v3 = Random.new(p1)
    local LocalPlayer = Players.LocalPlayer

    assert(LocalPlayer ~= nil, "Asset wander simulator requires a local player")

    local v5 = Personalities.GetConfig(p4.Personality)
    local self = setmetatable({}, t1)

    self._random = v3
    self._owner = p2
    self._localPlayer = LocalPlayer
    self._assetArea = p3
    self._itemData = p4
    self._config = v5
    self._greetingOrbitRadius = math.max(p6, 2.5)
    self._jumpHeight = math.min(math.max(p7, 1) * 2, 20)
    self._destination = p3.Position
    self._idleRemaining = 0
    self._idleAnchorCFrame = nil
    self._idleElapsed = 0
    self._walkSpeed = self:_rollWalkSpeed()
    self._mode = "Destination"
    self._phase = "Normal"
    self._greetRemaining = 0
    self._randomOrbitInsideSeconds = 0
    self._farSeconds = 0
    self._farRequiredSeconds = v3:NextNumber(105, 180)
    self._joinGreetingPending = true
    self._finishJumpsRemaining = 0
    self._finishJumpCooldown = 0
    self._returnGreetingHoldRemaining = 0
    self._returnGreetingJumpsRemaining = 0
    self._returnGreetingJumpCooldown = 0
    self._returnGreetingOwnerOffset = nil
    self._affectionInsideSeconds = 0
    self._affectionHoldRemaining = 0
    self._affectionJumpsRemaining = 0
    self._affectionJumpCooldown = 0
    self._affectionOwnerOffset = nil
    self._loyalOwnerOffset = AssetPersonalityMotion.RandomOwnerOffset(p3, v3, self._greetingOrbitRadius)
    self._pendingBubbleText = nil
    self._jumpRemaining = 0
    self._jumpElapsed = 0
    self._spinYaw = 0
    self._spinAppliedYaw = 0
    self._curveAngle = v3:NextNumber(-3.141592653589793, 3.141592653589793)
    self._curveRotationSpeed = v3:NextNumber(-0.8, 0.8)
    self._nextCurveChangeSeconds = v3:NextNumber(5, 10)
    self._curveChangeElapsed = 0
    self._retreatOwnerWasClose = false
    self._retreatActive = false
    self._lastOwnerPosition = nil
    self:_chooseNextDestination()

    if p5 then
        self:_tryStartFirstPlacementGreeting()
    end

    v1:AtDebug():Log((("Created asset wander simulator with seed %*"):format(p1)))

    return self
end

function t1:_rollWalkSpeed() -- line: 203
    -- upvalues: AssetMutationWalkSpeed (copy)
    local Movement = self._config.Movement

    return math.max(self._random:NextNumber(Movement.WalkSpeedMin, Movement.WalkSpeedMax), 4.5) * AssetMutationWalkSpeed.GetMultiplier(self._itemData)
end

function t1:_ownerRootPosition() -- line: 210
    -- upvalues: AssetPersonalityMotion (copy)
    return AssetPersonalityMotion.OwnerRootPosition(self._owner)
end

function t1:_distanceFromLocalPlayerToAreaCenter() -- line: 214
    -- upvalues: AssetPersonalityMotion (copy)
    return AssetPersonalityMotion.DistanceFromPlayerToAreaCenter(self._localPlayer, self._assetArea)
end

function t1:_chooseNextDestination() -- line: 220
    -- upvalues: AssetPersonalityMotion (copy)
    local v9 = self:_ownerRootPosition()
    local Movement = self._config.Movement

    self._walkSpeed = self:_rollWalkSpeed()
    self._destination = AssetPersonalityMotion.ChooseDestination(self._assetArea, self._random, Movement, v9)
    self._mode = self._random:NextNumber() < Movement.CurvedWanderChance and "Curve" or "Destination"
end

function t1:_tryRetreatFromOwner(p13, p14) -- line: 231
    -- upvalues: AssetPersonalityMotion (copy), AssetRetreatMotion (copy)
    local Retreat = self._config.Movement.Retreat

    if Retreat ~= nil and Vector3.new(p13.X - p14.X, 0, p13.Z - p14.Z).Magnitude <= Retreat.TriggerDistance then
        if self._retreatActive then
            self._destination = AssetRetreatMotion.Destination(self._assetArea, self._random, Retreat, p14, p13)
            self._mode = "Destination"
            self._idleRemaining = 0
            self._idleAnchorCFrame = nil
        else
            if self._retreatOwnerWasClose then
                return false
            end

            self._retreatOwnerWasClose = true

            if not AssetPersonalityMotion.RollChance(self._random, Retreat.Chance) then
                return false
            end

            self._retreatActive = true
            self._destination = AssetRetreatMotion.Destination(self._assetArea, self._random, Retreat, p14, p13)
            self._mode = "Destination"
            self._idleRemaining = 0
            self._idleAnchorCFrame = nil
            self._walkSpeed = self:_rollWalkSpeed()
        end

        return true
    end

    self._retreatOwnerWasClose = false
    self._retreatActive = false

    return false
end

function t1:_beginIdle(p16) -- line: 289
    local Movement = self._config.Movement

    self._idleRemaining = self._random:NextNumber(Movement.IdleSecondsMin, Movement.IdleSecondsMax)
    self._idleAnchorCFrame = p16
    self._idleElapsed = 0
end

function t1:_stepIdle(p18) -- line: 296
    -- upvalues: AssetPersonalityMotion (copy)
    local _idleAnchorCFrame = self._idleAnchorCFrame

    assert(_idleAnchorCFrame ~= nil, "Idle phase requires a stable anchor CFrame")

    local v13, v14, v15, v16 = AssetPersonalityMotion.StepIdle(p18, self._idleRemaining, self._idleElapsed, _idleAnchorCFrame, self._config.Movement.IdleTremble)

    self._idleRemaining = v14
    self._idleElapsed = v15

    if v16 then
        self._idleAnchorCFrame = nil
        self._idleElapsed = 0
    end

    return self:_applyJump(p18, v13)
end

function t1:_tryAmbientJump(p20) -- line: 316
    -- upvalues: AssetPersonalityMotion (copy)
    local Movement = self._config.Movement

    if AssetPersonalityMotion.ShouldStartAmbientJump(self._random, Movement.AmbientJumpRatePerSecond, p20, self._jumpRemaining > 0) then
        self:_startJump(Movement.AmbientSpinJumpChance)
    end
end

function t1:_startJump(p22) -- line: 330
    if self._jumpRemaining > 0 then
        return
    end

    local v17 = if p22 == nil then self._config.Greeting.SpinJumpChance else p22

    self._jumpRemaining = 0.45
    self._jumpElapsed = 0
    self._spinAppliedYaw = 0

    local v18 = if self._random:NextNumber() < 0.5 then -1 else 1

    if self._random:NextNumber() < v17 then
        self._spinYaw = 6.283185307179586 * v18
    else
        self._spinYaw = 0
    end
end

function t1:_resetGreetingFinish() -- line: 347
    self._finishJumpsRemaining = 0
    self._finishJumpCooldown = 0
end

function t1:_resetReturnGreeting() -- line: 352
    self._returnGreetingHoldRemaining = 0
    self._returnGreetingJumpsRemaining = 0
    self._returnGreetingJumpCooldown = 0
    self._returnGreetingOwnerOffset = nil
end

function t1:_resetAffection() -- line: 359
    self._affectionHoldRemaining = 0
    self._affectionJumpsRemaining = 0
    self._affectionJumpCooldown = 0
    self._affectionOwnerOffset = nil
    self._pendingBubbleText = nil
end

function t1:_popBubbleText() -- line: 367
    local _pendingBubbleText = self._pendingBubbleText

    self._pendingBubbleText = nil

    return _pendingBubbleText
end

function t1:_beginGreetingFinish() -- line: 374
    self._phase = "GreetingFinish"
    self._greetRemaining = 1.2
    self._finishJumpsRemaining = 2
    self._finishJumpCooldown = 0
    self._lastOwnerPosition = nil
end

function t1:_beginGreetingOrbit(p29) -- line: 382
    -- upvalues: t (copy), AssetPersonalityMotion (copy)
    t.strict(t.boolean)(p29)

    local Greeting = self._config.Greeting

    self._phase = "GreetingOrbit"
    self._greetRemaining = math.min(Greeting.DurationSeconds, 3)
    self._randomOrbitInsideSeconds = 0
    self._idleRemaining = 0
    self._lastOwnerPosition = nil
    self:_resetGreetingFinish()
    self:_resetReturnGreeting()
    self:_resetAffection()

    if p29 then
        self._pendingBubbleText = AssetPersonalityMotion.RandomConfiguredText(self._random, Greeting.Texts, self._config._id, "greeting")
    end
end

function t1:_tryStartGreetingOrbit(p31, p32) -- line: 407
    -- upvalues: t (copy), AssetPersonalityMotion (copy)
    t.strict(t.boolean)(p32)

    local Greeting = self._config.Greeting

    if p31 <= 0 or Greeting.DurationSeconds <= 0 or not AssetPersonalityMotion.RollChance(self._random, p31) then
        return false
    end

    self:_beginGreetingOrbit(p32)

    return true
end

function t1:_beginNormalGreeting(p34, p35, p36, p37) -- line: 424
    -- upvalues: t (copy), AssetPersonalityMotion (copy), AssetWanderArea (copy)
    t.strict(t.boolean)(p37)

    local v19 = AssetPersonalityMotion.RandomOwnerOffset(self._assetArea, self._random, self._greetingOrbitRadius)

    self._phase = "ReturnGreetingApproach"
    self._returnGreetingOwnerOffset = v19
    self._returnGreetingHoldRemaining = math.min(p36, 20)
    self._returnGreetingJumpsRemaining = p35
    self._returnGreetingJumpCooldown = 0
    self._destination = AssetWanderArea.PointNearOwner(self._assetArea, p34, v19)
    self._idleRemaining = 0
    self._walkSpeed = self:_rollWalkSpeed()
    self._lastOwnerPosition = nil
    self:_resetGreetingFinish()
    self:_resetAffection()

    if p37 then
        self._pendingBubbleText = AssetPersonalityMotion.RandomConfiguredText(self._random, self._config.Greeting.Texts, self._config._id, "greeting")
    end
end

function t1:_tryStartFirstPlacementGreeting() -- line: 460
    -- upvalues: AssetPersonalityMotion (copy)
    self._joinGreetingPending = false

    local Greeting = self._config.Greeting

    if self:_tryStartGreetingOrbit(Greeting.FirstPlacementChance, true) then
        return
    end

    local FirstPlacementBubbleChance = Greeting.FirstPlacementBubbleChance

    if FirstPlacementBubbleChance ~= nil and FirstPlacementBubbleChance > 0 and AssetPersonalityMotion.RollChance(self._random, FirstPlacementBubbleChance) then
        self._pendingBubbleText = AssetPersonalityMotion.RandomConfiguredText(self._random, Greeting.Texts, self._config._id, "greeting")
    else
        local v20 = self:_ownerRootPosition()

        if v20 ~= nil and AssetPersonalityMotion.RollChance(self._random, Greeting.FirstPlacementNormalChance) then
            local FirstPlacementNormalJumpCount = Greeting.FirstPlacementNormalJumpCount

            if not (FirstPlacementNormalJumpCount <= 0) then
                self:_beginNormalGreeting(v20, FirstPlacementNormalJumpCount, 0.6 * FirstPlacementNormalJumpCount, true)
            end
        end
    end
end

function t1:_tryStartReturnGreeting(p40, p41) -- line: 501
    -- upvalues: t (copy), AssetPersonalityMotion (copy)
    t.strict(t.boolean)(p41)

    local Greeting = self._config.Greeting

    if not (Greeting.Chance <= 0 or Greeting.DurationSeconds <= 0) and AssetPersonalityMotion.RollChance(self._random, Greeting.Chance) then
        local v21 = if p41 then self:_tryStartGreetingOrbit(Greeting.ReturnOrbitChance, false) else nil

        if not p41 or not v21 then
            self:_beginNormalGreeting(p40, Greeting.ReturnNormalJumpCount, math.min(Greeting.DurationSeconds, 20), false)
        end
    end
end

function t1:_beginAffection(p43) -- line: 526
    -- upvalues: AssetPersonalityMotion (copy), AssetWanderArea (copy)
    local Affection = self._config.Affection
    local v22 = AssetPersonalityMotion.RandomOwnerOffset(self._assetArea, self._random, self._greetingOrbitRadius)

    self._phase = "AffectionApproach"
    self._affectionOwnerOffset = v22
    self._destination = AssetWanderArea.PointNearOwner(self._assetArea, p43, v22)
    self._idleRemaining = 0
    self._walkSpeed = self:_rollWalkSpeed()
    self._affectionHoldRemaining = Affection.DurationSeconds
    self._affectionJumpsRemaining = Affection.JumpCount
    self._affectionJumpCooldown = 0
    self._pendingBubbleText = nil
    self._lastOwnerPosition = nil
    self:_resetGreetingFinish()
end

function t1:_updateAffectionTrigger(p45, p46) -- line: 550
    -- upvalues: AssetPersonalityMotion (copy), AssetWanderArea (copy)
    if self._phase == "Normal" then
        local Affection = self._config.Affection

        if Affection.Enabled and not (Affection.IntervalSeconds <= 0) and p46 ~= nil and AssetWanderArea.IsPositionInside(self._assetArea, p46) then
            self._affectionInsideSeconds += p45

            if not (self._affectionInsideSeconds < Affection.IntervalSeconds) then
                self._affectionInsideSeconds = 0

                if AssetPersonalityMotion.RollChance(self._random, Affection.Chance) then
                    self:_beginAffection(p46)
                end
            end
        else
            self._affectionInsideSeconds = 0
        end
    end
end

function t1:_updateOrbitGreetingTrigger(p48, p49) -- line: 581
    -- upvalues: AssetWanderArea (copy)
    if self._phase == "Normal" then
        local Greeting = self._config.Greeting

        if not (Greeting.RandomOrbitChance <= 0) and not (Greeting.RandomOrbitIntervalSeconds <= 0) and not (Greeting.DurationSeconds <= 0) and p49 ~= nil and AssetWanderArea.IsPositionInside(self._assetArea, p49) then
            self._randomOrbitInsideSeconds += p48

            if not (self._randomOrbitInsideSeconds < Greeting.RandomOrbitIntervalSeconds) then
                self._randomOrbitInsideSeconds = 0
                self:_tryStartGreetingOrbit(Greeting.RandomOrbitChance, false)
            end
        else
            self._randomOrbitInsideSeconds = 0
        end
    end
end

function t1:_updateReturnGreeting(p51) -- line: 615
    -- upvalues: AssetWanderArea (copy)
    if self._phase == "Normal" then
        if self._joinGreetingPending then
            local v23 = self:_ownerRootPosition()

            if v23 ~= nil then
                self._joinGreetingPending = false
                self._farSeconds = 0
                self._farRequiredSeconds = self._random:NextNumber(105, 180)
                self:_tryStartReturnGreeting(v23, AssetWanderArea.IsPositionInside(self._assetArea, v23))
            end
        else
            local v24 = self:_distanceFromLocalPlayerToAreaCenter()

            if v24 ~= nil then
                if v24 >= 200 then
                    self._farSeconds += p51
                elseif not (self._farSeconds >= self._farRequiredSeconds and v24 <= 200) then
                    self._farSeconds = 0
                else
                    self._farSeconds = 0
                    self._farRequiredSeconds = self._random:NextNumber(105, 180)

                    local v25 = self:_ownerRootPosition()

                    if v25 ~= nil and AssetWanderArea.IsPositionInside(self._assetArea, v25) then
                        self:_tryStartReturnGreeting(v25, true)
                    end
                end
            end
        end
    end
end

function t1:_updateGreeting(p53) -- line: 659
    if self._phase ~= "GreetingOrbit" and self._phase ~= "GreetingFinish" then
        return
    end

    local v26 = self:_distanceFromLocalPlayerToAreaCenter()

    if v26 == nil or not (v26 > 300) then
        self._greetRemaining = math.max(self._greetRemaining - p53, 0)

        if self._phase == "GreetingOrbit" then
            if self._greetRemaining <= 0 then
                self:_beginGreetingFinish()
            elseif self._random:NextNumber() < self._config.Greeting.JumpChancePerSecond * p53 then
                self:_startJump()
            end
        else
            self._finishJumpCooldown = math.max(self._finishJumpCooldown - p53, 0)

            if self._finishJumpsRemaining > 0 and self._finishJumpCooldown <= 0 then
                self:_startJump(0)
                self._finishJumpsRemaining -= 1
                self._finishJumpCooldown = 0.6
            end

            if self._finishJumpsRemaining <= 0 and self._jumpRemaining <= 0 and self._greetRemaining <= 0 then
                self._phase = "Normal"
                self:_resetGreetingFinish()
                self:_resetReturnGreeting()
                self:_resetAffection()
                self:_chooseNextDestination()
            end
        end
    else
        self._phase = "Normal"
        self._greetRemaining = 0
        self:_resetGreetingFinish()
        self:_resetReturnGreeting()
        self:_resetAffection()
        self:_chooseNextDestination()
    end
end

function t1:_stepReturnGreeting(p55, p56, p57) -- line: 703
    -- upvalues: AssetWanderArea (copy), AssetWanderMotion (copy)
    if self._phase == "ReturnGreetingApproach" then
        local _returnGreetingOwnerOffset = self._returnGreetingOwnerOffset

        assert(_returnGreetingOwnerOffset ~= nil, "Return greeting approach requires a stable owner offset")
        self._destination = AssetWanderArea.PointNearOwner(self._assetArea, p57, _returnGreetingOwnerOffset)

        local v30, v31, v32 = AssetWanderMotion.StepMoveToward(p55, p56, self._destination, self._walkSpeed)

        if Vector3.new(self._destination.X - v30.Position.X, 0, self._destination.Z - v30.Position.Z).Magnitude > 2.25 then
            local v35, v36 = self:_applyJump(p55, v30)

            return v35, v31 or self._jumpRemaining > 0, v36, v32
        end

        self._phase = "ReturnGreetingHold"
        self._returnGreetingJumpCooldown = 0

        if self._returnGreetingJumpsRemaining > 0 then
            self:_startJump(0)
            self._returnGreetingJumpsRemaining -= 1
            self._returnGreetingJumpCooldown = 0.6
        end

        local v37, v38 = self:_applyJump(p55, (AssetWanderMotion.FaceOwnerCFrame(v30, p57, p55, true)))

        return v37, v31 or self._jumpRemaining > 0, v38, v32
    end

    self._returnGreetingHoldRemaining = math.max(self._returnGreetingHoldRemaining - p55, 0)
    self._returnGreetingJumpCooldown = math.max(self._returnGreetingJumpCooldown - p55, 0)

    if self._returnGreetingJumpsRemaining > 0 and self._returnGreetingJumpCooldown <= 0 then
        self:_startJump(0)
        self._returnGreetingJumpsRemaining -= 1
        self._returnGreetingJumpCooldown = 0.6
    end

    local v41, v42 = self:_applyJump(p55, (AssetWanderMotion.FaceOwnerCFrame(p56, p57, p55)))

    if self._returnGreetingHoldRemaining <= 0 and self._returnGreetingJumpsRemaining <= 0 and self._jumpRemaining <= 0 then
        self._phase = "Normal"
        self:_resetReturnGreeting()
        self:_chooseNextDestination()
    end

    return v41, self._jumpRemaining > 0, v42, self._walkSpeed
end

function t1:_stepAffection(p59, p60, p61) -- line: 763
    -- upvalues: AssetPersonalityMotion (copy), AssetWanderArea (copy), AssetWanderMotion (copy)
    if self._phase == "AffectionApproach" then
        local _affectionOwnerOffset = self._affectionOwnerOffset

        assert(_affectionOwnerOffset ~= nil, "Affection approach requires a stable owner offset")
        self._destination = AssetWanderArea.PointNearOwner(self._assetArea, p61, _affectionOwnerOffset)

        local v44, v45, v46 = AssetWanderMotion.StepMoveToward(p59, p60, self._destination, self._walkSpeed)

        if Vector3.new(self._destination.X - v44.Position.X, 0, self._destination.Z - v44.Position.Z).Magnitude > 2.25 then
            local v49, v50 = self:_applyJump(p59, v44)

            return v49, v45 or self._jumpRemaining > 0, v50, v46
        end

        self._phase = "AffectionHold"
        self._affectionJumpCooldown = 0.6
        self._pendingBubbleText = AssetPersonalityMotion.RandomConfiguredText(self._random, self._config.Affection.Texts, self._config._id, "affection")

        if self._affectionJumpsRemaining > 0 then
            self:_startJump(0)
            self._affectionJumpsRemaining -= 1
        end

        local v51, v52 = self:_applyJump(p59, (AssetWanderMotion.FaceOwnerCFrame(v44, p61, p59, true)))

        return v51, v45 or self._jumpRemaining > 0, v52, v46
    end

    self._affectionHoldRemaining = math.max(self._affectionHoldRemaining - p59, 0)
    self._affectionJumpCooldown = math.max(self._affectionJumpCooldown - p59, 0)

    if self._affectionJumpsRemaining > 0 and self._affectionJumpCooldown <= 0 then
        self:_startJump(0)
        self._affectionJumpsRemaining -= 1
        self._affectionJumpCooldown = 0.6
    end

    local v55, v56 = self:_applyJump(p59, (AssetWanderMotion.FaceOwnerCFrame(p60, p61, p59)))

    if self._affectionHoldRemaining <= 0 and self._affectionJumpsRemaining <= 0 and self._jumpRemaining <= 0 then
        self._phase = "Normal"
        self:_resetAffection()
        self:_chooseNextDestination()
    end

    return v55, self._jumpRemaining > 0, v56, self._walkSpeed
end

function t1:_updateCurve(p63, p64) -- line: 826
    -- upvalues: AssetWanderArea (copy)
    self._curveChangeElapsed += p63

    if self._curveChangeElapsed >= self._nextCurveChangeSeconds then
        self._curveChangeElapsed = 0
        self._nextCurveChangeSeconds = self._random:NextNumber(5, 10)
        self._curveAngle = self._random:NextNumber(-3.141592653589793, 3.141592653589793)
        self._curveRotationSpeed = self._random:NextNumber(-0.8, 0.8)
    end

    self._curveAngle += self._curveRotationSpeed * p63

    local v59 = p64 + Vector3.new(math.cos(self._curveAngle), 0, (math.sin(self._curveAngle))) * 9

    self._destination = AssetWanderArea.ClampedPointToward(self._assetArea, v59)
end

function t1:_orbitGreetingCFrame(p66, p67, p68) -- line: 846
    -- upvalues: AssetWanderMotion (copy)
    local v60, v61 = AssetWanderMotion.OwnerMoveVector(p66, p68, self._lastOwnerPosition)

    self._lastOwnerPosition = v61

    return AssetWanderMotion.OrbitGreetingCFrame(self._assetArea, p66, p67, p68, v60, self._greetingOrbitRadius, 22, 0.75)
end

function t1:_applyJump(p70, p71) -- line: 867
    if self._jumpRemaining <= 0 then
        return p71, true
    end

    self._jumpRemaining = math.max(self._jumpRemaining - p70, 0)
    self._jumpElapsed = math.min(self._jumpElapsed + p70, 0.45)

    local v64 = self._jumpElapsed / 0.45
    local v66 = math.sin(v64 * 3.141592653589793) * self._jumpHeight
    local v67 = if self._spinYaw == 0 then 0 else self._spinYaw * v64
    local v68 = v67 - self._spinAppliedYaw

    self._spinAppliedYaw = v67

    local v69 = CFrame.new(p71.Position + Vector3.new(0, v66, 0)) * p71.Rotation

    if v68 ~= 0 then
        v69 *= CFrame.Angles(0, v68, 0)
    end

    if self._jumpRemaining <= 0 then
        self._spinAppliedYaw = 0
    end

    return v69, self._jumpRemaining <= 0
end

function t1:SetAssetArea(p73) -- line: 898
    -- upvalues: t (copy), AssetPersonalityMotion (copy)
    t.strict(t.instanceIsA("BasePart"))(p73)

    local v70 = self._assetArea ~= p73

    self._assetArea = p73

    if v70 then
        self._loyalOwnerOffset = AssetPersonalityMotion.RandomOwnerOffset(p73, self._random, self._greetingOrbitRadius)

        if self._returnGreetingOwnerOffset ~= nil then
            self._returnGreetingOwnerOffset = AssetPersonalityMotion.RandomOwnerOffset(p73, self._random, self._greetingOrbitRadius)
        else
            self._returnGreetingOwnerOffset = nil
        end

        if self._affectionOwnerOffset ~= nil then
            self._affectionOwnerOffset = AssetPersonalityMotion.RandomOwnerOffset(p73, self._random, self._greetingOrbitRadius)
        else
            self._affectionOwnerOffset = nil
        end
    end

    self:_chooseNextDestination()
end

function t1:SetItemData(p75, p76) -- line: 927
    -- upvalues: AssetItem (copy), Personalities (copy), t (copy)
    assert(AssetItem.AssetItemData(p75), "Invalid asset item data")
    t.strict(t.boolean)(p76)
    self._itemData = p75
    self._config = Personalities.GetConfig(p75.Personality)

    if p76 then
        self:_tryStartFirstPlacementGreeting()
    end
end

function t1:Step(p78, p79) -- line: 942
    -- upvalues: t (copy), AssetMutationWalkSpeed (copy), AssetWanderArea (copy), AssetWanderMotion (copy)
    t.strict(t.number)(p78)
    t.strict(t.CFrame)(p79)
    self:_updateReturnGreeting(p78)
    self:_updateGreeting(p78)

    local Position = p79.Position
    local v72 = self:_ownerRootPosition()

    if self._phase ~= "Normal" and v72 == nil then
        self._phase = "Normal"
        self._greetRemaining = 0
        self:_resetGreetingFinish()
        self:_resetReturnGreeting()
        self:_resetAffection()
        self:_chooseNextDestination()
    end

    self:_updateAffectionTrigger(p78, v72)
    self:_updateOrbitGreetingTrigger(p78, v72)

    local v73 = self._phase == "Normal" and v72 ~= nil and self:_tryRetreatFromOwner(Position, v72)

    if self._phase == "Normal" then
        self:_tryAmbientJump(p78)
    end

    if self._idleRemaining > 0 and self._phase == "Normal" then
        local v74, v75 = self:_stepIdle(p78)

        return v74, self._jumpRemaining > 0, v75, 0, false, self:_popBubbleText()
    end

    local v76, v77, v78, v79

    if self._phase == "GreetingOrbit" and v72 ~= nil then
        local v80, v81

        v80, v81, v76 = self:_orbitGreetingCFrame(p78, p79, v72)
        v77, v78 = self:_applyJump(p78, v80)
        v79 = v81 or self._jumpRemaining > 0

        return v77, v79, v78, v76, true, self:_popBubbleText()
    end

    local v82, v83, v84

    if self._phase == "GreetingFinish" and v72 ~= nil then
        v82, v83 = self:_applyJump(p78, (AssetWanderMotion.FaceOwnerCFrame(p79, v72, p78)))
        v84 = self._jumpRemaining > 0

        return v82, v84, v83, self._walkSpeed, true, self:_popBubbleText()
    end

    if (self._phase == "ReturnGreetingApproach" or self._phase == "ReturnGreetingHold") and v72 ~= nil then
        local v85, v86, v87, v88 = self:_stepReturnGreeting(p78, p79, v72)

        return v85, v86, v87, v88, false, self:_popBubbleText()
    end

    if (self._phase == "AffectionApproach" or self._phase == "AffectionHold") and v72 ~= nil then
        local v89, v90, v91, v92 = self:_stepAffection(p78, p79, v72)

        return v89, v90, v91, v92, false, self:_popBubbleText()
    end

    local v93, v94, v95, v96

    if self._config.Movement.FollowOwnerInPen and v72 ~= nil and AssetWanderArea.IsPositionInside(self._assetArea, v72) then
        local v97, v98

        v97, v98, v93 = AssetWanderMotion.StepFollowOwner(self._assetArea, p78, p79, v72, self._loyalOwnerOffset, self._walkSpeed, 2.25)
        v94, v95 = self:_applyJump(p78, v97)
        v96 = v98 or self._jumpRemaining > 0

        return v94, v96, v95, v93, false, self:_popBubbleText()
    end

    if self._mode == "Curve" then
        self:_updateCurve(p78, p79.Position)
    end

    local _destination = self._destination
    local v99 = _destination - Position
    local X, Z = v99.X, v99.Z
    local v100, v101, v102

    if Vector3.new(X, 0, Z).Magnitude <= 0.35 and not v73 then
        self:_beginIdle(p79)
        self:_chooseNextDestination()
        v100, v101 = self:_applyJump(p78, p79)
        v102 = self._jumpRemaining > 0

        return v100, v102, v101, self._walkSpeed, false, self:_popBubbleText()
    end

    local _walkSpeed = self._walkSpeed

    if self._random:NextNumber() < self._config.Movement.BurstChance * p78 then
        _walkSpeed = self._config.Movement.WalkSpeedMax * 1.25 * AssetMutationWalkSpeed.GetMultiplier(self._itemData)
        self:_startJump()
    end

    local v103, v104, v105 = AssetWanderMotion.StepMoveToward(p78, p79, _destination, _walkSpeed)
    local v106, v107 = self:_applyJump(p78, v103)

    return v106, v104 or self._jumpRemaining > 0, v107, v105, false, self:_popBubbleText()
end

return t1
