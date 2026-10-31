-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local react = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")

return {
    default = function(p1) -- RoundedFrame | line: 4
        -- upvalues: react (copy)
        local t1 = {
            AnchorPoint = p1.anchorPoint or Vector2.new(0.5, 0.5),
            BackgroundColor3 = if p1.backgroundColorSequence then Color3.new(255, 255, 255) else p1.backgroundColor3 or Color3.fromRGB(1, 1, 1)
        }
        local backgroundTransparency = p1.backgroundTransparency

        t1.BackgroundTransparency = if backgroundTransparency == nil then 0 else backgroundTransparency

        local clipDescendants = p1.clipDescendants

        t1.ClipsDescendants = clipDescendants ~= nil and clipDescendants

        local layoutOrder = p1.layoutOrder

        t1.LayoutOrder = if layoutOrder == nil then 0 else layoutOrder
        t1.Position = p1.position or UDim2.fromScale(0.5, 0.5)
        t1.Size = p1.size or UDim2.fromScale(1, 1)

        local zIndex = p1.zIndex

        t1.ZIndex = if zIndex == nil then 0 else zIndex

        local cornerRadius = p1.cornerRadius

        if cornerRadius == nil then
            cornerRadius = 5
        end

        local t2 = {
            CornerRadius = UDim.new(0, cornerRadius)
        }

        return react.createElement("frame", t1, react.createElement("uicorner", t2), if p1.backgroundColorSequence then react.createElement("uigradient", {
            Color = p1.backgroundColorSequence,
            Offset = p1.gradientOffset or Vector2.new(0, 0)
        }) else nil, if p1.borderThickness ~= nil then react.createElement("uistroke", {
            Color = p1.borderColor3 or Color3.fromRGB(0, 0, 0),
            Thickness = p1.borderThickness
        }) else nil, if p1.aspectRatio == nil then nil else react.createElement("uiaspectratioconstraint", {
            AspectRatio = p1.aspectRatio
        }), p1.children)
    end
}
