-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useScreenSize = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSize

return {
    default = function(p1) -- BRFrame | line: 5
        -- upvalues: react (copy), useScreenSize (copy)
        local v1 = typeof(p1.backgroundColor) == "ColorSequence"
        local v2 = if v1 then Color3.new(1, 1, 1) else p1.backgroundColor
        local v3 = useScreenSize()
        local tileSize = p1.tileSize

        if tileSize == nil then
            tileSize = 120
        end

        local v5 = math.round(tileSize * 0.5)
        local v6 = v3:map(function(p2) -- line: 16
            -- upvalues: tileSize (ref), v5 (copy)
            if p2 == "sm" then
                return (UDim2.fromOffset(v5, v5))
            end

            return (UDim2.fromOffset(tileSize, tileSize))
        end)
        local v7 = p1.cornerRadius ~= nil and p1.cornerRadius > 0 and react.createElement("uicorner", {
            CornerRadius = UDim.new(p1.cornerRadius, 0)
        })
        local v8 = p1.strokeColor ~= nil

        if v8 then
            local t1 = {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = p1.strokeColor,
                StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
            }
            local strokeThickness = p1.strokeThickness

            t1.Thickness = if strokeThickness == nil then 0.055 else strokeThickness

            local strokeTransparency = p1.strokeTransparency

            t1.Transparency = if strokeTransparency == nil then 0 else strokeTransparency
            v8 = react.createElement("uistroke", t1)
        end

        if v1 then
            local t2 = {
                Color = p1.backgroundColor,
                Offset = p1.gradientOffset
            }
            local gradientRotation = p1.gradientRotation

            t2.Rotation = if gradientRotation == nil then 90 else gradientRotation
            v1 = react.createElement("uigradient", t2)
        end

        local v9 = react.createElement(react.Fragment, nil, v7, v8, v1, p1.children)

        if p1.isStudded then
            local t3 = {
                AnchorPoint = p1.anchorPoint,
                BackgroundColor3 = v2
            }
            local isStuddedTransparency = p1.isStuddedTransparency

            if isStuddedTransparency == nil then
                isStuddedTransparency = p1.transparency

                if isStuddedTransparency == nil then
                    isStuddedTransparency = 0.8
                end
            end

            t3.BackgroundTransparency = isStuddedTransparency
            t3.BorderSizePixel = 0
            t3.ClipsDescendants = p1.clipsDescendants
            t3.Image = "rbxassetid://15910695828"

            local textureTransparency = p1.textureTransparency

            t3.ImageTransparency = if textureTransparency == nil then 0 else textureTransparency
            t3.LayoutOrder = p1.layoutOrder
            t3.Position = p1.position
            t3.ScaleType = Enum.ScaleType.Tile
            t3.Size = p1.size or UDim2.fromScale(1, 1)
            t3.TileSize = v6
            t3.ZIndex = p1.zIndex

            return react.createElement("imagelabel", t3, v9)
        end

        local t4 = {
            AnchorPoint = p1.anchorPoint,
            BackgroundColor3 = v2
        }
        local transparency = p1.transparency

        t4.BackgroundTransparency = if transparency == nil then 0 else transparency
        t4.BorderSizePixel = 0
        t4.ClipsDescendants = p1.clipsDescendants
        t4.LayoutOrder = p1.layoutOrder
        t4.Position = p1.position
        t4.Size = p1.size or UDim2.fromScale(1, 1)
        t4.ZIndex = p1.zIndex

        return react.createElement("frame", t4, v9)
    end
}
