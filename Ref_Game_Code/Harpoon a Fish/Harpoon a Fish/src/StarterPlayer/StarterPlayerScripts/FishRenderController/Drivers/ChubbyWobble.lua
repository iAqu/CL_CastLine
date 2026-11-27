-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 4
    local _, attr = p2.fightHooked, p2.attr

    p1.ChubbyWobble = {
        TAIL_A = 0.38,
        RECOIL = 0.06,
        WADDLE = 0.08,
        BOB = 0.015,
        BUN_LIFT = 0.03,
        BUN_TIP = 0.07,
        FIN_OPEN = 0.35,
        PEN_RATE = 5,
        HOOK_RATE = 14,
        HOOK_EFFORT = 1.6,
        FIN_DIR = { 0.26, -0.045, 0.965 },
        register = function(p3) -- register | line: 22
            -- upvalues: p1 (copy), attr (copy)
            local ChubbyWobble, StrokeClock = p1.ChubbyWobble, p1.StrokeClock
            local v1 = StrokeClock.setup(p3, { "Body", "TopBun", "Tail_1", "Tail_2", "Fin_L", "Fin_R" })

            if not v1 then
                return nil
            end

            local bones = v1.bones
            local FinDir = attr(p3, "FinDir")
            local v2 = typeof(FinDir) == "Vector3" and {
                FinDir.X,
                FinDir.Y,
                FinDir.Z
            } or ChubbyWobble.FIN_DIR

            local function fin(p4, p5) -- line: 31
                -- upvalues: StrokeClock (copy), v1 (copy), bones (copy), v2 (copy)
                local Unit = (-v1.right * p5 * v2[1] + -v1.up * v2[2] + -v1.nose * v2[3]).Unit

                return {
                    bone = bones[p4],
                    axis = StrokeClock.axis(v1, bones[p4], Unit)
                }
            end

            local v3 = fin("Fin_L", 1)
            local v4 = fin("Fin_R", -1)

            v1.finL = v3
            v1.finR = v4
            v1.body = {
                bone = bones.Body,
                up = StrokeClock.axis(v1, bones.Body, v1.up),
                nose = StrokeClock.axis(v1, bones.Body, v1.nose)
            }
            v1.bun = {
                bone = bones.TopBun,
                up = StrokeClock.axis(v1, bones.TopBun, v1.up),
                lat = StrokeClock.axis(v1, bones.TopBun, v1.right)
            }

            local BunLift = attr(p3, "BunLift")

            v1.bunLift = if type(BunLift) ~= "number" or not BunLift then ChubbyWobble.BUN_LIFT else BunLift
            v1.tail1 = {
                bone = bones.Tail_1,
                up = StrokeClock.axis(v1, bones.Tail_1, v1.up)
            }
            v1.tail2 = {
                bone = bones.Tail_2,
                up = StrokeClock.axis(v1, bones.Tail_2, v1.up)
            }

            return v1
        end,
        update = function(p6, p7, _) -- update | line: 45
            -- upvalues: p1 (copy)
            local ChubbyWobble = p1.ChubbyWobble
            local v6 = math.clamp(p1.StrokeClock.lock(p6, p7, ChubbyWobble), 0.5, 1.6)
            local phase, length = p6.phase, p6.length
            local v7 = math.sin(phase)
            local v9 = 0.5 - math.cos(2 * phase) * 0.5
            local body, bun = p6.body, p6.bun

            body.bone.Transform = CFrame.new(body.up * (ChubbyWobble.BOB * length * math.sin(2 * phase))) * CFrame.fromAxisAngle(body.up, -ChubbyWobble.RECOIL * v6 * v7) * CFrame.fromAxisAngle(body.nose, ChubbyWobble.WADDLE * v7)
            bun.bone.Transform = CFrame.new(bun.up * (p6.bunLift * length * v9)) * CFrame.fromAxisAngle(bun.lat, -ChubbyWobble.BUN_TIP * v9)
            p6.tail1.bone.Transform = CFrame.fromAxisAngle(p6.tail1.up, 0.4 * ChubbyWobble.TAIL_A * v6 * v7)
            p6.tail2.bone.Transform = CFrame.fromAxisAngle(p6.tail2.up, 0.6 * ChubbyWobble.TAIL_A * v6 * math.sin(phase - 0.8))
            p6.finL.bone.Transform = CFrame.fromAxisAngle(p6.finL.axis, ChubbyWobble.FIN_OPEN * v7)
            p6.finR.bone.Transform = CFrame.fromAxisAngle(p6.finR.axis, ChubbyWobble.FIN_OPEN * math.sin(phase + 3.141592653589793))
        end
    }
end
