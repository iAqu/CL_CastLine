-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked = p2.fightHooked

    p1.OctoCrawl = {
        N_ARM = 8,
        SEGS = 3,
        DUTY = 0.6,
        STRIDE = 0.35,
        SWEEP = 0.28,
        LIFT = 0.22,
        CURL = 0.3,
        LAG = 0.12,
        REACH_GAIN = 0.4,
        PUSH_GAIN = 0.3,
        IDLE = 0.06,
        IDLE_RATE = 0.9,
        MOVING = 0.15,
        WALK_TAU = 0.25,
        VEL_TAU = 0.15,
        HOOK_RATE = 3,
        HOOK_SPIN = 2,
        OFFSET = { 0, 0.55, 0.2, 0.75, 0.4, 0.95, 0.15, 0.65 },
        arm = function(p3, p4, p5, p6, p7, p8) -- arm | line: 23
            -- upvalues: p1 (copy)
            local OctoCrawl = p1.OctoCrawl
            local t2 = {}

            for i = 1, OctoCrawl.SEGS do
                local v1 = (p4 - OctoCrawl.LAG * (i - 1)) % 1
                local v2, v3, v4

                if v1 < OctoCrawl.DUTY then
                    local v5 = v1 / OctoCrawl.DUTY

                    v2 = OctoCrawl.SWEEP * p6 * (1 - 2 * v5) * (1 + OctoCrawl.PUSH_GAIN * math.max(0, -p5))
                    v4 = 0
                    v3 = OctoCrawl.CURL * math.sin(3.141592653589793 * v5)
                else
                    local v9 = (v1 - OctoCrawl.DUTY) / (1 - OctoCrawl.DUTY)

                    v2 = OctoCrawl.SWEEP * p6 * (2 * v9 - 1) * (1 + OctoCrawl.REACH_GAIN * math.max(0, p5))
                    v4 = OctoCrawl.LIFT * math.sin(3.141592653589793 * v9)
                    v3 = -0.5 * OctoCrawl.CURL * math.sin(3.141592653589793 * v9)
                end

                local v14 = OctoCrawl.IDLE * math.sin(OctoCrawl.IDLE_RATE * p8 + 1.7 * p3 + i * 0.9)
                local t3 = {
                    {
                        "sweep",
                        p7 * v2 / OctoCrawl.SEGS
                    },
                    {
                        "curl",
                        p7 * v3 / OctoCrawl.SEGS + (1 - p7) * v14
                    }
                }

                if i == 1 then
                    table.insert(t3, {
                        "lift",
                        p7 * v4
                    })
                end

                t2[i] = t3
            end

            return t2
        end,
        pose = function(p9, p10, p11, p12, p13) -- pose | line: 47
            -- upvalues: p1 (copy)
            local OctoCrawl = p1.OctoCrawl
            local t5 = {}

            for i = 1, OctoCrawl.N_ARM do
                local v15 = p13[i] - p10
                local v16 = (p9 + OctoCrawl.OFFSET[i]) % 1

                for v17, v18 in ipairs(OctoCrawl.arm(i, v16, math.cos(v15), -math.sin(v15), p11, p12)) do
                    t5["Arm_" .. i .. "_" .. v17] = v18
                end
            end

            return t5
        end,
        register = function(p14) -- register | line: 59
            -- upvalues: p1 (copy)
            local OctoCrawl, StrokeClock = p1.OctoCrawl, p1.StrokeClock
            local v19 = StrokeClock.setup(p14, { "Body", "Arm_1_1", "Arm_8_1" })

            if not v19 then
                return nil
            end

            local mcf, nose, up, right = v19.mcf, v19.nose, v19.up, v19.right
            local v20 = mcf:PointToObjectSpace(v19.bones.Body.WorldPosition)

            local function flat(p15) -- line: 66
                -- upvalues: up (copy)
                return p15 - up * p15:Dot(up)
            end

            local function ang(p16) -- line: 67
                -- upvalues: nose (copy), right (copy)
                return (math.atan2(p16:Dot(right), (p16:Dot(nose))))
            end

            local t6 = {}

            v19.armAng = {}
            v19.A = t6

            for i = 1, OctoCrawl.N_ARM do
                local t7 = {}

                for j = 1, OctoCrawl.SEGS do
                    local v23 = v19.bones["Arm_" .. i .. "_" .. j]

                    t7[j] = v23 and mcf:PointToObjectSpace(v23.WorldPosition)
                end

                local v24 = t7[1] or v20
                local armAng = v19.armAng
                local v25 = v24 - v20
                local v26 = v25 - up * v25:Dot(up)

                armAng[i] = math.atan2(v26:Dot(right), (v26:Dot(nose)))

                for k = 1, OctoCrawl.SEGS do
                    local v29 = v19.bones["Arm_" .. i .. "_" .. k]

                    if v29 then
                        local v30 = t7[k]
                        local v31 = t7[k + 1]

                        if not v31 then
                            v30 = t7[k - 1] or v20
                            v31 = t7[k]
                        end

                        local v32 = v31 - v30
                        local v33 = v32 - up * v32:Dot(up)

                        if v33.Magnitude < 1E-04 then
                            local v34 = v24 - v20

                            v33 = v34 - up * v34:Dot(up)
                        end

                        local Unit = v33.Unit:Cross(up).Unit

                        v19.A["Arm_" .. i .. "_" .. k] = {
                            bone = v29,
                            lift = StrokeClock.axis(v19, v29, Unit),
                            curl = StrokeClock.axis(v19, v29, -Unit),
                            sweep = StrokeClock.axis(v19, v29, -up)
                        }
                    end
                end
            end

            local v35 = math.random()

            v19.vel = Vector3.new(0, 0, 0)
            v19.walk = 0
            v19.cyc = v35

            return v19
        end,
        update = function(p17, p18, _) -- update | line: 93
            -- upvalues: p1 (copy), fightHooked (copy)
            local OctoCrawl = p1.OctoCrawl
            local _CFrame = p17.mesh.CFrame
            local v36 = if p17.lastPos and p18 > 1E-04 and (_CFrame.Position - p17.lastPos).Magnitude < 20 then _CFrame:VectorToObjectSpace((_CFrame.Position - p17.lastPos) / p18) else Vector3.new(0, 0, 0)

            p17.lastPos = _CFrame.Position

            local v37 = v36 - p17.up * v36:Dot(p17.up)

            p17.vel = p17.vel:Lerp(v37, (math.min(1, p18 / OctoCrawl.VEL_TAU)))

            local Magnitude = p17.vel.Magnitude
            local v39 = OctoCrawl.MOVING < Magnitude

            if v39 then
                p17.travel = math.atan2(p17.vel:Dot(p17.right), (p17.vel:Dot(p17.nose)))
            end

            p17.walk = p17.walk + ((if v39 then 1 else 0) - p17.walk) * math.min(1, p18 / OctoCrawl.WALK_TAU)
            p17.cyc = (p17.cyc + Magnitude * p18 / (OctoCrawl.STRIDE * p17.length)) % 1
            p17.fin += p18

            local walk2 = p17.walk
            local v44 = p17.travel or 0
            local cyc = p17.cyc

            if fightHooked(p17.model) then
                p17.cyc = (p17.cyc + p18 * OctoCrawl.HOOK_RATE) % 1
                walk2 = 1
                v44 = p17.fin * OctoCrawl.HOOK_SPIN
                cyc = p17.cyc
            end

            for v45, v46 in pairs(OctoCrawl.pose(cyc, v44, walk2, p17.fin, p17.armAng)) do
                local v47 = p17.A[v45]

                if v47 then
                    local v48 = CFrame.identity

                    for _, v49 in ipairs(v46) do
                        v48 *= CFrame.fromAxisAngle(v47[v49[1]], v49[2])
                    end

                    v47.bone.Transform = v48
                end
            end
        end
    }
end
