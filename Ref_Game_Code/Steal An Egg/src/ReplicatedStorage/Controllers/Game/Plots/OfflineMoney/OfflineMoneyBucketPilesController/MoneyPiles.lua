-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.intersection(t.numberMin(0), t.numberMaxExclusive(1e999))
local EmitAt = require(ReplicatedStorage.Shared.Utils.VFX).EmitAt
local Log = require(ReplicatedStorage.Packages.Log)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t1 = {}

t1.__index = t1
t1.__class = "OfflineGeneratedMoney"

local v2 = Color3.new(1, 1, 1)
local v3 = Log.new()
local BuckPiles = ReplicatedStorage.Assets.Models.BuckPiles

assert(BuckPiles:IsA("Folder"), "ReplicatedStorage.Assets.Models.BuckPiles must be a Folder")

local MoneyCollect = ReplicatedStorage.Assets.VFX.MoneyCollect

assert(MoneyCollect:IsA("Folder"), "ReplicatedStorage.Assets.VFX.MoneyCollect must be a Folder")

function t1.new(p1, p2) -- line: 84
    -- upvalues: t (copy), Signal (copy), Trove (copy), t1 (copy), BuckPiles (copy)
    t.strict(t.instanceIsA("BasePart"))(p1)
    t.strict(t.Instance)(p2)

    local self = setmetatable({}, t1)
    local Folder = Instance.new("Folder")

    Folder.Name = "LocalOfflineGeneratedMoneyPiles"
    Folder.Parent = p2

    local v5 = Trove.new()

    self._trove = v5
    self._animationTrove = Trove.new()
    self._bucketRoot = p1
    self._runtimeFolder = Folder
    self._stages = {}
    self._currentStageIndex = 0
    self._lastStageCenterCFrame = nil
    self._destroyed = false
    self._lastAdornee = nil
    self.BillboardAdorneeChanged = Signal.new()
    v5:Add(Folder)
    v5:Add(self._animationTrove)
    v5:Add(p1:GetPropertyChangedSignal("CFrame"):Connect(function() -- line: 111
        -- upvalues: p1 (copy), self (copy), t1 (copy)
        for _, v6 in ipairs(self._stages) do
            t1._pivotRootToBucket(v6.model, v6.rootPart, p1)
        end
    end))

    local t3 = {}

    for _, child in ipairs(BuckPiles:GetChildren()) do
        if child:IsA("Model") then
            t3[#t3 + 1] = child
        end
    end

    table.sort(t3, function(p3, p4) -- line: 126
        -- upvalues: t1 (copy)
        return t1._getStageSortIndex(p3) < t1._getStageSortIndex(p4)
    end)
    assert(#t3 == 3, "BuckPiles must contain exactly three stage models")

    for _, v8 in ipairs(t3) do
        self._stages[#self._stages + 1] = self:_buildStage(v8)
    end

    self:_hideAllStages()

    return self
end

function t1:_getStageSortIndex() -- line: 146
    local v9 = tonumber(self.Name)

    assert(v9, (("BuckPiles stage %* must be numerically named"):format(self.Name)))

    return v9
end

function t1:_readVector3Attribute(p7) -- line: 152
    -- upvalues: t (copy)
    local Attribute = self:GetAttribute(p7)

    t.strict(t.Vector3)(Attribute)

    return Attribute
end

function t1:_readCFrameAttribute(p9) -- line: 158
    -- upvalues: t (copy)
    local Attribute = self:GetAttribute(p9)

    t.strict(t.CFrame)(Attribute)

    return Attribute
end

function t1:_getVisibleTransparency() -- line: 164
    if self.Transparency >= 1 then
        return 0
    end

    return self.Transparency
end

function t1:_pivotRootToBucket(p12, p13) -- line: 168
    local Pivot = self:GetPivot()

    self:PivotTo(p13.CFrame * p12.CFrame:Inverse() * Pivot)
end

function t1:_createTopAttachment() -- line: 178
    -- upvalues: t (copy)
    local GeneratedMoneyTopAttachment = self:FindFirstChild("GeneratedMoneyTopAttachment")

    if GeneratedMoneyTopAttachment then
        t.strict(t.instanceIsA("Attachment"))(GeneratedMoneyTopAttachment)

        return GeneratedMoneyTopAttachment
    end

    local Attachment = Instance.new("Attachment")

    Attachment.Name = "GeneratedMoneyTopAttachment"
    Attachment.Parent = self

    return Attachment
end

function t1._createHighlight(p15) -- line: 191
    -- upvalues: v2 (copy)
    local Highlight = Instance.new("Highlight")

    Highlight.Name = "OfflineMoneyBucketHighlight"
    Highlight.Adornee = p15
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight.FillTransparency = 1
    Highlight.OutlineColor = v2
    Highlight.OutlineTransparency = 0
    Highlight.Enabled = false
    Highlight.Parent = p15

    return Highlight
end

function t1:_syncTopAttachment() -- line: 204
    local BoundingBox, BoundingBox2 = self.model:GetBoundingBox()
    local v11 = BoundingBox.Position + BoundingBox.UpVector * (BoundingBox2.Y * 0.5)

    self.topAttachment.Position = self.mainPart.CFrame:PointToObjectSpace(v11)
end

function t1:_collectAnimatedParts(p18) -- line: 211
    -- upvalues: t1 (copy), v3 (copy)
    local t4 = {}

    for _, descendant in ipairs(self:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant ~= p18 then
            local v12 = descendant:GetAttribute("OriginalSize") ~= nil
            local v13 = descendant:GetAttribute("TargetSize") ~= nil
            local v14 = descendant:GetAttribute("OriginalCFrame") ~= nil
            local v15 = descendant:GetAttribute("TargetCFrame") ~= nil

            if v12 or v13 or v14 or v15 then
                t4[#t4 + 1] = {
                    part = descendant,
                    originalSize = t1._readVector3Attribute(descendant, "OriginalSize"),
                    targetSize = t1._readVector3Attribute(descendant, "TargetSize"),
                    originalCFrame = t1._readCFrameAttribute(descendant, "OriginalCFrame"),
                    targetCFrame = t1._readCFrameAttribute(descendant, "TargetCFrame"),
                    visibleTransparency = t1._getVisibleTransparency(descendant)
                }
            end
        end
    end

    if #t4 == 0 then
        v3:AtWarning():Log((("BuckPiles stage %* has no animated part attributes"):format(self.Name)))
    end

    return t4
end

function t1:_setStageVisible(p20) -- line: 244
    for _, descendant in ipairs(self.model:GetDescendants()) do
        if descendant:IsA("BasePart") then
            if descendant == self.rootPart then
                descendant.Transparency = 1
            else
                local _OfflineGeneratedMoneyVisibleTransparency = descendant:GetAttribute("_OfflineGeneratedMoneyVisibleTransparency")

                descendant.Transparency = if not p20 or typeof(_OfflineGeneratedMoneyVisibleTransparency) ~= "number" then 1 else _OfflineGeneratedMoneyVisibleTransparency
            end
        end
    end

    self.highlight.Enabled = p20
end

function t1:_resetStageParts() -- line: 262
    -- upvalues: t1 (copy)
    local CFrame = self.rootPart.CFrame

    for _, v17 in ipairs(self.animatedParts) do
        v17.part.Size = v17.originalSize
        v17.part.CFrame = CFrame * v17.originalCFrame
    end

    t1._syncTopAttachment(self)
end

function t1:_applyStageAlpha(p23) -- line: 272
    -- upvalues: t1 (copy)
    local v18 = math.clamp(p23, 0, 1)
    local CFrame = self.rootPart.CFrame

    for _, v19 in ipairs(self.animatedParts) do
        v19.part.Size = v19.originalSize:Lerp(v19.targetSize, v18)
        v19.part.CFrame = CFrame * v19.originalCFrame:Lerp(v19.targetCFrame, v18)
        v19.part.Transparency = v19.visibleTransparency
    end

    t1._syncTopAttachment(self)
end

function t1:_buildStage(p25) -- line: 287
    -- upvalues: t (copy), t1 (copy)
    local clone = p25:Clone()

    clone.Name = ("OfflineGeneratedMoneyStage%*"):format(p25.Name)
    clone.Parent = self._runtimeFolder

    local RootPart = clone:FindFirstChild("RootPart")

    t.strict(t.instanceIsA("BasePart"))(RootPart)

    local Main = clone:FindFirstChild("Main")

    t.strict(t.instanceIsA("BasePart"))(Main)
    clone.PrimaryPart = RootPart
    t1._pivotRootToBucket(clone, RootPart, self._bucketRoot)

    for _, descendant in ipairs(clone:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant:SetAttribute("_OfflineGeneratedMoneyVisibleTransparency", t1._getVisibleTransparency(descendant))

            if descendant == RootPart then
                descendant.Transparency = 1
            end

            descendant.CanCollide = false
            descendant.CanTouch = false
            descendant.CanQuery = false
        end
    end

    local t6 = {
        index = t1._getStageSortIndex(p25),
        model = clone,
        rootPart = RootPart,
        mainPart = Main,
        highlight = t1._createHighlight(clone),
        topAttachment = t1._createTopAttachment(Main),
        animatedParts = t1._collectAnimatedParts(clone, RootPart)
    }

    t1._resetStageParts(t6)
    t1._setStageVisible(t6, false)

    return t6
end

function t1:_hideAllStages() -- line: 333
    -- upvalues: t1 (copy)
    for _, v20 in ipairs(self._stages) do
        t1._resetStageParts(v20)
        t1._setStageVisible(v20, false)
    end

    self._currentStageIndex = 0

    if self._lastAdornee ~= nil then
        self._lastAdornee = nil
        self.BillboardAdorneeChanged:Fire(nil)
    end
end

function t1:_fadeOutStages(p28) -- line: 346
    -- upvalues: TweenService (copy)
    local v21 = false

    for _, v22 in ipairs(self._stages) do
        v22.highlight.Enabled = false

        for _, descendant in ipairs(v22.model:GetDescendants()) do
            if descendant:IsA("BasePart") and descendant ~= v22.rootPart and descendant.Transparency < 1 then
                local tween = TweenService:Create(descendant, TweenInfo.new(p28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Transparency = 1
                })

                self._animationTrove:Add(tween)
                v21 = true
                tween:Play()
            end
        end
    end

    return v21
end

function t1:_getCollectAllEffectCFrame() -- line: 374
    local _currentStageIndex = if self._currentStageIndex > 0 then self._currentStageIndex else nil
    local v24 = if _currentStageIndex then self._stages[_currentStageIndex] else nil

    if v24 then
        return v24.mainPart.CFrame
    end

    return self._lastStageCenterCFrame or self._bucketRoot.CFrame
end

function t1._emitCollectAllCash(p30) -- line: 382
    -- upvalues: EmitAt (copy), MoneyCollect (copy)
    EmitAt(p30, MoneyCollect:GetChildren())
end

function t1:_setProgress(p32) -- line: 386
    -- upvalues: t1 (copy)
    local v25 = math.clamp(p32, 0, 1)
    local _stages = self._stages
    local v26 = #_stages

    if not (v26 <= 0) then
        if v25 <= 0 then
            self:_hideAllStages()
        else
            local v27 = v25 * v26
            local v29 = math.clamp(math.floor(v27) + 1, 1, v26)
            local v30 = if v25 >= 1 then 1 else v27 - (v29 - 1)

            for v31, v32 in ipairs(_stages) do
                local v33 = v31 == v29

                t1._setStageVisible(v32, v33)

                if v33 then
                    t1._applyStageAlpha(v32, v30)
                else
                    t1._resetStageParts(v32)
                end
            end

            self._currentStageIndex = v29
            self._lastStageCenterCFrame = _stages[v29].mainPart.CFrame

            local topAttachment = _stages[v29].topAttachment

            if self._lastAdornee ~= topAttachment then
                self._lastAdornee = topAttachment
                self.BillboardAdorneeChanged:Fire(topAttachment)
            end
        end
    end
end

function t1.UpdateInstant(p33, p34, p35) -- line: 428
    -- upvalues: t (copy), v1 (copy)
    t.strict(v1)(p34)
    t.strict(t.boolean)(p35)

    if not p35 or p34 <= 0 then
        p33:_hideAllStages()
    else
        p33:_setProgress((math.clamp(math.max(p34 - 1, 0) / 999999999, 0, 1)))
    end
end

function t1:PlayCollectReset() -- line: 447
    -- upvalues: Trove (copy), t1 (copy)
    self._animationTrove:Destroy()
    self._animationTrove = Trove.new()
    self._trove:Add(self._animationTrove)

    if self:_fadeOutStages(0.3) then
        t1._emitCollectAllCash(self:_getCollectAllEffectCFrame())
    end

    self._animationTrove:Add(task.delay(0.3, function() -- line: 457
        -- upvalues: self (copy)
        if not self._destroyed then
            self:_hideAllStages()
        end
    end))
end

function t1:GetBillboardAdornee() -- line: 466
    return self._lastAdornee
end

function t1:Destroy() -- line: 470
    self._destroyed = true
    self._trove:Destroy()
end

return t1
