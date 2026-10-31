-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default2 = RuntimeLib.import(script, script.Parent, "medium-shop-section").default
local default3 = RuntimeLib.import(script, script.Parent, "small-shop-section").default
local default4 = RuntimeLib.import(script, script.Parent, "long-shop-section").default

local function clamp(p1, p2, p3) -- line: 16
    if p1 < p2 then
        return p2
    end

    if p3 < p1 then
        return p3
    end

    return p1
end

local t7 = {
    {
        id = "longBlue",
        label = "LongBlueSection",
        defaultWidth = 0.45,
        defaultHeight = 0.24,
        render = function() -- render | line: 31
            -- upvalues: react (copy), default4 (copy)
            return react.createElement(default4, {
                sectionType = "LongBlueSection"
            })
        end
    },
    {
        id = "longYellow",
        label = "LongYellowSection",
        defaultWidth = 0.45,
        defaultHeight = 0.24,
        render = function() -- render | line: 41
            -- upvalues: react (copy), default4 (copy)
            return react.createElement(default4, {
                sectionType = "LongYellowSection"
            })
        end
    },
    {
        id = "mediumBlue",
        label = "MediumBlueSection",
        defaultWidth = 0.32,
        defaultHeight = 0.28,
        render = function() -- render | line: 51
            -- upvalues: react (copy), default2 (copy)
            return react.createElement(default2, {
                sectionType = "MediumBlueSection"
            })
        end
    },
    {
        id = "mediumGreen",
        label = "MediumGreenSection",
        defaultWidth = 0.32,
        defaultHeight = 0.28,
        render = function() -- render | line: 61
            -- upvalues: react (copy), default2 (copy)
            return react.createElement(default2, {
                sectionType = "MediumGreenSection"
            })
        end
    },
    {
        id = "mediumYellow",
        label = "MediumYellowSection",
        defaultWidth = 0.32,
        defaultHeight = 0.28,
        render = function() -- render | line: 71
            -- upvalues: react (copy), default2 (copy)
            return react.createElement(default2, {
                sectionType = "MediumYellowSection"
            })
        end
    },
    {
        id = "smallYellow",
        label = "SmallYellowSection",
        defaultWidth = 0.18,
        defaultHeight = 0.28,
        render = function() -- render | line: 81
            -- upvalues: react (copy), default3 (copy)
            return react.createElement(default3, {
                sectionType = "SmallYellowSection"
            })
        end
    }
}

local function StepperButton(p4) -- line: 87
    -- upvalues: react (copy)
    return react.createElement("textbutton", {
        TextSize = 20,
        BackgroundColor3 = Color3.fromRGB(70, 70, 80),
        Event = {
            Activated = p4.onClick
        },
        Font = Enum.Font.GothamBold,
        Size = UDim2.fromOffset(26, 26),
        Text = p4.text,
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.2, 0)
    }))
end

local function Controls(p5) -- line: 102
    -- upvalues: react (copy), StepperButton (copy)
    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Size = UDim2.fromOffset(170, 26),
        Text = p5.label,
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Text = "W",
        TextSize = 16,
        Font = Enum.Font.Code,
        Size = UDim2.fromOffset(40, 26),
        TextColor3 = Color3.fromRGB(180, 200, 255)
    }), react.createElement(StepperButton, {
        text = "-",
        onClick = function() -- onClick | line: 129
            -- upvalues: p5 (copy)
            return p5.onAdjustWidth(-0.01)
        end
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 3,
        TextSize = 16,
        Font = Enum.Font.Code,
        Size = UDim2.fromOffset(52, 26),
        Text = string.format("%.2f", p5.size.width),
        TextColor3 = Color3.new(1, 1, 1)
    }), react.createElement(StepperButton, {
        text = "+",
        onClick = function() -- onClick | line: 142
            -- upvalues: p5 (copy)
            return p5.onAdjustWidth(0.01)
        end
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 5,
        Text = "H",
        TextSize = 16,
        Font = Enum.Font.Code,
        Size = UDim2.fromOffset(40, 26),
        TextColor3 = Color3.fromRGB(255, 220, 180)
    }), react.createElement(StepperButton, {
        text = "-",
        onClick = function() -- onClick | line: 155
            -- upvalues: p5 (copy)
            return p5.onAdjustHeight(-0.01)
        end
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 7,
        TextSize = 16,
        Font = Enum.Font.Code,
        Size = UDim2.fromOffset(52, 26),
        Text = string.format("%.2f", p5.size.height),
        TextColor3 = Color3.new(1, 1, 1)
    }), react.createElement(StepperButton, {
        text = "+",
        onClick = function() -- onClick | line: 168
            -- upvalues: p5 (copy)
            return p5.onAdjustHeight(0.01)
        end
    }))
end

local function SectionRow(p6) -- line: 174
    -- upvalues: react (copy), Controls (copy)
    local function v10(p7) -- line: 175
        -- upvalues: p6 (copy)
        return p6.onResize(p6.def.id, p7)
    end

    local v12 = math.floor(p6.size.width * 900)
    local v14 = math.floor(p6.size.height * 900)

    return react.createElement("frame", {
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.fromRGB(40, 40, 48),
        Size = UDim2.new(1, 0, 0, 0)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 6)
    }), react.createElement("uipadding", {
        PaddingBottom = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 8)
    }), react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    }), react.createElement(Controls, {
        label = p6.def.label,
        onAdjustHeight = function(p8) -- onAdjustHeight | line: 199
            -- upvalues: p6 (copy), v10 (copy)
            local t15 = {
                width = p6.size.width
            }
            local v18 = p6.size.height + p8

            if v18 < 0.04 then
                v18 = 0.04
            elseif v18 > 0.6 then
                v18 = 0.6
            end

            t15.height = v18

            return v10(t15)
        end,
        onAdjustWidth = function(p9) -- onAdjustWidth | line: 205
            -- upvalues: p6 (copy), v10 (copy)
            local v19 = p6.size.width + p9

            if v19 < 0.05 then
                v19 = 0.05
            elseif v19 > 1 then
                v19 = 1
            end

            return v10({
                width = v19,
                height = p6.size.height
            })
        end,
        size = p6.size
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Size = UDim2.fromOffset(v12, v14)
    }, p6.def.render()))
end

local function AllSectionsBoard() -- line: 218
    -- upvalues: react (copy), useState (copy), t7 (copy), SectionRow (copy)
    local v20, v21 = useState(function() -- line: 219
        -- upvalues: t7 (copy)
        local t17 = {}

        for v22, v23 in t7 do
            local _ = v22 - 1

            t17[v23.id] = {
                width = v23.defaultWidth,
                height = v23.defaultHeight
            }
        end

        return t17
    end)

    local function v24(p10, p11) -- line: 234
        -- upvalues: v21 (copy)
        return v21(function(p12) -- line: 235
            -- upvalues: p10 (copy), p11 (copy)
            local v25 = table.clone(p12)

            setmetatable(v25, nil)
            v25[p10] = p11

            return v25
        end)
    end

    local v26 = react.createElement("uipadding", {
        PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 12)
    })
    local v27 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local v28 = table.create(#t7)

    for v29, v30 in t7 do
        local _ = v29 - 1

        v28[v29] = react.createElement(SectionRow, {
            def = v30,
            key = v30.id,
            onResize = v24,
            size = v20[v30.id]
        })
    end

    return react.createElement("scrollingframe", {
        Active = true,
        BorderSizePixel = 0,
        ScrollBarThickness = 8,
        AnchorPoint = Vector2.new(0.5, 0.5),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.fromRGB(25, 25, 30),
        CanvasSize = UDim2.new(),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.6, 0.95)
    }, v26, v27, v28)
end

return storyForScreenGui(react.createElement(default, {
    initialState = {}
}, react.createElement(AllSectionsBoard)))
