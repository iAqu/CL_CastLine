-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "shiny-overlay").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local getZoneGachaBuffDescriptions = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "zone-gacha-equipment").getZoneGachaBuffDescriptions
local rarityColors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").rarityColors
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(95, 255, 130)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 190, 70))
})
local v2 = Color3.fromRGB(22, 120, 52)
local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 180)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 40, 130))
})
local v4 = Color3.fromRGB(140, 20, 80)

return {
    default = function(p1) -- ZoneGachaTooltip | line: 14
        -- upvalues: react (copy), default (copy), default2 (copy), default3 (copy), useTheme (copy), getZoneGachaBuffDescriptions (copy), rarityColors (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy)
        local data, isEquippedAsBuff, isEquippedAsSkin, isOwned = p1.data, p1.isEquippedAsBuff, p1.isEquippedAsSkin, p1.isOwned
        local onEquipAsBuff, onEquipAsSkin = p1.onEquipAsBuff, p1.onEquipAsSkin
        local v5 = useTheme()
        local v6 = rarityColors[data.rarity]
        local v7 = getZoneGachaBuffDescriptions(data.buffs)
        local v8 = react.createElement("uiaspectratioconstraint", {
            AspectRatio = 0.75
        })
        local v9 = react.createElement("uicorner", {
            CornerRadius = UDim.new(0.06, 0)
        })
        local v10 = react.createElement("uicorner", {
            CornerRadius = UDim.new(0.05, 0)
        })
        local v11 = react.createElement("uigradient", {
            Rotation = 90,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(196, 196, 196))
            })
        })
        local v12 = react.createElement(default3, {
            zIndex = 201,
            position = UDim2.fromScale(0.5, 0.5),
            scaleType = Enum.ScaleType.Fit,
            size = UDim2.fromScale(1, 1)
        })
        local v13 = react.createElement(default, {
            shadowYScale = 0.05,
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 202,
                AnchorPoint = Vector2.new(0.5, 0),
                Font = v5.textFont,
                Position = UDim2.fromScale(0.5, 0.05),
                Size = UDim2.fromScale(0.8, 0.1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            text = data.displayName
        })
        local v14 = react.createElement("frame", {
            ClipsDescendants = true,
            ZIndex = 202,
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = Color3.fromRGB(9, 12, 18),
            Position = UDim2.fromScale(0.5, 0.18),
            Size = UDim2.fromScale(0.55, 0.3)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.1, 0)
        }), react.createElement("uistroke", {
            Thickness = 2,
            Color = v6
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 203,
            Image = data.imageId,
            Position = UDim2.fromScale(0.08, 0.08),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.84, 0.84)
        }))
        local v15 = react.createElement("textlabel", {
            BackgroundTransparency = 1,
            TextScaled = true,
            TextStrokeTransparency = 0.3,
            ZIndex = 202,
            Font = Enum.Font.GothamBold,
            Position = UDim2.fromScale(0.1, 0.5),
            Size = UDim2.fromScale(0.8, 0.06),
            Text = string.upper(data.rarity),
            TextColor3 = v6
        })
        local v16 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            Padding = UDim.new(0.01, 0),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        local v17

        if #v7 > 0 then
            v17 = table.create(#v7)

            local function v18(p2, p3) -- line: 98
                -- upvalues: v7 (copy), react (copy)
                return react.createElement("textlabel", {
                    BackgroundTransparency = 1,
                    TextScaled = true,
                    TextWrapped = true,
                    Font = Enum.Font.GothamBold,
                    LayoutOrder = p3,
                    Size = UDim2.fromScale(1, 1 / #v7),
                    Text = p2,
                    TextColor3 = Color3.fromRGB(60, 60, 60),
                    TextXAlignment = Enum.TextXAlignment.Center,
                    key = p2
                })
            end

            for v19, v20 in v7 do
                v17[v19] = v18(v20, v19 - 1, v7)
            end
        else
            v17 = react.createElement("textlabel", {
                BackgroundTransparency = 1,
                Text = "No buffs",
                TextScaled = true,
                Font = Enum.Font.GothamBold,
                Size = UDim2.fromScale(1, 1),
                TextColor3 = Color3.fromRGB(60, 60, 60)
            })
        end

        local createElement = react.createElement
        local t1 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 200,
            AnchorPoint = p1.anchorPoint or Vector2.new(0.5, 0.5),
            Position = p1.position or UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.24, 0.4)
        }
        local createElement2 = react.createElement
        local t2 = {
            BorderSizePixel = 0,
            ZIndex = 200,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.fromScale(1, 1)
        }
        local createElement3 = react.createElement
        local t3 = {
            ZIndex = 201,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.94, 0.94)
        }
        local v21 = react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 202,
            Position = UDim2.fromScale(0.1, 0.58),
            Size = UDim2.fromScale(0.8, 0.16)
        }, v16, v17)

        if not isOwned then
            local v22 = react.createElement("textlabel", {
                BackgroundTransparency = 1,
                Text = "Not owned yet",
                TextScaled = true,
                ZIndex = 202,
                Font = Enum.Font.GothamBold,
                Position = UDim2.fromScale(0.1, 0.8),
                Size = UDim2.fromScale(0.8, 0.12),
                TextColor3 = Color3.fromRGB(120, 120, 120)
            })

            return createElement("frame", t1, v8, createElement2("frame", t2, v9, createElement3("frame", t3, v10, v11, v12, v13, v14, v15, v21, v22)))
        end

        return createElement("frame", t1, v8, createElement2("frame", t2, v9, createElement3("frame", t3, v10, v11, v12, v13, v14, v15, v21, (react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 202,
            Position = UDim2.fromScale(0.1, 0.76),
            Size = UDim2.fromScale(0.8, 0.2)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.06, 0),
            SortOrder = Enum.SortOrder.LayoutOrder
        }), react.createElement(default2, {
            layoutOrder = 0,
            zIndex = 203,
            anchorPoint = Vector2.new(0.5, 0.5),
            color = if isEquippedAsSkin then v3 else v1,
            frameSize = UDim2.fromScale(1, 0.44),
            label = isEquippedAsSkin and "Equipped [Skin]" or "Equip [Skin]",
            onClick = onEquipAsSkin,
            popoutColor = if isEquippedAsSkin then v4 else v2,
            position = UDim2.fromScale(0.5, 0.5)
        }), react.createElement(default2, {
            layoutOrder = 1,
            zIndex = 203,
            anchorPoint = Vector2.new(0.5, 0.5),
            color = if isEquippedAsBuff then v3 else v1,
            frameSize = UDim2.fromScale(1, 0.44),
            label = isEquippedAsBuff and "Equipped [Buff]" or "Equip [Buff]",
            onClick = onEquipAsBuff,
            popoutColor = if isEquippedAsBuff then v4 else v2,
            position = UDim2.fromScale(0.5, 0.5)
        }))))))
    end
}
