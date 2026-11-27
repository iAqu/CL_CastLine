-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.AnglerSwim = {
        LURE_K = 60,
        LURE_C = 6,
        LURE_SURGE = 0.03,
        LURE_TURN = 0.35,
        LURE_BOB = 0.06,
        LURE_IDLE = 0.1,
        LURE_MAX = 0.9,
        BODY = { "Spine_01", "Spine_02", "Spine_03", "Spine_04", "Tail_01", "Tail_02", "Tail_03" },
        LURE_FRAC = { 0.2, 0.35, 0.45 },
        SCULL = {
            HOVER_AMP = 0.35,
            SWIM_AMP = 0.1,
            HOOK_AMP = 0.55,
            HOVER_HZ = 0.9,
            SWIM_HZ = 1.6,
            HOOK_HZ = 4,
            BL_FULL = 1,
            FEATHER = 0.5
        },
        scullRate = function(p3, p4, p5) -- scullRate | line: 43
            -- upvalues: p1 (copy)
            local SCULL = p1.AnglerSwim.SCULL

            if p4 then
                return SCULL.HOOK_HZ, SCULL.HOOK_AMP
            end

            local v2 = math.clamp(p3 / SCULL.BL_FULL, 0, 1)

            return SCULL.HOVER_HZ + (SCULL.SWIM_HZ - SCULL.HOVER_HZ) * v2, SCULL.HOVER_AMP + ((p5 or SCULL.SWIM_AMP) - SCULL.HOVER_AMP) * v2
        end,
        scull = function(p6, p7) -- scull | line: 49
            -- upvalues: p1 (copy)
            return p7 * math.sin(p6), p1.AnglerSwim.SCULL.FEATHER * p7 * math.cos(p6)
        end,
        pathChain = function(p8, p9, p10, p11) -- pathChain | line: 53
            local t2 = {}
            local t3 = {}

            for _, v3 in ipairs(p8.segs) do
                local v4 = p9:PointToObjectSpace(v3.bone.WorldPosition):Dot(p10)

                t2[#t2 + 1] = {
                    seg = v3,
                    x = 0.5 - v4 / p8.length
                }
                t3[v3] = true
            end

            table.sort(t2, function(p12, p13) -- line: 60
                return p12.x < p13.x
            end)
            p8.chain = t2
            p8.inChain = t3

            local v5 = p9:ToObjectSpace(t2[1].seg.bone.WorldCFrame)

            p8.rootLat = v5:VectorToObjectSpace(p10:Cross(v5:VectorToWorldSpace(t2[1].seg.axis)))

            local v6 = p10:Cross(p11)

            for _, v7 in ipairs(t2) do
                local v8 = p9:ToObjectSpace(v7.seg.bone.WorldCFrame)

                v7.pitch = v8:VectorToObjectSpace(v6)
                v7.roll = v8:VectorToObjectSpace(p10)
            end

            p8.fins = {}
            p8.disp = 0
        end,
        register = function(p14) -- register | line: 72
            -- upvalues: p1 (copy), attr (copy)
            local AnglerSwim = p1.AnglerSwim
            local MeshPart = p14:FindFirstChildWhichIsA("MeshPart")

            if not MeshPart then
                return nil
            end

            local t4 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t4[descendant.Name] = descendant
                end
            end

            if not (t4.Spine_01 and t4.Spine_04 and t4.Lure_3) then
                return nil
            end

            local CFrame = MeshPart.CFrame
            local Unit = CFrame:VectorToObjectSpace(t4.Spine_01.WorldPosition - t4.Spine_04.WorldPosition).Unit
            local Unit2 = (Vector3.new(0, 1, 0) - Unit * Unit.Y).Unit
            local Unit3 = Unit:Cross(Unit2).Unit
            local v9 = (attr(p14, "WaveStiffness") or 2.6) * (0.85 + math.random() * 0.3)
            local t5 = {}
            local t6 = {}

            for v10, v11 in ipairs(AnglerSwim.BODY) do
                local v12 = t4[v11]

                if not v12 then
                    return nil
                end

                local v13 = (v10 - 1) / 6
                local t7 = {
                    bone = v12,
                    t = v13,
                    gain = 0.05 + 1.2 * v13 ^ v9,
                    axis = CFrame:ToObjectSpace(v12.WorldCFrame):VectorToObjectSpace(Unit2)
                }

                t5[#t5 + 1] = t7

                if v10 >= 2 then
                    t6[t7] = true
                end
            end

            local t8 = {}

            for i = 1, 3 do
                local v14 = t4["Lure_" .. i]
                local v15 = CFrame:ToObjectSpace(v14.WorldCFrame)

                t8[i] = {
                    bone = v14,
                    up = v15:VectorToObjectSpace(Unit2),
                    lat = v15:VectorToObjectSpace(Unit3)
                }
            end

            local Size = MeshPart.Size
            local t9 = {
                nBody = 6,
                w = 0,
                v = 0,
                lp = 0,
                lpv = 0,
                ly = 0,
                lyv = 0,
                acc = 0,
                model = p14,
                mesh = MeshPart,
                segs = t5,
                body = t6,
                nose = Unit,
                phase = math.random() * 3.141592653589793 * 2,
                ampMul = (attr(p14, "WaveAmp") or 1) * (0.75 + math.random() * 0.5),
                beatMul = (attr(p14, "WaveBeat") or 1) * (0.72 + math.random() * 0.56),
                length = math.abs(Unit.X) * Size.X + math.abs(Unit.Y) * Size.Y + math.abs(Unit.Z) * Size.Z,
                lure = t8,
                t = math.random() * 10
            }

            if attr(p14, "PecScull") and t4.Fin_L and t4.Fin_R then
                local t10 = {}

                for _, v18 in ipairs({
                        {
                            t4.Fin_L,
                            1
                        },
                        {
                            t4.Fin_R,
                            -1
                        }
                    }) do
                    t10[#t10 + 1] = {
                        bone = v18[1],
                        sgn = v18[2],
                        up = CFrame:ToObjectSpace(v18[1].WorldCFrame):VectorToObjectSpace(Unit2)
                    }
                end

                t9.pec = {
                    fins = t10,
                    phase = math.random() * 3.141592653589793 * 2,
                    swimAmp = attr(p14, "ScullAmp")
                }
            end

            if attr(p14, "PathSwim") then
                AnglerSwim.pathChain(t9, CFrame, Unit, Unit2)
            end

            t9.lureFwd = attr(p14, "LureFwd")

            return t9
        end,
        update = function(p15, p16, p17) -- update | line: 124
            -- upvalues: p1 (copy), fightHooked (copy)
            local AnglerSwim = p1.AnglerSwim

            p1.SharkSwim.update(p15, p16, p17)

            local v19 = math.min(p16, 0.03333333333333333)

            p15.t += p16

            if p16 > 1E-04 then
                local v20 = (p15.v - (p15.prevV or p15.v)) / p16

                p15.acc = p15.acc + (v20 - p15.acc) * math.min(1, p16 / 0.1)
            end

            p15.prevV = p15.v

            local v23 = if fightHooked(p15.model) then 4 else 1
            local v30 = math.clamp(AnglerSwim.LURE_SURGE * p15.acc + AnglerSwim.LURE_BOB * math.sin(p15.phase) + (p15.sweepP or 0) + AnglerSwim.LURE_IDLE * v23 * math.sin(1.7 * p15.t), -(p15.lureFwd or AnglerSwim.LURE_MAX), AnglerSwim.LURE_MAX)
            local v36 = math.clamp(-AnglerSwim.LURE_TURN * p15.w + AnglerSwim.LURE_IDLE * v23 * math.sin(1.1 * p15.t + 1) + (p15.sweepY or 0), -AnglerSwim.LURE_MAX, AnglerSwim.LURE_MAX)

            p15.lpv += (AnglerSwim.LURE_K * (v30 - p15.lp) - AnglerSwim.LURE_C * p15.lpv) * v19
            p15.lp += p15.lpv * v19

            if p15.lureFwd and p15.lp < -p15.lureFwd then
                local v37 = -p15.lureFwd
                local v38 = math.max(p15.lpv, 0)

                p15.lp = v37
                p15.lpv = v38
            end

            p15.lyv += (AnglerSwim.LURE_K * (v36 - p15.ly) - AnglerSwim.LURE_C * p15.lyv) * v19
            p15.ly += p15.lyv * v19

            for v39, v40 in ipairs(p15.lure) do
                local v41 = AnglerSwim.LURE_FRAC[v39]

                v40.bone.Transform = CFrame.fromAxisAngle(v40.up, p15.ly * v41) * CFrame.fromAxisAngle(v40.lat, p15.lp * v41)
            end

            local pec = p15.pec

            if not pec then
                return
            end

            local v42, v43 = AnglerSwim.scullRate(p15.v / math.max(p15.length, 0.001), fightHooked(p15.model), pec.swimAmp)

            pec.phase += p16 * 2 * 3.141592653589793 * v42

            local v44, v45 = AnglerSwim.scull(pec.phase, v43)

            for _, v46 in ipairs(pec.fins) do
                v46.bone.Transform = CFrame.fromAxisAngle(v46.up, v46.sgn * v44) * CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v46.sgn * v45)
            end
        end
    }
end
