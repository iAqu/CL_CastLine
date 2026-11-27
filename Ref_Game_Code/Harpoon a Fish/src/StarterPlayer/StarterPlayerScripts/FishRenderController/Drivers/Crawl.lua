-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, _) -- line: 5
    p1.Crawl = {
        DUTY = {
            crab = 0.55,
            lobster = 0.65,
            scorpion = 0.6,
            trilobite = 0.7,
            spider = 0.65,
            seaspider = 0.65
        },
        SCORP_SWEEP = 0.25,
        SCORP_LIFT = 0.28,
        SCORP_TUCK = 0.35,
        SCORP = {
            LegL1_1 = 0,
            LegR2_1 = 0,
            LegL3_1 = 0,
            LegR1_1 = 0.5,
            LegL2_1 = 0.5,
            LegR3_1 = 0.5
        },
        CRAB_KNEE = 0.32,
        CRAB_LIFT = 0.3,
        CRAB_SWAY = 0.08,
        CRAB_HIPCOMP = 0.25,
        LOB_SWEEP = 0.32,
        LOB_LIFT = 0.28,
        LOB_TUCK = 0.35,
        STRIDE = {
            crab = 0.099,
            lobster = 0.207,
            scorpion = 0.14,
            trilobite = 0.053,
            spider = 0.183,
            seaspider = 0.1108
        },
        SPIDER = {
            LegL1_1 = 0,
            LegR2_1 = 0,
            LegL3_1 = 0,
            LegR4_1 = 0,
            LegR1_1 = 0.5,
            LegL2_1 = 0.5,
            LegR3_1 = 0.5,
            LegL4_1 = 0.5
        },
        SPIDER_SWEEP = 0.3,
        SPIDER_LIFT = 0.35,
        SPIDER_TUCK = 0.35,
        SEA_WALK = {
            LegL2_1 = 0,
            LegR3_1 = 0,
            LegL4_1 = 0,
            LegR2_1 = 0.5,
            LegL3_1 = 0.5,
            LegR4_1 = 0.5
        },
        SEA_FEEL = {
            LegL1_1 = 0,
            LegR1_1 = 0.5
        },
        SEA_T = 0.072,
        SEA_H = 0.036,
        SEA_TARSUS = 0.25,
        SEA_MARGIN = 0.004,
        FEEL_HZ = 0.3,
        FEEL_YAW = 0.14,
        FEEL_RAISE = 0.15,
        FEEL_BOB = 0.07,
        FEEL_CURL = 0.12,
        FEEL_LAG = 0.9,
        seaIK = function(p3, p4) -- seaIK | line: 54
            local hip, knee, tip, u = p3.hip, p3.knee, p3.tip, p3.u

            local function flat(p5) -- line: 56
                -- upvalues: u (copy)
                return p5 - u * p5:Dot(u)
            end

            local v1 = tip - hip
            local Unit = (v1 - u * v1:Dot(u)).Unit
            local v2 = p4 - hip
            local v3 = v2 - u * v2:Dot(u)
            local Unit2 = v3.Unit
            local v6 = math.atan2(Unit:Cross(Unit2):Dot(u), (Unit:Dot(Unit2)))
            local v7 = (knee - hip):Dot(Unit)
            local v8 = (knee - hip):Dot(u)
            local v9 = (tip - hip):Dot(Unit)
            local v10 = (tip - hip):Dot(u)
            local v12 = math.sqrt(v7 * v7 + v8 * v8)
            local v14 = math.sqrt((v9 - v7) ^ 2 + (v10 - v8) ^ 2)
            local Magnitude = v3.Magnitude
            local v15 = (p4 - hip):Dot(u)
            local v17 = math.sqrt(v9 * v9 + v10 * v10)
            local v19 = math.sqrt(Magnitude * Magnitude + v15 * v15)
            local v20 = if math.atan2(v8, v7) >= math.atan2(v10, v9) then 1 else -1
            local v23 = math.acos((math.clamp((v12 * v12 + v17 * v17 - v14 * v14) / (v12 * 2 * v17), -1, 1)))
            local v26 = math.acos((math.clamp((v12 * v12 + v19 * v19 - v14 * v14) / (v12 * 2 * v19), -1, 1)))
            local v27 = math.atan2(v10, v9) + v20 * v23
            local v28 = math.atan2(v15, Magnitude) + v20 * v26
            local v29 = v28 - v27
            local v30 = v12 * math.cos(v28)
            local v31 = v12 * math.sin(v28)
            local v34 = math.atan2(v10 - v8, v9 - v7)

            return v6, v29, math.atan2(v15 - v31, Magnitude - v30) - v34 - v29
        end,
        seaPull = function(p6, p7, p8) -- seaPull | line: 77
            -- upvalues: p1 (copy)
            local Crawl = p1.Crawl
            local hip, tip, u = p6.hip, p6.tip, p6.u
            local v37 = tip - hip
            local Unit = (v37 - u * v37:Dot(u)).Unit
            local Magnitude = (tip - hip).Magnitude
            local n1 = 0

            for _ = 1, 4 do
                local n2 = 0

                for i = 0, 63 do
                    local v38, v39 = Crawl.step(i / 64, Crawl.DUTY.seaspider)

                    n2 = math.max(n2, (tip + p8 * (Crawl.SEA_T * p7 / 2 * v38) + u * (Crawl.SEA_H * p7 * v39) - Unit * n1 - hip).Magnitude)
                end

                n1 += math.max(0, n2 - (Magnitude - Crawl.SEA_MARGIN * p7))
            end

            return n1
        end,
        TRILO_SWEEP = 0.35,
        TRILO_LIFT = 0.35,
        TRILO_TUCK = 0.4,
        TRILO_MAX = 12,
        ARM_DUTY = 0.6,
        ARM_OFF = 0,
        ARM_SWEEP = 0.16,
        ARM_LIFT = 0.45,
        ARM_CURL2 = 0.3,
        ARM_CURL3 = 0.45,
        TRIPOD = {
            ["leg.L.01"] = 0,
            ["leg.R.02"] = 0,
            ["leg.L.03"] = 0,
            ["leg.R.01"] = 0.5,
            ["leg.L.02"] = 0.5,
            ["leg.R.03"] = 0.5
        },
        WAVE = {
            ["leg.L.03"] = 0,
            ["leg.L.02"] = 0.3333333333333333,
            ["leg.L.01"] = 0.6666666666666666,
            ["leg.R.03"] = 0.5,
            ["leg.R.02"] = 0.8333333333333333,
            ["leg.R.01"] = 1.1666666666666665
        },
        TETRA_EXTRA = {
            ["leg.R.04"] = 0,
            ["leg.L.04"] = 0.5,
            ["leg.L.05"] = 0,
            ["leg.R.05"] = 0.5
        },
        MOVING = 0.15,
        WALK_TAU = 0.25,
        VEL_TAU = 0.15,
        ease = function(p9) -- ease | line: 122
            return 0.5 - math.cos(3.141592653589793 * math.clamp(p9, 0, 1)) * 0.5
        end,
        step = function(p10, p11) -- step | line: 127
            -- upvalues: p1 (copy)
            if p10 < p11 then
                return 1 - 2 * p10 / p11, 0
            end

            local v42 = (p10 - p11) / (1 - p11)

            return -1 + 2 * p1.Crawl.ease(v42), (math.sin(3.141592653589793 * v42))
        end,
        setup = function(p12, p13) -- setup | line: 135
            -- upvalues: p1 (copy)
            local Crawl, StrokeClock = p1.Crawl, p1.StrokeClock

            if p13 == "seaspider" then
                local Size = p12.mesh.Size
                local v45 = math.max(Size.X, Size.Y, Size.Z)

                local function pos(p14) -- line: 141
                    -- upvalues: p12 (copy)
                    return p12.mcf:PointToObjectSpace(p14.WorldPosition)
                end

                local t2 = {}
                local t3 = {}

                for v46, v47 in pairs({
                        [Crawl.SEA_WALK] = true,
                        [Crawl.SEA_FEEL] = false
                    }) do
                    for v48, v49 in pairs(v46) do
                        local v50 = v48:sub(1, -3)
                        local v51 = p12.bones[v50 .. "_1"]
                        local v52 = p12.bones[v50 .. "_2"]
                        local v53 = p12.bones[v50 .. "_3"]
                        local v54 = v47 and v53 or v52
                        local TipFrac = v54 and v54:GetAttribute("TipFrac")

                        if not v51 or not v52 or not v54 or typeof(TipFrac) ~= "Vector3" then
                            return false
                        end

                        local t4 = {
                            off = v49,
                            b1 = v51,
                            b2 = v52,
                            b3 = v47 and v53 or nil,
                            hip = p12.mcf:PointToObjectSpace(v51.WorldPosition),
                            knee = p12.mcf:PointToObjectSpace(v52.WorldPosition),
                            tip = TipFrac * Size,
                            u = p12.up
                        }
                        local v55 = t4.tip - t4.hip
                        local Unit = (v55 - p12.up * v55:Dot(p12.up)).Unit
                        local Unit2 = Unit:Cross(p12.up).Unit

                        t4.o = Unit

                        local v56 = StrokeClock.axis(p12, v51, p12.up)
                        local v57 = StrokeClock.axis(p12, v51, Unit2)
                        local v58 = StrokeClock.axis(p12, v52, Unit2)

                        t4.U1 = v56
                        t4.A1 = v57
                        t4.A2 = v58

                        if v47 then
                            t4.A3 = StrokeClock.axis(p12, v53, Unit2)
                            t4.pull = Crawl.seaPull(t4, v45, p12.nose)
                            t2[#t2 + 1] = t4
                        else
                            t3[#t3 + 1] = t4
                        end
                    end
                end

                p12.crawl = {
                    phase = 0,
                    walk = 0,
                    vel = Vector3.new(0, 0, 0),
                    kind = p13,
                    legs = {},
                    sea = t2,
                    feel = t3,
                    dirv = p12.nose,
                    length = v45,
                    stride = p12.model:GetAttribute("CrawlStride") or Crawl.STRIDE[p13]
                }
            else
                local v59, v60

                if p13 == "crab" then
                    local TRIPOD = Crawl.TRIPOD

                    if TRIPOD then
                        v59 = TRIPOD
                        v60 = true
                    elseif p13 == "scorpion" then
                        local SCORP = Crawl.SCORP

                        if SCORP then
                            v59 = SCORP
                            v60 = true
                        else
                            v60 = false
                        end
                    else
                        v60 = false
                    end
                elseif p13 == "scorpion" then
                    local SCORP = Crawl.SCORP

                    if SCORP then
                        v59 = SCORP
                        v60 = true
                    else
                        v60 = false
                    end
                else
                    v60 = false
                end

                if not v60 then
                    local v61 = p13 == "spider"
                    local SPIDER = if v61 then Crawl.SPIDER else nil

                    v59 = if not v61 or not SPIDER then Crawl.WAVE else SPIDER
                end

                if p13 == "trilobite" then
                    local n3 = 0

                    while n3 < Crawl.TRILO_MAX and p12.bones["LegL" .. n3 + 1 .. "_1"] do
                        n3 += 1
                    end

                    v59 = {}

                    for i = 1, n3 do
                        v59["LegL" .. i .. "_1"] = i / n3 % 1
                        v59["LegR" .. i .. "_1"] = (i / n3 + 0.5) % 1
                    end
                end

                local t6 = {}

                local function addLeg(p15, p16, p17) -- line: 182
                    -- upvalues: p12 (copy), StrokeClock (copy), t6 (copy)
                    local v62 = p12.mcf:PointToObjectSpace(p15.WorldPosition)
                    local v63 = p12.mcf:PointToObjectSpace(p16.WorldPosition) - v62
                    local Unit = (v63 - p12.up * v63:Dot(p12.up)).Unit
                    local Unit2 = Unit:Cross(p12.up).Unit

                    t6[#t6 + 1] = {
                        leg = p15,
                        foot = p16,
                        off = p17,
                        o = Unit,
                        gain = p15:GetAttribute("CrawlGain") or 1,
                        legA = StrokeClock.axis(p12, p15, Unit2),
                        legU = StrokeClock.axis(p12, p15, p12.up),
                        footA = StrokeClock.axis(p12, p16, Unit2),
                        legO = StrokeClock.axis(p12, p15, Unit)
                    }
                end

                for v64, v65 in pairs(v59) do
                    local v66 = p12.bones[v64]
                    local v67 = p12.bones[(p13 == "scorpion" or p13 == "trilobite" or p13 == "spider") and v64:sub(1, -3) .. "_2" or "foot" .. v64:sub(4)]

                    if v66 and v67 then
                        addLeg(v66, v67, v65)
                    elseif not p12.model:GetAttribute("CrawlSkipMissing") then
                        return false
                    end
                end

                if p13 == "crab" then
                    for v68, v69 in pairs(Crawl.TETRA_EXTRA) do
                        local v70 = p12.bones[v68]
                        local v71 = p12.bones["foot" .. v68:sub(4)]

                        if v70 and v71 then
                            addLeg(v70, v71, v69)
                        end
                    end
                end

                local Size = p12.mesh.Size

                p12.crawl = {
                    phase = 0,
                    walk = 0,
                    vel = Vector3.new(0, 0, 0),
                    kind = p13,
                    legs = t6,
                    dirv = p12.nose,
                    length = math.max(Size.X, Size.Y, Size.Z),
                    stride = p12.model:GetAttribute("CrawlStride") or Crawl.STRIDE[p13]
                }

                if p13 == "trilobite" and p12.bones.ArmL_1 then
                    local t8 = {}

                    for v72, v73 in pairs({
                            L = Crawl.ARM_OFF,
                            R = Crawl.ARM_OFF + 0.5
                        }) do
                        local t9 = {}

                        for j = 1, 3 do
                            local v74 = p12.bones["Arm" .. v72 .. "_" .. j]

                            if v74 then
                                t9[j] = {
                                    bone = v74,
                                    axis = StrokeClock.axis(p12, v74, p12.right)
                                }
                            end
                        end

                        if t9[1] then
                            t8[#t8 + 1] = {
                                off = v73,
                                b = t9
                            }
                        end
                    end

                    p12.crawl.arms = t8
                end
            end

            return true
        end,
        pose = function(p18, p19, p20, p21) -- pose | line: 231
            -- upvalues: p1 (copy)
            local Crawl = p1.Crawl
            local crawl = p18.crawl
            local v75 = Crawl.DUTY[crawl.kind]

            if crawl.kind == "seaspider" then
                local length = crawl.length

                for _, v76 in ipairs(crawl.sea) do
                    local v77, v78 = Crawl.step((p19 + v76.off) % 1, v75)
                    local v79 = v76.tip + (p20 * (Crawl.SEA_T * length / 2 * v77) + v76.u * (Crawl.SEA_H * length * v78) - v76.o * v76.pull) * p21
                    local v80, v81, v82 = Crawl.seaIK(v76, v79)

                    v76.b1.Transform = CFrame.fromAxisAngle(v76.U1, v80) * CFrame.fromAxisAngle(v76.A1, v81)
                    v76.b2.Transform = CFrame.fromAxisAngle(v76.A2, v82)
                    v76.b3.Transform = CFrame.fromAxisAngle(v76.A3, Crawl.SEA_TARSUS * v78 * p21)
                end

                local v83 = p18.t or 0

                for _, v84 in ipairs(crawl.feel) do
                    local v85 = 6.283185307179586 * (Crawl.FEEL_HZ * v83 + v84.off)

                    v84.b1.Transform = CFrame.fromAxisAngle(v84.U1, Crawl.FEEL_YAW * math.sin(v85)) * CFrame.fromAxisAngle(v84.A1, Crawl.FEEL_RAISE + Crawl.FEEL_BOB * math.sin(v85 - Crawl.FEEL_LAG))
                    v84.b2.Transform = CFrame.fromAxisAngle(v84.A2, Crawl.FEEL_CURL * math.sin(v85 - 2 * Crawl.FEEL_LAG))
                end
            else
                for _, v89 in ipairs(crawl.legs) do
                    local v90 = p21 * v89.gain
                    local v91, v92 = Crawl.step((p19 + v89.off) % 1, v75)

                    if crawl.kind == "crab" then
                        local v93 = if v89.o:Dot(p20) > 0 then 1 else -1
                        local v94 = v90 * Crawl.CRAB_KNEE * v91 * v93
                        local v95 = v90 * Crawl.CRAB_LIFT * v92
                        local v96 = v90 * Crawl.CRAB_SWAY * v91

                        v89.leg.Transform = CFrame.fromAxisAngle(v89.legA, v95 - Crawl.CRAB_HIPCOMP * v94) * CFrame.fromAxisAngle(v89.legU, v96)
                        v89.foot.Transform = CFrame.fromAxisAngle(v89.footA, v94 - v90 * 0.25 * v92)
                    elseif crawl.kind == "trilobite" then
                        local v97 = p18.up:Cross(v89.o):Dot(p20) > 0 and 1 or -1

                        v89.leg.Transform = CFrame.fromAxisAngle(v89.legO, v90 * Crawl.TRILO_SWEEP * v91 * v97) * CFrame.fromAxisAngle(v89.legA, v90 * Crawl.TRILO_LIFT * v92)
                        v89.foot.Transform = CFrame.fromAxisAngle(v89.footA, v90 * Crawl.TRILO_TUCK * v92)
                    else
                        local v98 = if p18.up:Cross(v89.o):Dot(p20) > 0 then 1 else -1
                        local SCORP_SWEEP, SCORP_LIFT, SCORP_TUCK

                        if crawl.kind == "scorpion" then
                            SCORP_SWEEP = Crawl.SCORP_SWEEP or Crawl.LOB_SWEEP
                            SCORP_LIFT = Crawl.SCORP_LIFT or Crawl.LOB_LIFT
                            SCORP_TUCK = Crawl.SCORP_TUCK or Crawl.LOB_TUCK
                        else
                            SCORP_SWEEP = Crawl.LOB_SWEEP
                            SCORP_LIFT = Crawl.LOB_LIFT
                            SCORP_TUCK = Crawl.LOB_TUCK
                        end

                        if crawl.kind == "spider" then
                            SCORP_SWEEP = Crawl.SPIDER_SWEEP
                            SCORP_LIFT = Crawl.SPIDER_LIFT
                            SCORP_TUCK = Crawl.SPIDER_TUCK
                        end

                        v89.leg.Transform = CFrame.fromAxisAngle(v89.legU, v90 * SCORP_SWEEP * v91 * v98) * CFrame.fromAxisAngle(v89.legA, v90 * SCORP_LIFT * v92)
                        v89.foot.Transform = CFrame.fromAxisAngle(v89.footA, v90 * SCORP_TUCK * v92)
                    end
                end

                if crawl.arms then
                    for _, v99 in ipairs(crawl.arms) do
                        local v100, v101 = Crawl.step((p19 + v99.off) % 1, Crawl.ARM_DUTY)
                        local t10 = {
                            p21 * (Crawl.ARM_SWEEP * v100 + Crawl.ARM_LIFT * v101),
                            p21 * Crawl.ARM_CURL2 * v101,
                            p21 * Crawl.ARM_CURL3 * v101
                        }

                        for i = 1, 3 do
                            local v102 = v99.b[i]

                            if v102 then
                                v102.bone.Transform = CFrame.fromAxisAngle(v102.axis, t10[i])
                            end
                        end
                    end
                end
            end
        end,
        update = function(p22, p23) -- update | line: 294
            -- upvalues: p1 (copy)
            local Crawl = p1.Crawl
            local crawl = p22.crawl
            local CFrame = p22.mesh.CFrame
            local v103 = if crawl.lastPos and p23 > 1E-04 and (CFrame.Position - crawl.lastPos).Magnitude < 20 then CFrame:VectorToObjectSpace((CFrame.Position - crawl.lastPos) / p23) else Vector3.new(0, 0, 0)

            crawl.lastPos = CFrame.Position

            local v104 = v103 - p22.up * v103:Dot(p22.up)

            crawl.vel = crawl.vel:Lerp(v104, (math.min(1, p23 / Crawl.VEL_TAU)))

            local Magnitude = crawl.vel.Magnitude
            local v106 = Crawl.MOVING < Magnitude

            if v106 then
                crawl.dirv = crawl.vel.Unit
            end

            crawl.walk = crawl.walk + ((if v106 then 1 else 0) - crawl.walk) * math.min(1, p23 / Crawl.WALK_TAU)
            crawl.phase = (crawl.phase + Magnitude * p23 / (crawl.stride * crawl.length)) % 1
            Crawl.pose(p22, crawl.phase, crawl.dirv, crawl.walk)
        end,
        stop = function(p24) -- stop | line: 313
            for _, v109 in ipairs(p24.crawl.legs) do
                v109.foot.Transform = CFrame.identity
            end

            for _, v110 in ipairs(p24.crawl.sea or {}) do
                local b1, b2, b3 = v110.b1, v110.b2, v110.b3
                local identity, identity2, identity3 = CFrame.identity, CFrame.identity, CFrame.identity

                b1.Transform = identity
                b2.Transform = identity2
                b3.Transform = identity3
            end

            for _, v111 in ipairs(p24.crawl.feel or {}) do
                local b1, b2 = v111.b1, v111.b2
                local identity, identity2 = CFrame.identity, CFrame.identity

                b1.Transform = identity
                b2.Transform = identity2
            end

            for _, v112 in ipairs(p24.crawl.arms or {}) do
                for _, v113 in pairs(v112.b) do
                    v113.bone.Transform = CFrame.identity
                end
            end

            p24.crawl = nil
        end
    }
end
