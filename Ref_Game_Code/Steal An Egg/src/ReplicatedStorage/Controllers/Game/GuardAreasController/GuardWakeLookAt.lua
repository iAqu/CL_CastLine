-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local t = require(ReplicatedStorage.Packages.t)
local Player = require(ReplicatedStorage.Shared.Player)
local WaitFor = require(ReplicatedStorage.Packages.WaitFor)
local t1 = {}

t1.__index = t1
t1.__class = "GuardWakeLookAt"

local t2 = {
    Jungle = {
        AuthoredPitchAxis = Vector3.new(-0, -0, -1),
        BasePitch = 0.7853981633974483,
        MaxPitch = 1.3962634015954636,
        MinPitch = 0.17453292519943295,
        TargetPitchScale = -1
    }
}

function t1.new(p1) -- line: 80
    -- upvalues: t (copy), WaitFor (copy), t1 (copy), t2 (copy)
    t.strict(t.instanceIsA("Model"))(p1)

    local self = setmetatable({}, t1)
    local v2, v3 = WaitFor.Descendant(p1, "Head"):await()
    local HumanoidRootPart = p1:WaitForChild("HumanoidRootPart")
    local Parent = p1.Parent

    assert(v2 and v3 ~= nil, (("%* requires a Head descendant for wake look-at"):format((p1:GetFullName()))))
    assert(v3:IsA("BasePart"), (("%* must be a BasePart"):format((v3:GetFullName()))))
    assert(HumanoidRootPart:IsA("BasePart"), (("%* must be a BasePart"):format((HumanoidRootPart:GetFullName()))))
    assert(Parent ~= nil and Parent:IsA("Model"), (("%* requires an area Model parent"):format((p1:GetFullName()))))

    local HeadLookAtBoneName = p1:GetAttribute("HeadLookAtBoneName")
    local v10, v11

    if HeadLookAtBoneName ~= nil then
        t.strict(t.string)(HeadLookAtBoneName)

        local v17

        v17, v10 = WaitFor.Custom(function() -- line: 103
            -- upvalues: p1 (copy), HeadLookAtBoneName (copy)
            for _, descendant in ipairs(p1:GetDescendants()) do
                if descendant:IsA("Bone") and descendant.Name == HeadLookAtBoneName then
                    return descendant
                end
            end

            return nil
        end):await()
        assert(v17 and v10 ~= nil, (("%* requires Bone \"%*\" for HeadLookAtBoneName"):format(p1:GetFullName(), HeadLookAtBoneName)))
        assert(v10:IsA("Bone"), (("%* must be a Bone"):format((v10:GetFullName()))))
    else
        local HeadLookAtMotorName = p1:GetAttribute("HeadLookAtMotorName")

        t.strict(t.optional(t.string))(HeadLookAtMotorName)

        local v12 = HeadLookAtMotorName or "Head"
        local v13

        v13, v11 = WaitFor.Custom(function() -- line: 121
            -- upvalues: p1 (copy), v12 (copy)
            for _, descendant in ipairs(p1:GetDescendants()) do
                if descendant:IsA("Motor6D") and descendant.Name == v12 then
                    return descendant
                end
            end

            return nil
        end):await()
        assert(v13 and v11 ~= nil, (("%* requires Motor6D \"%*\" for wake look-at"):format(p1:GetFullName(), v12)))
        assert(v11:IsA("Motor6D"), (("%* must be a Motor6D"):format((v11:GetFullName()))))
    end

    local v21

    if v10 ~= nil then
        v21 = v10.WorldCFrame
    else
        assert(v11 ~= nil, (("%* wake look-at requires a Motor6D or Bone"):format((p1:GetFullName()))))

        local Part0 = v11.Part0

        assert(Part0 ~= nil, (("%* requires Part0 for wake look-at"):format((v11:GetFullName()))))
        v21 = Part0.CFrame * v11.C0
    end

    local v26 = t2[Parent.Name]
    local v27 = v21.Rotation:ToObjectSpace(HumanoidRootPart.CFrame.Rotation)

    if v26 ~= nil then
        assert(v10 ~= nil, (("%* area look override requires a Bone"):format((p1:GetFullName()))))
    end

    self._areaLookOverride = v26
    self._appliedOffset = CFrame.identity
    self._bone = v10
    self._currentOffset = CFrame.identity
    self._guardModel = p1
    self._isWaking = false
    self._jointToFacingRotation = v27
    self._motor = v11
    self._preAnimationConnection = nil
    self._preSimulationConnection = nil
    self._root = HumanoidRootPart
    self._targetPitchReference = nil
    self._targetUserId = nil

    return self
end

function t1:_getJointTransform() -- line: 173
    local _bone = self._bone

    if _bone ~= nil then
        return _bone.Transform
    end

    local _motor = self._motor

    assert(_motor ~= nil, (("%* wake look-at requires a Motor6D or Bone"):format((self._guardModel:GetFullName()))))

    return _motor.Transform
end

function t1:_setJointTransform(p4) -- line: 184
    local _bone = self._bone

    if _bone ~= nil then
        _bone.Transform = p4

        return
    end

    local _motor = self._motor

    assert(_motor ~= nil, (("%* wake look-at requires a Motor6D or Bone"):format((self._guardModel:GetFullName()))))
    _motor.Transform = p4
end

function t1:_getAnimationJointWorldCFrame() -- line: 196
    local _bone = self._bone

    if _bone ~= nil then
        return _bone.TransformedWorldCFrame * self._appliedOffset:Inverse()
    end

    local _motor = self._motor

    assert(_motor ~= nil, (("%* wake look-at requires a Motor6D or Bone"):format((self._guardModel:GetFullName()))))

    local Part0 = _motor.Part0

    assert(Part0 ~= nil, (("%* requires Part0 for wake look-at"):format((_motor:GetFullName()))))

    local v38 = _motor.Transform * self._appliedOffset:Inverse()

    return Part0.CFrame * _motor.C0 * v38
end

function t1:_getAnimationJointTransform() -- line: 210
    return self:_getJointTransform() * self._appliedOffset:Inverse()
end

function t1:_getTargetOffset() -- line: 214
    -- upvalues: Players (copy), Player (copy)
    if not self._isWaking then
        return CFrame.identity
    end

    local v39 = Player.FindRootPart(Players.LocalPlayer)

    if v39 == nil or (v39.Position - self._root.Position).Magnitude > 400 then
        return CFrame.identity
    end

    local _targetUserId = self._targetUserId

    if _targetUserId == nil then
        return CFrame.identity
    end

    local v40 = tonumber(_targetUserId)

    assert(v40 ~= nil, (("%*.WakeTargetPlayer must be a user id"):format((self._guardModel:GetFullName()))))

    local PlayerByUserId = Players:GetPlayerByUserId(v40)

    if PlayerByUserId == nil then
        return CFrame.identity
    end

    local v43 = Player.FindHead(PlayerByUserId)

    if v43 == nil then
        return CFrame.identity
    end

    local v44 = self:_getAnimationJointWorldCFrame()
    local v45 = CFrame.new(v44.Position) * self._root.CFrame.Rotation
    local v46 = v43.Position - v45.Position

    if v46.Magnitude <= 0.001 then
        return CFrame.identity
    end

    local v47 = v45:VectorToObjectSpace(v46.Unit)
    local v48 = math.asin(v47.Y)
    local v51 = math.clamp(-math.atan2(v47.X, -v47.Z), -1.0471975511965976, 1.0471975511965976)
    local _areaLookOverride = self._areaLookOverride

    if _areaLookOverride == nil then
        local v52 = math.clamp(v48, -0.6108652381980153, 0.6108652381980153)
        local v53 = (v45 * CFrame.Angles(v52, v51, 0)).Rotation * self._jointToFacingRotation:Inverse()

        return v44.Rotation:ToObjectSpace(v53)
    end

    local _targetPitchReference = self._targetPitchReference

    if _targetPitchReference == nil then
        _targetPitchReference = v48
        self._targetPitchReference = v48
    end

    local v54 = self:_getAnimationJointTransform()
    local v55 = v44.Rotation * v54.Rotation:Inverse()
    local v57 = math.clamp(_areaLookOverride.BasePitch + (v48 - _targetPitchReference) * _areaLookOverride.TargetPitchScale, _areaLookOverride.MinPitch, _areaLookOverride.MaxPitch)
    local v58 = CFrame.fromAxisAngle(_areaLookOverride.AuthoredPitchAxis, v57)
    local v59 = CFrame.fromAxisAngle(self._root.CFrame.UpVector, v51) * v55 * v58 * v54.Rotation

    return v44.Rotation:ToObjectSpace(v59)
end

function t1:_applyOffset(p9) -- line: 289
    self:_setJointTransform(self:_getJointTransform() * p9)
    self._appliedOffset = p9
end

function t1:_restoreAppliedOffset() -- line: 294
    self:_setJointTransform(self:_getJointTransform() * self._appliedOffset:Inverse())
    self._appliedOffset = CFrame.identity
end

function t1:_isOffsetAtRest() -- line: 299
    local v60, v61, v62 = self._currentOffset:ToOrientation()

    return math.max(math.abs(v60), math.abs(v61), (math.abs(v62))) <= 0.001
end

function t1:_step(p13) -- line: 304
    local v66 = self:_getTargetOffset()
    local v68 = 1 - math.exp(p13 * -3.5)

    self._currentOffset = self._currentOffset:Lerp(v66, v68)
    self:_applyOffset(self._currentOffset)

    if self._isWaking or not self:_isOffsetAtRest() then
        return false
    end

    self._currentOffset = CFrame.identity
    self:_restoreAppliedOffset()

    return true
end

function t1:_ensureAnimation() -- line: 319
    -- upvalues: RunService (copy)
    if self._preSimulationConnection ~= nil then
        return
    end

    assert(self._preAnimationConnection == nil, "wake look-at frame connections must share a lifecycle")
    self._preAnimationConnection = RunService.PreAnimation:Connect(function() -- line: 329
        -- upvalues: self (copy)
        self:_restoreAppliedOffset()
    end)
    self._preSimulationConnection = RunService.PreSimulation:Connect(function(p15) -- line: 331
        -- upvalues: self (copy)
        if self:_step(p15) then
            self:_disconnectAnimation()
        end
    end)
end

function t1:_disconnectAnimation() -- line: 338
    local _preAnimationConnection = self._preAnimationConnection

    if _preAnimationConnection ~= nil then
        self._preAnimationConnection = nil
        _preAnimationConnection:Disconnect()
    end

    local _preSimulationConnection = self._preSimulationConnection

    if _preSimulationConnection ~= nil then
        self._preSimulationConnection = nil
        _preSimulationConnection:Disconnect()
    end
end

function t1:SetWaking(p18, p19) -- line: 356
    -- upvalues: t (copy)
    t.strict(t.boolean)(p18)
    t.strict(t.optional(t.string))(p19)

    if not p18 or not self._isWaking or p19 ~= self._targetUserId then
        self._targetPitchReference = nil
    end

    self._isWaking = p18
    self._targetUserId = p19

    if p18 or not self:_isOffsetAtRest() then
        self:_ensureAnimation()
    end
end

function t1:Destroy() -- line: 374
    self._isWaking = false
    self._targetPitchReference = nil
    self._targetUserId = nil
    self._currentOffset = CFrame.identity
    self:_restoreAppliedOffset()
    self:_disconnectAnimation()
end

return t1
