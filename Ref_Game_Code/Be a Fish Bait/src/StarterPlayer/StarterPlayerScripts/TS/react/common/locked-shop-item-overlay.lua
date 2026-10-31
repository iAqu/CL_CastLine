-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useTheme = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-theme").useTheme
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local default = RuntimeLib.import(script, script.Parent, "brainrot-style", "popout-text-two").default

return {
    default = function(p1) -- LockedShopItemOverlay | line: 7
        -- upvalues: react (copy), useTheme (copy), images (copy), default (copy)
        local displayText, zIndex = p1.displayText, p1.zIndex

        if zIndex == nil then
            zIndex = 10
        end

        local v1 = useTheme()

        return react.createElement("frame", {
            BackgroundTransparency = 0.7,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.new(0, 0, 0),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            ZIndex = zIndex
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.01, 0)
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0.2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.lockedFrame,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            ZIndex = zIndex + 1
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.45),
            Size = UDim2.fromScale(0.9, 0.25),
            ZIndex = zIndex + 2
        }, react.createElement(default, {
            shadowYScale = 0.06,
            color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 220, 220)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 130, 130))
            }),
            overrideProps = {
                TextScaled = true,
                Font = v1.textFont2,
                Size = UDim2.fromScale(1, 0.45),
                TextXAlignment = Enum.TextXAlignment.Center,
                ZIndex = zIndex + 2
            },
            popoutColor = Color3.fromRGB(40, 40, 40),
            strokeProps = {
                Thickness = 0.05
            },
            text = displayText
        })))
    end
}
