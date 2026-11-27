-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.MawSnap = {
        BREATH = 0.05,
        BREATH_RATE = 1.1,
        GAPE_WIDE = -0.22,
        SHUT = 0.7,
        CHOMPS = 3,
        CHOMP_T = 0.34,
        HOLD = 0.12,
        SNAP_EASE = 30,
        OPEN_EASE = 9,
        HOOK_RATE = 8,
        FLAG_AMP0 = 0.08,
        FLAG_AMP1 = 0.14,
        FLAG_RATE0 = 3,
        FLAG_RATE1 = 6,
        FLAG_LAG = 0.9,
        FLAG_FULL = 1.5,
        SCULL_RATE = 7,
        SCULL_FULL = 1,
        SCULL_MIN = 0.3,
        SCULL_HEAVE = 0.5,
        target = function(p3, p4, p5, p6, p7, p8, p9) -- target | line: 40
            -- upvalues: p1 (copy)
            local MawSnap = p1.MawSnap

            p8 = p8 or MawSnap.SHUT

            if p5 then
                return p8 * (math.sin(p6 * MawSnap.HOOK_RATE) * 0.5 + 0.5)
            end

            local CHOMPS, CHOMP_T, HOLD = MawSnap.CHOMPS, MawSnap.CHOMP_T, MawSnap.HOLD
            local v3, v4, v5, v6

            if p9 then
                local v7 = p9.chomps or CHOMPS
                local v8 = p9.chompT or CHOMP_T
                local v9 = p9.hold or HOLD

                if p3 < 0 then
                    v3 = p9.gape or MawSnap.GAPE_WIDE

                    return v3
                else
                    v6 = v9
                    v4 = v7
                    v5 = v8
                end
            else
                v6 = HOLD
                v4 = CHOMPS
                v5 = CHOMP_T
            end

            if p3 < v4 * v5 then
                local v10, v11

                if p3 % v5 < v6 and p8 then
                    v10 = p8
                    v11 = true
                elseif p9 then
                    local reopen = p9.reopen

                    if reopen then
                        v10 = reopen
                        v11 = true
                    else
                        v11 = false
                    end
                else
                    v11 = false
                end

                if not v11 then
                    v10 = 0
                end

                return v10
            end

            local v13 = (p9 and p9.rest or 0) + MawSnap.BREATH * (math.sin(MawSnap.BREATH_RATE * p7) * 0.5 + 0.5)

            return v13 + (MawSnap.GAPE_WIDE - v13) * p4
        end,
        register = function(p10) -- register | line: 59
            -- upvalues: p1 (copy), attr (copy)
            local v14 = p1.AnglerSwim.register(p10) or p1.SharkSwim.register(p10)

            if not v14 then
                return nil
            end

            local v15 = v14.mesh:FindFirstChild("Jaw", true)

            if not v15 then
                return nil
            end

            local CFrame = v14.mesh.CFrame
            local nose = v14.nose
            local Unit = (Vector3.new(0, 1, 0) - nose * nose.Y).Unit
            local Unit2 = nose:Cross(Unit).Unit

            v14.jaw = {
                bone = v15,
                right = CFrame:ToObjectSpace(v15.WorldCFrame):VectorToObjectSpace(Unit2)
            }

            local v16 = math.random() * 6.28

            v14.jawAngle = 0
            v14.jawFin = v16
            v14.since = 99
            v14.wasDisp = false
            v14.lastGulp = attr(p10, "Gulp")
            v14.shut = attr(p10, "JawShut")

            local t2 = {}
            local t3 = {}

            for _, descendant in ipairs(v14.mesh:GetDescendants()) do
                local v17, v18

                if descendant:IsA("Bone") then
                    v17, v18 = descendant.Name:match("^(Flag%w*)_(%d+)$")
                end

                if v17 then
                    if not t2[v17] then
                        t2[v17] = {}
                        t3[#t3 + 1] = v17
                    end

                    t2[v17][tonumber(v18)] = descendant
                end
            end

            table.sort(t3)

            local t4 = {}
            local v19 = math.random() * 10

            v14.flags = t4
            v14.flagT = v19

            for v20, v21 in ipairs(t3) do
                for v22, v23 in ipairs(t2[v21]) do
                    local v24 = CFrame:ToObjectSpace(v23.WorldCFrame)

                    v14.flags[#v14.flags + 1] = {
                        bone = v23,
                        k = v22,
                        n = #t2[v21],
                        off = v20 * 1.7,
                        up = v24:VectorToObjectSpace(Unit)
                    }
                end
            end

            local t5 = {
                bite = attr(p10, "JawBite"),
                idle = attr(p10, "JawIdle"),
                chomps = attr(p10, "JawChomps"),
                chompT = attr(p10, "JawChompT"),
                hold = attr(p10, "JawHold"),
                wind = attr(p10, "JawWind"),
                gape = attr(p10, "JawGape"),
                lift = attr(p10, "JawLift"),
                shake = attr(p10, "JawShake"),
                scull = attr(p10, "FinScull"),
                rest = attr(p10, "JawRest"),
                reopen = attr(p10, "JawReopen")
            }

            if next(t5) then
                v14.biteO = t5
                v14.lastE = 0
                v14.idleAt = t5.idle and t5.idle * math.random() or nil

                if t5.scull then
                    local t6 = {}
                    local v25 = math.random() * 6.28

                    v14.sculls = t6
                    v14.scullT = v25

                    for v26, v27 in pairs(v14.fins or {}) do
                        local v28 = CFrame:ToObjectSpace(v26.bone.WorldCFrame)

                        v14.sculls[#v14.sculls + 1] = {
                            bone = v26.bone,
                            nose = v27.axis,
                            sign = v27.sign,
                            right = v28:VectorToObjectSpace(Unit2)
                        }
                    end
                end
            end

            return v14
        end,
        update = function(p11, p12, p13) -- update | line: 112
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local MawSnap = p1.MawSnap;

            (p11.lure and p1.AnglerSwim or p1.SharkSwim).update(p11, p12, p13)

            local model = p11.model
            local v29 = not not attr(model, "Display")

            if p11.wasDisp and not v29 then
                p11.since = 0
            end

            p11.wasDisp = v29

            local Gulp = attr(model, "Gulp")

            if Gulp and Gulp ~= p11.lastGulp then
                p11.lastGulp = Gulp
                p11.since = 0
            end

            local v30 = fightHooked(model)
            local biteO = p11.biteO

            if biteO then
                MawSnap.biteStart(p11, biteO, p12, v29, v30)
            end

            p11.since += p12
            p11.jawFin += p12

            local v31 = MawSnap.target(p11.since, p11.disp or 0, v30, p13, p11.jawFin, p11.shut, biteO)
            local SNAP_EASE = p11.jawAngle < v31 and MawSnap.SNAP_EASE or MawSnap.OPEN_EASE

            p11.jawAngle = p11.jawAngle + (v31 - p11.jawAngle) * math.min(1, p12 * SNAP_EASE)
            p11.jaw.bone.Transform = CFrame.fromAxisAngle(p11.jaw.right, p11.jawAngle)

            if biteO then
                MawSnap.biteBody(p11, biteO, p12)
            end

            if not (#p11.flags > 0) then
                return
            end

            local v35 = math.clamp(p11.v / math.max(p11.length, 0.001) / MawSnap.FLAG_FULL, 0, 1)

            p11.flagT += p12 * (MawSnap.FLAG_RATE0 + MawSnap.FLAG_RATE1 * v35)

            local v36 = MawSnap.FLAG_AMP0 + MawSnap.FLAG_AMP1 * v35

            for _, v37 in ipairs(p11.flags) do
                v37.bone.Transform = CFrame.fromAxisAngle(v37.up, v36 * v37.k / v37.n * math.sin(p11.flagT - MawSnap.FLAG_LAG * v37.k + v37.off))
            end
        end,
        bite = function(p14, p15) -- bite | line: 149
            local biteO = p14.biteO
            local v40, v41

            if biteO then
                local v42 = -(p15 or biteO.wind or 0)

                if v42 then
                    v40 = v42
                    v41 = true
                else
                    v41 = false
                end
            else
                v41 = false
            end

            p14.since = if not v41 then 0 else v40
        end,
        biteStart = function(p16, p17, p18, p19, p20) -- biteStart | line: 154
            -- upvalues: p1 (copy), attr (copy)
            local MawSnap = p1.MawSnap
            local model = p16.model
            local v43 = p16.since < (p17.chomps or MawSnap.CHOMPS) * (p17.chompT or MawSnap.CHOMP_T)
            local v44, v45, v46

            if not p17.bite or not attr(model, "StrokeAt") or p20 then
                v45 = false
            else
                v44 = (attr(model, "StrokeRate") or 0) / math.max(attr(model, "StrokeCruise") or 1, 0.001)
                v46 = p17.bite < v44 and p16.lastE <= p17.bite
                v45 = v46
                p16.lastE = v44
            end

            if p17.idle and not (p20 or p19) then
                p16.idleAt -= p18

                if p16.idleAt <= 0 then
                    v45 = true
                    p16.idleAt = p17.idle * (0.5 + math.random())
                end
            end

            if v45 and not v43 then
                p16.since = -(p17.wind or 0)
            end
        end,
        biteBody = function(p21, p22, p23) -- biteBody | line: 175
            -- upvalues: p1 (copy)
            local MawSnap = p1.MawSnap
            local v49 = p21.chain and p21.chain[1]
            local v50 = p21.chain and p21.chain[2]

            if (p22.lift or p22.shake) and v49 and v50 then
                local v51 = p22.lift and p22.lift * math.clamp(-p21.jawAngle / math.max(-(p22.gape or MawSnap.GAPE_WIDE), 0.001), 0, 1) or 0
                local v55 = p22.chompT or MawSnap.CHOMP_T
                local v56 = (p22.chomps or MawSnap.CHOMPS) * v55
                local v57 = if p22.shake and p21.since >= 0 and p21.since < v56 then p22.shake * (1 - p21.since / v56) * math.sin(6.283185307179586 * p21.since / v55) else 0

                v49.seg.bone.Transform *= CFrame.fromAxisAngle(v49.pitch, v51) * CFrame.fromAxisAngle(v49.seg.axis, v57)
                v50.seg.bone.Transform *= CFrame.fromAxisAngle(v50.pitch, -v51) * CFrame.fromAxisAngle(v50.seg.axis, -v57)
            end

            if not (p22.scull and p21.sculls) then
                return
            end

            p21.scullT += p23 * MawSnap.SCULL_RATE

            local v63 = 1 - math.clamp((p21.v or 0) / math.max(p21.length * MawSnap.SCULL_FULL, 0.001), 0, 1)
            local v64 = p22.scull * (MawSnap.SCULL_MIN + (1 - MawSnap.SCULL_MIN) * v63)

            for _, v65 in ipairs(p21.sculls) do
                local bone = v65.bone

                bone.Transform = bone.Transform * (CFrame.fromAxisAngle(v65.nose, v65.sign * MawSnap.SCULL_HEAVE * v64 * math.cos(p21.scullT)) * CFrame.fromAxisAngle(v65.right, v64 * math.sin(p21.scullT)))
            end
        end
    }
end
