-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuardPrediction = require(game:GetService("ReplicatedStorage").Shared.Flags.GameplayBalance).GuardPrediction
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuardChasePolicy = require(script.Parent.GuardChasePolicy)
local t = require(ReplicatedStorage.Packages.t)

require(script.Parent.Types.Interface)

local t1 = {}

local function resolveHorizontalDirection(p1) -- line: 27
    local v1 = Vector3.new(p1.X, 0, p1.Z)

    assert(v1.Magnitude > 1E-06)

    return v1.Unit
end

local function resolveAtSpeed(p2, p3) -- line: 35
    -- upvalues: GuardChasePolicy (copy)
    if p3 == 0 then
        return {
            ExitTime = 1e999,
            Outcome = "Caught",
            CatchTime = GuardChasePolicy.GetWakingDuration()
        }
    end

    local v3 = p2.ExitDistance / p3
    local v4 = GuardChasePolicy.GetWakingDuration()

    if v3 <= v4 then
        return {
            CatchTime = nil,
            Outcome = "EscapedSafely",
            ExitTime = v3
        }
    end

    local ExitDirection = p2.ExitDirection
    local v5 = Vector3.new(ExitDirection.X, 0, ExitDirection.Z)

    assert(v5.Magnitude > 1E-06)

    local Unit = v5.Unit
    local v7 = (p2.PlayerStartPosition - p2.GuardStartPosition):Dot(Unit) + p3 * v4

    if v7 <= p2.HitDistance then
        return {
            Outcome = "Caught",
            CatchTime = v4,
            ExitTime = v3
        }
    end

    local v8 = GuardChasePolicy.ResolveCatchDuration(p2.BaseGuardWalkSpeed, p2.FlatRadius, p2.HitDistance, v7, p3)
    local v9 = if v8 == nil then nil else v4 + v8

    return {
        CatchTime = v9,
        ExitTime = v3,
        Outcome = v9 ~= nil and v9 < v3 and "Caught" or "EscapedSafely"
    }
end

function t1.ResolveExitDistance(p4, p5, p6, p7) -- line: 92
    -- upvalues: t (copy)
    t.strict(t.CFrame)(p4)
    t.strict(t.Vector3)(p5)
    t.strict(t.Vector3)(p6)
    t.strict(t.Vector3)(p7)

    local v11 = Vector3.new(p7.X, 0, p7.Z)

    assert(v11.Magnitude > 1E-06)

    local Unit = v11.Unit
    local v13 = p4:PointToObjectSpace(p6)
    local v14 = p4:VectorToObjectSpace(Unit)
    local v15 = p5 * 0.5

    assert(math.abs(v13.X) <= v15.X + 1E-06)
    assert(math.abs(v13.Z) <= v15.Z + 1E-06)

    local v20 = math.min(if math.abs(v14.X) > 1E-06 then ((if v14.X > 0 then v15.X else -v15.X) - v13.X) / v14.X else 1e999, if math.abs(v14.Z) > 1E-06 then ((if v14.Z > 0 then v15.Z else -v15.Z) - v13.Z) / v14.Z else 1e999)

    assert(v20 >= 0 and v20 < 1e999)

    return v20
end

function t1.ResolvePlayerWalkSpeedRequirement(p8, p9) -- line: 134
    -- upvalues: GuardChasePolicy (copy), t (copy), resolveAtSpeed (copy)
    t.strict(t.table)(p8)
    t.strict(t.number)(p9)
    t.strict(t.number)(p8.BaseGuardWalkSpeed)
    t.strict(t.Vector3)(p8.ExitDirection)
    t.strict(t.number)(p8.ExitDistance)
    t.strict(t.number)(p8.FlatRadius)
    t.strict(t.Vector3)(p8.GuardStartPosition)
    t.strict(t.number)(p8.HitDistance)
    t.strict(t.Vector3)(p8.PlayerStartPosition)
    assert(p8.BaseGuardWalkSpeed > 0)
    assert(p8.ExitDistance >= 0)
    assert(p8.FlatRadius > 0)
    assert(p8.HitDistance > 0)
    assert(p9 > 0 and p9 <= 1)

    if p8.ExitDistance == 0 then
        return 0
    end

    local v27 = GuardChasePolicy.GetWakingDuration()
    local v28 = 0
    local v29 = p8.ExitDistance / v27 / p9

    for _ = 1, 48 do
        local v30 = (v28 + v29) * 0.5

        if resolveAtSpeed(p8, v30 * p9).Outcome == "Caught" then
            v28 = v30
        else
            v29 = v30
        end
    end

    return v29
end

function t1.ResolveGreenPlayerWalkSpeedRequirement(p10) -- line: 175
    -- upvalues: GuardPrediction (copy), t1 (copy)
    return t1.ResolvePlayerWalkSpeedRequirement(p10, GuardPrediction.FULL_GREEN_EGG_CARRY_SPEED_RATIO)
end

function t1.ResolveSlowdownTolerance(p11, p12) -- line: 184
    -- upvalues: t (copy)
    t.strict(t.number)(p11)
    t.strict(t.number)(p12)
    assert(p11 >= 0)
    assert(p12 >= 0)

    if p11 == 0 then
        return 1
    end

    if p12 == 0 then
        return -1
    end

    return 1 - p11 / p12
end

function t1.Resolve(p13) -- line: 204
    -- upvalues: GuardPrediction (copy), t (copy), resolveAtSpeed (copy)
    t.strict(t.table)(p13)
    t.strict(t.number)(p13.BaseGuardWalkSpeed)
    t.strict(t.Vector3)(p13.ExitDirection)
    t.strict(t.number)(p13.ExitDistance)
    t.strict(t.number)(p13.FlatRadius)
    t.strict(t.Vector3)(p13.GuardStartPosition)
    t.strict(t.number)(p13.HitDistance)
    t.strict(t.number)(p13.PlayerWalkSpeed)
    t.strict(t.Vector3)(p13.PlayerStartPosition)
    assert(p13.BaseGuardWalkSpeed > 0)
    assert(p13.ExitDistance >= 0)
    assert(p13.FlatRadius > 0)
    assert(p13.HitDistance > 0)
    assert(p13.PlayerWalkSpeed >= 0)

    local v39 = resolveAtSpeed(p13, p13.PlayerWalkSpeed)

    if v39.Outcome == "Caught" then
        return v39
    end

    local v40 = resolveAtSpeed(p13, p13.PlayerWalkSpeed * GuardPrediction.FULL_GREEN_EGG_CARRY_SPEED_RATIO)

    return {
        CatchTime = v39.CatchTime,
        ExitTime = v39.ExitTime,
        Outcome = v40.Outcome == "Caught" and "EscapedAtRisk" or "EscapedSafely"
    }
end

return t1
