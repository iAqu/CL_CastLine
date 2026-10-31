-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent, "gradient-button").default
local default3 = RuntimeLib.import(script, script.Parent, "glow-button").default
local default4 = RuntimeLib.import(script, script.Parent, "glossy-button").default
local default5 = RuntimeLib.import(script, script.Parent, "scale-close-button").default

local function ButtonShowcase() -- line: 10
    -- upvalues: react (copy), default2 (copy), default3 (copy), default4 (copy), default5 (copy)
    local t1 = {
        "small",
        "medium",
        "large"
    }
    local _ = {
        "primary",
        "secondary",
        "danger",
        "success"
    }
    local t2 = {
        "default",
        "hover",
        "disabled",
        "active"
    }
    local t3 = {
        "rounded",
        "square",
        "pill"
    }
    local t4 = {
        "green",
        "blue",
        "purple",
        "red",
        "orange"
    }

    local function toUpperString(p1) -- line: 18
        local v1 = tostring(p1)

        return string.upper(v1)
    end

    local v2 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 20),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top
    })
    local v3 = react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 16,
        Text = "Gradient Buttons (with icons)",
        TextSize = 24,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.fromOffset(0, 40),
        TextColor3 = Color3.new(1, 1, 1)
    })
    local v4 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local v5 = react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Text = "Gradients:",
        TextSize = 18,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.fromOffset(100, 40),
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local v6 = table.create(#t4)

    local function v7(p2, p3) -- line: 56
        -- upvalues: react (copy), default2 (copy)
        local createElement = react.createElement
        local t5 = {
            shape = "pill",
            size = "medium",
            gradientScheme = p2,
            key = ("gradient-%*"):format(p2),
            overrideProps = {
                LayoutOrder = p3 + 1
            }
        }
        local v8 = tostring(p2)

        t5.text = ("With %*"):format((string.upper(v8)))

        return createElement(default2, t5)
    end

    for v9, v10 in t4 do
        v6[v9] = v7(v10, v9 - 1, t4)
    end

    local v11 = react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 17,
        Size = UDim2.fromOffset(0, 80)
    }, v4, v5, v6)
    local v12 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local v13 = react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Text = "Sizes:",
        TextSize = 18,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.fromOffset(100, 40),
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local v14 = table.create(#t1)

    local function v15(p4, p5) -- line: 95
        -- upvalues: react (copy), default2 (copy)
        local createElement = react.createElement
        local t6 = {
            gradientScheme = "green",
            shape = "pill",
            key = ("gradient-size-%*"):format(p4),
            overrideProps = {
                LayoutOrder = p5 + 1
            },
            size = p4
        }
        local v16 = tostring(p4)

        t6.text = string.upper(v16)

        return createElement(default2, t6)
    end

    for v17, v18 in t1 do
        v14[v17] = v15(v18, v17 - 1, t1)
    end

    local v19 = react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 18,
        Size = UDim2.fromOffset(0, 80)
    }, v12, v13, v14)
    local v20 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local v21 = react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Text = "States:",
        TextSize = 18,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.fromOffset(100, 40),
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local v22 = table.create(#t2)

    local function v23(p6, p7) -- line: 134
        -- upvalues: react (copy), default2 (copy)
        local createElement = react.createElement
        local t7 = {
            gradientScheme = "green",
            shape = "pill",
            size = "medium",
            key = ("gradient-state-%*"):format(p6),
            overrideProps = {
                LayoutOrder = p7 + 1
            },
            state = p6
        }
        local v24 = tostring(p6)

        t7.text = string.upper(v24)

        return createElement(default2, t7)
    end

    for v25, v26 in t2 do
        v22[v25] = v23(v26, v25 - 1, t2)
    end

    local v27 = react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 19,
        Size = UDim2.fromOffset(0, 80)
    }, v20, v21, v22)
    local v28 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local v29 = react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Text = "Shapes:",
        TextSize = 18,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.fromOffset(100, 40),
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local v30 = table.create(#t3)

    local function v31(p8, p9) -- line: 174
        -- upvalues: react (copy), default2 (copy)
        local createElement = react.createElement
        local t8 = {
            gradientScheme = "green",
            size = "medium",
            key = ("gradient-shape-%*"):format(p8),
            overrideProps = {
                LayoutOrder = p9 + 1
            },
            shape = p8
        }
        local v32 = tostring(p8)

        t8.text = string.upper(v32)

        return createElement(default2, t8)
    end

    for v33, v34 in t3 do
        v30[v33] = v31(v34, v33 - 1, t3)
    end

    local v35 = react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 20,
        Size = UDim2.fromOffset(0, 80)
    }, v28, v29, v30)
    local v36 = react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 21,
        Size = UDim2.fromOffset(0, 80)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Text = "Custom:",
        TextSize = 18,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.fromOffset(100, 40),
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left
    }), react.createElement(default2, {
        shape = "pill",
        size = "medium",
        text = "Custom Green",
        gradientLeft = Color3.new(0.1, 0.5, 0.2),
        gradientRight = Color3.new(0.2, 0.7, 0.3),
        overrideProps = {
            LayoutOrder = 1
        }
    }), react.createElement(default2, {
        shape = "pill",
        size = "medium",
        text = "Custom Blue",
        gradientLeft = Color3.new(0.1, 0.3, 0.6),
        gradientRight = Color3.new(0.2, 0.5, 0.8),
        overrideProps = {
            LayoutOrder = 2
        }
    }))
    local v37 = react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 22,
        Text = "Glow Buttons (with placeholder images)",
        TextSize = 24,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.fromOffset(0, 40),
        TextColor3 = Color3.new(1, 1, 1)
    })
    local v38 = react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 23,
        Size = UDim2.fromOffset(0, 120)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    }), react.createElement(default3, {
        borderColorScheme = "rainbow",
        key = "glow-rainbow",
        placeholderImage = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        shape = "rounded",
        size = "medium",
        text = "Season 8",
        overrideProps = {
            LayoutOrder = 1
        }
    }), react.createElement(default3, {
        borderColorScheme = "orange-red",
        key = "glow-orange-red",
        placeholderImage = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        shape = "rounded",
        size = "medium",
        text = "Quests",
        overrideProps = {
            LayoutOrder = 2
        }
    }), react.createElement(default3, {
        borderColorScheme = "teal-blue",
        key = "glow-teal-blue",
        placeholderImage = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        shape = "rounded",
        size = "medium",
        text = "Profile",
        overrideProps = {
            LayoutOrder = 3
        }
    }), react.createElement(default3, {
        borderColorScheme = "purple-magenta",
        key = "glow-purple-magenta",
        placeholderImage = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        shape = "rounded",
        size = "medium",
        text = "Events",
        overrideProps = {
            LayoutOrder = 4
        }
    }), react.createElement(default3, {
        borderColorScheme = "lime-yellow",
        key = "glow-lime-yellow",
        placeholderImage = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        shape = "rounded",
        size = "medium",
        text = "Trade",
        overrideProps = {
            LayoutOrder = 5
        }
    }))
    local v39 = react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 24,
        Text = "Glow Buttons (without placeholder images)",
        TextSize = 24,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.fromOffset(0, 40),
        TextColor3 = Color3.new(1, 1, 1)
    })
    local v40 = react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 25,
        Size = UDim2.fromOffset(0, 120)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    }), react.createElement(default3, {
        borderColorScheme = "rainbow",
        key = "glow-no-img-rainbow",
        shape = "rounded",
        size = "medium",
        text = "Season 8",
        overrideProps = {
            LayoutOrder = 1
        }
    }), react.createElement(default3, {
        borderColorScheme = "orange-red",
        key = "glow-no-img-orange-red",
        shape = "rounded",
        size = "medium",
        text = "Quests",
        overrideProps = {
            LayoutOrder = 2
        }
    }), react.createElement(default3, {
        borderColorScheme = "teal-blue",
        key = "glow-no-img-teal-blue",
        shape = "rounded",
        size = "medium",
        text = "Profile",
        overrideProps = {
            LayoutOrder = 3
        }
    }), react.createElement(default3, {
        borderColorScheme = "purple-magenta",
        key = "glow-no-img-purple-magenta",
        shape = "rounded",
        size = "medium",
        text = "Events",
        overrideProps = {
            LayoutOrder = 4
        }
    }), react.createElement(default3, {
        borderColorScheme = "lime-yellow",
        key = "glow-no-img-lime-yellow",
        shape = "rounded",
        size = "medium",
        text = "Trade",
        overrideProps = {
            LayoutOrder = 5
        }
    }))
    local v41 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local v42 = react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Text = "Sizes:",
        TextSize = 18,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.fromOffset(100, 40),
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local v43 = table.create(#t1)

    local function v44(p10, p11) -- line: 383
        -- upvalues: react (copy), default3 (copy)
        local createElement = react.createElement
        local t9 = {
            borderColorScheme = "rainbow",
            shape = "rounded",
            key = ("glow-size-%*"):format(p10),
            overrideProps = {
                LayoutOrder = p11 + 1
            },
            size = p10
        }
        local v45 = tostring(p10)

        t9.text = string.upper(v45)

        return createElement(default3, t9)
    end

    for v46, v47 in t1 do
        v43[v46] = v44(v47, v46 - 1, t1)
    end

    local v48 = react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 26,
        Size = UDim2.fromOffset(0, 120)
    }, v41, v42, v43)
    local v49 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local v50 = react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Text = "States:",
        TextSize = 18,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.fromOffset(100, 40),
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local v51 = table.create(#t2)

    local function v52(p12, p13) -- line: 422
        -- upvalues: react (copy), default3 (copy)
        local createElement = react.createElement
        local t10 = {
            borderColorScheme = "rainbow",
            shape = "rounded",
            size = "medium",
            key = ("glow-state-%*"):format(p12),
            overrideProps = {
                LayoutOrder = p13 + 1
            },
            state = p12
        }
        local v53 = tostring(p12)

        t10.text = string.upper(v53)

        return createElement(default3, t10)
    end

    for v54, v55 in t2 do
        v51[v54] = v52(v55, v54 - 1, t2)
    end

    local v56 = react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 27,
        Size = UDim2.fromOffset(0, 120)
    }, v49, v50, v51)
    local v57 = react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 28,
        Size = UDim2.fromOffset(0, 60)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Text = "Glossy Buttons",
        TextSize = 24,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.fromOffset(200, 40),
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left
    }))
    local v58 = react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 29,
        Size = UDim2.fromOffset(0, 60)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    }), react.createElement(default4, {
        key = "glossy-preview",
        size = "medium",
        text = "Preview",
        onClick = function() -- onClick | line: 475
            return print("Glossy button clicked!")
        end,
        overrideProps = {
            LayoutOrder = 1
        }
    }), react.createElement(default4, {
        key = "glossy-submit",
        size = "medium",
        text = "Submit",
        onClick = function() -- onClick | line: 485
            return print("Submit clicked!")
        end,
        overrideProps = {
            LayoutOrder = 2
        }
    }), react.createElement(default4, {
        key = "glossy-cancel",
        size = "medium",
        text = "Cancel",
        onClick = function() -- onClick | line: 495
            return print("Cancel clicked!")
        end,
        overrideProps = {
            LayoutOrder = 3
        }
    }))
    local v59 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local v60 = react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Text = "Sizes:",
        TextSize = 18,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.fromOffset(100, 40),
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local v61 = table.create(#t1)

    local function v62(p14, p15) -- line: 522
        -- upvalues: react (copy), default4 (copy)
        local createElement = react.createElement
        local t11 = {
            key = ("glossy-size-%*"):format(p14)
        }

        function t11.onClick() -- line: 525
            -- upvalues: p14 (copy)
            return print((("%* button clicked!"):format(p14)))
        end

        t11.overrideProps = {
            LayoutOrder = p15 + 1
        }
        t11.size = p14

        local v63 = tostring(p14)

        t11.text = string.upper(v63)

        return createElement(default4, t11)
    end

    for v64, v65 in t1 do
        v61[v64] = v62(v65, v64 - 1, t1)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.new(0.1, 0.1, 0.1),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("scrollingframe", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 8,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.fromScale(0, 0),
        Size = UDim2.fromScale(1, 1)
    }, v2, v3, v11, v19, v27, v35, v36, v37, v38, v39, v40, v48, v56, v57, v58, react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 30,
        Size = UDim2.fromOffset(0, 60)
    }, v59, v60, v61), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 31,
        Size = UDim2.fromOffset(0, 60)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Text = "States:",
        TextSize = 18,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.fromOffset(100, 40),
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left
    }), react.createElement(default4, {
        key = "glossy-state-default",
        size = "medium",
        state = "default",
        text = "Default",
        onClick = function() -- onClick | line: 575
            return print("Default button clicked!")
        end,
        overrideProps = {
            LayoutOrder = 1
        }
    }), react.createElement(default4, {
        key = "glossy-state-disabled",
        size = "medium",
        state = "disabled",
        text = "Disabled",
        onClick = function() -- onClick | line: 586
            return print("Disabled button clicked!")
        end,
        overrideProps = {
            LayoutOrder = 2
        }
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 32,
        Size = UDim2.fromOffset(0, 60)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Text = "Glossy Button Colors",
        TextSize = 24,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.fromOffset(200, 40),
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 33,
        Size = UDim2.fromScale(1, 0.3)
    }, react.createElement("uilistlayout", {
        Wraps = true,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top
    }), react.createElement(default4, {
        key = "glossy-color-gray",
        size = "medium",
        text = "Gray",
        backgroundColor = Color3.new(0.75, 0.75, 0.75),
        onClick = function() -- onClick | line: 628
            return print("Gray button clicked!")
        end,
        overrideProps = {
            LayoutOrder = 1
        }
    }), react.createElement(default4, {
        key = "glossy-color-blue",
        size = "medium",
        text = "Blue",
        backgroundColor = Color3.new(0.2, 0.4, 0.8),
        onClick = function() -- onClick | line: 639
            return print("Blue button clicked!")
        end,
        overrideProps = {
            LayoutOrder = 2
        }
    }), react.createElement(default4, {
        key = "glossy-color-red",
        size = "medium",
        text = "Red",
        backgroundColor = Color3.new(0.8, 0.2, 0.2),
        onClick = function() -- onClick | line: 650
            return print("Red button clicked!")
        end,
        overrideProps = {
            LayoutOrder = 3
        }
    }), react.createElement(default4, {
        key = "glossy-color-green",
        size = "medium",
        text = "Green",
        backgroundColor = Color3.new(0.2, 0.7, 0.3),
        onClick = function() -- onClick | line: 661
            return print("Green button clicked!")
        end,
        overrideProps = {
            LayoutOrder = 4
        }
    }), react.createElement(default4, {
        key = "glossy-color-purple",
        size = "medium",
        text = "Purple",
        backgroundColor = Color3.new(0.6, 0.2, 0.8),
        onClick = function() -- onClick | line: 672
            return print("Purple button clicked!")
        end,
        overrideProps = {
            LayoutOrder = 5
        }
    }), react.createElement(default4, {
        key = "glossy-color-orange",
        size = "medium",
        text = "Orange",
        backgroundColor = Color3.new(0.8, 0.5, 0.2),
        onClick = function() -- onClick | line: 683
            return print("Orange button clicked!")
        end,
        overrideProps = {
            LayoutOrder = 6
        }
    }), react.createElement(default4, {
        key = "glossy-color-cyan",
        size = "medium",
        text = "Cyan",
        backgroundColor = Color3.new(0.2, 0.6, 0.8),
        onClick = function() -- onClick | line: 694
            return print("Cyan button clicked!")
        end,
        overrideProps = {
            LayoutOrder = 7
        }
    }), react.createElement(default4, {
        key = "glossy-color-yellow",
        size = "medium",
        text = "Yellow",
        backgroundColor = Color3.new(0.8, 0.8, 0.2),
        onClick = function() -- onClick | line: 705
            return print("Yellow button clicked!")
        end,
        overrideProps = {
            LayoutOrder = 8
        }
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 34,
        Size = UDim2.fromScale(1, 0.3)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Text = "Close Buttons",
        TextSize = 24,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.fromOffset(200, 40),
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 35,
        Size = UDim2.fromScale(1, 0.3)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Text = "Sizes:",
        TextSize = 18,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.fromOffset(100, 40),
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left
    }), react.createElement(default5, {
        key = "close-size-small",
        onClick = function() -- onClick | line: 752
            return print("Small close button clicked!")
        end,
        overrideProps = {
            LayoutOrder = 1
        },
        size = UDim2.fromScale(1, 1)
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 36,
        Size = UDim2.fromOffset(0, 80)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Text = "States:",
        TextSize = 18,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.fromOffset(100, 40),
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left
    }), react.createElement(default5, {
        key = "close-state-default",
        state = "default",
        onClick = function() -- onClick | line: 779
            return print("Default close button clicked!")
        end,
        overrideProps = {
            LayoutOrder = 1
        },
        size = UDim2.fromScale(0.07, 0.07)
    }), react.createElement(default5, {
        key = "close-state-hover",
        state = "hover",
        onClick = function() -- onClick | line: 789
            return print("Hover close button clicked!")
        end,
        overrideProps = {
            LayoutOrder = 2
        },
        size = UDim2.fromScale(0.07, 0.07)
    }), react.createElement(default5, {
        key = "close-state-disabled",
        state = "disabled",
        onClick = function() -- onClick | line: 799
            return print("Disabled close button clicked!")
        end,
        overrideProps = {
            LayoutOrder = 3
        },
        size = UDim2.fromScale(0.07, 0.07)
    }))))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(ButtonShowcase)))
