-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local getCharmAttributeConfig = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "charm-attributes").getCharmAttributeConfig
local rarityColors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").rarityColors
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 180)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 40, 130))
})
local v2 = Color3.fromRGB(140, 20, 80)
local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(95, 255, 130)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 190, 70))
})
local v4 = Color3.fromRGB(22, 120, 52)
local v5 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 55)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(193, 193, 193)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(193, 193, 193)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(193, 193, 193)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(55, 55, 55))
})
local formatPercent, getAttributeLineColor

local function CharmCard(p1) -- line: 19
    -- upvalues: react (copy), default (copy), default2 (copy), default3 (copy), useTheme (copy), getCharmAttributeConfig (copy), rarityColors (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), formatPercent (ref), getAttributeLineColor (ref)
    local core, data, isAttributesEquipped, isSkinEquipped = p1.core, p1.data, p1.isAttributesEquipped, p1.isSkinEquipped
    local layoutOrder, onAttributesAction, onSkinAction = p1.layoutOrder, p1.onAttributesAction, p1.onSkinAction
    local v6 = useTheme()
    local v7 = rarityColors[data.rarity]
    local v8 = isSkinEquipped or isAttributesEquipped
    local t1 = {}

    if core ~= nil then
        table.insert(t1, {
            label = "Training Power",
            value = core.trainingPower
        })

        for _, v9 in core.affixes do
            table.insert(t1, {
                label = getCharmAttributeConfig(v9.attributeId).displayName,
                quality = v9.quality,
                value = v9.value
            })
        end
    end

    local v10 = v8 == true and react.createElement("textlabel", {
        BackgroundTransparency = 1,
        Rotation = -18,
        TextScaled = true,
        TextStrokeTransparency = 0.12,
        ZIndex = 12,
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromScale(-0.09, 0.035),
        Size = UDim2.fromScale(0.48, 0.07),
        Text = if not isSkinEquipped then "Attributes Equipped" elseif isAttributesEquipped then "Skin + Attributes" else "Skin Equipped",
        TextColor3 = Color3.fromRGB(76, 255, 118)
    })
    local v11 = react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        TextStrokeTransparency = 0.15,
        ZIndex = 2,
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromScale(0.06, 0.055),
        Size = UDim2.fromScale(0.88, 0.11),
        Text = data.displayName,
        TextColor3 = Color3.fromRGB(255, 255, 255)
    })
    local v12 = react.createElement(default, {
        clipsDescendants = true,
        cornerRadius = 0.045,
        strokeThickness = 0.014,
        transparency = 0,
        zIndex = 2,
        anchorPoint = Vector2.new(0.5, 0),
        backgroundColor = Color3.fromRGB(9, 12, 18),
        position = UDim2.fromScale(0.5, 0.19),
        size = UDim2.fromScale(0.46, 0.35),
        strokeColor = v7
    }, react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        Image = data.imageId,
        Position = UDim2.fromScale(0.03, 0.03),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.94, 0.94)
    }))
    local v13 = react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        TextStrokeTransparency = 0.25,
        ZIndex = 2,
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromScale(0.08, 0.565),
        Size = UDim2.fromScale(0.84, 0.075),
        Text = string.upper(data.rarity),
        TextColor3 = v7
    })
    local v14

    if core ~= nil then
        local v15 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.01, 0),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        local v16 = table.create(#t1)

        local function v17(p2, p3) -- line: 125
            -- upvalues: react (copy), formatPercent (ref), getAttributeLineColor (ref)
            return react.createElement("textlabel", {
                BackgroundTransparency = 1,
                TextScaled = true,
                TextStrokeTransparency = 0.35,
                ZIndex = 2,
                Font = Enum.Font.GothamBold,
                key = ("%*-%*"):format(p2.label, p3),
                LayoutOrder = p3,
                Size = UDim2.fromScale(1, 0.17),
                Text = ("%*  +%*"):format(p2.label, (formatPercent(p2.value))),
                TextColor3 = getAttributeLineColor(p2.quality),
                TextXAlignment = Enum.TextXAlignment.Left
            })
        end

        for v18, v19 in t1 do
            v16[v18] = v17(v19, v18 - 1, t1)
        end

        v14 = react.createElement(react.Fragment, nil, v15, v16)
    else
        v14 = react.createElement(default2, {
            shadowYScale = 0.06,
            color = Color3.fromRGB(220, 228, 239),
            overrideProps = {
                TextScaled = true,
                TextWrapped = true,
                ZIndex = 2,
                Font = v6.textFont2,
                Size = UDim2.fromScale(1, 1)
            },
            strokeProps = {
                Thickness = 0.045
            },
            text = data.description
        })
    end

    return react.createElement(default, {
        cornerRadius = 0.01,
        isStudded = true,
        strokeThickness = 0.01,
        textureTransparency = 0.6,
        tileSize = 80,
        transparency = 0.65,
        backgroundColor = v5,
        layoutOrder = layoutOrder,
        size = UDim2.fromScale(1, 1),
        strokeColor = Color3.fromRGB(64, 64, 64),
        zIndex = v8 == true and 10 or 1
    }, v10, v11, v12, v13, react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 2,
        Position = UDim2.fromScale(0.08, 0.64),
        Size = UDim2.fromScale(0.84, core == nil and 0.11 or 0.2)
    }, v14), react.createElement(default3, {
        isStudded = true,
        zIndex = 2,
        color = if isSkinEquipped then v1 else v3,
        font = v6.textFont2,
        frameSize = UDim2.fromScale(core == nil and 0.78 or 0.42, 0.13),
        label = isSkinEquipped and "Unequip Skin" or "Equip Skin",
        onClick = onSkinAction,
        popoutColor = if isSkinEquipped then v2 else v4,
        position = UDim2.fromScale(core == nil and 0.5 or 0.27, 0.91)
    }), core ~= nil and react.createElement(default3, {
        isStudded = true,
        zIndex = 2,
        color = if isAttributesEquipped then v1 else v3,
        font = v6.textFont2,
        frameSize = UDim2.fromScale(0.42, 0.13),
        label = isAttributesEquipped and "Unequip Attributes" or "Equip Attributes",
        onClick = onAttributesAction,
        popoutColor = if isAttributesEquipped then v2 else v4,
        position = UDim2.fromScale(0.73, 0.91)
    }))
end

function formatPercent(p4) -- line: 186
    return (`{ math.round(p4 * 1000) / 10 }%`)
end

function getAttributeLineColor(p5) -- line: 189
    -- upvalues: rarityColors (copy)
    if p5 == "perfect" then
        return rarityColors.legendary
    end

    if p5 == "great" then
        return rarityColors.epic
    end

    if p5 == "good" then
        return rarityColors.uncommon
    end

    if p5 == "standard" then
        return rarityColors.common
    end

    return rarityColors.rare
end

return {
    default = CharmCard
}
