-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 20
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.MawSwim = {
        K_ROOT = 50,
        K_TIP = 5,
        C = 5,
        W_AMP = 0.018,
        W_AMP_V = 0.022,
        W_OM = 2.2,
        W_OM_V = 2,
        W_LAG = 0.9,
        W_GROW = 1.5,
        HOOK_K = 0.5,
        HOOK_W = 2.5,
        HOOK_OM = 9,
        DT_SUB = 0.016666666666666666,
        RESET_DT = 0.25,
        JUMP = 0.5,
        MAX_ROOT = 1.6,
        MAX_BEND = 0.55,
        FLOW = 28,
        FLOW_POW = 0.6,
        CONVERGE = 4,
        DOWN = 0.7,
        GOLD = 2.39996,
        LOD_D = { 150, 400 },
        turnTo = function(p3, p4) -- turnTo | line: 37
            local Unit = p3.Unit
            local Unit2 = p4.Unit
            local v1 = Unit:Cross(Unit2)
            local Magnitude = v1.Magnitude

            if Magnitude < 1E-09 then
                return CFrame.identity
            end

            return CFrame.fromAxisAngle(v1 / Magnitude, (math.atan2(Magnitude, (Unit:Dot(Unit2)))))
        end,
        angle = function(p5, p6) -- angle | line: 45
            return (math.acos((math.clamp(p5:Dot(p6), -1, 1))))
        end,
        slerp = function(p7, p8, p9) -- slerp | line: 49
            local v8 = math.acos((math.clamp(p7:Dot(p8), -1, 1)))
            local v9 = math.sin(v8)

            if v9 < 1E-06 then
                return p7:Lerp(p8, p9)
            end

            return p7 * (math.sin((1 - p9) * v8) / v9) + p8 * (math.sin(p9 * v8) / v9)
        end,
        targets = function(p10, p11, p12, p13, p14, p15) -- targets | line: 57
            -- upvalues: p1 (copy)
            local MawSwim = p1.MawSwim
            local v15 = (MawSwim.W_AMP + MawSwim.W_AMP_V * p14) * (p15 and MawSwim.HOOK_W or 1) * p10.Lb * math.min(1, p10.segSum / (0.45 * p10.Lb))
            local t2 = {}

            for i = 0, p10.n do
                local v16 = p11 * p10.loc[i + 1]

                if i > 0 then
                    local v17 = (i / p10.n) ^ MawSwim.W_GROW
                    local v18 = p10.clk - MawSwim.W_LAG * i + MawSwim.GOLD * p10.k

                    v16 += p12 * (v15 * v17 * math.sin(v18)) + p13 * (0.6 * v15 * v17 * math.sin(v18 - 1.5708))
                end

                t2[i + 1] = v16
            end

            return t2
        end,
        step = function(p16, p17, p18, p19, p20, p21, p22, p23, p24, p25) -- step | line: 74
            -- upvalues: p1 (copy)
            local MawSwim = p1.MawSwim
            local HOOK_OM = p22 and MawSwim.HOOK_OM or MawSwim.W_OM + MawSwim.W_OM_V * p20

            p16.clk += HOOK_OM * p21

            local v22 = MawSwim.targets(p16, p17, p18, p19, p20, p22)

            if p16.x and not (MawSwim.RESET_DT < p21) and not ((v22[1] - p16.x[1]).Magnitude > MawSwim.JUMP * p16.Lb) then
                local v23 = if p25 then 1 else math.max(1, (math.ceil(p21 / MawSwim.DT_SUB - 1E-09)))
                local v26 = p21 / v23
                local HOOK_K = if p22 then MawSwim.HOOK_K else nil

                if not p22 or not HOOK_K then
                    HOOK_K = 1
                end

                local v27 = p16.x[1]
                local Rotation = p17.Rotation

                for i = 1, v23 do
                    local t3 = { v27:Lerp(v22[1], i / v23) }

                    for j = 1, p16.n do
                        local v30 = HOOK_K * (MawSwim.K_ROOT + (MawSwim.K_TIP - MawSwim.K_ROOT) * (j - 1) / math.max(p16.n - 1, 1))
                        local v31 = (v22[j + 1] - p16.x[j + 1]) * v30 - p16.v[j + 1] * MawSwim.C

                        if p20 > 0 then
                            v31 = v31 - (p23 + p19 * MawSwim.DOWN) * (MawSwim.FLOW * p16.Lb * p20 * (j / p16.n) ^ MawSwim.FLOW_POW) - p18 * (MawSwim.CONVERGE * p20 * (p16.x[j + 1] - p24):Dot(p18))
                        end

                        local v32 = p16.v[j + 1] + v31 * v26

                        t3[j + 1] = p16.x[j + 1] + v32 * v26
                    end

                    local v33 = CFrame.identity

                    for k = 1, p16.n do
                        local v34 = t3[k + 1] - t3[k]
                        local Magnitude = v34.Magnitude
                        local Unit = (v33 * (Rotation * (p16.loc[k + 1] - p16.loc[k]))).Unit
                        local v35 = Magnitude > 1E-09
                        local v36 = if v35 then v34 / Magnitude else nil
                        local v37 = if not v35 or not v36 then Unit else v36
                        local v38 = k == 1
                        local MAX_ROOT = if v38 then MawSwim.MAX_ROOT else nil
                        local v39 = if not v38 or not MAX_ROOT then MawSwim.MAX_BEND else MAX_ROOT
                        local v40 = MawSwim.angle(Unit, v37)
                        local v41 = if v39 < v40 then (v40 < 3.1 and MawSwim.slerp(Unit, v37, v39 / v40) or Unit).Unit else v37

                        t3[k + 1] = t3[k] + v41 * p16.seg[k]
                        v33 = MawSwim.turnTo(Unit, v41) * v33
                    end

                    for n = 1, p16.n do
                        p16.v[n + 1] = (t3[n + 1] - p16.x[n + 1]) / v26
                    end

                    p16.x = t3
                end

                return p16.x
            end

            local t4 = {}

            p16.x = {}
            p16.v = t4

            for i = 1, p16.n + 1 do
                local x, v = p16.x, p16.v

                x[i] = v22[i]
                v[i] = Vector3.new(0, 0, 0)
            end

            return p16.x
        end,
        register = function(p26) -- register | line: 126
            -- upvalues: p1 (copy), attr (copy)
            local _ = p1.MawSwim
            local v42 = p1.EelSwim.register(p26)

            if not v42 then
                return nil
            end

            local mesh = v42.mesh
            local AnatomyInverse = attr(p26, "AnatomyInverse")
            local v43 = p26:GetPivot() * AnatomyInverse:Inverse()

            v42.upM = mesh.CFrame:VectorToObjectSpace(v43.UpVector)

            local t5 = {}

            for match in string.gmatch(attr(p26, "TentTipRatio") or "", "[^,]+") do
                t5[#t5 + 1] = tonumber(match)
            end

            local t6 = {}

            for _, descendant in ipairs(mesh:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t6[descendant.Name] = descendant
                end
            end

            v42.tents = {}

            for i = 1, 64 do
                local t7 = {}

                for j = 1, 16 do
                    local v44 = t6["Tent_" .. i .. "_" .. j]

                    if not v44 then
                        break
                    end

                    t7[j] = v44
                end

                if #t7 < 2 then
                    break
                end

                local t8 = {}
                local v45 = CFrame.identity

                for v46, v47 in ipairs(t7) do
                    v45 *= v47.CFrame
                    t8[v46] = v45.Position
                end

                local v48 = #t7
                local Magnitude = (t8[v48] - t8[v48 - 1]).Magnitude

                t8[v48 + 1] = (v45 * CFrame.new(0, Magnitude * (t5[i] or 1), 0)).Position

                local t9 = {}
                local n1 = 0

                for k = 1, v48 do
                    t9[k] = (t8[k + 1] - t8[k]).Magnitude
                    n1 += t9[k]
                end

                v42.tents[i] = {
                    clk = 0,
                    k = i,
                    bones = t7,
                    parent = t7[1].Parent,
                    loc = t8,
                    seg = t9,
                    segSum = n1,
                    n = v48,
                    Lb = v42.ext
                }
            end

            return if #v42.tents ~= 0 then v42 else nil
        end,
        update = function(p27, p28) -- update | line: 170
            -- upvalues: p1 (copy), fightHooked (copy)
            local MawSwim = p1.MawSwim

            p1.EelSwim.update(p27, p28)

            local _CFrame = p27.mesh.CFrame
            local v49 = p27.cam or workspace.CurrentCamera
            local Magnitude = v49 and (v49.CFrame.Position - _CFrame.Position).Magnitude or 0
            local v50 = if Magnitude < MawSwim.LOD_D[1] then 1 elseif Magnitude < MawSwim.LOD_D[2] then 2 else 4

            p27.lodAcc = (p27.lodAcc or 0) + p28
            p27.lodN = (p27.lodN or 0) + 1

            if p27.lodN < v50 then
                return
            end

            local lodAcc = p27.lodAcc

            p27.lodAcc = 0
            p27.lodN = 0

            local v51 = fightHooked(p27.model)
            local Unit = _CFrame:VectorToWorldSpace(p27.noseM).Unit
            local Unit2 = _CFrame:VectorToWorldSpace(p27.upM).Unit
            local Unit3 = Unit2:Cross(Unit).Unit
            local CFramePosition = _CFrame.Position
            local v52 = p27.v / math.max(p27.ext, 0.001)

            for _, v53 in ipairs(p27.tents) do
                local v54 = v53.parent.TransformedWorldCFrame
                local v55 = MawSwim.step(v53, v54, Unit3, Unit2, v52, lodAcc, v51, Unit, CFramePosition, v50 > 1)

                for v56, v57 in ipairs(v53.bones) do
                    local v58 = v54 * v57.CFrame
                    local v59 = v55[v56 + 1] - v55[v56]
                    local identity = CFrame.identity

                    if v59.Magnitude > 1E-09 then
                        local v60 = MawSwim.turnTo(v58.YVector, v59)
                        local Rotation = v58.Rotation

                        identity = Rotation:Inverse() * v60 * Rotation
                    end

                    v57.Transform = identity
                    v54 = v58 * identity
                end
            end
        end
    }
end
