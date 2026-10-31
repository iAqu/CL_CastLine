-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local shallowEqual = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").shallowEqual
local default = RuntimeLib.import(script, script.Parent.Parent, "styled-text-label").default

local function v1(p1) -- line: 6
    -- upvalues: react (copy), default (copy)
    local anchorPoint, color, gradientOffset, gradientRotation = p1.anchorPoint, p1.color, p1.gradientOffset, p1.gradientRotation

    if gradientRotation == nil then
        gradientRotation = 90
    end

    local overrideProps, popoutColor = p1.overrideProps, p1.popoutColor

    if popoutColor == nil then
        popoutColor = Color3.fromRGB(0, 0, 0)
    end

    local position, shadowYScale = p1.position, p1.shadowYScale

    if shadowYScale == nil then
        shadowYScale = 0.1
    end

    local shadowText, strokeProps, text, textTransparency = p1.shadowText, p1.strokeProps, p1.text, p1.textTransparency
    local v2 = typeof(color) == "ColorSequence"
    local v3 = if overrideProps == nil then overrideProps else overrideProps.AutomaticSize
    local v4 = if v3 == Enum.AutomaticSize.X or v3 == Enum.AutomaticSize.XY then UDim2.fromScale(0, 1) else UDim2.fromScale(1, 1)
    local t1 = {
        AnchorPoint = if anchorPoint ~= nil then anchorPoint elseif overrideProps == nil then overrideProps else overrideProps.AnchorPoint,
        AutomaticSize = v3,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = if overrideProps == nil then overrideProps else overrideProps.LayoutOrder,
        Position = if position ~= nil then position elseif overrideProps == nil then overrideProps else overrideProps.Position
    }
    local v5 = if overrideProps == nil then overrideProps else overrideProps.Size

    t1.Size = if v5 == nil then v4 else v5
    t1.ZIndex = if overrideProps == nil then overrideProps else overrideProps.ZIndex

    local t2 = {
        hasStroke = false
    }
    local t3 = {}

    if overrideProps then
        for v6, v7 in overrideProps do
            t3[v6] = v7
        end
    end

    t3.AnchorPoint = Vector2.new(0, 0)
    t3.BackgroundTransparency = 1
    t3.LayoutOrder = nil
    t3.Position = UDim2.fromScale(0, shadowYScale)
    t3.Size = v4
    t3.TextColor3 = popoutColor
    t3.ZIndex = if (if overrideProps == nil then overrideProps else overrideProps.ZIndex) == nil then 1 else overrideProps.ZIndex
    t2.overrideProps = t3
    t2.text = if shadowText == nil then text else shadowText
    t2.textTransparency = textTransparency

    local v8 = react.createElement(default, t2)
    local t4 = {}
    local t5 = {}

    if overrideProps then
        for v9, v10 in overrideProps do
            t5[v9] = v10
        end
    end

    t5.AnchorPoint = Vector2.new(0, 0)
    t5.BackgroundTransparency = 1
    t5.LayoutOrder = nil
    t5.Position = UDim2.fromScale(0, 0)
    t5.Size = v4
    t5.TextColor3 = if v2 then Color3.fromRGB(255, 255, 255) else color
    t5.ZIndex = if (if overrideProps == nil then overrideProps else overrideProps.ZIndex) == nil then 2 else overrideProps.ZIndex + 1
    t4.overrideProps = t5

    local t6 = {
        Thickness = 0.075,
        StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    }

    if strokeProps then
        for v11, v12 in strokeProps do
            t6[v11] = v12
        end
    end

    t4.strokeProps = t6
    t4.text = text
    t4.textTransparency = textTransparency

    return react.createElement("frame", t1, v8, react.createElement(default, t4, v2 and react.createElement("uigradient", {
        Color = color,
        Offset = gradientOffset,
        Rotation = gradientRotation
    })))
end

return {
    default = react.memo(v1, function(p2, p3) -- line: 151
        -- upvalues: shallowEqual (copy)
        local overrideProps, strokeProps = p2.overrideProps, p2.strokeProps
        local overrideProps2, strokeProps2 = p3.overrideProps, p3.strokeProps
        local v13 = table.clone(p2)

        setmetatable(v13, nil)
        v13.overrideProps = nil
        v13.strokeProps = nil

        local v14 = table.clone(p3)

        setmetatable(v14, nil)
        v14.overrideProps = nil
        v14.strokeProps = nil

        return shallowEqual(overrideProps, overrideProps2) and shallowEqual(strokeProps, strokeProps2) and shallowEqual(v13, v14)
    end)
}
