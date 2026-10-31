-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useEffect, useRef, useState = react.useCallback, react.useEffect, react.useRef, react.useState
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, ReplicatedStorage, Workspace = services.Players, services.ReplicatedStorage, services.Workspace
local usePrefab = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "hooks", "use-prefab").usePrefab
local reflex = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex")
local useRootSelectorCreator, useRootSelector = reflex.useRootSelectorCreator, reflex.useRootSelector
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectCanAffordAquariumUpgrade, selectPlayerStat, selectPlayerAquariumMoneyPerSecond, selectPlayerAquariumLevel = selectors.selectCanAffordAquariumUpgrade, selectors.selectPlayerStat, selectors.selectPlayerAquariumMoneyPerSecond, selectors.selectPlayerAquariumLevel
local selectPlayerAquariumUpgradeCompleteTimestamp, selectPlayerAquariumUpgradeStartedTimestamp, selectPlayerBuffBonuses = selectors.selectPlayerAquariumUpgradeCompleteTimestamp, selectors.selectPlayerAquariumUpgradeStartedTimestamp, selectors.selectPlayerBuffBonuses
local aquariums = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquariums")
local allAquariumData, getAquariumData = aquariums.allAquariumData, aquariums.getAquariumData
local default = RuntimeLib.import(script, script.Parent, "upgrade-sign-surface-gui").default
local default2 = RuntimeLib.import(script, script.Parent, "aquarium-silhouette").default
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent, "network").functions
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local useRootProducer = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex").useRootProducer
local HttpService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").HttpService
local aquariumFlashAtom = RuntimeLib.import(script, script.Parent.Parent.Parent, "aquarium-flash-atom").aquariumFlashAtom
local getSkipAquariumUpgradeProductId = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-utils").getSkipAquariumUpgradeProductId
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent, "store-purchase-utils")
local promptCashPurchase, attemptStorePurchase = v1.promptCashPurchase, v1.attemptStorePurchase
local selectAquariumUpgradeTimeGateEnabled = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-config-snapshot.selectors").selectAquariumUpgradeTimeGateEnabled
local selectPlayerGamepasses = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerGamepasses
local calculateAquariumFishCapacity = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "aquarium-utils").calculateAquariumFishCapacity

return {
    default = function(p1) -- AquariumUpgradeSignRenderer | line: 43
        -- upvalues: react (copy), useCallback (copy), useEffect (copy), useRef (copy), useState (copy), Players (copy), ReplicatedStorage (copy), Workspace (copy), usePrefab (copy), useRootSelectorCreator (copy), useRootSelector (copy), selectCanAffordAquariumUpgrade (copy), selectPlayerStat (copy), selectPlayerAquariumMoneyPerSecond (copy), selectPlayerAquariumLevel (copy), selectPlayerAquariumUpgradeCompleteTimestamp (copy), selectPlayerAquariumUpgradeStartedTimestamp (copy), selectPlayerBuffBonuses (copy), allAquariumData (copy), getAquariumData (copy), default (copy), default2 (copy), functions (copy), abbreviate (copy), useRootProducer (copy), HttpService (copy), aquariumFlashAtom (copy), getSkipAquariumUpgradeProductId (copy), promptCashPurchase (copy), attemptStorePurchase (copy), selectAquariumUpgradeTimeGateEnabled (copy), selectPlayerGamepasses (copy), calculateAquariumFishCapacity (copy)
        local ownerUserId, plotInstance = p1.ownerUserId, p1.plotInstance
        local v2 = useRef(nil)
        local v3, v4 = useState(nil)
        local v5 = useRootProducer()
        local v6 = tostring(ownerUserId)
        local v7 = tostring(Players.LocalPlayer.UserId)
        local v8 = useRootSelectorCreator(selectCanAffordAquariumUpgrade, v6)
        local v9 = useRootSelectorCreator(selectAquariumUpgradeTimeGateEnabled, v6)
        local v10 = useRootSelectorCreator(selectPlayerGamepasses, v6)
        local v11 = useRootSelector(selectPlayerStat(v7, "money"))

        if v11 == nil then
            v11 = 0
        end

        local v12 = useRootSelector(selectPlayerAquariumMoneyPerSecond(v7))
        local v13 = useRootSelectorCreator(selectPlayerAquariumLevel, v6)
        local v14 = useRootSelectorCreator(selectPlayerAquariumUpgradeCompleteTimestamp, v6)
        local v15 = useRootSelectorCreator(selectPlayerAquariumUpgradeStartedTimestamp, v6)
        local moneyDiscount = useRootSelector(selectPlayerBuffBonuses(v7)).moneyDiscount
        local v16 = v13 + 1
        local v17 = getAquariumData(v13)
        local v18 = getAquariumData(v16)
        local v19 = #allAquariumData < v16
        local v20 = v8 and v13 > 1
        local v22 = math.floor(v17.upgradeCost * (1 - moneyDiscount))

        usePrefab({
            getPrefabInstance = useCallback(function() -- line: 70
                -- upvalues: ReplicatedStorage (copy)
                local PlotStuff = ReplicatedStorage:FindFirstChild("PlotStuff")

                if PlotStuff ~= nil then
                    PlotStuff = PlotStuff:FindFirstChild("AquariumUpgradeSign")
                end

                return PlotStuff
            end, {}),
            onPrefabInstantiated = useCallback(function(p2) -- line: 77
                -- upvalues: ownerUserId (copy), plotInstance (copy), v2 (copy), v4 (copy), Workspace (copy)
                p2:SetAttribute("ownerUserId", (tostring(ownerUserId)))
                p2.Parent = Workspace

                local BoundingBox, BoundingBox2 = p2:GetBoundingBox()
                local Pivot = p2:GetPivot()
                local WorldCFrame = plotInstance.UpgradeAquariumSignPos.WorldCFrame
                local WorldCFramePosition = WorldCFrame.Position
                local v25 = BoundingBox.Position.Y - BoundingBox2.Y / 2
                local v26 = WorldCFramePosition.Y + (Pivot.Position.Y - v25)

                p2:PivotTo(CFrame.new(WorldCFramePosition.X, v26, WorldCFramePosition.Z) * WorldCFrame.Rotation)
                v2.current = p2
                v4(p2.BillboardPart)
            end, { ownerUserId, plotInstance }),
            parent = plotInstance
        })

        local v27 = v15 ~= nil
        local v28 = v27 and v14 ~= nil and v14 <= Workspace:GetServerTimeNow()
        local v29 = tostring(Players.LocalPlayer.UserId) == v6

        useEffect(function() -- line: 102
            -- upvalues: v5 (copy), v9 (copy), v16 (copy), v27 (copy), v29 (copy), functions (copy), HttpService (copy), aquariumFlashAtom (copy)
            if not v27 then
                return nil
            end

            if not v9 and v29 then
                functions.confirmAquariumUpgrade():andThen(function(p3) -- line: 107
                    -- upvalues: v5 (copy), v16 (copy), HttpService (copy), aquariumFlashAtom (copy)
                    if p3 then
                        aquariumFlashAtom(true)
                        v5.onScreenFeedbackAdded({
                            type = "success",
                            id = HttpService:GenerateGUID(false),
                            message = ("Aquarium upgraded to level %*!"):format(v16)
                        })
                    end
                end)
            end
        end, { v27 })
        useEffect(function() -- line: 120
            -- upvalues: v2 (copy), v13 (copy), v27 (copy), v29 (copy), v28 (copy), getSkipAquariumUpgradeProductId (copy), attemptStorePurchase (copy)
            if not (v2.current and v29) or not v27 or v28 then
                return nil
            end

            local v30 = getSkipAquariumUpgradeProductId(v13)

            if v30 == nil then
                return nil
            end

            local ProximityPrompt = Instance.new("ProximityPrompt")

            ProximityPrompt.ActionText = "SKIP WAIT!"
            ProximityPrompt.ObjectText = ""
            ProximityPrompt.MaxActivationDistance = 12
            ProximityPrompt.HoldDuration = 0
            ProximityPrompt.RequiresLineOfSight = false
            ProximityPrompt.Parent = v2.current.BillboardPart

            local connection = ProximityPrompt.Triggered:Connect(function() -- line: 138
                -- upvalues: v30 (copy), attemptStorePurchase (copy)
                attemptStorePurchase(v30)
            end)

            return function() -- line: 141
                -- upvalues: ProximityPrompt (copy), connection (copy)
                connection:Disconnect()
                ProximityPrompt:Destroy()
            end
        end, { v27, v28, v29, v13 })

        local v31 = useCallback(function() -- line: 146
            -- upvalues: v13 (copy), v29 (copy), getSkipAquariumUpgradeProductId (copy), attemptStorePurchase (copy)
            if not v29 then
                return nil
            end

            local v32 = getSkipAquariumUpgradeProductId(v13)

            if v32 == nil then
                return nil
            end

            attemptStorePurchase(v32)
        end, { v29, v13 })

        if not v3 then
            return react.createElement(react.Fragment)
        end

        local createElement, Fragment = react.createElement, react.Fragment
        local v33 = v27 and v9 and react.createElement(default2, {
            aquariumLevel = v13,
            plotInstance = plotInstance
        })

        if not v29 then
            return createElement(Fragment, nil, v33, v29)
        end

        local createElement2 = react.createElement
        local t1 = {
            title = "FISH CAPACITY",
            adornPart = v3,
            aquariumUpgradeCompleteTimestamp = if v9 then v14 else nil,
            aquariumUpgradeStartedTimestamp = if not v9 then nil else v15,
            currentValue = calculateAquariumFishCapacity(v17.maxFish, v10),
            isGlowing = v20,
            isMaxed = v19,
            newValue = calculateAquariumFishCapacity(v18.maxFish, v10),
            onConfirm = function() -- onConfirm | line: 170
                -- upvalues: v5 (copy), v16 (copy), functions (copy), HttpService (copy), aquariumFlashAtom (copy)
                functions.confirmAquariumUpgrade():andThen(function(p4) -- line: 171
                    -- upvalues: v5 (copy), v16 (copy), HttpService (copy), aquariumFlashAtom (copy)
                    if p4 then
                        aquariumFlashAtom(true)
                        v5.onScreenFeedbackAdded({
                            type = "success",
                            id = HttpService:GenerateGUID(false),
                            message = ("Aquarium upgraded to level %*!"):format(v16)
                        })
                    end
                end)
            end,
            onSkipWait = if v28 then nil else v31
        }
        local v35 = v11

        function t1.onUpgrade() -- line: 183
            -- upvalues: v5 (copy), v12 (copy), v22 (copy), v35 (copy), functions (copy), HttpService (copy), promptCashPurchase (copy)
            if v35 < v22 then
                v5.onScreenFeedbackAdded({
                    message = "Not enough money!",
                    type = "error",
                    id = HttpService:GenerateGUID(false)
                })
                promptCashPurchase(v22, v12)

                return nil
            end

            functions.upgradeAquarium():andThen(function(p5) -- line: 193
                -- upvalues: v5 (copy), HttpService (copy)
                if p5 then
                    v5.onScreenFeedbackAdded({
                        message = "Aquarium upgrade started!",
                        type = "success",
                        id = HttpService:GenerateGUID(false)
                    })
                end
            end)
        end

        t1.price = ("$%*"):format((abbreviate(v22)))

        return createElement(Fragment, nil, v33, (createElement2(default, t1)))
    end
}
