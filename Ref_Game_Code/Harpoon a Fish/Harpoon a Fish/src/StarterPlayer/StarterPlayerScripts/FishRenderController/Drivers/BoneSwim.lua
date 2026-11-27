-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 17
    local fightHooked, attr = p2.fightHooked, p2.attr

    local function ss(p3) -- line: 21
        local v1 = math.clamp(p3, 0, 1)

        return v1 * v1 * (3 - 2 * v1)
    end

    p1.BoneSwim = {
        WAVE = {
            { "Chest", 0.06, 0 },
            { "Belly", 0.1, 0.224 },
            { "Pelvis", 0.16, 0.456 },
            { "Tail_1", 0.22, 0.662 },
            { "Tail_2", 0.26, 0.81 },
            { "Tail_3", 0.3, 0.956 },
            { "Tail_4", 0.32, 1.101 },
            { "Tail_5", 0.34, 1.242 },
            { "Tail_6", 0.34, 1.375 }
        },
        LAMBDA = 0.7,
        L_ARC = 1.92,
        BEND = 0.1,
        HEAD_STEADY = 0.7,
        LOOK = 0.2,
        NOD = 0.03,
        FORE_PH = 0,
        HIND_PH = 0.25,
        SWEEP = 0.2,
        LIFT = 0.16,
        FEATHER = 0.22,
        TIP_SW = 0.08,
        TIP_LIFT = 0.14,
        TIP_LAG = 0.9,
        HIND_GAIN = 0.8,
        IDLE = 0.35,
        RUDDER_DROP = 0.22,
        RUDDER_FWD = 0.12,
        TUCK = 0.18,
        BREATH = 0.04,
        BREATH_HZ = 0.3,
        WIND_T = 0.28,
        SNAP_T = 0.08,
        HOLD_T = 0.06,
        BOUNCE_T = 0.14,
        SNAP2_T = 0.08,
        OPEN_T = 0.5,
        GAPE = 0.1,
        SHUT = 0.38,
        BOUNCE = 0.2,
        SHUT2 = 0.34,
        HEAD_LIFT = 0.07,
        HEAD_DIP = 0.04,
        STRIDE = 0.5,
        MIN_HZ = 0.8,
        MAX_HZ = 2.6,
        HOOK_HZ = 1.6,
        CRUISE_HZ = 1.6,
        M_MIN = 0.45,
        M_MAX = 1.5,
        BITE_EVERY = { 4, 9 },
        TURN_FULL = 0.6,
        TURN_TAU = 0.3,
        V_TAU = 0.3,
        BONES = {
            "Chest",
            "Belly",
            "Pelvis",
            "Tail_1",
            "Tail_2",
            "Tail_3",
            "Tail_4",
            "Tail_5",
            "Tail_6",
            "Neck",
            "Head",
            "Jaw",
            "Fore_L_1",
            "Fore_L_2",
            "Fore_R_1",
            "Fore_R_2",
            "Hind_L_1",
            "Hind_L_2",
            "Hind_R_1",
            "Hind_R_2"
        },
        bite = function(p4) -- bite | line: 50
            -- upvalues: p1 (copy)
            local BoneSwim = p1.BoneSwim

            if p4 < 0 then
                return 0, 0
            end

            if p4 < BoneSwim.WIND_T then
                local v3 = math.clamp(p4 / BoneSwim.WIND_T, 0, 1)
                local v4 = v3 * v3 * (3 - 2 * v3)

                return -BoneSwim.GAPE * v4, BoneSwim.HEAD_LIFT * v4
            end

            local v5 = p4 - BoneSwim.WIND_T

            if v5 < BoneSwim.SNAP_T then
                local v7 = math.clamp(v5 / BoneSwim.SNAP_T, 0, 1)
                local v8 = v7 * v7 * (3 - 2 * v7)

                return -BoneSwim.GAPE + (BoneSwim.GAPE + BoneSwim.SHUT) * v8, BoneSwim.HEAD_LIFT - (BoneSwim.HEAD_LIFT + BoneSwim.HEAD_DIP) * v8
            end

            local v9 = v5 - BoneSwim.SNAP_T

            if v9 < BoneSwim.HOLD_T then
                return BoneSwim.SHUT, -BoneSwim.HEAD_DIP
            end

            local v10 = v9 - BoneSwim.HOLD_T

            if v10 < BoneSwim.BOUNCE_T then
                local v12 = math.clamp(v10 / BoneSwim.BOUNCE_T, 0, 1)
                local v13 = v12 * v12 * (3 - 2 * v12)

                return BoneSwim.SHUT - (BoneSwim.SHUT - BoneSwim.BOUNCE) * v13, -BoneSwim.HEAD_DIP
            end

            local v14 = v10 - BoneSwim.BOUNCE_T

            if v14 < BoneSwim.SNAP2_T then
                local v16 = math.clamp(v14 / BoneSwim.SNAP2_T, 0, 1)
                local v17 = v16 * v16 * (3 - 2 * v16)

                return BoneSwim.BOUNCE + (BoneSwim.SHUT2 - BoneSwim.BOUNCE) * v17, -BoneSwim.HEAD_DIP
            end

            local v18 = v14 - BoneSwim.SNAP2_T

            if v18 < BoneSwim.OPEN_T then
                local v20 = math.clamp(v18 / BoneSwim.OPEN_T, 0, 1)
                local v21 = v20 * v20 * (3 - 2 * v20)

                return BoneSwim.SHUT2 * (1 - v21), -BoneSwim.HEAD_DIP * (1 - v21)
            end

            return 0, 0
        end,
        effort = function(p5) -- effort | line: 82
            -- upvalues: p1 (copy)
            local BoneSwim = p1.BoneSwim

            return (math.min(BoneSwim.M_MAX, (math.max(BoneSwim.M_MIN, p5 / BoneSwim.CRUISE_HZ))))
        end,
        flipper = function(p6, p7, p8, p9, p10) -- flipper | line: 88
            -- upvalues: p1 (copy)
            local BoneSwim = p1.BoneSwim
            local v24 = p9 * (BoneSwim.IDLE + (1 - BoneSwim.IDLE) * p10)
            local v25 = p7 * p8
            local v26 = if not (v25 > 0) or not v25 then 0 else v25
            local v27 = v25 < 0 and -v25 or 0
            local v28 = p7 * (BoneSwim.SWEEP * v24 * math.cos(p6) - BoneSwim.RUDDER_FWD * p9 * v26 + BoneSwim.TUCK * p9 * v27)
            local v29 = BoneSwim.LIFT * v24 * math.sin(p6) - BoneSwim.RUDDER_DROP * p9 * v26
            local v30 = -p7 * BoneSwim.FEATHER * v24 * math.cos(p6)
            local v31 = p6 - BoneSwim.TIP_LAG

            return {
                { "up", v28 },
                { "lift", v29 },
                { "Y", v30 }
            }, {
                {
                    "up",
                    p7 * BoneSwim.TIP_SW * v24 * math.cos(v31)
                },
                {
                    "lift",
                    BoneSwim.TIP_LIFT * v24 * math.sin(v31)
                }
            }
        end,
        pose = function(p11, p12, p13, p14, p15) -- pose | line: 103
            -- upvalues: p1 (copy)
            local BoneSwim = p1.BoneSwim
            local v32 = 6.283185307179586 * p11
            local t2 = {}
            local n1 = 0

            for _, v33 in ipairs(BoneSwim.WAVE) do
                local v36 = v33[2] * p13 * math.sin(v32 - 6.283185307179586 * v33[3] / (BoneSwim.LAMBDA * BoneSwim.L_ARC))

                if v33[1] == "Chest" then
                    n1 = v36
                    t2.Chest = { { "up", v36 } }
                else
                    t2[v33[1]] = {
                        {
                            "up",
                            v36 - BoneSwim.BEND * p12 / 4
                        }
                    }
                end
            end

            local v37, v38 = BoneSwim.bite(p15)

            t2.Neck = {
                {
                    "up",
                    -BoneSwim.HEAD_STEADY * n1 + 0.4 * BoneSwim.LOOK * p12
                },
                {
                    "lat",
                    BoneSwim.NOD * math.sin(v32 + 1) + 0.5 * v38
                }
            }
            t2.Head = {
                {
                    "up",
                    0.6 * BoneSwim.LOOK * p12
                },
                {
                    "lat",
                    0.5 * v38
                }
            }
            t2.Jaw = {
                {
                    "lat",
                    v37 + BoneSwim.BREATH * math.sin(6.283185307179586 * BoneSwim.BREATH_HZ * p14)
                }
            }

            for _, v41 in ipairs({ "L", "R" }) do
                local v42 = if v41 == "L" then 1 else -1
                local v43 = if v42 > 0 then 0 else 0.5
                local v44, v45 = BoneSwim.flipper(6.283185307179586 * (p11 - BoneSwim.FORE_PH - v43), v42, p12, 1, p13)
                local v46 = "Fore_" .. v41 .. "_1"
                local v47 = "Fore_" .. v41 .. "_2"

                t2[v46] = v44
                t2[v47] = v45

                local v48, v49 = BoneSwim.flipper(6.283185307179586 * (p11 - BoneSwim.HIND_PH - v43), v42, p12, BoneSwim.HIND_GAIN, p13)
                local v50 = "Hind_" .. v41 .. "_1"
                local v51 = "Hind_" .. v41 .. "_2"

                t2[v50] = v48
                t2[v51] = v49
            end

            return t2
        end,
        register = function(p16) -- register | line: 132
            -- upvalues: p1 (copy), attr (copy)
            local BoneSwim = p1.BoneSwim
            local MeshPart = p16:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p16, "AnatomyInverse")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local t4 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t4[descendant.Name] = descendant
                end
            end

            for _, v52 in ipairs(BoneSwim.BONES) do
                if not t4[v52] then
                    return nil
                end
            end

            local CFrame = MeshPart.CFrame
            local v53 = p16:GetPivot() * AnatomyInverse:Inverse()
            local v54 = CFrame:VectorToObjectSpace(v53.RightVector)
            local v55 = CFrame:VectorToObjectSpace(v53.UpVector)
            local v56 = -v55:Cross(v54).Unit
            local Size = MeshPart.Size
            local v59 = math.abs(v54.X) * Size.X + math.abs(v54.Y) * Size.Y + math.abs(v54.Z) * Size.Z
            local t5 = {}

            for _, v60 in ipairs(BoneSwim.BONES) do
                local v61 = CFrame:ToObjectSpace(t4[v60].WorldCFrame)
                local v62 = v61:VectorToWorldSpace((Vector3.new(0, 1, 0))):Cross(v55)
                local v63 = v62.Magnitude > 1E-06 and v62.Unit or v56

                t5[v60] = {
                    Y = Vector3.new(0, 1, 0),
                    bone = t4[v60],
                    nose = v61:VectorToObjectSpace(v54),
                    up = v61:VectorToObjectSpace(v55),
                    lat = v61:VectorToObjectSpace(v56),
                    lift = v61:VectorToObjectSpace(v63)
                }
            end

            return {
                turn = 0,
                v = 0,
                model = p16,
                mesh = MeshPart,
                A = t5,
                noseM = v54,
                phase = math.random(),
                length = v59,
                t = math.random() * 10,
                biteAt = math.random() * BoneSwim.BITE_EVERY[2]
            }
        end,
        update = function(p17, p18) -- update | line: 166
            -- upvalues: p1 (copy), fightHooked (copy)
            local BoneSwim = p1.BoneSwim
            local model = p17.model
            local _CFrame = p17.mesh.CFrame

            if p17.lastPos and p18 > 1E-04 then
                local v64 = (_CFrame.Position - p17.lastPos).Magnitude / p18

                if v64 < 2000 then
                    p17.v = p17.v + (v64 - p17.v) * math.min(1, p18 / BoneSwim.V_TAU)
                end
            end

            p17.lastPos = _CFrame.Position

            local v67 = _CFrame:VectorToWorldSpace(p17.noseM)
            local v68 = Vector3.new(v67.X, 0, v67.Z)

            if v68.Magnitude > 1E-04 then
                local Unit = v68.Unit

                if p17.lastFlat and p18 > 1E-04 then
                    local v70 = math.atan2(p17.lastFlat:Cross(Unit).Y, (p17.lastFlat:Dot(Unit))) / p18

                    p17.turn = p17.turn + (math.clamp(v70 / BoneSwim.TURN_FULL, -1, 1) - p17.turn) * math.min(1, p18 / BoneSwim.TURN_TAU)
                end

                p17.lastFlat = Unit
            end

            local v74 = if fightHooked(model) then BoneSwim.HOOK_HZ else math.min(BoneSwim.MAX_HZ, (math.max(p17.v / (BoneSwim.STRIDE * math.max(p17.length, 0.001)), BoneSwim.MIN_HZ)))

            p17.phase = (p17.phase + p18 * v74) % 1
            p17.t += p18

            local v77 = p17.t - p17.biteAt

            if BoneSwim.WIND_T + BoneSwim.SNAP_T + BoneSwim.HOLD_T + BoneSwim.BOUNCE_T + BoneSwim.SNAP2_T + BoneSwim.OPEN_T < v77 then
                v77 = -1
                p17.biteAt = p17.t + BoneSwim.BITE_EVERY[1] + math.random() * (BoneSwim.BITE_EVERY[2] - BoneSwim.BITE_EVERY[1])
            end

            for v78, v79 in pairs(BoneSwim.pose(p17.phase, p17.turn, BoneSwim.effort(v74), p17.t, v77)) do
                local v80 = p17.A[v78]
                local v81 = CFrame.identity

                for _, v82 in ipairs(v79) do
                    v81 *= CFrame.fromAxisAngle(v80[v82[1]], v82[2])
                end

                v80.bone.Transform = v81
            end
        end
    }
end
