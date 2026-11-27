-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 26
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.TrikeSwim = {
        PHI0 = -0.1,
        SWING = 0.25,
        FOLD = 0.05,
        FOLD_LEAD = -0.5,
        HAND0 = 0.15,
        HAND = 0.35,
        HAND_LAG = 0.3,
        ARM_POLE = Vector3.new(0.4, 1, 0),
        DIAG = 0.1,
        PHI_L0 = 0.1,
        LSWING = 0.3,
        FOLD_L = 0.1,
        FOLD_L_LEAD = 1,
        FOOT0 = -0.1,
        FOOT = 0.25,
        FOOT_LAG = 0.3,
        LEG_POLE = Vector3.new(0, -1, 0),
        RAM_SWING = 0.2,
        TURN_GAIN = 0.3,
        WAVE = {
            { "Chest", 0.04 },
            { "Belly", 0.03 },
            { "Pelvis", 0.04 },
            { "Tail_1", 0.08 },
            { "Tail_2", 0.11 },
            { "Tail_3", 0.14 }
        },
        LAG = 0.6,
        BEND = 0.12,
        CHEST_ROLL = 0.05,
        HIP_ROLL = 0.04,
        ROCK = 0.02,
        HEAD_STEADY = 0.85,
        LOOK = 0.1,
        NOD = 0.03,
        NOD_LAG = 0.5,
        RAM_CHEST = 0.12,
        RAM_NECK = 0.08,
        RAM_HEAD = 0.08,
        RAM_E0 = 1.3,
        RAM_E1 = 1.55,
        STRIDE = 0.45,
        MIN_HZ = 0.3,
        MAX_HZ = 3,
        HOOK_HZ = 1.8,
        PEN_HZ = 0.6,
        TURN_FULL = 0.6,
        TURN_TAU = 0.3,
        V_TAU = 0.3,
        BONES = {
            "Chest",
            "Belly",
            "Pelvis",
            "Tail_1",
            "Tail_2",
            "Tail_3",
            "Neck",
            "Head",
            "Arm_L",
            "Fore_L",
            "Hand_L",
            "Arm_R",
            "Fore_R",
            "Hand_R",
            "Thigh_L",
            "Shin_L",
            "Foot_L",
            "Thigh_R",
            "Shin_R",
            "Foot_R"
        },
        ramOf = function(p3) -- ramOf | line: 51
            -- upvalues: p1 (copy)
            local TrikeSwim = p1.TrikeSwim
            local v2 = math.clamp((p3 - TrikeSwim.RAM_E0) / (TrikeSwim.RAM_E1 - TrikeSwim.RAM_E0), 0, 1)

            return v2 * v2 * (3 - v2 * 2)
        end,
        turnTo = function(p4, p5) -- turnTo | line: 57
            local Unit = p4.Unit
            local Unit2 = p5.Unit
            local v3 = Unit:Cross(Unit2)
            local Magnitude = v3.Magnitude

            if Magnitude < 1E-09 then
                return CFrame.identity
            end

            return CFrame.fromAxisAngle(v3 / Magnitude, (math.atan2(Magnitude, (Unit:Dot(Unit2)))))
        end,
        ik = function(p6, p7, p8, p9, p10) -- ik | line: 65
            -- upvalues: p1 (copy)
            local TrikeSwim = p1.TrikeSwim
            local Magnitude = (p7 - p6).Magnitude
            local Magnitude2 = (p8 - p7).Magnitude
            local v6 = p9 - p6
            local v8 = math.min(v6.Magnitude, (Magnitude + Magnitude2) * 0.999)
            local Unit = v6.Unit
            local Unit2 = (p10 - Unit * p10:Dot(Unit)).Unit
            local v9 = (Magnitude * Magnitude - Magnitude2 * Magnitude2 + v8 * v8) / (v8 * 2)
            local v12 = math.sqrt((math.max(0, Magnitude * Magnitude - v9 * v9)))
            local v13 = p6 + Unit * v9 + Unit2 * v12
            local v14 = TrikeSwim.turnTo(p7 - p6, v13 - p6)

            return v14, TrikeSwim.turnTo(v14 * (p8 - p7), p9 - v13) * v14
        end,
        target = function(p11, p12, p13, p14, p15, p16, p17, p18, p19, p20) -- target | line: 80
            -- upvalues: p1 (copy)
            local TrikeSwim = p1.TrikeSwim
            local v15 = 6.283185307179586 * p14
            local v16 = p15 - p16 * (1 + TrikeSwim.RAM_SWING * p20) * p19 * math.cos(v15)

            return p12 + CFrame.fromAxisAngle(p11.left, v16) * (p13 - p12) * (1 - p17 * (1 - math.sin(v15 + p18)) / 2)
        end,
        arm = function(p21, p22, p23, p24) -- arm | line: 87
            -- upvalues: p1 (copy)
            local TrikeSwim = p1.TrikeSwim
            local s = p21.s
            local v19 = (p22 + (if s == 1 then 0 else 0.5)) % 1
            local v20 = 1 - s * TrikeSwim.TURN_GAIN * p23
            local v21, v22 = TrikeSwim.ik(p21.S, p21.E, p21.W, TrikeSwim.target(p21, p21.S, p21.W, v19, TrikeSwim.PHI0, TrikeSwim.SWING, TrikeSwim.FOLD, TrikeSwim.FOLD_LEAD, v20, p24), p21.pole)

            return v21, v22, CFrame.fromAxisAngle(v22 * p21.left, TrikeSwim.HAND0 + TrikeSwim.HAND * math.sin(6.283185307179586 * v19 - TrikeSwim.HAND_LAG)) * v22
        end,
        leg = function(p25, p26, p27, p28) -- leg | line: 97
            -- upvalues: p1 (copy)
            local TrikeSwim = p1.TrikeSwim
            local s = p25.s
            local v25 = (p26 - TrikeSwim.DIAG + (if s == 1 then 0.5 else 0)) % 1
            local v26 = 1 - s * TrikeSwim.TURN_GAIN * p27
            local v27, v28 = TrikeSwim.ik(p25.S, p25.E, p25.W, TrikeSwim.target(p25, p25.S, p25.W, v25, TrikeSwim.PHI_L0, TrikeSwim.LSWING, TrikeSwim.FOLD_L, TrikeSwim.FOLD_L_LEAD, v26, p28), p25.pole)

            return v27, v28, CFrame.fromAxisAngle(v28 * p25.left, TrikeSwim.FOOT0 - TrikeSwim.FOOT * math.sin(6.283185307179586 * v25 - TrikeSwim.FOOT_LAG)) * v28
        end,
        body = function(p29, p30, p31, p32) -- body | line: 108
            -- upvalues: p1 (copy)
            local TrikeSwim = p1.TrikeSwim
            local steady = if p32 then p32.steady or TrikeSwim.HEAD_STEADY else TrikeSwim.HEAD_STEADY
            local sway = p32 and p32.sway or 0
            local nod = if p32 then p32.nod or TrikeSwim.NOD else TrikeSwim.NOD
            local v31 = 6.283185307179586 * p29
            local t2 = {}
            local n1 = 0

            for v32, v33 in ipairs(TrikeSwim.WAVE) do
                local v36 = v33[2] * math.sin(v31 - (v32 - 1) * TrikeSwim.LAG)

                if v33[1] == "Chest" then
                    n1 = v36
                    t2[v33[1]] = { { "up", v36 } }
                else
                    t2[v33[1]] = {
                        {
                            "up",
                            v36 + TrikeSwim.BEND * p30 / 4
                        }
                    }
                end
            end

            table.insert(t2.Chest, {
                "nose",
                -TrikeSwim.CHEST_ROLL * math.sin(v31)
            })
            table.insert(t2.Chest, {
                "lat",
                TrikeSwim.ROCK * math.sin(2 * v31) - TrikeSwim.RAM_CHEST * p31
            })
            table.insert(t2.Belly, {
                "lat",
                TrikeSwim.RAM_CHEST * p31 / 2
            })
            table.insert(t2.Pelvis, {
                "nose",
                TrikeSwim.HIP_ROLL * math.sin(v31 - 6.283185307179586 * TrikeSwim.DIAG)
            })
            table.insert(t2.Pelvis, {
                "lat",
                -TrikeSwim.ROCK * math.sin(2 * v31)
            })
            t2.Neck = {
                {
                    "up",
                    -steady * n1 + sway * math.sin(v31 + TrikeSwim.LAG) + TrikeSwim.LOOK * p30 / 2
                },
                {
                    "nose",
                    steady * TrikeSwim.CHEST_ROLL * math.sin(v31)
                },
                {
                    "lat",
                    -steady * TrikeSwim.ROCK * math.sin(2 * v31) - TrikeSwim.RAM_NECK * p31
                }
            }
            t2.Head = {
                {
                    "up",
                    TrikeSwim.LOOK * p30 / 2
                },
                {
                    "lat",
                    nod * math.sin(2 * v31 - TrikeSwim.NOD_LAG) - TrikeSwim.RAM_HEAD * p31
                }
            }

            return t2
        end,
        register = function(p33) -- register | line: 133
            -- upvalues: p1 (copy), attr (copy)
            local TrikeSwim = p1.TrikeSwim
            local MeshPart = p33:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p33, "AnatomyInverse")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local t11 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t11[descendant.Name] = descendant
                end
            end

            for _, v46 in ipairs(TrikeSwim.BONES) do
                if not t11[v46] then
                    return nil
                end
            end

            local CFrame = MeshPart.CFrame
            local v47 = p33:GetPivot() * AnatomyInverse:Inverse()
            local v48 = CFrame:VectorToObjectSpace(v47.RightVector)
            local v49 = CFrame:VectorToObjectSpace(v47.UpVector)
            local Unit = v49:Cross(v48).Unit
            local v50 = -Unit
            local v51 = -v48
            local Size = MeshPart.Size
            local v54 = math.abs(v48.X) * Size.X + math.abs(v48.Y) * Size.Y + math.abs(v48.Z) * Size.Z
            local t12 = {}

            for _, v55 in ipairs(TrikeSwim.BONES) do
                local v56 = CFrame:ToObjectSpace(t11[v55].WorldCFrame)

                t12[v55] = {
                    bone = t11[v55],
                    nose = v56:VectorToObjectSpace(v48),
                    up = v56:VectorToObjectSpace(v49),
                    lat = v56:VectorToObjectSpace(v50),
                    pos = v56.Position,
                    M = v56.Rotation
                }
            end

            local function bodyVec(p34, p35) -- line: 160
                -- upvalues: v49 (copy), Unit (copy), v51 (copy)
                return Unit * (p35 * p34.X) + v51 * p34.Y + v49 * p34.Z
            end

            local t13 = {}
            local t14 = {}

            for _, v57 in ipairs({ "L", "R" }) do
                local v58 = if v57 == "L" then 1 else -1
                local v59 = t12["Arm_" .. v57]
                local v60 = t12["Fore_" .. v57]
                local v61 = t12["Hand_" .. v57]
                local v62 = #t13 + 1
                local t15 = {
                    s = v58,
                    b = {
                        v59.bone,
                        v60.bone,
                        v61.bone
                    },
                    M = {
                        v59.M,
                        v60.M,
                        v61.M
                    },
                    S = v59.pos,
                    E = v60.pos,
                    W = v61.pos
                }
                local ARM_POLE = TrikeSwim.ARM_POLE

                t15.pole = Unit * (v58 * ARM_POLE.X) + v51 * ARM_POLE.Y + v49 * ARM_POLE.Z
                t15.left = Unit
                t13[v62] = t15

                local v63 = t12["Thigh_" .. v57]
                local v64 = t12["Shin_" .. v57]
                local v65 = t12["Foot_" .. v57]
                local v66 = #t14 + 1
                local t16 = {
                    s = v58,
                    b = {
                        v63.bone,
                        v64.bone,
                        v65.bone
                    },
                    M = {
                        v63.M,
                        v64.M,
                        v65.M
                    },
                    S = v63.pos,
                    E = v64.pos,
                    W = v65.pos
                }
                local v67 = if attr(p33, "LegPoleY") then Vector3.new(0, attr(p33, "LegPoleY"), 0) or TrikeSwim.LEG_POLE else TrikeSwim.LEG_POLE

                t16.pole = Unit * (v58 * v67.X) + v51 * v67.Y + v49 * v67.Z
                t16.left = Unit
                t14[v66] = t16
            end

            local t17 = {
                turn = 0,
                v = 0
            }
            local t18, v68

            if attr(p33, "HeadSteady") then
                local t19 = {
                    steady = attr(p33, "HeadSteady"),
                    sway = attr(p33, "HeadSway") or 0,
                    nod = attr(p33, "HeadNod") or p1.TrikeSwim.NOD
                }

                if t19 then
                    t18 = t19
                    v68 = true
                else
                    v68 = false
                end
            else
                v68 = false
            end

            t17.headOpt = if not v68 then nil else t18
            t17.model = p33
            t17.mesh = MeshPart
            t17.A = t12
            t17.arms = t13
            t17.legs = t14
            t17.noseM = v48
            t17.phase = math.random()
            t17.length = v54

            return t17
        end,
        update = function(p36, p37) -- update | line: 178
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local TrikeSwim = p1.TrikeSwim
            local model = p36.model
            local _CFrame = p36.mesh.CFrame

            if p36.lastPos and p37 > 1E-04 then
                local v69 = (_CFrame.Position - p36.lastPos).Magnitude / p37

                if v69 < 2000 then
                    p36.v = p36.v + (v69 - p36.v) * math.min(1, p37 / TrikeSwim.V_TAU)
                end
            end

            p36.lastPos = _CFrame.Position

            local v72 = _CFrame:VectorToWorldSpace(p36.noseM)
            local v73 = Vector3.new(v72.X, 0, v72.Z)

            if v73.Magnitude > 1E-04 then
                local Unit = v73.Unit

                if p36.lastFlat and p37 > 1E-04 then
                    local v75 = math.atan2(p36.lastFlat:Cross(Unit).Y, (p36.lastFlat:Dot(Unit))) / p37

                    p36.turn = p36.turn + (math.clamp(v75 / TrikeSwim.TURN_FULL, -1, 1) - p36.turn) * math.min(1, p37 / TrikeSwim.TURN_TAU)
                end

                p36.lastFlat = Unit
            end

            local PEN_HZ = TrikeSwim.PEN_HZ
            local PassCruise = attr(model, "PassCruise")
            local n2 = 0

            if fightHooked(model) then
                PEN_HZ = TrikeSwim.HOOK_HZ
            elseif attr(model, "School") or PassCruise then
                PEN_HZ = math.min(TrikeSwim.MAX_HZ, (math.max(p36.v / (TrikeSwim.STRIDE * math.max(p36.length, 0.001)), TrikeSwim.MIN_HZ)))
                n2 = if type(PassCruise) == "number" then TrikeSwim.ramOf(p36.v / math.max(PassCruise, 0.001)) else 0
            end

            p36.phase = (p36.phase + p37 * PEN_HZ) % 1

            local phase, turn = p36.phase, p36.turn

            for v81, v82 in pairs(TrikeSwim.body(phase, turn, n2, p36.headOpt)) do
                local v83 = p36.A[v81]
                local v84 = CFrame.identity

                for _, v85 in ipairs(v82) do
                    v84 *= CFrame.fromAxisAngle(v83[v85[1]], v85[2])
                end

                v83.bone.Transform = v84
            end

            for _, v86 in ipairs(p36.arms) do
                local v87, v88, v89 = TrikeSwim.arm(v86, phase, turn, n2)
                local t20 = {
                    CFrame.identity,
                    v87,
                    v88,
                    v89
                }

                for i = 1, 3 do
                    v86.b[i].Transform = v86.M[i]:Inverse() * t20[i]:Inverse() * t20[i + 1] * v86.M[i]
                end
            end

            for _, v90 in ipairs(p36.legs) do
                local v91, v92, v93 = TrikeSwim.leg(v90, phase, turn, n2)
                local t21 = {
                    CFrame.identity,
                    v91,
                    v92,
                    v93
                }

                for j = 1, 3 do
                    v90.b[j].Transform = v90.M[j]:Inverse() * t21[j]:Inverse() * t21[j + 1] * v90.M[j]
                end
            end
        end
    }
end
