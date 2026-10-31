-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local storyForBillboardGuiWithModel = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForBillboardGuiWithModel
local default = RuntimeLib.import(script, script.Parent, "fish-billboard").default

local function Story(p1) -- line: 6
    -- upvalues: react (copy), default (copy)
    local BasePart = p1.model:FindFirstChildWhichIsA("BasePart")

    return react.createElement(default, {
        moneyPerSecond = 1250,
        name = "Golden Tuna",
        rarity = "legendary",
        adornee = BasePart,
        model = p1.model
    })
end

return storyForBillboardGuiWithModel(function(p2) -- line: 16
    -- upvalues: react (copy), Story (copy)
    return react.createElement(Story, {
        model = p2
    })
end)
