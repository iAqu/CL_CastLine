-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent, "toolbar").default
local HttpService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").HttpService
local t1 = {
    "FishFlops",
    "Catfish",
    "Dolphin",
    "Blade",
    "Berrypla",
    "Berrywhal",
    "FrostTooth",
    "AbyssWhale",
    "DevilFlare"
}
local t2 = {}

for i = 0, #t1 - 1 do
    table.insert(t2, {
        itemType = "fish",
        level = 1,
        fishObtainedTimestamp = i,
        itemId = HttpService:GenerateGUID(false),
        itemName = t1[i + 1],
        isEquipped = i == 0,
        mutations = {},
        timeStampAdded = i
    })
end

return storyForScreenGui(react.createElement(default, nil, react.createElement("frame", {
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1)
}, react.createElement(default2, {
    activeItems = t2,
    onBackpackClick = function() -- onBackpackClick | line: 30
    end,
    onItemClick = function() -- onItemClick | line: 31
    end,
    shouldShowTutorialPointerForSlot = function(p1) -- shouldShowTutorialPointerForSlot | line: 32
        return p1 == 0
    end
}))))
