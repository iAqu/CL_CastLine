-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.LanternSwim = {
        ROD_SCALE = 0.5,
        PEND_K = 18,
        PEND_C = 3.4,
        PEND_SURGE = 0.027,
        PEND_TURN = 0.011,
        PEND_IDLE = 0.05,
        PEND_MAX = 0.45,
        register = function(p3) -- register | line: 27
            -- upvalues: p1 (copy), attr (copy)
            local v1 = p1.AnglerSwim.register(p3)

            if not v1 then
                return nil
            end

            local v2 = v1.mesh:FindFirstChild("Lantern", true)

            if not v2 then
                return nil
            end

            local CFrame = v1.mesh.CFrame
            local nose = v1.nose
            local Unit = (Vector3.new(0, 1, 0) - nose * nose.Y).Unit
            local Unit2 = nose:Cross(Unit).Unit
            local v3 = CFrame:ToObjectSpace(v2.WorldCFrame)

            v1.lan = {
                bone = v2,
                up = v3:VectorToObjectSpace(Unit),
                right = v3:VectorToObjectSpace(Unit2),
                nose = v3:VectorToObjectSpace(nose)
            }
            v1.pf = 0
            v1.pfv = 0
            v1.ps = 0
            v1.psv = 0
            v1.lanSwing = attr(p3, "LanternSwing")

            return v1
        end,
        update = function(p4, p5, p6) -- update | line: 42
            -- upvalues: p1 (copy), fightHooked (copy)
            local LanternSwim, AnglerSwim = p1.LanternSwim, p1.AnglerSwim

            AnglerSwim.update(p4, p5, p6)

            local v4 = p4.lp * LanternSwim.ROD_SCALE
            local v5 = p4.ly * LanternSwim.ROD_SCALE

            for v6, v7 in ipairs(p4.lure) do
                local v8 = AnglerSwim.LURE_FRAC[v6]

                v7.bone.Transform = CFrame.fromAxisAngle(v7.up, v5 * v8) * CFrame.fromAxisAngle(v7.lat, v4 * v8)
            end

            local v9 = math.min(p5, 0.03333333333333333)
            local v10 = if fightHooked(p4.model) then 4 else 1
            local v11 = p4.lanSwing or 1
            local v18 = math.clamp(v11 * (-LanternSwim.PEND_SURGE * p4.acc + LanternSwim.PEND_IDLE * v10 * math.sin(1.3 * p4.t)), -LanternSwim.PEND_MAX * v11, LanternSwim.PEND_MAX * v11)
            local v25 = math.clamp(v11 * (-LanternSwim.PEND_TURN * p4.v * p4.w + LanternSwim.PEND_IDLE * v10 * math.sin(0.9 * p4.t + 2)), -LanternSwim.PEND_MAX * v11, LanternSwim.PEND_MAX * v11)

            p4.pfv += (LanternSwim.PEND_K * (v18 - p4.pf) - LanternSwim.PEND_C * p4.pfv) * v9
            p4.pf += p4.pfv * v9
            p4.psv += (LanternSwim.PEND_K * (v25 - p4.ps) - LanternSwim.PEND_C * p4.psv) * v9
            p4.ps += p4.psv * v9

            local lan = p4.lan

            lan.bone.Transform = CFrame.fromAxisAngle(lan.up, -v5) * CFrame.fromAxisAngle(lan.right, -v4 + p4.pf) * CFrame.fromAxisAngle(lan.nose, p4.ps)
        end
    }
end
