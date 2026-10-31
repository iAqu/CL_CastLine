-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useMemo, useRef, useState = react.useEffect, react.useMemo, react.useRef, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent, "fish-roll-item").default
local useNibbleCycling = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-nibble-cycling").useNibbleCycling
local useConfig = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "config-context").useConfig

return {
    default = function(p1) -- FishRollGui | line: 18
        -- upvalues: react (copy), useEffect (copy), useMemo (copy), useRef (copy), useState (copy), useMotion (copy), default (copy), useNibbleCycling (copy), useConfig (copy)
        local bonusComboCount = p1.bonusComboCount
        local v1 = bonusComboCount

        if bonusComboCount == nil then
            v1 = 0
        end

        local bonusFishInPool = p1.bonusFishInPool

        if bonusFishInPool == nil then
            bonusFishInPool = false
        end

        local bonusItemGap = p1.bonusItemGap
        local v2 = bonusItemGap

        if bonusItemGap == nil then
            v2 = 0.025
        end

        local caughtFish, nibbleExpireTimestamp = p1.caughtFish, p1.nibbleExpireTimestamp

        if nibbleExpireTimestamp == nil then
            nibbleExpireTimestamp = 0
        end

        local nibblingFish = p1.nibblingFish
        local getSound = useConfig().getSound
        local v3, v4 = useMotion(0)
        local v5, v6 = useState({})
        local v7 = useRef({})

        v7.current = v5

        local v8, v9 = useMotion(0)
        local v10, v11 = useState(false)
        local v12 = useRef(0)
        local v13 = useRef(nil)
        local v14 = caughtFish ~= nil
        local v15 = useNibbleCycling({
            bonusFishInPool = bonusFishInPool,
            isFishCaught = v14,
            nibbleExpireTimestamp = nibbleExpireTimestamp,
            nibblingFish = nibblingFish
        })
        local currentFish, currentIsBonus, nibbleIndex = v15.currentFish, v15.currentIsBonus, v15.nibbleIndex

        useRef(currentFish).current = currentFish

        local v16 = useRef(-1)

        useEffect(function() -- line: 60
            -- upvalues: getSound (copy), v14 (copy), nibbleIndex (copy), v16 (copy)
            if v14 or nibbleIndex == v16.current then
                return nil
            end

            v16.current = nibbleIndex
            getSound("FishNibble"):Play()
        end, { nibbleIndex, v14, getSound })

        local v17 = #v5 - 1

        useEffect(function() -- line: 72
            -- upvalues: v1 (ref), v6 (copy), v7 (copy), v12 (copy)
            local current = v12.current

            v12.current = v1

            if v1 <= current then
                return nil
            end

            local t1 = {}

            for _, v18 in v7.current do
                table.insert(t1, v18)
            end

            if #t1 > 0 then
                local v19 = t1[#t1]

                t1[#t1] = {
                    lockedAsBonusFish = true,
                    lockedFish = nil,
                    key = v19.key
                }
            end

            if v1 < 3 then
                table.insert(t1, {
                    lockedAsBonusFish = false,
                    lockedFish = nil,
                    key = v1
                })
            end

            v6(t1)
        end, { v1 })
        useEffect(function() -- line: 102
            -- upvalues: caughtFish (copy), v6 (copy), v7 (copy), v13 (copy)
            local current = v13.current

            v13.current = caughtFish

            if caughtFish == nil or current ~= nil then
                return nil
            end

            local t3 = {}

            for _, v20 in v7.current do
                table.insert(t3, v20)
            end

            if #t3 > 0 then
                local v21 = t3[#t3]

                t3[#t3] = {
                    lockedAsBonusFish = false,
                    key = v21.key,
                    lockedFish = caughtFish
                }
            end

            v6(t3)
        end, { caughtFish })
        useEffect(function() -- line: 124
            -- upvalues: v9 (copy), v11 (copy), v14 (copy)
            if v14 then
                v9:spring(1, {
                    tension = 200,
                    friction = 22
                })

                local v22 = task.delay(0.5, function() -- line: 134
                    -- upvalues: v11 (copy)
                    return v11(true)
                end)

                return function() -- line: 137
                    -- upvalues: v22 (copy)
                    return task.cancel(v22)
                end
            end

            v9:set(0)
            v11(false)

            return nil
        end, { v14, v9 })
        useEffect(function() -- line: 142
            -- upvalues: v2 (ref), v4 (copy), v5 (copy), v14 (copy)
            local v23 = 0.075 + v2
            local v24 = #v5

            v4:spring(if v14 then v24 * v23 else v24 * v23 / 2, {
                tension = 200,
                friction = 22
            })
        end, { v5, v2, v4, v14 })

        local v26 = useMemo(function() -- line: 151
            -- upvalues: v3 (copy)
            return v3:map(function(p2) -- line: 152
                return UDim2.fromScale(0.5 - p2, 0.08499999999999999)
            end)
        end, { v3 })
        local v27 = #v5 > 0
        local v28 = v14 and #v5 == 0
        local v29 = if v27 then true else nil
        local caughtFish2 = if v28 then caughtFish else nil
        local v30 = if not (v14 and #v5 >= 1) then nil else v8
        local createElement, default2, t4, currentFish2, v31

        if not v10 or #v5 == 0 then
            createElement = react.createElement
            default2 = default
            t4 = {}
            t4.anchorPoint = Vector2.new(0.5, 0.5)
            t4.finalFishData = caughtFish2
            t4.finalIsBonus = v29
            t4.position = v26

            if not v27 and not v28 and not currentIsBonus then
                currentFish2 = currentFish
            end

            t4.rollingFishData = currentFish2

            if v27 or v28 then
                t4.rollingIsBonus = false
            else
                t4.rollingIsBonus = currentIsBonus
            end

            t4.transparency = v30
            v31 = createElement(default2, t4)
        else
            v31 = false
        end

        local v33 = table.create(#v5)

        local function v34(p3, p4) -- line: 172
            -- upvalues: v2 (ref), v3 (copy), v8 (copy), v10 (copy), v14 (copy), currentFish (copy), currentIsBonus (copy), v17 (copy), react (copy), default (copy)
            local v35 = p4 == v17
            local v36 = 0.075 + v2
            local v37 = v3:map(function(p5) -- line: 175
                -- upvalues: p4 (copy), v36 (copy)
                return UDim2.fromScale(0.5 - p5 + (p4 + 1) * v36, 0.08499999999999999)
            end)
            local v38 = if not v14 or v35 then nil else v8

            if v10 and not v35 then
                return react.createElement(react.Fragment)
            end

            return react.createElement(default, {
                anchorPoint = Vector2.new(0.5, 0.5),
                finalFishData = p3.lockedFish,
                finalIsBonus = if p3.lockedAsBonusFish then true else nil,
                key = tostring(p3.key),
                position = v37,
                rollingFishData = if not p3.lockedAsBonusFish and p3.lockedFish == nil and not currentIsBonus then currentFish else nil,
                rollingIsBonus = not p3.lockedAsBonusFish and p3.lockedFish == nil and currentIsBonus,
                transparency = v38
            })
        end

        for v39, v40 in v5 do
            v33[v39] = v34(v40, v39 - 1, v5)
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1)
        }, v31, v33)
    end
}
