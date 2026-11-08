-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observability = require(ReplicatedStorage.UserGenerated.Observability)
local Codec = require(ReplicatedStorage.UserGenerated.Observability.Codec)
local Op = Observability.Op
local t1 = {
    Angular = 1,
    Linear = 2,
    Acceleration = 4,
    SameRotation = 8,
    at = function(p1, p2, p3, p4, p5) -- at | line: 28
        local v1 = p4 * (p5 * 0.5 * p5)
        local Magnitude = p2.Magnitude

        if Magnitude == 0 then
            return p1 + p3 * p5 + v1
        end

        local v2 = p2 / Magnitude
        local v3 = p2:Cross(p3) / (Magnitude * Magnitude)
        local v4 = CFrame.fromAxisAngle(v2, Magnitude * p5)
        local v5 = v3 + v4:VectorToWorldSpace(p1.Position - v3) + v2 * (v2:Dot(p3) * p5) + v1

        return CFrame.new(v5) * v4 * p1.Rotation
    end,
    between = function(p6, p7, p8) -- between | line: 46
        local v6 = p7 * p6:Inverse()
        local v7, v8 = v6:ToAxisAngle()
        local Position = v6.Position

        if v8 < 1E-06 or v7.Magnitude < 1E-06 then
            return Vector3.new(0, 0, 0), Position / p8
        end

        local Unit = v7.Unit
        local v9 = Unit:Dot(Position)
        local v10 = Position - Unit * v9
        local v13 = (v10 + Unit:Cross(v10) / math.tan(v8 / 2)) * 0.5
        local v14 = Unit * (v8 / p8)

        return v14, Unit * (v9 / p8) - v14:Cross(v13)
    end,
    accelerating = function(p9, p10, p11, p12, p13, p14) -- accelerating | line: 64
        local v15 = (p10 - p9) / (p13 - p12)
        local v16 = (p11 - p10) / (p14 - p13)
        local v17 = (v16 - v15) / ((p14 - p12) / 2)

        return v16 + v17 * ((p14 - p13) / 2), v17
    end,
    apart = function(p15, p16, p17, p18) -- apart | line: 72
        if p17 < (p15.Position - p16.Position).Magnitude then
            return true
        end

        local _, v18 = (p15.Rotation:Inverse() * p16.Rotation):ToAxisAngle()
        local v19 = math.abs(v18) % 6.283185307179586

        return p18 < math.min(v19, 6.283185307179586 - v19)
    end
}

local function vector(p19, p20) -- line: 81
    p19:f32(p20.X)
    p19:f32(p20.Y)
    p19:f32(p20.Z)
end

function t1.write(p21, p22, p23, p24, p25, p26, p27, p28) -- line: 89
    -- upvalues: Codec (copy), Op (copy), t1 (copy)
    local v21 = (if p25 == Vector3.new(0, 0, 0) then 0 else t1.Angular) + (if p26 == Vector3.new(0, 0, 0) then 0 else t1.Linear) + (if p27 == Vector3.new(0, 0, 0) then 0 else t1.Acceleration) + (if p28 then t1.SameRotation else 0)

    p21:u8(Op.CFrameMotion)
    Codec.varuint(p21, p22)
    Codec.varuint(p21, p23)
    p21:u8(v21)

    if p28 then
        Codec.position(p21, p24)
    else
        Codec.cframe(p21, p24)
    end

    if bit32.btest(v21, t1.Angular) then
        p21:f32(p25.X)
        p21:f32(p25.Y)
        p21:f32(p25.Z)
    end

    if bit32.btest(v21, t1.Linear) then
        p21:f32(p26.X)
        p21:f32(p26.Y)
        p21:f32(p26.Z)
    end

    if not bit32.btest(v21, t1.Acceleration) then
        return
    end

    p21:f32(p27.X)
    p21:f32(p27.Y)
    p21:f32(p27.Z)
end

return t1
