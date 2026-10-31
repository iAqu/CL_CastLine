-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local UserInputService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").UserInputService
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "cyt-button").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "rounded-frame").default
local getRarityColor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").getRarityColor
local default3 = RuntimeLib.import(script, script.Parent, "item-rarity-overlay").default

return {
    default = function(p1) -- BackpackItem | line: 14
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), UserInputService (copy), default (copy), default2 (copy), getRarityColor (copy), default3 (copy)
        local sizeScale = p1.sizeScale

        if sizeScale == nil then
            sizeScale = 1
        end

        local v1 = useRef()
        local v2, v3 = useState(false)

        useEffect(function() -- line: 22
            -- upvalues: p1 (copy), v2 (copy), v3 (copy), UserInputService (copy)
            if not v2 then
                return nil
            end

            local connection = UserInputService.InputChanged:Connect(function(p2) -- line: 26
                -- upvalues: p1 (copy)
                if p2.UserInputType ~= Enum.UserInputType.MouseMovement and p2.UserInputType ~= Enum.UserInputType.Touch then
                    return nil
                end

                local onDragMove = p1.onDragMove

                if onDragMove ~= nil then
                    onDragMove(Vector2.new(p2.Position.X, p2.Position.Y))
                end
            end)
            local connection2 = UserInputService.InputEnded:Connect(function(p3) -- line: 35
                -- upvalues: p1 (copy), v3 (copy)
                if p3.UserInputType ~= Enum.UserInputType.MouseButton1 and p3.UserInputType ~= Enum.UserInputType.Touch then
                    return nil
                end

                local v4 = Vector2.new(p3.Position.X, p3.Position.Y)

                v3(false)

                local onDragEnd = p1.onDragEnd

                if onDragEnd ~= nil then
                    onDragEnd(p1.itemId, v4)
                end
            end)

            return function() -- line: 46
                -- upvalues: connection (copy), connection2 (copy)
                connection:Disconnect()
                connection2:Disconnect()
            end
        end, { v2 })

        local function v5() -- line: 51
            -- upvalues: p1 (copy), v3 (copy), UserInputService (copy)
            if p1.isDraggable ~= false and p1.itemType == "fish" and p1.imageId ~= "" then
                local MouseLocation = UserInputService:GetMouseLocation()

                v3(true)

                local onDragStart = p1.onDragStart

                if onDragStart ~= nil then
                    onDragStart(p1.itemId, p1.imageId, MouseLocation)
                end

                return
            end

            return nil
        end

        local v6 = react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            ref = v1
        })
        local v7 = if p1.equipped then react.createElement(default2, {
            backgroundTransparency = 1,
            cornerRadius = 5,
            anchorPoint = Vector2.new(0.5, 0.5),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1)
        }, react.createElement("uistroke", {
            Thickness = 0.05,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Color3.fromRGB(255, 255, 255),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        })) else nil
        local v8 = react.createElement("uistroke", {
            Thickness = 0.04,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Color3.fromRGB(0, 0, 0),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        })
        local v10 = react.createElement(default2, {
            cornerRadius = 8,
            zIndex = 1,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor3 = if p1.rarity == "godly" or p1.rarity == "exclusive" then Color3.fromRGB(255, 255, 255) elseif p1.rarity == "extinct" then Color3.fromRGB(0, 0, 0) else Color3.fromRGB(41, 41, 41),
            backgroundTransparency = (p1.rarity == "godly" or p1.rarity == "exclusive" or p1.rarity == "extinct") and 0 or 0.6,
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(0.9, 0.9)
        }, p1.rarity == "exclusive" and react.createElement("uigradient", {
            Rotation = 35,
            Color = getRarityColor("exclusive")
        }))
        local t2 = {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = p1.imageId,
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Fit
        }
        local imageSizeScale = p1.imageSizeScale

        if imageSizeScale == nil then
            imageSizeScale = 0.9
        end

        local imageSizeScale2 = p1.imageSizeScale

        if imageSizeScale2 == nil then
            imageSizeScale2 = 0.9
        end

        t2.Size = UDim2.fromScale(imageSizeScale, imageSizeScale2)
        t2.ZIndex = 5

        return react.createElement(default, {
            cornerRadius = 5,
            darkenOnHover = false,
            uiAspectRatio = 1,
            colorSequence = ColorSequence.new(Color3.fromRGB(30, 30, 30)),
            layoutOrder = p1.layoutOrder,
            onClick = p1.onClick or function() -- line: 121
            end,
            onMouseButton1Down = v5,
            onMouseEnter = function() -- onMouseEnter | line: 123
                -- upvalues: p1 (copy), v1 (copy)
                if v1.current ~= nil then
                    local onHoverStart = p1.onHoverStart

                    if onHoverStart ~= nil then
                        onHoverStart(v1.current)
                    end
                end
            end,
            onMouseLeave = p1.onHoverEnd,
            size = p1.size or UDim2.fromScale(sizeScale, sizeScale)
        }, v6, v7, react.createElement(default2, {
            backgroundTransparency = 0.6,
            cornerRadius = 5,
            zIndex = 0,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor3 = Color3.fromRGB(0, 0, 0),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1)
        }, v8, v10, react.createElement("imagelabel", t2, react.createElement("uicorner", {
            CornerRadius = UDim.new(0, 8)
        })), p1.rarity ~= nil and react.createElement(default2, {
            backgroundTransparency = 1,
            cornerRadius = 8,
            anchorPoint = Vector2.new(0.5, 0.5),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(0.9, 0.9),
            zIndex = p1.rarity == "extinct" and 6 or 4
        }, react.createElement(default3, {
            cornerRadius = 6,
            rarity = p1.rarity
        }))))
    end
}
