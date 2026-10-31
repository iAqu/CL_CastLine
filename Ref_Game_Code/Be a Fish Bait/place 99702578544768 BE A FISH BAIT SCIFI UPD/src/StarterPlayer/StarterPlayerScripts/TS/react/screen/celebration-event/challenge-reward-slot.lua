-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "rounded-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images

return {
    default = function(p1) -- ChallengeRewardSlot | line: 12
        -- upvalues: react (copy), default (copy), default2 (copy), images (copy)
        local icon, isClaimed, isLocked, quantity = p1.icon, p1.isClaimed, p1.isLocked, p1.quantity
        local size = p1.size

        if size == nil then
            size = UDim2.fromScale(1, 1)
        end

        local zIndex = p1.zIndex

        if zIndex == nil then
            zIndex = 1
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = size,
            ZIndex = zIndex
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }), react.createElement(default, {
            backgroundTransparency = 0.6,
            cornerRadius = 8,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor3 = Color3.fromRGB(0, 0, 0),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1),
            zIndex = zIndex
        }, react.createElement(default, {
            backgroundTransparency = 0.6,
            cornerRadius = 6,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor3 = Color3.fromRGB(41, 41, 41),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(0.9, 0.9),
            zIndex = zIndex + 1
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = icon,
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.75, 0.75),
            ZIndex = zIndex + 2
        })), isLocked and react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0, 0),
            Image = images.lockIcon,
            Position = UDim2.fromScale(-0.08, -0.08),
            Size = UDim2.fromScale(0.34, 0.34),
            ZIndex = zIndex + 3
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })), isClaimed and react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0),
            Image = images.checkmarkIcon,
            Position = UDim2.fromScale(1.08, -0.08),
            Size = UDim2.fromScale(0.34, 0.34),
            ZIndex = zIndex + 3
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })), quantity ~= nil and react.createElement(default2, {
            anchorPoint = Vector2.new(0.5, 1),
            color = Color3.fromRGB(255, 255, 255),
            overrideProps = {
                TextScaled = true,
                Size = UDim2.fromScale(0.9, 0.26),
                ZIndex = zIndex + 3
            },
            popoutColor = Color3.fromRGB(0, 0, 0),
            position = UDim2.fromScale(0.5, 1.02),
            text = ("x%*"):format(quantity)
        }))
    end
}
