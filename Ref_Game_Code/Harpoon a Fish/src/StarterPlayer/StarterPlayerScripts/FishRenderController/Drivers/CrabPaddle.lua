-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local attr = p2.attr

    p1.CrabPaddle = {
        PADDLE = { 0.35, 0.45, 0.6 },
        LAG = 0.8,
        SCULL = 0.12,
        WRIST_REST = -0.25,
        WRIST = 0.12,
        BOB = 0.05,
        HOOK_RATE = 14,
        HOOK_EFFORT = 1.6,
        PEN_RATE = 5,
        CLAW_T = 4.2,
        CLAW_RAISE = 0.3,
        RAISE_UP = 0.08,
        RAISE_HOLD = 0.3,
        RAISE_DOWN = 0.12,
        RAISE_WALK = 0.6,
        CLAW_SWAY = 0.06,
        CLAW_SWAY_RATE = 1.3,
        CLAW_BOB_C = 0.05,
        SNAP_OPEN = 0.38,
        SNAPS = { 0.13, 0.24 },
        SNAP_UP = 0.035,
        SNAP_DOWN = 0.012,
        IDLE_OPEN = 0.06,
        IDLE_RATE = 1.7,
        HOOK_RAISE = 0.3,
        HOOK_SNAP_RATE = 14,
        ease = function(p3) -- ease | line: 28
            return 0.5 - math.cos(3.141592653589793 * math.clamp(p3, 0, 1)) * 0.5
        end,
        raiseEnv = function(p4) -- raiseEnv | line: 31
            -- upvalues: p1 (copy)
            local CrabPaddle = p1.CrabPaddle

            if p4 < CrabPaddle.RAISE_UP then
                return CrabPaddle.ease(p4 / CrabPaddle.RAISE_UP)
            end

            if p4 < CrabPaddle.RAISE_HOLD then
                return 1
            end

            return 1 - CrabPaddle.ease((p4 - CrabPaddle.RAISE_HOLD) / CrabPaddle.RAISE_DOWN)
        end,
        snapEnv = function(p5) -- snapEnv | line: 37
            -- upvalues: p1 (copy)
            local CrabPaddle = p1.CrabPaddle
            local n1 = 0

            for _, v2 in ipairs(CrabPaddle.SNAPS) do
                if v2 - CrabPaddle.SNAP_UP <= p5 and p5 < v2 then
                    n1 = math.max(n1, CrabPaddle.ease((p5 - (v2 - CrabPaddle.SNAP_UP)) / CrabPaddle.SNAP_UP))
                elseif v2 <= p5 and p5 < v2 + CrabPaddle.SNAP_DOWN then
                    n1 = math.max(n1, 1 - (p5 - v2) / CrabPaddle.SNAP_DOWN)
                end
            end

            return n1
        end,
        crabClaws = function(p6, p7, p8, p9) -- crabClaws | line: 50
            -- upvalues: p1 (copy)
            local CrabPaddle = p1.CrabPaddle
            local t2 = {}

            for _, v5 in ipairs({
                    { "L", 0 },
                    { "R", 0.5 }
                }) do
                local v6 = v5[2]

                if p9 then
                    t2[v5[1]] = {
                        CrabPaddle.HOOK_RAISE + CrabPaddle.CLAW_SWAY * math.sin(9 * p6 + 6.283 * v6),
                        CrabPaddle.SNAP_OPEN * (math.sin(CrabPaddle.HOOK_SNAP_RATE * p6 + 6.283 * v6) * 0.5 + 0.5)
                    }
                else
                    local v11 = (p6 / CrabPaddle.CLAW_T + v6) % 1
                    local v17 = CrabPaddle.CLAW_RAISE * CrabPaddle.raiseEnv(v11) * (1 - CrabPaddle.RAISE_WALK * p8) + CrabPaddle.CLAW_SWAY * math.sin(CrabPaddle.CLAW_SWAY_RATE * p6 + 6.283 * v6) + p8 * CrabPaddle.CLAW_BOB_C * math.sin(12.566370614359172 * p7 + 3.141592653589793 * v6)
                    local v20 = CrabPaddle.SNAP_OPEN * CrabPaddle.snapEnv(v11) + CrabPaddle.IDLE_OPEN * (math.sin(CrabPaddle.IDLE_RATE * p6 + 6.283 * v6) * 0.5 + 0.5)

                    t2[v5[1]] = { v17, v20 }
                end
            end

            return t2
        end,
        poseClaws = function(p10, p11, p12, p13) -- poseClaws | line: 68
            -- upvalues: p1 (copy), attr (copy)
            local v21 = p1.CrabPaddle.crabClaws(p10.clawT, p11, p12, p13)
            local ClawHold = attr(p10.model, "ClawHold")

            for v22, v23 in pairs(p10.claws) do
                if v22 ~= ClawHold then
                    local v24 = v21[v22]

                    v23.arm.Transform = CFrame.fromAxisAngle(v23.armA, v24[1])
                    v23.dac.Transform = CFrame.fromAxisAngle(v23.dacA, v24[2])
                end
            end
        end,
        register = function(p14) -- register | line: 78
            -- upvalues: p1 (copy), attr (copy)
            local StrokeClock = p1.StrokeClock
            local v25 = StrokeClock.setup(p14, { "body", "leg.L.01", "leg.R.03" })

            if not v25 then
                return nil
            end

            local bones = v25.bones

            if not (bones.wrist or bones["claw.L.1"] and bones["claw.R.1"]) then
                return nil
            end

            local function at(p15) -- line: 84
                -- upvalues: v25 (copy), bones (copy)
                return v25.mcf:PointToObjectSpace(bones[p15].WorldPosition)
            end

            local v26 = bones.wrist and v25.mcf:VectorToObjectSpace(bones.wrist.WorldPosition - bones.body.WorldPosition) or (v25.mcf:PointToObjectSpace(bones["claw.L.1"].WorldPosition) + v25.mcf:PointToObjectSpace(bones["claw.R.1"].WorldPosition)) / 2 - v25.mcf:PointToObjectSpace(bones.body.WorldPosition)
            local Unit = (v26 - v25.up * v26:Dot(v25.up)).Unit

            v25.legs = {}

            for i = 1, 4 do
                for _, v27 in ipairs({
                        { "L", 1 },
                        { "R", -1 }
                    }) do
                    local v28 = bones["leg." .. v27[1] .. ".0" .. i]

                    if v28 then
                        v25.legs[#v25.legs + 1] = {
                            bone = v28,
                            i = math.min(i, 3),
                            side = v27[2],
                            axis = StrokeClock.axis(v25, v28, Unit)
                        }
                    end
                end
            end

            if bones.wrist then
                v25.wrist = {
                    bone = bones.wrist,
                    axis = StrokeClock.axis(v25, bones.wrist, Unit:Cross(v25.up).Unit)
                }
            else
                v25.claws = {}

                for _, v29 in ipairs({ "L", "R" }) do
                    local v30 = "claw." .. v29 .. ".1"
                    local v31 = v25.mcf:PointToObjectSpace(bones[v30].WorldPosition)
                    local v32 = "claw." .. v29 .. ".2"
                    local v33 = v25.mcf:PointToObjectSpace(bones[v32].WorldPosition)
                    local v34 = "claw." .. v29 .. ".3"
                    local v35 = v25.mcf:PointToObjectSpace(bones[v34].WorldPosition)
                    local v36 = v35 - v31
                    local Unit = (v36 - v25.up * v36:Dot(v25.up)).Unit
                    local v37 = bones["claw." .. v29 .. ".1"]
                    local v38 = bones["claw." .. v29 .. ".3"]

                    v25.claws[v29] = {
                        arm = v37,
                        armA = StrokeClock.axis(v25, v37, Unit:Cross(v25.up).Unit),
                        dac = v38,
                        dacA = StrokeClock.axis(v25, v38, (v35 - v33).Unit:Cross(v25.up).Unit)
                    }
                end

                v25.clawT = math.random() * p1.CrabPaddle.CLAW_T
            end

            v25.body = {
                bone = bones.body,
                axis = StrokeClock.axis(v25, bones.body, Unit)
            }

            if attr(p14, "Crawl") and not p1.Crawl.setup(v25, "crab") then
                warn("[FishRenderController] crawler rig has no split legs: " .. p14.Name)
            end

            return v25
        end,
        update = function(p16, p17, _) -- update | line: 121
            -- upvalues: p1 (copy), attr (copy)
            local CrabPaddle = p1.CrabPaddle

            if p16.crawl then
                if not attr(p16.model, "Hooked") then
                    p1.Crawl.update(p16, p17)
                    p16.fin += p17 * 1.5

                    if p16.claws then
                        p16.clawT += p17
                        CrabPaddle.poseClaws(p16, p16.crawl.phase, p16.crawl.walk, false)
                    else
                        p16.wrist.bone.Transform = CFrame.fromAxisAngle(p16.wrist.axis, CrabPaddle.WRIST_REST + CrabPaddle.WRIST * math.sin(p16.fin))
                    end

                    return
                end

                p1.Crawl.stop(p16)
            end

            local v40 = math.max(p1.StrokeClock.lock(p16, p17, CrabPaddle), 0)

            p1.StrokeClock.turn(p16, p17)
            p16.fin += p17 * 1.5

            local v43 = math.min(v40, 1) * (math.clamp(v40 - 1, 0, 1) * 0.3 + 1)
            local v44 = 1 - math.min(v40, 1)

            for _, v45 in ipairs(p16.legs) do
                local v51 = CrabPaddle.PADDLE[v45.i] * v43 * math.sin(p16.phase - CrabPaddle.LAG * (v45.i - 1)) + CrabPaddle.SCULL * v44 * math.sin(p16.fin * 2 - v45.i)

                v45.bone.Transform = CFrame.fromAxisAngle(v45.axis, v45.side * v51)
            end

            if p16.claws then
                p16.clawT += p17
                CrabPaddle.poseClaws(p16, 0, 0, not not attr(p16.model, "Hooked"))
            else
                p16.wrist.bone.Transform = CFrame.fromAxisAngle(p16.wrist.axis, CrabPaddle.WRIST_REST + CrabPaddle.WRIST * math.sin(p16.fin))
            end

            p16.body.bone.Transform = CFrame.fromAxisAngle(p16.body.axis, CrabPaddle.BOB * v43 * math.sin(p16.phase + 0.5))
        end
    }
end
