-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, SwimScale, attr = p2.fightHooked, p2.SwimScale, p2.attr

    p1.RayFlap = {
        LOCK = 10,
        W_TAU = 0.15,
        V_TAU = 0.3,
        TURN_REF = 0.8,
        HUB_AMP = 0.32,
        SPAN_LAG = 0.35,
        GLIDE_DIHEDRAL = 0.18,
        TURN_ASYM = 0.35,
        TAIL_V = 0.12,
        TAIL_LAG = 0.5,
        TAIL_DELAY = 1.5,
        TAIL_BEND = 0.7,
        HEAD_NOD = 0.03,
        HOOK_RATE = 9,
        HOOK_EFFORT = 1.4,
        PEN_RATE = 3.5,
        PASS_RATE = 3.2,
        SCHOOL_BL = 1.2,
        LOBE_SWAY = 0.14,
        LOBE_LAG = 0.7,
        LOBE_CURL = 0.1,
        LOBE_HZ = 0.35,
        LOBE_OFF = 1.3,
        SEG_AMP = { 0.12, 0.15, 0.17, 0.17 },
        CHORD_LAG = {
            A = 0,
            B = 0.45,
            C = 0.9
        },
        register = function(p3) -- register | line: 45
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

            local Spine_01, Spine_04, Fin_L, Fin_R = t2.Spine_01, t2.Spine_04, t2.Fin_L, t2.Fin_R

            if not (Spine_01 and Spine_04 and Fin_L and Fin_R) then
                return nil
            end

            local CFrame = MeshPart.CFrame
            local Unit = CFrame:VectorToObjectSpace(Spine_01.WorldPosition - Spine_04.WorldPosition).Unit
            local Unit2 = CFrame:VectorToObjectSpace(Fin_R.WorldPosition - Fin_L.WorldPosition).Unit
            local Unit3 = Unit2:Cross(Unit).Unit
            local t3 = {}

            for v1, v2 in pairs(t2) do
                local v3 = CFrame:ToObjectSpace(v2.WorldCFrame)
                local v4, v5, v6 = v1:match("^Wing_([LR])_([ABC])(%d)$")

                if v1 == "Fin_L" or v1 == "Fin_R" then
                    local v7 = CFrame:PointToObjectSpace(v2.WorldPosition)
                    local v8 = Vector3.new(0, 0, 0)
                    local n1 = 0

                    for _, child in ipairs(v2:GetChildren()) do
                        if child:IsA("Bone") then
                            v8 += CFrame:PointToObjectSpace(child.WorldPosition)
                            n1 += 1
                        end
                    end

                    local v9 = n1 > 0 and v8 / n1 - v7 or v7 - CFrame:PointToObjectSpace(v2.Parent.WorldPosition)
                    local v10 = v9 - Unit3 * v9:Dot(Unit3)

                    t3[#t3 + 1] = {
                        kind = "wing",
                        bone = v2,
                        side = v4 or v1:sub(-1),
                        ray = v5,
                        s = tonumber(v6) or 0,
                        axis = v3:VectorToObjectSpace(v10.Unit:Cross(Unit3))
                    }
                elseif v4 then
                    local v12 = CFrame:PointToObjectSpace(v2.WorldPosition)
                    local v13 = Vector3.new(0, 0, 0)
                    local n2 = 0

                    for _, child in ipairs(v2:GetChildren()) do
                        if child:IsA("Bone") then
                            v13 += CFrame:PointToObjectSpace(child.WorldPosition)
                            n2 += 1
                        end
                    end

                    local v14 = n2 > 0 and v13 / n2 - v12 or v12 - CFrame:PointToObjectSpace(v2.Parent.WorldPosition)
                    local v15 = v14 - Unit3 * v14:Dot(Unit3)

                    t3[#t3 + 1] = {
                        kind = "wing",
                        bone = v2,
                        side = v4,
                        ray = v5,
                        s = tonumber(v6) or 0,
                        axis = v3:VectorToObjectSpace(v15.Unit:Cross(Unit3))
                    }
                elseif v1 == "Lobe_L" or v1 == "Lobe_R" then
                    t3[#t3 + 1] = {
                        kind = "lobe",
                        bone = v2,
                        sgn = v1 == "Lobe_L" and 1 or -1,
                        off = if v1 == "Lobe_L" then 0 else p1.RayFlap.LOBE_OFF,
                        nose = v3:VectorToObjectSpace(Unit),
                        lat = v3:VectorToObjectSpace(Unit2)
                    }
                elseif v1:match("^Tail_0%d$") then
                    t3[#t3 + 1] = {
                        kind = "tail",
                        bone = v2,
                        i = tonumber(v1:sub(-1)),
                        lat = v3:VectorToObjectSpace(Unit2),
                        up = v3:VectorToObjectSpace(Unit3)
                    }
                elseif v1 == "Spine_01" then
                    t3[#t3 + 1] = {
                        kind = "head",
                        bone = v2,
                        lat = v3:VectorToObjectSpace(Unit2)
                    }
                end
            end

            local Size = MeshPart.Size

            return {
                phase = 0,
                w = 0,
                v = 0,
                model = p3,
                mesh = MeshPart,
                segs = t3,
                nose = Unit,
                lift = typeof(attr(p3, "WingLift")) == "number" and attr(p3, "WingLift") or 0,
                lobeClock = math.random() * 10,
                length = math.abs(Unit.X) * Size.X + math.abs(Unit.Y) * Size.Y + math.abs(Unit.Z) * Size.Z
            }
        end,
        update = function(p4, p5, _) -- update | line: 101
            -- upvalues: p1 (copy), p2 (copy), fightHooked (copy), SwimScale (copy), attr (copy)
            local RayFlap = p1.RayFlap
            local model = p4.model
            local StrokeAt = attr(model, "StrokeAt")
            local HOOK_EFFORT

            if fightHooked(model) then
                p4.phase += p5 * RayFlap.HOOK_RATE
                HOOK_EFFORT = RayFlap.HOOK_EFFORT
                p4.locked = nil
            elseif attr(model, "PassCruise") then
                local PassGlide = attr(model, "PassGlide")

                HOOK_EFFORT = if PassGlide then 0 else p4.v / math.max(attr(model, "PassCruise"), 0.001)
                p4.phase = p4.phase + p5 * RayFlap.PASS_RATE * SwimScale.beat(attr(model, "Size")) * (if PassGlide then 0 else math.max(HOOK_EFFORT, 0.3))
                p4.locked = nil
            elseif attr(model, "School") then
                HOOK_EFFORT = p4.v / math.max(RayFlap.SCHOOL_BL * p4.length, 0.001)
                p4.phase += p5 * RayFlap.PASS_RATE * SwimScale.beat(attr(model, "Size")) * math.max(HOOK_EFFORT, 0.3)
                p4.locked = nil
            elseif StrokeAt then
                local v21 = attr(model, "StrokeRate") or 0

                HOOK_EFFORT = v21 / math.max(attr(model, "StrokeCruise") or v21, 0.001)

                local v23 = (attr(model, "StrokePhase") or 0) + v21 * (workspace:GetServerTimeNow() - p2.renderLag() - StrokeAt)

                if p4.locked then
                    p4.phase += p5 * v21
                    p4.phase = p4.phase + ((v23 - p4.phase + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * math.min(1, p5 * RayFlap.LOCK)
                else
                    p4.phase = v23
                    p4.locked = true
                end
            else
                p4.phase += p5 * (attr(model, "StrokeHz") or RayFlap.PEN_RATE)
                HOOK_EFFORT = 1
                p4.locked = nil
            end

            local _CFrame = p4.mesh.CFrame
            local v26 = _CFrame:VectorToWorldSpace(p4.nose)
            local v27 = Vector3.new(v26.X, 0, v26.Z)

            if p4.lastPos and p4.lastNose and p5 > 1E-04 and (_CFrame.Position - p4.lastPos).Magnitude < 20 and v27.Magnitude > 0.001 then
                local lastNose = p4.lastNose
                local Unit = v27.Unit
                local v29 = math.atan2(lastNose:Cross(Unit).Y, (lastNose:Dot(Unit))) / p5
                local v30 = (_CFrame.Position - p4.lastPos).Magnitude / p5

                p4.w = p4.w + (v29 - p4.w) * math.min(1, p5 / RayFlap.W_TAU)
                p4.v = p4.v + (v30 - p4.v) * math.min(1, p5 / RayFlap.V_TAU)
            end

            p4.lastPos = _CFrame.Position

            if v27.Magnitude > 0.001 then
                p4.lastNose = v27.Unit
            end

            local v36 = math.clamp(p4.w / RayFlap.TURN_REF, -1, 1)
            local v39 = math.clamp(p4.length * p4.w / math.max(p4.v, 5), -0.9, 0.9)
            local v40 = math.max(HOOK_EFFORT, 0)
            local v43 = (math.min(v40, 1) * 0.75 + 0.25) * (math.max(0, v40 - 1) * 0.25 + 1)
            local v44 = RayFlap.GLIDE_DIHEDRAL * (1 - math.clamp(v40, 0, 1))
            local phase = p4.phase

            p4.lobeClock += p5

            for _, v45 in ipairs(p4.segs) do
                if v45.kind == "wing" then
                    local v46 = v43 * (1 + RayFlap.TURN_ASYM * v36 * (if v45.side == "L" then -1 else 1))
                    local v47 = if v45.s == 0 then v46 * RayFlap.HUB_AMP * math.sin(phase) + v44 + p4.lift else v46 * RayFlap.SEG_AMP[v45.s] * math.sin(phase - v45.s * RayFlap.SPAN_LAG - RayFlap.CHORD_LAG[v45.ray])

                    v45.bone.Transform = CFrame.fromAxisAngle(v45.axis, v47)
                elseif v45.kind == "tail" then
                    local v52 = v43 * RayFlap.TAIL_V * (v45.i / 6) * math.sin(phase - RayFlap.TAIL_DELAY - RayFlap.TAIL_LAG * (v45.i - 1))
                    local v53 = -RayFlap.TAIL_BEND * v39 / 6

                    v45.bone.Transform = CFrame.fromAxisAngle(v45.up, v53) * CFrame.fromAxisAngle(v45.lat, v52)
                elseif v45.kind == "lobe" then
                    v45.bone.Transform = CFrame.fromAxisAngle(v45.nose, v45.sgn * v43 * RayFlap.LOBE_SWAY * math.sin(phase - RayFlap.LOBE_LAG)) * CFrame.fromAxisAngle(v45.lat, RayFlap.LOBE_CURL * math.sin(6.283185307179586 * RayFlap.LOBE_HZ * p4.lobeClock + v45.off))
                else
                    v45.bone.Transform = CFrame.fromAxisAngle(v45.lat, v43 * RayFlap.HEAD_NOD * math.sin(phase + 0.8))
                end
            end
        end
    }
end
