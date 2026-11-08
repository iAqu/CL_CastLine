-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local Hud = require(ReplicatedStorage.Client.Hud)
local ShopNavigation = require(ReplicatedStorage.Client.ShopNavigation)

return {
    Start = function() -- Start | line: 10
        -- upvalues: ButtonFX (copy), Hud (copy), ShopNavigation (copy)
        for _, v1 in Hud.Every("SpeedShopButton") do
            ButtonFX(v1, 1.08, function() -- line: 12
                -- upvalues: ShopNavigation (copy)
                ShopNavigation.Open("SpeedProducts")
            end)
        end
    end
}
