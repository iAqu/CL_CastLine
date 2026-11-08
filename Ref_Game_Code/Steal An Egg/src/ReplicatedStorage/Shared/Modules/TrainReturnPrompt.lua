-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    ClosestPoint = function(p1, p2, p3) -- ClosestPoint | line: 4
        local v1 = p3 - p2
        local v2 = v1:Dot(v1)

        if v2 < 1E-04 then
            return p2
        end

        return p2 + v1 * math.clamp((p1 - p2):Dot(v1) / v2, 0, 1)
    end
}
