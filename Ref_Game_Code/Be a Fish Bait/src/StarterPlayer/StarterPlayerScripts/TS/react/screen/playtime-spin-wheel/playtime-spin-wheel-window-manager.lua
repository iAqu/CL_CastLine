-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useMemo = react.useMemo
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local attemptStorePurchase = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "store-purchase-utils").attemptStorePurchase
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector, useRootSelectorCreator = reflex.useRootProducer, reflex.useRootSelector, reflex.useRootSelectorCreator
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerAquarium, selectPlayerStat, selectPlayerUnlockedTitles = selectors.selectPlayerAquarium, selectors.selectPlayerStat, selectors.selectPlayerUnlockedTitles
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "playtime-spin-wheel-config")
local getPlaytimeSpinWheelSegmentById, jurassicDuplicateTimeSkipSeconds, monarchDuplicateTimeSkipSeconds, playtimeSpinWheelSegments = v1.getPlaytimeSpinWheelSegmentById, v1.jurassicDuplicateTimeSkipSeconds, v1.monarchDuplicateTimeSkipSeconds, v1.playtimeSpinWheelSegments
local getPlaytimeWheelExtraSpinProductId = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-utils").getPlaytimeWheelExtraSpinProductId
local default = RuntimeLib.import(script, script.Parent, "playtime-spin-wheel-window").default

return {
    default = function() -- PlaytimeSpinWheelWindowManager | line: 24
        -- upvalues: RuntimeLib (copy), react (copy), useMemo (copy), Players (copy), functions (copy), attemptStorePurchase (copy), useRootProducer (copy), useRootSelector (copy), useRootSelectorCreator (copy), selectPlayerAquarium (copy), selectPlayerStat (copy), selectPlayerUnlockedTitles (copy), getPlaytimeSpinWheelSegmentById (copy), jurassicDuplicateTimeSkipSeconds (copy), monarchDuplicateTimeSkipSeconds (copy), playtimeSpinWheelSegments (copy), getPlaytimeWheelExtraSpinProductId (copy), default (copy)
        local v2 = useRootProducer()
        local v3 = tostring(Players.LocalPlayer.UserId)
        local v4 = useRootSelectorCreator(selectPlayerAquarium, v3)
        local v5 = if v4 == nil then v4 else v4.moneyPerSecond

        if v5 == nil then
            v5 = 0
        end

        local v6 = useRootSelector(selectPlayerStat(v3, "spinWheelSpins"))

        if v6 == nil then
            v6 = 0
        end

        local v7 = useRootSelector(selectPlayerUnlockedTitles(v3))
        local v19 = useMemo(function() -- line: 43
            -- upvalues: v4 (copy), v7 (copy), jurassicDuplicateTimeSkipSeconds (copy), monarchDuplicateTimeSkipSeconds (copy), playtimeSpinWheelSegments (copy)
            local v9 = table.find(v7, "monarch") ~= nil
            local v10 = v4

            if v4 ~= nil then
                v10 = table.find(v4.ownedSkins, "Jurassic") ~= nil
            end

            local v11 = v10 == true
            local v12 = table.create(#playtimeSpinWheelSegments)

            local function v13(p1) -- line: 52
                -- upvalues: v11 (copy), v9 (copy), jurassicDuplicateTimeSkipSeconds (copy), monarchDuplicateTimeSkipSeconds (copy)
                if v9 and p1.reward.kind == "title" and p1.reward.titleId == "monarch" then
                    local v14 = table.clone(p1)

                    setmetatable(v14, nil)
                    v14.reward = {
                        kind = "timeSkip",
                        seconds = monarchDuplicateTimeSkipSeconds
                    }

                    return v14
                end

                if not v11 or p1.reward.kind ~= "aquariumSkin" or p1.reward.skinName ~= "Jurassic" then
                    return p1
                end

                local v15 = table.clone(p1)

                setmetatable(v15, nil)
                v15.reward = {
                    kind = "timeSkip",
                    seconds = jurassicDuplicateTimeSkipSeconds
                }

                return v15
            end

            for v16, v17 in playtimeSpinWheelSegments do
                v12[v16] = v13(v17, v16 - 1, playtimeSpinWheelSegments)
            end

            return v12
        end, {
            if v4 == nil then v4 else v4.ownedSkins,
            v7
        })

        return react.createElement(default, {
            onBuyFiveSpinsRequested = function() -- onBuyFiveSpinsRequested | line: 85
                -- upvalues: attemptStorePurchase (copy), getPlaytimeWheelExtraSpinProductId (copy)
                local v20 = getPlaytimeWheelExtraSpinProductId(5)

                if v20 ~= nil then
                    attemptStorePurchase(v20)
                end
            end,
            onBuyOneSpinRequested = function() -- onBuyOneSpinRequested | line: 91
                -- upvalues: attemptStorePurchase (copy), getPlaytimeWheelExtraSpinProductId (copy)
                local v21 = getPlaytimeWheelExtraSpinProductId(1)

                if v21 ~= nil then
                    attemptStorePurchase(v21)
                end
            end,
            onClose = function() -- onClose | line: 97
                -- upvalues: v2 (copy)
                return v2.windowClosed({})
            end,
            onSpinRequested = RuntimeLib.async(function() -- line: 100
                -- upvalues: RuntimeLib (copy), functions (copy), getPlaytimeSpinWheelSegmentById (copy)
                local v22 = RuntimeLib.await(functions.spinPlaytimeWheel())

                if v22 ~= false then
                    local v23 = getPlaytimeSpinWheelSegmentById(v22.segmentId)

                    if v23 then
                        return {
                            cashAmount = v22.cashAmount,
                            fishName = v22.fishName,
                            replacementTimeSkipSeconds = v22.replacementTimeSkipSeconds,
                            segment = v23,
                            skinName = v22.skinName,
                            titleId = v22.titleId
                        }
                    end
                end

                return nil
            end),
            segmentsOverride = v19,
            spinCount = v6,
            totalMps = v5
        })
    end
}
