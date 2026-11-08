-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuardAreaGeometry = require(ReplicatedStorage.Shared.Util.GuardAreaGeometry)
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.strict(t.instanceIsA("BasePart"))
local v2 = t.strict(t.Vector3)
local v3 = t.strict(t.number)
local v4 = t.strict(t.optional(t.number))
local t1 = {
    CLAIM_PRELOAD_DISTANCE_STUDS = 50
}

function t1.GetShortestDistanceToClaimLine(p1, p2) -- line: 23
    -- upvalues: GuardAreaGeometry (copy), v1 (copy), v2 (copy)
    v1(p1)
    v2(p2)

    return (math.abs((GuardAreaGeometry.SignedDistanceToLine(p1, p2))))
end

function t1.IsSpeedEligible(p3, p4) -- line: 33
    -- upvalues: v3 (copy), v4 (copy)
    v3(p3)
    v4(p4)

    return p4 ~= nil and p4 <= p3
end

function t1.IsWithinClaimPreloadDistance(p5) -- line: 43
    -- upvalues: v3 (copy), t1 (copy)
    v3(p5)

    return p5 < t1.CLAIM_PRELOAD_DISTANCE_STUDS
end

function t1.ShouldPreloadCarriedEgg(p6, p7, p8) -- line: 49
    -- upvalues: v4 (copy), t1 (copy)
    v4(p8)

    local v6 = t1.IsSpeedEligible(p6, p7)

    if not v6 then
        v6 = p8 ~= nil and t1.IsWithinClaimPreloadDistance(p8)
    end

    return v6
end

return table.freeze(t1)
