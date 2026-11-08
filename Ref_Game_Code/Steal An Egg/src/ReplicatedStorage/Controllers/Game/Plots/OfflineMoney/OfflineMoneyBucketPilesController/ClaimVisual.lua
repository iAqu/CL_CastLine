-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.intersection(t.numberMin(0), t.numberMaxExclusive(1e999))
local MoneyPiles = require(script.Parent.MoneyPiles)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t1 = {}

t1.__index = t1
t1.__class = "OfflineMoneyClaimVisual"

local v2 = Color3.new(1, 1, 1)
local Assets = ReplicatedStorage.Assets
local ClaimArea = Assets.Models.ClaimArea

assert(ClaimArea:IsA("BasePart"), "ReplicatedStorage.Assets.Models.ClaimArea must be a BasePart")

local OfflineCash = Assets.Billboards.OfflineCash

assert(OfflineCash:IsA("BillboardGui"), "ReplicatedStorage.Assets.Billboards.OfflineCash must be a BillboardGui")

function t1.new(p1, p2, p3) -- line: 67
    -- upvalues: t (copy), v1 (copy), MoneyPiles (copy), Trove (copy), t1 (copy), ClaimArea (copy), OfflineCash (copy)
    t.strict(v1)(p1)
    t.strict(t.instanceIsA("BasePart"))(p2)
    t.strict(t.Instance)(p3)

    local self = setmetatable({}, t1)
    local v4 = Trove.new()
    local Model = Instance.new("Model")

    Model.Name = "LocalOfflineMoneyClaim"
    Model.Parent = p3

    local clone = ClaimArea:Clone()

    clone.Name = "OfflineMoneyClaimArea"
    clone.CFrame = p2.CFrame + Vector3.new(0, 0.2, 0)
    clone.Anchored = true
    clone.CanCollide = false
    clone.CanTouch = false
    clone.CanQuery = false
    clone.Parent = Model

    local v5 = MoneyPiles.new(clone, Model)
    local clone2 = OfflineCash:Clone()

    clone2.Name = "OfflineMoneyClaimBillboard"
    clone2.AlwaysOnTop = true
    clone2.Parent = clone
    clone2.Enabled = true

    local Money = clone2.Money

    assert(Money and Money:IsA("TextLabel"), "OfflineCash.Money must be a TextLabel")
    self._trove = v4
    self._amount = p1
    self._rootModel = Model
    self._claimArea = clone
    self._generatedMoney = v5
    self._billboard = clone2
    self._billboardBaseSize = clone2.Size
    self._billboardPulseTween = nil
    self._billboardTextBlinkTween = nil
    self._billboardPulseActive = false
    self._moneyLabel = Money
    self._moneyLabelBaseTextColor = self._moneyLabel.TextColor3
    v4:Add(Model)
    v4:Add(function() -- line: 118
        -- upvalues: v5 (copy)
        v5:Destroy()
    end)
    v4:Add(v5.BillboardAdorneeChanged:Connect(function() -- line: 120
        -- upvalues: self (copy)
        self:_syncBillboardAdornee()
    end))
    self:Update(p1, p2)

    return self
end

function t1._formatMoney(p4) -- line: 132
    -- upvalues: Simple (copy)
    return "$" .. Simple.FormatCompact(math.max(p4, 0), "precision-integer")
end

function t1:_scaleBillboardSize(p6) -- line: 136
    return UDim2.new(self.X.Scale * p6, math.round(self.X.Offset * p6), self.Y.Scale * p6, (math.round(self.Y.Offset * p6)))
end

function t1:_stopBillboardPulse() -- line: 145
    self._billboardPulseActive = false

    local _billboardPulseTween = self._billboardPulseTween

    if _billboardPulseTween then
        _billboardPulseTween:Cancel()
        self._billboardPulseTween = nil
    end

    local _billboardTextBlinkTween = self._billboardTextBlinkTween

    if _billboardTextBlinkTween then
        _billboardTextBlinkTween:Cancel()
        self._billboardTextBlinkTween = nil
    end

    self._billboard.Size = self._billboardBaseSize
    self._moneyLabel.TextColor3 = self._moneyLabelBaseTextColor
end

function t1:_syncBillboardPulse() -- line: 162
    -- upvalues: TweenService (copy), t1 (copy), v2 (copy)
    if not self._billboard.Enabled or not (self._amount > 0) then
        self:_stopBillboardPulse()

        return
    end

    if not self._billboardPulseActive then
        self._billboardPulseActive = true
        self._billboard.Size = self._billboardBaseSize
        self._moneyLabel.TextColor3 = self._moneyLabelBaseTextColor

        local tween = TweenService:Create(self._billboard, TweenInfo.new(0.8, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, -1, true), {
            Size = t1._scaleBillboardSize(self._billboardBaseSize, 1.75)
        })
        local tween2 = TweenService:Create(self._moneyLabel, TweenInfo.new(0.6400000000000001, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -1, true), {
            TextColor3 = v2
        })

        self._billboardPulseTween = tween
        self._billboardTextBlinkTween = tween2
        tween:Play()
        tween2:Play()
    end
end

function t1:_syncBillboardAdornee() -- line: 212
    -- upvalues: OfflineCash (copy)
    self._billboard.AlwaysOnTop = true

    local BillboardAdornee = self._generatedMoney:GetBillboardAdornee()

    if BillboardAdornee then
        self._billboard.Adornee = BillboardAdornee
        self._billboard.StudsOffset = OfflineCash.StudsOffset
    else
        self._billboard.Adornee = self._claimArea
        self._billboard.StudsOffset = Vector3.new(0, 6, 0)
    end
end

function t1:_syncBillboardText() -- line: 224
    -- upvalues: t1 (copy)
    self._moneyLabel.RichText = true
    self._moneyLabel.Text = ("OFFLINE CLAIM! <br/>%*"):format((t1._formatMoney(self._amount)))
end

function t1:Update(p12, p13) -- line: 233
    -- upvalues: t (copy), v1 (copy)
    t.strict(v1)(p12)
    t.strict(t.instanceIsA("BasePart"))(p13)
    self._amount = p12
    self._claimArea.CFrame = p13.CFrame + Vector3.new(0, 0.2, 0)
    self._generatedMoney:UpdateInstant(p12, true)
    self:_syncBillboardText()
    self:_syncBillboardAdornee()
    self._billboard.Enabled = p12 > 0
    self:_syncBillboardPulse()
end

function t1:SetBillboardEnabled(p15) -- line: 250
    -- upvalues: t (copy)
    t.strict(t.boolean)(p15)
    self._billboard.Enabled = p15 and self._amount > 0
    self:_syncBillboardPulse()
end

function t1:ContainsWorldPosition(p17) -- line: 259
    -- upvalues: t (copy)
    t.strict(t.Vector3)(p17)

    local v12 = self._claimArea.CFrame:PointToObjectSpace(p17)
    local v13 = self._claimArea.Size * 0.5

    if self._claimArea:IsA("Part") and self._claimArea.Shape == Enum.PartType.Cylinder then
        local v14 = math.abs(v12.X) < v13.X
        local v15 = math.min(v13.Y, v13.Z)
        local v16 = v12.Y * v12.Y + v12.Z * v12.Z

        return v14 and v16 < v15 * v15
    end

    if not (math.abs(v12.X) < v13.X) then
        return false
    end

    return math.abs(v12.Z) < v13.Z
end

function t1:PlayClaim() -- line: 280
    self._billboard.Enabled = false
    self:_stopBillboardPulse()
    self._generatedMoney:PlayCollectReset()
end

function t1:Destroy() -- line: 286
    self:_stopBillboardPulse()
    self._trove:Destroy()
end

return t1
