-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    Prepare = function(p1) -- Prepare | line: 3
        local t2 = {}
        local n1 = 0

        for v1, v2 in ipairs(p1) do
            if v1 > 1 then
                n1 += (v2 - p1[v1 - 1]).Magnitude
            end

            table.insert(t2, {
                Position = v2,
                Distance = n1
            })
        end

        return t2
    end,
    Frame = function(p2, p3) -- Frame | line: 8
        local n2 = 2

        while n2 < #p2 and p2[n2].Distance < p3 do
            n2 += 1
        end

        local v3 = p2[n2 - 1]
        local v4 = p2[n2]
        local v5 = v4.Position - v3.Position
        local Magnitude = v5.Magnitude
        local v6 = (p3 - v3.Distance) / Magnitude
        local v7 = v3.Position + v5 * v6
        local Position = p2[math.max(1, n2 - 2)].Position
        local Position2 = p2[math.min(#p2, n2 + 1)].Position
        local v11 = (v4.Position - Position).Unit:Lerp((Position2 - v3.Position).Unit, (math.clamp(v6, 0, 1)))

        return CFrame.lookAt(v7, v7 + v11)
    end,
    DistanceAt = function(p4, p5, p6, p7, p8) -- DistanceAt | line: 21
        if p7 <= 0 then
            return p5
        end

        local v13 = math.clamp((p8 - p6) / p7, 0, 1)

        return p4 + (p5 - p4) * v13 * v13 * (3 - v13 * 2)
    end
}

return table.freeze(t1)
