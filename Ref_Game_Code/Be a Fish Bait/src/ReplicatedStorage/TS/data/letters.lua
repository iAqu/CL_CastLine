-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    {
        id = "Bemmyblox",
        recipientName = "Bemmyblox",
        bodyRichText = "Watching your video was an absolute joy, and we LOVED every second of it.\n\nAnd to answer some of your questions:\n\nYes, the fart was fully intended.\n\nYes, the weight lifting animation is intended. Peak athletic performance takes many forms, and we believe we have captured its pinnacle.\n\nSkipping across the water like a flat rock... means you're officially one of us.\n\nAnd the capybara in the water was fully intended. They're living their best life, and we're just living in their world.\n\nThanks for loving the game and making the team laugh 😂❤️ \nCome back soon!\n\nSincerely,\nThe Developers of BAFB\n&lt;3",
        recipientColor = Color3.fromRGB(191, 143, 20)
    },
    {
        id = "Aqua",
        recipientName = "Aqua",
        bodyRichText = "I hope this letter finds you in good health and spirits (especially after losing your frostwyrm 😂). The team wants to take this moment to express their gratitude for your profound support and impact, especially within the Discord community.\n\nYou've helped countless of players, and your enthusiasm and love for the game is infectious.\n\nThank you for being one of our biggest supporters and the team appreciates your efforts.\n\nSincerely,\nThe BAFB Developers",
        recipientColor = Color3.fromRGB(255, 105, 180)
    }
}
local v1 = table.create(#t1)

local function v2(p1) -- line: 28
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
    getLetterData = function(p2) -- getLetterData | line: 40
        -- upvalues: t2 (copy)
        return t2[p2]
    end,
    lettersData = t1,
    lettersById = t2
}
