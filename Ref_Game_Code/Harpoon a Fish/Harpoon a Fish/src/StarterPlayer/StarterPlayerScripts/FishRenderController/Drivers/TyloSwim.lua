-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 20
    local fightHooked, attr = p2.fightHooked, p2.attr

    local function ss(p3) -- line: 24
        local v1 = math.clamp(p3, 0, 1)

        return v1 * v1 * (3 - 2 * v1)
    end

    p1.TyloSwim = {
        WAVE = {
            { "Chest", 0.034 },
            { "Belly", 0.06 },
            { "Pelvis", 0.102 },
            { "Tail_1", 0.145 },
            { "Tail_2", 0.179 },
            { "Tail_3", 0.213 },
            { "Tail_4", 0.238 },
            { "Tail_5", 0.255 }
        },
        LAG = 0.7,
        BEND = 0.1,
        HEAD_STEADY = 0.75,
        LOOK = 0.2,
        NOD = 0.015,
        FORE_PH = 0,
        HIND_PH = 0.25,
        SWEEP = 0.2,
        LIFT = 0.16,
        FEATHER = 0.22,
        TIP_SW = 0.08,
        TIP_LIFT = 0.14,
        TIP_LAG = 0.9,
        HIND_GAIN = 0.65,
        IDLE = 0.35,
        RUDDER_DROP = 0.22,
        RUDDER_FWD = 0.12,
        TUCK = 0.18,
        BREATH = 0.035,
        BREATH_HZ = 0.35,
        WIND_T = 0.3,
        SNAP_T = 0.1,
        HOLD_T = 0.1,
        OPEN_T = 0.55,
        GAPE = 0.1,
        SHUT = 0.34,
        HEAD_LIFT = 0.06,
        HEAD_DIP = 0.035,
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
        bite = function(p4) -- bite | line: 51
            -- upvalues: p1 (copy)
            local TyloSwim = p1.TyloSwim

            if p4 < 0 then
                return 0, 0
            end

            if p4 < TyloSwim.WIND_T then
                local v3 = math.clamp(p4 / TyloSwim.WIND_T, 0, 1)
                local v4 = v3 * v3 * (3 - 2 * v3)

                return -TyloSwim.GAPE * v4, TyloSwim.HEAD_LIFT * v4
            end

            local v5 = p4 - TyloSwim.WIND_T

            if v5 < TyloSwim.SNAP_T then
                local v7 = math.clamp(v5 / TyloSwim.SNAP_T, 0, 1)
                local v8 = v7 * v7 * (3 - 2 * v7)

                return -TyloSwim.GAPE + (TyloSwim.GAPE + TyloSwim.SHUT) * v8, TyloSwim.HEAD_LIFT - (TyloSwim.HEAD_LIFT + TyloSwim.HEAD_DIP) * v8
            end

            local v9 = v5 - TyloSwim.SNAP_T

            if v9 < TyloSwim.HOLD_T then
                return TyloSwim.SHUT, -TyloSwim.HEAD_DIP
            end

            local v10 = v9 - TyloSwim.HOLD_T

            if v10 < TyloSwim.OPEN_T then
                local v12 = math.clamp(v10 / TyloSwim.OPEN_T, 0, 1)
                local v13 = v12 * v12 * (3 - 2 * v12)

                return TyloSwim.SHUT * (1 - v13), -TyloSwim.HEAD_DIP * (1 - v13)
            end

            return 0, 0
        end,
        effort = function(p5) -- effort | line: 73
            -- upvalues: p1 (copy)
            local TyloSwim = p1.TyloSwim

            return (math.min(TyloSwim.M_MAX, (math.max(TyloSwim.M_MIN, p5 / TyloSwim.CRUISE_HZ))))
        end,
        flipper = function(p6, p7, p8, p9, p10) -- flipper | line: 79
            -- upvalues: p1 (copy)
            local TyloSwim = p1.TyloSwim
            local v16 = p9 * (TyloSwim.IDLE + (1 - TyloSwim.IDLE) * p10)
            local v17 = p7 * p8
            local v18 = if not (v17 > 0) or not v17 then 0 else v17
            local v19 = v17 < 0 and -v17 or 0
            local v20 = p7 * (TyloSwim.SWEEP * v16 * math.cos(p6) - TyloSwim.RUDDER_FWD * p9 * v18 + TyloSwim.TUCK * p9 * v19)
            local v21 = TyloSwim.LIFT * v16 * math.sin(p6) - TyloSwim.RUDDER_DROP * p9 * v18
            local v22 = -p7 * TyloSwim.FEATHER * v16 * math.cos(p6)
            local v23 = p6 - TyloSwim.TIP_LAG

            return {
                { "up", v20 },
                { "lift", v21 },
                { "Y", v22 }
            }, {
                {
                    "up",
                    p7 * TyloSwim.TIP_SW * v16 * math.cos(v23)
                },
                {
                    "lift",
                    TyloSwim.TIP_LIFT * v16 * math.sin(v23)
                }
            }
        end,
        pose = function(p11, p12, p13, p14, p15) -- pose | line: 94
            -- upvalues: p1 (copy)
            local TyloSwim = p1.TyloSwim
            local v24 = 6.283185307179586 * p11
            local t2 = {}
            local n1 = 0

            for v25, v26 in ipairs(TyloSwim.WAVE) do
                local v29 = v26[2] * p13 * math.sin(v24 - (v25 - 1) * TyloSwim.LAG)

                if v26[1] == "Chest" then
                    n1 = v29
                    t2.Chest = { { "up", v29 } }
                else
                    t2[v26[1]] = {
                        {
                            "up",
                            v29 - TyloSwim.BEND * p12 / 4
                        }
                    }
                end
            end

            local v30, v31 = TyloSwim.bite(p15)

            t2.Neck = {
                {
                    "up",
                    -TyloSwim.HEAD_STEADY * n1 + 0.4 * TyloSwim.LOOK * p12
                },
                {
                    "lat",
                    TyloSwim.NOD * math.sin(2 * v24) + 0.5 * v31
                }
            }
            t2.Head = {
                {
                    "up",
                    0.6 * TyloSwim.LOOK * p12
                },
                {
                    "lat",
                    0.5 * v31
                }
            }
            t2.Jaw = {
                {
                    "lat",
                    v30 + TyloSwim.BREATH * math.sin(6.283185307179586 * TyloSwim.BREATH_HZ * p14)
                }
            }

            for _, v34 in ipairs({ "L", "R" }) do
                local v35 = if v34 == "L" then 1 else -1
                local v36 = if v35 > 0 then 0 else 0.5
                local v37, v38 = TyloSwim.flipper(6.283185307179586 * (p11 - TyloSwim.FORE_PH - v36), v35, p12, 1, p13)
                local v39 = "Fore_" .. v34 .. "_1"
                local v40 = "Fore_" .. v34 .. "_2"

                t2[v39] = v37
                t2[v40] = v38

                local v41, v42 = TyloSwim.flipper(6.283185307179586 * (p11 - TyloSwim.HIND_PH - v36), v35, p12, TyloSwim.HIND_GAIN, p13)
                local v43 = "Hind_" .. v34 .. "_1"
                local v44 = "Hind_" .. v34 .. "_2"

                t2[v43] = v41
                t2[v44] = v42
            end

            return t2
        end,
        register = function(p16) -- register | line: 123
            -- upvalues: p1 (copy), attr (copy)
            local TyloSwim = p1.TyloSwim
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

            for _, v45 in ipairs(TyloSwim.BONES) do
                if not t4[v45] then
                    return nil
                end
            end

            local CFrame = MeshPart.CFrame
            local v46 = p16:GetPivot() * AnatomyInverse:Inverse()
            local v47 = CFrame:VectorToObjectSpace(v46.RightVector)
            local v48 = CFrame:VectorToObjectSpace(v46.UpVector)
            local v49 = -v48:Cross(v47).Unit
            local Size = MeshPart.Size
            local v52 = math.abs(v47.X) * Size.X + math.abs(v47.Y) * Size.Y + math.abs(v47.Z) * Size.Z
            local t5 = {}

            for _, v53 in ipairs(TyloSwim.BONES) do
                local v54 = CFrame:ToObjectSpace(t4[v53].WorldCFrame)
                local v55 = v54:VectorToWorldSpace((Vector3.new(0, 1, 0))):Cross(v48)
                local v56 = v55.Magnitude > 1E-06 and v55.Unit or v49

                t5[v53] = {
                    Y = Vector3.new(0, 1, 0),
                    bone = t4[v53],
                    nose = v54:VectorToObjectSpace(v47),
                    up = v54:VectorToObjectSpace(v48),
                    lat = v54:VectorToObjectSpace(v49),
                    lift = v54:VectorToObjectSpace(v56)
                }
            end

            return {
                turn = 0,
                v = 0,
                model = p16,
                mesh = MeshPart,
                A = t5,
                noseM = v47,
                phase = math.random(),
                length = v52,
                t = math.random() * 10,
                biteAt = math.random() * TyloSwim.BITE_EVERY[2]
            }
        end,
        update = function(p17, p18) -- update | line: 157
            -- upvalues: p1 (copy), fightHooked (copy)
            local TyloSwim = p1.TyloSwim
            local model = p17.model
            local _CFrame = p17.mesh.CFrame

            if p17.lastPos and p18 > 1E-04 then
                local v57 = (_CFrame.Position - p17.lastPos).Magnitude / p18

                if v57 < 2000 then
                    p17.v = p17.v + (v57 - p17.v) * math.min(1, p18 / TyloSwim.V_TAU)
                end
            end

            p17.lastPos = _CFrame.Position

            local v60 = _CFrame:VectorToWorldSpace(p17.noseM)
            local v61 = Vector3.new(v60.X, 0, v60.Z)

            if v61.Magnitude > 1E-04 then
                local Unit = v61.Unit

                if p17.lastFlat and p18 > 1E-04 then
                    local v63 = math.atan2(p17.lastFlat:Cross(Unit).Y, (p17.lastFlat:Dot(Unit))) / p18

                    p17.turn = p17.turn + (math.clamp(v63 / TyloSwim.TURN_FULL, -1, 1) - p17.turn) * math.min(1, p18 / TyloSwim.TURN_TAU)
                end

                p17.lastFlat = Unit
            end

            local v67 = if fightHooked(model) then TyloSwim.HOOK_HZ else math.min(TyloSwim.MAX_HZ, (math.max(p17.v / (TyloSwim.STRIDE * math.max(p17.length, 0.001)), TyloSwim.MIN_HZ)))

            p17.phase = (p17.phase + p18 * v67) % 1
            p17.t += p18

            local v70 = p17.t - p17.biteAt

            if TyloSwim.WIND_T + TyloSwim.SNAP_T + TyloSwim.HOLD_T + TyloSwim.OPEN_T < v70 then
                v70 = -1
                p17.biteAt = p17.t + TyloSwim.BITE_EVERY[1] + math.random() * (TyloSwim.BITE_EVERY[2] - TyloSwim.BITE_EVERY[1])
            end

            for v71, v72 in pairs(TyloSwim.pose(p17.phase, p17.turn, TyloSwim.effort(v67), p17.t, v70)) do
                local v73 = p17.A[v71]
                local v74 = CFrame.identity

                for _, v75 in ipairs(v72) do
                    v74 *= CFrame.fromAxisAngle(v73[v75[1]], v75[2])
                end

                v73.bone.Transform = v74
            end
        end
    }
end
