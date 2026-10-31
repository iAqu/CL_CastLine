-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useMemo, useRef = react.useMemo, react.useRef
local useCyclingSelection = RuntimeLib.import(script, script.Parent, "use-cycling-selection").useCyclingSelection

return {
    nibbleCycleIntervalFast = 0.1,
    nibbleCycleIntervalSlow = 0.3,
    useNibbleCycling = function(p1) -- useNibbleCycling | line: 9
        -- upvalues: useMemo (copy), useRef (copy), useCyclingSelection (copy)
        local bonusFishInPool = p1.bonusFishInPool
        local v1 = bonusFishInPool

        if bonusFishInPool == nil then
            v1 = false
            bonusFishInPool = false
        end

        local caughtFishName, isFishCaught, nibbleExpireTimestamp, nibblingFish = p1.caughtFishName, p1.isFishCaught, p1.nibbleExpireTimestamp, p1.nibblingFish
        local nibblingFishEntries = p1.nibblingFishEntries
        local v2 = useRef(nil)

        if nibblingFish ~= nil then
            v2.current = nibblingFish
        end

        local current = v2.current
        local v3 = useRef(nil)

        if nibblingFishEntries ~= nil and #nibblingFishEntries > 0 then
            v3.current = nibblingFishEntries
        end

        local current2 = v3.current
        local v4 = if current == nil then current else #current

        if v4 == nil then
            v4 = 0
        end

        local v5 = v4 + (if bonusFishInPool then 1 else 0)
        local v6 = useMemo(function() -- line: 43
            -- upvalues: v1 (ref), v4 (ref), v5 (copy)
            local t1 = {}

            if not (v1 and v4 > 0) then
                local n1 = 0
                local v7 = false

                while true do
                    if v7 then
                        n1 += 1
                    else
                        v7 = true
                    end

                    if n1 < v5 then
                        table.insert(t1, n1)
                        continue
                    end

                    break
                end
            else
                local n2 = 0
                local v8 = false

                while true do
                    if v8 then
                        n2 += 1
                    else
                        v8 = true
                    end

                    if n2 < v4 then
                        table.insert(t1, n2)
                        table.insert(t1, v4)
                        continue
                    end

                    break
                end
            end

            return t1
        end, { v5, v1, v4 })
        local v9 = useCyclingSelection({
            baseInterval = 0.1,
            maxInterval = 0.3,
            isActive = not isFishCaught and v5 > 1,
            items = v6,
            expireTimestamp = nibbleExpireTimestamp
        })
        local v10 = if #v6 > 0 then v6[v9 % #v6 + 1] else 0
        local v11 = not isFishCaught and v1 and v10 == v4
        local v12 = v10 % v4
        local v13 = if not isFishCaught and not v11 and current ~= nil and v4 > 0 then current[v12 + 1] else nil
        local v14

        if not isFishCaught and not v11 and current2 ~= nil and v4 > 0 then
            v14 = current2[v12 + 1]

            if v14 ~= nil then
                v14 = v14.fishId
            end
        end

        local v15

        if not isFishCaught and not v11 and current2 ~= nil and v4 > 0 then
            v15 = current2[v12 + 1]

            if v15 ~= nil then
                v15 = v15.mutations
            end

            if v15 == nil then
                v15 = {}
            end
        else
            v15 = {}
        end

        if not isFishCaught or caughtFishName == nil then
            current2 = nil
        elseif current2 ~= nil then
            local v16

            for v17, v18 in current2 do
                local _ = v17 - 1

                if v18.fishName == caughtFishName == true then
                    v16 = v18
                    break
                end

                v16 = nil
            end

            current2 = v16
        end

        local v19 = if not isFishCaught or caughtFishName == nil then nil elseif current2 ~= nil then current2.fishId else current2
        local t3 = {
            currentFish = v13,
            currentFishId = if not isFishCaught then v14 else v19,
            currentIsBonus = v11
        }

        if isFishCaught then
            local v21 = if current2 == nil then current2 else current2.mutations

            if v21 ~= nil then
                v15 = v21
            else
                v15 = {}
            end
        end

        t3.currentMutations = v15
        t3.nibbleIndex = v9

        return t3
    end
}
