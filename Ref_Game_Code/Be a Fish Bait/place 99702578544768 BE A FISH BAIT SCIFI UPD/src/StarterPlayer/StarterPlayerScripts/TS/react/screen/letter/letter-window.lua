-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-button").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local v1 = Color3.fromRGB(28, 17, 8)
local v2 = Color3.fromRGB(35, 22, 8)
local v3 = Color3.fromRGB(10, 6, 3)

local function CloseButton(p1) -- line: 13
    -- upvalues: react (copy), default (copy), default2 (copy), useTheme (copy)
    local onClick = p1.onClick
    local v4 = useTheme()

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 10,
        AnchorPoint = Vector2.new(0, 0),
        Position = UDim2.fromScale(1.015, 0.055),
        Size = UDim2.fromScale(0.075, 0.1)
    }, react.createElement(default, {
        aspectRatio = 1,
        cornerRadius = 0.1,
        zIndex = 10,
        anchorPoint = Vector2.new(0.5, 0.5),
        color = Color3.fromRGB(255, 43, 43),
        onClick = onClick,
        popoutColor = Color3.fromRGB(122, 31, 31),
        position = UDim2.fromScale(0.5, 0.5),
        size = UDim2.fromScale(1, 1),
        strokeColor = Color3.fromRGB(255, 179, 179)
    }, react.createElement(default2, {
        shadowYScale = 0.075,
        text = "X",
        anchorPoint = Vector2.new(0.5, 0.5),
        color = Color3.new(1, 1, 1),
        overrideProps = {
            TextScaled = true,
            ZIndex = 12,
            Font = v4.textFont2,
            Size = UDim2.fromScale(0.8, 0.8)
        },
        position = UDim2.fromScale(0.5, 0.5)
    })))
end

return {
    default = function(p2) -- LetterWindow | line: 48
        -- upvalues: react (copy), images (copy), v1 (copy), v2 (copy), v3 (copy), CloseButton (copy)
        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.7, 0.84)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1.3
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.oldLetter,
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Stretch,
            Size = UDim2.fromScale(1, 1)
        }), react.createElement(CloseButton, {
            onClick = p2.onClose
        }), react.createElement("scrollingframe", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ScrollBarThickness = 6,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(),
            Position = UDim2.fromScale(0.515, 0.5),
            ScrollBarImageColor3 = Color3.fromRGB(120, 90, 50),
            ScrollingDirection = Enum.ScrollingDirection.Y,
            Size = UDim2.fromScale(0.55, 0.5)
        }, react.createElement("uipadding", {
            PaddingBottom = UDim.new(0, 12),
            PaddingLeft = UDim.new(0, 16),
            PaddingRight = UDim.new(0, 16),
            PaddingTop = UDim.new(0, 12)
        }), react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Top
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Size = UDim2.new(1, 0, 0, 38)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = UDim.new(0, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom
        }), react.createElement("textlabel", {
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Text = "Dear ",
            TextSize = 32,
            TextStrokeTransparency = 0.55,
            AutomaticSize = Enum.AutomaticSize.X,
            Font = Enum.Font.PatrickHand,
            Size = UDim2.fromScale(0, 1),
            TextColor3 = v1,
            TextStrokeColor3 = v3,
            TextXAlignment = Enum.TextXAlignment.Left
        }), react.createElement("textlabel", {
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            TextSize = 32,
            AutomaticSize = Enum.AutomaticSize.X,
            Font = Enum.Font.PatrickHand,
            Size = UDim2.fromScale(0, 1),
            Text = p2.recipientName,
            TextColor3 = p2.recipientColor,
            TextXAlignment = Enum.TextXAlignment.Left
        }, react.createElement("uistroke", {
            Thickness = 1.5,
            Transparency = 0,
            Color = v2
        })), react.createElement("textlabel", {
            BackgroundTransparency = 1,
            LayoutOrder = 3,
            Text = ",",
            TextSize = 32,
            TextStrokeTransparency = 0.55,
            AutomaticSize = Enum.AutomaticSize.X,
            Font = Enum.Font.PatrickHand,
            Size = UDim2.fromScale(0, 1),
            TextColor3 = v1,
            TextStrokeColor3 = v3,
            TextXAlignment = Enum.TextXAlignment.Left
        })), react.createElement("textlabel", {
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            LineHeight = 1.1,
            RichText = true,
            TextSize = 32,
            TextStrokeTransparency = 0.55,
            TextWrapped = true,
            AutomaticSize = Enum.AutomaticSize.Y,
            Font = Enum.Font.PatrickHand,
            Size = UDim2.fromScale(1, 0),
            Text = p2.bodyRichText,
            TextColor3 = v1,
            TextStrokeColor3 = v3,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top
        })))
    end
}
