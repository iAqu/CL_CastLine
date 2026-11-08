-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AlertBadge = require(ReplicatedStorage.Client.UI.AlertBadge)
local Hud = require(ReplicatedStorage.Client.Hud)
local Tabs = require(ReplicatedStorage.Client.Tabs)

return {
    Start = function() -- Start | line: 18
        -- upvalues: Players (copy), ReplicatedStorage (copy), AlertBadge (copy), Hud (copy), Tabs (copy)
        local LocalPlayer = Players.LocalPlayer
        local v1 = AlertBadge.Attach(Hud.Find("ShopButton"))
        local v2 = false

        local function updateBadge() -- line: 28
            -- upvalues: LocalPlayer (copy), v1 (copy), v2 (ref)
            if not v2 and LocalPlayer:GetAttribute("ShopVersionChanged") == true then
                v1:Show()
            end
        end

        Tabs.Activated:Connect(function(p1) -- line: 34
            -- upvalues: v1 (copy), v2 (ref)
            if p1 == "Shop" then
                v2 = true
                v1:Dismiss()
            end
        end)

        local function showGlobalAlert() -- line: 41
            -- upvalues: v1 (copy), v2 (ref), Tabs (copy)
            if Tabs.Active() ~= "Shop" then
                v2 = false
                v1:Show()
            end
        end

        LocalPlayer:GetAttributeChangedSignal("ShopVersionChanged"):Connect(updateBadge)
        ReplicatedStorage:GetAttributeChangedSignal("ShopAlertNonce"):Connect(showGlobalAlert)

        if not v2 and LocalPlayer:GetAttribute("ShopVersionChanged") == true then
            v1:Show()
        end
    end
}
