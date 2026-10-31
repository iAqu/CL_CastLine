-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-window").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "side-confetti").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local commify = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").commify
local useCountUpBinding = RuntimeLib.import(script, script.Parent, "use-count-up-binding").useCountUpBinding
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(157, 244, 155)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(121, 200, 119))
})
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(254, 231, 109)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(246, 191, 33))
})
local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 253, 252)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(87, 239, 252))
})
local v4 = Color3.fromRGB(5, 34, 99)
local v5 = Color3.fromRGB(80, 220, 80)
local v6 = Color3.fromRGB(54, 145, 54)

local function HeaderContent() -- line: 19
    -- upvalues: react (copy), default2 (copy), useTheme (copy), v2 (copy)
    local v7 = useTheme()

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 21,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromScale(0.04, 0.5),
        Size = UDim2.fromScale(0.83, 0.72)
    }, react.createElement(default2, {
        text = "CELEBRATION EVENT",
        color = v2,
        overrideProps = {
            TextScaled = true,
            ZIndex = 21,
            Font = v7.textFont2,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        strokeProps = {
            Color = Color3.fromRGB(90, 60, 0)
        }
    }))
end

local function ComingSoonText(p1) -- line: 43
    -- upvalues: react (copy), default2 (copy), useTheme (copy), v3 (copy), v4 (copy)
    local position, size, text, zIndex = p1.position, p1.size, p1.text, p1.zIndex
    local v8 = useTheme()

    return react.createElement(default2, {
        anchorPoint = Vector2.new(0.5, 0.5),
        color = v3,
        overrideProps = {
            TextScaled = true,
            Font = v8.textFont2,
            Size = size,
            ZIndex = zIndex
        },
        popoutColor = v4,
        position = position,
        strokeProps = {
            Thickness = 0.08,
            Color = v4
        },
        text = text
    })
end

return {
    default = function(p2) -- CelebrationRegistrationWindow | line: 67
        -- upvalues: react (copy), default (copy), default2 (copy), default3 (copy), default4 (copy), images (copy), commify (copy), useCountUpBinding (copy), v1 (copy), v2 (copy), v5 (copy), v6 (copy), HeaderContent (copy), ComingSoonText (copy)
        local isRegistered, justRegistered, onClose, onRegister = p2.isRegistered, p2.justRegistered, p2.onClose, p2.onRegister
        local v9 = useCountUpBinding(p2.registeredCount)

        return react.createElement(default, {
            aspectRatio = 1.4,
            bodyTransparency = 1,
            title = "",
            bodyBg = Color3.fromRGB(0, 0, 0),
            headerBg = v1,
            headerNode = react.createElement(HeaderContent),
            onClose = onClose,
            size = UDim2.fromScale(0.55, 0.6)
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0.6,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.rainbowRainImage,
            Position = UDim2.fromScale(0.5, 0.3),
            ScaleType = Enum.ScaleType.Crop,
            Size = UDim2.fromScale(1, 1)
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0.38,
            ZIndex = 3,
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
            ZIndex = 4,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.celebrationBackground,
            Position = UDim2.fromScale(0.5, 0.6),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(1.05, 1.05)
        }), react.createElement(ComingSoonText, {
            text = "COMING",
            zIndex = 5,
            position = UDim2.fromScale(0.5, 0.28),
            size = UDim2.fromScale(0.75, 0.2)
        }), react.createElement(ComingSoonText, {
            text = "SOON!",
            zIndex = 5,
            position = UDim2.fromScale(0.5, 0.46),
            size = UDim2.fromScale(0.75, 0.2)
        }), react.createElement(default2, {
            anchorPoint = Vector2.new(0.5, 0.5),
            color = v2,
            overrideProps = {
                TextScaled = true,
                ZIndex = 5,
                Size = UDim2.fromScale(0.8, 0.08)
            },
            popoutColor = Color3.fromRGB(90, 60, 0),
            position = UDim2.fromScale(0.5, 0.68),
            strokeProps = {
                Color = Color3.fromRGB(90, 60, 0)
            },
            text = v9:map(function(p3) -- line: 135
                -- upvalues: commify (copy)
                return (("%* Players Are Waiting!"):format((commify(p3))))
            end)
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.85),
            Size = UDim2.fromScale(0.4, 0.12)
        }, if isRegistered then react.createElement(default2, {
            text = "Registered!",
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 5,
                Size = UDim2.fromScale(1, 1)
            },
            popoutColor = Color3.fromRGB(48, 20, 20),
            strokeProps = {
                Color = Color3.fromRGB(0, 90, 0)
            }
        }) else react.createElement(default3, {
            cornerRadius = 0.125,
            label = "Register!",
            zIndex = 5,
            color = v5,
            frameSize = UDim2.fromScale(0.8, 0.9),
            onClick = onRegister,
            popoutColor = v6,
            position = UDim2.fromScale(0.5, 0.6)
        })), react.createElement(default4, {
            zIndex = 6,
            active = justRegistered
        }))
    end
}
