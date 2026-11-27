-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.LionFan = {
        LOCK = 10,
        W_TAU = 0.15,
        V_TAU = 0.3,
        FIN_RATE = 2.2,
        BODY_AMP = 0.35,
        WAVE_K = 2,
        BEND = 0.6,
        IDLE_SWAY = 0.02,
        SPINE_RIPPLE = 0.1,
        SPINE_LAG = 0.7,
        SPINE_TIP = 0.08,
        SPINE_ERECT = 0.1,
        SPINE_FOLD = 0.35,
        LOBE_AMP = 0.35,
        LOBE_IDLE = 0.1,
        FLARE_REL = 0.15,
        FLARE_HOVER = 0.7,
        FLARE_TUCK = 0.25,
        SCULL = 0.08,
        SPREAD = 0.3,
        RAY_RIPPLE = 0.12,
        BELLY_RIPPLE = 0.1,
        HOOK_RATE = 12,
        HOOK_EFFORT = 1.6,
        PEN_RATE = 3.5,
        BODY_ORDER = { "Spine_01", "Spine_02", "Spine_03", "Spine_04", "Tail_01", "Tail_02", "Tail_03" },
        BODY_GAIN = {
            Spine_01 = 0,
            Spine_02 = 0.04,
            Spine_03 = 0.08,
            Spine_04 = 0.14,
            Tail_01 = 0.25,
            Tail_02 = 0.35,
            Tail_03 = 0.45
        },
        RAY_LAG = {
            A = 0,
            B = 0.5,
            C = 1
        },
        SPREAD_W = {
            A = 1,
            B = 0.5,
            C = 1
        },
        register = function(p3) -- register | line: 36
            -- upvalues: attr (copy)
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
            local v1 = attr(p3, "FanAxis") == "Up"
            local t3 = {}

            for v2, v3 in pairs(t2) do
                local v4 = CFrame:ToObjectSpace(v3.WorldCFrame)
                local v5 = if v2:sub(1, 5) == "Fin_L" then 1 else -1
                local v6 = v1 and (v2 == "Fin_L" or v2 == "Fin_R") and -Unit3 * v5 or Unit * v5

                t3[v2] = {
                    bone = v3,
                    up = v4:VectorToObjectSpace(Unit3),
                    lat = v4:VectorToObjectSpace(Unit2),
                    flare = v4:VectorToObjectSpace(v6)
                }
            end

            local Size = MeshPart.Size

            return {
                phase = 0,
                w = 0,
                v = 0,
                model = p3,
                mesh = MeshPart,
                axes = t3,
                nose = Unit,
                fin = math.random() * 6.28,
                fanScale = attr(p3, "FanScale") or 1,
                length = math.abs(Unit.X) * Size.X + math.abs(Unit.Y) * Size.Y + math.abs(Unit.Z) * Size.Z
            }
        end,
        update = function(p4, p5, _) -- update | line: 70
            -- upvalues: p1 (copy), p2 (copy), fightHooked (copy), attr (copy)
            local LionFan = p1.LionFan
            local model = p4.model
            local StrokeAt = attr(model, "StrokeAt")
            local HOOK_EFFORT = 1

            if fightHooked(model) then
                p4.phase += p5 * LionFan.HOOK_RATE
                HOOK_EFFORT = LionFan.HOOK_EFFORT
                p4.locked = nil
            elseif StrokeAt then
                local v9 = attr(model, "StrokeRate") or 0

                HOOK_EFFORT = v9 / math.max(attr(model, "StrokeCruise") or v9, 0.001)

                local v11 = (attr(model, "StrokePhase") or 0) + v9 * (workspace:GetServerTimeNow() - p2.renderLag() - StrokeAt)

                if p4.locked then
                    p4.phase += p5 * v9
                    p4.phase = p4.phase + ((v11 - p4.phase + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * math.min(1, p5 * LionFan.LOCK)
                else
                    p4.phase = v11
                    p4.locked = true
                end
            else
                p4.phase += p5 * (attr(model, "StrokeHz") or LionFan.PEN_RATE)
                p4.locked = nil
            end

            local v14 = math.max(HOOK_EFFORT, 0)

            p4.fin += p5 * LionFan.FIN_RATE * (math.min(v14, 1.5) * 0.3 + 1)

            local _CFrame = p4.mesh.CFrame
            local v15 = _CFrame:VectorToWorldSpace(p4.nose)
            local v16 = Vector3.new(v15.X, 0, v15.Z)

            if p4.lastPos and p4.lastNose and p5 > 1E-04 and (_CFrame.Position - p4.lastPos).Magnitude < 20 and v16.Magnitude > 0.001 then
                local lastNose = p4.lastNose
                local Unit = v16.Unit
                local v18 = math.atan2(lastNose:Cross(Unit).Y, (lastNose:Dot(Unit))) / p5
                local v19 = (_CFrame.Position - p4.lastPos).Magnitude / p5

                p4.w = p4.w + (v18 - p4.w) * math.min(1, p5 / LionFan.W_TAU)
                p4.v = p4.v + (v19 - p4.v) * math.min(1, p5 / LionFan.V_TAU)
            end

            p4.lastPos = _CFrame.Position

            if v16.Magnitude > 0.001 then
                p4.lastNose = v16.Unit
            end

            local v26 = math.clamp(p4.length * p4.w / math.max(p4.v, 5), -0.9, 0.9)
            local v29 = (math.min(v14, 1) * 0.85 + 0.15) * (math.max(0, v14 - 1) * 0.6 + 1)
            local v30 = 1 - math.min(v14, 1)
            local v33 = math.min(math.max(0, v14 - 1), 1)
            local phase, fin, axes = p4.phase, p4.fin, p4.axes

            local function set(p7, p8, p9) -- line: 117
                -- upvalues: axes (copy)
                local v34 = axes[p7]

                if v34 then
                    v34.bone.Transform = CFrame.fromAxisAngle(v34[p8], p9)
                end
            end

            for v35, v36 in ipairs(LionFan.BODY_ORDER) do
                local v37 = (v35 - 1) / 6
                local v43 = LionFan.BODY_AMP * v29 * LionFan.BODY_GAIN[v36] * math.sin(phase - v37 * LionFan.WAVE_K) + LionFan.IDLE_SWAY * v37 * math.sin(0.5 * fin - v37)

                if v35 >= 3 then
                    v43 += -LionFan.BEND * v26 / 5
                end

                local v44 = axes[v36]

                if v44 then
                    v44.bone.Transform = CFrame.fromAxisAngle(v44.up, v43)
                end
            end

            local v45 = LionFan.SPINE_FOLD * v33 - LionFan.SPINE_ERECT * v30

            for i = 1, 5 do
                local v46 = "DSpine_" .. i .. "_1"
                local v48 = v45 + LionFan.SPINE_RIPPLE * math.sin(fin - LionFan.SPINE_LAG * i)
                local v49 = axes[v46]

                if v49 then
                    v49.bone.Transform = CFrame.fromAxisAngle(v49.lat, v48)
                end

                local v50 = "DSpine_" .. i .. "_2"
                local v52 = LionFan.SPINE_TIP * math.sin(fin - LionFan.SPINE_LAG * i - 0.6)
                local v53 = axes[v50]

                if v53 then
                    v53.bone.Transform = CFrame.fromAxisAngle(v53.lat, v52)
                end
            end

            local v58 = LionFan.LOBE_AMP * v29 * math.sin(phase - 1.2) + LionFan.LOBE_IDLE * math.sin(fin - 1.2)
            local Rear_U = axes.Rear_U

            if Rear_U then
                Rear_U.bone.Transform = CFrame.fromAxisAngle(Rear_U.up, v58)
            end

            local v63 = LionFan.LOBE_AMP * v29 * math.sin(phase - 1.6) + LionFan.LOBE_IDLE * math.sin(fin - 1.6)
            local Rear_L = axes.Rear_L

            if Rear_L then
                Rear_L.bone.Transform = CFrame.fromAxisAngle(Rear_L.up, v63)
            end

            local v64 = LionFan.FLARE_REL + LionFan.FLARE_HOVER * v30 - LionFan.FLARE_TUCK * v33

            for _, v65 in ipairs({ "L", "R" }) do
                local v66 = "Fin_" .. v65
                local v67 = (v64 + LionFan.SCULL * math.sin(fin)) * p4.fanScale
                local v68 = axes[v66]

                if v68 then
                    v68.bone.Transform = CFrame.fromAxisAngle(v68.flare, v67)
                end

                for v69, v70 in pairs(LionFan.RAY_LAG) do
                    local v71 = "Fin_" .. v65 .. "_" .. v69 .. "1"
                    local v72 = LionFan.SPREAD * v30 * LionFan.SPREAD_W[v69]
                    local v73 = axes[v71]

                    if v73 then
                        v73.bone.Transform = CFrame.fromAxisAngle(v73.lat, v72)
                    end

                    local v74 = "Fin_" .. v65 .. "_" .. v69 .. "2"
                    local v76 = LionFan.RAY_RIPPLE * math.sin(fin - v70 - 0.8)
                    local v77 = axes[v74]

                    if v77 then
                        v77.bone.Transform = CFrame.fromAxisAngle(v77.flare, v76)
                    end
                end
            end

            local v79 = LionFan.BELLY_RIPPLE * math.sin(1.2 * fin)
            local Pelvic_1 = axes.Pelvic_1

            if Pelvic_1 then
                Pelvic_1.bone.Transform = CFrame.fromAxisAngle(Pelvic_1.lat, v79)
            end

            local v81 = LionFan.BELLY_RIPPLE * math.sin(1.2 * fin - 0.7)
            local Pelvic_2 = axes.Pelvic_2

            if Pelvic_2 then
                Pelvic_2.bone.Transform = CFrame.fromAxisAngle(Pelvic_2.lat, v81)
            end

            local v84 = LionFan.LOBE_AMP * 0.5 * v29 * math.sin(phase - 1.4)
            local Anal_1 = axes.Anal_1

            if Anal_1 then
                Anal_1.bone.Transform = CFrame.fromAxisAngle(Anal_1.up, v84)
            end
        end
    }
end
