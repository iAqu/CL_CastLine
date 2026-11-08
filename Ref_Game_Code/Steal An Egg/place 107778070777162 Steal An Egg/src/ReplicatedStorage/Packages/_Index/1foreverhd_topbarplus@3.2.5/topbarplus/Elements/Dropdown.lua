-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1) -- line: 2
    local Frame = Instance.new("Frame")

    Frame.Name = "Dropdown"
    Frame.AutomaticSize = Enum.AutomaticSize.XY
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.AnchorPoint = Vector2.new(0.5, 0)
    Frame.Position = UDim2.new(0.5, 0, 1, 10)
    Frame.ZIndex = -2
    Frame.ClipsDescendants = true
    Frame.Parent = p1.widget

    local GuiService = game:GetService("GuiService")

    p1:setBehaviour("Dropdown", "BackgroundTransparency", function(p2) -- line: 16
        -- upvalues: GuiService (copy)
        local v1 = p2 * GuiService.PreferredTransparency

        if p2 == 1 then
            return p2
        end

        return v1
    end)
    p1.janitor:add(GuiService:GetPropertyChangedSignal("PreferredTransparency"):Connect(function() -- line: 24
        -- upvalues: p1 (copy), Frame (copy)
        p1:refreshAppearance(Frame, "BackgroundTransparency")
    end))

    local UICorner = Instance.new("UICorner")

    UICorner.Name = "DropdownCorner"
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Frame

    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Name = "DropdownScroller"
    ScrollingFrame.AutomaticSize = Enum.AutomaticSize.X
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.AnchorPoint = Vector2.new(0, 0)
    ScrollingFrame.Position = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.ZIndex = -1
    ScrollingFrame.ClipsDescendants = true
    ScrollingFrame.Visible = true
    ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.None
    ScrollingFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    ScrollingFrame.Active = false
    ScrollingFrame.ScrollingEnabled = true
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.ScrollBarThickness = 5
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    ScrollingFrame.ScrollBarImageTransparency = 0.8
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.Selectable = false
    ScrollingFrame.Active = true
    ScrollingFrame.Parent = Frame

    local UIPadding = Instance.new("UIPadding")

    UIPadding.Name = "DropdownPadding"
    UIPadding.PaddingTop = UDim.new(0, 0)
    UIPadding.PaddingBottom = UDim.new(0, 0)
    UIPadding.Parent = ScrollingFrame

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.Name = "DropdownList"
    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.HorizontalFlex = Enum.UIFlexAlignment.SpaceEvenly
    UIListLayout.Parent = ScrollingFrame

    local dropdownJanitor = p1.dropdownJanitor
    local iconModule = require(p1.iconModule)

    p1.dropdownChildAdded:Connect(function(p3) -- line: 72
        local _, v2 = p3:modifyTheme({
            { "Widget", "BorderSize", 0 },
            {
                "IconCorners",
                "CornerRadius",
                UDim.new(0, 10)
            },
            { "Widget", "MinimumWidth", 190 },
            { "Widget", "MinimumHeight", 58 },
            { "IconLabel", "TextSize", 20 },
            {
                "IconOverlay",
                "Size",
                UDim2.new(1, 0, 1, 0)
            },
            {
                "PaddingLeft",
                "Size",
                UDim2.fromOffset(25, 0)
            },
            {
                "Notice",
                "Position",
                UDim2.new(1, -24, 0, 5)
            },
            {
                "ContentsList",
                "HorizontalAlignment",
                Enum.HorizontalAlignment.Left
            },
            {
                "Selection",
                "Size",
                UDim2.new(1, -0, 1, -0)
            },
            {
                "Selection",
                "Position",
                UDim2.new(0, 0, 0, 0)
            }
        })

        task.defer(function() -- line: 87
            -- upvalues: p3 (copy), v2 (copy)
            p3.joinJanitor:add(function() -- line: 88
                -- upvalues: p3 (copy), v2 (copy)
                p3:removeModification(v2)
            end)
        end)
    end)
    p1.dropdownSet:Connect(function(p4) -- line: 93
        -- upvalues: p1 (copy), iconModule (copy)
        for _, v3 in pairs(p1.dropdownIcons) do
            iconModule.getIconByUID(v3):destroy()
        end

        if type(p4) == "table" then
            for _, v4 in pairs(p4) do
                v4:joinDropdown(p1)
            end
        end
    end)

    local Utility = require(script.Parent.Parent.Utility)

    local function updateVisibility() -- line: 109
        -- upvalues: p1 (copy), Frame (copy), Utility (copy)
        Utility.setVisible(Frame, p1.isSelected, "InternalDropdown")
    end

    dropdownJanitor:add(p1.toggled:Connect(updateVisibility))
    Utility.setVisible(Frame, p1.isSelected, "InternalDropdown")

    local n1 = 0
    local v5 = false

    local function updateMaxIcons() -- line: 121
        -- upvalues: p1 (copy), Frame (copy), ScrollingFrame (copy), UIPadding (copy), iconModule (copy), n1 (ref), v5 (ref), updateMaxIcons (copy)
        n1 += 1

        if v5 then
            return
        end

        local v6 = n1

        v5 = true
        task.defer(function() -- line: 129
            -- upvalues: v6 (copy), n1 (ref), v5 (ref), updateMaxIcons (copy)
            v5 = false

            if n1 ~= v6 then
                updateMaxIcons()
            end
        end)

        local MaxIcons = Frame:GetAttribute("MaxIcons")

        if not MaxIcons then
            return
        end

        local t1 = {}

        for _, child in pairs(ScrollingFrame:GetChildren()) do
            if child:IsA("GuiObject") then
                table.insert(t1, {
                    child,
                    child.AbsolutePosition.Y
                })
            end
        end

        table.sort(t1, function(p5, p6) -- line: 146
            return p5[2] < p6[2]
        end)

        local v7 = math.ceil(MaxIcons)
        local n2 = 0
        local v8 = false

        for i = 1, v7 do
            local v9 = t1[i]

            if not v9 then
                break
            end

            local v10 = v9[1]
            local Y = v10.AbsoluteSize.Y
            local v11 = i == v7 and v7 ~= MaxIcons

            if v11 then
                Y *= MaxIcons - v7 + 1
            end

            n2 += Y

            if not v11 then
                local WidgetUID = v10:GetAttribute("WidgetUID")
                local v12 = WidgetUID and iconModule.getIconByUID(WidgetUID)

                if v12 then
                    local v13, v14

                    if v8 then
                        v14 = v8
                    else
                        v14 = true
                        v13 = p1:getInstance("ClickRegion")
                    end

                    v8 = v14
                    v12:getInstance("ClickRegion").NextSelectionUp = v13
                end
            end
        end

        local v15 = n2 + UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset

        ScrollingFrame.Size = UDim2.fromOffset(0, v15)
    end

    dropdownJanitor:add(ScrollingFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(updateMaxIcons))
    dropdownJanitor:add(ScrollingFrame.ChildAdded:Connect(updateMaxIcons))
    dropdownJanitor:add(ScrollingFrame.ChildRemoved:Connect(updateMaxIcons))
    dropdownJanitor:add(Frame:GetAttributeChangedSignal("MaxIcons"):Connect(updateMaxIcons))
    dropdownJanitor:add(p1.childThemeModified:Connect(updateMaxIcons))
    updateMaxIcons()

    return Frame
end
