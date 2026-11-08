-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GUI = require(ReplicatedStorage.Client.GUI)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local Trove = require(ReplicatedStorage.Packages.Trove)
local AddCommas = require(ReplicatedStorage.Shared.Utils.Numbers).AddCommas
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local t1 = {}

local function toast(p1) -- line: 14
    -- upvalues: Toast (copy)
    Toast.Show({
        Seconds = 3,
        SingleLine = true,
        Unique = true,
        Text = p1
    })
end

function t1.new(p2) -- line: 17
    -- upvalues: GUI (copy), Tabs (copy), ButtonFX (copy), Trove (copy), AddCommas (copy), Toast (copy)
    local t2 = {}
    local v1 = Trove.new()
    local v2 = Trove.new()

    v1:Add(v2)

    local DrScrambleEvent = GUI.Get("DrScrambleEvent")
    local DRScrambleEventUIMain = DrScrambleEvent.DRScrambleEventUIMain
    local ScrollingFrame = DRScrambleEventUIMain.ContentFrame.ScrollingFrame
    local ShopItem = ScrollingFrame:WaitForChild("ShopItem")
    local ShopItem_Rare = ScrollingFrame:WaitForChild("ShopItem_Rare")
    local ShopItemLeavesTimer = ScrollingFrame:WaitForChild("ShopItemLeavesTimer")
    local CurrencyHolder = DRScrambleEventUIMain.CurrencyHolder
    local BuyMore = CurrencyHolder:FindFirstChild("BuyMore")

    if BuyMore then
        BuyMore:Destroy()
    end

    local t3 = {}
    local v3
    local v4 = ""
    local v5 = true
    local v6 = false
    local v7 = false
    local v8

    for _, child in ScrollingFrame:GetChildren() do
        if child:IsA("GuiObject") then
            child.Visible = false
        end
    end

    DrScrambleEvent:SetAttribute("ImmediateClose", true)
    DrScrambleEvent.Enabled = false

    local function available() -- line: 42
        -- upvalues: v3 (ref)
        if v3 ~= nil and v3.Ready == true and v3.Enabled == true and v3.WorldReady == true then
            return workspace:GetServerTimeNow() < (v3.EventEndsAt or 0)
        end

        return false
    end

    local function purchased(p3) -- line: 49
        -- upvalues: v3 (ref)
        local State

        if not v3 or workspace:GetServerTimeNow() >= (v3.ShopRestockAt or 0) then
            return 0
        else
            State = v3.State and (v3.State.ShopPurchases or {})[p3.Id]
        end

        if not State or State.Period ~= v3.ShopPeriod then
            return 0
        end

        return State.Count
    end

    local function send(p4, p5, p6) -- line: 54
        -- upvalues: p2 (copy), v3 (ref), v5 (ref), v6 (ref), v8 (ref), Toast (copy)
        if v6
            or v3 == nil
            or v3.Ready ~= true
            or v3.Enabled ~= true
            or v3.WorldReady ~= true
            or not (workspace:GetServerTimeNow() < (v3.EventEndsAt or 0)) then
            return
        end

        v6 = true
        v8()

        local ok, result = pcall(p2, p4, p5, p6)

        v6 = false

        if v5 then
            v8()

            if ok and result then
                if not result.Ok and (result.Reason == "Busy" or result.Reason == "ProfileUnavailable") then
                    Toast.Show({
                        Text = "Please wait a moment and try again.",
                        Seconds = 3,
                        SingleLine = true,
                        Unique = true
                    })
                end
            else
                Toast.Show({
                    Text = "Could not confirm the request. Reopen the shop to refresh.",
                    Seconds = 3,
                    SingleLine = true,
                    Unique = true
                })
            end
        end
    end

    local function clearCards() -- line: 72
        -- upvalues: v2 (copy), t3 (copy)
        v2:Clean()
        table.clear(t3)
    end

    local function v10() -- line: 76
        -- upvalues: v2 (copy), ScrollingFrame (copy), ShopItem (copy), ShopItem_Rare (copy), ShopItemLeavesTimer (copy), CurrencyHolder (copy), t3 (copy), v3 (ref), v4 (ref), v6 (ref), purchased (copy), send (copy), ButtonFX (copy), AddCommas (copy), Toast (copy)
        local v11 = v3.Shop or {}
        local t5 = {
            "Shop"
        }

        for _, v12 in v11 do
            table.insert(t5, v12.Quote .. ":" .. tostring(v12.LeavesAtEventEnd))
        end

        local v14 = table.concat(t5, "\n")

        if v14 == v4 then
            return
        end

        v4 = v14
        v2:Clean()
        table.clear(t3)

        for v15, v16 in v11 do
            local clone = (if v16.Rare then ShopItem_Rare elseif v16.LeavesAtEventEnd then ShopItemLeavesTimer else ShopItem):Clone()

            clone.Name = "Offer_" .. v16.Id
            clone.LayoutOrder = v15

            local Card = clone.Card
            local ImageButton = Instance.new("ImageButton")

            for _, v17 in {
                    "Name",
                    "AnchorPoint",
                    "Position",
                    "Size",
                    "Rotation",
                    "BackgroundColor3",
                    "BackgroundTransparency",
                    "BorderColor3",
                    "BorderSizePixel",
                    "BorderMode",
                    "ClipsDescendants",
                    "LayoutOrder",
                    "ZIndex",
                    "Visible",
                    "SizeConstraint",
                    "AutomaticSize"
                } do
                ImageButton[v17] = Card[v17]
            end

            ImageButton.ImageTransparency = 1
            ImageButton.AutoButtonColor = false
            ImageButton.Selectable = false

            for _, child in Card:GetChildren() do
                child.Parent = ImageButton
            end

            Card:Destroy()
            ImageButton.Parent = clone
            ImageButton.EggName.Text = v16.Label
            ImageButton.EggName.RichText = false

            local v18 = ImageButton:FindFirstChild("ItemIcon") or ImageButton:FindFirstChild("OutputEgg")

            assert(v18 and v18:IsA("ImageLabel"), "Scramble shop card requires ItemIcon or OutputEgg")
            v18.Image = v16.Icon
            ImageButton.Quantity.QuantityLabel.Text = v16.QuantityText or "x" .. AddCommas(v16.Quantity)
            ImageButton.Buy.PriceHolder.Icon.Visible = true
            ImageButton.Buy.PriceHolder.Icon:RemoveTag("ICON")
            ImageButton.Buy.PriceHolder.Icon:SetAttribute("IconId", nil)
            ImageButton.Buy.PriceHolder.Icon.Image = CurrencyHolder.CurrencyIcon.Image
            ImageButton.SoldOut.Visible = false
            ImageButton.Buy.Visible = true
            clone.Visible = true
            clone.Parent = ScrollingFrame
            v2:Add(clone)

            local v20 = clone:FindFirstChild("LeaveTimer", true)

            if v16.LeavesAtEventEnd then
                assert(v20 and v20:IsA("TextLabel"), "Limited Scramble shop card requires LeaveTimer")
            end

            table.insert(t3, {
                Offer = v16,
                Card = ImageButton,
                LeaveTimer = if not (v20 and v20:IsA("TextLabel")) then nil else v20
            })
            v2:Add(ButtonFX(ImageButton, 1.04, nil, true))
            v2:Add(ButtonFX(ImageButton.Buy, nil, function() -- line: 132
                -- upvalues: v16 (copy), ImageButton (copy), v3 (ref), v6 (ref), purchased (copy), send (copy), Toast (copy)
                if ImageButton.Buy.Interactable and not v6 and v3 ~= nil and v3.Ready == true and v3.Enabled == true and v3.WorldReady == true and workspace:GetServerTimeNow() < (v3.EventEndsAt or 0) then
                    if v16.PurchaseLimit and purchased(v16) + v16.Quantity > v16.PurchaseLimit then
                        Toast.Show({
                            Text = "Sold out for today. Check the restock timer!",
                            Seconds = 3,
                            SingleLine = true,
                            Unique = true
                        })
                    elseif not v3.State or v3.State.Samples < v16.Price then
                        Toast.Show({
                            Text = "Not enough Samples. Defeat Dr. Scramble to earn more.",
                            Seconds = 3,
                            SingleLine = true,
                            Unique = true
                        })
                    else
                        send("Shop", v16.Id, {
                            Quote = v16.Quote,
                            Sequence = v3.State.ShopSequence
                        })
                    end
                end
            end))
        end
    end

    local function resize() -- line: 148
        -- upvalues: DRScrambleEventUIMain (copy)
        local CurrentCamera = workspace.CurrentCamera

        if not CurrentCamera then
            return
        end

        local ViewportSize = CurrentCamera.ViewportSize
        local AspectRatio = DRScrambleEventUIMain.UIAspectRatioConstraint.AspectRatio
        local v25 = math.min(ViewportSize.X * 0.6, ViewportSize.Y * 0.74 * AspectRatio)

        DRScrambleEventUIMain.UISizeConstraint.MinSize = Vector2.zero
        DRScrambleEventUIMain.Size = UDim2.fromOffset(v25, v25 / AspectRatio)
    end

    v8 = function() -- line: 159
        -- upvalues: CurrencyHolder (copy), t3 (copy), v3 (ref), v5 (ref), v6 (ref), v7 (ref), purchased (copy), v10 (copy), AddCommas (copy)
        if not v5 then
            return
        end

        if not (v3 and v3.State) then
            CurrencyHolder.QuantityLabel.Text = "0"
        else
            CurrencyHolder.QuantityLabel.Text = AddCommas(v3.State.Samples)
        end

        local v28 = math.max(0, (math.floor((v3 and v3.EventEndsAt or 0) - workspace:GetServerTimeNow()))) // 3600
        local v29 = string.format("LEAVES IN: %dD %dHR", v28 // 24, v28 % 24)

        if v7 and v3 then
            v10()

            for _, v30 in t3 do
                local Offer, Card = v30.Offer, v30.Card

                if v30.LeaveTimer then
                    v30.LeaveTimer.Text = v29
                end

                local v31 = purchased(Offer)
                local v32 = Offer.PurchaseLimit ~= nil and v31 + Offer.Quantity > Offer.PurchaseLimit

                Card.SoldOut.Visible = v32
                Card.Buy.Visible = not v32

                if Offer.PurchaseLimit then
                    Card.Quantity.QuantityLabel.Text = tostring((math.max(0, Offer.PurchaseLimit - v31))) .. "/" .. Offer.PurchaseLimit .. " LEFT"
                end

                local StocksInLabel = Card:FindFirstChild("StocksInLabel")

                if StocksInLabel and StocksInLabel:IsA("TextLabel") then
                    if Offer.PurchaseLimit ~= nil then
                        StocksInLabel.Visible = v31 > 0
                    else
                        StocksInLabel.Visible = false
                    end

                    if StocksInLabel.Visible then
                        local v37 = math.max(1, (math.ceil(((v3.ShopRestockAt or 0) - workspace:GetServerTimeNow()) / 60)))

                        StocksInLabel.Text = string.format("Stocks In:\n%dhr %dm", v37 // 60, v37 % 60)
                    end
                end

                local v38 = v3 ~= nil and v3.Ready == true and v3.Enabled == true and v3.WorldReady == true and workspace:GetServerTimeNow() < (v3.EventEndsAt or 0) and not v6 and v3.State ~= nil and not v32
                local v39 = v38 and v3.State.Samples >= Offer.Price

                Card.Buy.PriceHolder.Price.Text = AddCommas(Offer.Price)
                Card.Active = v38
                Card.Interactable = v38

                local Buy, Buy2, Buy3 = Card.Buy, Card.Buy, Card.Buy

                Buy.Active = v38
                Buy2.Interactable = v38
                Buy3.Selectable = v38

                local Buy4 = Card.Buy

                if v39 then
                    Buy4.ImageColor3 = Color3.new(1, 1, 1)
                else
                    Buy4.ImageColor3 = Color3.fromRGB(140, 140, 140)
                end

                local Price = Card.Buy.PriceHolder.Price

                if v39 then
                    Price.TextColor3 = Color3.new(1, 1, 1)
                else
                    Price.TextColor3 = Color3.fromRGB(255, 64, 64)
                end
            end
        end
    end

    v1:Add(DrScrambleEvent:GetAttributeChangedSignal("Open"):Connect(function() -- line: 207
        -- upvalues: DrScrambleEvent (copy), Tabs (copy)
        if DrScrambleEvent:GetAttribute("Open") == false and Tabs.IsActive("DrScrambleEvent") then
            Tabs.Deactivate()
        end
    end))
    v1:Add(Tabs.Activated:Connect(function(p7) -- line: 212
        -- upvalues: DRScrambleEventUIMain (copy), v8 (ref)
        if p7 ~= "DrScrambleEvent" then
            return
        end

        local CurrentCamera = workspace.CurrentCamera

        if CurrentCamera then
            local ViewportSize = CurrentCamera.ViewportSize
            local AspectRatio = DRScrambleEventUIMain.UIAspectRatioConstraint.AspectRatio
            local v42 = math.min(ViewportSize.X * 0.6, ViewportSize.Y * 0.74 * AspectRatio)

            DRScrambleEventUIMain.UISizeConstraint.MinSize = Vector2.zero
            DRScrambleEventUIMain.Size = UDim2.fromOffset(v42, v42 / AspectRatio)
        end

        v8()
    end))

    if ScrollingFrame:IsA("ScrollingFrame") then
        local UIGridLayout = ScrollingFrame.UIGridLayout

        local function canvas() -- line: 220
            -- upvalues: ScrollingFrame (copy), UIGridLayout (copy)
            ScrollingFrame.CanvasSize = UDim2.fromOffset(0, UIGridLayout.AbsoluteContentSize.Y)
        end

        v1:Add(UIGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(canvas))
        ScrollingFrame.CanvasSize = UDim2.fromOffset(0, UIGridLayout.AbsoluteContentSize.Y)
    end

    if workspace.CurrentCamera then
        v1:Add(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resize))
    end

    local CurrentCamera = workspace.CurrentCamera

    if CurrentCamera then
        local ViewportSize = CurrentCamera.ViewportSize
        local AspectRatio = DRScrambleEventUIMain.UIAspectRatioConstraint.AspectRatio
        local v45 = math.min(ViewportSize.X * 0.6, ViewportSize.Y * 0.74 * AspectRatio)

        DRScrambleEventUIMain.UISizeConstraint.MinSize = Vector2.zero
        DRScrambleEventUIMain.Size = UDim2.fromOffset(v45, v45 / AspectRatio)
    end

    function t2.Update(p8) -- line: 230
        -- upvalues: t2 (copy), v3 (ref), v8 (ref)
        v3 = p8

        if v3 == nil or v3.Ready ~= true or v3.Enabled ~= true or v3.WorldReady ~= true or not (workspace:GetServerTimeNow() < (v3.EventEndsAt or 0)) then
            t2.Close()
        end

        v8()
    end

    function t2.Show() -- line: 237
        -- upvalues: ScrollingFrame (copy), t3 (copy), v3 (ref), v7 (ref), v8 (ref), Tabs (copy), Toast (copy)
        if v3 == nil or v3.Ready ~= true or v3.Enabled ~= true or v3.WorldReady ~= true or not (workspace:GetServerTimeNow() < (v3.EventEndsAt or 0)) then
            return
        end

        v7 = true
        v8()

        if #t3 == 0 then
            Toast.Show({
                Text = "The Sample shop has no available offers yet.",
                Seconds = 3,
                SingleLine = true,
                Unique = true
            })
        else
            if ScrollingFrame:IsA("ScrollingFrame") then
                ScrollingFrame.CanvasPosition = Vector2.zero
            end

            Tabs.Activate("DrScrambleEvent")
        end
    end

    function t2.Close() -- line: 252
        -- upvalues: Tabs (copy)
        if Tabs.IsActive("DrScrambleEvent") then
            Tabs.Deactivate()
        end
    end

    local n1 = -1

    function t2.Tick(p9) -- line: 258
        -- upvalues: t2 (copy), v3 (ref), v8 (ref), n1 (ref), Tabs (copy)
        if Tabs.IsActive("DrScrambleEvent") then
            if v3 == nil or v3.Ready ~= true or v3.Enabled ~= true or v3.WorldReady ~= true or not (workspace:GetServerTimeNow() < (v3.EventEndsAt or 0)) then
                t2.Close()
            elseif math.floor(p9) ~= n1 then
                n1 = math.floor(p9)
                v8()
            end
        end
    end

    function t2.Destroy() -- line: 267
        -- upvalues: v1 (copy), v5 (ref)
        v5 = false
        v1:Destroy()
    end

    return t2
end

return t1
