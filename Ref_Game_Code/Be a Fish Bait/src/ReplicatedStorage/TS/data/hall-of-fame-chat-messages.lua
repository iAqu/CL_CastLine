-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    {
        id = "chatMessagePlaceholder1",
        displayName = "Brother Aki",
        userId = 1,
        text = "oh no i hit 67 power"
    },
    {
        id = "chatMessagePlaceholder2",
        displayName = "makiling2",
        userId = 1,
        text = "skill issue"
    },
    {
        id = "chatMessagePlaceholder3",
        displayName = "el",
        userId = 1,
        text = "how to get seahorse ghost ?"
    },
    {
        id = "chatMessagePlaceholder4",
        displayName = "Astra",
        userId = 1,
        text = "Bro lost the frostwyrm"
    },
    {
        id = "chatMessagePlaceholder5",
        displayName = "aquafina",
        userId = 1,
        text = "I want my frostwyrm I lost back"
    },
    {
        id = "chatMessagePlaceholder6",
        displayName = "expiredwine",
        userId = 1,
        text = "who is haribro like wow"
    },
    {
        id = "chatMessagePlaceholder7",
        displayName = "zip",
        userId = 1,
        text = "new codes PLEASEEEEE"
    }
}
local v1 = table.create(#t1)

local function v2(p1) -- line: 47
    return {
        p1.id,
        p1
    }
end

for v3, v4 in t1 do
    local _ = v3 - 1

    v1[v3] = {
        v4.id,
        v4
    }
end

local t2 = {}

for _, v5 in v1 do
    t2[v5[1]] = v5[2]
end

return {
    hallOfFameChatMessagesData = t1,
    hallOfFameChatMessagesById = t2
}
