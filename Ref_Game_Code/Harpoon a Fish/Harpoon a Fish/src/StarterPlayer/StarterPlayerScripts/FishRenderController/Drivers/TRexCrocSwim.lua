-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 22
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.TRexCrocSwim = {
        WAVE = {
            { "Chest", 0.02 },
            { "Belly", 0.03 },
            { "Pelvis", 0.05 },
            { "Tail_1", 0.09 },
            { "Tail_2", 0.14 },
            { "Tail_3", 0.19 },
            { "Tail_4", 0.24 },
            { "Tail_5", 0.29 }
        },
        LAG = 0.6,
        RAM_TAIL = 0.5,
        HEAD_STEADY = 0.4,
        BEND = 0.12,
        LOOK = 0.2,
        RAM_NECK = 0.08,
        HEAD_SWAY = 0.07,
        HEAD_SWAY2 = 0.05,
        NOD = 0.035,
        HEAD_ROLL = 0.03,
        ARM = {
            PH = 0.2,
            FOLD0 = 1.05,
            SWING = 0.15,
            DRAW = 0.1,
            SPLAY = 0.03,
            END0 = 0.4,
            END = 0.25,
            END_LAG = 0.9,
            RAM_TUCK = 0.2
        },
        LEG = {
            PH = 0.45,
            FOLD0 = 0.7,
            SWING = 0.18,
            DRAW = 0.1,
            SPLAY = 0.03,
            END0 = 1.4,
            END = 0.3,
            END_LAG = 0.6,
            RAM_TUCK = 0.15
        },
        TURN_GAIN = 0.3,
        RAM_E0 = 1.25,
        RAM_E1 = 1.5,
        BITE = 0.55,
        BITE_R = 0.5,
        CLOSE_T = 0.12,
        HOLD_T = 0.15,
        OPEN_T = 0.35,
        STRIDE = 0.39,
        MIN_HZ = 0.5,
        MAX_HZ = 3.5,
        HOOK_HZ = 2.5,
        PEN_HZ = 0.5,
        SPEC_L = 1.902544,
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
            "Tail_4",
            "Tail_5",
            "Neck",
            "Head",
            "Jaw",
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
        ss = function(p3) -- ss | line: 43
            local v1 = math.clamp(p3, 0, 1)

            return v1 * v1 * (3 - 2 * v1)
        end,
        ramOf = function(p4) -- ramOf | line: 47
            -- upvalues: p1 (copy)
            local TRexCrocSwim = p1.TRexCrocSwim

            return TRexCrocSwim.ss((p4 - TRexCrocSwim.RAM_E0) / (TRexCrocSwim.RAM_E1 - TRexCrocSwim.RAM_E0))
        end,
        biteEnv = function(p5) -- biteEnv | line: 52
            -- upvalues: p1 (copy)
            local TRexCrocSwim = p1.TRexCrocSwim

            if p5 == nil then
                return 0
            end

            return TRexCrocSwim.ss(p5 / TRexCrocSwim.CLOSE_T) * (1 - TRexCrocSwim.ss((p5 - TRexCrocSwim.CLOSE_T - TRexCrocSwim.HOLD_T) / TRexCrocSwim.OPEN_T))
        end,
        turnTo = function(p6, p7) -- turnTo | line: 58
            local Unit = p6.Unit
            local Unit2 = p7.Unit
            local v2 = Unit:Cross(Unit2)
            local Magnitude = v2.Magnitude

            if Magnitude < 1E-09 then
                return CFrame.identity
            end

            return CFrame.fromAxisAngle(v2 / Magnitude, (math.atan2(Magnitude, (Unit:Dot(Unit2)))))
        end,
        ik = function(p8, p9, p10, p11, p12) -- ik | line: 66
            -- upvalues: p1 (copy)
            local TRexCrocSwim = p1.TRexCrocSwim
            local Magnitude = (p9 - p8).Magnitude
            local Magnitude2 = (p10 - p9).Magnitude
            local v5 = p11 - p8
            local v7 = math.min(v5.Magnitude, (Magnitude + Magnitude2) * 0.999)
            local Unit = v5.Unit
            local Unit2 = (p12 - Unit * p12:Dot(Unit)).Unit
            local v8 = (Magnitude * Magnitude - Magnitude2 * Magnitude2 + v7 * v7) / (v7 * 2)
            local v11 = math.sqrt((math.max(0, Magnitude * Magnitude - v8 * v8)))
            local v12 = p8 + Unit * v8 + Unit2 * v11
            local v13 = TRexCrocSwim.turnTo(p9 - p8, v12 - p8)

            return v13, TRexCrocSwim.turnTo(v13 * (p10 - p9), p11 - v12) * v13
        end,
        target = function(p13, p14, p15, p16, p17) -- target | line: 81
            local v14 = 6.283185307179586 * p15
            local v15 = p14.FOLD0 + p14.RAM_TUCK * p17 + p14.SWING * (1 - p17) * p16 * math.cos(v14)
            local v16 = (1 - math.sin(v14)) / 2

            return p13.S + CFrame.fromAxisAngle(p13.left, v15) * (p13.W - p13.S) * (1 - p14.DRAW * (1 - p17) * v16) + p13.left * (p13.s * p14.SPLAY * p13.sc * v16)
        end,
        limb = function(p18, p19, p20, p21, p22) -- limb | line: 88
            -- upvalues: p1 (copy)
            local TRexCrocSwim = p1.TRexCrocSwim
            local s = p18.s
            local v17 = (p20 + p19.PH + (if s == 1 then 0 else 0.5)) % 1
            local v18 = 1 - s * TRexCrocSwim.TURN_GAIN * p21
            local v19, v20 = TRexCrocSwim.ik(p18.S, p18.E, p18.W, TRexCrocSwim.target(p18, p19, v17, v18, p22), p18.pole)

            return v19, v20, CFrame.fromAxisAngle(v20 * p18.left, p19.END0 + p19.END * (1 - p22) * math.sin(6.283185307179586 * v17 - p19.END_LAG)) * v20
        end,
        body = function(p23, p24, p25, p26) -- body | line: 98
            -- upvalues: p1 (copy)
            local TRexCrocSwim = p1.TRexCrocSwim
            local v24 = 6.283185307179586 * p23
            local t2 = {}
            local n1 = 0

            for v25, v26 in ipairs(TRexCrocSwim.WAVE) do
                local v29 = v26[2] * (1 + (v25 >= 3 and TRexCrocSwim.RAM_TAIL * p25 or 0)) * math.sin(v24 - (v25 - 1) * TRexCrocSwim.LAG)

                if v26[1] == "Chest" then
                    n1 = v29
                    t2[v26[1]] = { { "up", v29 } }
                else
                    t2[v26[1]] = {
                        {
                            "up",
                            v29 + TRexCrocSwim.BEND * p24 / 4
                        }
                    }
                end
            end

            t2.Neck = {
                {
                    "up",
                    -TRexCrocSwim.HEAD_STEADY * n1 + TRexCrocSwim.HEAD_SWAY * math.sin(v24 + TRexCrocSwim.LAG) + TRexCrocSwim.LOOK * p24 / 2
                },
                {
                    "lat",
                    TRexCrocSwim.RAM_NECK * p25 + TRexCrocSwim.NOD * math.sin(2 * v24)
                },
                {
                    "nose",
                    TRexCrocSwim.HEAD_ROLL * math.sin(v24 + TRexCrocSwim.LAG)
                }
            }
            t2.Head = {
                {
                    "up",
                    TRexCrocSwim.HEAD_SWAY2 * math.sin(v24 + 2 * TRexCrocSwim.LAG) + TRexCrocSwim.LOOK * p24 / 2
                },
                {
                    "lat",
                    TRexCrocSwim.NOD * 0.6 * math.sin(2 * v24 - TRexCrocSwim.LAG)
                }
            }
            t2.Jaw = {
                {
                    "lat",
                    TRexCrocSwim.BITE * p26
                }
            }

            return t2
        end,
        register = function(p27) -- register | line: 118
            -- upvalues: p1 (copy), attr (copy)
            local TRexCrocSwim = p1.TRexCrocSwim
            local MeshPart = p27:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p27, "AnatomyInverse")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local t6 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t6[descendant.Name] = descendant
                end
            end

            for _, v38 in ipairs(TRexCrocSwim.BONES) do
                if not t6[v38] then
                    return nil
                end
            end

            local CFrame = MeshPart.CFrame
            local v39 = p27:GetPivot() * AnatomyInverse:Inverse()
            local v40 = CFrame:VectorToObjectSpace(v39.RightVector)
            local v41 = CFrame:VectorToObjectSpace(v39.UpVector)
            local Unit = v41:Cross(v40).Unit
            local v42 = -Unit
            local Size = MeshPart.Size
            local v45 = math.abs(v40.X) * Size.X + math.abs(v40.Y) * Size.Y + math.abs(v40.Z) * Size.Z
            local t7 = {}

            for _, v46 in ipairs(TRexCrocSwim.BONES) do
                local v47 = CFrame:ToObjectSpace(t6[v46].WorldCFrame)

                t7[v46] = {
                    bone = t6[v46],
                    nose = v47:VectorToObjectSpace(v40),
                    up = v47:VectorToObjectSpace(v41),
                    lat = v47:VectorToObjectSpace(v42),
                    pos = v47.Position,
                    M = v47.Rotation
                }
            end

            local t8 = {}

            for _, v48 in ipairs({ "L", "R" }) do
                local v49 = if v48 == "L" then 1 else -1

                for _, v50 in ipairs({
                        {
                            "Arm_",
                            "Fore_",
                            "Hand_",
                            TRexCrocSwim.ARM
                        },
                        {
                            "Thigh_",
                            "Shin_",
                            "Foot_",
                            TRexCrocSwim.LEG
                        }
                    }) do
                    local v51 = t7[v50[1] .. v48]
                    local v52 = t7[v50[2] .. v48]
                    local v53 = t7[v50[3] .. v48]
                    local pos = v51.pos
                    local pos2 = v52.pos
                    local pos3 = v53.pos
                    local Unit2 = (pos3 - pos).Unit
                    local v54 = pos2 - pos - Unit2 * (pos2 - pos):Dot(Unit2)

                    t8[#t8 + 1] = {
                        s = v49,
                        P = v50[4],
                        b = {
                            v51.bone,
                            v52.bone,
                            v53.bone
                        },
                        M = {
                            v51.M,
                            v52.M,
                            v53.M
                        },
                        S = pos,
                        E = pos2,
                        W = pos3,
                        pole = v54,
                        left = Unit,
                        sc = v45 / TRexCrocSwim.SPEC_L
                    }
                end
            end

            return {
                turn = 0,
                v = 0,
                t = 0,
                armed = true,
                biteT0 = nil,
                model = p27,
                mesh = MeshPart,
                A = t7,
                limbs = t8,
                noseM = v40,
                phase = math.random(),
                length = v45
            }
        end,
        update = function(p28, p29) -- update | line: 161
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local TRexCrocSwim = p1.TRexCrocSwim
            local model = p28.model
            local _CFrame = p28.mesh.CFrame

            p28.t += p29

            if p28.lastPos and p29 > 1E-04 then
                local v55 = (_CFrame.Position - p28.lastPos).Magnitude / p29

                if v55 < 2000 then
                    p28.v = p28.v + (v55 - p28.v) * math.min(1, p29 / TRexCrocSwim.V_TAU)
                end
            end

            p28.lastPos = _CFrame.Position

            local v58 = _CFrame:VectorToWorldSpace(p28.noseM)
            local v59 = Vector3.new(v58.X, 0, v58.Z)

            if v59.Magnitude > 1E-04 then
                local Unit = v59.Unit

                if p28.lastFlat and p29 > 1E-04 then
                    local v61 = math.atan2(p28.lastFlat:Cross(Unit).Y, (p28.lastFlat:Dot(Unit))) / p29

                    p28.turn = p28.turn + (math.clamp(v61 / TRexCrocSwim.TURN_FULL, -1, 1) - p28.turn) * math.min(1, p29 / TRexCrocSwim.TURN_TAU)
                end

                p28.lastFlat = Unit
            end

            local PEN_HZ = TRexCrocSwim.PEN_HZ
            local PassCruise = attr(model, "PassCruise")
            local n2 = 0

            if fightHooked(model) then
                PEN_HZ = TRexCrocSwim.HOOK_HZ
            elseif attr(model, "School") or PassCruise then
                PEN_HZ = math.min(TRexCrocSwim.MAX_HZ, (math.max(p28.v / (TRexCrocSwim.STRIDE * math.max(p28.length, 0.001)), TRexCrocSwim.MIN_HZ)))
                n2 = if type(PassCruise) == "number" then TRexCrocSwim.ramOf(p28.v / math.max(PassCruise, 0.001)) else 0
            end

            if p28.armed and TRexCrocSwim.BITE_R < n2 then
                p28.biteT0 = p28.t
                p28.armed = false
            elseif not p28.armed and n2 < TRexCrocSwim.BITE_R / 2 then
                p28.armed = true
            end

            local v67 = TRexCrocSwim.biteEnv(p28.biteT0 and p28.t - p28.biteT0 or nil)

            p28.phase = (p28.phase + p29 * PEN_HZ) % 1

            local phase, turn = p28.phase, p28.turn

            for v68, v69 in pairs(TRexCrocSwim.body(phase, turn, n2, v67)) do
                local v70 = p28.A[v68]
                local v71 = CFrame.identity

                for _, v72 in ipairs(v69) do
                    v71 *= CFrame.fromAxisAngle(v70[v72[1]], v72[2])
                end

                v70.bone.Transform = v71
            end

            for _, v73 in ipairs(p28.limbs) do
                local v74, v75, v76 = TRexCrocSwim.limb(v73, v73.P, phase, turn, n2)
                local t9 = {
                    CFrame.identity,
                    v74,
                    v75,
                    v76
                }

                for i = 1, 3 do
                    v73.b[i].Transform = v73.M[i]:Inverse() * t9[i]:Inverse() * t9[i + 1] * v73.M[i]
                end
            end
        end
    }
end
