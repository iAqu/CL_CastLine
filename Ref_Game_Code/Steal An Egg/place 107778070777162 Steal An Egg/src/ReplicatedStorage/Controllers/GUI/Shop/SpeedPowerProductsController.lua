-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local GUI = require(ReplicatedStorage.Client.GUI)

require(ReplicatedStorage.Client.Types.GUI)

local Gifting = require(ReplicatedStorage.Client.Gifting)
local Price = require(ReplicatedStorage.Shared.Utils.Marketplace).Price

require(ReplicatedStorage.Data.Products)

local Products = require(ReplicatedStorage.Data.Products)
local Save = require(ReplicatedStorage.Shared.Save)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local Storefront = require(ReplicatedStorage.Client.Functions.Storefront)
local t1 = {
    Products.Directory.SpeedPower_150000,
    Products.Directory.SpeedPower_1000000,
    Products.Directory.SpeedPower_10000000,
    Products.Directory.SpeedPower_50000000,
    Products.Directory.SpeedPower_500000000,
    Products.Directory.SpeedPower_1000000000
}
local SpeedPacks = require(ReplicatedStorage.Data.SpeedPacks)
local LocalPlayer = game:GetService("Players").LocalPlayer

return {
    Start = function() -- Start | line: 38
        -- upvalues: ButtonFX (copy), Constants (copy), GUI (copy), Gifting (copy), Price (copy), Save (copy), Simple (copy), Storefront (copy), t1 (copy), SpeedPacks (copy), LocalPlayer (copy)
        local v1 = GUI.Shop()
        local Speed = v1.Frame.ScrollingFrame.Speed
        local t3 = {
            Speed.c1,
            Speed.c2,
            Speed.c3,
            Speed.c4,
            Speed.c5,
            Speed.c6
        }

        local function updateProductPrice(p1, p2) -- line: 55
            -- upvalues: Constants (copy), Price (copy)
            if p2 ~= nil then
                local ProductId = p2.ProductId

                if ProductId <= 0 then
                    p1.Text = "???"
                else
                    task.spawn(function() -- line: 67
                        -- upvalues: p1 (copy), ProductId (copy), Constants (copy), Price (copy)
                        local v2 = Price(ProductId, Enum.InfoType.Product)

                        p1.Text = ("%*%*"):format(Constants.ROBUX_ICON_STR, if v2 == nil then "???" else tostring(v2))
                    end)
                end
            else
                p1.Text = "???"
            end
        end

        local function bindSpeedPowerProductFrame(p3, p4, p5) -- line: 73
            -- upvalues: v1 (copy), Speed (copy), ButtonFX (copy), Constants (copy), Gifting (copy), Price (copy), Simple (copy), Storefront (copy), SpeedPacks (copy), LocalPlayer (copy)
            local Price2 = p3.Btns.Buy.Price

            if p4 ~= nil then
                local ProductId = p4.ProductId

                if ProductId <= 0 then
                    Price2.Text = "???"
                else
                    task.spawn(function() -- line: 67
                        -- upvalues: Price2 (copy), ProductId (copy), Constants (copy), Price (copy)
                        local v4 = Price(ProductId, Enum.InfoType.Product)

                        Price2.Text = ("%*%*"):format(Constants.ROBUX_ICON_STR, if v4 == nil then "???" else tostring(v4))
                    end)
                end
            else
                Price2.Text = "???"
            end

            p3.Title.RichText = true

            local v6 = assert(SpeedPacks.FindSlot(p4.ProductId))

            local function refresh() -- line: 81
                -- upvalues: p3 (copy), p5 (copy), v6 (copy), Simple (copy), SpeedPacks (copy), LocalPlayer (copy)
                local v7 = SpeedPacks.GetShownAmount(LocalPlayer, v6)
                local Title = p3.Title

                if v7 then
                    Title.Text = ("<font color=\"#%*\">+%*</font> SPEED"):format(p5:ToHex(), (Simple.FormatCompact(v7, ".#")))
                else
                    Title.Text = "Loading..."
                end
            end

            SpeedPacks.ObserveShownAmount(LocalPlayer, v6, refresh)
            v1:GetPropertyChangedSignal("Enabled"):Connect(refresh)
            v1.Frame:GetPropertyChangedSignal("Visible"):Connect(refresh)
            Speed:GetPropertyChangedSignal("Visible"):Connect(refresh)
            ButtonFX(p3.Btns.Buy, nil, function() -- line: 91
                -- upvalues: p4 (copy), Storefront (copy)
                Storefront.Prompt(p4.ProductId, true)
            end)
            Gifting.Bind(p3.Btns.Gift, "Product", p4.ProductId)
        end

        Save.Await()

        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = "SpeedPackMaxNotice"
        TextLabel.LayoutOrder = Speed.LayoutOrder + 1
        TextLabel.Size = UDim2.new(1, 0, 0, 36)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.TextColor3 = Color3.new(1, 1, 1)
        TextLabel.TextStrokeTransparency = 0
        TextLabel.TextScaled = true
        TextLabel.TextWrapped = true
        TextLabel.Text = "Max for now. Bigger packs with the next biome."

        local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

        UITextSizeConstraint.MaxTextSize = 22
        UITextSizeConstraint.Parent = TextLabel
        TextLabel.Parent = Speed.Parent

        local function refreshNotice() -- line: 117
            -- upvalues: Speed (copy), TextLabel (copy), SpeedPacks (copy), LocalPlayer (copy)
            local Visible = Speed.Visible and LocalPlayer:GetAttribute(SpeedPacks.ReadyAttribute) == true and LocalPlayer:GetAttribute(SpeedPacks.MaxAttribute) == true

            TextLabel.Visible = Visible
        end

        LocalPlayer:GetAttributeChangedSignal(SpeedPacks.RevisionAttribute):Connect(refreshNotice)
        LocalPlayer:GetAttributeChangedSignal(SpeedPacks.ReadyAttribute):Connect(refreshNotice)
        LocalPlayer:GetAttributeChangedSignal(SpeedPacks.MaxAttribute):Connect(refreshNotice)
        Speed:GetPropertyChangedSignal("Visible"):Connect(refreshNotice)

        local Visible = Speed.Visible and LocalPlayer:GetAttribute(SpeedPacks.ReadyAttribute) == true and LocalPlayer:GetAttribute(SpeedPacks.MaxAttribute) == true

        TextLabel.Visible = Visible

        for v8, v9 in t3 do
            bindSpeedPowerProductFrame(v9, t1[v8], if v8 <= 3 then Color3.fromRGB(0, 255, 0) else Color3.fromRGB(255, 200, 0))
        end
    end
}
