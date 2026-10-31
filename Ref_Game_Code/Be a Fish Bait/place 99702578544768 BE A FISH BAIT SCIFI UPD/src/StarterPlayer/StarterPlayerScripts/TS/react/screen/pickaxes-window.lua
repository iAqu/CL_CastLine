-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useContext, useEffect, useRef, useState = react.useContext, react.useEffect, react.useRef, react.useState
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "cyt-style", "rounded-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent, "common", "styled-text-label").default
local default3 = RuntimeLib.import(script, script.Parent.Parent, "common", "cyt-style", "cyt-button").default
local v1 = RuntimeLib.import(script, script.Parent.Parent, "utils", "responsive-utils")
local getBorderThickness, getTextStrokeThickness, getMaxTextSize = v1.getBorderThickness, v1.getTextStrokeThickness, v1.getMaxTextSize
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local ThemeContext = RuntimeLib.import(script, script.Parent.Parent, "context", "theme-context").ThemeContext
local pickaxes = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "pickaxe").pickaxes
local default4 = RuntimeLib.import(script, script.Parent, "pickaxe-item").default
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local default5 = RuntimeLib.import(script, script.Parent.Parent, "common", "scrolling-frame").default
local reflex = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local v2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "reflex", "slices", "trash-mode.selectors")
local selectTrashModeEnabled, selectTrashModeSelectedItemIds = v2.selectTrashModeEnabled, v2.selectTrashModeSelectedItemIds
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local _, RunService = services.HttpService, services.RunService

return {
    default = function(p1) -- PickaxesWindow | line: 32
        -- upvalues: react (copy), useContext (copy), useEffect (copy), useRef (copy), useState (copy), default (copy), default2 (copy), default3 (copy), getBorderThickness (copy), getTextStrokeThickness (copy), getMaxTextSize (copy), useScreenSizeState (copy), ThemeContext (copy), pickaxes (copy), default4 (copy), images (copy), default5 (copy), useRootProducer (copy), useRootSelector (copy), selectTrashModeEnabled (copy), selectTrashModeSelectedItemIds (copy), RunService (copy)
        local v3 = useScreenSizeState()
        local v4 = useContext(ThemeContext)
        local v5, v6 = useState(nil)
        local v7, v8 = useState(nil)
        local v9 = useRef(nil)
        local v10 = useRef({})
        local v11 = useRootProducer()
        local v12 = useRootSelector(selectTrashModeEnabled)
        local v13 = useRootSelector(selectTrashModeSelectedItemIds)

        local function v14(p2) -- line: 42
            -- upvalues: pickaxes (copy)
            local v15 = pickaxes[p2]

            if v15 ~= nil then
                v15 = v15.imageId
            end

            if v15 == nil then
                v15 = ""
            end

            return v15
        end

        local function v16(p3) -- line: 103
            -- upvalues: p1 (copy), v11 (copy), v12 (copy)
            if v12 then
                v11.itemTrashSelectionToggled({
                    itemId = p3
                })
            else
                local onItemClick = p1.onItemClick

                if onItemClick ~= nil then
                    onItemClick(p3)
                end
            end
        end

        local v17

        if v5 ~= nil then
            for v18, v19 in p1.pickaxeItems do
                local _ = v18 - 1

                if v19.itemId == v5 == true then
                    v17 = v19
                    break
                end

                v17 = nil
            end
        end

        local v20 = if v17 ~= nil then pickaxes[v17.itemName] else nil

        useEffect(function() -- line: 143
            -- upvalues: v5 (copy), v8 (copy), v9 (copy), v10 (copy), RunService (copy)
            if v5 == nil then
                v8(nil)

                return nil
            end

            local function v21() -- line: 148
                -- upvalues: v5 (copy), v8 (copy), v9 (copy), v10 (copy)
                local v22 = v10.current[v5]
                local current = v9.current

                if not (v22 and current and v22.Parent) then
                    return nil
                end

                local v23 = v22.AbsolutePosition.X + v22.AbsoluteSize.X / 2
                local v24 = v22.AbsolutePosition.Y + v22.AbsoluteSize.Y
                local v25 = v23 - current.AbsolutePosition.X
                local v26 = v24 - current.AbsolutePosition.Y

                v8(UDim2.fromOffset(v25, v26))
            end

            v21()

            local connection = RunService.Heartbeat:Connect(v21)

            return function() -- line: 162
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, { v5 })

        local v27 = react.createElement(default2, {
            text = "Pickaxes",
            overrideProps = {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, -0.1),
                Size = UDim2.fromScale(0.5, 0.15)
            }
        }, react.createElement("uigradient", {
            Color = v4.colorSequences.blueGradient
        }))
        local v28 = react.createElement(default3, {
            cornerRadius = 25,
            uiAspectRatio = 1,
            zIndex = 1,
            anchorPoint = Vector2.new(0.5, 0.5),
            borderThickness = getBorderThickness(v3, "sm"),
            onClick = p1.onClose,
            position = UDim2.fromScale(1, 0),
            size = UDim2.fromScale(0.15, 0.15)
        }, react.createElement(default, {
            cornerRadius = 25,
            zIndex = 1,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor3 = Color3.fromRGB(255, 0, 0),
            borderColor3 = Color3.fromRGB(0, 0, 0),
            borderThickness = getBorderThickness(v3, "sm"),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1)
        }, react.createElement("textlabel", {
            BackgroundTransparency = 1,
            Text = "X",
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Font = v4.textFont,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.75, 0.75),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextXAlignment = Enum.TextXAlignment.Center
        }, react.createElement("uistroke", {
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = getBorderThickness(v3, "xsm")
        }))))
        local pickaxeItems = p1.pickaxeItems
        local v29 = table.create(#pickaxeItems)

        local function v30(p4, p5) -- line: 211
            -- upvalues: v6 (copy), v10 (copy), v13 (copy), v16 (copy), react (copy), pickaxes (copy), default4 (copy)
            local t1 = {
                equipped = p4.isInToolbar
            }
            local v31 = pickaxes[p4.itemName]

            if v31 ~= nil then
                v31 = v31.imageId
            end

            t1.imageId = if v31 == nil then "" else v31

            local itemId = p4.itemId

            t1.isSelectedForDeletion = table.find(v13, itemId) ~= nil
            t1.itemName = p4.itemName

            t1.onClick = function() -- line: 219
                -- upvalues: p4 (copy), v16 (copy)
                return v16(p4.itemId)
            end

            t1.onHideStats = function() -- line: 222
                -- upvalues: v6 (copy)
                return v6(nil)
            end

            t1.onShowStats = function() -- line: 225
                -- upvalues: p4 (copy), v6 (copy)
                return v6(p4.itemId)
            end

            return react.createElement("frame", {
                BackgroundTransparency = 1,
                LayoutOrder = p5,
                Size = UDim2.fromScale(0.25, 1),
                key = ("pickaxe-item-wrapper-%*"):format(p5),
                ref = function(p6) -- ref | line: 233
                    -- upvalues: p4 (copy), v10 (copy)
                    if p6 then
                        v10.current[p4.itemId] = p6
                    end
                end
            }, react.createElement(default4, t1))
        end

        for v32, v33 in pickaxeItems do
            v29[v32] = v30(v33, v32 - 1, pickaxeItems)
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            ClipsDescendants = false,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.3, 0.5),
            ref = v9
        }, react.createElement(default, {
            backgroundTransparency = 0.7,
            cornerRadius = 5,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor3 = Color3.fromRGB(0, 0, 0),
            borderColor3 = Color3.fromRGB(0, 0, 0),
            borderThickness = getBorderThickness(v3, "sm"),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1)
        }, v27, v28, react.createElement(default5, {
            cellsPerRow = 3,
            listPaddingOffset = 15,
            rowsToBeVisible = 3,
            scrollBarThickness = 5,
            zIndex = 0,
            anchorPoint = Vector2.new(0.5, 0.5),
            fillDirection = Enum.FillDirection.Horizontal,
            padding = {
                all = UDim.new(0, v3 == "lg" and 25 or 10)
            },
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1)
        }, v29), react.createElement(default3, {
            cornerRadius = 5,
            anchorPoint = Vector2.new(0.5, 0.5),
            borderThickness = getBorderThickness(v3, "sm"),
            onClick = function() -- onClick | line: 277
                -- upvalues: p1 (copy), v11 (copy)
                p1.onClose()
                v11.windowOpened({
                    currentWindow = "exclusiveShop"
                })
            end,
            position = UDim2.fromScale(0.5, 1),
            size = UDim2.fromScale(0.4, 0.15)
        }, react.createElement(default, {
            cornerRadius = 5,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColorSequence = v4.colorSequences.CYTGreenGradient,
            borderColor3 = Color3.fromRGB(0, 0, 0),
            borderThickness = getBorderThickness(v3, "sm"),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1)
        }, react.createElement(default2, {
            text = "Get More",
            overrideProps = {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.8, 0.8)
            },
            textColor3 = Color3.fromRGB(255, 255, 255)
        })))), v20 ~= nil and react.createElement(default, {
            backgroundTransparency = 0.7,
            cornerRadius = 5,
            zIndex = 5,
            anchorPoint = Vector2.new(0.5, 0),
            backgroundColor3 = Color3.fromRGB(0, 0, 0),
            borderColor3 = Color3.fromRGB(0, 0, 0),
            borderThickness = getBorderThickness(v3, "sm"),
            position = v7 or UDim2.fromScale(0.5, 1),
            size = UDim2.fromScale(1, 0.5)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement(default2, {
            overrideProps = {
                LayoutOrder = 0,
                ZIndex = 6,
                Size = UDim2.fromScale(1, 0.35)
            },
            text = v20.title,
            textColor3 = Color3.fromRGB(255, 255, 255)
        }, react.createElement("uistroke", {
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = getTextStrokeThickness(v3, "xsm")
        }), react.createElement("uitextsizeconstraint", {
            MaxTextSize = getMaxTextSize(v3, "md")
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            ZIndex = 6,
            Size = UDim2.fromScale(1, 0.3)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 20),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 0,
            Size = UDim2.fromScale(0.3, 1)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            LayoutOrder = 0,
            ZIndex = 6,
            Image = images.pickaxeIcon,
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.4, 1)
        }), react.createElement(default2, {
            overrideProps = {
                LayoutOrder = 1,
                ZIndex = 6,
                Size = UDim2.fromScale(0.5, 0.8),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            text = tostring(v20.damage),
            textColor3 = Color3.fromRGB(255, 255, 255)
        }, react.createElement("uistroke", {
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = getTextStrokeThickness(v3, "xsm")
        }), react.createElement("uitextsizeconstraint", {
            MaxTextSize = getMaxTextSize(v3, "sm")
        }))), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Size = UDim2.fromScale(0.3, 1)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            LayoutOrder = 0,
            ZIndex = 6,
            Image = images.timerIcon,
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.4, 1)
        }), react.createElement(default2, {
            overrideProps = {
                LayoutOrder = 1,
                ZIndex = 6,
                Size = UDim2.fromScale(0.5, 0.8),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            text = tostring(v20.cooldown),
            textColor3 = Color3.fromRGB(255, 255, 255)
        }, react.createElement("uistroke", {
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = getTextStrokeThickness(v3, "xsm")
        }), react.createElement("uitextsizeconstraint", {
            MaxTextSize = getMaxTextSize(v3, "sm")
        }))))))
    end
}
