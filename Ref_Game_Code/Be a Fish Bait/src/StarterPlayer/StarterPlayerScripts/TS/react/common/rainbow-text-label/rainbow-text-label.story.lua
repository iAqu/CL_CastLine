-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent, "rainbow-text-label").default

local function RainbowTextLabelShowcase() -- line: 7
    -- upvalues: react (copy), default2 (copy)
    return react.createElement("frame", {
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.new(0.1, 0.1, 0.1),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("scrollingframe", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.fromScale(0, 0),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 30),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top
    }), react.createElement("uipadding", {
        PaddingBottom = UDim.new(0, 20),
        PaddingLeft = UDim.new(0, 20),
        PaddingRight = UDim.new(0, 20),
        PaddingTop = UDim.new(0, 20)
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Text = "Rainbow Text Label Showcase",
        TextSize = 32,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.fromOffset(0, 50),
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Center
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Size = UDim2.fromOffset(0, 100)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 20),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Text = "Default Speed (1x)",
        TextSize = 20,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.fromOffset(0, 30),
        TextColor3 = Color3.new(0.8, 0.8, 0.8),
        TextXAlignment = Enum.TextXAlignment.Center
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default2, {
        text = "Rainbow Text Label",
        size = UDim2.fromScale(0.8, 0.1)
    }))), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        Size = UDim2.fromOffset(0, 100)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 20),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Text = "Slow Speed (0.5x)",
        TextSize = 20,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.fromOffset(0, 30),
        TextColor3 = Color3.new(0.8, 0.8, 0.8),
        TextXAlignment = Enum.TextXAlignment.Center
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default2, {
        speed = 0.5,
        text = "Slow Rainbow Animation",
        size = UDim2.fromScale(0.8, 0.1)
    }))), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 3,
        Size = UDim2.fromScale(1, 0.2)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 20),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Text = "Fast Speed (2x)",
        TextSize = 20,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.fromOffset(0, 30),
        TextColor3 = Color3.new(0.8, 0.8, 0.8),
        TextXAlignment = Enum.TextXAlignment.Center
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default2, {
        speed = 0.5,
        text = "Fast Rainbow Animation",
        size = UDim2.fromScale(0.8, 0.1)
    }))), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 4,
        Size = UDim2.fromOffset(0, 200)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 20),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Text = "Different Sizes",
        TextSize = 20,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.fromOffset(0, 30),
        TextColor3 = Color3.new(0.8, 0.8, 0.8),
        TextXAlignment = Enum.TextXAlignment.Center
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default2, {
        text = "Large Rainbow Text",
        size = UDim2.fromScale(0.9, 0.15)
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default2, {
        text = "Medium Rainbow Text",
        size = UDim2.fromScale(0.7, 0.08)
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 3,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default2, {
        text = "Small Rainbow Text",
        size = UDim2.fromScale(0.5, 0.05)
    }))), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 5,
        Size = UDim2.fromOffset(0, 200)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 20),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Text = "Different Text Content",
        TextSize = 20,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.fromOffset(0, 30),
        TextColor3 = Color3.new(0.8, 0.8, 0.8),
        TextXAlignment = Enum.TextXAlignment.Center
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default2, {
        text = "Hello, World!",
        size = UDim2.fromScale(0.8, 0.1)
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default2, {
        text = "Rainbow Gradient Effect",
        size = UDim2.fromScale(0.8, 0.1)
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 3,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default2, {
        text = "Animated Colors",
        size = UDim2.fromScale(0.8, 0.1)
    })))))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement(RainbowTextLabelShowcase)))
