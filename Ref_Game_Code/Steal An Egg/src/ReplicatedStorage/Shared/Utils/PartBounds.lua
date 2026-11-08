-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.strict(t.table)

local function corner(p1, p2) -- line: 17
    return (Vector3.new(if p2 % 2 ~= 0 then p1.X else -p1.X, if p2 // 2 % 2 ~= 0 then p1.Y else -p1.Y, if p2 // 4 ~= 0 then p1.Z else -p1.Z))
end

return function(p3, p4) -- line: 27
    -- upvalues: v1 (copy)
    v1(p3)
    assert(#p3 > 0, "PartBounds needs at least one part")
    p4 = p4 or CFrame.identity

    local v7 = Vector3.new(1, 1, 1) * 1e999
    local v8 = -v7

    for _, v9 in p3 do
        if v9:IsA("BasePart") then
            local v10 = p4:ToObjectSpace(v9.CFrame)
            local v11 = v9.Size / 2

            for i = 0, 7 do
                local v15 = v10 * Vector3.new(if i % 2 ~= 0 then v11.X else -v11.X, if i // 2 % 2 ~= 0 then v11.Y else -v11.Y, if i // 4 ~= 0 then v11.Z else -v11.Z)

                v7 = v7:Min(v15)
                v8 = v8:Max(v15)
            end
        end
    end

    return p4 * CFrame.new((v7 + v8) / 2), v8 - v7
end
