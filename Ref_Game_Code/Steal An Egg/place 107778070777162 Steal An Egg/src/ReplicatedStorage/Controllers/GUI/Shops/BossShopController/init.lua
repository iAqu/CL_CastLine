-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local BossMastery = require(ReplicatedStorage.Data.BossMastery)
local BossMasteryFlags = require(ReplicatedStorage.Shared.Flags.BossMasteryFlags)
local BossShopProductCard = require(script.BossShopProductCard)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local GUI = require(ReplicatedStorage.Client.GUI)
local GamepadBindings = require(ReplicatedStorage.Client.GamepadBindings)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local Numbers = require(ReplicatedStorage.Shared.Utils.Numbers)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v2 = Color3.fromRGB(255, 64, 64)
local v3 = Color3.fromRGB(80, 255, 120)

return {
    Start = function() -- Start | line: 29
        -- upvalues: TweenService (copy), BossMastery (copy), BossMasteryFlags (copy), BossShopProductCard (copy), ButtonFX (copy), Simple (copy), GUI (copy), GamepadBindings (copy), Toast (copy), Numbers (copy), Remotes (copy), Save (copy), Tabs (copy), Trove (copy), v1 (copy), v2 (copy), v3 (copy)
        local Main = GUI.BossShop().Main
        local Main2 = Main.Main
        local ScrollingFrame = Main2.ScrollingFrame
        local BossShopItemTemplate = ScrollingFrame.BossShopItemTemplate
        local Amount = Main2.Header.CurrencyHolder.Amount
        local Close = Main2.Close
        local BossMasteryButton = Main.BossMasteryButton
        local GamepadGlyph = BossMasteryButton.GamepadGlyph
        local v4 = Trove.new()
        local v5 = Trove.new()
        local v6 = Trove.new()
        local t2 = {}
        local BossTokens, NumberValue
        local v7 = false

        v4:Add(v5)
        v4:Add(v6)
        v4:Add(ButtonFX(Close, 1.08, function() -- line: 49
            -- upvalues: Tabs (copy)
            Tabs.Deactivate()
        end))
        GamepadGlyph:SetAttribute("GamepadKey", "ButtonX")
        GamepadBindings.Inspect(GamepadGlyph)
        v4:Add(ButtonFX(BossMasteryButton, 1.08, function() -- line: 54
            -- upvalues: Tabs (copy)
            Tabs.Activate("BossMastery")
        end))

        local function formatTokens(p1) -- line: 58
            -- upvalues: Simple (copy), Numbers (copy)
            if math.abs(p1) > 99999 then
                return Simple.FormatCompact(math.round(p1), ".#")
            end

            return Numbers.AddCommas((math.round(p1)))
        end

        local function setTokenText(p2) -- line: 65
            -- upvalues: Amount (copy), Simple (copy), Numbers (copy)
            Amount.Text = if math.abs(p2) > 99999 then Simple.FormatCompact(math.round(p2), ".#") else Numbers.AddCommas((math.round(p2)))
        end

        local function refreshTokenBalance(p3) -- line: 69
            -- upvalues: Amount (copy), v5 (copy), BossTokens (ref), NumberValue (ref), setTokenText (copy), TweenService (copy), Simple (copy), Numbers (copy), Save (copy), v1 (copy)
            local v9 = Save.Await()

            if v9 == nil then
                return
            end

            local BossTokens2 = v9.BossTokens
            local v10 = if NumberValue then NumberValue.Value else BossTokens

            BossTokens = BossTokens2
            v5:Clean()
            NumberValue = nil

            if not (p3 or v10 == nil or v10 == BossTokens2) then
                local NumberValue2 = Instance.new("NumberValue")

                NumberValue2.Value = v10
                NumberValue = NumberValue2
                v5:Add(NumberValue2)
                v5:Connect(NumberValue2.Changed, setTokenText)
                Amount.Text = if math.abs(v10) > 99999 then Simple.FormatCompact(math.round(v10), ".#") else Numbers.AddCommas((math.round(v10)))

                local tween = TweenService:Create(NumberValue2, v1, {
                    Value = BossTokens2
                })

                v5:Add(tween)
                tween:Play()
            else
                Amount.Text = if math.abs(BossTokens2) > 99999 then Simple.FormatCompact(math.round(BossTokens2), ".#") else Numbers.AddCommas((math.round(BossTokens2)))
            end
        end

        local function refreshCards() -- line: 99
            -- upvalues: t2 (copy)
            for _, v13 in t2 do
                v13.Refresh()
            end
        end

        local function setCardsPending(p4) -- line: 105
            -- upvalues: t2 (copy), v7 (ref)
            v7 = p4

            for _, v14 in t2 do
                v14.SetPending(p4)
            end
        end

        local function showResult(p5, p6, p7) -- line: 112
            -- upvalues: BossMastery (copy), Toast (copy), v2 (copy), v3 (copy)
            local Show = Toast.Show
            local t3 = {
                Seconds = 2.5,
                SingleLine = true
            }

            if p6 then
                t3.Text = ("Purchased %*!"):format((BossMastery.GetShopDisplayName(p5)))
                t3.Color = v3
            else
                t3.Text = p7 or "Purchase failed"
                t3.Color = v2
            end

            t3.Image = p5.Icon
            Show(t3)
        end

        local function requestPurchase(p8, _) -- line: 128
            -- upvalues: t2 (copy), v7 (ref), showResult (copy), Toast (copy), Remotes (copy), v2 (copy)
            if v7 then
                return
            end

            v7 = true

            for _, v15 in t2 do
                v15.SetPending(true)
            end

            local function v16() -- line: 136
                -- upvalues: p8 (copy), Remotes (copy)
                return Remotes.BossMastery.AskBuyShopItem:InvokeServer(p8.Id)
            end

            local v17, v18, v19 = pcall(v16)

            v7 = false

            for _, v20 in t2 do
                v20.SetPending(false)
            end

            if v17 then
                showResult(p8, v18, v19)
            else
                Toast.Show({
                    Text = "Something went wrong, please try again.",
                    Seconds = 2.5,
                    SingleLine = true,
                    Color = v2,
                    Image = p8.Icon
                })
            end
        end

        local function rebuildCards() -- line: 149
            -- upvalues: ScrollingFrame (copy), BossShopItemTemplate (copy), v6 (copy), t2 (copy), v7 (ref), requestPurchase (copy), BossMastery (copy), BossShopProductCard (copy)
            v6:Clean()
            table.clear(t2)

            for v21, v22 in BossMastery.GetShopProducts() do
                local v23 = BossShopProductCard.New(BossShopItemTemplate, ScrollingFrame, v22, v21, requestPurchase)

                t2[v22.Id] = v23
                v6:Add(v23.Destroy)
                v23.SetPending(v7)
            end
        end

        BossShopItemTemplate.Visible = false
        rebuildCards()
        Save.Await()

        local v24 = Save.Await()

        if v24 ~= nil then
            local BossTokens2 = v24.BossTokens

            if NumberValue then
                local _ = NumberValue.Value
            end

            BossTokens = BossTokens2
            v5:Clean()
            NumberValue = nil
            Amount.Text = if math.abs(BossTokens2) > 99999 then Simple.FormatCompact(math.round(BossTokens2), ".#") else Numbers.AddCommas((math.round(BossTokens2)))
        end

        v4:Add(Save.WatchFields("BossTokens", function() -- line: 172
            -- upvalues: refreshTokenBalance (copy)
            refreshTokenBalance()
        end))
        v4:Add(BossMasteryFlags.ShopPriceOverrides.Changed:Connect(refreshCards))
        v4:Add(BossMasteryFlags.ShopProductIds.Changed:Connect(rebuildCards))
        v4:Add(BossMasteryFlags.CashBoosterDurationSeconds.Changed:Connect(refreshCards))
        v4:Add(BossMasteryFlags.SpeedBoostDurationSeconds.Changed:Connect(refreshCards))
        v4:Add(BossMasteryFlags.TreadmillBoostDurationSeconds.Changed:Connect(refreshCards))
        v4:Add(BossMasteryFlags.MutationConsumableSuccessPercent.Changed:Connect(refreshCards))
        v4:Add(BossMasteryFlags.CashBoosterMultiplier.Changed:Connect(refreshCards))
        v4:Add(BossMasteryFlags.TreadmillBoostMultiplier.Changed:Connect(refreshCards))
        v4:Add(BossMasteryFlags.SpeedBoostMultiplier.Changed:Connect(refreshCards))
        v4:Add(Tabs.Activated:Connect(function(p10) -- line: 200
            -- upvalues: Amount (copy), v5 (copy), t2 (copy), BossTokens (ref), NumberValue (ref), Simple (copy), Numbers (copy), Save (copy)
            if p10 ~= "BossShop" then
                return
            end

            local v26 = Save.Await()

            if v26 ~= nil then
                local BossTokens2 = v26.BossTokens

                if NumberValue then
                    local _ = NumberValue.Value
                end

                BossTokens = BossTokens2
                v5:Clean()
                NumberValue = nil
                Amount.Text = if math.abs(BossTokens2) > 99999 then Simple.FormatCompact(math.round(BossTokens2), ".#") else Numbers.AddCommas((math.round(BossTokens2)))
            end

            for _, v28 in t2 do
                v28.Refresh()
            end
        end))

        return v4
    end
}
