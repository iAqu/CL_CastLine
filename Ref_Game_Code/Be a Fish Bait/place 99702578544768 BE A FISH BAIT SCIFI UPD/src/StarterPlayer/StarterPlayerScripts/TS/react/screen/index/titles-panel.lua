-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useMemo = react.useEffect, react.useMemo
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "scrolling-frame").default
local default5 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "og-prime-title-effects").default
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelector
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local titlesData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "titles").titlesData
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerEquippedTitle, selectPlayerUnlockedTitles = selectors.selectPlayerEquippedTitle, selectors.selectPlayerUnlockedTitles
local v1 = ColorSequence.new(Color3.fromRGB(120, 200, 90))
local v2 = ColorSequence.new(Color3.fromRGB(230, 80, 80))
local t1 = {}

local function v3(p1) -- line: 27
    return p1.obtainable
end

local n1 = 0

for v4, v5 in titlesData do
    local _ = v4 - 1

    if v5.obtainable == true then
        n1 += 1
        t1[n1] = v5
    end
end

table.sort(t1, function(p2, p3) -- line: 38
    return p2.order < p3.order
end)

local function CelebrationTitleName(p4) -- line: 42
    -- upvalues: react (copy), useEffect (copy), useMotion (copy), default2 (copy), default5 (copy), useTheme (copy), images (copy)
    local title = p4.title
    local v6 = useTheme()
    local v7 = title.visualTier == "premiumEvent"
    local v8, v9 = useMotion(0)
    local v10, v11 = useMotion(1)

    useEffect(function() -- line: 48
        -- upvalues: v9 (copy), v11 (copy), v7 (copy)
        local v12 = true

        v9:linear(360, {
            speed = 45
        })

        local v13 = v9:onComplete(function() -- line: 56
            -- upvalues: v9 (copy)
            v9:immediate(0)
            v9:linear(360, {
                speed = 45
            })
        end)
        local v14

        if v7 then
            v11:spring(1.035, {
                damping = 0.8,
                frequency = 0.35
            })
            v14 = v11:onComplete(function() -- line: 66
                -- upvalues: v12 (ref), v11 (copy)
                v12 = not v12
                v11:spring(v12 and 1.035 or 1, {
                    damping = 0.8,
                    frequency = 0.35
                })
            end)
        else
            v11:immediate(1)
        end

        return function() -- line: 77
            -- upvalues: v13 (copy), v14 (ref)
            v13()

            local v16 = v14

            if v16 ~= nil then
                v16()
            end
        end
    end, { v7, v11, v9 })

    local createElement = react.createElement
    local t2 = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1)
    }
    local createElement2 = react.createElement

    if not v7 then
        v10 = 1
    end

    return createElement("frame", t2, createElement2("uiscale", {
        Scale = v10
    }), title.visualTier == "premiumEvent" and react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ZIndex = 6,
        AnchorPoint = Vector2.new(0, 0.5),
        Image = images.eventIcon,
        Position = UDim2.fromScale(0, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.105, 0.82)
    }), react.createElement(default2, {
        gradientRotation = 0,
        color = title.animatedColor or title.color,
        gradientOffset = v8:map(function(p5) -- line: 101
            return Vector2.new(math.sin((math.rad(p5))) * 0.22, 0)
        end),
        overrideProps = {
            TextScaled = true,
            ZIndex = 5,
            Font = v6.textFont2,
            Position = UDim2.fromScale(title.visualTier == "premiumEvent" and 0.115 or 0, 0),
            Size = UDim2.fromScale(title.visualTier == "premiumEvent" and 0.58 or 0.88, 1),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        text = title.displayName
    }), title.visualTier == "premiumEvent" and react.createElement(react.Fragment, nil, react.createElement(default5, {
        zIndex = 8,
        animationProgress = v8
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ImageTransparency = 0,
        ZIndex = 10,
        AnchorPoint = Vector2.new(1, 0.5),
        Image = images.sparkleIcon,
        ImageColor3 = Color3.fromRGB(255, 235, 125),
        Position = UDim2.fromScale(0.555, 0.44),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.075, 0.5)
    })))
end

return {
    default = function() -- TitlesPanel | line: 129
        -- upvalues: react (copy), useMemo (copy), default (copy), default2 (copy), default3 (copy), default4 (copy), useRootSelector (copy), useScreenSizeState (copy), useTheme (copy), localPlayerUserId (copy), functions (copy), images (copy), selectPlayerEquippedTitle (copy), selectPlayerUnlockedTitles (copy), v1 (copy), v2 (copy), t1 (copy), CelebrationTitleName (copy)
        local v20 = useScreenSizeState()
        local v21 = useTheme()
        local v22 = useRootSelector(selectPlayerUnlockedTitles(localPlayerUserId))
        local v23 = useRootSelector(selectPlayerEquippedTitle(localPlayerUserId))
        local v24 = useMemo(function() -- line: 134
            -- upvalues: v22 (copy)
            local t6 = {}

            for _, v25 in v22 do
                t6[v25] = true
            end

            return t6
        end, { v22 })
        local v26 = v20 == "sm"
        local v27, v28, v29, v30, v31, v32, v33, v34, v35

        if v26 then
            v32 = 4
            v33 = 3.05
            v34 = 14
            v35 = 12
            v29 = 0.56
            v30 = 0.68
            v28 = UDim2.fromScale(1.035, 0.8)
            v31 = UDim2.fromScale(0.29, 0.58)
            v27 = 0.055
        else
            v32 = if v20 == "md" then 7 else 10
            v33 = if v20 == "md" then 3.55 else 3.75
            v34 = if v20 == "md" then 16 else 18
            v35 = 16
            v29 = 0.64
            v30 = if v20 == "md" then 0.74 else 0.76
            v28 = UDim2.fromScale(1.045, 0.8)
            v31 = UDim2.fromScale(0.24, 0.6)
            v27 = 0.045
        end

        local v36 = table.create(#t1)

        local function v37(p6) -- line: 153
            -- upvalues: v21 (copy), v23 (copy), v24 (copy), v27 (ref), v28 (ref), v29 (ref), v30 (ref), v31 (ref), react (copy), default (copy), default2 (copy), default3 (copy), functions (copy), images (copy), v1 (copy), v2 (copy), CelebrationTitleName (copy)
            local v38 = v24[p6.id] ~= nil
            local v39 = v23 == p6.id
            local v40 = if p6.animatedColor then p6.animatedColor else p6.color

            if p6.animatedColor then
            end

            local color = p6.color
            local v41 = if v38 or p6.lockedDisplayName == nil then p6.displayName else p6.lockedDisplayName
            local v42 = if v38 or p6.lockedDescription == nil then p6.description else p6.lockedDescription
            local v43 = not v38 and p6.lockedDescription ~= nil
            local createElement = react.createElement
            local t7 = {
                cornerRadius = 0.08,
                isStudded = true,
                textureTransparency = 0.55,
                transparency = 0.3,
                zIndex = 4,
                backgroundColor = Color3.fromRGB(20, 20, 20),
                key = p6.id,
                size = UDim2.fromScale(1, 1),
                strokeColor = color,
                strokeThickness = v39 and 0.025 or 0.018,
                strokeTransparency = v38 and 0 or 0.28
            }
            local v46 = react.createElement("frame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 5,
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.fromScale(0.03, 0.5),
                Size = UDim2.fromScale(if v43 then v30 else v29, 0.78)
            }, react.createElement("uilistlayout", {
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                Padding = UDim.new(0.04, 0),
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center
            }), react.createElement("frame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                LayoutOrder = 1,
                ZIndex = 5,
                Size = UDim2.fromScale(1, 0.5)
            }, if p6.id == "markOfTheOg" or p6.visualTier == "premiumEvent" then react.createElement(CelebrationTitleName, {
                title = p6
            }) else react.createElement(default2, {
                color = v40,
                overrideProps = {
                    TextScaled = true,
                    ZIndex = 5,
                    Font = v21.textFont2,
                    Size = UDim2.fromScale(1, 1),
                    TextXAlignment = Enum.TextXAlignment.Left
                },
                text = v41
            })), react.createElement("frame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                LayoutOrder = 2,
                ZIndex = 5,
                Size = UDim2.fromScale(1, v43 and 0.46 or 0.4)
            }, react.createElement("textlabel", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                TextScaled = true,
                TextStrokeTransparency = 0.1,
                ZIndex = 5,
                Font = v21.textFont,
                Size = UDim2.fromScale(1, 1),
                Text = v42,
                TextColor3 = Color3.fromRGB(245, 245, 245),
                TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left
            }, react.createElement("uistroke", {
                Transparency = 0.25,
                Color = Color3.fromRGB(0, 0, 0),
                StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize,
                Thickness = v27
            }))))
            local createElement4 = react.createElement
            local t10 = {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 6,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = if v38 then v28 else UDim2.fromScale(v28.X.Scale, 0.5),
                Size = v31
            }

            if not v38 then
                local v47 = react.createElement("imagelabel", {
                    BackgroundTransparency = 1,
                    ZIndex = 6,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = images.lockIcon,
                    ImageColor3 = Color3.new(1, 1, 1),
                    Position = UDim2.fromScale(0.5, 0.5),
                    ScaleType = Enum.ScaleType.Fit,
                    Size = UDim2.fromScale(0.55, 0.9)
                })

                return createElement(default, t7, v46, createElement4("frame", t10, v47))
            end

            return createElement(default, t7, v46, createElement4("frame", t10, (react.createElement(default3, {
                cornerRadius = 0.18,
                zIndex = 6,
                color = if v39 then v2 else v1,
                frameSize = UDim2.fromScale(1, 1),
                label = v39 and "Unequip" or "Equip",
                onClick = function() -- onClick | line: 240
                    -- upvalues: p6 (copy), v39 (copy), functions (copy)
                    local id = if v39 then nil else p6.id

                    functions.equipTitle(id)
                end
            }))))
        end

        for v48, v49 in t1 do
            v36[v48] = v37(v49, v48 - 1, t1)
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.965),
            Size = UDim2.fromScale(v26 and 0.94 or 0.9, v26 and 0.8 or 0.82)
        }, react.createElement(default4, {
            cellsPerRow = 1,
            clipsDescendants = true,
            zIndex = 3,
            anchorPoint = Vector2.new(0.5, 0.5),
            fillDirection = Enum.FillDirection.Horizontal,
            horizontalAlignment = Enum.HorizontalAlignment.Center,
            listPaddingOffset = v34,
            padding = {
                all = UDim.new(0, v35)
            },
            position = UDim2.fromScale(0.5, 0.5),
            rowsToBeVisible = v33,
            scrollBarColor = Color3.fromRGB(10, 10, 10),
            scrollBarThickness = v32,
            size = UDim2.fromScale(1, 1),
            verticalAlignment = Enum.VerticalAlignment.Top
        }, v36))
    end
}
