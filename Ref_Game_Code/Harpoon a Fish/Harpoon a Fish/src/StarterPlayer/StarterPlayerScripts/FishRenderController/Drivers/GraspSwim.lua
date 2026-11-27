-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 10
    local fightHooked = p2.fightHooked

    p1.GraspSwim = {
        HAND_A = 0.4,
        HAND_LAG = 0.6,
        HAND_B = 0.3,
        HAND_HOOK = 1.4,
        hands = function(p3, p4, p5, p6) -- hands | line: 16
            -- upvalues: p1 (copy)
            local GraspSwim = p1.GraspSwim
            local v1 = (1 + GraspSwim.HAND_B * p5) * (p6 and GraspSwim.HAND_HOOK or 1)
            local lam = p3.P.lam

            for _, v2 in ipairs(p3.hands) do
                local v5 = v1 * GraspSwim.HAND_A * math.sin(p4 - 6.283185307179586 * v2.x / lam - GraspSwim.HAND_LAG)
                local bone = v2.bone
                local fromAxisAngle = CFrame.fromAxisAngle
                local axis = v2.axis

                if v2.row ~= "U" or not v5 then
                    v5 = -v5
                end

                bone.Transform = fromAxisAngle(axis, v5)
            end
        end,
        register = function(p7) -- register | line: 25
            -- upvalues: p1 (copy)
            local v6 = p1.EelSwim.register(p7)

            if not v6 then
                return nil
            end

            local mesh = v6.mesh
            local CFrame = v6.mesh.CFrame
            local AnatomyInverse = p7:GetAttribute("AnatomyInverse")
            local v7 = p7:GetPivot() * AnatomyInverse:Inverse()
            local v8 = CFrame:VectorToObjectSpace(v7.RightVector)
            local Unit = CFrame:VectorToObjectSpace(v7.UpVector):Cross(v8).Unit
            local t2 = {}

            for _, descendant in ipairs(mesh:GetDescendants()) do
                if descendant:IsA("Bone") and descendant.Name:match("^Hand[UD]%d+$") then
                    local v9 = CFrame:ToObjectSpace(descendant.WorldCFrame)

                    t2[#t2 + 1] = {
                        bone = descendant,
                        row = descendant.Name:sub(5, 5),
                        axis = v9:VectorToObjectSpace(Unit),
                        x = (v6.ext / 2 - v9.Position:Dot(v8)) / v6.ext
                    }
                end
            end

            if #t2 == 0 then
                return nil
            end

            v6.hands = t2

            return v6
        end,
        update = function(p8, p9) -- update | line: 48
            -- upvalues: p1 (copy), fightHooked (copy)
            p1.EelSwim.update(p8, p9)
            p1.GraspSwim.hands(p8, p8.phase, p8.burst, fightHooked(p8.model))
        end
    }
end
