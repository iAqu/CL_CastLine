-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent, "cyt-button").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local defaultTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "theme-context").defaultTheme

return storyForScreenGui(react.createElement(default2, {
    initialState = {}
}, react.createElement("frame", {
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromScale(1, 1)
}, react.createElement("uilistlayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    Padding = UDim.new(0, 20),
    SortOrder = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Center
}), react.createElement(default, {
    layoutOrder = 1,
    borderColor = Color3.fromRGB(0, 0, 0),
    colorSequence = defaultTheme.colorSequences.blueGradient,
    onClick = function() -- onClick | line: 25
        print("Button 1 clicked!")
    end,
    size = UDim2.fromScale(0.1, 0.1)
}, react.createElement("textlabel", {
    BackgroundTransparency = 1,
    Text = "Click Me",
    TextScaled = true,
    TextStrokeTransparency = 0,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Font = defaultTheme.textFont,
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromScale(0.9, 0.9),
    TextColor3 = Color3.new(1, 1, 1),
    TextStrokeColor3 = Color3.new(0, 0, 0)
}, react.createElement("uitextsizeconstraint", {
    MaxTextSize = 32
}))), react.createElement(default, {
    layoutOrder = 2,
    borderColor = Color3.fromRGB(0, 0, 0),
    colorSequence = defaultTheme.colorSequences.greenGradient,
    onClick = function() -- onClick | line: 46
        print("Button 2 clicked!")
    end,
    size = UDim2.fromScale(0.1, 0.1)
}, react.createElement("imagelabel", {
    BackgroundTransparency = 1,
    Image = "rbxassetid://15910695828",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromScale(0.8, 0.8)
})), react.createElement(default, {
    disabled = true,
    layoutOrder = 3,
    borderColor = Color3.fromRGB(0, 0, 0),
    colorSequence = defaultTheme.colorSequences.redGradient,
    onClick = function() -- onClick | line: 61
        print("This won't fire")
    end,
    size = UDim2.fromScale(0.1, 0.1)
}, react.createElement("textlabel", {
    BackgroundTransparency = 1,
    Text = "Disabled",
    TextScaled = true,
    TextStrokeTransparency = 0,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Font = defaultTheme.textFont,
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromScale(0.9, 0.9),
    TextColor3 = Color3.new(1, 1, 1),
    TextStrokeColor3 = Color3.new(0, 0, 0)
}, react.createElement("uitextsizeconstraint", {
    MaxTextSize = 32
}))))))
