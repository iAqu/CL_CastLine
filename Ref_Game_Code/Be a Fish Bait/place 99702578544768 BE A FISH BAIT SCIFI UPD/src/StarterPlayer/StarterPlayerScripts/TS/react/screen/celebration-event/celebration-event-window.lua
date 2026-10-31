-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useRef = react.useRef
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-button").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default5 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "list-scrolling-frame").default
local default6 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "ticket-counter-badge").default
local default7 = RuntimeLib.import(script, script.Parent.Parent.Parent, "tutorial", "tutorial-screen-pointer").default
local useTransitionMotion = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "use-transition-motion").useTransitionMotion
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local commify = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").commify
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local default8 = RuntimeLib.import(script, script.Parent, "celebration-rewards-store-page").default
local default9 = RuntimeLib.import(script, script.Parent, "celebration-earn-tickets-page").default
local default10 = RuntimeLib.import(script, script.Parent, "celebration-live-events-page").default
local default11 = RuntimeLib.import(script, script.Parent, "celebration-island-attractions-page").default
local default12 = RuntimeLib.import(script, script.Parent, "celebration-fomo-bar-page").default
local default13 = RuntimeLib.import(script, script.Parent, "celebration-event-countdown").default
local v1 = Color3.fromRGB(0, 0, 0)
local t1 = {
    time = 0.3
}
local v2 = Color3.fromRGB(168, 42, 191)

local function CloseButton(p1) -- line: 60
    -- upvalues: react (copy), default2 (copy), default3 (copy), useTheme (copy)
    local onClick = p1.onClick
    local v3 = useTheme()

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 100,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.fromScale(0.925, 0.015),
        Size = UDim2.fromScale(0.045, 0.065)
    }, react.createElement(default2, {
        aspectRatio = 1,
        cornerRadius = 0.1,
        zIndex = 100,
        anchorPoint = Vector2.new(0.5, 0.5),
        color = Color3.fromRGB(255, 43, 43),
        onClick = onClick,
        popoutColor = Color3.fromRGB(122, 31, 31),
        position = UDim2.fromScale(0.5, 0.5),
        size = UDim2.fromScale(1, 1),
        strokeColor = Color3.fromRGB(255, 179, 179)
    }, react.createElement(default3, {
        shadowYScale = 0.075,
        text = "X",
        anchorPoint = Vector2.new(0.5, 0.5),
        color = Color3.new(1, 1, 1),
        overrideProps = {
            TextScaled = true,
            ZIndex = 104,
            Font = v3.textFont2,
            Size = UDim2.fromScale(0.8, 0.8)
        },
        position = UDim2.fromScale(0.5, 0.5)
    })))
end

local function HeaderContent(p2) -- line: 101
    -- upvalues: react (copy), default6 (copy), commify (copy), images (copy)
    local ticketCount = p2.ticketCount

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 20,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default6, {
        width = 0.12,
        zIndex = 21,
        anchorPoint = Vector2.new(1, 0.5),
        icon = images.celebrationTicket,
        position = UDim2.fromScale(0.85, 0.5),
        text = commify(ticketCount)
    }))
end

local function BodyBackgroundDecor() -- line: 125
    -- upvalues: react (copy), images (copy)
    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 1,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromScale(0.5, 1),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ImageTransparency = 0.6,
        ZIndex = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = images.rainbowRainImage,
        Position = UDim2.fromScale(0.5, 0.5),
        ScaleType = Enum.ScaleType.Crop,
        Size = UDim2.fromScale(1, 1)
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ImageTransparency = 0.38,
        ZIndex = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = images.shineBackground,
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.fromScale(0.5, 0.1),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(1.1, 1.1)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    })), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ImageTransparency = 0.4,
        ZIndex = 1,
        AnchorPoint = Vector2.new(0, 0.5),
        Image = images.celebrationBackgroundLeft,
        Position = UDim2.fromScale(-0.1, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.4, 1)
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ImageTransparency = 0.4,
        ZIndex = 1,
        AnchorPoint = Vector2.new(1, 0.5),
        Image = images.celebrationBackgroundRight,
        Position = UDim2.fromScale(1.1, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.4, 1)
    }))
end

return {
    celebrationEventWindowFadeDurationSeconds = 0.3,
    default = function(p3) -- CelebrationEventWindow | line: 174
        -- upvalues: react (copy), useRef (copy), default (copy), default3 (copy), default4 (copy), default5 (copy), default7 (copy), useTransitionMotion (copy), useTheme (copy), images (copy), default8 (copy), default9 (copy), default10 (copy), default11 (copy), default12 (copy), default13 (copy), v1 (copy), t1 (copy), v2 (copy), CloseButton (copy), HeaderContent (copy), BodyBackgroundDecor (copy)
        local globalTicketCount, isCelebrationPlace, onClose, onOpenStore = p3.globalTicketCount, p3.isCelebrationPlace, p3.onClose, p3.onOpenStore
        local onTeleport, onViewChallenge, ticketCount = p3.onTeleport, p3.onViewChallenge, p3.ticketCount
        local v4 = useTheme()
        local v5 = useTransitionMotion({
            whenIn = 0,
            whenOut = 1
        }, {
            motionType = "tween",
            tweenOptions = t1
        })[1]
        local v6 = useRef(nil)

        return react.createElement("screengui", {
            ResetOnSpawn = false,
            ScreenInsets = Enum.ScreenInsets.None
        }, react.createElement("canvasgroup", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 1,
            GroupTransparency = v5,
            Size = UDim2.fromScale(1, 1)
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 20,
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.fromScale(1, 0.1)
        }, react.createElement(HeaderContent, {
            ticketCount = ticketCount
        })), react.createElement(default, {
            isStudded = true,
            textureTransparency = 0.9,
            transparency = 0.5,
            zIndex = 1,
            anchorPoint = Vector2.new(0.5, 1),
            backgroundColor = v1,
            position = UDim2.fromScale(0.5, 1),
            size = UDim2.fromScale(1, 1)
        }), react.createElement(BodyBackgroundDecor), react.createElement(default5, {
            canvasHeightScale = 6.25,
            clipsDescendants = false,
            itemPaddingScale = 0.05,
            zIndex = 2,
            anchorPoint = Vector2.new(0.5, 1),
            position = UDim2.fromScale(0.5, 1),
            scrollFrameRef = v6,
            size = UDim2.fromScale(1, 1)
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Size = UDim2.fromScale(1, 1)
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0),
            Image = images.eventBannerImage,
            Position = UDim2.fromScale(0.5, 0.1),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.6, 0.6)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.06, 0)
        })), react.createElement(default13, {
            zIndex = 3,
            position = UDim2.fromScale(0.5, 0.73),
            size = UDim2.fromScale(0.38, 0.045)
        }), not isCelebrationPlace and react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.84),
            Size = UDim2.fromScale(1, 0.16)
        }, react.createElement(default4, {
            cornerRadius = 0.12,
            label = "Teleport to FOMO party island!",
            shadowYScale = 0.06,
            zIndex = 3,
            anchorPoint = Vector2.new(0.5, 0.5),
            color = v2,
            frameSize = UDim2.fromScale(0.32, 0.7),
            onClick = onTeleport,
            popoutColor = Color3.fromRGB(84, 13, 94),
            position = UDim2.fromScale(0.5, 0.5)
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.93),
            Size = UDim2.fromScale(0.4, 0.06)
        }, react.createElement(default7, {
            direction = "up",
            zIndex = 3,
            anchorPoint = Vector2.new(0.5, 0.5),
            image = images.chevronsIcon,
            position = UDim2.fromScale(0.1, 0.45),
            size = UDim2.fromScale(0.18, 1)
        }), react.createElement(default3, {
            shadowYScale = 0.075,
            text = "Scroll down!",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 3,
                Font = v4.textFont2,
                Size = UDim2.fromScale(1, 1)
            },
            position = UDim2.fromScale(0.5, 0.5)
        }), react.createElement(default7, {
            direction = "up",
            zIndex = 3,
            anchorPoint = Vector2.new(0.5, 0.5),
            image = images.chevronsIcon,
            position = UDim2.fromScale(0.81, 0.45),
            size = UDim2.fromScale(0.18, 1)
        }))), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            Size = UDim2.fromScale(1, 1)
        }, react.createElement(default8, {
            isCelebrationPlace = isCelebrationPlace,
            onOpenStore = onOpenStore
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 3,
            Size = UDim2.fromScale(1, 1)
        }, react.createElement(default9)), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 4,
            Size = UDim2.fromScale(1, 1)
        }, react.createElement(default10)), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 5,
            Size = UDim2.fromScale(1, 1)
        }, react.createElement(default11)), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 6,
            Size = UDim2.fromScale(1, 1)
        }, react.createElement(default12, {
            currentTickets = globalTicketCount,
            isCelebrationPlace = isCelebrationPlace,
            onViewChallenge = onViewChallenge
        }))), react.createElement(CloseButton, {
            onClick = onClose
        })))
    end
}
