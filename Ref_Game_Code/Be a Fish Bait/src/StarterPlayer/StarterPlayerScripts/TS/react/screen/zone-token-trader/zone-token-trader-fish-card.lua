-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local useSound = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-sound").useSound
local getMutationTokenMultiplier = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "zone-token-trader").getMutationTokenMultiplier

return {
    default = function(p1) -- ZoneTokenTraderFishCard | line: 9
        -- upvalues: react (copy), default (copy), default2 (copy), useTheme (copy), useSound (copy), getMutationTokenMultiplier (copy)
        local v1 = useTheme()
        local playSound = useSound("ButtonClick").playSound

        return react.createElement(default, {
            cornerRadius = 0.06,
            isStudded = false,
            transparency = 0.1,
            zIndex = 2,
            backgroundColor = Color3.fromRGB(30, 160, 150),
            layoutOrder = p1.layoutOrder,
            size = UDim2.fromScale(1, 1)
        }, react.createElement("imagebutton", {
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            ZIndex = 3,
            Event = {
                Activated = function() -- Activated | line: 25
                    -- upvalues: p1 (copy), playSound (copy)
                    playSound()
                    p1.onClick()
                end
            },
            Size = UDim2.fromScale(1, 1)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.02, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("uipadding", {
            PaddingBottom = UDim.new(0.06, 0),
            PaddingLeft = UDim.new(0.06, 0),
            PaddingRight = UDim.new(0.06, 0),
            PaddingTop = UDim.new(0.06, 0)
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 1,
            ZIndex = 4,
            Size = UDim2.fromScale(1, 0.16)
        }, react.createElement(default2, {
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 4,
                Font = v1.textFont2,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            text = p1.name
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 2,
            ZIndex = 4,
            Size = UDim2.fromScale(1, 0.55)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = p1.imageId,
            ImageTransparency = p1.isSelected and 0.6 or 0,
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.9, 0.9)
        }), p1.isSelected and react.createElement(default2, {
            text = "X",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(230, 40, 40),
            overrideProps = {
                TextScaled = true,
                ZIndex = 6,
                Font = v1.textFont2,
                Size = UDim2.fromScale(1, 1)
            },
            position = UDim2.fromScale(0.5, 0.5),
            strokeProps = {
                Thickness = 0.08
            }
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 3,
            ZIndex = 4,
            Size = UDim2.fromScale(1, 0.14)
        }, react.createElement(default2, {
            color = Color3.fromRGB(255, 220, 90),
            overrideProps = {
                TextScaled = true,
                ZIndex = 4,
                Font = v1.textFont2,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            text = if p1.mutationCount > 0 then ("+%* (x%*)"):format(p1.tokens, (getMutationTokenMultiplier(p1.mutationCount))) else ("+%*"):format(p1.tokens)
        }))))
    end
}
