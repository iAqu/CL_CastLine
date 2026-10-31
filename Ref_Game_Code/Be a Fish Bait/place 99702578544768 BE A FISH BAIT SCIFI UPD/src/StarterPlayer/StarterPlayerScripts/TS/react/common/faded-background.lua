-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local react = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local v1 = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.2, 0),
    NumberSequenceKeypoint.new(0.8, 0),
    NumberSequenceKeypoint.new(1, 1)
})

return {
    default = function(p1) -- FadedBackground | line: 5
        -- upvalues: react (copy), v1 (copy)
        local anchorPoint = p1.anchorPoint

        if anchorPoint == nil then
            anchorPoint = Vector2.new(0.5, 0.5)
        end

        local backgroundTransparency = p1.backgroundTransparency

        if backgroundTransparency == nil then
            backgroundTransparency = 0
        end

        local children, color = p1.children, p1.color

        if color == nil then
            color = Color3.fromRGB(0, 0, 0)
        end

        local cornerRadius, position = p1.cornerRadius, p1.position

        if position == nil then
            position = UDim2.fromScale(0.5, 0.5)
        end

        local size = p1.size

        if size == nil then
            size = UDim2.fromScale(1, 1)
        end

        local strokeColor, strokeSize, zIndex = p1.strokeColor, p1.strokeSize, p1.zIndex
        local v2 = cornerRadius ~= nil and react.createElement("uicorner", {
            CornerRadius = cornerRadius
        })
        local v3 = react.createElement("uigradient", {
            Transparency = v1
        })
        local v4 = strokeSize ~= nil and strokeColor ~= nil

        if v4 then
            local t1 = {
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0.5, 0),
                BackgroundColor3 = strokeColor,
                Position = UDim2.fromScale(0.5, 0),
                Size = UDim2.new(1, 0, 0, strokeSize),
                ZIndex = (if zIndex == nil then 0 else zIndex) + 1
            }
            local v5 = react.createElement("frame", t1, react.createElement("uigradient", {
                Transparency = v1
            }))
            local t2 = {
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0.5, 1),
                BackgroundColor3 = strokeColor,
                Position = UDim2.fromScale(0.5, 1),
                Size = UDim2.new(1, 0, 0, strokeSize),
                ZIndex = (if zIndex == nil then 0 else zIndex) + 1
            }

            v4 = react.createElement(react.Fragment, nil, v5, react.createElement("frame", t2, react.createElement("uigradient", {
                Transparency = v1
            })))
        end

        return react.createElement("frame", {
            AnchorPoint = anchorPoint,
            BackgroundColor3 = color,
            BackgroundTransparency = backgroundTransparency,
            Position = position,
            Size = size,
            ZIndex = zIndex
        }, v2, v3, v4, children)
    end
}
