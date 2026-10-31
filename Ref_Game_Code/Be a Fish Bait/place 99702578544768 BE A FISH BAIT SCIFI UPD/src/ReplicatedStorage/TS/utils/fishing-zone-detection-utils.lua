-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local getFishingZoneIndex = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "fishing-zones-utils").getFishingZoneIndex

return {
    resolveZoneContaining = function(p1, p2, p3) -- resolveZoneContaining | line: 11
        -- upvalues: getFishingZoneIndex (copy)
        local v1

        if p3 ~= nil and p3 then
            v1 = p1
        else
            v1 = {}

            local v2 = #v1

            table.move(p1, 1, #p1, v2 + 1, v1)
            table.sort(v1, function(p4, p5) -- line: 22
                -- upvalues: getFishingZoneIndex (copy)
                return getFishingZoneIndex(p4.zone) > getFishingZoneIndex(p5.zone)
            end)
        end

        for _, v3 in v1 do
            local v4 = v3.part.CFrame:PointToObjectSpace(p2)
            local v5 = v3.part.Size / 2

            if math.abs(v4.X) <= v5.X and math.abs(v4.Z) <= v5.Z then
                return v3
            end
        end

        return nil
    end,
    resolveNearestZone = function(p6, p7) -- resolveNearestZone | line: 43
        local n1 = 1e999
        local v6

        for _, v7 in p6 do
            local Magnitude = (v7.part.Position - p7).Magnitude

            if Magnitude < n1 then
                n1 = Magnitude
                v6 = v7
            end
        end

        return v6
    end
}
