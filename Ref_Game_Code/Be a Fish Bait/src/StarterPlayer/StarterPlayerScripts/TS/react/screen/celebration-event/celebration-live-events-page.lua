-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "styled-text-label").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local PlaceholderImageFrame = RuntimeLib.import(script, script.Parent, "celebration-placeholder-image").PlaceholderImageFrame
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(240, 220, 255)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(190, 90, 255)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(140, 30, 245)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 10, 180))
})
local v2 = Color3.fromRGB(50, 10, 90)

return {
    default = function() -- CelebrationLiveEventsPage | line: 18
        -- upvalues: react (copy), default (copy), default2 (copy), useTheme (copy), images (copy), PlaceholderImageFrame (copy), v1 (copy), v2 (copy)
        local v3 = useTheme()

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement(default, {
            text = "Party with the Whole Server",
            anchorPoint = Vector2.new(0.5, 0),
            color = v1,
            overrideProps = {
                TextScaled = true,
                ZIndex = 5,
                Font = v3.textFont2,
                Size = UDim2.fromScale(0.56, 0.072)
            },
            popoutColor = v2,
            position = UDim2.fromScale(0.5, 0.02),
            strokeProps = {
                Color = v2
            }
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 2,
            Position = UDim2.fromScale(0.069, 0.16),
            Size = UDim2.fromScale(0.527, 0.82)
        }, react.createElement(PlaceholderImageFrame, {
            description = "PIÑATA BASH GAMEPLAY SCENE\nSmall, medium, and large piñatas with players teaming up to break them for different reward tiers",
            image = images.pinataImage,
            size = UDim2.fromScale(1, 0.6)
        }), react.createElement(default, {
            shadowYScale = 0.06,
            text = "Three-Tier Piñata Bash",
            anchorPoint = Vector2.new(0.5, 0),
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 3,
                Font = v3.textFont2,
                Size = UDim2.fromScale(1, 0.08)
            },
            position = UDim2.fromScale(0.5, 0.63)
        }), react.createElement(default2, {
            text = "Small, medium, and giant piñatas can appear, and each size pays out a different reward tier. The bigger the piñata, the bigger the Ticket moment for the server.",
            overrideProps = {
                TextScaled = true,
                TextWrapped = true,
                ZIndex = 3,
                AnchorPoint = Vector2.new(0.5, 0),
                Font = v3.textFont,
                Position = UDim2.fromScale(0.5, 0.76),
                Size = UDim2.fromScale(0.96, 0.22),
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Top
            },
            strokeProps = {
                Thickness = 0.03
            }
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 2,
            Position = UDim2.fromScale(0.65, 0.16),
            Size = UDim2.fromScale(0.272, 0.82)
        }, react.createElement(PlaceholderImageFrame, {
            description = "FOMO TICKET RAIN GAMEPLAY SCENE\nTickets raining across the island while players run around collecting them",
            image = images.ticketRainImage,
            size = UDim2.fromScale(1, 0.6)
        }), react.createElement(default, {
            shadowYScale = 0.06,
            text = "FOMO Ticket Rain",
            anchorPoint = Vector2.new(0.5, 0),
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 3,
                Font = v3.textFont2,
                Size = UDim2.fromScale(1, 0.08)
            },
            position = UDim2.fromScale(0.5, 0.63)
        }), react.createElement(default2, {
            text = "Every so often, Tickets rain across the island for a short burst. Run around and grab as many as you can before it ends.",
            overrideProps = {
                TextScaled = true,
                TextWrapped = true,
                ZIndex = 3,
                AnchorPoint = Vector2.new(0.5, 0),
                Font = v3.textFont,
                Position = UDim2.fromScale(0.5, 0.76),
                Size = UDim2.fromScale(0.96, 0.24),
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Top
            },
            strokeProps = {
                Thickness = 0.03
            }
        })))
    end
}
