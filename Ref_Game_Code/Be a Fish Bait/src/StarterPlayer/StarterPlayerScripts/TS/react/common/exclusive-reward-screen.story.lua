-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fishing-rod-skins")
local fishingRodSkinsData, fomoRodSkinId = v1.fishingRodSkinsData, v1.fomoRodSkinId
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent, "exclusive-reward-screen").default
local v2 = fishingRodSkinsData[fomoRodSkinId]

local function Story() -- line: 14
    -- upvalues: react (copy), useState (copy), images (copy), default2 (copy), v2 (copy)
    local v3, v4 = useState(0)
    local v5 = v2

    if v2 ~= nil then
        v5 = v2.imageId
    end

    if v5 == nil then
        v5 = images.giftBox
    end

    local t1 = {}

    t1.iconImage = v5
    t1.key = v3

    local v6 = v2

    if v2 ~= nil then
        v6 = v2.name
    end

    t1.rewardText = if v6 == nil then "FOMO Rod Skin" else v6
    t1.title = "FAREWELL GIFT!"
    t1.uiScale = 1
    t1.zIndex = 50

    return react.createElement("frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(18, 16, 28),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default2, t1), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "Replay",
        TextScaled = true,
        ZIndex = 300,
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundColor3 = Color3.fromRGB(65, 120, 220),
        Event = {
            Activated = function() -- Activated | line: 48
                -- upvalues: v4 (copy)
                return v4(function(p1) -- line: 49
                    return p1 + 1
                end)
            end
        },
        Position = UDim2.fromScale(0.5, 0.97),
        Size = UDim2.fromScale(0.18, 0.06),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(Story)))
