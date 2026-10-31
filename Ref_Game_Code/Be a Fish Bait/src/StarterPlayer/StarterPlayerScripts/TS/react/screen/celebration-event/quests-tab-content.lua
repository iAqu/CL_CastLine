-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useMemo, useState = react.useMemo, react.useState
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "scrolling-frame").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-countdown").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local formatCountdownClock = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").formatCountdownClock
local quests = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "quests")
local dailyQuests, eventQuests, getQuestDefinition = quests.dailyQuests, quests.eventQuests, quests.getQuestDefinition
local default5 = RuntimeLib.import(script, script.Parent, "quest-card").default

local function cloneMap(p1) -- line: 19
    local t1 = {}

    for v1, v2 in p1 do
        t1[v1] = v2
    end

    return t1
end

local t2 = {
    ["daily-playtime-1"] = 276,
    ["daily-minigame-play-1"] = 5,
    ["daily-area-1"] = 7200
}
local t3 = {
    ["daily-area-1"] = true
}

local function buildSeedState() -- line: 44
    -- upvalues: dailyQuests (copy), eventQuests (copy), t2 (copy), t3 (copy)
    local t4 = {}
    local t5 = {}
    local t6 = {}
    local v3 = #t6
    local v4 = #dailyQuests

    table.move(dailyQuests, 1, v4, v3 + 1, t6)

    local v5 = v3 + v4

    table.move(eventQuests, 1, #eventQuests, v5 + 1, t6)

    for _, v6 in t6 do
        local questId = v6.questId
        local v7 = t2[v6.questId]

        if v7 == nil then
            v7 = 0
        end

        t4[questId] = v7

        local questId3 = v6.questId
        local v8 = t3[v6.questId]

        if v8 == nil then
            v8 = false
        end

        t5[questId3] = v8
    end

    return {
        claimed = t5,
        progress = t4
    }
end

local function getNextUtcMidnightTimestamp(p2) -- line: 74
    local v9 = DateTime.fromUnixTimestamp(p2):ToUniversalTime()

    return DateTime.fromUniversalTime(v9.Year, v9.Month, v9.Day, 0, 0, 0).UnixTimestamp + 86400
end

local function QuestGrid(p3) -- line: 79
    -- upvalues: react (copy), default3 (copy), default5 (copy)
    local onClaim, quests, state = p3.onClaim, p3.quests, p3.state
    local v10 = table.create(#quests)

    local function v11(p4) -- line: 85
        -- upvalues: onClaim (copy), state (copy), react (copy), default5 (copy)
        local t7 = {
            definition = p4
        }
        local v12 = state.claimed[p4.questId]

        t7.isClaimed = v12 ~= nil and v12
        t7.key = p4.questId
        t7.onClaim = onClaim

        local v13 = state.progress[p4.questId]

        t7.progress = if v13 == nil then 0 else v13

        return react.createElement(default5, t7)
    end

    for v14, v15 in quests do
        v10[v14] = v11(v15, v14 - 1, quests)
    end

    return react.createElement(default3, {
        cellsPerRow = 2,
        scrollBarThickness = 6,
        zIndex = 2,
        fillDirection = Enum.FillDirection.Vertical,
        listPaddingScale = Vector2.new(0.03, 0.05),
        padding = {
            all = UDim.new(0, 4)
        },
        rowsToBeVisible = math.ceil(#quests / 2),
        scrollBarColor = Color3.fromRGB(10, 10, 10),
        size = UDim2.fromScale(1, 1)
    }, v10)
end

return {
    default = function() -- QuestsTabContent | line: 125
        -- upvalues: react (copy), useMemo (copy), useState (copy), Workspace (copy), default (copy), default2 (copy), default4 (copy), useTheme (copy), formatCountdownClock (copy), dailyQuests (copy), eventQuests (copy), getQuestDefinition (copy), cloneMap (copy), t2 (copy), t3 (copy), buildSeedState (copy), QuestGrid (copy)
        local v17 = useTheme()
        local v18, v19 = useState(buildSeedState)
        local secondsLeft = default4((useMemo(function() -- line: 128
            -- upvalues: Workspace (copy)
            local ServerTimeNow = Workspace:GetServerTimeNow()
            local v21 = DateTime.fromUnixTimestamp(ServerTimeNow):ToUniversalTime()

            return DateTime.fromUniversalTime(v21.Year, v21.Month, v21.Day, 0, 0, 0).UnixTimestamp + 86400
        end, {}))).secondsLeft

        local function v22(p5) -- line: 133
            -- upvalues: v19 (copy), getQuestDefinition (copy), cloneMap (copy)
            v19(function(p6) -- line: 134
                -- upvalues: p5 (copy), getQuestDefinition (copy), cloneMap (copy)
                if p6.claimed[p5] == true then
                    return p6
                end

                local v23 = getQuestDefinition(p5)

                if not v23 then
                    return p6
                end

                local v24 = p6.progress[p5]

                if v24 == nil then
                    v24 = 0
                end

                if v24 < v23.targetAmount then
                    return p6
                end

                local v25 = cloneMap(p6.claimed)

                v25[p5] = true

                return {
                    claimed = v25,
                    progress = p6.progress
                }
            end)
        end

        local function v26() -- line: 163
            -- upvalues: v19 (copy), dailyQuests (copy), cloneMap (copy), t2 (copy), t3 (copy)
            v19(function(p7) -- line: 164
                -- upvalues: dailyQuests (copy), cloneMap (copy), t2 (copy), t3 (copy)
                local v27 = cloneMap(p7.progress)
                local v28 = cloneMap(p7.claimed)

                for _, v29 in dailyQuests do
                    local questId = v29.questId
                    local v30 = t2[v29.questId]

                    if v30 == nil then
                        v30 = 0
                    end

                    v27[questId] = v30

                    local questId3 = v29.questId
                    local v31 = t3[v29.questId]

                    if v31 == nil then
                        v31 = false
                    end

                    v28[questId3] = v31
                end

                return {
                    claimed = v28,
                    progress = v27
                }
            end)
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.92, 0.94)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.015, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Top
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            ZIndex = 2,
            Size = UDim2.fromScale(1, 0.055)
        }, react.createElement(default, {
            text = "Daily Quests:",
            anchorPoint = Vector2.new(0, 0.5),
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 2,
                Font = v17.textFont2,
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.fromScale(0.5, 1),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            position = UDim2.fromScale(0, 0.5)
        }), react.createElement(default, {
            anchorPoint = Vector2.new(1, 0.5),
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 2,
                Font = v17.textFont,
                Position = UDim2.fromScale(1, 0.5),
                Size = UDim2.fromScale(0.5, 1),
                TextXAlignment = Enum.TextXAlignment.Right
            },
            position = UDim2.fromScale(1, 0.5),
            text = secondsLeft:map(function(p8) -- line: 232
                -- upvalues: formatCountdownClock (copy)
                return (("Refresh In: %*"):format((formatCountdownClock(p8))))
            end)
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            Size = UDim2.fromScale(1, 0.36)
        }, react.createElement(QuestGrid, {
            onClaim = v22,
            quests = dailyQuests,
            state = v18
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 3,
            ZIndex = 2,
            Size = UDim2.fromScale(1, 0.055)
        }, react.createElement(default, {
            text = "Event Quests:",
            anchorPoint = Vector2.new(0, 0.5),
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 2,
                Font = v17.textFont2,
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.fromScale(0.5, 1),
                TextXAlignment = Enum.TextXAlignment.Left
            },
            position = UDim2.fromScale(0, 0.5)
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 4,
            Size = UDim2.fromScale(1, 0.25)
        }, react.createElement(QuestGrid, {
            onClaim = v22,
            quests = eventQuests,
            state = v18
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 5,
            ZIndex = 2,
            Size = UDim2.fromScale(1, 0.08)
        }, react.createElement(default2, {
            cornerRadius = 0.2,
            label = "Refresh Quests",
            zIndex = 2,
            anchorPoint = Vector2.new(0.5, 0.5),
            color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(106, 250, 11)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 193, 8))
            }),
            frameSize = UDim2.fromScale(0.4, 0.9),
            onClick = v26,
            popoutColor = Color3.fromRGB(10, 120, 10),
            position = UDim2.fromScale(0.5, 0.5)
        })))
    end
}
