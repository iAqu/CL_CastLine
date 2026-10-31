-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent, "celebration-event-shop", "celebration-sunburst-glow").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "styled-text-label").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local v1 = Color3.fromRGB(210, 213, 222)
local v2 = Color3.fromRGB(75, 80, 92)
local v3 = Color3.fromRGB(168, 42, 191)
local v4 = Color3.fromRGB(20, 22, 33)
local v5 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 252, 220)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 220, 90)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(245, 170, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 110, 10))
})

local function PlaceholderImageFrame(p1) -- line: 27
    -- upvalues: react (copy), default (copy), default2 (copy), default3 (copy), useTheme (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy)
    local anchorPoint, aspectRatio, content, cornerRadius = p1.anchorPoint, p1.aspectRatio, p1.content, p1.cornerRadius

    if cornerRadius == nil then
        cornerRadius = 0.06
    end

    local description = p1.description

    if description == nil then
        description = ""
    end

    local image, imageSize, layoutOrder, position = p1.image, p1.imageSize, p1.layoutOrder, p1.position
    local scaleType = p1.scaleType

    if scaleType == nil then
        scaleType = Enum.ScaleType.Crop
    end

    local showSunburst = p1.showSunburst

    if showSunburst == nil then
        showSunburst = false
    end

    local size, titleText, zIndex = p1.size, p1.titleText, p1.zIndex

    if zIndex == nil then
        zIndex = 1
    end

    local v6 = useTheme()
    local v7 = content ~= nil or titleText ~= nil
    local createElement = react.createElement
    local t1 = {
        BackgroundTransparency = 1,
        AnchorPoint = anchorPoint,
        LayoutOrder = layoutOrder,
        Position = position,
        Size = size or UDim2.fromScale(1, 1),
        ZIndex = zIndex
    }
    local v8 = aspectRatio ~= nil and react.createElement("uiaspectratioconstraint", {
        AspectRatio = aspectRatio
    })
    local v9 = showSunburst and react.createElement(default, {
        color = Color3.new(1, 1, 1),
        position = UDim2.fromScale(0.5, 0.5),
        size = UDim2.fromScale(0.85, 0.85),
        zIndex = zIndex - 2
    })
    local createElement2 = react.createElement
    local t2 = {
        BorderSizePixel = 0,
        ClipsDescendants = true,
        BackgroundColor3 = if v7 then v4 else v1,
        BackgroundTransparency = not (not v7 and image == nil) and 1 or 0.1,
        Size = UDim2.fromScale(1, 1),
        ZIndex = zIndex
    }
    local v10 = react.createElement("uicorner", {
        CornerRadius = UDim.new(cornerRadius, 0)
    })

    if content == nil then
        content = if titleText ~= nil then react.createElement(default2, {
            anchorPoint = Vector2.new(0.5, 0.5),
            color = v5,
            overrideProps = {
                TextScaled = true,
                TextWrapped = true,
                Font = v6.textFont2,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.85, 0.7)
            },
            popoutColor = Color3.fromRGB(90, 60, 0),
            position = UDim2.fromScale(0.5, 0.5),
            strokeProps = {
                Color = Color3.fromRGB(90, 60, 0)
            },
            text = titleText
        })
            elseif image ~= nil then react.createElement("imagelabel", {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Image = image,
                Position = UDim2.fromScale(0.5, 0.5),
                ScaleType = scaleType,
                Size = imageSize or UDim2.fromScale(1, 1)
            }, react.createElement("uicorner", {
                CornerRadius = UDim.new(cornerRadius, 0)
            }))
            else react.createElement(default3, {
                hasStroke = false,
                overrideProps = {
                    TextScaled = true,
                    TextWrapped = true,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromScale(0.85, 0.7),
                    TextColor3 = v2
                },
                text = description
            })
    end

    return createElement("frame", t1, v8, v9, createElement2("frame", t2, v10, content), react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(0.99, 0.99),
        ZIndex = zIndex + 1
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(cornerRadius, 0)
    }), react.createElement("uistroke", {
        Thickness = 0.03,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = v3,
        StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    })))
end

return {
    PlaceholderImageFrame = PlaceholderImageFrame,
    LabeledImageSlot = function(p2) -- LabeledImageSlot | line: 145
        -- upvalues: react (copy), default2 (copy), useTheme (copy), PlaceholderImageFrame (copy)
        local aspectRatio, content, description, image = p2.aspectRatio, p2.content, p2.description, p2.image
        local imageSize, label, layoutOrder, scaleType = p2.imageSize, p2.label, p2.layoutOrder, p2.scaleType
        local showSunburst = p2.showSunburst

        if showSunburst == nil then
            showSunburst = false
        end

        local size, textPosition = p2.size, p2.textPosition

        if textPosition == nil then
            textPosition = "bottom"
        end

        local textYPosition, textYSize, titleSize = p2.textYPosition, p2.textYSize, p2.titleSize

        if titleSize == nil then
            titleSize = 0.22
        end

        local titleTreatment = p2.titleTreatment

        if titleTreatment == nil then
            titleTreatment = false
        end

        local v11 = useTheme()
        local v12 = 1 - titleSize
        local v13 = if textPosition == "top" then 0 else v12
        local v14 = if textPosition == "top" then titleSize else 0
        local v15 = react.createElement(PlaceholderImageFrame, {
            anchorPoint = Vector2.new(0.5, 0.5),
            aspectRatio = aspectRatio,
            content = content,
            description = description,
            image = image,
            imageSize = imageSize,
            position = UDim2.fromScale(0.5, v14 + v12 / 2),
            scaleType = scaleType,
            showSunburst = showSunburst,
            size = UDim2.fromScale(1, v12),
            titleText = if titleTreatment then label else nil
        })
        local t5 = {
            anchorPoint = Vector2.new(0.5, 0),
            color = Color3.new(1, 1, 1)
        }
        local t6 = {
            Font = v11.textFont
        }

        if textYSize ~= nil then
            titleSize = textYSize
        end

        t6.Size = UDim2.fromScale(1, titleSize)
        t6.TextScaled = true
        t6.TextWrapped = true
        t5.overrideProps = t6

        if textYPosition ~= nil then
            v13 = textYPosition
        end

        t5.position = UDim2.fromScale(0.5, v13)
        t5.shadowYScale = 0.06
        t5.text = label

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = layoutOrder,
            Size = size or UDim2.fromScale(1, 1)
        }, v15, react.createElement(default2, t5))
    end,
    celebrationImageBorderColor = v3
}
