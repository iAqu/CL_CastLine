-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuardRecovery = require(game:GetService("ReplicatedStorage").Shared.Flags.GameplayBalance).GuardRecovery
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Log = require(ReplicatedStorage.Packages.Log)
local t = require(ReplicatedStorage.Packages.t)
local v1 = Log.new()
local t1 = {}

t1.__index = t1
t1.__class = "GuardMovementRecovery"

function t1.new(p1, p2) -- line: 40
    -- upvalues: t (copy), t1 (copy)
    t.strict(t.instanceIsA("BasePart"))(p1)
    t.strict(t.instanceIsA("BasePart"))(p2)

    local self = setmetatable({}, t1)

    self._ground = p2
    self._lastProgressPosition = nil
    self._lastProgressTime = 0
    self._returnHomeStartedAt = nil
    self._root = p1

    return self
end

function t1:_getHorizontalDistance(p4) -- line: 59
    local v3 = self._root.Position - p4

    return Vector3.new(v3.X, 0, v3.Z).Magnitude
end

function t1:Reset() -- line: 72
    self._lastProgressPosition = nil
    self._lastProgressTime = 0
    self._returnHomeStartedAt = nil
end

function t1:ShouldRecoverFromFall() -- line: 78
    -- upvalues: GuardRecovery (copy), v1 (copy)
    if self._root.Position.Y >= self._ground.Position.Y - GuardRecovery.FALL_RECOVERY_DEPTH then
        return false
    end

    v1:AtWarning():Log((("Guard fell below the world and requires recovery: %*"):format((self._root:GetFullName()))))

    return true
end

function t1:Step(p8, p9, p10) -- line: 88
    -- upvalues: GuardRecovery (copy), t (copy), v1 (copy)
    t.strict(t.number)(p8)
    t.strict(t.boolean)(p9)
    t.strict(t.boolean)(p10)

    if p10 then
        local _returnHomeStartedAt = self._returnHomeStartedAt

        if _returnHomeStartedAt ~= nil then
            if p8 - _returnHomeStartedAt >= GuardRecovery.RETURN_HOME_TIMEOUT then
                v1:AtWarning():Log((("Guard return-home timeout triggered for %*"):format((self._root:GetFullName()))))
                self:Reset()

                return true
            end
        else
            self._returnHomeStartedAt = p8
        end
    else
        self._returnHomeStartedAt = nil
    end

    if p9 then
        local _lastProgressPosition = self._lastProgressPosition

        if _lastProgressPosition == nil or self:_getHorizontalDistance(_lastProgressPosition) >= GuardRecovery.MINIMUM_HORIZONTAL_PROGRESS then
            self._lastProgressPosition = self._root.Position
            self._lastProgressTime = p8

            return false
        end

        if p8 - self._lastProgressTime < GuardRecovery.STUCK_TIMEOUT then
            return false
        end

        v1:AtWarning():Log((("Guard stuck recovery triggered for %*"):format((self._root:GetFullName()))))
        self:Reset()

        return true
    end

    self._lastProgressPosition = nil
    self._lastProgressTime = 0

    return false
end

return t1
