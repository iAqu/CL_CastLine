-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TitanPath = require(script.Parent:WaitForChild("TitanPath"))
local TitanConfig = require(script.Parent:WaitForChild("TitanConfig"))
local KarkinosMotion = require(script.Parent:WaitForChild("KarkinosMotion"))
local AspidoMotion = require(script.Parent:WaitForChild("AspidoMotion"))
local UmiMotion = require(script.Parent:WaitForChild("UmiMotion"))
local AmmoMotion = require(script.Parent:WaitForChild("AmmoMotion"))
local SpinoMotion = require(script.Parent:WaitForChild("SpinoMotion"))
local DunkMotion = require(script.Parent:WaitForChild("DunkMotion"))
local PlessioMotion = require(script.Parent:WaitForChild("PlessioMotion"))
local BagoMotion = require(script.Parent:WaitForChild("BagoMotion"))
local t1 = {
    ROLL = 0,
    SHAPES = {
        Charybdis = {
            LENGTH = 891,
            FRONT = -25,
            SKIN = {
                { -25, 26 },
                { 0, 30 },
                { 50, 38 },
                { 100, 37 },
                { 150, 41 },
                { 200, 39 },
                { 250, 38 },
                { 300, 34 },
                { 350, 31 },
                { 400, 30 },
                { 450, 27 },
                { 500, 25 },
                { 550, 24 },
                { 600, 21 },
                { 650, 16 },
                { 700, 12 },
                { 750, 9 },
                { 800, 5 },
                { 850, 5 },
                { 891, 8 }
            },
            HIT = {
                { -25, 28 },
                { 0, 37 },
                { 50, 44 },
                { 100, 42 },
                { 150, 52 },
                { 200, 46 },
                { 250, 44 },
                { 300, 45 },
                { 350, 37 },
                { 400, 36 },
                { 450, 34 },
                { 500, 31 },
                { 550, 29 },
                { 600, 25 },
                { 650, 20 },
                { 700, 15 },
                { 750, 12 },
                { 800, 8 },
                { 850, 7 },
                { 891, 12 }
            }
        },
        TitanJormungandr = {
            LENGTH = 600,
            FRONT = 0,
            FLIP = true,
            SKIN = {
                { 0, 27 },
                { 25, 27.5 },
                { 75, 27.8 },
                { 125, 28 },
                { 175, 24.6 },
                { 225, 23.1 },
                { 275, 23.2 },
                { 325, 23.6 },
                { 375, 21.6 },
                { 425, 18.9 },
                { 475, 16.8 },
                { 525, 15 },
                { 600, 15 }
            },
            HIT = {
                { 0, 40 },
                { 25, 42 },
                { 75, 36.1 },
                { 125, 39.8 },
                { 175, 38.3 },
                { 225, 31.1 },
                { 275, 34.3 },
                { 325, 34 },
                { 375, 28.6 },
                { 425, 24.7 },
                { 475, 19.2 },
                { 525, 25.2 },
                { 575, 65.6 },
                { 600, 60 }
            }
        },
        Karkinos = {
            LENGTH = 90,
            FRONT = -50,
            RIGID = true,
            MOTION = KarkinosMotion,
            SKIN = {
                { -50, 10 },
                { 0, 12 },
                { 20, 15 },
                { 45, 16 },
                { 70, 14 },
                { 90, 9 }
            },
            HIT = {
                { -50, 50 },
                { 0, 75 },
                { 45, 90 },
                { 90, 75 }
            }
        },
        Aspidochelone = {
            LENGTH = 214,
            FRONT = 0,
            RIGID = true,
            SWIM = true,
            MOTION = AspidoMotion,
            SKIN = {
                { 0, 4 },
                { 17, 8 },
                { 34, 11 },
                { 51, 19 },
                { 68, 20 },
                { 85, 19 },
                { 102, 20 },
                { 118, 17 },
                { 135, 14 },
                { 152, 19 },
                { 169, 15 },
                { 186, 14 },
                { 203, 12 },
                { 214, 8 }
            },
            HIT = {
                { 0, 10 },
                { 20, 20 },
                { 40, 62 },
                { 80, 62 },
                { 105, 40 },
                { 125, 64 },
                { 150, 64 },
                { 170, 25 },
                { 214, 15 }
            }
        },
        Umibozu = {
            LENGTH = 180,
            FRONT = 0,
            SWIM = true,
            MOTION = UmiMotion,
            SKIN = {
                { 0, 7 },
                { 22, 10 },
                { 37, 13 },
                { 52, 15 },
                { 67, 11 },
                { 82, 7 },
                { 97, 8 },
                { 112, 15 },
                { 127, 22 },
                { 142, 27 },
                { 157, 25 },
                { 172, 19 },
                { 180, 15 }
            },
            HIT = {
                { 0, 10 },
                { 22, 22 },
                { 37, 23 },
                { 52, 23 },
                { 67, 26 },
                { 82, 31 },
                { 97, 32 },
                { 112, 28 },
                { 127, 30 },
                { 142, 35 },
                { 157, 32 },
                { 172, 26 },
                { 180, 20 }
            }
        },
        Ammonarch = {
            LENGTH = 209,
            FRONT = 0,
            RIGID = true,
            SWIM = true,
            MOTION = AmmoMotion,
            SKIN = {
                { 0, 20 },
                { 7, 26 },
                { 22, 32 },
                { 37, 34 },
                { 52, 37 },
                { 67, 35 },
                { 82, 33 },
                { 97, 33 },
                { 112, 27 },
                { 127, 26 },
                { 142, 22 },
                { 157, 23 },
                { 172, 23 },
                { 187, 22 },
                { 202, 21 },
                { 209, 15 }
            },
            HIT = {
                { 0, 30 },
                { 7, 37 },
                { 22, 48 },
                { 37, 57 },
                { 52, 61 },
                { 67, 55 },
                { 82, 52 },
                { 97, 48 },
                { 112, 48 },
                { 127, 46 },
                { 142, 43 },
                { 157, 45 },
                { 172, 49 },
                { 187, 42 },
                { 202, 38 },
                { 209, 30 }
            }
        },
        Spinosauron = {
            LENGTH = 211,
            FRONT = 0,
            SWIM = true,
            MOTION = SpinoMotion,
            SKIN = {
                { 0, 12 },
                { 7, 12 },
                { 22, 10 },
                { 37, 16 },
                { 52, 18 },
                { 67, 23 },
                { 82, 21 },
                { 97, 20 },
                { 112, 17 },
                { 127, 16 },
                { 142, 14 },
                { 157, 13 },
                { 172, 18 },
                { 187, 22 },
                { 202, 22 },
                { 211, 18 }
            },
            HIT = {
                { 0, 13 },
                { 7, 16 },
                { 22, 15 },
                { 37, 45 },
                { 52, 51 },
                { 67, 46 },
                { 82, 43 },
                { 97, 34 },
                { 112, 33 },
                { 127, 30 },
                { 142, 22 },
                { 157, 22 },
                { 172, 35 },
                { 187, 33 },
                { 202, 32 },
                { 211, 28 }
            }
        },
        Dunkeltorian = {
            LENGTH = 209,
            FRONT = 0,
            RIGID = true,
            SWIM = true,
            MOTION = DunkMotion,
            SKIN = {
                { 0, 17 },
                { 7, 17 },
                { 22, 21 },
                { 37, 20 },
                { 52, 25 },
                { 67, 26 },
                { 82, 30 },
                { 97, 28 },
                { 112, 22 },
                { 127, 18 },
                { 142, 16 },
                { 157, 12 },
                { 172, 14 },
                { 187, 18 },
                { 202, 28 },
                { 209, 28 }
            },
            HIT = {
                { 0, 25 },
                { 7, 25 },
                { 22, 28 },
                { 37, 30 },
                { 52, 33 },
                { 67, 36 },
                { 82, 49 },
                { 97, 63 },
                { 112, 31 },
                { 127, 29 },
                { 142, 27 },
                { 157, 23 },
                { 172, 26 },
                { 187, 31 },
                { 202, 44 },
                { 209, 44 }
            }
        },
        Plessiomother = {
            LENGTH = 210,
            FRONT = 0,
            SWIM = true,
            MOTION = PlessioMotion,
            SKIN = {
                { 0, 5 },
                { 7, 5 },
                { 22, 7 },
                { 37, 6 },
                { 52, 6 },
                { 67, 5 },
                { 82, 8 },
                { 97, 11 },
                { 112, 18 },
                { 127, 18 },
                { 142, 19 },
                { 157, 17 },
                { 172, 11 },
                { 187, 7 },
                { 202, 8 },
                { 210, 8 }
            },
            HIT = {
                { 0, 7 },
                { 7, 7 },
                { 22, 9 },
                { 37, 9 },
                { 52, 9 },
                { 67, 11 },
                { 82, 14 },
                { 97, 24 },
                { 112, 40 },
                { 127, 25 },
                { 142, 26 },
                { 157, 38 },
                { 172, 45 },
                { 187, 13 },
                { 202, 12 },
                { 210, 12 }
            }
        },
        Bagosaurus = {
            LENGTH = 209,
            FRONT = 0,
            SWIM = true,
            MOTION = BagoMotion,
            SKIN = {
                { 0, 13 },
                { 7, 13 },
                { 22, 12 },
                { 37, 12 },
                { 52, 16 },
                { 67, 20 },
                { 82, 20 },
                { 97, 20 },
                { 112, 16 },
                { 127, 15 },
                { 142, 16 },
                { 157, 14 },
                { 172, 17 },
                { 187, 23 },
                { 202, 28 },
                { 209, 28 }
            },
            HIT = {
                { 0, 21 },
                { 7, 21 },
                { 22, 19 },
                { 37, 21 },
                { 52, 38 },
                { 67, 39 },
                { 82, 33 },
                { 97, 30 },
                { 112, 27 },
                { 127, 28 },
                { 142, 38 },
                { 157, 24 },
                { 172, 29 },
                { 187, 35 },
                { 202, 42 },
                { 209, 42 }
            }
        }
    }
}

local function shapeOf(p1) -- line: 123
    -- upvalues: TitanConfig (copy), t1 (copy)
    local v1 = TitanConfig.SPECIES[TitanConfig.RiseSpecies(p1)]

    return t1.SHAPES[v1 and v1.shape or "Charybdis"] or t1.SHAPES.Charybdis
end

local function profile(p2, p3) -- line: 131
    if p3 <= p2[1][1] then
        return p2[1][2]
    end

    for i = 2, #p2 do
        local v2 = p2[i]

        if p3 <= v2[1] then
            local v3 = p2[i - 1]

            return v3[2] + (v2[2] - v3[2]) * (p3 - v3[1]) / (v2[1] - v3[1])
        end
    end

    return p2[#p2][2]
end

function t1.Skin(p4, p5) -- line: 142
    -- upvalues: TitanConfig (copy), t1 (copy), profile (copy)
    local v4 = TitanConfig.SPECIES[TitanConfig.RiseSpecies(p4)]

    return (profile((t1.SHAPES[v4 and v4.shape or "Charybdis"] or t1.SHAPES.Charybdis).SKIN, p5))
end

function t1.HitRadius(p6, p7) -- line: 143
    -- upvalues: TitanConfig (copy), t1 (copy), profile (copy)
    local v5 = TitanConfig.SPECIES[TitanConfig.RiseSpecies(p6)]

    return (profile((t1.SHAPES[v5 and v5.shape or "Charybdis"] or t1.SHAPES.Charybdis).HIT, p7))
end

function t1.Out(p8, p9) -- line: 147
    -- upvalues: TitanPath (copy)
    if TitanPath.HeadS(p8, p9) >= 0 then
        return p9 < TitanPath.SandAt(p8)
    end

    return false
end

function t1.Frame(p10, p11, p12, p13) -- line: 153
    -- upvalues: TitanPath (copy), TitanConfig (copy), t1 (copy)
    p13 = p13 or TitanPath.Direction(p10)

    local v7 = TitanConfig.SPECIES[TitanConfig.RiseSpecies(p10)]
    local v8 = t1.SHAPES[v7 and v7.shape or "Charybdis"] or t1.SHAPES.Charybdis

    if v8.RIGID then
        local MOTION = v8.MOTION
        local v9 = MOTION.Body(p10, p11, p13) * CFrame.new(MOTION.HEAD + Vector3.new(0, 0, p12))

        return v9, v9.LookVector
    end

    local v10, v11, v12 = TitanPath.At(p10, TitanPath.Back(p10, TitanPath.HeadS(p10, p11), p12), p13)
    local Unit = (v12 - v11 * v12:Dot(v11)).Unit
    local v13 = (p11 - (p10 - TitanPath.LEAD_IN)) * t1.ROLL * 6.283185307179586

    return CFrame.fromMatrix(v10, Unit, (-v11):Cross(Unit)) * CFrame.Angles(0, 0, v13), v11
end

function t1.Point(p14, p15, p16, p17, p18) -- line: 168
    -- upvalues: t1 (copy)
    local v14, v15 = t1.Frame(p14, p15, p16, p18)
    local v18 = v14:VectorToWorldSpace((Vector3.new(math.cos(p17), math.sin(p17), 0)))

    return v14.Position + v18 * t1.Skin(p14, p16), v18, v15
end

t1.SPEAR = {
    IN = 2,
    RAKE = 40
}

function t1.Spear(p19, p20, p21, p22, p23, p24, p25) -- line: 179
    -- upvalues: t1 (copy)
    local v19, v20, v21 = t1.Point(p19, p20, p21, p22, p25)
    local v22 = math.rad(t1.SPEAR.RAKE)
    local Unit = (-v20 * math.cos(v22) + v21 * math.sin(v22)).Unit
    local v23 = CFrame.fromMatrix(Vector3.new(0, 0, 0), v21:Cross(v20), Unit)
    local v24 = CFrame.new(v19 - v20 * t1.SPEAR.IN - v23:VectorToWorldSpace(p23)) * v23

    return v24, v24:PointToWorldSpace(p24), v20, v21
end

function t1.SpearEnds(p26) -- line: 189
    local v25 = p26:FindFirstChild("Tip", true)
    local v26 = p26:FindFirstChild("End", true)

    if not v25 or not v26 then
        return nil
    end

    local Pivot = p26:GetPivot()

    return Pivot:PointToObjectSpace(v25.WorldPosition), Pivot:PointToObjectSpace(v26.WorldPosition)
end

local function closest(p27, p28, p29, p30) -- line: 197
    local v27 = p27 - p29
    local v28 = p28:Dot(p28)
    local v29 = p30:Dot(p30)
    local v30 = p30:Dot(v27)
    local v31 = p28:Dot(v27)
    local v32 = p28:Dot(p30)
    local v33 = v28 * v29 - v32 * v32
    local v34 = v33 > 1E-09 and math.clamp((v32 * v30 - v31 * v29) / v33, 0, 1) or 0
    local v36 = (v32 * v34 + v30) / v29

    if v36 < 0 then
        v36 = 0
        v34 = math.clamp(-v31 / v28, 0, 1)
    elseif v36 > 1 then
        v36 = 1
        v34 = math.clamp((v32 - v31) / v28, 0, 1)
    end

    return v34, v36, (p27 + p28 * v34 - (p29 + p30 * v36)).Magnitude
end

function t1.Hit(p31, p32, p33, p34, p35) -- line: 215
    -- upvalues: TitanPath (copy), TitanConfig (copy), t1 (copy), profile (copy), closest (copy)
    if not t1.Out(p31, p32) then
        return nil
    end

    local v39 = TitanPath.Direction(p31)
    local v40 = TitanPath.HeadS(p31, p32)
    local v41 = p34 * p35
    local v42 = TitanConfig.SPECIES[TitanConfig.RiseSpecies(p31)]
    local v43 = t1.SHAPES[v42 and v42.shape or "Charybdis"] or t1.SHAPES.Charybdis
    local v44 = v43.RIGID and v43.MOTION.Body(p31, p32, v39)

    local function spine(p36) -- line: 224
        -- upvalues: p31 (copy), v39 (copy), v40 (copy), v43 (copy), v44 (copy), TitanPath (copy)
        if v44 then
            return v44:PointToWorldSpace(v43.MOTION.HEAD + Vector3.new(0, 0, p36))
        end

        return (TitanPath.At(p31, TitanPath.Back(p31, v40, p36), v39))
    end

    local FRONT = v43.FRONT
    local v46 = if v44 then nil else nil
    local v45 = if v44 then v44:PointToWorldSpace(v43.MOTION.HEAD + Vector3.new(0, 0, FRONT)) else TitanPath.At(p31, TitanPath.Back(p31, v40, FRONT), v39)

    while FRONT < v43.LENGTH do
        local v48 = math.min(FRONT + 30, v43.LENGTH)
        local v49 = if v44 then v44:PointToWorldSpace(v43.MOTION.HEAD + Vector3.new(0, 0, v48)) else TitanPath.At(p31, TitanPath.Back(p31, v40, v48), v39)
        local v50, v51, v52 = closest(p33, v41, v45, v49 - v45)

        v45 = v49

        local v53 = FRONT + (v48 - FRONT) * v51
        local v54 = profile(v43.HIT, v53)

        if v52 < v54 then
            local v55 = math.max(0, v50 * p35 - math.sqrt(v54 * v54 - v52 * v52))

            if not v46 or v55 < v46.dist then
                v46 = {
                    dist = v55,
                    u = v53
                }
            end
        end

        FRONT = v48
    end

    if not v46 then
        return nil
    end

    local v61 = t1.Frame(p31, p32, v46.u, v39):PointToObjectSpace(p33 + p34 * v46.dist)

    v46.angle = math.atan2(v61.Y, v61.X)
    v46.point = t1.Point(p31, p32, v46.u, v46.angle, v39)

    return v46
end

return t1
