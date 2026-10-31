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
    ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 255, 225)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(90, 255, 140)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(30, 215, 90)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 140, 40))
})
local v2 = Color3.fromRGB(10, 70, 20)

local function AttractionCard(p1) -- line: 16
    -- upvalues: react (copy), default (copy), default2 (copy), useTheme (copy), PlaceholderImageFrame (copy)
    local description, heading, image, paragraph = p1.description, p1.heading, p1.image, p1.paragraph
    local position, size = p1.position, p1.size
    local v3 = useTheme()

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 2,
        Position = position,
        Size = size
    }, react.createElement(PlaceholderImageFrame, {
        description = description,
        image = image,
        size = UDim2.fromScale(0.4, 1)
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 3,
        AnchorPoint = Vector2.new(0, 0),
        Position = UDim2.fromScale(0.44, 0),
        Size = UDim2.fromScale(0.56, 1)
    }, react.createElement(default, {
        shadowYScale = 0.06,
        color = Color3.new(1, 1, 1),
        overrideProps = {
            TextScaled = true,
            ZIndex = 3,
            Font = v3.textFont2,
            Position = UDim2.fromScale(0, 0.06),
            Size = UDim2.fromScale(1, 0.26),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        text = heading
    }), react.createElement(default2, {
        overrideProps = {
            TextScaled = true,
            TextWrapped = true,
            ZIndex = 3,
            Font = v3.textFont,
            Position = UDim2.fromScale(0, 0.38),
            Size = UDim2.fromScale(1, 0.58),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top
        },
        strokeProps = {
            Thickness = 0.03
        },
        text = paragraph
    })))
end

return {
    default = function() -- CelebrationIslandAttractionsPage | line: 72
        -- upvalues: react (copy), default (copy), default2 (copy), useTheme (copy), images (copy), PlaceholderImageFrame (copy), v1 (copy), v2 (copy), AttractionCard (copy)
        local v4 = useTheme()

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement(default, {
            text = "Explore FOMO Party Island",
            anchorPoint = Vector2.new(0.5, 0),
            color = v1,
            overrideProps = {
                TextScaled = true,
                ZIndex = 5,
                Font = v4.textFont2,
                Size = UDim2.fromScale(0.72, 0.072)
            },
            popoutColor = v2,
            position = UDim2.fromScale(0.5, 0.02),
            strokeProps = {
                Color = v2
            }
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0, 0),
            Position = UDim2.fromScale(0.1, 0.14),
            Size = UDim2.fromScale(0.44, 0.84)
        }, react.createElement(PlaceholderImageFrame, {
            description = "COMMUNITY WALL\nFeatured creators, players, posts, and celebration moments from across the community",
            image = images.communityImage,
            size = UDim2.fromScale(1, 0.7)
        }), react.createElement(default, {
            shadowYScale = 0.06,
            text = "Community Highlights",
            anchorPoint = Vector2.new(0.5, 0),
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 3,
                Font = v4.textFont2,
                Size = UDim2.fromScale(1, 0.06)
            },
            position = UDim2.fromScale(0.5, 0.75)
        }), react.createElement(default2, {
            text = "Spot featured creators, community members, and memorable moments from Discord, YouTube, and the game.",
            overrideProps = {
                TextScaled = true,
                TextWrapped = true,
                ZIndex = 3,
                AnchorPoint = Vector2.new(0.5, 0),
                Font = v4.textFont,
                Position = UDim2.fromScale(0.5, 0.825),
                Size = UDim2.fromScale(0.96, 0.13),
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Top
            },
            strokeProps = {
                Thickness = 0.03
            }
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0, 0),
            Position = UDim2.fromScale(0.6, 0.14),
            Size = UDim2.fromScale(0.34, 0.84)
        }, react.createElement(AttractionCard, {
            description = "PHOTOBOOTH ART / UI",
            heading = "Strike a Pose",
            paragraph = "Take a party photo with your friends and capture the event before it disappears.",
            image = images.photospotImage,
            position = UDim2.fromScale(0, 0),
            size = UDim2.fromScale(1, 0.48)
        }), react.createElement(AttractionCard, {
            description = "FOMO DANCE FLOOR LIGHTS / EMOTES",
            heading = "Dance on the FOMO Floor",
            paragraph = "Meet up with the server, show off your emotes, and look out for a hidden party secret.",
            image = images.danceFloorImage,
            position = UDim2.fromScale(0, 0.52),
            size = UDim2.fromScale(1, 0.48)
        })))
    end
}
