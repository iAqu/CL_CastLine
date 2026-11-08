-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local t = require(ReplicatedStorage.Packages.t)
local Gears = require(ReplicatedStorage.Data.Gears)
local SurfaceButton = require(ReplicatedStorage.Client.UI.VFX.SurfaceButton)
local Trove = require(ReplicatedStorage.Packages.Trove)

require(script.Types.Interface)

local t1 = {}

t1.__index = t1
t1.__class = "AreaIndexProgressComponent"

local v1 = Color3.fromRGB(0, 182, 24)
local v2 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function gearIcon(p1) -- line: 40
    -- upvalues: Gears (copy)
    local v3 = Gears.Directory[p1]

    if v3 == nil then
        return ""
    end

    return v3.Icon
end

function t1.new(p2, p3) -- line: 49
    -- upvalues: Trove (copy), t1 (copy)
    local self = setmetatable({}, t1)

    self._view = p2
    self._onAction = p3
    self._sectionId = nil
    self._actionEnabled = false
    self._defaultTextColor = p2.TextLabel.TextColor3
    self._progressTween = nil
    self._trove = Trove.new()
    self:_init()

    return self
end

function t1:_setProgress(p5, p6) -- line: 69
    -- upvalues: TweenService (copy), v2 (copy)
    local _progressTween = self._progressTween

    if _progressTween then
        _progressTween:Cancel()
        _progressTween:Destroy()
    end

    local v5 = UDim2.fromScale(p5, 1)

    if p6 then
        self._view.Fill.Size = v5
    else
        local tween = TweenService:Create(self._view.Fill, v2, {
            Size = v5
        })

        self._progressTween = tween
        tween:Play()
    end
end

function t1:_render(p8, p9, p10, p11, p12, p13, p14) -- line: 91
    -- upvalues: t (copy), v1 (copy)
    t.strict(t.string)(p8)
    t.strict(t.string)(p9)
    t.strict(t.number)(p10)
    t.strict(t.number)(p11)
    t.strict(t.string)(p12)
    t.strict(t.boolean)(p13)
    t.strict(t.boolean)(p14)

    local _view = self._view
    local v6 = p11 > 0 and p11 <= p10
    local v7 = v6 and p14
    local v8 = if p11 == 0 then 0 else math.clamp(p10 / p11, 0, 1)

    self._sectionId = p8
    self._actionEnabled = v7
    _view.Active = v7
    _view.ImageLabel.Image = p9
    _view.ImageLabel.Visible = p9 ~= ""

    local TextLabel = _view.TextLabel

    if v6 then
        TextLabel.Text = p12
    else
        TextLabel.Text = ("%*/%*"):format(p10, p11)
    end

    local TextLabel2 = _view.TextLabel

    if not v6 or not p13 then
        TextLabel2.TextColor3 = self._defaultTextColor
    else
        TextLabel2.TextColor3 = v1
    end

    self:_setProgress(v8)
end

function t1.RenderAreaBat(p15, p16, p17, p18, p19, p20, p21) -- line: 132
    -- upvalues: t (copy), Gears (copy)
    t.strict(t.string)(p16)
    t.strict(t.string)(p17)
    t.strict(t.number)(p18)
    t.strict(t.number)(p19)
    t.strict(t.boolean)(p20)
    t.strict(t.boolean)(p21)

    local v10 = Gears.Directory[p17]

    p15:_render(p16, if v10 == nil then "" else v10.Icon, p18, p19, p21 and "Equipped" or "Equip Bat!", p21, not p21)
end

function t1.RenderGearClaim(p22, p23, p24, p25, p26, p27) -- line: 159
    -- upvalues: t (copy), Gears (copy)
    t.strict(t.boolean)(p27)

    local v11 = Gears.Directory[p24]

    p22:_render(p23, if v11 == nil then "" else v11.Icon, p25, p26, p27 and "CLAIMED!" or "CLAIM!", p27, not p27)
end

function t1.RenderCollection(p28, p29, p30, p31, p32) -- line: 180
    p28:_render(p29, p30, p31, p32, "COMPLETE!", true, false)
end

function t1:Destroy() -- line: 190
    local _progressTween = self._progressTween

    if _progressTween then
        _progressTween:Cancel()
        _progressTween:Destroy()
        self._progressTween = nil
    end

    self._teardown()
    self._trove:Destroy()
end

function t1:_init() -- line: 205
    -- upvalues: SurfaceButton (copy)
    self._teardown = SurfaceButton(self._view, 1.04, function() -- line: 206
        -- upvalues: self (copy)
        local _sectionId = self._sectionId

        if _sectionId ~= nil and self._actionEnabled then
            self._onAction(_sectionId)
        end
    end)
end

return t1
