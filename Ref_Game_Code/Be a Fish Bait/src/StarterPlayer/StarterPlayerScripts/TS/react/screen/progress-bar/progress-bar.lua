-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local joinBindings, useCallback, useEffect, useRef = react.joinBindings, react.useCallback, react.useEffect, react.useRef
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, RunService = services.Players, services.RunService
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "styled-text-label").default
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local getBorderThickness = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "responsive-utils").getBorderThickness
local getRarityColor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").getRarityColor
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images

local function darkenSequence(p1, p2) -- line: 20
    local t1 = {}

    for _, v1 in p1.Keypoints do
        table.insert(t1, (ColorSequenceKeypoint.new(v1.Time, Color3.fromRGB(math.round(v1.Value.R * 255 * p2), math.round(v1.Value.G * 255 * p2), (math.round(v1.Value.B * 255 * p2))))))
    end

    return ColorSequence.new(t1)
end

local t2 = {
    {
        label = "Common",
        gradient = getRarityColor("common"),
        innerGradient = darkenSequence(getRarityColor("common"), 0.55),
        mainColor = Color3.fromRGB(255, 255, 255)
    },
    {
        label = "Uncommon",
        gradient = getRarityColor("uncommon"),
        innerGradient = darkenSequence(getRarityColor("uncommon"), 0.55),
        mainColor = Color3.fromRGB(255, 255, 255)
    },
    {
        label = "Rare",
        gradient = getRarityColor("rare"),
        innerGradient = darkenSequence(getRarityColor("rare"), 0.55),
        mainColor = Color3.fromRGB(255, 255, 255)
    },
    {
        label = "Epic",
        gradient = getRarityColor("epic"),
        innerGradient = darkenSequence(getRarityColor("epic"), 0.55),
        mainColor = Color3.fromRGB(255, 255, 255)
    },
    {
        label = "Legend",
        gradient = getRarityColor("legendary"),
        innerGradient = darkenSequence(getRarityColor("legendary"), 0.55),
        mainColor = Color3.fromRGB(255, 255, 255)
    },
    {
        label = "Mythic",
        gradient = getRarityColor("mythic"),
        innerGradient = darkenSequence(getRarityColor("mythic"), 0.55),
        mainColor = Color3.fromRGB(255, 255, 255)
    },
    {
        label = "Godly",
        gradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(251, 255, 230)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 201, 43)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(251, 255, 230))
        }),
        innerGradient = darkenSequence(ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(251, 255, 230)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 201, 43)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(251, 255, 230))
        }), 0.7),
        mainColor = Color3.fromRGB(255, 255, 255)
    },
    {
        label = "Secret",
        gradient = getRarityColor("secret"),
        innerGradient = darkenSequence(getRarityColor("secret"), 0.55),
        innerImage = images.secretBackground,
        mainColor = Color3.fromRGB(255, 255, 255)
    },
    {
        label = "Hacked",
        gradient = getRarityColor("hacked"),
        innerGradient = darkenSequence(getRarityColor("hacked"), 0.55),
        innerImage = images.hackedBackground,
        mainColor = Color3.fromRGB(255, 255, 255)
    },
    {
        label = "Cosmic",
        gradient = getRarityColor("cosmic"),
        innerGradient = darkenSequence(getRarityColor("cosmic"), 0.55),
        innerImage = images.cosmicBackground,
        mainColor = Color3.fromRGB(255, 255, 255)
    },
    {
        label = "Extinct",
        gradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 140, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 200, 80)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 140, 0))
        }),
        innerGradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(188, 63, 6)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(253, 247, 160)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(188, 63, 6))
        }),
        innerImage = images.extinctBackground,
        mainColor = Color3.fromRGB(255, 255, 255)
    },
    {
        label = "KaijUwU",
        gradient = ColorSequence.new(Color3.fromRGB(126, 116, 100)),
        innerGradient = darkenSequence(ColorSequence.new(Color3.fromRGB(126, 116, 100)), 0.55),
        innerImage = images.kaijuwuBackground,
        mainColor = Color3.fromRGB(255, 255, 255)
    },
    {
        label = "Scifi",
        gradient = getRarityColor("scifi"),
        innerGradient = darkenSequence(getRarityColor("scifi"), 0.55),
        innerImage = images.scifiBackground,
        mainColor = Color3.fromRGB(255, 255, 255)
    }
}
local v8 = #t2
local v9 = (v8 - 1) * 240 + 480
local t3 = {}
local n1 = 1
local v10 = false

while true do
    if v10 then
        n1 += 1
    else
        v10 = true
    end

    if n1 < v8 then
        table.insert(t3, n1 / v8)
        continue
    end

    break
end

local v12 = math.min(10, v8)
local v13 = v8 / v12
local v14 = v8 - v12
local v15 = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(1, 1)
})

return {
    default = function(p3) -- ProgressBar | line: 131
        -- upvalues: react (copy), joinBindings (copy), useCallback (copy), useEffect (copy), useRef (copy), useMotion (copy), Players (copy), RunService (copy), default (copy), default2 (copy), useScreenSizeState (copy), getBorderThickness (copy), t2 (copy), v8 (copy), v9 (copy), t3 (copy), v12 (copy), v13 (copy), v14 (copy), v15 (copy)
        local anchorPoint, position, progress, _ = p3.anchorPoint, p3.position, p3.progress, p3.size
        local studsOverride, zIndex = p3.studsOverride, p3.zIndex

        if zIndex == nil then
            zIndex = 1
        end

        local LocalPlayer = Players.LocalPlayer
        local v16 = ("rbxthumb://type=AvatarHeadShot&id=%*&w=60&h=60"):format(if LocalPlayer == nil then 156 else LocalPlayer.UserId)
        local v17 = useScreenSizeState()
        local xsm = getBorderThickness(v17, "xsm")
        local v18 = position or UDim2.fromScale(0.5, 0.05)

        if v17 == "sm" then
            position = UDim2.new(v18.X.Scale, v18.X.Offset, v18.Y.Scale + 0.15, v18.Y.Offset)
        end

        local v19 = type(progress) == "number"
        local v21, v22 = useMotion(if v19 then progress else 0.5)
        local v23, v24 = useMotion(1)
        local v25 = useRef(0)
        local v26 = useRef(nil)
        local v27 = useCallback(function() -- line: 155
            -- upvalues: v24 (copy), v26 (copy)
            if v26.current ~= nil then
                task.cancel(v26.current)
            end

            v24:set(2)
            v26.current = task.delay(0.1, function() -- line: 160
                -- upvalues: v24 (copy), v26 (copy)
                v24:set(1)
                v26.current = nil
            end)
        end, { v24 })

        useEffect(function() -- line: 165
            -- upvalues: progress (copy), v19 (copy), v22 (copy), v25 (copy), v27 (copy), t3 (copy)
            if not v19 then
                return nil
            end

            v22:spring(progress, {
                frequency = 3
            })

            local current = v25.current

            if current >= 0 and current < progress then
                for i = 0, #t3 - 1 do
                    local v29 = t3[i + 1]

                    if current < v29 and v29 <= progress then
                        v27()
                        break
                    end
                end
            end

            v25.current = if progress < current then -1 else progress
        end, { progress, v22, v19, v27 })
        useEffect(function() -- line: 185
            -- upvalues: progress (copy), v19 (copy), v25 (copy), v27 (copy), RunService (copy), t3 (copy)
            if v19 then
                return nil
            end

            local connection = RunService.Heartbeat:Connect(function() -- line: 190
                -- upvalues: progress (copy), v25 (copy), v27 (copy), t3 (copy)
                local v30 = progress:getValue()
                local current = v25.current

                if current >= 0 and current < v30 then
                    for i = 0, #t3 - 1 do
                        local v31 = t3[i + 1]

                        if current < v31 and v31 <= v30 then
                            v27()
                            break
                        end
                    end
                end

                v25.current = if v30 < current then -1 else v30
            end)

            return function() -- line: 204
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, { v19, progress, v27 })

        if not v19 then
            v21 = progress
        end

        local v32 = v21:map(function(p4) -- line: 211
            -- upvalues: v8 (copy), v12 (copy), v14 (copy)
            return (math.clamp(p4 * v8 - v12 / 2, 0, v14))
        end)
        local v34 = v32:map(function(p5) -- line: 214
            -- upvalues: v12 (copy)
            return UDim2.fromScale(-p5 / v12, 0)
        end)
        local v35 = joinBindings({ v21, v32 }):map(function(p6) -- line: 217
            -- upvalues: v8 (copy), v12 (copy)
            local v36 = p6[1]
            local v37 = p6[2]

            return UDim2.fromScale(math.clamp((v36 * v8 - v37) / v12, 0.5 / v12, 1 - 0.5 / v12), 0)
        end)
        local v41 = v32:map(function(p7) -- line: 224
            if p7 <= 0 then
                return 1
            end

            return 0
        end)
        local v42 = v32:map(function(p8) -- line: 227
            -- upvalues: v14 (copy)
            if v14 <= p8 then
                return 1
            end

            return 0
        end)
        local v43 = type(studsOverride) == "number"
        local v44 = if studsOverride == nil then v21:map(function(p9) -- line: 231
            -- upvalues: v9 (copy)
            return (("%* studs"):format((math.round(p9 * v9))))
        end)
            elseif v43 then ("%* studs"):format((math.round(studsOverride)))
            else studsOverride:map(function(p10) -- line: 233
                return (("%* studs"):format((math.round(p10))))
            end)
        local v46 = react.createElement("uistroke", {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = xsm
        })
        local v47 = react.createElement("uiaspectratioconstraint", {
            AspectRatio = v12,
            DominantAxis = Enum.DominantAxis.Width
        })
        local v48 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = UDim.new(0, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        })
        local v49 = table.create(#t2)

        local function v50(p11, p12) -- line: 254
            -- upvalues: zIndex (ref), react (copy), default2 (copy), v8 (copy)
            return react.createElement("frame", {
                BorderSizePixel = 0,
                BackgroundColor3 = p11.mainColor,
                LayoutOrder = p12,
                Size = UDim2.fromScale(1 / v8, 1),
                ZIndex = zIndex + 1,
                key = p11.label
            }, p11.gradient ~= nil and react.createElement("uigradient", {
                Color = p11.gradient
            }), react.createElement("frame", {
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = if p11.innerGradient == nil then p11.mainColor else Color3.fromRGB(255, 255, 255),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.9, 0.9),
                ZIndex = zIndex + 2
            }, p11.innerGradient ~= nil and react.createElement("uigradient", {
                Color = p11.innerGradient
            }), p11.innerImage ~= nil and react.createElement("imagelabel", {
                BackgroundTransparency = 1,
                ScaleType = "Stretch",
                AnchorPoint = Vector2.new(0.5, 0.5),
                Image = p11.innerImage,
                ImageTransparency = p11.label == "Secret" and 0.7 or 0,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1),
                ZIndex = zIndex + 3
            }), react.createElement(default2, {
                hasStroke = true,
                overrideProps = {
                    TextScaled = true,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Font = Enum.Font.GothamBold,
                    Position = UDim2.fromScale(0.5, 0.15),
                    Size = UDim2.fromScale(1, 0.23),
                    TextXAlignment = Enum.TextXAlignment.Center,
                    ZIndex = zIndex + 15
                },
                strokeProps = {
                    Thickness = 0.1,
                    Color = Color3.fromRGB(0, 0, 0)
                },
                text = p11.label,
                textColor3 = Color3.fromRGB(255, 255, 255)
            })))
        end

        for v54, v55 in t2 do
            v49[v54] = v50(v55, v54 - 1, t2)
        end

        local v56 = react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            ZIndex = zIndex
        }, v48, v49)
        local v57 = table.create(#t2)

        local function v58(_, p14) -- line: 312
            -- upvalues: zIndex (ref), react (copy), v8 (copy), t3 (copy)
            if p14 < v8 - 1 then
                return (react.createElement("frame", {
                    BorderSizePixel = 0,
                    AnchorPoint = Vector2.new(0.5, 0),
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                    Position = UDim2.fromScale(t3[p14 + 1], 0),
                    Size = UDim2.new(0, 2, 1, 0),
                    ZIndex = zIndex + 3,
                    key = ("div-%*"):format(p14)
                }))
            end

            return false
        end

        for v59, v60 in t2 do
            v57[v59] = v58(v60, v59 - 1, t2)
        end

        return react.createElement(default, {
            cornerRadius = 0,
            anchorPoint = anchorPoint,
            backgroundColor = Color3.fromRGB(12, 12, 12),
            position = position,
            size = UDim2.fromScale(0.94, 0.12),
            zIndex = zIndex
        }, v46, v47, react.createElement("frame", {
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Size = UDim2.fromScale(1, 1),
            ZIndex = zIndex
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            Position = v34,
            Size = UDim2.fromScale(v13, 1),
            ZIndex = zIndex
        }, v56, react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            ZIndex = zIndex + 3
        }, v57))), react.createElement("frame", {
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0, 0),
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            BackgroundTransparency = v41,
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.fromScale(0.15, 1),
            ZIndex = zIndex + 5
        }, react.createElement("uigradient", {
            Rotation = 0,
            Transparency = v15
        })), react.createElement("frame", {
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(1, 0),
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            BackgroundTransparency = v42,
            Position = UDim2.fromScale(1, 0),
            Size = UDim2.fromScale(0.15, 1),
            ZIndex = zIndex + 5
        }, react.createElement("uigradient", {
            Rotation = 180,
            Transparency = v15
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = v35,
            Size = UDim2.fromScale(1 / v12, 1.5),
            ZIndex = zIndex + 8
        }, react.createElement("frame", {
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0.5, 0.3333333333333333),
            Size = v23:map(function(p15) -- line: 381
                return UDim2.fromScale(0.6 * p15, 0.39999999999999997 * p15)
            end),
            ZIndex = zIndex + 9
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(1, 0)
        }), react.createElement("uistroke", {
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = xsm
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = v16,
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Crop,
            Size = UDim2.fromScale(1, 1),
            ZIndex = zIndex + 10
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(1, 0)
        }))), react.createElement(default2, {
            hasStroke = true,
            overrideProps = {
                AnchorPoint = Vector2.new(0.5, 0),
                Font = Enum.Font.GothamBold,
                Position = UDim2.fromScale(0.5, 0.7),
                Size = UDim2.fromScale(1.5, 0.25),
                TextXAlignment = Enum.TextXAlignment.Center,
                ZIndex = zIndex + 9
            },
            strokeProps = {
                Thickness = 0.1,
                Color = Color3.fromRGB(0, 0, 0)
            },
            text = v44,
            textColor3 = Color3.fromRGB(255, 255, 255)
        })))
    end
}
