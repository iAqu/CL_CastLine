-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Controllers = script.Parent:WaitForChild("Controllers")
local t1 = {
    "DataController",
    "UIScaler",
    "Sounds",
    "MusicController",
    "RobuxPrices",
    "ScreenFX",
    "CameraRig",
    "FogController",
    "UIKit",
    "UIBackdrop",
    "HUDController",
    "PowerSlider",
    "AnimalVisuals",
    "TrainingVisuals",
    "TrainingController",
    "ShopController",
    "PlotController",
    "PlotTags",
    "IndexController",
    "AnimalsPanel",
    "SellShop",
    "ProtectedSell",
    "Inventory",
    "ExclusiveShopController",
    "ShopFX",
    "GiftController",
    "EggController",
    "Tutorial",
    "UpgradePopups",
    "ReleaseController",
    "ReleaseShow",
    "EventFollow",
    "UIFocus",
    "OfflineEarnings",
    "SuperThrow",
    "ThrowController",
    "PackOffers",
    "DevPanel",
    "NewAnimalView"
}
local t2 = {}

for _, v1 in ipairs(t1) do
    local v2 = Controllers:FindFirstChild(v1)

    if v2 then
        local _require = require
        local ok, result = pcall(_require, v2)

        if ok then
            t2[v1] = result
        else
            warn("[ClientMain] Failed to require " .. v1 .. ": " .. tostring(result))
        end
    else
        warn("[ClientMain] Missing controller: " .. v1)
    end
end

if t2.Sounds and t2.Sounds.Preload then
    t2.Sounds.Preload()
end

for _, v3 in ipairs(t1) do
    local v4 = t2[v3]

    if v4 and type(v4) == "table" and v4.Init then
        local Init = v4.Init
        local ok, result = pcall(Init)

        if not ok then
            warn("[ClientMain] " .. v3 .. ".Init failed: " .. tostring(result))
        end
    end
end

print("[ClientMain] Client started")
