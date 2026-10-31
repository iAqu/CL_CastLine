-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(218, 72, 240)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(157, 35, 201))
})

return {
    default = function(p1) -- ExclusiveShopGiftButton | line: 7
        -- upvalues: react (copy), default (copy), images (copy), v1 (copy)
        local zIndex = p1.zIndex

        if zIndex == nil then
            zIndex = 4
        end

        return react.createElement(default, {
            cornerRadius = 0.1,
            label = "",
            anchorPoint = p1.anchorPoint,
            color = v1,
            frameSize = p1.frameSize,
            layoutOrder = p1.layoutOrder,
            onClick = p1.onClick,
            popoutColor = Color3.fromRGB(104, 25, 137),
            position = p1.position,
            zIndex = zIndex
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.giftBox,
            Position = UDim2.fromScale(0.5, 0.46),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.72, 0.72),
            ZIndex = zIndex + 4
        }))
    end
}
