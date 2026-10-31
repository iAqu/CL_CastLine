-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local rarityColors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").rarityColors

return {
    default = function(p1) -- ItemRarityOverlay | line: 6
        -- upvalues: react (copy), images (copy), rarityColors (copy)
        local cornerRadius, rarity, zIndex = p1.cornerRadius, p1.rarity, p1.zIndex

        if zIndex == nil then
            zIndex = 4
        end

        local v1 = UDim.new(0, cornerRadius)

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            ZIndex = zIndex
        }, react.createElement("uicorner", {
            CornerRadius = v1
        }), rarity == "godly" and react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0,
            ScaleType = "Stretch",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.fadedBottomBorder,
            ImageColor3 = Color3.fromRGB(255, 209, 66),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            ZIndex = zIndex
        }, react.createElement("uicorner", {
            CornerRadius = v1
        })), rarity == "secret" and react.createElement(react.Fragment, nil, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ScaleType = "Stretch",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.secretBackground,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            ZIndex = zIndex - 1
        }, react.createElement("uicorner", {
            CornerRadius = v1
        })), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ScaleType = "Stretch",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.fadedBottomBorder,
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            ZIndex = zIndex
        }, react.createElement("uicorner", {
            CornerRadius = v1
        }))), rarity == "hacked" and react.createElement(react.Fragment, nil, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0,
            ScaleType = "Stretch",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.hackedBackground,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            ZIndex = zIndex
        }, react.createElement("uicorner", {
            CornerRadius = v1
        })), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0.6,
            ScaleType = "Stretch",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.fadedBottomBorder,
            ImageColor3 = Color3.fromRGB(0, 161, 41),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            ZIndex = zIndex
        }, react.createElement("uicorner", {
            CornerRadius = v1
        }))), rarity == "cosmic" and react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0.4,
            ScaleType = "Stretch",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.cosmicBackground,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            ZIndex = zIndex
        }, react.createElement("uicorner", {
            CornerRadius = v1
        })), rarity == "extinct" and react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ScaleType = "Stretch",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.extinctBackgroundWithoutSun,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            ZIndex = zIndex + 3
        }, react.createElement("uicorner", {
            CornerRadius = v1
        })), rarity == "kaijuwu" and react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ScaleType = "Stretch",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.kaijuwuBackgroundWithoutCharacter,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            ZIndex = zIndex
        }, react.createElement("uicorner", {
            CornerRadius = v1
        })), rarity == "scifi" and react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ScaleType = "Stretch",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.scifiBackgroundWithoutCharacter,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            ZIndex = zIndex
        }, react.createElement("uicorner", {
            CornerRadius = v1
        })), rarity ~= "godly" and rarity ~= "secret" and rarity ~= "hacked" and rarity ~= "cosmic" and rarity ~= "extinct" and rarity ~= "kaijuwu" and rarity ~= "scifi" and react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0.4,
            ScaleType = "Stretch",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.fadedBottomBorder,
            ImageColor3 = rarityColors[rarity],
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            ZIndex = zIndex
        }, react.createElement("uicorner", {
            CornerRadius = v1
        })))
    end
}
