-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    selectHoopTestingEnabled = function(p1) -- selectHoopTestingEnabled | line: 2
        return function(p2) -- line: 3
            -- upvalues: p1 (copy)
            local v1 = p2.hoopTesting[p1]

            if v1 ~= nil then
                v1 = v1.enabled
            end

            if v1 == nil then
                v1 = false
            end

            return v1
        end
    end
}
