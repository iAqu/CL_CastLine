-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1 = Color3.fromRGB(39, 41, 48)

return function(p1) -- line: 3
    -- upvalues: v1 (copy)
    local ClickRegion = p1:getInstance("ClickRegion")
    local CanvasGroup = Instance.new("CanvasGroup")

    CanvasGroup.Name = "Caption"
    CanvasGroup.AnchorPoint = Vector2.new(0.5, 0)
    CanvasGroup.BackgroundTransparency = 1
    CanvasGroup.BorderSizePixel = 0
    CanvasGroup.GroupTransparency = 1
    CanvasGroup.Position = UDim2.fromOffset(0, 0)
    CanvasGroup.Visible = true
    CanvasGroup.ZIndex = 30
    CanvasGroup.Parent = ClickRegion

    local Frame = Instance.new("Frame")

    Frame.Name = "Box"
    Frame.AutomaticSize = Enum.AutomaticSize.XY
    Frame.BackgroundColor3 = v1
    Frame.Position = UDim2.fromOffset(4, 7)
    Frame.ZIndex = 12
    Frame.Parent = CanvasGroup

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Header"
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    TextLabel.Text = "Caption"
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 15
    TextLabel.TextTruncate = Enum.TextTruncate.None
    TextLabel.TextWrapped = false
    TextLabel.AutomaticSize = Enum.AutomaticSize.X
    TextLabel.BackgroundTransparency = 1
    TextLabel.LayoutOrder = 1
    TextLabel.Size = UDim2.fromOffset(0, 16)
    TextLabel.ZIndex = 18
    TextLabel.Parent = Frame

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.Name = "Layout"
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.Parent = Frame

    local UICorner = Instance.new("UICorner")

    UICorner.Name = "CaptionCorner"
    UICorner.Parent = Frame

    local UIPadding = Instance.new("UIPadding")

    UIPadding.Name = "Padding"
    UIPadding.PaddingBottom = UDim.new(0, 12)
    UIPadding.PaddingLeft = UDim.new(0, 12)
    UIPadding.PaddingRight = UDim.new(0, 12)
    UIPadding.PaddingTop = UDim.new(0, 12)
    UIPadding.Parent = Frame

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Hotkeys"
    Frame2.AutomaticSize = Enum.AutomaticSize.Y
    Frame2.BackgroundTransparency = 1
    Frame2.LayoutOrder = 3
    Frame2.Size = UDim2.fromScale(1, 0)
    Frame2.Visible = false
    Frame2.Parent = Frame

    local UIListLayout2 = Instance.new("UIListLayout")

    UIListLayout2.Name = "Layout1"
    UIListLayout2.Padding = UDim.new(0, 6)
    UIListLayout2.FillDirection = Enum.FillDirection.Vertical
    UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout2.HorizontalFlex = Enum.UIFlexAlignment.None
    UIListLayout2.ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    UIListLayout2.VerticalFlex = Enum.UIFlexAlignment.None
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout2.Parent = Frame2

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Key1"
    ImageLabel.Image = "rbxasset://textures/ui/Controls/key_single.png"
    ImageLabel.ImageTransparency = 0.7
    ImageLabel.ScaleType = Enum.ScaleType.Slice
    ImageLabel.SliceCenter = Rect.new(5, 5, 23, 24)
    ImageLabel.AutomaticSize = Enum.AutomaticSize.X
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.LayoutOrder = 1
    ImageLabel.Size = UDim2.fromOffset(0, 30)
    ImageLabel.ZIndex = 15
    ImageLabel.Parent = Frame2

    local UIPadding2 = Instance.new("UIPadding")

    UIPadding2.Name = "Inset"
    UIPadding2.PaddingLeft = UDim.new(0, 8)
    UIPadding2.PaddingRight = UDim.new(0, 8)
    UIPadding2.Parent = ImageLabel

    local TextLabel2 = Instance.new("TextLabel")

    TextLabel2.AutoLocalize = false
    TextLabel2.Name = "LabelContent"
    TextLabel2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    TextLabel2.Text = ""
    TextLabel2.TextColor3 = Color3.fromRGB(189, 190, 190)
    TextLabel2.TextSize = 15
    TextLabel2.AutomaticSize = Enum.AutomaticSize.X
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Position = UDim2.fromOffset(0, -1)
    TextLabel2.Size = UDim2.fromScale(1, 1)
    TextLabel2.ZIndex = 16
    TextLabel2.Parent = ImageLabel

    local ImageLabel2 = Instance.new("ImageLabel")

    ImageLabel2.Name = "Caret"
    ImageLabel2.Image = "rbxassetid://101906294438076"
    ImageLabel2.ImageColor3 = v1
    ImageLabel2.AnchorPoint = Vector2.new(0, 0.5)
    ImageLabel2.BackgroundTransparency = 1
    ImageLabel2.Position = UDim2.new(0, 0, 0, 4)
    ImageLabel2.Size = UDim2.fromOffset(16, 8)
    ImageLabel2.ZIndex = 12
    ImageLabel2.Parent = CanvasGroup

    local ImageLabel3 = Instance.new("ImageLabel")

    ImageLabel3.Visible = true
    ImageLabel3.Name = "DropShadow"
    ImageLabel3.Image = "rbxassetid://124920646932671"
    ImageLabel3.ImageColor3 = Color3.fromRGB(0, 0, 0)
    ImageLabel3.ImageTransparency = 0.45
    ImageLabel3.ScaleType = Enum.ScaleType.Slice
    ImageLabel3.SliceCenter = Rect.new(12, 12, 13, 13)
    ImageLabel3.BackgroundTransparency = 1
    ImageLabel3.Position = UDim2.fromOffset(0, 5)
    ImageLabel3.Size = UDim2.new(1, 0, 0, 48)
    ImageLabel3.Parent = CanvasGroup
    Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 145
        -- upvalues: Frame (copy), ImageLabel3 (copy)
        ImageLabel3.Size = UDim2.new(1, 0, 0, Frame.AbsoluteSize.Y + 8)
    end)

    local captionJanitor = p1.captionJanitor
    local _, v2 = p1:clipOutside(CanvasGroup)

    v2.AutomaticSize = Enum.AutomaticSize.None

    local function matchSize() -- line: 155
        -- upvalues: CanvasGroup (copy), v2 (copy)
        local AbsoluteSize = CanvasGroup.AbsoluteSize

        v2.Size = UDim2.fromOffset(AbsoluteSize.X, AbsoluteSize.Y)
    end

    captionJanitor:add(CanvasGroup:GetPropertyChangedSignal("AbsoluteSize"):Connect(matchSize))

    local AbsoluteSize = CanvasGroup.AbsoluteSize

    v2.Size = UDim2.fromOffset(AbsoluteSize.X, AbsoluteSize.Y)

    local v3 = false
    local Header = CanvasGroup.Box.Header
    local UserInputService = game:GetService("UserInputService")

    local function updateHotkey(p2) -- line: 168
        -- upvalues: p1 (copy), CanvasGroup (copy), Frame2 (copy), TextLabel2 (copy), Header (copy), UserInputService (copy)
        local KeyboardEnabled = UserInputService.KeyboardEnabled
        local v4 = CanvasGroup:GetAttribute("CaptionText") or ""
        local v5 = v4 == "_hotkey_"

        if not KeyboardEnabled and v5 then
            p1:setCaption()

            return
        end

        Header.Text = v4
        Header.Visible = not v5

        if p2 then
            TextLabel2.Text = p2.Name
            Frame2.Visible = true
        end

        if not KeyboardEnabled then
            Frame2.Visible = false
        end
    end

    CanvasGroup:GetAttributeChangedSignal("CaptionText"):Connect(updateHotkey)

    local Quad = Enum.EasingStyle.Quad
    local v6 = TweenInfo.new(0.2, Quad, Enum.EasingDirection.In)
    local v7 = TweenInfo.new(0.2, Quad, Enum.EasingDirection.Out)
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")

    local function getCaptionPosition(p3) -- line: 194
        -- upvalues: v3 (ref)
        local v8 = if if p3 == nil then v3 else p3 then 10 else 2

        return UDim2.new(0.5, 0, 1, v8)
    end

    local function updatePosition(p4) -- line: 201
        -- upvalues: ClickRegion (copy), CanvasGroup (copy), ImageLabel2 (copy), v2 (copy), v3 (ref), v6 (copy), v7 (copy), TweenService (copy), RunService (copy)
        if not v3 then
            return
        end

        local v9 = if p4 == nil then v3 else p4
        local v10 = not v9

        if v10 == nil then
            v10 = v3
        end

        local v11 = if v10 then 10 else 2
        local v12 = UDim2.new(0.5, 0, 1, v11)
        local v13 = if if v9 == nil then v3 else v9 then 10 else 2
        local v14 = UDim2.new(0.5, 0, 1, v13)

        if v9 then
            local Offset = ImageLabel2.Position.Y.Offset

            ImageLabel2.Position = UDim2.fromOffset(0, Offset)
            CanvasGroup.AutomaticSize = Enum.AutomaticSize.XY
            CanvasGroup.Size = UDim2.fromOffset(32, 53)
        else
            local AbsoluteSize = CanvasGroup.AbsoluteSize

            CanvasGroup.AutomaticSize = Enum.AutomaticSize.Y
            CanvasGroup.Size = UDim2.fromOffset(AbsoluteSize.X, AbsoluteSize.Y)
        end

        local v15

        local function updateCaret() -- line: 230
            -- upvalues: v15 (ref), ClickRegion (copy), CanvasGroup (copy), ImageLabel2 (copy)
            local v16 = ClickRegion.AbsolutePosition.X - CanvasGroup.AbsolutePosition.X + ClickRegion.AbsoluteSize.X / 2 - ImageLabel2.AbsoluteSize.X / 2
            local Offset = ImageLabel2.Position.Y.Offset
            local v17 = UDim2.fromOffset(v16, Offset)

            if v15 ~= v16 then
                v15 = v16
                ImageLabel2.Position = UDim2.fromOffset(0, Offset)
                task.wait()
            end

            ImageLabel2.Position = v17
        end

        v2.Position = v12
        updateCaret()

        local tween = TweenService:Create(v2, v9 and v6 or v7, {
            Position = v14
        })
        local connection = RunService.Heartbeat:Connect(updateCaret)

        tween:Play()
        tween.Completed:Once(function() -- line: 253
            -- upvalues: connection (copy)
            connection:Disconnect()
        end)
    end

    captionJanitor:add(ClickRegion:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 258
        -- upvalues: updatePosition (copy)
        updatePosition()
    end))
    updatePosition(false)
    captionJanitor:add(p1.toggleKeyAdded:Connect(updateHotkey))

    for v19, _ in pairs(p1.bindedToggleKeys) do
        local KeyboardEnabled = UserInputService.KeyboardEnabled
        local v20 = CanvasGroup:GetAttribute("CaptionText") or ""
        local v21 = v20 == "_hotkey_"
        local v22 = false

        if KeyboardEnabled then
            Header.Text = v20
            Header.Visible = not v21

            if v19 then
                TextLabel2.Text = v19.Name
                Frame2.Visible = true
            end
        elseif v21 then
            v22 = true
        else
            Header.Text = v20
            Header.Visible = not v21

            if v19 then
                TextLabel2.Text = v19.Name
                Frame2.Visible = true
            end
        end

        if v22 then
            p1:setCaption()
        elseif not KeyboardEnabled then
            Frame2.Visible = false
        end

        break
    end

    captionJanitor:add(p1.fakeToggleKeyChanged:Connect(updateHotkey))

    local fakeToggleKey = p1.fakeToggleKey

    if fakeToggleKey then
        local KeyboardEnabled = UserInputService.KeyboardEnabled
        local v23 = CanvasGroup:GetAttribute("CaptionText") or ""
        local v24 = v23 == "_hotkey_"
        local v25

        if KeyboardEnabled then
            Header.Text = v23
            Header.Visible = not v24
            TextLabel2.Text = fakeToggleKey.Name
            v25 = false
            Frame2.Visible = true
        elseif v24 then
            v25 = true
        else
            Header.Text = v23
            Header.Visible = not v24
            TextLabel2.Text = fakeToggleKey.Name
            v25 = false
            Frame2.Visible = true
        end

        if v25 then
            p1:setCaption()
        elseif not KeyboardEnabled then
            Frame2.Visible = false
        end
    end

    local function setCaptionEnabled(p5) -- line: 274
        -- upvalues: p1 (copy), CanvasGroup (copy), Frame2 (copy), v2 (copy), v3 (ref), Header (copy), UserInputService (copy), v6 (copy), v7 (copy), TweenService (copy), updatePosition (copy)
        if v3 == p5 then
            return
        end

        local joinedFrame = p1.joinedFrame
        local v26 = (not joinedFrame or not string.match(joinedFrame.Name, "Dropdown")) and p5

        v3 = v26

        local v27, v28

        if v26 then
            v28 = 0
            v27 = v6
        else
            v28 = 1
        end

        if not v26 or not v27 then
            v27 = v7
        end

        TweenService:Create(CanvasGroup, v27, {
            GroupTransparency = v28
        }):Play()

        if v26 then
            v2:SetAttribute("ForceUpdate", true)
        end

        updatePosition()

        local KeyboardEnabled = UserInputService.KeyboardEnabled
        local v29 = CanvasGroup:GetAttribute("CaptionText") or ""
        local v30 = v29 == "_hotkey_"

        if not KeyboardEnabled and v30 then
            p1:setCaption()

            return
        end

        Header.Text = v29
        Header.Visible = not v30

        if not KeyboardEnabled then
            Frame2.Visible = false
        end
    end

    local iconModule = require(p1.iconModule)

    captionJanitor:add(p1.stateChanged:Connect(function(p6) -- line: 299
        -- upvalues: p1 (copy), setCaptionEnabled (copy), iconModule (copy)
        if p6 ~= "Viewing" then
            iconModule.captionLastClosedClock = os.clock()
            setCaptionEnabled(false)

            return
        end

        local captionLastClosedClock = iconModule.captionLastClosedClock
        local v31 = (captionLastClosedClock and os.clock() - captionLastClosedClock or 999) < 0.3 and 0 or 0.5

        task.delay(v31, function() -- line: 304
            -- upvalues: p1 (copy), setCaptionEnabled (copy)
            if p1.activeState == "Viewing" then
                setCaptionEnabled(true)
            end
        end)
    end))

    return CanvasGroup
end
