-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local EggGrowthAnimation = require(ReplicatedStorage.Shared.Eggs.EggGrowthAnimation)
local Player = require(ReplicatedStorage.Shared.Player)
local t1 = {}

t1.__index = t1
t1.__class = "AreaEggNearbyPulse"

function t1.new(p1) -- line: 48
    -- upvalues: t (copy), t1 (copy)
    t.strict(t.instanceIsA("Player"))(p1)

    local self = setmetatable({}, t1)

    self._player = p1
    self._random = Random.new()
    self._registeredByUid = {}
    self._nextPulseAt = nil

    return self
end

function t1:_scheduleNextFor(p3, p4) -- line: 64
    local v4 = assert(self._registeredByUid[p3], (("Area egg %* must be registered before scheduling"):format(p3)))
    local v5 = p4 + self._random:NextNumber(6, 25)

    v4.NextPulseAt = v5

    local _nextPulseAt = self._nextPulseAt

    if _nextPulseAt == nil or v5 < _nextPulseAt then
        self._nextPulseAt = v5
    end
end

function t1:_recomputeNextPulseAt() -- line: 76
    local NextPulseAt

    for _, v6 in pairs(self._registeredByUid) do
        if NextPulseAt == nil or v6.NextPulseAt < NextPulseAt then
            NextPulseAt = v6.NextPulseAt
        end
    end

    self._nextPulseAt = NextPulseAt
end

function t1:_collectClosest(p7) -- line: 86
    local t3 = {}
    local t4 = {}

    for v7, v8 in pairs(self._registeredByUid) do
        if v8.Model.Parent ~= nil and v8.Root.Parent ~= nil then
            local v9 = v8.Root.Position - p7
            local v10 = v9:Dot(v9)

            if not (v10 > 122500) then
                local v11 = #t3 + 1

                for v12, v13 in ipairs(t4) do
                    if v10 < v13 then
                        v11 = v12
                        break
                    end
                end

                if v11 <= 8 then
                    table.insert(t3, v11, v7)
                    table.insert(t4, v11, v10)

                    if #t3 > 8 then
                        table.remove(t3)
                        table.remove(t4)
                    end
                end
            end
        end
    end

    return t3
end

function t1:Bind(p9, p10, p11) -- line: 129
    -- upvalues: t (copy), EggGrowthAnimation (copy)
    t.strict(t.string)(p9)
    t.strict(t.instanceIsA("Model"))(p10)
    t.strict(t.number)(p11)
    self:Unbind(p9)

    local PrimaryPart = p10.PrimaryPart

    assert(PrimaryPart ~= nil, (("Rendered area egg %* must have a PrimaryPart"):format(p9)))

    local t5 = {
        NextPulseAt = 0,
        Model = p10,
        Root = PrimaryPart,
        Animation = EggGrowthAnimation.new(p10, p10:GetPivot(), 2)
    }

    self._registeredByUid[p9] = t5
    self:_scheduleNextFor(p9, p11)

    return function() -- line: 152
        -- upvalues: self (copy), p9 (copy), t5 (copy)
        if self._registeredByUid[p9] == t5 then
            self:Unbind(p9)
        end
    end
end

function t1:Unbind(p13) -- line: 159
    -- upvalues: t (copy)
    t.strict(t.string)(p13)

    local v16 = self._registeredByUid[p13]

    if v16 == nil then
        return
    end

    local v17 = v16.NextPulseAt == self._nextPulseAt

    self._registeredByUid[p13] = nil
    v16.Animation:Destroy()

    if v17 then
        self:_recomputeNextPulseAt()
    end
end

function t1:Step(p15) -- line: 175
    -- upvalues: t (copy), Player (copy)
    t.strict(t.number)(p15)

    local _nextPulseAt = self._nextPulseAt

    if _nextPulseAt ~= nil and not (p15 < _nextPulseAt) then
        local v18 = Player.FindRootPart(self._player)
        local t6 = {}

        if v18 ~= nil then
            assert(v18:IsA("BasePart"), "Local HumanoidRootPart must be a BasePart")

            for _, v19 in ipairs(self:_collectClosest(v18.Position)) do
                t6[v19] = true
            end
        end

        self._nextPulseAt = nil

        for v20, v21 in pairs(self._registeredByUid) do
            if v21.NextPulseAt <= p15 then
                self:_scheduleNextFor(v20, p15)

                if t6[v20] then
                    v21.Animation:SetBasePivot(v21.Model:GetPivot())
                    v21.Animation:Play()
                end
            elseif self._nextPulseAt == nil or v21.NextPulseAt < self._nextPulseAt then
                self._nextPulseAt = v21.NextPulseAt
            end
        end
    end
end

return t1
