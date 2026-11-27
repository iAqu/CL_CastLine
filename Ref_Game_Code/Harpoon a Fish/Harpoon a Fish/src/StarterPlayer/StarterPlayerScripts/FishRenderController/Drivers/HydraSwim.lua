-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked = p2.fightHooked

    p1.HydraSwim = {
        SWAY = 0.1,
        PITCH = 0.06,
        RATE = 1.4,
        LAG = 0.7,
        RATE_DISP = 3.2,
        REAR = 0.14,
        SWAY_HOOK = 0.16,
        RATE_HOOK = 7,
        GOLD = 2.39996,
        STRIKE_TIME = 0.8,
        STRIKE_UP = 0.4,
        STRIKE_HIT = 0.15,
        STRIKE_REAR = 0.55,
        STRIKE_SNAP = -0.22,
        STRIKE_EVERY = { 2.2, 4.5 },
        smooth = function(p3) -- smooth | line: 20
            local v1 = math.clamp(p3, 0, 1)

            return v1 * v1 * (3 - 2 * v1)
        end,
        strikePitch = function(p4) -- strikePitch | line: 25
            -- upvalues: p1 (copy)
            local HydraSwim = p1.HydraSwim

            if p4 <= 0 or p4 >= 1 then
                return 0
            end

            if p4 < HydraSwim.STRIKE_UP then
                return HydraSwim.STRIKE_REAR * HydraSwim.smooth(p4 / HydraSwim.STRIKE_UP)
            end

            if p4 < HydraSwim.STRIKE_UP + HydraSwim.STRIKE_HIT then
                return HydraSwim.STRIKE_REAR + (HydraSwim.STRIKE_SNAP - HydraSwim.STRIKE_REAR) * HydraSwim.smooth((p4 - HydraSwim.STRIKE_UP) / HydraSwim.STRIKE_HIT)
            end

            return HydraSwim.STRIKE_SNAP * (1 - HydraSwim.smooth((p4 - HydraSwim.STRIKE_UP - HydraSwim.STRIKE_HIT) / (1 - HydraSwim.STRIKE_UP - HydraSwim.STRIKE_HIT)))
        end,
        pose = function(p5, p6, p7, p8, p9, p10, p11, p12) -- pose | line: 34
            -- upvalues: p1 (copy)
            local HydraSwim = p1.HydraSwim

            p11 = p11 or 1
            p12 = p12 or 0

            local v4 = if p10 then HydraSwim.SWAY_HOOK else HydraSwim.SWAY * p11
            local v5 = if p10 then HydraSwim.RATE_HOOK else HydraSwim.RATE + (HydraSwim.RATE_DISP - HydraSwim.RATE) * p9
            local t2 = {}

            for i = 1, p6 do
                local v6 = v5 * p8 + HydraSwim.GOLD * p5 - HydraSwim.LAG * i

                t2[i] = {
                    v4 * math.sin(v6),
                    v4 / HydraSwim.SWAY * HydraSwim.PITCH * math.cos(v6) + HydraSwim.REAR * p9 * p7 / p6 + p12 / p6
                }
            end

            return t2
        end,
        register = function(p13) -- register | line: 50
            -- upvalues: p1 (copy)
            local v7 = p1.SharkSwim.register(p13)

            if not v7 then
                return nil
            end

            local CFrame = v7.mesh.CFrame
            local nose = v7.nose
            local Unit = (Vector3.new(0, 1, 0) - nose * nose.Y).Unit
            local Unit2 = nose:Cross(Unit).Unit
            local t3 = {}

            for _, descendant in ipairs(v7.mesh:GetDescendants()) do
                local v8, v9

                if descendant:IsA("Bone") then
                    v8, v9 = string.match(descendant.Name, "^(Head%w*)_(%d+)$")
                end

                if v8 then
                    t3[v8] = t3[v8] or {}
                    t3[v8][tonumber(v9)] = descendant
                end
            end

            local t4 = {}

            for v10 in pairs(t3) do
                t4[#t4 + 1] = v10
            end

            table.sort(t4)

            if #t4 == 0 then
                return nil
            end

            v7.heads = {}

            local n1 = 0

            for v11, v12 in ipairs(t4) do
                local v13 = t3[v12]
                local t5 = {}

                for i = 1, #v13 do
                    local v14 = v13[i]
                    local v15 = CFrame:ToObjectSpace(v14.WorldCFrame)

                    t5[i] = {
                        bone = v14,
                        up = v15:VectorToObjectSpace(Unit),
                        right = v15:VectorToObjectSpace(Unit2)
                    }
                end

                local v16 = CFrame:PointToObjectSpace(v13[#v13].WorldPosition):Dot(Unit)

                v7.heads[v11] = {
                    k = v11,
                    bones = t5,
                    z = v16
                }
                n1 += v16 / #t4
            end

            for _, v17 in ipairs(v7.heads) do
                v17.side = n1 < v17.z and 1 or -1
            end

            v7.hydraT = math.random() * 10
            v7.headAmp = p13:GetAttribute("HeadSway") or 1

            if p13:GetAttribute("HeadStrike") == true then
                local STRIKE_EVERY = p1.HydraSwim.STRIKE_EVERY

                for _, v18 in ipairs(v7.heads) do
                    v18.nextStrike = v7.hydraT + STRIKE_EVERY[1] + math.random() * (STRIKE_EVERY[2] - STRIKE_EVERY[1]) * 1.5
                end
            end

            return v7
        end,
        update = function(p14, p15, p16) -- update | line: 93
            -- upvalues: p1 (copy), fightHooked (copy)
            local HydraSwim = p1.HydraSwim

            p1.SharkSwim.update(p14, p15, p16)
            p14.hydraT += p15

            local v19 = fightHooked(p14.model)
            local hydraT = p14.hydraT

            for _, v20 in ipairs(p14.heads) do
                local n2 = 0

                if v20.nextStrike then
                    if v19 then
                    elseif v20.strikeAt then
                        local v21 = (hydraT - v20.strikeAt) / HydraSwim.STRIKE_TIME

                        if v21 >= 1 then
                            v20.strikeAt = nil
                            v20.nextStrike = hydraT + HydraSwim.STRIKE_EVERY[1] + math.random() * (HydraSwim.STRIKE_EVERY[2] - HydraSwim.STRIKE_EVERY[1])
                        else
                            n2 = HydraSwim.strikePitch(v21)
                        end
                    elseif v20.nextStrike <= hydraT then
                        v20.strikeAt = hydraT
                    end
                end

                local v22 = HydraSwim.pose(v20.k, #v20.bones, v20.side, hydraT, p14.disp or 0, v19, p14.headAmp, n2)

                for v23, v24 in ipairs(v20.bones) do
                    v24.bone.Transform = CFrame.fromAxisAngle(v24.up, v22[v23][1]) * CFrame.fromAxisAngle(v24.right, v22[v23][2])
                end
            end
        end
    }
end
