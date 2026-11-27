-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.WalrusSwim = {
        LOCK = 10,
        W_TAU = 0.25,
        TURN_REF = 0.6,
        HOOK_RATE = 9,
        HOOK_EFFORT = 1.5,
        PEN_RATE = 4,
        NECK_DOWN = -0.22,
        HEAD_UP = 0.1,
        FORE_OPEN = 0.45,
        FORE_PADDLE = 0.12,
        HIND_ROLL = 0.35,
        A_LUMBAR = 0.12,
        A_PELVIS = 0.3,
        A_HIND = 0.45,
        LAG_LUMBAR = 0.8,
        LAG_PELVIS = 1.6,
        LAG_HIND = 2.4,
        FEATHER = 0.25,
        BEND = 0.15,
        LOOK = 0.2,
        CHEST_YAW = 0.04,
        KICK = 0.25,
        FORE_SWIM = { 0.57, 0.53, 0.48 },
        pose = function(p3, p4, p5) -- pose | line: 28
            -- upvalues: p1 (copy)
            local WalrusSwim = p1.WalrusSwim
            local v3 = math.clamp(p4, 0, 1) * (1 + WalrusSwim.KICK * math.clamp(p4 - 1, 0, 1))
            local t2 = {
                Neck = {
                    {
                        "lat",
                        WalrusSwim.NECK_DOWN
                    },
                    {
                        "up",
                        0.4 * WalrusSwim.LOOK * p5
                    }
                },
                Head = {
                    {
                        "lat",
                        WalrusSwim.HEAD_UP
                    },
                    {
                        "up",
                        0.6 * WalrusSwim.LOOK * p5
                    }
                },
                Chest = {
                    {
                        "up",
                        -WalrusSwim.CHEST_YAW * v3 * math.sin(p3)
                    }
                },
                Lumbar = {
                    {
                        "up",
                        WalrusSwim.A_LUMBAR * v3 * math.sin(p3 - WalrusSwim.LAG_LUMBAR) - WalrusSwim.BEND * p5
                    }
                },
                Pelvis = {
                    {
                        "up",
                        WalrusSwim.A_PELVIS * v3 * math.sin(p3 - WalrusSwim.LAG_PELVIS) - WalrusSwim.BEND * p5
                    }
                }
            }

            for _, v8 in ipairs({
                    { "L", 1 },
                    { "R", -1 }
                }) do
                local v9 = v8[1]
                local v10 = v8[2]
                local v13 = WalrusSwim.A_HIND * v3 * math.sin(p3 - WalrusSwim.LAG_HIND) - WalrusSwim.BEND * p5
                local v16 = WalrusSwim.FEATHER * v3 * math.sin(p3 - WalrusSwim.LAG_HIND) * v10

                t2["Hind_" .. v9] = {
                    { "up", v13 },
                    {
                        "span",
                        v10 * (WalrusSwim.HIND_ROLL + v16)
                    }
                }

                local v18 = math.max(0, v10 * p5)

                t2["Fore_" .. v9] = {
                    {
                        "tuck",
                        1 - WalrusSwim.FORE_OPEN * v18
                    },
                    {
                        "lat",
                        WalrusSwim.FORE_PADDLE * (1 - math.min(v3, 1) * 0.5) * math.sin(p3)
                    }
                }
            end

            return t2
        end,
        register = function(p6) -- register | line: 47
            -- upvalues: p1 (copy), attr (copy)
            local WalrusSwim = p1.WalrusSwim
            local MeshPart = p6:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p6, "AnatomyInverse")
            local ForeDir = attr(p6, "ForeDir")
            local HindSpan = attr(p6, "HindSpan")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" or typeof(ForeDir) ~= "Vector3" or typeof(HindSpan) ~= "Vector3" then
                return nil
            end

            local t3 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t3[descendant.Name] = descendant
                end
            end

            for _, v19 in ipairs({
                    "Chest",
                    "Lumbar",
                    "Pelvis",
                    "Neck",
                    "Head",
                    "Fore_L",
                    "Fore_R",
                    "Hind_L",
                    "Hind_R"
                }) do
                if not t3[v19] then
                    return nil
                end
            end

            local CFrame = MeshPart.CFrame
            local v20 = p6:GetPivot() * AnatomyInverse:Inverse()
            local v21 = CFrame:VectorToObjectSpace(v20.RightVector)
            local v22 = CFrame:VectorToObjectSpace(v20.UpVector)
            local Unit = v21:Cross(v22).Unit

            local function fishvec(p7, p8, p9, p10) -- line: 65
                -- upvalues: v21 (copy), v22 (copy), Unit (copy)
                return -Unit * p10 * p7 + -v21 * p8 + -v22 * p9
            end

            local t4 = {}

            for v23, v24 in pairs(t3) do
                local v25 = CFrame:ToObjectSpace(v24.WorldCFrame)
                local t5 = {
                    bone = v24,
                    nose = v25:VectorToObjectSpace(v21),
                    up = v25:VectorToObjectSpace(v22),
                    lat = v25:VectorToObjectSpace(Unit),
                    scale = {}
                }
                local v26 = if v23:sub(-2) == "_L" then 1 else -1

                if v23:find("^Hind_") then
                    local X, Y, Z = HindSpan.X, HindSpan.Y, HindSpan.Z

                    t5.span = v25:VectorToObjectSpace((-Unit * v26 * X + -v21 * Y + -v22 * Z).Unit)
                elseif v23:find("^Fore_") then
                    local X, Y, Z = ForeDir.X, ForeDir.Y, ForeDir.Z
                    local Unit2 = (-Unit * v26 * X + -v21 * Y + -v22 * Z).Unit
                    local v27 = WalrusSwim.FORE_SWIM[1]
                    local v28 = WalrusSwim.FORE_SWIM[2]
                    local v29 = WalrusSwim.FORE_SWIM[3]
                    local Unit3 = (-Unit * v26 * v27 + -v21 * v28 + -v22 * v29).Unit

                    t5.tuck = v25:VectorToObjectSpace(Unit2:Cross(Unit3).Unit)
                    t5.scale.tuck = math.acos((math.clamp(Unit2:Dot(Unit3), -1, 1)))
                end

                t4[v23] = t5
            end

            return {
                w = 0,
                model = p6,
                mesh = MeshPart,
                A = t4,
                nose = v21,
                phase = math.random() * 3.141592653589793 * 2
            }
        end,
        update = function(p11, p12, _) -- update | line: 85
            -- upvalues: p1 (copy), p2 (copy), fightHooked (copy), attr (copy)
            local WalrusSwim = p1.WalrusSwim
            local model = p11.model
            local StrokeAt = attr(model, "StrokeAt")
            local HOOK_EFFORT = 1

            if fightHooked(model) then
                p11.phase += p12 * WalrusSwim.HOOK_RATE
                HOOK_EFFORT = WalrusSwim.HOOK_EFFORT
                p11.locked = nil
            elseif StrokeAt then
                local v32 = attr(model, "StrokeRate") or 0

                HOOK_EFFORT = v32 / math.max(attr(model, "StrokeCruise") or v32, 0.001)

                local v34 = (attr(model, "StrokePhase") or 0) + v32 * (workspace:GetServerTimeNow() - p2.renderLag() - StrokeAt)

                if p11.locked then
                    p11.phase += p12 * v32
                    p11.phase = p11.phase + ((v34 - p11.phase + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * math.min(1, p12 * WalrusSwim.LOCK)
                else
                    p11.phase = v34
                    p11.locked = true
                end
            else
                p11.phase += p12 * (attr(model, "StrokeHz") or WalrusSwim.PEN_RATE)
                p11.locked = nil
            end

            local v37 = p11.mesh.CFrame:VectorToWorldSpace(p11.nose)
            local v38 = Vector3.new(v37.X, 0, v37.Z)

            if p11.lastNose and p12 > 1E-04 and v38.Magnitude > 0.001 then
                local lastNose = p11.lastNose
                local Unit = v38.Unit

                p11.w = p11.w + (math.atan2(lastNose:Cross(Unit).Y, (lastNose:Dot(Unit))) / p12 - p11.w) * math.min(1, p12 / WalrusSwim.W_TAU)
            end

            if v38.Magnitude > 0.001 then
                p11.lastNose = v38.Unit
            end

            local v43 = WalrusSwim.pose(p11.phase, HOOK_EFFORT, (math.clamp(p11.w / WalrusSwim.TURN_REF, -1, 1)))

            for v44, v45 in pairs(v43) do
                local v46 = p11.A[v44]

                if v46 then
                    local v47 = CFrame.identity

                    for _, v48 in ipairs(v45) do
                        v47 *= CFrame.fromAxisAngle(v46[v48[1]], v48[2] * (v46.scale[v48[1]] or 1))
                    end

                    v46.bone.Transform = v47
                end
            end
        end
    }
end
