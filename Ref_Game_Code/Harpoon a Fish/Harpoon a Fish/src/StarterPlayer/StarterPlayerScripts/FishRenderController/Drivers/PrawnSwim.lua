-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local attr = p2.attr

    p1.PrawnSwim = {
        PAD = 0.5,
        LAG = 0.9,
        SCULL = 0.15,
        ANT_SWEEP = 0.35,
        ANT_TURN = 0.3,
        ANT_WAVE = 0.12,
        TAIL = 0.08,
        FLICK = 0.9,
        ARM = 0.1,
        HOOK_RATE = 16,
        HOOK_EFFORT = 1.8,
        PEN_RATE = 6,
        register = function(p3) -- register | line: 17
            -- upvalues: p1 (copy)
            local StrokeClock = p1.StrokeClock
            local v1 = StrokeClock.setup(p3, { "body", "tail.01", "tail.02", "leg.L.01", "antennae.L.01" })

            if not v1 then
                return nil
            end

            local bones, right = v1.bones, v1.right

            v1.legs = {}

            for i = 1, 3 do
                for _, v2 in ipairs({ "L", "R" }) do
                    local v3 = bones["leg." .. v2 .. ".0" .. i]

                    v1.legs[#v1.legs + 1] = {
                        bone = v3,
                        i = i,
                        axis = StrokeClock.axis(v1, v3, right)
                    }
                end
            end

            v1.arms = {}

            for _, v4 in ipairs({ "arm.L.01", "arm.R.01", "arm.L.03", "arm.R.03" }) do
                if bones[v4] then
                    v1.arms[#v1.arms + 1] = {
                        bone = bones[v4],
                        axis = StrokeClock.axis(v1, bones[v4], right),
                        k = #v1.arms
                    }
                end
            end

            v1.ant = {}

            for _, v5 in ipairs({ "antennae.L.01", "antennae.R.01", "antennae.L.02", "antennae.R.02" }) do
                if bones[v5] then
                    v1.ant[#v1.ant + 1] = {
                        bone = bones[v5],
                        lat = StrokeClock.axis(v1, bones[v5], right),
                        up = StrokeClock.axis(v1, bones[v5], v1.up),
                        tip = v5:sub(-1) == "2"
                    }
                end
            end

            v1.tail1 = {
                bone = bones["tail.01"],
                axis = StrokeClock.axis(v1, bones["tail.01"], right),
                up = StrokeClock.axis(v1, bones["tail.01"], v1.up)
            }
            v1.tail2 = {
                bone = bones["tail.02"],
                axis = StrokeClock.axis(v1, bones["tail.02"], right)
            }

            return v1
        end,
        update = function(p4, p5, _) -- update | line: 42
            -- upvalues: p1 (copy), attr (copy)
            local PrawnSwim = p1.PrawnSwim
            local v7 = math.max(p1.StrokeClock.lock(p4, p5, PrawnSwim), 0)
            local v8 = p1.StrokeClock.turn(p4, p5)

            p4.fin += p5 * 1.3

            local v11 = math.min(v7, 1) * (math.clamp(v7 - 1, 0, 1) * 0.3 + 1)
            local v12 = 1 - math.min(v7, 1)
            local v14 = math.clamp(v7 - 1, 0, 1)

            for _, v15 in ipairs(p4.legs) do
                v15.bone.Transform = CFrame.fromAxisAngle(v15.axis, PrawnSwim.PAD * v11 * math.sin(p4.phase - PrawnSwim.LAG * (v15.i - 1)) + PrawnSwim.SCULL * v12 * math.sin(p4.fin * 3 - v15.i))
            end

            for _, v21 in ipairs(p4.arms) do
                v21.bone.Transform = CFrame.fromAxisAngle(v21.axis, PrawnSwim.ARM * math.sin(p4.fin - v21.k * 0.7))
            end

            local model = p4.model
            local v23 = (attr(model, "StrokeCruise") or 6) * (attr(model, "StrokeStride") or 1)
            local v25 = math.clamp(p4.v / math.max(v23, 1), 0, 1.5)

            for _, v26 in ipairs(p4.ant) do
                local v30 = (if v26.tip then 0.5 else 1) * (PrawnSwim.ANT_SWEEP * v25 + PrawnSwim.ANT_WAVE * math.sin(p4.fin + (if v26.tip then 1 else 0)))

                v26.bone.Transform = CFrame.fromAxisAngle(v26.lat, v30) * CFrame.fromAxisAngle(v26.up, -PrawnSwim.ANT_TURN * math.clamp(p4.w / 0.8, -1, 1))
            end

            local v35 = PrawnSwim.FLICK * v14 * (math.cos(p4.phase) * 0.5 + 0.5) ^ 3

            p4.tail1.bone.Transform = CFrame.fromAxisAngle(p4.tail1.axis, PrawnSwim.TAIL * v11 * math.sin(p4.phase - 1) + v35 * 0.6) * CFrame.fromAxisAngle(p4.tail1.up, -0.3 * v8)
            p4.tail2.bone.Transform = CFrame.fromAxisAngle(p4.tail2.axis, PrawnSwim.TAIL * v11 * math.sin(p4.phase - 1.8) + v35 * 0.4)
        end
    }
end
