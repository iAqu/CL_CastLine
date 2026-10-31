-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local images = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local t1 = {
    {
        animationId = "rbxassetid://10714068222",
        displayName = "Dolphin",
        emoteId = "Dolphin",
        imageId = images.emoteIconDolphin
    },
    {
        animationId = "rbxassetid://10714388352",
        displayName = "Monke",
        emoteId = "Monke",
        imageId = images.emoteIconMonkey
    },
    {
        animationId = "rbxassetid://10714340543",
        displayName = "Floss",
        emoteId = "Floss",
        imageId = images.emoteIconFloss
    },
    {
        animationId = "rbxassetid://131993317980055",
        displayName = "Scuba",
        emoteId = "Scuba",
        ticketPrice = 300,
        imageId = images.scubaEmoteIcon
    },
    {
        animationId = "rbxassetid://112419851464800",
        displayName = "Hear Me Now",
        emoteId = "HearMeNow",
        imageId = images.emoteIconHearMeNow
    },
    {
        animationId = "rbxassetid://109835090228014",
        displayName = "NPC Goat Simulator",
        emoteId = "GoatSim",
        imageId = images.emoteIconGoatSim
    },
    {
        animationId = "rbxassetid://129601617475831",
        displayName = "No Hands",
        emoteId = "NoHands",
        imageId = images.emoteIconNoHands
    },
    {
        animationId = "rbxassetid://81132562064069",
        displayName = "Popular Vibe",
        emoteId = "PopularVibe",
        imageId = images.emoteIconPopularVibe
    },
    {
        animationId = "rbxassetid://118570726228574",
        displayName = "Snoopy",
        emoteId = "Snoopy",
        imageId = images.emoteIconSnoopy
    },
    {
        animationId = "rbxassetid://82891222209594",
        displayName = "Sway",
        emoteId = "Sway",
        imageId = images.emoteIconSway
    },
    {
        animationId = "rbxassetid://98683187872526",
        displayName = "Wolf",
        emoteId = "Wolf",
        imageId = images.emoteIconWolf
    }
}
local v1 = table.create(#t1)

local function v2(p1) -- line: 64
    return {
        p1.emoteId,
        p1
    }
end

for v3, v4 in t1 do
    local _ = v3 - 1

    v1[v3] = {
        v4.emoteId,
        v4
    }
end

local t2 = {}

for _, v5 in v1 do
    t2[v5[1]] = v5[2]
end

return {
    emoteDefinitions = t1,
    emoteDefinitionsById = t2
}
