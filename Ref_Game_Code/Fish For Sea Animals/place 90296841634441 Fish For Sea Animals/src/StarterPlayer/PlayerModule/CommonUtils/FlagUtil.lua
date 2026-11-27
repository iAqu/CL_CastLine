-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    getUserFlag = function(p1) -- getUserFlag | line: 11
        local function v1() -- line: 12
            -- upvalues: p1 (copy)
            return UserSettings():IsUserFeatureEnabled(p1)
        end

        local ok, result = pcall(v1)

        return ok and result
    end
}
