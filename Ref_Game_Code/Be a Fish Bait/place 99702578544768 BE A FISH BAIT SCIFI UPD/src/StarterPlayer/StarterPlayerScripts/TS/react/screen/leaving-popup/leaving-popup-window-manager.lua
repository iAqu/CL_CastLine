-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local GuiService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").GuiService
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "reward-screen").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "window-transition").default
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local useSound = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-sound").useSound
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelector
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerAquariumMoneyPerSecond, selectPlayerPreLogoutBuff = selectors.selectPlayerAquariumMoneyPerSecond, selectors.selectPlayerPreLogoutBuff
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "pre-logout-buff-utils")
local getPreLogoutDayKey, pickPreLogoutBuffKind = v1.getPreLogoutDayKey, v1.pickPreLogoutBuffKind
local offlineEarningsConfig = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "offline-earnings-utils").offlineEarningsConfig
local default3 = RuntimeLib.import(script, script.Parent, "leaving-popup").default
local t1 = {
    money = "2x Money for 5 mins!",
    mutationLuck = "2x Mutation Luck for 5 mins!",
    power = "2x Power for 5 mins!"
}
local t2 = {
    money = images.cash2stack,
    mutationLuck = images.serverLuckCloverIcon,
    power = images.strongArmIcon
}

return {
    default = function() -- LeavingPopupWindowManager | line: 41
        -- upvalues: react (copy), useEffect (copy), useState (copy), GuiService (copy), default (copy), default2 (copy), functions (copy), useSound (copy), useScreenSizeState (copy), useRootSelector (copy), localPlayerUserId (copy), selectPlayerAquariumMoneyPerSecond (copy), selectPlayerPreLogoutBuff (copy), getPreLogoutDayKey (copy), pickPreLogoutBuffKind (copy), offlineEarningsConfig (copy), default3 (copy), t1 (copy), t2 (copy)
        local v2, v3 = useState(false)
        local v4, v5 = useState(false)
        local v6, v7 = useState(nil)
        local playSound = useSound("LeavingNotif").playSound
        local playSound2 = useSound("SkillCheckSuccess").playSound
        local v8 = useScreenSizeState()
        local v9 = v8 == "sm" or v8 == "md"
        local v10 = useRootSelector(selectPlayerPreLogoutBuff(localPlayerUserId))
        local v11 = useRootSelector(selectPlayerAquariumMoneyPerSecond(localPlayerUserId))
        local v12 = getPreLogoutDayKey()
        local v13 = pickPreLogoutBuffKind()

        if v10 ~= nil then
            v10 = v10[v13]

            if v10 ~= nil then
                v10 = v10.claimedDayKey
            end
        end

        local v14 = v10 ~= v12
        local v17 = math.max(50000, (math.floor(v11 * offlineEarningsConfig.maxOfflineSeconds * offlineEarningsConfig.offlineFactor)))

        local function v18() -- line: 64
            -- upvalues: v5 (copy)
            v5(false)
        end

        useEffect(function() -- line: 67
            -- upvalues: v3 (copy), v5 (copy), playSound (copy), GuiService (copy)
            local connection = GuiService.MenuOpened:Connect(function() -- line: 68
                -- upvalues: v3 (copy), v5 (copy), playSound (copy)
                v3(true)
                v5(true)
                pcall(playSound)
            end)
            local connection2 = GuiService.MenuClosed:Connect(function() -- line: 74
                -- upvalues: v3 (copy)
                v3(false)
            end)

            return function() -- line: 77
                -- upvalues: connection (copy), connection2 (copy)
                connection:Disconnect()
                connection2:Disconnect()
            end
        end, { v14, playSound })

        return react.createElement(react.Fragment, nil, react.createElement(default2, {
            enableCameraEffects = false,
            ["in"] = v4
        }, react.createElement(default3, {
            buffKind = v13,
            canClaimBuff = v14,
            forecastEarnings = v17,
            onClaimBuff = function() -- onClaimBuff | line: 89
                -- upvalues: v5 (copy), v7 (copy), v14 (copy), functions (copy)
                if not v14 then
                    return nil
                end

                functions.claimPreLogoutBuff():andThen(function(p1) -- line: 93
                    -- upvalues: v5 (copy), v7 (copy)
                    if p1 ~= false then
                        v5(false)
                        v7({
                            buffKind = p1.buffKind,
                            id = os.clock()
                        })
                    end
                end)
            end,
            onDismiss = v18,
            showBanners = v2
        })), v6 ~= nil and react.createElement(default, {
            title = "REWARD CLAIMED!",
            zIndex = 200,
            iconImage = t2[v6.buffKind],
            key = v6.id,
            onFinished = function() -- onFinished | line: 108
                -- upvalues: v7 (copy)
                return v7(nil)
            end,
            onReveal = function() -- onReveal | line: 111
                -- upvalues: playSound2 (copy)
                return playSound2()
            end,
            rewardText = t1[v6.buffKind],
            uiScale = v9 and 0.78 or 1
        }))
    end
}
