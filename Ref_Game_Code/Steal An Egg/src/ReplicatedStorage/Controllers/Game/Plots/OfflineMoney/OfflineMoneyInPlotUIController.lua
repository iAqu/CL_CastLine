-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local AdminBoosts = require(ReplicatedStorage.Shared.Util.AdminBoosts)
local AssetItems = require(ReplicatedStorage.Shared.Util.AssetItems)
local AssetRoster = require(ReplicatedStorage.Client.AssetRoster)
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local Player = require(ReplicatedStorage.Shared.Player)
local PlotState = require(ReplicatedStorage.Client.PlotState)
local Save = require(ReplicatedStorage.Shared.Save)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local Trove = require(ReplicatedStorage.Packages.Trove)
local OFFLINE_ASSETS = Constants.OFFLINE_ASSETS
local LocalPlayer = Players.LocalPlayer

return {
    Start = function() -- Start | line: 31
        -- upvalues: RunService (copy), AdminBoosts (copy), AssetItems (copy), AssetRoster (copy), HiddenUIHandler (copy), Player (copy), PlotState (copy), Save (copy), Simple (copy), Trove (copy), OFFLINE_ASSETS (copy), LocalPlayer (copy)
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

        assert(PlayerGui:IsA("PlayerGui"), "Expected PlayerGui")

        local OfflineMoneyInPlot = PlayerGui:WaitForChild("OfflineMoneyInPlot")

        assert(OfflineMoneyInPlot:IsA("ScreenGui"), "OfflineMoneyInPlot must be a ScreenGui")

        local TopBar = OfflineMoneyInPlot:WaitForChild("TopBar")

        assert(TopBar:IsA("GuiObject"), "OfflineMoneyInPlot.TopBar must be a GuiObject")

        local InPlot = TopBar:WaitForChild("InPlot")

        assert(InPlot:IsA("GuiObject"), "OfflineMoneyInPlot.TopBar.InPlot must be a GuiObject")

        local TextLabel = InPlot:WaitForChild("TextLabel")

        assert(TextLabel:IsA("TextLabel"), "OfflineMoneyInPlot.TopBar.InPlot.TextLabel must be a TextLabel")

        local v1 = Trove.new()
        local n1 = 0
        local updateVisibility

        local function formatOfflineAmount(p1) -- line: 52
            -- upvalues: Simple (copy)
            return Simple.FormatCompact((math.max(p1, 0)))
        end

        local function getOfflinePreviewAmountFromTotalRate(p2) -- line: 56
            -- upvalues: OFFLINE_ASSETS (copy)
            return math.max(p2, 0) * OFFLINE_ASSETS.MAX_DURATION_SECONDS * OFFLINE_ASSETS.MONEY_RATE_MULTIPLIER
        end

        local function updateText() -- line: 62
            -- upvalues: TextLabel (copy), n1 (ref), formatOfflineAmount (copy), OFFLINE_ASSETS (copy)
            TextLabel.RichText = true
            TextLabel.Text = string.format("You earn <font color = \"#00ff00\">$%s</font>/Day offline! 😈", formatOfflineAmount(math.max(n1, 0) * OFFLINE_ASSETS.MAX_DURATION_SECONDS * OFFLINE_ASSETS.MONEY_RATE_MULTIPLIER))
        end

        local function isWorldPositionInsideScaledPetAreaXZ(p3) -- line: 70
            -- upvalues: AssetRoster (copy), LocalPlayer (copy)
            local v3 = AssetRoster.FindPenArea(LocalPlayer)

            if v3 == nil then
                return false
            end

            local v4 = v3.CFrame:PointToObjectSpace(p3)
            local v5 = v3.Size.X * 0.74 * 0.5
            local v6 = v3.Size.Z * 0.74 * 0.5

            if not (math.abs(v4.X) <= v5) then
                return false
            end

            return math.abs(v4.Z) <= v6
        end

        local function refreshRateFromSave() -- line: 83
            -- upvalues: TextLabel (copy), n1 (ref), updateVisibility (ref), formatOfflineAmount (copy), AssetItems (copy), Save (copy), OFFLINE_ASSETS (copy), LocalPlayer (copy)
            local v7 = Save.Await()

            n1 = if v7 ~= nil then AssetItems.ProfileIncomePerSecond(LocalPlayer, v7) else 0
            TextLabel.RichText = true
            TextLabel.Text = string.format("You earn <font color = \"#00ff00\">$%s</font>/Day offline! 😈", formatOfflineAmount(math.max(n1, 0) * OFFLINE_ASSETS.MAX_DURATION_SECONDS * OFFLINE_ASSETS.MONEY_RATE_MULTIPLIER))
            updateVisibility()
        end

        function updateVisibility() -- line: 92
            -- upvalues: OfflineMoneyInPlot (copy), n1 (ref), isWorldPositionInsideScaledPetAreaXZ (copy), HiddenUIHandler (copy), Player (copy), LocalPlayer (copy)
            local v9 = Player.FindRootPart(LocalPlayer)
            local v10 = not HiddenUIHandler.IsHidden() and n1 > 1000 and v9 ~= nil and isWorldPositionInsideScaledPetAreaXZ(v9.Position)

            OfflineMoneyInPlot.Enabled = v10
        end

        TextLabel.RichText = true
        OfflineMoneyInPlot.Enabled = false

        local v11 = Save.Await()

        n1 = if v11 ~= nil then AssetItems.ProfileIncomePerSecond(LocalPlayer, v11) else 0
        TextLabel.RichText = true
        TextLabel.Text = string.format("You earn <font color = \"#00ff00\">$%s</font>/Day offline! 😈", formatOfflineAmount(math.max(n1, 0) * OFFLINE_ASSETS.MAX_DURATION_SECONDS * OFFLINE_ASSETS.MONEY_RATE_MULTIPLIER))
        updateVisibility()
        updateVisibility()
        v1:Add(Save.WatchFields({
            "EquippedAssets",
            "Inventory",
            "Gamepasses",
            "Products"
        }, refreshRateFromSave))
        v1:Add(AdminBoosts.Observe(AdminBoosts.EARNINGS):Connect(refreshRateFromSave))
        v1:Add(Save.Loaded:Connect(function(p4) -- line: 117
            -- upvalues: TextLabel (copy), n1 (ref), updateVisibility (ref), formatOfflineAmount (copy), AssetItems (copy), Save (copy), OFFLINE_ASSETS (copy), LocalPlayer (copy)
            if p4 ~= LocalPlayer then
                return
            end

            local v13 = Save.Await()

            n1 = if v13 ~= nil then AssetItems.ProfileIncomePerSecond(LocalPlayer, v13) else 0
            TextLabel.RichText = true
            TextLabel.Text = string.format("You earn <font color = \"#00ff00\">$%s</font>/Day offline! 😈", formatOfflineAmount(math.max(n1, 0) * OFFLINE_ASSETS.MAX_DURATION_SECONDS * OFFLINE_ASSETS.MONEY_RATE_MULTIPLIER))
            updateVisibility()
        end))
        v1:Add(PlotState.LocalPlotChanged:Connect(updateVisibility))
        v1:Connect(RunService.Heartbeat, updateVisibility)
    end
}
