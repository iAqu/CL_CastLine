-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef = react.useEffect, react.useRef
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local robuxIconPrefix = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-utils").robuxIconPrefix
local useProductPrice = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "hooks", "use-product-price").useProductPrice
local getRarityColor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").getRarityColor

return {
    default = function(p1) -- InstantCaptureOffer | line: 23
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useMotion (copy), default (copy), default2 (copy), default3 (copy), images (copy), robuxIconPrefix (copy), useProductPrice (copy), getRarityColor (copy)
        local durationSec, fish, paused = p1.durationSec, p1.fish, p1.paused
        local v1 = paused

        if paused == nil then
            v1 = false
            paused = false
        end

        local priceRobux, productId, uiScale, onBuy = p1.priceRobux, p1.productId, p1.uiScale, p1.onBuy
        local onCancel = p1.onCancel
        local v2, v3 = useMotion(1)
        local v4, v5 = useMotion(0)
        local v6, v7 = useMotion(0)
        local v8 = useRef(durationSec)
        local v9 = useRef(nil)
        local v10 = useRef(onCancel)

        v10.current = onCancel

        local v11 = useRef(false)

        v11.current = paused

        local v12 = useProductPrice(productId, Enum.InfoType.Product)

        if v12 ~= nil then
            priceRobux = v12
        end

        useEffect(function() -- line: 52
            -- upvalues: durationSec (copy), v3 (copy), v5 (copy), v7 (copy), v9 (copy), v10 (copy), v11 (copy)
            v5:spring(1, {
                damping = 0.55,
                frequency = 2.4
            })
            v3:linear(0, {
                speed = 1 / durationSec
            })
            v7:linear(360, {
                speed = 18
            })
            v9.current = task.delay(durationSec, function() -- line: 63
                -- upvalues: v10 (copy), v11 (copy)
                if not v11.current then
                    v10.current()
                end
            end)

            return function() -- line: 68
                -- upvalues: v9 (copy)
                if v9.current ~= nil then
                    task.cancel(v9.current)
                end
            end
        end, {})
        useEffect(function() -- line: 75
            -- upvalues: durationSec (copy), v1 (ref), v2 (copy), v3 (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy)
            if v1 then
                v3:stop()

                if v9.current ~= nil then
                    task.cancel(v9.current)
                    v9.current = nil
                end

                v8.current = v2:getValue() * durationSec
            elseif v8.current > 0 then
                v3:linear(0, {
                    speed = 1 / v8.current
                })
                v9.current = task.delay(v8.current, function() -- line: 88
                    -- upvalues: v10 (copy), v11 (copy)
                    if not v11.current then
                        v10.current()
                    end
                end)
            end
        end, { v1 })

        local v13 = 460 * uiScale
        local v14 = 500 * uiScale
        local v15 = 80 * uiScale
        local v16 = 138 * uiScale

        return react.createElement("frame", {
            Active = true,
            BackgroundTransparency = 0.45,
            BorderSizePixel = 0,
            ZIndex = 40,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement(default, {
            cornerRadius = 0.06,
            isStudded = true,
            isStuddedTransparency = 0.2,
            textureTransparency = 0.85,
            tileSize = 100,
            transparency = 0.3,
            zIndex = 41,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor = Color3.fromRGB(28, 32, 44),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromOffset(v13, v14)
        }, react.createElement("uistroke", {
            Thickness = 0.025,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Color3.fromRGB(255, 210, 70),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        }, react.createElement("uigradient", {
            Rotation = 90,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 236, 150)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 196, 46)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(196, 130, 20))
            })
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 42,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.965, 0.965)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.055, 0)
        }), react.createElement("uistroke", {
            Thickness = 0.012,
            Transparency = 0.78,
            Color = Color3.fromRGB(255, 255, 255),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 43,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement("uiscale", {
            Scale = v4:map(function(p2) -- line: 152
                return 0.85 + p2 * 0.15
            end)
        }), react.createElement(default3, {
            text = "INSTANT CAPTURE?",
            anchorPoint = Vector2.new(0.5, 0),
            color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 240, 150)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 180, 40))
            }),
            overrideProps = {
                TextScaled = true,
                ZIndex = 43,
                Size = UDim2.fromOffset(v13 * 0.92, 78 * uiScale)
            },
            position = UDim2.new(0.5, 0, 0, 22 * uiScale),
            strokeProps = {
                Thickness = 0.09
            }
        }), fish ~= nil and react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 43,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, 108 * uiScale),
            Size = UDim2.fromOffset(v16, v16)
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ImageTransparency = 0.18,
            ZIndex = 42,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.shineBackground,
            ImageColor3 = Color3.fromRGB(255, 232, 82),
            Position = UDim2.fromScale(0.5, 0.5),
            Rotation = v6,
            Size = UDim2.fromScale(1.7, 1.7)
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 43,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = fish.imageId,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        })), fish ~= nil and react.createElement("textlabel", {
            BackgroundTransparency = 1,
            TextScaled = true,
            ZIndex = 43,
            AnchorPoint = Vector2.new(0.5, 0),
            Font = Enum.Font.GothamBlack,
            Position = UDim2.new(0.5, 0, 0, 246 * uiScale),
            Size = UDim2.fromOffset(v13 * 0.9, 30 * uiScale),
            Text = fish.displayName,
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }, react.createElement("uistroke", {
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = math.max(1.5, 2.5 * uiScale)
        })), fish ~= nil and react.createElement("textlabel", {
            BackgroundTransparency = 1,
            TextScaled = true,
            ZIndex = 43,
            AnchorPoint = Vector2.new(0.5, 0),
            Font = Enum.Font.GothamBlack,
            Position = UDim2.new(0.5, 0, 0, 280 * uiScale),
            Size = UDim2.fromOffset(v13 * 0.9, 26 * uiScale),
            Text = string.upper(fish.rarity),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }, react.createElement("uigradient", {
            Rotation = 90,
            Color = getRarityColor(fish.rarity)
        }), react.createElement("uistroke", {
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = math.max(1.5, 2.5 * uiScale)
        })), react.createElement(default2, {
            cornerRadius = 0.28,
            zIndex = 43,
            anchorPoint = Vector2.new(0.5, 1),
            color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 220, 50)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 175, 20))
            }),
            frameSize = UDim2.fromOffset(v13 * 0.82, v15),
            label = ("%*%*"):format(robuxIconPrefix, priceRobux),
            onClick = onBuy,
            popoutColor = Color3.fromRGB(10, 120, 10),
            position = UDim2.new(0.5, 0, 1, -(v15 + 6 * uiScale))
        }), react.createElement(default2, {
            cornerRadius = 0.32,
            label = "No thanks",
            zIndex = 43,
            anchorPoint = Vector2.new(0.5, 1),
            color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(110, 116, 130)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(64, 68, 80))
            }),
            frameSize = UDim2.fromOffset(v13 * 0.5, 44 * uiScale),
            onClick = onCancel,
            popoutColor = Color3.fromRGB(40, 43, 52),
            position = UDim2.new(0.5, 0, 1, -(20 * uiScale))
        }))), react.createElement("frame", {
            BackgroundTransparency = 0.35,
            BorderSizePixel = 0,
            ZIndex = 42,
            AnchorPoint = Vector2.new(0.5, 1),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Position = UDim2.new(0.5, 0, 1, -(24 * uiScale)),
            Size = UDim2.fromOffset(520 * uiScale, 52 * uiScale)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        }), react.createElement("frame", {
            BorderSizePixel = 0,
            ZIndex = 43,
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 196, 54),
            Position = UDim2.fromScale(0, 0.5),
            Size = v2:map(function(p3) -- line: 258
                return UDim2.fromScale(math.clamp(p3, 0, 1), 1)
            end)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        })), react.createElement("textlabel", {
            BackgroundTransparency = 1,
            TextScaled = true,
            ZIndex = 44,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Font = Enum.Font.GothamBlack,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            Text = v2:map(function(p4) -- line: 270
                -- upvalues: durationSec (copy)
                return (("%*s"):format((math.ceil(math.clamp(p4, 0, 1) * durationSec))))
            end),
            TextColor3 = v2:map(function(p5) -- line: 273
                -- upvalues: durationSec (copy)
                if math.clamp(p5, 0, 1) * durationSec <= 3 then
                    return (Color3.fromRGB(255, 60, 60))
                end

                return (Color3.fromRGB(255, 255, 255))
            end)
        }, react.createElement("uiscale", {
            Scale = v2:map(function(p6) -- line: 279
                -- upvalues: durationSec (copy)
                local v31 = math.clamp(p6, 0, 1) * durationSec

                if v31 > 3 then
                    return 1
                end

                return math.abs((math.sin(v31 * 3.141592653589793 * 2))) * 0.18 + 1
            end)
        }), react.createElement("uipadding", {
            PaddingBottom = UDim.new(0, 3 * uiScale),
            PaddingTop = UDim.new(0, 3 * uiScale)
        }), react.createElement("uistroke", {
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = math.max(1, 2 * uiScale)
        }))))
    end
}
