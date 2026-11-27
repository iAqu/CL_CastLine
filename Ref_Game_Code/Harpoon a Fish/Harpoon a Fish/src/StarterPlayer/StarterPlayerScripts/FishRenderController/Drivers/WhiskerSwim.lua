-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, _) -- line: 5
    p1.WhiskerSwim = {
        register = function(p3) -- register | line: 16
            -- upvalues: p1 (copy)
            local v1 = p1.AnglerSwim.register(p3)

            if not v1 then
                return nil
            end

            local CFrame = v1.mesh.CFrame

            for _, v2 in ipairs(v1.lure) do
                v2.nose = CFrame:ToObjectSpace(v2.bone.WorldCFrame):VectorToObjectSpace(v1.nose)
            end

            return v1
        end,
        update = function(p4, p5, p6) -- update | line: 25
            -- upvalues: p1 (copy)
            local AnglerSwim = p1.AnglerSwim

            AnglerSwim.update(p4, p5, p6)

            for v3, v4 in ipairs(p4.lure) do
                local v5 = AnglerSwim.LURE_FRAC[v3]

                v4.bone.Transform = CFrame.fromAxisAngle(v4.lat, -p4.lp * v5) * CFrame.fromAxisAngle(v4.nose, p4.ly * v5)
            end
        end
    }
end
