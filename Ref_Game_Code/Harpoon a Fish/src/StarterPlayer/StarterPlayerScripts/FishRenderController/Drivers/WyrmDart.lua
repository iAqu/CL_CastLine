-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.WyrmDart = {
        BODY = { "Spine_01", "Spine_02", "Spine_03", "Spine_04", "Tail_01", "Tail_02", "Tail_03" },
        ENV = { 0.05, -0.13, 0.28 },
        WAVELENGTH = 1,
        STRIDE = 0.8,
        MOVE_BL = 0.6,
        MIN_ENV = 0.35,
        DASH_AMP = 0.25,
        DASH_LO = 0.6,
        DASH_HI = 2.2,
        NECK = { "Neck_1", "Neck_2", "Head" },
        EL = {
            Neck_1 = 1.2341215074081695,
            Neck_2 = 1.3521273809209546,
            Head = 0.3320594675428855
        },
        EL_T = {
            Neck_1 = 0.5235987755982988,
            Neck_2 = 0.5235987755982988,
            Head = 0.08726646259971647
        },
        EXT = 0.9,
        SWAY = 0.12,
        SWAY_RATE = 0.6,
        LOOK = 0.5,
        FIN_DIR = {
            Fin_FL = Vector3.new(0.195, 0.085, -0.977),
            Fin_FR = Vector3.new(-0.194, 0.072, -0.978),
            Fin_RL = Vector3.new(0.211, 0.332, -0.919),
            Fin_RR = Vector3.new(-0.108, 0.814, -0.57)
        },
        FOLD = 0.8,
        FLARE = 0.7,
        SCULL = 0.18,
        SCULL_RATE = 0.7,
        HOOK_AMP = 1.6,
        HOOK_WHIP = 0.35,
        MIN_HZ = 0.3,
        HOOK_HZ = 3,
        BEND = 0.5,
        BEND_MAX = 0.9,
        BRAKE_REF = 1.5,
        BRAKE_TAU = 0.25,
        smooth01 = function(p3) -- smooth01 | line: 33
            local v1 = math.clamp(p3, 0, 1)

            return v1 * v1 * (3 - 2 * v1)
        end,
        finAxes = function(p4) -- finAxes | line: 38
            local Unit = p4.Unit
            local v2 = if Unit.X > 0 then 1 else -1
            local Unit2 = Vector3.new(v2 * 0.15, 1, -0.35).Unit
            local Unit3 = Vector3.new(v2 * 1, -0.35, -0.3).Unit

            return Unit:Cross(Unit2).Unit, math.acos((math.clamp(Unit:Dot(Unit2), -1, 1))), Unit:Cross(Unit3).Unit, (math.acos((math.clamp(Unit:Dot(Unit3), -1, 1))))
        end,
        register = function(p5) -- register | line: 45
            -- upvalues: p1 (copy), attr (copy)
            local WyrmDart = p1.WyrmDart
            local MeshPart = p5:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p5, "AnatomyInverse")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local CFrame = MeshPart.CFrame
            local v10 = p5:GetPivot() * AnatomyInverse:Inverse()
            local v11 = CFrame:VectorToObjectSpace(v10.RightVector)
            local v12 = CFrame:VectorToObjectSpace(v10.UpVector)
            local v13 = v12:Cross(v11)
            local Size = MeshPart.Size
            local v16 = math.abs(v11.X) * Size.X + math.abs(v11.Y) * Size.Y + math.abs(v11.Z) * Size.Z

            local function fromBlender(p6) -- line: 58
                -- upvalues: v11 (copy), v12 (copy), v13 (copy)
                return v13 * p6.X - v11 * p6.Y + v12 * p6.Z
            end

            local t2 = {}

            for _, descendant in ipairs(MeshPart:GetDescendants()) do
                if descendant:IsA("Bone") then
                    t2[descendant.Name] = descendant
                end
            end

            local function seg(p7) -- line: 65
                -- upvalues: CFrame (copy), v11 (copy), v12 (copy), v13 (copy), v16 (copy), t2 (copy)
                local v17 = t2[p7]

                if not v17 then
                    return nil
                end

                local v18 = CFrame:ToObjectSpace(v17.WorldCFrame)

                return {
                    bone = v17,
                    rest = v18,
                    x = 0.5 - v18.Position:Dot(v11) / v16,
                    up = v18:VectorToObjectSpace(v12),
                    left = v18:VectorToObjectSpace(v13),
                    right = v18:VectorToObjectSpace(-v13)
                }
            end

            local t3 = {}
            local t4 = {}
            local t5 = {}

            for _, v19 in ipairs(WyrmDart.BODY) do
                local v20 = seg(v19)

                if not v20 then
                    return nil
                end

                t3[#t3 + 1] = v20
            end

            for _, v21 in ipairs(WyrmDart.NECK) do
                local v22 = seg(v21)

                if not v22 then
                    return nil
                end

                v22.name = v21
                t4[#t4 + 1] = v22
            end

            for v23, v24 in pairs(WyrmDart.FIN_DIR) do
                local v25 = seg(v23)

                if v25 then
                    local v26, v27, v28, v29 = WyrmDart.finAxes(v24)

                    v25.fold = v25.rest:VectorToObjectSpace(v13 * v26.X - v11 * v26.Y + v12 * v26.Z)
                    v25.flare = v25.rest:VectorToObjectSpace(v13 * v28.X - v11 * v28.Y + v12 * v28.Z)
                    v25.fang = v27
                    v25.lang = v29
                    v25.side = v24.X > 0 and 1 or -1
                    t5[#t5 + 1] = v25
                end
            end

            return {
                t = 0,
                w = 0,
                v = 0,
                lastV = 0,
                brake = 0,
                model = p5,
                mesh = MeshPart,
                nose = v11,
                L = v16,
                chain = t3,
                neck = t4,
                fins = t5,
                phase = math.random() * 6.283185307179586
            }
        end,
        update = function(p8, p9) -- update | line: 100
            -- upvalues: p1 (copy), fightHooked (copy)
            local WyrmDart = p1.WyrmDart

            p1.SharkSwim.readTurn(p8, p9)

            local L = p8.L
            local v30 = p8.v / math.max(L, 0.001)
            local v31 = fightHooked(p8.model)

            p8.t += p9

            local t = p8.t
            local v32 = p9 > 1E-04 and (p8.v - p8.lastV) / p9 / math.max(L, 0.001) or 0

            p8.lastV = p8.v

            local v34 = math.clamp(-v32 / WyrmDart.BRAKE_REF, 0, 1)

            p8.brake = p8.brake + (v34 - p8.brake) * math.min(1, p9 / WyrmDart.BRAKE_TAU)

            local brake2, phase = p8.brake, p8.phase
            local v37 = p9 * 2 * 3.141592653589793
            local HOOK_HZ = if v31 then WyrmDart.HOOK_HZ else nil

            if not v31 or not HOOK_HZ then
                HOOK_HZ = math.max(v30 / WyrmDart.STRIDE, WyrmDart.MIN_HZ)
            end

            p8.phase = phase + v37 * HOOK_HZ

            local phase2 = p8.phase
            local v42 = math.clamp(WyrmDart.BEND * L * p8.w / math.max(p8.v, 5), -WyrmDart.BEND_MAX, WyrmDart.BEND_MAX)
            local v43 = WyrmDart.smooth01((v30 - WyrmDart.DASH_LO) / (WyrmDart.DASH_HI - WyrmDart.DASH_LO))
            local HOOK_AMP = if v31 then WyrmDart.HOOK_AMP else nil

            if not v31 or not HOOK_AMP then
                HOOK_AMP = math.clamp(v30 / WyrmDart.MOVE_BL, WyrmDart.MIN_ENV, 1) * (1 + WyrmDart.DASH_AMP * v43)
            end

            local ENV = WyrmDart.ENV

            local function h(p10) -- line: 120
                -- upvalues: WyrmDart (copy), phase2 (copy), HOOK_AMP (ref), ENV (copy)
                return HOOK_AMP * (ENV[1] + ENV[2] * p10 + ENV[3] * p10 * p10) / 2 * math.sin(phase2 - 6.283185307179586 * p10 / WyrmDart.WAVELENGTH)
            end

            local chain = p8.chain
            local v47 = -v42 / (#chain - 1)
            local n1 = 0

            for v48, v49 in ipairs(chain) do
                local v50 = chain[v48 + 1] and chain[v48 + 1].x or 1
                local v53 = HOOK_AMP * (ENV[1] + ENV[2] * v50 + ENV[3] * v50 * v50) / 2 * math.sin(phase2 - 6.283185307179586 * v50 / WyrmDart.WAVELENGTH)
                local x = v49.x
                local v57 = math.atan((v53 - HOOK_AMP * (ENV[1] + ENV[2] * x + ENV[3] * x * x) / 2 * math.sin(phase2 - 6.283185307179586 * x / WyrmDart.WAVELENGTH)) / (v50 - v49.x))
                local v58 = v57 - n1

                n1 = v57

                if v48 > 1 then
                    v58 += v47
                end

                local v59 = CFrame.fromAxisAngle(v49.up, v58)

                if v48 == 1 then
                    local new = CFrame.new
                    local right, x = v49.right, v49.x

                    v59 = new(right * (HOOK_AMP * (ENV[1] + ENV[2] * x + ENV[3] * x * x) / 2 * math.sin(phase2 - 6.283185307179586 * x / WyrmDart.WAVELENGTH) * L)) * v59
                end

                v49.bone.Transform = v59
            end

            local v62 = (if v31 then 0.3 else v43) * WyrmDart.EXT
            local v65 = WyrmDart.SWAY * (1 - v43) * math.sin(WyrmDart.SWAY_RATE * t)
            local n2 = 0

            for _, v66 in ipairs(p8.neck) do
                local v67 = (WyrmDart.EL[v66.name] - WyrmDart.EL_T[v66.name]) * v62
                local v68 = v65 / 2 + WyrmDart.LOOK * v42 / 2

                if v31 then
                    v68 += WyrmDart.HOOK_WHIP * math.sin(9 * t + (if v66.name == "Neck_1" then 0 else 0.8))
                end

                v66.bone.Transform = CFrame.fromAxisAngle(v66.left, v67 - n2) * CFrame.fromAxisAngle(v66.up, v68)
                n2 = v67
            end

            for _, v70 in ipairs(p8.fins) do
                local v71 = WyrmDart.FOLD * v43 * (1 - brake2)
                local v72 = WyrmDart.FLARE * (if v31 then 1 else brake2)
                local v75 = WyrmDart.SCULL * (1 - v43) * (1 - brake2) * math.sin(6.283185307179586 * WyrmDart.SCULL_RATE * t + (if v70.side > 0 then 0 else 3.141592653589793))

                if v31 then
                    v75 = math.sin(14 * t + (if v70.side > 0 then 0 else 3.141592653589793)) * 0.25
                end

                v70.bone.Transform = CFrame.fromAxisAngle(v70.fold, v70.fang * v71 + v75) * CFrame.fromAxisAngle(v70.flare, v70.lang * v72)
            end
        end
    }
end
