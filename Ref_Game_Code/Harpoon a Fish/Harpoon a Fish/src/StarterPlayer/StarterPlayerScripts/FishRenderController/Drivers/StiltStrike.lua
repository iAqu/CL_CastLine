-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 13
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.StiltStrike = {
        SHOOT = 0.12,
        COCK = 0.3,
        SHOTS = 2,
        SHOT_T = 0.5,
        HOLD = 0.22,
        BREATH = 0.1,
        BREATH_RATE = 1.1,
        SHOOT_EASE = 35,
        RETURN_EASE = 9,
        SWAY = 0.1,
        SWAY_RATE = 1.6,
        HOOK_RATE = 7,
        HOOK_R0 = 0.35,
        HOOK_R1 = 0.45,
        PODS = {
            { "PodU", 0, 0 },
            { "PodD", 0.5, 3.141592653589793 }
        },
        target = function(p3, p4, p5, p6, p7, p8, p9) -- target | line: 20
            -- upvalues: p1 (copy)
            local StiltStrike = p1.StiltStrike

            if p7 then
                return StiltStrike.HOOK_R0 + StiltStrike.HOOK_R1 * math.sin(StiltStrike.HOOK_RATE * p8 + p4)
            end

            if p6 then
                return -StiltStrike.COCK
            end

            if p5 < StiltStrike.SHOTS * StiltStrike.SHOT_T then
                local v2 = p5 - p3 * StiltStrike.SHOT_T

                if not (v2 >= 0 and v2 % StiltStrike.SHOT_T < StiltStrike.HOLD) then
                    return 0
                end

                return 1
            end

            return StiltStrike.BREATH * (math.sin(StiltStrike.BREATH_RATE * p9 + p4) * 0.5 + 0.5)
        end,
        pose = function(p10, p11) -- pose | line: 35
            -- upvalues: p1 (copy)
            local StiltStrike = p1.StiltStrike

            for _, v4 in ipairs(p10.pods) do
                local v7 = StiltStrike.SWAY * math.sin(StiltStrike.SWAY_RATE * p11 + v4.off) * (1 - math.clamp(v4.r, 0, 1))

                v4.bone.Transform = CFrame.new(Vector3.new(0, 1, 0) * (v4.r * StiltStrike.SHOOT * p10.length)) * CFrame.fromAxisAngle(v4.up, v7)
            end
        end,
        register = function(p12) -- register | line: 42
            -- upvalues: p1 (copy), attr (copy)
            local v8 = p1.SharkSwim.register(p12)

            if not v8 then
                return nil
            end

            local CFrame = v8.mesh.CFrame
            local t2 = {}

            for _, v9 in ipairs(p1.StiltStrike.PODS) do
                local v10 = v8.mesh:FindFirstChild(v9[1], true)

                if not v10 then
                    return nil
                end

                local v11 = CFrame:ToObjectSpace(v10.WorldCFrame)

                t2[#t2 + 1] = {
                    r = 0,
                    bone = v10,
                    delay = v9[2],
                    off = v9[3],
                    up = v11:VectorToObjectSpace(v8.up)
                }
            end

            v8.pods = t2

            local v12 = math.random() * 6.28

            v8.stiltSince = 99
            v8.stiltFin = v12
            v8.stiltWasDisp = false
            v8.stiltGulp = attr(p12, "Gulp")

            return v8
        end,
        update = function(p13, p14, p15) -- update | line: 58
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local StiltStrike = p1.StiltStrike

            p1.SharkSwim.update(p13, p14, p15)

            local model = p13.model
            local v13 = not not attr(model, "Display")

            if p13.stiltWasDisp and not v13 then
                p13.stiltSince = 0
            end

            p13.stiltWasDisp = v13

            local Gulp = attr(model, "Gulp")

            if Gulp and Gulp ~= p13.stiltGulp then
                p13.stiltGulp = Gulp
                p13.stiltSince = 0
            end

            local v14 = fightHooked(model)

            p13.stiltSince += p14
            p13.stiltFin += p14

            for _, v15 in ipairs(p13.pods) do
                local v16 = StiltStrike.target(v15.delay, v15.off, p13.stiltSince, v13, v14, p15, p13.stiltFin)

                v15.r = v15.r + (v16 - v15.r) * math.min(1, p14 * (v15.r < v16 and StiltStrike.SHOOT_EASE or StiltStrike.RETURN_EASE))
            end

            StiltStrike.pose(p13, p13.stiltFin)
        end
    }
end
