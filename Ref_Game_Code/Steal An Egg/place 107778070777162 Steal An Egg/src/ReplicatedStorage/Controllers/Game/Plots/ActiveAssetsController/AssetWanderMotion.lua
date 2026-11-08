-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local AssetWanderArea = require(script.Parent.AssetWanderArea)
local t1 = {
    YawFromFlatDirection = function(p1) -- YawFromFlatDirection | line: 18
        return (math.atan2(-p1.X, -p1.Z))
    end,
    ShortestYawDelta = function(p2, p3) -- ShortestYawDelta | line: 22
        local v3 = p3 - p2

        return (math.atan2(math.sin(v3), (math.cos(v3))))
    end
}

function t1.StepYawToward(p4, p5, p6) -- line: 28
    -- upvalues: t1 (copy)
    local v6 = t1.ShortestYawDelta(p4, p5)
    local v7 = p6 * 3.839724354387525
    local v9 = math.clamp(v6, -v7, v7)

    return p4 + v9, v9
end

function t1.StepMoveToward(p7, p8, p9, p10) -- line: 40
    -- upvalues: t1 (copy)
    local Position = p8.Position
    local v10 = p9 - Position
    local v11 = Vector3.new(v10.X, 0, v10.Z)
    local Magnitude = v11.Magnitude

    if Magnitude <= 0 then
        return p8, false, 0
    end

    local v13 = math.min(Magnitude, p10 * p7)
    local Unit = v11.Unit
    local LookVector = p8.LookVector
    local v14 = Vector3.new(LookVector.X, 0, LookVector.Z)
    local v15 = if v14.Magnitude > 0 then v14.Unit else Unit
    local v16 = t1.YawFromFlatDirection(v15)
    local v17 = t1.YawFromFlatDirection(Unit)
    local v18, v19 = t1.StepYawToward(v16, v17, p7)
    local v23 = math.clamp((math.cos((math.abs((t1.ShortestYawDelta(v18, v17))))) - 0.2) / 0.8, 0, 1)
    local v24 = Position + Unit * v13 * v23

    return CFrame.new(v24) * CFrame.Angles(0, v18, 0), v23 > 0 or math.abs(v19) > 0.008726646259971648, p10 * v23
end

function t1.FaceOwnerCFrame(p11, p12, p13, p14) -- line: 75
    -- upvalues: t1 (copy)
    local Position = p11.Position
    local v27 = Vector3.new(p12.X - Position.X, 0, p12.Z - Position.Z)

    if v27.Magnitude <= 0 then
        return p11
    end

    local LookVector = p11.LookVector
    local v28 = Vector3.new(LookVector.X, 0, LookVector.Z)

    assert(v28.Magnitude > 0, "Asset wander CFrame must have a horizontal facing direction")

    local v30 = t1.YawFromFlatDirection(v28.Unit)
    local v31 = t1.YawFromFlatDirection(v27.Unit)

    if p14 ~= true then
        v31 = t1.StepYawToward(v30, v31, p13)
    end

    return CFrame.new(Position) * CFrame.Angles(0, v31, 0)
end

function t1.StepFollowOwner(p15, p16, p17, p18, p19, p20, p21) -- line: 104
    -- upvalues: AssetWanderArea (copy), t1 (copy)
    local v32 = AssetWanderArea.PointNearOwner(p15, p18, p19)
    local v33, v34, v35 = t1.StepMoveToward(p16, p17, v32, p20)

    if Vector3.new(v32.X - v33.Position.X, 0, v32.Z - v33.Position.Z).Magnitude <= p21 then
        v33 = t1.FaceOwnerCFrame(v33, p18, p16)
    end

    return v33, v34, v35
end

function t1.OwnerMoveVector(p22, p23, p24) -- line: 125
    if p23 == nil then
        return Vector3.new(0, 0, 0), nil
    end

    if p24 == nil or p22 <= 0 then
        return Vector3.new(0, 0, 0), p23
    end

    local v38 = p23 - p24

    return Vector3.new(v38.X, 0, v38.Z) / p22, p23
end

function t1.OrbitGreetingCFrame(p25, p26, p27, p28, p29, p30, p31, p32) -- line: 141
    -- upvalues: AssetWanderArea (copy), t1 (copy)
    local Position = p27.Position
    local v41 = Vector3.new(Position.X - p28.X, 0, Position.Z - p28.Z)
    local Unit

    if v41.Magnitude == 0 then
        local LookVector = p25.CFrame.LookVector
        local v42 = Vector3.new(LookVector.X, 0, LookVector.Z)

        assert(v42.Magnitude > 0, "Asset area must provide a horizontal orbit greeting direction")
        Unit = v42.Unit
    else
        local Unit2 = v41.Unit

        Unit = (Vector3.new(-Unit2.Z, 0, Unit2.X) + Unit2 * math.clamp((p30 - v41.Magnitude) / p30, -p32, p32)).Unit
    end

    local v48 = Unit * p31 + p29
    local v49 = Vector3.new(v48.X, 0, v48.Z)
    local Magnitude = v48.Magnitude

    if v49.Magnitude <= 0 then
        return p27, false, 0
    end

    local v50 = AssetWanderArea.ClampedPointToward(p25, Position + v48 * p26)
    local v53 = Vector3.new(v50.X - Position.X, 0, v50.Z - Position.Z)

    if v53.Magnitude <= 0 then
        return p27, false, 0
    end

    local v54 = t1.YawFromFlatDirection(v53.Unit)

    return CFrame.new(v50) * CFrame.Angles(0, v54, 0), true, Magnitude
end

return t1
