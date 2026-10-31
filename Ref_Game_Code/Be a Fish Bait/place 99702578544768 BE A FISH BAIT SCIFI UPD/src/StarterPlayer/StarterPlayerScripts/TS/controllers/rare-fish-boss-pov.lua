-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local GuiService, RunService, Workspace = services.GuiService, services.RunService, services.Workspace
local v1 = RuntimeLib.import(script, script.Parent.Parent, "fishing-phase-atom")
local bossActivePromptAtom, bossWeakSpotsAtom = v1.bossActivePromptAtom, v1.bossWeakSpotsAtom
local playRareFishBossSfxCue = RuntimeLib.import(script, script.Parent.Parent, "react", "screen", "fishing", "rare-fish-boss", "boss-sfx").playRareFishBossSfxCue
local weakSpotOffsets = RuntimeLib.import(script, script.Parent.Parent, "react", "screen", "fishing", "rare-fish-boss", "boss-config").weakSpotOffsets
local v2 = RuntimeLib.import(script, script.Parent, "rare-fish-boss-vfx")
local cloneRareFishVfx, playRareFishVfx, setRareFishVfxEnabled = v2.cloneRareFishVfx, v2.playRareFishVfx, v2.setRareFishVfxEnabled
local createBossArmViewmodel = RuntimeLib.import(script, script.Parent, "rare-fish-boss-viewmodel").createBossArmViewmodel
local t1 = {
    targetDisplaySize = 12,
    camBackOffset = -0.4,
    camHeightOffset = 0.4,
    fishHeadDownTiltDeg = -20,
    fishForwardBase = 2,
    fishForwardSizeFactor = 0.48,
    fishHeightAboveBait = 0.4,
    fov = 90,
    viewmodelEnabled = true,
    viewmodelScale = 2.05,
    viewmodelSideOffsetX = 0.65,
    viewmodelOffsetY = -0.1,
    viewmodelOffsetZ = -0.32
}
local t2 = {
    great = {
        fovKick = 4,
        recoilDistance = 1.15,
        shakeDuration = 0.14,
        shakeMagnitude = 0.34
    },
    miss = {
        fovKick = -2,
        recoilDistance = -0.7,
        shakeDuration = 0.22,
        shakeMagnitude = 0.4
    },
    okay = {
        fovKick = 2,
        recoilDistance = 0.65,
        shakeDuration = 0.1,
        shakeMagnitude = 0.16
    },
    perfect = {
        fovKick = 6,
        recoilDistance = 1.55,
        shakeDuration = 0.2,
        shakeMagnitude = 0.5
    }
}
local t3 = {
    intro = 1,
    rage = 1.7,
    struggle = 1.3
}
local t4 = {
    punch = true,
    slap = true,
    counter = true,
    strike = true,
    brace = true
}
local t5 = {
    Duck = -2.4,
    SeahorseGhost = -2.8,
    SeahorseWarrior = -2.8
}

return {
    startRareFishBossPov = function(p1) -- startRareFishBossPov | line: 100
        -- upvalues: Maid (copy), GuiService (copy), RunService (copy), Workspace (copy), bossActivePromptAtom (copy), bossWeakSpotsAtom (copy), playRareFishBossSfxCue (copy), weakSpotOffsets (copy), cloneRareFishVfx (copy), playRareFishVfx (copy), setRareFishVfxEnabled (copy), createBossArmViewmodel (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy)
        local aimPosition, camera, fishModel, rig = p1.aimPosition, p1.camera, p1.fishModel, p1.rig
        local v3 = Maid.new()
        local v4 = t5[fishModel.Name]

        if v4 == nil then
            v4 = 0
        end

        local clone = fishModel:Clone()

        clone:RemoveTag("FishingZoneFish")

        local Highlight = clone:FindFirstChildOfClass("Highlight")

        if Highlight ~= nil then
            Highlight:Destroy()
        end

        clone.Parent = Workspace
        v3:GiveTask(clone)

        local t6 = {}

        for _, descendant in clone:GetDescendants() do
            if descendant:IsA("BasePart") then
                table.insert(t6, descendant)
            end
        end

        local v5 = clone.PrimaryPart or t6[1]

        if v5 ~= nil then
            clone.PrimaryPart = v5
            v5.Anchored = true

            for _, v6 in t6 do
                v6.LocalTransparencyModifier = 0
                v6.CanCollide = false

                if v6 ~= v5 then
                    v6.Anchored = false

                    local WeldConstraint = Instance.new("WeldConstraint")

                    WeldConstraint.Part0 = v5
                    WeldConstraint.Part1 = v6
                    WeldConstraint.Parent = v5
                end
            end
        end

        local _, BoundingBox = clone:GetBoundingBox()
        local v7 = math.max(BoundingBox.X, BoundingBox.Y, BoundingBox.Z)

        if v7 > 0.001 then
            clone:ScaleTo((math.clamp(t1.targetDisplaySize / v7, 0.1, 16)))
        end

        local _, BoundingBox2 = clone:GetBoundingBox()
        local v9 = BoundingBox2.X / 2
        local v10 = BoundingBox2.Y / 2
        local v11 = BoundingBox2.Z / 2
        local v12 = math.max(BoundingBox2.X, BoundingBox2.Y, BoundingBox2.Z)
        local v13 = rig:FindFirstChild("HumanoidRootPart", true) or rig:FindFirstChild("HumanoidPart", true)
        local Position = if if v13 == nil then v13 else v13:IsA("BasePart") then v13.Position else rig:GetPivot().Position
        local v14 = Vector3.new(camera.CFrame.LookVector.X, 0, camera.CFrame.LookVector.Z)
        local v15 = if v14.Magnitude > 0.001 then v14.Unit else Vector3.new(0, 0, -1)
        local v16 = aimPosition or Position + v15
        local v19 = Vector3.new(v16.X - Position.X, 0, v16.Z - Position.Z)
        local v20 = if v19.Magnitude > 0.001 then v19.Unit else Vector3.new(0, 0, -1)

        rig:PivotTo(CFrame.lookAt(Position, Position + v20, (Vector3.new(0, 1, 0))))

        local v21 = rig:FindFirstChild("Head", true)

        if not (if v21 == nil then v21 else v21:IsA("BasePart")) then
            v21 = nil
        end

        local v22 = if v21 == nil then v21 else v21.Position

        if v22 == nil then
            v22 = Position + Vector3.new(0, 1.5, 0)
        end

        local function computeFraming() -- line: 202
            -- upvalues: v4 (ref), v12 (copy), v20 (copy), v22 (ref), t1 (copy)
            local v24 = v20 * (t1.fishForwardBase + v12 * t1.fishForwardSizeFactor)
            local v27 = v22 + v24 + Vector3.new(0, t1.fishHeightAboveBait + v4, 0)
            local v28 = v20 * t1.camBackOffset
            local v30 = v22 - v28 + Vector3.new(0, t1.camHeightOffset, 0)

            return {
                baseFishCFrame = CFrame.lookAt(v27, v30, (Vector3.new(0, 1, 0))) * CFrame.Angles(math.rad(t1.fishHeadDownTiltDeg), 0, 0),
                camEyeBase = v30,
                fishCenter = v27
            }
        end

        local function currentEye(p2) -- line: 227
            -- upvalues: v21 (ref), v22 (ref)
            if v21 == nil or v21.Parent == nil then
                return p2
            end

            return p2 + (v21.Position - v22)
        end

        local v32 = computeFraming()

        camera.CameraType = Enum.CameraType.Scriptable
        camera.CFrame = CFrame.lookAt(v32.camEyeBase, v32.fishCenter, (Vector3.new(0, 1, 0)))
        camera.FieldOfView = t1.fov
        playRareFishBossSfxCue("povEnter")

        local v33 = if t1.viewmodelEnabled then createBossArmViewmodel(rig, {
            offsetY = t1.viewmodelOffsetY,
            offsetZ = t1.viewmodelOffsetZ,
            scale = t1.viewmodelScale,
            sideOffsetX = t1.viewmodelSideOffsetX
        }) else nil

        if v33 ~= nil then
            v3:GiveTask(function() -- line: 250
                -- upvalues: v33 (copy)
                return v33:destroy()
            end)
        end

        local v34 = Vector3.new()
        local t7 = {}

        t7[1] = v34

        local v35 = Vector3.new()
        local t8 = {}

        t8[1] = v35

        local v36 = CFrame.new()
        local t9 = {}

        t9[1] = v36

        local v37 = CFrame.new()
        local t10 = {}

        t10[1] = v37

        local n1 = 0
        local n2 = 0
        local n3 = 0
        local n4 = 0
        local v38 = "intro"
        local v39 = v32.baseFishCFrame
        local elapsed
        local v40 = v32.baseFishCFrame
        local _CFrame = camera.CFrame
        local n5 = 0
        local Part
        local v41 = false

        local function ensureGlowHolder() -- line: 274
            -- upvalues: v3 (copy), Part (ref), Workspace (copy), cloneRareFishVfx (copy), setRareFishVfxEnabled (copy)
            if Part ~= nil then
                return Part
            end

            local Part2 = Instance.new("Part")

            Part2.Anchored = true
            Part2.CanCollide = false
            Part2.CanQuery = false
            Part2.CanTouch = false
            Part2.Transparency = 1
            Part2.Size = Vector3.new(1, 1, 1)
            Part2.Parent = Workspace

            local v42 = cloneRareFishVfx("WeakSpotGlow", Part2)

            if v42 ~= nil then
                setRareFishVfxEnabled(v42, false)
            end

            Part = Part2
            v3:GiveTask(Part2)

            return Part2
        end

        local elapsed2 = os.clock()

        playRareFishVfx({
            name = "BubblesUp",
            cleanupAfterSeconds = 3,
            cframe = v32.baseFishCFrame
        })

        local function weakSpotWorld(p3, p4) -- line: 301
            -- upvalues: v9 (copy), v10 (copy), v11 (copy), weakSpotOffsets (copy)
            local v43

            for v44, v45 in weakSpotOffsets do
                local _ = v44 - 1

                if v45.id == p4 == true then
                    v43 = v45
                    break
                end

                v43 = nil
            end

            return if v43 ~= nil then (p3 * CFrame.new(v43.x * v9, v43.y * v10, v43.z * v11)).Position else nil
        end

        local GuiInset = GuiService:GetGuiInset()

        v3:GiveTask((RunService.RenderStepped:Connect(function(p5) -- line: 323
            -- upvalues: camera (copy), clone (copy), v5 (copy), v9 (copy), v10 (copy), v11 (copy), v12 (copy), v21 (ref), v22 (ref), computeFraming (copy), v33 (copy), t7 (copy), t8 (copy), t9 (copy), t10 (copy), n1 (ref), n2 (ref), n3 (ref), n4 (ref), v38 (ref), v39 (ref), elapsed (ref), v40 (ref), _CFrame (ref), n5 (ref), Part (ref), v41 (ref), ensureGlowHolder (copy), elapsed2 (copy), weakSpotWorld (copy), GuiInset (copy), bossActivePromptAtom (copy), bossWeakSpotsAtom (copy), weakSpotOffsets (copy), setRareFishVfxEnabled (copy), t1 (copy), t3 (copy)
            local v46 = os.clock() - elapsed2
            local v47 = t3[v38]
            local v48 = computeFraming()
            local fishCenter = v48.fishCenter
            local v50 = math.sin(v46 * 2.5) * 0.15 * v47
            local v52 = math.sin(v46 * 1.7) * 0.08 * v47
            local v54 = math.sin(v46 * 0.9) * 0.06981317007977318 * v47
            local baseFishCFrame = v48.baseFishCFrame
            local v55 = CFrame.new(v52, v50, 0)
            local v56 = CFrame.Angles(0, v54, 0)
            local v57 = baseFishCFrame * v55 * v56
            local v59 = math.min(p5 * 13, 1)
            local v61 = math.min(p5 * 5.2, 1)

            t7[1] = t7[1]:Lerp(t8[1], v59)
            t8[1] = t8[1]:Lerp(Vector3.new(), v61)
            t9[1] = t9[1]:Lerp(t10[1], v59)
            t10[1] = t10[1]:Lerp(CFrame.new(), v61)

            local v62 = v57 * t9[1] + t7[1]
            local v63 = if elapsed == nil then nil else os.clock() - elapsed

            if v63 ~= nil then
                local v66 = 1 - math.pow(1 - math.clamp(v63 / 1.75, 0, 1), 3)
                local v67 = CFrame.lookAt(v40.Position, camera.CFrame.Position) * CFrame.Angles(0, 0, 3.141592653589793)

                v62 = v40:Lerp(v67, v66)
                t7[1] = Vector3.new()
                t8[1] = Vector3.new()
                t9[1] = CFrame.new()
                t10[1] = CFrame.new()
            end

            v39 = v62

            if v5 ~= nil then
                clone:PivotTo(v62)
            end

            local lookAt = CFrame.lookAt
            local camEyeBase = v48.camEyeBase

            if v21 ~= nil and v21.Parent ~= nil then
                camEyeBase += v21.Position - v22
            end

            local v68 = lookAt(camEyeBase, fishCenter, (Vector3.new(0, 1, 0)))
            local v69 = CFrame.new()

            if n3 < n2 then
                n3 += p5

                local v71 = math.max(1 - n3 / n2, 0)
                local v72 = n1 * v71

                n5 += 1

                local v73 = (math.noise(n5 * 0.3, 0) - 0) * v72
                local v74 = (math.noise(0, n5 * 0.3) - 0) * v72

                v69 = CFrame.new(v73, v74, 0) * CFrame.Angles(math.rad(v74 * 8), math.rad(v73 * 8), 0)
            end

            local v79 = v68 * v69

            if v63 ~= nil then
                local v82 = 1 - math.pow(1 - math.clamp(v63 / 1.75, 0, 1), 3)
                local Position = v62.Position
                local v83 = Position - _CFrame.Position
                local v88 = Position - (if v83.Magnitude > 0.001 then v83.Unit else camera.CFrame.LookVector) * math.max(v12 * 0.62, 2.5) + Vector3.new(0, v12 * 0.08, 0)
                local v89 = CFrame.lookAt(v88, Position, (Vector3.new(0, 1, 0)))

                v79 = _CFrame:Lerp(v89, v82)
            end

            camera.CFrame = v79
            n4 += (0 - n4) * math.min(p5 * 6, 1)
            camera.FieldOfView = t1.fov + n4

            if v33 ~= nil then
                v33:update(camera)
            end

            local t11 = {}

            for _, v93 in weakSpotOffsets do
                local v94, v95 = camera:WorldToViewportPoint((v62 * CFrame.new(v93.x * v9, v93.y * v10, v93.z * v11)).Position)

                t11[v93.id] = {
                    onScreen = v95 and v94.Z > 0,
                    x = v94.X - GuiInset.X,
                    y = v94.Y - GuiInset.Y
                }
            end

            bossWeakSpotsAtom(t11)

            local v96 = bossActivePromptAtom()
            local v97 = if v96 == nil then nil else weakSpotWorld(v62, v96.weakSpotId)

            if v97 ~= nil then
                local v98 = ensureGlowHolder()

                if v98 ~= nil then
                    v98.CFrame = CFrame.new(v97)

                    if not v41 then
                        setRareFishVfxEnabled(v98, true)
                        v41 = true
                    end
                end
            elseif v41 and Part ~= nil then
                setRareFishVfxEnabled(Part, false)
                v41 = false
            end
        end)))

        local function playRatingImpactVfx(p6, p7) -- line: 443
            -- upvalues: playRareFishVfx (copy)
            local v99 = CFrame.new(p6)

            if p7 == "perfect" then
                playRareFishVfx({
                    name = "PerfectImpact",
                    cleanupAfterSeconds = 1,
                    cframe = v99
                })
                playRareFishVfx({
                    name = "ShockwaveRing",
                    cleanupAfterSeconds = 1,
                    cframe = v99
                })
            elseif p7 == "great" then
                playRareFishVfx({
                    name = "GreatImpact",
                    cleanupAfterSeconds = 1,
                    cframe = v99
                })
            elseif p7 == "okay" then
                playRareFishVfx({
                    name = "OkayImpact",
                    cleanupAfterSeconds = 1,
                    cframe = v99
                })
            else
                playRareFishVfx({
                    name = "MissImpact",
                    cleanupAfterSeconds = 0.8,
                    cframe = v99
                })
            end
        end

        return {
            getFishPivot = function(_) -- getFishPivot | line: 481
                -- upvalues: clone (copy), v5 (copy), v39 (ref)
                return if clone.Parent ~= nil and v5 ~= nil then v39 else nil
            end,
            reactToHit = function(_, p10) -- reactToHit | line: 487
                -- upvalues: camera (copy), t8 (copy), t10 (copy), n1 (ref), n2 (ref), n3 (ref), n4 (ref), v39 (ref), n5 (ref), weakSpotWorld (copy), playRatingImpactVfx (copy), playRareFishBossSfxCue (copy), playRareFishVfx (copy), t2 (copy), t4 (copy)
                local v100 = t2[p10.rating]

                n1 = v100.shakeMagnitude
                n2 = v100.shakeDuration
                n3 = 0
                n4 = v100.fovKick

                local v101 = v39.Position - camera.CFrame.Position
                local v102 = if v101.Magnitude > 0.001 then v101.Unit else Vector3.new(0, 0, 1)
                local v103 = math.noise(n5 * 0.7, 1) * 0.3141592653589793
                local v104 = math.noise(1, n5 * 0.7) * 0.24434609527920614
                local RightVector = camera.CFrame.RightVector
                local v105 = Vector3.new()
                local n6 = 0

                if p10.rating ~= "miss" and p10.action == "punch" then
                    v105 = RightVector * -1
                    n6 = 0.6981317007977318
                elseif p10.rating == "miss" then
                elseif p10.action == "slap" then
                    v105 = RightVector
                    n6 = -0.6981317007977318
                end

                local v106 = math.abs(v100.recoilDistance) * 2.4
                local v107 = v102 * v100.recoilDistance
                local v108 = v105 * v106
                local v110 = Vector3.new(0, math.abs(v100.recoilDistance) * 0.22, 0)

                t8[1] = v107 + v108 + v110

                local v111 = if p10.rating == "miss" then 0.08726646259971647 else -math.rad(math.abs(v100.recoilDistance) * 4 + 11)

                t10[1] = CFrame.Angles(v111, v103 + n6 * 0.85, v104 + n6 * 0.75)

                local v113 = weakSpotWorld(v39, p10.weakSpotId)

                if v113 ~= nil then
                    playRatingImpactVfx(v113, p10.rating)

                    local v114 = p10.rating ~= "miss"

                    v114 = v114 and t4[p10.action] ~= nil

                    if v114 then
                        playRareFishVfx({
                            name = "Punch",
                            cleanupAfterSeconds = 2,
                            cframe = CFrame.new(v113)
                        })
                    end
                end

                playRareFishBossSfxCue(p10.rating == "miss" and "fishLunge" or "fishRecoil")

                if p10.rating ~= "miss" then
                    playRareFishBossSfxCue("damageSpot")
                end
            end,
            playSuccessCutscene = function(_) -- playSuccessCutscene | line: 548
                -- upvalues: camera (copy), n1 (ref), n2 (ref), n3 (ref), n4 (ref), v39 (ref), elapsed (ref), v40 (ref), _CFrame (ref), bossActivePromptAtom (copy)
                elapsed = os.clock()
                v40 = v39
                _CFrame = camera.CFrame
                n1 = 0.18
                n2 = 0.2
                n3 = 0
                n4 = -6
                bossActivePromptAtom(nil)
            end,
            telegraphPrompt = function(_, p13) -- telegraphPrompt | line: 558
                -- upvalues: v12 (copy), t7 (copy), t8 (copy), t9 (copy), t10 (copy), n1 (ref), n2 (ref), n3 (ref), n4 (ref), n5 (ref), playRareFishBossSfxCue (copy)
                if p13.action ~= "counter" then
                    return nil
                end

                t7[1] = Vector3.new(0, v12 * 0.04, 0)
                t8[1] = t7[1]
                t9[1] = CFrame.Angles(-0.06981317007977318, math.noise(n5 * 0.5, 2) * 0.08726646259971647, 0)
                t10[1] = t9[1]
                n1 = 0.12
                n2 = 0.1
                n3 = 0
                n4 = -1.5
                playRareFishBossSfxCue("fishLunge")
            end,
            setPhase = function(_, p15) -- setPhase | line: 572
                -- upvalues: v38 (ref), v39 (ref), playRareFishVfx (copy)
                if p15 == "rage" and v38 ~= "rage" then
                    playRareFishVfx({
                        name = "BubblesUp",
                        cleanupAfterSeconds = 3,
                        cframe = v39
                    })
                end

                v38 = p15
            end,
            destroy = function(_) -- destroy | line: 583
                -- upvalues: v3 (copy), Part (ref), bossActivePromptAtom (copy), bossWeakSpotsAtom (copy)
                v3:Destroy()
                Part = nil
                bossActivePromptAtom(nil)
                bossWeakSpotsAtom({})
            end
        }
    end,
    bossPovFraming = t1
}
