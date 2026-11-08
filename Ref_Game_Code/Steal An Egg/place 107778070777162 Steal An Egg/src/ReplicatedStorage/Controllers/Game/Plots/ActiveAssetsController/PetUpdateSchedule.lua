-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    GetInterval = function(p1, p2, p3, p4, p5, p6) -- GetInterval | line: 12
        if not p6.Enabled then
            return 0
        end

        if p1 then
            return p6.HiddenInterval
        end

        if not p2 and p5 ~= nil then
            local v1 = p3 - p5
            local v2 = p6.DistantDistance + p4

            if v1:Dot(v1) > v2 * v2 then
                return p6.DistantInterval
            end
        end

        return 0
    end,
    TakeStep = function(p7, p8, p9, p10) -- TakeStep | line: 34
        local v3 = p7 + p8

        if p9 > 0 and v3 + 1E-06 < p9 and not p10 then
            return false, 0, v3
        end

        if p9 > 0 then
            v3 = math.min(v3, 0.25)
        end

        return true, v3, 0
    end
}

return table.freeze(t1)
