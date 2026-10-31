-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-window").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local useFreePurchaseModeEnabled = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-free-purchase-mode").useFreePurchaseModeEnabled

return {
    default = function(p1) -- OfflineEarningsWindow | line: 11
        -- upvalues: react (copy), default (copy), default2 (copy), default3 (copy), images (copy), useTheme (copy), abbreviate (copy), useFreePurchaseModeEnabled (copy)
        local v1 = useTheme()
        local v2 = useFreePurchaseModeEnabled()
        local v3 = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 220, 60)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 255, 80))
        })
        local v4 = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 40)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 140, 20))
        })

        return react.createElement(default, {
            aspectRatio = 1.25,
            title = "Welcome Back!",
            bodyBg = Color3.fromRGB(8, 8, 12),
            headerBg = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(52, 175, 230)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 120, 200))
            }),
            onClose = p1.onClose,
            size = UDim2.fromScale(0.42, 0.58)
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.cashPile,
            Position = UDim2.fromScale(0.5, 0.42),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.7, 0.52)
        }), react.createElement(default3, {
            text = "OFFLINE EARNINGS",
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 4,
                AnchorPoint = Vector2.new(0.5, 1),
                Font = v1.textFont2,
                Position = UDim2.fromScale(0.5, 0.24),
                Size = UDim2.fromScale(0.72, 0.12),
                TextXAlignment = Enum.TextXAlignment.Center
            }
        }), react.createElement(default3, {
            color = v3,
            overrideProps = {
                TextScaled = true,
                ZIndex = 5,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Font = v1.textFont2,
                Position = UDim2.fromScale(0.5, 0.6),
                Size = UDim2.fromScale(0.55, 0.13),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            text = ("$%*"):format((abbreviate(p1.amount)))
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.94),
            Size = UDim2.fromScale(0.9, 0.3)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.04, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            ZIndex = 3,
            Size = UDim2.fromScale(0.55, 1)
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.fromScale(0.04, 0.38),
            Size = UDim2.fromScale(0.6, 0.265)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = UDim.new(0, 4),
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            Image = "rbxasset://textures/ui/common/robux@2x.png",
            LayoutOrder = 1,
            ZIndex = 5,
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.3, 1)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })), react.createElement(default3, {
            color = Color3.new(1, 1, 1),
            overrideProps = {
                LayoutOrder = 2,
                TextScaled = true,
                ZIndex = 5,
                Font = v1.textFont2,
                Size = UDim2.fromScale(0.6, 1),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            text = if v2 then "FREE" else tostring(p1.robuxCost)
        })), react.createElement(default2, {
            isStudded = true,
            label = "Claim x10!",
            zIndex = 3,
            anchorPoint = Vector2.new(0.5, 1),
            color = v4,
            font = v1.textFont2,
            frameSize = UDim2.fromScale(1, 0.68),
            onClick = p1.onClaimMultiply,
            popoutColor = Color3.fromRGB(180, 100, 10),
            position = UDim2.fromScale(0.5, 1)
        })), react.createElement(default2, {
            isStudded = true,
            label = "Claim!",
            layoutOrder = 2,
            zIndex = 3,
            anchorPoint = Vector2.new(0.5, 1),
            color = v3,
            font = v1.textFont2,
            frameSize = UDim2.fromScale(0.41, 0.68),
            onClick = p1.onClaim,
            popoutColor = Color3.fromRGB(30, 120, 30),
            position = UDim2.fromScale(0.5, 1)
        })))
    end
}
