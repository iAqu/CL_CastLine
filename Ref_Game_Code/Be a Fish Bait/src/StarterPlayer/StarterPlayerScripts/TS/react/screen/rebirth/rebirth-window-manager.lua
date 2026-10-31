-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useEffect, useRef, useState = react.useCallback, react.useEffect, react.useRef, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local HttpService, MarketplaceService = services.HttpService, services.MarketplaceService
local rebirthCelebrationAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "rebirth-celebration-atom").rebirthCelebrationAtom
local attemptStorePurchase = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "store-purchase-utils").attemptStorePurchase
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerStat, selectPlayerRebirthCount = selectors.selectPlayerStat, selectors.selectPlayerRebirthCount
local getRebirthEntry = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "rebirth-utils").getRebirthEntry
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-utils")
local getSkipRebirthProductId, getRebirthSkipRobuxPrice = v1.getSkipRebirthProductId, v1.getRebirthSkipRobuxPrice
local v2 = RuntimeLib.import(script, script.Parent, "rebirth-window")
local default, RebirthSuccessCelebration, rebirthTextDelaySec = v2.default, v2.RebirthSuccessCelebration, v2.rebirthTextDelaySec
local t1 = {}

local function triggerRebirthCelebration() -- line: 32
    -- upvalues: rebirthCelebrationAtom (copy), t1 (copy)
    warn("[rebirthwindowmanager]")

    local n1 = 0

    for _ in t1 do
        n1 += 1
    end

    print((("[Rebirth] triggerRebirthCelebration called, listener count: %*"):format(n1)))
    rebirthCelebrationAtom(function(p1) -- line: 41
        return p1 + 1
    end)

    local function v3(p2) -- line: 45
        return p2()
    end

    for v4 in t1 do
        v4()
    end
end

local function WhiteFlash(p3) -- line: 53
    -- upvalues: react (copy), useEffect (copy), useMotion (copy)
    local onDone = p3.onDone
    local v5, v6 = useMotion(0)

    useEffect(function() -- line: 56
        -- upvalues: onDone (copy), v6 (copy)
        v6:linear(1, {
            speed = 3.5
        })

        local v7 = task.delay(0.5, function() -- line: 60
            -- upvalues: onDone (copy)
            return onDone()
        end)

        return function() -- line: 63
            -- upvalues: v7 (copy)
            return task.cancel(v7)
        end
    end, { onDone, v6 })

    return react.createElement("frame", {
        Active = false,
        BorderSizePixel = 0,
        ZIndex = 500,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = v5,
        Size = UDim2.fromScale(1, 1)
    })
end

local function RebirthCelebrationOverlay() -- line: 76
    -- upvalues: react (copy), useCallback (copy), useState (copy), RebirthSuccessCelebration (copy), rebirthTextDelaySec (copy), t1 (copy), WhiteFlash (copy)
    local v8, v9 = useState(false)
    local v10, v11 = useState(false)
    local v12 = useCallback(function() -- line: 79
        -- upvalues: v9 (copy), v11 (copy), rebirthTextDelaySec (copy)
        print((("[Rebirth] trigger callback fired, scheduling celebration after %*s"):format(rebirthTextDelaySec)))
        v11(true)
        task.delay(rebirthTextDelaySec, function() -- line: 82
            -- upvalues: v9 (copy)
            print("[Rebirth] delay elapsed, setShowCelebration(true)")
            v9(true)
        end)
    end, {})

    react.useEffect(function() -- line: 87
        -- upvalues: v12 (copy), t1 (copy)
        print("[Rebirth] RebirthCelebrationOverlay mounted, registering trigger")
        t1[v12] = true

        return function() -- line: 90
            -- upvalues: v12 (copy), t1 (copy)
            print("[Rebirth] RebirthCelebrationOverlay unmounted, removing trigger")
            t1[v12] = nil
        end
    end, { v12 })
    print((("[Rebirth] RebirthCelebrationOverlay render, showCelebration=%*"):format(v8)))

    local createElement, Fragment = react.createElement, react.Fragment

    v10 = v10 and react.createElement(WhiteFlash, {
        onDone = function() -- onDone | line: 97
            -- upvalues: v11 (copy)
            return v11(false)
        end
    })
    v8 = v8 and react.createElement(RebirthSuccessCelebration, {
        onDone = function() -- onDone | line: 101
            -- upvalues: v9 (copy)
            return v9(false)
        end
    })

    return createElement(Fragment, nil, v10, v8)
end

local function RebirthReadyNotifier() -- line: 106
    -- upvalues: react (copy), useEffect (copy), useRef (copy), HttpService (copy), useRootProducer (copy), useRootSelector (copy), localPlayerUserId (copy), selectPlayerStat (copy), selectPlayerRebirthCount (copy), getRebirthEntry (copy)
    local v13 = useRootProducer()
    local v14 = useRootSelector(selectPlayerStat(localPlayerUserId, "power"))

    if v14 == nil then
        v14 = 0
    end

    local v16 = getRebirthEntry((useRootSelector(selectPlayerRebirthCount(localPlayerUserId)))).powerCost <= v14
    local v17 = useRef(nil)

    useEffect(function() -- line: 117
        -- upvalues: v13 (copy), v17 (copy), v16 (copy), HttpService (copy)
        local current = v17.current

        v17.current = v16

        if current == false and v16 then
            v13.onScreenFeedbackAdded({
                message = "You can rebirth!",
                type = "success",
                id = HttpService:GenerateGUID(false)
            })
        end
    end, { v16, v13 })

    return react.createElement(react.Fragment)
end

return {
    triggerRebirthCelebration = triggerRebirthCelebration,
    RebirthCelebrationOverlay = RebirthCelebrationOverlay,
    RebirthReadyNotifier = RebirthReadyNotifier,
    default = function() -- RebirthWindowManager | line: 130
        -- upvalues: react (copy), useCallback (copy), HttpService (copy), MarketplaceService (copy), attemptStorePurchase (copy), useRootProducer (copy), useRootSelector (copy), localPlayerUserId (copy), selectPlayerRebirthCount (copy), functions (copy), getSkipRebirthProductId (copy), getRebirthSkipRobuxPrice (copy), default (copy), triggerRebirthCelebration (copy)
        local v18 = useRootProducer()
        local v19 = useRootSelector(selectPlayerRebirthCount(localPlayerUserId))

        if v19 == nil then
            v19 = 0
        end

        local v20 = useCallback(function() -- line: 137
            -- upvalues: v18 (copy)
            v18.windowClosed({})
        end, { v18 })
        local v21 = useCallback(function() -- line: 140
            -- upvalues: v18 (copy), functions (copy), triggerRebirthCelebration (copy)
            print("[Rebirth] onRebirth called, firing performRebirth")
            functions.performRebirth():andThen(function(p4) -- line: 142
                -- upvalues: v18 (copy), triggerRebirthCelebration (copy)
                print((("[Rebirth] performRebirth resolved, success=%*"):format(p4)))

                if p4 ~= true then
                    return nil
                end

                v18.windowClosed({})
                triggerRebirthCelebration()
            end)
        end, { v18 })
        local v22 = useCallback(function() -- line: 151
            -- upvalues: v18 (copy), HttpService (copy)
            v18.onScreenFeedbackAdded({
                message = "Not enough power!",
                type = "error",
                id = HttpService:GenerateGUID(false)
            })
        end, { v18 })
        local v23 = useCallback(function() -- line: 158
            -- upvalues: v18 (copy), v19 (ref), MarketplaceService (copy), attemptStorePurchase (copy), functions (copy), getSkipRebirthProductId (copy), triggerRebirthCelebration (copy)
            local v24 = v19 + 1
            local v25 = getSkipRebirthProductId(v24)

            if v25 == nil then
                return nil
            end

            local connection

            connection = MarketplaceService.PromptProductPurchaseFinished:Connect(function(_, p6, p7) -- line: 165
                -- upvalues: v24 (copy), v25 (copy), connection (ref), v18 (copy), functions (copy), triggerRebirthCelebration (copy)
                if p6 ~= v25 then
                    return nil
                end

                connection:Disconnect()

                if not p7 then
                    return nil
                end

                functions.skipRebirth(v24):andThen(function(p8) -- line: 173
                    -- upvalues: v18 (copy), triggerRebirthCelebration (copy)
                    if p8 ~= true then
                        return nil
                    end

                    v18.windowClosed({})
                    triggerRebirthCelebration()
                end)
            end)
            attemptStorePurchase(v25)
        end, { v18, v19 })
        local v26 = getRebirthSkipRobuxPrice(v19 + 1)

        return react.createElement(default, {
            onClose = v20,
            onRebirth = v21,
            onRebirthFailed = v22,
            onSkipRebirth = v23,
            skipRobuxPrice = v26
        })
    end
}
