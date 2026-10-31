-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef = react.useEffect, react.useRef
local createPortal = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox").createPortal
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local useNibbleCycling = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-nibble-cycling").useNibbleCycling
local reflex = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelectorCreator = reflex.useRootProducer, reflex.useRootSelectorCreator
local useConfig = RuntimeLib.import(script, script.Parent.Parent, "context", "config-context").useConfig
local default = RuntimeLib.import(script, script.Parent.Parent, "screen", "fishing", "fish-roll-item").default
local selectInventoryFishMutations = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectInventoryFishMutations
local v1 = UDim2.new(3.6923076923076925, 0, 4.923076923076923, 0)
local v2 = tostring(Players.LocalPlayer.UserId)

return {
    default = function(p1) -- FishNibbleBillboard | line: 18
        -- upvalues: react (copy), useEffect (copy), useRef (copy), createPortal (copy), useNibbleCycling (copy), useRootProducer (copy), useRootSelectorCreator (copy), useConfig (copy), default (copy), selectInventoryFishMutations (copy), v1 (copy), v2 (copy)
        local adornee, bonusChosen = p1.adornee, p1.bonusChosen

        if bonusChosen == nil then
            bonusChosen = false
        end

        local bonusFishInPool = p1.bonusFishInPool

        if bonusFishInPool == nil then
            bonusFishInPool = false
        end

        local caughtFish, caughtFishMutations, keepObscured = p1.caughtFish, p1.caughtFishMutations, p1.keepObscured

        if keepObscured == nil then
            keepObscured = false
        end

        local nibbleExpireTimestamp = p1.nibbleExpireTimestamp

        if nibbleExpireTimestamp == nil then
            nibbleExpireTimestamp = 0
        end

        local nibblingFish, nibblingFishEntries, rollingFishData, rollingIsBonus = p1.nibblingFish, p1.nibblingFishEntries, p1.rollingFishData, p1.rollingIsBonus

        if rollingIsBonus == nil then
            rollingIsBonus = false
        end

        local v3 = caughtFish ~= nil
        local v4 = useRootProducer()
        local getSound = useConfig().getSound
        local t1 = {
            bonusFishInPool = bonusFishInPool
        }

        t1.caughtFishName = if caughtFish == nil then caughtFish else caughtFish.name
        t1.isFishCaught = v3
        t1.nibbleExpireTimestamp = nibbleExpireTimestamp
        t1.nibblingFish = nibblingFish
        t1.nibblingFishEntries = nibblingFishEntries

        local v5 = useNibbleCycling(t1)
        local currentFish, currentFishId, currentIsBonus, currentMutations = v5.currentFish, v5.currentFishId, v5.currentIsBonus, v5.currentMutations
        local nibbleIndex = v5.nibbleIndex

        useEffect(function() -- line: 68
            -- upvalues: caughtFish (copy), v4 (copy), currentFish (copy), currentFishId (copy), v3 (copy)
            local v6 = if v3 then caughtFish else currentFish

            if v6 ~= nil then
                v6 = v6.name
            end

            print((("[NibbleBillboard] isFishCaught=%* name=%* currentFishId=%*"):format(v3, v6, currentFishId)))
            v4.nibbleActiveFishSet({
                fishId = currentFishId
            })

            return function() -- line: 88
                -- upvalues: v4 (copy)
                v4.nibbleActiveFishSet({
                    fishId = nil
                })
            end
        end, { currentFishId, v4 })

        local v7 = useRef(-1)

        useEffect(function() -- line: 95
            -- upvalues: getSound (copy), nibbleIndex (copy), v7 (copy), v3 (copy)
            print((("[FishNibble] nibbleIndex=%* isFishCaught=%* prev=%*"):format(nibbleIndex, v3, v7.current)))

            if v3 or nibbleIndex == v7.current then
                return nil
            end

            v7.current = nibbleIndex
            print("[FishNibble] playing")
            getSound("FishNibble"):Play()
        end, { nibbleIndex, v3, getSound })

        local v8 = rollingFishData or currentFish

        if rollingFishData ~= nil then
            currentIsBonus = rollingIsBonus
        end

        local v9 = useRef({
            fish = nil,
            isBonus = false
        })

        if (v8 ~= nil or currentIsBonus) and not v3 then
            v9.current = {
                fish = v8,
                isBonus = currentIsBonus
            }
        end

        local v10

        if v3 then
            currentIsBonus = false
        else
            v10 = v8 or v9.current.fish
            currentIsBonus = currentIsBonus or not v8 and v9.current.isBonus
        end

        local v12 = useRootSelectorCreator(selectInventoryFishMutations, v2, if currentFishId == nil then "" else currentFishId)

        if v3 then
            currentMutations = caughtFishMutations or currentMutations
        else
            if not (#currentMutations > 0) then
                currentMutations = v12 or {}
            end

            if v10 == nil and not currentIsBonus then
                return react.createElement(react.Fragment)
            end
        end

        if keepObscured then
            return react.createElement(react.Fragment)
        end

        return createPortal(react.createElement("billboardgui", {
            AlwaysOnTop = true,
            LightInfluence = 0,
            MaxDistance = 80,
            StudsOffsetWorldSpace = Vector3.new(0, 3, 0),
            Size = v1
        }, react.createElement(default, {
            anchorPoint = Vector2.new(0.5, 0.5),
            finalFishData = caughtFish,
            finalIsBonus = bonusChosen,
            finalMutations = currentMutations,
            key = nibbleExpireTimestamp,
            position = UDim2.fromScale(0.5, 0.5),
            rollingFishData = v10,
            rollingIsBonus = currentIsBonus,
            rollingMutations = currentMutations,
            size = UDim2.fromScale(1, 1)
        })), adornee)
    end
}
