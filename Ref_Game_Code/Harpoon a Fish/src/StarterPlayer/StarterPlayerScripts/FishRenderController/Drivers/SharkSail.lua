-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 4
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.SharkSail = {
        SAIL_AMP = 0.18,
        SAIL_IDLE = 0.1,
        SAIL_RATE = 1.4,
        SAIL_K = 0.9,
        SAIL_LAG = 0.9,
        SAIL_TIP = 1.2,
        SAIL_SWEEP = 0.25,
        SAIL_MAX = 0.35,
        LEAN = 0.15,
        LEAN_REF = 1.5,
        FIN_AMP = 0.25,
        FIN_RATE = 1.2,
        FLUT_RATE = 7,
        SP_BL = 1,
        SP_EASE = 3,
        HOOK_RATE = 13,
        HOOK_EFFORT = 1.6,
        PEN_RATE = 4,
        register = function(p3) -- register | line: 28
            -- upvalues: p1 (copy)
            local v1 = p1.SharkSwim.register(p3)

            if not v1 then
                return nil
            end

            local CFrame = v1.mesh.CFrame
            local nose, up = v1.nose, v1.up
            local Unit = nose:Cross(up).Unit

            local function axes(p4) -- line: 35
                -- upvalues: CFrame (copy), nose (copy), up (copy), Unit (copy)
                local v2 = CFrame:ToObjectSpace(p4.WorldCFrame)

                return {
                    bone = p4,
                    up = v2:VectorToObjectSpace(up),
                    right = v2:VectorToObjectSpace(Unit),
                    nose = v2:VectorToObjectSpace(nose)
                }
            end

            local t2 = {}
            local t3 = {}
            local t4 = {}

            for _, descendant in ipairs(v1.mesh:GetDescendants()) do
                if descendant:IsA("Bone") then
                    local v3, v4, v5 = descendant.Name:match("^(%a+)_(%d+)_(%d+)$")

                    if v3 == "Dorsal" or v3 == "Anal" then
                        local v6 = if v3 == "Dorsal" then 1 else -1

                        t2[#t2 + 1] = {
                            a = axes(descendant),
                            sg = v6,
                            s = tonumber(v4),
                            l = tonumber(v5)
                        }
                        t3[v6] = math.max(t3[v6] or 1, (tonumber(v4)))
                    elseif descendant.Name == "Fin_L" or descendant.Name == "Fin_R" then
                        t4[descendant.Name] = axes(descendant)
                    end
                end
            end

            v1.sail = {
                sp = 0.4,
                lean = 0,
                sails = t2,
                nsec = t3,
                finL = t4.Fin_L,
                finR = t4.Fin_R,
                ph = math.random() * 6.28,
                fin = math.random() * 6.28,
                flut = math.random() * 6.28
            }

            return v1
        end,
        update = function(p5, p6, p7) -- update | line: 56
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local SharkSail = p1.SharkSail

            p1.SharkSwim.update(p5, p6, p7)

            local model, sail = p5.model, p5.sail
            local StrokeAt = attr(model, "StrokeAt")
            local v10 = fightHooked(model)
            local HOOK_EFFORT, v11

            if StrokeAt and not v10 and p5.locked then
                local v12 = attr(model, "StrokeRate") or 0

                HOOK_EFFORT = v12 / math.max(attr(model, "StrokeCruise") or v12, 0.001)
                v11 = p5.phase
            else
                local ph = sail.ph
                local HOOK_RATE = if v10 then SharkSail.HOOK_RATE else nil

                if not v10 or not HOOK_RATE then
                    HOOK_RATE = attr(model, "StrokeHz") or SharkSail.PEN_RATE
                end

                sail.ph = ph + p6 * HOOK_RATE

                if v10 then
                    HOOK_EFFORT = SharkSail.HOOK_EFFORT
                end

                if not v10 or not HOOK_EFFORT then
                    HOOK_EFFORT = 1
                end

                v11 = sail.ph
            end

            sail.fin += p6 * SharkSail.FIN_RATE
            sail.flut += p6 * SharkSail.FLUT_RATE

            local v14 = math.max(HOOK_EFFORT, 0)
            local v17 = math.min(v14, 1) * (math.clamp(v14 - 1, 0, 1) * 0.2 + 1)

            if sail.finL and sail.finR then
                sail.finL.bone.Transform = CFrame.fromAxisAngle(sail.finL.up, SharkSail.FIN_AMP * math.sin(sail.flut))
                sail.finR.bone.Transform = CFrame.fromAxisAngle(sail.finR.up, -SharkSail.FIN_AMP * math.sin(sail.flut + 3.141592653589793))
            end

            local n1 = 0.4

            if v10 then
                n1 = 1.3
            elseif StrokeAt then
                n1 = math.clamp((p5.v or 0) / math.max(SharkSail.SP_BL * p5.length, 1), 0, 1.3)
            end

            sail.sp = sail.sp + (n1 - sail.sp) * math.min(1, p6 * SharkSail.SP_EASE)

            local v25 = if v10 or not StrokeAt then 0 else math.clamp((p5.w or 0) / SharkSail.LEAN_REF, -1, 1)

            sail.lean = sail.lean + (v25 - sail.lean) * math.min(1, p6 * 4)

            local v29 = math.min(v17, 1)

            for _, v30 in ipairs(sail.sails) do
                local v33 = (v30.s - 1) / math.max(sail.nsec[v30.sg] - 1, 1)
                local v34 = SharkSail.SAIL_K * v33 + SharkSail.SAIL_LAG * (v30.l - 1)
                local v43 = math.clamp((if v30.l == 1 then 1 else SharkSail.SAIL_TIP) * (SharkSail.SAIL_AMP * v17 * math.sin(v11 - 0.9 - v34) + SharkSail.SAIL_IDLE * (1 - v29 * 0.5) * math.sin(SharkSail.SAIL_RATE * sail.fin - v34 + (if v30.sg == 1 then 0 else 2)) + SharkSail.LEAN * sail.lean), -SharkSail.SAIL_MAX, SharkSail.SAIL_MAX)
                local v44 = SharkSail.SAIL_SWEEP * sail.sp * (if v30.l == 1 then 1 else 0.5)

                v30.a.bone.Transform = CFrame.fromAxisAngle(v30.a.right, v30.sg * v44) * CFrame.fromAxisAngle(v30.a.nose, v30.sg * v43)
            end
        end
    }
end
