-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.CetaceanSwim = {
        X0 = 0.6,
        A_REST = 0.01,
        LAM = 1.2,
        FEATHER = 0.5,
        STRIDE = 0.8,
        FLIP_TURN = 0.3,
        BEND = 0.5,
        BEND_MAX = 0.6,
        MIN_HZ = 0.25,
        MOVE_BL = 0.4,
        MIN_ENV = 0.35,
        HOOK_A = 0.3,
        HOOK_HZ = 2.2,
        FLAP_LAG = 1,
        JAW_SHUT = 0.15,
        JAW_GAPE = -0.1,
        JAW_HZ = 0.2,
        JAW_HOOK = 6,
        BODY = { "Spine_01", "Spine_02", "Spine_03", "Spine_04", "Tail_01", "Tail_02", "Tail_03" },
        env = function(p3, p4, p5, p6) -- env | line: 63
            -- upvalues: p1 (copy)
            local CetaceanSwim = p1.CetaceanSwim
            local x0 = p6 and p6.x0 or CetaceanSwim.X0
            local v2 = math.clamp((p3 - x0) / (p5 - x0), 0, 1)

            if not (p6 and p6.p) then
                return CetaceanSwim.A_REST + (p4 - CetaceanSwim.A_REST) * v2 * v2
            end

            return CetaceanSwim.A_REST + (p4 - CetaceanSwim.A_REST) * v2 ^ p6.p
        end,
        h = function(p7, p8, p9, p10, p11) -- h | line: 72
            -- upvalues: p1 (copy)
            local CetaceanSwim = p1.CetaceanSwim
            local lam = p11 and p11.lam or CetaceanSwim.LAM

            return CetaceanSwim.env(p7, p9, p10, p11) / 2 * math.sin(p8 - 6.283185307179586 * p7 / lam)
        end,
        flukePitch = function(p12, p13, p14, p15) -- flukePitch | line: 77
            -- upvalues: p1 (copy)
            local CetaceanSwim = p1.CetaceanSwim
            local lam = if p15 then p15.lam or CetaceanSwim.LAM else CetaceanSwim.LAM
            local feather = if p15 then p15.feather or CetaceanSwim.FEATHER else CetaceanSwim.FEATHER
            local v7 = CetaceanSwim.env(p14, p13, p14, p15) / 2 * math.cos(p12 - 6.283185307179586 * p14 / lam) * 2 * 3.141592653589793 / CetaceanSwim.STRIDE

            return -feather * math.atan(v7)
        end,
        jaw = function(p16) -- jaw | line: 84
            -- upvalues: p1 (copy)
            local CetaceanSwim = p1.CetaceanSwim
            local v9 = math.sin(6.283185307179586 * CetaceanSwim.JAW_HZ * p16) * 0.5 + 0.5

            return CetaceanSwim.JAW_GAPE + (CetaceanSwim.JAW_SHUT - CetaceanSwim.JAW_GAPE) * v9 * v9 * (3 - v9 * 2)
        end,
        amplitude = function(p17, p18) -- amplitude | line: 89
            if p17 ~= "beluga" then
                return 0.2
            end

            return (math.clamp(0.26 - 0.045 * p18, 0.15, 0.24))
        end,
        register = function(p19) -- register | line: 95
            -- upvalues: p1 (copy), attr (copy)
            local CetaceanSwim = p1.CetaceanSwim
            local MeshPart = p19:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p19, "AnatomyInverse")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local CFrame = MeshPart.CFrame
            local v11 = p19:GetPivot() * AnatomyInverse:Inverse()
            local v12 = CFrame:VectorToObjectSpace(v11.RightVector)
            local v13 = CFrame:VectorToObjectSpace(v11.UpVector)
            local v14 = v13:Cross(v12)
            local Size = MeshPart.Size
            local v17 = math.abs(v12.X) * Size.X + math.abs(v12.Y) * Size.Y + math.abs(v12.Z) * Size.Z

            local function seg(p20) -- line: 107
                -- upvalues: CFrame (copy), v12 (copy), v13 (copy), v14 (copy), v17 (copy)
                local v18 = CFrame:ToObjectSpace(p20.WorldCFrame)

                return {
                    bone = p20,
                    x = 0.5 - v18.Position:Dot(v12) / v17,
                    pitch = v18:VectorToObjectSpace(v14),
                    yaw = v18:VectorToObjectSpace(v13),
                    roll = v18:VectorToObjectSpace(v12),
                    lift = v18:VectorToObjectSpace(v13),
                    down = v18:VectorToObjectSpace(-v13),
                    side = v18:VectorToObjectSpace(v14)
                }
            end

            local t2 = {}

            for _, v19 in ipairs(CetaceanSwim.BODY) do
                local v20 = MeshPart:FindFirstChild(v19, true)

                if not v20 then
                    return nil
                end

                t2[#t2 + 1] = seg(v20)
            end

            local v21 = MeshPart:FindFirstChild("Head", true)
            local v22 = MeshPart:FindFirstChild("Fin_L", true)
            local v23 = MeshPart:FindFirstChild("Fin_R", true)
            local v24 = MeshPart:FindFirstChild("Jaw", true)

            local function num(p21) -- line: 126
                -- upvalues: p19 (copy), attr (copy)
                local v25 = attr(p19, p21)

                if typeof(v25) ~= "number" or not v25 then
                    v25 = nil
                end

                return v25
            end

            local CetaceanX0 = attr(p19, "CetaceanX0")

            if typeof(CetaceanX0) ~= "number" or not CetaceanX0 then
                CetaceanX0 = nil
            end

            local CetaceanP = attr(p19, "CetaceanP")

            if typeof(CetaceanP) ~= "number" or not CetaceanP then
                CetaceanP = nil
            end

            local CetaceanLam = attr(p19, "CetaceanLam")

            if typeof(CetaceanLam) ~= "number" or not CetaceanLam then
                CetaceanLam = nil
            end

            local CetaceanFeather = attr(p19, "CetaceanFeather")

            if typeof(CetaceanFeather) ~= "number" or not CetaceanFeather then
                CetaceanFeather = nil
            end

            local t3, v26

            if CetaceanX0 or CetaceanP or CetaceanLam or CetaceanFeather then
                local t4 = {
                    x0 = CetaceanX0,
                    p = CetaceanP,
                    lam = CetaceanLam,
                    feather = CetaceanFeather
                }

                if t4 then
                    t3 = t4
                    v26 = true
                else
                    v26 = false
                end
            else
                v26 = false
            end

            if not v26 then
                t3 = nil
            end

            return {
                w = 0,
                v = 0,
                model = p19,
                mesh = MeshPart,
                chain = t2,
                L = v17,
                nose = v12,
                head = v21 and seg(v21),
                fins = {
                    v22 and seg(v22),
                    v23 and seg(v23)
                },
                jaw = v24 and seg(v24),
                jawClock = math.random() * 5,
                kind = attr(p19, "Cetacean"),
                neck = attr(p19, "NeckLook") or 0,
                phase = math.random() * 6.283185307179586,
                shape = t3,
                lateral = attr(p19, "CetaceanPlane") == "Lateral",
                finSway = type(attr(p19, "FinSway")) == "number" and attr(p19, "FinSway") or nil
            }
        end,
        update = function(p22, p23) -- update | line: 141
            -- upvalues: p1 (copy), fightHooked (copy)
            local CetaceanSwim = p1.CetaceanSwim

            p1.SharkSwim.readTurn(p22, p23)

            local drive = p22.drive

            if drive then
                if drive.v then
                    p22.v = drive.v
                end

                if drive.w then
                    p22.w = drive.w
                end
            end

            local L, chain = p22.L, p22.chain
            local v29 = p22.v / math.max(L, 0.001)
            local v30 = fightHooked(p22.model)
            local v31, v32

            if v30 then
                v31 = CetaceanSwim.HOOK_A
                v32 = CetaceanSwim.HOOK_HZ
            else
                v31 = CetaceanSwim.amplitude(p22.kind, v29) * math.clamp(v29 / CetaceanSwim.MOVE_BL, CetaceanSwim.MIN_ENV, 1)
                v32 = math.max(v29 / CetaceanSwim.STRIDE, CetaceanSwim.MIN_HZ)

                if drive and drive.power then
                    v31 *= drive.power
                end
            end

            local v36, v37

            if drive and drive.arch then
                local v39 = math.clamp(drive.arch, -CetaceanSwim.BEND_MAX, CetaceanSwim.BEND_MAX)

                if v39 then
                    v36 = v39
                    v37 = true
                else
                    v37 = false
                end
            else
                v37 = false
            end

            if not v37 then
                v36 = 0
            end

            p22.phase += p23 * 2 * 3.141592653589793 * v32

            local phase = p22.phase
            local v43 = math.clamp(CetaceanSwim.BEND * L * p22.w / math.max(p22.v, 5), -CetaceanSwim.BEND_MAX, CetaceanSwim.BEND_MAX)
            local x = chain[#chain].x
            local x2 = chain[3].x
            local shape = p22.shape
            local n1 = 0

            for _, v44 in ipairs(chain) do
                if x2 <= v44.x then
                    n1 += 1
                end
            end

            local n2 = 0

            for v45, v46 in ipairs(chain) do
                local v47 = chain[v45 + 1] and chain[v45 + 1].x or 1
                local v48 = if v45 == #chain then CetaceanSwim.flukePitch(phase, v31, x, shape) else math.atan((CetaceanSwim.h(v47, phase, v31, x, shape) - CetaceanSwim.h(v46.x, phase, v31, x, shape)) / (v47 - v46.x))
                local v50 = CFrame.fromAxisAngle(p22.lateral and v46.down or v46.pitch, v48 - n2)

                n2 = v48

                if x2 <= v46.x then
                    v50 *= CFrame.fromAxisAngle(v46.yaw, -v43 / n1)
                end

                if v36 ~= 0 and x2 <= v46.x then
                    v50 *= CFrame.fromAxisAngle(v46.pitch, v36 / n1)
                end

                if v45 == 1 then
                    v50 = CFrame.new((p22.lateral and v46.side or v46.lift) * (CetaceanSwim.h(v46.x, phase, v31, x, shape) * L)) * v50
                end

                v46.bone.Transform = v50
            end

            if p22.head then
                p22.head.bone.Transform = CFrame.fromAxisAngle(p22.head.yaw, p22.neck * v43)
            end

            for v51, v52 in pairs(p22.fins) do
                local v53 = -CetaceanSwim.FLIP_TURN * v43

                if p22.finSway then
                    v53 += (if v51 == 1 then -1 else 1) * p22.finSway * math.sin(phase - CetaceanSwim.FLAP_LAG)
                end

                v52.bone.Transform = CFrame.fromAxisAngle(v52.roll, v53)
            end

            if p22.jaw then
                p22.jawClock += p23 * (v30 and CetaceanSwim.JAW_HOOK or 1)
                p22.jaw.bone.Transform = CFrame.fromAxisAngle(p22.jaw.pitch, -CetaceanSwim.jaw(p22.jawClock))
            end
        end
    }
end
