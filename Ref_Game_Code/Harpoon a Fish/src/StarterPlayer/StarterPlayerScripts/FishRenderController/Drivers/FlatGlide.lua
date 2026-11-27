-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 3
    local fightHooked = p2.fightHooked

    p1.FlatGlide = {
        IDLE_HZ = 0.45,
        STRIDE = 0.12,
        RIM_A = 0.34,
        RIM_IDLE = 0.12,
        RIM_WAVES = 1.5,
        PERI_A = 0.014,
        PERI_WAVES = 1,
        HUMP = 0.012,
        TURN_BEND = 0.07,
        W_FULL = 0.45,
        HOOK_HZ = 2.5,
        MOVING = 0.15,
        WALK_TAU = 0.25,
        VEL_TAU = 0.15,
        W_TAU = 0.2,
        rate = function(p3, p4, p5) -- rate | line: 24
            -- upvalues: p1 (copy)
            local FlatGlide = p1.FlatGlide

            return FlatGlide.IDLE_HZ * (1 - p4) + p4 * math.max(FlatGlide.IDLE_HZ, p3 / (FlatGlide.STRIDE * p5))
        end,
        pose = function(p6, p7, p8, p9) -- pose | line: 29
            -- upvalues: p1 (copy)
            local FlatGlide = p1.FlatGlide
            local length = p6.length
            local v3 = FlatGlide.RIM_IDLE + (FlatGlide.RIM_A - FlatGlide.RIM_IDLE) * p8
            local n1 = 0
            local n2 = 0

            for v4, v5 in ipairs(p6.glide) do
                local v6 = 6.283185307179586 * (p7 - FlatGlide.PERI_WAVES * v5.s)
                local v7 = FlatGlide.PERI_A * length * p8 * math.sin(v6)
                local v8 = FlatGlide.HUMP * length * p8 * (math.cos(v6) * 0.5 + 0.5) ^ 2
                local v9 = v5.back * (v7 - n1) + v5.up * (v8 - n2)

                n2 = v8
                v5.spine.Transform = v4 > 1 and CFrame.new(v9) * CFrame.fromAxisAngle(v5.yaw, FlatGlide.TURN_BEND * p9) or CFrame.new(v9)

                local v11 = v3 * (0.5 - math.cos(6.283185307179586 * (p7 - FlatGlide.RIM_WAVES * v5.s)) * 0.5)

                if v5.edgeL then
                    v5.edgeL.Transform = CFrame.fromAxisAngle(v5.axL, v11)
                end

                if v5.edgeR then
                    v5.edgeR.Transform = CFrame.fromAxisAngle(v5.axR, -v11)
                end

                n1 = v7
            end
        end,
        register = function(p10) -- register | line: 47
            -- upvalues: p1 (copy)
            local StrokeClock = p1.StrokeClock
            local v12 = StrokeClock.setup(p10, { "Spine_01", "Spine_02", "EdgeL_1", "EdgeR_1" })

            if not v12 then
                return nil
            end

            local length = v12.length
            local t2 = {}
            local t3 = {}

            while v12.bones[("Spine_%02d"):format(#t3 + 1)] do
                local v13 = v12.bones[("Spine_%02d"):format(#t3 + 1)]

                t3[#t3 + 1] = v13
                t2[#t2 + 1] = 0.5 - v12.mcf:PointToObjectSpace(v13.WorldPosition):Dot(v12.nose) / length
            end

            t2[#t2 + 1] = 1

            local t4 = {}

            for v14, v15 in ipairs(t3) do
                local v16 = v12.bones["EdgeL_" .. v14]
                local v17 = v12.bones["EdgeR_" .. v14]

                t4[v14] = {
                    spine = v15,
                    s = (t2[v14] + t2[v14 + 1]) / 2,
                    back = StrokeClock.axis(v12, v15, -v12.nose),
                    up = StrokeClock.axis(v12, v15, v12.up),
                    yaw = StrokeClock.axis(v12, v15, v12.up),
                    edgeL = v16,
                    edgeR = v17,
                    axL = v16 and StrokeClock.axis(v12, v16, v12.nose),
                    axR = v17 and StrokeClock.axis(v12, v17, v12.nose)
                }
            end

            v12.glide = t4
            v12.crawl = {
                walk = 0,
                vel = Vector3.new(0, 0, 0),
                wv = 0,
                phase = math.random()
            }

            return v12
        end,
        update = function(p11, p12) -- update | line: 74
            -- upvalues: p1 (copy), fightHooked (copy)
            local FlatGlide = p1.FlatGlide
            local crawl = p11.crawl
            local CFrame = p11.mesh.CFrame

            if fightHooked(p11.model) then
                crawl.walk = 1
                crawl.phase = (crawl.phase + p12 * FlatGlide.HOOK_HZ) % 1
                crawl.lastPos = nil
                crawl.lastNose = nil
                FlatGlide.pose(p11, crawl.phase, 1, 0)
            else
                local v18 = CFrame:VectorToWorldSpace(p11.up)
                local v19 = CFrame:VectorToWorldSpace(p11.nose)
                local v20 = v19 - v18 * v19:Dot(v18)
                local v21, v22

                if crawl.lastPos and p12 > 1E-04 and (CFrame.Position - crawl.lastPos).Magnitude < 20 then
                    v21 = CFrame:VectorToObjectSpace((CFrame.Position - crawl.lastPos) / p12)

                    if crawl.lastNose and v20.Magnitude > 0.001 then
                        local lastNose = crawl.lastNose
                        local Unit = v20.Unit

                        v22 = math.atan2(lastNose:Cross(Unit):Dot(v18), (lastNose:Dot(Unit))) / p12
                    else
                        v22 = 0
                    end
                else
                    v21 = Vector3.new(0, 0, 0)
                    v22 = 0
                end

                crawl.lastPos = CFrame.Position

                if v20.Magnitude > 0.001 then
                    crawl.lastNose = v20.Unit
                end

                local v25 = v21 - p11.up * v21:Dot(p11.up)

                crawl.vel = crawl.vel:Lerp(v25, (math.min(1, p12 / FlatGlide.VEL_TAU)))

                local Magnitude = crawl.vel.Magnitude

                crawl.walk = crawl.walk + ((if FlatGlide.MOVING < Magnitude then 1 else 0) - crawl.walk) * math.min(1, p12 / FlatGlide.WALK_TAU)
                crawl.wv = crawl.wv + (v22 - crawl.wv) * math.min(1, p12 / FlatGlide.W_TAU)
                crawl.phase = (crawl.phase + FlatGlide.rate(Magnitude, crawl.walk, p11.length) * p12) % 1
                FlatGlide.pose(p11, crawl.phase, crawl.walk, (math.clamp(crawl.wv / FlatGlide.W_FULL, -1, 1)))
            end
        end
    }
end
