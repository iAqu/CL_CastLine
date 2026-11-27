-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.MarlinSwim = {
        LOCK = 10,
        W_TAU = 0.15,
        V_TAU = 0.3,
        FIN_RATE = 1.6,
        SWAY_RATE = 7,
        K = 2.6,
        AMP = 0.3,
        BEND = 0.5,
        SAIL_FOLD = 1.3,
        FLUTTER = 0.05,
        TURN_REF = 0.8,
        FOLD_EASE = 4,
        PASS_STRIDE = 0.9,
        PASS_MIN_HZ = 0.5,
        HOOK_RATE = 14,
        HOOK_EFFORT = 1.6,
        HOOK_AMP = 1.8,
        PEN_RATE = 5,
        PEN_EFFORT = 0.6,
        SLASH_T = 0.35,
        SLASH_AMP = 0.5,
        BODY = { "Spine_01", "Spine_02", "Spine_03", "Spine_04", "Tail_01", "Tail_02", "Tail_03" },
        T = { 0, 0.08, 0.16, 0.24, 0.36, 0.55, 1 },
        G = { 0, 0.03, 0.06, 0.12, 0.3, 0.6, 1 },
        FIN_DIR = { 0.334, 0.669, 0.664 },
        FIN_FLAT = { 0.1, 0.3, 1 },
        SLASH_G = { 1, -0.5, -0.3, -0.2, 0, 0, 0 },
        register = function(p3) -- register | line: 52
            -- upvalues: p1 (copy), attr (copy)
            local MarlinSwim = p1.MarlinSwim
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

            if not (t2.Spine_01 and t2.Spine_04 and t2.Fin_L and t2.Fin_R) then
                return nil
            end

            local CFrame = MeshPart.CFrame
            local Unit = CFrame:VectorToObjectSpace(t2.Spine_01.WorldPosition - t2.Spine_04.WorldPosition).Unit
            local Unit2 = CFrame:VectorToObjectSpace(t2.Fin_R.WorldPosition - t2.Fin_L.WorldPosition).Unit
            local Unit3 = Unit2:Cross(Unit).Unit
            local FinDir = attr(p3, "FinDir")
            local v1 = typeof(FinDir) == "Vector3" and {
                FinDir.X,
                FinDir.Y,
                FinDir.Z
            } or MarlinSwim.FIN_DIR
            local FIN_FLAT = MarlinSwim.FIN_FLAT
            local v4 = math.sqrt(FIN_FLAT[1] * FIN_FLAT[1] + FIN_FLAT[2] * FIN_FLAT[2] + FIN_FLAT[3] * FIN_FLAT[3])
            local t3 = {
                FIN_FLAT[1] / v4,
                FIN_FLAT[2] / v4,
                FIN_FLAT[3] / v4
            }
            local v5 = v1[2] * t3[3] - v1[3] * t3[2]
            local v6 = v1[3] * t3[1] - v1[1] * t3[3]
            local v7 = v1[1] * t3[2] - v1[2] * t3[1]
            local v9 = math.sqrt(v5 * v5 + v6 * v6 + v7 * v7)
            local v10 = v5 / v9
            local v11 = v6 / v9
            local v12 = v7 / v9
            local v15 = math.acos((math.clamp(v1[1] * t3[1] + v1[2] * t3[2] + v1[3] * t3[3], -1, 1)))

            local function fishvec(p4, p5, p6, p7) -- line: 75
                -- upvalues: Unit (copy), Unit2 (copy), Unit3 (copy)
                return -Unit2 * p7 * p4 + -Unit3 * p5 + -Unit * p6
            end

            local function local_(p8, p9) -- line: 78
                -- upvalues: CFrame (copy)
                return CFrame:ToObjectSpace(p8.WorldCFrame):VectorToObjectSpace(p9)
            end

            local t4 = {}

            for v16, v17 in ipairs(MarlinSwim.BODY) do
                local v18 = t2[v17]

                if not v18 then
                    return nil
                end

                t4[v16] = {
                    bone = v18,
                    up = CFrame:ToObjectSpace(v18.WorldCFrame):VectorToObjectSpace(Unit3)
                }
            end

            local t5 = {}

            for i = 1, 4 do
                local v19 = t2["Dorsal_" .. i]

                if v19 then
                    t5[#t5 + 1] = {
                        bone = v19,
                        lat = CFrame:ToObjectSpace(v19.WorldCFrame):VectorToObjectSpace(Unit2),
                        nose = CFrame:ToObjectSpace(v19.WorldCFrame):VectorToObjectSpace(Unit)
                    }
                end
            end

            local t6 = {}

            for _, v20 in ipairs({
                    { "Fin_L", 1 },
                    { "Fin_R", -1 }
                }) do
                local v21 = t2[v20[1]]
                local v22 = #t6 + 1
                local t7 = {
                    bone = v21
                }
                local v23 = v20[2]
                local v24 = (-Unit2 * v23 * v10 + -Unit3 * v11 + -Unit * v12) * v20[2]

                t7.axis = CFrame:ToObjectSpace(v21.WorldCFrame):VectorToObjectSpace(v24)
                t7.up = CFrame:ToObjectSpace(v21.WorldCFrame):VectorToObjectSpace(Unit3)
                t6[v22] = t7
            end

            local Size = MeshPart.Size
            local SailFold = attr(p3, "SailFold")

            return {
                w = 0,
                v = 0,
                sf = 0.45,
                pf = 0,
                model = p3,
                mesh = MeshPart,
                body = t4,
                sail = t5,
                fins = t6,
                finAngle = v15,
                nose = Unit,
                sailFold = if type(SailFold) ~= "number" or not SailFold then nil else SailFold,
                finSwayA = type(attr(p3, "FinSway")) == "number" and attr(p3, "FinSway") or nil,
                swayT = math.random() * 6.28,
                phase = math.random() * 3.141592653589793 * 2,
                fin = math.random() * 6.28,
                length = math.abs(Unit.X) * Size.X + math.abs(Unit.Y) * Size.Y + math.abs(Unit.Z) * Size.Z
            }
        end,
        update = function(p10, p11, _) -- update | line: 109
            -- upvalues: p1 (copy), p2 (copy), fightHooked (copy), attr (copy)
            local MarlinSwim = p1.MarlinSwim
            local model = p10.model
            local StrokeAt = attr(model, "StrokeAt")
            local v27 = fightHooked(model)
            local HOOK_EFFORT

            if v27 then
                p10.phase += p11 * MarlinSwim.HOOK_RATE
                HOOK_EFFORT = MarlinSwim.HOOK_EFFORT
                p10.locked = nil
            elseif attr(model, "PassCruise") then
                HOOK_EFFORT = p10.v / math.max(attr(model, "PassCruise"), 0.001)
                p10.phase = p10.phase + p11 * 2 * 3.141592653589793 * math.max(p10.v / (MarlinSwim.PASS_STRIDE * math.max(p10.length, 0.001)), MarlinSwim.PASS_MIN_HZ)
                p10.locked = nil
            elseif StrokeAt then
                local v30 = attr(model, "StrokeRate") or 0

                HOOK_EFFORT = v30 / math.max(attr(model, "StrokeCruise") or v30, 0.001)

                local v32 = (attr(model, "StrokePhase") or 0) + v30 * (workspace:GetServerTimeNow() - p2.renderLag() - StrokeAt)

                if p10.locked then
                    p10.phase += p11 * v30
                    p10.phase = p10.phase + ((v32 - p10.phase + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * math.min(1, p11 * MarlinSwim.LOCK)
                else
                    p10.phase = v32
                    p10.locked = true
                end
            else
                p10.phase += p11 * (attr(model, "StrokeHz") or MarlinSwim.PEN_RATE)
                HOOK_EFFORT = MarlinSwim.PEN_EFFORT
                p10.locked = nil
            end

            local v35 = math.max(HOOK_EFFORT, 0)

            p10.fin += p11 * MarlinSwim.FIN_RATE

            local _CFrame = p10.mesh.CFrame
            local v36 = _CFrame:VectorToWorldSpace(p10.nose)
            local v37 = Vector3.new(v36.X, 0, v36.Z)

            if p10.lastPos and p10.lastNose and p11 > 1E-04 and (_CFrame.Position - p10.lastPos).Magnitude < 20 and v37.Magnitude > 0.001 then
                local lastNose = p10.lastNose
                local Unit = v37.Unit
                local v39 = math.atan2(lastNose:Cross(Unit).Y, (lastNose:Dot(Unit))) / p11
                local v40 = (_CFrame.Position - p10.lastPos).Magnitude / p11

                p10.w = p10.w + (v39 - p10.w) * math.min(1, p11 / MarlinSwim.W_TAU)
                p10.v = p10.v + (v40 - p10.v) * math.min(1, p11 / MarlinSwim.V_TAU)
            end

            p10.lastPos = _CFrame.Position

            if v37.Magnitude > 0.001 then
                p10.lastNose = v37.Unit
            end

            local v47 = math.clamp(p10.length * p10.w / math.max(p10.v, 5), -0.9, 0.9)
            local v49 = math.min(1, math.abs(p10.w) / MarlinSwim.TURN_REF)
            local v50 = if v35 <= 0.3 then 0 elseif v35 <= 1 then (v35 - 0.3) * 0.45 / 0.7 else math.min(1, (v35 - 1) / 0.5) * 0.55 + 0.45
            local v53 = math.max(0, v50 - v49 * 0.5)
            local v58 = math.max(-0.15, math.clamp((v35 - 0.9) / 0.5, 0, 1) - math.max(0, 1 - v35 / 0.3) * 0.15 - v49 * 0.5)
            local v60 = math.min(1, p11 * MarlinSwim.FOLD_EASE)

            p10.sf += (v53 - p10.sf) * v60
            p10.pf += (v58 - p10.pf) * v60

            local v63 = math.min(v35, 1) * (math.clamp(v35 - 1, 0, 1) * 0.2 + 1)

            if v27 then
                v63 = MarlinSwim.HOOK_AMP
            end

            local Slash = attr(model, "Slash")
            local v64

            if Slash then
                v64 = (workspace:GetServerTimeNow() - p2.renderLag() - Slash) / MarlinSwim.SLASH_T

                if not (v64 >= 0 and v64 <= 1) then
                    v64 = nil
                end
            end

            local v65 = attr(model, "SlashSide") or 1

            for v66, v67 in ipairs(p10.body) do
                local v70 = MarlinSwim.AMP * v63 * MarlinSwim.G[v66] * math.sin(p10.phase - MarlinSwim.K * MarlinSwim.T[v66])

                if v66 >= 3 then
                    v70 += -MarlinSwim.BEND * v47 / 5
                end

                if v64 then
                    v70 += MarlinSwim.SLASH_AMP * MarlinSwim.SLASH_G[v66] * v65 * math.sin(3.141592653589793 * v64)
                end

                v67.bone.Transform = CFrame.fromAxisAngle(v67.up, v70)
            end

            for v73, v74 in ipairs(p10.sail) do
                v74.bone.Transform = CFrame.fromAxisAngle(v74.lat, (p10.sailFold or MarlinSwim.SAIL_FOLD) * p10.sf) * CFrame.fromAxisAngle(v74.nose, MarlinSwim.FLUTTER * (1 - p10.sf) * math.sin(p10.fin - 0.7 * (v73 - 1)))
            end

            if p10.finSwayA then
                p10.swayT += p11 * MarlinSwim.SWAY_RATE
            end

            for _, v78 in ipairs(p10.fins) do
                v78.bone.Transform = CFrame.fromAxisAngle(v78.axis, p10.finAngle * p10.pf)

                if p10.finSwayA then
                    local bone = v78.bone

                    bone.Transform = bone.Transform * CFrame.fromAxisAngle(v78.up, p10.finSwayA * (1 - math.clamp(p10.pf, 0, 1)) * math.sin(p10.swayT))
                end
            end
        end
    }
end
