-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 4
    local fightHooked = p2.fightHooked

    p1.VikingSwim = {
        ROW_AMP = 0.38,
        ROW_LIFT = 0.3,
        ROW_STRIDE = 0.8,
        ROW_HOOK_HZ = 2.2,
        FLAG_LAG = 0.9,
        FLAG_FLAP = 0.35,
        SAIL_RATE = 1.1,
        SAIL_LAG = 0.8,
        SP_MAX = 1.5,
        ROW_HZ = { 0.4, 2.2 },
        FLAG_A = { 0.1, 0.24 },
        FLAG_RATE = { 3, 11 },
        SAIL_BACK = { 0.1, 0.06 },
        SAIL_BREATH = { 0.05, 0.07 },
        FLAGS = { "Flag_1", "Flag_2", "Flag_3" },
        SAILS = { "Sail_1", "Sail_2" },
        OARS = {
            { "Oar_L1", 1 },
            { "Oar_L2", 1 },
            { "Oar_R1", -1 },
            { "Oar_R2", -1 }
        },
        rowHz = function(p3, p4) -- rowHz | line: 28
            -- upvalues: p1 (copy)
            local VikingSwim = p1.VikingSwim

            if p4 then
                return VikingSwim.ROW_HOOK_HZ
            end

            return (math.min(VikingSwim.ROW_HZ[2], (math.max(VikingSwim.ROW_HZ[1], p3 / VikingSwim.ROW_STRIDE))))
        end,
        pose = function(p5, p6, p7, p8, p9) -- pose | line: 35
            -- upvalues: p1 (copy)
            local VikingSwim = p1.VikingSwim
            local v5 = VikingSwim.FLAG_A[1] + (VikingSwim.FLAG_A[2] - VikingSwim.FLAG_A[1]) * p8

            for i = 0, 2 do
                local v7 = math.sin(p6 - VikingSwim.FLAG_LAG * i)

                p9[i * 2 + 1] = v5 * v7

                local v8 = v5 * VikingSwim.FLAG_FLAP
                local v9 = p6 - VikingSwim.FLAG_LAG * i

                p9[i * 2 + 2] = v8 * math.cos(v9)
            end

            p9[7] = -VikingSwim.SAIL_BACK[1] * p8 + VikingSwim.SAIL_BREATH[1] * math.sin(p7)
            p9[8] = -VikingSwim.SAIL_BACK[2] * p8 + VikingSwim.SAIL_BREATH[2] * math.sin(p7 - VikingSwim.SAIL_LAG)
            p9[9] = VikingSwim.ROW_AMP * math.cos(p5)
            p9[10] = VikingSwim.ROW_LIFT * math.max(0, -math.sin(p5))

            return p9
        end,
        register = function(p10) -- register | line: 49
            -- upvalues: p1 (copy)
            local VikingSwim = p1.VikingSwim
            local v14 = p1.MarlinSwim.register(p10)

            if not v14 then
                return nil
            end

            local t2 = {}

            for _, descendant in ipairs(v14.mesh:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t2[descendant.Name] = descendant
                end
            end

            local CFrame = v14.mesh.CFrame
            local nose = v14.nose
            local Unit = CFrame:VectorToObjectSpace(t2.Fin_R.WorldPosition - t2.Fin_L.WorldPosition).Unit
            local Unit2 = Unit:Cross(nose).Unit

            local function axes(p11) -- line: 61
                -- upvalues: CFrame (copy), nose (copy), Unit (copy), Unit2 (copy)
                local v15 = CFrame:ToObjectSpace(p11.WorldCFrame)

                return {
                    bone = p11,
                    up = v15:VectorToObjectSpace(Unit2),
                    lat = v15:VectorToObjectSpace(Unit),
                    nose = v15:VectorToObjectSpace(nose)
                }
            end

            local t3 = {
                flags = {},
                sails = {},
                oars = {},
                a = table.create(10, 0),
                row = math.random() * 6.28,
                flag = math.random() * 6.28,
                sail = math.random() * 6.28
            }

            for v16, v17 in ipairs(VikingSwim.FLAGS) do
                if t2[v17] then
                    table.insert(t3.flags, {
                        ax = axes(t2[v17]),
                        i = v16
                    })
                end
            end

            for v18, v19 in ipairs(VikingSwim.SAILS) do
                if t2[v19] then
                    table.insert(t3.sails, {
                        ax = axes(t2[v19]),
                        i = v18
                    })
                end
            end

            for _, v20 in ipairs(VikingSwim.OARS) do
                if t2[v20[1]] then
                    table.insert(t3.oars, {
                        ax = axes(t2[v20[1]]),
                        side = v20[2]
                    })
                end
            end

            v14.rig = t3

            return v14
        end,
        update = function(p12, p13, p14) -- update | line: 79
            -- upvalues: p1 (copy), fightHooked (copy)
            local VikingSwim = p1.VikingSwim

            p1.MarlinSwim.update(p12, p13, p14)

            local rig = p12.rig
            local v21 = p12.v / math.max(p12.length, 0.001)
            local v22 = math.min(v21, VikingSwim.SP_MAX) / VikingSwim.SP_MAX

            rig.row += p13 * 2 * 3.141592653589793 * VikingSwim.rowHz(v21, fightHooked(p12.model))
            rig.flag += p13 * (VikingSwim.FLAG_RATE[1] + (VikingSwim.FLAG_RATE[2] - VikingSwim.FLAG_RATE[1]) * v22)
            rig.sail += p13 * VikingSwim.SAIL_RATE

            local v23 = VikingSwim.pose(rig.row, rig.flag, rig.sail, v22, rig.a)

            for _, v24 in ipairs(rig.flags) do
                v24.ax.bone.Transform = CFrame.fromAxisAngle(v24.ax.up, v23[2 * v24.i - 1]) * CFrame.fromAxisAngle(v24.ax.lat, v23[2 * v24.i])
            end

            for _, v25 in ipairs(rig.sails) do
                v25.ax.bone.Transform = CFrame.fromAxisAngle(v25.ax.lat, v23[6 + v25.i])
            end

            for _, v26 in ipairs(rig.oars) do
                v26.ax.bone.Transform = CFrame.fromAxisAngle(v26.ax.lat, v23[9]) * CFrame.fromAxisAngle(v26.ax.nose, v26.side * v23[10])
            end
        end
    }
end
