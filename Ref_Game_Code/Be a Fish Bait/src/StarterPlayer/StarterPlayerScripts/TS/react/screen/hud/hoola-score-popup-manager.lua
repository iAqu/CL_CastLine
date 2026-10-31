-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useEffect, useRef, useState = react.useCallback, react.useEffect, react.useRef, react.useState
local flightTriggerGateScorePopup = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "flight-trigger-gate-events").flightTriggerGateScorePopup
local default = RuntimeLib.import(script, script.Parent, "hoola-score-popup").default
local flightGateFXConfig = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "flight-gate-fx-config").flightGateFXConfig
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local useRootSelectorCreator = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelectorCreator
local selectPlayerFishingState = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "fishing-state.selectors").selectPlayerFishingState
local v1 = tostring(Players.LocalPlayer.UserId)

local function randomBetween(p1) -- line: 16
    return p1.X + math.random() * (p1.Y - p1.X)
end

return {
    default = function() -- HoolaScorePopupManager | line: 20
        -- upvalues: react (copy), useCallback (copy), useEffect (copy), useRef (copy), useState (copy), flightTriggerGateScorePopup (copy), default (copy), flightGateFXConfig (copy), useRootSelectorCreator (copy), selectPlayerFishingState (copy), v1 (copy)
        local v2, v3 = useState({})
        local v4 = useRootSelectorCreator(selectPlayerFishingState, v1)
        local v5 = useRef(0)
        local scorePopupVFX = flightGateFXConfig.scorePopupVFX

        useEffect(function() -- line: 25
            -- upvalues: v3 (copy), v4 (copy), v5 (copy), scorePopupVFX (copy), flightTriggerGateScorePopup (copy)
            local connection = flightTriggerGateScorePopup:Connect(function(p2) -- line: 26
                -- upvalues: v3 (copy), v4 (copy), v5 (copy), scorePopupVFX (copy)
                local v7 = v4

                if v4 ~= nil then
                    v7 = v4.castParams

                    if v7 ~= nil then
                        v7 = v7.flightTriggerGateEligible
                    end
                end

                if not v7 then
                    return nil
                end

                local spawnXRange = scorePopupVFX.spawnXRange
                local v8 = spawnXRange.X + math.random() * (spawnXRange.Y - spawnXRange.X)
                local tiltRange = scorePopupVFX.tiltRange
                local v9 = tiltRange.X + math.random() * (tiltRange.Y - tiltRange.X)
                local v10 = if v8 >= 0.5 then 1 else -1

                v5.current += 1

                local current = v5.current

                v3(function(p3) -- line: 42
                    -- upvalues: p2 (copy), v8 (copy), v9 (copy), current (copy), v10 (copy), scorePopupVFX (copy)
                    local t1 = {}
                    local v11 = #t1
                    local v12 = #p3

                    table.move(p3, 1, v12, v11 + 1, t1)

                    local v13 = v11 + v12 + 1
                    local t2 = {
                        id = current,
                        rotation = v10 * v9,
                        score = p2,
                        x = v8
                    }
                    local spawnYRange = scorePopupVFX.spawnYRange

                    t2.y = spawnYRange.X + math.random() * (spawnYRange.Y - spawnYRange.X)
                    t1[v13] = t2

                    return t1
                end)
            end)

            return function() -- line: 58
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, {
            scorePopupVFX.spawnXRange,
            scorePopupVFX.spawnYRange,
            scorePopupVFX.tiltRange,
            if v4 == nil then v4 else v4.castParams
        })

        local function v15() -- line: 70
            -- upvalues: v3 (copy), v4 (copy)
            local v16 = v4

            if v4 ~= nil then
                v16 = v4.castParams

                if v16 ~= nil then
                    v16 = v16.flightTriggerGateEligible
                end
            end

            if not v16 then
                v3({})
            end
        end

        local castParams

        if v4 ~= nil then
            castParams = v4.castParams

            if castParams ~= nil then
                castParams = castParams.flightTriggerGateEligible
            end
        else
            castParams = v4
        end

        useEffect(v15, { castParams })

        local v17 = useCallback(function(p4) -- line: 90
            -- upvalues: v3 (copy)
            v3(function(p5) -- line: 91
                -- upvalues: p4 (copy)
                local t3 = {}
                local n1 = 0

                for v18, v19 in p5 do
                    local _ = v18 - 1

                    if v19.id ~= p4 == true then
                        n1 += 1
                        t3[n1] = v19
                    end
                end

                return t3
            end)
        end, {})
        local v20 = table.create(#v2)

        local function v21(p6) -- line: 110
            -- upvalues: v17 (copy), react (copy), default (copy)
            return react.createElement(default, {
                key = p6.id,
                onComplete = function() -- onComplete | line: 113
                    -- upvalues: p6 (copy), v17 (copy)
                    return v17(p6.id)
                end,
                score = p6.score,
                x = p6.x,
                y = p6.y,
                rotation = p6.rotation
            })
        end

        for v22, v23 in v2 do
            v20[v22] = v21(v23, v22 - 1, v2)
        end

        return react.createElement(react.Fragment, nil, v20)
    end
}
