-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CashPacks = require(ReplicatedStorage.Data.CashPacks)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local GUI = require(ReplicatedStorage.Client.GUI)
local MonetizationEntitlements = require(ReplicatedStorage.Shared.Util.MonetizationEntitlements)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local Products = require(ReplicatedStorage.Data.Products)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Storefront = require(ReplicatedStorage.Client.Functions.Storefront)
local Trails = require(ReplicatedStorage.Data.Trails)
local TreadmillUtil = require(ReplicatedStorage.Shared.Util.TreadmillUtil)
local v1 = Color3.fromRGB(9, 255, 0)

return {
    Start = function() -- Start | line: 49
        -- upvalues: Players (copy), CashPacks (copy), ButtonFX (copy), Simple (copy), GUI (copy), MonetizationEntitlements (copy), Toast (copy), Products (copy), Remotes (copy), Save (copy), Storefront (copy), Trails (copy), TreadmillUtil (copy), v1 (copy)
        local ScrollingFrame = GUI.TrailShop().Frame.ScrollingFrame
        local UIListLayout = ScrollingFrame:FindFirstChildOfClass("UIListLayout")

        assert(UIListLayout ~= nil, "TrailShop.Frame.ScrollingFrame needs a UIListLayout")

        local Frame = Instance.new("Frame")

        Frame.Name = "TrailingGap"
        Frame.BackgroundTransparency = 1
        Frame.BorderSizePixel = 0
        Frame.LayoutOrder = 1E+06
        Frame.Size = UDim2.new()
        Frame.Parent = ScrollingFrame

        local t2 = {}
        local t3 = {}
        local t4 = {}

        local function refreshTrailingGap() -- line: 80
            -- upvalues: ScrollingFrame (copy), UIListLayout (copy), Frame (copy)
            local Padding = UIListLayout.Padding
            local v3 = Padding.Scale * ScrollingFrame.AbsoluteSize.X + Padding.Offset

            Frame.Size = UDim2.fromOffset(math.ceil(v3), 0)
        end

        local function refreshEntry(p1, p2) -- line: 86
            -- upvalues: Players (copy), CashPacks (copy), Simple (copy), Products (copy), Save (copy), Trails (copy)
            local v4 = Save.Await()

            assert(v4 ~= nil, "Expected local save data")

            local v6 = v4.TrailInventory[p2] == true
            local v7 = v4.EquippedTrail == p2

            p1.LockedControls.Visible = not v6
            p1.OwnedControls.Visible = v6
            p1.OwnedControls.Equip.Visible = v6 and not v7
            p1.OwnedControls.Unequip.Visible = v6 and v7

            if v6 then
                return
            end

            p1.LockedControls.BuyCash.Price.Text = ("$%*"):format((Simple.FormatCompact(Trails.Directory[p2].Price, ".#")))

            local ProductId = Trails.Directory[p2].ProductId
            local BuyRbx = p1.LockedControls.BuyRbx

            if ProductId == nil or Products.FromProductId(ProductId) == nil then
                BuyRbx.Visible = false
            else
                BuyRbx.Visible = CashPacks.GetCanBuyProduct(CashPacks.GetPlayerGroup(Players.LocalPlayer), "Trail_" .. p2)
            end
        end

        local function showFailure(p3) -- line: 113
            -- upvalues: Toast (copy)
            Toast.Show({
                Seconds = 3,
                Text = p3,
                Color = Color3.fromRGB(255, 64, 64)
            })
        end

        local function requestPurchase(p4, p5) -- line: 121
            -- upvalues: refreshEntry (copy), Toast (copy), Remotes (copy)
            local v8, v9 = Remotes.Trailwear.AskPurchase:InvokeServer(p4)

            if not v8 then
                local v10 = v9 or "Trail request failed"

                Toast.Show({
                    Seconds = 3,
                    Text = v10,
                    Color = Color3.fromRGB(255, 64, 64)
                })
            end

            refreshEntry(p5, p4)
        end

        local function requestWear(p6, p7, p8) -- line: 129
            -- upvalues: refreshEntry (copy), Toast (copy), Remotes (copy)
            local v11, v12

            if p8 then
                v11, v12 = Remotes.Trailwear.AskChoose:InvokeServer(p6)
            else
                v11, v12 = Remotes.Trailwear.AskDoff:InvokeServer()
            end

            if not v11 then
                local v13 = v12 or "Trail request failed"

                Toast.Show({
                    Seconds = 3,
                    Text = v13,
                    Color = Color3.fromRGB(255, 64, 64)
                })
            end

            refreshEntry(p7, p6)
        end

        local function bindShopEntry(p9, p10) -- line: 147
            -- upvalues: ScrollingFrame (copy), t2 (copy), t3 (copy), refreshEntry (copy), ButtonFX (copy), Simple (copy), MonetizationEntitlements (copy), Toast (copy), Products (copy), Remotes (copy), Storefront (copy), Trails (copy), TreadmillUtil (copy), v1 (copy)
            local v14 = Trails.Directory[p9]
            local v15 = ScrollingFrame:FindFirstChild(p9)

            assert(v15 ~= nil and v15:IsA("ImageLabel"), (("TrailShop has no card for \"%*\""):format(p9)))
            v15.LayoutOrder = p10
            v15.TrailName.Text = v14.DisplayName
            v15.TrailRarity.Text = v14.Rarity.DisplayName
            v15.Icon.Image = v14.Icon
            v15.Multi.Value.RichText = true
            v15.Multi.Value.Text = ("<font color=\"#%*\">%*</font> <font color=\"#FFFFFF\">Speed</font>"):format(v1:ToHex(), (TreadmillUtil.FormatSpeedMultiplierValue(v14.SpeedMultiplier)))
            t2[p9] = {
                RobuxPrice = nil,
                Card = v15
            }
            ButtonFX(v15.LockedControls.BuyCash, 1.05, function() -- line: 167
                -- upvalues: p9 (copy), v15 (copy), refreshEntry (copy), Toast (copy), Remotes (copy)
                local v18, v19 = Remotes.Trailwear.AskPurchase:InvokeServer(p9)

                if not v18 then
                    local v20 = v19 or "Trail request failed"

                    Toast.Show({
                        Seconds = 3,
                        Text = v20,
                        Color = Color3.fromRGB(255, 64, 64)
                    })
                end

                refreshEntry(v15, p9)
            end)
            ButtonFX(v15.OwnedControls.Equip, 1.05, function() -- line: 170
                -- upvalues: p9 (copy), v15 (copy), refreshEntry (copy), Toast (copy), Remotes (copy)
                local v21, v22 = Remotes.Trailwear.AskChoose:InvokeServer(p9)

                if not v21 then
                    local v23 = v22 or "Trail request failed"

                    Toast.Show({
                        Seconds = 3,
                        Text = v23,
                        Color = Color3.fromRGB(255, 64, 64)
                    })
                end

                refreshEntry(v15, p9)
            end)
            ButtonFX(v15.OwnedControls.Unequip, 1.05, function() -- line: 173
                -- upvalues: p9 (copy), v15 (copy), refreshEntry (copy), Toast (copy), Remotes (copy)
                local v24, v25 = Remotes.Trailwear.AskDoff:InvokeServer()

                if not v24 then
                    local v26 = v25 or "Trail request failed"

                    Toast.Show({
                        Seconds = 3,
                        Text = v26,
                        Color = Color3.fromRGB(255, 64, 64)
                    })
                end

                refreshEntry(v15, p9)
            end)
            ButtonFX(v15.LockedControls.BuyRbx, 1.05, function() -- line: 176
                -- upvalues: v14 (copy), Toast (copy), Products (copy), Storefront (copy)
                local ProductId = v14.ProductId

                if ProductId == nil or Products.FromProductId(ProductId) == nil then
                    Toast.Show({
                        Text = "This trail Robux product is not configured yet",
                        Seconds = 3,
                        Color = Color3.fromRGB(255, 64, 64)
                    })
                else
                    Storefront.Prompt(ProductId, true)
                end
            end)

            if v14.ProductId ~= nil and Products.FromProductId(v14.ProductId) ~= nil then
                v15.LockedControls.BuyRbx.Price.Text = ""

                if not t3[v14.ProductId] then
                    t3[v14.ProductId] = true
                    task.spawn(function() -- line: 191
                        -- upvalues: p9 (copy), v14 (copy), v15 (copy), t2 (copy), Simple (copy), MonetizationEntitlements (copy)
                        local v27 = MonetizationEntitlements.ProductPrice(v14.ProductId)
                        local v28 = t2[p9]

                        if v28 ~= nil and v27 > 0 then
                            v28.RobuxPrice = v27
                            v15.LockedControls.BuyRbx.Price.Text = Simple.FormatCompact(v27, ".#")
                        end
                    end)
                end
            end

            refreshEntry(v15, p9)
        end

        Save.Await()

        local t5 = {}

        for v29, v30 in pairs(Trails.Directory) do
            if v30.DisplayInShop then
                t5[#t5 + 1] = v29
            end
        end

        table.sort(t5, function(p11, p12) -- line: 219
            -- upvalues: Trails (copy)
            return Trails.Directory[p11].Price < Trails.Directory[p12].Price
        end)

        for v31, v32 in ipairs(t5) do
            bindShopEntry(v32, v31)
        end

        ScrollingFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(refreshTrailingGap)

        local Padding = UIListLayout.Padding
        local v33 = Padding.Scale * ScrollingFrame.AbsoluteSize.X + Padding.Offset

        Frame.Size = UDim2.fromOffset(math.ceil(v33), 0)
        Save.WatchFields({
            "TrailInventory",
            "EquippedTrail"
        }, function() -- line: 230
            -- upvalues: t2 (copy), refreshEntry (copy), t5 (copy)
            for _, v34 in ipairs(t5) do
                local v35 = t2[v34]

                assert(v35 ~= nil, (("Missing trail shop entry \"%*\""):format(v34)))
                refreshEntry(v35.Card, v34)
            end
        end)
        Players.LocalPlayer:GetAttributeChangedSignal(CashPacks.RevisionAttribute):Connect(function() -- line: 240
            -- upvalues: t2 (copy), refreshEntry (copy)
            for v38, v39 in t2 do
                refreshEntry(v39.Card, v38)
            end
        end)

        return t4
    end
}
