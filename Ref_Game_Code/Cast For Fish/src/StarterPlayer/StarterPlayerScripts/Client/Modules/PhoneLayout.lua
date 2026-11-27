-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local t1 = {}

t1.__index = t1
t1.MIN_PX = 18
t1.DESIGN_TEXT = 22
t1.GAP = 14
t1.INDEX_COLUMNS = 3
t1.CARD_W = 200
t1.CARD_H = 220
t1.ZONE_TILE_W = 170
t1.ZONE_TILE_H = 290
t1.HEADER_GAP = 8
t1.ZONE_GAP = 22

function t1.IsPhone() -- line: 18
    -- upvalues: UserInputService (copy)
    return UserInputService.TouchEnabled and (not UserInputService.KeyboardEnabled or UserInputService:GetLastInputType() == Enum.UserInputType.Touch)
end

function t1.new(p1) -- line: 22
    -- upvalues: t1 (copy)
    local self = setmetatable({}, t1)

    self.Windows = p1
    self.Applied = {}

    return self
end

function t1.Fit(_, p3) -- line: 29
    local ScreenGui = p3.Frame:FindFirstAncestorOfClass("ScreenGui")
    local FitScale = ScreenGui and ScreenGui:FindFirstChild("FitScale")

    if not FitScale then
        return 1
    end

    return (math.max(FitScale.Scale, 0.05))
end

function t1:Zoom(p5, p6) -- line: 35
    return (math.clamp(self.MIN_PX / (self.DESIGN_TEXT * self:Fit(p5)), 1, p6))
end

function t1.ContentWidth(_, p8) -- line: 39
    return p8.Frame.Size.X.Offset + p8.Content.Size.X.Offset
end

function t1.Holder(p9, p10, p11) -- line: 43
    local Frame = Instance.new("Frame")

    Frame.Name = p9
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "PhoneScale"
    UIScale.Scale = p11
    UIScale.Parent = Frame
    Frame.Parent = p10

    return Frame, UIScale
end

function t1:Wrap(p13, p14, p15, p16) -- line: 56
    -- upvalues: t1 (copy)
    local Offset = self.Size.X.Offset
    local Offset2 = self.Size.Y.Offset
    local v3 = t1.Holder(self.Name .. "Phone", p13, p14)

    v3.Size = UDim2.fromOffset(Offset, Offset2)
    v3.Position = UDim2.fromOffset(p15, p16)
    v3.ZIndex = self.ZIndex
    self.Parent = v3
    self.Position = UDim2.fromOffset(Offset * self.AnchorPoint.X, Offset2 * self.AnchorPoint.Y)

    return v3
end

function t1:WrapWide(p18, p19, p20, p21) -- line: 67
    -- upvalues: t1 (copy)
    local v4 = t1.Holder(self.Name .. "Phone", p18, p19)

    v4.Size = UDim2.new(1 / p19, 0, 0, p20)
    v4.Position = UDim2.fromOffset(0, p21 or 0)
    v4.LayoutOrder = self.LayoutOrder
    v4.ZIndex = self.ZIndex
    self.Parent = v4
    self.AnchorPoint = Vector2.zero
    self.Position = UDim2.new()
    self.Size = UDim2.fromScale(1, 1)

    return v4
end

function t1:Taller(p23, p24) -- line: 80
    if not self or not self:IsA("GuiObject") then
        return
    end

    self.Size = UDim2.new(self.Size.X.Scale, self.Size.X.Offset, self.Size.Y.Scale, p23)

    if p24 then
        for _, descendant in ipairs(self:GetDescendants()) do
            if descendant:IsA("UITextSizeConstraint") then
                descendant.MaxTextSize = math.max(descendant.MaxTextSize, p24)
            end
        end

        local UITextSizeConstraint = self:FindFirstChildOfClass("UITextSizeConstraint")

        if UITextSizeConstraint then
            UITextSizeConstraint.MaxTextSize = math.max(UITextSizeConstraint.MaxTextSize, p24)
        end
    end
end

function t1.Scroll(p25, p26) -- line: 98
    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Name = "PhoneScroll"
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Position = UDim2.fromOffset(0, p26)
    ScrollingFrame.Size = UDim2.new(1, 0, 1, -p26)
    ScrollingFrame.ScrollBarThickness = 10
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ScrollingFrame.CanvasSize = UDim2.new()
    ScrollingFrame.ZIndex = 11
    ScrollingFrame.Parent = p25

    return ScrollingFrame
end

function t1:Index() -- line: 113
    -- upvalues: t1 (copy)
    local Index = self.Windows.Index
    local Content = Index.Content
    local v5 = self:Zoom(Index, 2.5)
    local Summary = Content:FindFirstChild("Summary")
    local Zones = Content:FindFirstChild("Zones")

    if Summary and Zones then
        local Total = Summary:FindFirstChild("Total")

        if Total then
            Total.Size = UDim2.new(1, -142, 0, 44)
        end

        local Percent = Summary:FindFirstChild("Percent")

        if Percent then
            Percent.AnchorPoint = Vector2.zero
            Percent.Position = UDim2.fromOffset(128, 100)
            t1.Taller(Percent:FindFirstChild("Caption"), 28)
        end

        local Variants = Summary:FindFirstChild("Variants")

        if Variants then
            Variants.AnchorPoint = Vector2.zero
            Variants.Position = UDim2.fromOffset(290, 100)
            t1.Taller(Variants:FindFirstChild("Caption"), 28)
        end

        local v6 = t1.WrapWide(Summary, Zones, v5, 184, 0)

        v6.Size = UDim2.new(1 / v5, -16 / v5, 0, 184)
        v6.LayoutOrder = -1
        Zones.Position = UDim2.new()
        Zones.Size = UDim2.fromScale(1, 1)

        local UIListLayout = Zones:FindFirstChildOfClass("UIListLayout")

        if UIListLayout then
            UIListLayout.Padding = UDim.new(0, (math.floor(self.ZONE_GAP * v5)))
        end

        for _, child in ipairs(Zones:GetChildren()) do
            local v8 = child:IsA("Frame") and child:FindFirstChild("ZoneTile")

            if v8 then
                local t3 = {}

                for _, child in ipairs(child:GetChildren()) do
                    if child:IsA("GuiObject") and child ~= v8 then
                        table.insert(t3, child)
                    end
                end

                table.sort(t3, function(p28, p29) -- line: 157
                    if p28.Position.Y.Offset == p29.Position.Y.Offset then
                        return p28.Position.X.Offset < p29.Position.X.Offset
                    end

                    return p28.Position.Y.Offset < p29.Position.Y.Offset
                end)

                local Tag = v8:FindFirstChild("Tag")

                t1.Taller(Tag, 36)

                for _, v9 in ipairs(t3) do
                    self:CompactCard(v9)
                end

                local INDEX_COLUMNS = self.INDEX_COLUMNS
                local v11 = math.min(v5, (child.Size.X.Offset - INDEX_COLUMNS * self.GAP - 16) / (self.ZONE_TILE_W + INDEX_COLUMNS * self.CARD_W))
                local v12 = self.ZONE_TILE_W * v11 + self.GAP
                local v13 = self.CARD_H * v11
                local n1 = 0

                for v14, v15 in ipairs(t3) do
                    local v16 = (v14 - 1) % INDEX_COLUMNS
                    local v18 = math.floor((v14 - 1) / INDEX_COLUMNS) * (v13 + self.GAP)

                    t1.Wrap(v15, child, v11, v12 + v16 * (self.CARD_W * v11 + self.GAP), v18)
                    n1 = math.max(n1, v18 + v13)
                end

                local v21 = math.max(n1, self.ZONE_TILE_H * v11)

                self:ReshapeTile(v8, self.ZONE_TILE_W, self.ZONE_TILE_H)
                t1.Wrap(v8, child, v11, 0, 0)
                child.Size = UDim2.fromOffset(child.Size.X.Offset, v21)
            end
        end
    end
end

function t1:CompactCard(p31) -- line: 188
    -- upvalues: t1 (copy)
    p31.Size = UDim2.fromOffset(self.CARD_W, self.CARD_H)

    local FishName = p31:FindFirstChild("FishName")

    if FishName then
        FishName.Size = UDim2.new(1, -16, 0, 46)
        FishName.Position = UDim2.fromOffset(8, 12)
        t1.Taller(FishName, 46, 46)
    end

    local Picture = p31:FindFirstChild("Picture")

    if Picture then
        Picture.Size = UDim2.new(1, -24, 0, 84)
        Picture.Position = UDim2.new(0.5, 0, 0, 104)
    end

    local Glow = p31:FindFirstChild("Glow")

    if Glow then
        Glow.Size = UDim2.fromOffset(self.CARD_H * 0.8, self.CARD_H * 0.8)
        Glow.Position = UDim2.new(0.5, 0, 0, 104)
    end

    local Variants = p31:FindFirstChild("Variants")

    if Variants then
        Variants.Position = UDim2.new(0, 0, 0, 148)
    end

    local Info = p31:FindFirstChild("Info")

    t1.Taller(Info, 46, 46)

    if Info then
        local TextLabel = Info:FindFirstChildWhichIsA("TextLabel")

        if TextLabel then
            TextLabel.Size = UDim2.new(TextLabel.Size.X.Scale, TextLabel.Size.X.Offset, 1, -4)
            TextLabel.Position = UDim2.new(TextLabel.Position.X.Scale, TextLabel.Position.X.Offset, 0, 2)
        end
    end
end

function t1.ReshapeTile(_, p33, p34, p35) -- line: 222
    p33.Size = UDim2.fromOffset(p34, p35)

    local Name = p33:FindFirstChild("Name")

    if Name then
        Name.Size = UDim2.new(1, -12, 0, 80)
        Name.Position = UDim2.fromOffset(6, 46)
    end

    local Art = p33:FindFirstChild("Art")

    if not (Art and Art:IsA("GuiObject")) then
        return
    end

    local v22 = p35 - 60

    Art.Size = UDim2.new(1, -8, 0, (math.clamp(v22 - 128, 40, 260)))
    Art.Position = UDim2.new(0.5, 0, 0, (v22 + 128) / 2)
end

function t1:Gifts() -- line: 237
    -- upvalues: t1 (copy)
    local Gifts = self.Windows.Gifts
    local Content = Gifts.Content
    local v24 = self:ContentWidth(Gifts)
    local t4 = {}

    for _, child in ipairs(Content:GetChildren()) do
        if child:IsA("GuiButton") and string.match(child.Name, "^Gift%d+$") then
            table.insert(t4, child)
        end
    end

    if #t4 == 0 then
        return
    end

    table.sort(t4, function(p37, p38) -- line: 250
        return tonumber(string.match(p37.Name, "%d+")) < tonumber(string.match(p38.Name, "%d+"))
    end)

    local Offset = t4[1].Size.X.Offset
    local Offset2 = t4[1].Size.Y.Offset
    local v26 = (v24 - self.GAP - 24) / (2 * Offset)
    local Sub = Content:FindFirstChild("Sub")

    if Sub then
        Sub.TextWrapped = true
        t1.WrapWide(Sub, Content, v26, 84, 0)
    end

    local PlayedPill = Content:FindFirstChild("PlayedPill")
    local v27 = 84 * v26 + 4

    for _, v28 in ipairs(t4) do
        t1.Taller(v28:FindFirstChild("Prize"), t4[1]:FindFirstChild("Prize").Size.Y.Offset, 60)
    end

    if PlayedPill then
        local v29 = t1.Holder("PlayedPillPhone", Content, v26)

        v29.Size = UDim2.new(1 / v26, 0, 0, 40)
        v29.Position = UDim2.fromOffset(0, v27)
        PlayedPill.Parent = v29
        PlayedPill.Position = UDim2.new(0.5, 0, 0, 2)
        v27 += 40 * v26 + 8
    end

    local v30 = t1.Scroll(Content, v27)
    local v31 = Offset * v26
    local v32 = (v24 - 12 - 2 * v31 - self.GAP) / 2
    local n2 = 0

    for v33, v34 in ipairs(t4) do
        local v35 = (v33 - 1) % 2

        t1.Wrap(v34, v30, v26, v32 + v35 * (v31 + self.GAP), n2)

        if v35 == 1 or v33 == #t4 then
            n2 += Offset2 * v26 + self.GAP
        end
    end

    v30.CanvasSize = UDim2.fromOffset(0, n2)
end

function t1:Rebirth() -- line: 287
    -- upvalues: t1 (copy)
    local Rebirth = self.Windows.Rebirth
    local Content = Rebirth.Content
    local v36 = self:ContentWidth(Rebirth)
    local Need = Content:FindFirstChild("Need")
    local Right = Content:FindFirstChild("Right")
    local Go = Content:FindFirstChild("Go")

    if not (Need and Right) then
        return
    end

    local v37 = (v36 - 12 - self.GAP) / 930
    local v38 = t1.Scroll(Content, 0)
    local Offset = Need.Size.X.Offset
    local Offset2 = Need.Size.Y.Offset

    t1.Wrap(Need, v38, v37, (470 - Offset) / 2 * v37, 0)

    local v39 = 0 + (Offset2 * v37 + self.GAP)
    local Lose = Right:FindFirstChild("Lose")
    local Keep = Right:FindFirstChild("Keep")

    if Lose and Keep then
        local Offset = Lose.Size.Y.Offset

        Lose.Size = UDim2.new(1, 0, 0, Offset)
        Keep.Size = UDim2.new(1, 0, 0, Offset)
        Keep.Position = UDim2.new(0, 0, 0, Lose.Position.Y.Offset + Offset + 8)
        Right.Size = UDim2.new(Right.Size.X.Scale, Right.Size.X.Offset, 0, Right.Size.Y.Offset + Offset + 8)
    end

    local Offset3 = Right.Size.Y.Offset
    local v40 = t1.WrapWide(Right, v38, v37, Offset3, 0)

    v40.Size = UDim2.new(0, 460, 0, Offset3)
    v40.Position = UDim2.fromOffset(470 * v37 + self.GAP, 0)

    if Go then
        Go.AnchorPoint = Vector2.zero

        local Offset = Go.Size.X.Offset
        local Offset2 = Go.Size.Y.Offset

        t1.Wrap(Go, v38, v37, (470 - Offset) / 2 * v37, v39)
        v39 += Offset2 * v37 + self.GAP
    end

    t1.Taller(Content:FindFirstChild("PipsLabel"), 40)

    local v41 = t1.Holder("PipsPhone", v38, v37)

    v41.Size = UDim2.fromOffset(470, 132)
    v41.Position = UDim2.fromOffset(0, v39)

    for _, child in ipairs(Content:GetChildren()) do
        if child:IsA("GuiObject") and (string.match(child.Name, "^Pip%d+$") or child.Name == "PipsLabel") then
            child.Parent = v41
            child.Position = UDim2.fromOffset(child.Position.X.Offset, child.Position.Y.Offset - 484)
        end
    end

    local v42 = v39 + 132 * v37

    v38.CanvasSize = UDim2.fromOffset(0, math.max(v42, Offset3 * v37) + self.GAP)
end

function t1:IndexRewards() -- line: 336
    -- upvalues: t1 (copy)
    local IndexRewards = self.Windows.IndexRewards
    local Content = IndexRewards.Content
    local v44 = self:Zoom(IndexRewards, 2.5)
    local Summary = Content:FindFirstChild("Summary")
    local List = Content:FindFirstChild("List")

    if Summary and List then
        local Found = Summary:FindFirstChild("Found")

        if Found then
            Found.Size = UDim2.new(1, -20, 0, 46)
            Found.Position = UDim2.fromOffset(20, 0)
        end

        local Luck = Summary:FindFirstChild("Luck")

        if Luck then
            Luck.Size = UDim2.new(1, -20, 0, 46)
            Luck.Position = UDim2.fromOffset(20, 46)
        end

        local Back = Summary:FindFirstChild("Back")

        if Back then
            Back.Position = UDim2.new(1, -16, 0, 130)
        end

        local v45 = t1.WrapWide(Summary, List, v44, 168, 0)

        v45.Size = UDim2.new(1 / v44, -18 / v44, 0, 168)
        v45.LayoutOrder = -1
        List.Position = UDim2.new()
        List.Size = UDim2.fromScale(1, 1)

        for _, child in ipairs(List:GetChildren()) do
            if child:IsA("Frame") and string.match(child.Name, "^Reward%d+$") then
                local Offset = child.Size.Y.Offset

                for _, v46 in ipairs({ "Prize", "LuckLine", "Bar" }) do
                    local v47 = child:FindFirstChild(v46)

                    if v47 then
                        v47.Size = UDim2.new(1, -126, v47.Size.Y.Scale, v47.Size.Y.Offset)
                    end
                end

                local At = child:FindFirstChild("At")
                local Caption = At and At:FindFirstChild("Caption")

                if Caption then
                    Caption.Size = UDim2.new(1, 0, 0, 26)
                    Caption.AnchorPoint = Vector2.new(0, 1)
                    Caption.Position = UDim2.new(0, 0, 1, -2)
                end

                local Claim = child:FindFirstChild("Claim")

                if Claim then
                    Claim.AnchorPoint = Vector2.new(1, 0)
                    Claim.Position = UDim2.new(1, -14, 0, Offset)
                    Offset += Claim.Size.Y.Offset + 12
                end

                t1.WrapWide(child, List, v44, Offset).Size = UDim2.new(1 / v44, -18 / v44, 0, Offset)
            end
        end
    end
end

function t1:Readable(p42, p43) -- line: 393
    local v48 = self:Zoom(p42, p43)

    for _, descendant in ipairs(p42.Content:GetDescendants()) do
        if descendant:IsA("TextLabel") and not descendant.TextScaled then
            local v49 = descendant:FindFirstChildOfClass("UITextSizeConstraint") or Instance.new("UITextSizeConstraint")

            v49.MaxTextSize = math.floor(descendant.TextSize * v48)
            v49.Parent = descendant
            descendant.TextWrapped = true
            descendant.TextScaled = true
        end
    end
end

function t1:Trade() -- line: 406
    self:Readable(self.Windows.Trade, 1.6)
end

function t1:TradePlayers() -- line: 410
    -- upvalues: t1 (copy)
    local TradePlayers = self.Windows.TradePlayers
    local Hint = TradePlayers.Content:FindFirstChild("Hint")
    local List = TradePlayers.Content:FindFirstChild("List")

    if Hint and List then
        t1.Taller(Hint, 60)
        List.Position = UDim2.new(List.Position.X.Scale, List.Position.X.Offset, 0, 68)
        List.Size = UDim2.new(List.Size.X.Scale, List.Size.X.Offset, 1, -70)
    end

    self:Readable(TradePlayers, 1.6)
end

function t1:HeaderButtons(p47) -- line: 422
    local t5 = {}

    for _, child in ipairs(p47.Frame:GetChildren()) do
        if child:IsA("GuiButton") then
            table.insert(t5, child)
            child.Size = UDim2.new(child.Size.X.Scale, math.floor(child.Size.X.Offset * 1.25), child.Size.Y.Scale, (math.floor(child.Size.Y.Offset * 1.25)))

            local Badge = child:FindFirstChild("Badge")

            if Badge and Badge:IsA("GuiObject") then
                Badge.Size = UDim2.new(Badge.Size.X.Scale, math.floor(Badge.Size.X.Offset * 1.3), Badge.Size.Y.Scale, (math.floor(Badge.Size.Y.Offset * 1.3)))
            end
        end
    end

    if #t5 > 1 then
        task.spawn(self.SpreadButtons, self, p47, t5)
    end
end

function t1:SpreadButtons(p49, p50) -- line: 439
    -- upvalues: RunService (copy)
    while p49.Frame.AbsoluteSize.X <= 1 do
        RunService.RenderStepped:Wait()
    end

    RunService.RenderStepped:Wait()

    local v57 = p49.Frame.AbsoluteSize.X / math.max(p49.Frame.Size.X.Offset, 1)

    table.sort(p50, function(p51, p52) -- line: 445
        return p51.AbsolutePosition.X > p52.AbsolutePosition.X
    end)

    local v58 = p50[1].AbsolutePosition.X

    for i = 2, #p50 do
        local v59 = p50[i]
        local v60 = v59.AbsolutePosition.X + v59.AbsoluteSize.X - (v58 - self.HEADER_GAP * v57)

        if v60 > 0 then
            local v62 = math.ceil(v60 / v57)

            v59.Position = UDim2.new(v59.Position.X.Scale, v59.Position.X.Offset - v62, v59.Position.Y.Scale, v59.Position.Y.Offset)
        end

        v58 = math.min(v58, v59.AbsolutePosition.X - math.max(v60, 0))
    end
end

function t1:Apply(p54) -- line: 461
    -- upvalues: t1 (copy)
    if p54 or t1.IsPhone() then
        for _, v64 in ipairs({ "Index", "Gifts", "Rebirth", "IndexRewards", "Trade", "TradePlayers" }) do
            if not self.Applied[v64] and self.Windows[v64] then
                self.Applied[v64] = true

                local v65 = self[v64]
                local ok, result = pcall(v65, self)

                if ok then
                    local HeaderButtons = self.HeaderButtons
                    local v66 = self.Windows[v64]

                    ok, result = pcall(HeaderButtons, self, v66)
                end

                if not ok then
                    warn("[PhoneLayout] " .. v64 .. ": " .. tostring(result))
                end
            end
        end

        return true
    end

    return false
end

return t1
