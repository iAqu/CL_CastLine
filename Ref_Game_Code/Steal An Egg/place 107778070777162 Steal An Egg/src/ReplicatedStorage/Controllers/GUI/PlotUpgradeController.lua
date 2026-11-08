-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local BaseUpgrade = require(ReplicatedStorage.Client.BaseUpgrade)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)

require(ReplicatedStorage.Client.Types.GUI)

local EnsureUIScale = require(ReplicatedStorage.Shared.Utils.EnsureUIScale)
local PlotState = require(ReplicatedStorage.Client.PlotState)
local PlotUpgradeVisibility = require(ReplicatedStorage.Client.PlotUpgradeVisibility)

require(ReplicatedStorage.Data.Products)

local Products = require(ReplicatedStorage.Data.Products)
local Storefront = require(ReplicatedStorage.Client.Functions.Storefront)
local Save = require(ReplicatedStorage.Shared.Save)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = Color3.new(0.760784, 0, 0)
local v2 = TweenInfo.new(0.65, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)

return {
    Start = function() -- Start | line: 36
        -- upvalues: ReplicatedStorage (copy), TweenService (copy), BaseUpgrade (copy), ButtonFX (copy), Simple (copy), EnsureUIScale (copy), PlotState (copy), PlotUpgradeVisibility (copy), Products (copy), Storefront (copy), Save (copy), Trove (copy), v1 (copy), v2 (copy)
        local PlotUpgrade = ReplicatedStorage.Assets.UI.PlotUpgrade
        local FirstUpgradeInfo = PlotUpgrade.FirstUpgradeInfo

        assert(FirstUpgradeInfo:IsA("Frame"), "PlotUpgrade.FirstUpgradeInfo template must be a Frame")

        local FirstUpgrade = PlotUpgrade.FirstUpgrade

        assert(FirstUpgrade:IsA("ImageButton"), "PlotUpgrade.FirstUpgrade template must be an ImageButton")

        local v3, BackgroundColor3, Enabled

        local function getProductForLevel(p1) -- line: 57
            -- upvalues: Products (copy)
            local v4 = ("BaseUpgradeTier%*"):format(p1)

            return if Products.ProductNameExists(v4) then Products.Directory[v4] else nil
        end

        local function refreshPlotUpgradeVisibility() -- line: 63
            -- upvalues: PlotUpgradeVisibility (copy)
            PlotUpgradeVisibility.Apply("PlotUpgrade")
        end

        local function bindLocalPlot() -- line: 65
            -- upvalues: FirstUpgradeInfo (copy), FirstUpgrade (copy), v3 (ref), BackgroundColor3 (ref), Enabled (ref), TweenService (copy), BaseUpgrade (copy), ButtonFX (copy), Simple (copy), EnsureUIScale (copy), PlotState (copy), Products (copy), Storefront (copy), Save (copy), Trove (copy), v1 (copy), v2 (copy)
            if v3 ~= nil then
                v3:Destroy()
                v3 = nil
            end

            local v5 = PlotState.ResolvePlot()

            if v5 == nil then
                return
            end

            local PlotFolder = v5.PlotFolder

            assert(PlotFolder:IsA("Model"), "Local plot folder must be a Model")

            local PlotUpgrade = PlotFolder:WaitForChild("PlotUpgrade")

            assert(PlotUpgrade:IsA("Model"), "PlotUpgrade must be a Model")

            local Sign = PlotUpgrade.Sign

            assert(Sign:IsA("BasePart"), "PlotUpgrade.Sign must be a BasePart")

            local CanUpgrade = Sign.CanUpgrade

            assert(CanUpgrade:IsA("BillboardGui"), "PlotUpgrade.Sign.CanUpgrade must be a BillboardGui")

            local SurfaceGui = Sign.SurfaceGui

            assert(SurfaceGui:IsA("SurfaceGui"), "PlotUpgrade.Sign.SurfaceGui must be a SurfaceGui")

            local Info = SurfaceGui.Info

            assert(Info:IsA("TextLabel"), "PlotUpgrade.Sign.SurfaceGui.Info must be a TextLabel")

            local Level = SurfaceGui.Level

            assert(Level:IsA("TextLabel"), "PlotUpgrade.Sign.SurfaceGui.Level must be a TextLabel")

            local Frame = SurfaceGui.Frame

            assert(Frame:IsA("GuiObject"), "PlotUpgrade.Sign.SurfaceGui.Frame must be a GuiObject")

            local Upgrade = Frame.Upgrade

            assert(Upgrade:IsA("GuiButton"), "Plot Upgrade must be a GuiButton")

            local RobuxUpgrade = Frame.RobuxUpgrade

            assert(RobuxUpgrade:IsA("GuiButton"), "Plot RobuxUpgrade must be a GuiButton")

            local Cost = Upgrade.Cost

            assert(Cost:IsA("TextLabel"), "Plot Upgrade.Cost must be a TextLabel")

            local UIGradient = Upgrade:FindFirstChildOfClass("UIGradient")

            if BackgroundColor3 == nil then
                BackgroundColor3 = Upgrade.BackgroundColor3
            end

            if UIGradient ~= nil and Enabled == nil then
                Enabled = UIGradient.Enabled
            end

            local v6 = assert(BackgroundColor3, "Plot Upgrade authored background color must be initialized")

            Upgrade.AutoButtonColor = false

            local v7 = Trove.new()
            local clone = FirstUpgradeInfo:Clone()
            local Icon = clone.Icon

            assert(Icon:IsA("ImageLabel"), "Plot FirstUpgradeInfo.Icon must be an ImageLabel")

            local clone2 = FirstUpgrade:Clone()
            local Cost2 = clone2.Cost

            assert(Cost2:IsA("TextLabel"), "Plot FirstUpgrade.Cost must be a TextLabel")

            local ProgressFill = clone2.ProgressFill

            assert(ProgressFill:IsA("Frame"), "Plot FirstUpgrade.ProgressFill must be a Frame")

            local UIGradient2 = clone2.UIGradient

            assert(UIGradient2:IsA("UIGradient"), "Plot FirstUpgrade button gradient must be a UIGradient")

            local BackgroundColor3_3 = clone2.BackgroundColor3
            local Enabled2 = UIGradient2.Enabled
            local Size = ProgressFill.Size

            clone.Visible = false
            clone.Parent = SurfaceGui
            v7:Add(clone)

            local v8 = EnsureUIScale(Icon)

            v8.Scale = 0.8

            local tween = TweenService:Create(v8, v2, {
                Scale = 1.3
            })

            v7:Add(tween)
            tween:Play()
            clone2.Visible = false
            clone2.AutoButtonColor = false
            clone2.Parent = Frame
            v7:Add(clone2)
            v3 = v7

            local function refresh() -- line: 145
                -- upvalues: CanUpgrade (copy), Info (copy), Level (copy), Upgrade (copy), RobuxUpgrade (copy), Cost (copy), UIGradient (copy), v6 (copy), clone (copy), clone2 (copy), Cost2 (copy), ProgressFill (copy), UIGradient2 (copy), BackgroundColor3_3 (copy), Enabled2 (copy), Size (copy), Enabled (ref), BaseUpgrade (copy), Simple (copy), Save (copy), v1 (copy)
                local v9 = Save.Await()

                assert(v9 ~= nil, "Plot upgrade UI requires loaded data")

                local v11 = v9.BaseUpgradeLevel == 0

                Info.Visible = not v11
                Level.Visible = not v11
                clone.Visible = v11
                Upgrade.Visible = not v11
                clone2.Visible = v11

                local v12, v13 = BaseUpgrade.ResolveNextTier(v9)
                local v14 = BaseUpgrade.IsNextTierAffordable(v9)

                CanUpgrade.Enabled = v14
                Upgrade.BackgroundColor3 = if v14 then v6 else v1

                if UIGradient ~= nil then
                    UIGradient.Enabled = v14 and Enabled == true
                end

                clone2.BackgroundColor3 = if v14 then BackgroundColor3_3 else v1
                UIGradient2.Enabled = v14 and Enabled2

                if v12 ~= nil and v13 ~= nil then
                    Level.Text = ("Level %* > Level %*"):format(v9.BaseUpgradeLevel, v12)

                    local v18 = "$" .. Simple.FormatCompact(v13.Cost, ".#")

                    Cost.Text = v18
                    Cost2.Text = v18
                    assert(v13.Cost > 0, "Plot upgrade cost must be positive")

                    local v21 = math.clamp(v9.Money / v13.Cost, 0, 1)

                    ProgressFill.Size = UDim2.new(v21, Size.X.Offset, Size.Y.Scale, Size.Y.Offset)
                else
                    Level.Text = "Level MAX"
                    Cost.Text = "MAX"
                end

                RobuxUpgrade.Visible = false
            end

            v7:Add(ButtonFX(Upgrade, 1.05, BaseUpgrade.PurchaseNextTier))
            v7:Add(ButtonFX(clone2, 1.05, BaseUpgrade.PurchaseNextTier))
            v7:Add(ButtonFX(RobuxUpgrade, 1.05, function() -- line: 203
                -- upvalues: BaseUpgrade (copy), Products (copy), Storefront (copy), Save (copy)
                local v22 = Save.Await()

                assert(v22 ~= nil, "Plot Robux upgrade requires loaded data")

                local v24, v25 = BaseUpgrade.ResolveNextTier(v22)

                if v24 ~= nil and v25 ~= nil then
                    local v26 = ("BaseUpgradeTier%*"):format(v24)
                    local v27 = if Products.ProductNameExists(v26) then Products.Directory[v26] else nil

                    if v27 ~= nil then
                        Storefront.Prompt(v27.ProductId, true)
                    end
                end
            end))
            v7:Add(Save.Watch("BaseUpgradeLevel"):Connect(refresh))
            v7:Add(Save.Watch("Money"):Connect(refresh))
            refresh()
        end

        Save.Await()
        bindLocalPlot()
        PlotUpgradeVisibility.Apply("PlotUpgrade")
        PlotState.LocalPlotChanged:Connect(function() -- line: 227
            -- upvalues: bindLocalPlot (copy), PlotUpgradeVisibility (copy)
            bindLocalPlot()
            PlotUpgradeVisibility.Apply("PlotUpgrade")
        end)
        PlotState.PlotChanged:Connect(refreshPlotUpgradeVisibility)
        PlotState.FolderChanged:Connect(refreshPlotUpgradeVisibility)
    end
}
