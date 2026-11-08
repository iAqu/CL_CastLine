-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local GuardAreaGeometry = require(ReplicatedStorage.Shared.Util.GuardAreaGeometry)
local EMPCoin = ReplicatedStorage.Assets.Models.EMPCoin
local GuardAreas = Workspace:WaitForChild("World"):WaitForChild("Areas"):WaitForChild("GuardAreas")
local v1
local t1 = {}

t1.SpinSpeed = 2.4
t1.PickupRadius = EMPCoin.Size.Y / 2
t1.ChargeMax = 100
t1.PHASES = {
    {
        Id = "Wave1"
    },
    {
        Id = "Wave2"
    },
    {
        Id = "Wave3"
    }
}

function t1.PickupTemplate() -- line: 55
    -- upvalues: EMPCoin (copy)
    return EMPCoin
end

function t1.Zones() -- line: 60
    -- upvalues: GuardAreaGeometry (copy), GuardAreas (copy), v1 (ref)
    local v2 = v1

    if v2 then
        return v2
    end

    local v3 = GuardAreaGeometry.ReadAreaBounds(GuardAreas)

    table.sort(v3, function(p1, p2) -- line: 66
        return p1.Bounds.Position.X < p2.Bounds.Position.X
    end)
    v1 = v3

    return v3
end

function t1.ZoneIndexAt(p3) -- line: 74
    -- upvalues: t1 (copy), GuardAreaGeometry (copy)
    local n1 = 1
    local n2 = 1e999

    for v4, v5 in (t1.Zones()) do
        if GuardAreaGeometry.IsWithinFootprint(v5.Bounds, p3) then
            return v4
        end

        local v7 = math.abs(v5.Bounds.Position.X - p3.X)

        if v7 < n2 then
            n2 = v7
            n1 = v4
        end
    end

    return n1
end

function t1.EncodePickups(p4) -- line: 91
    local v8 = buffer.create(#p4 * 12)
    local n3 = 0

    for _, v9 in p4 do
        buffer.writef32(v8, n3, v9.X)
        buffer.writef32(v8, n3 + 4, v9.Y)
        buffer.writef32(v8, n3 + 8, v9.Z)
        n3 += 12
    end

    return v8
end

function t1.DecodePickups(p5) -- line: 103
    local t2 = {}

    for i = 1, buffer.len(p5) // 12 do
        local v12 = (i - 1) * 12

        t2[i] = {
            X = buffer.readf32(p5, v12),
            Y = buffer.readf32(p5, v12 + 4),
            Z = buffer.readf32(p5, v12 + 8)
        }
    end

    return t2
end

return t1
