-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local storyForBillboardGuiWithModel = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForBillboardGuiWithModel
local AuraShowcaseBillboard = RuntimeLib.import(script, script.Parent, "aura-showcase-billboard-manager").AuraShowcaseBillboard

return storyForBillboardGuiWithModel(function(p1) -- line: 6
    -- upvalues: react (copy), AuraShowcaseBillboard (copy)
    local v1 = p1:FindFirstChildWhichIsA("BillboardGui", true)

    assert(v1 ~= nil, "Story model is missing a BillboardGui")

    return react.createElement(AuraShowcaseBillboard, {
        auraName = "VoidsporeAura",
        billboard = v1
    })
end)
