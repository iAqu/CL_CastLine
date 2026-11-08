-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuardEscapePrediction = require(ReplicatedStorage.Shared.Modules.GuardAreas.GuardEscapePrediction)
local GuardEscapeRequirement = require(ReplicatedStorage.Shared.Modules.GuardAreas.GuardEscapeRequirement)
local RequiredSpeedSign = require(script.Parent.Parent.Parent.GUI.GuardAreas.RequiredSpeedSign)
local SpeedPowerProjection
local TreadmillUtil = require(ReplicatedStorage.Shared.Util.TreadmillUtil)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t = require(ReplicatedStorage.Packages.t)
local t1 = {}

t1.__index = t1
t1.__class = "GuardEscapeSignController"

function t1.new(p1) -- line: 30
    -- upvalues: ReplicatedStorage (copy), GuardEscapeRequirement (copy), RequiredSpeedSign (copy), SpeedPowerProjection (ref), Trove (copy), t (copy), t1 (copy)
    t.strict(t.instanceIsA("Model"))(p1)

    local self = setmetatable({}, t1)

    self._areaModel = p1
    self._destroyed = false
    self._requiredSpeedSign = RequiredSpeedSign.new(p1)
    self._trove = Trove.new()
    self._trove:Add(self._requiredSpeedSign)
    self._trove:Add(p1:GetAttributeChangedSignal(GuardEscapeRequirement.SIGN_SPEEDS_ATTRIBUTE):Connect(function() -- line: 46
        -- upvalues: self (copy)
        self:_render()
    end))
    task.spawn(function() -- line: 50
        -- upvalues: self (copy), ReplicatedStorage (copy), SpeedPowerProjection (ref)
        local SpeedPowerProjection2 = require(ReplicatedStorage.Client.SpeedPowerProjection)

        if self._destroyed then
            return
        end

        SpeedPowerProjection = SpeedPowerProjection2
        self._trove:Add(SpeedPowerProjection2.Changed:Connect(function() -- line: 54
            -- upvalues: self (copy)
            self:_render()
        end))
        self:_render()
    end)
    self:_render()

    return self
end

function t1:_render() -- line: 61
    -- upvalues: GuardEscapePrediction (copy), GuardEscapeRequirement (copy), SpeedPowerProjection (ref), TreadmillUtil (copy)
    local Attribute = self._areaModel:GetAttribute(GuardEscapeRequirement.SIGN_SPEEDS_ATTRIBUTE)

    if SpeedPowerProjection ~= nil and typeof(Attribute) == "Vector2" and Attribute.X >= 0 and Attribute.X < 1e999 and Attribute.Y >= 0 and Attribute.Y < 1e999 then
        self._requiredSpeedSign:SetSpeedPowerRequirement(Attribute.X)
        self._requiredSpeedSign:SetSlowdownTolerance(GuardEscapePrediction.ResolveSlowdownTolerance(Attribute.Y, TreadmillUtil.SpeedPowerToWalkSpeed(SpeedPowerProjection.ReadProjected())))
    else
        self._requiredSpeedSign:SetLoading()
    end
end

function t1:Destroy() -- line: 89
    self._destroyed = true
    self._trove:Destroy()
end

return t1
