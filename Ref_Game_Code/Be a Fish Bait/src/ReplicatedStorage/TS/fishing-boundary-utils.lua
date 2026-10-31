-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function getLateralExtent(p1, p2) -- line: 2
    return math.abs((p2:Dot(p1.CFrame.RightVector))) * p1.Size.X * 0.5 + math.abs((p2:Dot(p1.CFrame.LookVector))) * p1.Size.Z * 0.5
end

return {
    getFishingBoundaryLimits = function(p3, p4, p5) -- getFishingBoundaryLimits | line: 12
        if #p3 ~= 2 then
            return nil
        end

        local v4 = p4:Dot(p5)
        local v5 = table.create(#p3)

        for v6, v7 in p3 do
            local _ = v6 - 1
            local v8 = v7.Position:Dot(p5)
            local v12 = math.abs((p5:Dot(v7.CFrame.RightVector))) * v7.Size.X * 0.5 + math.abs((p5:Dot(v7.CFrame.LookVector))) * v7.Size.Z * 0.5

            v5[v6] = {
                center = v8,
                min = v8 - v12,
                max = v8 + v12
            }
        end

        table.sort(v5, function(p6, p7) -- line: 33
            return p6.center < p7.center
        end)

        local max = v5[1].max
        local min = v5[2].min
        local v13 = max - v4
        local v14 = min - v4

        return if not (v14 <= v13) then {
            minOffset = v13,
            maxOffset = v14
        } else nil
    end,
    clampFishingBoundaryOffset = function(p8, p9) -- clampFishingBoundaryOffset | line: 48
        return (math.clamp(p8, p9.minOffset, p9.maxOffset))
    end
}
