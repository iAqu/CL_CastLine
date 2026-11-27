-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.LeafDrift = {
        ROLL = 0.1,
        ROLL_RATE = 0.9,
        HEAD_DOWN = 0.2,
        PITCH = 0.05,
        PITCH_RATE = 0.6,
        RUST = 0.16,
        RUST_RATE = 2.2,
        DFOLD = 0.9,
        SCHOOL_RUST = 0.08,
        SCHOOL_LAG = 0.45,
        SCULL = 0.3,
        SCULL_RATE = 3.2,
        PFOLD = 0.8,
        SWAY = 0.12,
        VFOLD = 0.8,
        FOLD_EASE = 10,
        register = function(p3) -- register | line: 28
            -- upvalues: p1 (copy)
            local v1 = p1.SharkSwim.register(p3)

            if not v1 then
                return nil
            end

            local CFrame = v1.mesh.CFrame
            local nose = v1.nose
            local Unit = (Vector3.new(0, 1, 0) - nose * nose.Y).Unit
            local Unit2 = nose:Cross(Unit).Unit

            local function part(p4) -- line: 35
                -- upvalues: v1 (copy), CFrame (copy), nose (copy), Unit (copy), Unit2 (copy)
                local v2 = v1.mesh:FindFirstChild(p4, true)

                if not v2 then
                    return nil
                end

                local v3 = CFrame:ToObjectSpace(v2.WorldCFrame)

                return {
                    bone = v2,
                    right = v3:VectorToObjectSpace(Unit2),
                    nose = v3:VectorToObjectSpace(nose),
                    up = v3:VectorToObjectSpace(Unit)
                }
            end

            v1.root = part("Spine_01")
            v1.rootInWave = false

            for _, v4 in ipairs(v1.segs) do
                if v4.bone == v1.root.bone then
                    v1.rootInWave = true
                end
            end

            local t2 = {}
            local t3 = {}

            v1.leaves = {}
            v1.pecs = t2
            v1.lower = t3

            for i = 1, 5 do
                local v5 = part("Leaf_D" .. i)

                if not v5 then
                    return nil
                end

                v5.k = i
                v1.leaves[i] = v5
            end

            for _, v6 in ipairs({
                    { "Pec_L", 1 },
                    { "Pec_R", -1 }
                }) do
                local v7 = part(v6[1])

                if v7 then
                    v7.side = v6[2]
                    v1.pecs[#v1.pecs + 1] = v7
                end
            end

            for _, v8 in ipairs({
                    { "Pelvic_L", 0 },
                    { "Pelvic_R", 2 },
                    { "Anal", 1 }
                }) do
                local v9 = part(v8[1])

                if v9 then
                    v9.off = v8[2]
                    v1.lower[#v1.lower + 1] = v9
                end
            end

            local v10 = math.random() * 6.28

            v1.fold = 0
            v1.fin = v10

            return v1
        end,
        update = function(p5, p6, p7) -- update | line: 70
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local LeafDrift = p1.LeafDrift

            p1.SharkSwim.update(p5, p6, p7)

            local model = p5.model
            local v11 = fightHooked(model)
            local n1 = 0.6

            if v11 then
                n1 = 0
            elseif attr(model, "StrokeAt") then
                n1 = (attr(model, "StrokeRate") or 0) / math.max(attr(model, "StrokeCruise") or 1, 0.001)
            end

            local v15 = math.clamp((n1 - 1.2) / 0.6, 0, 1)

            p5.fold = p5.fold + (v15 - p5.fold) * math.min(1, p6 * LeafDrift.FOLD_EASE)
            p5.fin += p6 * (v11 and 3 or 1)

            local fold2, fin = p5.fold, p5.fin
            local v18 = 1 - fold2
            local School = attr(model, "School")
            local root = p5.root
            local SCHOOL_RUST, SCHOOL_LAG

            if School then
                SCHOOL_RUST = LeafDrift.SCHOOL_RUST or LeafDrift.RUST
                SCHOOL_LAG = LeafDrift.SCHOOL_LAG or 0.9
            else
                local Transform = p5.rootInWave and root.bone.Transform or CFrame.identity

                root.bone.Transform = Transform * CFrame.fromAxisAngle(root.nose, v18 * LeafDrift.ROLL * math.sin(LeafDrift.ROLL_RATE * fin)) * CFrame.fromAxisAngle(root.right, -LeafDrift.HEAD_DOWN * v18 + v18 * LeafDrift.PITCH * math.sin(LeafDrift.PITCH_RATE * fin + 1))
                SCHOOL_RUST = LeafDrift.RUST
                SCHOOL_LAG = 0.9
            end

            for _, v25 in ipairs(p5.leaves) do
                v25.bone.Transform = CFrame.fromAxisAngle(v25.right, LeafDrift.DFOLD * fold2) * CFrame.fromAxisAngle(v25.nose, v18 * SCHOOL_RUST * math.sin(LeafDrift.RUST_RATE * fin - SCHOOL_LAG * v25.k))
            end

            for _, v29 in ipairs(p5.pecs) do
                v29.bone.Transform = CFrame.fromAxisAngle(v29.up, v29.side * (LeafDrift.PFOLD * fold2 + v18 * LeafDrift.SCULL * math.sin(LeafDrift.SCULL_RATE * fin))) * CFrame.fromAxisAngle(v29.nose, v29.side * v18 * 0.4 * LeafDrift.SCULL * math.sin(LeafDrift.SCULL_RATE * fin + 1.2))
            end

            for _, v36 in ipairs(p5.lower) do
                v36.bone.Transform = CFrame.fromAxisAngle(v36.right, -LeafDrift.VFOLD * fold2) * CFrame.fromAxisAngle(v36.nose, v18 * LeafDrift.SWAY * math.sin(1.7 * fin + v36.off))
            end
        end
    }
end
