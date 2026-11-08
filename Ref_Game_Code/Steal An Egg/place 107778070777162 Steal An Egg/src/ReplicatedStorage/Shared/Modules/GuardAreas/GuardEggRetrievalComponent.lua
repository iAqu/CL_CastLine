-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuardRetrieval = require(game:GetService("ReplicatedStorage").Shared.Flags.GameplayBalance).GuardRetrieval
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local GuardDistance = require(script.Parent.GuardDistance)
local Physics = require(ReplicatedStorage.Shared.Utils.Physics)
local t = require(ReplicatedStorage.Packages.t)

require(script.Parent.Types.Interface)

local WaitFor = require(ReplicatedStorage.Packages.WaitFor)
local t1 = {}

t1.__index = t1
t1.__class = "GuardEggRetrievalComponent"

function t1.new(p1, p2, p3) -- line: 44
    -- upvalues: Constants (copy), t (copy), WaitFor (copy), t1 (copy)
    t.strict(t.instanceIsA("Model"))(p1)
    t.strict(t.instanceIsA("BasePart"))(p2)
    t.strict(t.CFrame)(p3)

    local v1, v2 = WaitFor.Descendant(p1, "EggPoint", Constants.STUDIO_YIELD_TIMEOUT):await()

    assert(v1, (("Failed to resolve EggPoint under %*: %*"):format(p1:GetFullName(), (tostring(v2)))))
    assert(v2:IsA("BasePart"), (("%*.EggPoint must be a BasePart"):format((p1:GetFullName()))))

    local self = setmetatable({}, t1)

    self._byUid = {}
    self._current = nil
    self._eggPoint = v2
    self._homeCFrame = p3
    self._queue = {}
    self._root = p2
    self._stage = nil
    self._weld = nil

    return self
end

function t1:_enqueue(p5) -- line: 82
    for v6, v7 in ipairs(self._queue) do
        if p5.Priority > v7.Priority then
            table.insert(self._queue, v6, p5)

            return
        end
    end

    table.insert(self._queue, p5)
end

function t1:_selectCurrent() -- line: 96
    if self._current ~= nil then
        return self._current
    end

    local v8

    while true do
        if not (#self._queue > 0) then
            return nil
        end

        v8 = table.remove(self._queue, 1)
        assert(v8 ~= nil, "Non-empty guard retrieval queue must yield a target")

        local Model = v8.Model

        if self._byUid[v8.EggUid] == v8 and (Model == nil or Model.Parent ~= nil) then
            break
        end

        self._byUid[v8.EggUid] = nil
    end

    self._current = v8
    self._stage = "Approaching"

    return v8
end

function t1:_destroyWeld() -- line: 122
    local _weld = self._weld

    if _weld ~= nil then
        self._weld = nil
        _weld:Destroy()
    end
end

function t1:_removeCurrent() -- line: 131
    local _current = self._current

    assert(_current ~= nil, "Guard retrieval current target is required")
    self:_destroyWeld()
    self._byUid[_current.EggUid] = nil
    self._current = nil
    self._stage = nil

    return _current
end

function t1:Register(p10) -- line: 149
    -- upvalues: t (copy)
    t.strict(t.table)(p10)
    t.strict(t.string)(p10.EggUid)
    t.strict(t.optional(t.instanceIsA("Model")))(p10.Model)
    t.strict(t.Vector3)(p10.DroppedPosition)
    t.strict(t.CFrame)(p10.NestBottomCFrame)
    t.strict(t.number)(p10.Priority)

    if self._byUid[p10.EggUid] ~= nil then
        return false
    end

    self._byUid[p10.EggUid] = p10
    self:_enqueue(p10)

    local _current = self._current

    if _current ~= nil and self._stage == "Approaching" and p10.Priority > _current.Priority then
        self._current = nil
        self._stage = nil
        self:_enqueue(_current)
    end

    return true
end

function t1:Clear(p12) -- line: 179
    -- upvalues: t (copy)
    t.strict(t.string)(p12)

    local v11 = self._byUid[p12]

    if v11 == nil then
        return false
    end

    self._byUid[p12] = nil

    if self._current == v11 then
        self:_destroyWeld()
        self._current = nil
        self._stage = nil
    end

    local v12 = table.find(self._queue, v11)

    if v12 ~= nil then
        table.remove(self._queue, v12)
    end

    return true
end

function t1:HasPending() -- line: 205
    return next(self._byUid) ~= nil
end

function t1:IsAttached(p15) -- line: 209
    -- upvalues: t (copy)
    t.strict(t.string)(p15)

    if self._current ~= nil and self._current.EggUid == p15 then
        return self._stage == "Carrying"
    end

    return false
end

function t1:GetMoveTarget() -- line: 218
    local v13 = self:_selectCurrent()

    if v13 == nil then
        return nil
    end

    if self._stage == "Carrying" then
        return self._homeCFrame.Position
    end

    return v13.DroppedPosition
end

function t1:TryTransition(p18) -- line: 232
    -- upvalues: GuardRetrieval (copy), GuardDistance (copy), Physics (copy), t (copy)
    t.strict(t.number)(p18)

    local v14 = self:_selectCurrent()

    if v14 ~= nil then
        local Model = v14.Model

        if Model == nil or Model.Parent ~= nil then
            if self._stage == "Approaching" then
                if p18 < GuardDistance.XZ(self._root.Position, v14.DroppedPosition) then
                    return nil
                end

                if Model ~= nil then
                    local PrimaryPart = Model.PrimaryPart

                    assert(PrimaryPart ~= nil, (("Rendered guard retrieval egg %* must have a PrimaryPart"):format(v14.EggUid)))
                    Physics.SetAnchored(Model, false)
                    Model:PivotTo(self._eggPoint.CFrame * CFrame.new(0, 0, -PrimaryPart.Size.Z * 0.5))

                    local _eggPoint = self._eggPoint
                    local Motor6D

                    if _eggPoint.Anchored then
                        Motor6D = Instance.new("Motor6D")
                        Motor6D.C0 = _eggPoint.CFrame:ToObjectSpace(PrimaryPart.CFrame)
                    else
                        Motor6D = Instance.new("WeldConstraint")
                    end

                    Motor6D.Part0 = _eggPoint
                    Motor6D.Part1 = PrimaryPart
                    Motor6D.Parent = _eggPoint
                    self._weld = Motor6D
                end

                self._stage = "Carrying"

                return "Attached"
            end

            if GuardDistance.XZ(self._root.Position, self._homeCFrame.Position) > GuardRetrieval.DEPOSIT_DISTANCE_XZ then
                return nil
            end

            self:_destroyWeld()

            if Model ~= nil then
                Physics.SetAnchored(Model, true)
                Model:PivotTo(v14.NestBottomCFrame)
            end

            self:_removeCurrent()

            return "Deposited"
        end

        self:Clear(v14.EggUid)
    end

    return nil
end

function t1:GetCurrentEggUid() -- line: 304
    local v17 = self:_selectCurrent()

    return if v17 ~= nil then v17.EggUid else nil
end

function t1:Destroy() -- line: 310
    self:_destroyWeld()
    table.clear(self._byUid)
    table.clear(self._queue)
    self._current = nil
    self._stage = nil
end

return t1
