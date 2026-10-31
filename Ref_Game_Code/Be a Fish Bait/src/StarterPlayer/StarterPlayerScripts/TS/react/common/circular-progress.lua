-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local react = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")

local function clamp(p1, p2, p3) -- line: 4
    return (math.clamp(p1, p2, p3))
end

local function computeRotations(p4, p5, p6) -- line: 7
    if p5 == "Up" then
        if p6 == "Left" then
            return {
                math.clamp(p4, 180, 360),
                (math.clamp(p4, 0, 180))
            }
        end

        if p6 == "Right" then
            return {
                180 - math.clamp(p4, 0, 180),
                -math.clamp(p4, 180, 360) + 180
            }
        end

        return {
            180 - math.clamp(p4, 0, 360) / 2,
            math.clamp(p4, 0, 360) / 2
        }
    end

    if p5 == "Down" then
        if p6 == "Left" then
            return {
                math.clamp(p4, 180, 360) + 180,
                math.clamp(p4, 0, 180) + 180
            }
        end

        if p6 == "Right" then
            return {
                -math.clamp(p4, 0, 180),
                -math.clamp(p4, 180, 360)
            }
        end

        return {
            -math.clamp(p4, 0, 360) / 2,
            math.clamp(p4, 0, 360) / 2 + 180
        }
    end

    if p5 == "Left" then
        if p6 == "Left" then
            return {
                math.clamp(p4, 180, 360) - 90,
                math.clamp(p4, 0, 180) - 90
            }
        end

        if p6 == "Right" then
            return {
                90 - math.clamp(p4, 0, 180),
                -math.clamp(p4, 180, 360) + 90
            }
        end

        return {
            90 - math.clamp(p4, 0, 360) / 2,
            math.clamp(p4, 0, 360) / 2 - 90
        }
    end

    if p6 == "Left" then
        return {
            math.clamp(p4, 180, 360) + 90,
            math.clamp(p4, 0, 180) + 90
        }
    end

    if p6 == "Right" then
        return {
            270 - math.clamp(p4, 0, 180),
            -math.clamp(p4, 180, 360) + 270
        }
    end

    return {
        270 - math.clamp(p4, 0, 360) / 2,
        math.clamp(p4, 0, 360) / 2 + 90
    }
end

return {
    default = function(p7) -- CircularProgress | line: 45
        -- upvalues: react (copy), computeRotations (copy)
        local progress, starterPoint = p7.progress, p7.starterPoint
        local v1 = starterPoint

        if starterPoint == nil then
            v1 = "Up"
        end

        local direction = p7.direction
        local v2 = direction

        if direction == nil then
            v2 = "Left"
        end

        local missingPartType = p7.missingPartType

        if missingPartType == nil then
            missingPartType = "TransAndColor"
        end

        local imageId = p7.imageId

        if imageId == nil then
            imageId = "3587367081"
        end

        local imageColor = p7.imageColor

        if imageColor == nil then
            imageColor = Color3.fromRGB(255, 255, 255)
        end

        local imageTransparency = p7.imageTransparency

        if imageTransparency == nil then
            imageTransparency = 0
        end

        local colorOfPercentPart = p7.colorOfPercentPart

        if colorOfPercentPart == nil then
            colorOfPercentPart = Color3.fromRGB(255, 255, 255)
        end

        local colorOfMissingPart = p7.colorOfMissingPart
        local v3 = colorOfMissingPart

        if colorOfMissingPart == nil then
            v3 = Color3.fromRGB(0, 0, 0)
        end

        local transOfPercentPart = p7.transOfPercentPart

        if transOfPercentPart == nil then
            transOfPercentPart = 0
        end

        local transOfMissingPart = p7.transOfMissingPart

        if transOfMissingPart == nil then
            transOfMissingPart = 0.25
        end

        local size = p7.size

        if size == nil then
            size = UDim2.fromScale(0.2, 0.2)
        end

        local position = p7.position

        if position == nil then
            position = UDim2.fromOffset(0, 0)
        end

        local anchorPoint = p7.anchorPoint

        if anchorPoint == nil then
            anchorPoint = Vector2.new(0, 1)
        end

        local zIndex = p7.zIndex

        if zIndex == nil then
            zIndex = 1
        end

        if typeof(progress) ~= "table" or progress.map == nil then
            progress = react.createBinding(progress)
        end

        local v4 = progress:map(function(p8) -- line: 104
            -- upvalues: v1 (ref), v2 (ref), computeRotations (copy)
            local v7 = computeRotations(math.clamp(p8 * 3.6, 0, 360), v1, v2)

            return {
                g1Rot = v7[1],
                g2Rot = v7[2]
            }
        end)
        local v8, v9

        if v1 == "Left" or v1 == "Right" then
            v8 = UDim2.new(1, 0, 0.5, 1)
            v9 = UDim2.fromScale(1, 2)
        else
            v8 = UDim2.new(0.5, 1, 1, 0)
            v9 = UDim2.fromScale(2, 1)
        end

        local v10, v11, v12, v13, v14, v15, v16, v17

        if v1 == "Up" then
            v10 = UDim2.fromScale(0, 0)
            v11 = Vector2.new(0, 0)
            v12 = UDim2.fromScale(1, 0)
            v13 = Vector2.new(1, 0)
            v14 = UDim2.fromScale(0, 0)
            v15 = Vector2.new(0, 0)
            v16 = UDim2.fromScale(1, 0)
            v17 = Vector2.new(1, 0)
        elseif v1 == "Down" then
            v10 = UDim2.fromScale(0, 0)
            v11 = Vector2.new(0, 0)
            v12 = UDim2.fromScale(1, 0)
            v13 = Vector2.new(1, 0)
            v14 = UDim2.fromScale(1, 0)
            v15 = Vector2.new(1, 0)
            v16 = UDim2.fromScale(0, 0)
            v17 = Vector2.new(0, 0)
        elseif v1 == "Left" then
            v10 = UDim2.fromScale(0, 0)
            v11 = Vector2.new(0, 0)
            v12 = UDim2.fromScale(0, 1)
            v13 = Vector2.new(0, 1)
            v14 = UDim2.fromScale(0, 0)
            v15 = Vector2.new(0, 0)
            v16 = UDim2.fromScale(0, 1)
            v17 = Vector2.new(0, 1)
        else
            v10 = UDim2.fromScale(0, 1)
            v11 = Vector2.new(0, 1)
            v12 = UDim2.fromScale(0, 0)
            v13 = Vector2.new(0, 0)
            v14 = UDim2.fromScale(0, 1)
            v15 = Vector2.new(0, 1)
            v16 = UDim2.fromScale(0, 0)
            v17 = Vector2.new(0, 0)
        end

        if typeof(colorOfPercentPart) ~= "table" or colorOfPercentPart.map == nil then
            colorOfPercentPart = react.createBinding(colorOfPercentPart)
        end

        local v18 = if missingPartType == "Trans" then ColorSequence.new(Color3.fromRGB(255, 255, 255)) else colorOfPercentPart:map(function(p9) -- line: 167
            -- upvalues: v3 (ref)
            return ColorSequence.new({
                ColorSequenceKeypoint.new(0, p9),
                ColorSequenceKeypoint.new(0.5, p9),
                ColorSequenceKeypoint.new(0.502, v3),
                ColorSequenceKeypoint.new(1, v3)
            })
        end)
        local v19 = if missingPartType == "Color" then NumberSequence.new(0) else NumberSequence.new({
            NumberSequenceKeypoint.new(0, transOfPercentPart),
            NumberSequenceKeypoint.new(0.5, transOfPercentPart),
            NumberSequenceKeypoint.new(0.502, transOfMissingPart),
            NumberSequenceKeypoint.new(1, transOfMissingPart)
        })
        local v20 = ("rbxassetid://%*"):format(imageId)

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            ClipsDescendants = false,
            AnchorPoint = anchorPoint,
            Position = position,
            Size = size,
            ZIndex = zIndex
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            AnchorPoint = v11,
            Position = v10,
            Size = v8,
            ZIndex = zIndex
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            AnchorPoint = v15,
            Image = v20,
            ImageColor3 = imageColor,
            ImageTransparency = imageTransparency,
            Position = v14,
            ScaleType = Enum.ScaleType.Stretch,
            Size = v9,
            ZIndex = zIndex
        }, react.createElement("uigradient", {
            Color = v18,
            Rotation = v4:map(function(p10) -- line: 199
                return p10.g1Rot
            end),
            Transparency = v19
        }))), react.createElement("frame", {
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            AnchorPoint = v13,
            Position = v12,
            Size = v8,
            ZIndex = zIndex
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            AnchorPoint = v17,
            Image = v20,
            ImageColor3 = imageColor,
            ImageTransparency = imageTransparency,
            Position = v16,
            ScaleType = Enum.ScaleType.Stretch,
            Size = v9,
            ZIndex = zIndex
        }, react.createElement("uigradient", {
            Color = v18,
            Rotation = v4:map(function(p11) -- line: 222
                return p11.g2Rot
            end),
            Transparency = v19
        }))))
    end
}
