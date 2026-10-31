-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 220, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 175, 20))
})
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(110, 116, 130)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(64, 68, 80))
})
local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 180)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 40, 140))
})

return {
    default = function(p1) -- StorePurchaseConfirmationModal | line: 10
        -- upvalues: react (copy), default (copy), default2 (copy), default3 (copy), v1 (copy), v2 (copy), v3 (copy)
        local v4, v5

        if p1.recipientName ~= nil then
            v5 = v3
            v4 = ("Gift %*\nto %*?"):format(p1.title, p1.recipientName)
        else
            v5 = v1
            v4 = ("Give yourself\n%*?"):format(p1.title)
        end

        return react.createElement("frame", {
            Active = true,
            BackgroundTransparency = 0.45,
            BorderSizePixel = 0,
            ZIndex = 200,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement(default, {
            cornerRadius = 0.06,
            isStudded = true,
            isStuddedTransparency = 0.2,
            textureTransparency = 0.85,
            tileSize = 100,
            transparency = 0.3,
            zIndex = 201,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor = Color3.fromRGB(28, 32, 44),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(0.36, 0.4)
        }, react.createElement("uistroke", {
            Thickness = 0.025,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Color3.fromRGB(255, 255, 255),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        }, react.createElement("uigradient", {
            Rotation = 90,
            Color = v5
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 202,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.965, 0.965)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.055, 0)
        }), react.createElement("uistroke", {
            Thickness = 0.012,
            Transparency = 0.78,
            Color = Color3.fromRGB(255, 255, 255),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 203,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement(default2, {
            anchorPoint = Vector2.new(0.5, 0),
            color = v5,
            overrideProps = {
                TextScaled = true,
                TextWrapped = true,
                ZIndex = 203,
                Size = UDim2.fromScale(0.85, 0.44)
            },
            position = UDim2.fromScale(0.5, 0.14),
            strokeProps = {
                Thickness = 0.07
            },
            text = v4
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 203,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.92),
            Size = UDim2.fromScale(0.9, 0.28)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.06, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement(default3, {
            cornerRadius = 0.22,
            label = "Confirm",
            layoutOrder = 0,
            zIndex = 204,
            color = v1,
            frameSize = UDim2.fromScale(0.46, 0.85),
            onClick = p1.onConfirm,
            popoutColor = Color3.fromRGB(10, 120, 10)
        }), react.createElement(default3, {
            cornerRadius = 0.22,
            label = "Cancel",
            layoutOrder = 1,
            zIndex = 204,
            color = v2,
            frameSize = UDim2.fromScale(0.46, 0.85),
            onClick = p1.onCancel,
            popoutColor = Color3.fromRGB(40, 43, 52)
        })))))
    end
}
