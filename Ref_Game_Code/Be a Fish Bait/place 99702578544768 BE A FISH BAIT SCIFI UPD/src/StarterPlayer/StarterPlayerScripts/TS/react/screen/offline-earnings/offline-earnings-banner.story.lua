-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local default2 = RuntimeLib.import(script, script.Parent, "offline-earnings-banner").default
local t1 = {
    playerData = {
        fishingContracts = {},
        aquarium = {
            [localPlayerUserId] = {
                aquariumLevel = 1,
                moneyPerSecond = 150000,
                uncollectedMoney = 0,
                aquariumUpgradeCompleteTimestamp = nil,
                aquariumUpgradeStartedTimestamp = nil,
                equippedSkin = "Default",
                fishItems = {},
                ownedSkins = { "Default" },
                seenSkins = {}
            }
        }
    }
}

local function BannerShowcase() -- line: 28
    -- upvalues: react (copy), useState (copy), default2 (copy)
    local v1, v2 = useState(true)

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("textbutton", {
        BorderSizePixel = 0,
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundColor3 = Color3.fromRGB(50, 100, 200),
        Event = {
            Activated = function() -- Activated | line: 38
                -- upvalues: v2 (copy)
                return v2(function(p1) -- line: 39
                    return not p1
                end)
            end
        },
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.5, 0.98),
        Size = UDim2.fromOffset(260, 36),
        Text = v1 and "Hide banner" or "Show banner",
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.2, 0)
    })), react.createElement(default2, {
        visible = v1
    }))
end

return storyForScreenGui(react.createElement(default, {
    initialState = t1
}, react.createElement(BannerShowcase)), {
    zIndexBehavior = Enum.ZIndexBehavior.Sibling
})
