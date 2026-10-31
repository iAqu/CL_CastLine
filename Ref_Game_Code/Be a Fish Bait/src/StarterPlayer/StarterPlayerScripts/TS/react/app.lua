-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, UserInputService = services.Players, services.UserInputService
local default = RuntimeLib.import(script, script.Parent, "screen", "hud", "hud").default
local default2 = RuntimeLib.import(script, script.Parent, "screen", "hud", "celebration-hud").default
local default3 = RuntimeLib.import(script, script.Parent, "plot", "plot-manager").default
local default4 = RuntimeLib.import(script, script.Parent, "gift", "incoming-gift-request-manager").default
local default5 = RuntimeLib.import(script, script.Parent, "leaderboard", "leaderboard-manager").default
local default6 = RuntimeLib.import(script, script.Parent, "weather", "weather-timer-display-manager").default
local default7 = RuntimeLib.import(script, script.Parent, "screen", "topbar-plus", "topbar-plus").default
local default8 = RuntimeLib.import(script, script.Parent, "screen", "touch-gui-replica", "touch-gui-replica").default
local default9 = RuntimeLib.import(script, script.Parent, "fishing-zone", "fishing-zone-fish-manager").default
local LocalFishingHookManager = RuntimeLib.import(script, script.Parent, "fishing", "local-fishing-hook-manager").LocalFishingHookManager
local OtherPlayerHookManager = RuntimeLib.import(script, script.Parent, "fishing", "other-player-hook-manager").OtherPlayerHookManager
local default10 = RuntimeLib.import(script, script.Parent, "screen", "playtime-spin-wheel", "spin-wheel-surface-gui-manager").default
local default11 = RuntimeLib.import(script, script.Parent, "fishing", "high-score-marker").default
local default12 = RuntimeLib.import(script, script.Parent, "screen", "aquarium-flash").default
local default13 = RuntimeLib.import(script, script.Parent, "screen", "fishing", "delulu-rift-camera-punch").default
local default14 = RuntimeLib.import(script, script.Parent, "fishing", "delulu-rift-crack").default
local default15 = RuntimeLib.import(script, script.Parent, "screen", "delulu-rift-screen-flash").default
local default16 = RuntimeLib.import(script, script.Parent, "fishing", "delulu-rift-sky-manager").default
local default17 = RuntimeLib.import(script, script.Parent, "fishing", "new-high-score-popup").default
local useRootSelector = RuntimeLib.import(script, script.Parent, "hooks", "reflex").useRootSelector
local selectHighScoreShown = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-config-snapshot.selectors").selectHighScoreShown
local selectCurrentWindow = RuntimeLib.import(script, script.Parent.Parent, "reflex", "slices", "selectors", "current-window.selectors").selectCurrentWindow
local selectIsCelebrationPlace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-config-snapshot.selectors").selectIsCelebrationPlace
local secretFrostwyrmActiveAtom = RuntimeLib.import(script, script.Parent.Parent, "secret-frostwyrm-active-atom").secretFrostwyrmActiveAtom
local default18 = RuntimeLib.import(script, script.Parent, "secret-frostwyrm", "secret-frostwyrm-manager").default
local catchSticksActiveAtom = RuntimeLib.import(script, script.Parent.Parent, "catch-sticks-active-atom").catchSticksActiveAtom
local default19 = RuntimeLib.import(script, script.Parent, "catch-sticks", "catch-sticks-manager").default
local default20 = RuntimeLib.import(script, script.Parent, "screen", "pinata-boss", "boss-area-hud-manager").default
local default21 = RuntimeLib.import(script, script.Parent, "screen", "pinata-boss", "boss-damage-popup-manager").default
local default22 = RuntimeLib.import(script, script.Parent, "special-event", "special-event-timer-billboard-manager").default
local default23 = RuntimeLib.import(script, script.Parent, "lucky-block", "lucky-block-display-manager").default
local default24 = RuntimeLib.import(script, script.Parent, "teaser", "teaser-rig-manager").default
local default25 = RuntimeLib.import(script, script.Parent, "aura-showcase", "aura-showcase-billboard-manager").default
local default26 = RuntimeLib.import(script, script.Parent, "common", "dance-floor-aura-spew-manager").default
local default27 = RuntimeLib.import(script, script.Parent, "hall-of-fame", "hall-of-fame-npc-dialogue-manager").default
local default28 = RuntimeLib.import(script, script.Parent, "hall-of-fame", "hall-of-fame-chat-surface-gui-manager").default
local default29 = RuntimeLib.import(script, script.Parent, "hall-of-fame", "hall-of-fame-screenshot-surface-gui-manager").default
local default30 = RuntimeLib.import(script, script.Parent, "screen", "rgl", "rgl-countdown-overlay").default
local default31 = RuntimeLib.import(script, script.Parent, "screen", "rgl", "rgl-light-overlay").default
local default32 = RuntimeLib.import(script, script.Parent, "reward-presentation-host").default
local default33 = RuntimeLib.import(script, script.Parent, "screen", "charm-preview", "charm-preview-overlay").default
local default34 = RuntimeLib.import(script, script.Parent, "screen", "mount-fish-preview", "mount-fish-preview-overlay").default
local default35 = RuntimeLib.import(script, script.Parent, "screen", "aquarium-skin-preview", "aquarium-skin-preview-overlay").default
local default36 = RuntimeLib.import(script, script.Parent, "screen", "celebration-farewell", "celebration-farewell-manager").default
local v1 = RuntimeLib.import(script, script.Parent, "charm-podium", "charm-podium-billboard")
local default37, CharmPodiumInteractionManager = v1.default, v1.CharmPodiumInteractionManager
local default38 = RuntimeLib.import(script, script.Parent, "common", "auto-rotate-meshparts-manager").default
local default39 = RuntimeLib.import(script, script.Parent, "screen", "fishing", "flight-trigger-gate-combo-vfx").default
local v2 = tostring(Players.LocalPlayer.UserId)

local function ScreenGui() -- line: 61
    -- upvalues: react (copy), default (copy), default2 (copy), default4 (copy), default12 (copy), default15 (copy), default17 (copy), useRootSelector (copy), selectHighScoreShown (copy), selectCurrentWindow (copy), selectIsCelebrationPlace (copy), default20 (copy), default21 (copy), default30 (copy), default31 (copy), CharmPodiumInteractionManager (copy), default39 (copy), v2 (copy)
    local v3 = useRootSelector(selectHighScoreShown(v2))
    local v4 = useRootSelector(selectCurrentWindow)
    local v5 = v4 == "baitAuras"
    local v6 = v4 == "charmAttributes"
    local v7 = v4 == "aquariumShop"
    local v8 = v4 == "celebrationEventShop"
    local v9 = useRootSelector(selectIsCelebrationPlace(v2))

    return react.createElement("screengui", {
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
        ZIndexBehavior = if v8 or v6 then Enum.ZIndexBehavior.Global else Enum.ZIndexBehavior.Sibling
    }, if v9 then react.createElement(default2) else react.createElement(default), react.createElement(CharmPodiumInteractionManager), not v7 and not v6 and react.createElement(default20), not v7 and not v6 and react.createElement(default21), not v7 and not v6 and react.createElement(default30), not v7 and not v6 and react.createElement(default31), not v5 and not v7 and not v6 and react.createElement(default4), not v5 and not v7 and not v6 and react.createElement(default12), not v5 and not v7 and not v6 and react.createElement(default15), not v5 and not v7 and not v6 and react.createElement(default39), if not v5 and not v7 and not v6 and v3 then react.createElement(default17) else nil)
end

return {
    default = function(_) -- App | line: 77
        -- upvalues: react (copy), useEffect (copy), useState (copy), subscribe (copy), UserInputService (copy), default3 (copy), default5 (copy), default6 (copy), default7 (copy), default8 (copy), default9 (copy), LocalFishingHookManager (copy), OtherPlayerHookManager (copy), default10 (copy), default11 (copy), default13 (copy), default14 (copy), default16 (copy), useRootSelector (copy), selectCurrentWindow (copy), selectIsCelebrationPlace (copy), secretFrostwyrmActiveAtom (copy), default18 (copy), catchSticksActiveAtom (copy), default19 (copy), default22 (copy), default23 (copy), default24 (copy), default25 (copy), default26 (copy), default27 (copy), default28 (copy), default29 (copy), default32 (copy), default33 (copy), default34 (copy), default35 (copy), default36 (copy), default37 (copy), default38 (copy), v2 (copy), ScreenGui (copy)
        local v10 = useRootSelector(selectCurrentWindow)
        local v11 = v10 == "baitAuras"
        local v12 = v10 == "charmAttributes"
        local v13 = v10 == "aquariumShop"
        local v14, v15 = useState(secretFrostwyrmActiveAtom())
        local v16, v17 = useState(catchSticksActiveAtom())
        local v18 = useRootSelector(selectIsCelebrationPlace(v2))

        useEffect(function() -- line: 85
            -- upvalues: v15 (copy), subscribe (copy), secretFrostwyrmActiveAtom (copy)
            return subscribe(secretFrostwyrmActiveAtom, v15)
        end, {})
        useEffect(function() -- line: 88
            -- upvalues: v17 (copy), subscribe (copy), catchSticksActiveAtom (copy)
            return subscribe(catchSticksActiveAtom, v17)
        end, {})

        local v19 = v14 or v16

        return react.createElement(react.Fragment, nil, react.createElement(default33), react.createElement(default38), react.createElement(default34), react.createElement(default35), react.createElement(default36), react.createElement(default32, {
            enabled = not v19
        }), not v19 and react.createElement(ScreenGui), not v19 and react.createElement(default3), not v19 and react.createElement(default9), not v19 and react.createElement(LocalFishingHookManager), not v19 and react.createElement(OtherPlayerHookManager), not v19 and react.createElement(default5), not v19 and react.createElement(default10), not v19 and react.createElement(default11), react.createElement(default18), v18 and react.createElement(default19), react.createElement(default24), react.createElement(default25), react.createElement(default37), react.createElement(default26), react.createElement(default27), react.createElement(default28), react.createElement(default29), react.createElement(default13), react.createElement(default14), react.createElement(default16), not v14 and not v11 and not v12 and react.createElement(default6), not v14 and not v11 and not v12 and react.createElement(default23), not v14 and not v11 and not v12 and react.createElement(default22), not v14 and not v11 and not v12 and react.createElement(default7), not v14 and not v11 and not v12 and not v13 and UserInputService.TouchEnabled and react.createElement(default8))
    end
}
