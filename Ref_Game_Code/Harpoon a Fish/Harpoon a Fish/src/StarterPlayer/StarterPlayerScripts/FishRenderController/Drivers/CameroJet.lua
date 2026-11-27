-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 19
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.CameroJet = {
        SKEW = 0.35,
        SKEW_N = 1.1746,
        SWEEP = 0.2,
        SEG_LAG = 0.45,
        OPEN = 0.15,
        CLOSE = 0.5,
        OFF_CAP = 0.9,
        RLAG = 0.9,
        RIP_HZ = 0.45,
        RETRACT = 0.025,
        HEAD_LEAD = 0.3,
        NOD = 0.012,
        NOD_LAG = 0.8,
        CROWN_TURN = 0.12,
        STRIDE = 0.6,
        MIN_HZ = 0.35,
        MAX_HZ = 2.4,
        HOOK_HZ = 1.6,
        PEN_HZ = 0.45,
        TURN_FULL = 0.6,
        TURN_TAU = 0.3,
        V_TAU = 0.3,
        SPEC_L = 1.900762,
        NARM = 14,
        CURL = { 0, 0.22, 0.25, 0.28 },
        RIP = { 0, 0.065, 0.09, 0.12 },
        jet = function(p3) -- jet | line: 39
            -- upvalues: p1 (copy)
            local CameroJet = p1.CameroJet

            return 0.5 * (1 + (math.sin(p3) + CameroJet.SKEW * math.sin(2 * p3)) / CameroJet.SKEW_N)
        end,
        register = function(p4) -- register | line: 43
            -- upvalues: p1 (copy), attr (copy)
            local CameroJet = p1.CameroJet
            local MeshPart = p4:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p4, "AnatomyInverse")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local t2 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t2[descendant.Name] = descendant
                end
            end

            if not (t2.Shell and t2.Head) then
                return nil
            end

            for i = 1, CameroJet.NARM do
                if not t2["Arm_" .. i .. "_" .. 1] or not t2["Arm_" .. i .. "_" .. 2] or not t2["Arm_" .. i .. "_" .. 3] or not t2["Arm_" .. i .. "_" .. 4] then
                    return nil
                end
            end

            local CFrame = MeshPart.CFrame
            local v3 = p4:GetPivot() * AnatomyInverse:Inverse()
            local v4 = CFrame:VectorToObjectSpace(v3.RightVector)
            local v5 = CFrame:VectorToObjectSpace(v3.UpVector)
            local Unit = v5:Cross(v4).Unit
            local v6 = -v4
            local Size = MeshPart.Size
            local v9 = math.abs(v4.X) * Size.X + math.abs(v4.Y) * Size.Y + math.abs(v4.Z) * Size.Z

            local function rest(p5) -- line: 66
                -- upvalues: t2 (copy), CFrame (copy)
                return CFrame:ToObjectSpace(t2[p5].WorldCFrame)
            end

            local v10 = CFrame:ToObjectSpace(t2.Head.WorldCFrame)
            local Position = v10.Position
            local v11 = CFrame:ToObjectSpace(t2.Shell.WorldCFrame)
            local t3 = {
                turn = 0,
                v = 0,
                model = p4,
                mesh = MeshPart,
                noseM = v4,
                length = v9,
                phase = math.random(),
                rip = math.random(),
                shell = {
                    bone = t2.Shell,
                    left = v11:VectorToObjectSpace(Unit)
                },
                head = {
                    bone = t2.Head,
                    up = v10:VectorToObjectSpace(v5),
                    back = v10:VectorToObjectSpace(v6) * (v9 / CameroJet.SPEC_L)
                },
                arms = {}
            }

            for i = 1, CameroJet.NARM do
                local Position2 = CFrame:ToObjectSpace(t2["Arm_" .. i .. "_1"].WorldCFrame).Position
                local Position3 = CFrame:ToObjectSpace(t2["Arm_" .. i .. "_4"].WorldCFrame).Position
                local v12 = Position3 - Position
                local Unit2 = (v12 - v6 * v12:Dot(v6)).Unit
                local Unit3 = Unit2:Cross(v6).Unit
                local v13 = Position2 - Position
                local v16 = math.atan2(-v13:Dot(Unit), (v13:Dot(v5))) % 6.283185307179586
                local v20 = math.min(CameroJet.OFF_CAP, (math.acos((math.clamp((Position3 - Position2).Unit:Dot(v6), -1, 1)))))
                local t4 = {}

                for j = 1, 4 do
                    local v21 = CFrame:ToObjectSpace(t2["Arm_" .. i .. "_" .. j].WorldCFrame)

                    t4[j] = {
                        bone = t2["Arm_" .. i .. "_" .. j],
                        pa = v21:VectorToObjectSpace(Unit3),
                        ra = v21:VectorToObjectSpace(Unit2)
                    }
                end

                t3.arms[i] = {
                    ang = v16,
                    off = v20,
                    segs = t4
                }
            end

            return t3
        end,
        update = function(p6, p7) -- update | line: 97
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local CameroJet = p1.CameroJet
            local model = p6.model
            local _CFrame = p6.mesh.CFrame

            if p6.lastPos and p7 > 1E-04 then
                local v22 = (_CFrame.Position - p6.lastPos).Magnitude / p7

                if v22 < 2000 then
                    p6.v = p6.v + (v22 - p6.v) * math.min(1, p7 / CameroJet.V_TAU)
                end
            end

            p6.lastPos = _CFrame.Position

            local v25 = _CFrame:VectorToWorldSpace(p6.noseM)
            local v26 = Vector3.new(v25.X, 0, v25.Z)

            if v26.Magnitude > 1E-04 then
                local Unit = v26.Unit

                if p6.lastFlat and p7 > 1E-04 then
                    local v28 = math.atan2(p6.lastFlat:Cross(Unit).Y, (p6.lastFlat:Dot(Unit))) / p7

                    p6.turn = p6.turn + (math.clamp(v28 / CameroJet.TURN_FULL, -1, 1) - p6.turn) * math.min(1, p7 / CameroJet.TURN_TAU)
                end

                p6.lastFlat = Unit
            end

            local PEN_HZ = CameroJet.PEN_HZ

            if fightHooked(model) then
                PEN_HZ = CameroJet.HOOK_HZ
            elseif attr(model, "School") or attr(model, "PassCruise") then
                PEN_HZ = math.min(CameroJet.MAX_HZ, (math.max(p6.v / (CameroJet.STRIDE * math.max(p6.length, 0.001)), CameroJet.MIN_HZ)))
            end

            p6.phase = (p6.phase + p7 * PEN_HZ) % 1
            p6.rip = (p6.rip + p7 * CameroJet.RIP_HZ) % 1

            local v34 = 6.283185307179586 * p6.phase
            local v35 = 6.283185307179586 * p6.rip
            local jet = CameroJet.jet

            for v36, v37 in ipairs(p6.arms) do
                local v38 = v34 - CameroJet.SWEEP * v37.ang

                for i = 1, 4 do
                    local v39 = v37.segs[i]
                    local v40 = jet(v38 - CameroJet.SEG_LAG * (i - 1))
                    local v41 = v35 + 2.4 * v36 - CameroJet.RLAG * i
                    local v42 = CameroJet.RIP[i]
                    local v43 = if i == 1 then CFrame.fromAxisAngle(v39.pa, v37.off * (-CameroJet.OPEN + (CameroJet.OPEN + CameroJet.CLOSE) * v40)) else CFrame.fromAxisAngle(v39.pa, CameroJet.CURL[i] * (0.5 - v40) + 0.5 * v42 * math.cos(v41))

                    v39.bone.Transform = v43 * CFrame.fromAxisAngle(v39.ra, v42 * math.sin(v41))
                end
            end

            local head = p6.head

            head.bone.Transform = CFrame.new(head.back * (-CameroJet.RETRACT * jet(v34 + CameroJet.HEAD_LEAD))) * CFrame.fromAxisAngle(head.up, -CameroJet.CROWN_TURN * p6.turn)
            p6.shell.bone.Transform = CFrame.fromAxisAngle(p6.shell.left, CameroJet.NOD * math.sin(v34 - CameroJet.NOD_LAG))
        end
    }
end
