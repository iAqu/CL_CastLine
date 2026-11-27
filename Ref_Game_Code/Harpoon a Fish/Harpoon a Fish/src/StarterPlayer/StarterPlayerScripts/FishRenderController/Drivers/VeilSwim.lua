-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.VeilSwim = {
        LOCK = 10,
        W_TAU = 0.15,
        V_TAU = 0.3,
        FIN_RATE = 1.2,
        FLUT_RATE = 7,
        SPINE = { "Spine_02", "Spine_03", "Spine_04" },
        SG = { 0.04, 0.08, 0.14 },
        ST = { 0.1, 0.2, 0.3 },
        AMP_B = 0.3,
        K = 2.6,
        VEIL = { "Tail_01", "Tail_02", "Tail_03", "Tail_04", "Tail_05", "Tail_06" },
        GT = { 0.35, 0.35, 0.3, 0.3, 0.25, 0.25 },
        AMP_T = 0.35,
        K_T = 0.7,
        IDLE = 0.12,
        BILLOW = 0.05,
        BEND = 0.6,
        FIN_AMP = 0.25,
        HOVER = 0.8,
        HOOK_RATE = 13,
        HOOK_EFFORT = 1.6,
        PEN_RATE = 4,
        SAIL_AMP = 0.18,
        SAIL_IDLE = 0.1,
        SAIL_RATE = 1.4,
        SAIL_K = 0.9,
        SAIL_LAG = 0.9,
        SAIL_TIP = 1.2,
        SAIL_SWEEP = 0.25,
        SAIL_MAX = 0.35,
        LEAN = 0.15,
        LEAN_REF = 1.5,
        FIN_TIP = 1,
        FIN_LAG = 1,
        BARB_K = 30,
        BARB_C = 4,
        BARB_TRAIL = 0.35,
        BARB_SURGE = 0.02,
        BARB_TURN = 0.25,
        BARB_MAX = 0.8,
        BARB_FRAC = { 0.3, 0.35, 0.35 },
        BARB_RIP = 0.12,
        BARB_K_RIP = 1.1,
        SP_BL = 1,
        SP_EASE = 3,
        LIP_RATE = 3,
        LIP_HOOK = 3,
        BARBS = { "BarbL", "BarbR", "WhiskL", "WhiskR" },
        register = function(p3) -- register | line: 53
            -- upvalues: p1 (copy), attr (copy)
            local MeshPart = p3:FindFirstChildWhichIsA("MeshPart")

            if not MeshPart then
                return nil
            end

            local t2 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t2[descendant.Name] = descendant
                end
            end

            if not (t2.Spine_01 and t2.Spine_04 and t2.Tail_06 and t2.Fin_L and t2.Fin_R) then
                return nil
            end

            local CFrame = MeshPart.CFrame
            local Unit = CFrame:VectorToObjectSpace(t2.Spine_01.WorldPosition - t2.Spine_04.WorldPosition).Unit
            local Unit2 = CFrame:VectorToObjectSpace(t2.Fin_R.WorldPosition - t2.Fin_L.WorldPosition).Unit
            local Unit3 = Unit2:Cross(Unit).Unit
            local t3 = {}

            for v1, v2 in pairs(t2) do
                local v3 = CFrame:ToObjectSpace(v2.WorldCFrame)

                t3[v1] = {
                    bone = v2,
                    up = v3:VectorToObjectSpace(Unit3),
                    right = v3:VectorToObjectSpace(Unit2),
                    nose = v3:VectorToObjectSpace(Unit)
                }
            end

            local Size = MeshPart.Size
            local t4 = {
                w = 0,
                v = 0,
                model = p3,
                mesh = MeshPart,
                A = t3,
                nose = Unit,
                phase = math.random() * 3.141592653589793 * 2,
                fin = math.random() * 6.28,
                flut = math.random() * 6.28,
                length = math.abs(Unit.X) * Size.X + math.abs(Unit.Y) * Size.Y + math.abs(Unit.Z) * Size.Z
            }
            local t5 = {}
            local t6 = {}

            for v6, v7 in pairs(t3) do
                local v8, v9, v10 = v6:match("^(%a+)_(%d+)_(%d+)$")

                if v8 == "Dorsal" or v8 == "Anal" then
                    local v11 = if v8 == "Dorsal" then 1 else -1

                    t5[#t5 + 1] = {
                        a = v7,
                        sg = v11,
                        s = tonumber(v9),
                        l = tonumber(v10)
                    }
                    t6[v11] = math.max(t6[v11] or 1, (tonumber(v9)))
                end
            end

            local t8 = {}

            for v15, v16 in ipairs(p1.VeilSwim.BARBS) do
                local n1 = 1

                while t3[v16 .. "_" .. n1] do
                    t8[#t8 + 1] = {
                        a = t3[v16 .. "_" .. n1],
                        bi = v15,
                        j = n1
                    }
                    n1 += 1
                end
            end

            if #t5 > 0 or #t8 > 0 or t3.Fin_L2 then
                t4.flow = {
                    sails = t5,
                    nsec = t6,
                    barbs = t8,
                    tips = t3.Fin_L2 and t3.Fin_R2 and true
                }
                t4.sp = 0.4
                t4.lean = 0
                t4.bp = 0
                t4.bpv = 0
                t4.by = 0
                t4.byv = 0
                t4.acc = 0
            end

            t4.bodyAmp = attr(p3, "BodyAmp")
            t4.waddle = attr(p3, "Waddle")

            local LipGulp = attr(p3, "LipGulp")

            t4.lipGulp = if t3.Lip_1 and type(LipGulp) == "number" and LipGulp then LipGulp else nil
            t4.lipT = math.random() * 6.28

            return t4
        end,
        update = function(p4, p5, _) -- update | line: 106
            -- upvalues: p1 (copy), p2 (copy), fightHooked (copy), attr (copy)
            local VeilSwim = p1.VeilSwim
            local model = p4.model
            local StrokeAt = attr(model, "StrokeAt")
            local v17, v18, v19, phase, v20, v21

            if fightHooked(model) then
                p4.phase += p5 * VeilSwim.HOOK_RATE
                v19 = VeilSwim.HOOK_EFFORT
                p4.locked = nil
            elseif StrokeAt then
                v20 = attr(model, "StrokeRate") or 0
                v18 = attr(model, "StrokeCruise") or v20
                v19 = v20 / math.max(v18, 0.001)
                v17 = (attr(model, "StrokePhase") or 0) + v20 * (workspace:GetServerTimeNow() - p2.renderLag() - StrokeAt)

                if p4.locked then
                    p4.phase += p5 * v20
                    v18 = p4.phase
                    phase = (v17 - p4.phase + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
                    v21 = p5 * VeilSwim.LOCK
                    p4.phase = v18 + phase * math.min(1, v21)
                else
                    p4.phase = v17
                    p4.locked = true
                end
            else
                p4.phase += p5 * (attr(model, "StrokeHz") or VeilSwim.PEN_RATE)
                v19 = 1
                p4.locked = nil
            end

            p4.fin += p5 * VeilSwim.FIN_RATE
            p4.flut += p5 * VeilSwim.FLUT_RATE
            v20 = p4.mesh.CFrame
            v17 = v20:VectorToWorldSpace(p4.nose)

            local A, fin = v17.X, v17.Z

            v18 = Vector3.new(A, 0, fin)

            local bone, right

            if p4.lastPos and p4.lastNose and p5 > 1E-04 and (v20.Position - p4.lastPos).Magnitude < 20 and v18.Magnitude > 0.001 then
                A = p4.lastNose
                phase = v18.Unit
                bone = A:Cross(phase).Y
                v21 = A:Dot(phase)
                v17 = math.atan2(bone, v21) / p5
                phase = (v20.Position - p4.lastPos).Magnitude / p5
                fin = p4.w
                v21 = v17 - p4.w
                right = p5 / VeilSwim.W_TAU
                p4.w = fin + v21 * math.min(1, right)
                fin = p4.v
                v21 = phase - p4.v
                right = p5 / VeilSwim.V_TAU
                p4.v = fin + v21 * math.min(1, right)
            end

            p4.lastPos = v20.Position

            if v18.Magnitude > 0.001 then
                p4.lastNose = v18.Unit
            end

            v18 = math.max(v19, 0)

            local v22 = math.clamp(p4.length * p4.w / math.max(p4.v, 5), -0.9, 0.9)

            v19 = math.min(v18, 1) * (math.clamp(v18 - 1, 0, 1) * 0.2 + 1)
            A = p4.A
            phase = p4.phase
            fin = p4.fin

            local fromAxisAngle, v23, v24, bone2, v25, right2

            for v26, v27 in ipairs(VeilSwim.SPINE) do
                v23 = A[v27]

                if v23 then
                    v24 = v23.bone
                    fromAxisAngle = CFrame.fromAxisAngle
                    bone2 = v23.up
                    v25 = VeilSwim.AMP_B * (p4.bodyAmp or 1) * v19 * VeilSwim.SG[v26]
                    right2 = phase - VeilSwim.K * VeilSwim.ST[v26]
                    v24.Transform = fromAxisAngle(bone2, v25 * math.sin(right2))
                end
            end

            local v28, fromAxisAngle2

            for v29, v30 in ipairs(VeilSwim.VEIL) do
                v23 = A[v30]

                if v23 then
                    v24 = v29 - 1
                    v25 = VeilSwim.AMP_T * v19 * VeilSwim.GT[v29]
                    right2 = phase - 0.9 - VeilSwim.K_T * v24
                    v28 = v25 * math.sin(right2)
                    fromAxisAngle2 = VeilSwim.IDLE * (1 - math.min(v19, 1) * 0.5) * VeilSwim.GT[v29]
                    fromAxisAngle = v28 + fromAxisAngle2 * math.sin(fin - VeilSwim.K_T * v24) - VeilSwim.BEND * v22 / 6
                    bone2 = v23.bone
                    v25 = CFrame.fromAxisAngle(v23.up, fromAxisAngle)
                    fromAxisAngle2 = CFrame.fromAxisAngle
                    right2 = v23.right
                    bone2.Transform = v25 * fromAxisAngle2(right2, VeilSwim.BILLOW * math.sin(1.3 * fin - 0.8 * v24))
                end
            end

            v20 = 1 + VeilSwim.HOVER * (1 - math.min(v18, 1))
            A.Fin_L.bone.Transform = CFrame.fromAxisAngle(A.Fin_L.up, VeilSwim.FIN_AMP * v20 * math.sin(p4.flut))
            bone = A.Fin_R.bone
            v21 = CFrame.fromAxisAngle

            local v33 = A.Fin_R.up

            right = -VeilSwim.FIN_AMP * v20
            v24 = p4.flut + 3.141592653589793
            bone.Transform = v21(v33, right * math.sin(v24))

            if p4.waddle then
                v18 = p4.waddle * v20 / (1 + VeilSwim.HOVER)
                bone = A.Spine_01.bone
                v33 = CFrame.fromAxisAngle

                local fromAxisAngle = A.Spine_01.nose

                v24 = p4.flut
                v33 = v33(fromAxisAngle, v18 * math.sin(v24))
                fromAxisAngle = CFrame.fromAxisAngle
                right = A.Spine_01.right
                v24 = 0.35 * v18
                bone2 = 2 * p4.flut + 0.6
                bone.Transform = v33 * fromAxisAngle(right, v24 * math.sin(bone2))
            end

            local lipT, v34

            if p4.lipGulp then
                p4.lipT += p5 * VeilSwim.LIP_RATE * (fightHooked(model) and VeilSwim.LIP_HOOK or 1)
                lipT = A.Lip_1.bone
                v21 = CFrame.fromAxisAngle
                v34 = A.Lip_1.right
                right = -p4.lipGulp
                bone2 = p4.lipT
                lipT.Transform = v21(v34, right * (math.sin(bone2) * 0.5 + 0.5))
            end

            lipT = p4.flow

            if not lipT then
                return
            end

            v21 = fightHooked(model)

            local v35

            if v21 then
                model = 1.3
            elseif StrokeAt then
                right = p4.v
                v24 = VeilSwim.SP_BL * p4.length
                v35 = right / math.max(v24, 1)
                model = math.clamp(v35, 0, 1.3)
            else
                model = 0.4
            end

            p4.sp = p4.sp + (model - p4.sp) * math.min(1, p5 * VeilSwim.SP_EASE)

            if v21 or not StrokeAt then
                model = 0
            else
                v35 = p4.w / VeilSwim.LEAN_REF
                model = math.clamp(v35, -1, 1)
            end

            v34 = p4.lean
            right = model - p4.lean
            fromAxisAngle = p5 * 4
            p4.lean = v34 + right * math.min(1, fromAxisAngle)

            if lipT.tips then
                v34 = A.Fin_L2.bone
                v35 = CFrame.fromAxisAngle
                right = A.Fin_L2.up
                v24 = VeilSwim.FIN_TIP * VeilSwim.FIN_AMP * v20
                bone2 = p4.flut - VeilSwim.FIN_LAG
                v34.Transform = v35(right, v24 * math.sin(bone2))
                v34 = A.Fin_R2.bone
                v35 = CFrame.fromAxisAngle
                right = A.Fin_R2.up
                v24 = -VeilSwim.FIN_TIP * VeilSwim.FIN_AMP * v20
                bone2 = p4.flut + 3.141592653589793 - VeilSwim.FIN_LAG
                v34.Transform = v35(right, v24 * math.sin(bone2))
            end

            v21 = math.min(v19, 1)

            for _, v36 in ipairs(lipT.sails) do
                fromAxisAngle = v36.s - 1
                v28 = lipT.nsec[v36.sg] - 1
                A = fromAxisAngle / math.max(v28, 1)
                v20 = VeilSwim.SAIL_K * A + VeilSwim.SAIL_LAG * (v36.l - 1)
                A = if v36.l == 1 then 1 else VeilSwim.SAIL_TIP
                fromAxisAngle = VeilSwim.SAIL_AMP * v19
                v28 = phase - 0.9 - v20
                StrokeAt = fromAxisAngle * math.sin(v28)
                fromAxisAngle = VeilSwim.SAIL_IDLE * (1 - v21 * 0.5)
                v25 = VeilSwim.SAIL_RATE * fin - v20
                fromAxisAngle2 = if v36.sg == 1 then 0 else 2
                v28 = v25 + fromAxisAngle2
                bone2 = A * (StrokeAt + fromAxisAngle * math.sin(v28) + VeilSwim.LEAN * p4.lean)
                v28 = -VeilSwim.SAIL_MAX
                v25 = VeilSwim.SAIL_MAX
                fromAxisAngle = math.clamp(bone2, v28, v25)

                local v37 = VeilSwim.SAIL_SWEEP * p4.sp

                bone2 = if v36.l == 1 then 1 else 0.5
                A = v37 * bone2
                v36.a.bone.Transform = CFrame.fromAxisAngle(v36.a.right, v36.sg * A) * CFrame.fromAxisAngle(v36.a.nose, v36.sg * fromAxisAngle)
            end

            if not (#lipT.barbs > 0) then
                return
            end

            local v38 = math.min(p5, 0.03333333333333333)

            if p5 > 1E-04 then
                phase = (p4.v - (p4.prevV or p4.v)) / p5
                v34 = p4.acc
                right = phase - p4.acc
                fromAxisAngle = p5 / 0.1
                p4.acc = v34 + right * math.min(1, fromAxisAngle)
            end

            p4.prevV = p4.v
            v34 = math.clamp(VeilSwim.BARB_TRAIL * p4.sp + VeilSwim.BARB_SURGE * p4.acc, -VeilSwim.BARB_MAX, VeilSwim.BARB_MAX)
            v33 = math.clamp(-VeilSwim.BARB_TURN * p4.w, -VeilSwim.BARB_MAX, VeilSwim.BARB_MAX)
            p4.bpv += (VeilSwim.BARB_K * (v34 - p4.bp) - VeilSwim.BARB_C * p4.bpv) * v38
            p4.bp += p4.bpv * v38
            p4.byv += (VeilSwim.BARB_K * (v33 - p4.by) - VeilSwim.BARB_C * p4.byv) * v38
            p4.by += p4.byv * v38

            for _, v39 in ipairs(lipT.barbs) do
                bone2 = VeilSwim.BARB_FRAC
                v25 = v39.j
                v34 = bone2[math.min(v25, 3)]
                bone2 = VeilSwim.BARB_RIP
                v25 = 1.6 * fin - VeilSwim.BARB_K_RIP * v39.j + 1.7 * (v39.bi - 1)
                v38 = bone2 * math.sin(v25)
                bone2 = VeilSwim.BARB_RIP
                v25 = 1.3 * fin - VeilSwim.BARB_K_RIP * v39.j + 2.3 * (v39.bi - 1) + 1
                v19 = bone2 * math.sin(v25)
                v39.a.bone.Transform = CFrame.fromAxisAngle(v39.a.right, -p4.bp * v34 + v38) * CFrame.fromAxisAngle(v39.a.nose, p4.by * v34 + v19)
            end
        end
    }
end
