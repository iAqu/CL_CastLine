-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local attr = p2.attr

    p1.LobsterFlip = {
        CURL = 1.15,
        SHARP = 4,
        WRIST = 0.35,
        TUCK = 0.35,
        IDLE = 0.06,
        HOOK_RATE = 9,
        HOOK_EFFORT = 1.6,
        PEN_RATE = 2.5,
        register = function(p3) -- register | line: 17
            -- upvalues: p1 (copy), attr (copy)
            local StrokeClock = p1.StrokeClock
            local v1 = StrokeClock.setup(p3, { "body", "wrist", "tail.01", "leg.L.01" })

            if not v1 then
                return nil
            end

            local bones = v1.bones
            local Unit = (-v1.nose):Cross(v1.up).Unit

            v1.tail = {
                bone = bones["tail.01"],
                axis = StrokeClock.axis(v1, bones["tail.01"], Unit)
            }
            v1.wrist = {
                bone = bones.wrist,
                axis = StrokeClock.axis(v1, bones.wrist, Unit)
            }
            v1.legs = {}

            for i = 1, 3 do
                for _, v2 in ipairs({ "L", "R" }) do
                    local v3 = bones["leg." .. v2 .. ".0" .. i]

                    v1.legs[#v1.legs + 1] = {
                        bone = v3,
                        axis = StrokeClock.axis(v1, v3, v1.up),
                        side = v2 == "L" and 1 or -1
                    }
                end
            end

            if attr(p3, "Crawl") and not p1.Crawl.setup(v1, "lobster") then
                warn("[FishRenderController] crawler rig has no split legs: " .. p3.Name)
            end

            return v1
        end,
        update = function(p4, p5, _) -- update | line: 41
            -- upvalues: p1 (copy), attr (copy)
            local LobsterFlip = p1.LobsterFlip

            if p4.crawl then
                if not attr(p4.model, "Hooked") then
                    p1.Crawl.update(p4, p5)
                    p4.fin += p5
                    p4.tail.bone.Transform = CFrame.fromAxisAngle(p4.tail.axis, LobsterFlip.IDLE * math.sin(p4.fin))
                    p4.wrist.bone.Transform = CFrame.fromAxisAngle(p4.wrist.axis, LobsterFlip.IDLE * math.sin(p4.fin * 0.7 + 1))

                    return
                end

                p1.Crawl.stop(p4)
            end

            local v7 = math.max(p1.StrokeClock.lock(p4, p5, LobsterFlip), 0)

            p1.StrokeClock.turn(p4, p5)
            p4.fin += p5

            local v10 = math.min(v7, 1) * (math.clamp(v7 - 1, 0, 1) * 0.3 + 1)
            local v12 = (math.cos(2 * p4.phase) * 0.5 + 0.5) ^ LobsterFlip.SHARP

            p4.tail.bone.Transform = CFrame.fromAxisAngle(p4.tail.axis, LobsterFlip.CURL * v10 * v12 + LobsterFlip.IDLE * math.sin(p4.fin))
            p4.wrist.bone.Transform = CFrame.fromAxisAngle(p4.wrist.axis, -LobsterFlip.WRIST * v10 * v12)

            for _, v14 in ipairs(p4.legs) do
                v14.bone.Transform = CFrame.fromAxisAngle(v14.axis, v14.side * LobsterFlip.TUCK * v10 * (0.4 + 0.6 * v12))
            end
        end
    }
end
