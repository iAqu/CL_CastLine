-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.SharkSwim = {
        LOCK = 10,
        BEND = 0.5,
        BEND_MAX = 0.9,
        W_TAU = 0.15,
        V_TAU = 0.3,
        BEAT_STRIDE = 0.7,
        WAVELENGTH = 1,
        ENV = { 0.05, -0.13, 0.28 },
        FULL_SPEED = 0.6,
        MIN_ENV = 0.35,
        MIN_BEAT = 0.3,
        DISPLAY_TAU = 0.35,
        DISPLAY_HEAD = 0.16,
        DISPLAY_ARCH = 0.3,
        DISPLAY_FINS = 0.45,
        DISPLAY_ROLL = 0.14,
        DISPLAY_SWING = 0.4,
        PEC_AMP = 0.55,
        PEC_FEATHER = 0.6,
        PEC_STRIDE = 0.45,
        PEC_MIN_HZ = 1.2,
        PEC_MAX_HZ = 4,
        BODY_MIN = 0.25,
        PEC_TUCK = 0.45,
        PEC_RISE = 0.4,
        SWAY_RATE = 7,
        SWAY_HOOK = 2,
        ARM_BEATS = 3,
        ARM_TILT = 0.13,
        ARM_TWIST = 0.28,
        ARM_TWIST_LAG = 1.2,
        ARM_CURL = 0.35,
        ARM_CURL_LAG = 0.9,
        ARM_BANK = 0.25,
        ARM_HOOK = 1.5,
        gait = function(p3, p4) -- gait | line: 86
            local v2 = math.clamp((p3 - 0.8 * p4) / (0.5 * p4), 0, 1)

            return v2 * v2 * (3 - v2 * 2)
        end,
        pec = function(p5, p6, p7, p8, p9) -- pec | line: 90
            -- upvalues: p1 (copy)
            local SharkSwim = p1.SharkSwim
            local v3 = SharkSwim.gait(p6, p7)
            local v6 = SharkSwim.PEC_AMP * (1 - 0.7 * v3) * math.min(1, SharkSwim.PEC_RISE + (1 - SharkSwim.PEC_RISE) * p6 / p7)

            return p9 * v6 * (1 - p8) * math.sin(p5), p9 * SharkSwim.PEC_FEATHER * v6 * math.cos(p5), p9 * (p8 * v6 * math.sin(p5) + SharkSwim.PEC_TUCK * v3)
        end,
        register = function(p10) -- register | line: 97
            -- upvalues: p1 (copy), attr (copy)
            local v7 = p1.FishWave.register(p10)

            if not v7 then
                return nil
            end

            local mesh = v7.mesh
            local v8 = mesh:FindFirstChild("Spine_01", true)
            local v9 = mesh:FindFirstChild("Spine_04", true)

            if not v8 or not v9 then
                return nil
            end

            local Unit = mesh.CFrame:VectorToObjectSpace(v8.WorldPosition - v9.WorldPosition).Unit
            local Size = mesh.Size

            v7.nose = Unit
            v7.length = math.abs(Unit.X) * Size.X + math.abs(Unit.Y) * Size.Y + math.abs(Unit.Z) * Size.Z
            v7.body = {}
            v7.nBody = 0

            for _, v12 in ipairs(v7.segs) do
                local Name = v12.bone.Name

                if Name:match("^Spine_0[2-9]") or Name:match("^Tail_") then
                    v7.body[v12] = true
                    v7.nBody += 1
                end
            end

            v7.w = 0
            v7.v = 0
            v7.waveK = attr(p10, "WaveK")

            local t2 = {}
            local t3 = {}
            local CFrame = mesh.CFrame

            for _, v13 in ipairs(v7.segs) do
                local Name = v13.bone.Name

                if Name:match("^Spine_%d") or Name:match("^Tail_%d") then
                    local v14 = CFrame:PointToObjectSpace(v13.bone.WorldPosition):Dot(Unit)

                    t2[#t2 + 1] = {
                        seg = v13,
                        x = 0.5 - v14 / v7.length
                    }
                    t3[v13] = true
                end
            end

            table.sort(t2, function(p11, p12) -- line: 132
                return p11.x < p12.x
            end)
            v7.chain = t2
            v7.inChain = t3

            if t2[1] then
                local v16 = CFrame:ToObjectSpace(t2[1].seg.bone.WorldCFrame)

                v7.rootLat = v16:VectorToObjectSpace(Unit:Cross((v16:VectorToWorldSpace(t2[1].seg.axis))))
            end

            local v17 = Unit:Cross(v7.up)

            for _, v18 in ipairs(t2) do
                local v19 = CFrame:ToObjectSpace(v18.seg.bone.WorldCFrame)

                v18.pitch = v19:VectorToObjectSpace(v17)
                v18.roll = v19:VectorToObjectSpace(Unit)
            end

            v7.fins = {}

            for _, v20 in ipairs(v7.segs) do
                local Name = v20.bone.Name

                if Name == "Fin_L" or Name == "Fin_R" then
                    local v21 = CFrame:ToObjectSpace(v20.bone.WorldCFrame)

                    v7.fins[v20] = {
                        axis = v21:VectorToObjectSpace(Unit),
                        up = v21:VectorToObjectSpace(v7.up),
                        sign = v21.Position:Dot(v17) > 0 and 1 or -1
                    }
                end
            end

            v7.disp = 0
            v7.pec = math.random() * 2 * 3.141592653589793

            local FinSway = attr(p10, "FinSway")

            v7.finSwayA = if type(FinSway) ~= "number" or not FinSway then nil else FinSway
            v7.swayT = math.random() * 2 * 3.141592653589793

            local WaveEnv = attr(p10, "WaveEnv")

            v7.waveEnv = typeof(WaveEnv) == "Vector3" and {
                WaveEnv.X,
                WaveEnv.Y,
                WaveEnv.Z
            } or nil

            local ArmSway = attr(p10, "ArmSway")

            if type(ArmSway) == "number" then
                local t6 = {}

                for _, v22 in ipairs({
                        { "L", 1 },
                        { "R", -1 }
                    }) do
                    local v23 = mesh:FindFirstChild("Arm" .. v22[1] .. "_1", true)
                    local v24 = mesh:FindFirstChild("Arm" .. v22[1] .. "_2", true)

                    if v23 and v24 then
                        local v25 = v22[2]
                        local Unit = (CFrame:PointToObjectSpace(v24.WorldPosition) - CFrame:PointToObjectSpace(v23.WorldPosition)).Unit
                        local v26 = CFrame:ToObjectSpace(v23.WorldCFrame)
                        local v27 = CFrame:ToObjectSpace(v24.WorldCFrame)

                        t6[#t6 + 1] = {
                            b1 = v23,
                            b2 = v24,
                            sg = v25,
                            tilt = v26:VectorToObjectSpace(Unit:Cross((Vector3.new(0, 1, 0))).Unit),
                            twist = v26:VectorToObjectSpace(-v25 * Unit),
                            curl = v27:VectorToObjectSpace(-v25 * Vector3.new(0, 1, 0))
                        }
                    end
                end

                if #t6 > 0 then
                    v7.arms = t6
                    v7.armA = ArmSway
                end
            end

            return v7
        end,
        finSway = function(p13, p14) -- finSway | line: 193
            -- upvalues: p1 (copy), fightHooked (copy)
            local finSwayA = p13.finSwayA

            if not finSwayA then
                return
            end

            local SharkSwim = p1.SharkSwim

            p13.swayT += p14 * SharkSwim.SWAY_RATE * (fightHooked(p13.model) and SharkSwim.SWAY_HOOK or 1)

            local v28 = finSwayA * math.sin(p13.swayT)

            for v29, v30 in pairs(p13.fins) do
                v29.bone.Transform *= CFrame.fromAxisAngle(v30.up, v28)
            end
        end,
        armSway = function(p15, _, p17) -- armSway | line: 205
            -- upvalues: p1 (copy), fightHooked (copy)
            local arms = p15.arms

            if not arms then
                return
            end

            local SharkSwim = p1.SharkSwim
            local v31 = p15.phase / SharkSwim.ARM_BEATS
            local v32 = p15.armA * (fightHooked(p15.model) and SharkSwim.ARM_HOOK or 1)
            local v33 = if p17 then math.clamp(SharkSwim.BEND * p15.length * p15.w / math.max(p15.v, 5), -SharkSwim.BEND_MAX, SharkSwim.BEND_MAX) else 0

            for _, v37 in ipairs(arms) do
                local v38 = v31 + (if v37.sg > 0 then 0 else 3.141592653589793)
                local v39 = v32 * SharkSwim.ARM_TILT * math.sin(v38) - v37.sg * SharkSwim.ARM_BANK * v33
                local v42 = v32 * SharkSwim.ARM_TWIST * math.sin(v38 - SharkSwim.ARM_TWIST_LAG)
                local v45 = v32 * SharkSwim.ARM_CURL * math.sin(v38 - SharkSwim.ARM_CURL_LAG)

                v37.b1.Transform *= CFrame.fromAxisAngle(v37.tilt, v39) * CFrame.fromAxisAngle(v37.twist, v42)
                v37.b2.Transform *= CFrame.fromAxisAngle(v37.curl, v45)
            end
        end,
        readTurn = function(p18, p19) -- readTurn | line: 225
            -- upvalues: p1 (copy)
            local SharkSwim = p1.SharkSwim
            local CFrame = p18.mesh.CFrame
            local v46 = CFrame:VectorToWorldSpace(p18.nose)
            local v47 = Vector3.new(v46.X, 0, v46.Z)

            if p18.lastPos and p18.lastNose and p19 > 1E-04 and (CFrame.Position - p18.lastPos).Magnitude < 20 and v47.Magnitude > 0.001 then
                local lastNose = p18.lastNose
                local Unit = v47.Unit
                local v49 = math.atan2(lastNose:Cross(Unit).Y, (lastNose:Dot(Unit))) / p19
                local v50 = (CFrame.Position - p18.lastPos).Magnitude / p19

                p18.w = p18.w + (v49 - p18.w) * math.min(1, p19 / SharkSwim.W_TAU)
                p18.v = p18.v + (v50 - p18.v) * math.min(1, p19 / SharkSwim.V_TAU)
            end

            p18.lastPos = CFrame.Position

            if v47.Magnitude > 0.001 then
                p18.lastNose = v47.Unit
            end
        end,
        schoolSwim = function(p20, p21) -- schoolSwim | line: 243
            -- upvalues: p1 (copy), attr (copy)
            local SharkSwim = p1.SharkSwim
            local model = p20.model

            SharkSwim.readTurn(p20, p21)

            local length = p20.length
            local v55 = p20.v / math.max(length, 0.001)
            local v56 = attr(model, "WaveLength") or SharkSwim.WAVELENGTH

            p20.phase = p20.phase + p21 * 2 * 3.141592653589793 * math.max(v55 / (attr(model, "BeatStride") or SharkSwim.BEAT_STRIDE), SharkSwim.MIN_BEAT)
            p20.disp = p20.disp + ((if attr(model, "Display") then 1 else 0) - p20.disp) * math.min(1, p21 / SharkSwim.DISPLAY_TAU)

            local disp2 = p20.disp
            local v62 = math.clamp(v55 / SharkSwim.FULL_SPEED, SharkSwim.MIN_ENV, 1) * p20.ampMul * (1 + SharkSwim.DISPLAY_SWING * disp2)
            local v63 = v62
            local Labriform = attr(model, "Labriform")

            if Labriform then
                v63 = v62 * (SharkSwim.BODY_MIN + (1 - SharkSwim.BODY_MIN) * SharkSwim.gait(v55, Labriform))
                p20.pec = p20.pec + p21 * 2 * 3.141592653589793 * math.clamp(v55 / SharkSwim.PEC_STRIDE, SharkSwim.PEC_MIN_HZ, SharkSwim.PEC_MAX_HZ)
            end

            local v66 = p20.waveEnv or SharkSwim.ENV
            local phase2 = p20.phase

            local function h(p22) -- line: 260
                -- upvalues: v63 (ref), phase2 (copy), v66 (copy), v56 (copy)
                return v63 * (v66[1] + v66[2] * p22 + v66[3] * p22 * p22) / 2 * math.sin(phase2 - 6.283185307179586 * p22 / v56)
            end

            local v72 = math.clamp(SharkSwim.BEND * length * p20.w / math.max(p20.v, 5), -SharkSwim.BEND_MAX, SharkSwim.BEND_MAX)
            local chain = p20.chain
            local v75 = -v72 / math.max(#chain - 1, 1)
            local n1 = 0

            for v76, v77 in ipairs(chain) do
                local v78 = chain[v76 + 1] and chain[v76 + 1].x or 1
                local v79 = v66[1] + v66[2] * v78 + v66[3] * v78 * v78
                local v82 = v63 * v79 / 2 * math.sin(phase2 - 6.283185307179586 * v78 / v56)
                local x = v77.x
                local v83 = v66[1] + v66[2] * x + v66[3] * x * x
                local v89 = math.atan((v82 - v63 * v83 / 2 * math.sin(phase2 - 6.283185307179586 * x / v56)) / math.max(v78 - v77.x, 0.001))
                local v90 = v89 - n1

                n1 = v89

                if v76 > 1 then
                    v90 += v75
                end

                local v91 = CFrame.fromAxisAngle(v77.seg.axis, v90)

                if disp2 > 0.001 then
                    local fromAxisAngle = CFrame.fromAxisAngle
                    local pitch = v77.pitch
                    local DISPLAY_HEAD

                    if v76 == 1 then
                        DISPLAY_HEAD = SharkSwim.DISPLAY_HEAD

                        if not DISPLAY_HEAD then
                            DISPLAY_HEAD = SharkSwim.DISPLAY_ARCH / math.max(#chain - 1, 1)
                        end
                    else
                        DISPLAY_HEAD = SharkSwim.DISPLAY_ARCH / math.max(#chain - 1, 1)
                    end

                    v91 *= fromAxisAngle(pitch, disp2 * DISPLAY_HEAD)

                    if v76 == 1 then
                        v91 = CFrame.fromAxisAngle(v77.roll, disp2 * SharkSwim.DISPLAY_ROLL * math.sin(phase2)) * v91
                    end
                end

                if v76 == 1 then
                    local new = CFrame.new
                    local rootLat = p20.rootLat
                    local x = v77.x
                    local v94 = v66[1] + v66[2] * x + v66[3] * x * x

                    v91 = new(rootLat * (v63 * v94 / 2 * math.sin(phase2 - 6.283185307179586 * x / v56) * length)) * v91
                end

                v77.seg.bone.Transform = v91
            end

            for _, v97 in ipairs(p20.segs) do
                if not p20.inChain[v97] then
                    local v98 = p20.fins[v97]
                    local identity = CFrame.identity

                    if v98 then
                        if Labriform then
                            local v99, v100, v101 = SharkSwim.pec(p20.pec, v55, Labriform, attr(model, "PecRow") or 0, v98.sign)

                            identity = CFrame.fromAxisAngle(v98.axis, v99) * CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v100) * CFrame.fromAxisAngle(v98.up, v101)
                        end

                        if disp2 > 0.001 then
                            identity = CFrame.fromAxisAngle(v98.axis, v98.sign * SharkSwim.DISPLAY_FINS * disp2) * identity
                        end
                    end

                    v97.bone.Transform = identity
                end
            end
        end,
        update = function(p23, p24, p25) -- update | line: 294
            -- upvalues: p1 (copy), p2 (copy), fightHooked (copy), attr (copy)
            local SharkSwim = p1.SharkSwim
            local model = p23.model
            local StrokeAt = attr(model, "StrokeAt")
            local v102 = fightHooked(model)

            if not StrokeAt and not v102 and (attr(model, "School") or attr(model, "PassCruise")) and p23.chain and p23.chain[1] then
                p23.locked = nil
                SharkSwim.schoolSwim(p23, p24)
                SharkSwim.armSway(p23, p24, true)

                return SharkSwim.finSway(p23, p24)
            end

            local v103

            if not StrokeAt or v102 then
                p23.locked = nil
                p23.lastPos = nil
                p1.FishWave.update(p23, p24, p25)
                SharkSwim.armSway(p23, p24, false)

                return SharkSwim.finSway(p23, p24)
            else
                v103 = attr(model, "StrokeRate") or 0

                local v105 = (attr(model, "StrokePhase") or 0) + v103 * (workspace:GetServerTimeNow() - p2.renderLag() - StrokeAt)

                if p23.locked then
                    p23.phase += p24 * v103
                    p23.phase = p23.phase + ((v105 - p23.phase + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * math.min(1, p24 * SharkSwim.LOCK)
                else
                    p23.phase = v105
                    p23.locked = true
                end
            end

            SharkSwim.readTurn(p23, p24)

            local v109 = math.clamp((0.04 + 0.009 * v103 * (attr(model, "StrokeStride") or 0)) * p23.ampMul, 0.05, 0.6)
            local v114 = -math.clamp(SharkSwim.BEND * p23.length * p23.w / math.max(p23.v, 5), -SharkSwim.BEND_MAX, SharkSwim.BEND_MAX) / math.max(p23.nBody, 1)

            for _, v115 in ipairs(p23.segs) do
                local v118 = v109 * v115.gain * math.sin(p23.phase - v115.t * (p23.waveK or 2.6))

                if p23.body[v115] then
                    v118 += v114
                end

                v115.bone.Transform = CFrame.fromAxisAngle(v115.axis, v118)
            end

            SharkSwim.armSway(p23, p24, false)
            SharkSwim.finSway(p23, p24)
        end
    }
end
