-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 28
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.AnkyloSwim = {
        PHI0 = -0.1,
        SWING = 0.3,
        FOLD = 0.1,
        FOLD_LEAD = -0.25,
        HAND0 = 0.15,
        HAND = 0.35,
        HAND_LAG = 0.3,
        ARM_POLE = Vector3.new(0.4, 1, 0),
        DIAG = 0.1,
        PHI_L0 = 0.1,
        LSWING = 0.3,
        FOLD_L = 0.1,
        FOLD_L_LEAD = 0,
        FOOT0 = 0,
        FOOT = 0.2,
        FOOT_LAG = 0.3,
        LEG_POLE = Vector3.new(0, -1, 0),
        RAM_SWING = 0.2,
        TURN_GAIN = 0.3,
        TRUNK = {
            { "Chest", 0.035 },
            { "Belly", 0.025 },
            { "Pelvis", 0.035 }
        },
        LAG = 0.6,
        BEND = 0.1,
        CHEST_ROLL = 0.05,
        HIP_ROLL = 0.04,
        ROCK = 0.02,
        CLUB = {
            { "Tail_1", 0.14, 0.9 },
            { "Tail_2", 0.14, 1.4 },
            { "Tail_3", 0.08, 1.9 }
        },
        RAM_CLUB = 1,
        RUDDER = 0.1,
        HEAD_STEADY = 0.85,
        LOOK = 0.1,
        NOD = 0.03,
        NOD_LAG = 0.5,
        RAM_CHEST = 0.05,
        RAM_NECK = 0.05,
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
        ramOf = function(p3) -- ramOf | line: 55
            -- upvalues: p1 (copy)
            local AnkyloSwim = p1.AnkyloSwim
            local v2 = math.clamp((p3 - AnkyloSwim.RAM_E0) / (AnkyloSwim.RAM_E1 - AnkyloSwim.RAM_E0), 0, 1)

            return v2 * v2 * (3 - v2 * 2)
        end,
        turnTo = function(p4, p5) -- turnTo | line: 61
            local Unit = p4.Unit
            local Unit2 = p5.Unit
            local v3 = Unit:Cross(Unit2)
            local Magnitude = v3.Magnitude

            if Magnitude < 1E-09 then
                return CFrame.identity
            end

            return CFrame.fromAxisAngle(v3 / Magnitude, (math.atan2(Magnitude, (Unit:Dot(Unit2)))))
        end,
        ik = function(p6, p7, p8, p9, p10) -- ik | line: 69
            -- upvalues: p1 (copy)
            local AnkyloSwim = p1.AnkyloSwim
            local Magnitude = (p7 - p6).Magnitude
            local Magnitude2 = (p8 - p7).Magnitude
            local v6 = p9 - p6
            local v8 = math.min(v6.Magnitude, (Magnitude + Magnitude2) * 0.999)
            local Unit = v6.Unit
            local Unit2 = (p10 - Unit * p10:Dot(Unit)).Unit
            local v9 = (Magnitude * Magnitude - Magnitude2 * Magnitude2 + v8 * v8) / (v8 * 2)
            local v12 = math.sqrt((math.max(0, Magnitude * Magnitude - v9 * v9)))
            local v13 = p6 + Unit * v9 + Unit2 * v12
            local v14 = AnkyloSwim.turnTo(p7 - p6, v13 - p6)

            return v14, AnkyloSwim.turnTo(v14 * (p8 - p7), p9 - v13) * v14
        end,
        target = function(p11, p12, p13, p14, p15, p16, p17, p18, p19, p20) -- target | line: 84
            -- upvalues: p1 (copy)
            local AnkyloSwim = p1.AnkyloSwim
            local v15 = 6.283185307179586 * p14
            local v16 = p15 - p16 * (1 + AnkyloSwim.RAM_SWING * p20) * p19 * math.cos(v15)

            return p12 + CFrame.fromAxisAngle(p11.left, v16) * (p13 - p12) * (1 - p17 * (1 - math.sin(v15 + p18)) / 2)
        end,
        arm = function(p21, p22, p23, p24) -- arm | line: 91
            -- upvalues: p1 (copy)
            local AnkyloSwim = p1.AnkyloSwim
            local s = p21.s
            local v19 = (p22 + (if s == 1 then 0 else 0.5)) % 1
            local v20 = 1 - s * AnkyloSwim.TURN_GAIN * p23
            local v21, v22 = AnkyloSwim.ik(p21.S, p21.E, p21.W, AnkyloSwim.target(p21, p21.S, p21.W, v19, AnkyloSwim.PHI0, AnkyloSwim.SWING, AnkyloSwim.FOLD, AnkyloSwim.FOLD_LEAD, v20, p24), p21.pole)

            return v21, v22, CFrame.fromAxisAngle(v22 * p21.left, AnkyloSwim.HAND0 + AnkyloSwim.HAND * math.sin(6.283185307179586 * v19 - AnkyloSwim.HAND_LAG)) * v22
        end,
        leg = function(p25, p26, p27, p28) -- leg | line: 101
            -- upvalues: p1 (copy)
            local AnkyloSwim = p1.AnkyloSwim
            local s = p25.s
            local v25 = (p26 - AnkyloSwim.DIAG + (if s == 1 then 0.5 else 0)) % 1
            local v26 = 1 - s * AnkyloSwim.TURN_GAIN * p27
            local v27, v28 = AnkyloSwim.ik(p25.S, p25.E, p25.W, AnkyloSwim.target(p25, p25.S, p25.W, v25, AnkyloSwim.PHI_L0, AnkyloSwim.LSWING, AnkyloSwim.FOLD_L, AnkyloSwim.FOLD_L_LEAD, v26, p28), p25.pole)

            return v27, v28, CFrame.fromAxisAngle(v28 * p25.left, AnkyloSwim.FOOT0 - AnkyloSwim.FOOT * math.sin(6.283185307179586 * v25 - AnkyloSwim.FOOT_LAG)) * v28
        end,
        body = function(p29, p30, p31, p32) -- body | line: 112
            -- upvalues: p1 (copy)
            local AnkyloSwim = p1.AnkyloSwim
            local steady = if p32 then p32.steady or AnkyloSwim.HEAD_STEADY else AnkyloSwim.HEAD_STEADY
            local sway = p32 and p32.sway or 0
            local nod = if p32 then p32.nod or AnkyloSwim.NOD else AnkyloSwim.NOD
            local v31 = 6.283185307179586 * p29
            local t2 = {}
            local n1 = 0

            for v32, v33 in ipairs(AnkyloSwim.TRUNK) do
                local v36 = v33[2] * math.sin(v31 - (v32 - 1) * AnkyloSwim.LAG)

                if v33[1] == "Chest" then
                    n1 = v36
                    t2[v33[1]] = { { "up", v36 } }
                else
                    t2[v33[1]] = {
                        {
                            "up",
                            v36 + AnkyloSwim.BEND * p30 / 4
                        }
                    }
                end
            end

            for _, v37 in ipairs(AnkyloSwim.CLUB) do
                t2[v37[1]] = {
                    {
                        "up",
                        v37[2] * (1 + AnkyloSwim.RAM_CLUB * p31) * math.sin(v31 - v37[3]) + AnkyloSwim.RUDDER * p30 / 2
                    }
                }
            end

            table.insert(t2.Chest, {
                "nose",
                -AnkyloSwim.CHEST_ROLL * math.sin(v31)
            })
            table.insert(t2.Chest, {
                "lat",
                AnkyloSwim.ROCK * math.sin(2 * v31) - AnkyloSwim.RAM_CHEST * p31
            })
            table.insert(t2.Belly, {
                "lat",
                AnkyloSwim.RAM_CHEST * p31 / 2
            })
            table.insert(t2.Pelvis, {
                "nose",
                AnkyloSwim.HIP_ROLL * math.sin(v31 - 6.283185307179586 * AnkyloSwim.DIAG)
            })
            table.insert(t2.Pelvis, {
                "lat",
                -AnkyloSwim.ROCK * math.sin(2 * v31)
            })
            t2.Neck = {
                {
                    "up",
                    -steady * n1 + sway * math.sin(v31 + AnkyloSwim.LAG) + AnkyloSwim.LOOK * p30 / 2
                },
                {
                    "nose",
                    steady * AnkyloSwim.CHEST_ROLL * math.sin(v31)
                },
                {
                    "lat",
                    -steady * AnkyloSwim.ROCK * math.sin(2 * v31) - AnkyloSwim.RAM_NECK * p31
                }
            }
            t2.Head = {
                {
                    "up",
                    AnkyloSwim.LOOK * p30 / 2
                },
                {
                    "lat",
                    nod * math.sin(2 * v31 - AnkyloSwim.NOD_LAG) - AnkyloSwim.RAM_HEAD * p31
                }
            }

            return t2
        end,
        register = function(p33) -- register | line: 140
            -- upvalues: p1 (copy), attr (copy)
            local AnkyloSwim = p1.AnkyloSwim
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

            for _, v50 in ipairs(AnkyloSwim.BONES) do
                if not t11[v50] then
                    return nil
                end
            end

            local CFrame = MeshPart.CFrame
            local v51 = p33:GetPivot() * AnatomyInverse:Inverse()
            local v52 = CFrame:VectorToObjectSpace(v51.RightVector)
            local v53 = CFrame:VectorToObjectSpace(v51.UpVector)
            local Unit = v53:Cross(v52).Unit
            local v54 = -Unit
            local v55 = -v52
            local Size = MeshPart.Size
            local v58 = math.abs(v52.X) * Size.X + math.abs(v52.Y) * Size.Y + math.abs(v52.Z) * Size.Z
            local t12 = {}

            for _, v59 in ipairs(AnkyloSwim.BONES) do
                local v60 = CFrame:ToObjectSpace(t11[v59].WorldCFrame)

                t12[v59] = {
                    bone = t11[v59],
                    nose = v60:VectorToObjectSpace(v52),
                    up = v60:VectorToObjectSpace(v53),
                    lat = v60:VectorToObjectSpace(v54),
                    pos = v60.Position,
                    M = v60.Rotation
                }
            end

            local function bodyVec(p34, p35) -- line: 167
                -- upvalues: v53 (copy), Unit (copy), v55 (copy)
                return Unit * (p35 * p34.X) + v55 * p34.Y + v53 * p34.Z
            end

            local t13 = {}
            local t14 = {}

            for _, v61 in ipairs({ "L", "R" }) do
                local v62 = if v61 == "L" then 1 else -1
                local v63 = t12["Arm_" .. v61]
                local v64 = t12["Fore_" .. v61]
                local v65 = t12["Hand_" .. v61]
                local v66 = #t13 + 1
                local t15 = {
                    s = v62,
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
                local ARM_POLE = AnkyloSwim.ARM_POLE

                t15.pole = Unit * (v62 * ARM_POLE.X) + v55 * ARM_POLE.Y + v53 * ARM_POLE.Z
                t15.left = Unit
                t13[v66] = t15

                local v67 = t12["Thigh_" .. v61]
                local v68 = t12["Shin_" .. v61]
                local v69 = t12["Foot_" .. v61]
                local v70 = #t14 + 1
                local t16 = {
                    s = v62,
                    b = {
                        v67.bone,
                        v68.bone,
                        v69.bone
                    },
                    M = {
                        v67.M,
                        v68.M,
                        v69.M
                    },
                    S = v67.pos,
                    E = v68.pos,
                    W = v69.pos
                }
                local v71 = if attr(p33, "LegPoleY") then Vector3.new(0, attr(p33, "LegPoleY"), 0) or AnkyloSwim.LEG_POLE else AnkyloSwim.LEG_POLE

                t16.pole = Unit * (v62 * v71.X) + v55 * v71.Y + v53 * v71.Z
                t16.left = Unit
                t14[v70] = t16
            end

            local t17 = {
                turn = 0,
                v = 0
            }
            local t18, v72

            if attr(p33, "HeadSteady") then
                local t19 = {
                    steady = attr(p33, "HeadSteady"),
                    sway = attr(p33, "HeadSway") or 0,
                    nod = attr(p33, "HeadNod") or p1.AnkyloSwim.NOD
                }

                if t19 then
                    t18 = t19
                    v72 = true
                else
                    v72 = false
                end
            else
                v72 = false
            end

            t17.headOpt = if not v72 then nil else t18
            t17.model = p33
            t17.mesh = MeshPart
            t17.A = t12
            t17.arms = t13
            t17.legs = t14
            t17.noseM = v52
            t17.phase = math.random()
            t17.length = v58

            return t17
        end,
        update = function(p36, p37) -- update | line: 185
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local AnkyloSwim = p1.AnkyloSwim
            local model = p36.model
            local _CFrame = p36.mesh.CFrame

            if p36.lastPos and p37 > 1E-04 then
                local v73 = (_CFrame.Position - p36.lastPos).Magnitude / p37

                if v73 < 2000 then
                    p36.v = p36.v + (v73 - p36.v) * math.min(1, p37 / AnkyloSwim.V_TAU)
                end
            end

            p36.lastPos = _CFrame.Position

            local v76 = _CFrame:VectorToWorldSpace(p36.noseM)
            local v77 = Vector3.new(v76.X, 0, v76.Z)

            if v77.Magnitude > 1E-04 then
                local Unit = v77.Unit

                if p36.lastFlat and p37 > 1E-04 then
                    local v79 = math.atan2(p36.lastFlat:Cross(Unit).Y, (p36.lastFlat:Dot(Unit))) / p37

                    p36.turn = p36.turn + (math.clamp(v79 / AnkyloSwim.TURN_FULL, -1, 1) - p36.turn) * math.min(1, p37 / AnkyloSwim.TURN_TAU)
                end

                p36.lastFlat = Unit
            end

            local PEN_HZ = AnkyloSwim.PEN_HZ
            local PassCruise = attr(model, "PassCruise")
            local n2 = 0

            if fightHooked(model) then
                PEN_HZ = AnkyloSwim.HOOK_HZ
            elseif attr(model, "School") or PassCruise then
                PEN_HZ = math.min(AnkyloSwim.MAX_HZ, (math.max(p36.v / (AnkyloSwim.STRIDE * math.max(p36.length, 0.001)), AnkyloSwim.MIN_HZ)))
                n2 = if type(PassCruise) == "number" then AnkyloSwim.ramOf(p36.v / math.max(PassCruise, 0.001)) else 0
            end

            p36.phase = (p36.phase + p37 * PEN_HZ) % 1

            local phase, turn = p36.phase, p36.turn

            for v85, v86 in pairs(AnkyloSwim.body(phase, turn, n2, p36.headOpt)) do
                local v87 = p36.A[v85]
                local v88 = CFrame.identity

                for _, v89 in ipairs(v86) do
                    v88 *= CFrame.fromAxisAngle(v87[v89[1]], v89[2])
                end

                v87.bone.Transform = v88
            end

            for _, v90 in ipairs(p36.arms) do
                local v91, v92, v93 = AnkyloSwim.arm(v90, phase, turn, n2)
                local t20 = {
                    CFrame.identity,
                    v91,
                    v92,
                    v93
                }

                for i = 1, 3 do
                    v90.b[i].Transform = v90.M[i]:Inverse() * t20[i]:Inverse() * t20[i + 1] * v90.M[i]
                end
            end

            for _, v94 in ipairs(p36.legs) do
                local v95, v96, v97 = AnkyloSwim.leg(v94, phase, turn, n2)
                local t21 = {
                    CFrame.identity,
                    v95,
                    v96,
                    v97
                }

                for j = 1, 3 do
                    v94.b[j].Transform = v94.M[j]:Inverse() * t21[j]:Inverse() * t21[j + 1] * v94.M[j]
                end
            end
        end
    }
end
