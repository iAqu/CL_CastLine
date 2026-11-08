-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 6
    local Frame = Instance.new("Frame")

    Frame:SetAttribute("WidgetUID", p1.UID)
    Frame.Name = "Widget"
    Frame.BackgroundTransparency = 1
    Frame.Visible = true
    Frame.ZIndex = 20
    Frame.Active = false
    Frame.ClipsDescendants = true

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "IconButton"
    Frame2.Visible = true
    Frame2.ZIndex = 2
    Frame2.BorderSizePixel = 0
    Frame2.Parent = Frame
    Frame2.ClipsDescendants = true
    Frame2.Active = false
    p1.deselected:Connect(function() -- line: 24
        -- upvalues: p1 (copy), Frame2 (copy)
        Frame2.ClipsDescendants = true
        task.delay(0.2, function() -- line: 26
            -- upvalues: p1 (copy), Frame2 (copy)
            if p1.isSelected then
                Frame2.ClipsDescendants = false
            end
        end)
    end)

    local GuiService = game:GetService("GuiService")

    p1:setBehaviour("IconButton", "BackgroundTransparency", function(p3) -- line: 35
        -- upvalues: GuiService (copy)
        local v1 = p3 * GuiService.PreferredTransparency

        if p3 == 1 then
            return p3
        end

        return v1
    end)
    p1.janitor:add(GuiService:GetPropertyChangedSignal("PreferredTransparency"):Connect(function() -- line: 43
        -- upvalues: p1 (copy), Frame2 (copy)
        p1:refreshAppearance(Frame2, "BackgroundTransparency")
    end))

    local UICorner = Instance.new("UICorner")

    UICorner:SetAttribute("Collective", "IconCorners")
    UICorner.Name = "UICorner"
    UICorner.Parent = Frame2

    local v2 = require(script.Parent.Menu)(p1)
    local MenuUIListLayout, MenuGap = v2.MenuUIListLayout, v2.MenuGap

    v2.Parent = Frame2

    local Frame3 = Instance.new("Frame")

    Frame3.Name = "IconSpot"
    Frame3.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
    Frame3.BackgroundTransparency = 0.9
    Frame3.Visible = true
    Frame3.AnchorPoint = Vector2.new(0, 0.5)
    Frame3.ZIndex = 5
    Frame3.Parent = v2
    UICorner:Clone().Parent = Frame3

    local clone = Frame3:Clone()

    clone.UICorner.Name = "OverlayUICorner"
    clone.Name = "IconOverlay"
    clone.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    clone.ZIndex = Frame3.ZIndex + 1
    clone.Size = UDim2.new(1, 0, 1, 0)
    clone.Position = UDim2.new(0, 0, 0, 0)
    clone.AnchorPoint = Vector2.new(0, 0)
    clone.Visible = false
    clone.Parent = Frame3

    local TextButton = Instance.new("TextButton")

    TextButton:SetAttribute("CorrespondingIconUID", p1.UID)
    TextButton.Name = "ClickRegion"
    TextButton.BackgroundTransparency = 1
    TextButton.Visible = true
    TextButton.Text = ""
    TextButton.ZIndex = 20
    TextButton.Selectable = true
    TextButton.SelectionGroup = true
    TextButton.Parent = Frame3
    require(script.Parent.Parent.Features.Gamepad).registerButton(TextButton)
    UICorner:Clone().Parent = TextButton

    local Frame4 = Instance.new("Frame")

    Frame4.Name = "Contents"
    Frame4.BackgroundTransparency = 1
    Frame4.Size = UDim2.fromScale(1, 1)
    Frame4.Parent = Frame3

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.Name = "ContentsList"
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.VerticalFlex = Enum.UIFlexAlignment.SpaceEvenly
    UIListLayout.Padding = UDim.new(0, 3)
    UIListLayout.Parent = Frame4

    local Frame5 = Instance.new("Frame")

    Frame5.Name = "PaddingLeft"
    Frame5.LayoutOrder = 1
    Frame5.ZIndex = 5
    Frame5.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame5.BackgroundTransparency = 1
    Frame5.BorderSizePixel = 0
    Frame5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame5.Parent = Frame4

    local Frame6 = Instance.new("Frame")

    Frame6.Name = "PaddingCenter"
    Frame6.LayoutOrder = 3
    Frame6.ZIndex = 5
    Frame6.Size = UDim2.new(0, 0, 1, 0)
    Frame6.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame6.BackgroundTransparency = 1
    Frame6.BorderSizePixel = 0
    Frame6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame6.Parent = Frame4

    local Frame7 = Instance.new("Frame")

    Frame7.Name = "PaddingRight"
    Frame7.LayoutOrder = 5
    Frame7.ZIndex = 5
    Frame7.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame7.BackgroundTransparency = 1
    Frame7.BorderSizePixel = 0
    Frame7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame7.Parent = Frame4

    local Frame8 = Instance.new("Frame")

    Frame8.Name = "IconLabelContainer"
    Frame8.LayoutOrder = 4
    Frame8.ZIndex = 3
    Frame8.AnchorPoint = Vector2.new(0, 0.5)
    Frame8.Size = UDim2.new(0, 0, 0.5, 0)
    Frame8.BackgroundTransparency = 1
    Frame8.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame8.Parent = Frame4

    local TextLabel = Instance.new("TextLabel")
    local v3 = workspace.CurrentCamera.ViewportSize.X + 200

    TextLabel.Name = "IconLabel"
    TextLabel.LayoutOrder = 4
    TextLabel.ZIndex = 15
    TextLabel.AnchorPoint = Vector2.new(0, 0)
    TextLabel.Size = UDim2.new(0, v3, 1, 0)
    TextLabel.ClipsDescendants = false
    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.fromScale(0, 0)
    TextLabel.RichText = true
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Text = ""
    TextLabel.TextWrapped = true
    TextLabel.TextWrap = true
    TextLabel.TextScaled = false
    TextLabel.Active = false
    TextLabel.AutoLocalize = true
    TextLabel.Parent = Frame8

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "IconImage"
    ImageLabel.LayoutOrder = 2
    ImageLabel.ZIndex = 15
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
    ImageLabel.Size = UDim2.new(0, 0, 0.5, 0)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Position = UDim2.new(0, 11, 0.5, 0)
    ImageLabel.ScaleType = Enum.ScaleType.Stretch
    ImageLabel.Active = false
    ImageLabel.Parent = Frame4

    local clone2 = UICorner:Clone()

    clone2:SetAttribute("Collective", nil)
    clone2.CornerRadius = UDim.new(0, 0)
    clone2.Name = "IconImageCorner"
    clone2.Parent = ImageLabel

    local TweenService = game:GetService("TweenService")
    local n1 = 0

    local function handleLabelAndImageChangesUnstaggered(_) -- line: 194
        -- upvalues: p1 (copy), p2 (copy), Frame (copy), Frame2 (copy), v2 (copy), MenuUIListLayout (copy), MenuGap (copy), Frame3 (copy), TextButton (copy), Frame4 (copy), UIListLayout (copy), Frame5 (copy), Frame6 (copy), Frame7 (copy), Frame8 (copy), TextLabel (copy), v3 (copy), ImageLabel (copy), TweenService (copy), n1 (ref)
        task.defer(function() -- line: 200
            -- upvalues: p1 (copy), p2 (copy), Frame (copy), Frame2 (copy), v2 (copy), MenuUIListLayout (copy), MenuGap (copy), Frame3 (copy), TextButton (copy), Frame4 (copy), UIListLayout (copy), Frame5 (copy), Frame6 (copy), Frame7 (copy), Frame8 (copy), TextLabel (copy), v3 (copy), ImageLabel (copy), TweenService (copy), n1 (ref)
            local indicator = p1.indicator
            local v4 = indicator and indicator.Visible
            local v5 = v4 or TextLabel.Text ~= ""
            local v6 = ImageLabel.Image ~= "" and ImageLabel.Image ~= nil
            local _ = Enum.HorizontalAlignment.Center
            local v7 = UDim2.fromScale(1, 1)

            if not v6 or v5 then
                if v6 or not v5 then
                    if v6 and v5 then
                        Frame8.Visible = true
                        ImageLabel.Visible = true
                        Frame5.Visible = true
                        Frame6.Visible = not v4
                        Frame7.Visible = not v4

                        local _ = Enum.HorizontalAlignment.Left
                    end
                else
                    Frame8.Visible = true
                    ImageLabel.Visible = false
                    Frame5.Visible = true
                    Frame6.Visible = false
                    Frame7.Visible = true
                end
            else
                Frame8.Visible = false
                ImageLabel.Visible = true
                Frame5.Visible = false
                Frame6.Visible = false
                Frame7.Visible = false
            end

            Frame2.Size = v7

            local function getItemWidth(p5) -- line: 230
                return p5:GetAttribute("TargetWidth") or p5.AbsoluteSize.X
            end

            local Offset = UIListLayout.Padding.Offset
            local X = TextLabel.TextBounds.X

            Frame8.Size = UDim2.new(0, X, TextLabel.Size.Y.Scale, 0)

            local v8 = Offset

            for _, child in pairs(Frame4:GetChildren()) do
                if child:IsA("GuiObject") and child.Visible == true then
                    v8 += getItemWidth(child) + Offset
                end
            end

            local MinimumWidth = Frame:GetAttribute("MinimumWidth")
            local MinimumHeight = Frame:GetAttribute("MinimumHeight")
            local BorderSize = Frame:GetAttribute("BorderSize")
            local v9 = math.clamp(v8, MinimumWidth, v3)
            local v10 = #p1.menuIcons > 0 and p1.isSelected
            local v11

            if v10 then
                local n2 = 0

                for _, child in pairs(v2:GetChildren()) do
                    if child ~= Frame3 and child:IsA("GuiObject") and child.Visible then
                        n2 += getItemWidth(child) + MenuUIListLayout.Padding.Offset
                    end
                end

                local v12 = if Frame3.Visible then v9 else v9 - ((Frame3:GetAttribute("TargetWidth") or Frame3.AbsoluteSize.X) + MenuUIListLayout.Padding.Offset * 2 + BorderSize)

                v11 = n2 - BorderSize * 0.5
                v9 = v12 + (v11 - BorderSize * 0.75)
            else
                v11 = 0
            end

            MenuGap.Visible = v10 and Frame3.Visible

            local DesiredWidth = Frame:GetAttribute("DesiredWidth")

            if not (DesiredWidth and v9 < DesiredWidth) then
                DesiredWidth = v9
            end

            p1.updateMenu:Fire()

            local v14 = math.max(DesiredWidth - v11, MinimumWidth) - BorderSize * 2
            local MenuWidth = v2:GetAttribute("MenuWidth")
            local v15 = MenuWidth and MenuWidth + v14 + MenuUIListLayout.Padding.Offset + 10
            local v16 = DesiredWidth

            if v15 then
                local MaxWidth = v2:GetAttribute("MaxWidth")
                local v17 = if MaxWidth then math.max(MaxWidth, MinimumWidth) else v15

                v2:SetAttribute("MenuCanvasWidth", DesiredWidth)

                if v17 < DesiredWidth then
                    v16 = v17
                end
            end

            local Quint = Enum.EasingStyle.Quint
            local Out = Enum.EasingDirection.Out
            local v19 = math.max(v14, Frame3:GetAttribute("TargetWidth") or Frame3.AbsoluteSize.X, Frame3.AbsoluteSize.X)
            local v21 = math.max(v16, Frame:GetAttribute("TargetWidth") or Frame.AbsoluteSize.X, Frame.AbsoluteSize.X)
            local v22 = TweenInfo.new(v19 / 750, Quint, Out)
            local v23 = TweenInfo.new(v21 / 750, Quint, Out)

            TweenService:Create(Frame3, v22, {
                Position = UDim2.new(0, BorderSize, 0.5, 0),
                Size = UDim2.new(0, v14, 1, -BorderSize * 2)
            }):Play()
            TweenService:Create(TextButton, v22, {
                Size = UDim2.new(0, v14, 1, 0)
            }):Play()

            local v24 = UDim2.fromOffset(v16, MinimumHeight)

            if Frame.Size.Y.Offset ~= MinimumHeight then
                Frame.Size = v24
            end

            Frame:SetAttribute("TargetWidth", v24.X.Offset)
            TweenService:Create(Frame, v23, {
                Size = v24
            }):Play()
            n1 += 1

            for i = 1, v23.Time * 100 do
                task.delay(i / 100, function() -- line: 312
                    -- upvalues: p1 (copy), p2 (copy)
                    p2.iconChanged:Fire(p1)
                end)
            end

            task.delay(v23.Time - 0.2, function() -- line: 316
                -- upvalues: p1 (copy), n1 (ref)
                n1 -= 1
                task.defer(function() -- line: 318
                    -- upvalues: p1 (copy), n1 (ref)
                    if n1 == 0 then
                        p1.resizingComplete:Fire()
                    end
                end)
            end)
            p1:updateParent()
        end)
    end

    local v25 = require(script.Parent.Parent.Utility).createStagger(0.01, handleLabelAndImageChangesUnstaggered)
    local v26 = true

    p1:setBehaviour("IconLabel", "Text", v25)
    p1:setBehaviour("IconLabel", "FontFace", function(p6) -- line: 331
        -- upvalues: TextLabel (copy), v25 (copy), v26 (ref)
        if TextLabel.FontFace ~= p6 then
            task.spawn(function() -- line: 336
                -- upvalues: v25 (copy), v26 (ref)
                v25()

                if v26 then
                    v26 = false

                    for _ = 1, 10 do
                        task.wait(1)
                        v25()
                    end
                end
            end)
        end
    end)

    local function updateBorderSize() -- line: 358
        -- upvalues: p1 (copy), Frame (copy), v2 (copy), MenuUIListLayout (copy), MenuGap (copy), Frame3 (copy), v25 (copy)
        task.defer(function() -- line: 359
            -- upvalues: p1 (copy), Frame (copy), v2 (copy), MenuUIListLayout (copy), MenuGap (copy), Frame3 (copy), v25 (copy)
            local BorderSize = Frame:GetAttribute("BorderSize")
            local alignment = p1.alignment
            local v27 = if Frame3.Visible == false then 0 else alignment == "Right" and -BorderSize or BorderSize

            v2.Position = UDim2.new(0, v27, 0, 0)
            MenuGap.Size = UDim2.fromOffset(BorderSize, 0)
            MenuUIListLayout.Padding = UDim.new(0, 0)
            v25()
        end)
    end

    p1:setBehaviour("Widget", "BorderSize", updateBorderSize)
    p1:setBehaviour("IconSpot", "Visible", updateBorderSize)
    p1.startMenuUpdate:Connect(v25)
    p1.updateSize:Connect(v25)
    p1:setBehaviour("ContentsList", "HorizontalAlignment", v25)
    p1:setBehaviour("Widget", "Visible", v25)
    p1:setBehaviour("Widget", "DesiredWidth", v25)
    p1:setBehaviour("Widget", "MinimumWidth", v25)
    p1:setBehaviour("Widget", "MinimumHeight", v25)
    p1:setBehaviour("Indicator", "Visible", v25)
    p1:setBehaviour("IconImageRatio", "AspectRatio", v25)
    p1:setBehaviour("IconImage", "Image", function(p7) -- line: 382
        -- upvalues: ImageLabel (copy), v25 (copy)
        local v29 = tonumber(p7) and "http://www.roblox.com/asset/?id=" .. p7 or p7 or ""

        if ImageLabel.Image ~= v29 then
            v25()
        end

        return v29
    end)
    p1.alignmentChanged:Connect(function(p8) -- line: 389
        -- upvalues: p1 (copy), Frame (copy), v2 (copy), MenuUIListLayout (copy), MenuGap (copy), Frame3 (copy), v25 (copy)
        local v30 = if p8 == "Center" then "Left" else p8

        MenuUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment[v30]
        task.defer(function() -- line: 359
            -- upvalues: p1 (copy), Frame (copy), v2 (copy), MenuUIListLayout (copy), MenuGap (copy), Frame3 (copy), v25 (copy)
            local BorderSize = Frame:GetAttribute("BorderSize")
            local alignment = p1.alignment
            local v31 = if Frame3.Visible == false then 0 else alignment == "Right" and -BorderSize or BorderSize

            v2.Position = UDim2.new(0, v31, 0, 0)
            MenuGap.Size = UDim2.fromOffset(BorderSize, 0)
            MenuUIListLayout.Padding = UDim.new(0, 0)
            v25()
        end)
    end)

    local LocalPlayer = game:GetService("Players").LocalPlayer
    local LocaleId = LocalPlayer.LocaleId

    p1.janitor:add(LocalPlayer:GetPropertyChangedSignal("LocaleId"):Connect(function() -- line: 401
        -- upvalues: p1 (copy), LocalPlayer (copy), LocaleId (ref)
        task.delay(0.2, function() -- line: 402
            -- upvalues: p1 (copy), LocalPlayer (copy), LocaleId (ref)
            local LocaleId2 = LocalPlayer.LocaleId

            if LocaleId2 == LocaleId then
                return
            end

            LocaleId = LocaleId2
            p1:refresh()
            task.wait(0.5)
            p1:refresh()
        end)
    end))

    local NumberValue = Instance.new("NumberValue")

    NumberValue.Name = "IconImageScale"
    NumberValue.Parent = ImageLabel
    NumberValue:GetPropertyChangedSignal("Value"):Connect(function() -- line: 416
        -- upvalues: ImageLabel (copy), NumberValue (copy)
        ImageLabel.Size = UDim2.new(NumberValue.Value, 0, NumberValue.Value, 0)
    end)

    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

    UIAspectRatioConstraint.Name = "IconImageRatio"
    UIAspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
    UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
    UIAspectRatioConstraint.Parent = ImageLabel

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Name = "IconGradient"
    UIGradient.Enabled = true
    UIGradient.Parent = Frame2

    local UIGradient2 = Instance.new("UIGradient")

    UIGradient2.Name = "IconSpotGradient"
    UIGradient2.Enabled = true
    UIGradient2.Parent = Frame3

    return Frame
end
