-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 4
    local fightHooked, _ = p2.fightHooked, p2.attr

    p1.PaddleSwim = {
        POWER = 0.4,
        SWING_FWD = 0.75,
        SWING_BACK = 0.15,
        REACH = 0.65,
        LIFT = 0.4,
        FEATHER = 0.4,
        LAG_R = 0.15,
        AMP_R = 0.92,
        KICK = 0.45,
        KICK_X = 2,
        HEAVE = 0.035,
        HEAVE_LAG = 0.7,
        PITCH0 = 0.12,
        PITCH = 0.12,
        ROLL = 0.05,
        WAG = 0.3,
        WAG_X = 2,
        TAIL_TURN = 0.5,
        HOOK_AMP = 1.25,
        HOOK_RATE = 14,
        HOOK_EFFORT = 1.5,
        PEN_RATE = 7,
        WAG_SHARE = {
            { "Spine_04", 0.1 },
            { "Tail_01", 0.25 },
            { "Tail_02", 0.3 },
            { "Tail_03", 0.35 }
        },
        arm = function(p3, p4) -- arm | line: 27
            -- upvalues: p1 (copy)
            local PaddleSwim = p1.PaddleSwim
            local v1 = (p3 / 6.283185307179586 + 0.5) % 1 - 0.5
            local v2 = PaddleSwim.POWER / 2
            local v3 = (PaddleSwim.SWING_FWD - PaddleSwim.SWING_BACK) / 2
            local v4 = (PaddleSwim.SWING_FWD + PaddleSwim.SWING_BACK) / 2

            if math.abs(v1) <= v2 then
                local v5 = v1 / v2

                return (v3 - v4 * math.sin(1.5707963267948966 * v5)) * p4, PaddleSwim.REACH * math.cos(1.5707963267948966 * v5) * p4, PaddleSwim.FEATHER * math.cos(1.5707963267948966 * v5) * p4
            end

            local v11 = (v1 - v2) % 1 / (1 - PaddleSwim.POWER)

            return (v3 - v4 * math.cos(3.141592653589793 * v11)) * p4, -PaddleSwim.LIFT * math.sin(3.141592653589793 * v11) * p4, 0
        end,
        register = function(p5) -- register | line: 40
            -- upvalues: p1 (copy)
            local PaddleSwim, StrokeClock = p1.PaddleSwim, p1.StrokeClock
            local t2 = {
                "Spine_01",
                "Fin_L",
                "Fin_R",
                "Leg_L",
                "Leg_R"
            }

            for _, v16 in ipairs(PaddleSwim.WAG_SHARE) do
                table.insert(t2, v16[1])
            end

            local v18 = StrokeClock.setup(p5, t2)

            if not v18 then
                return nil
            end

            local bones = v18.bones

            local function axes(p6) -- line: 49
                -- upvalues: StrokeClock (copy), v18 (copy), bones (copy)
                return {
                    bone = bones[p6],
                    up = StrokeClock.axis(v18, bones[p6], v18.up),
                    nose = StrokeClock.axis(v18, bones[p6], v18.nose),
                    right = StrokeClock.axis(v18, bones[p6], v18.right)
                }
            end

            local Fin_L = axes("Fin_L")
            local Fin_R = axes("Fin_R")
            local Leg_L = axes("Leg_L")
            local Leg_R = axes("Leg_R")
            local Spine_01 = axes("Spine_01")

            v18.finL = Fin_L
            v18.finR = Fin_R
            v18.legL = Leg_L
            v18.legR = Leg_R
            v18.root = Spine_01
            v18.wag = {}

            for _, v19 in ipairs(PaddleSwim.WAG_SHARE) do
                table.insert(v18.wag, {
                    bone = bones[v19[1]],
                    up = StrokeClock.axis(v18, bones[v19[1]], v18.up),
                    share = v19[2]
                })
            end

            return v18
        end,
        update = function(p7, p8, _) -- update | line: 57
            -- upvalues: p1 (copy), fightHooked (copy)
            local PaddleSwim, StrokeClock = p1.PaddleSwim, p1.StrokeClock
            local v21 = math.max(StrokeClock.lock(p7, p8, PaddleSwim), 0)
            local v22 = StrokeClock.turn(p7, p8)

            p7.fin += p8

            local phase, fin = p7.phase, p7.fin
            local v23 = fightHooked(p7.model)
            local HOOK_AMP = if v23 then PaddleSwim.HOOK_AMP else nil

            if not v23 or not HOOK_AMP then
                HOOK_AMP = math.clamp(v21 * 0.4 + 0.6, 0.6, 1.2)
            end

            for _, v25 in ipairs({
                    {
                        p7.finL,
                        1,
                        phase,
                        1
                    },
                    {
                        p7.finR,
                        -1,
                        phase - PaddleSwim.LAG_R,
                        PaddleSwim.AMP_R
                    }
                }) do
                local v26 = v25[1]
                local v27 = v25[2]
                local v28, v29, v30 = PaddleSwim.arm(v25[3], HOOK_AMP * v25[4])

                v26.bone.Transform = CFrame.fromAxisAngle(v26.up, -v28 * v27) * CFrame.fromAxisAngle(v26.nose, -v29 * v27) * CFrame.fromAxisAngle(v26.right, -v30)
            end

            local v33 = PaddleSwim.KICK * HOOK_AMP * math.sin(PaddleSwim.KICK_X * phase)
            local v36 = PaddleSwim.KICK * HOOK_AMP * math.sin(PaddleSwim.KICK_X * phase + 3.141592653589793)

            p7.legL.bone.Transform = CFrame.fromAxisAngle(p7.legL.right, -v33)
            p7.legR.bone.Transform = CFrame.fromAxisAngle(p7.legR.right, -v36)

            local v39 = PaddleSwim.WAG * HOOK_AMP * math.sin(PaddleSwim.WAG_X * phase) - PaddleSwim.TAIL_TURN * v22

            for _, v40 in ipairs(p7.wag) do
                v40.bone.Transform = CFrame.fromAxisAngle(v40.up, v39 * v40.share)
            end

            local v43 = PaddleSwim.PITCH0 + PaddleSwim.PITCH * HOOK_AMP * math.cos(phase - PaddleSwim.HEAVE_LAG)
            local v47 = PaddleSwim.ROLL * (math.sin(0.9 * fin) + math.sin(2.3 * fin + 1.1) * 0.6)
            local v50 = PaddleSwim.HEAVE * p7.length * HOOK_AMP * math.cos(phase - PaddleSwim.HEAVE_LAG)
            local root = p7.root

            root.bone.Transform = CFrame.new(root.up * v50) * CFrame.fromAxisAngle(root.right, v43) * CFrame.fromAxisAngle(root.nose, v47)
        end
    }
end
