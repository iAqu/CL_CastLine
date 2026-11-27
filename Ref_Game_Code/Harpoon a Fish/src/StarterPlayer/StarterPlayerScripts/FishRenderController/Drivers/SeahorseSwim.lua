-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, _) -- line: 5
    p1.SeahorseSwim = {
        FLUT = 0.55,
        HOVER_FLUT = 0.45,
        HOVER_RATE = 12,
        TAIL = 0.14,
        TAIL_TURN = 0.25,
        ROCK = 0.05,
        HOOK_RATE = 20,
        HOOK_EFFORT = 1.6,
        PEN_RATE = 10,
        register = function(p3) -- register | line: 16
            -- upvalues: p1 (copy)
            local StrokeClock = p1.StrokeClock
            local v1 = StrokeClock.setup(p3, { "body", "tail.01", "fin.L", "fin.R" })

            if not v1 then
                return nil
            end

            local bones = v1.bones

            v1.finL = {
                bone = bones["fin.L"],
                axis = StrokeClock.axis(v1, bones["fin.L"], v1.up)
            }
            v1.finR = {
                bone = bones["fin.R"],
                axis = StrokeClock.axis(v1, bones["fin.R"], v1.up)
            }
            v1.tail = {
                bone = bones["tail.01"],
                lat = StrokeClock.axis(v1, bones["tail.01"], v1.right),
                up = StrokeClock.axis(v1, bones["tail.01"], v1.up)
            }
            v1.body = {
                bone = bones.body,
                axis = StrokeClock.axis(v1, bones.body, v1.right)
            }

            return v1
        end,
        update = function(p4, p5, _) -- update | line: 27
            -- upvalues: p1 (copy)
            local SeahorseSwim = p1.SeahorseSwim
            local v3 = math.max(p1.StrokeClock.lock(p4, p5, SeahorseSwim), 0)
            local v4 = p1.StrokeClock.turn(p4, p5)

            p4.fin += p5

            local v5 = math.min(v3, 1)
            local v6 = 1 - v5
            local v11 = SeahorseSwim.FLUT * v5 * math.sin(p4.phase) + SeahorseSwim.HOVER_FLUT * v6 * math.sin(SeahorseSwim.HOVER_RATE * p4.fin)

            p4.finL.bone.Transform = CFrame.fromAxisAngle(p4.finL.axis, v11)
            p4.finR.bone.Transform = CFrame.fromAxisAngle(p4.finR.axis, -v11)
            p4.tail.bone.Transform = CFrame.fromAxisAngle(p4.tail.lat, SeahorseSwim.TAIL * math.sin(0.8 * p4.fin)) * CFrame.fromAxisAngle(p4.tail.up, -SeahorseSwim.TAIL_TURN * v4)
            p4.body.bone.Transform = CFrame.fromAxisAngle(p4.body.axis, SeahorseSwim.ROCK * v5 * math.sin(p4.phase + 0.6))
        end
    }
end
