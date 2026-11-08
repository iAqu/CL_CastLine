-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local EggActionMovement = require(script.Parent.EggActionMovement)
local t = require(ReplicatedStorage.Packages.t)
local t1 = {}

t1.__index = t1
t1.__class = "EggGrowthAnimation"

function t1.new(p1, p2, p3) -- line: 40
    -- upvalues: t (copy), t1 (copy)
    t.strict(t.instanceIsA("Model"))(p1)
    t.strict(t.CFrame)(p2)
    t.strict(t.number)(p3)
    assert(p3 > 0, "Jump height multiplier must be positive")

    local self = setmetatable({}, t1)

    self._model = p1
    self._basePivot = p2
    self._jumpHeightMultiplier = p3
    self._animation = nil
    self._destroyed = false

    return self
end

function t1:_resetVisual() -- line: 64
    -- upvalues: EggActionMovement (copy)
    local _model = self._model

    if _model:IsDescendantOf(game) then
        EggActionMovement.SetPivot(_model, self._basePivot)
    end
end

function t1:SetBasePivot(p6) -- line: 75
    -- upvalues: t (copy)
    t.strict(t.CFrame)(p6)
    self._basePivot = p6

    if not self:IsPlaying() then
        self:_resetVisual()
    end
end

function t1:IsPlaying() -- line: 84
    return self._animation ~= nil
end

function t1:Play() -- line: 88
    -- upvalues: RunService (copy), TweenService (copy), EggActionMovement (copy)
    if self._destroyed or self:IsPlaying() or not self._model:IsDescendantOf(game) then
        return false
    end

    local function step(p9) -- line: 93
        -- upvalues: self (copy), TweenService (copy), EggActionMovement (copy)
        local v3, v4, v5

        if self._destroyed then
            v5 = true
        elseif self._model:IsDescendantOf(game) then
            v3 = math.clamp(p9, 0, 1)
            v4 = if v3 < 0.5 then TweenService:GetValue(v3 * 2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) else 1 - TweenService:GetValue((v3 - 0.5) * 2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
            v5 = false
        else
            v5 = true
        end

        if v5 then
            return true
        end

        local v6 = 1 - TweenService:GetValue(v3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local v8 = math.sin(v3 * 3.141592653589793 * 2 * 4) * 0.06981317007977318 * v6
        local v9 = 0.85 * self._jumpHeightMultiplier * v4

        EggActionMovement.SetPivot(self._model, self._basePivot * CFrame.new(0, v9, 0) * CFrame.Angles(0, 0, v8))

        return p9 >= 1
    end

    local n1 = 0
    local connection

    connection = RunService.PreRender:Connect(function(p10) -- line: 122
        -- upvalues: self (copy), step (copy), n1 (ref), connection (ref)
        n1 = math.min(n1 + p10, 0.55)

        if not step(n1 / 0.55) then
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

function t1:Cancel() -- line: 143
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

function t1:Destroy() -- line: 156
    if not self._destroyed then
        self:Cancel()
        self._destroyed = true
    end
end

return t1
