-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    getObbyCheckpointOrder = function(p1) -- getObbyCheckpointOrder | line: 2
        local v1 = string.match(p1, "^Checkpoint(%d+)$")

        return if v1 ~= nil then tonumber(v1) else nil
    end,
    getFinalObbyCheckpointId = function(p2) -- getFinalObbyCheckpointId | line: 6
        local n1 = -1
        local v2

        for _, v3 in p2 do
            local v4 = string.match(v3, "^Checkpoint(%d+)$")
            local v5 = if v4 == nil then nil else tonumber(v4)

            if v5 ~= nil and n1 < v5 then
                n1 = v5
                v2 = v3
            end
        end

        return v2
    end
}
