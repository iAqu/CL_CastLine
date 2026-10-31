-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local luckyBlockRewardPool = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "lucky-block-drop-utils").luckyBlockRewardPool
local getRarityColor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").getRarityColor
local v1 = RuntimeLib.import(script, script.Parent, "lucky-block-reward-visuals")
local formatLuckyBlockChancePercent, luckyBlockRewardVisuals = v1.formatLuckyBlockChancePercent, v1.luckyBlockRewardVisuals
local v2 = Color3.fromRGB(255, 255, 255)
local v3 = Color3.fromRGB(255, 210, 90)

local function DropChanceCard(p1) -- line: 27
    -- upvalues: react (copy), default (copy), default2 (copy), getRarityColor (copy), formatLuckyBlockChancePercent (copy), luckyBlockRewardVisuals (copy), v2 (copy), v3 (copy)
    local v4 = luckyBlockRewardVisuals[p1.reward]
    local v5 = if v4.rarity == nil then v2 else getRarityColor(v4.rarity).Keypoints[1].Value

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = p1.layoutOrder
    }, react.createElement(default, {
        cornerRadius = 0.14,
        isStudded = true,
        isStuddedTransparency = 0.35,
        strokeThickness = 0.045,
        textureTransparency = 0.76,
        zIndex = 3,
        anchorPoint = Vector2.new(0.5, 0.5),
        backgroundColor = Color3.fromRGB(10, 19, 36),
        position = UDim2.fromScale(0.5, 0.5),
        size = UDim2.fromScale(1, 1),
        strokeColor = v5
    }, react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ZIndex = 4,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = v4.image,
        Position = UDim2.fromScale(0.5, 0.4),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.62, 0.62)
    }), react.createElement(default2, {
        shadowYScale = 0.05,
        color = v2,
        overrideProps = {
            TextScaled = true,
            TextWrapped = true,
            ZIndex = 4,
            Position = UDim2.fromScale(0.05, 0.76),
            Size = UDim2.fromScale(0.9, 0.2),
            TextXAlignment = Enum.TextXAlignment.Center
        },
        strokeProps = {
            Thickness = 0.06
        },
        text = v4.label
    })), react.createElement(default2, {
        shadowYScale = 0.05,
        anchorPoint = Vector2.new(0, 0),
        color = v3,
        overrideProps = {
            TextScaled = true,
            ZIndex = 6,
            Font = Enum.Font.FredokaOne,
            Size = UDim2.fromScale(0.5, 0.22),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        position = UDim2.fromScale(-0.04, -0.08),
        strokeProps = {
            Thickness = 0.12,
            Color = Color3.fromRGB(0, 0, 0)
        },
        text = formatLuckyBlockChancePercent(p1.chance)
    }))
end

return {
    default = function() -- LuckyBlockDropChanceList | line: 90
        -- upvalues: react (copy), luckyBlockRewardPool (copy), DropChanceCard (copy)
        local v6 = react.createElement("uiaspectratioconstraint", {
            AspectRatio = 2.074074074074074
        })
        local v7 = react.createElement("uigridlayout", {
            CellPadding = UDim2.fromScale(0.03571428571428571, 0.07407407407407407),
            CellSize = UDim2.fromScale(0.2232142857142857, 0.4629629629629629),
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            StartCorner = Enum.StartCorner.TopLeft,
            VerticalAlignment = Enum.VerticalAlignment.Center
        })
        local v8 = table.create(#luckyBlockRewardPool)

        local function v9(p2, p3) -- line: 105
            -- upvalues: react (copy), DropChanceCard (copy)
            return react.createElement(DropChanceCard, {
                chance = p2.chance,
                key = p2.reward,
                layoutOrder = p3,
                reward = p2.reward
            })
        end

        for v10, v11 in luckyBlockRewardPool do
            local v12 = v10 - 1

            v8[v10] = react.createElement(DropChanceCard, {
                chance = v11.chance,
                key = v11.reward,
                layoutOrder = v12,
                reward = v11.reward
            })
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }, v6, v7, v8)
    end
}
