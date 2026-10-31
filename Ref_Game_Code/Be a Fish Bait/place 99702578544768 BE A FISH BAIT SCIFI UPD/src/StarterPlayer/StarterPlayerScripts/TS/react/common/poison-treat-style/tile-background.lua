-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useScreenSize = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSize

return {
    default = function(p1) -- TileBackground | line: 5
        -- upvalues: react (copy), useScreenSize (copy)
        local v1 = useScreenSize()
        local v2 = v1:map(function(p2) -- line: 7
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
            v2 = borderSizePixel
        end

        return react.createElement("imagelabel", {
            Image = "rbxassetid://15910695828",
            ScaleType = "Tile",
            AnchorPoint = p1.anchorPoint,
            BackgroundColor3 = p1.color,
            BorderColor3 = p1.borderColor,
            BorderSizePixel = v2,
            Position = p1.position,
            Size = p1.size or UDim2.fromScale(1, 1),
            TileSize = v1:map(function(p3) -- line: 24
                if p3 == "sm" then
                    return UDim2.fromOffset(60, 60)
                end

                return UDim2.fromOffset(120, 120)
            end),
            ZIndex = p1.zIndex
        }, p1.children)
    end
}
