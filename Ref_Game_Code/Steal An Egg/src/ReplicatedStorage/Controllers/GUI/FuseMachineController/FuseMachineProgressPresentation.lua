-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Fusion = require(game:GetService("ReplicatedStorage").Shared.Flags.GameplayBalance).Fusion
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local t = require(ReplicatedStorage.Packages.t)

require(ReplicatedStorage.Shared.Types.FuseMachine)

local Log = require(ReplicatedStorage.Packages.Log)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = Log.new()
local t1 = {}

t1.__index = t1
t1.__class = "FuseMachineProgressPresentation"

local t2 = {
    "LeftBar",
    "MiddleBar",
    "RightBar"
}
local v2 = Color3.new(1, 1, 1)
local v3 = Color3.new(0, 0, 0)
local v4 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v5 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v6 = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)

function t1.new(p1, p2) -- line: 80
    -- upvalues: t (copy), Trove (copy), t1 (copy), t2 (copy)
    t.strict(t.instanceIsA("Frame"))(p1)
    t.strict(t.instanceIsA("Frame"))(p2)

    local self = setmetatable({}, t1)

    self._barFills = {}
    self._barFilled = {}
    self._barLitTransparencies = {}
    self._barOriginalVisible = {}
    self._barTroves = {}
    self._barTweenInfo = TweenInfo.new(p2:GetAttribute("FillFadeSeconds") or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    for v8, v9 in ipairs(t2) do
        local v10 = p2:FindFirstChild(v9)

        assert(v10 ~= nil, (("PetFuse.FuseMain.DesignBars.%* is missing"):format(v9)))

        local Fill = v10:FindFirstChild("Fill")

        assert(Fill ~= nil and Fill:IsA("ImageLabel"), (("PetFuse.FuseMain.DesignBars.%*.Fill must be an ImageLabel"):format(v9)))
        self._barFills[v8] = Fill
        self._barLitTransparencies[v8] = Fill.ImageTransparency
        self._barOriginalVisible[v8] = Fill.Visible
        self._barTroves[v8] = Trove.new()
    end

    self._icon = p1.OutputEgg
    t.strict(t.instanceIsA("ImageLabel"))(self._icon)
    self._iconOriginalBackgroundColor = self._icon.BackgroundColor3
    self._iconOriginalColor = self._icon.ImageColor3
    self._iconOriginalImage = self._icon.Image
    self._iconOriginalTransparency = self._icon.ImageTransparency
    self._iconScale = Instance.new("UIScale")
    self._iconScale.Name = "FuseProgressScale"
    self._iconScale.Parent = self._icon
    self._iconOriginalScale = self._iconScale.Scale
    self._iconTrove = Trove.new()
    self._outputFill = p1.Fill
    t.strict(t.instanceIsA("Frame"))(self._outputFill)
    self._outputOriginalPosition = self._outputFill.Position
    self._outputOriginalSize = self._outputFill.Size
    self._outputAnchorY = self._outputFill.AnchorPoint.Y
    self._outputBottomScale = self._outputOriginalPosition.Y.Scale + (1 - self._outputAnchorY) * self._outputOriginalSize.Y.Scale
    self._outputBottomOffset = self._outputOriginalPosition.Y.Offset + (1 - self._outputAnchorY) * self._outputOriginalSize.Y.Offset
    self._outputTrove = Trove.new()
    self._selectedCount = nil
    self._trove = Trove.new()
    self._trove:Add(self._iconScale)
    self._trove:Add(self._iconTrove)
    self._trove:Add(self._outputTrove)

    for _, v15 in ipairs(self._barTroves) do
        self._trove:Add(v15)
    end

    return self
end

function t1:_setBarFilled(p4, p5, p6) -- line: 156
    -- upvalues: TweenService (copy)
    if self._barFilled[p4] == p5 then
        return
    end

    self._barFilled[p4] = p5

    local v16 = self._barTroves[p4]

    v16:Clean()

    local v17 = self._barFills[p4]
    local v18 = if p5 then self._barLitTransparencies[p4] else 1

    if not p6 then
        v17.ImageTransparency = v18
        v17.Visible = p5

        return
    end

    if p5 and not v17.Visible then
        v17.ImageTransparency = 1
        v17.Visible = true
    end

    local tween = TweenService:Create(v17, self._barTweenInfo, {
        ImageTransparency = v18
    })

    v16:Add(function() -- line: 190
        -- upvalues: tween (copy)
        tween:Cancel()
        tween:Destroy()
    end)
    v16:Add(tween.Completed:Connect(function(p7) -- line: 195
        -- upvalues: self (copy), p4 (copy), v17 (copy)
        if p7 == Enum.PlaybackState.Completed then
            v17.Visible = self._barFilled[p4]
        end
    end))
    tween:Play()
end

function t1:_setOutputProgress(p9, p10) -- line: 205
    -- upvalues: Fusion (copy), TweenService (copy), v4 (copy)
    self._outputTrove:Clean()

    local v20 = math.min(p9 / Fusion.INPUT_COUNT, 1)
    local v21 = UDim2.new(self._outputOriginalSize.X.Scale, self._outputOriginalSize.X.Offset, v20, 0)
    local v22 = UDim2.new(self._outputOriginalPosition.X.Scale, self._outputOriginalPosition.X.Offset, self._outputBottomScale - (1 - self._outputAnchorY) * v20, self._outputBottomOffset)

    if not p10 then
        self._outputFill.Size = v21
        self._outputFill.Position = v22

        return
    end

    local tween = TweenService:Create(self._outputFill, v4, {
        Position = v22,
        Size = v21
    })

    self._outputTrove:Add(function() -- line: 236
        -- upvalues: tween (copy)
        tween:Cancel()
        tween:Destroy()
    end)
    tween:Play()
end

function t1:_setIncompleteIcon() -- line: 244
    -- upvalues: v3 (copy)
    self._iconTrove:Clean()
    self._icon.ImageTransparency = 0.1
    self._icon.ImageColor3 = v3
    self._icon.BackgroundColor3 = v3
    self._iconScale.Scale = self._iconOriginalScale
end

function t1:_setReadyIcon(p13) -- line: 254
    -- upvalues: Fusion (copy), TweenService (copy), v2 (copy), v5 (copy), v6 (copy)
    self._iconTrove:Clean()
    self._icon.ImageTransparency = 0
    self._icon.ImageColor3 = v2
    self._icon.BackgroundColor3 = v2
    self._iconScale.Scale = self._iconOriginalScale

    if not p13 then
        return
    end

    self._iconScale.Scale = 0.8

    local tween = TweenService:Create(self._iconScale, v5, {
        Scale = self._iconOriginalScale * 1.2
    })

    self._iconTrove:Add(function() -- line: 272
        -- upvalues: tween (copy)
        tween:Cancel()
        tween:Destroy()
    end)
    self._iconTrove:Add(tween.Completed:Connect(function(p14) -- line: 277
        -- upvalues: self (copy), Fusion (copy), TweenService (copy), v6 (copy)
        if p14 == Enum.PlaybackState.Completed and self._selectedCount == Fusion.INPUT_COUNT then
            local tween = TweenService:Create(self._iconScale, v6, {
                Scale = self._iconOriginalScale
            })

            self._iconTrove:Add(function() -- line: 288
                -- upvalues: tween (copy)
                tween:Cancel()
                tween:Destroy()
            end)
            tween:Play()
        end
    end))
    tween:Play()
end

function t1:Update(p16, p17) -- line: 302
    -- upvalues: Fusion (copy), t (copy)
    t.strict(t.array(t.boolean))(p16)
    assert(#p16 == 3, "Fuse progress needs one flag per input slot")
    t.strict(t.optional(t.string))(p17)

    local n1 = 0

    for _, v24 in ipairs(p16) do
        if v24 then
            n1 += 1
        end
    end

    if n1 == 0 then
        self._icon.Image = self._iconOriginalImage
    else
        assert(p17 ~= nil and p17 ~= "", "Selected FuseMachine category requires an egg icon")
        self._icon.Image = p17
    end

    local _selectedCount = self._selectedCount

    self:_setBarFilled(1, p16[1], _selectedCount ~= nil)
    self:_setBarFilled(2, p16[2], _selectedCount ~= nil)
    self:_setBarFilled(3, p16[3], _selectedCount ~= nil)

    if _selectedCount ~= n1 then
        self._selectedCount = n1

        if _selectedCount ~= nil then
            self:_setOutputProgress(n1, true)

            if n1 == Fusion.INPUT_COUNT then
                self:_setReadyIcon(true)
            else
                self:_setIncompleteIcon()
            end
        else
            self:_setOutputProgress(n1, false)

            if n1 == Fusion.INPUT_COUNT then
                self:_setReadyIcon(false)
            else
                self:_setIncompleteIcon()
            end
        end
    end
end

function t1:Destroy() -- line: 361
    -- upvalues: v1 (copy)
    self._trove:Destroy()

    for v26, v27 in ipairs(self._barFills) do
        v27.ImageTransparency = self._barLitTransparencies[v26]
        v27.Visible = self._barOriginalVisible[v26]
    end

    self._outputFill.Position = self._outputOriginalPosition
    self._outputFill.Size = self._outputOriginalSize
    self._icon.Image = self._iconOriginalImage
    self._icon.ImageTransparency = self._iconOriginalTransparency
    self._icon.ImageColor3 = self._iconOriginalColor
    self._icon.BackgroundColor3 = self._iconOriginalBackgroundColor
    v1:AtTrace():Log("Destroyed FuseMachine progress presentation")
end

return t1
