-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ServerClock = require(game:GetService("ReplicatedStorage").Shared.Util.ServerClock)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

game:GetService("Workspace")

local t = require(ReplicatedStorage.Packages.t)
local v1 = t.intersection(t.numberMinExclusive((-1e999)), t.numberMaxExclusive(1e999))
local AreaEggCycle = require(ReplicatedStorage.Shared.Util.AreaEggCycle)
local Assets = require(ReplicatedStorage.Data.Assets)
local EggActionMovement = require(script.Parent.EggActionMovement)
local EggRecords = require(ReplicatedStorage.Shared.Util.EggRecords)
local Eggs = require(ReplicatedStorage.Shared.Types.Eggs)
local Elapsed = require(ReplicatedStorage.Shared.Utils.Time).Elapsed
local SwapGradient = require(ReplicatedStorage.Shared.Utils.SwapGradient)
local VisualTransform = require(ReplicatedStorage.Shared.Utils.VisualTransform)
local PlacedEggGrowthPresentationPolicy = require(script.Parent.PlacedEggGrowthPresentationPolicy)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t1 = {}

t1.__index = t1
t1.__class = "NightEggTimeSkipAnimation"

local v2 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v3 = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
local v4 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local NightEggTimeSkip = ReplicatedStorage.Assets.Billboards.NightEggTimeSkip

assert(NightEggTimeSkip:IsA("BillboardGui"), "ReplicatedStorage.Assets.Billboards.NightEggTimeSkip must be a BillboardGui")

function t1.new(p1, p2, p3, p4, p5, p6, p7, p8) -- line: 117
    -- upvalues: t (copy), v1 (copy), AreaEggCycle (copy), Assets (copy), EggRecords (copy), Eggs (copy), VisualTransform (copy), Trove (copy), t1 (copy)
    t.strict(t.instanceIsA("Model"))(p1)
    t.strict(t.string)(p2)
    assert(Eggs.SchemaValidation.RuntimeEggRecord(p3), "Invalid runtime egg record")
    t.strict(t.CFrame)(p4)
    t.strict(v1)(p5)
    t.strict(v1)(p6)
    t.strict(v1)(p7)
    t.strict(v1)(p8)
    assert(p5 > 0 and p6 > 0, "Egg time skip scales must be positive")
    assert(p7 < p8, "Egg time skip day start must follow night start")
    assert(p3.Placement, "Night egg time skip requires a placed egg")

    local v8 = Assets.Directory[p3.AssetCategory]

    assert(v8 ~= nil, (("Missing asset config for category %*"):format(p3.AssetCategory)))

    local GrowthSpeedMultiplier = p3.GrowthSpeedMultiplier
    local v11 = AreaEggCycle.PeriodIndexAt(p8)
    local v12 = EggRecords.CommittedNightCredit(p3, v11)
    local v13 = EggRecords.GrowthSecondsRemaining(p3, p7, GrowthSpeedMultiplier) + v12
    local v14 = math.min(AreaEggCycle.NightGrowthSkipSeconds, v13)
    local self = setmetatable({}, t1)

    self._model = p1
    self._uid = p2
    self._record = p3
    self._basePivot = p4
    self._startScale = p5
    self._targetScale = p6
    self._growthSpeedMultiplier = GrowthSpeedMultiplier
    self._nightStartsAt = p7
    self._dayStartsAt = p8
    self._nightPeriodIndex = v11
    self._nightTargetCreditSeconds = v14
    self._committedNightCreditSeconds = v12
    self._skipSeconds = math.max(0, v14 - v12)
    self._remainingAtNightfall = v13
    self._nightScaleStart = p5
    self._nightScaleEnd = p6
    self._snappedGrowthScale = nil
    assert(self._skipSeconds > 0, "Night egg time skip requires remaining growth time")
    self._appliedSeconds = Instance.new("NumberValue")
    self._billboardFader = VisualTransform.Fader()
    self._lifecycleTrove = Trove.new()
    self._visualTrove = Trove.new()
    self._animation = nil
    self._visualFinishing = false
    self._visualFinished = false
    self._billboardFadeFinished = false
    self._pendingCommit = true
    self._destroyed = false
    self._lastTimerSecond = -1
    self._lastShakeElapsed = 0
    self._lastShakeAlpha = 0
    self._lastShakePitch = 0
    self._lastShakeRoll = 0
    self._billboard = nil
    self._timerLabel = nil
    self._textScale = nil
    self._originalTextColor = nil

    if v8.Egg.HideRarity or p3.PurchaseId ~= nil then
        self._rarityGradient = nil
    else
        self._rarityGradient = v8.Rarity.RarityGradient
    end

    self:_refreshNightScaleRange()
    self._lifecycleTrove:Add(self._appliedSeconds)
    self:_init()

    return self
end

local function stepPresentation(p9) -- line: 204
    -- upvalues: RunService (copy)
    local n1 = 0
    local connection

    connection = RunService.PreRender:Connect(function(p10) -- line: 207
        -- upvalues: p9 (copy), n1 (ref), connection (ref)
        n1 += p10

        if p9(n1) then
            connection:Disconnect()
        end
    end)

    return connection
end

local function easeOutQuad(p11) -- line: 216
    -- upvalues: TweenService (copy)
    return TweenService:GetValue(p11, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
end

function t1:_getAppliedSecondsAt(p13) -- line: 220
    -- upvalues: EggRecords (copy)
    return EggRecords.NightCreditAt(self._record, p13, self._growthSpeedMultiplier, self._nightStartsAt, self._nightPeriodIndex)
end

function t1:_getGrowthScaleAt(p15) -- line: 233
    -- upvalues: EggRecords (copy)
    local v18 = EggRecords.GrowthAlpha(self._record, p15, self._growthSpeedMultiplier, self:_getAppliedSecondsAt(p15))

    return (math.lerp(self._startScale, self._targetScale, v18))
end

function t1:_refreshNightScaleRange() -- line: 246
    local v19 = self:_getGrowthScaleAt(self._nightStartsAt)
    local v20 = self:_getGrowthScaleAt(self._dayStartsAt)
    local v22 = math.abs(self._nightScaleStart - v19) > 0.001 or math.abs(self._nightScaleEnd - v20) > 0.001

    self._nightScaleStart = v19
    self._nightScaleEnd = v20

    if v22 then
        self._snappedGrowthScale = nil
    end
end

function t1:_createPresentation() -- line: 258
    -- upvalues: t (copy), AreaEggCycle (copy), Elapsed (copy), SwapGradient (copy), NightEggTimeSkip (copy)
    local PrimaryPart = self._model.PrimaryPart

    t.strict(t.instanceIsA("BasePart"))(PrimaryPart)

    local v26 = math.min(5, (math.max(0.1, (PrimaryPart.Size.X / 6.388999938964844 * (PrimaryPart.Size.Y / 7.507999897003174) * (PrimaryPart.Size.Z / 6.367000102996826)) ^ 0.3333333333333333 * 0.9)))
    local Attachment = Instance.new("Attachment")

    Attachment.Name = "NightEggTimeSkipAttachment"
    Attachment.Parent = PrimaryPart
    self._visualTrove:Add(Attachment)

    local clone = NightEggTimeSkip:Clone()
    local Main = clone.Main

    assert(Main:IsA("Frame"), "NightEggTimeSkip.Main must be a Frame")

    local child

    for _, child2 in Main:GetChildren() do
        if child2:IsA("Frame") then
            local v27 = child == nil

            child = child2
            assert(v27, "NightEggTimeSkip.Main must contain exactly one content Frame")
        end
    end

    local v28 = assert(child, "NightEggTimeSkip.Main must contain a content Frame")
    local Timer = v28.Timer

    assert(Timer:IsA("Frame"), "NightEggTimeSkip.Main.Frame.Timer must be a Frame")

    local Timer2 = Timer.Timer

    assert(Timer2:IsA("TextLabel"), "NightEggTimeSkip.Main.Frame.Timer.Timer must be a TextLabel")

    local Multiplier = Timer.Multiplier

    assert(Multiplier:IsA("TextLabel"), "NightEggTimeSkip.Main.Frame.Timer.Multiplier must be a TextLabel")

    local DisplayName = v28.DisplayName

    assert(DisplayName:IsA("TextLabel"), "NightEggTimeSkip.Main.Frame.DisplayName must be a TextLabel")
    DisplayName.Text = "Egg"
    SwapGradient(DisplayName, self._rarityGradient)

    local Size = clone.Size

    clone.Size = UDim2.new(Size.X.Scale * v26, Size.X.Offset * v26, Size.Y.Scale * v26, Size.Y.Offset * v26)
    clone.StudsOffsetWorldSpace = Vector3.new(0, -2, 0)
    clone.Adornee = Attachment
    clone.Parent = Attachment
    self._billboard = clone
    self._timerLabel = Timer2
    self._originalTextColor = Timer2.TextColor3
    self._visualTrove:Add(clone)

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "NightEggTimeSkipScale"
    UIScale.Scale = 1
    UIScale.Parent = Timer2
    self._textScale = UIScale

    local _billboardFader = self._billboardFader

    self._visualTrove:Add(function() -- line: 328
        -- upvalues: clone (copy), _billboardFader (copy)
        _billboardFader:Hide(clone, 0)
    end)
    _billboardFader:Hide(clone, 1)

    local v31 = math.max(0, (math.floor(self._remainingAtNightfall - self._committedNightCreditSeconds + 0.5)))

    if v31 == 0 then
        Timer2.Text = "READY!"
    else
        Timer2.Text = Elapsed(v31)
    end

    Multiplier.Text = `(x{ math.round(AreaEggCycle.NightGrowthRate() * 10) / 10 })`
end

function t1:_setAppliedSeconds(p19) -- line: 338
    -- upvalues: Elapsed (copy)
    local v33 = math.clamp(p19, 0, self._skipSeconds)

    self._appliedSeconds.Value = v33

    local v36 = math.max(0, (math.floor(self._remainingAtNightfall - self._committedNightCreditSeconds - v33 + 0.5)))

    if v36 == self._lastTimerSecond then
        return
    end

    self._lastTimerSecond = v36

    local _timerLabel = self._timerLabel

    if _timerLabel ~= nil then
        if v36 == 0 then
            _timerLabel.Text = "READY!"
        else
            _timerLabel.Text = Elapsed(v36)
        end
    end
end

function t1:_applyShake(p21, p22) -- line: 363
    -- upvalues: EggActionMovement (copy)
    local v38 = math.sin(p21 * 3.141592653589793 * 2 * 1.75) * 0.039269908169872414 * p22
    local v40 = math.cos(p21 * 3.141592653589793 * 2 * 2.25) * 0.05672320068981571 * p22

    self._lastShakeElapsed = p21
    self._lastShakeAlpha = p22
    self._lastShakePitch = v38
    self._lastShakeRoll = v40
    EggActionMovement.SetPivot(self._model, self._basePivot * CFrame.Angles(v38, 0, v40))
end

function t1:_updateModel(p24) -- line: 381
    -- upvalues: TweenService (copy), PlacedEggGrowthPresentationPolicy (copy)
    local _model = self._model

    self:_setAppliedSeconds((self:_getAppliedSecondsAt(p24)))

    local v41 = PlacedEggGrowthPresentationPolicy.GetGrowthScaleDeltaSkipReason(self._nightScaleStart, self._nightScaleEnd)

    if v41 ~= nil then
        if self._snappedGrowthScale ~= self._nightScaleEnd then
            _model:ScaleTo(self._nightScaleEnd)
            self._snappedGrowthScale = self._nightScaleEnd
            PlacedEggGrowthPresentationPolicy.LogSkipped(self._uid, "night growth scale channel", v41)
        end
    else
        self._snappedGrowthScale = nil
        _model:ScaleTo(self:_getGrowthScaleAt(p24))
    end

    local v43 = math.max(0, p24 - self._nightStartsAt)

    self:_applyShake(v43, (TweenService:GetValue(math.clamp(v43 / 5, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out)))

    local _billboard = self._billboard

    if _billboard ~= nil then
        local Value = TweenService:GetValue(math.clamp(v43 / 1, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        _billboard.StudsOffsetWorldSpace = (Vector3.new(0, -2, 0)):Lerp(Vector3.new(0, 0, 0), Value)
        self._billboardFader:Hide(_billboard, 1 - Value)
    else
        self._billboardFadeFinished = true
    end
end

function t1:_fadeVisuals() -- line: 421
    -- upvalues: RunService (copy), TweenService (copy)
    local _billboard = self._billboard

    if _billboard ~= nil then
        local _billboardFader, _lastShakeElapsed, _lastShakeAlpha = self._billboardFader, self._lastShakeElapsed, self._lastShakeAlpha
        local n2 = 0

        while n2 < 5 do
            local v48 = RunService.PreRender:Wait()

            if self._destroyed then
                break
            end

            n2 = math.min(n2 + v48, 5)

            local v52 = math.clamp(n2 / 1, 0, 1)
            local Value = TweenService:GetValue(v52, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local Value2 = TweenService:GetValue(n2 / 5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

            _billboardFader:Hide(_billboard, Value)

            if v52 >= 1 then
                self._billboardFadeFinished = true
            end

            self:_applyShake(_lastShakeElapsed + n2, _lastShakeAlpha * (1 - Value2))
        end
    else
        self._billboardFadeFinished = true
    end
end

function t1:_playTextFinish() -- line: 448
    -- upvalues: TweenService (copy), v2 (copy), v3 (copy), v4 (copy)
    local _timerLabel, _textScale, _originalTextColor = self._timerLabel, self._textScale, self._originalTextColor

    if _timerLabel ~= nil and _textScale ~= nil and _originalTextColor ~= nil then
        local tween = TweenService:Create(_textScale, v2, {
            Scale = 1.5
        })
        local tween2 = TweenService:Create(_timerLabel, v4, {
            TextColor3 = Color3.new(1, 1, 1)
        })

        self._visualTrove:Add(tween)
        self._visualTrove:Add(tween2)
        tween:Play()
        tween2:Play()
        tween.Completed:Wait()

        if self._destroyed then
            return
        end

        local tween3 = TweenService:Create(_textScale, v3, {
            Scale = 1
        })
        local tween4 = TweenService:Create(_timerLabel, v4, {
            TextColor3 = _originalTextColor
        })

        self._visualTrove:Add(tween3)
        self._visualTrove:Add(tween4)
        tween3:Play()
        tween4:Play()
        tween3.Completed:Wait()

        if not self._destroyed then
            _timerLabel.TextColor3 = _originalTextColor
        end
    end
end

function t1:_finishVisuals(p28) -- line: 481
    -- upvalues: ServerClock (copy), RunService (copy), EggActionMovement (copy)
    if self._visualFinishing or self._visualFinished or self._destroyed then
        return
    end

    self._visualFinishing = true

    local _animation = self._animation

    if _animation ~= nil then
        _animation:Disconnect()
        self._animation = nil
    end

    self:_setAppliedSeconds(if p28 then self._skipSeconds else self:_getAppliedSecondsAt(ServerClock.Now()))

    if p28 then
        local _lastShakeElapsed, _lastShakeAlpha = self._lastShakeElapsed, self._lastShakeAlpha

        local function v55(p29) -- line: 503
            -- upvalues: self (copy), _lastShakeElapsed (copy), _lastShakeAlpha (copy)
            if self._destroyed then
                return true
            end

            self:_applyShake(_lastShakeElapsed + p29, _lastShakeAlpha)

            return nil
        end

        local n3 = 0
        local connection

        connection = RunService.PreRender:Connect(function(p30) -- line: 207
            -- upvalues: v55 (copy), n3 (ref), connection (ref)
            n3 += p30

            if v55(n3) then
                connection:Disconnect()
            end
        end)
        self._animation = connection
        self:_playTextFinish()
        connection:Disconnect()

        if self._animation == connection then
            self._animation = nil
        end
    end

    if not self._destroyed then
        self:_fadeVisuals()
    end

    if self._destroyed then
        return
    end

    self._lastShakeAlpha = 0
    self._lastShakePitch = 0
    self._lastShakeRoll = 0
    EggActionMovement.SetPivot(self._model, self._basePivot)
    self._visualTrove:Clean()
    self._billboard = nil
    self._timerLabel = nil
    self._textScale = nil
    self._visualFinishing = false
    self._visualFinished = true
end

function t1:_start() -- line: 536
    -- upvalues: ServerClock (copy), RunService (copy), EggRecords (copy)
    self:_createPresentation()

    local function v57(_) -- line: 538
        -- upvalues: self (copy), ServerClock (copy), EggRecords (copy)
        if self._destroyed or self._model.Parent == nil then
            return true
        end

        local v58 = ServerClock.Now()

        self:_updateModel(v58)

        if not (EggRecords.GrowthSecondsRemaining(self._record, v58, self._growthSpeedMultiplier, self._appliedSeconds.Value) <= 0 and v58 < self._dayStartsAt) then
            if not (self._dayStartsAt <= v58) then
                return nil
            end

            task.spawn(self._finishVisuals, self, true)
        else
            task.spawn(self._finishVisuals, self, false)
        end

        return true
    end

    local n4 = 0
    local connection

    connection = RunService.PreRender:Connect(function(p33) -- line: 207
        -- upvalues: v57 (copy), n4 (ref), connection (ref)
        n4 += p33

        if v57(n4) then
            connection:Disconnect()
        end
    end)
    self._animation = connection
end

function t1._init(p34) -- line: 563
    p34:_start()
end

function t1:GetAppliedSecondsValue() -- line: 569
    return self._appliedSeconds
end

function t1:IsComplete() -- line: 575
    return self._visualFinished and not self._pendingCommit
end

function t1:IsBillboardFadeFinished() -- line: 579
    return self._billboardFadeFinished
end

function t1:SetTransform(p39, p40, p41) -- line: 585
    -- upvalues: t (copy), v1 (copy)
    t.strict(t.CFrame)(p39)
    t.strict(v1)(p40)
    t.strict(v1)(p41)
    self._basePivot = p39
    self._startScale = p40
    self._targetScale = p41
    self:_refreshNightScaleRange()
end

function t1:AcknowledgeRecord(p43) -- line: 600
    -- upvalues: ServerClock (copy), AreaEggCycle (copy), EggRecords (copy), Eggs (copy)
    assert(Eggs.SchemaValidation.RuntimeEggRecord(p43), "Invalid runtime egg record")
    self._record = p43
    self._growthSpeedMultiplier = p43.GrowthSpeedMultiplier

    local Placement = p43.Placement

    if Placement ~= nil and Placement.ReadyAt == nil then
        local v60 = EggRecords.CommittedNightCredit(p43, self._nightPeriodIndex)

        self._committedNightCreditSeconds = v60

        local v61 = EggRecords.GrowthSecondsRemaining(p43, self._nightStartsAt, self._growthSpeedMultiplier) + v60

        self._remainingAtNightfall = v61
        self._nightTargetCreditSeconds = math.min(AreaEggCycle.NightGrowthSkipSeconds, v61)
        self._skipSeconds = math.max(0, self._nightTargetCreditSeconds - v60)
        self:_refreshNightScaleRange()
        self:_setAppliedSeconds(self:_getAppliedSecondsAt(ServerClock.Now()))

        if self._nightTargetCreditSeconds - 0.05 <= v60 then
            self._pendingCommit = false
        end

        return
    end

    self:_setAppliedSeconds(0)
    self._pendingCommit = false
end

function t1:CancelVisual() -- line: 633
    if not (self._visualFinished or self._visualFinishing) then
        task.spawn(self._finishVisuals, self, false)
    end
end

function t1:Destroy() -- line: 640
    -- upvalues: EggActionMovement (copy)
    if self._destroyed then
        return
    end

    self._destroyed = true

    local _animation = self._animation

    if _animation ~= nil then
        _animation:Disconnect()
        self._animation = nil
    end

    self._visualTrove:Destroy()
    self._lifecycleTrove:Destroy()

    if self._model.Parent ~= nil then
        EggActionMovement.SetPivot(self._model, self._basePivot)
    end
end

return t1
