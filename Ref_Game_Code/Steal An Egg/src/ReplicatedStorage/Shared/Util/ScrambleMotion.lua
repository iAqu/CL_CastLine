-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    Pose = function(p1, p2) -- Pose | line: 5
        local v1 = (p2 - p1.StartedAt) * p1.Speed + p1.Phase
        local v6 = Vector3.new(math.cos(v1) * p1.Radius, math.sin(v1 * 2.1) * p1.Bob, math.sin(v1) * p1.Radius)

        return p1.Home * CFrame.new(v6) * CFrame.Angles(0, -v1, math.sin(v1) * 0.08)
    end,
    Read = function(p3) -- Read | line: 14
        local FlightHome = p3:GetAttribute("FlightHome")

        return if typeof(FlightHome) == "CFrame" then {
            Home = FlightHome,
            StartedAt = p3:GetAttribute("FlightStartedAt"),
            Phase = p3:GetAttribute("FlightPhase"),
            Radius = p3:GetAttribute("FlightRadius"),
            Speed = p3:GetAttribute("FlightSpeed"),
            Bob = p3:GetAttribute("FlightBob")
        } else nil
    end,
    Envelope = function(p4, p5, p6, p7, p8, p9) -- Envelope | line: 28
        local v7 = p4.Magnitude / 2
        local v10 = math.max((p9 or 12) / 2, p5.Radius + v7 + p7)
        local v12 = math.max(p8, p5.Home.Position.Y - p6.Y + v7 + p5.Bob + p7)

        return CFrame.new(p6 + Vector3.new(0, v12 / 2, 0)), (Vector3.new(v10 * 2, v12, v10 * 2))
    end,
    Hitbox = function(p10, p11, p12, p13) -- Hitbox | line: 42
        return p11 * p12, p10 + Vector3.new(1, 1, 1) * math.min(p13, 1) * 2
    end
}

return table.freeze(t1)
