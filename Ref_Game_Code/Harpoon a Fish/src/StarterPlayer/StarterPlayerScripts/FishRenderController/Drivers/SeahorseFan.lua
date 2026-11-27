-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.SeahorseFan = {
        FLUTTER_HZ = 10,
        FIN_LAG = 1,
        FIN_AMP = 0.18,
        FIN_AMP_E = 0.22,
        LEAN = 0.12,
        NOD = 0.05,
        NOD_RATE = 0.8,
        LOOK = 0.15,
        LOOK_MAX = 0.15,
        COIL = 0.06,
        COIL_RATE = 0.9,
        COIL_LAG = 0.4,
        TRAIL = 0.15,
        HOOK_FIN = 0.45,
        HOOK_THRASH = 0.18,
        HOOK_RATE = 6,
        BEAT_MIN = 0.6,
        BEAT_MAX = 0.9,
        NECK_STAB = 0.85,
        NECK_LAG = 0.3,
        HEAD_FOLLOW = 0.03,
        HEAD_LAG = 1.2,
        TAIL_FOLLOW = 0.7,
        TAIL_CURL = 0.25,
        TAIL_LAG = 0.5,
        FIN_PUSH = 0.2,
        register = function(p3) -- register | line: 37
            -- upvalues: attr (copy)
            local MeshPart = p3:FindFirstChildWhichIsA("MeshPart")

            if not MeshPart then
                return nil
            end

            local AnatomyInverse = attr(p3, "AnatomyInverse")

            if typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local CFrame = MeshPart.CFrame
            local v1 = p3:GetPivot() * AnatomyInverse:Inverse()
            local v2 = CFrame:VectorToObjectSpace(v1.RightVector)
            local v3 = CFrame:VectorToObjectSpace(v1.UpVector)
            local Unit = v2:Cross(v3).Unit

            local function part(p4) -- line: 49
                -- upvalues: MeshPart (copy), CFrame (copy), v3 (copy), Unit (copy)
                local v4 = MeshPart:FindFirstChild(p4, true)

                if not v4 then
                    return nil
                end

                local v5 = CFrame:ToObjectSpace(v4.WorldCFrame)

                return {
                    bone = v4,
                    up = v5:VectorToObjectSpace(v3),
                    right = v5:VectorToObjectSpace(Unit),
                    pivot = v5:PointToObjectSpace((Vector3.new(0, 0, 0)))
                }
            end

            local Size = MeshPart.Size
            local t2 = {
                w = 0,
                v = 0,
                model = p3,
                mesh = MeshPart,
                nose = v2,
                t = math.random() * 10,
                length = math.abs(v2.X) * Size.X + math.abs(v2.Y) * Size.Y + math.abs(v2.Z) * Size.Z,
                body = part("Body"),
                head = part("Head"),
                fins = {},
                tail = {}
            }

            if not (t2.body and t2.head) then
                return nil
            end

            t2.fins[1] = part("Dorsal_" .. 1)

            if not t2.fins[1] then
                return nil
            end

            t2.fins[2] = part("Dorsal_" .. 2)

            if not t2.fins[2] then
                return nil
            end

            t2.fins[3] = part("Dorsal_" .. 3)

            if not t2.fins[3] then
                return nil
            end

            for i = 1, 5 do
                t2.tail[i] = part("Tail_" .. i)

                if not t2.tail[i] then
                    return nil
                end
            end

            local SeaBeat = attr(p3, "SeaBeat")

            if type(SeaBeat) == "number" then
                local v8 = math.random() * 2 * 3.141592653589793
                local t3 = {}

                t2.seaBeat = SeaBeat
                t2.beat = v8
                t2.neck = t3

                while true do
                    local v9 = part("Neck_" .. #t2.neck + 1)

                    if v9 then
                        t2.neck[#t2.neck + 1] = v9
                        continue
                    end

                    break
                end
            end

            return t2
        end,
        update = function(p5, p6, _) -- update | line: 83
            -- upvalues: p1 (copy), fightHooked (copy)
            local SeahorseFan = p1.SeahorseFan

            p1.SharkSwim.readTurn(p5, p6)
            p5.t += p6

            local t = p5.t
            local v10 = fightHooked(p5.model)
            local v12 = math.clamp(p5.v / math.max(p5.length, 0.001), 0, 1)

            if not p5.seaBeat or v10 then
                if p5.neck then
                    for _, v13 in ipairs(p5.neck) do
                        v13.bone.Transform = CFrame.identity
                    end
                end

                local HOOK_FIN = if v10 then SeahorseFan.HOOK_FIN else nil

                if not v10 or not HOOK_FIN then
                    HOOK_FIN = SeahorseFan.FIN_AMP + SeahorseFan.FIN_AMP_E * v12
                end

                for v14, v15 in ipairs(p5.fins) do
                    v15.bone.Transform = CFrame.fromAxisAngle(v15.up, HOOK_FIN * math.sin(6.283185307179586 * SeahorseFan.FLUTTER_HZ * t - SeahorseFan.FIN_LAG * (v14 - 1)))
                end

                local body = p5.body

                body.bone.Transform = CFrame.fromAxisAngle(body.right, -SeahorseFan.LEAN * v12)

                local head = p5.head
                local v19 = math.clamp(SeahorseFan.LOOK * p5.w, -SeahorseFan.LOOK_MAX, SeahorseFan.LOOK_MAX)

                head.bone.Transform = CFrame.fromAxisAngle(head.up, v19) * CFrame.fromAxisAngle(head.right, SeahorseFan.NOD * math.sin(SeahorseFan.NOD_RATE * t))

                local v22 = math.clamp(p5.w, -1, 1)

                for v23, v24 in ipairs(p5.tail) do
                    local v25 = if v10 then SeahorseFan.HOOK_THRASH * math.sin(SeahorseFan.HOOK_RATE * t - 0.6 * (v23 - 1)) or -SeahorseFan.TRAIL * v22 * v23 / 5 else -SeahorseFan.TRAIL * v22 * v23 / 5

                    v24.bone.Transform = CFrame.fromAxisAngle(v24.right, SeahorseFan.COIL * math.sin(SeahorseFan.COIL_RATE * t + SeahorseFan.COIL_LAG * (v23 - 1))) * CFrame.fromAxisAngle(v24.up, v25)
                end
            else
                p5.beat += p6 * 2 * 3.141592653589793 * (SeahorseFan.BEAT_MIN + (SeahorseFan.BEAT_MAX - SeahorseFan.BEAT_MIN) * v12)

                local beat, seaBeat = p5.beat, p5.seaBeat
                local v28 = (SeahorseFan.FIN_AMP + SeahorseFan.FIN_AMP_E * v12) * (1 + SeahorseFan.FIN_PUSH * math.sin(beat))

                for v29, v30 in ipairs(p5.fins) do
                    v30.bone.Transform = CFrame.fromAxisAngle(v30.up, v28 * math.sin(6.283185307179586 * SeahorseFan.FLUTTER_HZ * t - SeahorseFan.FIN_LAG * (v29 - 1)))
                end

                local body = p5.body

                body.bone.Transform = CFrame.new(body.pivot) * CFrame.fromAxisAngle(body.right, -SeahorseFan.LEAN * v12 + seaBeat * math.sin(beat)) * CFrame.new(-body.pivot)

                for v32, v33 in ipairs(p5.neck) do
                    v33.bone.Transform = CFrame.fromAxisAngle(v33.right, -SeahorseFan.NECK_STAB * seaBeat * math.sin(beat - SeahorseFan.NECK_LAG * v32) / #p5.neck)
                end

                local head = p5.head
                local v38 = math.clamp(SeahorseFan.LOOK * p5.w, -SeahorseFan.LOOK_MAX, SeahorseFan.LOOK_MAX)

                head.bone.Transform = CFrame.fromAxisAngle(head.up, v38) * CFrame.fromAxisAngle(head.right, SeahorseFan.HEAD_FOLLOW * seaBeat * math.sin(beat - SeahorseFan.HEAD_LAG))

                local v42 = math.clamp(p5.w, -1, 1)

                for v43, v44 in ipairs(p5.tail) do
                    local v45 = v43 == 1 and -SeahorseFan.TAIL_FOLLOW or SeahorseFan.TAIL_CURL

                    v44.bone.Transform = CFrame.fromAxisAngle(v44.right, v45 * seaBeat * math.sin(beat - SeahorseFan.TAIL_LAG * v43)) * CFrame.fromAxisAngle(v44.up, -SeahorseFan.TRAIL * v42 * v43 / 5)
                end
            end
        end
    }
end
