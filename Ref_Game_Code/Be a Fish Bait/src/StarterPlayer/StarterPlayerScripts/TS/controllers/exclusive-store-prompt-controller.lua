-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local MarketplaceService, Players, StarterGui = services.MarketplaceService, services.Players, services.StarterGui
local events = RuntimeLib.import(script, script.Parent.Parent, "network").events
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local attemptStorePurchase = RuntimeLib.import(script, script.Parent.Parent, "store-purchase-utils").attemptStorePurchase
local v1 = RuntimeLib.import(script, script.Parent.Parent, "fishing-phase-atom")
local apexSkillCheckAtom, rareFishTransitionAtom = v1.apexSkillCheckAtom, v1.rareFishTransitionAtom
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent, "utils").localPlayerUserId
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "gamepass-utils")
local vipGamepassName, powerTrainingGamepassName, cashGamepassName, fishLuckGamepassName = v2.vipGamepassName, v2.powerTrainingGamepassName, v2.cashGamepassName, v2.fishLuckGamepassName
local mutationLuckGamepassName, extraAquariumFishGamepassName = v2.mutationLuckGamepassName, v2.extraAquariumFishGamepassName
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerOwnsGamepass, selectPlayerBundlePurchaseHistory, selectPlayerAquarium = selectors.selectPlayerOwnsGamepass, selectors.selectPlayerBundlePurchaseHistory, selectors.selectPlayerAquarium
local v3 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-utils")
local starterPackProductId, vipGamepassProductId, powerTrainingGamepassProductId, cashGamepassProductId = v3.starterPackProductId, v3.vipGamepassProductId, v3.powerTrainingGamepassProductId, v3.cashGamepassProductId
local fishLuckGamepassProductId, mutationLuckGamepassProductId, extraAquariumFishGamepassProductId, timeSkip5MinProductId = v3.fishLuckGamepassProductId, v3.mutationLuckGamepassProductId, v3.extraAquariumFishGamepassProductId, v3.timeSkip5MinProductId
local timeSkip30MinProductId, volcanicAquariumSkinProductId, starterPackBundleName = v3.timeSkip30MinProductId, v3.volcanicAquariumSkinProductId, v3.starterPackBundleName
local t1 = {
    {
        name = "Starter Pack",
        isGamepass = false,
        icon = images.starterPackFeatured,
        productId = starterPackProductId,
        bundleName = starterPackBundleName
    },
    {
        name = "VIP",
        isGamepass = true,
        icon = images.vipCrownIcon,
        productId = vipGamepassProductId,
        gamepassName = vipGamepassName
    },
    {
        name = "Volcanic Aquarium Skin",
        isGamepass = false,
        skinName = "Volcanic",
        icon = images.volcanicAquariumSkin,
        productId = volcanicAquariumSkinProductId
    },
    {
        name = "+1 Fish In Aquarium",
        isGamepass = true,
        icon = images.fishPlusOneIcon,
        productId = extraAquariumFishGamepassProductId,
        gamepassName = extraAquariumFishGamepassName
    },
    {
        name = "x2 Power",
        isGamepass = true,
        icon = images.strongArmIcon,
        productId = powerTrainingGamepassProductId,
        gamepassName = powerTrainingGamepassName
    },
    {
        name = "x2 Cash",
        isGamepass = true,
        icon = images.cashPile,
        productId = cashGamepassProductId,
        gamepassName = cashGamepassName
    },
    {
        name = "x2 Boss Fish Luck",
        isGamepass = true,
        icon = images.bossFishIcon,
        productId = fishLuckGamepassProductId,
        gamepassName = fishLuckGamepassName
    },
    {
        name = "x2 Mutation Luck",
        isGamepass = true,
        icon = images.serverLuckCloverIcon,
        productId = mutationLuckGamepassProductId,
        gamepassName = mutationLuckGamepassName
    },
    {
        name = "5m Time Skip",
        isGamepass = false,
        icon = images.timeSkipIcon,
        productId = timeSkip5MinProductId
    },
    {
        name = "30m Time Skip",
        isGamepass = false,
        icon = images.timeSkipBundleIcon,
        productId = timeSkip30MinProductId
    }
}

local function promptPurchase(p1) -- line: 105
    -- upvalues: MarketplaceService (copy), Players (copy), attemptStorePurchase (copy)
    if p1.productId == 0 then
        return nil
    end

    if p1.isGamepass then
        MarketplaceService:PromptGamePassPurchase(Players.LocalPlayer, p1.productId)
    else
        attemptStorePurchase(p1.productId)
    end
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 118
        return "ExclusiveStorePromptController"
    end
})

self.__index = self

function self.new(...) -- line: 123
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p2) -- line: 127
    p2._castCount = 0
    p2._productIndex = 0
end

function self._isOwned(_, p4) -- line: 131
    -- upvalues: clientProducer (copy), localPlayerUserId (copy), selectPlayerOwnsGamepass (copy), selectPlayerBundlePurchaseHistory (copy), selectPlayerAquarium (copy)
    local v6 = clientProducer:getState()

    if p4.gamepassName == nil then
        if p4.bundleName == nil then
            if p4.skinName == nil then
                return false
            end

            local v7 = selectPlayerAquarium(localPlayerUserId)(v6)

            if v7 ~= nil then
                local ownedSkins = v7.ownedSkins
                local skinName = p4.skinName

                v7 = table.find(ownedSkins, skinName) ~= nil
            end

            local v8 = v7 == true

            print((("[ExclusiveStorePrompt] %* skin owned=%*"):format(p4.name, v8)))

            return v8
        end

        local v9 = selectPlayerBundlePurchaseHistory(localPlayerUserId)(v6)
        local v10 = v9 ~= nil

        if v10 then
            v10 = false

            for v11, v12 in v9 do
                local _ = v11 - 1

                if v12.bundleName == p4.bundleName then
                    v10 = true
                    break
                end

                v10 = false
            end
        end

        local name = p4.name

        if v9 ~= nil then
            v9 = #v9
        end

        if v9 == nil then
            v9 = 0
        end

        print((("[ExclusiveStorePrompt] %* bundle owned=%* historySize=%*"):format(name, v10, v9)))

        return v10
    end

    local v13 = selectPlayerOwnsGamepass(localPlayerUserId, p4.gamepassName)(v6)

    print((("[ExclusiveStorePrompt] %* gamepass owned=%* userId=%*"):format(p4.name, v13, localPlayerUserId)))

    return v13
end

function self._nextUnownedProduct(p5) -- line: 183
    -- upvalues: t1 (copy)
    local v14 = #t1

    print((("[ExclusiveStorePrompt] _nextUnownedProduct start, index=%*"):format(p5._productIndex)))

    local n1 = 0
    local v15 = false
    local v16

    while true do
        if v15 then
            n1 += 1
        else
            v15 = true
        end

        if n1 < v14 then
            v16 = t1[p5._productIndex % v14 + 1]
            p5._productIndex += 1

            if p5:_isOwned(v16) then
                print((("[ExclusiveStorePrompt] skipped owned product: %*"):format(v16.name)))
                continue
            end

            break
        end

        print("[ExclusiveStorePrompt] all products owned, skipping notification")

        return nil
    end

    print((("[ExclusiveStorePrompt] selected product: %*"):format(v16.name)))

    return v16
end

function self.onStart(p6) -- line: 210
    -- upvalues: MarketplaceService (copy), Players (copy), StarterGui (copy), events (copy), attemptStorePurchase (copy), apexSkillCheckAtom (copy), rareFishTransitionAtom (copy)
    events.reelStarted:connect(function() -- line: 211
        -- upvalues: p6 (copy), MarketplaceService (copy), Players (copy), StarterGui (copy), attemptStorePurchase (copy), apexSkillCheckAtom (copy), rareFishTransitionAtom (copy)
        if rareFishTransitionAtom() or apexSkillCheckAtom() ~= nil then
            return nil
        end

        p6._castCount += 1
        print((("[ExclusiveStorePrompt] reelStarted castCount=%*"):format(p6._castCount)))

        if p6._castCount % 3 ~= 0 then
            return nil
        end

        local v17 = p6:_nextUnownedProduct()

        if v17 == nil then
            return nil
        end

        print((("[ExclusiveStorePrompt] scheduling notification for: %* in %*s"):format(v17.name, 3)))
        task.delay(3, function() -- line: 226
            -- upvalues: v17 (copy), p6 (copy), MarketplaceService (copy), Players (copy), StarterGui (copy), attemptStorePurchase (copy)
            if p6:_isOwned(v17) then
                print((("[ExclusiveStorePrompt] %* owned at fire time, skipping"):format(v17.name)))

                return nil
            end

            local BindableFunction = Instance.new("BindableFunction")

            BindableFunction.OnInvoke = function(p7) -- line: 232
                -- upvalues: BindableFunction (copy), v17 (copy), MarketplaceService (copy), Players (copy), attemptStorePurchase (copy)
                if p7 == "Buy" and v17.productId ~= 0 then
                    if v17.isGamepass then
                        MarketplaceService:PromptGamePassPurchase(Players.LocalPlayer, v17.productId)
                    else
                        attemptStorePurchase(v17.productId)
                    end
                end

                BindableFunction:Destroy()
            end

            StarterGui:SetCore("SendNotification", {
                Title = "Get stronger now!",
                Duration = 20,
                Button1 = "Buy",
                Button2 = "Close",
                Text = ("Buy %*"):format(v17.name),
                Icon = v17.icon,
                Callback = BindableFunction
            })
        end)
    end)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/exclusive-store-prompt-controller@ExclusiveStorePromptController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    ExclusiveStorePromptController = self
}
