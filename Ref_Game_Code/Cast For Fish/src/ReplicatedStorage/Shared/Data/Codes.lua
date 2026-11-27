-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    GROUP_ID = 0,
    List = {
        {
            code = "RELEASE",
            lucky = 3
        },
        {
            code = "FISHY",
            cash = 10,
            cashMin = 2500
        },
        {
            code = "CASTAWAY",
            power = 5
        },
        {
            code = "LUCKY20",
            lucky = 20
        }
    },
    ByCode = {}
}

for _, v1 in ipairs(t1.List) do
    t1.ByCode[string.upper(v1.code)] = v1
end

return t1
