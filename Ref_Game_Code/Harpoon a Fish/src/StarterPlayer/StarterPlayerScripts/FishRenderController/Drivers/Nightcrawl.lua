-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 18
    local fightHooked, attr = p2.fightHooked, p2.attr

    local function ss(p3) -- line: 21
        local v1 = math.clamp(p3, 0, 1)

        return v1 * v1 * (3 - 2 * v1)
    end

    local function noise1(p4, p5) -- line: 25
        return (math.clamp(math.noise(p4, p5 * 0.731, 0.5) * 2, -1, 1))
    end

    p1.Nightcrawl = {
        P = {
            waveAmp = 0.04,
            waveK = 5.291103416572283,
            waveHz = { 1.2, 4.5 },
            turnBend = 0.5,
            gaitHz = { 1.4, 7.5 },
            swing = 0.55,
            lift = 0.45,
            flex = 0.7,
            creepGait = 0.6,
            snapEvery = { 0.22, 0.85 },
            snapTau = 0.022,
            yaw = 0.55,
            pitch = 0.28,
            roll = 0.6,
            lookGain = 0.8,
            twitchEvery = { 0.15, 0.6 },
            twitchAmp = { 0.25, 0.55 },
            twitchDecay = 5,
            jawRest = 0.08,
            jawCreep = 0.38,
            jawCreepRate = 0.6,
            jawDash = 0.32,
            chatterEvery = { 0.8, 2.6 },
            chatterHz = 15,
            chatterN = { 3, 6 },
            chatterAmp = 0.16,
            tailCurl = 0.16,
            tailQuiver = 0.035,
            tailQuiverHz = 23,
            tailWhip = 0.35,
            shiver = 0.012,
            shiverHz = 11,
            stareYaw = 1,
            starePitch = 0.6,
            stareJitter = 0.15,
            lockYaw = 2.2,
            lockPitch = 1.2,
            lockJitter = 0.06,
            still = 1.5,
            creepMax = 20,
            V_TAU = 0.1,
            roarLook = 1.1,
            roarHold = 2.4,
            roarJaw = 0.55,
            roarShake = 0.14,
            roarHz = 17,
            roarShiver = 5,
            scareLook = 0.55,
            scareHold = 1.8,
            scareJaw = 0.62
        },
        EYES = {
            {
                pos = Vector3.new(0.0214, 0.0598, -0.4607),
                normal = Vector3.new(0.35, 0.27, -0.9),
                w = 0.05,
                h = 0.062
            },
            {
                pos = Vector3.new(-0.1134, 0.0101, -0.4424),
                normal = Vector3.new(-0.76, 0.04, -0.65),
                w = 0.04,
                h = 0.036
            }
        },
        EYE_COLOR = Color3.fromRGB(255, 85, 10),
        EYE_HOT = Color3.fromRGB(255, 150, 40),
        TRIPOD_A = {
            FL = true,
            MR = true,
            RL = true
        },
        LIMBS = { "FL", "FR", "ML", "MR", "RL", "RR" },
        BODY_U = {
            Head = -0.785,
            Neck_2 = -0.52,
            Neck_1 = -0.31,
            Body_1 = -0.09,
            Body_2 = 0.12
        },
        BODY_PARENT = {
            Head = "Neck_2",
            Neck_2 = "Neck_1",
            Neck_1 = "Body_1",
            Body_2 = "Body_1"
        },
        TAIL = { "Tail_1", "Tail_2", "Tail_3", "Tail_4", "Tail_5" },
        TAIL_U = { 0.31, 0.46, 0.58, 0.7, 0.81 },
        register = function(p6) -- register | line: 66
            -- upvalues: p1 (copy), attr (copy)
            local MeshPart = p6:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p6, "AnatomyInverse")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local _CFrame = MeshPart.CFrame
            local v3 = p6:GetPivot() * AnatomyInverse:Inverse()
            local v4 = _CFrame:VectorToObjectSpace(v3.RightVector)
            local v5 = _CFrame:VectorToObjectSpace(v3.UpVector)
            local v6 = v5:Cross(v4)
            local t2 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t2[descendant.Name] = descendant
                end
            end

            if not (t2.Head and t2.Body_1 and t2.Tail_5) then
                return nil
            end

            local t3 = {}

            local function frame(p7) -- line: 81
                -- upvalues: _CFrame (copy), v4 (copy), v5 (copy), v6 (copy), t2 (copy), t3 (copy)
                local v7 = t2[p7]

                if not v7 then
                    return nil
                end

                local v8 = _CFrame:ToObjectSpace(v7.WorldCFrame)

                local function L(p8) -- line: 85
                    -- upvalues: v8 (copy)
                    return v8:VectorToObjectSpace(p8).Unit
                end

                local t4 = {
                    bone = v7,
                    up = v8:VectorToObjectSpace(v5).Unit,
                    nose = v8:VectorToObjectSpace(v4).Unit,
                    left = v8:VectorToObjectSpace(v6).Unit,
                    jaw = v8:VectorToObjectSpace(v6).Unit
                }
                local v9, v10 = p7:match("^Limb_%u(%u)_(%d)$")

                if v9 then
                    local v11 = if v9 == "L" then 1 else -1
                    local Unit, v12

                    if v10 == "1" then
                        Unit = (_CFrame:PointToObjectSpace(t2[p7:sub(1, -2) .. "2"].WorldPosition) - v8.Position).Unit
                        v12 = Unit
                    else
                        local v14 = _CFrame:ToObjectSpace(v7.Parent.WorldCFrame)

                        Unit = (v8.Position - v14.Position).Unit

                        local TipDir = v7:GetAttribute("TipDir")

                        v12 = typeof(TipDir) == "Vector3" and TipDir.Unit or Unit
                    end

                    t4.swing = v8:VectorToObjectSpace(v5 * v11).Unit
                    t4.lift = v8:VectorToObjectSpace((Unit:Cross(v5))).Unit
                    t4.flex = v8:VectorToObjectSpace((v5:Cross(v12))).Unit
                end

                t3[p7] = t4

                return t4
            end

            for v15 in pairs(t2) do
                frame(v15)
            end

            local t5 = {}
            local NcEyes = p6:FindFirstChild("NcEyes")

            if NcEyes then
                NcEyes:Destroy()
            end

            local Folder = Instance.new("Folder")

            Folder.Name = "NcEyes"

            local Size = MeshPart.Size
            local Z = MeshPart.Size.Z
            local v16 = t2.Head and _CFrame:ToObjectSpace(t2.Head.WorldCFrame)

            for v17, v18 in ipairs(p1.Nightcrawl.EYES) do
                local v19 = v18.pos * Size
                local v20 = CFrame.lookAt(v19, v19 + v18.normal.Unit)

                local function blob(p9, p10, p11, p12, p13) -- line: 119
                    -- upvalues: Folder (copy), v20 (copy), v17 (copy), v16 (copy)
                    local Part = Instance.new("Part")

                    Part.Name = p9 .. v17
                    Part.Anchored = true
                    Part.CanCollide = false
                    Part.CanQuery = false
                    Part.CanTouch = false
                    Part.CastShadow = false
                    Part.Massless = true
                    Part.Size = p10
                    Part.Color = p11
                    Part.Material = p12

                    local SpecialMesh = Instance.new("SpecialMesh")

                    SpecialMesh.MeshType = Enum.MeshType.Sphere
                    SpecialMesh.Parent = Part
                    Part.Parent = Folder

                    return {
                        part = Part,
                        off = v16 and v16:Inverse() * v20 * CFrame.new(0, 0, -p13) or v20 * CFrame.new(0, 0, -p13)
                    }
                end

                local v24 = blob("Eye", Vector3.new(v18.w * Z, v18.h * Z, 0.06 * Z * 0.5), p1.Nightcrawl.EYE_COLOR, Enum.Material.Neon, 0.25)
                local v28 = blob("Slit", Vector3.new(v18.w * Z * 0.16, v18.h * Z * 0.85, 0.06 * Z * 0.4), Color3.new(0, 0, 0), Enum.Material.SmoothPlastic, 0.55)
                local PointLight = Instance.new("PointLight")
                local EYE_COLOR = p1.Nightcrawl.EYE_COLOR
                local v29 = Z * 0.22

                PointLight.Color = EYE_COLOR
                PointLight.Range = v29
                PointLight.Brightness = 1.2
                PointLight.Shadows = false
                PointLight.Parent = v24.part
                t5[v17] = {
                    glow = v24,
                    slit = v28,
                    light = PointLight
                }
            end

            Folder.Parent = p6

            local P = p1.Nightcrawl.P
            local t7 = {}

            for _, v30 in ipairs(p1.Nightcrawl.LIMBS) do
                t7[v30] = { 0, 0, 0 }
            end

            return {
                wave = 0,
                gait = 0,
                snapIn = 0.4,
                twitchIn = 0.3,
                chatter = nil,
                chatterIn = 1.2,
                dashT = 0,
                lastMode = "freeze",
                v = 0,
                model = p6,
                mesh = MeshPart,
                ax = t3,
                nose = v4,
                up = v5,
                left = v6,
                eyes = t5,
                rng = Random.new(),
                t = math.random() * 10,
                head = { 0, 0, 0 },
                headWant = { 0, 0, 0 },
                twitch = t7,
                jaw = P.jawRest
            }
        end,
        update = function(p14, p15) -- update | line: 148
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local Nightcrawl = p1.Nightcrawl
            local P = Nightcrawl.P
            local rng = p14.rng
            local _CFrame = p14.mesh.CFrame
            local v31 = _CFrame:VectorToWorldSpace(p14.nose)
            local v32 = _CFrame:VectorToWorldSpace(p14.up)
            local v33 = _CFrame:VectorToWorldSpace(p14.left)
            local CFramePosition = _CFrame.Position
            local v34, v, v35, v36, v37, v38

            if p14.lastPos and p15 > 1E-04 then
                v34 = (CFramePosition - p14.lastPos).Magnitude / p15

                if v34 < 2000 then
                    v = p14.v
                    v37 = v34 - p14.v
                    v36 = p15 / P.V_TAU
                    p14.v = v + v37 * math.min(1, v36)
                end

                v = p14.lastNose - v32 * p14.lastNose:Dot(v32)

                local v39 = v31 - v32 * v31:Dot(v32)

                if v.Magnitude > 0.001 and v39.Magnitude > 0.001 then
                    v37 = v.Unit:Cross(v39.Unit):Dot(v32)
                    v35 = math.clamp(v37, -1, 1)
                    v38 = math.asin(v35) / p15
                else
                    v38 = 0
                end
            else
                v38 = 0
            end

            p14.lastPos = CFramePosition
            p14.lastNose = v31
            CFramePosition = fightHooked(p14.model)
            v34 = attr(p14.model, "NcMode")
            v = p14.v

            local v40, v41

            if CFramePosition then
                v40 = "dash"
                v41 = 100
            else
                v41 = v
                v40 = if v34 ~= nil then v34
                    elseif v < P.still then "freeze"
                    elseif v < P.creepMax then "creep"
                    else "dash"
            end

            v37 = attr(p14.model, "NcWarn")

            local v42, v43

            if v40 == "freeze" and typeof(v37) == "Vector3" and v37.Magnitude > 0.001 then
                v35 = v37 - v32 * v37:Dot(v32)

                if v35.Magnitude > 0.001 then
                    v35 = v35.Unit
                    v42 = v35:Dot(v33)
                    v36 = math.atan2(v42, (v35:Dot(v31)))
                    v43 = math.clamp(v36, -1.2, 1.2)
                end
            end

            p14.t += p15
            v37 = v40 ~= "freeze"
            v35 = math.clamp(v41 / 100, 0, 1)

            if v40 == "dash" and p14.lastMode ~= "dash" then
                p14.dashT = 0
            end

            p14.dashT += p15
            p14.lastMode = v40

            local ax = p14.ax

            local function set(p16, p17) -- line: 192
                -- upvalues: ax (copy)
                local v46 = ax[p16]

                if not v46 then
                    return
                end

                local v47 = CFrame.identity

                for _, v48 in ipairs(p17) do
                    v47 *= CFrame.fromAxisAngle(v46[v48[1]], v48[2])
                end

                v46.bone.Transform = v47
            end

            v36 = P.waveHz[1] + (P.waveHz[2] - P.waveHz[1]) * v35
            p14.wave += p15 * 6.283185307179586 * v36 * (v37 and 1 or 0.15)
            v42 = P.waveAmp

            local v49 = v40 == "dash"
            local v50, v51, v52

            if v49 then
                v51 = v35 * 3
                v52 = math.clamp(v51, 0, 1)
                v50 = v52 * v52 * (3 - 2 * v52)
            end

            if not v49 or not v50 then
                v50 = if v40 == "creep" then 0.35 else 0.05
            end

            local v53 = v42 * v50

            v42 = math.clamp(v38 / 8, -1, 1) * P.turnBend

            local function slope(p18) -- line: 204
                -- upvalues: p14 (copy), P (copy), v53 (copy)
                local v54 = v53 * (math.abs(p18) + 0.5)
                local v55 = if p18 >= 0 then 1 else -1

                return -(v54 * -P.waveK * math.cos(p14.wave - P.waveK * p18) + v53 * v55 * math.sin(p14.wave - P.waveK * p18))
            end

            local t8 = {}
            local v61, v62, v63, v64, v65, v66, v67

            for v68, v69 in pairs(Nightcrawl.BODY_U) do
                v66 = v53 * (math.abs(v69) + 0.5)
                v63 = if v69 >= 0 then 1 else -1
                v67 = v66 * -P.waveK
                v61 = p14.wave - P.waveK * v69
                v62 = v67 * math.cos(v61)
                v64 = v53 * v63
                v65 = p14.wave - P.waveK * v69
                t8[v68] = -(v62 + v64 * math.sin(v65)) + v42 * -v69
            end

            v42 = t8.Body_1

            local v70 = {}
            local v71, v72

            for _, v73 in ipairs({ "Neck_1", "Neck_2", "Head", "Body_2" }) do
                v71 = Nightcrawl.BODY_PARENT[v73]
                v63 = t8[v73]
                v72 = if v71 == "Body_1" and v42 then v42 else t8[v71]
                v66 = v63 - v72
                v63 = P.shiver
                v62 = p14.t * P.shiverHz
                v67 = #v73 * 13 + string.byte(v73, 1)
                v61 = math.noise(v62, v67 * 0.731, 0.5) * 2
                v71 = v63 * math.clamp(v61, -1, 1)
                v70[v73] = {
                    {
                        "up",
                        v66 + v71
                    },
                    {
                        "left",
                        v71 * 0.6
                    }
                }
            end

            local NcRoar = attr(p14.model, "NcRoar")
            local v74 = type(NcRoar) == "number" and workspace:GetServerTimeNow() - NcRoar or nil

            v42 = v74 ~= nil and -P.roarLook <= v74 and v74 < P.roarHold

            local v75 = v42 and v74 >= 0
            local NcScare = attr(p14.model, "NcScare")
            local v76 = type(NcScare) == "number" and workspace:GetServerTimeNow() - NcScare or nil
            local roarJaw = P.roarJaw

            v71 = P.roarHold

            local v77 = v42
            local v78 = v75
            local v79 = v74
            local v80 = v71
            local v81 = roarJaw

            if v76 ~= nil and -P.scareLook <= v76 and v76 < P.scareHold then
                v77 = true
                v79 = v76
                v78 = v76 >= 0
                v81 = P.scareJaw
                v80 = P.scareHold
            end

            p14.snapIn -= p15

            if v77 and not p14.wasLooking then
                p14.snapIn = 0
            end

            p14.wasLooking = v77
            v76 = if attr(p14.model, "NcStare") == true or v77 then not v37 and v43 == nil else v77

            local Unit, v82

            if v77 then
                if p14.snapIn <= 0 then
                    p14.snapIn = P.snapEvery[1] + rng:NextNumber() * (P.snapEvery[2] - P.snapEvery[1])
                    p14.lockJit = {
                        (rng:NextNumber() * 2 - 1) * P.lockJitter,
                        (rng:NextNumber() * 2 - 1) * P.lockJitter,
                        (rng:NextNumber() * 2 - 1) * P.roll * 0.6
                    }
                end

                NcScare = workspace.CurrentCamera
                v66 = ax.Head and ax.Head.bone
                v63 = NcScare and v66 and NcScare.CFrame.Position - v66.TransformedWorldCFrame.Position

                if v63 and v63.Magnitude > 1 then
                    Unit = v63.Unit
                    v82 = p14.lockJit or { 0, 0, 0 }
                    v67 = Unit:Dot(v33)
                    v64 = Unit:Dot(v31)
                    v62 = math.atan2(v67, v64)
                    v67 = -P.lockYaw
                    v64 = P.lockYaw
                    v72 = math.clamp(v62, v67, v64)
                    v67 = Unit:Dot(v32)
                    v61 = Unit:Dot(v33) ^ 2 + Unit:Dot(v31) ^ 2
                    v64 = math.sqrt(v61)
                    v62 = math.atan2(v67, v64)
                    v67 = -P.lockPitch
                    v64 = P.lockPitch

                    local v83 = math.clamp(v62, v67, v64)

                    p14.headWant = {
                        v72 + v82[1],
                        v83 + v82[2],
                        v82[3]
                    }
                end
            elseif v43 ~= nil then
                p14.headWant = {
                    v43 * P.lookGain,
                    0.05,
                    -v43 * 0.35
                }
            elseif v37 then
                v72 = v38 * 0.06
                p14.headWant = {
                    math.clamp(v72, -0.4, 0.4),
                    v35 * -0.1,
                    0
                }
            elseif p14.snapIn <= 0 then
                p14.snapIn = P.snapEvery[1] + rng:NextNumber() * (P.snapEvery[2] - P.snapEvery[1])

                if v76 then
                    v82 = workspace.CurrentCamera
                    Unit = ax.Head and ax.Head.bone
                    v72 = v82 and Unit and v82.CFrame.Position - Unit.WorldPosition

                    if v72 and v72.Magnitude > 1 then
                        v72 = v72.Unit
                        v64 = v72:Dot(v33)
                        v61 = v72:Dot(v31)
                        v67 = math.atan2(v64, v61)
                        v64 = -P.stareYaw
                        v61 = P.stareYaw
                        v62 = math.clamp(v67, v64, v61)
                        v61 = v72:Dot(v32)
                        v64 = math.clamp(v61, -1, 1)
                        v67 = math.asin(v64)
                        v64 = -P.starePitch
                        v61 = P.starePitch

                        local v84 = math.clamp(v67, v64, v61)
                        local stareJitter = P.stareJitter

                        p14.headWant = {
                            v62 + (rng:NextNumber() * 2 - 1) * stareJitter,
                            v84 + (rng:NextNumber() * 2 - 1) * stareJitter * 0.5,
                            (rng:NextNumber() * 2 - 1) * P.roll
                        }
                    end
                else
                    p14.headWant = {
                        (rng:NextNumber() * 2 - 1) * P.yaw,
                        (rng:NextNumber() * 1.6 - 0.6) * P.pitch,
                        (rng:NextNumber() * 2 - 1) * P.roll
                    }
                end
            end

            local v85, v86

            if v37 and v43 == nil then
                v86 = false
            else
                Unit = -p15 / P.snapTau
                v76 = 1 - math.exp(Unit)

                if v76 then
                    v85 = v76
                    v86 = true
                else
                    v86 = false
                end
            end

            if not v86 then
                Unit = -p15 * 12
                v85 = 1 - math.exp(Unit)
            end

            for i = 1, 3 do
                v62 = p14.head
                v62[i] += (p14.headWant[i] - p14.head[i]) * v85
            end

            v85 = v70.Head
            v85[#v85 + 1] = {
                "up",
                p14.head[1]
            }
            v85[#v85 + 1] = {
                "left",
                -p14.head[2]
            }
            v85[#v85 + 1] = {
                "nose",
                p14.head[3]
            }

            local v87, v88, v89, v90

            if v78 then
                Unit = (v79 - (v80 - 0.4)) / 0.4
                v77 = 1 - math.clamp(Unit, 0, 1)
                v43 = p14.t * P.roarHz
                v82 = #v85 + 1
                v67 = P.roarShake * v77
                v61 = math.noise(v43, 59.211, 0.5) * 2
                v85[v82] = {
                    "up",
                    v67 * math.clamp(v61, -1, 1)
                }
                v82 = #v85 + 1
                v67 = P.roarShake * 1.3 * v77
                v61 = math.noise(v43, 60.673, 0.5) * 2
                v85[v82] = {
                    "nose",
                    v67 * math.clamp(v61, -1, 1)
                }

                for _, v91 in ipairs({ "Neck_1", "Neck_2", "Body_2" }) do
                    v33 = v70[v91]
                    v64 = #v33 + 1
                    v87 = P.shiver * P.roarShiver * v77
                    v88 = v43 * 0.7
                    v89 = #v91 + 90
                    v90 = math.noise(v88, v89 * 0.731, 0.5) * 2
                    v33[v64] = {
                        "left",
                        v87 * math.clamp(v90, -1, 1)
                    }
                end
            end

            for v92, v93 in pairs(v70) do
                set(v92, v93)
            end

            p14.chatterIn -= p15

            local jawDash, v94

            if v40 == "dash" then
                jawDash = P.jawDash
                v94 = if p14.dashT < 0.12 then 1.25 else 1
                v85 = jawDash * v94
                jawDash = p14.jaw
                v72 = v85 - p14.jaw
                v64 = p15 * 25
            else
                jawDash = P.jawRest
                v72 = P.jawCreep - P.jawRest
                v62 = if v40 == "creep" then 0 else 1
                v70 = jawDash + v72 * v62
                jawDash = p14.jaw
                v72 = v70 - p14.jaw
                v64 = p15 * P.jawCreepRate
            end

            p14.jaw = jawDash + v72 * math.min(1, v64)

            if p14.chatter == nil and p14.chatterIn <= 0 and not v37 then
                p14.chatter = {
                    p14.t,
                    rng:NextInteger(P.chatterN[1], P.chatterN[2])
                }
                p14.chatterIn = P.chatterEvery[1] + rng:NextNumber() * (P.chatterEvery[2] - P.chatterEvery[1])
            end

            local jaw = p14.jaw

            if p14.chatter then
                local v95 = (p14.t - p14.chatter[1]) * P.chatterHz

                if p14.chatter[2] <= v95 then
                    p14.chatter = nil
                else
                    v94 = P.chatterAmp
                    v64 = 6.283185307179586 * v95
                    jaw -= v94 * (0.5 - math.cos(v64) * 0.5)
                end
            end

            if CFramePosition then
                jawDash = P.jawDash
                v72 = P.chatterAmp
                v61 = 6.283185307179586 * p14.t * P.chatterHz
                jaw = jawDash + v72 * (0.5 - math.cos(v61) * 0.5)
            end

            if v78 then
                v94 = v79 / 0.12
                jawDash = math.clamp(v94, 0, 1)
                v62 = (v79 - (v80 - 0.4)) / 0.4
                v62 = v81 * (jawDash * (1 - math.clamp(v62, 0, 1)))
                v65 = p14.t * 9
                v87 = math.noise(v65, 62.135, 0.5) * 2
                v72 = v62 + 0.04 * math.clamp(v87, -1, 1)
                jaw = math.max(jaw, v72)
            end

            set("JawA_1", {
                {
                    "jaw",
                    (math.max(0, jaw))
                }
            })
            v80 = P.gaitHz[1] + (P.gaitHz[2] - P.gaitHz[1]) * v35
            p14.gait += p15 * 6.283185307179586 * v80 * (v37 and 1 or 0)

            local creepGait = if v40 == "dash" then 1 else v40 == "creep" and P.creepGait or 0

            p14.twitchIn -= p15

            if not v37 and p14.twitchIn <= 0 then
                p14.twitchIn = P.twitchEvery[1] + rng:NextNumber() * (P.twitchEvery[2] - P.twitchEvery[1])
                v81 = Nightcrawl.LIMBS[rng:NextInteger(1, #Nightcrawl.LIMBS)]

                local v97 = rng:NextInteger(1, 3)

                p14.twitch[v81][v97] += (P.twitchAmp[1] + rng:NextNumber() * (P.twitchAmp[2] - P.twitchAmp[1])) * (rng:NextNumber() < 0.5 and 1 or -1) * (v97 == 2 and 0.6 or 1)
            end

            local v98, v99, v100

            for v101, v102 in ipairs(Nightcrawl.LIMBS) do
                v98 = p14.gait
                v61 = if Nightcrawl.TRIPOD_A[v102] then 0 else 3.141592653589793
                v37 = v98 + v61
                v40 = -P.swing * math.cos(v37) * creepGait
                v65 = -math.sin(v37)
                jaw = math.max(0, v65) * creepGait
                v37 = p14.twitch[v102]
                v98 = v37[1]
                v65 = -p15 * P.twitchDecay
                v37[1] = v98 * math.exp(v65)
                v98 = v37[2]
                v65 = -p15 * P.twitchDecay
                v37[2] = v98 * math.exp(v65)
                v98 = v37[3]
                v65 = -p15 * P.twitchDecay
                v37[3] = v98 * math.exp(v65)
                v65 = p14.t * 0.8
                v99 = v101 + 3
                v100 = math.noise(v65, v99 * 0.731, 0.5) * 2
                v38 = 0.06 * math.clamp(v100, -1, 1)
                set("Limb_" .. v102 .. "_1", {
                    {
                        "swing",
                        v40 + v37[1] + v38
                    },
                    {
                        "lift",
                        P.lift * jaw + v37[2]
                    }
                })
                set("Limb_" .. v102 .. "_2", {
                    {
                        "flex",
                        P.flex * jaw + v37[3] + 0.5 * v38
                    }
                })
            end

            creepGait = ax.Head and ax.Head.bone

            local v103, v104

            if creepGait and p14.eyes then
                local TransformedWorldCFrame = creepGait.TransformedWorldCFrame
                local Transparency, LocalTransparencyModifier = p14.mesh.Transparency, p14.mesh.LocalTransparencyModifier
                local v105 = if v78 then 1 else 0

                for _, v106 in ipairs(p14.eyes) do
                    for _, v107 in ipairs({
                            v106.glow,
                            v106.slit
                        }) do
                        v107.part.CFrame = TransformedWorldCFrame * v107.off
                        v107.part.Transparency = Transparency
                        v107.part.LocalTransparencyModifier = LocalTransparencyModifier
                    end

                    v106.glow.part.Color = Nightcrawl.EYE_COLOR:Lerp(Nightcrawl.EYE_HOT, v105)
                    v99 = v106.light
                    v88 = 1.2 + 3 * v105
                    v103 = p14.t * 3
                    v104 = math.noise(v103, 63.597, 0.5) * 2
                    v99.Brightness = (v88 + 0.25 * math.clamp(v104, -1, 1)) * (1 - math.max(Transparency, LocalTransparencyModifier))
                end
            end

            creepGait = (1 - v35) * P.tailCurl

            for v108, v109 in ipairs(Nightcrawl.TAIL) do
                v78 = Nightcrawl.TAIL_U[v108]
                v61 = P.tailQuiver * (1 - v35)
                v99 = p14.t * P.tailQuiverHz
                v87 = 40 + v108
                v88 = math.noise(v99, v87 * 0.731, 0.5) * 2
                v98 = v61 * math.clamp(v88, -1, 1)

                local v110

                if v108 > 1 then
                    v65 = Nightcrawl.TAIL_U[v108 - 1]
                    v99 = v53 * (math.abs(v65) + 0.5)
                    v87 = if v65 >= 0 then 1 else -1
                    v89 = v99 * -P.waveK
                    v90 = p14.wave - P.waveK * v65
                    v88 = v89 * math.cos(v90)
                    v110 = v53 * v87
                    v103 = p14.wave - P.waveK * v65
                    v61 = -(v88 + v110 * math.sin(v103)) or t8.Body_2
                else
                    v61 = t8.Body_2
                end

                v100 = v53 * (math.abs(v78) + 0.5)
                v88 = if v78 >= 0 then 1 else -1
                v90 = v100 * -P.waveK
                v110 = v90 * math.cos(p14.wave - P.waveK * v78)
                v103 = v53 * v88
                v104 = p14.wave - P.waveK * v78
                v99 = -(v110 + v103 * math.sin(v104)) - v61
                v89 = P.tailWhip * v35
                v90 = p14.wave * 1.3 - 1.1 * (v108 - 1)
                v65 = v99 + v89 * math.sin(v90) * v108 / 5
                set(v109, {
                    {
                        "left",
                        creepGait * (0.4 + 0.3 * (v108 - 1)) + v98
                    },
                    {
                        "up",
                        v65 + v98 * 0.5
                    }
                })
            end
        end
    }
end
