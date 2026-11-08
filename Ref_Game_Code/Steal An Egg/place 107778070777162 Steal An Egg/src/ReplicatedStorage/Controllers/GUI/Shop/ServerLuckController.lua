-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local Timecode = require(ReplicatedStorage.Shared.Utils.Time).Timecode
local GUI = require(ReplicatedStorage.Client.GUI)
local Price = require(ReplicatedStorage.Shared.Utils.Marketplace).Price
local Products = require(ReplicatedStorage.Data.Products)
local Storefront = require(ReplicatedStorage.Client.Functions.Storefront)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local ServerLuck = require(ReplicatedStorage.Shared.Types.ServerLuck)

return {
    Start = function() -- Start | line: 20
        -- upvalues: RunService (copy), ButtonFX (copy), Constants (copy), Timecode (copy), GUI (copy), Price (copy), Products (copy), Storefront (copy), Remotes (copy), ServerLuck (copy)
        if Constants.IS_STUDIO then
            assert(Products.Directory.ServerLuck_X2, "ServerLuck_X2 product not found in Products directory")
            assert(Products.Directory.ServerLuck_X4, "ServerLuck_X4 product not found in Products directory")
            assert(Products.Directory.ServerLuck_X8, "ServerLuck_X8 product not found in Products directory")
        end

        local v1 = GUI.Shop():FindFirstChild("ServerLuck", true)

        if v1 == nil then
            return
        end

        local v2 = v1:FindFirstChild("Main") or v1
        local ExpiresIn = v2:WaitForChild("ExpiresIn")
        local BuyButton = v2:WaitForChild("BuyButton")
        local Price2 = BuyButton:WaitForChild("Price")
        local Available = v2:WaitForChild("Available")
        local v3 = Available:WaitForChild("1")
        local v4 = Available:WaitForChild("2")
        local ButtonsWithExtension = v2:WaitForChild("ButtonsWithExtension")
        local List = ButtonsWithExtension:WaitForChild("List")
        local v5 = List:WaitForChild("15Min")
        local v6 = List:WaitForChild("30Min")
        local v7 = {
            Multiplier = 1
        }

        local function getNextMultiplier(p1) -- line: 54
            if p1 < 2 then
                return 2
            end

            if p1 < 4 then
                return 4
            end

            return 8
        end

        local function updateLuckTimer(p2) -- line: 64
            -- upvalues: ExpiresIn (copy), Timecode (copy)
            ExpiresIn.Text = if p2 > 0 then ("<stroke color=\"rgb(0,0,0)\" joins=\"round\" thickness=\"2\"><font color=\"rgb(255, 0, 0)\">%*</font></stroke>"):format((Timecode(p2))) else "<font color=\"rgb(255, 0, 0)\">15 mins</font>"
        end

        local function updateUI() -- line: 79
            -- upvalues: v2 (copy), ExpiresIn (copy), Price2 (copy), v3 (copy), v4 (copy), ButtonsWithExtension (copy), v5 (copy), v6 (copy), v7 (ref), Timecode (copy), Price (copy), Products (copy)
            local v9 = if v7.ExpiresAt then math.max(0, v7.ExpiresAt - workspace:GetServerTimeNow()) else 0

            ExpiresIn.Text = if v9 > 0 then ("<stroke color=\"rgb(0,0,0)\" joins=\"round\" thickness=\"2\"><font color=\"rgb(255, 0, 0)\">%*</font></stroke>"):format((Timecode(v9))) else "<font color=\"rgb(255, 0, 0)\">15 mins</font>"
            v2.Available.Visible = v7.Multiplier ~= 8
            v2.MaxedOut.Visible = v7.Multiplier == 8
            ButtonsWithExtension.Visible = v7.Multiplier > 1

            if not (v7.Multiplier < 8) then
                Price2.Text = "Maxed"

                return
            end

            local Multiplier = v7.Multiplier
            local v12 = if Multiplier < 2 then 2 elseif Multiplier < 4 then 4 else 8

            v3.Text = ("<stroke color=\"rgb(0,0,0)\" joins=\"round\" thickness=\"2\">%*<font color=\"rgb(56, 232, 57)\"></font></stroke>x"):format(v7.Multiplier)
            v4.Text = ("<stroke color=\"rgb(0,0,0)\" joins=\"round\" thickness=\"2\"><font color=\"rgb(56, 232, 57)\">%*</font></stroke>x"):format(v12)

            local v13 = Products.Directory[("ServerLuck_X%*"):format(v12)]

            if v13 then
                Price2.Text = ("%*"):format(Price(v13.ProductId, Enum.InfoType.Product) or 0)
            end

            if ButtonsWithExtension.Visible then
                local ServerLuck_Extend15 = Products.Directory.ServerLuck_Extend15

                if ServerLuck_Extend15 then
                    v5.Text = ("%*"):format(Price(ServerLuck_Extend15.ProductId, Enum.InfoType.Product) or 0)
                end

                local ServerLuck_Extend30 = Products.Directory.ServerLuck_Extend30

                if ServerLuck_Extend30 then
                    v6.Text = ("%*"):format(Price(ServerLuck_Extend30.ProductId, Enum.InfoType.Product) or 0)
                end
            end
        end

        ButtonFX(BuyButton, nil, function() -- line: 119
            -- upvalues: v7 (ref), Products (copy), Storefront (copy)
            if not (v7.Multiplier < 8) then
                return
            end

            local Multiplier = v7.Multiplier
            local v17 = if Multiplier < 2 then 2 elseif Multiplier < 4 then 4 else 8
            local v18 = Products.Directory[("ServerLuck_X%*"):format(v17)]

            if v18 then
                Storefront.Prompt(v18.ProductId, true)
            end
        end)
        ButtonFX(v5, nil, function() -- line: 129
            -- upvalues: v7 (ref), Products (copy), Storefront (copy)
            if v7.Multiplier > 1 then
                local ServerLuck_Extend15 = Products.Directory.ServerLuck_Extend15

                if ServerLuck_Extend15 then
                    Storefront.Prompt(ServerLuck_Extend15.ProductId, true)
                end
            end
        end)
        ButtonFX(v6, nil, function() -- line: 138
            -- upvalues: v7 (ref), Products (copy), Storefront (copy)
            if v7.Multiplier > 1 then
                local ServerLuck_Extend30 = Products.Directory.ServerLuck_Extend30

                if ServerLuck_Extend30 then
                    Storefront.Prompt(ServerLuck_Extend30.ProductId, true)
                end
            end
        end)
        Remotes.LuckWindow.StateRefreshed.OnClientEvent:Connect(function(p3) -- line: 147
            -- upvalues: v7 (ref), updateUI (copy), ServerLuck (copy)
            if ServerLuck.State(p3) then
                v7 = p3
                updateUI()
            end
        end)

        local function v19() -- line: 154
            -- upvalues: Remotes (copy)
            return Remotes.LuckWindow.FetchState:InvokeServer()
        end

        local ok, result = pcall(v19)

        if ok and type(result) == "table" and ServerLuck.State(result) then
            v7 = result
            updateUI()
        end

        RunService.Heartbeat:Connect(function() -- line: 160
            -- upvalues: v7 (ref), updateUI (copy)
            if v7.ExpiresAt then
                updateUI()
            end
        end)
    end
}
