-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function getRglObstacleCycleSpawnCount(p1, p2, p3, p4) -- line: 2
    return (math.min(math.max(0, p3 - p1 - p2), p4))
end

local function isRglObstacleCycleReady(p5, p6) -- line: 5
    return p5 ~= nil and p5 <= p6
end

local function calculateRglObstacleTimeline(p7, p8) -- line: 8
    local v3 = p7 + p8.warningAppearDelaySeconds
    local v4 = v3 + p8.warningSolidSeconds
    local v5 = v4 + p8.warningBlinkSeconds
    local v6 = v5 + p8.fallDurationSeconds

    return {
        blinkingStartsAt = v4,
        expiresAt = v6 + p8.groundedLifetimeSeconds,
        fallsAt = v5,
        landsAt = v6,
        warningAppearsAt = v3
    }
end

local flatten

local function isRglObstaclePlacementAllowed(p9, p10, p11, p12, p13) -- line: 22
    -- upvalues: flatten (ref)
    for _, v7 in p10 do
        if flatten(v7 - p9).Magnitude < p12 then
            return false
        end
    end

    for _, v8 in p11 do
        if flatten(v8 - p9).Magnitude < p13 then
            return false
        end
    end

    return true
end

local function getRglObstacleFallingCFrame(p14, p15) -- line: 37
    local v10 = math.max(0.001, p14.landsAt - p14.fallsAt)
    local v12 = math.clamp((p15 - p14.fallsAt) / v10, 0, 1)

    return p14.skyCFrame:Lerp(p14.landingCFrame, v12 * v12)
end

function flatten(p16) -- line: 42
    return (Vector3.new(p16.X, 0, p16.Z))
end

return {
    getRglObstacleCycleSpawnCount = getRglObstacleCycleSpawnCount,
    isRglObstacleCycleReady = isRglObstacleCycleReady,
    calculateRglObstacleTimeline = calculateRglObstacleTimeline,
    isRglObstaclePlacementAllowed = isRglObstaclePlacementAllowed,
    getRglObstacleFallingCFrame = getRglObstacleFallingCFrame
}
