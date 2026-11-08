-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local CashPacks = require(ReplicatedStorage.Data.CashPacks)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)

require(ReplicatedStorage.Client.Types.GUI)

local MonetizationEntitlements = require(ReplicatedStorage.Shared.Util.MonetizationEntitlements)
local PlotState = require(ReplicatedStorage.Client.PlotState)
local Products = require(ReplicatedStorage.Data.Products)
local Save = require(ReplicatedStorage.Shared.Save)
local Client = require(script.Client)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = Color3.new(0.760784, 0, 0)
local v2 = nil
local n1 = 0

return {
    Start = function() -- Start | line: 30
        -- upvalues: Players (copy), ButtonFX (copy), CashPacks (copy), Simple (copy), MonetizationEntitlements (copy), PlotState (copy), Products (copy), Save (copy), Client (copy), Trove (copy), v1 (copy), v2 (ref), n1 (ref)
        local function bindLocalPlot() -- line: 35
            -- upvalues: Players (copy), ButtonFX (copy), CashPacks (copy), Simple (copy), MonetizationEntitlements (copy), PlotState (copy), Products (copy), Save (copy), Client (copy), Trove (copy), v1 (copy), v2 (ref), n1 (ref)
            n1 += 1

            local v3 = n1

            if v2 ~= nil then
                v2:Destroy()
                v2 = nil
            end

            local v4 = PlotState.ResolvePlot()

            if v4 == nil then
                return
            end

            local PlotFolder = v4.PlotFolder

            assert(PlotFolder:IsA("Model"), "Local plot folder must be a Model")

            local TreadmillUpgrade = PlotFolder:WaitForChild("TreadmillUpgrade")

            assert(TreadmillUpgrade:IsA("Model"), "TreadmillUpgrade must be a Model")

            local Sign = TreadmillUpgrade.Sign

            assert(Sign:IsA("BasePart"), "TreadmillUpgrade.Sign must be a BasePart")

            local CanUpgrade = Sign.CanUpgrade

            assert(CanUpgrade:IsA("BillboardGui"), "TreadmillUpgrade.Sign.CanUpgrade must be a BillboardGui")

            local SurfaceGui = Sign.SurfaceGui

            assert(SurfaceGui:IsA("SurfaceGui"), "TreadmillUpgrade.Sign.SurfaceGui must be a SurfaceGui")

            local Level = SurfaceGui.Level

            assert(Level:IsA("TextLabel"), "TreadmillUpgrade.Sign.SurfaceGui.Level must be a TextLabel")

            local Frame = SurfaceGui.Frame

            assert(Frame:IsA("GuiObject"), "TreadmillUpgrade.Sign.SurfaceGui.Frame must be a GuiObject")

            local Upgrade = Frame.Upgrade

            assert(Upgrade:IsA("GuiButton"), "Treadmill Upgrade must be a GuiButton")

            local RobuxUpgrade = Frame.RobuxUpgrade

            assert(RobuxUpgrade:IsA("GuiButton"), "Treadmill RobuxUpgrade must be a GuiButton")

            local Cost = Upgrade.Cost

            assert(Cost:IsA("TextLabel"), "Treadmill Upgrade.Cost must be a TextLabel")

            local Cost2 = RobuxUpgrade.Cost

            assert(Cost2:IsA("TextLabel"), "Treadmill RobuxUpgrade.Cost must be a TextLabel")

            local BackgroundColor3 = Upgrade.BackgroundColor3
            local UIGradient = Upgrade:FindFirstChildOfClass("UIGradient")
            local v5 = UIGradient ~= nil and UIGradient.Enabled
            local v6 = Trove.new()

            v2 = v6
            v6:Add(function() -- line: 101
                -- upvalues: Upgrade (copy), BackgroundColor3 (copy), UIGradient (copy), v5 (copy)
                Upgrade.BackgroundColor3 = BackgroundColor3

                if UIGradient ~= nil then
                    UIGradient.Enabled = v5
                end
            end)

            local function refresh() -- line: 107
                -- upvalues: v3 (copy), CanUpgrade (copy), Level (copy), Upgrade (copy), RobuxUpgrade (copy), Cost (copy), Cost2 (copy), BackgroundColor3 (copy), UIGradient (copy), v6 (copy), v5 (copy), Players (copy), CashPacks (copy), Simple (copy), MonetizationEntitlements (copy), Products (copy), Save (copy), Client (copy), v1 (copy), v2 (ref), n1 (ref)
                local v7 = Save.Await()

                assert(v7 ~= nil, "Treadmill upgrade UI requires loaded data")

                local v9, v10 = Client.GetNextConfig(v7)
                local v11 = Client.CanAffordNext(v7)

                CanUpgrade.Enabled = v7.BaseUpgradeLevel > 0 and v11
                Upgrade.BackgroundColor3 = if v11 then BackgroundColor3 else v1

                if UIGradient ~= nil then
                    UIGradient.Enabled = v11 and v5
                end

                if v10 ~= nil then
                    Level.Text = ("Level %* > Level %*"):format(v7.TreadmillUpgradeLevel, v9)
                    Cost.Text = "$" .. Simple.FormatCompact(v10.Price, ".#")

                    local ProductId = v10.ProductId

                    RobuxUpgrade.Visible = ProductId ~= nil and Products.FromProductId(ProductId) ~= nil and CashPacks.GetCanBuyProduct(CashPacks.GetPlayerGroup(Players.LocalPlayer), "Treadmill_" .. v10._id)
                    Cost2.Text = ""

                    if ProductId ~= nil and RobuxUpgrade.Visible then
                        task.spawn(function() -- line: 141
                            -- upvalues: ProductId (copy), v3 (copy), Cost2 (copy), v6 (copy), Simple (copy), MonetizationEntitlements (copy), v2 (ref), n1 (ref)
                            local v16 = MonetizationEntitlements.ProductPrice(ProductId)

                            if v3 == n1 and v2 == v6 and v16 > 0 then
                                Cost2.Text = (" %*"):format((Simple.FormatCompact(v16, ".#")))
                            end
                        end)
                    end
                else
                    Level.Text = "Level MAX"
                    Cost.Text = "MAX"
                    RobuxUpgrade.Visible = false
                end
            end

            v6:Add(ButtonFX(Upgrade, 1.05, Client.RequestCashUpgrade))
            v6:Add(ButtonFX(RobuxUpgrade, 1.05, Client.PromptRobuxUpgrade))
            v6:Add(Save.Watch("TreadmillUpgradeLevel"):Connect(refresh))
            v6:Add(Save.Watch("BaseUpgradeLevel"):Connect(refresh))
            v6:Add(Save.Watch("Money"):Connect(refresh))
            v6:Connect(Players.LocalPlayer:GetAttributeChangedSignal(CashPacks.RevisionAttribute), refresh)
            refresh()
        end

        Save.Await()
        bindLocalPlot()
        PlotState.LocalPlotChanged:Connect(bindLocalPlot)
    end
}
