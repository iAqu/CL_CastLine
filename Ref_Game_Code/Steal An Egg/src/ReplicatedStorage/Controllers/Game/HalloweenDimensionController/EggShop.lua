-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = require(ReplicatedStorage.Data.Assets)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local GUI = require(ReplicatedStorage.Client.GUI)
local HalloweenDimension = require(ReplicatedStorage.Shared.Util.HalloweenDimension)
local HalloweenDimensionEgg = require(ReplicatedStorage.Data.HalloweenDimensionEgg)
local Numbers = require(ReplicatedStorage.Shared.Utils.Numbers)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)

require(ReplicatedStorage.Packages.Trove)

local v1 = Color3.fromRGB(255, 64, 64)
local v2 = Color3.fromRGB(80, 255, 120)
local v3 = false
local t1 = {}

local function formatChance(p1) -- line: 35
    if p1 >= 1 then
        return (`{ math.round(p1 * 10) / 10 }%`)
    end

    return (("%*%%"):format((tonumber(string.format("%.3g", p1)))))
end

local function populate(p2) -- line: 42
    -- upvalues: Assets (copy), HalloweenDimensionEgg (copy), Numbers (copy)
    local HalloweenEgg = p2.Content.Cards.HalloweenEgg
    local Entries = HalloweenDimensionEgg.Entries

    for v5, v6 in Entries do
        local v7 = HalloweenEgg.ItemChances:FindFirstChild((tostring(v5)))

        assert(v7 ~= nil, (("ItemChances has no slot %*"):format(v5)))
        v7.Icon.Image = Assets.Directory[v6.AssetId].Icon

        local Amount = v7.Amount
        local v10 = HalloweenDimensionEgg.Chance(v6)

        if v10 >= 1 then
            Amount.Text = `{ math.round(v10 * 10) / 10 }%`
        else
            Amount.Text = ("%*%%"):format((tonumber(string.format("%.3g", v10))))
        end
    end

    assert(HalloweenEgg.ItemChances:FindFirstChild((tostring(#Entries + 1))) == nil, "ItemChances has more slots than the egg has pets")
    HalloweenEgg.EggName.Text = string.upper(HalloweenDimensionEgg.DisplayName)
    p2.Content.Btns.Buy.PriceHolder.Price.Text = Numbers.AddCommas(HalloweenDimensionEgg.Price)
end

local function refreshTokens(p3) -- line: 59
    -- upvalues: Numbers (copy), Save (copy)
    local v14 = Save.Peek()

    p3.Text = Numbers.AddCommas(if v14 == nil then 0 else v14.HalloweenTokens)
end

local function buy() -- line: 64
    -- upvalues: HalloweenDimensionEgg (copy), Remotes (copy), Toast (copy), v1 (copy), v2 (copy), v3 (ref)
    if v3 then
        return
    end

    v3 = true

    local function v15() -- line: 69
        -- upvalues: Remotes (copy)
        return Remotes.HalloweenDimension.AskBuyEgg:InvokeServer()
    end

    local v16, v17, v18 = pcall(v15)

    v3 = false

    local v19 = v16 and v17 == true
    local Show = Toast.Show
    local t2 = {
        Seconds = 2.5,
        SingleLine = true
    }

    if v19 then
        v18 = ("Purchased a %*!"):format(HalloweenDimensionEgg.DisplayName)
    else
        local v20 = if v16 then typeof(v18) == "string" else nil

        if not v16 or not v20 then
            v18 = "Something went wrong, please try again."
        end
    end

    t2.Text = v18
    t2.Color = if v19 then v2 else v1
    Show(t2)
end

function t1.Start(p4) -- line: 89
    -- upvalues: ProximityPromptService (copy), ButtonFX (copy), GUI (copy), HalloweenDimension (copy), Numbers (copy), Save (copy), Tabs (copy), populate (copy), buy (copy)
    local Main = GUI.Get("HalloweenDimensionEggUI").Main
    local QuantityLabel = Main.CurrencyHolder.QuantityLabel

    populate(Main)

    local v21 = Save.Peek()

    QuantityLabel.Text = Numbers.AddCommas(if v21 == nil then 0 else v21.HalloweenTokens)
    p4:Add(ButtonFX(Main.Content.Btns.Buy, 1.08, function() -- line: 95
        -- upvalues: buy (copy)
        task.spawn(buy)
    end))
    p4:Add(Save.WatchFields("HalloweenTokens", function() -- line: 98
        -- upvalues: QuantityLabel (copy), Numbers (copy), Save (copy)
        local v23 = Save.Peek()

        QuantityLabel.Text = Numbers.AddCommas(if v23 == nil then 0 else v23.HalloweenTokens)
    end))
    p4:Connect(Tabs.Activated, function(p5) -- line: 101
        -- upvalues: QuantityLabel (copy), Numbers (copy), Save (copy)
        if p5 ~= "HalloweenDimensionEggUI" then
            return
        end

        local v25 = Save.Peek()

        QuantityLabel.Text = Numbers.AddCommas(if v25 == nil then 0 else v25.HalloweenTokens)
    end)
    p4:Connect(ProximityPromptService.PromptTriggered, function(p6) -- line: 106
        -- upvalues: HalloweenDimension (copy), Tabs (copy)
        if p6:HasTag(HalloweenDimension.EggShopTag) then
            Tabs.Activate("HalloweenDimensionEggUI")
        end
    end)
end

return table.freeze(t1)
