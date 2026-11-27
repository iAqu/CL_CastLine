-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 22
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.ChicxSwim = {
        ROLL_A = 0.22,
        WOB_Y = 0.02,
        WOB_P = 0.02,
        WOB_LAG = 0.7,
        REAR_ROLL = 0.4,
        FLAME = {
            { "Rear", 0.03, 0.02 },
            { "Flame_1", 0.08, 0.04 },
            { "Flame_2", 0.12, 0.06 },
            { "Flame_3", 0.16, 0.08 },
            { "Flame_4", 0.2, 0.1 },
            { "Flame_5", 0.24, 0.12 }
        },
        LAG = 0.7,
        LAG_P = 0.9,
        RAM_FLAME = 0.6,
        RUDDER = 0.1,
        ROCK_SPIN = 0.25,
        RAM_HEAD = 0.05,
        DART_E0 = 0.75,
        DART_E1 = 1.5,
        BITE = 0.4,
        BITE_R = 0.5,
        CLOSE_T = 0.12,
        HOLD_T = 0.15,
        OPEN_T = 0.35,
        STRIDE = 0.6,
        MIN_HZ = 1.6,
        MAX_HZ = 4,
        HOOK_HZ = 3,
        TUMBLE_HZ = 0.35,
        TURN_FULL = 0.6,
        TURN_TAU = 0.3,
        V_TAU = 0.3,
        BONES = {
            "Body",
            "Rear",
            "Flame_1",
            "Flame_2",
            "Flame_3",
            "Flame_4",
            "Flame_5",
            "Jaw",
            "Rock_1",
            "Rock_2"
        },
        ss = function(p3) -- ss | line: 41
            local v1 = math.clamp(p3, 0, 1)

            return v1 * v1 * (3 - 2 * v1)
        end,
        dartOf = function(p4) -- dartOf | line: 45
            -- upvalues: p1 (copy)
            local ChicxSwim = p1.ChicxSwim

            return ChicxSwim.ss((p4 - ChicxSwim.DART_E0) / (ChicxSwim.DART_E1 - ChicxSwim.DART_E0))
        end,
        biteEnv = function(p5) -- biteEnv | line: 50
            -- upvalues: p1 (copy)
            local ChicxSwim = p1.ChicxSwim

            if p5 == nil then
                return 0
            end

            return ChicxSwim.ss(p5 / ChicxSwim.CLOSE_T) * (1 - ChicxSwim.ss((p5 - ChicxSwim.CLOSE_T - ChicxSwim.HOLD_T) / ChicxSwim.OPEN_T))
        end,
        body = function(p6, p7, p8, p9, p10) -- body | line: 56
            -- upvalues: p1 (copy)
            local ChicxSwim = p1.ChicxSwim
            local v2 = 6.283185307179586 * p6
            local v3 = 6.283185307179586 * p7
            local v4 = ChicxSwim.ROLL_A * math.sin(v3)
            local t2 = {
                Body = {
                    {
                        "nose",
                        v4
                    },
                    {
                        "up",
                        ChicxSwim.WOB_Y * math.sin(v3 + ChicxSwim.WOB_LAG)
                    },
                    {
                        "lat",
                        ChicxSwim.WOB_P * math.sin(2 * v3 - ChicxSwim.WOB_LAG) - ChicxSwim.RAM_HEAD * p9
                    }
                }
            }

            for v7, v8 in ipairs(ChicxSwim.FLAME) do
                local v9 = v7 - 1
                local t6 = {
                    {
                        "up",
                        v8[2] * (1 + ChicxSwim.RAM_FLAME * p9) * math.sin(v2 - v9 * ChicxSwim.LAG) + ChicxSwim.RUDDER * p8 / 6
                    },
                    {
                        "lat",
                        v8[3] * (1 + ChicxSwim.RAM_FLAME * p9) * math.sin(2 * v2 - v9 * ChicxSwim.LAG_P)
                    }
                }

                if v8[1] == "Rear" then
                    table.insert(t6, 1, {
                        "nose",
                        -ChicxSwim.REAR_ROLL * v4
                    })
                end

                t2[v8[1]] = t6
            end

            for v14, v15 in ipairs({ "Rock_1", "Rock_2" }) do
                local v16 = v14 - 1

                t2[v15] = {
                    {
                        "up",
                        ChicxSwim.ROCK_SPIN * math.sin(v3 + v16)
                    },
                    {
                        "lat",
                        ChicxSwim.ROCK_SPIN * math.cos(v3 + v16)
                    }
                }
            end

            t2.Jaw = {
                {
                    "lat",
                    ChicxSwim.BITE * p10
                }
            }

            return t2
        end,
        register = function(p11) -- register | line: 77
            -- upvalues: p1 (copy), attr (copy)
            local ChicxSwim = p1.ChicxSwim
            local MeshPart = p11:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p11, "AnatomyInverse")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local t9 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t9[descendant.Name] = descendant
                end
            end

            for _, v19 in ipairs(ChicxSwim.BONES) do
                if not t9[v19] then
                    return nil
                end
            end

            local CFrame = MeshPart.CFrame
            local v20 = p11:GetPivot() * AnatomyInverse:Inverse()
            local v21 = CFrame:VectorToObjectSpace(v20.RightVector)
            local v22 = CFrame:VectorToObjectSpace(v20.UpVector)
            local v23 = -v22:Cross(v21).Unit
            local Size = MeshPart.Size
            local v26 = math.abs(v21.X) * Size.X + math.abs(v21.Y) * Size.Y + math.abs(v21.Z) * Size.Z
            local t10 = {}

            for _, v27 in ipairs(ChicxSwim.BONES) do
                local v28 = CFrame:ToObjectSpace(t9[v27].WorldCFrame)

                t10[v27] = {
                    bone = t9[v27],
                    nose = v28:VectorToObjectSpace(v21),
                    up = v28:VectorToObjectSpace(v22),
                    lat = v28:VectorToObjectSpace(v23)
                }
            end

            return {
                turn = 0,
                v = 0,
                t = 0,
                armed = true,
                biteT0 = nil,
                model = p11,
                mesh = MeshPart,
                A = t10,
                noseM = v21,
                phase = math.random(),
                tumble = math.random(),
                length = v26
            }
        end,
        update = function(p12, p13) -- update | line: 107
            -- upvalues: p1 (copy), fightHooked (copy)
            local ChicxSwim = p1.ChicxSwim
            local model = p12.model
            local _CFrame = p12.mesh.CFrame

            p12.t += p13

            if p12.lastPos and p13 > 1E-04 then
                local v29 = (_CFrame.Position - p12.lastPos).Magnitude / p13

                if v29 < 2000 then
                    p12.v = p12.v + (v29 - p12.v) * math.min(1, p13 / ChicxSwim.V_TAU)
                end
            end

            p12.lastPos = _CFrame.Position

            local v32 = _CFrame:VectorToWorldSpace(p12.noseM)
            local v33 = Vector3.new(v32.X, 0, v32.Z)

            if v33.Magnitude > 1E-04 then
                local Unit = v33.Unit

                if p12.lastFlat and p13 > 1E-04 then
                    local v35 = math.atan2(p12.lastFlat:Cross(Unit).Y, (p12.lastFlat:Dot(Unit))) / p13

                    p12.turn = p12.turn + (math.clamp(v35 / ChicxSwim.TURN_FULL, -1, 1) - p12.turn) * math.min(1, p13 / ChicxSwim.TURN_TAU)
                end

                p12.lastFlat = Unit
            end

            local v39 = math.max(p12.length, 0.001)
            local v40 = if fightHooked(model) then ChicxSwim.HOOK_HZ else math.clamp(p12.v / (ChicxSwim.STRIDE * v39), ChicxSwim.MIN_HZ, ChicxSwim.MAX_HZ)
            local v42 = ChicxSwim.dartOf(p12.v / v39)

            if p12.armed and ChicxSwim.BITE_R < v42 then
                p12.biteT0 = p12.t
                p12.armed = false
            elseif not p12.armed and v42 < ChicxSwim.BITE_R / 2 then
                p12.armed = true
            end

            local v43 = ChicxSwim.biteEnv(p12.biteT0 and p12.t - p12.biteT0 or nil)

            p12.phase = (p12.phase + p13 * v40) % 1
            p12.tumble = (p12.tumble + p13 * ChicxSwim.TUMBLE_HZ) % 1

            for v44, v45 in pairs(ChicxSwim.body(p12.phase, p12.tumble, p12.turn, v42, v43)) do
                local v46 = p12.A[v44]
                local v47 = CFrame.identity

                for _, v48 in ipairs(v45) do
                    v47 *= CFrame.fromAxisAngle(v46[v48[1]], v48[2])
                end

                v46.bone.Transform = v47
            end
        end
    }
end
