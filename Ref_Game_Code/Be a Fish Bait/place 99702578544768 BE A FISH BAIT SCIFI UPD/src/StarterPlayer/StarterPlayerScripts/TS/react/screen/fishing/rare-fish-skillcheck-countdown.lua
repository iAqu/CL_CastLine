-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local react = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")

return {
    default = function(p1) -- RareFishCountdown | line: 10
        -- upvalues: react (copy)
        local fade, isGo, scale, text = p1.fade, p1.isGo, p1.scale, p1.text

        return react.createElement("textlabel", {
            BackgroundTransparency = 1,
            TextScaled = true,
            ZIndex = 100,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Font = Enum.Font.GothamBlack,
            Position = UDim2.fromScale(0.5, 0.44),
            Size = UDim2.fromOffset(500, 360),
            Text = text,
            TextColor3 = if isGo then Color3.fromRGB(90, 255, 140) else Color3.fromRGB(255, 255, 255),
            TextTransparency = fade
        }, react.createElement("uiscale", {
            Scale = scale
        }), react.createElement("uistroke", {
            Thickness = 6,
            Color = Color3.fromRGB(0, 0, 0),
            Transparency = fade
        }))
    end
}
