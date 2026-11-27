-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.SailFlag = {
        SAIL_BACK = 0.5,
        FLUT0 = 0.06,
        FLUT1 = 0.16,
        LAG = 0.8,
        FLAG_RATE0 = 2,
        FLAG_RATE1 = 6,
        register = function(p3) -- register | line: 16
            -- upvalues: p1 (copy)
            local v1 = p1.SharkSwim.register(p3)

            if not v1 then
                return nil
            end

            local CFrame = v1.mesh.CFrame
            local nose = v1.nose
            local Unit = nose:Cross((Vector3.new(0, 1, 0) - nose * nose.Y).Unit).Unit

            v1.sails = {}

            for i = 1, 4 do
                local v2 = v1.mesh:FindFirstChild("Sail_" .. i, true)

                if not v2 then
                    return nil
                end

                local v3 = CFrame:ToObjectSpace(v2.WorldCFrame)

                v1.sails[i] = {
                    bone = v2,
                    k = i,
                    right = v3:VectorToObjectSpace(Unit),
                    nose = v3:VectorToObjectSpace(nose)
                }
            end

            local v4 = math.random() * 6.28

            v1.sp = 0.4
            v1.flag = v4

            return v1
        end,
        update = function(p4, p5, p6) -- update | line: 33
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local SailFlag = p1.SailFlag

            p1.SharkSwim.update(p4, p5, p6)

            local model = p4.model
            local v5 = fightHooked(model)
            local v8 = (attr(model, "StrokeCruise") or 4) * math.max(attr(model, "StrokeStride") or 0, 0.1)
            local n1 = 0.4

            if v5 then
                n1 = 1.3
            elseif attr(model, "StrokeAt") then
                n1 = math.clamp((p4.v or 0) / math.max(v8, 1), 0, 1.3)
            end

            p4.sp = p4.sp + (n1 - p4.sp) * math.min(1, p5 * 3)
            p4.flag += p5 * (SailFlag.FLAG_RATE0 + SailFlag.FLAG_RATE1 * p4.sp)

            for _, v12 in ipairs(p4.sails) do
                v12.bone.Transform = CFrame.fromAxisAngle(v12.right, SailFlag.SAIL_BACK * p4.sp * (0.7 + 0.1 * v12.k)) * CFrame.fromAxisAngle(v12.nose, (SailFlag.FLUT0 + SailFlag.FLUT1 * p4.sp) * math.sin(p4.flag - SailFlag.LAG * v12.k))
            end
        end
    }
end
