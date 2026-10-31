-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local v1 = t.union(t.literal("common"), t.literal("uncommon"), t.literal("rare"), t.literal("epic"), t.literal("legendary"))
local v2 = t.interface({
    gemDisplayName = t.string,
    gemName = t.string,
    gemRarity = v1,
    playerName = t.string,
    rarityFactor = t.number
})
local v3 = t.interface({
    fishDisplayName = t.string,
    fishRarity = t.string,
    isApex = t.boolean,
    mutationName = t.optional(t.string),
    originJobId = t.string,
    playerName = t.string,
    totalFishCount = t.number
})
local v4 = t.interface({
    auraDisplayName = t.string,
    auraRarity = t.string,
    chancePercent = t.number,
    originJobId = t.string,
    playerName = t.string
})
local v5 = t.interface({
    exclusiveIndex = t.optional(t.number),
    playerName = t.string
})
local v6 = t.interface({
    richText = t.string
})
local v7 = t.intersection(v6, t.interface({
    jobId = t.string
}))

return {
    rareGemTopic = "rareGemObtained",
    rareFishCaughtTopic = "rareFishCaught",
    rareAuraObtainedTopic = "rareAuraObtained",
    frostwyrmCaughtTopic = "frostwyrmCaught",
    serverAnnouncementTopic = "serverAnnouncement",
    constructRichText = function(p1) -- constructRichText | line: 49
        local text = p1.text

        return (("<font color=\"#%*\">%*</font>"):format(p1.color:ToHex(), text))
    end,
    escapeRichText = function(p2) -- escapeRichText | line: 54
        return (string.gsub(string.gsub(string.gsub(p2, "&", "&amp;"), "<", "&lt;"), ">", "&gt;"))
    end,
    rareGemObtainedPayloadGuard = v2,
    rareFishCaughtPayloadGuard = v3,
    rareAuraObtainedPayloadGuard = v4,
    frostwyrmCaughtPayloadGuard = v5,
    systemMessageInfoGuard = v6,
    messagingServiceSystemMessageData = v7,
    systemMessageColors = {
        green = Color3.fromRGB(33, 214, 122),
        red = Color3.fromRGB(214, 33, 33),
        gold = Color3.fromRGB(255, 215, 0),
        purple = Color3.fromRGB(181, 8, 181)
    },
    fishMutationColors = {
        Gold = "#FFD700",
        Diamond = "#B9F2FF",
        Plasma = "#CC44FF",
        Molten = "#FF6600",
        Radioactive = "#39FF14",
        Glitched = "#FF00FF",
        Champion = "#FFEB78",
        Delulu = "#D22396",
        hoola1 = "#2AE2D7",
        hoola2 = "#E8B536",
        hoola3 = "#9D7DFF"
    }
}
