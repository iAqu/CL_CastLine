-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useMemo = react.useMemo
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "cyt-button").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "notification-bubble").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "radial-background").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "styled-text-label").default
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelectorCreator = reflex.useRootProducer, reflex.useRootSelectorCreator
local default5 = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-countdown").default
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "responsive-utils")
local getTextSize, getTextStrokeThickness = v1.getTextSize, v1.getTextStrokeThickness
local selectPlaytimeRewardEligibilityData = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "topbar.selectors").selectPlaytimeRewardEligibilityData
local selectShouldAutoPromptDailyReward = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-config-snapshot.selectors").selectShouldAutoPromptDailyReward
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "playtime-rewards-utils")
local calculateTimestampForPlaytimeReward, getPlaytimeRewardElapsedSeconds, getPlaytimeRewardDisplayText, playtimeRewards = v2.calculateTimestampForPlaytimeReward, v2.getPlaytimeRewardElapsedSeconds, v2.getPlaytimeRewardDisplayText, v2.playtimeRewards
local formatDuration = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").formatDuration
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images

local function getTargetRewardAndTimestamp(p1) -- line: 35
    -- upvalues: Workspace (copy), calculateTimestampForPlaytimeReward (copy), getPlaytimeRewardElapsedSeconds (copy), playtimeRewards (copy)
    local ServerTimeNow = Workspace:GetServerTimeNow()
    local v3 = getPlaytimeRewardElapsedSeconds(ServerTimeNow, p1.savedTimeForPlaytimeReward, p1.playTimeRewardStartTime, p1.timeLastSaved) / 60
    local rewards = p1.rewards
    local v4, v5
    local n1 = 1e999

    for _, v6 in playtimeRewards do
        if rewards[v6.rewardId] ~= true then
            if v6.timeToClaim <= v3 then
                if not v4 or v6.timeToClaim > v4.timeToClaim then
                    v4 = v6
                end
            elseif v6.timeToClaim < n1 then
                v5 = v6
                n1 = v6.timeToClaim
            end
        end
    end

    local v7 = v4 or v5

    return if v7 then {
        reward = v7,
        canClaimTimestamp = calculateTimestampForPlaytimeReward(ServerTimeNow, v7.timeToClaim, p1.savedTimeForPlaytimeReward, p1.playTimeRewardStartTime, p1.timeLastSaved)
    } else nil
end

return {
    default = function() -- PlaytimeRewardTopbarButton | line: 68
        -- upvalues: react (copy), useMemo (copy), Workspace (copy), default (copy), default2 (copy), default3 (copy), default4 (copy), useRootProducer (copy), useRootSelectorCreator (copy), default5 (copy), useScreenSizeState (copy), getTextSize (copy), getTextStrokeThickness (copy), selectPlaytimeRewardEligibilityData (copy), selectShouldAutoPromptDailyReward (copy), getPlaytimeRewardDisplayText (copy), formatDuration (copy), localPlayerUserId (copy), images (copy), getTargetRewardAndTimestamp (copy)
        local v8 = useRootProducer()
        local v9 = useRootSelectorCreator(selectShouldAutoPromptDailyReward, localPlayerUserId)
        local v10 = useRootSelectorCreator(selectPlaytimeRewardEligibilityData, localPlayerUserId)
        local v11 = useScreenSizeState()
        local v12 = useMemo(function() -- line: 73
            -- upvalues: v10 (copy), getTargetRewardAndTimestamp (copy)
            return if v10 then getTargetRewardAndTimestamp(v10) else nil
        end, { v10 })
        local v13 = if v12 == nil then v12 else v12.canClaimTimestamp

        if v13 == nil then
            v13 = 0
        end

        local secondsLeft = default5(v13).secondsLeft
        local v14 = v13 <= Workspace:GetServerTimeNow()
        local v15 = useMemo(function() -- line: 89
            -- upvalues: v8 (copy)
            return function() -- line: 90
                -- upvalues: v8 (copy)
                return v8.windowOpened({
                    currentWindow = "playtimeRewards"
                })
            end
        end, { v8 })

        if not (v9 and v12) then
            return react.createElement(react.Fragment)
        end

        local reward = v12.reward
        local rewardIcon = reward.rewardIcon

        getPlaytimeRewardDisplayText(reward)

        local v16 = secondsLeft:map(function(p2) -- line: 103
            -- upvalues: formatDuration (copy)
            return formatDuration(p2)
        end)

        if v14 then
            v16 = "FREE!"
        end

        return react.createElement(default, {
            darkenOnHover = false,
            uiAspectRatio = 1,
            anchorPoint = Vector2.new(0.5, 0.5),
            onClick = v15,
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1.3, 1.3)
        }, react.createElement(default3, {
            zIndex = 0,
            anchorPoint = Vector2.new(0.5, 0.5),
            imageColor3 = Color3.fromRGB(255, 255, 255),
            imageId = images.radialBackground2,
            position = UDim2.fromScale(0.525, 0.5),
            size = UDim2.fromScale(1.5, 1.5)
        }), v14 and react.createElement(default2, {
            text = "1",
            zIndex = 2,
            position = UDim2.fromScale(1.1, -0.05),
            size = UDim2.fromScale(0.35, 0.35)
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = rewardIcon,
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(1.2, 1.2)
        }), react.createElement(default4, {
            overrideProps = {
                TextScaled = false,
                TextSize = getTextSize(v11, "sm"),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 1)
            },
            text = v16,
            textColor3 = Color3.fromRGB(255, 255, 255)
        }, react.createElement("uistroke", {
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = getTextStrokeThickness(v11, "sm")
        })))
    end
}
