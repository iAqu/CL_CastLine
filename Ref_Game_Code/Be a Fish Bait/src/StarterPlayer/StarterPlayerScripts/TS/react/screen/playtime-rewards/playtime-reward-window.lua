-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useContext = react.useContext
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "rounded-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "styled-text-label").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "cyt-button").default
local default4 = RuntimeLib.import(script, script.Parent, "playtime-reward-item").default
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "responsive-utils")
local getBorderThickness, getTextSize = v1.getBorderThickness, v1.getTextSize
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local ThemeContext = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "theme-context").ThemeContext
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "playtime-rewards-utils")
local playtimeRewards, calculateTimestampForPlaytimeReward = v2.playtimeRewards, v2.calculateTimestampForPlaytimeReward
local default5 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "scrolling-frame").default
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace

return {
    default = function(p1) -- PlaytimeRewardWindow | line: 21
        -- upvalues: react (copy), useContext (copy), default (copy), default2 (copy), default3 (copy), default4 (copy), getBorderThickness (copy), getTextSize (copy), useScreenSizeState (copy), ThemeContext (copy), playtimeRewards (copy), calculateTimestampForPlaytimeReward (copy), default5 (copy), Workspace (copy)
        local v3 = useScreenSizeState()
        local v4 = useContext(ThemeContext)
        local ServerTimeNow = Workspace:GetServerTimeNow()
        local t1 = {}

        for _, v5 in playtimeRewards do
            if p1.claimedRewards[v5.rewardId] == true then
            end

            local v6 = calculateTimestampForPlaytimeReward(ServerTimeNow, v5.timeToClaim, p1.savedTimeForPlaytimeReward, p1.playTimeRewardStartTime, p1.timeLastSaved)

            table.insert(t1, {
                reward = v5,
                timeToClaim = v5.timeToClaim,
                canClaimTimestamp = v6
            })
        end

        table.sort(t1, function(p2, p3) -- line: 38
            return p2.timeToClaim < p3.timeToClaim
        end)

        local v7 = react.createElement(default2, {
            text = "🎁 Playtime Rewards 🎁",
            overrideProps = {
                TextScaled = false,
                AnchorPoint = Vector2.new(0.5, 1),
                Position = UDim2.fromScale(0.5, -0.05),
                Size = UDim2.fromScale(0.6, 0.1),
                TextSize = getTextSize(v3, "lg")
            }
        }, react.createElement("uigradient", {
            Color = v4.colorSequences.gold
        }))
        local v8 = react.createElement(default3, {
            cornerRadius = 25,
            uiAspectRatio = 1,
            zIndex = 1,
            anchorPoint = Vector2.new(0.5, 0.5),
            borderThickness = getBorderThickness(v3, "sm"),
            onClick = p1.onClose,
            position = UDim2.fromScale(1, 0),
            size = UDim2.fromScale(0.1, 0.1)
        }, react.createElement(default, {
            cornerRadius = 25,
            zIndex = 1,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor3 = Color3.fromRGB(200, 60, 60),
            borderColor3 = Color3.fromRGB(0, 0, 0),
            borderThickness = getBorderThickness(v3, "sm"),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1)
        }, react.createElement("textlabel", {
            BackgroundTransparency = 1,
            Text = "X",
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Font = v4.textFont,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.7, 0.7),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextXAlignment = Enum.TextXAlignment.Center
        }, react.createElement("uistroke", {
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = getBorderThickness(v3, "xsm")
        }))))
        local v9 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.05, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        })
        local v10 = table.create(#t1)

        local function v11(p4) -- line: 94
            -- upvalues: p1 (copy), react (copy), default4 (copy)
            local t3 = {
                canClaimTimestamp = p4.canClaimTimestamp
            }

            t3.isClaimed = p1.claimedRewards[p4.reward.rewardId] == true
            t3.key = p4.reward.rewardId
            t3.onClaim = p1.onClaim
            t3.playtimeReward = p4.reward

            return react.createElement(default4, t3)
        end

        for v12, v13 in t1 do
            v10[v12] = v11(v13, v12 - 1, t1)
        end

        return react.createElement(default, {
            backgroundTransparency = 0.7,
            cornerRadius = 8,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor3 = Color3.fromRGB(0, 0, 0),
            borderColor3 = Color3.fromRGB(0, 0, 0),
            borderThickness = getBorderThickness(v3, "sm"),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(0.55, 0.6)
        }, v7, v8, react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.95, 0.95)
        }, v9, react.createElement(default5, {
            cellsPerRow = 4.1,
            rowsToBeVisible = 3.2,
            fillDirection = Enum.FillDirection.Horizontal,
            horizontalAlignment = Enum.HorizontalAlignment.Center,
            listPaddingScale = Vector2.new(0.035, 0.05),
            size = UDim2.fromScale(1, 1),
            verticalAlignment = Enum.VerticalAlignment.Center
        }, v10)))
    end
}
