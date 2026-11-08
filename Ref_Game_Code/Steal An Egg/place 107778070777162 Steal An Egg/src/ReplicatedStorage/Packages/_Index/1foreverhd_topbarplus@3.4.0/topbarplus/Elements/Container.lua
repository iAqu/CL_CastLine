-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1 = false
local n1 = 0

return function(p1) -- line: 3
    -- upvalues: v1 (ref), n1 (ref)
    local GuiService = game:GetService("GuiService")
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local t1 = {}
    local v2 = require(script.Parent.Parent.Packages.GoodSignal).new()
    local v3 = GuiService:GetGuiInset()
    local n2 = 0
    local n3 = 0
    local n4 = 0
    local n5 = 0
    local v4 = false
    local v5 = false

    local function checkInset(p2) -- line: 20
        -- upvalues: p1 (copy), GuiService (copy), Players (copy), UserInputService (copy), v2 (copy), v3 (ref), n2 (ref), n3 (ref), n4 (ref), n5 (ref), v4 (ref), v5 (ref), checkInset (copy), v1 (ref), n1 (ref)
        local Height = GuiService.TopbarInset.Height
        local v6 = Height <= 36

        v4 = GuiService:IsTenFootInterface()
        v5 = UserInputService.VREnabled
        p1.isOldTopbar = v6
        n5 += 1

        if Height ~= 0 or p2 ~= nil then
            if n5 == 1 then
                task.delay(5, function() -- line: 38
                    -- upvalues: Players (copy), n5 (ref), checkInset (copy)
                    Players.LocalPlayer:WaitForChild("PlayerGui")

                    if n5 == 1 then
                        checkInset()
                    end
                end)
            end
        else
            task.defer(function() -- line: 33
                -- upvalues: checkInset (copy)
                task.wait(8)
                checkInset("ForceConvertToOld")
            end)
        end

        if not (not p1.isOldTopbar or v4 or v5 or v1 ~= false or Height == 0 and p2 ~= "ForceConvertToOld") then
            v1 = true
            task.defer(function() -- line: 50
                -- upvalues: p1 (copy), GuiService (copy)
                local Classic = require(script.Parent.Parent.Features.Themes.Classic)

                p1.modifyBaseTheme(Classic)

                local function decideToHideTopbar() -- line: 57
                    -- upvalues: p1 (copy), GuiService (copy)
                    if GuiService.MenuIsOpen then
                        p1.setTopbarEnabled(false, true)
                    else
                        p1.setTopbarEnabled()
                    end
                end

                GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(decideToHideTopbar)

                if GuiService.MenuIsOpen then
                    p1.setTopbarEnabled(false, true)
                else
                    p1.setTopbarEnabled()
                end
            end)
        end

        v3 = GuiService:GetGuiInset()
        n2 = if v6 then 12 else v3.Y - 50
        n3 = v6 and 2 or 0
        n4 = -2

        if v4 then
            n2 = 10
            n3 = 0
        end

        if GuiService.TopbarInset.Height == 0 and not v1 then
            n3 += 13
            n4 = 50
        end

        v2:Fire(v3)

        local Y = v3.Y

        if Y == n1 then
            return
        end

        n1 = Y
        task.defer(function() -- line: 88
            -- upvalues: Y (copy), p1 (copy)
            p1.insetHeightChanged:Fire(Y)
        end)
    end

    GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(checkInset)
    checkInset("FirstTime")

    local ScreenGui = Instance.new("ScreenGui")

    v2:Connect(function() -- line: 98
        -- upvalues: n2 (ref), ScreenGui (copy)
        ScreenGui:SetAttribute("StartInset", n2)
    end)
    ScreenGui.Name = "TopbarStandard"
    ScreenGui.Enabled = true
    ScreenGui.DisplayOrder = p1.baseDisplayOrder
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ScreenInsets = Enum.ScreenInsets.TopbarSafeInsets
    t1[ScreenGui.Name] = ScreenGui
    p1.baseDisplayOrderChanged:Connect(function() -- line: 109
        -- upvalues: p1 (copy), ScreenGui (copy)
        ScreenGui.DisplayOrder = p1.baseDisplayOrder
    end)

    local Frame = Instance.new("Frame")

    Frame.Name = "Holders"
    Frame.BackgroundTransparency = 1
    v2:Connect(function() -- line: 116
        -- upvalues: n3 (ref), n4 (ref), v4 (ref), v5 (ref), Frame (copy)
        local v9 = if v5 then 36 else 56
        local v10 = if v4 then UDim2.new(1, 0, 0, v9) else UDim2.new(1, 0, 1, n4)

        Frame.Position = UDim2.new(0, 0, 0, n3)
        Frame.Size = v10
    end)
    Frame.Visible = true
    Frame.ZIndex = 1
    Frame.Parent = ScreenGui

    local clone = ScreenGui:Clone()
    local Holders = clone.Holders

    local function updateCenteredHoldersHeight() -- line: 128
        -- upvalues: GuiService (copy), n4 (ref), Holders (copy)
        Holders.Size = UDim2.new(1, 0, 0, GuiService.TopbarInset.Height + n4)
    end

    clone.Name = "TopbarCentered"
    clone.DisplayOrder = p1.baseDisplayOrder
    clone.ScreenInsets = Enum.ScreenInsets.None
    p1.baseDisplayOrderChanged:Connect(function() -- line: 134
        -- upvalues: p1 (copy), clone (copy)
        clone.DisplayOrder = p1.baseDisplayOrder
    end)
    t1[clone.Name] = clone
    v2:Connect(updateCenteredHoldersHeight)
    Holders.Size = UDim2.new(1, 0, 0, GuiService.TopbarInset.Height + n4)

    local clone2 = ScreenGui:Clone()

    clone2.Name ..= "Clipped"
    clone2.DisplayOrder = p1.baseDisplayOrder + 1
    p1.baseDisplayOrderChanged:Connect(function() -- line: 145
        -- upvalues: p1 (copy), clone2 (copy)
        clone2.DisplayOrder = p1.baseDisplayOrder + 1
    end)
    t1[clone2.Name] = clone2

    local clone3 = clone:Clone()

    clone3.Name ..= "Clipped"
    clone3.DisplayOrder = p1.baseDisplayOrder + 1
    p1.baseDisplayOrderChanged:Connect(function() -- line: 153
        -- upvalues: p1 (copy), clone3 (copy)
        clone3.DisplayOrder = p1.baseDisplayOrder + 1
    end)
    t1[clone3.Name] = clone3

    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame:SetAttribute("IsAHolder", true)
    ScrollingFrame.Name = "Left"
    v2:Connect(function() -- line: 162
        -- upvalues: n2 (ref), ScrollingFrame (copy)
        ScrollingFrame.Position = UDim2.fromOffset(n2, 0)
    end)
    ScrollingFrame.Size = UDim2.new(1, -24, 1, 0)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.Visible = true
    ScrollingFrame.ZIndex = 1
    ScrollingFrame.Active = false
    ScrollingFrame.ClipsDescendants = true
    ScrollingFrame.HorizontalScrollBarInset = Enum.ScrollBarInset.None
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 1, -1)
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
    ScrollingFrame.ScrollBarThickness = 0
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Selectable = false
    ScrollingFrame.ScrollingEnabled = false
    ScrollingFrame.ElasticBehavior = Enum.ElasticBehavior.Never
    ScrollingFrame.Parent = Frame

    local UIListLayout = Instance.new("UIListLayout")

    v2:Connect(function() -- line: 183
        -- upvalues: n2 (ref), UIListLayout (copy)
        UIListLayout.Padding = UDim.new(0, n2)
    end)
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    UIListLayout.Parent = ScrollingFrame

    local clone4 = ScrollingFrame:Clone()

    v2:Connect(function() -- line: 193
        -- upvalues: n2 (ref), clone4 (copy)
        clone4.UIListLayout.Padding = UDim.new(0, n2)
    end)
    clone4.ScrollingEnabled = false
    clone4.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    clone4.Name = "Center"
    clone4.Parent = Holders

    local clone5 = ScrollingFrame:Clone()

    v2:Connect(function() -- line: 202
        -- upvalues: n2 (ref), clone5 (copy)
        clone5.UIListLayout.Padding = UDim.new(0, n2)
    end)
    clone5.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    clone5.Name = "Right"
    clone5.AnchorPoint = Vector2.new(1, 0)
    clone5.Position = UDim2.new(1, -12, 0, 0)
    clone5.Parent = Frame
    v2:Fire(v3)

    return t1
end
