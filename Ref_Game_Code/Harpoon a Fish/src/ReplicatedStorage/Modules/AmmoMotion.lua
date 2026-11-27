-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TitanPath = require(script.Parent:WaitForChild("TitanPath"))
local t1 = {
    HEAD = Vector3.new(0, -14.3, -104.5),
    LENGTH = 209,
    BODY = {
        CHORD = 100
    },
    JET = {
        PERIOD = 2.4,
        RISE = 0.22,
        DECAY = 3.2,
        V_COAST = 0.35,
        V_SURGE = 1.3,
        SURGE = 1
    },
    TENT = {
        SEG_LAG = 0.045,
        RIPPLE = 5,
        RIPPLE_HZ = 0.9,
        RIPPLE_LAG = 0.9,
        GROUP_LAG = 0.8,
        FLARE = { 22, 14, 10 },
        SNAP = { -14, -10, -8 }
    },
    ROCK = {
        DEG = 7,
        PERIOD = 1.3,
        TAU = 0.9
    },
    NOD = 4
}
local JET, TENT, ROCK = t1.JET, t1.TENT, t1.ROCK

local function smooth(p1) -- line: 41
    local v1 = math.clamp(p1, 0, 1)

    return v1 * v1 * (3 - 2 * v1)
end

local v3 = math.exp(-(1 - JET.RISE) * JET.DECAY)

function t1.Squeeze(p2) -- line: 50
    -- upvalues: JET (copy), v3 (copy)
    local v4 = p2 % 1

    if v4 < JET.RISE then
        local v5 = 1 - v3
        local v7 = math.clamp(v4 / JET.RISE, 0, 1)

        return v3 + v5 * (v7 * v7 * (3 - 2 * v7))
    end

    return (math.exp(-(v4 - JET.RISE) * JET.DECAY))
end

local function rock(p3) -- line: 61
    -- upvalues: JET (copy), ROCK (copy)
    local v9 = p3 % JET.PERIOD
    local n1 = 0

    for i = 0, 2 do
        local v10 = v9 + i * JET.PERIOD

        n1 += ROCK.DEG * math.exp(-v10 / ROCK.TAU) * math.sin(6.283185307179586 * v10 / ROCK.PERIOD)
    end

    return n1
end

local t2 = {}
local t3 = {}
local n2 = 0

for i = 0, 239 do
    local V_COAST, V_SURGE = JET.V_COAST, JET.V_SURGE
    local v14 = i / 240 % 1
    local v15

    if v14 < JET.RISE then
        local v16 = 1 - v3
        local v18 = math.clamp(v14 / JET.RISE, 0, 1)

        v15 = v3 + v16 * (v18 * v18 * (3 - 2 * v18))
    else
        v15 = math.exp(-(v14 - JET.RISE) * JET.DECAY)
    end

    t3[i] = V_COAST + V_SURGE * v15
    n2 += t3[i] / 240
end

local v20 = JET.PERIOD / 240
local n3 = 0
local n4 = 0

for i = 0, 239 do
    t2[i + 1] = n3
    n4 += n3
    n3 += (t3[i] / n2 - 1) * v20
end

for i = 1, 240 do
    t2[i] -= n4 / 240
end

local function surgeAt(p4) -- line: 88
    -- upvalues: JET (copy), t2 (copy)
    local v21 = p4 % JET.PERIOD / JET.PERIOD * 240
    local v22 = math.floor(v21)
    local v23 = v21 - v22

    return t2[v22 % 240 + 1] * (1 - v23) + t2[(v22 + 1) % 240 + 1] * v23
end

function t1.Place(p5, p6, p7, _, p9, p10, p11) -- line: 97
    -- upvalues: t1 (copy), JET (copy), rock (copy), t2 (copy)
    local v24 = p9 * JET.SURGE
    local v25 = p10 % JET.PERIOD / JET.PERIOD * 240
    local v26 = math.floor(v25)
    local v27 = v25 - v26
    local v28 = p5 + p6 * (v24 * (t2[v26 % 240 + 1] * (1 - v27) + t2[(v26 + 1) % 240 + 1] * v27))

    return CFrame.lookAt(v28, v28 + p6, p7) * CFrame.new(-t1.HEAD) * CFrame.Angles(math.rad(-rock(p10)), 0, 0), {
        t = p10,
        kd = p11 or 0
    }
end

local function lineAt(p12, p13, p14) -- line: 106
    -- upvalues: TitanPath (copy), t1 (copy)
    local v31 = TitanPath.At(p12, p13, p14)
    local v32 = v31 - TitanPath.At(p12, p13 - t1.BODY.CHORD, p14)
    local Unit = v32.Magnitude > 0.001 and v32.Unit or Vector3.new(0, 1, 0)

    return v31, Unit, (-select(3, TitanPath.At(p12, p13 - t1.BODY.CHORD / 2, p14))):Cross(Unit)
end

function t1.Body(p15, p16, p17) -- line: 115
    -- upvalues: TitanPath (copy), t1 (copy), lineAt (copy)
    p17 = p17 or TitanPath.Direction(p15)

    local v34 = TitanPath.HeadS(p15, p16)
    local v36 = math.max(0, (v34 - TitanPath.HeadS(p15, p16 - 0.1)) / 0.1)
    local v37, v38, v39 = lineAt(p15, v34, p17)
    local v43 = math.deg((math.asin((math.clamp(select(2, lineAt(p15, v34 - 25, p17)):Cross(v38):Dot(v39), -1, 1))))) / 25

    return t1.Place(v37, v38, v39, v34, v36, p16, v43)
end

function t1.Rig(p18, p19) -- line: 128
    p19 = p19 or 1

    local PrimaryPart = p18.PrimaryPart
    local CFrame = PrimaryPart.CFrame
    local t4 = {}

    for _, descendant in ipairs(PrimaryPart:GetDescendants()) do
        if descendant:IsA("Bone") then
            local v45 = CFrame:ToObjectSpace(descendant.WorldCFrame)

            t4[descendant.Name] = {
                bone = descendant,
                pos = v45.Position,
                R = v45.Rotation
            }
        end
    end

    local t5 = {
        bones = {},
        j = t4,
        tent = {},
        head = t4.Head
    }
    local v46 = Vector3.new(4.2, -25.2, 32.7) * p19

    for v47, v48 in pairs(t4) do
        t5.bones[v47] = v48.bone

        local v49, v50 = v47:match("^T(%d+)_(%d+)$")

        if v49 then
            local v51 = v48.pos - v46
            local v52 = v51 - Vector3.new(0, 0, 1) * v51:Dot((Vector3.new(0, 0, 1)))
            local v53 = v52.Magnitude > 1E-04 and v52.Unit or Vector3.new(1, 0, 0)

            table.insert(t5.tent, {
                j = v48,
                g = tonumber(v49) - 1,
                seg = tonumber(v50),
                axis = (Vector3.new(0, 0, 1)):Cross(v53).Unit
            })
        end
    end

    return t5
end

local function turn(p20, p21) -- line: 155
    if p20 then
        p20.bone.Transform = p20.R:Inverse() * p21 * p20.R
    end
end

local function tentacle(p22, p23, p24) -- line: 160
    -- upvalues: JET (copy), TENT (copy), v3 (copy)
    local v54 = (p24 / JET.PERIOD - (p23 - 1) * TENT.SEG_LAG) % 1 % 1
    local v55

    if v54 < JET.RISE then
        local v56 = 1 - v3
        local v58 = math.clamp(v54 / JET.RISE, 0, 1)

        v55 = v3 + v56 * (v58 * v58 * (3 - 2 * v58))
    else
        v55 = math.exp(-(v54 - JET.RISE) * JET.DECAY)
    end

    return TENT.FLARE[p23] + (TENT.SNAP[p23] - TENT.FLARE[p23]) * v55 + TENT.RIPPLE * math.sin(6.283185307179586 * TENT.RIPPLE_HZ * p24 - (p23 - 1) * TENT.RIPPLE_LAG + p22 * TENT.GROUP_LAG)
end

function t1.Pose(p25, p26, p27) -- line: 169
    -- upvalues: t1 (copy), JET (copy), v3 (copy), tentacle (copy)
    local t = p26 and p26.t or p27

    for _, v62 in ipairs(p25.tent) do
        local j = v62.j
        local v64 = CFrame.fromAxisAngle(v62.axis, (math.rad((tentacle(v62.g, v62.seg, t)))))

        if j then
            j.bone.Transform = j.R:Inverse() * v64 * j.R
        end
    end

    local head = p25.head
    local fromAxisAngle = CFrame.fromAxisAngle
    local v65 = -t1.NOD
    local v66 = t / JET.PERIOD % 1
    local v67

    if v66 < JET.RISE then
        local v68 = 1 - v3
        local v70 = math.clamp(v66 / JET.RISE, 0, 1)

        v67 = v3 + v68 * (v70 * v70 * (3 - 2 * v70))
    else
        v67 = math.exp(-(v66 - JET.RISE) * JET.DECAY)
    end

    local v73 = fromAxisAngle(Vector3.new(1, 0, 0), (math.rad(v65 * v67)))

    if head then
        head.bone.Transform = head.R:Inverse() * v73 * head.R
    end
end

return t1
