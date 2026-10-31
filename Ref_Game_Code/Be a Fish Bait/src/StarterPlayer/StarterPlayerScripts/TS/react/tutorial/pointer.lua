-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useLoopMotion = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-loop-motion").useLoopMotion
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images

return {
    default = function(p1) -- Pointer | line: 6
        -- upvalues: react (copy), useLoopMotion (copy), images (copy)
        local color, direction, image, position = p1.color, p1.direction, p1.image, p1.position
        local rotation, size, zIndex = p1.rotation, p1.size, p1.zIndex
        local v1 = direction == "right" or direction == "left"
        local v3 = useLoopMotion({
            min = 0,
            motionType = "linear",
            max = (direction == "right" or direction == "down") and 0.1 or -0.1,
            linearOptions = {
                speed = 2
            }
        })[1]

        if rotation == nil then
            rotation = if direction == "right" then 90
                elseif direction == "left" then 270
                elseif direction == "up" then 0
                else 180
        end

        local v4 = if v1 then v3:map(function(p2) -- line: 29
            return UDim2.fromScale(p2, 0)
        end) else v3:map(function(p3) -- line: 31
            return UDim2.fromScale(0, p3)
        end)

        if position then
            v4 = v4:map(function(p4) -- line: 34
                -- upvalues: position (copy)
                return p4 + position
            end)
        end

        local v5 = size or UDim2.fromScale(0.9, 1)
        local t2 = {
            BackgroundTransparency = 1
        }

        t2.Image = if image == nil then images.clickPointer else image
        t2.ImageColor3 = color
        t2.Position = v4
        t2.Rotation = rotation
        t2.ScaleType = Enum.ScaleType.Fit
        t2.Size = v5
        t2.SizeConstraint = Enum.SizeConstraint.RelativeXY
        t2.ZIndex = if zIndex == nil then 2 else zIndex

        return react.createElement("imagelabel", t2)
    end
}
