-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 21
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.WormSwim = {
        LAM = 0.5,
        A = 0.03,
        X0 = 0.12,
        X1 = 0.38,
        X2 = 0.62,
        TAIL_E = 0.55,
        B = 0.45,
        TURN_ROW = 0.3,
        HOOK_ROW = 1,
        HOOK_A = 1.35,
        STRIDE = 0.72,
        MIN_HZ = 1,
        MAX_HZ = 6,
        HOOK_HZ = 5,
        TURN_BEND = 0.18,
        TURN_FULL = 0.6,
        TURN_TAU = 0.3,
        FWD = 0.15,
        TIP = 0.985,
        V_TAU = 0.1,
        HINGE = {
            U = { -0.6519, 0.7583 },
            D = { 0.3384, 0.941 }
        },
        ss = function(p3) -- ss | line: 35
            local v1 = math.clamp(p3, 0, 1)

            return v1 * v1 * (3 - 2 * v1)
        end,
        env = function(p4) -- env | line: 39
            -- upvalues: p1 (copy)
            local WormSwim = p1.WormSwim

            return WormSwim.ss((p4 - WormSwim.X0) / (WormSwim.X1 - WormSwim.X0)) * (1 - (1 - WormSwim.TAIL_E) * WormSwim.ss((p4 - WormSwim.X2) / (1 - WormSwim.X2)))
        end,
        h = function(p5, p6, p7) -- h | line: 43
            -- upvalues: p1 (copy)
            local WormSwim = p1.WormSwim

            return WormSwim.A * (p7 and WormSwim.HOOK_A or 1) * WormSwim.env(p5) * math.sin(p6 + 6.283185307179586 * p5 / WormSwim.LAM)
        end,
        hz = function(p8, p9) -- hz | line: 47
            -- upvalues: p1 (copy)
            local WormSwim = p1.WormSwim

            if p9 then
                return WormSwim.HOOK_HZ
            end

            return (math.min(WormSwim.MAX_HZ, (math.max(WormSwim.MIN_HZ, p8 / WormSwim.STRIDE))))
        end,
        spine = function(p10, p11, p12, p13) -- spine | line: 54
            -- upvalues: p1 (copy)
            local WormSwim = p1.WormSwim
            local v6 = #p10
            local v7 = table.create(v6)

            for i = 1, v6 do
                v7[i] = WormSwim.h(p10[i], p11, p13)
            end

            local v8 = table.create(v6 - 1)
            local v9 = WormSwim.TURN_BEND * p12 / (v6 - 1)
            local v10 = v6 - 1
            local n1 = 0

            for i = 1, v10 do
                local v12 = math.atan((v7[i + 1] - v7[i]) / (p10[i + 1] - p10[i]))

                v8[i] = v12 - n1 + v9
                n1 = v12
            end

            return v8
        end,
        rows = function(p14, p15, p16, p17) -- rows | line: 72
            -- upvalues: p1 (copy)
            local WormSwim = p1.WormSwim
            local HOOK_ROW = p17 and WormSwim.HOOK_ROW or 1
            local v13 = WormSwim.B * (1 - WormSwim.TURN_ROW * p16) * HOOK_ROW
            local v14 = WormSwim.B * (1 + WormSwim.TURN_ROW * p16) * HOOK_ROW
            local FWD = WormSwim.FWD
            local cos, fromAxisAngle = math.cos, CFrame.fromAxisAngle

            for _, v15 in ipairs(p14.rows) do
                if v15.s == 1 then
                    v15.bone.Transform = fromAxisAngle(v15.axis, -FWD + v13 * cos(p15 + v15.kx))
                else
                    v15.bone.Transform = fromAxisAngle(v15.axis, FWD + v14 * cos(p15 + v15.kx))
                end
            end
        end,
        register = function(p18) -- register | line: 87
            -- upvalues: p1 (copy), attr (copy)
            local WormSwim = p1.WormSwim
            local MeshPart = p18:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p18, "AnatomyInverse")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local CFrame = MeshPart.CFrame
            local v16 = p18:GetPivot() * AnatomyInverse:Inverse()
            local v17 = CFrame:VectorToObjectSpace(v16.RightVector)
            local v18 = CFrame:VectorToObjectSpace(v16.UpVector)
            local Unit = v18:Cross(v17).Unit
            local Size = MeshPart.Size
            local v21 = math.abs(v17.X) * Size.X + math.abs(v17.Y) * Size.Y + math.abs(v17.Z) * Size.Z
            local t2 = {}
            local t3 = {}

            for i = 1, 99 do
                local v22 = MeshPart:FindFirstChild(string.format("Spine_%02d", i), true)

                if not v22 then
                    break
                end

                local v23 = CFrame:ToObjectSpace(v22.WorldCFrame)

                t2[i] = {
                    bone = v22,
                    up = v23:VectorToObjectSpace(v18)
                }
                t3[i] = (v21 / 2 - v23.Position:Dot(v17)) / v21
            end

            if #t2 < 3 then
                return nil
            end

            t3[#t2 + 1] = WormSwim.TIP

            local t4 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") and descendant.Name:sub(1, 3) == "Row" then
                    local v24 = descendant.Name:sub(4, 4)
                    local v25 = descendant.Name:sub(5, 5)
                    local v26 = WormSwim.HINGE[v25]

                    if v26 and (v24 == "L" or v24 == "R") then
                        local v27 = if v24 == "L" then 1 else -1
                        local v28 = CFrame:ToObjectSpace(descendant.WorldCFrame)
                        local Unit2 = (Unit * (v27 * v26[1]) + v18 * v26[2]).Unit
                        local v29 = (v21 / 2 - v28.Position:Dot(v17)) / v21

                        t4[#t4 + 1] = {
                            bone = descendant,
                            s = v27,
                            x = v29,
                            kx = 6.283185307179586 * v29 / WormSwim.LAM,
                            axis = v28:VectorToObjectSpace(Unit2)
                        }
                    end
                end
            end

            return if #t4 ~= 0 then {
                v = 0,
                turn = 0,
                model = p18,
                mesh = MeshPart,
                spine = t2,
                knots = t3,
                rows = t4,
                ext = v21,
                noseM = v17,
                phase = math.random() * 6.283185307179586
            } else nil
        end,
        update = function(p19, p20) -- update | line: 129
            -- upvalues: p1 (copy), fightHooked (copy)
            local WormSwim = p1.WormSwim
            local _CFrame = p19.mesh.CFrame

            if p19.lastPos and p20 > 1E-04 then
                local v31 = (_CFrame.Position - p19.lastPos).Magnitude / p20

                if v31 < 2000 then
                    p19.v = p19.v + (v31 - p19.v) * math.min(1, p20 / WormSwim.V_TAU)
                end
            end

            p19.lastPos = _CFrame.Position

            local v34 = _CFrame:VectorToWorldSpace(p19.noseM)
            local v35 = Vector3.new(v34.X, 0, v34.Z)

            if v35.Magnitude > 1E-04 then
                local Unit = v35.Unit

                if p19.lastFlat and p20 > 1E-04 then
                    local v37 = math.atan2(p19.lastFlat:Cross(Unit).Y, (p19.lastFlat:Dot(Unit))) / p20

                    p19.turn = p19.turn + (math.clamp(v37 / WormSwim.TURN_FULL, -1, 1) - p19.turn) * math.min(1, p20 / WormSwim.TURN_TAU)
                end

                p19.lastFlat = Unit
            end

            local v41 = fightHooked(p19.model)
            local v42 = p19.v / math.max(p19.ext, 0.001)

            p19.phase = (p19.phase + p20 * 6.283185307179586 * WormSwim.hz(v42, v41)) % 6.283185307179586

            local phase, turn = p19.phase, p19.turn
            local v43 = WormSwim.spine(p19.knots, phase, turn, v41)

            for v44, v45 in ipairs(p19.spine) do
                v45.bone.Transform = CFrame.fromAxisAngle(v45.up, v43[v44])
            end

            WormSwim.rows(p19, phase, turn, v41)
        end
    }
end
