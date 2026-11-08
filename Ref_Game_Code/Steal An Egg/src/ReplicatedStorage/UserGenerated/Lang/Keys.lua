-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function Keys(p1) -- line: 20
    local t1 = {}

    for v1, _ in pairs(p1) do
        table.insert(t1, v1)
    end

    return t1
end

return Keys
