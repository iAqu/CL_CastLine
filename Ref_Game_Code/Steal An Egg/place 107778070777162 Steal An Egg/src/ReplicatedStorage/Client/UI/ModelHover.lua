-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollisionGroups = require(ReplicatedStorage.Shared.Types.CollisionGroups)
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.strict(t.table)
local v2 = t.strict(t.Vector2)
local v3 = t.strict(t.number)
local v4 = t.strict(t.string)
local v5 = t.strict(t.instanceIsA("Model"))
local v6 = RaycastParams.new()

v6.CollisionGroup = CollisionGroups.PLAYER_COLLISION_GROUP
v6.IgnoreWater = true

return {
    KeyUnderCursor = function(p1, p2, p3) -- KeyUnderCursor | line: 20
        -- upvalues: v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy)
        v1(p1)
        v2(p2)
        v3(p3)
        assert(p3 > 0, "a hover probe with no reach can never touch anything")

        local CurrentCamera = workspace.CurrentCamera
        local v8 = CurrentCamera and CurrentCamera:ViewportPointToRay(p2.X, p2.Y)
        local v9 = v8 and workspace:Raycast(v8.Origin, v8.Direction * p3, v6)

        if v9 then
            for v10, v11 in pairs(p1) do
                v4(v10)
                v5(v11)

                if v11.Parent and v9.Instance:IsDescendantOf(v11) then
                    return v10
                end
            end
        end

        return nil
    end
}
