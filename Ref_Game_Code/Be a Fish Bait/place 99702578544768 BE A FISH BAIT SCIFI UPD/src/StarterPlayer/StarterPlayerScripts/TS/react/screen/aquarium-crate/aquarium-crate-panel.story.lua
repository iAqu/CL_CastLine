-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local activeAquariumCrateSeries = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-crates").activeAquariumCrateSeries
local default2 = RuntimeLib.import(script, script.Parent, "aquarium-crate-panel").default

local function AquariumCratePanelStory() -- line: 10
    -- upvalues: react (copy), useState (copy), default (copy), activeAquariumCrateSeries (copy), default2 (copy)
    local v1, v2 = useState(false)

    return react.createElement(default, nil, react.createElement("frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.94, 0.42)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 2.65
    }), react.createElement(default2, {
        paidItemsAllowed = true,
        pityCount = 0,
        variant = "exclusiveShop",
        hasPurchasedFirstCrate = v1,
        onPurchase = function(p1) -- onPurchase | line: 21
            -- upvalues: v2 (copy)
            print((("Aquarium crate purchase clicked: %*"):format(p1)))

            if p1 == 1 then
                v2(true)
            end
        end,
        onShards = function() -- onShards | line: 27
            return print("Aquarium skin shards clicked")
        end,
        prices = {
            first = 67,
            one = 149,
            ten = 1299,
            three = 399
        },
        series = activeAquariumCrateSeries
    })))
end

return storyForScreenGui(react.createElement(AquariumCratePanelStory))
