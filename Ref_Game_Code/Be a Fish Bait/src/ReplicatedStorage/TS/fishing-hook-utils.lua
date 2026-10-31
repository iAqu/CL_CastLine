-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage
local MiniPlayerRigR15 = ReplicatedStorage:FindFirstChild("MiniPlayerRigR15")

assert(MiniPlayerRigR15, "MiniPlayerRigR15 not found in ReplicatedStorage")

local FlyingWave = ReplicatedStorage:FindFirstChild("FlyingWave")

assert(FlyingWave, "FlyingWave not found in ReplicatedStorage")

local FlyingVFX = ReplicatedStorage:FindFirstChild("FlyingVFX")

assert(FlyingVFX, "FlyingVFX not found in ReplicatedStorage")

local CastCutScene = ReplicatedStorage:FindFirstChild("CastCutScene")

assert(CastCutScene, "CastCutScene not found in ReplicatedStorage")

local function attachFlyingWaveToHead(p1) -- line: 12
    -- upvalues: FlyingWave (copy)
    local Head = p1:FindFirstChild("Head")
    local clone = FlyingWave:Clone()
    local _CFrame = Head.CFrame
    local v1 = CFrame.Angles(1.5707963267948966, 0, 0)

    clone.CFrame = (_CFrame + Vector3.new(0, 0, 0)) * v1
    clone.Parent = p1

    local WeldConstraint = Instance.new("WeldConstraint")

    WeldConstraint.Part0 = clone
    WeldConstraint.Part1 = Head
    WeldConstraint.Parent = clone

    return clone
end

local function attachFlyingVFXToRig(p2) -- line: 26
    -- upvalues: FlyingVFX (copy)
    local clone = FlyingVFX:Clone()

    clone:PivotTo(p2:GetPivot())

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("Beam") then
            descendant.Enabled = true
        end
    end

    clone.Parent = p2

    return clone
end

local function calculatePowerMultiplier(p3) -- line: 37
    return math.clamp(p3, 0, 100) / 100 + 1
end

local v2

local function fovFromSpeed(p4) -- line: 45
    -- upvalues: v2 (ref)
    return math.clamp((p4 - v2) / (427 - v2), 0, 1) * 50 + 70
end

local function speedlineDistanceFromSpeed(p5) -- line: 52
    -- upvalues: v2 (ref)
    return 10 - math.clamp((p5 - v2) / (427 - v2), 0, 1) * 1.5
end

local function peakHeightFromSpeed(p6, p7, p8) -- line: 62
    return (if p7 == nil then 0.75 else p7) * p6 ^ (if p8 == nil then 0.86 else p8)
end

local function bounceInitialDistanceFromSpeed(p9, p10, p11) -- line: 80
    return (if p10 == nil then 15 else p10) * p9 ^ (if p11 == nil then 0.5 else p11)
end

local function computeBounceDistances(p12, p13, p14) -- line: 95
    local v5 = if p14 == nil then 0.5 else p14
    local v7 = p12 / (if math.abs(v5 - 1) < 0.001 then p13 else (1 - v5 ^ p13) / (1 - v5))
    local t1 = {}
    local n1 = 0
    local v8 = false

    while true do
        if v8 then
            n1 += 1
        else
            v8 = true
        end

        if n1 < p13 then
            table.insert(t1, v7 * v5 ^ n1)
            continue
        end

        break
    end

    return t1
end

v2 = 20

local function launchSpeedScaleFromPower(p15) -- line: 145
    local v11 = math.log(math.max(0, p15) + 1)
    local v13 = 1 / (math.exp(-(v11 - 20) / 3) + 1)
    local v15 = 1 / (math.exp(-(v11 - 37.25) / 1) + 1)

    return v13 * -2 + 11 - v15 * 0.1791
end

local function castLaunchSpeedFromPower(p16) -- line: 151
    -- upvalues: v2 (ref)
    local v16 = math.max(0, p16)
    local v17 = v2
    local v19 = math.log(math.max(0, v16) + 1)
    local v21 = 1 / (math.exp(-(v19 - 20) / 3) + 1)
    local v23 = 1 / (math.exp(-(v19 - 37.25) / 1) + 1)

    return v17 + (v21 * -2 + 11 - v23 * 0.1791) * math.log(v16 + 1)
end

local function castDuration(p17) -- line: 155
    return math.log(math.max(0, p17) + 1) * 0.2 + 1
end

local function castDistanceFromPower(p18) -- line: 159
    -- upvalues: v2 (ref)
    local v27 = math.max(0, p18)
    local v28 = v2
    local v30 = math.log(math.max(0, v27) + 1)
    local v32 = 1 / (math.exp(-(v30 - 20) / 3) + 1)
    local v34 = 1 / (math.exp(-(v30 - 37.25) / 1) + 1)

    return (v28 + (v32 * -2 + 11 - v34 * 0.1791) * math.log(v27 + 1)) * (math.log(math.max(0, p18) + 1) * 0.2 + 1)
end

local v39 = 0.75 * (v2 + 10.774208193017845 * 13.815511557963774) ^ 0.86

local function computeReelPhase1Studs(p19) -- line: 171
    return 180 + p19 * 2
end

local function computeReelCameraCutTime(p20) -- line: 184
    return (math.max(p20 * 0.2, 0.4))
end

local function computeReelStartPos(p21, p22, p23) -- line: 187
    local v41 = 3 + p23 ^ 0.8 * 0.7
    local v42 = p23 * 0.5
    local v44 = if math.abs(p22.X) + math.abs(p22.Z) > 0.01 then Vector3.new(p22.X, 0, p22.Z).Unit else Vector3.new(0, 0, 0)

    return Vector3.new(p21.X, 95.1 - v41, p21.Z) + v44 * v42
end

local function computeReelArcDurations(_, _, _, p27) -- line: 195
    local v46 = if p27 == nil then 0 else p27
    local v47 = (180 + v46 * 2) / (48 + v46 ^ 1.2 * 1)
    local v49 = math.max(v47 * 0.2, 0.4)

    return {
        phase2 = 0.1,
        phase1 = v47,
        arcTotal = v47 + 0.1,
        cameraCutTime = v49,
        total = v49 + 0.9
    }
end

local v50 = 80.1 - math.log(v2) * -10

local function castEndYFromSpeed(p28) -- line: 216
    -- upvalues: v50 (copy)
    return v50 + math.log(p28) * -10
end

local function castEndYFromPower(p29) -- line: 219
    -- upvalues: v2 (ref), v50 (copy)
    local v51 = math.max(0, p29)
    local v52 = v2
    local v54 = math.log(math.max(0, v51) + 1)
    local v56 = 1 / (math.exp(-(v54 - 20) / 3) + 1)
    local v58 = 1 / (math.exp(-(v54 - 37.25) / 1) + 1)

    return v50 + math.log(v52 + (v56 * -2 + 11 - v58 * 0.1791) * math.log(v51 + 1)) * -10
end

local function computeArcOffset(p30, p31, p32) -- line: 227
    local v62 = math.clamp(p32, 0.01, 0.99)
    local v63 = p31 / (v62 * 2 * (1 - v62))

    return 2 * (1 - p30) * p30 * v63
end

local function findVisualTWater(p33, p34, p35, p36, p37, p38) -- line: 236
    if p33 <= p35 then
        return 0
    end

    if p35 <= p34 then
        return 1
    end

    local n2 = 0
    local n3 = 1

    for _ = 0, 63 do
        local v64 = (n2 + n3) / 2
        local v65 = v64 + (1 - v64) / math.max(p36, 0.001)
        local v66 = p33 + (p34 - p33) / v65 * v64
        local v67 = v64 / v65
        local v68 = math.clamp(p38, 0.01, 0.99)
        local v69 = p37 / (v68 * 2 * (1 - v68))

        if p35 < v66 + 2 * (1 - v67) * v67 * v69 then
            n2 = v64
        else
            n3 = v64
        end
    end

    return (n2 + n3) / 2
end

return {
    attachFlyingWaveToHead = attachFlyingWaveToHead,
    attachFlyingVFXToRig = attachFlyingVFXToRig,
    calculatePowerMultiplier = calculatePowerMultiplier,
    fovFromSpeed = fovFromSpeed,
    speedlineDistanceFromSpeed = speedlineDistanceFromSpeed,
    peakHeightFromSpeed = peakHeightFromSpeed,
    bounceInitialDistanceFromSpeed = bounceInitialDistanceFromSpeed,
    computeBounceDistances = computeBounceDistances,
    launchSpeedScaleFromPower = launchSpeedScaleFromPower,
    castLaunchSpeedFromPower = castLaunchSpeedFromPower,
    castDuration = castDuration,
    castDistanceFromPower = castDistanceFromPower,
    computeReelPhase1Studs = computeReelPhase1Studs,
    computeReelCameraCutTime = computeReelCameraCutTime,
    computeReelStartPos = computeReelStartPos,
    computeReelArcDurations = computeReelArcDurations,
    castEndYFromSpeed = castEndYFromSpeed,
    castEndYFromPower = castEndYFromPower,
    computeArcOffset = computeArcOffset,
    findVisualTWater = findVisualTWater,
    effectiveCastDistance = function(p39, p40, p41, p42) -- effectiveCastDistance | line: 267
        -- upvalues: v2 (ref), computeBounceDistances (copy), v50 (copy), findVisualTWater (copy)
        local v70 = math.max(0, p39)
        local v71 = v2
        local v73 = math.log(math.max(0, v70) + 1)
        local v75 = 1 / (math.exp(-(v73 - 20) / 3) + 1)
        local v77 = 1 / (math.exp(-(v73 - 37.25) / 1) + 1)
        local v80 = v71 + (v75 * -2 + 11 - v77 * 0.1791) * math.log(v70 + 1)
        local v82 = v80 * (math.log(math.max(0, p39) + 1) * 0.2 + 1)
        local v83 = math.max(0, p39)
        local v85 = math.log(math.max(0, v83) + 1)
        local v87 = 1 / (math.exp(-(v85 - 20) / 3) + 1)
        local v89 = 1 / (math.exp(-(v85 - 37.25) / 1) + 1)
        local v95 = findVisualTWater(p40, v50 + math.log(v71 + (v87 * -2 + 11 - v89 * 0.1791) * math.log(v83 + 1)) * -10, 95.1, 2.5, 0.75 * v80 ^ 0.86, 0.35)
        local v96 = v82 / (v95 + (1 - v95) / 2.5) * v95
        local v97 = 15 * v80 ^ 0.5 * (if p41 then 1.3 else 1) * (1 + p42)
        local v98 = computeBounceDistances(v97, 3)

        return v96 + (v97 + v98[#v98])
    end,
    miniPlayerRig = MiniPlayerRigR15,
    flyingWave = FlyingWave,
    flyingVFX = FlyingVFX,
    castCutScene = CastCutScene,
    waterSurfaceY = 95.1,
    baseFov = 70,
    defaultCameraBack = 8,
    defaultCameraUp = 3,
    defaultPeakBias = 0.35,
    peakHeightA = 0.75,
    peakHeightB = 0.86,
    gravity = 196,
    launchAngle = 0.7853981633974483,
    drag = 2.5,
    defaultBounceDiminishFactor = 0.5,
    defaultBounceInitialHeight = 30,
    defaultBounceGravity = 80,
    bounceCount = 3,
    bounceDistA = 15,
    bounceDistB = 0.5,
    defaultPeakHeight = v39,
    skipReelArcToLanding = true,
    reelAboveCasterHeight = 35,
    reelPhase1ArcStuds = 180,
    reelPhase1Speed = 48,
    reelPhase1SpeedPerFishDim = 1,
    reelPhase1StudsPerFishDim = 2,
    reelStartSubmergeDepthBase = 3,
    reelStartSubmergeDepthPerFishDim = 0.7,
    reelStartForwardOffsetPerFishDim = 0.5,
    reelCameraCutFraction = 0.2,
    reelCameraCutMin = 0.4,
    reelPhase2Duration = 0.1,
    catchFadeDuration = 0.4,
    reelDropDuration = 0.9,
    reelFishFallHeight = 12,
    perfectCastStrengthThreshold = 97,
    perfectCastBounceMultiplier = 1.3
}
