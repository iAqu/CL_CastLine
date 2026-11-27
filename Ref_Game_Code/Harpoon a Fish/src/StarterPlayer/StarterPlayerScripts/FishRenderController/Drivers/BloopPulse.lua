-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 15
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.BloopPulse = {
        STRIDE = 0.3,
        MIN_HZ = 0.8,
        MAX_HZ = 2.4,
        HOOK_HZ = 2.6,
        CONTRACT = 0.35,
        RIM_IN = 0.18,
        PULSE_AMP = 0.25,
        X0 = 0.3,
        A_L = 0.06,
        A_V = 0.04,
        A_R = 0.15,
        LAM_L = 1.1,
        LAM_V = 0.9,
        LAM_R = 1.4,
        PHV = 1.2,
        BEND = 0.35,
        HOOK_AMP = 1.4,
        TURN_FULL = 0.6,
        TURN_TAU = 0.3,
        V_TAU = 0.3,
        KNOTS = {
            0, 0.3, 0.38, 0.46, 0.54, 0.61, 0.68, 0.75,
            0.82, 0.89
        },
        ss = function(p3) -- ss | line: 27
            local v1 = math.clamp(p3, 0, 1)

            return v1 * v1 * (3 - 2 * v1)
        end,
        contraction = function(p4) -- contraction | line: 31
            -- upvalues: p1 (copy)
            local BloopPulse = p1.BloopPulse
            local v2 = p4 % 1

            if v2 < BloopPulse.CONTRACT then
                return BloopPulse.ss(v2 / BloopPulse.CONTRACT)
            end

            return 1 - BloopPulse.ss((v2 - BloopPulse.CONTRACT) / (1 - BloopPulse.CONTRACT))
        end,
        pose = function(p5, p6, p7) -- pose | line: 38
            -- upvalues: p1 (copy)
            local BloopPulse = p1.BloopPulse
            local v3 = BloopPulse.contraction(p5)
            local v4 = (1 + BloopPulse.PULSE_AMP * v3) * (p7 and BloopPulse.HOOK_AMP or 1)
            local v5 = 6.283185307179586 * p5

            local function env(p8) -- line: 43
                -- upvalues: BloopPulse (copy)
                return BloopPulse.ss((p8 - BloopPulse.X0) / (1 - BloopPulse.X0))
            end

            local function hl(p9) -- line: 44
                -- upvalues: BloopPulse (copy), v4 (copy), v5 (copy)
                return v4 * BloopPulse.A_L * BloopPulse.ss((p9 - BloopPulse.X0) / (1 - BloopPulse.X0)) * math.sin(v5 - 6.283185307179586 * p9 / BloopPulse.LAM_L)
            end

            local function hv(p10) -- line: 45
                -- upvalues: BloopPulse (copy), v4 (copy), v5 (copy)
                return v4 * BloopPulse.A_V * BloopPulse.ss((p10 - BloopPulse.X0) / (1 - BloopPulse.X0)) * math.sin(v5 - 6.283185307179586 * p10 / BloopPulse.LAM_V + BloopPulse.PHV)
            end

            local function rr(p11) -- line: 46
                -- upvalues: BloopPulse (copy), v4 (copy), v5 (copy)
                return v4 * BloopPulse.A_R * BloopPulse.ss((p11 - BloopPulse.X0) / (1 - BloopPulse.X0)) * math.sin(v5 - 6.283185307179586 * p11 / BloopPulse.LAM_R)
            end

            local KNOTS = BloopPulse.KNOTS
            local n1 = 0

            for _, v12 in ipairs(KNOTS) do
                if BloopPulse.X0 <= v12 then
                    n1 += 1
                end
            end

            local t2 = {}
            local n2 = 0
            local n3 = 0
            local n4 = 0

            for i = 1, #KNOTS do
                local v14 = KNOTS[i]
                local v15 = KNOTS[i + 1] or 1
                local v22 = math.atan((v4 * BloopPulse.A_L * BloopPulse.ss((v15 - BloopPulse.X0) / (1 - BloopPulse.X0)) * math.sin(v5 - 6.283185307179586 * v15 / BloopPulse.LAM_L) - v4 * BloopPulse.A_L * BloopPulse.ss((v14 - BloopPulse.X0) / (1 - BloopPulse.X0)) * math.sin(v5 - 6.283185307179586 * v14 / BloopPulse.LAM_L)) / (v15 - v14))
                local v29 = -math.atan((v4 * BloopPulse.A_V * BloopPulse.ss((v15 - BloopPulse.X0) / (1 - BloopPulse.X0)) * math.sin(v5 - 6.283185307179586 * v15 / BloopPulse.LAM_V + BloopPulse.PHV) - v4 * BloopPulse.A_V * BloopPulse.ss((v14 - BloopPulse.X0) / (1 - BloopPulse.X0)) * math.sin(v5 - 6.283185307179586 * v14 / BloopPulse.LAM_V + BloopPulse.PHV)) / (v15 - v14))
                local v32 = v4 * BloopPulse.A_R * BloopPulse.ss((v14 - BloopPulse.X0) / (1 - BloopPulse.X0)) * math.sin(v5 - 6.283185307179586 * v14 / BloopPulse.LAM_R)
                local t3 = {
                    {
                        "yaw",
                        v22 - n2
                    },
                    {
                        "pitch",
                        v29 - n3
                    },
                    {
                        "roll",
                        v32 - n4
                    }
                }

                n4 = v32

                if BloopPulse.X0 <= v14 then
                    t3[#t3 + 1] = {
                        "yaw",
                        BloopPulse.BEND * p6 / n1
                    }
                end

                t2[("Spine_%02d"):format(i)] = t3
                n2 = v22
                n3 = v29
            end

            t2.Rim_L = {
                {
                    "roll",
                    -BloopPulse.RIM_IN * v3
                }
            }
            t2.Rim_R = {
                {
                    "roll",
                    BloopPulse.RIM_IN * v3
                }
            }

            return t2
        end,
        register = function(p12) -- register | line: 66
            -- upvalues: p1 (copy), attr (copy)
            local BloopPulse = p1.BloopPulse
            local MeshPart = p12:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p12, "AnatomyInverse")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local CFrame = MeshPart.CFrame
            local v33 = p12:GetPivot() * AnatomyInverse:Inverse()
            local v34 = CFrame:VectorToObjectSpace(v33.RightVector)
            local v35 = CFrame:VectorToObjectSpace(v33.UpVector)
            local Unit = v35:Cross(v34).Unit
            local Size = MeshPart.Size
            local v38 = math.abs(v34.X) * Size.X + math.abs(v34.Y) * Size.Y + math.abs(v34.Z) * Size.Z
            local t4 = {}
            local t5 = {
                "Rim_L",
                "Rim_R"
            }

            for i = 1, #BloopPulse.KNOTS do
                t5[#t5 + 1] = ("Spine_%02d"):format(i)
            end

            for _, v39 in ipairs(t5) do
                local v40 = MeshPart:FindFirstChild(v39, true)

                if not v40 then
                    return nil
                end

                local v41 = CFrame:ToObjectSpace(v40.WorldCFrame)

                t4[v39] = {
                    bone = v40,
                    yaw = v41:VectorToObjectSpace(v35),
                    pitch = v41:VectorToObjectSpace(Unit),
                    roll = v41:VectorToObjectSpace(v34)
                }
            end

            return {
                turn = 0,
                v = 0,
                model = p12,
                mesh = MeshPart,
                A = t4,
                noseM = v34,
                length = v38,
                phase = math.random()
            }
        end,
        update = function(p13, p14) -- update | line: 89
            -- upvalues: p1 (copy), fightHooked (copy)
            local BloopPulse = p1.BloopPulse
            local _CFrame = p13.mesh.CFrame

            if p13.lastPos and p14 > 1E-04 then
                local v42 = (_CFrame.Position - p13.lastPos).Magnitude / p14

                if v42 < 2000 then
                    p13.v = p13.v + (v42 - p13.v) * math.min(1, p14 / BloopPulse.V_TAU)
                end
            end

            p13.lastPos = _CFrame.Position

            local v45 = _CFrame:VectorToWorldSpace(p13.noseM)
            local v46 = Vector3.new(v45.X, 0, v45.Z)

            if v46.Magnitude > 1E-04 then
                local Unit = v46.Unit

                if p13.lastFlat and p14 > 1E-04 then
                    local v48 = math.atan2(p13.lastFlat:Cross(Unit).Y, (p13.lastFlat:Dot(Unit))) / p14

                    p13.turn = p13.turn + (math.clamp(v48 / BloopPulse.TURN_FULL, -1, 1) - p13.turn) * math.min(1, p14 / BloopPulse.TURN_TAU)
                end

                p13.lastFlat = Unit
            end

            local v52 = fightHooked(p13.model)
            local HOOK_HZ = if v52 then BloopPulse.HOOK_HZ else nil

            if not v52 or not HOOK_HZ then
                HOOK_HZ = math.clamp(p13.v / (BloopPulse.STRIDE * math.max(p13.length, 0.001)), BloopPulse.MIN_HZ, BloopPulse.MAX_HZ)
            end

            p13.phase = (p13.phase + p14 * HOOK_HZ) % 1

            for v54, v55 in pairs(BloopPulse.pose(p13.phase, p13.turn, v52)) do
                local v56 = p13.A[v54]
                local v57 = CFrame.identity

                for _, v58 in ipairs(v55) do
                    v57 *= CFrame.fromAxisAngle(v56[v58[1]], v58[2])
                end

                v56.bone.Transform = v57
            end
        end
    }
end
