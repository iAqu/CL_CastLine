-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.PerchScan = {
        SCAN = 0.35,
        SCAN_PERIOD = 1.8,
        SCAN_EASE = 4,
        register = function(p3) -- register | line: 19
            -- upvalues: p1 (copy)
            local v1 = p1.SpikeSwim.register(p3)

            if not v1 then
                return nil
            end

            local CFrame = v1.mesh.CFrame
            local nose = v1.nose
            local Unit = (Vector3.new(0, 1, 0) - nose * nose.Y).Unit

            local function upOf(p4) -- line: 25
                -- upvalues: v1 (copy), CFrame (copy), Unit (copy)
                local v2 = v1.mesh:FindFirstChild(p4, true)

                return v2 and {
                    bone = v2,
                    up = CFrame:ToObjectSpace(v2.WorldCFrame):VectorToObjectSpace(Unit)
                }
            end

            v1.pecs = {}

            for _, v3 in ipairs({
                    { "Fin_L", 1 },
                    { "Fin_R", -1 }
                }) do
                local v4 = upOf(v3[1])

                if not v4 then
                    return nil
                end

                v4.side = v3[2]
                v1.pecs[#v1.pecs + 1] = v4
            end

            local Spine_01 = upOf("Spine_01")
            local Spine_02 = upOf("Spine_02")

            v1.head = Spine_01
            v1.neck = Spine_02

            if not (v1.head and v1.neck) then
                return nil
            end

            local v5 = math.random() * 6.28
            local v6 = math.random() * 2

            v1.pfin = v5
            v1.scanS = 0
            v1.lookT = v6

            return v1
        end,
        update = function(p5, p6, p7) -- update | line: 41
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local PerchScan, RockFan = p1.PerchScan, p1.RockFan

            p1.SpikeSwim.update(p5, p6, p7)

            local model = p5.model
            local v7 = fightHooked(model)
            local v8 = if attr(model, "School") then 1 else p1.SpikeSwim.PEN_EFFORT

            if v7 then
                v8 = 0
            elseif attr(model, "StrokeAt") then
                v8 = (attr(model, "StrokeRate") or 0) / math.max(attr(model, "StrokeCruise") or 1, 0.001)
            end

            p5.pfin += p6 * (v7 and 3 or 1)

            local v11 = 1 - math.clamp(v8, 0, 1)
            local v13 = math.clamp(v8 - 1, 0, 0.5) / 0.5
            local v19 = v11 * RockFan.HOVER_OPEN * (math.sin(RockFan.HOVER_RATE * p5.pfin) * 0.5 + 0.5) + (1 - v11) * (1 - v13) * RockFan.CRUISE_OPEN * (math.sin(p5.phase or 0) * 0.5 + 0.5)

            for _, v20 in ipairs(p5.pecs) do
                v20.bone.Transform = CFrame.fromAxisAngle(v20.up, -v20.side * v19)
            end

            local v21 = if v7 then 0 else math.clamp((0.5 - v8) / 0.3, 0, 1)

            p5.scanS = p5.scanS + (v21 - p5.scanS) * math.min(1, p6 * PerchScan.SCAN_EASE)
            p5.lookT += p6 * p5.scanS

            local v28 = PerchScan.SCAN * p5.scanS * math.tanh(math.sin(6.283185307179586 * p5.lookT / PerchScan.SCAN_PERIOD) * 3) / 0.9950547536867305

            p5.head.bone.Transform = CFrame.fromAxisAngle(p5.head.up, v28) * p5.head.bone.Transform
            p5.neck.bone.Transform = CFrame.fromAxisAngle(p5.neck.up, -v28) * p5.neck.bone.Transform
        end
    }
end
