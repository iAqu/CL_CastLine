-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local Kit = require(script.Parent.Kit)

return {
    Throw = function(p1, p2, p3, p4) -- Throw | line: 14
        -- upvalues: RunService (copy), Kit (copy)
        local Position = p1.Position
        local v1 = math.max(Position.Y, p3.Y) + 55
        local v5 = Vector3.new((Position.X + p3.X) / 2, v1 * 2 - (Position.Y + p3.Y) / 2, (Position.Z + p3.Z) / 2)
        local v6 = Kit.Flat(p3 - Position)
        local v7 = if v6.Magnitude > 0.1 then (Vector3.new(0, 1, 0)):Cross(v6.Unit) else Vector3.new(1, 0, 0)
        local Rotation = p1.CFrame.Rotation
        local elapsed = os.clock()

        p2.PlatformStand = true

        local connection

        connection = RunService.RenderStepped:Connect(function() -- line: 28
            -- upvalues: p1 (copy), p2 (copy), p3 (copy), p4 (copy), Position (copy), v5 (copy), v7 (copy), Rotation (copy), elapsed (copy), connection (ref)
            local v9 = math.clamp((os.clock() - elapsed) / p4, 0, 1)
            local v10 = 1 - v9
            local v11 = Position * (v10 * v10) + v5 * (v10 * 2 * v9) + p3 * (v9 * v9)

            p1.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            p1.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            p1.CFrame = CFrame.new(v11) * CFrame.fromAxisAngle(v7, v9 * 3.141592653589793 * 4) * Rotation

            if not (v9 >= 1) and p1.Parent ~= nil and not (p2.Health <= 0) then
                return
            end

            if connection then
                connection:Disconnect()
            end

            p1.CFrame = CFrame.new(p3) * Rotation
            p1.AssemblyLinearVelocity = Vector3.new(0, -20, 0)
            p2.PlatformStand = false
        end)
    end
}
