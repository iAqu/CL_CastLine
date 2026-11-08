-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local t1 = {}
local t2 = {}

local function cframeInFrontOfRootClampedToArea(p1, p2) -- line: 31
    local LookVector = p1.LookVector
    local v1 = Vector3.new(LookVector.X, 0, LookVector.Z)

    assert(v1.Magnitude > 0, "Asset front placement requires a horizontal root facing direction")

    local Unit = v1.Unit
    local Size = p2.Size
    local v4 = math.max(Size.X * 0.5 - 1.75, 0)
    local v6 = math.max(Size.Z * 0.5 - 1.75, 0)
    local v7 = p1.Position + Unit * 6
    local v8 = p2.CFrame:PointToObjectSpace(v7)
    local v13 = Vector3.new(math.clamp(v8.X, -v4, v4), 0, (math.clamp(v8.Z, -v6, v6)))
    local Position = (p2.CFrame * CFrame.new(v13)).Position

    return CFrame.lookAt(Position, Position + Unit)
end

function t2.SetFrontPlacement(p3, p4) -- line: 59
    -- upvalues: t (copy), t1 (copy)
    t.strict(t.string)(p3)
    t.strict(t.CFrame)(p4)
    t1[p3] = {
        RootCFrame = p4,
        ExpiresAt = os.clock() + 10
    }
end

function t2.ConsumeFrontPlacement(p5, p6) -- line: 69
    -- upvalues: t (copy), t1 (copy), cframeInFrontOfRootClampedToArea (copy)
    t.strict(t.string)(p5)
    t.strict(t.instanceIsA("BasePart"))(p6)

    local v14 = t1[p5]

    t1[p5] = nil

    if v14 == nil or v14.ExpiresAt < os.clock() then
        return nil
    end

    return cframeInFrontOfRootClampedToArea(v14.RootCFrame, p6)
end

function t2.ClearFrontPlacement(p7) -- line: 82
    -- upvalues: t (copy), t1 (copy)
    t.strict(t.string)(p7)
    t1[p7] = nil
end

return t2
