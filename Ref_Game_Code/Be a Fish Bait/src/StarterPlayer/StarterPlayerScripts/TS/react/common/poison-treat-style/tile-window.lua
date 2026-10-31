-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent, "tile-gradient-frame").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local useScreenSize = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSize
local default2 = RuntimeLib.import(script, script.Parent, "tile-button").default
local default3 = RuntimeLib.import(script, script.Parent.Parent, "styled-text-label").default

return {
    default = function(p1) -- TileWindow | line: 9
        -- upvalues: react (copy), default (copy), useTheme (copy), useScreenSize (copy), default2 (copy), default3 (copy)
        useTheme()

        local v1 = useScreenSize()
        local v2 = v1:map(function(p2) -- line: 12
            if p2 == "sm" then
                return 2
            end

            if p2 == "md" then
                return 3
            end

            return 4
        end)
        local v3 = #p1.title * 0.075

        return react.createElement("frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = p1.size
        }, p1.aspectRatio ~= nil and react.createElement("uiaspectratioconstraint", {
            AspectRatio = p1.aspectRatio
        }), react.createElement(default, {
            anchorPoint = Vector2.new(0.5, 0),
            borderColor = Color3.fromRGB(0, 0, 0),
            borderSizePixel = p1.borderSizePixel,
            colorSequence = if p1.headerColor then p1.headerColorSequence else p1.bodyColorSequence,
            disableTileBackground = p1.disableTileBackground,
            position = UDim2.fromScale(0.5, 0),
            size = UDim2.fromScale(1, 0.2)
        }, not p1.headerColor and react.createElement("frame", {
            BackgroundTransparency = 0.75,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.new(0, 0, 0),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(0, 0.5),
            Size = UDim2.fromScale(p1.titleCenteredWithoutButton and 1 or 0.9, 0.7)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 8)
        }), p1.imageId ~= nil and react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0, 0.5),
            Image = p1.imageId,
            Position = UDim2.fromScale(0, 0.5),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })), react.createElement(default3, {
            overrideProps = {
                BackgroundTransparency = 1,
                TextScaled = true,
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.fromScale(0.7, 0.5),
                Size = UDim2.fromScale(v3, 1),
                Text = p1.title,
                TextYAlignment = Enum.TextYAlignment.Center
            },
            strokeProps = {
                Thickness = v2
            },
            text = p1.title
        }, react.createElement("uitextsizeconstraint", {
            MaxTextSize = v1:map(function(p3) -- line: 68
                if p3 == "sm" then
                    return 36
                end

                if p3 == "md" then
                    return 48
                end

                return 64
            end)
        }))), react.createElement(default2, {
            uiAspectRatio = 1,
            anchorPoint = Vector2.new(0.5, 0.5),
            borderColor = Color3.fromRGB(92, 2, 5),
            colorSequence = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 111)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 0, 80))
            }),
            disableTileBackground = p1.disableTileBackground,
            onClick = p1.onClose,
            position = UDim2.fromScale(0.9, 0.5),
            size = UDim2.fromScale(0.8, 0.6)
        }, react.createElement(default3, {
            text = "X",
            overrideProps = {
                BackgroundTransparency = 1,
                Text = "X",
                TextScaled = true,
                ZIndex = 2,
                AnchorPoint = Vector2.new(0.5, 0.5),
                FontSize = Enum.FontSize.Size24,
                Position = UDim2.fromScale(0.51, 0.44),
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center
            },
            strokeProps = {
                Thickness = v2
            }
        }, react.createElement("uiscale", {
            Scale = 1.2
        })))), react.createElement(default, {
            anchorPoint = Vector2.new(0.5, 0),
            borderColor = Color3.fromRGB(0, 0, 0),
            borderSizePixel = p1.borderSizePixel,
            colorSequence = p1.bodyColorSequence,
            disableTileBackground = p1.disableTileBackground,
            position = UDim2.fromScale(0.5, 0.2),
            size = UDim2.fromScale(1, 0.8)
        }, p1.children))
    end
}
