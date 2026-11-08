-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CashPacks = require(ReplicatedStorage.Data.CashPacks)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local GUI = require(ReplicatedStorage.Client.GUI)

require(ReplicatedStorage.Client.Types.GUI)
require(ReplicatedStorage.Shared.Modules.ProfileDefaults.Types.Interface)

local Price = require(ReplicatedStorage.Shared.Utils.Marketplace).Price
local Products = require(ReplicatedStorage.Data.Products)
local Save = require(ReplicatedStorage.Shared.Save)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Client = require(script.Parent.Parent.TreadmillUpgradeController.Client)
local Treadmills = require(ReplicatedStorage.Data.Treadmills)
local v1 = ColorSequence.new(Color3.fromRGB(214, 17, 17), Color3.fromRGB(253, 20, 20))
local v2 = Color3.fromRGB(72, 0, 0)
local v3 = Color3.fromRGB(255, 103, 103)

return {
    Start = function() -- Start | line: 39
        -- upvalues: Players (copy), CashPacks (copy), ButtonFX (copy), Constants (copy), Simple (copy), GUI (copy), Price (copy), Products (copy), Save (copy), Tabs (copy), Client (copy), Treadmills (copy), v1 (copy), v2 (copy), v3 (copy)
        local UpgradeTreadmil = GUI.Shop().Frame.ScrollingFrame.UpgradeTreadmil
        local Spacer = UpgradeTreadmil.Spacer
        local Btns = Spacer.Btns
        local Cash, Robux = Btns.Cash, Btns.Robux
        local UIGradient = Cash:FindFirstChildOfClass("UIGradient")
        local UIStroke = Cash:FindFirstChild("UIStroke")
        local UIStrokeClr = Cash:FindFirstChild("UIStrokeClr")
        local Color = if UIGradient == nil then nil else UIGradient.Color
        local Color2 = if UIStroke == nil then nil else UIStroke.Color
        local Color3 = if UIStrokeClr == nil then nil else UIStrokeClr.Color
        local n1 = 0

        local function getLoadedData() -- line: 70
            -- upvalues: Save (copy)
            local v4 = Save.Await()

            assert(v4 ~= nil, "Treadmill speed shop requires loaded player data")

            return v4
        end

        local function updateRobuxUpgradePrice(p1, p2) -- line: 76
            -- upvalues: Robux (copy), n1 (ref), Constants (copy), Simple (copy), Price (copy)
            Robux.Price.Text = Constants.ROBUX_ICON_STR
            task.spawn(function() -- line: 81
                -- upvalues: p1 (copy), p2 (copy), Robux (copy), n1 (ref), Constants (copy), Simple (copy), Price (copy)
                local v6 = Price(p1, Enum.InfoType.Product)

                if p2 ~= n1 then
                    return
                end

                Robux.Price.Text = ("%* %*"):format(Constants.ROBUX_ICON_STR, if v6 == nil then "???" else Simple.FormatCompact(v6, ".#"))
            end)
        end

        local function applyMoneyAffordability(p3) -- line: 93
            -- upvalues: UIGradient (copy), UIStroke (copy), UIStrokeClr (copy), Color3 (copy), Color (copy), Color2 (copy), v1 (copy), v2 (copy), v3 (copy)
            if UIGradient ~= nil then
                UIGradient.Color = if p3 then Color else v1
            end

            if UIStroke ~= nil then
                UIStroke.Color = if p3 then Color2 else v2
            end

            if UIStrokeClr ~= nil then
                UIStrokeClr.Color = if p3 then Color3 else v3
            end
        end

        local function refreshUpgrade(p4, p5) -- line: 111
            -- upvalues: UpgradeTreadmil (copy), Spacer (copy), Cash (copy), Robux (copy), UIGradient (copy), UIStroke (copy), UIStrokeClr (copy), n1 (ref), Color3 (copy), Color (copy), Color2 (copy), Players (copy), CashPacks (copy), Constants (copy), Simple (copy), Price (copy), Products (copy), Client (copy), Treadmills (copy), v1 (copy), v2 (copy), v3 (copy)
            local v10 = Treadmills.GetByUpgradeLevel(p4.TreadmillUpgradeLevel)

            assert(v10 ~= nil, (("Invalid current treadmill level %*"):format(p4.TreadmillUpgradeLevel)))
            Spacer.CurrentTreadmill.Image = v10.Icon

            local _, v13 = Client.GetNextConfig(p4)

            if v13 ~= nil then
                UpgradeTreadmil.Visible = true
                Spacer.NextTreadmill.Image = v13.Icon
                Cash.Price.Text = "$" .. Simple.FormatCompact(v13.Price, ".#")

                local v14 = Client.CanAffordNext(p4)

                if UIGradient ~= nil then
                    UIGradient.Color = if v14 then Color else v1
                end

                if UIStroke ~= nil then
                    UIStroke.Color = if v14 then Color2 else v2
                end

                if UIStrokeClr ~= nil then
                    UIStrokeClr.Color = if v14 then Color3 else v3
                end

                local ProductId = v13.ProductId

                Robux.Visible = ProductId ~= nil and Products.FromProductId(ProductId) ~= nil and CashPacks.GetCanBuyProduct(CashPacks.GetPlayerGroup(Players.LocalPlayer), "Treadmill_" .. v13._id)

                if ProductId ~= nil and Robux.Visible then
                    Robux.Price.Text = Constants.ROBUX_ICON_STR
                    task.spawn(function() -- line: 81
                        -- upvalues: p5 (copy), ProductId (copy), Robux (copy), n1 (ref), Constants (copy), Simple (copy), Price (copy)
                        local v19 = Price(ProductId, Enum.InfoType.Product)

                        if p5 ~= n1 then
                            return
                        end

                        Robux.Price.Text = ("%* %*"):format(Constants.ROBUX_ICON_STR, if v19 == nil then "???" else Simple.FormatCompact(v19, ".#"))
                    end)
                end
            else
                UpgradeTreadmil.Visible = false
            end
        end

        local function refreshShop() -- line: 144
            -- upvalues: n1 (ref), refreshUpgrade (copy), Save (copy)
            n1 += 1

            local v20 = n1
            local v21 = Save.Await()

            assert(v21 ~= nil, "Treadmill speed shop requires loaded player data")
            refreshUpgrade(v21, v20)
        end

        Save.Await()
        ButtonFX(Cash, nil, Client.RequestCashUpgrade)
        ButtonFX(Robux, nil, Client.PromptRobuxUpgrade)
        Tabs.Activated:Connect(function(p6) -- line: 161
            -- upvalues: n1 (ref), refreshUpgrade (copy), Save (copy)
            if p6 ~= "Shop" then
                return
            end

            n1 += 1

            local v23 = n1
            local v24 = Save.Await()

            assert(v24 ~= nil, "Treadmill speed shop requires loaded player data")
            refreshUpgrade(v24, v23)
        end)
        Save.Watch("TreadmillUpgradeLevel"):Connect(function() -- line: 167
            -- upvalues: n1 (ref), refreshUpgrade (copy), Save (copy), Tabs (copy)
            if not Tabs.IsActive("Shop") then
                return
            end

            n1 += 1

            local v26 = n1
            local v27 = Save.Await()

            assert(v27 ~= nil, "Treadmill speed shop requires loaded player data")
            refreshUpgrade(v27, v26)
        end)
        Save.Watch("Money"):Connect(function() -- line: 173
            -- upvalues: n1 (ref), refreshUpgrade (copy), Save (copy), Tabs (copy)
            if not Tabs.IsActive("Shop") then
                return
            end

            n1 += 1

            local v29 = n1
            local v30 = Save.Await()

            assert(v30 ~= nil, "Treadmill speed shop requires loaded player data")
            refreshUpgrade(v30, v29)
        end)
        Players.LocalPlayer:GetAttributeChangedSignal(CashPacks.RevisionAttribute):Connect(refreshShop)
        n1 += 1

        local v32 = n1
        local v33 = Save.Await()

        assert(v33 ~= nil, "Treadmill speed shop requires loaded player data")
        refreshUpgrade(v33, v32)
    end
}
