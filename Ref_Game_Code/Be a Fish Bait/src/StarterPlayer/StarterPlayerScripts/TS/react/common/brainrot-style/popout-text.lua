-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent, "styled-text-label").default

return {
    default = function(p1) -- PopoutText | line: 5
        -- upvalues: react (copy), default (copy)
        local anchorPoint, color, overrideProps, position = p1.anchorPoint, p1.color, p1.overrideProps, p1.position
        local strokeProps, text = p1.strokeProps, p1.text
        local v1 = typeof(color) == "ColorSequence"
        local t1 = {
            AnchorPoint = if anchorPoint ~= nil then anchorPoint elseif overrideProps == nil then overrideProps else overrideProps.AnchorPoint,
            AutomaticSize = if overrideProps == nil then overrideProps else overrideProps.AutomaticSize,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = if overrideProps == nil then overrideProps else overrideProps.LayoutOrder,
            Position = if position ~= nil then position elseif overrideProps == nil then overrideProps else overrideProps.Position
        }
        local v2 = if overrideProps == nil then overrideProps else overrideProps.Size

        t1.Size = if v2 == nil then UDim2.fromScale(1, 1) else v2
        t1.ZIndex = if overrideProps == nil then overrideProps else overrideProps.ZIndex

        local t2 = {}
        local t3 = {}

        if overrideProps then
            for v3, v4 in overrideProps do
                t3[v3] = v4
            end
        end

        t3.AnchorPoint = Vector2.new(0, 0)
        t3.BackgroundTransparency = 1
        t3.LayoutOrder = nil
        t3.Position = UDim2.fromScale(0.01, 0.05)
        t3.Size = UDim2.fromScale(1, 1)
        t3.TextColor3 = Color3.fromRGB(0, 0, 0)
        t3.ZIndex = 1
        t2.overrideProps = t3
        t2.strokeProps = strokeProps
        t2.text = text

        local v5 = react.createElement(default, t2)
        local t4 = {}
        local t5 = {}

        if overrideProps then
            for v6, v7 in overrideProps do
                t5[v6] = v7
            end
        end

        t5.AnchorPoint = Vector2.new(0, 0)
        t5.BackgroundTransparency = 1
        t5.LayoutOrder = nil
        t5.Position = UDim2.fromScale(0, 0)
        t5.Size = UDim2.fromScale(1, 1)
        t5.TextColor3 = if v1 then Color3.fromRGB(255, 255, 255) else color
        t5.ZIndex = 2
        t4.overrideProps = t5
        t4.strokeProps = strokeProps
        t4.text = text

        return react.createElement("frame", t1, v5, react.createElement(default, t4, v1 and react.createElement("uigradient", {
            Rotation = 90,
            Color = color
        })))
    end
}
