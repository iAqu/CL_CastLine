-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-window").default
local default2 = RuntimeLib.import(script, script.Parent, "daily-reward-item").default
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "daily-rewards-utils")
local dailyRewards, dailyRewardLoopStartDay, dailyRewardWeekLength, getDay2Reward = v1.dailyRewards, v1.dailyRewardLoopStartDay, v1.dailyRewardWeekLength, v1.getDay2Reward
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "scrolling-frame").default
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerAquariumMoneyPerSecond, selectPlayerAquariumOwnedSkins = selectors.selectPlayerAquariumMoneyPerSecond, selectors.selectPlayerAquariumOwnedSkins
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local useSelectorCreator = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-reflex").useSelectorCreator
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 38, 38)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(72, 72, 72))
})

return {
    default = function(p1) -- DailyRewardWindow | line: 22
        -- upvalues: react (copy), useEffect (copy), useState (copy), default (copy), default2 (copy), dailyRewards (copy), dailyRewardLoopStartDay (copy), dailyRewardWeekLength (copy), getDay2Reward (copy), default3 (copy), selectPlayerAquariumMoneyPerSecond (copy), selectPlayerAquariumOwnedSkins (copy), localPlayerUserId (copy), useSelectorCreator (copy), useTheme (copy), v2 (copy)
        local v3 = useTheme()
        local v4 = useSelectorCreator(selectPlayerAquariumMoneyPerSecond, localPlayerUserId)
        local v5 = useSelectorCreator(selectPlayerAquariumOwnedSkins, localPlayerUserId)

        if v5 ~= nil then
            v5 = table.find(v5, "Fossil") ~= nil
        end

        local v6 = v5 == true
        local v7 = if p1.claimableDayIndex >= dailyRewardLoopStartDay then dailyRewardLoopStartDay else 1
        local v8, v9 = useState(v7)
        local v10 = false

        for i = 1, dailyRewardWeekLength do
            local v11 = if i == 2 then getDay2Reward(v6) else dailyRewards[i]

            if v11 ~= nil and p1.claimedRewards[v11.rewardId] == true then
                v10 = true
                break
            end
        end

        local v12 = v8 == dailyRewardLoopStartDay and p1.claimableDayIndex >= dailyRewardLoopStartDay and not v10

        useEffect(function() -- line: 48
            -- upvalues: v7 (copy), v9 (copy)
            v9(v7)
        end, { v7 })

        local v13 = v8 > 1
        local v14 = v8 < dailyRewardLoopStartDay
        local t1 = {}

        for i = v8, v8 + dailyRewardWeekLength - 1 do
            local v15 = dailyRewards[i]

            if v15 then
                local v16 = if i == 2 then getDay2Reward(v6) else v15
                local v17 = p1.claimedRewards[v16.rewardId] == true
                local v18 = i == p1.claimableDayIndex and p1.canClaim

                table.insert(t1, {
                    displayDayNumber = if v12 then i - dailyRewardWeekLength else i,
                    isClaimable = v18,
                    isClaimed = v17,
                    reward = v16,
                    rewardDayIndex = i
                })
            end
        end

        table.sort(t1, function(p2, p3) -- line: 73
            return p2.rewardDayIndex < p3.rewardDayIndex
        end)

        local t3 = {}
        local n1 = 0

        for v19, v20 in t1 do
            local _ = v19 - 1

            if v20.rewardDayIndex < v8 + dailyRewardWeekLength - 1 == true then
                n1 += 1
                t3[n1] = v20
            end
        end

        local v21

        for v22, v23 in t1 do
            local _ = v22 - 1

            if v23.rewardDayIndex == v8 + dailyRewardWeekLength - 1 == true then
                v21 = v23
                break
            end

            v21 = nil
        end

        local function v24(p4, p5, p6, p7) -- line: 103
            -- upvalues: v3 (copy), react (copy)
            return react.createElement("imagebutton", {
                BorderSizePixel = 0,
                ZIndex = 30,
                AnchorPoint = Vector2.new(0.5, 0.5),
                AutoButtonColor = p6,
                BackgroundColor3 = if p6 then Color3.fromRGB(32, 32, 38) else Color3.fromRGB(72, 72, 78),
                BackgroundTransparency = p6 and 0.05 or 0.25,
                Event = {
                    Activated = function() -- Activated | line: 111
                        -- upvalues: p6 (copy), p7 (copy)
                        return p6 and p7()
                    end
                },
                Position = p5,
                Size = UDim2.fromScale(0.065, 0.12)
            }, react.createElement("uicorner", {
                CornerRadius = UDim.new(0.18, 0)
            }), react.createElement("uistroke", {
                Thickness = 0.04,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = if p6 then Color3.fromRGB(0, 0, 0) else Color3.fromRGB(36, 36, 40),
                StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
            }), react.createElement("textlabel", {
                BackgroundTransparency = 1,
                TextScaled = true,
                ZIndex = 31,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Font = v3.textFont,
                Position = UDim2.fromScale(p4 == "<" and 0.47 or 0.53, 0.5),
                Size = UDim2.fromScale(0.85, 0.85),
                Text = p4,
                TextColor3 = if p6 then Color3.fromRGB(255, 255, 255) else Color3.fromRGB(150, 150, 155),
                TextStrokeColor3 = if p6 then Color3.fromRGB(0, 0, 0) else Color3.fromRGB(48, 48, 52),
                TextStrokeTransparency = p6 and 0 or 0.35
            }))
        end

        local v27 = react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1.78
        })
        local v28 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.025, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        })
        local v29 = table.create(#t3)

        local function v30(p8) -- line: 151
            -- upvalues: p1 (copy), v4 (copy), react (copy), default2 (copy)
            return react.createElement(default2, {
                claimDayIndex = p8.rewardDayIndex,
                dailyReward = p8.reward,
                dayNumber = p8.displayDayNumber,
                isClaimable = p8.isClaimable,
                isClaimed = p8.isClaimed,
                justClaimed = p1.claimedDayIndex == p8.rewardDayIndex,
                key = p8.reward.rewardId,
                moneyPerSecond = v4,
                onClaim = p1.onClaim
            })
        end

        for v31, v32 in t3 do
            v29[v31] = v30(v32, v31 - 1, t3)
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.55, 0.55)
        }, v27, react.createElement(default, {
            title = "Daily Rewards!",
            bodyBg = Color3.fromRGB(20, 20, 25),
            bodyOverlay = p1.bodyOverlay,
            headerBg = v2,
            onClose = p1.onClose,
            size = UDim2.fromScale(1, 1)
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.97),
            Size = UDim2.fromScale(0.95, 0.82)
        }, v28, react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            ZIndex = 2,
            Size = UDim2.fromScale(0.67, 1)
        }, react.createElement(default3, {
            cellsPerRow = 3,
            rowsToBeVisible = 2,
            fillDirection = Enum.FillDirection.Horizontal,
            horizontalAlignment = Enum.HorizontalAlignment.Center,
            listPaddingScale = Vector2.new(0.04, 0.03),
            padding = {
                all = UDim.new(0, 4)
            },
            size = UDim2.fromScale(1, 1),
            verticalAlignment = Enum.VerticalAlignment.Center
        }, v29)), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            ZIndex = 2,
            Size = UDim2.fromScale(0.305, 1)
        }, v21 ~= nil and react.createElement(default2, {
            claimDayIndex = v21.rewardDayIndex,
            dailyReward = v21.reward,
            dayNumber = v21.displayDayNumber,
            isClaimable = v21.isClaimable,
            isClaimed = v21.isClaimed,
            justClaimed = p1.claimedDayIndex == v21.rewardDayIndex,
            key = v21.reward.rewardId,
            moneyPerSecond = v4,
            onClaim = p1.onClaim
        })))), v24("<", UDim2.fromScale(0.895, 1.08), v13, function() -- line: 218
            -- upvalues: v9 (copy)
            return v9(1)
        end), v24(">", UDim2.fromScale(0.9675, 1.08), v14, function() -- line: 220
            -- upvalues: v9 (copy), dailyRewardLoopStartDay (copy)
            return v9(dailyRewardLoopStartDay)
        end))
    end
}
