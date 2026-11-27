-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 3
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.LobeSwim = {
        N = 14,
        STRIDE = 0.42,
        MIN_HZ = 1,
        MAX_HZ = 4.5,
        HOOK_HZ = 5,
        WAVES = 1,
        AMP = 0.24,
        SPREAD = 0.07,
        TURN_AMP = 0.35,
        HOOK_AMP = 1.35,
        B_AMP = 0.015,
        B_LAG = 0.6,
        TURN_BEND = 0.12,
        TURN_FAN = 0.25,
        P_YAW = 0.16,
        P_CURL = 0.1,
        P_RATE = 2,
        P_CURL_RATE = 1.3,
        P_LAG = 0.8,
        P_BASE = 0.5,
        CURL_UNDER = -0.45,
        CURL_T = 7,
        HOOK_PROB = 2.5,
        TURN_FULL = 0.6,
        TURN_TAU = 0.3,
        V_TAU = 0.15,
        BODY = { "Spine_02", "Spine_03", "Spine_04", "Tail_01", "Tail_02", "Tail_03" },
        register = function(p3) -- register | line: 29
            -- upvalues: p1 (copy), attr (copy)
            local LobeSwim = p1.LobeSwim
            local MeshPart = p3:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p3, "AnatomyInverse")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local CFrame = MeshPart.CFrame
            local v1 = p3:GetPivot() * AnatomyInverse:Inverse()
            local v2 = CFrame:VectorToObjectSpace(v1.RightVector)
            local v3 = CFrame:VectorToObjectSpace(v1.UpVector)
            local Unit = v2:Cross(v3).Unit

            local function axes(p4) -- line: 39
                -- upvalues: CFrame (copy), v2 (copy), v3 (copy), Unit (copy)
                local v4 = CFrame:ToObjectSpace(p4.WorldCFrame)

                return {
                    bone = p4,
                    up = v4:VectorToObjectSpace(v3),
                    right = v4:VectorToObjectSpace(Unit),
                    nose = v4:VectorToObjectSpace(v2)
                }
            end

            local t2 = {}

            for _, v5 in ipairs({ "L", "R" }) do
                for i = 1, LobeSwim.N do
                    local v6 = MeshPart:FindFirstChild(string.format("Lobe%s%02d_1", v5, i), true)

                    if not v6 then
                        return nil
                    end

                    local v7 = axes(v6)
                    local v8 = if v5 == "L" then 1 else -1
                    local v9 = i - 1

                    v7.s = v8
                    v7.k = v9
                    t2[#t2 + 1] = v7
                end
            end

            local t3 = {}

            for v10, v11 in ipairs(LobeSwim.BODY) do
                local v12 = MeshPart:FindFirstChild(v11, true)

                if v12 then
                    local v13 = axes(v12)
                    local v14 = v11 == "Tail_03"

                    v13.i = v10
                    v13.fan = v14
                    t3[#t3 + 1] = v13
                end
            end

            local t4 = {}

            for i = 1, 8 do
                local v15 = MeshPart:FindFirstChild("Prob_" .. i, true)

                if not v15 then
                    break
                end

                t4[i] = axes(v15)
            end

            local Size = MeshPart.Size

            return {
                v = 0,
                turn = 0,
                model = p3,
                mesh = MeshPart,
                nose = v2,
                lobes = t2,
                body = t3,
                prob = t4,
                ext = math.abs(v2.X) * Size.X + math.abs(v2.Y) * Size.Y + math.abs(v2.Z) * Size.Z,
                phi = math.random() * 2 * 3.141592653589793,
                t = math.random() * 10
            }
        end,
        update = function(p5, p6) -- update | line: 69
            -- upvalues: p1 (copy), fightHooked (copy)
            local LobeSwim = p1.LobeSwim
            local _CFrame = p5.mesh.CFrame

            if p5.lastPos and p6 > 1E-04 then
                local v18 = (_CFrame.Position - p5.lastPos).Magnitude / p6

                if v18 < 2000 then
                    p5.v = p5.v + (v18 - p5.v) * math.min(1, p6 / LobeSwim.V_TAU)
                end
            end

            p5.lastPos = _CFrame.Position

            local v21 = _CFrame:VectorToWorldSpace(p5.nose)
            local v22 = Vector3.new(v21.X, 0, v21.Z)

            if v22.Magnitude > 1E-04 then
                local Unit = v22.Unit

                if p5.lastFlat and p6 > 1E-04 then
                    local v24 = math.atan2(p5.lastFlat:Cross(Unit).Y, (p5.lastFlat:Dot(Unit))) / p6

                    p5.turn = p5.turn + (math.clamp(v24 / LobeSwim.TURN_FULL, -1, 1) - p5.turn) * math.min(1, p6 / LobeSwim.TURN_TAU)
                end

                p5.lastFlat = Unit
            end

            local v28 = fightHooked(p5.model)
            local HOOK_HZ = if v28 then LobeSwim.HOOK_HZ else nil

            if not v28 or not HOOK_HZ then
                HOOK_HZ = math.clamp(p5.v / math.max(p5.ext, 0.001) / LobeSwim.STRIDE, LobeSwim.MIN_HZ, LobeSwim.MAX_HZ)
            end

            p5.phi = (p5.phi + p6 * 2 * 3.141592653589793 * HOOK_HZ) % 6.283185307179586
            p5.t += p6 * (v28 and LobeSwim.HOOK_PROB or 1)

            local phi, turn, t = p5.phi, p5.turn, p5.t
            local v30 = 6.283185307179586 * LobeSwim.WAVES / (LobeSwim.N - 1)
            local HOOK_AMP = v28 and LobeSwim.HOOK_AMP or 1

            for _, v31 in ipairs(p5.lobes) do
                local v32 = LobeSwim.AMP * (1 - v31.s * LobeSwim.TURN_AMP * turn) * HOOK_AMP

                v31.bone.Transform = CFrame.fromAxisAngle(v31.nose, v31.s * (LobeSwim.SPREAD + v32 * math.sin(phi - v31.k * v30)))
            end

            for _, v34 in ipairs(p5.body) do
                local v35 = LobeSwim.TURN_BEND / #LobeSwim.BODY * turn

                if v34.fan then
                    v35 -= LobeSwim.TURN_FAN * turn
                end

                v34.bone.Transform = CFrame.fromAxisAngle(v34.right, LobeSwim.B_AMP * math.sin(phi - v34.i * LobeSwim.B_LAG)) * CFrame.fromAxisAngle(v34.up, v35)
            end

            local v38 = ((1 - math.cos(6.283185307179586 * t / LobeSwim.CURL_T)) / 2) ^ 6

            for v39, v40 in ipairs(p5.prob) do
                local v41 = v39 == 1 and LobeSwim.P_BASE or 1

                v40.bone.Transform = CFrame.fromAxisAngle(v40.up, v41 * LobeSwim.P_YAW * math.sin(t * LobeSwim.P_RATE - v39 * LobeSwim.P_LAG)) * CFrame.fromAxisAngle(v40.right, v41 * LobeSwim.P_CURL * math.sin(t * LobeSwim.P_CURL_RATE - v39 * LobeSwim.P_LAG) + LobeSwim.CURL_UNDER * (v39 - 1) / 3 * v38)
            end
        end
    }
end
