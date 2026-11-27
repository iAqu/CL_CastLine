-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.EelSwim = {
        MAX_HZ = 5,
        MIN_HZ = 0.8,
        HOOK_TAIL = 0.14,
        HOOK_ALPHA = 2.2,
        HOOK_HZ = 6,
        TIP = 0.985,
        FIN_AMP = 0.12,
        FIN_RATE = 0.5,
        V_TAU = 0.1,
        BURST_TAU = 0.3,
        KINDS = {
            Eel = {
                lam = 0.6,
                alpha = 2.76,
                tail = 0.069,
                alphaB = 3.6,
                tailB = 0.09,
                stride = 0.43
            },
            Mosasaur = {
                lam = 1,
                alpha = 5.5,
                tail = 0.08,
                alphaB = 6,
                tailB = 0.1,
                stride = 0.7
            },
            Dragon = {
                lam = 0.8,
                alpha = 3.4,
                tail = 0.075,
                alphaB = 4.2,
                tailB = 0.095,
                stride = 0.55,
                finAmp = 0.3,
                finRate = 1
            },
            Drake = {
                lam = 1,
                alpha = 5.5,
                tail = 0.08,
                alphaB = 6,
                tailB = 0.1,
                stride = 0.7,
                finAmp = 0.25,
                finRate = 0.5
            },
            Serpent = {
                lam = 0.7,
                alpha = 1.2,
                tail = 0.07,
                alphaB = 1.6,
                tailB = 0.09,
                stride = 0.5
            },
            Lamprey = {
                lam = 0.72,
                alpha = 2.2,
                tail = 0.08,
                alphaB = 2.6,
                tailB = 0.095,
                stride = 0.59,
                maxHz = 8.5
            },
            Newt = {
                lam = 1,
                alpha = 2.1,
                tail = 0.1,
                alphaB = 2.5,
                tailB = 0.12,
                stride = 0.65,
                finAmp = 0.1,
                finRate = 1,
                finFold = 0.9,
                foldV = 1
            },
            SeaSnake = {
                lam = 0.7,
                alpha = 0.85,
                tail = 0.098,
                alphaB = 1,
                tailB = 0.1,
                stride = 0.56,
                maxHz = 8.5,
                track = true
            },
            Xenacanth = {
                lam = 0.6,
                alpha = 2.76,
                tail = 0.069,
                alphaB = 3.6,
                tailB = 0.09,
                stride = 0.43,
                maxHz = 9.5
            },
            Iguana = {
                lam = 1.1,
                alpha = 3,
                tail = 0.11,
                alphaB = 3.3,
                tailB = 0.13,
                stride = 0.9,
                finAmp = 0.06,
                finRate = 1,
                finFold = 0.45,
                foldV = 0.6,
                finAdduct = 0.25,
                finTurn = 0.6,
                turnBend = 0.15,
                turnFull = 0.6,
                turnTau = 0.3
            },
            Pliosaur = {
                lam = 1.1,
                alpha = 1.8,
                tail = 0.05,
                alphaB = 2.2,
                tailB = 0.06,
                stride = 1.6,
                stroke = {
                    rate = 1.5,
                    maxHz = 3,
                    amp = 0.62,
                    bias = 0.12,
                    sweep = 0.22,
                    sweepLag = 0.5,
                    feather = 0.3,
                    lagR = 1.5707963267948966,
                    ampR = 0.85
                }
            },
            Crocodon = {
                lam = 1,
                alpha = 1.6,
                tail = 0.09,
                alphaB = 2,
                tailB = 0.11,
                stride = 0.6,
                jawGape = 0.25,
                row = {
                    rate = 1,
                    maxHz = 3,
                    sweep = 0.55,
                    feather = 0.8,
                    lift = 0.25,
                    bias = -0.05,
                    skew = 0.35,
                    lag = {
                        R = 0,
                        M = 0.25,
                        F = 0.5
                    }
                },
                jawEvery = { 0.8, 1.6 }
            },
            PoisonedHexjaw = {
                lam = 0.8,
                alpha = 3,
                tail = 0.17,
                alphaB = 3.2,
                tailB = 0.18,
                stride = 0.42,
                jawGape = 0.3,
                jawSync = true,
                jawEvery = { 0.7, 1.3 }
            },
            Megalodon = {
                lam = 1.1,
                alpha = 3.2,
                tail = 0.12,
                alphaB = 3.6,
                tailB = 0.13,
                stride = 1.15,
                finAmp = 0.05,
                finRate = 0.5,
                bite = {
                    gape = 0.16,
                    lift = 0.07,
                    shut = 0.3,
                    snap = 0.11,
                    hold = 0.14,
                    reopen = 0.55,
                    every = { 2.4, 4.2 }
                }
            },
            Fossilshark = {
                lam = 1.1,
                alpha = 3.2,
                tail = 0.12,
                alphaB = 3.6,
                tailB = 0.13,
                stride = 0.5,
                finAmp = 0.05,
                finRate = 0.5,
                bite = {
                    gape = 0.16,
                    lift = 0.07,
                    shut = 0.3,
                    snap = 0.11,
                    hold = 0.14,
                    reopen = 0.55,
                    every = { 2.4, 4.2 }
                }
            },
            Hydrax = {
                lam = 0.7,
                alpha = 1.2,
                tail = 0.07,
                alphaB = 1.6,
                tailB = 0.09,
                stride = 0.5,
                finAmp = 0.25,
                finRate = 1,
                turns = {
                    gape = 0.22,
                    shut = 0.3,
                    hold = 0.12,
                    breath = 0.04,
                    breathRate = 2,
                    gap = { 0.5, 1.3 }
                }
            },
            Tigermosasaur = {
                lam = 1,
                alpha = 2.8,
                tail = 0.11,
                alphaB = 3.2,
                tailB = 0.12,
                stride = 0.95,
                finAmp = 0.1,
                finRate = 0.5,
                bite = {
                    gape = 0.12,
                    lift = 0.03,
                    shut = 0.48,
                    snap = 0.09,
                    hold = 0.12,
                    reopen = 0.5,
                    every = { 2.8, 4.6 }
                }
            },
            Spinosaurus = {
                lam = 1.05,
                alpha = 1.9,
                tail = 0.13,
                alphaB = 2.2,
                tailB = 0.15,
                stride = 0.8,
                finAmp = 0.18,
                finRate = 0.5,
                bite = {
                    gape = 0.14,
                    lift = 0.04,
                    shut = 0.3,
                    snap = 0.09,
                    hold = 0.12,
                    reopen = 0.5,
                    every = { 2.8, 4.6 }
                }
            },
            CrownedMosasaur = {
                lam = 0.95,
                alpha = 1.8,
                tail = 0.14,
                alphaB = 2,
                tailB = 0.16,
                stride = 0.8,
                finAmp = 0.2,
                finRate = 0.5
            },
            MummifiedMosasaur = {
                lam = 0.95,
                alpha = 1.8,
                tail = 0.14,
                alphaB = 2,
                tailB = 0.16,
                stride = 0.8,
                finAmp = 0.2,
                finRate = 0.5,
                chomp = {
                    wind = 0.3,
                    gape = 0.28,
                    lift = 0.18,
                    snap = 0.06,
                    hold = 0.08,
                    reopen = 0.16,
                    shut = 0.42,
                    dip = 0.06,
                    shake = 0.26,
                    shakeHz = 6,
                    hookHz = 5,
                    maxYaw = 0.26,
                    minPitch = -0.06,
                    maxPitch = 0.18,
                    every = { 1.8, 3.2 },
                    chomps = { 1, 3 }
                },
                head = {
                    yaw = 0.09,
                    pitch = 0.04,
                    rate = 0.45
                }
            },
            Dreadsaber = {
                lam = 0.7,
                alpha = 1.2,
                tail = 0.07,
                alphaB = 1.6,
                tailB = 0.09,
                stride = 0.5,
                finAmp = 0.2,
                finRate = 0.5,
                chomp = {
                    wind = 0.3,
                    gape = 0.28,
                    lift = 0.18,
                    snap = 0.06,
                    hold = 0.08,
                    reopen = 0.16,
                    shut = 0.42,
                    dip = 0.06,
                    shake = 0.26,
                    shakeHz = 6,
                    hookHz = 5,
                    maxYaw = 0.26,
                    minPitch = -0.06,
                    maxPitch = 0.18,
                    every = { 1.8, 3.2 },
                    chomps = { 1, 3 }
                },
                head = {
                    yaw = 0.09,
                    pitch = 0.04,
                    rate = 0.45
                }
            },
            AbominatedMaw = {
                lam = 0.9,
                alpha = 3,
                tail = 0.11,
                alphaB = 3.2,
                tailB = 0.13,
                stride = 0.8,
                hookTail = 0.13,
                hookAlpha = 3.2,
                chomp = {
                    wind = 0.3,
                    gape = 0.28,
                    lift = 0.18,
                    snap = 0.06,
                    hold = 0.08,
                    reopen = 0.16,
                    shut = 0.42,
                    dip = 0.06,
                    shake = 0.26,
                    shakeHz = 6,
                    hookHz = 5,
                    maxYaw = 0.26,
                    minPitch = -0.06,
                    maxPitch = 0.18,
                    every = { 1.8, 3.2 },
                    chomps = { 1, 3 }
                },
                head = {
                    yaw = 0.09,
                    pitch = 0.04,
                    rate = 0.45
                }
            },
            Gravedigger = {
                lam = 0.95,
                alpha = 1.8,
                tail = 0.14,
                alphaB = 2,
                tailB = 0.16,
                stride = 0.8,
                minHz = 0.45,
                lure = {
                    k = 14,
                    c = 5.2,
                    surge = 0.012,
                    turn = 0.006,
                    idle = 0.06,
                    max = 0.25,
                    split = 0.6,
                    lan = {
                        k = 12,
                        c = 4.5,
                        surge = 0.02,
                        turn = 0.009,
                        idle = 0.07,
                        max = 0.38
                    }
                },
                jaw = {
                    breath = 3.6,
                    amp = 0.06,
                    snapAcc = 120,
                    yawn = {
                        open = 0.12,
                        time = 1.6,
                        every = { 5, 9 }
                    },
                    snap = {
                        shut = 0.24,
                        time = 0.45
                    },
                    hook = {
                        rate = 3.2,
                        shut = 0.22
                    }
                }
            },
            WizardSquid = {
                lam = 0.9,
                alpha = 3,
                tail = 0.11,
                alphaB = 3.2,
                tailB = 0.13,
                stride = 0.8,
                hookTail = 0.13,
                hookAlpha = 3.2,
                trail = {
                    lag = 0.45,
                    gain = 1.15,
                    heave = 0.05
                },
                cast = {
                    attr = "Spell",
                    lift = 0.25,
                    charge = 0.45,
                    rise = 0.75,
                    snap = 0.12
                }
            },
            VoidspikedBattleworm = {
                lam = 0.9,
                alpha = 1.5,
                tail = 0.1,
                alphaB = 1.8,
                tailB = 0.11,
                stride = 0.75,
                jawGape = 0.32,
                jawSync = true,
                heave = {
                    amp = 0.6,
                    lag = 1.5708
                },
                jawEvery = { 1.4, 2.4 }
            },
            Voidlurker = {
                lam = 0.55,
                alpha = 1.4,
                tail = 0.075,
                alphaB = 1.7,
                tailB = 0.085,
                stride = 0.5,
                bite = {
                    gape = 0.22,
                    lift = 0.06,
                    shut = 0.34,
                    snap = 0.12,
                    hold = 0.14,
                    reopen = 0.7,
                    every = { 2.2, 3.8 }
                }
            },
            Voidbloom = {
                lam = 0.75,
                alpha = 1.6,
                tail = 0.09,
                alphaB = 1.9,
                tailB = 0.1,
                stride = 0.6,
                jawGape = 0.42,
                jawSync = true,
                jawStagger = 0.6,
                jawEvery = { 1.6, 2.6 }
            }
        },
        h = function(p3, p4, p5, p6, p7) -- h | line: 280
            return p5 * math.exp(p6 * (p3 - 1)) * math.sin(p4 - 6.283185307179586 * p3 / p7)
        end,
        pose = function(p8, p9, p10, p11, p12, p13) -- pose | line: 285
            -- upvalues: p1 (copy)
            local EelSwim = p1.EelSwim
            local v4 = if p12 then p11.hookTail or EelSwim.HOOK_TAIL else p11.tail + (p11.tailB - p11.tail) * p10
            local v5 = if p12 then p11.hookAlpha or EelSwim.HOOK_ALPHA else p11.alpha + (p11.alphaB - p11.alpha) * p10
            local v6 = v4 * (p13 or 1)
            local t2 = {}
            local v7 = #p8 - 1
            local n1 = 0

            for i = 1, v7 do
                local v8 = p8[i]
                local v9 = p8[i + 1]
                local v11 = math.atan((EelSwim.h(v9, p9, v6, v5, p11.lam) - EelSwim.h(v8, p9, v6, v5, p11.lam)) / (v9 - v8))

                t2[i] = v11 - n1
                n1 = v11
            end

            return t2
        end,
        slide = function(p14, p15, p16, p17, p18) -- slide | line: 305
            -- upvalues: p1 (copy)
            local EelSwim = p1.EelSwim
            local v12 = if p18 then p17.hookTail or EelSwim.HOOK_TAIL else p17.tail + (p17.tailB - p17.tail) * p16
            local v13 = if p18 then p17.hookAlpha or EelSwim.HOOK_ALPHA else p17.alpha + (p17.alphaB - p17.alpha) * p16

            return EelSwim.h(p14[1], p15, v12, v13, p17.lam)
        end,
        register = function(p19) -- register | line: 316
            -- upvalues: p1 (copy), attr (copy)
            local EelSwim = p1.EelSwim
            local MeshPart = p19:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p19, "AnatomyInverse")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local CFrame = MeshPart.CFrame
            local v14 = p19:GetPivot() * AnatomyInverse:Inverse()
            local v15 = CFrame:VectorToObjectSpace(v14.RightVector)
            local v16 = CFrame:VectorToObjectSpace(v14.UpVector)
            local Size = MeshPart.Size
            local v19 = math.abs(v15.X) * Size.X + math.abs(v15.Y) * Size.Y + math.abs(v15.Z) * Size.Z
            local t3 = {}
            local t4 = {}

            for i = 1, 99 do
                local v20 = MeshPart:FindFirstChild(string.format("Spine_%02d", i), true)

                if not v20 then
                    break
                end

                local v21 = CFrame:ToObjectSpace(v20.WorldCFrame)

                t3[i] = {
                    bone = v20,
                    up = v21:VectorToObjectSpace(v16)
                }
                t4[i] = (v19 / 2 - v21.Position:Dot(v15)) / v19
            end

            if #t3 < 3 then
                return nil
            end

            t4[#t3 + 1] = EelSwim.TIP

            local t5 = {}

            for _, v22 in ipairs({ "Fin_FL", "Fin_FR", "Fin_RL", "Fin_RR" }) do
                local v23 = MeshPart:FindFirstChild(v22, true)

                if v23 then
                    local v24 = CFrame:ToObjectSpace(v23.WorldCFrame)

                    t5[#t5 + 1] = {
                        bone = v23,
                        axis = v24:VectorToObjectSpace(v15),
                        up = v24:VectorToObjectSpace(v16),
                        side = v22:sub(-1) == "L" and 1 or -1,
                        lag = v22:sub(5, 5) == "F" and 0 or 1.5
                    }
                end
            end

            local v26 = EelSwim.KINDS[attr(p19, "EelKind") or "Eel"] or EelSwim.KINDS.Eel
            local t7 = {
                v = 0,
                burst = 0,
                model = p19,
                mesh = MeshPart,
                spine = t3,
                knots = t4,
                fins = t5,
                ext = v19,
                P = v26,
                phase = math.random() * 6.283185307179586
            }
            local Unit = v15:Cross(v16).Unit

            local function axes(p20) -- line: 353
                -- upvalues: CFrame (copy), v15 (copy), v16 (copy), Unit (copy)
                local v27 = CFrame:ToObjectSpace(p20.WorldCFrame)

                return {
                    bone = p20,
                    up = v27:VectorToObjectSpace(v16),
                    right = v27:VectorToObjectSpace(Unit),
                    nose = v27:VectorToObjectSpace(v15)
                }
            end

            if v26.track then
                t3[1].right = axes(t3[1].bone).right
            end

            if v26.lure then
                local v28 = MeshPart:FindFirstChild("Lure_1", true)
                local v29 = MeshPart:FindFirstChild("Lure_2", true)
                local v30 = MeshPart:FindFirstChild("Lantern", true)

                if v28 and v29 and v30 then
                    t7.lure = {
                        axes(v28),
                        axes(v29),
                        (axes(v30))
                    }
                    t7.lp = 0
                    t7.lpv = 0
                    t7.ly = 0
                    t7.lyv = 0
                    t7.pf = 0
                    t7.pfv = 0
                    t7.ps = 0
                    t7.psv = 0
                end
            end

            if v26.jaw then
                local v31 = MeshPart:FindFirstChild("Jaw_1", true)

                if v31 then
                    t7.jaw = axes(v31)
                    t7.jt = math.random() * 10
                    t7.nextYawn = nil
                end
            end

            if v26.chomp then
                local v32 = MeshPart:FindFirstChild("Jaw_1", true)

                if v32 and t3[2] and t3[2].bone.Parent == t3[1].bone then
                    local v33 = axes(t3[1].bone)

                    t7.head = {
                        neck = t3[2].bone.CFrame.Position,
                        c2 = t3[2].bone.CFrame,
                        up = v33.up,
                        right = v33.right,
                        jaw = v32,
                        jawRight = axes(v32).right
                    }
                    t7.ct = math.random() * 5
                end
            end

            if v26.trail then
                local t8 = {}

                for i = 1, 99 do
                    local v34 = MeshPart:FindFirstChild(string.format("Trail_%02d", i), true)

                    if not v34 then
                        break
                    end

                    t8[i] = axes(v34)
                end

                if #t8 == #t3 then
                    t7.trail = t8

                    local v35 = t3[1]
                    local v36 = t3[2]
                    local right = axes(t3[1].bone).right
                    local right2 = axes(t3[2].bone).right

                    v35.right = right
                    v36.right = right2
                end
            end

            t7.t = 0
            t7.acc = 0
            t7.w = 0
            t7.noseM = v15

            return t7
        end,
        update = function(p21, p22) -- update | line: 400
            -- upvalues: p1 (copy), fightHooked (copy)
            local EelSwim = p1.EelSwim
            local _CFrame = p21.mesh.CFrame

            if p21.lastPos and p22 > 1E-04 then
                local v37 = (_CFrame.Position - p21.lastPos).Magnitude / p22

                if v37 < 2000 then
                    p21.v = p21.v + (v37 - p21.v) * math.min(1, p22 / EelSwim.V_TAU)
                end
            end

            p21.lastPos = _CFrame.Position

            local v40 = fightHooked(p21.model)
            local v41 = p21.v / math.max(p21.ext, 0.001)
            local v43 = math.clamp((v41 - 1) / 2, 0, 1)

            p21.burst = p21.burst + (v43 - p21.burst) * math.min(1, p22 / EelSwim.BURST_TAU)

            local v46, minHz, v47, v48

            if v40 then
                local HOOK_HZ = EelSwim.HOOK_HZ

                if HOOK_HZ then
                    v47 = HOOK_HZ
                    v48 = true
                else
                    v46 = v41 / p21.P.stride
                    minHz = p21.P.minHz or EelSwim.MIN_HZ
                    v48 = false
                end
            else
                v46 = v41 / p21.P.stride
                minHz = p21.P.minHz or EelSwim.MIN_HZ
                v48 = false
            end

            if not v48 then
                v47 = math.clamp(v46, minHz, p21.P.maxHz or EelSwim.MAX_HZ)
            end

            p21.phase += p22 * 2 * 3.141592653589793 * v47

            local v50 = EelSwim.pose(p21.knots, p21.phase, p21.burst, p21.P, v40)
            local P = p21.P

            if (P.finTurn or P.turnBend) and not p21.lure and not p21.jaw then
                local v51 = _CFrame:VectorToWorldSpace(p21.noseM)
                local v52 = Vector3.new(v51.X, 0, v51.Z)
                local Unit

                if v52.Magnitude > 1E-04 then
                    Unit = v52.Unit

                    if p21.lastFlat and p22 > 1E-04 then
                        local v54 = math.atan2(p21.lastFlat:Cross(Unit).Y, (p21.lastFlat:Dot(Unit))) / p22

                        p21.turn = (p21.turn or 0) + (math.clamp(v54 / P.turnFull, -1, 1) - (p21.turn or 0)) * math.min(1, p22 / P.turnTau)
                    end

                    p21.lastFlat = Unit
                end
            end

            if P.turnBend then
                local v59 = P.turnBend * (p21.turn or 0) / #p21.spine

                for i = 1, #v50 do
                    v50[i] += v59
                end
            end

            for v60, v61 in ipairs(p21.spine) do
                v61.bone.Transform = CFrame.fromAxisAngle(v61.up, v50[v60])
            end

            if p21.P.track then
                local v62 = p21.spine[1]

                v62.bone.Transform = CFrame.new(v62.right * (EelSwim.slide(p21.knots, p21.phase, p21.burst, p21.P, v40) * p21.ext)) * CFrame.fromAxisAngle(v62.up, v50[1])
            end

            if p21.head then
                local head = p21.head
                local v63 = p21.spine[1]
                local v64 = p21.spine[2]
                local v65, v66, v67 = EelSwim.chomp(p21, p22, v40)
                local neck = head.neck
                local v68 = CFrame.new(neck) * CFrame.fromAxisAngle(head.up, v65) * CFrame.fromAxisAngle(head.right, v66) * CFrame.new(-neck)

                v63.bone.Transform = CFrame.fromAxisAngle(v63.up, v50[1]) * v68
                v64.bone.Transform = head.c2:Inverse() * v68:Inverse() * head.c2 * CFrame.fromAxisAngle(v64.up, v50[2])
                head.jaw.Transform = CFrame.fromAxisAngle(head.jawRight, v67)
            end

            local finFold = p21.P.finFold

            if finFold then
                finFold *= math.min(1, v41 / (p21.P.foldV or 1))
            end

            local finAdduct = p21.P.finAdduct

            finAdduct = finAdduct and p21.P.finAdduct * math.min(1, v41 / (p21.P.foldV or 1))

            for _, v71 in ipairs(p21.fins) do
                local v72 = if finAdduct then CFrame.fromAxisAngle(v71.axis, v71.side * ((p21.P.finAmp or EelSwim.FIN_AMP) * math.sin(p21.phase * (p21.P.finRate or EelSwim.FIN_RATE) + v71.lag) - finAdduct)) else CFrame.fromAxisAngle(v71.axis, v71.side * (p21.P.finAmp or EelSwim.FIN_AMP) * math.sin(p21.phase * (p21.P.finRate or EelSwim.FIN_RATE) + v71.lag))
                local v77 = if finFold and p21.P.finTurn then finFold * (1 - p21.P.finTurn * math.max(0, -v71.side * (p21.turn or 0))) else finFold

                v71.bone.Transform = v77 and CFrame.fromAxisAngle(v71.up, v71.side * v77) * v72 or v72
            end

            if p21.lure or p21.jaw then
                EelSwim.parts(p21, p22, _CFrame, v40)
            end

            if p21.trail then
                EelSwim.drag(p21, v50, v40)
            end
        end,
        chomp = function(p23, p24, p25) -- chomp | line: 472
            local chomp, head = p23.P.chomp, p23.P.head

            p23.ct += p24

            local ct = p23.ct
            local v82 = head.yaw * (math.sin(ct * 6.283185307179586 * head.rate) + math.sin(ct * 6.283185307179586 * head.rate * 2.3 + 1.1) * 0.35)
            local v84 = head.pitch * math.sin(ct * 6.283185307179586 * head.rate * 0.8 + 0.6)
            local v85, v87
            local v86 = v84

            if p25 then
                v85 = v82 + chomp.shake * math.sin(ct * 6.283185307179586 * chomp.shakeHz)
                v87 = chomp.shut * (math.sin(ct * 6.283185307179586 * chomp.hookHz) * 0.5 + 0.5)
            else
                p23.biteAt = p23.biteAt or ct + chomp.every[1] + math.random() * (chomp.every[2] - chomp.every[1])

                local v90 = ct - p23.biteAt

                v85 = v82

                if v90 >= 0 then
                    p23.chomps = p23.chomps or math.random(chomp.chomps[1], chomp.chomps[2])

                    local v91 = chomp.snap + chomp.hold + chomp.reopen

                    if v90 < chomp.wind then
                        local v92 = v90 / chomp.wind
                        local v93 = v92 * v92 * (3 - 2 * v92)

                        v87 = -chomp.gape * v93
                        v86 = v84 + chomp.lift * v93
                    else
                        local v94 = v90 - chomp.wind
                        local v96 = math.floor(v94 / v91)

                        if p23.chomps <= v96 then
                            p23.biteAt = nil
                            v87 = 0
                            p23.chomps = nil
                        else
                            local v97 = v94 - v96 * v91
                            local v98 = v96 == p23.chomps - 1
                            local v99 = v96 == 0 and -chomp.gape or -chomp.gape * 0.5
                            local lift = v96 == 0 and chomp.lift or chomp.lift * 0.4
                            local v100 = if v98 then 0 else -chomp.gape * 0.5
                            local v101 = if v98 then 0 else chomp.lift * 0.4
                            local v102

                            if v97 < chomp.snap then
                                local v103 = (v97 / chomp.snap) ^ 2

                                v87 = v99 + (chomp.shut - v99) * v103
                                v102 = lift + (-chomp.dip - lift) * v103
                            elseif v97 < chomp.snap + chomp.hold then
                                v87 = chomp.shut
                                v102 = -chomp.dip
                            else
                                local v104 = (v97 - chomp.snap - chomp.hold) / chomp.reopen
                                local v105 = v104 * v104 * (3 - 2 * v104)

                                v87 = chomp.shut + (v100 - chomp.shut) * v105
                                v102 = -chomp.dip + (v101 + chomp.dip) * v105
                            end

                            v86 = v84 + v102
                            v85 = v82 + chomp.shake * math.sin(v94 * 6.283185307179586 * chomp.shakeHz) * (1 - v94 / (p23.chomps * v91))
                        end
                    end
                else
                    v87 = 0
                end
            end

            return math.clamp(v85, -chomp.maxYaw, chomp.maxYaw), math.clamp(v86, chomp.minPitch, chomp.maxPitch), v87
        end,
        drag = function(p26, p27, p28) -- drag | line: 528
            -- upvalues: p1 (copy), attr (copy)
            local EelSwim = p1.EelSwim
            local P = p26.P
            local trail, cast = P.trail, P.cast
            local v109 = cast and attr(p26.model, cast.attr)
            local n2 = 0

            if type(v109) == "number" then
                if p28 then
                else
                    local v110 = workspace:GetServerTimeNow() - v109

                    if v110 >= 0 and v110 < cast.charge then
                        local v112 = math.min(1, v110 / (cast.charge * cast.rise))

                        n2 = cast.lift * v112 * v112 * (3 - v112 * 2)
                    elseif cast.charge <= v110 and v110 < cast.charge + cast.snap then
                        local v113 = (v110 - cast.charge) / cast.snap

                        n2 = cast.lift * (1 - v113 * v113 * (3 - 2 * v113))
                    end
                end
            end

            local v114 = EelSwim.pose(p26.knots, p26.phase - trail.lag, p26.burst, P, p28, trail.gain)
            local v115 = #p26.trail

            for v116, v117 in ipairs(p26.trail) do
                local v119 = trail.heave * math.sin(0.7 * p26.phase - 0.9 * (v116 - 1)) / v115 * 3

                v117.bone.Transform = CFrame.fromAxisAngle(v117.right, v116 == 1 and -n2 or 0) * CFrame.fromAxisAngle(v117.up, v114[v116]) * CFrame.fromAxisAngle(v117.right, v119)
            end

            if not (n2 > 0) then
                return
            end

            local v120 = p26.spine[1]
            local v121 = p26.spine[2]

            v120.bone.Transform = CFrame.fromAxisAngle(v120.right, n2) * CFrame.fromAxisAngle(v120.up, p27[1])
            v121.bone.Transform = CFrame.fromAxisAngle(v121.right, -n2) * CFrame.fromAxisAngle(v121.up, p27[2])
        end,
        parts = function(p29, p30, p31, p32) -- parts | line: 557
            local P = p29.P
            local v122 = math.min(p30, 0.03333333333333333)

            p29.t += p30

            if v122 <= 1E-04 then
                return
            end

            local v = p29.v

            p29.acc = p29.acc + ((v - (p29.lastV or v)) / v122 - p29.acc) * math.min(1, v122 / 0.12)
            p29.lastV = v

            local v125 = p31:VectorToWorldSpace(p29.noseM)
            local v126 = Vector3.new(v125.X, 0, v125.Z)

            if v126.Magnitude > 0.001 then
                local Unit = v126.Unit

                if p29.lastFlat then
                    local v128 = math.atan2(p29.lastFlat:Cross(Unit).Y, (p29.lastFlat:Dot(Unit))) / v122

                    p29.w = p29.w + (v128 - p29.w) * math.min(1, v122 / 0.15)
                end

                p29.lastFlat = Unit
            end

            local v131 = math.clamp(p29.acc, -400, 400)
            local w = p29.w

            if p29.lure then
                local lure = P.lure
                local lan = P.lure.lan
                local v132 = if p32 then 4 else 1
                local v138 = math.clamp(lure.surge * v131 + lure.idle * v132 * math.sin(1.1 * p29.t), -lure.max, lure.max)
                local v144 = math.clamp(-lure.turn * v * w + lure.idle * v132 * math.sin(0.8 * p29.t + 1), -lure.max, lure.max)

                p29.lpv += (lure.k * (v138 - p29.lp) - lure.c * p29.lpv) * v122
                p29.lp += p29.lpv * v122
                p29.lyv += (lure.k * (v144 - p29.ly) - lure.c * p29.lyv) * v122
                p29.ly += p29.lyv * v122

                local v145 = p29.lure[1]
                local v146 = p29.lure[2]
                local v147 = p29.lure[3]
                local split = lure.split

                v145.bone.Transform = CFrame.fromAxisAngle(v145.up, p29.ly * split) * CFrame.fromAxisAngle(v145.right, p29.lp * split)
                v146.bone.Transform = CFrame.fromAxisAngle(v146.up, p29.ly * (1 - split)) * CFrame.fromAxisAngle(v146.right, p29.lp * (1 - split))

                local v153 = math.clamp(-lan.surge * v131 + lan.idle * v132 * math.sin(1.3 * p29.t), -lan.max, lan.max)
                local v159 = math.clamp(-lan.turn * v * w + lan.idle * v132 * math.sin(0.9 * p29.t + 2), -lan.max, lan.max)

                p29.pfv += (lan.k * (v153 - p29.pf) - lan.c * p29.pfv) * v122
                p29.pf += p29.pfv * v122
                p29.psv += (lan.k * (v159 - p29.ps) - lan.c * p29.psv) * v122
                p29.ps += p29.psv * v122
                v147.bone.Transform = CFrame.fromAxisAngle(v147.up, -p29.ly) * CFrame.fromAxisAngle(v147.right, -p29.lp + p29.pf) * CFrame.fromAxisAngle(v147.nose, p29.ps)
            end

            local v160 = false
            local v161 = false
            local v162 = false
            local v163 = false
            local v164 = false
            local v165 = false

            if p29.jaw then
                v160 = true
            else
                v165 = true
            end

            local jaw

            if v160 then
                jaw = P.jaw
                p29.jt += p30

                if p32 then
                    v162 = true
                else
                    v161 = true
                end
            end

            v160 = false

            local v166, v167

            if v161 then
                v166 = jaw.amp * (0.5 - math.cos(p29.jt * 2 * 3.141592653589793 / jaw.breath) * 0.5)

                local nextYawn = p29.nextYawn

                if nextYawn then
                    v167 = nextYawn
                    v163 = true
                else
                    v160 = true
                end
            end

            v161 = false

            if v160 then
                v167 = p29.jt + jaw.yawn.every[1] + math.random() * (jaw.yawn.every[2] - jaw.yawn.every[1])
                v163 = true
            end

            v160 = false

            local v169

            if v163 then
                p29.nextYawn = v167

                if p29.jt >= p29.nextYawn then
                    v160 = true
                else
                    v169 = v166
                    v161 = true
                end
            end

            v163 = false

            local v170

            if v160 then
                v170 = (p29.jt - p29.nextYawn) / jaw.yawn.time

                if v170 >= 1 then
                    v164 = true
                else
                    v163 = true
                end
            end

            v160 = false

            if v163 then
                v169 = v166 - jaw.yawn.open * math.sin(3.141592653589793 * v170) ^ 2
                v161 = true
            end

            v163 = false

            if v164 then
                p29.nextYawn = p29.jt + jaw.yawn.every[1] + math.random() * (jaw.yawn.every[2] - jaw.yawn.every[1])
                v169 = v166
                v161 = true
            end

            v164 = false

            if v161 then
                if jaw.snapAcc < v131 then
                    v164 = true
                else
                    v163 = true
                end
            end

            v161 = false

            if v164 then
                if p29.snapAt then
                    v163 = true
                else
                    v161 = true
                end
            end

            v164 = false

            if v161 then
                v163 = true
                p29.snapAt = p29.jt
            end

            v161 = false

            local v172

            if v163 then
                if p29.snapAt then
                    v161 = true
                else
                    v172 = v169
                    v165 = false
                end
            end

            v163 = false

            local v173

            if v161 then
                v173 = (p29.jt - p29.snapAt) / jaw.snap.time

                if v173 >= 1 then
                    v164 = true
                else
                    v163 = true
                end
            end

            v161 = false

            local shut

            if v163 then
                shut = jaw.snap.shut

                if v173 < 0.15 then
                    v161 = true
                else
                    v160 = true
                end
            end

            v163 = false

            local v174

            if v161 then
                local v175 = v173 / 0.15

                if v175 then
                    v174 = v175
                    v163 = true
                else
                    v160 = true
                end
            end

            if v160 then
                v174 = (1 - (v173 - 0.15) / 0.85) ^ 2
                v163 = true
            end

            if v163 then
                v172 = math.max(v169, shut * v174)
                v165 = false
            end

            v163 = false

            if v164 then
                if v131 < jaw.snapAcc * 0.5 then
                    v163 = true
                else
                    v172 = v169
                    v165 = false
                end
            end

            if v163 then
                p29.snapAt = nil
                v172 = v169
                v165 = false
            end

            if v162 then
                v172 = jaw.hook.shut * (math.sin(p29.jt * 2 * 3.141592653589793 * jaw.hook.rate) * 0.5 + 0.5)
                v165 = false
            end

            if not v165 then
                p29.jaw.bone.Transform = CFrame.fromAxisAngle(p29.jaw.right, v172)
            end
        end
    }
end
