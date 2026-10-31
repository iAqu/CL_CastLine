-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    {
        id = "communityMemberPlaceholder1",
        category = "communityMember",
        displayName = "PLACEHOLDER_COMMUNITY_NAME",
        userId = 1,
        quotes = { "PLACEHOLDER_QUOTE_1", "PLACEHOLDER_QUOTE_2", "PLACEHOLDER_QUOTE_3" }
    },
    {
        id = "contentCreatorPlaceholder1",
        category = "contentCreator",
        displayName = "PLACEHOLDER_CREATOR_NAME",
        userId = 1,
        quotes = { "PLACEHOLDER_QUOTE_1", "PLACEHOLDER_QUOTE_2", "PLACEHOLDER_QUOTE_3" }
    },
    {
        id = "developerPlaceholder1",
        category = "developer",
        displayName = "PLACEHOLDER_DEV_NAME",
        userId = 1,
        quotes = { "PLACEHOLDER_QUOTE_1", "PLACEHOLDER_QUOTE_2", "PLACEHOLDER_QUOTE_3" }
    },
    {
        id = "topLeaderboardPlayerPlaceholder1",
        category = "topLeaderboardPlayer",
        displayName = "PLACEHOLDER_TOP1_NAME",
        userId = 1,
        quotes = { "PLACEHOLDER_QUOTE_1", "PLACEHOLDER_QUOTE_2" }
    },
    {
        id = "topLeaderboardPlayerPlaceholder2",
        category = "topLeaderboardPlayer",
        displayName = "PLACEHOLDER_TOP2_NAME",
        userId = 1,
        quotes = { "PLACEHOLDER_QUOTE_1", "PLACEHOLDER_QUOTE_2" }
    },
    {
        id = "topLeaderboardPlayerPlaceholder3",
        category = "topLeaderboardPlayer",
        displayName = "PLACEHOLDER_TOP3_NAME",
        userId = 1,
        quotes = { "PLACEHOLDER_QUOTE_1", "PLACEHOLDER_QUOTE_2" }
    },
    {
        id = "bemmyblox",
        category = "contentCreator",
        displayName = "BemmyBlox",
        userId = 1,
        quotes = { "I JUST FARTED OUT A MINI ME? THAT'S CRAZY!", "IS THAT THE INTENDED ANIMATION? THAT'S NOT REAL!", "Is this proper lifting technique?", "What is this animation bro?", "Should I be concerned?", "WHAT IN THE WORLD? WHY AM I SKIPPING LIKE A ROCK?", "Capybara? That's not a fish... What is bro doing in the water?" }
    }
}
local v1 = table.create(#t1)

local function v2(p1) -- line: 57
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
    getHallOfFameNpcData = function(p2) -- getHallOfFameNpcData | line: 69
        -- upvalues: t2 (copy)
        return t2[p2]
    end,
    hallOfFameNpcData = t1,
    hallOfFameNpcById = t2
}
