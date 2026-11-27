-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TitanPath = require(script.Parent:WaitForChild("TitanPath"))
local t1 = {}
local v1 = (Vector3.new(0, 0, -1)):Cross((Vector3.new(0, 1, 0)))
local t2 = {
    1.6, 3.2
}

local function bite(p1, p2, p3) -- line: 33
    local v2 = p2 - p3.snap - p3.hold - p3.reopen

    if p1 < v2 then
        local v4 = math.clamp(p1 / v2, 0, 1)

        return v4 * v4 * (3 - v4 * 2), 0
    end

    local v5 = p1 - v2

    if v5 < p3.snap then
        local v6 = v5 / p3.snap
        local v7 = v6 * v6

        return 1 - v7, v7
    end

    local v8 = v5 - p3.snap

    if v8 < p3.hold then
        return 0, 1
    end

    local v10 = math.clamp((v8 - p3.hold) / p3.reopen, 0, 1)

    return 0, 1 - v10 * v10 * (3 - v10 * 2)
end

local function stroke(p4, p5, p6, p7) -- line: 53
    local ampR, v11

    if p6 then
        v11 = p4 - p5.lagR
        ampR = p5.ampR
    else
        v11 = p4
    end

    if not p6 or not ampR then
        ampR = 1
    end

    return p7 * ampR * (p5.bias + p5.amp * math.sin(v11)), p7 * ampR * (-p5.sweep * math.sin(v11 - p5.sweepLag)), p7 * ampR * (-p5.feather * math.cos(v11))
end

local function frame(p8, p9, p10) -- line: 61
    local v16 = p9 - p8 * p9:Dot(p8)

    if v16.Magnitude < 0.001 then
        v16 = p8:Cross(p10.RightVector)
    end

    return CFrame.fromMatrix(Vector3.new(0, 0, 0), p8, v16.Unit)
end

local function lay(p11, p12, p13) -- line: 69
    local function knot(p14) -- line: 70
        -- upvalues: p11 (copy)
        local v17, v18, v19 = p11(p14)

        return {
            pos = v17,
            back = -v18,
            up = v19
        }
    end

    local v20, v21, v22 = p11(p12 / 2)
    local v23 = CFrame.lookAt(v20, v20 + v21, v22)

    return v23, {
        v = p13,
        F = v23,
        knot = knot
    }
end

function t1.New(p15) -- line: 79
    -- upvalues: TitanPath (copy), v1 (copy), t2 (copy), bite (copy), stroke (copy), lay (copy)
    local KIND = p15.KIND
    local t3 = {
        HEAD = p15.HEAD,
        LENGTH = p15.LENGTH,
        KIND = KIND,
        BODY = {
            CHORD = p15.CHORD or 100
        }
    }

    local function h(p16, p17) -- line: 83
        -- upvalues: KIND (copy)
        return KIND.tail * 1 * math.exp(KIND.alpha * (p16 - 1)) * math.sin(p17 - 6.283185307179586 * p16 / KIND.lam)
    end

    function t3.Rig(p18, _) -- line: 90
        -- upvalues: v1 (copy)
        local PrimaryPart = p18.PrimaryPart
        local _CFrame = PrimaryPart.CFrame
        local t4 = {}

        for _, descendant in ipairs(PrimaryPart:GetDescendants()) do
            if descendant:IsA("Bone") then
                t4[descendant.Name] = descendant
            end
        end

        local t5 = {
            phase = 0,
            v = 0,
            s = 0,
            bones = t4,
            segs = {},
            fins = {},
            jaws = {},
            rng = Random.new(1)
        }
        local t6 = {}

        for i = 1, 99 do
            local v28 = t4[("Spine_%02d"):format(i)]

            if not v28 then
                break
            end

            t6[i] = {
                bone = v28,
                rest = _CFrame:ToObjectSpace(v28.WorldCFrame),
                loc = v28.CFrame
            }
        end

        local n1 = 0

        for v29, v30 in ipairs(t6) do
            local Magnitude = t6[v29 + 1] and (t6[v29 + 1].rest.Position - v30.rest.Position).Magnitude or t5.segs[v29 - 1].len
            local v31 = if v29 == 1 then Vector3.new(0, 0, -1) else -v30.rest.UpVector
            local v32 = CFrame.fromMatrix(Vector3.new(0, 0, 0), v31, if v29 == 1 then Vector3.new(0, 1, 0) else v1:Cross(v31))

            t5.segs[v29] = {
                bone = v30.bone,
                len = Magnitude,
                x = n1,
                off = v32:Inverse() * v30.rest.Rotation,
                loc = v30.loc
            }
            n1 += Magnitude
        end

        for _, v33 in ipairs(t5.segs) do
            v33.x /= n1
        end

        t5.L = n1

        for v34, v35 in pairs(t4) do
            local v36 = _CFrame:ToObjectSpace(v35.WorldCFrame)

            if v34:sub(1, 4) == "Fin_" then
                table.insert(t5.fins, {
                    bone = v35,
                    axis = v36:VectorToObjectSpace((Vector3.new(0, 0, -1))),
                    upAxis = v36:VectorToObjectSpace((Vector3.new(0, 1, 0))),
                    side = v34:sub(-1) == "L" and 1 or -1,
                    lag = v34:sub(5, 5) == "F" and 0 or 1.5
                })
            elseif v34:sub(1, 3) == "Jaw" then
                table.insert(t5.jaws, {
                    sign = -1,
                    open = 0,
                    bone = v35,
                    right = v36:VectorToObjectSpace(v1),
                    t = t5.rng:NextNumber() * 2,
                    period = 1.6 + t5.rng:NextNumber() * 1.6
                })
            end
        end

        return t5
    end

    function t3.Place(p20, p21, p22, _, p24, _, _, p27) -- line: 130
        -- upvalues: t3 (copy), lay (copy)
        return lay(function(p28) -- line: 131
            -- upvalues: p20 (copy), p21 (copy), p22 (copy)
            return p20 - p21 * p28, p21, p22
        end, p27 or t3.LENGTH, p24)
    end

    t3.Lay = lay

    function t3.Body(p29, p30, p31) -- line: 139
        -- upvalues: t3 (copy), TitanPath (copy), lay (copy)
        local v37 = p31 or TitanPath.Direction(p29)
        local v38 = TitanPath.HeadS(p29, p30)
        local v40 = math.max(0, (v38 - TitanPath.HeadS(p29, p30 - 0.1)) / 0.1)

        return lay(function(p32) -- line: 143
            -- upvalues: v37 (copy), p29 (copy), v38 (copy), TitanPath (copy)
            local v41, v42, v43 = TitanPath.At(p29, TitanPath.Back(p29, v38, p32), v37)

            return v41, v42, (-v43):Cross(v42)
        end, t3.LENGTH, v40)
    end

    function t3.Pose(p33, p34, p35, p36) -- line: 151
        -- upvalues: KIND (copy), t2 (copy), bite (copy), stroke (copy)
        p36 = p36 or p34.F

        local v45 = p33.t and math.clamp(p35 - p33.t, 0, 0.25) or 0

        p33.t = p35
        p33.v = p33.v + ((p34.v or 0) - p33.v) * math.min(1, v45 / 0.1)

        local L, segs = p33.L, p33.segs
        local v49 = #segs
        local hz = p34.hz

        if not hz then
            hz = math.clamp(p33.v / L / KIND.stride, 0.8, 5)
        end

        local v51 = p34.amp or 1

        p33.phase += v45 * 6.283185307179586 * hz

        local t9 = {}
        local t10 = {}

        for i = 1, v49 + 1 do
            local v52 = i <= v49
            local x = if v52 then segs[i].x else nil
            local v53 = if not v52 or not x then 1 else x
            local v54 = p34.knot(v53 * L)
            local v55 = v54.back:Cross(v54.up)
            local pos = v54.pos

            if v55.Magnitude > 0.001 then
                local Unit = v55.Unit
                local phase = p33.phase

                pos += Unit * (KIND.tail * 1 * math.exp(KIND.alpha * (v53 - 1)) * math.sin(phase - 6.283185307179586 * v53 / KIND.lam) * L * v51)
            end

            local up = v54.up

            t9[i] = pos
            t10[i] = up
        end

        local v61 = math.clamp((p33.v - 1) / 9, 0, 1)

        p33.s = p33.s + (v61 - p33.s) * math.min(1, v45 * 6)

        local s2 = p33.s
        local v64 = t9[1] - t9[2]
        local Unit = v64.Magnitude > 0.001 and v64.Unit or p36:VectorToWorldSpace((Vector3.new(0, 0, -1)))
        local v65 = CFrame.new(t9[1])
        local v66 = t10[1]
        local v67 = v66 - Unit * v66:Dot(Unit)

        if v67.Magnitude < 0.001 then
            v67 = Unit:Cross(p36.RightVector)
        end

        local v68 = v65 * (CFrame.fromMatrix(Vector3.new(0, 0, 0), Unit, v67.Unit) * segs[1].off)
        local bite2 = KIND.bite
        local v69 = p33.jaws[1]

        if bite2 and v69 then
            local v70 = bite2.lift * v69.open

            if v70 > 1E-06 and segs[2] then
                local locPosition = segs[2].loc.Position
                local v71 = CFrame.fromAxisAngle(segs[1].off:VectorToObjectSpace((Vector3.new(0, 0, 1))), v70)

                v68 *= CFrame.new(locPosition) * v71 * CFrame.new(-locPosition)
            end
        end

        local v72 = p36 * segs[1].loc

        segs[1].bone.Transform = CFrame.identity:Lerp(v72:Inverse() * v68, s2)

        for i = 2, v49 do
            local v73 = segs[i]
            local v74 = v68 * v73.loc
            local v75 = t9[i + 1] - v74.Position

            if v75.Magnitude > 0.001 then
                Unit = -v75.Unit
            end

            local v76 = CFrame.new(v74.Position)
            local v77 = t10[i]
            local v78 = v77 - Unit * v77:Dot(Unit)

            if v78.Magnitude < 0.001 then
                v78 = Unit:Cross(p36.RightVector)
            end

            v68 = v76 * (CFrame.fromMatrix(Vector3.new(0, 0, 0), Unit, v78.Unit) * v73.off)
            v73.bone.Transform = CFrame.identity:Lerp(v74:Inverse() * v68, s2)
        end

        local stroke2 = KIND.stroke

        if stroke2 then
            local v80 = math.min(hz * stroke2.rate, stroke2.maxHz)

            p33.finPhase = (p33.finPhase or p33.phase) + v45 * 6.283185307179586 * v80

            for _, v81 in ipairs(p33.fins) do
                local v82, v83, v84 = stroke(p33.finPhase, stroke2, v81.lag ~= 0, v81.side)

                v81.bone.Transform = CFrame.fromAxisAngle(v81.axis, v82) * CFrame.fromAxisAngle(v81.upAxis, v83) * CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v84)
            end
        else
            for _, v85 in ipairs(p33.fins) do
                v85.bone.Transform = CFrame.fromAxisAngle(v85.axis, v85.side * (KIND.finAmp or 0.12) * math.sin(p33.phase * (KIND.finRate or 0.5) + v85.lag))
            end
        end

        local every = bite2 and bite2.every or t2

        for _, v88 in ipairs(p33.jaws) do
            v88.t += v45

            if v88.t >= v88.period then
                v88.t -= v88.period
                v88.period = every[1] + p33.rng:NextNumber() * (every[2] - every[1])
            end

            if bite2 then
                local v89, v90 = bite(v88.t, v88.period, bite2)

                v88.open = v89
                v88.bone.Transform = CFrame.fromAxisAngle(v88.right, v88.sign * (bite2.gape * v89 - bite2.shut * v90))
            else
                local v91 = v88.period - 0.12
                local v93 = math.clamp(v88.t / v91, 0, 1)
                local v94 = v88.t < v91 and v93 * v93 * (3 - v93 * 2) or 1 - (v88.t - v91) / 0.12

                v88.bone.Transform = CFrame.fromAxisAngle(v88.right, v88.sign * 0.2 * v94)
            end
        end
    end

    return t3
end

return t1
