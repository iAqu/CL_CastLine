-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "preview-icon-button").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local default4 = RuntimeLib.import(script, script.Parent.Parent, "exclusive-shop", "long-shop-section").default
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils")
local getRarityBorderColor, getRarityColor, getRarityDisplayName = v1.getRarityBorderColor, v1.getRarityColor, v1.getRarityDisplayName
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(116, 255, 92)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 190, 62))
})
local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(151, 157, 168)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(72, 78, 89))
})

local function getSkinSectionType(p1) -- line: 16
    if p1 == "epic" then
        return "LongLightPurpleSection"
    end

    if p1 == "legendary" then
        return "LongOrangeSection"
    end

    if p1 == "mythic" then
        return "LongRedSection"
    end

    return "LongBlueSection"
end

local function getShardImage(p2) -- line: 28
    -- upvalues: images (copy)
    if p2 == "epic" then
        return images.epicShard
    end

    if p2 == "legendary" then
        return images.legendaryShard
    end

    if p2 == "mythic" then
        return images.mythicShard
    end

    return images.rareShard
end

return {
    default = function(p3) -- AquariumShopSkinCard | line: 41
        -- upvalues: react (copy), default (copy), default2 (copy), default3 (copy), useTheme (copy), default4 (copy), images (copy), getRarityBorderColor (copy), getRarityColor (copy), getRarityDisplayName (copy), v2 (copy), v3 (copy)
        local v4 = useTheme()
        local data = p3.data
        local v5 = not p3.owned and p3.ownedRarityShards >= data.requiredShards
        local v6 = if p3.owned then "OWNED" else ("%* / %*"):format(p3.ownedRarityShards, data.requiredShards)
        local moneyBoost = data.moneyBoost

        if moneyBoost == nil then
            moneyBoost = 0
        end

        local v8 = ("+%*%% CASH WHEN OWNED"):format((math.round(moneyBoost * 100)))
        local createElement = react.createElement
        local t1 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = p3.layoutOrder,
            Size = UDim2.fromScale(1, 0.42)
        }
        local createElement2 = react.createElement
        local t2 = {
            zIndex = 3
        }
        local rarity = data.rarity

        t2.sectionType = if rarity == "epic" then "LongLightPurpleSection"
            elseif rarity == "legendary" then "LongOrangeSection"
            elseif rarity == "mythic" then "LongRedSection"
            else "LongBlueSection"
        t2.size = UDim2.fromScale(1, 1)

        local v9 = react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(0.02, 0.5),
            Size = UDim2.fromScale(0.43, 0.9)
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0.36,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.shineBackground,
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1.38, 1.38)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0.68,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.shineBackground,
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1.12, 1.12)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 7,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = data.imageId,
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.9, 0.9)
        }))
        local createElement3 = react.createElement
        local t3 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(0.45, 0.5),
            Size = UDim2.fromScale(0.52, 0.88)
        }
        local v10 = react.createElement(default2, {
            shadowYScale = 0.055,
            color = Color3.fromRGB(255, 255, 255),
            overrideProps = {
                TextScaled = true,
                TextWrapped = false,
                ZIndex = 7,
                Font = v4.textFont2,
                Position = UDim2.fromScale(0, 0.02),
                Size = UDim2.fromScale(0.96, 0.22),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            strokeProps = {
                Thickness = 0.07
            },
            text = data.displayName
        })
        local v11 = react.createElement(default2, {
            shadowYScale = 0.04,
            color = getRarityColor(data.rarity),
            overrideProps = {
                TextScaled = true,
                ZIndex = 7,
                Font = v4.textFont,
                Position = UDim2.fromScale(0, 0.25),
                Size = UDim2.fromScale(0.92, 0.11),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            strokeProps = {
                Thickness = 0.055
            },
            text = string.upper(getRarityDisplayName(data.rarity))
        })
        local v12 = react.createElement(default2, {
            shadowYScale = 0.04,
            color = Color3.fromRGB(137, 255, 121),
            overrideProps = {
                TextScaled = true,
                ZIndex = 7,
                Font = v4.textFont,
                Position = UDim2.fromScale(0, 0.39),
                Size = UDim2.fromScale(0.95, 0.1),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            strokeProps = {
                Thickness = 0.085,
                Color = Color3.fromRGB(5, 5, 5)
            },
            text = v8
        })
        local v13 = react.createElement(default2, {
            shadowYScale = 0.035,
            color = Color3.fromRGB(217, 235, 255),
            overrideProps = {
                TextScaled = true,
                ZIndex = 7,
                Font = v4.textFont,
                Position = UDim2.fromScale(0, 0.52),
                Size = UDim2.fromScale(0.95, 0.1),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            strokeProps = {
                Thickness = 0.085,
                Color = Color3.fromRGB(5, 5, 5)
            },
            text = ("EXCHANGE WITH %* SHARDS"):format((string.upper(getRarityDisplayName(data.shardRarity))))
        })
        local createElement4 = react.createElement
        local t4 = {
            isStudded = false,
            zIndex = 8,
            anchorPoint = Vector2.new(0, 1),
            color = if p3.owned then v3 else v2,
            disabled = not v5,
            font = v4.textFont,
            frameSize = UDim2.fromScale(0.46, 0.24),
            isShiny = not p3.owned,
            label = v6,
            onClick = function() -- onClick | line: 178
                -- upvalues: p3 (copy), data (copy)
                return p3.onPurchase(data.name)
            end,
            popoutColor = if p3.owned then Color3.fromRGB(52, 56, 65) else Color3.fromRGB(17, 125, 42),
            position = UDim2.fromScale(0, 0.89),
            size = UDim2.fromScale(0.5, 0.66),
            strokeColor = getRarityBorderColor(data.rarity)
        }
        local createElement5 = react.createElement
        local t5 = {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1)
        }
        local v14 = react.createElement(default2, {
            shadowYScale = 0.05,
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(255, 255, 255),
            overrideProps = {
                TextScaled = true,
                ZIndex = 13,
                Font = v4.textFont,
                Size = UDim2.fromScale(0.68, 0.66),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            position = UDim2.fromScale(0.5, 0.49),
            strokeProps = {
                Thickness = 0.055
            },
            text = v6
        })
        local v15 = not p3.owned

        if v15 then
            local createElement = react.createElement
            local t6 = {
                BackgroundTransparency = 1,
                ZIndex = 13,
                AnchorPoint = Vector2.new(0.5, 0.5)
            }
            local shardRarity = data.shardRarity

            t6.Image = if shardRarity == "epic" then images.epicShard
                elseif shardRarity == "legendary" then images.legendaryShard
                elseif shardRarity == "mythic" then images.mythicShard
                else images.rareShard
            t6.Position = UDim2.fromScale(0.86, 0.49)
            t6.ScaleType = Enum.ScaleType.Fit
            t6.Size = UDim2.fromScale(0.2, 0.72)
            v15 = createElement("imagelabel", t6, react.createElement("uiaspectratioconstraint", {
                AspectRatio = 1
            }))
        end

        return createElement("frame", t1, createElement2(default4, t2, v9, createElement3("frame", t3, v10, v11, v12, v13, createElement4(default3, t4, createElement5("frame", t5, v14, v15))), react.createElement(default, {
            zIndex = 9,
            anchorPoint = Vector2.new(1, 0.5),
            onClick = function() -- onClick | line: 217
                -- upvalues: p3 (copy), data (copy)
                return p3.onPreview(data.name)
            end,
            position = UDim2.fromScale(0.95, 0.45),
            size = UDim2.fromOffset(42, 42)
        })))
    end
}
