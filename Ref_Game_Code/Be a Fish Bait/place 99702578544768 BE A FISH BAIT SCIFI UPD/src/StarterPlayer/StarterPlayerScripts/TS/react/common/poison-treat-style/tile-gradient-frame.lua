-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent, "tile-background").default
local useScreenSize = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSize

return {
    default = function(p1) -- TileGradientFrame | line: 6
        -- upvalues: react (copy), default (copy), useScreenSize (copy)
        local colorSequence = p1.colorSequence

        if colorSequence then
            local t1 = {
                Color = p1.colorSequence
            }
            local gradientRotation = p1.gradientRotation

            t1.Rotation = if gradientRotation == nil then 90 else gradientRotation
            colorSequence = react.createElement("uigradient", t1)
        end

        local v1 = useScreenSize():map(function(p2) -- line: 21
            if p2 == "sm" then
                return 2
            end

            if p2 == "md" then
                return 3
            end

            return 4
        end)
        local borderSizePixel = p1.borderSizePixel

        if borderSizePixel ~= nil then
            v1 = borderSizePixel
        end

        if p1.disableTileBackground then
            return react.createElement("frame", {
                AnchorPoint = p1.anchorPoint,
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderColor3 = p1.borderColor or Color3.new(0, 0, 0),
                BorderSizePixel = v1,
                ClipsDescendants = p1.clipsDescendants,
                LayoutOrder = p1.layoutOrder,
                Position = p1.position,
                Size = p1.size or UDim2.fromScale(1, 1),
                ZIndex = p1.zIndex
            }, colorSequence, p1.children)
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = p1.anchorPoint,
            ClipsDescendants = p1.clipsDescendants,
            LayoutOrder = p1.layoutOrder,
            Position = p1.position,
            Size = p1.size or UDim2.fromScale(1, 1),
            ZIndex = p1.zIndex
        }, react.createElement(default, {
            borderColor = p1.borderColor,
            borderSizePixel = v1,
            color = Color3.new(1, 1, 1),
            size = UDim2.fromScale(1, 1),
            zIndex = p1.zIndex
        }, colorSequence, p1.children))
    end
}
