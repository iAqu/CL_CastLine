-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.PufferSwim = {
        FIN_OPEN = 0.6,
        HOVER_OPEN = 0.35,
        HOVER_FLUT = 0.25,
        HOVER_RATE = 11,
        TAIL_SWAY = 0.12,
        TAIL_TURN = 0.45,
        TAIL_BURST = 0.55,
        ROCK = 0.05,
        BOB = 0.03,
        HOOK_FIN = 0.9,
        HOOK_TAIL = 0.7,
        HOOK_RATE = 18,
        HOOK_EFFORT = 1.6,
        PEN_RATE = 15,
        FIN_DIR = { 0.25, -0.801, 0.543 },
        register = function(p3) -- register | line: 25
            -- upvalues: p1 (copy), attr (copy)
            local PufferSwim, StrokeClock = p1.PufferSwim, p1.StrokeClock
            local v1 = StrokeClock.setup(p3, { "Body", "Tail_1", "Tail_2", "Fin_L", "Fin_R" })

            if not v1 then
                return nil
            end

            local bones = v1.bones
            local FinDir = attr(p3, "FinDir")
            local v2 = typeof(FinDir) == "Vector3" and {
                FinDir.X,
                FinDir.Y,
                FinDir.Z
            } or PufferSwim.FIN_DIR

            local function fin(p4, p5) -- line: 34
                -- upvalues: StrokeClock (copy), v1 (copy), bones (copy), v2 (copy)
                local v3 = -v1.right * p5
                local v4 = v3 * v2[1] + -v1.up * v2[2] + -v1.nose * v2[3]

                return {
                    bone = bones[p4],
                    axis = StrokeClock.axis(v1, bones[p4], v4:Cross(v3).Unit)
                }
            end

            local v5 = fin("Fin_L", 1)
            local v6 = fin("Fin_R", -1)

            v1.finL = v5
            v1.finR = v6
            v1.tail1 = {
                bone = bones.Tail_1,
                up = StrokeClock.axis(v1, bones.Tail_1, v1.up)
            }
            v1.tail2 = {
                bone = bones.Tail_2,
                up = StrokeClock.axis(v1, bones.Tail_2, v1.up)
            }
            v1.body = {
                bone = bones.Body,
                nose = StrokeClock.axis(v1, bones.Body, v1.nose),
                lat = StrokeClock.axis(v1, bones.Body, v1.right)
            }

            return v1
        end,
        update = function(p6, p7, _) -- update | line: 45
            -- upvalues: p1 (copy), fightHooked (copy)
            local PufferSwim, StrokeClock = p1.PufferSwim, p1.StrokeClock
            local v8 = math.max(StrokeClock.lock(p6, p7, PufferSwim), 0)
            local v9 = StrokeClock.turn(p6, p7)

            p6.fin += p7

            local phase, fin = p6.phase, p6.fin
            local v10, v11, v12, v13, v14, v15

            if fightHooked(p6.model) then
                v10 = PufferSwim.HOOK_FIN * (math.sin(PufferSwim.HOOK_RATE * fin) * 0.5 + 0.5)
                v11 = PufferSwim.HOOK_FIN * (math.sin(PufferSwim.HOOK_RATE * fin + 3.141592653589793) * 0.5 + 0.5)
                v12 = 0.45 * PufferSwim.HOOK_TAIL * math.sin(PufferSwim.HOOK_RATE * 0.8 * fin)
                v13 = 0.55 * PufferSwim.HOOK_TAIL * math.sin(PufferSwim.HOOK_RATE * 0.8 * fin - 0.7)
                v14 = math.sin(PufferSwim.HOOK_RATE * 0.5 * fin) * 0.12
                v15 = 0
            else
                local v24 = math.min(v8 / 0.3, 1)
                local v26 = math.clamp((v8 - 1) / 0.6, 0, 1)
                local v27 = PufferSwim.FIN_OPEN * v24 * (1 - v26)
                local v28 = 1 - v24

                v10 = math.max(0, v27 * (math.sin(phase) * 0.5 + 0.5) + v28 * (PufferSwim.HOVER_OPEN + PufferSwim.HOVER_FLUT * math.sin(PufferSwim.HOVER_RATE * fin)))
                v11 = math.max(0, v27 * (math.sin(phase + 3.141592653589793) * 0.5 + 0.5) + v28 * (PufferSwim.HOVER_OPEN + PufferSwim.HOVER_FLUT * math.sin(PufferSwim.HOVER_RATE * fin + 1.3)))

                local v38 = PufferSwim.TAIL_SWAY * (1 - v26) * math.sin(0.9 * fin) - PufferSwim.TAIL_TURN * v9

                v12 = 0.45 * (v38 + PufferSwim.TAIL_BURST * v26 * math.sin(phase))
                v13 = 0.55 * (v38 + PufferSwim.TAIL_BURST * v26 * math.sin(phase - 0.7))
                v14 = PufferSwim.ROCK * v24 * (1 - v26) * math.sin(phase)
                v15 = PufferSwim.BOB * math.sin(0.5 * fin)
            end

            p6.finL.bone.Transform = CFrame.fromAxisAngle(p6.finL.axis, v10)
            p6.finR.bone.Transform = CFrame.fromAxisAngle(p6.finR.axis, v11)
            p6.tail1.bone.Transform = CFrame.fromAxisAngle(p6.tail1.up, v12)
            p6.tail2.bone.Transform = CFrame.fromAxisAngle(p6.tail2.up, v13)
            p6.body.bone.Transform = CFrame.fromAxisAngle(p6.body.nose, v14) * CFrame.fromAxisAngle(p6.body.lat, v15)
        end
    }
end
