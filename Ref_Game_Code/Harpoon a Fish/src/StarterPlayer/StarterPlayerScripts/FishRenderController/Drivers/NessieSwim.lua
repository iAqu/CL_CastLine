-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.NessieSwim = {
        LOCK = 10,
        W_TAU = 0.2,
        V_TAU = 0.3,
        TURN_REF = 0.6,
        FIN_RATE = 1,
        FLAP = 0.45,
        HIND = 0.8,
        HIND_LAG = 0.8,
        TIP = 0.25,
        TIP_LAG = 0.8,
        FEATHER = 0.35,
        SWEEP = 0.35,
        TURN_GAIN = 0.35,
        TAIL = { "Tail_1", "Tail_2", "Tail_3", "Tail_4" },
        TAIL_G = { 0.3, 0.5, 0.8, 1 },
        TAIL_SWAY = 0.1,
        BEND = 0.5,
        LOOK = 0.45,
        LOOK_HEAD = 0.15,
        NOD = 0.04,
        FRONDS = { "Frond_N3", "Frond_N2", "Frond_N1", "Frond_B1", "Frond_B2", "Frond_T1", "Frond_T" },
        FROND_SWEEP = 0.35,
        FROND_FLUTTER = 0.12,
        FROND_RATE = 2.2,
        FROND_TURN = 0.25,
        HOOK_RATE = 7,
        HOOK_EFFORT = 1.6,
        PEN_RATE = 2.5,
        PEN_SPEED = 0.5,
        PASS_STRIDE = 1.3,
        PASS_MIN_HZ = 0.2,
        register = function(p3) -- register | line: 32
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

            if not (t2.Body_1 and t2.Body_2 and t2.Head and t2.Flip_FL and t2.Frond_T) then
                return nil
            end

            local CFrame = MeshPart.CFrame
            local v1 = CFrame:VectorToObjectSpace(t2.Body_1.WorldPosition - t2.Body_2.WorldPosition)
            local Unit = Vector3.new(v1.X, 0, v1.Z).Unit
            local Unit2 = Unit:Cross((Vector3.new(0, 1, 0))).Unit
            local t3 = {}

            for v2, v3 in pairs(t2) do
                local v4 = CFrame:ToObjectSpace(v3.WorldCFrame)

                t3[v2] = {
                    bone = v3,
                    up = v4:VectorToObjectSpace((Vector3.new(0, 1, 0))),
                    right = v4:VectorToObjectSpace(Unit2),
                    nose = v4:VectorToObjectSpace(Unit),
                    outL = v4:VectorToObjectSpace(-Unit2),
                    outR = v4:VectorToObjectSpace(Unit2)
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
        update = function(p4, p5, _) -- update | line: 60
            -- upvalues: p1 (copy), p2 (copy), fightHooked (copy), attr (copy)
            local NessieSwim = p1.NessieSwim
            local model = p4.model
            local StrokeAt = attr(model, "StrokeAt")
            local HOOK_EFFORT, PassCruise

            if fightHooked(model) then
                p4.phase += p5 * NessieSwim.HOOK_RATE
                HOOK_EFFORT = NessieSwim.HOOK_EFFORT
                p4.locked = nil
            elseif not StrokeAt and attr(model, "PassCruise") then
                PassCruise = attr(model, "PassCruise")
                p4.phase = p4.phase + p5 * 2 * 3.141592653589793 * math.max(p4.v / (NessieSwim.PASS_STRIDE * math.max(p4.length, 0.001)), NessieSwim.PASS_MIN_HZ)
                HOOK_EFFORT = p4.v / math.max(PassCruise, 0.001)
                p4.locked = nil
            elseif StrokeAt then
                local v9 = attr(model, "StrokeRate") or 0
                local v10 = attr(model, "StrokeCruise") or v9

                HOOK_EFFORT = v9 / math.max(v10, 0.001)
                PassCruise = v10 * (attr(model, "StrokeStride") or 0)

                local v11 = (attr(model, "StrokePhase") or 0) + v9 * (workspace:GetServerTimeNow() - p2.renderLag() - StrokeAt)

                if p4.locked then
                    p4.phase += p5 * v9
                    p4.phase = p4.phase + ((v11 - p4.phase + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * math.min(1, p5 * NessieSwim.LOCK)
                else
                    p4.phase = v11
                    p4.locked = true
                end
            else
                p4.phase += p5 * (attr(model, "StrokeHz") or NessieSwim.PEN_RATE)
                HOOK_EFFORT = 1
                p4.locked = nil
            end

            p4.fin += p5 * NessieSwim.FIN_RATE

            local _CFrame = p4.mesh.CFrame
            local v14 = _CFrame:VectorToWorldSpace(p4.nose)
            local v15 = Vector3.new(v14.X, 0, v14.Z)

            if p4.lastPos and p4.lastNose and p5 > 1E-04 and (_CFrame.Position - p4.lastPos).Magnitude < 20 and v15.Magnitude > 0.001 then
                local lastNose = p4.lastNose
                local Unit = v15.Unit
                local v17 = math.atan2(lastNose:Cross(Unit).Y, (lastNose:Dot(Unit))) / p5
                local v18 = (_CFrame.Position - p4.lastPos).Magnitude / p5

                p4.w = p4.w + (v17 - p4.w) * math.min(1, p5 / NessieSwim.W_TAU)
                p4.v = p4.v + (v18 - p4.v) * math.min(1, p5 / NessieSwim.V_TAU)
            end

            p4.lastPos = _CFrame.Position

            if v15.Magnitude > 0.001 then
                p4.lastNose = v15.Unit
            end

            local v23 = math.max(HOOK_EFFORT, 0)
            local v25 = math.clamp(p4.w / NessieSwim.TURN_REF, -1, 1)
            local v28 = math.clamp(p4.length * p4.w / math.max(p4.v, 5), -0.9, 0.9)
            local v29 = PassCruise and p4.v / math.max(PassCruise, 1) or NessieSwim.PEN_SPEED
            local v32 = math.min(v23, 1) * (math.clamp(v23 - 1, 0, 1) * 0.3 + 1)
            local v33 = 1 - math.min(v23, 1)
            local A, phase, fin = p4.A, p4.phase, p4.fin

            for _, v34 in ipairs({
                    { "F", 0, 1 },
                    {
                        "B",
                        NessieSwim.HIND_LAG,
                        NessieSwim.HIND
                    }
                }) do
                local v35 = phase - v34[2]

                for _, v36 in ipairs({
                        { "L", 1 },
                        { "R", -1 }
                    }) do
                    local v37 = v36[2]
                    local v38 = NessieSwim.FLAP * v34[3] * v32 * (1 - v37 * NessieSwim.TURN_GAIN * v25)
                    local v39 = A["Flip_" .. v34[1] .. v36[1]]
                    local v40 = A["Flip_" .. v34[1] .. v36[1] .. "_Tip"]

                    if v39 then
                        v39.bone.Transform = CFrame.fromAxisAngle(v39.nose, v37 * v38 * math.sin(v35)) * CFrame.fromAxisAngle(v37 == 1 and v39.outL or v39.outR, v37 * NessieSwim.FEATHER * v32 * math.cos(v35)) * CFrame.fromAxisAngle(v39.up, v37 * NessieSwim.SWEEP * v33)
                    end

                    if v40 then
                        v40.bone.Transform = CFrame.fromAxisAngle(v40.nose, v37 * NessieSwim.TIP * v34[3] * v32 * math.sin(v35 - NessieSwim.TIP_LAG))
                    end
                end
            end

            for v43, v44 in ipairs(NessieSwim.TAIL) do
                local v45 = A[v44]

                if v45 then
                    v45.bone.Transform = CFrame.fromAxisAngle(v45.up, NessieSwim.TAIL_SWAY * NessieSwim.TAIL_G[v43] * math.sin(fin - 0.9 * (v43 - 1)) - NessieSwim.BEND * v28 / 4)
                end
            end

            for _, v48 in ipairs({ "Neck_1", "Neck_2", "Neck_3" }) do
                local v49 = A[v48]

                if v49 then
                    local v50 = CFrame.fromAxisAngle(v49.up, NessieSwim.LOOK * v28 / 3)

                    if v48 == "Neck_1" then
                        v50 *= CFrame.fromAxisAngle(v49.right, NessieSwim.NOD * v32 * math.sin(phase - 1.2))
                    end

                    v49.bone.Transform = v50
                end
            end

            A.Head.bone.Transform = CFrame.fromAxisAngle(A.Head.up, NessieSwim.LOOK_HEAD * v28)

            local v53 = math.clamp(v29, 0, 1.5)

            for v54, v55 in ipairs(NessieSwim.FRONDS) do
                local v56 = A[v55]

                if v56 then
                    v56.bone.Transform = CFrame.fromAxisAngle(v56.right, NessieSwim.FROND_SWEEP * v53 + NessieSwim.FROND_FLUTTER * (math.min(v53, 1) * 0.7 + 0.3) * math.sin(fin * NessieSwim.FROND_RATE - 0.9 * (v54 - 1))) * CFrame.fromAxisAngle(v56.up, -NessieSwim.FROND_TURN * v25)
                end
            end
        end
    }
end
