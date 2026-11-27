-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 3
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.FrogKick = {
        KICK = 0.22,
        GLIDE = 0.32,
        FORE_REACH = 0.8,
        PELVIS = 0.16,
        HEAVE = 0.1,
        SURGE = 0.06,
        KICK_STRIDE = 1.5,
        MIN_KICK = 0.3,
        MAX_KICK = 3,
        HOOK_HZ = 3,
        V_TAU = 0.15,
        CHAINS = {
            {
                kind = "Hind",
                n = 3
            },
            {
                kind = "Fore",
                n = 1
            }
        },
        TARGET = {
            Hind = {
                { 0.55, 1, 0 },
                { 0.18, 1, 0 },
                { 0.12, 1, 0 }
            },
            Fore = { { 0.45, 1, -0.2 } }
        },
        SEG_REACH = {
            Hind = { 0.3, 1, 1 },
            Fore = { 0.6 }
        },
        CROUCH_TARGET = {
            Hind = {
                { 0.75, -0.55, 0.05 },
                { -0.3, 1, 0.15 },
                { 0.5, -0.85, 0 }
            }
        },
        CROUCH_REACH = {
            Hind = { 0.4, 0.8, 0.8 }
        },
        KINDS = {},
        ALT = {
            STRIDE = 1.2,
            THIGH_FWD = 0,
            THIGH_BACK = 0,
            KNEE_FLEX = 0,
            KNEE_EXT = 0,
            SWEEP = 1.1344640137963142,
            DROP = 0.17453292519943295,
            FEATHER = 1.3962634015954636,
            YAW = 0.05,
            ROLL = 0.05,
            HEAVE = 0.03,
            PELVIS_YAW = 0.07,
            PELVIS_PITCH = 0.04,
            FORE_SWEEP = 0.18,
            FORE_LIFT = 0.08,
            OFF = {
                L = 0,
                R = 0.5
            }
        },
        LOON = {
            STRIDE = 1.2,
            SW_MID = 0.2617993877991494,
            SW_AMP = 0.5235987755982988,
            OUT_MID = 0.17453292519943295,
            OUT_AMP = 0.3490658503988659,
            OUT_LAG = 0.5,
            F_PEAK = 0.1,
            TRAIL_FOLD = 0.4363323129985824,
            TWIST = 1.5707963267948966,
            TOE_HYPER = 0.20943951023931956,
            TOE_TRAIL = 0.17453292519943295,
            SURGE = 0.012,
            NECK = 0.01,
            HEAVE = 0.03,
            HEAVE_LAG = 0,
            TURN_FULL = 0.6,
            TURN_TAU = 0.3,
            TURN_LEAD = 0.06,
            TURN_ROLL = 0.12
        },
        ROW = {
            STRIDE = 0.9,
            MIN_HZ = 0.3,
            MAX_HZ = 3,
            HOOK_HZ = 3,
            F_PEAK = 0.18,
            TILT = 1.5009831567151235,
            TIP_FOLD = 0.3490658503988659,
            SURGE = 0.04,
            HEAVE = 0.04,
            TURN_BEND = 0.15,
            RUDDER = 0.3,
            TURN_FULL = 0.6,
            TURN_TAU = 0.3,
            REACH = {
                PadA = {
                    { 1, -0.1, 0 },
                    { 1, 0.1, 0 }
                },
                PadB = {
                    { 1, 0.36, 0 },
                    { 1, 0.5, 0 }
                }
            },
            SWEEP = {
                PadA = {
                    { 0.85, 1, -0.35 },
                    { 0.75, 1, -0.4 }
                },
                PadB = {
                    { 0.6, 1, -0.3 },
                    { 0.5, 1, -0.35 }
                }
            },
            REACH_W = { 0.9, 0.9 },
            ABDOMEN = { "Spine_02", "Spine_03", "Spine_04", "Tail_01", "Tail_02", "Tail_03" }
        },
        ext = function(p3, p4) -- ext | line: 94
            -- upvalues: p1 (copy)
            p4 = p4 or p1.FrogKick

            local v2 = p3 % 1

            if v2 < p4.KICK then
                return (math.sin(1.5707963267948966 * v2 / p4.KICK))
            end

            if v2 < p4.KICK + p4.GLIDE then
                return 1
            end

            return math.cos(3.141592653589793 * ((v2 - p4.KICK - p4.GLIDE) / (1 - p4.KICK - p4.GLIDE))) * 0.5 + 0.5
        end,
        turn = function(p5, p6, p7) -- turn | line: 103
            local v5 = p5:Cross(p6)
            local Magnitude = v5.Magnitude

            if Magnitude < 1E-06 then
                return CFrame.new()
            end

            return CFrame.fromAxisAngle(v5 / Magnitude, math.atan2(Magnitude, (p5:Dot(p6))) * p7)
        end,
        solve = function(p8, p9, p10, p11, p12, p13, p14, p15) -- solve | line: 110
            -- upvalues: p1 (copy)
            local FrogKick = p1.FrogKick
            local t2 = {}
            local v8 = CFrame.new()

            for i = 1, #p10 do
                local v9 = p8:ToObjectSpace(p9[i].WorldCFrame)
                local Unit = v8:VectorToWorldSpace(p8:ToObjectSpace(p9[i + 1].WorldCFrame).Position - v9.Position).Unit
                local v10 = p10[i]
                local Unit2 = (p13 * (p12 * v10[1]) + p14 * v10[2] + p15 * v10[3]).Unit
                local v11 = FrogKick.turn(Unit, Unit2, p11[i])
                local v12 = v8 * v9.Rotation

                t2[i] = v12:Inverse() * v11 * v12
                v8 = v11 * v8
            end

            return t2
        end,
        register = function(p16) -- register | line: 126
            -- upvalues: p1 (copy), attr (copy)
            local FrogKick = p1.FrogKick
            local v14 = setmetatable(FrogKick.KINDS[attr(p16, "KickKind") or ""] or {}, {
                __index = FrogKick
            })
            local MeshPart = p16:FindFirstChildWhichIsA("MeshPart")
            local AnatomyInverse = attr(p16, "AnatomyInverse")

            if not MeshPart or typeof(AnatomyInverse) ~= "CFrame" then
                return nil
            end

            local CFrame = MeshPart.CFrame
            local v15 = p16:GetPivot() * AnatomyInverse:Inverse()
            local v16 = CFrame:VectorToObjectSpace(v15.RightVector)
            local v17 = CFrame:VectorToObjectSpace(v15.UpVector)
            local v18 = -v16
            local Unit = v18:Cross(v17).Unit
            local v19 = -Unit

            if attr(p16, "KickKind") == "Alt" then
                return FrogKick.altRegister(p16, MeshPart, CFrame, v16, v17, v18, Unit, v19)
            end

            if attr(p16, "KickKind") == "LoonStroke" then
                return FrogKick.loonRegister(p16, MeshPart, CFrame, v16, v17, v18, Unit, v19)
            end

            if attr(p16, "KickKind") == "RowStroke" then
                return FrogKick.rowRegister(p16, MeshPart, CFrame, v16, v17, v18, Unit, v19)
            end

            local t4 = {}

            for _, v20 in ipairs(v14.CHAINS) do
                for _, v21 in ipairs({ "L", "R" }) do
                    local v22 = if v21 == "L" then 1 else -1
                    local t5 = {}

                    for i = 1, v20.n + 1 do
                        t5[i] = MeshPart:FindFirstChild(v20.kind .. v21 .. "_" .. i, true)

                        if not t5[i] then
                            return nil
                        end
                    end

                    local v23 = FrogKick.solve(CFrame, t5, v14.TARGET[v20.kind], v14.SEG_REACH[v20.kind], v22, Unit, v18, v17)
                    local v24 = v14.CROUCH_TARGET[v20.kind] and FrogKick.solve(CFrame, t5, v14.CROUCH_TARGET[v20.kind], v14.CROUCH_REACH[v20.kind], v22, Unit, v18, v17)

                    for j = 1, v20.n do
                        t4[#t4 + 1] = {
                            bone = t5[j],
                            ext = v23[j],
                            crouch = v24 and v24[j],
                            fore = v20.kind == "Fore"
                        }
                    end
                end
            end

            local function body(p17) -- line: 158
                -- upvalues: MeshPart (copy), CFrame (copy), v16 (copy), v19 (copy)
                local v26 = MeshPart:FindFirstChild(p17, true)

                if not v26 then
                    return nil
                end

                local v27 = CFrame:ToObjectSpace(v26.WorldCFrame)

                return {
                    bone = v26,
                    right = v27:VectorToObjectSpace(v19),
                    nose = v27:VectorToObjectSpace(v16)
                }
            end

            local Size = MeshPart.Size
            local v30 = math.abs(v16.X) * Size.X + math.abs(v16.Y) * Size.Y + math.abs(v16.Z) * Size.Z

            return {
                v = 0,
                P = v14,
                model = p16,
                mesh = MeshPart,
                legs = t4,
                root = body("Spine_01"),
                pelvis = body("Spine_04"),
                ext = v30,
                phase = math.random()
            }
        end,
        update = function(p18, p19) -- update | line: 168
            -- upvalues: p1 (copy), fightHooked (copy)
            local v31 = p18.P or p1.FrogKick

            if p18.alt then
                return p1.FrogKick.altUpdate(p18, p19)
            end

            if p18.loon then
                return p1.FrogKick.loonUpdate(p18, p19)
            end

            if p18.row then
                return p1.FrogKick.rowUpdate(p18, p19)
            end

            local _CFrame = p18.mesh.CFrame

            if p18.lastPos and p19 > 1E-04 then
                local v32 = (_CFrame.Position - p18.lastPos).Magnitude / p19

                if v32 < 2000 then
                    p18.v = p18.v + (v32 - p18.v) * math.min(1, p19 / v31.V_TAU)
                end
            end

            p18.lastPos = _CFrame.Position

            local v35 = fightHooked(p18.model)
            local HOOK_HZ = if v35 then v31.HOOK_HZ else nil

            if not v35 or not HOOK_HZ then
                HOOK_HZ = math.clamp(p18.v / math.max(p18.ext, 0.001) / v31.KICK_STRIDE, v31.MIN_KICK, v31.MAX_KICK)
            end

            p18.phase = (p18.phase + p19 * HOOK_HZ) % 1

            local v37 = p1.FrogKick.ext(p18.phase, v31)
            local v38 = CFrame.new()

            for _, v39 in ipairs(p18.legs) do
                if v39.crouch then
                    v39.bone.Transform = v39.crouch:Lerp(v39.ext, v37)
                else
                    v39.bone.Transform = v38:Lerp(v39.ext, v39.fore and v31.FORE_REACH * v37 or v37)
                end
            end

            if p18.pelvis then
                p18.pelvis.bone.Transform = CFrame.fromAxisAngle(p18.pelvis.right, v31.PELVIS * (1 - v37))
            end

            if p18.root then
                local root = p18.root

                root.bone.Transform = CFrame.new(root.nose * (v31.SURGE * (2 * v37 - 1) * p18.ext)) * CFrame.fromAxisAngle(root.right, v31.HEAVE * (v37 - 0.5))
            end
        end,
        altRegister = function(p20, p21, p22, p23, p24, p25, p26, p27) -- altRegister | line: 200
            -- upvalues: p1 (copy)
            local FrogKick = p1.FrogKick

            local function pos(p28) -- line: 202
                -- upvalues: p22 (copy)
                return p22:PointToObjectSpace(p28.WorldPosition)
            end

            local function rot(p29) -- line: 203
                -- upvalues: p22 (copy)
                return p22:ToObjectSpace(p29.WorldCFrame).Rotation
            end

            local t7 = {}

            for _, v40 in ipairs({ "L", "R" }) do
                local t8 = {}

                for i = 1, 4 do
                    t8[i] = p21:FindFirstChild("Hind" .. v40 .. "_" .. i, true)

                    if not t8[i] then
                        return nil
                    end
                end

                local t9 = {
                    side = v40,
                    sgn = v40 == "L" and 1 or -1,
                    b = t8,
                    hip = p22:PointToObjectSpace(t8[1].WorldPosition),
                    knee = p22:PointToObjectSpace(t8[2].WorldPosition),
                    ankle = p22:PointToObjectSpace(t8[3].WorldPosition),
                    mid = p22:PointToObjectSpace(t8[4].WorldPosition),
                    M = {
                        p22:ToObjectSpace(t8[1].WorldCFrame).Rotation,
                        p22:ToObjectSpace(t8[2].WorldCFrame).Rotation,
                        p22:ToObjectSpace(t8[3].WorldCFrame).Rotation
                    }
                }
                local v41 = t9.knee - t9.hip
                local v42 = t9.ankle - t9.knee
                local Unit = v41:Cross(v42).Unit

                t9.foldSign = (CFrame.fromAxisAngle(Unit, 0.2) * v42 - v42):Dot(p25) < 0 and 1 or -1
                t7[#t7 + 1] = t9
            end

            local function body(p30) -- line: 218
                -- upvalues: p21 (copy), p22 (copy), p23 (copy), p24 (copy), p27 (copy)
                local v43 = p21:FindFirstChild(p30, true)

                if not v43 then
                    return nil
                end

                local Rotation = p22:ToObjectSpace(v43.WorldCFrame).Rotation

                return {
                    bone = v43,
                    up = Rotation:VectorToObjectSpace(p24),
                    nose = Rotation:VectorToObjectSpace(p23),
                    right = Rotation:VectorToObjectSpace(p27)
                }
            end

            local t10 = {}

            for _, v44 in ipairs({ "L", "R" }) do
                local v45 = body("Fore" .. v44 .. "_1")

                if v45 then
                    v45.sgn = v44 == "L" and 1 or -1
                    v45.other = v44 == "L" and "R" or "L"
                    t10[#t10 + 1] = v45
                end
            end

            local Size = p21.Size
            local v48 = math.abs(p23.X) * Size.X + math.abs(p23.Y) * Size.Y + math.abs(p23.Z) * Size.Z

            return {
                v = 0,
                P = FrogKick,
                alt = {
                    legs = t7,
                    up = p24,
                    back = p25,
                    left = p26,
                    root = body("Spine_01"),
                    pelvis = body("Spine_04"),
                    fore = t10
                },
                model = p20,
                mesh = p21,
                ext = v48,
                phase = math.random()
            }
        end,
        altUpdate = function(p31, p32) -- altUpdate | line: 234
            -- upvalues: p1 (copy), fightHooked (copy)
            local FrogKick = p1.FrogKick
            local ALT = FrogKick.ALT
            local alt = p31.alt
            local _CFrame = p31.mesh.CFrame

            if p31.lastPos and p32 > 1E-04 then
                local v49 = (_CFrame.Position - p31.lastPos).Magnitude / p32

                if v49 < 2000 then
                    p31.v = p31.v + (v49 - p31.v) * math.min(1, p32 / FrogKick.V_TAU)
                end
            end

            p31.lastPos = _CFrame.Position

            local v52 = fightHooked(p31.model)
            local HOOK_HZ = if v52 then FrogKick.HOOK_HZ else nil

            if not v52 or not HOOK_HZ then
                HOOK_HZ = math.clamp(p31.v / math.max(p31.ext, 0.001) / ALT.STRIDE, FrogKick.MIN_KICK, FrogKick.MAX_KICK)
            end

            p31.phase = (p31.phase + p32 * HOOK_HZ) % 1

            local phase = p31.phase
            local up = alt.up

            for _, v54 in ipairs(alt.legs) do
                local v55 = (phase + ALT.OFF[v54.side]) % 1
                local v57 = 0.5 - math.cos(6.283185307179586 * v55) * 0.5
                local v59 = ((math.cos(6.283185307179586 * (v55 - 0.75)) + 1) / 2) ^ 3
                local v60 = v54.knee - v54.hip
                local v61 = v54.ankle - v54.knee
                local v62 = v54.mid - v54.ankle
                local v63 = ALT.THIGH_FWD + (ALT.THIGH_BACK - ALT.THIGH_FWD) * v57
                local v64 = CFrame.fromAxisAngle(up, -v54.sgn * v63)
                local Unit = v60:Cross(v61).Unit
                local v65 = ALT.KNEE_FLEX + (ALT.KNEE_EXT - ALT.KNEE_FLEX) * v57
                local v66 = CFrame.fromAxisAngle(v64 * Unit, v65 * v54.foldSign) * v64
                local Unit2 = (v66 * v62).Unit
                local v67 = CFrame.fromAxisAngle(up, -v54.sgn * ALT.SWEEP * (1 - v57))
                local v68 = v67 * Unit2
                local Unit3 = v68:Cross(up).Unit
                local v69 = CFrame.fromAxisAngle(Unit3, v54.sgn * ALT.DROP * (1 - v57))
                local v70 = v69 * v68
                local v71 = CFrame.fromAxisAngle(v70, v54.sgn * ALT.FEATHER * v59) * v69 * v67 * v66
                local t11 = {
                    CFrame.identity,
                    v64,
                    v66,
                    v71
                }

                for i = 1, 3 do
                    v54.b[i].Transform = v54.M[i]:Inverse() * t11[i]:Inverse() * t11[i + 1] * v54.M[i]
                end
            end

            local v72 = 6.283185307179586 * phase

            if alt.root then
                local root = alt.root

                root.bone.Transform = CFrame.fromAxisAngle(root.up, -ALT.YAW * math.sin(v72)) * CFrame.fromAxisAngle(root.nose, ALT.ROLL * math.sin(v72 + 0.6)) * CFrame.fromAxisAngle(root.right, ALT.HEAVE * math.sin(2 * v72 + 0.4))
            end

            if alt.pelvis then
                local pelvis = alt.pelvis

                pelvis.bone.Transform = CFrame.fromAxisAngle(pelvis.up, -ALT.PELVIS_YAW * math.sin(v72 + 0.5)) * CFrame.fromAxisAngle(pelvis.right, ALT.PELVIS_PITCH * math.sin(2 * v72 + 0.9))
            end

            for _, v81 in ipairs(alt.fore) do
                local v82 = 6.283185307179586 * ((phase + ALT.OFF[v81.other]) % 1)

                v81.bone.Transform = CFrame.fromAxisAngle(v81.up * v81.sgn, ALT.FORE_SWEEP * math.sin(v82)) * CFrame.fromAxisAngle(v81.right, ALT.FORE_LIFT * math.sin(v82 - 0.9))
            end
        end,
        loonRegister = function(p33, p34, p35, p36, _, p38, p39, p40) -- loonRegister | line: 285
            -- upvalues: p1 (copy)
            local FrogKick = p1.FrogKick

            local function pos(p41) -- line: 287
                -- upvalues: p35 (copy)
                return p35:PointToObjectSpace(p41.WorldPosition)
            end

            local function rot(p42) -- line: 288
                -- upvalues: p35 (copy)
                return p35:ToObjectSpace(p42.WorldCFrame).Rotation
            end

            local t12 = {}

            for _, v85 in ipairs({ "L", "R" }) do
                local t13 = {}

                for i = 1, 4 do
                    t13[i] = p34:FindFirstChild("Hind" .. v85 .. "_" .. i, true)

                    if not t13[i] then
                        return nil
                    end
                end

                t12[#t12 + 1] = {
                    s = v85 == "L" and 1 or -1,
                    b = t13,
                    ankle = p35:PointToObjectSpace(t13[2].WorldPosition),
                    toe = p35:PointToObjectSpace(t13[3].WorldPosition),
                    mid = p35:PointToObjectSpace(t13[4].WorldPosition),
                    M = {
                        p35:ToObjectSpace(t13[1].WorldCFrame).Rotation,
                        p35:ToObjectSpace(t13[2].WorldCFrame).Rotation,
                        p35:ToObjectSpace(t13[3].WorldCFrame).Rotation
                    }
                }
            end

            local function body(p43) -- line: 298
                -- upvalues: p34 (copy), p35 (copy), p36 (copy), p40 (copy)
                local v87 = p34:FindFirstChild(p43, true)

                if not v87 then
                    return nil
                end

                local Rotation = p35:ToObjectSpace(v87.WorldCFrame).Rotation

                return {
                    bone = v87,
                    nose = Rotation:VectorToObjectSpace(p36),
                    right = Rotation:VectorToObjectSpace(p40)
                }
            end

            local Size = p34.Size
            local v90 = math.abs(p36.X) * Size.X + math.abs(p36.Y) * Size.Y + math.abs(p36.Z) * Size.Z

            return {
                v = 0,
                P = FrogKick,
                loon = {
                    turn = 0,
                    legs = t12,
                    back = p38,
                    left = p39,
                    nose = p36,
                    root = body("Spine_01"),
                    neck = body("Spine_03")
                },
                model = p33,
                mesh = p34,
                ext = v90,
                phase = math.random()
            }
        end,
        loonUpdate = function(p44, p45) -- loonUpdate | line: 309
            -- upvalues: p1 (copy), fightHooked (copy)
            local FrogKick = p1.FrogKick
            local LOON = FrogKick.LOON
            local loon = p44.loon
            local _CFrame = p44.mesh.CFrame

            if p44.lastPos and p45 > 1E-04 then
                local v91 = (_CFrame.Position - p44.lastPos).Magnitude / p45

                if v91 < 2000 then
                    p44.v = p44.v + (v91 - p44.v) * math.min(1, p45 / FrogKick.V_TAU)
                end
            end

            p44.lastPos = _CFrame.Position

            local v94 = _CFrame:VectorToWorldSpace(loon.nose)
            local v95 = Vector3.new(v94.X, 0, v94.Z)

            if v95.Magnitude > 1E-04 then
                local Unit = v95.Unit

                if p44.lastFlat and p45 > 1E-04 then
                    local v97 = math.atan2(p44.lastFlat:Cross(Unit).Y, (p44.lastFlat:Dot(Unit))) / p45

                    loon.turn = loon.turn + (math.clamp(v97 / LOON.TURN_FULL, -1, 1) - loon.turn) * math.min(1, p45 / LOON.TURN_TAU)
                end

                p44.lastFlat = Unit
            end

            local v101 = fightHooked(p44.model)
            local HOOK_HZ = if v101 then FrogKick.HOOK_HZ else nil

            if not v101 or not HOOK_HZ then
                HOOK_HZ = math.clamp(p44.v / math.max(p44.ext, 0.001) / LOON.STRIDE, FrogKick.MIN_KICK, FrogKick.MAX_KICK)
            end

            p44.phase = (p44.phase + p45 * HOOK_HZ) % 1

            local phase = p44.phase
            local turn, back, left = loon.turn, loon.back, loon.left

            for _, v103 in ipairs(loon.legs) do
                local s = v103.s
                local v105 = (phase + LOON.TURN_LEAD * math.max(0, -s * turn)) % 1
                local v106 = 6.283185307179586 * v105
                local v107 = LOON.SW_MID + LOON.SW_AMP * math.cos(v106)
                local v109 = LOON.OUT_MID + LOON.OUT_AMP * math.cos(v106 - LOON.OUT_LAG)
                local v110 = CFrame.fromAxisAngle(back, -s * v109) * CFrame.fromAxisAngle(left, -v107)
                local v112 = math.cos(6.283185307179586 * (v105 - LOON.F_PEAK)) * 0.5 + 0.5
                local v113 = v112 * v112 * (3 - v112 * 2)
                local v114 = left * s
                local v115 = CFrame.fromAxisAngle(v110 * v114, s * LOON.TRAIL_FOLD * (1 - v113)) * v110
                local Unit = (v115 * (v103.toe - v103.ankle)).Unit
                local v116 = CFrame.fromAxisAngle(Unit, s * LOON.TWIST * v113) * v115
                local Unit2 = (v116 * (v103.mid - v103.toe)):Cross(v116 * v114).Unit
                local v117 = CFrame.fromAxisAngle(Unit2, LOON.TOE_HYPER * v113 - LOON.TOE_TRAIL * (1 - v113)) * v116
                local t15 = {
                    CFrame.identity,
                    v110,
                    v116,
                    v117
                }

                for i = 1, 3 do
                    v103.b[i].Transform = v103.M[i]:Inverse() * t15[i]:Inverse() * t15[i + 1] * v103.M[i]
                end
            end

            local v118 = 6.283185307179586 * phase

            if loon.root then
                local root = loon.root

                root.bone.Transform = CFrame.new(root.nose * (-(LOON.SURGE + LOON.NECK) * math.cos(v118) * p44.ext)) * CFrame.fromAxisAngle(root.right, LOON.HEAVE * math.sin(v118 + LOON.HEAVE_LAG)) * CFrame.fromAxisAngle(root.nose, LOON.TURN_ROLL * turn)
            end

            if loon.neck then
                loon.neck.bone.Transform = CFrame.new(-loon.neck.nose * (-LOON.NECK * math.cos(v118) * p44.ext))
            end
        end,
        rowRegister = function(p46, p47, p48, p49, p50, p51, p52, p53) -- rowRegister | line: 365
            -- upvalues: p1 (copy)
            local FrogKick = p1.FrogKick
            local ROW = FrogKick.ROW
            local t16 = {}

            for _, v121 in ipairs({ "PadA", "PadB" }) do
                for _, v122 in ipairs({ "L", "R" }) do
                    local v123 = if v122 == "L" then 1 else -1
                    local t17 = {}

                    for i = 1, 3 do
                        t17[i] = p47:FindFirstChild(v121 .. v122 .. "_" .. i, true)

                        if not t17[i] then
                            return nil
                        end
                    end

                    local v124 = FrogKick.solve(p48, t17, ROW.SWEEP[v121], ROW.REACH_W, v123, p52, p51, p50)
                    local v125 = FrogKick.solve(p48, t17, ROW.REACH[v121], ROW.REACH_W, v123, p52, p51, p50)
                    local v126 = p48:ToObjectSpace(t17[2].WorldCFrame)
                    local v127 = v126:VectorToObjectSpace((p48:PointToObjectSpace(t17[3].WorldPosition) - v126.Position).Unit)

                    t16[#t16 + 1] = {
                        bone = t17[1],
                        reach = v125[1],
                        sweep = v124[1]
                    }
                    t16[#t16 + 1] = {
                        bone = t17[2],
                        reach = v125[2],
                        sweep = v124[2],
                        s = v123,
                        up = v126:VectorToObjectSpace(p50),
                        axis = v127
                    }
                end
            end

            local function body(p54) -- line: 385
                -- upvalues: p47 (copy), p48 (copy), p49 (copy), p50 (copy), p53 (copy)
                local v128 = p47:FindFirstChild(p54, true)

                if not v128 then
                    return nil
                end

                local Rotation = p48:ToObjectSpace(v128.WorldCFrame).Rotation

                return {
                    bone = v128,
                    up = Rotation:VectorToObjectSpace(p50),
                    nose = Rotation:VectorToObjectSpace(p49),
                    right = Rotation:VectorToObjectSpace(p53)
                }
            end

            local t18 = {}

            for _, v129 in ipairs(ROW.ABDOMEN) do
                local v130 = body(v129)

                if v130 then
                    v130.rudder = v129 == "Tail_03"
                    t18[#t18 + 1] = v130
                end
            end

            local Size = p47.Size
            local v133 = math.abs(p49.X) * Size.X + math.abs(p49.Y) * Size.Y + math.abs(p49.Z) * Size.Z

            return {
                v = 0,
                P = FrogKick,
                row = {
                    turn = 0,
                    legs = t16,
                    root = body("Spine_01"),
                    abd = t18,
                    nose = p49
                },
                model = p46,
                mesh = p47,
                ext = v133,
                phase = math.random()
            }
        end,
        rowUpdate = function(p55, p56) -- rowUpdate | line: 401
            -- upvalues: p1 (copy), fightHooked (copy)
            local FrogKick = p1.FrogKick
            local ROW = FrogKick.ROW
            local row = p55.row
            local _CFrame = p55.mesh.CFrame

            if p55.lastPos and p56 > 1E-04 then
                local v134 = (_CFrame.Position - p55.lastPos).Magnitude / p56

                if v134 < 2000 then
                    p55.v = p55.v + (v134 - p55.v) * math.min(1, p56 / FrogKick.V_TAU)
                end
            end

            p55.lastPos = _CFrame.Position

            local v137 = _CFrame:VectorToWorldSpace(row.nose)
            local v138 = Vector3.new(v137.X, 0, v137.Z)

            if v138.Magnitude > 1E-04 then
                local Unit = v138.Unit

                if p55.lastFlat and p56 > 1E-04 then
                    local v140 = math.atan2(p55.lastFlat:Cross(Unit).Y, (p55.lastFlat:Dot(Unit))) / p56

                    row.turn = row.turn + (math.clamp(v140 / ROW.TURN_FULL, -1, 1) - row.turn) * math.min(1, p56 / ROW.TURN_TAU)
                end

                p55.lastFlat = Unit
            end

            local v144 = fightHooked(p55.model)
            local HOOK_HZ = if v144 then ROW.HOOK_HZ else nil

            if not v144 or not HOOK_HZ then
                HOOK_HZ = math.clamp(p55.v / math.max(p55.ext, 0.001) / ROW.STRIDE, ROW.MIN_HZ, ROW.MAX_HZ)
            end

            p55.phase = (p55.phase + p56 * HOOK_HZ) % 1

            local v146 = 6.283185307179586 * p55.phase
            local v147 = 0.5 - math.cos(v146) * 0.5
            local v149 = math.cos(v146 - 6.283185307179586 * ROW.F_PEAK) * 0.5 + 0.5
            local v150 = v149 * v149 * (3 - v149 * 2)

            for _, v151 in ipairs(row.legs) do
                local v152 = v151.reach:Lerp(v151.sweep, v147)

                if v151.axis then
                    v152 = v152 * CFrame.fromAxisAngle(v151.up, v151.s * ROW.TIP_FOLD * (1 - v150)) * CFrame.fromAxisAngle(v151.axis, v151.s * ROW.TILT * v150)
                end

                v151.bone.Transform = v152
            end

            if row.root then
                local root = row.root

                root.bone.Transform = CFrame.new(root.nose * (-ROW.SURGE * math.cos(v146) * p55.ext)) * CFrame.fromAxisAngle(root.right, ROW.HEAVE * math.sin(v146))
            end

            for _, v153 in ipairs(row.abd) do
                local v154 = ROW.TURN_BEND * row.turn / #ROW.ABDOMEN

                if v153.rudder then
                    v154 -= ROW.RUDDER * row.turn
                end

                v153.bone.Transform = CFrame.fromAxisAngle(v153.up, v154)
            end
        end
    }
end
