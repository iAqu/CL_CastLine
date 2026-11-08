-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local EggActionMovement = require(script.Parent.EggActionMovement)
local t = require(ReplicatedStorage.Packages.t)
local t1 = {}

t1.__index = t1
t1.__class = "PlacedEggReadyPulse"

function t1.new(p1, p2, p3) -- line: 47
    -- upvalues: t (copy), t1 (copy)
    t.strict(t.instanceIsA("Model"))(p1)
    t.strict(t.CFrame)(p2)
    t.strict(t.number)(p3)

    local self = setmetatable({}, t1)

    self._model = p1
    self._highlight = nil
    self._basePivot = p2
    self._baseScale = p3
    self._animation = nil
    self._destroyed = false

    return self
end

function t1:_createHighlight() -- line: 71
    local Highlight = Instance.new("Highlight")

    Highlight.Name = "ReadyEggPulseHighlight"
    Highlight.Adornee = self._model
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.FillColor = Color3.new(1, 1, 1)
    Highlight.FillTransparency = 1
    Highlight.OutlineTransparency = 1
    Highlight.Parent = self._model
    self._highlight = Highlight

    return Highlight
end

function t1:_destroyHighlight() -- line: 85
    local _highlight = self._highlight

    if _highlight ~= nil then
        self._highlight = nil
        _highlight:Destroy()
    end
end

function t1:_resetVisual() -- line: 95
    -- upvalues: EggActionMovement (copy)
    local _model = self._model

    if _model:IsDescendantOf(game) then
        _model:ScaleTo(self._baseScale)
        EggActionMovement.SetPivot(_model, self._basePivot)
    end

    self:_destroyHighlight()
end

function t1:SetTransform(p8, p9) -- line: 109
    -- upvalues: t (copy)
    t.strict(t.CFrame)(p8)
    t.strict(t.number)(p9)
    self._basePivot = p8
    self._baseScale = p9
end

function t1:IsPlaying() -- line: 121
    return self._animation ~= nil
end

function t1:Play() -- line: 125
    -- upvalues: RunService (copy), TweenService (copy), EggActionMovement (copy)
    if self._destroyed or self:IsPlaying() or not self._model:IsDescendantOf(game) then
        return false
    end

    self:_resetVisual()

    local function step(p12) -- line: 132
        -- upvalues: self (copy), TweenService (copy), EggActionMovement (copy)
        if self._destroyed or not self._model:IsDescendantOf(game) then
            return true
        end

        local v2 = math.clamp(p12, 0, 1) * 1.05
        local _model, _basePivot, _baseScale = self._model, self._basePivot, self._baseScale

        if v2 < 0.25 then
            local v3 = v2 / 0.25
            local v4 = 1 - TweenService:GetValue(v3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local v6 = math.sin(v3 * 3.141592653589793 * 2 * 3) * 0.05235987755982989 * v4

            _model:ScaleTo(_baseScale)
            EggActionMovement.SetPivot(_model, _basePivot * CFrame.Angles(0, 0, v6))

            return false
        end

        local v7 = v2 - 0.25

        if v7 < 0.6 then
            local v8 = v7 / 0.6
            local Value = TweenService:GetValue(v8, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
            local v10 = math.sin(v8 * 3.141592653589793);

            (self._highlight or self:_createHighlight()).FillTransparency = 1 - v10 * 0.9
            _model:ScaleTo(_baseScale * (1 + 0.19999999999999996 * Value))
            EggActionMovement.SetPivot(_model, _basePivot)

            return false
        end

        self:_destroyHighlight()
        _model:ScaleTo(_baseScale * (1.2 + -0.19999999999999996 * TweenService:GetValue(math.clamp((v7 - 0.6) / 0.2, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out)))
        EggActionMovement.SetPivot(_model, _basePivot)

        return p12 >= 1
    end

    local n1 = 0
    local connection

    connection = RunService.PreRender:Connect(function(p13) -- line: 187
        -- upvalues: self (copy), step (copy), n1 (ref), connection (ref)
        n1 = math.min(n1 + p13, 1.05)

        if not step(n1 / 1.05) then
            return
        end

        connection:Disconnect()

        if self._animation == connection then
            self._animation = nil

            if not self._destroyed then
                self:_resetVisual()
            end
        end
    end)
    self._animation = connection

    return true
end

function t1:Cancel() -- line: 208
    local _animation = self._animation

    if _animation == nil then
        return
    end

    self._animation = nil
    _animation:Disconnect()

    if not self._destroyed then
        self:_resetVisual()
    end
end

function t1:Destroy() -- line: 221
    if self._destroyed then
        return
    end

    self:Cancel()
    self._destroyed = true
    self:_destroyHighlight()
end

return t1
