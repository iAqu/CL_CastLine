-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 15
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.ChainPulse = {
        CONTRACT = 0.3,
        RIM_IN = 0.65,
        LAG = 0.09,
        SYNC = 0.85,
        JET = 0.006,
        MIN_PULSE = 0.35,
        SWAY = 0.05,
        SWAY_HZ = 0.4,
        SWAY_LAG = 0.6,
        TURN_BEND = 0.05,
        STRIDE = 0.75,
        MIN_HZ = 0.5,
        MAX_HZ = 2.2,
        SURGE_SPAN = 0.6,
        HOOK_HZ = 2.5,
        V_TAU = 0.3,
        W_TAU = 0.3,
        W_FULL = 0.45,
        smooth = function(p3) -- smooth | line: 22
            local v1 = math.clamp(p3, 0, 1)

            return v1 * v1 * (3 - 2 * v1)
        end,
        contract = function(p4) -- contract | line: 26
            -- upvalues: p1 (copy)
            local ChainPulse = p1.ChainPulse
            local v2 = (p4 + ChainPulse.CONTRACT / 2) % 1

            if v2 < ChainPulse.CONTRACT then
                return ChainPulse.smooth(v2 / ChainPulse.CONTRACT)
            end

            return 1 - ChainPulse.smooth((v2 - ChainPulse.CONTRACT) / (1 - ChainPulse.CONTRACT))
        end,
        rate = function(p5, p6) -- rate | line: 34
            -- upvalues: p1 (copy)
            local ChainPulse = p1.ChainPulse

            return (math.min(ChainPulse.MAX_HZ, (math.max(ChainPulse.MIN_HZ, p5 / (ChainPulse.STRIDE * p6)))))
        end,
        pose = function(p7, p8, p9, p10, p11, p12) -- pose | line: 39
            -- upvalues: p1 (copy)
            local ChainPulse = p1.ChainPulse
            local length = p7.length
            local v5 = ChainPulse.MIN_PULSE + (1 - ChainPulse.MIN_PULSE) * math.clamp(p10, 0, 1)
            local v6 = ChainPulse.LAG * (1 - ChainPulse.SYNC * p11)
            local n1 = 0

            for v7, v8 in ipairs(p7.bells) do
                local v9 = ChainPulse.contract(p8 - (v7 - 1) * v6)
                local v10 = -ChainPulse.JET * length * v5 * v9
                local v11 = v8.back * (v10 - n1)

                n1 = v10

                if v7 > 1 then
                    v8.bone.Transform = CFrame.new(v11) * CFrame.fromAxisAngle(v8.yaw, ChainPulse.SWAY * math.sin(6.283185307179586 * ChainPulse.SWAY_HZ * p9 - v7 * ChainPulse.SWAY_LAG) + ChainPulse.TURN_BEND * p12)
                else
                    v8.bone.Transform = CFrame.new(v11)
                end

                local v14 = v5 * ChainPulse.RIM_IN * v9

                if v8.rimL then
                    v8.rimL.Transform = CFrame.fromAxisAngle(v8.axL, v14)
                end

                if v8.rimR then
                    v8.rimR.Transform = CFrame.fromAxisAngle(v8.axR, -v14)
                end
            end
        end,
        register = function(p13) -- register | line: 60
            -- upvalues: p1 (copy)
            local StrokeClock = p1.StrokeClock
            local v15 = StrokeClock.setup(p13, { "Bell_01", "Bell_02", "RimL_1", "RimR_1" })

            if not v15 then
                return nil
            end

            local t2 = {}

            while v15.bones[("Bell_%02d"):format(#t2 + 1)] do
                local v16 = #t2 + 1
                local v17 = v15.bones[("Bell_%02d"):format(v16)]
                local v18 = v15.bones["RimL_" .. v16]
                local v19 = v15.bones["RimR_" .. v16]

                t2[v16] = {
                    bone = v17,
                    back = StrokeClock.axis(v15, v17, -v15.nose),
                    yaw = StrokeClock.axis(v15, v17, v15.up),
                    rimL = v18,
                    rimR = v19,
                    axL = v18 and StrokeClock.axis(v15, v18, -v15.nose),
                    axR = v19 and StrokeClock.axis(v15, v19, -v15.nose)
                }
            end

            v15.bells = t2

            local v20 = math.random()
            local v21 = math.random() * 10

            v15.p = v20
            v15.t = v21
            v15.v = 0
            v15.wv = 0

            return v15
        end,
        update = function(p14, p15) -- update | line: 79
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local ChainPulse = p1.ChainPulse
            local model = p14.model
            local CFrame = p14.mesh.CFrame

            p14.t += p15

            local v22 = CFrame:VectorToWorldSpace(p14.up)
            local v23 = CFrame:VectorToWorldSpace(p14.nose)
            local v24 = v23 - v22 * v23:Dot(v22)
            local v25 = 0

            if p14.lastPos and p15 > 1E-04 and (CFrame.Position - p14.lastPos).Magnitude < 20 then
                local v26 = (CFrame.Position - p14.lastPos).Magnitude / p15

                p14.v = p14.v + (v26 - p14.v) * math.min(1, p15 / ChainPulse.V_TAU)

                if p14.lastNose and v24.Magnitude > 0.001 then
                    local lastNose = p14.lastNose
                    local Unit = v24.Unit

                    v25 = math.atan2(lastNose:Cross(Unit):Dot(v22), (lastNose:Dot(Unit))) / p15
                end
            end

            p14.lastPos = CFrame.Position

            if v24.Magnitude > 0.001 then
                p14.lastNose = v24.Unit
            end

            p14.wv = p14.wv + (v25 - p14.wv) * math.min(1, p15 / ChainPulse.W_TAU)

            local v33 = ChainPulse.rate(p14.v, p14.length)
            local v34, v35

            if fightHooked(model) then
                v34 = 1
                v35 = 1
                v33 = ChainPulse.HOOK_HZ
            else
                local PassCruise = attr(model, "PassCruise")

                if type(PassCruise) == "number" and PassCruise > 0 then
                    v34 = p14.v / PassCruise
                    v35 = math.clamp((v34 - 1) / ChainPulse.SURGE_SPAN, 0, 1)
                else
                    v34 = 1
                    v35 = 0
                end
            end

            p14.p = (p14.p + v33 * p15) % 1
            ChainPulse.pose(p14, p14.p, p14.t, v34, v35, (math.clamp(p14.wv / ChainPulse.W_FULL, -1, 1)))
        end
    }
end
