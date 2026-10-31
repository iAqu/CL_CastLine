-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local react = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")

return {
    default = react.memo(function(p1) -- ConsoleCrosshair | line: 6
        -- upvalues: react (copy)
        return react.createElement("frame", {
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            ZIndex = 50,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(8, 8),
            Visible = p1.visible
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(1, 0)
        }), react.createElement("uistroke", {
            Thickness = 2,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Color3.fromRGB(0, 0, 0)
        }))
    end)
}
