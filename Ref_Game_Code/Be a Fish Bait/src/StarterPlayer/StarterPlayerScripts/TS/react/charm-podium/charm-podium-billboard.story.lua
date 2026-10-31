-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent, "utils", "story-provider").default
local storyForBillboardGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForBillboardGui
local CharmPodiumBillboardContent = RuntimeLib.import(script, script.Parent, "charm-podium-billboard").CharmPodiumBillboardContent

return storyForBillboardGui(function(p1) -- line: 7
    -- upvalues: react (copy), default (copy), CharmPodiumBillboardContent (copy)
    return react.createElement(default, nil, react.createElement("billboardgui", {
        AlwaysOnTop = true,
        MaxDistance = 65,
        StudsOffsetWorldSpace = Vector3.new(0, 5, 0),
        Adornee = p1,
        Size = UDim2.fromOffset(390, 190)
    }, react.createElement(CharmPodiumBillboardContent, {
        hasPending = false,
        isCompact = false,
        isFree = true,
        isLowerTier = false,
        isUnlocked = true,
        rebirthCount = 8,
        tierId = 4
    })))
end)
