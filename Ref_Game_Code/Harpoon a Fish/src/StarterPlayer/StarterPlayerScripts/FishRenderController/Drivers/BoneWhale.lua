-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 4
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.BoneWhale = {
        COLUMN = {
            "Spine_01",
            "Spine_02",
            "Spine_03",
            "Spine_04",
            "Tail_01",
            "Tail_02",
            "Tail_03",
            "Tail_04",
            "Tail_05",
            "Tail_06"
        },
        X = {
            0.174, 0.263, 0.342, 0.437, 0.532, 0.626, 0.71, 0.784,
            0.852, 0.916
        },
        A_HEAD = 0.02,
        A_TAIL = 0.3,
        X0 = 0.2,
        P = 1.3,
        LAM = 0.8,
        STRIDE = 0.6,
        MIN_HZ = 0.35,
        FULL_BL = 0.35,
        MIN_SCALE = 0.4,
        HOOK_HZ = 2.2,
        HOOK_SCALE = 1.3,
        BEND = 0.5,
        BEND_MAX = 0.9,
        SWEEP = 0.55,
        SPREAD = 0.35,
        FOLD = 0.6,
        FOLD_LAG = 0.6,
        FEATHER = 0.9,
        PAD_BL = 0.9,
        PAD_BL2 = 1.6,
        PAD_MIN = 0.35,
        TUCK = 0.35,
        JAW_REST = 0.02,
        JAW_GAPE = 0.22,
        JAW_RATE = 0.7,
        BREATH = 0.14,
        BREATH_RATE = 0.9,
        RATTLE = 0.12,
        RIB_LAG = 0.45,
        RATTLE_LAG = 0.6,
        env = function(p3) -- env | line: 39
            -- upvalues: p1 (copy)
            local BoneWhale = p1.BoneWhale
            local v2 = math.clamp((p3 - BoneWhale.X0) / (1 - BoneWhale.X0), 0, 1)

            return BoneWhale.A_HEAD + (BoneWhale.A_TAIL - BoneWhale.A_HEAD) * v2 ^ BoneWhale.P
        end,
        h = function(p4, p5, p6) -- h | line: 44
            -- upvalues: p1 (copy)
            local BoneWhale = p1.BoneWhale

            return p6 * BoneWhale.env(p4) / 2 * math.sin(p5 - 6.283185307179586 * p4 / BoneWhale.LAM)
        end,
        beat = function(p7, p8) -- beat | line: 49
            -- upvalues: p1 (copy)
            local BoneWhale = p1.BoneWhale

            if p8 then
                return 6.283185307179586 * BoneWhale.HOOK_HZ
            end

            return 6.283185307179586 * math.max(p7 / BoneWhale.STRIDE, BoneWhale.MIN_HZ)
        end,
        size = function(p9, p10) -- size | line: 55
            -- upvalues: p1 (copy)
            local BoneWhale = p1.BoneWhale

            if p10 then
                return BoneWhale.HOOK_SCALE
            end

            return (math.clamp(p9 / BoneWhale.FULL_BL, BoneWhale.MIN_SCALE, 1))
        end,
        paddle = function(p11, p12) -- paddle | line: 61
            -- upvalues: p1 (copy)
            local BoneWhale = p1.BoneWhale

            if p12 then
                return 1
            end

            local v8 = math.clamp((p11 - BoneWhale.PAD_BL) / (BoneWhale.PAD_BL2 - BoneWhale.PAD_BL), 0, 1)

            return 1 - (1 - BoneWhale.PAD_MIN) * v8
        end,
        arc = function(p13, p14, p15) -- arc | line: 68
            -- upvalues: p1 (copy)
            local BoneWhale = p1.BoneWhale

            return (math.clamp(BoneWhale.BEND * p13 * p14 / math.max(p15, 5), -BoneWhale.BEND_MAX, BoneWhale.BEND_MAX))
        end,
        register = function(p16) -- register | line: 72
            -- upvalues: p1 (copy)
            local v11 = p1.SharkSwim.register(p16)

            if not v11 then
                return nil
            end

            local BoneWhale = p1.BoneWhale
            local nose = v11.nose
            local Unit = (Vector3.new(0, 1, 0) - nose * nose.Y).Unit
            local Unit2 = nose:Cross(Unit).Unit

            local function part(p17) -- line: 81
                -- upvalues: v11 (copy), nose (copy), Unit (copy), Unit2 (copy)
                local v12 = v11.mesh:FindFirstChild(p17, true)

                if v12 and v12:IsA("Bone") then
                    local v13, Parent = v12.CFrame, v12.Parent

                    while Parent and Parent:IsA("Bone") do
                        v13 = Parent.CFrame * v13
                        Parent = Parent.Parent
                    end

                    return {
                        bone = v12,
                        up = v13:VectorToObjectSpace(Unit),
                        right = v13:VectorToObjectSpace(Unit2),
                        nose = v13:VectorToObjectSpace(nose)
                    }
                end

                return nil
            end

            v11.column = {}

            for v14, v15 in ipairs(BoneWhale.COLUMN) do
                local v16 = part(v15)

                if not v16 then
                    return nil
                end

                v11.column[v14] = v16
            end

            v11.jaw = part("Jaw")

            if not v11.jaw then
                return nil
            end

            local t2 = {}

            v11.ribs = {}
            v11.arms = t2

            for _, v17 in ipairs({
                    { "L", 1 },
                    { "R", -1 }
                }) do
                for i = 1, 6 do
                    local v18 = part("Rib_" .. v17[1] .. i)

                    if not v18 then
                        return nil
                    end

                    local v19 = v17[2]
                    local v20 = i - 1

                    v18.side = v19
                    v18.k = v20
                    v11.ribs[#v11.ribs + 1] = v18
                end

                local v21 = part("Arm_" .. v17[1] .. "1")
                local v22 = part("Arm_" .. v17[1] .. "2")

                if not v21 or not v22 then
                    return nil
                end

                v11.arms[#v11.arms + 1] = {
                    a = v21,
                    b = v22,
                    side = v17[2]
                }
            end

            local v23 = math.random() * 10
            local v24 = math.random() * 6.28

            v11.t = v23
            v11.breath = v24

            return v11
        end,
        update = function(p18, p19, _) -- update | line: 115
            -- upvalues: p1 (copy), p2 (copy), fightHooked (copy), attr (copy)
            local BoneWhale = p1.BoneWhale
            local model = p18.model
            local v25 = fightHooked(model)

            p1.SharkSwim.readTurn(p18, p19)

            local length = p18.length
            local v26 = p18.v / math.max(length, 0.001)
            local v27 = not v25 and attr(model, "StrokeAt")

            if v27 then
                local v28 = attr(model, "StrokeRate") or 0
                local v29 = (attr(model, "StrokePhase") or 0) + v28 * (workspace:GetServerTimeNow() - p2.renderLag() - v27)

                if p18.locked then
                    p18.phase += p19 * v28
                    p18.phase = p18.phase + ((v29 - p18.phase + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * math.min(1, p19 * p1.SharkSwim.LOCK)
                else
                    p18.phase = v29
                    p18.locked = true
                end
            else
                p18.locked = nil
                p18.phase += p19 * BoneWhale.beat(v26, v25)
            end

            local v32 = if v25 then 3 else 1

            p18.t += p19 * v32
            p18.breath += p19 * BoneWhale.BREATH_RATE * v32

            local phase, t, breath = p18.phase, p18.t, p18.breath
            local v33 = BoneWhale.size(v26, v25)
            local v34 = BoneWhale.paddle(v26, v25)
            local v35 = BoneWhale.arc(length, p18.w, p18.v)
            local column = p18.column
            local X = BoneWhale.X
            local v36 = #column
            local n1 = 0

            for v37, v38 in ipairs(column) do
                local v39 = X[v37]
                local v40 = X[v37 + 1] or 1
                local v42 = math.atan((BoneWhale.h(v40, phase, v33) - BoneWhale.h(v39, phase, v33)) / (v40 - v39))
                local v43 = v42 - n1

                n1 = v42

                if v37 > 1 then
                    v43 -= v35 / (v36 - 1)
                end

                local v44 = CFrame.fromAxisAngle(v38.up, v43)

                if v37 == 1 then
                    v44 = CFrame.new(v38.right * (BoneWhale.h(X[1], phase, v33) * length)) * v44
                end

                v38.bone.Transform = v44
            end

            p18.jaw.bone.Transform = CFrame.fromAxisAngle(p18.jaw.right, -(BoneWhale.JAW_REST + BoneWhale.JAW_GAPE * (math.sin(BoneWhale.JAW_RATE * t) * 0.5 + 0.5)))

            for _, v46 in ipairs(p18.ribs) do
                local v51 = BoneWhale.BREATH * (math.sin(breath - BoneWhale.RIB_LAG * v46.k) * 0.5 + 0.5) + BoneWhale.RATTLE * v33 * math.sin(phase - BoneWhale.RATTLE_LAG * v46.k)

                v46.bone.Transform = CFrame.fromAxisAngle(v46.nose, v46.side * v51)
            end

            for _, v52 in ipairs(p18.arms) do
                local side = v52.side
                local v53 = phase + (if side == 1 then 0 else 3.141592653589793)
                local v54 = v34 * BoneWhale.SWEEP * math.cos(v53) - BoneWhale.TUCK * (1 - v34)
                local v55 = v34 * BoneWhale.SPREAD * (math.sin(v53) * 0.5 + 0.5)
                local v58 = v34 * BoneWhale.FOLD * (0.5 - math.sin(v53 - BoneWhale.FOLD_LAG) * 0.5)
                local v59 = v34 * BoneWhale.FEATHER * (0.5 - math.sin(v53) * 0.5)

                v52.a.bone.Transform = CFrame.fromAxisAngle(v52.a.right, v54) * CFrame.fromAxisAngle(v52.a.nose, side * v55)
                v52.b.bone.Transform = CFrame.fromAxisAngle(v52.b.right, -v58) * CFrame.fromAxisAngle(Vector3.new(0, 1, 0), side * v59)
            end
        end
    }
end
