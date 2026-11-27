-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.ClownSwim = {
        LOCK = 10,
        W_TAU = 0.15,
        V_TAU = 0.3,
        FIN_RATE = 1,
        ROW = 0.55,
        FEATHER = 0.5,
        HOVER_ROW = 0.6,
        HOVER_RATE = 3,
        WADDLE = 0.4,
        K_W = 1.2,
        ROLL = 0.08,
        BEND = 0.5,
        TAIL_BURST = 0.35,
        HOOK_RATE = 16,
        HOOK_EFFORT = 1.8,
        PEN_RATE = 6,
        BODY = { "Spine_02", "Spine_03", "Spine_04", "Tail_01", "Tail_02", "Tail_03" },
        G = { 0.08, 0.1, 0.12, 0.15, 0.2, 0.25 },
        T = { 0.15, 0.3, 0.45, 0.6, 0.8, 1 },
        register = function(p3) -- register | line: 24
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

            if not (t2.Spine_01 and t2.Spine_04 and t2.Tail_03 and t2.Fin_L and t2.Fin_R) then
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
                    nose = v3:VectorToObjectSpace(Unit),
                    outL = v3:VectorToObjectSpace(-Unit2),
                    outR = v3:VectorToObjectSpace(Unit2)
                }
            end

            local Size = MeshPart.Size

            return {
                w = 0,
                v = 0,
                model = p3,
                mesh = MeshPart,
                A = t3,
                nose = Unit,
                phase = math.random() * 3.141592653589793 * 2,
                fin = math.random() * 6.28,
                length = math.abs(Unit.X) * Size.X + math.abs(Unit.Y) * Size.Y + math.abs(Unit.Z) * Size.Z
            }
        end,
        update = function(p4, p5, _) -- update | line: 48
            -- upvalues: p1 (copy), p2 (copy), fightHooked (copy), attr (copy)
            local ClownSwim = p1.ClownSwim
            local model = p4.model
            local StrokeAt = attr(model, "StrokeAt")
            local HOOK_EFFORT = 1

            if fightHooked(model) then
                p4.phase += p5 * ClownSwim.HOOK_RATE
                HOOK_EFFORT = ClownSwim.HOOK_EFFORT
                p4.locked = nil
            elseif StrokeAt then
                local v6 = attr(model, "StrokeRate") or 0

                HOOK_EFFORT = v6 / math.max(attr(model, "StrokeCruise") or v6, 0.001)

                local v8 = (attr(model, "StrokePhase") or 0) + v6 * (workspace:GetServerTimeNow() - p2.renderLag() - StrokeAt)

                if p4.locked then
                    p4.phase += p5 * v6
                    p4.phase = p4.phase + ((v8 - p4.phase + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * math.min(1, p5 * ClownSwim.LOCK)
                else
                    p4.phase = v8
                    p4.locked = true
                end
            else
                p4.phase += p5 * (attr(model, "StrokeHz") or ClownSwim.PEN_RATE)
                p4.locked = nil
            end

            p4.fin += p5 * ClownSwim.FIN_RATE

            local _CFrame = p4.mesh.CFrame
            local v11 = _CFrame:VectorToWorldSpace(p4.nose)
            local v12 = Vector3.new(v11.X, 0, v11.Z)

            if p4.lastPos and p4.lastNose and p5 > 1E-04 and (_CFrame.Position - p4.lastPos).Magnitude < 20 and v12.Magnitude > 0.001 then
                local lastNose = p4.lastNose
                local Unit = v12.Unit
                local v14 = math.atan2(lastNose:Cross(Unit).Y, (lastNose:Dot(Unit))) / p5
                local v15 = (_CFrame.Position - p4.lastPos).Magnitude / p5

                p4.w = p4.w + (v14 - p4.w) * math.min(1, p5 / ClownSwim.W_TAU)
                p4.v = p4.v + (v15 - p4.v) * math.min(1, p5 / ClownSwim.V_TAU)
            end

            p4.lastPos = _CFrame.Position

            if v12.Magnitude > 0.001 then
                p4.lastNose = v12.Unit
            end

            local v20 = math.max(HOOK_EFFORT, 0)
            local v23 = math.clamp(p4.length * p4.w / math.max(p4.v, 5), -0.9, 0.9)
            local v26 = math.min(v20, 1) * (math.clamp(v20 - 1, 0, 1) * 0.3 + 1)
            local v27 = 1 - math.min(v20, 1)
            local v29 = math.clamp(v20 - 1, 0, 1)
            local A, phase, fin = p4.A, p4.phase, p4.fin
            local v33 = v26 * math.sin(phase) + v27 * ClownSwim.HOVER_ROW * math.sin(ClownSwim.HOVER_RATE * fin)
            local v37 = v26 * math.cos(phase) + v27 * ClownSwim.HOVER_ROW * math.cos(ClownSwim.HOVER_RATE * fin)

            A.Fin_L.bone.Transform = CFrame.fromAxisAngle(A.Fin_L.up, ClownSwim.ROW * v33) * CFrame.fromAxisAngle(A.Fin_L.outL, ClownSwim.FEATHER * v37)
            A.Fin_R.bone.Transform = CFrame.fromAxisAngle(A.Fin_R.up, -ClownSwim.ROW * v33) * CFrame.fromAxisAngle(A.Fin_R.outR, -ClownSwim.FEATHER * v37)

            for v38, v39 in ipairs(ClownSwim.BODY) do
                local v40 = A[v39]

                if v40 then
                    local v46 = ClownSwim.WADDLE * v26 * ClownSwim.G[v38] * math.sin(phase - ClownSwim.K_W * ClownSwim.T[v38]) + ClownSwim.TAIL_BURST * v29 * ClownSwim.T[v38] ^ 2 * math.sin(phase - 2.6 * ClownSwim.T[v38])

                    if v38 >= 2 then
                        v46 += -ClownSwim.BEND * v23 / 5
                    end

                    v40.bone.Transform = CFrame.fromAxisAngle(v40.up, v46)
                end
            end

            A.Spine_01.bone.Transform = CFrame.fromAxisAngle(A.Spine_01.nose, ClownSwim.ROLL * v26 * math.sin(phase + 0.6))
        end
    }
end
