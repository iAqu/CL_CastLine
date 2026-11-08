-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.strict(t.CFrame)
local v2 = t.strict(t.Vector3)

return function(p1, p2, p3) -- line: 15
    -- upvalues: v1 (copy), v2 (copy)
    v1(p1)
    v2(p2)
    v2(p3)

    local v3 = p1:PointToObjectSpace(p3):Abs()
    local v4 = p2 / 2

    return v3:Max(v4) == v4
end
