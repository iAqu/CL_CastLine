-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local rarityColors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").rarityColors
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 55)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(193, 193, 193)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(193, 193, 193)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(55, 55, 55))
})

return {
    default = function(p1) -- ZoneGachaCard | line: 8
        -- upvalues: react (copy), default (copy), images (copy), rarityColors (copy), v1 (copy)
        local data, isOwned, layoutOrder, onClick = p1.data, p1.isOwned, p1.layoutOrder, p1.onClick
        local v2 = rarityColors[data.rarity]

        return react.createElement(default, {
            cornerRadius = 0.06,
            strokeThickness = 0.025,
            transparency = 0,
            zIndex = 130,
            backgroundColor = v1,
            layoutOrder = layoutOrder,
            size = UDim2.fromScale(1, 1),
            strokeColor = Color3.fromRGB(20, 20, 20)
        }, react.createElement(default, {
            clipsDescendants = true,
            cornerRadius = 0.09,
            strokeThickness = 0.02,
            transparency = 0,
            zIndex = 131,
            anchorPoint = Vector2.new(0.5, 0),
            backgroundColor = Color3.fromRGB(9, 12, 18),
            position = UDim2.fromScale(0.5, 0.08),
            size = UDim2.fromScale(0.7, 0.55),
            strokeColor = v2
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 132,
            Image = data.imageId,
            Position = UDim2.fromScale(0.05, 0.05),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.9, 0.9)
        })), isOwned and react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 133,
            AnchorPoint = Vector2.new(1, 0),
            Image = images.checkmarkIcon,
            ImageColor3 = Color3.fromRGB(80, 255, 120),
            Position = UDim2.fromScale(0.98, 0.02),
            Size = UDim2.fromScale(0.16, 0.16)
        }), react.createElement("textlabel", {
            BackgroundTransparency = 1,
            TextScaled = true,
            TextStrokeTransparency = 0.15,
            ZIndex = 131,
            Font = Enum.Font.GothamBlack,
            Position = UDim2.fromScale(0.05, 0.66),
            Size = UDim2.fromScale(0.9, 0.14),
            Text = data.displayName,
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }), react.createElement("textlabel", {
            BackgroundTransparency = 1,
            TextScaled = true,
            TextStrokeTransparency = 0.2,
            ZIndex = 131,
            Font = Enum.Font.GothamBold,
            Position = UDim2.fromScale(0.05, 0.81),
            Size = UDim2.fromScale(0.9, 0.14),
            Text = ("%*%%"):format(data.chancePercent),
            TextColor3 = Color3.fromRGB(105, 232, 255)
        }), react.createElement("imagebutton", {
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            ZIndex = 135,
            Event = {
                Activated = function(p2) -- Activated | line: 74
                    -- upvalues: onClick (copy)
                    return onClick(p2)
                end
            },
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.fromScale(1, 1)
        }))
    end
}
