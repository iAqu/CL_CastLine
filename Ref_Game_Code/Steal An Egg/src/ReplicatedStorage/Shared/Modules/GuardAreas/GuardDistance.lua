-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)

return {
    XZ = function(p1, p2) -- XZ | line: 16
        -- upvalues: t (copy)
        t.strict(t.Vector3)(p1)
        t.strict(t.Vector3)(p2)

        local v1 = p1 - p2

        return Vector3.new(v1.X, 0, v1.Z).Magnitude
    end
}
