-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, Workspace = services.Players, services.Workspace
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent, "fishing-phase-atom")
local apexAfterRareFishCutsceneAtom, apexSkillCheckAtom, castIsPerfectAtom = v1.apexAfterRareFishCutsceneAtom, v1.apexSkillCheckAtom, v1.castIsPerfectAtom
local useRootSelectorCreator = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex").useRootSelectorCreator
local selectPlayerFishingState = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "fishing-state.selectors").selectPlayerFishingState
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "fishing-hook-utils")
local defaultCameraBack, defaultCameraUp = v2.defaultCameraBack, v2.defaultCameraUp
local FishingHookCast = RuntimeLib.import(script, script.Parent, "fishing-hook-cast").FishingHookCast
local createPortal = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox").createPortal
local FlightTriggerGateCourse = RuntimeLib.import(script, script.Parent, "flight-trigger-gate-course").FlightTriggerGateCourse
local SubwaySurfOcclusion = RuntimeLib.import(script, script.Parent, "subway-surf-occlusion").SubwaySurfOcclusion
local v3 = tostring(Players.LocalPlayer.UserId)

return {
    LocalFishingHookManager = function() -- LocalFishingHookManager | line: 25
        -- upvalues: react (copy), useEffect (copy), useState (copy), subscribe (copy), Workspace (copy), apexAfterRareFishCutsceneAtom (copy), apexSkillCheckAtom (copy), castIsPerfectAtom (copy), useRootSelectorCreator (copy), selectPlayerFishingState (copy), defaultCameraBack (copy), defaultCameraUp (copy), FishingHookCast (copy), createPortal (copy), FlightTriggerGateCourse (copy), SubwaySurfOcclusion (copy), v3 (copy)
        local v4 = useRootSelectorCreator(selectPlayerFishingState, v3)
        local v6, v7 = useState(apexSkillCheckAtom() ~= nil or apexAfterRareFishCutsceneAtom())

        useEffect(function() -- line: 30
            -- upvalues: v7 (copy), subscribe (copy), apexAfterRareFishCutsceneAtom (copy), apexSkillCheckAtom (copy)
            local function v8() -- line: 31
                -- upvalues: v7 (copy), apexAfterRareFishCutsceneAtom (copy), apexSkillCheckAtom (copy)
                return v7(apexSkillCheckAtom() ~= nil or apexAfterRareFishCutsceneAtom())
            end

            local v10 = subscribe(apexSkillCheckAtom, v8)
            local v11 = subscribe(apexAfterRareFishCutsceneAtom, v8)

            return function() -- line: 36
                -- upvalues: v10 (copy), v11 (copy)
                v10()
                v11()
            end
        end, {})

        local function v12() -- line: 41
            -- upvalues: v4 (copy)
            local v13 = v4

            if v4 ~= nil then
                v13 = v4.fishingState
            end

            if v13 == nil or not v4.castParams then
                return nil
            end

            local v14 = ("[HoopDebug] LocalFishingHookManager mounted cast: fishingState=%* "):format(v4.fishingState)
            local flightTriggerGateEligible = v4.castParams.flightTriggerGateEligible

            if flightTriggerGateEligible == nil then
                flightTriggerGateEligible = "undefined"
            end

            print(v14 .. ("flightTriggerGateEligible=%*"):format(flightTriggerGateEligible))
        end

        local v15 = if v4 == nil then v4 else v4.fishingState
        local castParams

        if v4 ~= nil then
            castParams = v4.castParams

            if castParams ~= nil then
                castParams = castParams.flightTriggerGateEligible
            end
        else
            castParams = v4
        end

        useEffect(v12, { v15, castParams })

        if (if v4 == nil then v4 else v4.fishingState) == nil or not v4.castParams then
            return react.createElement(react.Fragment)
        end

        local v16 = table.clone(v4.castParams)

        setmetatable(v16, nil)
        v16.cameraBackDistance = defaultCameraBack
        v16.cameraUpDistance = defaultCameraUp
        v16.isPerfect = castIsPerfectAtom()
        v16.showHook = v4.fishingState ~= "reeling" or v6

        local v17 = react.createElement(FishingHookCast, v16)
        local flightTriggerGateEligible = v4.castParams.flightTriggerGateEligible

        if flightTriggerGateEligible then
            local v18 = table.clone(v4.castParams)

            setmetatable(v18, nil)
            flightTriggerGateEligible = react.createElement(FlightTriggerGateCourse, v18)
        end

        return createPortal(react.createElement(react.Fragment, nil, v17, flightTriggerGateEligible, react.createElement(SubwaySurfOcclusion)), Workspace)
    end
}
