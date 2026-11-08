-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    ContainsPoint = function(p1, p2, p3) -- ContainsPoint | line: 4
        if p1.Anchored and not (p1.CFrame.UpVector.Y < 0.95) then
            local v2 = p1.CFrame:PointToObjectSpace(p2)
            local v3 = p3 or 0.35
            local v1 = false

            if math.abs(v2.X) <= p1.Size.X / 2 + v3 and math.abs(v2.Z) <= p1.Size.Z / 2 + v3 and v2.Y >= -p1.Size.Y / 2 - 0.5 then
                v1 = v2.Y <= p1.Size.Y / 2 + 12
            end

            return v1
        end

        return false
    end
}

function t1.ContainsCharacter(p4, p5) -- line: 16
    -- upvalues: t1 (copy)
    if not p5 then
        return false
    end

    local Humanoid = p5:FindFirstChildOfClass("Humanoid")
    local HumanoidRootPart = p5:FindFirstChild("HumanoidRootPart")

    if not Humanoid or Humanoid.Health <= 0 or not HumanoidRootPart or not HumanoidRootPart:IsA("BasePart") then
        return false
    end

    if not Humanoid.Sit and not Humanoid.PlatformStand and t1.ContainsPoint(p4, HumanoidRootPart.Position) then
        if not (math.abs(HumanoidRootPart.AssemblyLinearVelocity.Y) > 5) then
            local v4 = Humanoid.HipHeight + HumanoidRootPart.Size.Y / 2
            local v5 = p5:FindFirstChild("Left Leg")

            if v5 and v5:IsA("BasePart") then
                v4 += v5.Size.Y
            end

            local v6 = RaycastParams.new()

            v6.FilterType = Enum.RaycastFilterType.Exclude
            v6.FilterDescendantsInstances = { p5 }
            v6.RespectCanCollide = true

            local v9 = workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -math.min(v4 + 1.5, 12), 0), v6)

            if v9 and not (v9.Normal.Y < 0.5) then
                local v11 = p4.CFrame:PointToObjectSpace(v9.Position)

                return v11.Y >= -p4.Size.Y / 2 - 1.5 and v11.Y <= p4.Size.Y / 2 + 1.5
            end
        end

        return false
    end

    return false
end

return table.freeze(t1)
