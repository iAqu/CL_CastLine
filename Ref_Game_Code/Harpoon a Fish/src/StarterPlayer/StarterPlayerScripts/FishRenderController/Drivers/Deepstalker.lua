-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.Deepstalker = {
        V_TAU = 0.2,
        FIN_RATE = 1.2,
        FIN_AMP = 0.3,
        FIN_WRAP = 0.9,
        STIFF_FREE = 5,
        STIFF_JET = 9,
        DAMP = 0.9,
        register = function(p3) -- register | line: 28
            local DeepstalkerPlan = require(game:GetService("ReplicatedStorage").Modules.DeepstalkerPlan)
            local MeshPart = p3:FindFirstChildWhichIsA("MeshPart")

            if not MeshPart then
                return nil
            end

            local t2 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t2[descendant.Name] = descendant
                end
            end

            if not (t2.Head and t2.Mantle_2 and t2.Fin_L and t2.Fin_R) then
                return nil
            end

            local CFrame = MeshPart.CFrame
            local t3 = {}

            for v1, v2 in ipairs(DeepstalkerPlan.LIMBS) do
                local t4 = {}
                local n1 = 1

                while t2[v2 .. "_" .. n1] do
                    t4[n1] = t2[v2 .. "_" .. n1]
                    n1 += 1
                end

                if #t4 < 2 then
                    return nil
                end

                local t5 = {}
                local t6 = {}

                for v3, v4 in ipairs(t4) do
                    local v5 = CFrame:ToObjectSpace(v4.WorldCFrame)

                    t5[v3] = v5.Rotation
                    t6[v3] = v5.Position
                end

                local t7 = {}
                local t8 = {}
                local v6 = #t4 - 1
                local n2 = 0

                for i = 1, v6 do
                    local v7 = t6[i + 1] - t6[i]

                    t8[i] = v7.Magnitude
                    t7[i] = v7.Unit
                    n2 += t8[i]
                end

                t8[#t4] = t8[#t4 - 1]
                t7[#t4] = t7[#t4 - 1]
                t3[v1] = {
                    name = v2,
                    bones = t4,
                    rest = t5,
                    dirs = t7,
                    lens = t8,
                    len = n2 + t8[#t4],
                    rootL = t6[1],
                    phase = 6.283185307179586 * v1 / #DeepstalkerPlan.LIMBS
                }
            end

            local v8 = CFrame:PointToObjectSpace(t2.Head.WorldPosition)
            local Unit = (v8 - CFrame:PointToObjectSpace(t2.Mantle_2.WorldPosition)).Unit
            local Unit2 = (Vector3.new(0, 1, 0) - Unit * (Vector3.new(0, 1, 0)):Dot(Unit)).Unit
            local t9 = {}

            for _, v9 in ipairs({
                    { "Fin_L", 1 },
                    { "Fin_R", -1 }
                }) do
                local v10 = t2[v9[1]]

                t9[#t9 + 1] = {
                    bone = v10,
                    side = v9[2],
                    rest = CFrame:ToObjectSpace(v10.WorldCFrame).Rotation
                }
            end

            return {
                vel = Vector3.new(0, 0, 0),
                model = p3,
                mesh = MeshPart,
                P = DeepstalkerPlan,
                limbs = t3,
                fins = t9,
                headL = v8,
                noseL = Unit,
                upL = Unit2,
                clear = 0.1 * MeshPart.Size.Y,
                clock = math.random() * 10
            }
        end,
        turn = function(p4, p5) -- turn | line: 77
            local v11 = p4:Cross(p5)
            local Magnitude = v11.Magnitude
            local v12 = p4:Dot(p5)

            if Magnitude < 1E-06 then
                if v12 > 0 then
                    return CFrame.identity
                end

                local v13 = p4:Cross((Vector3.new(1, 0, 0)))

                if v13.Magnitude < 0.001 then
                    v13 = p4:Cross((Vector3.new(0, 1, 0)))
                end

                return CFrame.fromAxisAngle(v13.Unit, 3.141592653589793)
            end

            return CFrame.fromAxisAngle(v11 / Magnitude, (math.atan2(Magnitude, v12)))
        end,
        apply = function(p6, p7, p8) -- apply | line: 89
            -- upvalues: p1 (copy)
            local Deepstalker = p1.Deepstalker
            local v14 = CFrame.identity

            for v15, v16 in ipairs(p6.bones) do
                local v17 = v14:VectorToWorldSpace(p6.dirs[v15])
                local v18 = p8:VectorToObjectSpace(p7[v15 + 1] - p7[v15])
                local v19 = v18.Magnitude > 1E-06 and v18.Unit or v17
                local v20 = Deepstalker.turn(v17, v19) * v14
                local v21 = p6.rest[v15]

                v16.Transform = v21:Inverse() * (v14:Inverse() * v20) * v21
                v14 = v20
            end
        end,
        freeShape = function(p9, p10, p11, p12, p13, p14, p15, p16) -- freeShape | line: 103
            local t10 = {
                p10
            }
            local v22 = p11:Cross((Vector3.new(0, 1, 0)))

            if v22.Magnitude < 1E-04 then
                v22 = p11:Cross((Vector3.new(1, 0, 0)))
            end

            local Unit = v22.Unit
            local Unit2 = Unit:Cross(p11).Unit

            for i = 1, 8 do
                local v23 = i / 8
                local v24 = p15 * v23 ^ 1.5 * p9.len
                local v29 = p10 + p11 * (p9.len * v23) + p12 * (1 - p14 * v23) + p16 * math.min(1, v23 * 2) + Unit * (v24 * math.sin(1.7 * p13 - v23 * 3 + p9.phase))
                local v30 = 0.6 * v24
                local v31 = 1.3 * p13 - v23 * 2.4 + 1.7 * p9.phase

                t10[i + 1] = v29 + Unit2 * (v30 * math.sin(v31))
            end

            return t10
        end,
        verlet = function(p17, p18, p19, p20, p21) -- verlet | line: 117
            if not p17.V then
                local v32 = table.clone(p18)
                local v33 = table.clone(p18)

                p17.V = v32
                p17.W = v33
            end

            local V, W = p17.V, p17.W

            V[1] = p18[1]
            W[1] = V[1]

            local v35 = math.min(1, p20 * p19)

            for i = 2, #V do
                local v36 = (V[i] - W[i]) * p21

                W[i] = V[i]
                V[i] = V[i] + v36 + (p18[i] - V[i]) * v35
            end

            for i = 1, #p17.lens do
                local v37 = V[i + 1] - V[i]
                local v38 = v37.Magnitude > 1E-06
                local Unit = if v38 then v37.Unit else nil
                local v39 = if not v38 or not Unit then (p18[i + 1] - p18[i]).Unit else Unit

                V[i + 1] = V[i] + v39 * p17.lens[i]
            end

            return table.clone(V)
        end,
        readPlan = function(p22) -- readPlan | line: 138
            -- upvalues: attr (copy)
            local DeepPlan = attr(p22.model, "DeepPlan")

            if DeepPlan == p22.planStr then
                return
            end

            p22.planStr = DeepPlan
            p22.plan = nil

            if not DeepPlan then
                return
            end

            local function v40() -- line: 144
                -- upvalues: DeepPlan (copy)
                return game:GetService("HttpService"):JSONDecode(DeepPlan)
            end

            local ok, result = pcall(v40)

            if ok then
                local function V(p23) -- line: 146
                    return (Vector3.new(p23[1], p23[2], p23[3]))
                end

                local cove = result.cove
                local v47 = Vector3.new(cove[1], cove[2], cove[3])
                local out = result.out
                local v51 = Vector3.new(out[1], out[2], out[3])

                result.cove = v47
                result.out = v51
                result.mouthPt = result.cove + result.out * result.mouth

                for _, v52 in ipairs(p22.limbs) do
                    local v53 = result.limbs[v52.name]

                    if v53 then
                        local a = v53.a
                        local t11 = {}

                        t11.a = Vector3.new(a[1], a[2], a[3])

                        local n = v53.n

                        t11.n = Vector3.new(n[1], n[2], n[3])

                        local lip = v53.lip

                        t11.lip = Vector3.new(lip[1], lip[2], lip[3])

                        local rad = v53.rad

                        t11.rad = Vector3.new(rad[1], rad[2], rad[3])
                        t11.r = v53.r
                        t11.d = v53.d
                        t11.edge = v53.edge
                        v52.g = t11
                        v52.phase = v53.az
                    end

                    v52.released = nil
                end

                p22.plan = result
            end
        end,
        update = function(p24, p25, _) -- update | line: 159
            -- upvalues: p1 (copy), p2 (copy), fightHooked (copy), attr (copy)
            local Deepstalker = p1.Deepstalker
            local P, model = p24.P, p24.model
            local _CFrame = p24.mesh.CFrame

            Deepstalker.readPlan(p24)

            local v66 = fightHooked(model)

            if v66 or attr(model, "Hooked") then
                p24.planOff = true
            end

            local plan = not p24.planOff and p24.plan or nil

            p24.clock += p25

            local CFramePosition = _CFrame.Position

            if p24.lastPos and p25 > 1E-04 and (CFramePosition - p24.lastPos).Magnitude < 30 then
                p24.vel = p24.vel:Lerp((CFramePosition - p24.lastPos) / p25, (math.min(1, p25 / Deepstalker.V_TAU)))
            end

            p24.lastPos = CFramePosition

            local v69 = _CFrame:PointToWorldSpace(p24.headL)
            local v70 = _CFrame:VectorToWorldSpace(p24.noseL)
            local v71 = plan and workspace:GetServerTimeNow() - p2.renderLag() - plan.at or nil
            local v72 = v71 and v71 - P.launch() or nil
            local vel = p24.vel
            local v73 = _CFrame:VectorToWorldSpace(p24.upL)
            local v74 = v70

            if vel.Magnitude > 0.001 then
                local v75 = P.smooth(vel.Magnitude / 12)
                local v76 = v70 * (1 - v75) - vel.Unit * v75 - v73 * (2 * v75 * (1 - v75))

                v74 = v76.Magnitude > 1E-04 and v76.Unit or v70
            end

            local STIFF_FREE = Deepstalker.STIFF_FREE
            local clock = p24.clock
            local v77, v78, v79, v80

            if v66 then
                v77 = 0.15
                v78 = 0.14
                clock = p24.clock * 3
                v79 = 1.3
                v80 = Vector3.new(0, 0, 0)
            elseif v72 and v72 > 0 then
                v77 = 0.85
                v78 = 0.03
                STIFF_FREE = Deepstalker.STIFF_JET
                v79 = 0.6
                v80 = -v73 * p24.clear
            else
                v77 = 0.45
                v78 = 0.07
                v79 = 1.3
                v80 = Vector3.new(0, 0, 0)
            end

            for _, v81 in ipairs(p24.limbs) do
                local v82 = _CFrame:PointToWorldSpace(v81.rootL)
                local g = v81.g
                local v83

                if plan and g and not v81.released and v71 < P.launch() + P.LET_GO[v81.name] then
                    local out, cove = plan.out, plan.cove
                    local v84 = (v71 - P.DELAY[v81.name]) / P.DUR[v81.name]
                    local v85 = P.smoother(v84)
                    local v86 = v82 + v70 * (0.55 * v81.len)
                    local v87 = plan.mouthPt + out * 2 + g.rad * (g.r * 0.45)
                    local v88 = g.lip - out * 3.5 + g.rad * 1.5
                    local Unit = g.edge and (g.rad * 0.5 + out).Unit or (g.rad + out * 0.45).Unit
                    local v89

                    if v84 < 1 then
                        v89 = P.bezier(v86, v87, v88, g.a, v85)

                        local v93 = P.bezier(v86, v87, v88, g.a, (math.min(1, v85 + 0.02))) - P.bezier(v86, v87, v88, g.a, (math.max(0, v85 - 0.02)))
                        local v94 = v93.Magnitude > 1E-06 and v93.Unit or v70

                        Unit = P.slerpDir(v94, Unit, P.smooth((v85 - 0.6) / 0.4))
                    else
                        v89 = g.a
                    end

                    local v95 = v82 - v69 - v70 * (v82 - v69):Dot(v70)
                    local Unit2 = (v70 + (v95.Magnitude > 1E-04 and v95.Unit * 0.5 or Vector3.new(0, 0, 0))).Unit
                    local v96 = P.slerpDir(_CFrame:VectorToWorldSpace(v81.dirs[1]), Unit2, 0.55)
                    local v97 = v89 - cove
                    local v98, v99

                    if (v97 - out * v97:Dot(out)).Magnitude > g.r - 1 and v97:Dot(out) < plan.mouth + 1 and (v82 - cove):Dot(out) > plan.mouth - 1 then
                        v98, v99 = P.arcLimb({
                            { v82, v96 },
                            {
                                g.lip,
                                (-out + g.rad * 0.9).Unit
                            },
                            { v89, Unit }
                        }, v81.len)
                    else
                        v98, v99 = P.arcLimb({
                            {
                                v82,
                                v96
                            },
                            {
                                v89,
                                Unit
                            }
                        }, v81.len)
                    end

                    if v99 and v84 >= 1 and P.REACH < v71 then
                        v81.released = v71
                    else
                        v83 = P.walk(v82, v98, v81.lens)

                        local v100 = table.clone(v83)
                        local v101 = table.clone(v83)

                        v81.V = v100
                        v81.W = v101
                    end
                end

                if not v83 then
                    local v102 = v82 - v69 - v70 * (v82 - v69):Dot(v70)
                    local v103 = Deepstalker.freeShape(v81, v82, v74, v102 * v79, clock, v77, v78, v80)

                    v83 = Deepstalker.verlet(v81, P.walk(v82, P.catmull(v103, 6), v81.lens), p25, STIFF_FREE, Deepstalker.DAMP)
                end

                Deepstalker.apply(v81, v83, _CFrame)
            end

            local v104, v105

            if v72 and v72 > 0 then
                local v106 = P.smooth(v72 / 0.3)

                if v106 then
                    v104 = v106
                    v105 = true
                else
                    v105 = false
                end
            else
                v105 = false
            end

            if not v105 then
                v104 = 0
            end

            local noseL = p24.noseL

            for _, v107 in ipairs(p24.fins) do
                local v111 = v107.side * (-Deepstalker.FIN_WRAP * v104 + (1 - v104) * Deepstalker.FIN_AMP * math.sin(6.283185307179586 * Deepstalker.FIN_RATE * p24.clock))

                v107.bone.Transform = v107.rest:Inverse() * CFrame.fromAxisAngle(noseL, v111) * v107.rest
            end
        end
    }
end
