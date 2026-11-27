-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TitanPath = require(script.Parent:WaitForChild("TitanPath"))
local t1 = {
    HEAD = Vector3.new(0, -1.8, -104.53),
    LENGTH = 209,
    BODY = {
        CHORD = 100
    },
    SWIM = {
        STRIDE = 0.7,
        WAVELENGTH = 2.5,
        AMP = 1,
        FIN_SWAY = 0.3,
        SWAY_RATE = 7
    }
}
local t2 = {
    "Spine_01",
    "Spine_02",
    "Spine_03",
    "Spine_04",
    "Tail_01",
    "Tail_02",
    "Tail_03"
}
local SWIM = t1.SWIM

local function h(p1, p2, p3) -- line: 39
    -- upvalues: SWIM (copy)
    return p3 * (0.05 + -0.13 * p1 + 0.28 * p1 * p1) / 2 * math.sin(p2 - 6.283185307179586 * p1 / SWIM.WAVELENGTH)
end

function t1.Place(p4, p5, p6, _, p8, _, p10) -- line: 45
    -- upvalues: t1 (copy)
    return CFrame.lookAt(p4, p4 + p5, p6) * CFrame.new(-t1.HEAD), {
        v = p8,
        kd = p10 or 0
    }
end

local function lineAt(p11, p12, p13) -- line: 50
    -- upvalues: TitanPath (copy), t1 (copy)
    local v3 = TitanPath.At(p11, p12, p13)
    local v4 = v3 - TitanPath.At(p11, p12 - t1.BODY.CHORD, p13)
    local Unit = v4.Magnitude > 0.001 and v4.Unit or Vector3.new(0, 1, 0)

    return v3, Unit, (-select(3, TitanPath.At(p11, p12 - t1.BODY.CHORD / 2, p13))):Cross(Unit)
end

function t1.Body(p14, p15, p16) -- line: 59
    -- upvalues: TitanPath (copy), t1 (copy), lineAt (copy)
    p16 = p16 or TitanPath.Direction(p14)

    local v6 = TitanPath.HeadS(p14, p15)
    local v8 = math.max(0, (v6 - TitanPath.HeadS(p14, p15 - 0.1)) / 0.1)
    local v9, v10, v11 = lineAt(p14, v6, p16)
    local v15 = math.deg((math.asin((math.clamp(select(2, lineAt(p14, v6 - 25, p16)):Cross(v10):Dot(v11), -1, 1))))) / 25

    return t1.Place(v9, v10, v11, v6, v8, p15, v15)
end

function t1.Rig(p17, _) -- line: 71
    -- upvalues: t2 (copy)
    local PrimaryPart = p17.PrimaryPart
    local CFrame = PrimaryPart.CFrame
    local Z = PrimaryPart.Size.Z
    local t3 = {}

    for _, descendant in ipairs(PrimaryPart:GetDescendants()) do
        if descendant:IsA("Bone") then
            local v16 = CFrame:ToObjectSpace(descendant.WorldCFrame)

            t3[descendant.Name] = {
                bone = descendant,
                pos = v16.Position,
                R = v16.Rotation
            }
        end
    end

    local t4 = {
        phase = 0,
        bones = {},
        j = t3,
        L = Z,
        knots = {}
    }

    for v17, v18 in pairs(t3) do
        t4.bones[v17] = v18.bone
    end

    for v19, v20 in ipairs(t2) do
        t4.knots[v19] = (t3[v20].pos.Z + Z / 2) / Z
    end

    t4.knots[#t2 + 1] = 1

    return t4
end

local function turn(p19, p20, p21) -- line: 90
    if p19 then
        p19.bone.Transform = CFrame.new(p19.R:VectorToObjectSpace(p21 or Vector3.new(0, 0, 0))) * (p19.R:Inverse() * p20 * p19.R)
    end
end

function t1.Pose(p22, p23, p24) -- line: 96
    -- upvalues: t2 (copy), SWIM (copy)
    local v21 = p22.t and math.clamp(p24 - p22.t, 0, 0.25) or 0

    p22.t = p24

    local v23 = p23.v or 0
    local v24 = v23 / p22.L

    p22.phase = p22.phase + v21 * 6.283185307179586 * math.max(v24 / SWIM.STRIDE, 0.3)

    local v28 = math.clamp(v24 / 0.6, 0.35, 1) * SWIM.AMP
    local v30 = math.rad(p23.kd or 0) * v23
    local v32 = math.clamp(0.5 * p22.L * v30 / math.max(v23, 5), -0.9, 0.9)
    local knots = p22.knots
    local v33 = #t2 - 1
    local n1 = 0

    for v34, v35 in ipairs(t2) do
        local v36 = knots[v34]
        local v37 = knots[v34 + 1]
        local phase = p22.phase
        local v40 = v28 * (0.05 + -0.13 * v37 + 0.28 * v37 * v37) / 2 * math.sin(phase - 6.283185307179586 * v37 / SWIM.WAVELENGTH)
        local phase2 = p22.phase
        local v44 = math.atan((v40 - v28 * (0.05 + -0.13 * v36 + 0.28 * v36 * v36) / 2 * math.sin(phase2 - 6.283185307179586 * v36 / SWIM.WAVELENGTH)) / (v37 - v36))
        local v45 = v44 - n1

        n1 = v44

        if v34 > 1 then
            v45 += -v32 / v33
        end

        local v46

        if v34 == 1 then
            local phase = p22.phase

            v46 = Vector3.new(1, 0, 0) * (v28 * (0.05 + -0.13 * v36 + 0.28 * v36 * v36) / 2 * math.sin(phase - 6.283185307179586 * v36 / SWIM.WAVELENGTH) * p22.L) or nil
        end

        local v49 = p22.j[v35]
        local v50 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v45)

        if v49 then
            v49.bone.Transform = CFrame.new(v49.R:VectorToObjectSpace(v46 or Vector3.new(0, 0, 0))) * (v49.R:Inverse() * v50 * v49.R)
        end
    end

    local v52 = SWIM.FIN_SWAY * math.sin(SWIM.SWAY_RATE * p24)
    local Fin_L = p22.j.Fin_L
    local v53, v54 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v52)

    if Fin_L then
        Fin_L.bone.Transform = CFrame.new(Fin_L.R:VectorToObjectSpace(v54 or Vector3.new(0, 0, 0))) * (Fin_L.R:Inverse() * v53 * Fin_L.R)
    end

    local Fin_R = p22.j.Fin_R
    local v55, v56 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v52)

    if Fin_R then
        Fin_R.bone.Transform = CFrame.new(Fin_R.R:VectorToObjectSpace(v56 or Vector3.new(0, 0, 0))) * (Fin_R.R:Inverse() * v55 * Fin_R.R)
    end
end

return t1
