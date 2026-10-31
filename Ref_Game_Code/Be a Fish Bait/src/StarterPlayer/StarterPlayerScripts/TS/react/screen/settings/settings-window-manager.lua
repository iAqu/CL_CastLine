-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Flamework = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Flamework
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback = react.useCallback
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerAudioSettings, selectPlayerBossAutokillEnabled, selectPlayerBundlePurchaseHistory = selectors.selectPlayerAudioSettings, selectors.selectPlayerBossAutokillEnabled, selectors.selectPlayerBundlePurchaseHistory
local bossAutokillBundleName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-utils").bossAutokillBundleName
local SoundController = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "controllers", "sound-controller").SoundController
local default = RuntimeLib.import(script, script.Parent, "settings-window").default

return {
    default = function() -- SettingsWindowManager | line: 19
        -- upvalues: RuntimeLib (copy), Flamework (copy), react (copy), useCallback (copy), useRootProducer (copy), useRootSelector (copy), functions (copy), localPlayerUserId (copy), selectPlayerAudioSettings (copy), selectPlayerBossAutokillEnabled (copy), selectPlayerBundlePurchaseHistory (copy), bossAutokillBundleName (copy), SoundController (copy), default (copy)
        local v1 = useRootProducer()
        local v2 = useRootSelector(selectPlayerAudioSettings(localPlayerUserId))
        local v3 = useRootSelector(selectPlayerBossAutokillEnabled(localPlayerUserId))
        local v4 = useRootSelector(selectPlayerBundlePurchaseHistory(localPlayerUserId))

        if v4 ~= nil then
            local function v5(p1) -- line: 28
                -- upvalues: bossAutokillBundleName (copy)
                return p1.bundleName == bossAutokillBundleName
            end

            local v6 = false

            for v7, v8 in v4 do
                local _ = v7 - 1

                if v8.bundleName == bossAutokillBundleName then
                    v6 = true
                    break
                end
            end

            v4 = v6
        end

        if v4 == nil then
            v4 = false
        end

        local v9 = if v2 == nil then v2 else v2.musicVolume

        if v9 == nil then
            v9 = SoundController.defaultMusicVolume
        end

        local v10 = if v2 == nil then v2 else v2.sfxVolume

        if v10 == nil then
            v10 = SoundController.defaultSfxVolume
        end

        local v11 = if v2 == nil then v2 else v2.hapticsEnabled

        if v11 == nil then
            v11 = true
        end

        if v2 ~= nil then
            v2 = v2.cameraShakeEnabled
        end

        if v2 == nil then
            v2 = true
        end

        local v12 = useCallback(function(p2) -- line: 81
            -- upvalues: Flamework (copy)
            Flamework.resolveDependency("client/controllers/sound-controller@SoundController"):previewVolume("music", p2)
        end, {})
        local v13 = useCallback(function(p3) -- line: 84
            -- upvalues: Flamework (copy)
            Flamework.resolveDependency("client/controllers/sound-controller@SoundController"):previewVolume("sfx", p3)
        end, {})
        local v14 = useCallback(function(p4) -- line: 87
            -- upvalues: RuntimeLib (copy), functions (copy)
            task.spawn(RuntimeLib.async(function() -- line: 88
                -- upvalues: p4 (copy), RuntimeLib (copy), functions (copy)
                RuntimeLib.await(functions.setAudioVolume("music", p4))
            end))
        end, {})
        local v15 = useCallback(function(p5) -- line: 92
            -- upvalues: RuntimeLib (copy), functions (copy)
            task.spawn(RuntimeLib.async(function() -- line: 93
                -- upvalues: p5 (copy), RuntimeLib (copy), functions (copy)
                RuntimeLib.await(functions.setAudioVolume("sfx", p5))
            end))
        end, {})
        local v16 = useCallback(function(p6) -- line: 97
            -- upvalues: RuntimeLib (copy), functions (copy)
            task.spawn(RuntimeLib.async(function() -- line: 98
                -- upvalues: p6 (copy), RuntimeLib (copy), functions (copy)
                RuntimeLib.await(functions.setHapticsEnabled(p6))
            end))
        end, {})
        local v17 = useCallback(function(p7) -- line: 102
            -- upvalues: RuntimeLib (copy), functions (copy)
            task.spawn(RuntimeLib.async(function() -- line: 103
                -- upvalues: p7 (copy), RuntimeLib (copy), functions (copy)
                RuntimeLib.await(functions.setCameraShakeEnabled(p7))
            end))
        end, {})
        local v18 = useCallback(function(p8) -- line: 107
            -- upvalues: RuntimeLib (copy), functions (copy)
            task.spawn(RuntimeLib.async(function() -- line: 108
                -- upvalues: p8 (copy), RuntimeLib (copy), functions (copy)
                RuntimeLib.await(functions.setBossAutokillEnabled(p8))
            end))
        end, {})
        local v19 = useCallback(function() -- line: 112
            -- upvalues: v1 (copy)
            v1.windowClosed({})
        end, { v1 })
        local v20 = useCallback(function() -- line: 115
            -- upvalues: v1 (copy)
            v1.windowOpened({
                currentWindow = "playerStats"
            })
        end, { v1 })

        return react.createElement(default, {
            bossAutokillEnabled = v3,
            bossAutokillOwned = v4,
            cameraShakeEnabled = v2,
            hapticsEnabled = v11,
            musicVolume = v9,
            onCameraShakeToggle = v17,
            onBossAutokillToggle = v18,
            onClose = v19,
            onHapticsToggle = v16,
            onMusicVolumeChange = v14,
            onMusicVolumePreview = v12,
            onPlayerStatsOpen = v20,
            onSfxVolumeChange = v15,
            onSfxVolumePreview = v13,
            sfxVolume = v10
        })
    end
}
