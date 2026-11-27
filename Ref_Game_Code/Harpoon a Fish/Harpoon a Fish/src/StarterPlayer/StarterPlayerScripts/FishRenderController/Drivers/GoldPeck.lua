-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.GoldPeck = {
        PECK = 0.45,
        DOWN = 0.12,
        UP = 0.35,
        PAUSE_EASE = 4,
        EVERY = { 0.5, 0.9 },
        FIRST = { 0.2, 0.5 },
        register = function(p3) -- register | line: 17
            -- upvalues: p1 (copy)
            local v1 = p1.SailFlag.register(p3)

            if not v1 then
                return nil
            end

            local v2 = v1.mesh:FindFirstChild("Spine_01", true)
            local nose = v1.nose
            local Unit = nose:Cross((Vector3.new(0, 1, 0) - nose * nose.Y).Unit).Unit

            v1.root = {
                bone = v2,
                right = v1.mesh.CFrame:ToObjectSpace(v2.WorldCFrame):VectorToObjectSpace(Unit)
            }
            v1.pauseS = 0
            v1.peckT = 99
            v1.nextPeck = 0

            return v1
        end,
        update = function(p4, p5, p6) -- update | line: 28
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local GoldPeck = p1.GoldPeck

            p1.SailFlag.update(p4, p5, p6)

            local model = p4.model
            local v3 = fightHooked(model)
            local n1 = 1

            if attr(model, "StrokeAt") then
                n1 = if v3 then 1 else (attr(model, "StrokeRate") or 0) / math.max(attr(model, "StrokeCruise") or 1, 0.001)
            end

            local v6 = if v3 then 0 else math.clamp((0.5 - n1) / 0.3, 0, 1)

            p4.pauseS = p4.pauseS + (v6 - p4.pauseS) * math.min(1, p5 * GoldPeck.PAUSE_EASE)

            if p4.pauseS > 0.6 then
                p4.nextPeck -= p5

                if p4.nextPeck <= 0 then
                    p4.peckT = 0
                    p4.nextPeck = GoldPeck.EVERY[1] + math.random() * (GoldPeck.EVERY[2] - GoldPeck.EVERY[1])
                end
            else
                p4.nextPeck = GoldPeck.FIRST[1] + math.random() * (GoldPeck.FIRST[2] - GoldPeck.FIRST[1])
            end

            p4.peckT += p5

            local peckT = p4.peckT
            local n2 = 0

            if peckT < GoldPeck.DOWN then
                local v10 = peckT / GoldPeck.DOWN

                n2 = v10 * v10 * (3 - 2 * v10)
            elseif peckT < GoldPeck.DOWN + GoldPeck.UP then
                local v11 = (peckT - GoldPeck.DOWN) / GoldPeck.UP

                n2 = 1 - v11 * v11 * (3 - 2 * v11)
            end

            p4.root.bone.Transform = CFrame.fromAxisAngle(p4.root.right, -GoldPeck.PECK * p4.pauseS * n2) * p4.root.bone.Transform
        end
    }
end
