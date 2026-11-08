-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Themes = require(script.Parent.Parent.Features.Themes)

return function(p1) -- line: 5
    -- upvalues: TweenService (copy), RunService (copy), Themes (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = "Dropdown"
    Frame.AutomaticSize = Enum.AutomaticSize.X
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.AnchorPoint = Vector2.new(0.5, 0)
    Frame.Position = UDim2.new(0.5, 0, 1, 10)
    Frame.ZIndex = -2
    Frame.ClipsDescendants = true
    Frame.Parent = p1.widget

    local GuiService = game:GetService("GuiService")

    p1:setBehaviour("Dropdown", "BackgroundTransparency", function(p2) -- line: 20
        -- upvalues: GuiService (copy)
        local v1 = p2 * GuiService.PreferredTransparency

        if p2 == 1 then
            return p2
        end

        return v1
    end)
    p1.janitor:add(GuiService:GetPropertyChangedSignal("PreferredTransparency"):Connect(function() -- line: 28
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

    local NumberValue = Instance.new("NumberValue")

    NumberValue.Name = "DropdownSpeed"
    NumberValue.Value = 0.07
    NumberValue.Parent = Frame

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

    p1.dropdownChildAdded:Connect(function(p3) -- line: 81
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

        task.defer(function() -- line: 95
            -- upvalues: p3 (copy), v2 (copy)
            p3.joinJanitor:add(function() -- line: 96
                -- upvalues: p3 (copy), v2 (copy)
                p3:removeModification(v2)
            end)
        end)
    end)
    p1.dropdownSet:Connect(function(p4) -- line: 101
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

    local function updateMaxIcons() -- line: 113
        -- upvalues: Frame (copy), ScrollingFrame (copy), UIPadding (copy)
        local MaxIcons = Frame:GetAttribute("MaxIcons")

        if not MaxIcons then
            return 0
        end

        local t1 = {}

        for _, child in pairs(ScrollingFrame:GetChildren()) do
            if child:IsA("GuiObject") and child.Visible then
                table.insert(t1, child)
            end
        end

        table.sort(t1, function(p5, p6) -- line: 124
            return p5.AbsolutePosition.Y < p6.AbsolutePosition.Y
        end)

        local v5 = math.ceil(MaxIcons)
        local n1 = 0

        for i = 1, v5 do
            local v6 = t1[i]

            if not v6 then
                break
            end

            local Y = v6.AbsoluteSize.Y

            if i == v5 and v5 ~= MaxIcons then
                Y *= MaxIcons - v5 + 1
            end

            n1 += Y
        end

        return n1 + (UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset)
    end

    local v7, v8, v9, v10

    local function getTweenInfo() -- line: 145
        -- upvalues: Frame (copy), NumberValue (copy), v9 (ref), v10 (ref), Themes (copy)
        local v11 = Themes.getInstanceValue(Frame, "MaxIcons") or 1

        if v9 and v9 == v11 and v10 then
            return v10
        end

        local v12 = TweenInfo.new(NumberValue.Value * v11, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

        v10 = v12
        v9 = v11

        return v12
    end

    local function updateVisibility() -- line: 159
        -- upvalues: p1 (copy), Frame (copy), NumberValue (copy), updateMaxIcons (copy), v7 (ref), v8 (ref), v9 (ref), v10 (ref), TweenService (copy), Themes (copy)
        local v13 = Themes.getInstanceValue(Frame, "MaxIcons") or 1
        local v14

        if v9 and v9 == v13 and v10 then
            v14 = v10
        else
            v14 = TweenInfo.new(NumberValue.Value * v13, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
            v10 = v14
            v9 = v13
        end

        if v7 then
            v7:Cancel()
            v7 = nil
        end

        if v8 then
            v8:Cancel()
            v8 = nil
        end

        if p1.isSelected then
            local v15 = updateMaxIcons()

            Frame.Visible = true
            Frame.BackgroundTransparency = 0
            Frame.Size = UDim2.new(0, Frame.Size.X.Offset, 0, 0)
            v7 = TweenService:Create(Frame, v14, {
                Size = UDim2.new(0, Frame.Size.X.Offset, 0, v15)
            })
            v7:Play()
            v7.Completed:Connect(function() -- line: 180
                -- upvalues: v7 (ref)
                v7 = nil
            end)
        else
            v8 = TweenService:Create(Frame, TweenInfo.new(0), {
                Size = UDim2.new(0, Frame.Size.X.Offset, 0, 0)
            })
            v8:Play()
            v8.Completed:Connect(function() -- line: 187
                -- upvalues: v8 (ref)
                v8 = nil
            end)
        end
    end

    dropdownJanitor:add(p1.toggled:Connect(updateVisibility))
    updateVisibility()

    local function updateChildSize() -- line: 197
        -- upvalues: p1 (copy), Frame (copy), NumberValue (copy), updateMaxIcons (copy), v7 (ref), v8 (ref), v9 (ref), v10 (ref), TweenService (copy), RunService (copy), Themes (copy)
        local v17 = Themes.getInstanceValue(Frame, "MaxIcons") or 1
        local v18

        if v9 and v9 == v17 and v10 then
            v18 = v10
        else
            v18 = TweenInfo.new(NumberValue.Value * v17, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
            v10 = v18
            v9 = v17
        end

        if p1.isSelected then
            if v7 then
                v7:Cancel()
                v7 = nil
            end

            if v8 then
                v8:Cancel()
                v8 = nil
            end

            RunService.Heartbeat:Wait()

            local v19 = updateMaxIcons()

            v7 = TweenService:Create(Frame, v18, {
                Size = UDim2.new(0, Frame.Size.X.Offset, 0, v19)
            })
            v7:Play()
            v7.Completed:Connect(function() -- line: 215
                -- upvalues: v7 (ref)
                v7 = nil
            end)
        end
    end

    dropdownJanitor:add(p1.toggled:Connect(updateVisibility))

    local n2 = 0
    local v20 = false

    local function updateMaxIconsListener() -- line: 228
        -- upvalues: p1 (copy), Frame (copy), ScrollingFrame (copy), UIPadding (copy), iconModule (copy), n2 (ref), v20 (ref), updateMaxIconsListener (copy)
        n2 += 1

        if v20 then
            return
        end

        local v21 = n2

        v20 = true
        task.defer(function() -- line: 233
            -- upvalues: v21 (copy), n2 (ref), v20 (ref), updateMaxIconsListener (copy)
            v20 = false

            if n2 ~= v21 then
                updateMaxIconsListener()
            end
        end)

        local MaxIcons = Frame:GetAttribute("MaxIcons")

        if not MaxIcons then
            return
        end

        local t2 = {}

        for _, child in pairs(ScrollingFrame:GetChildren()) do
            if child:IsA("GuiObject") and child.Visible then
                table.insert(t2, {
                    child,
                    child.AbsolutePosition.Y
                })
            end
        end

        table.sort(t2, function(p7, p8) -- line: 248
            return p7[2] < p8[2]
        end)

        local v22 = math.ceil(MaxIcons)
        local n3 = 0
        local v23 = false

        for i = 1, v22 do
            local v24 = t2[i]

            if not v24 then
                break
            end

            local v25 = v24[1]
            local Y = v25.AbsoluteSize.Y
            local v26 = i == v22 and v22 ~= MaxIcons

            if v26 then
                Y *= MaxIcons - v22 + 1
            end

            n3 += Y

            if not v26 then
                local WidgetUID = v25:GetAttribute("WidgetUID")
                local v27 = WidgetUID and iconModule.getIconByUID(WidgetUID)

                if v27 then
                    local v28, v29

                    if v23 then
                        v29 = v23
                    else
                        v29 = true
                        v28 = p1:getInstance("ClickRegion")
                    end

                    v23 = v29
                    v27:getInstance("ClickRegion").NextSelectionUp = v28
                end
            end
        end

        local v30 = n3 + (UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset)

        ScrollingFrame.Size = UDim2.fromOffset(0, v30)
    end

    dropdownJanitor:add(ScrollingFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(updateMaxIconsListener))
    dropdownJanitor:add(ScrollingFrame.ChildAdded:Connect(updateMaxIconsListener))
    dropdownJanitor:add(ScrollingFrame.ChildRemoved:Connect(updateChildSize))
    dropdownJanitor:add(ScrollingFrame.ChildRemoved:Connect(updateMaxIconsListener))
    dropdownJanitor:add(Frame:GetAttributeChangedSignal("MaxIcons"):Connect(updateMaxIconsListener))
    dropdownJanitor:add(Frame:GetAttributeChangedSignal("MaxIcons"):Connect(updateChildSize))
    dropdownJanitor:add(p1.childThemeModified:Connect(updateMaxIconsListener))
    updateMaxIconsListener()

    local function connectVisibilityListeners(p9) -- line: 293
        -- upvalues: updateChildSize (copy)
        if not p9:IsA("GuiObject") then
            return
        end

        p9:GetPropertyChangedSignal("Visible"):Connect(updateChildSize)
        p9:GetPropertyChangedSignal("Size"):Connect(updateChildSize)
    end

    for _, child in pairs(ScrollingFrame:GetChildren()) do
        if child:IsA("GuiObject") then
            child:GetPropertyChangedSignal("Visible"):Connect(updateChildSize)
            child:GetPropertyChangedSignal("Size"):Connect(updateChildSize)
        end
    end

    ScrollingFrame.ChildAdded:Connect(function(p10) -- line: 305
        -- upvalues: updateChildSize (copy), RunService (copy)
        RunService.Heartbeat:Wait()

        if p10:IsA("GuiObject") then
            p10:GetPropertyChangedSignal("Visible"):Connect(updateChildSize)
            p10:GetPropertyChangedSignal("Size"):Connect(updateChildSize)
        end

        updateChildSize()
    end)
    Frame.Visible = false

    return Frame
end
