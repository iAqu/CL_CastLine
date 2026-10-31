-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent, "celebration-reward-item").default
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "celebration-reward-utils")
local celebrationRewards, celebrationRewardLoopStartDay, celebrationRewardWeekLength = v1.celebrationRewards, v1.celebrationRewardLoopStartDay, v1.celebrationRewardWeekLength
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "scrolling-frame").default
local selectPlayerAquariumMoneyPerSecond = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerAquariumMoneyPerSecond
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local useSelectorCreator = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-reflex").useSelectorCreator

return {
    default = function(p1) -- CelebrationRewardGrid | line: 13
        -- upvalues: react (copy), default (copy), celebrationRewards (copy), celebrationRewardLoopStartDay (copy), celebrationRewardWeekLength (copy), default2 (copy), selectPlayerAquariumMoneyPerSecond (copy), localPlayerUserId (copy), useSelectorCreator (copy)
        local weekStart = p1.weekStart
        local v2 = useSelectorCreator(selectPlayerAquariumMoneyPerSecond, localPlayerUserId)
        local v3 = false

        for i = 1, celebrationRewardWeekLength do
            local v4 = celebrationRewards[i]

            if v4 ~= nil and p1.claimedRewards[v4.rewardId] == true then
                v3 = true
                break
            end
        end

        local v5 = weekStart == celebrationRewardLoopStartDay and p1.claimableDayIndex >= celebrationRewardLoopStartDay and not v3
        local t1 = {}

        for i = weekStart, weekStart + celebrationRewardWeekLength - 1 do
            local v6 = celebrationRewards[i]

            if v6 then
                local v7 = p1.claimedRewards[v6.rewardId] == true
                local v8 = i == p1.claimableDayIndex and p1.canClaim

                table.insert(t1, {
                    displayDayNumber = if v5 then i - celebrationRewardWeekLength else i,
                    isClaimable = v8,
                    isClaimed = v7,
                    reward = v6,
                    rewardDayIndex = i
                })
            end
        end

        table.sort(t1, function(p2, p3) -- line: 51
            return p2.rewardDayIndex < p3.rewardDayIndex
        end)

        local t3 = {}
        local n1 = 0

        for v9, v10 in t1 do
            local _ = v9 - 1

            if v10.rewardDayIndex < weekStart + celebrationRewardWeekLength - 1 == true then
                n1 += 1
                t3[n1] = v10
            end
        end

        local v11

        for v12, v13 in t1 do
            local _ = v12 - 1

            if v13.rewardDayIndex == weekStart + celebrationRewardWeekLength - 1 == true then
                v11 = v13
                break
            end

            v11 = nil
        end

        local v14 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.025, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        })
        local v15 = table.create(#t3)

        local function v16(p4) -- line: 92
            -- upvalues: p1 (copy), v2 (copy), react (copy), default (copy)
            return react.createElement(default, {
                celebrationReward = p4.reward,
                claimDayIndex = p4.rewardDayIndex,
                dayNumber = p4.displayDayNumber,
                isClaimable = p4.isClaimable,
                isClaimed = p4.isClaimed,
                justClaimed = p1.claimedDayIndex == p4.rewardDayIndex,
                key = p4.reward.rewardId,
                moneyPerSecond = v2,
                onClaim = p1.onClaim
            })
        end

        for v17, v18 in t3 do
            v15[v17] = v16(v18, v17 - 1, t3)
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 2,
            AnchorPoint = p1.anchorPoint,
            Position = p1.position,
            Size = p1.size or UDim2.fromScale(1, 1)
        }, v14, react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            ZIndex = 2,
            Size = UDim2.fromScale(0.67, 1)
        }, react.createElement(default2, {
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
        }, v15)), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            ZIndex = 2,
            Size = UDim2.fromScale(0.305, 1)
        }, v11 ~= nil and react.createElement(default, {
            celebrationReward = v11.reward,
            claimDayIndex = v11.rewardDayIndex,
            dayNumber = v11.displayDayNumber,
            isClaimable = v11.isClaimable,
            isClaimed = v11.isClaimed,
            justClaimed = p1.claimedDayIndex == v11.rewardDayIndex,
            key = v11.reward.rewardId,
            moneyPerSecond = v2,
            onClaim = p1.onClaim
        })))
    end
}
