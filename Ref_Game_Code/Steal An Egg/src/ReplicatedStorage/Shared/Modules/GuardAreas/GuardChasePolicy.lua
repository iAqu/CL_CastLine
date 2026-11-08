-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuardChase = require(game:GetService("ReplicatedStorage").Shared.Flags.GameplayBalance).GuardChase
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local t1 = {
    GetWakingDuration = function() -- GetWakingDuration | line: 23
        -- upvalues: GuardChase (copy)
        return GuardChase.WAKING_DURATION
    end,
    ResolveHitDistance = function(p1) -- ResolveHitDistance | line: 27
        -- upvalues: GuardChase (copy), t (copy)
        t.strict(t.optional(t.number))(p1)
        p1 = p1 or GuardChase.DEFAULT_HIT_DISTANCE
        assert(p1 > 0)

        return p1
    end,
    ResolveWalkSpeed = function(p2, p3, p4) -- ResolveWalkSpeed | line: 37
        -- upvalues: GuardChase (copy), t (copy)
        t.strict(t.number)(p2)
        t.strict(t.number)(p3)
        t.strict(t.number)(p4)
        assert(p2 > 0)
        assert(p3 > 0)
        assert(p4 >= 0)

        local v6 = math.max(p3, 0.001)

        if p4 <= v6 then
            return p2
        end

        return (math.min(p2 * (1 + (p4 / v6 - 1) * GuardChase.DISTANCE_MULTIPLIER_STRENGTH), p2 * GuardChase.MAX_DISTANCE_MULTIPLIER))
    end
}

function t1.ResolveCatchDuration(p5, p6, p7, p8, p9) -- line: 64
    -- upvalues: GuardChase (copy), t (copy), t1 (copy)
    t.strict(t.number)(p5)
    t.strict(t.number)(p6)
    t.strict(t.number)(p7)
    t.strict(t.number)(p8)
    t.strict(t.number)(p9)
    assert(p5 > 0)
    assert(p6 > 0)
    assert(p7 > 0)
    assert(p8 >= 0)
    assert(p9 >= 0)

    if p8 <= p7 then
        return 0
    end

    if t1.ResolveWalkSpeed(p5, p6, p7) <= p9 then
        return nil
    end

    local v14 = math.max(p6, 0.001)
    local v15 = v14 * (1 + (GuardChase.MAX_DISTANCE_MULTIPLIER - 1) / GuardChase.DISTANCE_MULTIPLIER_STRENGTH)
    local v16 = math.max(p7, v15)
    local v17 = if v16 < p8 then 0 + (p8 - v16) / (p5 * GuardChase.MAX_DISTANCE_MULTIPLIER - p9) else 0
    local v18 = math.max(p7, v14)
    local v19 = math.min(p8, v15)

    if v18 < v19 then
        local v20 = p5 * GuardChase.DISTANCE_MULTIPLIER_STRENGTH / v14
        local v21 = p5 * (1 - GuardChase.DISTANCE_MULTIPLIER_STRENGTH)

        v17 += math.log((v21 + v20 * v19 - p9) / (v21 + v20 * v18 - p9)) / v20
    end

    local v23 = math.min(p8, v14)

    if p7 < v23 then
        v17 += (v23 - p7) / (p5 - p9)
    end

    return v17
end

return t1
