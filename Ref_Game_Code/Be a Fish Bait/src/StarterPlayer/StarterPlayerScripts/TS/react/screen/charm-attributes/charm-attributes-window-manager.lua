-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useEffect, useRef, useState = react.useCallback, react.useEffect, react.useRef, react.useState
local UserInputService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").UserInputService
local charmPodiumPreviewTargetAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "charm-podium-preview-target-atom").charmPodiumPreviewTargetAtom
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent, "charm-podium", "charm-podium-camera-focus")
local focusCharmPodium, releaseCharmPodiumFocus, setCharmPodiumRollPresentationActive, setCharmPodiumSuccessPresentationActive = v1.focusCharmPodium, v1.releaseCharmPodiumFocus, v1.setCharmPodiumRollPresentationActive, v1.setCharmPodiumSuccessPresentationActive
local useConfig = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "config-context").useConfig
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local v2 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "selectors", "current-window.selectors")
local selectCharmAttributesTierId, selectCurrentWindow = v2.selectCharmAttributesTierId, v2.selectCurrentWindow
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local v3 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "charm-attributes")
local charmCandidateTimeoutSeconds, charmRevealDurationSeconds, charmTierConfigs, getCharmTierFlag = v3.charmCandidateTimeoutSeconds, v3.charmRevealDurationSeconds, v3.charmTierConfigs, v3.getCharmTierFlag
local getCharmTierKey, getCharmTierResonance = v3.getCharmTierKey, v3.getCharmTierResonance
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerCharms, selectPlayerRebirthCount, selectPlayerStat = selectors.selectPlayerCharms, selectors.selectPlayerRebirthCount, selectors.selectPlayerStat
local default = RuntimeLib.import(script, script.Parent, "charm-attributes-window").default

return {
    default = function() -- CharmAttributesWindowManager | line: 37
        -- upvalues: react (copy), useCallback (copy), useEffect (copy), useRef (copy), useState (copy), UserInputService (copy), charmPodiumPreviewTargetAtom (copy), functions (copy), focusCharmPodium (copy), releaseCharmPodiumFocus (copy), setCharmPodiumRollPresentationActive (copy), setCharmPodiumSuccessPresentationActive (copy), useConfig (copy), useRootProducer (copy), useRootSelector (copy), selectCharmAttributesTierId (copy), selectCurrentWindow (copy), localPlayerUserId (copy), charmCandidateTimeoutSeconds (copy), charmRevealDurationSeconds (copy), charmTierConfigs (copy), getCharmTierFlag (copy), getCharmTierKey (copy), getCharmTierResonance (copy), selectPlayerCharms (copy), selectPlayerRebirthCount (copy), selectPlayerStat (copy), default (copy)
        local v4 = useRootProducer()
        local v5 = useConfig()
        local disableMovement, enableMovement = v5.disableMovement, v5.enableMovement
        local v6 = useRootSelector(selectCurrentWindow)
        local v7 = useRootSelector(selectCharmAttributesTierId)
        local v8 = useRootSelector(selectPlayerCharms(localPlayerUserId))
        local v9 = useRootSelector(selectPlayerRebirthCount(localPlayerUserId))
        local v10 = useRootSelector(selectPlayerStat(localPlayerUserId, "money"))

        if v10 == nil then
            v10 = 0
        end

        local v11 = if v8 == nil then v8 else v8.pendingCharmCandidate
        local v12 = if v11 == nil then v11 else v11.tierId

        if v12 == nil then
            v12 = v7 or 1
        end

        local v13 = charmTierConfigs[v12]
        local v14 = if v8 == nil then v8 else v8.charmCoresByTier[getCharmTierKey(v12)]
        local v15 = if v8 == nil then v8 else v8.resonanceByTier

        if v15 == nil then
            v15 = { 0, 0, 0, 0, 0 }
        end

        local v16 = getCharmTierResonance(v15, v12)
        local v17, v18 = useState(false)
        local v19, v20 = useState(false)
        local v21, v22 = useState(false)
        local v23, v24 = useState(false)
        local v25, v26 = useState()
        local v27, v28 = useState()
        local v29 = useRef()
        local v30 = useRef()
        local v31 = useRef()
        local v32 = useRef()

        useEffect(function() -- line: 93
            -- upvalues: disableMovement (copy), enableMovement (copy)
            disableMovement()

            return function() -- line: 95
                -- upvalues: enableMovement (copy)
                return enableMovement()
            end
        end, { disableMovement, enableMovement })
        useEffect(function() -- line: 99
            -- upvalues: charmPodiumPreviewTargetAtom (copy), focusCharmPodium (copy), releaseCharmPodiumFocus (copy)
            local v33 = charmPodiumPreviewTargetAtom()

            if v33 ~= nil and v33.Parent ~= nil then
                focusCharmPodium(v33)
            end

            return function() -- line: 104
                -- upvalues: releaseCharmPodiumFocus (copy)
                releaseCharmPodiumFocus()
            end
        end, {})
        useEffect(function() -- line: 108
            -- upvalues: v19 (copy), setCharmPodiumRollPresentationActive (copy)
            setCharmPodiumRollPresentationActive(v19)

            return function() -- line: 110
                -- upvalues: v19 (copy), setCharmPodiumRollPresentationActive (copy)
                if v19 then
                    setCharmPodiumRollPresentationActive(false)
                end
            end
        end, { v19 })
        useEffect(function() -- line: 116
            -- upvalues: v27 (copy), setCharmPodiumSuccessPresentationActive (copy)
            setCharmPodiumSuccessPresentationActive(v27 ~= nil)

            return function() -- line: 118
                -- upvalues: v27 (copy), setCharmPodiumSuccessPresentationActive (copy)
                if v27 ~= nil then
                    setCharmPodiumSuccessPresentationActive(false)
                end
            end
        end, { v27 })
        useEffect(function() -- line: 124
            -- upvalues: v4 (copy), v6 (copy), v11 (copy)
            if v11 ~= nil and v6 ~= "charmAttributes" and v6 ~= "loadingScreen" and v6 ~= "eventLoadingScreen" and v6 ~= "teleportingToHome" then
                v4.windowOpened({
                    currentWindow = "charmAttributes",
                    charmTierId = v11.tierId
                })
            end
        end, { v11, v6, v4 })
        useEffect(function() -- line: 132
            -- upvalues: v29 (copy), v30 (copy), v31 (copy), v32 (copy)
            return function() -- line: 133
                -- upvalues: v29 (copy), v30 (copy), v31 (copy), v32 (copy)
                if v29.current ~= nil then
                    task.cancel(v29.current)
                end

                if v30.current ~= nil then
                    task.cancel(v30.current)
                end

                if v31.current ~= nil then
                    task.cancel(v31.current)
                end

                if v32.current ~= nil then
                    task.cancel(v32.current)
                end
            end
        end, {})

        local v34 = useCallback(function() -- line: 148
            -- upvalues: v20 (copy), v22 (copy), v24 (copy), v29 (copy), v30 (copy)
            if v29.current ~= nil then
                task.cancel(v29.current)
            end

            if v30.current ~= nil then
                task.cancel(v30.current)
            end

            v29.current = nil
            v30.current = nil
            v24(false)
            v20(false)
            v22(false)
        end, {})
        local v35 = useCallback(function() -- line: 161
            -- upvalues: v20 (copy), v22 (copy), v24 (copy), v29 (copy), v30 (copy), v34 (copy), charmRevealDurationSeconds (copy)
            v20(false)
            v22(true)
            v24(false)
            v30.current = task.delay(0.5, function() -- line: 165
                -- upvalues: v24 (copy), v30 (copy)
                v30.current = nil
                v24(true)
            end)
            v29.current = task.delay(charmRevealDurationSeconds, function() -- line: 169
                -- upvalues: v29 (copy), v34 (copy)
                v29.current = nil
                v34()
            end)
        end, { v34 })
        local v36 = useCallback(function(p1) -- line: 174
            -- upvalues: v26 (copy), v31 (copy)
            if v31.current ~= nil then
                task.cancel(v31.current)
            end

            v26(p1)
            v31.current = task.delay(1.5, function() -- line: 179
                -- upvalues: v26 (copy), v31 (copy)
                v31.current = nil
                v26(nil)
            end)
        end, {})
        local v37 = useCallback(function() -- line: 184
            -- upvalues: v11 (copy), v12 (ref), v17 (copy), v18 (copy), v20 (copy), functions (copy)
            if v17 or v11 ~= nil then
                return nil
            end

            v18(true)
            functions.startCharmRoll(v12):andThen(function(p2) -- line: 189
                -- upvalues: v18 (copy), v20 (copy)
                v18(false)

                if p2.kind ~= "success" then
                    return nil
                end

                v20(true)
            end):catch(function() -- line: 195
                -- upvalues: v18 (copy)
                return v18(false)
            end)
        end, { v11, v17, v12 })
        local v38 = useCallback(function(p3, p4) -- line: 199
            -- upvalues: v4 (copy), v11 (copy), v14 (copy), v17 (copy), v18 (copy), v28 (copy), v36 (copy), charmPodiumPreviewTargetAtom (copy), functions (copy)
            local v39 = p4

            if p4 == nil then
                v39 = false
            end

            if v17 or v11 == nil then
                return nil
            end

            local v40 = p3 ~= "replace" and v14 or v11

            v18(true)

            if p3 == "keep" then
                v36("KEEP OLD → RESONANCE +1")
            end

            functions.resolveCharmCandidate(p3):andThen(function(p5) -- line: 211
                -- upvalues: v39 (ref), p3 (copy), v40 (copy), v4 (copy), v18 (copy), v28 (copy), charmPodiumPreviewTargetAtom (copy)
                v18(false)

                if p5.kind ~= "success" then
                    return nil
                end

                if v39 then
                    charmPodiumPreviewTargetAtom(nil)
                    v4.windowClosed({})

                    return nil
                end

                v28({
                    core = v40,
                    decision = p3
                })
            end):catch(function() -- line: 225
                -- upvalues: v18 (copy)
                return v18(false)
            end)
        end, { v14, v11, v17, v4, v36 })
        local v41 = useCallback(function() -- line: 229
            -- upvalues: v4 (copy), v11 (copy), v34 (copy), v38 (copy), charmPodiumPreviewTargetAtom (copy)
            v34()

            if v11 ~= nil then
                v38("keep", true)
            else
                charmPodiumPreviewTargetAtom(nil)
                v4.windowClosed({})
            end
        end, { v11, v34, v4, v38 })

        useEffect(function() -- line: 238
            -- upvalues: v11 (copy), v19 (copy), v21 (copy), v32 (copy), v38 (copy), charmCandidateTimeoutSeconds (copy)
            if v32.current ~= nil then
                task.cancel(v32.current)
            end

            v32.current = nil

            if v11 == nil or v19 or v21 then
                return nil
            end

            v32.current = task.delay(charmCandidateTimeoutSeconds, function() -- line: 246
                -- upvalues: v32 (copy), v38 (copy)
                v32.current = nil
                v38("keep", true)
            end)

            return function() -- line: 250
                -- upvalues: v32 (copy)
                if v32.current ~= nil then
                    task.cancel(v32.current)
                end

                v32.current = nil
            end
        end, { v11, v19, v21, v38 })
        useEffect(function() -- line: 257
            -- upvalues: v6 (copy), v41 (copy), UserInputService (copy)
            local connection = UserInputService.InputBegan:Connect(function(p6) -- line: 258
                -- upvalues: v6 (copy), v41 (copy)
                if v6 == "charmAttributes" and p6.KeyCode == Enum.KeyCode.Escape then
                    v41()
                end
            end)

            return function() -- line: 263
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, { v6, v41 })

        local t1 = {
            activeCore = v14,
            canSkip = v23,
            candidate = v11
        }

        if v8 ~= nil then
            v8 = v8.firstRollClaimedByTier
        end

        if v8 == nil then
            v8 = { false, false, false, false, false }
        end

        t1.firstRollFree = not getCharmTierFlag(v8, v12)
        t1.isBusy = v17
        t1.isLocking = v19
        t1.isRevealing = v21
        t1.money = v10
        t1.onClose = v41

        t1.onKeepOld = function() -- line: 286
            -- upvalues: v38 (copy)
            return v38("keep")
        end

        t1.onLockComplete = v35

        t1.onReplace = function() -- line: 290
            -- upvalues: v38 (copy)
            return v38("replace")
        end

        t1.onResolutionSuccessDismiss = function() -- line: 293
            -- upvalues: v28 (copy)
            v28(nil)
        end

        t1.onRoll = v37
        t1.onSkip = v34
        t1.rebirthCount = v9
        t1.resolutionSuccess = v27
        t1.resonance = v16
        t1.resonanceFeedback = v25
        t1.tier = v13

        return react.createElement(default, t1)
    end
}
