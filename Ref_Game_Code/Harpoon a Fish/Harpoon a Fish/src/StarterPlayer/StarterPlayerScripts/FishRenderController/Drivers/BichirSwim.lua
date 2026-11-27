-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 21
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.BichirSwim = {
        LAM = 0.95,
        ALPHA = 2.6,
        TAIL = 0.1,
        HEAD_STEADY = 0.5,
        STRIDE = 0.9,
        MIN_HZ = 0.8,
        MAX_HZ = 4,
        HOOK_TAIL = 0.13,
        HOOK_ALPHA = 2.4,
        HOOK_HZ = 4.5,
        TURN_BEND = 0.15,
        TURN_FULL = 0.6,
        TURN_TAU = 0.3,
        FIN_RATIO = 1.5,
        AY = 0.04,
        AO = 0.022,
        OUT = (Vector3.new(1, 0, -0.7)).Unit,
        TURN_GAIN = 0.12,
        F_PEAK = 0.25,
        DIP = 0.6981317007977318,
        FOLD = 0.15,
        FOLD_V = 0.6,
        FIN_AMP = 0.08,
        FIN_TURN = 0.6,
        TIP = 0.985,
        V_TAU = 0.1,
        SPEC_L = 1.9163526,
        h = function(p3, p4, p5) -- h | line: 41
            -- upvalues: p1 (copy)
            local BichirSwim = p1.BichirSwim
            local v2 = if p5 then BichirSwim.HOOK_TAIL else BichirSwim.TAIL
            local v1 = if p5 then BichirSwim.HOOK_ALPHA else BichirSwim.ALPHA

            return v2 * math.exp(v1 * (p3 - 1)) * math.sin(p4 - 6.283185307179586 * p3 / BichirSwim.LAM)
        end,
        bodyHz = function(p6, p7) -- bodyHz | line: 47
            -- upvalues: p1 (copy)
            local BichirSwim = p1.BichirSwim

            if p7 then
                return BichirSwim.HOOK_HZ
            end

            return (math.min(BichirSwim.MAX_HZ, (math.max(BichirSwim.MIN_HZ, p6 / BichirSwim.STRIDE))))
        end,
        spine = function(p8, p9, p10, p11) -- spine | line: 53
            -- upvalues: p1 (copy)
            local BichirSwim = p1.BichirSwim
            local t2 = {}
            local v8 = BichirSwim.TURN_BEND * p10 / (#p8 - 1)
            local v9 = #p8 - 1
            local n1 = 0

            for i = 1, v9 do
                local v10 = p8[i]
                local v11 = p8[i + 1]
                local v13 = math.atan((BichirSwim.h(v11, p9, p11) - BichirSwim.h(v10, p9, p11)) / (v11 - v10))

                if i == 1 then
                    v13 *= BichirSwim.HEAD_STEADY
                end

                t2[i] = v13 - n1 + v8
                n1 = v13
            end

            return t2
        end,
        turnTo = function(p12, p13) -- turnTo | line: 69
            local Unit = p12.Unit
            local Unit2 = p13.Unit
            local v14 = Unit:Cross(Unit2)
            local Magnitude = v14.Magnitude

            if Magnitude < 1E-09 then
                return CFrame.identity
            end

            return CFrame.fromAxisAngle(v14 / Magnitude, (math.atan2(Magnitude, (Unit:Dot(Unit2)))))
        end,
        pawF = function(p14) -- pawF | line: 76
            -- upvalues: p1 (copy)
            local v18 = math.cos(6.283185307179586 * (p14 - p1.BichirSwim.F_PEAK)) * 0.5 + 0.5

            return v18 * v18 * (3 - v18 * 2)
        end,
        arm = function(p15, p16, p17) -- arm | line: 82
            -- upvalues: p1 (copy)
            local BichirSwim = p1.BichirSwim
            local s = p15.s
            local v19 = 6.283185307179586 * p16
            local v20 = 1 - s * BichirSwim.TURN_GAIN * p17
            local v21 = p15.left * (s * BichirSwim.OUT.X) + p15.up * BichirSwim.OUT.Z
            local v22 = p15.W0 + p15.back * (-BichirSwim.AY * p15.sc * v20 * math.cos(v19)) + v21 * (BichirSwim.AO * p15.sc * v20 * math.sin(v19))
            local S, E0, W0 = p15.S, p15.E0, p15.W0
            local Magnitude = (E0 - S).Magnitude
            local Magnitude2 = (W0 - E0).Magnitude
            local v23 = v22 - S
            local v25 = math.min(v23.Magnitude, (Magnitude + Magnitude2) * 0.999)
            local Unit = v23.Unit
            local Unit2 = (p15.pole - Unit * p15.pole:Dot(Unit)).Unit
            local v26 = (Magnitude * Magnitude - Magnitude2 * Magnitude2 + v25 * v25) / (v25 * 2)
            local v29 = math.sqrt((math.max(0, Magnitude * Magnitude - v26 * v26)))
            local v30 = S + Unit * v26 + Unit2 * v29
            local v31 = BichirSwim.turnTo(E0 - S, v30 - S)
            local v32 = BichirSwim.turnTo(v31 * (W0 - E0), v22 - v30) * v31
            local v33 = BichirSwim.pawF(p16)

            return v31, v32, CFrame.fromAxisAngle(v32 * p15.hinge0, -BichirSwim.DIP * v33) * v32
        end,
        register = function(p18) -- register | line: 104
            -- upvalues: p1 (copy), attr (copy)
            local BichirSwim = p1.BichirSwim
            local MeshPart = p18:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p18, "AnatomyInverse")
            local HandTipL = attr(p18, "HandTipL")
            local HandTipR = attr(p18, "HandTipR")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" or typeof(HandTipL) ~= "Vector3" or typeof(HandTipR) ~= "Vector3" then
                return nil
            end

            local CFrame = MeshPart.CFrame
            local v34 = p18:GetPivot() * AnatomyInverse:Inverse()
            local v35 = CFrame:VectorToObjectSpace(v34.RightVector)
            local v36 = CFrame:VectorToObjectSpace(v34.UpVector)
            local Unit = v36:Cross(v35).Unit
            local Size = MeshPart.Size
            local v39 = math.abs(v35.X) * Size.X + math.abs(v35.Y) * Size.Y + math.abs(v35.Z) * Size.Z
            local t3 = {}
            local t4 = {}

            for i = 1, 99 do
                local v40 = MeshPart:FindFirstChild(string.format("Spine_%02d", i), true)

                if not v40 then
                    break
                end

                local v41 = CFrame:ToObjectSpace(v40.WorldCFrame)

                t3[i] = {
                    bone = v40,
                    up = v41:VectorToObjectSpace(v36)
                }
                t4[i] = (v39 / 2 - v41.Position:Dot(v35)) / v39
            end

            if #t3 < 3 then
                return nil
            end

            t4[#t3 + 1] = BichirSwim.TIP

            local t5 = {}

            for _, v42 in ipairs({ "Fin_RL", "Fin_RR" }) do
                local v43 = MeshPart:FindFirstChild(v42, true)

                if not v43 then
                    return nil
                end

                local v44 = CFrame:ToObjectSpace(v43.WorldCFrame)

                t5[#t5 + 1] = {
                    bone = v43,
                    up = v44:VectorToObjectSpace(v36),
                    nose = v44:VectorToObjectSpace(v35),
                    s = v42:sub(-1) == "L" and 1 or -1
                }
            end

            local t7 = {}

            for _, v46 in ipairs({ "L", "R" }) do
                local t8 = {}

                for v47, v48 in ipairs({
                        "Fore_" .. v46,
                        "Fore_" .. v46 .. "_2",
                        "Fore_" .. v46 .. "_3"
                    }) do
                    t8[v47] = MeshPart:FindFirstChild(v48, true)

                    if not t8[v47] then
                        return nil
                    end
                end

                local v49 = CFrame:ToObjectSpace(t8[1].WorldCFrame)
                local v50 = CFrame:ToObjectSpace(t8[2].WorldCFrame)
                local v51 = CFrame:ToObjectSpace(t8[3].WorldCFrame)
                local Position = v49.Position
                local Position2 = v50.Position
                local Position3 = v51.Position
                local v52 = (v46 == "L" and HandTipL or HandTipR) * Size
                local Unit2 = (Position3 - Position).Unit

                t7[#t7 + 1] = {
                    s = v46 == "L" and 1 or -1,
                    b = t8,
                    M = {
                        v49.Rotation,
                        v50.Rotation,
                        v51.Rotation
                    },
                    S = Position,
                    E0 = Position2,
                    W0 = Position3,
                    pole = Position2 - Position - Unit2 * (Position2 - Position):Dot(Unit2),
                    hinge0 = (v52 - Position3):Cross(v36).Unit,
                    left = Unit,
                    back = -v35,
                    up = v36,
                    sc = v39 / BichirSwim.SPEC_L
                }
            end

            return {
                v = 0,
                turn = 0,
                model = p18,
                mesh = MeshPart,
                spine = t3,
                knots = t4,
                fins = t5,
                arms = t7,
                ext = v39,
                noseM = v35,
                phase = math.random() * 6.283185307179586,
                p = math.random()
            }
        end,
        update = function(p19, p20) -- update | line: 156
            -- upvalues: p1 (copy), fightHooked (copy)
            local BichirSwim = p1.BichirSwim
            local _CFrame = p19.mesh.CFrame

            if p19.lastPos and p20 > 1E-04 then
                local v54 = (_CFrame.Position - p19.lastPos).Magnitude / p20

                if v54 < 2000 then
                    p19.v = p19.v + (v54 - p19.v) * math.min(1, p20 / BichirSwim.V_TAU)
                end
            end

            p19.lastPos = _CFrame.Position

            local v57 = _CFrame:VectorToWorldSpace(p19.noseM)
            local v58 = Vector3.new(v57.X, 0, v57.Z)

            if v58.Magnitude > 1E-04 then
                local Unit = v58.Unit

                if p19.lastFlat and p20 > 1E-04 then
                    local v60 = math.atan2(p19.lastFlat:Cross(Unit).Y, (p19.lastFlat:Dot(Unit))) / p20

                    p19.turn = p19.turn + (math.clamp(v60 / BichirSwim.TURN_FULL, -1, 1) - p19.turn) * math.min(1, p20 / BichirSwim.TURN_TAU)
                end

                p19.lastFlat = Unit
            end

            local v64 = fightHooked(p19.model)
            local v65 = p19.v / math.max(p19.ext, 0.001)
            local v66 = BichirSwim.bodyHz(v65, v64)

            p19.phase = (p19.phase + p20 * 6.283185307179586 * v66) % 6.283185307179586
            p19.p = (p19.p + p20 * v66 * BichirSwim.FIN_RATIO) % 1

            local phase, p, turn = p19.phase, p19.p, p19.turn
            local v67 = BichirSwim.spine(p19.knots, phase, turn, v64)

            for v68, v69 in ipairs(p19.spine) do
                v69.bone.Transform = CFrame.fromAxisAngle(v69.up, v67[v68])
            end

            for _, v70 in ipairs(p19.fins) do
                local v74 = BichirSwim.FOLD * math.min(1, v65 / BichirSwim.FOLD_V) * (1 - BichirSwim.FIN_TURN * math.max(0, -v70.s * turn))

                v70.bone.Transform = CFrame.fromAxisAngle(v70.up, v70.s * v74) * CFrame.fromAxisAngle(v70.nose, v70.s * BichirSwim.FIN_AMP * math.sin(phase + 1.5))
            end

            for _, v78 in ipairs(p19.arms) do
                local v79, v80, v81 = BichirSwim.arm(v78, p, turn)
                local t10 = {
                    CFrame.identity,
                    v79,
                    v80,
                    v81
                }

                for i = 1, 3 do
                    v78.b[i].Transform = v78.M[i]:Inverse() * t10[i]:Inverse() * t10[i + 1] * v78.M[i]
                end
            end
        end
    }
end
