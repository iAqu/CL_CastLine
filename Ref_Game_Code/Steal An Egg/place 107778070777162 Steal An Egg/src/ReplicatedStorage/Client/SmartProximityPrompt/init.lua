-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local FollowerLoop = require(script.FollowerLoop)
local SurfaceTracker = require(script.SurfaceTracker)

return {
    AttachToModel = function(p1, p2, p3) -- AttachToModel | line: 16
        -- upvalues: FollowerLoop (copy), SurfaceTracker (copy)
        FollowerLoop.Drop(p1)
        p3 = p3 or {}

        if p3.MaxActivationDistance ~= nil then
            p1.MaxActivationDistance = p3.MaxActivationDistance
        end

        local v2 = FollowerLoop.MakeAnchor(p3.PartName, p2:GetPivot())
        local v3 = SurfaceTracker.new(p2, v2)

        p1.RequiresLineOfSight = false

        return FollowerLoop.Add(p1, p2, v2, v3, p3)
    end
}
