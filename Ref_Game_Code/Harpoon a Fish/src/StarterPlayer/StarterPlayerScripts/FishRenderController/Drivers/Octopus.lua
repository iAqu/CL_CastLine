-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr
    local t1 = {
        version = 13,
        cycle = {
            cascade = 0.12,
            restKey = 0,
            keys = {
                {
                    u = 0.06,
                    lag = 0.1,
                    curl = {
                        { 0, -56 },
                        { 0.35, -64 },
                        { 0.7, -92 },
                        { 1, -110 }
                    }
                },
                {
                    u = 0.4,
                    lag = 0.06,
                    curl = {
                        { 0, -50 },
                        { 0.35, -60 },
                        { 0.7, -82 },
                        { 1, -116 }
                    }
                },
                {
                    u = 0.5,
                    lag = 0.08,
                    curl = {
                        { 0, -62 },
                        { 0.35, -72 },
                        { 0.7, -96 },
                        { 1, -125 }
                    }
                },
                {
                    u = 0.58,
                    lag = 0.14,
                    curl = {
                        { 0, -6 },
                        { 0.2, 7 },
                        { 0.5, 12 },
                        { 1, 22 }
                    },
                    biasWeight = {
                        { 0, 0 },
                        { 1, 1 }
                    }
                },
                {
                    u = 0.74,
                    lag = 0,
                    curl = {
                        { 0, -6 },
                        { 0.2, 7 },
                        { 0.5, 12 },
                        { 1, 22 }
                    },
                    biasWeight = {
                        { 0, 0 },
                        { 1, 1 }
                    }
                },
                {
                    u = 0.8,
                    lag = 0.02,
                    curl = {
                        { 0, -62 },
                        { 0.25, -40 },
                        { 0.5, 0 },
                        { 0.75, 28 },
                        { 1, 72 }
                    }
                },
                {
                    u = 0.94,
                    lag = 0.04,
                    through = true,
                    curl = {
                        { 0, -60 },
                        { 0.25, -62 },
                        { 0.5, -80 },
                        { 0.75, -50 },
                        { 1, -10 }
                    }
                }
            },
            head = {
                {
                    u = 0.08,
                    push = -0.2,
                    pitch = -0.04,
                    squash = -0.08,
                    bulge = -0.25
                },
                {
                    u = 0.42,
                    push = -0.25,
                    pitch = -0.05,
                    squash = 0.12,
                    bulge = 0.2
                },
                {
                    u = 0.5,
                    push = -0.9,
                    pitch = -0.25,
                    squash = 0.15,
                    bulge = 0.25
                },
                {
                    u = 0.7,
                    push = 1.3,
                    pitch = 0.2,
                    squash = -0.6,
                    bulge = -0.5
                },
                {
                    u = 0.74,
                    push = 1.3,
                    pitch = 0.2,
                    squash = -0.6,
                    bulge = -0.5
                },
                {
                    u = 0.8,
                    push = 1.1,
                    pitch = 0.12,
                    squash = -0.1,
                    bulge = 0.95
                },
                {
                    u = 0.88,
                    push = 0.5,
                    pitch = 0.06,
                    squash = -0.1,
                    bulge = 0.95
                }
            }
        },
        idle = {
            tempo = 2.2,
            excursion = 0.85,
            pushScale = 0.15
        },
        arms = {
            order = { "L1", "L2", "L3", "L4", "R1", "R2", "R3", "R4" },
            phaseOffsets = { 0.012, 0.004, -0.004, -0.012, 0.01, 0.002, -0.006, -0.014 },
            ampScale = { 0.98, 1.02, 1, 0.97, 1.03, 0.98, 0.99, 1.01 },
            flutter = {
                amp = 16,
                hz = 0.9,
                power = 1.2,
                gateDeg = 60,
                gateFloor = 0.3,
                offsets = { 0, 0.37, 0.74, 0.11, 0.48, 0.85, 0.22, 0.59 }
            },
            closeBias = { 0, 0, -10, -16, 0, 0, -10, -16 }
        },
        timing = {
            powerAt = 0.7,
            signalAhead = 0.18,
            caveInStart = 0.5,
            holdFloor = 0.25,
            retimeRange = { 0.5, 2.5 },
            holdZone = { 0.16, 0.5 }
        },
        rig = {
            segmentsPerArm = 8,
            mantleBones = 3,
            girthBones = 6,
            girthHeightStuds = 0.75,
            boneCount = 82,
            squashSplit = { 0.5, 0.5 }
        }
    }
    local t2 = {
        TAU = 6.283185307179586,
        INTERVAL_MIN = 0.35,
        INTERVAL_MAX = 3,
        IDLE_AFTER = 1.6,
        IDLE_EASE = 1,
        PULSE_EASE = 0.15,
        HOOK_TEMPO = 9,
        HOOK_TREMOR = 10,
        HOOK_TREMOR_HZ = 12,
        HOOK_PITCH = 0.2,
        HOOK_PITCH_HZ = 7,
        LOD_NEAR = 220,
        LOD_MID = 340,
        LOD_FAR = 440,
        MAX_POSED = 18,
        frame = 0,
        frameClock = -1,
        want = 0,
        loadEvery = 1,
        slots = 0,
        smoothstep = function(p3) -- smoothstep | line: 326
            local v1 = if p3 < 0 then 0 else p3

            if v1 > 1 then
                v1 = 1
            end

            return v1 * v1 * (3 - 2 * v1)
        end,
        wrap01 = function(p4) -- wrap01 | line: 332
            return p4 - math.floor(p4)
        end,
        profile = function(p5, p6) -- profile | line: 337
            local v2 = #p5

            if p6 <= p5[1][1] then
                return p5[1][2]
            end

            for i = 2, v2 do
                if p6 <= p5[i][1] then
                    local v3 = p5[i - 1][1]
                    local v4 = p5[i - 1][2]
                    local v5 = p5[i][1]
                    local v6 = p5[i][2]

                    if v5 <= v3 then
                        return v6
                    end

                    return v4 + (v6 - v4) * (p6 - v3) / (v5 - v3)
                end
            end

            return p5[v2][2]
        end
    }

    function t2.keyPhase(p7, p8, p9, p10) -- line: 352
        -- upvalues: t2 (copy)
        if #p7 <= p8 then
            return t2.keyPhase(p7, 0, p9, p10) + 1
        end

        local v7 = p7[p8 + 1]
        local lag = v7.lag

        if lag == nil then
            lag = p10
        end

        return v7.u + lag * p9
    end

    function t2.liftPhase(p11, p12, p13, p14) -- line: 362
        -- upvalues: t2 (copy)
        if p12 < t2.keyPhase(p11, 0, p13, p14) then
            return p12 + 1
        end

        return p12
    end

    function t2.isThrough(p15, p16) -- line: 369
        local v8 = #p15

        return p15[(if v8 <= p16 then p16 - v8 else p16) + 1].through == true
    end

    function t2.findKey(p17, p18, p19, p20) -- line: 380
        -- upvalues: t2 (copy)
        local v9 = #p17
        local v10 = v9 - 1

        for i = 0, v9 - 1 do
            if p18 < t2.keyPhase(p17, i + 1, p19, p20) then
                v10 = i
                break
            end
        end

        local v11 = v10

        while v11 > 0 and t2.isThrough(p17, v11) do
            v11 -= 1
        end

        local v12 = v10 + 1

        while v12 < v9 and t2.isThrough(p17, v12) do
            v12 += 1
        end

        local v13 = t2.keyPhase(p17, v11, p19, p20)
        local v14 = t2.keyPhase(p17, v12, p19, p20)
        local v15 = v13 + t2.smoothstep((p18 - v13) / (v14 - v13)) * (v14 - v13)
        local v16 = v12 - 1

        for i = v11, v12 - 1 do
            if v15 < t2.keyPhase(p17, i + 1, p19, p20) then
                v16 = i
                break
            end
        end

        local v17 = t2.keyPhase(p17, v16, p19, p20)
        local v18 = t2.keyPhase(p17, v16 + 1, p19, p20)
        local v19 = (v15 - v17) / (v18 - v17)

        if v19 < 0 then
            v19 = 0
        end

        if v19 > 1 then
            v19 = 1
        end

        return v16, v19
    end

    function t2.restKey(p21) -- line: 412
        return p21.restKey or 0
    end

    function t2.segTables(p22, p23) -- line: 423
        -- upvalues: t2 (copy)
        local cycle = p22.cycle
        local keys = cycle.keys
        local v20 = #keys
        local t3 = {}
        local t4 = {}
        local t5 = {}
        local t6 = {}
        local t7 = {}

        for i = 1, v20 do
            t3[i] = t2.keyPhase(keys, i - 1, p23, cycle.cascade)
            t4[i] = t2.profile(keys[i].curl, p23)

            local biasWeight = keys[i].biasWeight
            local v21 = if biasWeight then t2.profile(keys[i].biasWeight, p23) else nil

            if not biasWeight or not v21 then
                t5[i] = 0
            else
                t5[i] = v21
            end

            local v22 = i

            while v22 > 1 and t2.isThrough(keys, v22 - 1) do
                v22 -= 1
            end

            local v23 = i + 1

            while v23 <= v20 and t2.isThrough(keys, v23 - 1) do
                v23 += 1
            end

            t6[i] = v22
            t7[i] = v23
        end

        t3[v20 + 1] = t3[1] + 1

        local v24 = v20 + 1
        local v25 = v20 + 1
        local v26 = t4[1]
        local v27 = t5[1]

        t4[v24] = v26
        t5[v25] = v27

        return {
            n = v20,
            ph = t3,
            cv = t4,
            bw = t5,
            sa = t6,
            sb = t7,
            cone = t4[t2.restKey(cycle) + 1],
            tPow = p23 ^ p22.arms.flutter.power
        }
    end

    function t2.tangentAt(p24, p25, p26, p27, p28, p29) -- line: 450
        -- upvalues: t2 (copy)
        local ph, n = p24.ph, p24.n
        local v28 = if p27 then p25 + p26.off else p25
        local v29 = if p27 then p26.bias else 0
        local v30 = v28 - math.floor(v28)

        if v30 < ph[1] then
            v30 += 1
        end

        for i = 1, n do
            if v30 < ph[i + 1] then
                n = i
                break
            end
        end

        local v31 = p24.sa[n]
        local v32 = p24.sb[n]
        local v33 = ph[v31]
        local v34 = ph[v32]
        local v35 = v33 + t2.smoothstep((v30 - v33) / (v34 - v33)) * (v34 - v33)
        local v36 = v32 - 1

        for i = v31, v32 - 1 do
            if v35 < ph[i + 1] then
                v36 = i
                break
            end
        end

        local v37 = ph[v36]
        local v38 = ph[v36 + 1]
        local v39 = (v35 - v37) / (v38 - v37)

        if v39 < 0 then
            v39 = 0
        end

        if v39 > 1 then
            v39 = 1
        end

        local cv, bw = p24.cv, p24.bw
        local v40 = cv[v36] + v29 * bw[v36]
        local v41 = v40 + (cv[v36 + 1] + v29 * bw[v36 + 1] - v40) * v39
        local cone = p24.cone
        local v42 = cone + (if p27 then p29 * p26.amp else p29) * (v41 - cone)

        if not p27 then
            return v42
        end

        if not (t2.FL_GATE > 0) then
            local v43 = 1

            return v42 + v43 * t2.FL_AMP * p24.tPow * p28
        end

        local v44 = -v42 / t2.FL_GATE

        if v44 < 0 then
            v44 = 0
        end

        if v44 > 1 then
            v44 = 1
        end

        return v42 + (t2.FL_FLOOR + (1 - t2.FL_FLOOR) * v44) * t2.FL_AMP * p24.tPow * p28
    end

    t2.SEG = {}

    for i = 1, t1.rig.segmentsPerArm do
        local SEG, segTables = t2.SEG, t2.segTables
        local v45 = t1.rig.segmentsPerArm - 1

        SEG[i] = segTables(t1, (i - 1) / math.max(v45, 1))
    end

    t2.FL_AMP = t1.arms.flutter.amp
    t2.FL_HZTAU = t2.TAU * t1.arms.flutter.hz
    t2.FL_GATE = t1.arms.flutter.gateDeg or 0
    t2.FL_FLOOR = t1.arms.flutter.gateFloor or 0

    function t2.head(p30, p31, p32, p33) -- line: 515
        -- upvalues: t2 (copy)
        local head = p30.cycle.head
        local v46 = #head
        local v47 = t2.liftPhase(head, t2.wrap01(p31), 0, 0)
        local v48, v49 = t2.findKey(head, v47, 0, 0)
        local v50 = v48 + 1

        if v46 <= v50 then
            v50 = 0
        end

        local v51 = head[v48 + 1]
        local v52 = head[v50 + 1]
        local v53 = head[1]

        return v53.push + p33 * (v51.push + (v52.push - v51.push) * v49 - v53.push), v53.pitch + p33 * (v51.pitch + (v52.pitch - v51.pitch) * v49 - v53.pitch), v53.squash + p32 * (v51.squash + (v52.squash - v51.squash) * v49 - v53.squash), v53.bulge + p32 * (v51.bulge + (v52.bulge - v51.bulge) * v49 - v53.bulge)
    end

    function t2.aimBone(p34, p35, p36, p37, p38) -- line: 540
        local v54 = p34 * p35
        local v55 = v54:Cross(p37)
        local v56 = v54:Dot(p37)
        local Magnitude = v55.Magnitude
        local v57, v58

        if Magnitude < 1E-09 then
            if v56 > 0 then
                return CFrame.identity, p34, CFrame.identity
            end

            v57 = p38
            v58 = 3.141592653589793
        else
            v57 = v55 / Magnitude
            v58 = math.atan2(Magnitude, v56)
        end

        local v59 = CFrame.fromAxisAngle(v57, v58)

        return CFrame.fromAxisAngle(p36:VectorToObjectSpace(p34:VectorToObjectSpace(v57)), v58), v59 * p34, v59
    end

    function t2.arm(p39, p40) -- line: 564
        local v60 = p40.powerAt - p39.phase

        if v60 <= 0 then
            v60 += 1
        end

        p39.retime = math.min(v60 / p40.signalAhead, p40.retimeRange[2])
        p39.armLeft = v60
        p39.armed = true
        p39.armIn = nil
    end

    p1.Octopus = {
        register = function(p41) -- register | line: 574
            -- upvalues: attr (copy), t1 (copy), t2 (copy)
            local MeshPart = p41:FindFirstChildWhichIsA("MeshPart")

            if not MeshPart then
                return nil
            end

            local t9 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t9[descendant.Name] = descendant
                end
            end

            if not (t9.body and t9["tent.L.1.1"] and t9["tent.R.1.1"]) then
                return nil
            end

            local t10 = {}

            local function lrest(p42) -- line: 586
                -- upvalues: t10 (copy), lrest (copy)
                local v63 = t10[p42]
                local v64

                if v63 then
                    v64 = v63
                else
                    local Parent = p42.Parent

                    v64 = (Parent:IsA("Bone") and lrest(Parent) or CFrame.identity) * p42.CFrame
                    t10[p42] = v64
                end

                return v64
            end

            local function lp(p43) -- line: 595
                -- upvalues: t10 (copy), lrest (copy)
                local v65 = t10[p43]
                local v66

                if v65 then
                    v66 = v65
                else
                    local Parent = p43.Parent

                    v66 = (Parent:IsA("Bone") and lrest(Parent) or CFrame.identity) * p43.CFrame
                    t10[p43] = v66
                end

                return v66.Position
            end

            local function lrot(p44) -- line: 596
                -- upvalues: t10 (copy), lrest (copy)
                local v67 = t10[p44]
                local v68

                if v67 then
                    v68 = v67
                else
                    local Parent = p44.Parent

                    v68 = (Parent:IsA("Bone") and lrest(Parent) or CFrame.identity) * p44.CFrame
                    t10[p44] = v68
                end

                return v68.Rotation
            end

            local body = t9.body
            local v69 = t10[body]

            if not v69 then
                local bodyParent = body.Parent

                v69 = (bodyParent:IsA("Bone") and lrest(bodyParent) or CFrame.identity) * body.CFrame
                t10[body] = v69
            end

            local Position = v69.Position
            local segmentsPerArm = t1.rig.segmentsPerArm
            local t11 = {}
            local v70 = Vector3.new(0, 0, 0)
            local n1 = 0

            for v71, v72 in ipairs(t1.arms.order) do
                local v73 = ("tent.%s.%s."):format(v72:sub(1, 1), v72:sub(2))
                local t12 = {}
                local t13 = {}

                for i = 1, segmentsPerArm do
                    local v74 = t9[v73 .. i]

                    if not v74 then
                        return nil
                    end

                    t12[i] = v74

                    local v75 = t10[v74]
                    local v76

                    if v75 then
                        v76 = v75
                    else
                        local Parent = v74.Parent

                        v76 = (Parent:IsA("Bone") and lrest(Parent) or CFrame.identity) * v74.CFrame
                        t10[v74] = v76
                    end

                    t13[i] = v76.Position
                    v70 += t13[i]
                    n1 += 1
                end

                local v77 = t9[v73 .. segmentsPerArm + 1]
                local t14 = {
                    segs = t12,
                    heads = t13
                }

                if v77 then
                    local v78 = t10[v77]

                    if not v78 then
                        local Parent = v77.Parent

                        v78 = (Parent:IsA("Bone") and lrest(Parent) or CFrame.identity) * v77.CFrame
                        t10[v77] = v78
                    end

                    t14.tipPos = v78.Position or nil
                else
                    t14.tipPos = nil
                end

                t11[v71] = t14
            end

            local Unit = (v70 / n1 - Position).Unit
            local t15 = {}

            for v79, v80 in ipairs(t11) do
                local v81 = v80.heads[1] - Position
                local Unit2 = (v81 - Unit * v81:Dot(Unit)).Unit
                local Unit3 = Unit2:Cross(Unit).Unit
                local t16 = {}
                local v82 = Vector3.new(0, 0, 0)

                for j = 1, segmentsPerArm do
                    if j < segmentsPerArm then
                        v82 = (v80.heads[j + 1] - v80.heads[j]).Unit
                    elseif v80.tipPos then
                        v82 = (v80.tipPos - v80.heads[j]).Unit
                    end

                    local t17 = {
                        bone = v80.segs[j]
                    }
                    local v83 = segmentsPerArm - 1

                    t17.t = (j - 1) / math.max(v83, 1)
                    t17.dir = v82

                    local v84 = v80.segs[j]
                    local v85 = t10[v84]
                    local v86

                    if v85 then
                        v86 = v85
                    else
                        local Parent = v84.Parent

                        v86 = (Parent:IsA("Bone") and lrest(Parent) or CFrame.identity) * v84.CFrame
                        t10[v84] = v86
                    end

                    t17.rest = v86.Rotation
                    t17.tab = t2.SEG[j]
                    t16[j] = t17
                end

                t15[v79] = {
                    chain = t16,
                    radial = Unit2,
                    curlAxis = Unit3,
                    off = t1.arms.phaseOffsets[v79],
                    amp = t1.arms.ampScale[v79],
                    bias = t1.arms.closeBias and t1.arms.closeBias[v79] or 0,
                    flOff = t2.TAU * t1.arms.flutter.offsets[v79]
                }
            end

            local v87 = t9["tent.L.1.1"]
            local v88 = t10[v87]
            local v89

            if v88 then
                v89 = v88
            else
                local Parent = v87.Parent

                v89 = (Parent:IsA("Bone") and lrest(Parent) or CFrame.identity) * v87.CFrame
                t10[v87] = v89
            end

            local Position2 = v89.Position
            local v90 = t9["tent.R.1.1"]
            local v91 = t10[v90]
            local v92

            if v91 then
                v92 = v91
            else
                local Parent = v90.Parent

                v92 = (Parent:IsA("Bone") and lrest(Parent) or CFrame.identity) * v90.CFrame
                t10[v90] = v92
            end

            local v93 = Position2 - v92.Position
            local Unit2 = (v93 - Unit * v93:Dot(Unit)).Unit
            local body2 = t9.body
            local v94 = t10[body2]
            local v95

            if v94 then
                v95 = v94
            else
                local bodyParent = body2.Parent

                v95 = (bodyParent:IsA("Bone") and lrest(bodyParent) or CFrame.identity) * body2.CFrame
                t10[body2] = v95
            end

            local Rotation = v95.Rotation
            local t19 = {
                bone = t9.body,
                fwd = Rotation:VectorToObjectSpace(-Unit),
                pitchAxis = Rotation:VectorToObjectSpace(Unit2)
            }
            local v96 = t9["mantle." .. t1.rig.mantleBones]
            local v97, v98

            if v96 then
                local v99 = t10[v96]

                if not v99 then
                    local Parent = v96.Parent

                    v99 = (Parent:IsA("Bone") and lrest(Parent) or CFrame.identity) * v96.CFrame
                    t10[v96] = v99
                end

                local Unit = (v99.Position - Position).Unit

                if Unit then
                    v97 = Unit
                    v98 = true
                else
                    v98 = false
                end
            else
                v98 = false
            end

            if not v98 then
                v97 = -Unit
            end

            local v100, v101

            if v96 then
                local v102 = t10[v96]

                if not v102 then
                    local Parent = v96.Parent

                    v102 = (Parent:IsA("Bone") and lrest(Parent) or CFrame.identity) * v96.CFrame
                    t10[v96] = v102
                end

                local Magnitude = (v102.Position - Position).Magnitude

                if Magnitude then
                    v100 = Magnitude
                    v101 = true
                else
                    v101 = false
                end
            else
                v101 = false
            end

            if not v101 then
                v100 = 0
            end

            local t20 = {}

            for i = 2, t1.rig.mantleBones do
                local v103 = t9["mantle." .. i]

                if v103 then
                    local v104 = #t20 + 1
                    local t21 = {
                        bone = v103
                    }
                    local v105 = t10[v103]

                    if not v105 then
                        local Parent = v103.Parent

                        v105 = (Parent:IsA("Bone") and lrest(Parent) or CFrame.identity) * v103.CFrame
                        t10[v103] = v105
                    end

                    t21.along = v105.Rotation:VectorToObjectSpace(v97)
                    t21.share = t1.rig.squashSplit[i - 1] or 0
                    t20[v104] = t21
                end
            end

            local t22 = {}

            for i = 1, t1.rig.girthBones do
                local v106 = t9["girth." .. i]

                if v106 then
                    local v107 = t10[v106]

                    if not v107 then
                        local Parent = v106.Parent

                        v107 = (Parent:IsA("Bone") and lrest(Parent) or CFrame.identity) * v106.CFrame
                        t10[v106] = v107
                    end

                    local Rotation = v107.Rotation
                    local UpVector = Rotation.UpVector
                    local v108 = UpVector - v97 * UpVector:Dot(v97)

                    if v108.Magnitude > 1E-04 then
                        t22[#t22 + 1] = {
                            bone = v106,
                            out = Rotation:VectorToObjectSpace(v108.Unit)
                        }
                    end
                end
            end

            t2.slots += 1

            return {
                period = 1,
                periodSeen = false,
                armed = false,
                armLeft = 0,
                lastPulseAt = nil,
                sincePulse = 1E+09,
                every = 1,
                model = p41,
                mesh = MeshPart,
                central = Unit,
                arms = t15,
                body = t19,
                mantle = t20,
                mantleLen = v100,
                ring = t22,
                phase = math.random(),
                rate = t1.idle.tempo / t2.TAU,
                exc = t1.idle.excursion,
                pushExc = t1.idle.pushScale,
                lastPulse = attr(p41, "Pulse") or 0,
                leadComp = attr(p41, "LeadComp"),
                slot = t2.slots
            }
        end,
        update = function(p45, p46, p47) -- update | line: 692
            -- upvalues: p2 (copy), fightHooked (copy), attr (copy), t1 (copy), t2 (copy)
            local timing = t1.timing
            local v109 = fightHooked(p45.model)

            p45.sincePulse += p46

            local v110 = p45.sincePulse > p45.period * t2.IDLE_AFTER

            if attr(p45.model, "Floating") then
                v110 = false
            end

            local v111 = attr(p45.model, "Pulse") or 0
            local v112, v113

            if v111 == p45.lastPulse then
                v112 = v110
                v113 = false
            else
                p45.lastPulse = v111

                if p45.lastPulseAt then
                    local v114 = p47 - p45.lastPulseAt

                    if t2.INTERVAL_MIN <= v114 and v114 <= t2.INTERVAL_MAX then
                        if p45.periodSeen then
                            p45.period += (v114 - p45.period) * 0.6
                        else
                            p45.period = v114
                            p45.periodSeen = true
                        end
                    end
                elseif not v109 then
                    p45.phase = timing.caveInStart
                    p45.exc = 1
                    p45.pushExc = 1
                end

                p45.lastPulseAt = p47
                p45.sincePulse = 0
                p45.rate = 1 / p45.period
                p45.retime = nil
                p45.armed = false
                p45.armIn = nil

                if v109 then
                    v113 = false
                else
                    if v110 then
                        p45.phase = timing.caveInStart
                        p45.exc = 1
                        p45.pushExc = 1
                    end

                    local v118 = math.min(p45.leadComp or p2.bodyLag(), (math.max(0, 0.5 * p45.period - timing.signalAhead)))

                    if not (v118 > 0 and p45.phase <= timing.caveInStart) then
                        v113 = false
                        t2.arm(p45, timing)
                    else
                        v113 = true
                        p45.armIn = v118
                    end
                end

                v112 = false
            end

            local v119, v120, v121, v122

            if v109 then
                v120 = t2.HOOK_TEMPO / t2.TAU
                v121 = 1
                v122 = 1
                v119 = t2.PULSE_EASE
            elseif v112 then
                v120 = t1.idle.tempo / t2.TAU
                v121 = t1.idle.excursion
                v122 = t1.idle.pushScale
                v119 = t2.IDLE_EASE
            else
                v120 = 1 / p45.period
                v121 = 1
                v122 = 1
                v119 = t2.PULSE_EASE
            end

            local v124 = math.min(1, p46 / v119)

            p45.rate += (v120 - p45.rate) * v124
            p45.exc += (v121 - p45.exc) * v124
            p45.pushExc += (v122 - p45.pushExc) * v124

            if p45.armIn then
                p45.armIn -= p46

                if p45.armIn <= 0 and not v113 then
                    if v109 then
                        p45.armIn = nil
                    else
                        t2.arm(p45, timing)
                    end
                end
            end

            local phase, rate = p45.phase, p45.rate

            if p45.retime and not v109 then
                rate = p45.retime
            end

            local v125 = v112 or v109

            if not v125 and p45.sincePulse > p45.period and timing.holdZone[1] <= phase and phase < timing.holdZone[2] then
                rate *= timing.holdFloor
            end

            local v126 = phase + p46 * rate

            if not (v125 or p45.armed) and phase <= timing.caveInStart and timing.caveInStart <= v126 then
                v126 = math.max(phase, timing.caveInStart - 0.001)
            end

            if p45.armed then
                p45.armLeft -= v126 - phase

                if p45.armLeft <= 0 then
                    p45.armed = false
                    p45.retime = nil
                end
            end

            p45.phase = t2.wrap01(v126)

            local phase2 = p45.phase

            if p47 ~= t2.frameClock then
                t2.frameClock = p47
                t2.frame += 1
                t2.loadEvery = if t2.want > 2 * t2.MAX_POSED then 4 elseif t2.want > t2.MAX_POSED then 2 else 1
                t2.want = 0
            end

            local v129 = p45.every == 0
            local CurrentCamera = workspace.CurrentCamera

            if CurrentCamera then
                local meshPosition = p45.mesh.Position
                local v130 = CurrentCamera:WorldToViewportPoint(meshPosition)
                local ViewportSize = CurrentCamera.ViewportSize

                if v130.Z < 0 or v130.X < -0.5 * ViewportSize.X or v130.X > 1.5 * ViewportSize.X or v130.Y < -0.5 * ViewportSize.Y or v130.Y > 1.5 * ViewportSize.Y then
                    p45.every = 0
                else
                    local Magnitude = (CurrentCamera.CFrame.Position - meshPosition).Magnitude

                    if t2.LOD_NEAR <= Magnitude then
                        if t2.LOD_FAR <= Magnitude then
                            p45.every = 8
                        elseif Magnitude < t2.LOD_MID then
                            p45.every = 2
                        else
                            p45.every = 4
                        end
                    else
                        p45.every = 1
                    end
                end
            end

            local v131 = if v109 then 1 else p45.every

            if v131 == 0 then
                return
            end

            t2.want += 1 / v131

            if not v109 and v131 < t2.loadEvery then
                v131 = t2.loadEvery
            end

            if not v129 and (t2.frame + p45.slot) % v131 ~= 0 then
                return
            end

            local v132, v133, v134, v135 = t2.head(t1, phase2, p45.exc, p45.pushExc)

            if v109 then
                v133 += t2.HOOK_PITCH * math.sin(p47 * t2.HOOK_PITCH_HZ)
            end

            local body = p45.body

            body.bone.Transform = CFrame.new(body.fwd * v132) * CFrame.fromAxisAngle(body.pitchAxis, v133)

            for _, v137 in ipairs(p45.mantle) do
                v137.bone.Transform = CFrame.new(-v137.along * (v137.share * v134 * p45.mantleLen))
            end

            for _, v138 in ipairs(p45.ring) do
                v138.bone.Transform = CFrame.new(v138.out * v135)
            end

            local central, exc = p45.central, p45.exc
            local HOOK_TREMOR = v109 and t2.HOOK_TREMOR or 0
            local v139 = t2.FL_HZTAU * p47

            for _, v140 in ipairs(p45.arms) do
                local radial, curlAxis = v140.radial, v140.curlAxis
                local v142 = math.sin(v139 + v140.flOff)
                local v144 = HOOK_TREMOR * math.sin(p47 * t2.HOOK_TREMOR_HZ + v140.flOff)
                local v145 = CFrame.identity

                for _, v146 in ipairs(v140.chain) do
                    local v148 = math.rad(t2.tangentAt(v146.tab, phase2, v140, true, v142, exc) + v144 * v146.t)
                    local v149

                    v149, v145 = t2.aimBone(v145, v146.dir, v146.rest, central * math.cos(v148) - radial * math.sin(v148), curlAxis)
                    v146.bone.Transform = v149
                end
            end
        end
    }
end
