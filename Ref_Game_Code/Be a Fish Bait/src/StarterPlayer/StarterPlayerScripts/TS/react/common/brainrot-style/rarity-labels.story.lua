-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils")
local getRarityBorderColor, getRarityColor = v1.getRarityBorderColor, v1.getRarityColor
local t1 = {
    "common",
    "uncommon",
    "rare",
    "epic",
    "legendary",
    "mythic",
    "godly",
    "secret",
    "hacked",
    "cosmic"
}

local function capitalize(p1) -- line: 10
    return string.upper((string.sub(p1, 1, 1))) .. string.sub(p1, 2)
end

local function RarityLabels() -- line: 13
    -- upvalues: react (copy), getRarityBorderColor (copy), getRarityColor (copy), t1 (copy)
    local v2 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })
    local v3 = table.create(#t1)

    local function v4(p2, p3) -- line: 23
        -- upvalues: react (copy), getRarityBorderColor (copy), getRarityColor (copy)
        return react.createElement("textlabel", {
            BackgroundTransparency = 1,
            TextScaled = true,
            ZIndex = 1,
            Font = Enum.Font.FredokaOne,
            LayoutOrder = p3,
            Size = UDim2.fromOffset(300, 36),
            Text = string.upper((string.sub(p2, 1, 1))) .. string.sub(p2, 2),
            TextColor3 = Color3.new(1, 1, 1),
            TextXAlignment = Enum.TextXAlignment.Left,
            key = p2
        }, react.createElement("uigradient", {
            Rotation = 90,
            Color = getRarityColor(p2)
        }), react.createElement("uistroke", {
            Thickness = 0.03,
            Color = getRarityBorderColor(p2),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        }))
    end

    for v5, v6 in t1 do
        v3[v5] = v4(v6, v5 - 1, t1)
    end

    return react.createElement("frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(300, 480)
    }, v2, v3))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(RarityLabels)))
