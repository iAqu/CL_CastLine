-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local CashPacks = require(ReplicatedStorage.Data.CashPacks)
local Message = require(ReplicatedStorage.Client.Message)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local GUI = require(ReplicatedStorage.Client.GUI)
local Gamepasses = require(ReplicatedStorage.Data.Gamepasses)
local Gamepasses2 = require(ReplicatedStorage.Client.Gamepasses)
local Gifting = require(ReplicatedStorage.Client.Gifting)
local Price = require(ReplicatedStorage.Shared.Utils.Marketplace).Price
local Hud = require(ReplicatedStorage.Client.Hud)
local Products = require(ReplicatedStorage.Data.Products)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local ShopNavigation = require(ReplicatedStorage.Client.ShopNavigation)
local Storefront = require(ReplicatedStorage.Client.Functions.Storefront)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local TryLock = require(ReplicatedStorage.Shared.Utils.TryLock)
local t = require(ReplicatedStorage.Packages.t)
local t1 = {
    Owned = "OWNED",
    Pending = "Loading..."
}

return {
    Start = function() -- Start | line: 54
        -- upvalues: Players (copy), ButtonFX (copy), CashPacks (copy), Message (copy), Simple (copy), GUI (copy), Gamepasses (copy), Gamepasses2 (copy), Gifting (copy), Price (copy), Hud (copy), Products (copy), Remotes (copy), Save (copy), ShopNavigation (copy), Storefront (copy), Tabs (copy), TryLock (copy), t (copy), t1 (copy)
        local LocalPlayer = Players.LocalPlayer
        local ScrollingFrame = GUI.Shop().Frame.ScrollingFrame
        local Money, Passes = ScrollingFrame.Money, ScrollingFrame.Passes
        local v1 = TryLock()

        local function mapProductEntry(p1, p2) -- line: 69
            -- upvalues: t (copy)
            t.strict(t.table)(p2)
            t.strict(t.number)(p2.ProductId)

            local Buy = p1.Btns.Buy
            local Price = Buy.Price

            assert(Buy and Buy:IsA("GuiButton"), "Expected Btns.Buy to be a GuiButton")
            assert(Price and Price:IsA("TextLabel"), "Expected Buy.Price to be a TextLabel")

            return {
                frame = p1,
                button = Buy,
                priceLabel = Price,
                productId = p2.ProductId,
                giftButton = p1.Btns.Gift
            }
        end

        local t3 = {
            mapProductEntry(Money.c1, Products.Directory.CashPack1),
            mapProductEntry(Money.c2, Products.Directory.CashPack2),
            mapProductEntry(Money.c3, Products.Directory.CashPack3),
            mapProductEntry(Money.c4, Products.Directory.CashPack4),
            (mapProductEntry(Money.c5, Products.Directory.CashPack5))
        }

        local function mapGamepassEntry(p3, p4) -- line: 105
            -- upvalues: t (copy)
            local Buy = p3.Btns.Buy
            local Price = Buy.Price

            assert(p3 and p3:IsA("GuiObject"), "Expected a pass card GuiObject")
            assert(Price and Price:IsA("TextLabel"), "Expected card.Btns.Buy.Price to be a TextLabel")
            t.strict(t.table)(p4)
            t.strict(t.string)(p4.Name)
            t.strict(t.number)(p4.ProductId)

            return {
                card = p3,
                button = Buy,
                giftButton = p3.Btns.Gift,
                priceLabel = Price,
                gamepassId = p4.Name,
                productId = p4.ProductId
            }
        end

        local t4 = {
            mapGamepassEntry(Passes.Money, Gamepasses.Directory.X2Money),
            (mapGamepassEntry(Passes.Growth, Gamepasses.Directory.X2Growth))
        }

        local function ownsProduct(p5) -- line: 143
            -- upvalues: Save (copy)
            local v6 = Save.Await()
            local Products = if v6 == nil then nil else v6.Products

            return Products ~= nil and Products[tostring(p5)] == true
        end

        local function renderPrice(p6, p7, p8, p9) -- line: 149
            -- upvalues: Price (copy)
            local v7 = Price(p7, p8)

            if v7 ~= nil then
                if p9() then
                    p6.Text = "OWNED"
                else
                    p6.Text = "" .. tostring(v7)
                end
            else
                p6.Text = "Loading..."
            end
        end

        local function updateGamepassPrice(p10) -- line: 165
            -- upvalues: Gamepasses2 (copy), Price (copy), t1 (copy)
            local priceLabel = p10.priceLabel
            local v8 = Price(p10.productId, Enum.InfoType.GamePass)
            local Pending = t1.Pending

            if v8 ~= nil then
                Pending = if Gamepasses2.Owns(p10.gamepassId) then t1.Owned else "" .. tostring(v8)
            end

            priceLabel.Text = Pending
        end

        local function updatePrice(p11) -- line: 176
            -- upvalues: LocalPlayer (copy), CashPacks (copy), Simple (copy), Price (copy), Save (copy), t1 (copy)
            local v9 = CashPacks.FindSlot(p11.productId)
            local Title, v10

            if v9 then
                local v11 = CashPacks.GetShownAmount(LocalPlayer, v9)

                Title = p11.frame:FindFirstChild("Title")

                if Title and Title:IsA("TextLabel") then
                    v10 = if v11 then "$" .. Simple.FormatCompact(v11, ".#") else "Loading..."
                    Title.Text = v10
                end
            end

            local priceLabel = p11.priceLabel
            local v12 = Price(p11.productId, Enum.InfoType.Product)
            local Pending = t1.Pending

            if v12 ~= nil then
                local productId = p11.productId
                local v13 = Save.Await()
                local Products = if v13 == nil then nil else v13.Products

                if Products ~= nil and Products[tostring(productId)] == true then
                    priceLabel.Text = t1.Owned
                else
                    priceLabel.Text = "" .. tostring(v12)
                end
            else
                priceLabel.Text = Pending
            end
        end

        local function bindBuyButton(p12, p13, p14, p15) -- line: 197
            -- upvalues: v1 (copy), ButtonFX (copy), Message (copy), Storefront (copy)
            ButtonFX(p12, nil, function() -- line: 203
                -- upvalues: p13 (copy), p14 (copy), p15 (copy), v1 (copy), Message (copy), Storefront (copy)
                v1(function() -- line: 204
                    -- upvalues: p13 (copy), p14 (copy), p15 (copy), Message (copy), Storefront (copy)
                    if p15 == nil or not p15() then
                        Storefront.Prompt(p13, p14)
                    else
                        Message.Notice("You already own this item!")
                    end
                end)
            end)
        end

        local function updateAllProducts() -- line: 214
            -- upvalues: t3 (copy), updatePrice (copy)
            for _, v14 in t3 do
                task.spawn(updatePrice, v14)
            end
        end

        local function updateAllGamepasses() -- line: 220
            -- upvalues: t4 (copy), updateGamepassPrice (copy)
            for _, v15 in t4 do
                task.spawn(updateGamepassPrice, v15)
            end
        end

        for _, v16 in t3 do
            Gifting.Bind(v16.giftButton, "Product", v16.productId)
            task.spawn(function() -- line: 228
                -- upvalues: v1 (copy), updatePrice (copy), v16 (copy), ButtonFX (copy), Message (copy), Save (copy), Storefront (copy)
                updatePrice(v16)

                local button, productId = v16.button, v16.productId

                local function v17() -- line: 230
                    -- upvalues: v16 (copy), Save (copy)
                    local productId = v16.productId
                    local v18 = Save.Await()
                    local Products = if v18 == nil then nil else v18.Products

                    return Products ~= nil and Products[tostring(productId)] == true
                end

                local v19 = true

                ButtonFX(button, nil, function() -- line: 203
                    -- upvalues: productId (copy), v17 (copy), v19 (copy), v1 (copy), Message (copy), Storefront (copy)
                    v1(function() -- line: 204
                        -- upvalues: productId (copy), v17 (copy), v19 (copy), Message (copy), Storefront (copy)
                        if v17 == nil or not v17() then
                            Storefront.Prompt(productId, v19)
                        else
                            Message.Notice("You already own this item!")
                        end
                    end)
                end)
            end)
        end

        for _, v20 in t4 do
            Gifting.Bind(v20.giftButton, "Gamepass", v20.productId)
            task.spawn(function() -- line: 238
                -- upvalues: v1 (copy), v20 (copy), ButtonFX (copy), Message (copy), Gamepasses2 (copy), Price (copy), Storefront (copy), t1 (copy)
                local priceLabel = v20.priceLabel
                local v21 = Price(v20.productId, Enum.InfoType.GamePass)
                local Pending = t1.Pending

                if v21 ~= nil then
                    Pending = if Gamepasses2.Owns(v20.gamepassId) then t1.Owned else "" .. tostring(v21)
                end

                priceLabel.Text = Pending

                local button, productId2 = v20.button, v20.productId
                local v22
                local v23 = false

                ButtonFX(button, nil, function() -- line: 203
                    -- upvalues: productId2 (copy), v22 (copy), v23 (copy), v1 (copy), Message (copy), Storefront (copy)
                    v1(function() -- line: 204
                        -- upvalues: productId2 (copy), v22 (copy), v23 (copy), Message (copy), Storefront (copy)
                        if v22 == nil or not v22() then
                            Storefront.Prompt(productId2, v23)
                        else
                            Message.Notice("You already own this item!")
                        end
                    end)
                end)
            end)
        end

        for _, v24 in Hud.Every("ShopButton") do
            ButtonFX(v24, 1.08, function() -- line: 245
                -- upvalues: ShopNavigation (copy), Tabs (copy)
                if Tabs.IsActive("Shop") then
                    Tabs.Deactivate()
                else
                    ShopNavigation.Open("Featured")
                end
            end)
        end

        Tabs.Activated:Connect(function(p16) -- line: 254
            -- upvalues: t3 (copy), t4 (copy), updateGamepassPrice (copy), updatePrice (copy)
            if p16 ~= "Shop" then
                return
            end

            for _, v25 in t3 do
                task.spawn(updatePrice, v25)
            end

            for _, v26 in t4 do
                task.spawn(updateGamepassPrice, v26)
            end
        end)

        if Save.IsLoaded() then
            task.spawn(function() -- line: 262
                -- upvalues: t3 (copy), t4 (copy), updateGamepassPrice (copy), updatePrice (copy)
                for _, v27 in t3 do
                    task.spawn(updatePrice, v27)
                end

                for _, v28 in t4 do
                    task.spawn(updateGamepassPrice, v28)
                end
            end)
        end

        Save.Loaded:Connect(function(p17) -- line: 268
            -- upvalues: LocalPlayer (copy), t3 (copy), updatePrice (copy)
            if p17 ~= LocalPlayer then
                return
            end

            for _, v29 in t3 do
                task.spawn(updatePrice, v29)
            end
        end)
        LocalPlayer:GetAttributeChangedSignal(CashPacks.RevisionAttribute):Connect(updateAllProducts)
        Save.WatchFields("Products", updateAllProducts)
        Save.WatchFields("Gamepasses", updateAllGamepasses)
        Remotes.PassGrants.Awarded.OnClientEvent:Connect(updateAllGamepasses)
    end
}
