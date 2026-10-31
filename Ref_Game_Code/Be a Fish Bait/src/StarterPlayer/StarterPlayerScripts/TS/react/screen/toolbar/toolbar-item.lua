-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local UserInputService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").UserInputService
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "cyt-button").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "rounded-frame").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "tutorial", "tutorial-screen-pointer").default
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local default5 = RuntimeLib.import(script, script.Parent, "tooltip").default
local default6 = RuntimeLib.import(script, script.Parent, "item-rarity-overlay").default
local getRarityColor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").getRarityColor

return {
    default = function(p1) -- ToolbarItem | line: 17
        -- upvalues: react (copy), useEffect (copy), useState (copy), UserInputService (copy), default (copy), default2 (copy), default3 (copy), default4 (copy), images (copy), default5 (copy), default6 (copy), getRarityColor (copy)
        local sizeScale = p1.sizeScale

        if sizeScale == nil then
            sizeScale = 1
        end

        local v1, v2 = useState(false)
        local v3, v4 = useState(false)

        useEffect(function() -- line: 25
            -- upvalues: p1 (copy), v3 (copy), v4 (copy), UserInputService (copy)
            if not v3 or p1.itemId == nil then
                return nil
            end

            local connection = UserInputService.InputChanged:Connect(function(p2) -- line: 29
                -- upvalues: p1 (copy)
                if p2.UserInputType ~= Enum.UserInputType.MouseMovement and p2.UserInputType ~= Enum.UserInputType.Touch then
                    return nil
                end

                local onDragMove = p1.onDragMove

                if onDragMove ~= nil then
                    onDragMove(Vector2.new(p2.Position.X, p2.Position.Y))
                end
            end)
            local connection2 = UserInputService.InputEnded:Connect(function(p3) -- line: 38
                -- upvalues: p1 (copy), v4 (copy)
                if p3.UserInputType ~= Enum.UserInputType.MouseButton1 and p3.UserInputType ~= Enum.UserInputType.Touch then
                    return nil
                end

                local v5 = Vector2.new(p3.Position.X, p3.Position.Y)

                v4(false)

                local onDragEnd = p1.onDragEnd

                if onDragEnd ~= nil then
                    onDragEnd(p1.itemId, v5)
                end
            end)

            return function() -- line: 49
                -- upvalues: connection (copy), connection2 (copy)
                connection:Disconnect()
                connection2:Disconnect()
            end
        end, {
            v3,
            p1.itemId
        })

        local function v6() -- line: 54
            -- upvalues: p1 (copy), v4 (copy), UserInputService (copy)
            if p1.itemId ~= nil and p1.itemType == "fish" and p1.imageId ~= "" then
                local MouseLocation = UserInputService:GetMouseLocation()

                v4(true)

                local onDragStart = p1.onDragStart

                if onDragStart ~= nil then
                    onDragStart(p1.itemId, p1.imageId, MouseLocation)
                end

                return
            end

            return nil
        end

        local createElement = react.createElement
        local t1 = {
            cornerRadius = 8,
            darkenOnHover = false,
            uiAspectRatio = 1,
            colorSequence = ColorSequence.new(Color3.fromRGB(0, 0, 0)),
            layoutOrder = p1.layoutOrder,
            onClick = p1.onClick or function() -- line: 70
            end,
            onMouseButton1Down = v6,
            onMouseEnter = function() -- onMouseEnter | line: 72
                -- upvalues: v2 (copy)
                return v2(true)
            end,
            onMouseLeave = function() -- onMouseLeave | line: 75
                -- upvalues: v2 (copy)
                return v2(false)
            end,
            size = UDim2.fromScale(sizeScale, sizeScale)
        }

        if v1 then
            v1 = p1.rarity ~= nil and react.createElement(default5, {
                exclusiveEditionLabel = p1.exclusiveEditionLabel,
                itemName = p1.name,
                moneyPerSecond = p1.moneyPerSecond,
                mutations = p1.mutations,
                powerCap = p1.powerCap,
                rarity = p1.rarity
            })
        end

        local createElement2 = react.createElement
        local t2 = {
            backgroundTransparency = 0.6,
            cornerRadius = 8,
            zIndex = 0,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor3 = Color3.fromRGB(0, 0, 0),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(0.92, 0.92)
        }
        local v7 = if p1.equipped then react.createElement(default2, {
            backgroundTransparency = 1,
            cornerRadius = 8,
            anchorPoint = Vector2.new(0.5, 0.5),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1)
        }, react.createElement("uistroke", {
            Thickness = 0.05,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Color3.fromRGB(255, 255, 255),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        })) else nil
        local v9 = react.createElement(default2, {
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
        local v10 = not UserInputService.TouchEnabled

        v10 = v10 and react.createElement(default3, {
            color = Color3.new(1, 1, 1),
            overrideProps = {
                ZIndex = 6,
                AnchorPoint = Vector2.new(0, 0),
                Font = Enum.Font.GothamBlack,
                Position = UDim2.fromScale(0.05, 0.04),
                Size = UDim2.fromScale(0.22, 0.22)
            },
            text = tostring(p1.slotNumber)
        })

        return createElement(default, t1, v1, createElement2(default2, t2, v7, v9, v10, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ScaleType = "Fit",
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = p1.imageId,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.9, 0.9)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0, 8)
        })), p1.isSelectedForTrash and react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 10,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.trashIcon,
            ImageColor3 = Color3.fromRGB(255, 0, 0),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }), p1.rarity ~= nil and react.createElement(default2, {
            backgroundTransparency = 1,
            cornerRadius = 8,
            anchorPoint = Vector2.new(0.5, 0.5),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(0.9, 0.9),
            zIndex = p1.rarity == "extinct" and 6 or 2
        }, react.createElement(default6, {
            cornerRadius = 6,
            rarity = p1.rarity
        }))), p1.shouldShowTutorialPointer and react.createElement(default4, {
            direction = "down",
            zIndex = 100,
            anchorPoint = Vector2.new(0.5, 0),
            position = UDim2.fromScale(0.25, -1),
            size = UDim2.fromScale(0.8, 0.8)
        }))
    end
}
