-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BossMastery = require(ReplicatedStorage.Data.BossMastery)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local t1 = {
    New = function(p1, p2, p3, p4, p5) -- New | line: 17
        -- upvalues: BossMastery (copy), ButtonFX (copy), Simple (copy)
        local clone = p1:Clone()

        clone.Name = p3.Id
        clone.LayoutOrder = p4
        clone.Visible = true
        clone.Parent = p2

        local Frame = clone.Frame
        local EggName, OutputEgg = Frame.EggName, Frame.OutputEgg
        local QuantityLabel = Frame.Quantity.QuantityLabel
        local Buy = Frame.Buy
        local Price = Buy.PriceHolder.Price
        local v1 = false

        OutputEgg.Image = p3.Icon

        local t2

        local function refresh() -- line: 45
            -- upvalues: p3 (copy), EggName (copy), QuantityLabel (copy), Price (copy), BossMastery (copy), Simple (copy)
            EggName.Text = BossMastery.GetShopDisplayName(p3)
            Price.Text = Simple.FormatCompact(BossMastery.GetShopPrice(p3), ".#")
            QuantityLabel.Text = BossMastery.GetShopQuantityText(p3)
        end

        local function setPending(p6) -- line: 54
            -- upvalues: Buy (copy), v1 (ref)
            v1 = p6
            Buy.Active = not p6
            Buy.Interactable = not p6
            Buy.AutoButtonColor = not p6
        end

        local v2 = ButtonFX(Buy, 1.05, function() -- line: 61
            -- upvalues: p3 (copy), p5 (copy), v1 (ref), t2 (ref)
            if not v1 then
                p5(p3, t2)
            end
        end)

        t2 = {
            Refresh = refresh,
            SetPending = setPending,
            Destroy = function() -- Destroy | line: 70
                -- upvalues: clone (copy), v2 (copy)
                v2()
                clone:Destroy()
            end
        }
        EggName.Text = BossMastery.GetShopDisplayName(p3)
        Price.Text = Simple.FormatCompact(BossMastery.GetShopPrice(p3), ".#")
        QuantityLabel.Text = BossMastery.GetShopQuantityText(p3)

        return t2
    end
}

return table.freeze(t1)
