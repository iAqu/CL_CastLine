-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useEffect, useRef, useState = react.useCallback, react.useEffect, react.useRef, react.useState
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out")
local useBindingListener, useMotion = out.useBindingListener, out.useMotion
local ReplicatedStorage = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage
local hapticCrateTap = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "haptics").hapticCrateTap
local playClonedSound = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "vfx").playClonedSound
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "viewport-frame-with-prefab").default
local multiverseAquariumCrateSeries = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-crates").multiverseAquariumCrateSeries
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "aquarium-crate-opening-utils")
local aquariumCratePresentationTiers, aquariumCrateUpgradeAttemptCount = v1.aquariumCratePresentationTiers, v1.aquariumCrateUpgradeAttemptCount
local rarityColorGradients = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").rarityColorGradients
local t1 = {
    {
        phase = 0,
        size = 0.045,
        endPosition = Vector2.new(0.27, 0.28),
        startPosition = Vector2.new(0.4, 0.43)
    },
    {
        phase = 0.04,
        size = 0.052,
        endPosition = Vector2.new(0.5, 0.22),
        startPosition = Vector2.new(0.5, 0.39)
    },
    {
        phase = 0.08,
        size = 0.04,
        endPosition = Vector2.new(0.73, 0.29),
        startPosition = Vector2.new(0.6, 0.43)
    },
    {
        phase = 0.02,
        size = 0.055,
        endPosition = Vector2.new(0.78, 0.53),
        startPosition = Vector2.new(0.64, 0.52)
    },
    {
        phase = 0.1,
        size = 0.044,
        endPosition = Vector2.new(0.66, 0.74),
        startPosition = Vector2.new(0.58, 0.61)
    },
    {
        phase = 0.06,
        size = 0.05,
        endPosition = Vector2.new(0.34, 0.75),
        startPosition = Vector2.new(0.42, 0.61)
    },
    {
        phase = 0.12,
        size = 0.042,
        endPosition = Vector2.new(0.22, 0.53),
        startPosition = Vector2.new(0.36, 0.52)
    },
    {
        phase = 0.14,
        size = 0.034,
        endPosition = Vector2.new(0.38, 0.2),
        startPosition = Vector2.new(0.45, 0.4)
    },
    {
        phase = 0.17,
        size = 0.038,
        endPosition = Vector2.new(0.64, 0.21),
        startPosition = Vector2.new(0.56, 0.4)
    },
    {
        phase = 0.15,
        size = 0.036,
        endPosition = Vector2.new(0.8, 0.68),
        startPosition = Vector2.new(0.63, 0.59)
    },
    {
        phase = 0.19,
        size = 0.04,
        endPosition = Vector2.new(0.18, 0.7),
        startPosition = Vector2.new(0.37, 0.6)
    }
}
local t2 = {
    {
        phase = 0,
        rotation = 0,
        endPosition = Vector2.new(0.5, 0.19),
        startPosition = Vector2.new(0.5, 0.39)
    },
    {
        phase = 0.03,
        rotation = 45,
        endPosition = Vector2.new(0.7, 0.27),
        startPosition = Vector2.new(0.59, 0.41)
    },
    {
        phase = 0.06,
        rotation = 90,
        endPosition = Vector2.new(0.8, 0.52),
        startPosition = Vector2.new(0.64, 0.52)
    },
    {
        phase = 0.09,
        rotation = 135,
        endPosition = Vector2.new(0.71, 0.75),
        startPosition = Vector2.new(0.59, 0.62)
    },
    {
        phase = 0.02,
        rotation = 180,
        endPosition = Vector2.new(0.5, 0.82),
        startPosition = Vector2.new(0.5, 0.65)
    },
    {
        phase = 0.05,
        rotation = 225,
        endPosition = Vector2.new(0.29, 0.75),
        startPosition = Vector2.new(0.41, 0.62)
    },
    {
        phase = 0.08,
        rotation = 270,
        endPosition = Vector2.new(0.2, 0.52),
        startPosition = Vector2.new(0.36, 0.52)
    },
    {
        phase = 0.11,
        rotation = 315,
        endPosition = Vector2.new(0.3, 0.27),
        startPosition = Vector2.new(0.41, 0.41)
    }
}
local t3 = {
    0, 0.14
}
local t4 = {
    0, 0.08, 0.16, 0.24
}
local v2 = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.38, 0.08),
    NumberSequenceKeypoint.new(0.62, 0.08),
    NumberSequenceKeypoint.new(1, 1)
})
local t5 = {
    {
        phase = 0,
        size = 0.036,
        endPosition = Vector2.new(0.32, 0.37),
        startPosition = Vector2.new(0.32, 0.42)
    },
    {
        phase = 0.2,
        size = 0.043,
        endPosition = Vector2.new(0.66, 0.35),
        startPosition = Vector2.new(0.66, 0.41)
    },
    {
        phase = 0.4,
        size = 0.032,
        endPosition = Vector2.new(0.72, 0.6),
        startPosition = Vector2.new(0.72, 0.66)
    },
    {
        phase = 0.6,
        size = 0.04,
        endPosition = Vector2.new(0.42, 0.7),
        startPosition = Vector2.new(0.42, 0.76)
    },
    {
        phase = 0.8,
        size = 0.034,
        endPosition = Vector2.new(0.26, 0.58),
        startPosition = Vector2.new(0.26, 0.64)
    },
    {
        phase = 0.1,
        size = 0.032,
        endPosition = Vector2.new(0.2, 0.34),
        startPosition = Vector2.new(0.2, 0.43)
    },
    {
        phase = 0.3,
        size = 0.038,
        endPosition = Vector2.new(0.8, 0.4),
        startPosition = Vector2.new(0.8, 0.49)
    },
    {
        phase = 0.5,
        size = 0.035,
        endPosition = Vector2.new(0.63, 0.76),
        startPosition = Vector2.new(0.63, 0.84)
    },
    {
        phase = 0.7,
        size = 0.03,
        endPosition = Vector2.new(0.36, 0.24),
        startPosition = Vector2.new(0.36, 0.32)
    },
    {
        phase = 0.9,
        size = 0.042,
        endPosition = Vector2.new(0.77, 0.67),
        startPosition = Vector2.new(0.77, 0.75)
    },
    {
        phase = 0.15,
        size = 0.037,
        endPosition = Vector2.new(0.17, 0.68),
        startPosition = Vector2.new(0.17, 0.77)
    },
    {
        phase = 0.35,
        size = 0.034,
        endPosition = Vector2.new(0.55, 0.26),
        startPosition = Vector2.new(0.55, 0.34)
    },
    {
        phase = 0.55,
        size = 0.031,
        endPosition = Vector2.new(0.84, 0.55),
        startPosition = Vector2.new(0.84, 0.64)
    },
    {
        phase = 0.75,
        size = 0.04,
        endPosition = Vector2.new(0.28, 0.78),
        startPosition = Vector2.new(0.28, 0.87)
    }
}
local t6 = {
    rare = {
        ambientSparkleCount = 5,
        effectScale = 1,
        upgradeRingCount = 1,
        background = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 31, 72)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(33, 65, 142)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(62, 26, 118))
        }),
        glowColor = Color3.fromRGB(105, 232, 255),
        shadowColor = Color3.fromRGB(8, 24, 63)
    },
    epic = {
        ambientSparkleCount = 8,
        effectScale = 1.2,
        upgradeRingCount = 2,
        background = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(41, 8, 83)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(112, 31, 156)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(201, 42, 169))
        }),
        glowColor = Color3.fromRGB(210, 87, 255),
        shadowColor = Color3.fromRGB(52, 5, 88)
    },
    legendary = {
        ambientSparkleCount = 11,
        effectScale = 1.45,
        upgradeRingCount = 3,
        background = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(91, 33, 3)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(214, 105, 7)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 203, 45))
        }),
        glowColor = Color3.fromRGB(255, 220, 74),
        shadowColor = Color3.fromRGB(94, 45, 2)
    },
    mythic = {
        ambientSparkleCount = 14,
        effectScale = 1.75,
        upgradeRingCount = 4,
        background = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(61, 0, 30)),
            ColorSequenceKeypoint.new(0.45, Color3.fromRGB(174, 15, 61)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 76, 30))
        }),
        glowColor = Color3.fromRGB(255, 72, 108),
        shadowColor = Color3.fromRGB(68, 0, 28)
    }
}
local v3 = CFrame.new(0, -3.05, 0) * CFrame.Angles(0, -0.20943951023931956, 0)

local function getChestTemplateName(p1) -- line: 248
    -- upvalues: multiverseAquariumCrateSeries (copy)
    if p1 == multiverseAquariumCrateSeries.id then
        return "Gacha_Chest_Multiverse"
    end

    return "Gacha_Chest"
end

local function findChestTemplate(p2) -- line: 251
    -- upvalues: ReplicatedStorage (copy), multiverseAquariumCrateSeries (copy)
    local VFX = ReplicatedStorage:FindFirstChild("VFX")

    if VFX ~= nil then
        VFX = VFX:FindFirstChild(if p2 == multiverseAquariumCrateSeries.id then "Gacha_Chest_Multiverse" else "Gacha_Chest")
    end

    return if if VFX == nil then VFX else VFX:IsA("Model") then VFX else nil
end

local function easeOutCubic(p3) -- line: 263
    return 1 - math.pow(1 - p3, 3)
end

local function getChestMorphScale(p4) -- line: 266
    if p4 >= 0 then
        return (Vector3.new(1 + p4 * 0.16, 1 - p4 * 0.32, 1 + p4 * 0.06))
    end

    local v8 = 1 + -p4 * 0.2

    return (Vector3.new(v8, v8, v8))
end

return {
    default = function(p5) -- AquariumCrateOpeningScreen | line: 274
        -- upvalues: react (copy), useCallback (copy), useEffect (copy), useRef (copy), useState (copy), useBindingListener (copy), useMotion (copy), ReplicatedStorage (copy), hapticCrateTap (copy), playClonedSound (copy), default (copy), default2 (copy), multiverseAquariumCrateSeries (copy), images (copy), aquariumCratePresentationTiers (copy), aquariumCrateUpgradeAttemptCount (copy), rarityColorGradients (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), v2 (copy), t5 (copy), t6 (copy), v3 (copy)
        local onFinished, seriesId, targetTier = p5.onFinished, p5.seriesId, p5.targetTier
        local v9, v10 = useState(function() -- line: 278
            -- upvalues: seriesId (copy), ReplicatedStorage (copy), multiverseAquariumCrateSeries (copy)
            local VFX = ReplicatedStorage:FindFirstChild("VFX")

            if VFX ~= nil then
                VFX = VFX:FindFirstChild(if seriesId == multiverseAquariumCrateSeries.id then "Gacha_Chest_Multiverse" else "Gacha_Chest")
            end

            return if if VFX == nil then VFX else VFX:IsA("Model") then VFX else nil
        end)
        local v11 = useRef(nil)
        local v12 = useRef(nil)
        local v13 = useRef({})
        local v14 = useRef(false)
        local v15 = useRef(0)
        local v16 = useRef(0)
        local v17 = useRef(0)
        local v18 = useRef(0)
        local v19 = useRef(0)
        local v20 = useRef(nil)
        local v21 = useRef(0)
        local v22 = useRef(false)
        local v23 = useRef(0)
        local awaitingInput, awaitingInput2 = useState("awaitingInput")
        local v24, v25 = useState(0)
        local v26, v27 = useState(-1)
        local v28, v29 = useState(0)
        local v30, v31 = useState(0)
        local v32, v33 = useMotion(0)
        local v34, v35 = useMotion(0)
        local v36, v37 = useMotion(0)
        local v38, v39 = useMotion(0)
        local v40, v41 = useMotion(0)
        local v42, v43 = useMotion(0)
        local v44, v45 = useMotion(0)
        local v46, v47 = useMotion(0)
        local v48, v49 = useMotion(1)
        local v50, v51 = useMotion(1)
        local v52, v53 = useMotion(0)
        local v54, v55 = useMotion(0)
        local v56 = if v26 >= 0 then aquariumCratePresentationTiers[v26 + 1] else nil
        local n1 = -1
        local v57

        for v58, v59 in aquariumCratePresentationTiers do
            v57 = v58 - 1

            if v59 == targetTier == true then
                n1 = v58 - 1
                break
            end

            n1 = -1
        end

        local v60 = v56 or "rare"
        local v61 = t6[v60]
        local v62 = useCallback(function() -- line: 327
            -- upvalues: v12 (copy), v13 (copy), v15 (copy), v16 (copy), v17 (copy), v18 (copy), v19 (copy), v20 (copy), v21 (copy)
            local current = v12.current

            if current == nil then
                return nil
            end

            local current2 = v15.current
            local v63

            if current2 >= 0 then
                v63 = Vector3.new(1 + current2 * 0.16, 1 - current2 * 0.32, 1 + current2 * 0.06)
            else
                local v67 = 1 + -current2 * 0.2

                v63 = Vector3.new(v67, v67, v67)
            end

            local v71 = current * CFrame.new(0, v16.current, 0) * CFrame.Angles(0, math.rad(v17.current + v19.current), (math.rad(v18.current)))

            for _, v72 in v13.current do
                if v72.part.Parent ~= nil then
                    local relativeCFramePosition = v72.relativeCFrame.Position
                    local v76 = Vector3.new(relativeCFramePosition.X * v63.X, relativeCFramePosition.Y * v63.Y, relativeCFramePosition.Z * v63.Z)

                    v72.part.Size = Vector3.new(v72.size.X * v63.X, v72.size.Y * v63.Y, v72.size.Z * v63.Z)

                    local v80 = v71 * CFrame.new(v76) * v72.relativeCFrame.Rotation

                    if v72.part == v20.current then
                        local v83 = 1 - math.pow(1 - math.clamp(v21.current / 0.72, 0, 1), 3)
                        local v84 = CFrame.new(0, -v72.size.Y * v63.Y / 2, v72.size.Z * v63.Z / 2)
                        local v85 = v80 * v84
                        local v87 = CFrame.Angles(math.rad(105 * v83), 0, 0)
                        local v88 = v84:Inverse()

                        v80 = v85 * v87 * v88
                    end

                    v72.part.CFrame = v80
                end
            end
        end, {})
        local v89 = useCallback(function(p6) -- line: 359
            -- upvalues: v12 (copy), v13 (copy), v14 (copy), v20 (copy), v62 (copy), playClonedSound (copy), v3 (copy)
            p6:PivotTo(v3)

            local Pivot = p6:GetPivot()
            local t7 = {}

            for _, descendant in p6:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.Anchored = true
                    descendant.CanCollide = false
                    descendant.CanQuery = false
                    descendant.CanTouch = false
                    table.insert(t7, {
                        part = descendant,
                        relativeCFrame = Pivot:ToObjectSpace(descendant.CFrame),
                        size = descendant.Size
                    })
                end
            end

            v12.current = Pivot
            v13.current = t7

            local Chest_001_Top = p6:FindFirstChild("Chest_001_Top")

            v20.current = if not (if Chest_001_Top == nil then Chest_001_Top else Chest_001_Top:IsA("BasePart")) then nil else Chest_001_Top

            if v20.current == nil then
                warn("[AquariumCrateOpening] Gacha_Chest.Chest_001_Top is missing")
            end

            v62()

            if not v14.current then
                v14.current = true
                playClonedSound("CrateLandingSound")
            end
        end, { v62 })
        local v90 = useCallback(function() -- line: 395
            -- upvalues: v22 (copy), v23 (copy), awaitingInput (copy), awaitingInput2 (copy), v24 (copy), v25 (copy), v26 (copy), v27 (copy), v29 (copy), v31 (copy), n1 (ref), hapticCrateTap (copy), aquariumCrateUpgradeAttemptCount (copy)
            if awaitingInput ~= "awaitingInput" and awaitingInput ~= "upgrading" then
                return nil
            end

            local elapsed = os.clock()

            if elapsed < v23.current then
                return nil
            end

            v23.current = elapsed + 0.32

            if v24 >= aquariumCrateUpgradeAttemptCount then
                hapticCrateTap(true)
                v22.current = true
                v29(function(p7) -- line: 407
                    return p7 + 1
                end)
                awaitingInput2("finishingTaps")

                return nil
            end

            local v91 = v24 + 1
            local v93 = math.min(v91 - 1, n1)

            hapticCrateTap(v93 >= 2)
            v22.current = false
            v25(v91)
            v29(function(p8) -- line: 418
                return p8 + 1
            end)

            if v26 < v93 then
                v27(v93)
                v31(function(p9) -- line: 423
                    return p9 + 1
                end)
            end

            awaitingInput2("upgrading")
        end, { awaitingInput, v24, n1, v26 })

        useEffect(function() -- line: 429
            -- upvalues: onFinished (copy), seriesId (copy), v9 (copy), v10 (copy), ReplicatedStorage (copy), multiverseAquariumCrateSeries (copy)
            if v9 ~= nil then
                return nil
            end

            local v94 = if seriesId == multiverseAquariumCrateSeries.id then "Gacha_Chest_Multiverse" else "Gacha_Chest"
            local v95 = task.spawn(function() -- line: 434
                -- upvalues: v94 (copy), onFinished (copy), v10 (copy), ReplicatedStorage (copy)
                local v96 = ReplicatedStorage:WaitForChild("VFX", 5)

                if v96 ~= nil then
                    v96 = v96:WaitForChild(v94, 5)
                end

                if if v96 == nil then v96 else v96:IsA("Model") then
                    v10(v96)

                    return nil
                end

                warn((("[AquariumCrateOpening] ReplicatedStorage.VFX.%* is missing"):format(v94)))
                onFinished()
            end)

            return function() -- line: 452
                -- upvalues: v95 (copy)
                return task.cancel(v95)
            end
        end, { v9, onFinished, seriesId })
        useEffect(function() -- line: 456
            -- upvalues: awaitingInput (copy), awaitingInput2 (copy), playClonedSound (copy)
            if awaitingInput ~= "finishingTaps" then
                return nil
            end

            playClonedSound("CrateRevealStinger")

            local v97 = task.spawn(function() -- line: 461
                -- upvalues: awaitingInput2 (copy), playClonedSound (copy)
                playClonedSound("CrateRevealSound", {
                    playbackSpeed = 1.35
                })
                task.wait(0.2)
                playClonedSound("CrateRevealSound", {
                    playbackSpeed = 1.5
                })
                task.wait(0.16)
                playClonedSound("CrateRevealSound", {
                    playbackSpeed = 1.68
                })
                task.wait(0.16000000000000003)
                awaitingInput2("opening")
            end)

            return function() -- line: 476
                -- upvalues: v97 (copy)
                return task.cancel(v97)
            end
        end, { awaitingInput })
        useEffect(function() -- line: 480
            -- upvalues: v22 (copy), v24 (copy), v28 (copy), v33 (copy), v35 (copy), v49 (copy), v61 (copy), playClonedSound (copy)
            if v28 == 0 then
                return nil
            end

            v33:immediate(1)
            v33:spring(0, {
                damping = 0.5,
                frequency = 5
            })
            v35:immediate(1)
            v35:linear(0, {
                speed = 2.5
            })
            v49:immediate(0)
            v49:linear(1, {
                speed = 2.0833333333333335
            })

            if v22.current then
                return
            end

            playClonedSound("CrateTapSound", {
                playbackSpeed = math.max(v24 - 1, 0) * 0.12 + 1,
                volume = math.min(1, 0.45 + v61.effectScale * 0.2)
            })
        end, {
            v35,
            v33,
            v24,
            v28,
            v49,
            v61.effectScale
        })
        useEffect(function() -- line: 504
            -- upvalues: v30 (copy), v51 (copy), v61 (copy)
            if v30 == 0 then
                return nil
            end

            v51:immediate(0)
            v51:linear(1, {
                speed = 1 / (0.62 + v61.effectScale * 0.08)
            })
        end, {
            v61.effectScale,
            v51,
            v30
        })
        useEffect(function() -- line: 513
            -- upvalues: awaitingInput (copy), v39 (copy), v43 (copy), v53 (copy), v61 (copy), playClonedSound (copy)
            if awaitingInput == "awaitingInput" or awaitingInput == "upgrading" then
                local effectScale = v61.effectScale
                local v100 = 0.72 / (0.6 + effectScale * 0.4)
                local v101 = 4.5 * effectScale
                local v102 = 0.07 / (0.7 + effectScale * 0.3)
                local v103 = true

                local function v104() -- line: 525
                    -- upvalues: effectScale (copy), v100 (copy), v103 (ref), v39 (copy)
                    v39:tween(if v103 then 0.18 * effectScale else -0.063 * effectScale, {
                        direction = Enum.EasingDirection.InOut,
                        style = Enum.EasingStyle.Sine,
                        time = v100
                    })
                    v103 = not v103
                end

                v104()

                local v106 = v39:onComplete(v104)

                v53:linear(1, {
                    speed = 0.42 * effectScale
                })

                local v107 = v53:onComplete(function() -- line: 541
                    -- upvalues: effectScale (copy), v53 (copy)
                    v53:immediate(0)
                    v53:linear(1, {
                        speed = 0.42 * effectScale
                    })
                end)
                local v108 = true
                local v109 = task.spawn(function() -- line: 546
                    -- upvalues: effectScale (copy), v101 (copy), v102 (copy), v108 (ref), v43 (copy), v61 (copy), playClonedSound (copy)
                    while v108 do
                        task.wait(math.random(24, 42) / (10 * effectScale))
                        playClonedSound("CrateShakingSound")

                        local n2 = 0
                        local v110 = false

                        while true do
                            if v110 then
                                n2 += 1
                            else
                                v110 = true
                            end

                            if n2 <= v61.upgradeRingCount then
                                v43:tween(-v101, {
                                    direction = Enum.EasingDirection.Out,
                                    style = Enum.EasingStyle.Quad,
                                    time = v102
                                })
                                task.wait(v102)
                                v43:tween(v101, {
                                    direction = Enum.EasingDirection.InOut,
                                    style = Enum.EasingStyle.Quad,
                                    time = v102 * 1.35
                                })
                                task.wait(v102 * 1.35)
                                continue
                            end

                            break
                        end

                        v43:tween(0, {
                            direction = Enum.EasingDirection.Out,
                            style = Enum.EasingStyle.Back,
                            time = 0.14 / effectScale
                        })
                    end
                end)

                return function() -- line: 583
                    -- upvalues: v106 (copy), v107 (copy), v108 (ref), v109 (copy), v39 (copy), v43 (copy)
                    v108 = false
                    v106()
                    v107()
                    task.cancel(v109)
                    v39:immediate(0)
                    v43:immediate(0)
                end
            end

            v39:immediate(0)
            v43:immediate(0)

            return nil
        end, {
            v53,
            v39,
            v43,
            awaitingInput,
            v61.effectScale,
            v61.upgradeRingCount
        })
        useEffect(function() -- line: 592
            -- upvalues: v55 (copy)
            v55:linear(360, {
                speed = 20
            })

            return (v55:onComplete(function() -- line: 599
                -- upvalues: v55 (copy)
                v55:immediate(0)
                v55:linear(360, {
                    speed = 20
                })
            end))
        end, { v55 })
        useEffect(function() -- line: 605
            -- upvalues: awaitingInput (copy), v41 (copy)
            if awaitingInput == "opening" then
                v41:tween(360, {
                    time = 0.72,
                    direction = Enum.EasingDirection.Out,
                    style = Enum.EasingStyle.Quad
                })
            else
                if awaitingInput == "finishingTaps" then
                    v41:linear(360, {
                        speed = 180
                    })

                    return (v41:onComplete(function() -- line: 624
                        -- upvalues: v41 (copy)
                        v41:immediate(0)
                        v41:linear(360, {
                            speed = 180
                        })
                    end))
                end

                v41:immediate(0)
            end

            return nil
        end, { v41, awaitingInput })
        useEffect(function() -- line: 630
            -- upvalues: awaitingInput (copy), v28 (copy), v37 (copy), v45 (copy)
            if v28 == 0 and awaitingInput ~= "opening" then
                return nil
            end

            local v111 = task.spawn(function() -- line: 634
                -- upvalues: v37 (copy), v45 (copy)
                v37:immediate(0)
                v45:immediate(0)
                v45:tween(360, {
                    time = 0.61,
                    direction = Enum.EasingDirection.InOut,
                    style = Enum.EasingStyle.Quad
                })
                v37:tween(1, {
                    time = 0.12,
                    direction = Enum.EasingDirection.In,
                    style = Enum.EasingStyle.Quad
                })
                task.wait(0.12)
                task.wait(0.05)
                v37:tween(-1, {
                    time = 0.18,
                    direction = Enum.EasingDirection.Out,
                    style = Enum.EasingStyle.Back
                })
                task.wait(0.18)
                task.wait(0.06)
                v37:tween(0, {
                    time = 0.2,
                    direction = Enum.EasingDirection.Out,
                    style = Enum.EasingStyle.Quad
                })
                task.wait(0.2)
                v37:immediate(0)
                v45:immediate(0)
            end)

            return function() -- line: 665
                -- upvalues: v111 (copy)
                return task.cancel(v111)
            end
        end, { v37, v45, awaitingInput, v28 })
        useEffect(function() -- line: 669
            -- upvalues: onFinished (copy), v23 (copy), awaitingInput (copy), v47 (copy)
            if awaitingInput ~= "opening" then
                return nil
            end

            v23.current = 1e999
            v47:immediate(0)

            local v112 = task.spawn(function() -- line: 675
                -- upvalues: onFinished (copy), v47 (copy)
                v47:linear(1, {
                    speed = 1.3888888888888888
                })
                task.wait(0.72)
                onFinished()
            end)

            return function() -- line: 682
                -- upvalues: v112 (copy)
                return task.cancel(v112)
            end
        end, { onFinished, v47, awaitingInput })
        useBindingListener(v36, function(p10) -- line: 686
            -- upvalues: v15 (copy), v62 (copy)
            v15.current = p10
            v62()
        end)
        useBindingListener(v40, function(p11) -- line: 690
            -- upvalues: v17 (copy), v62 (copy)
            v17.current = p11
            v62()
        end)
        useBindingListener(v38, function(p12) -- line: 694
            -- upvalues: v16 (copy), v62 (copy)
            v16.current = p12
            v62()
        end)
        useBindingListener(v42, function(p13) -- line: 698
            -- upvalues: v18 (copy), v62 (copy)
            v18.current = p13
            v62()
        end)
        useBindingListener(v44, function(p14) -- line: 702
            -- upvalues: v19 (copy), v62 (copy)
            v19.current = p14
            v62()
        end)
        useBindingListener(v46, function(p15) -- line: 706
            -- upvalues: v21 (copy), v62 (copy)
            v21.current = p15
            v62()
        end)

        if v9 == nil then
            return nil
        end

        v44 = awaitingInput == "awaitingInput" or awaitingInput == "upgrading"

        local v113 = react.createElement("uigradient", {
            Rotation = 90,
            Color = v61.background
        })
        local v114 = react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0.48,
            ZIndex = 201,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.shineBackground,
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0.5, 0.52),
            Rotation = v54,
            Size = UDim2.fromScale(0.96, 1.18)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1,
            DominantAxis = Enum.DominantAxis.Height
        }))
        local v115 = react.createElement

        v57 = {
            BackgroundTransparency = 1,
            ZIndex = 202,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.shineBackground,
            ImageColor3 = v61.glowColor
        }
        v57.ImageTransparency = v34:map(function(p16) -- line: 737
            -- upvalues: v61 (copy)
            return (math.clamp(0.38 - p16 * (0.2 + v61.effectScale * 0.08), 0.02, 0.5))
        end)
        v57.Position = UDim2.fromScale(0.5, 0.52)
        v57.Rotation = v32:map(function(p17) -- line: 741
            -- upvalues: v28 (copy)
            return v28 * 24 + p17 * 35
        end)
        v57.Size = UDim2.fromScale(0.92, 1.08)
        v115 = v115("imagelabel", v57, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1,
            DominantAxis = Enum.DominantAxis.Height
        }))

        local v117 = table.create(#t3)

        v36 = function(p18, p19) -- line: 752
            -- upvalues: v28 (copy), v48 (copy), v61 (copy), react (copy)
            return react.createElement("frame", {
                BackgroundTransparency = 1,
                ZIndex = 203,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.52),
                Size = v48:map(function(p20) -- line: 757
                    -- upvalues: p18 (copy), v61 (copy)
                    local v120 = 0.15 + (1 - math.pow(1 - math.clamp((p20 - p18) / (1 - p18), 0, 1), 3)) * 0.72 * v61.effectScale

                    return UDim2.fromScale(v120, v120)
                end),
                Visible = v28 > 0,
                key = ("tap-burst-ring-%*"):format(p19)
            }, react.createElement("uiaspectratioconstraint", {
                AspectRatio = 1,
                DominantAxis = Enum.DominantAxis.Height
            }), react.createElement("uicorner", {
                CornerRadius = UDim.new(1, 0)
            }), react.createElement("uistroke", {
                Color = v61.glowColor,
                Thickness = v48:map(function(p21) -- line: 772
                    -- upvalues: p18 (copy), v61 (copy)
                    return (7 - math.clamp((p21 - p18) / (1 - p18), 0, 1) * 4) * v61.effectScale
                end),
                Transparency = v48:map(function(p22) -- line: 776
                    -- upvalues: p18 (copy)
                    if p22 < p18 then
                        return 1
                    end

                    return (math.clamp(math.clamp((p22 - p18) / (1 - p18), 0, 1) * 1.18, 0, 1))
                end)
            }))
        end

        for v126, v127 in t3 do
            v117[v126] = v36(v127, v126 - 1, t3)
        end

        local v128 = table.create(#t4)

        local function v129(p23, p24) -- line: 791
            -- upvalues: v30 (copy), v50 (copy), v61 (copy), react (copy)
            if p24 < v61.upgradeRingCount then
                return (react.createElement("frame", {
                    BackgroundTransparency = 1,
                    ZIndex = 206,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.52),
                    Size = v50:map(function(p25) -- line: 796
                        -- upvalues: p23 (copy), v61 (copy)
                        local v132 = 0.2 + (1 - math.pow(1 - math.clamp((p25 - p23) / (1 - p23), 0, 1), 3)) * (0.62 + v61.effectScale * 0.22)

                        return UDim2.fromScale(v132, v132)
                    end),
                    Visible = v30 > 0,
                    key = ("tier-up-burst-ring-%*"):format(p24)
                }, react.createElement("uiaspectratioconstraint", {
                    AspectRatio = 1,
                    DominantAxis = Enum.DominantAxis.Height
                }), react.createElement("uicorner", {
                    CornerRadius = UDim.new(1, 0)
                }), react.createElement("uistroke", {
                    Color = if p24 % 2 == 0 then Color3.fromRGB(255, 255, 255) else v61.glowColor,
                    Thickness = v50:map(function(p26) -- line: 811
                        -- upvalues: p23 (copy), v61 (copy)
                        return (10 - math.clamp((p26 - p23) / (1 - p23), 0, 1) * 6) * v61.effectScale
                    end),
                    Transparency = v50:map(function(p27) -- line: 815
                        -- upvalues: p23 (copy)
                        if p27 < p23 then
                            return 1
                        end

                        return (math.clamp(math.clamp((p27 - p23) / (1 - p23), 0, 1) * 1.08, 0, 1))
                    end)
                })))
            end

            return false
        end

        for v138, v139 in t4 do
            v128[v138] = v129(v139, v138 - 1, t4)
        end

        v129 = table.create(#t2)

        local function v140(p28, p29) -- line: 830
            -- upvalues: v28 (copy), v48 (copy), v61 (copy), react (copy), v2 (copy)
            return react.createElement("frame", {
                BorderSizePixel = 0,
                ZIndex = 204,
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = v61.glowColor,
                BackgroundTransparency = v48:map(function(p30) -- line: 834
                    -- upvalues: p28 (copy)
                    if p30 < p28.phase then
                        return 1
                    end

                    return (math.clamp((math.clamp((p30 - p28.phase) / (1 - p28.phase), 0, 1) - 0.18) / 0.72, 0, 1))
                end),
                Position = v48:map(function(p31) -- line: 842
                    -- upvalues: p28 (copy)
                    local v145 = 1 - math.pow(1 - math.clamp((p31 - p28.phase) / (1 - p28.phase), 0, 1), 3)

                    return UDim2.fromScale(p28.startPosition.X + (p28.endPosition.X - p28.startPosition.X) * v145, p28.startPosition.Y + (p28.endPosition.Y - p28.startPosition.Y) * v145)
                end),
                Rotation = v48:map(function(p32) -- line: 847
                    -- upvalues: p28 (copy), p29 (copy)
                    return p28.rotation + p32 * (if p29 % 2 == 0 then 12 else -12)
                end),
                Size = v48:map(function(p33) -- line: 850
                    -- upvalues: p28 (copy), v61 (copy)
                    local v147 = math.clamp((p33 - p28.phase) / (1 - p28.phase), 0, 1)

                    return UDim2.fromScale(0.012 * v61.effectScale * (1 - v147 * 0.45), 0.08 + math.sin(v147 * 3.141592653589793) * 0.13 * v61.effectScale)
                end),
                Visible = v28 > 0,
                key = ("tap-beam-%*"):format(p29)
            }, react.createElement("uicorner", {
                CornerRadius = UDim.new(1, 0)
            }), react.createElement("uigradient", {
                Rotation = 90,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, v61.glowColor)
                }),
                Transparency = v2
            }))
        end

        for v150, v151 in t2 do
            v129[v150] = v140(v151, v150 - 1, t2)
        end

        v140 = table.create(#t5)

        v57 = function(p34, p35) -- line: 871
            -- upvalues: v52 (copy), v61 (copy), react (copy), images (copy)
            if p35 < v61.ambientSparkleCount then
                return (react.createElement("imagelabel", {
                    BackgroundTransparency = 1,
                    ZIndex = 204,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = images.sparkleIcon,
                    ImageColor3 = v61.glowColor,
                    ImageTransparency = v52:map(function(p36) -- line: 877
                        -- upvalues: p34 (copy)
                        return 1 - math.sin((p36 + p34.phase) % 1 * 3.141592653589793) * 0.82
                    end),
                    Position = v52:map(function(p37) -- line: 881
                        -- upvalues: p34 (copy), v61 (copy)
                        local v153 = (p37 + p34.phase) % 1
                        local v154 = 1 + (v61.effectScale - 1) * 1.6

                        return UDim2.fromScale(p34.startPosition.X + (p34.endPosition.X - p34.startPosition.X) * v153 * v154, p34.startPosition.Y + (p34.endPosition.Y - p34.startPosition.Y) * v153 * v154)
                    end),
                    Rotation = v52:map(function(p38) -- line: 886
                        -- upvalues: p34 (copy), v61 (copy)
                        return p38 * 180 * v61.effectScale + p34.phase * 360
                    end),
                    Size = v52:map(function(p39) -- line: 889
                        -- upvalues: p34 (copy), v61 (copy)
                        local v155 = (p39 + p34.phase) % 1
                        local v158 = p34.size * v61.effectScale * (math.sin(v155 * 3.141592653589793) * 0.75 + 0.55)

                        return UDim2.fromScale(v158, v158)
                    end),
                    key = ("ambient-sparkle-%*"):format(p35)
                }, react.createElement("uiaspectratioconstraint", {
                    AspectRatio = 1
                })))
            end

            return false
        end

        for v159, v160 in t5 do
            v140[v159] = v57(v160, v159 - 1, t5)
        end

        v57 = table.create(#t1)

        local function v161(p40, p41) -- line: 906
            -- upvalues: v48 (copy), v61 (copy), react (copy), images (copy)
            return react.createElement("imagelabel", {
                BackgroundTransparency = 1,
                ZIndex = 207,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Image = images.sparkleIcon,
                ImageColor3 = v61.glowColor,
                ImageTransparency = v48:map(function(p42) -- line: 912
                    -- upvalues: p40 (copy)
                    if p42 < p40.phase then
                        return 1
                    end

                    return (math.clamp((p42 - 0.35 - p40.phase) / 0.5, 0, 1))
                end),
                Position = v48:map(function(p43) -- line: 915
                    -- upvalues: p40 (copy)
                    local v165 = 1 - math.pow(1 - math.clamp((p43 - p40.phase) / (1 - p40.phase), 0, 1), 3)

                    return UDim2.fromScale(p40.startPosition.X + (p40.endPosition.X - p40.startPosition.X) * v165, p40.startPosition.Y + (p40.endPosition.Y - p40.startPosition.Y) * v165)
                end),
                Rotation = v48:map(function(p44) -- line: 920
                    -- upvalues: p41 (copy)
                    return p44 * 300 * (if p41 % 2 == 0 then 1 else -1)
                end),
                Size = v48:map(function(p45) -- line: 923
                    -- upvalues: p40 (copy), v61 (copy)
                    local v167 = math.clamp((p45 - p40.phase) / (1 - p40.phase), 0, 1)
                    local v170 = p40.size * v61.effectScale * (math.sin(v167 * 3.141592653589793) * 0.9 + 0.45)

                    return UDim2.fromScale(v170, v170)
                end),
                key = ("tap-sparkle-%*"):format(p41)
            }, react.createElement("uiaspectratioconstraint", {
                AspectRatio = 1
            }))
        end

        for v171, v172 in t1 do
            v57[v171] = v161(v172, v171 - 1, t1)
        end

        v161 = react.createElement(default2, {
            cameraFov = 34,
            cameraCFrame = v46:map(function(p46) -- line: 939
                local v175 = 1 - math.pow(1 - p46, 3)
                local v176 = 20.83 + 4.860000000000003 * v175

                return CFrame.new(Vector3.new(0, 0.8, -v176), (Vector3.new(0, 0.35 + v175 * 0.3, 0)))
            end),
            getPrefabInstance = function() -- getPrefabInstance | line: 945
                -- upvalues: v9 (copy)
                return v9
            end,
            onPrefabInstantiated = v89,
            prefabRef = v11,
            viewportFrameProps = {
                BackgroundTransparency = 1,
                LightDirection = Vector3.new(-1, -0.8, -0.4),
                ZIndex = 205,
                Ambient = Color3.fromRGB(205, 205, 235),
                AnchorPoint = Vector2.new(0.5, 0.5),
                ImageTransparency = v46:map(function(p47) -- line: 954
                    return (math.clamp((p47 - 0.82) / 0.18, 0, 1))
                end),
                LightColor = Color3.fromRGB(255, 246, 221),
                Position = v32:map(function(p48) -- line: 959
                    return UDim2.fromScale(0.5 + p48 * 0.012, 0.53 - p48 * 0.008)
                end),
                Rotation = v32:map(function(p49) -- line: 962
                    return p49 * 4.5
                end),
                Size = UDim2.fromScale(1, 1)
            }
        })

        local v181 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.025, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        })
        local v182 = table.create(#aquariumCratePresentationTiers)

        v11 = function(p50, p51) -- line: 978
            -- upvalues: v24 (copy), v60 (copy), react (copy), default (copy), rarityColorGradients (copy)
            return react.createElement(default, {
                shadowYScale = 0.045,
                text = "★",
                color = if p51 < v24 then rarityColorGradients[v60].color else Color3.fromRGB(58, 59, 82),
                key = p50,
                overrideProps = {
                    TextScaled = true,
                    ZIndex = 211,
                    Font = Enum.Font.GothamBlack,
                    LayoutOrder = p51,
                    Size = UDim2.fromScale(0.21, 1)
                },
                strokeProps = {
                    Thickness = 0.07,
                    Color = if p51 < v24 then rarityColorGradients[v60].borderColor else Color3.fromRGB(18, 19, 32)
                }
            })
        end

        for v183, v184 in aquariumCratePresentationTiers do
            v182[v183] = v11(v184, v183 - 1, aquariumCratePresentationTiers)
        end

        v181 = react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 210,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.08),
            Size = UDim2.fromScale(0.32, 0.075)
        }, v181, v182)
        v89 = {
            shadowYScale = 0.055,
            anchorPoint = Vector2.new(0.5, 0),
            color = rarityColorGradients[v60].color,
            overrideProps = {
                TextScaled = true,
                ZIndex = 211,
                Font = Enum.Font.GothamBlack,
                Size = UDim2.fromScale(0.34, 0.07)
            },
            position = UDim2.fromScale(0.5, 0.16),
            strokeProps = {
                Thickness = 0.075,
                Color = rarityColorGradients[v60].borderColor
            }
        }

        local v185

        if aquariumCrateUpgradeAttemptCount <= v24 then
            v185 = "TAP TO OPEN!"
        else
            v185 = if v56 ~= nil then string.upper(v56) else v56

            if v185 == nil then
                v185 = "TAP!!!"
            end
        end

        v89.text = v185

        local v173 = react.createElement
        local t20 = {
            Active = true,
            BorderSizePixel = 0,
            ZIndex = 200,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.fromScale(1, 1)
        }
        local v186 = react.createElement(default, v89)
        local v187 = v30 > 0 and react.createElement(default, {
            shadowYScale = 0.05,
            text = "TIER UP!",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(255, 255, 255),
            overrideProps = {
                TextScaled = true,
                ZIndex = 218,
                Font = Enum.Font.GothamBlack,
                Size = UDim2.fromScale(0.34 + v61.effectScale * 0.08, 0.07 + v61.effectScale * 0.02),
                TextTransparency = v50
            },
            position = UDim2.fromScale(0.5, 0.31),
            strokeProps = {
                Thickness = 0.08,
                Color = v61.shadowColor
            }
        })
        local createElement = react.createElement("frame", {
            BorderSizePixel = 0,
            ZIndex = 220,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = v34:map(function(p52) -- line: 1064
                -- upvalues: v61 (copy)
                return 1 - p52 * math.min(0.94, 0.58 + v61.effectScale * 0.18)
            end),
            Size = UDim2.fromScale(1, 1)
        })

        return v173("frame", t20, v113, v114, v115, v117, v128, v129, v140, v57, v161, v181, v186, v187, createElement, react.createElement("frame", {
            BorderSizePixel = 0,
            ZIndex = 221,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = v46:map(function(p53) -- line: 1072
                return 1 - math.clamp((p53 - 0.58) / 0.28, 0, 1)
            end),
            Size = UDim2.fromScale(1, 1)
        }), react.createElement("textbutton", {
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
            ZIndex = 230,
            Active = v44,
            Event = {
                Activated = v90
            },
            Size = UDim2.fromScale(1, 1)
        }))
    end
}
