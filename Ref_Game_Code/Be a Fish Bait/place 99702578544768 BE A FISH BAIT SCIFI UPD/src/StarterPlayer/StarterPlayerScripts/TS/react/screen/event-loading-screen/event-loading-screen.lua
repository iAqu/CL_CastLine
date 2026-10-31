-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "side-confetti").default
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 244, 122)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 163, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 92, 194))
})

local function getLoadingText(p1) -- line: 12
    local v3 = math.floor(p1 * 4) % 4

    if v3 == 0 then
        return "Travelling to Party Island"
    end

    if v3 == 1 then
        return "Travelling to Party Island."
    end

    if v3 == 2 then
        return "Travelling to Party Island.."
    end

    return "Travelling to Party Island..."
end

return {
    default = function() -- EventLoadingScreen | line: 26
        -- upvalues: useMotion (copy), react (copy), useEffect (copy), default (copy), default2 (copy), images (copy), v1 (copy)
        local v4, v5 = useMotion(0)
        local v6, v7 = useMotion(0)

        useEffect(function() -- line: 29
            -- upvalues: v5 (copy)
            v5:linear(1, {
                speed = 0.3333333333333333
            })

            return (v5:onComplete(function() -- line: 36
                -- upvalues: v5 (copy)
                v5:immediate(0)
                v5:linear(1, {
                    speed = 0.3333333333333333
                })
            end))
        end, { v5 })
        useEffect(function() -- line: 42
            -- upvalues: v7 (copy)
            v7:linear(360, {
                speed = 12
            })

            return (v7:onComplete(function() -- line: 49
                -- upvalues: v7 (copy)
                v7:immediate(0)
                v7:linear(360, {
                    speed = 12
                })
            end))
        end, { v7 })

        local v8 = v4:map(function(p2) -- line: 55
            local v10 = math.floor(p2 * 4) % 4

            if v10 == 0 then
                return "Travelling to Party Island"
            end

            if v10 == 1 then
                return "Travelling to Party Island."
            end

            if v10 == 2 then
                return "Travelling to Party Island.."
            end

            return "Travelling to Party Island..."
        end)

        return react.createElement("frame", {
            BorderSizePixel = 0,
            ZIndex = 100,
            BackgroundColor3 = Color3.fromRGB(37, 8, 80),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement("uigradient", {
            Rotation = 90,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 3, 73)),
                ColorSequenceKeypoint.new(0.48, Color3.fromRGB(112, 25, 142)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 3, 73))
            })
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0.45,
            ZIndex = 101,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.rainbowRainImage,
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Crop,
            Size = UDim2.fromScale(1, 1)
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 0.62,
            ZIndex = 102,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.shineBackground,
            ImageColor3 = Color3.fromRGB(255, 241, 151),
            Position = UDim2.fromScale(0.5, 0.43),
            Rotation = v6,
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.82, 1.35)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 103,
            AnchorPoint = Vector2.new(0, 0.5),
            Image = images.celebrationBackgroundLeft,
            Position = UDim2.fromScale(0, 0.52),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.3, 0.96)
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 103,
            AnchorPoint = Vector2.new(1, 0.5),
            Image = images.celebrationBackgroundRight,
            Position = UDim2.fromScale(1, 0.52),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.3, 0.96)
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 104,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.43),
            Size = UDim2.fromScale(0.48, 0.42)
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 104,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.voidDeckStudios,
            Position = UDim2.fromScale(0.5, 0.54),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(1, 1)
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            Rotation = -16,
            ZIndex = 105,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.partyHat,
            Position = UDim2.fromScale(0.25, 0.12),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.34, 0.42)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }))), react.createElement(default, {
            text = "THE PARTY STARTS NOW!",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = v1,
            overrideProps = {
                TextScaled = true,
                ZIndex = 106,
                Size = UDim2.fromScale(0.54, 0.075)
            },
            popoutColor = Color3.fromRGB(74, 16, 88),
            position = UDim2.fromScale(0.5, 0.72),
            strokeProps = {
                Thickness = 0.055,
                Color = Color3.fromRGB(82, 28, 92)
            }
        }), react.createElement(default, {
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 106,
                Size = UDim2.fromScale(0.48, 0.055)
            },
            popoutColor = Color3.fromRGB(50, 12, 72),
            position = UDim2.fromScale(0.5, 0.83),
            strokeProps = {
                Thickness = 0.05,
                Color = Color3.fromRGB(50, 12, 72)
            },
            text = v8
        }), react.createElement(default2, {
            active = true,
            zIndex = 108
        }))
    end
}
