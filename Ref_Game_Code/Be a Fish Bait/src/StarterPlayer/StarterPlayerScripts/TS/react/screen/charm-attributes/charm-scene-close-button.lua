-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-button").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default

return {
    default = function(p1) -- CharmSceneCloseButton | line: 7
        -- upvalues: react (copy), default (copy), default2 (copy)
        local onClose, zIndex = p1.onClose, p1.zIndex

        if zIndex == nil then
            zIndex = 950
        end

        return react.createElement(default, {
            aspectRatio = 1,
            cornerRadius = 0.1,
            anchorPoint = Vector2.new(1, 0),
            color = Color3.fromRGB(255, 43, 43),
            onClick = onClose,
            popoutColor = Color3.fromRGB(122, 31, 31),
            position = UDim2.fromScale(0.975, 0.025),
            size = UDim2.fromScale(0.055, 0.085),
            strokeColor = Color3.fromRGB(255, 179, 179),
            zIndex = zIndex
        }, react.createElement(default2, {
            shadowYScale = 0.075,
            text = "X",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(255, 255, 255),
            overrideProps = {
                TextScaled = true,
                Font = Enum.Font.FredokaOne,
                Size = UDim2.fromScale(0.8, 0.8),
                ZIndex = zIndex + 3
            },
            position = UDim2.fromScale(0.5, 0.5)
        }))
    end
}
