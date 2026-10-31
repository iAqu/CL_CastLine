-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local produceWrapper = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils").produceWrapper
local v1 = createProducer({
    aquariumShopSection = nil,
    charmTierId = nil,
    currentShopId = nil,
    currentWindow = "loadingScreen",
    openShopPrompt = nil
}, {
    windowToggled = produceWrapper(function(p1, p2) -- line: 13
        if p2.currentWindow == p1.currentWindow then
            p1.currentWindow = "none"
        else
            p1.currentWindow = p2.currentWindow
        end
    end),
    windowClosed = produceWrapper(function(p3) -- line: 16
        p3.aquariumShopSection = nil
        p3.charmTierId = nil
        p3.currentWindow = "none"
        p3.currentShopId = nil
    end),
    windowOpened = produceWrapper(function(p4, p5) -- line: 22
        p4.currentWindow = p5.currentWindow

        if p5.currentWindow == "charmAttributes" then
            p4.charmTierId = p5.charmTierId
        else
            p4.charmTierId = nil
        end

        if p5.currentWindow == "aquariumShop" then
            p4.aquariumShopSection = p5.aquariumShopSection
        else
            p4.aquariumShopSection = nil
        end

        if p5.currentWindow == "shop" and p5.shopId ~= nil then
            p4.currentShopId = p5.shopId
        end
    end),
    shopAreaEntered = produceWrapper(function(p6, p7) -- line: 30
        p6.openShopPrompt = {
            shopId = p7.shopId
        }
    end),
    shopAreaExited = produceWrapper(function(p8, _) -- line: 35
        p8.openShopPrompt = nil

        if p8.currentWindow == "shop" then
            p8.currentWindow = "none"
            p8.currentShopId = nil
        end
    end)
})

v1:getActions()

return {
    currentWindowSlice = v1
}
