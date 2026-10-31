-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default2 = RuntimeLib.import(script, script.Parent, "bait-aura-window").default
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "bait-aura-utils")
local baitAuraConfigs, defaultBaitAuraName, rollBaitAura = v1.baitAuraConfigs, v1.defaultBaitAuraName, v1.rollBaitAura

local function BaitAuraWindowStory() -- line: 13
    -- upvalues: RuntimeLib (copy), react (copy), useState (copy), default2 (copy), baitAuraConfigs (copy), defaultBaitAuraName (copy), rollBaitAura (copy)
    local v2, v3 = useState(true)
    local v4, v5 = useState(0)
    local v6, v7 = useState(0)
    local v8, v9 = useState(0)
    local v10, v11 = useState({ true, false, false })
    local v12, v13 = useState({ defaultBaitAuraName, "", "" })
    local v14, v15 = useState(0)

    if v2 then
        local v20 = react.createElement(default2, {
            disableSceneCamera = true,
            useSimplePreview = true,
            auraSlots = v12,
            equippedSlotIndex = v8,
            onBuyReroll = function(p1) -- onBuyReroll | line: 50
                -- upvalues: v5 (copy)
                return v5(function(p2) -- line: 51
                    -- upvalues: p1 (copy)
                    return p2 + p1
                end)
            end,
            onBuySlotWithRobux = function(p3) -- onBuySlotWithRobux | line: 55
                -- upvalues: v11 (copy)
                return v11(function(p4) -- line: 56
                    -- upvalues: p3 (copy)
                    local t2 = {}
                    local v16 = #t2

                    table.move(p4, 1, #p4, v16 + 1, t2)
                    t2[p3 + 1] = true

                    return t2
                end)
            end,
            onClose = function() -- onClose | line: 65
                -- upvalues: v3 (copy)
                return v3(false)
            end,
            onEquipSlot = function(p5) -- onEquipSlot | line: 68
                -- upvalues: v9 (copy), v10 (copy), v12 (copy)
                if v10[p5 + 1] and v12[p5 + 1] ~= "" then
                    v9(p5)
                end
            end,
            onRollAura = RuntimeLib.async(function(p6) -- line: 73
                -- upvalues: v4 (copy), v5 (copy), v9 (copy), v10 (copy), v13 (copy), rollBaitAura (copy)
                if v4 <= 0 or not v10[p6 + 1] then
                    return nil
                end

                v5(function(p7) -- line: 77
                    return (math.max(p7 - 1, 0))
                end)

                local v18 = rollBaitAura()

                v13(function(p8) -- line: 81
                    -- upvalues: p6 (copy), v18 (copy)
                    local t3 = {}
                    local v19 = #t3

                    table.move(p8, 1, #p8, v19 + 1, t3)
                    t3[p6 + 1] = v18.auraName

                    return t3
                end)
                v9(p6)

                return {
                    auraName = v18.auraName,
                    displayName = v18.displayName,
                    rarity = v18.rarity
                }
            end),
            rebirthCount = v6,
            rerolls = v4,
            unlockedSlots = v10
        })
        local v21 = react.createElement("uicorner", {
            CornerRadius = UDim.new(0, 8)
        })
        local v22 = react.createElement("uistroke", {
            Thickness = 1.5,
            Color = Color3.fromRGB(0, 0, 0)
        })
        local v23 = react.createElement("uilistlayout", {
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        local v24 = react.createElement("uipadding", {
            PaddingBottom = UDim.new(0, 6),
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 6),
            PaddingTop = UDim.new(0, 6)
        })
        local v25 = react.createElement("textlabel", {
            BackgroundTransparency = 1,
            LayoutOrder = 0,
            Text = "Spawn Aura Into Slot",
            TextScaled = true,
            Font = Enum.Font.GothamBold,
            Size = UDim2.fromOffset(160, 18),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        })
        local v26 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        local t4 = {
            0, 1, 2
        }
        local v27 = table.create(#t4)

        local function v28(p9) -- line: 135
            -- upvalues: v14 (copy), v15 (copy), react (copy)
            return react.createElement("textbutton", {
                TextScaled = true,
                BackgroundColor3 = if v14 == p9 then Color3.fromRGB(42, 150, 91) else Color3.fromRGB(60, 60, 60),
                Event = {
                    Activated = function() -- Activated | line: 139
                        -- upvalues: p9 (copy), v15 (copy)
                        return v15(p9)
                    end
                },
                Font = Enum.Font.GothamBold,
                Size = UDim2.fromOffset(50, 24),
                Text = `Slot { p9 + 1 }`,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                key = ("slot-%*"):format(p9)
            }, react.createElement("uicorner", {
                CornerRadius = UDim.new(0, 6)
            }))
        end

        for v29, v30 in t4 do
            v27[v29] = v28(v30, v29 - 1, t4)
        end

        local v31 = react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Size = UDim2.fromOffset(160, 24)
        }, v26, v27)
        local v32 = react.createElement("uilistlayout", {
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        local v33 = table.create(#baitAuraConfigs)

        local function v34(p10, p11) -- line: 168
            -- upvalues: v9 (copy), v11 (copy), v13 (copy), v14 (copy), react (copy)
            return react.createElement("textbutton", {
                TextScaled = true,
                BackgroundColor3 = p10.color,
                Event = {
                    Activated = function() -- Activated | line: 172
                        -- upvalues: p10 (copy), v9 (copy), v11 (copy), v13 (copy), v14 (copy)
                        v11(function(p12) -- line: 174
                            -- upvalues: v14 (copy)
                            local t9 = {}
                            local v35 = #t9

                            table.move(p12, 1, #p12, v35 + 1, t9)
                            t9[v14 + 1] = true

                            return t9
                        end)
                        v13(function(p13) -- line: 182
                            -- upvalues: p10 (copy), v14 (copy)
                            local t10 = {}
                            local v36 = #t10

                            table.move(p13, 1, #p13, v36 + 1, t10)
                            t10[v14 + 1] = p10.auraName

                            return t10
                        end)
                        v9(v14)
                    end
                },
                Font = Enum.Font.GothamBold,
                LayoutOrder = p11,
                Size = UDim2.fromOffset(160, 24),
                Text = ("%* (%*)"):format(p10.displayName, p10.rarity),
                TextColor3 = Color3.fromRGB(0, 0, 0),
                key = p10.auraName
            }, react.createElement("uicorner", {
                CornerRadius = UDim.new(0, 6)
            }), react.createElement("uistroke", {
                Thickness = 1,
                Color = Color3.fromRGB(0, 0, 0)
            }))
        end

        for v37, v38 in baitAuraConfigs do
            v33[v37] = v34(v38, v37 - 1, baitAuraConfigs)
        end

        return react.createElement(react.Fragment, nil, v20, react.createElement("frame", {
            BackgroundTransparency = 0.3,
            ZIndex = 500,
            AnchorPoint = Vector2.new(1, 0),
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            Position = UDim2.new(1, -10, 0, 10),
            Size = UDim2.fromOffset(180, 340)
        }, v21, v22, v23, v24, v25, v31, react.createElement("scrollingframe", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 2,
            ScrollBarThickness = 4,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.fromScale(0, 0),
            Size = UDim2.fromOffset(160, 260)
        }, v32, v33)), react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 500,
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.new(0, 10, 1, -10),
            Size = UDim2.fromOffset(110, 89)
        }, react.createElement("uilistlayout", {
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder
        }), react.createElement("textbutton", {
            LayoutOrder = 1,
            Text = "+10 Rerolls",
            TextScaled = true,
            BackgroundColor3 = Color3.fromRGB(42, 91, 150),
            Event = {
                Activated = function() -- Activated | line: 238
                    -- upvalues: v5 (copy)
                    return v5(function(p14) -- line: 239
                        return p14 + 10
                    end)
                end
            },
            Font = Enum.Font.GothamBold,
            Size = UDim2.fromOffset(110, 27),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0, 6)
        }), react.createElement("uistroke", {
            Thickness = 1.5,
            Color = Color3.fromRGB(0, 0, 0)
        })), react.createElement("textbutton", {
            LayoutOrder = 2,
            Text = "Fill Slots",
            TextScaled = true,
            BackgroundColor3 = Color3.fromRGB(120, 78, 35),
            Event = {
                Activated = function() -- Activated | line: 258
                    -- upvalues: v11 (copy), v13 (copy), baitAuraConfigs (copy)
                    v11({ true, true, true })
                    v13({
                        baitAuraConfigs[1].auraName,
                        baitAuraConfigs[4].auraName,
                        baitAuraConfigs[8].auraName
                    })
                end
            },
            Font = Enum.Font.GothamBold,
            Size = UDim2.fromOffset(110, 27),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0, 6)
        }), react.createElement("uistroke", {
            Thickness = 1.5,
            Color = Color3.fromRGB(0, 0, 0)
        })), react.createElement("textbutton", {
            LayoutOrder = 3,
            TextScaled = true,
            BackgroundColor3 = Color3.fromRGB(80, 50, 130),
            Event = {
                Activated = function() -- Activated | line: 277
                    -- upvalues: v7 (copy)
                    return v7(function(p15) -- line: 278
                        if p15 >= 6 then
                            return 0
                        end

                        return p15 + 3
                    end)
                end
            },
            Font = Enum.Font.GothamBold,
            Size = UDim2.fromOffset(110, 27),
            Text = ("Rebirth: %*"):format(v6),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0, 6)
        }), react.createElement("uistroke", {
            Thickness = 1.5,
            Color = Color3.fromRGB(0, 0, 0)
        }))))
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("textbutton", {
        Text = "Open Bait Auras",
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(42, 91, 150),
        Event = {
            Activated = function() -- Activated | line: 29
                -- upvalues: v3 (copy)
                return v3(true)
            end
        },
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(240, 56),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 8)
    }), react.createElement("uistroke", {
        Thickness = 2,
        Color = Color3.fromRGB(0, 0, 0)
    })))
end

return storyForScreenGui(react.createElement(default, {
    initialState = {}
}, react.createElement(BaitAuraWindowStory)), {
    zIndexBehavior = Enum.ZIndexBehavior.Sibling
})
