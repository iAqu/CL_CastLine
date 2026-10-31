-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local createRoot = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox").createRoot
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local HttpService, MarketplaceService, Players = services.HttpService, services.MarketplaceService, services.Players
local default = RuntimeLib.import(script, script.Parent.Parent, "react", "common", "reward-screen").default
local network = RuntimeLib.import(script, script.Parent.Parent, "network")
local events, functions = network.events, network.functions
local selectPendingPurchaseExtraInfo = RuntimeLib.import(script, script.Parent.Parent, "reflex", "slices", "store-purchase.selectors").selectPendingPurchaseExtraInfo
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-utils")
local getProductConfigurationByProductId, isNonCatalogStoreProductId, purchaseFinishMaxRetries, purchaseFinishRetryDelaySeconds = v1.getProductConfigurationByProductId, v1.isNonCatalogStoreProductId, v1.purchaseFinishMaxRetries, v1.purchaseFinishRetryDelaySeconds
local StoreProductType = v1.StoreProductType
local getStoreProductDisplayInfo = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-display-utils").getStoreProductDisplayInfo
local fish = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish")
local fishDataByName, isFishData = fish.fishDataByName, fish.isFishData
local getTitleData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "titles").getTitleData
local charmData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "charms").charmData
local getHologramSkinData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "hologram-skins").getHologramSkinData

local function v2(p1) -- line: 29
    return (("Purchased %* successfully!"):format(p1))
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 41
        return "StoreController"
    end
})

self.__index = self

function self.new(...) -- line: 46
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p2, p3) -- line: 50
    p2._reflexController = p3
end

function self.onStart(p4) -- line: 53
    -- upvalues: events (copy)
    p4:_setupPurchaseFinishHandlers()
    events.podiumFreePurchaseGranted:connect(function(p5, p6) -- line: 59
        -- upvalues: p4 (copy)
        p4:_applyPurchaseResult(p5, p6, false, nil)
    end)
end

function self._getProductTitle(_, p8) -- line: 63
    -- upvalues: getProductConfigurationByProductId (copy), getStoreProductDisplayInfo (copy)
    local v5 = getProductConfigurationByProductId(p8)

    return if v5.kind ~= "error" then getStoreProductDisplayInfo({
        storeProductConfiguration = v5.data
    }).title else nil
end

function self._showExclusiveFishReward(_, p10) -- line: 72
    -- upvalues: react (copy), createRoot (copy), Players (copy), default (copy), fishDataByName (copy), isFishData (copy)
    local v6 = fishDataByName[p10.fishName]

    if v6 == nil or not isFishData(v6) then
        return nil
    end

    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "ExclusiveFishRewardScreen"
    ScreenGui.DisplayOrder = 1000
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    local v7 = createRoot(ScreenGui)

    v7:render(react.createElement(default, {
        title = "EXCLUSIVE!",
        uiScale = 1,
        zIndex = 200,
        fish = v6,
        rewardBadgeText = ("#%* / %*"):format(p10.exclusiveIndex, p10.totalStock),
        onFinished = function() -- onFinished | line: 92
            -- upvalues: ScreenGui (copy), v7 (copy)
            v7:unmount()
            ScreenGui:Destroy()
        end
    }))
end

function self._showTitleReward(_, p12) -- line: 98
    -- upvalues: react (copy), createRoot (copy), Players (copy), default (copy), getTitleData (copy)
    local v8 = getTitleData(p12)

    if v8 == nil then
        return nil
    end

    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "TitleRewardScreen"
    ScreenGui.DisplayOrder = 1000
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    local v9 = createRoot(ScreenGui)

    v9:render(react.createElement(default, {
        showIcon = false,
        title = "NEW TITLE!",
        uiScale = 1,
        zIndex = 200,
        titleReward = {
            color = v8.animatedColor or v8.color,
            displayName = v8.displayName,
            perkDescription = v8.perkDescription
        },
        onFinished = function() -- onFinished | line: 121
            -- upvalues: ScreenGui (copy), v9 (copy)
            v9:unmount()
            ScreenGui:Destroy()
        end
    }))
end

function self.handlePurchaseResult(p13, p14, p15, p16) -- line: 127
    -- upvalues: Players (copy)
    p13:_applyPurchaseResult(p14, p15, p16 ~= nil, if p16 == nil then nil else Players:GetPlayerByUserId(p16))
end

function self._applyPurchaseResult(p17, p18, p19, p20, p21) -- line: 132
    -- upvalues: HttpService (copy), getProductConfigurationByProductId (copy), StoreProductType (copy), charmData (copy), getHologramSkinData (copy)
    local v10 = p17._reflexController:getClientProducer()

    if p19.kind == "error" then
        if p19.reason == "gamepassAlreadyOwned" or p19.reason == "bundleAlreadyPurchased" then
            v10.onScreenFeedbackAdded({
                type = "error",
                id = HttpService:GenerateGUID(false),
                message = p20 and "Recipient already owns this." or "Already owned."
            })
        elseif p19.reason == "recipientNotFound" then
            v10.onScreenFeedbackAdded({
                duration = 10,
                message = "Could not process as player left. Retry in Shop > Inventory",
                type = "error",
                id = HttpService:GenerateGUID(false)
            })
        elseif p19.reason == "serverLuckDuplicate" then
            v10.onScreenFeedbackAdded({
                message = "Server luck already active — you got a free use for this tier next time!",
                type = "success",
                id = HttpService:GenerateGUID(false)
            })
        else
            v10.onScreenFeedbackAdded({
                type = "error",
                id = HttpService:GenerateGUID(false),
                message = p20 and "Gift could not be sent. Please try again." or "Purchase could not be completed. Please try again."
            })
        end

        v10.purchaseExtraInfoConsumed({
            productId = p18
        })

        return nil
    end

    local v11 = p17:_getProductTitle(p18)

    if v11 == nil then
        v11 = "Item"
    end

    if not p20 then
        if p19.exclusiveFishReward ~= nil then
            p17:_showExclusiveFishReward(p19.exclusiveFishReward)
        end

        if p19.titleReward ~= nil then
            p17:_showTitleReward(p19.titleReward)
        end
    end

    local v12 = getProductConfigurationByProductId(p18)

    if not p20 then
        if v12.kind == "success" and v12.data.storeProductType == StoreProductType.Charm then
            local v13 = charmData[v12.data.charmId]

            if v13 ~= nil then
                p17:_showItemReward(v13.imageId, v13.displayName)
            end
        end

        if v12.kind == "success" and v12.data.storeProductType == StoreProductType.HologramSkin then
            local v14 = getHologramSkinData(v12.data.hologramSkinName)

            if v14 ~= nil then
                p17:_showItemReward(v14.imageId, v14.displayName)
            end
        end
    end

    local t9 = {
        id = HttpService:GenerateGUID(false)
    }

    if p20 then
        local v15 = if p21 == nil then p21 else p21.DisplayName

        if v15 == nil then
            v15 = "player"
        end

        t9.message = ("Gift sent to %*!"):format(v15)
    else
        t9.message = ("Purchased %* successfully!"):format(v11)
    end

    t9.type = "success"
    v10.onScreenFeedbackAdded(t9)
    v10.purchaseExtraInfoConsumed({
        productId = p18
    })
end

function self._showItemReward(_, p23, p24) -- line: 216
    -- upvalues: react (copy), createRoot (copy), Players (copy), default (copy)
    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "ItemRewardScreen"
    ScreenGui.DisplayOrder = 1000
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    local v16 = createRoot(ScreenGui)

    v16:render(react.createElement(default, {
        title = "NEW REWARD!",
        uiScale = 0.9,
        zIndex = 200,
        iconImage = p23,
        rewardText = p24,
        onFinished = function() -- onFinished | line: 231
            -- upvalues: ScreenGui (copy), v16 (copy)
            v16:unmount()
            ScreenGui:Destroy()
        end
    }))
end

function self._setupPurchaseFinishHandlers(p25) -- line: 237
    -- upvalues: RuntimeLib (copy), HttpService (copy), MarketplaceService (copy), Players (copy), functions (copy), getProductConfigurationByProductId (copy), isNonCatalogStoreProductId (copy), StoreProductType (copy)
    local v17 = p25._reflexController:getClientProducer()

    MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(_, p27, p28) -- line: 239
        -- upvalues: p25 (copy), v17 (copy), HttpService (copy)
        if not p28 then
            v17.purchasePromptWasCancelled({
                productId = p27
            })

            return nil
        end

        local v18 = p25:_getProductTitle(p27)

        if v18 == nil then
            v18 = "Gamepass"
        end

        v17.onScreenFeedbackAdded({
            type = "success",
            id = HttpService:GenerateGUID(false),
            message = ("Purchased %* successfully!"):format(v18)
        })
    end)
    MarketplaceService.PromptProductPurchaseFinished:Connect(function(_, p30, p31) -- line: 258
        -- upvalues: p25 (copy), v17 (copy), RuntimeLib (copy), HttpService (copy), Players (copy), functions (copy), getProductConfigurationByProductId (copy), isNonCatalogStoreProductId (copy), StoreProductType (copy)
        local pendingPurchaseRecipientUserId = v17:getState().storeGiftUi.pendingPurchaseRecipientUserId

        v17.storePurchasePromptConsumed({})

        if isNonCatalogStoreProductId(p30) then
            if p31 then
                v17.purchaseRetryFinished({
                    productId = p30
                })
            else
                v17.purchasePromptWasCancelled({
                    productId = p30
                })
            end
        else
            if p31 then
                local v19 = pendingPurchaseRecipientUserId ~= nil
                local v20 = if v19 then Players:GetPlayerByUserId((tonumber(pendingPurchaseRecipientUserId))) else nil
                local v21 = p25:_getProductTitle(p30)

                if v21 == nil then
                    v21 = "Item"
                end

                v17.onScreenFeedbackAdded({
                    type = "success",
                    id = HttpService:GenerateGUID(false),
                    message = ("Purchasing %*..."):format(v21)
                })
                v17.purchaseRetryStarted({
                    productId = p30
                })
                RuntimeLib.try(function() -- line: 313
                    -- upvalues: p30 (copy), pendingPurchaseRecipientUserId (copy), v19 (copy), v20 (copy), p25 (copy)
                    p25:_runPurchaseFinishRetryLoop(p30, v19, pendingPurchaseRecipientUserId, v20)
                end, nil, function() -- line: 315
                    -- upvalues: p30 (copy), v17 (copy)
                    v17.purchaseRetryFinished({
                        productId = p30
                    })
                end)

                return
            end

            v17.purchasePromptWasCancelled({
                productId = p30
            })

            local v22 = getProductConfigurationByProductId(p30)

            if v22.kind == "success" and v22.data.storeProductType == StoreProductType.ExclusiveFish then
                functions.cancelExclusiveFishReservation(p30)
            end
        end

        return nil
    end)
end

function self._runPurchaseFinishRetryLoop(p32, p33, p34, p35, p36) -- line: 322
    -- upvalues: RuntimeLib (copy), HttpService (copy), functions (copy), selectPendingPurchaseExtraInfo (copy), getProductConfigurationByProductId (copy), purchaseFinishMaxRetries (copy), purchaseFinishRetryDelaySeconds (copy), StoreProductType (copy)
    local v23 = p32._reflexController:getClientProducer()

    task.wait(1)

    local v24 = selectPendingPurchaseExtraInfo(p33)(v23:getState())
    local n1 = 0
    local v25, v26 = RuntimeLib.Promise.retryWithDelay(RuntimeLib.async(function() -- line: 331
        -- upvalues: p33 (copy), p34 (copy), p35 (copy), v23 (copy), v24 (copy), n1 (ref), HttpService (copy), functions (copy), getProductConfigurationByProductId (copy), purchaseFinishMaxRetries (copy), StoreProductType (copy)
        local v27 = getProductConfigurationByProductId(p33)

        if v27.kind == "error" then
            return {
                kind = "failure",
                reason = "others"
            }
        end

        local data = v27.data

        if not p34 and data.storeProductType == StoreProductType.Gamepass and data.devProductId == p33 then
            v23.onScreenFeedbackAdded({
                message = "Purchase could not be completed. Please try again.",
                type = "error",
                id = HttpService:GenerateGUID(false)
            })

            return {
                kind = "failure",
                reason = "others"
            }
        end

        local v28 = n1

        if math.floor(purchaseFinishMaxRetries / 2) <= v28 then
            v23.onScreenFeedbackAdded({
                message = "Purchase is taking longer than usual...",
                type = "success",
                id = HttpService:GenerateGUID(false)
            })
        end

        local v30 = (if p34 then functions.processGiftPurchase(p33, (tonumber(p35))) else functions.processIndividualPurchase(p33, v24)):expect()

        if v30.kind == "error" then
            n1 += 1

            if v30.reason == "serverLuckDuplicate" then
                return {
                    kind = "failure",
                    reason = "serverLuckDuplicate"
                }
            end

            if v30.reason == "gamepassAlreadyOwned" or v30.reason == "bundleAlreadyPurchased" then
                return {
                    kind = "failure",
                    reason = v30.reason
                }
            end

            if v30.reason == "recipientNotFound" then
                return {
                    kind = "failure",
                    reason = "recipientNotFound"
                }
            end

            error("[src/client/controllers/store-controller.ts:429]" .. ("Failed to process purchase: %*"):format(v30.reason))
        end

        return v30
    end), purchaseFinishMaxRetries, purchaseFinishRetryDelaySeconds):await()

    if not v25 or v26.kind ~= "success" then
        warn("[src/client/controllers/store-controller.ts:443]", v26)
    end

    local t11, v31, v32

    if v25 then
        if v26.kind == "success" then
            v32 = true
        else
            t11 = {
                kind = "error"
            }
            v31 = if v26.kind ~= "failure" or v26.reason == "others" then "unknown" else v26.reason
            v32 = false
        end
    else
        t11 = {
            kind = "error"
        }
        v31 = "unknown"
        v32 = false
    end

    if not v32 then
        v26 = t11
        t11.reason = v31
    end

    p32:_applyPurchaseResult(p33, v26, p34, p36)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/store-controller@StoreController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/reflex-controller@ReflexController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    serverLuckDuplicateMessage = "Server luck already active — you got a free use for this tier next time!",
    StoreController = self
}
