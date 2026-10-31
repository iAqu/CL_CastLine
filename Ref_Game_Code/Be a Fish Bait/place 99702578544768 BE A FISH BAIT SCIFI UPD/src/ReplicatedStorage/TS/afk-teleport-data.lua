-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    isAfkTeleportData = function(p1) -- isAfkTeleportData | line: 13
        if not (p1 ~= 0 and p1 == p1 and p1 ~= "" and p1) or typeof(p1) ~= "table" or p1.isAfkTeleport ~= true or typeof(p1.resumeTraining) ~= "boolean" then
            return false
        end

        local relativePosition = p1.relativePosition

        if not relativePosition or typeof(relativePosition) ~= "table" then
            return false
        end

        local v1 = typeof(relativePosition.x) ~= "number"
        local v2

        if v1 then
            v2 = v1
        else
            local v3 = typeof(relativePosition.y) ~= "number"

            v2 = v3 or typeof(relativePosition.z) ~= "number"
        end

        if v2 then
            return false
        end

        local relativeLookAt = p1.relativeLookAt

        if not relativeLookAt or typeof(relativeLookAt) ~= "table" then
            return false
        end

        local v4 = typeof(relativeLookAt.x) ~= "number"
        local v5

        if v4 then
            v5 = v4
        else
            local v6 = typeof(relativeLookAt.y) ~= "number"

            v5 = v6 or typeof(relativeLookAt.z) ~= "number"
        end

        return not v5
    end
}
