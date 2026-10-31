-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "rounded-frame").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "styled-text-label").default
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils")
local getRarityBorderColor, getRarityColor = v1.getRarityBorderColor, v1.getRarityColor
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local default5 = RuntimeLib.import(script, script.Parent.Parent, "toolbar", "item-rarity-overlay").default
local getFishMutationDisplayName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "mutations").getFishMutationDisplayName
local t1 = {
    common = "Common",
    uncommon = "Uncommon",
    rare = "Rare",
    epic = "Epic",
    legendary = "Legendary",
    mythic = "Mythic",
    godly = "Godly",
    secret = "Secret",
    hacked = "Hacked",
    cosmic = "Cosmic",
    extinct = "Extinct",
    kaijuwu = "KaijUwU",
    scifi = "Scifi",
    exclusive = "Exclusive"
}

return {
    default = function(p1) -- AquariumFishItem | line: 30
        -- upvalues: react (copy), default (copy), default2 (copy), default3 (copy), default4 (copy), getRarityBorderColor (copy), getRarityColor (copy), abbreviate (copy), default5 (copy), getFishMutationDisplayName (copy), t1 (copy)
        local detailsPosition = p1.detailsPosition

        if detailsPosition == nil then
            detailsPosition = UDim2.fromScale(0.275, 0.5)
        end

        local detailsSize = p1.detailsSize

        if detailsSize == nil then
            detailsSize = UDim2.fromScale(0.7, 0.9)
        end

        local fishName, imageId, isActive = p1.fishName, p1.imageId, p1.isActive

        if isActive == nil then
            isActive = false
        end

        local layoutOrder, level, moneyPerSecond, mutation = p1.layoutOrder, p1.level, p1.moneyPerSecond, p1.mutation
        local offlineEarningPerSec, onClick, rarity = p1.offlineEarningPerSec, p1.onClick, p1.rarity
        local v2 = ("Offline: $%*/s"):format((abbreviate(offlineEarningPerSec)))
        local v3 = ("$%*/s"):format((abbreviate(moneyPerSecond)))

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = layoutOrder,
            Size = UDim2.fromScale(1, 1)
        }, react.createElement(default, {
            cornerRadius = 0.08,
            strokeThickness = 0.008,
            zIndex = 1,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor = Color3.fromRGB(30, 35, 55),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1),
            strokeColor = Color3.fromRGB(70, 80, 110),
            transparency = isActive and 0.15 or 0.5
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(0.015, 0.5),
            Size = UDim2.fromScale(0.86, 0.86)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1,
            DominantAxis = Enum.DominantAxis.Height
        }), react.createElement(default2, {
            backgroundTransparency = 0.6,
            cornerRadius = 8,
            zIndex = 3,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor3 = Color3.fromRGB(0, 0, 0),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1)
        }, react.createElement(default2, {
            cornerRadius = 6,
            zIndex = 1,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor3 = if rarity == "godly" or rarity == "exclusive" then Color3.fromRGB(255, 255, 255) elseif rarity == "extinct" then Color3.fromRGB(0, 0, 0) else Color3.fromRGB(41, 41, 41),
            backgroundTransparency = (rarity == "godly" or rarity == "exclusive" or rarity == "extinct") and 0 or 0.6,
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(0.9, 0.9)
        }, rarity == "exclusive" and react.createElement("uigradient", {
            Rotation = 35,
            Color = getRarityColor("exclusive")
        })), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = imageId,
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.9, 0.9)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0, 6)
        })), react.createElement(default2, {
            backgroundTransparency = 1,
            cornerRadius = 8,
            anchorPoint = Vector2.new(0.5, 0.5),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(0.9, 0.9),
            zIndex = rarity == "extinct" and 6 or 4
        }, react.createElement(default5, {
            cornerRadius = 6,
            rarity = rarity
        }))), react.createElement(default4, {
            overrideProps = {
                ZIndex = 7,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Font = Enum.Font.GothamBlack,
                Position = UDim2.fromScale(0.5, 1),
                Size = UDim2.fromScale(0.88, 0.225),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = {
                Thickness = 0.07
            },
            text = v3,
            textColor3 = Color3.fromRGB(100, 255, 120)
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = detailsPosition,
            Size = detailsSize
        }, react.createElement(default3, {
            shadowYScale = 0.06,
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 4,
                AnchorPoint = Vector2.new(0, 0),
                Font = Enum.Font.GothamBlack,
                Position = UDim2.fromScale(0, 0),
                Size = UDim2.fromScale(0.6, 0.3),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            strokeProps = {
                Thickness = 0.06,
                StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
            },
            text = fishName
        }), level ~= nil and react.createElement(default4, {
            overrideProps = {
                ZIndex = 4,
                AnchorPoint = Vector2.new(1, 0),
                Font = Enum.Font.GothamBlack,
                Position = UDim2.fromScale(1, 0),
                Size = UDim2.fromScale(0.4, 0.2),
                TextXAlignment = Enum.TextXAlignment.Right
            },
            strokeProps = {
                Thickness = 0.06
            },
            text = ("Lvl %*"):format(level)
        }), react.createElement("textlabel", {
            BackgroundTransparency = 1,
            RichText = true,
            TextScaled = true,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0, 0),
            Font = Enum.Font.GothamBold,
            Position = UDim2.fromScale(0, 0.36),
            Size = UDim2.fromScale(0.6, 0.2),
            Text = getFishMutationDisplayName(mutation),
            TextColor3 = Color3.new(1, 1, 1),
            TextXAlignment = Enum.TextXAlignment.Left
        }, react.createElement("uistroke", {
            Thickness = 0.05,
            Color = Color3.new(0, 0, 0),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        })), react.createElement(default4, {
            overrideProps = {
                ZIndex = 4,
                AnchorPoint = Vector2.new(0, 1),
                Font = Enum.Font.GothamBold,
                Position = UDim2.fromScale(0, 1),
                Size = UDim2.fromScale(0.6, 0.2),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            strokeProps = {
                Thickness = 0.05
            },
            text = v2,
            textColor3 = Color3.fromRGB(145, 145, 155)
        }), react.createElement("textlabel", {
            BackgroundTransparency = 1,
            TextScaled = true,
            ZIndex = 4,
            AnchorPoint = Vector2.new(1, 1),
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(1, 1),
            Size = UDim2.fromScale(0.45, 0.25),
            Text = t1[rarity],
            TextColor3 = Color3.new(1, 1, 1),
            TextXAlignment = Enum.TextXAlignment.Right
        }, react.createElement("uigradient", {
            Rotation = 90,
            Color = getRarityColor(rarity)
        }), react.createElement("uistroke", {
            Thickness = 0.03,
            Color = getRarityBorderColor(rarity),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        }))), react.createElement("textbutton", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
            ZIndex = 10,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Event = {
                Activated = onClick
            },
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }))
    end
}
