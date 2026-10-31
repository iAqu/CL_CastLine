-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "cyt-button").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "styled-text-label").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "rounded-frame").default
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images

return {
    default = function(p1) -- Backpack | line: 9
        -- upvalues: react (copy), default (copy), default2 (copy), default3 (copy), images (copy)
        return react.createElement(default, {
            darkenOnHover = false,
            uiAspectRatio = 1,
            borderColor = Color3.fromRGB(0, 0, 0),
            colorSequence = ColorSequence.new(Color3.fromRGB(200, 0, 0)),
            layoutOrder = p1.layoutOrder,
            onClick = p1.onClick or function() -- line: 15
            end,
            size = UDim2.fromScale(1, 1)
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.backpackIcon,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }), if #p1.excessItems > 0 then react.createElement(default3, {
            cornerRadius = 40,
            zIndex = 1,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor3 = Color3.fromRGB(255, 0, 0),
            position = UDim2.fromScale(0.8, 1),
            size = UDim2.fromScale(0.5, 0.5)
        }, react.createElement("uistroke", {
            Thickness = 0.04,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Color3.fromRGB(0, 0, 0),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        }), react.createElement(default2, {
            hasStroke = true,
            overrideProps = {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.7, 0.7)
            },
            text = tostring(#p1.excessItems),
            textColor3 = Color3.new(1, 1, 1)
        })) else nil)
    end
}
