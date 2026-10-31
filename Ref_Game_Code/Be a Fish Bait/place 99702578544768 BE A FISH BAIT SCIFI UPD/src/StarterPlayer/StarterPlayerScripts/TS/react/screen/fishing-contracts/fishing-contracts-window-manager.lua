-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useMemo = react.useCallback, react.useMemo
local HttpService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").HttpService
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-window").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fishing-contracts")
local contractMilestones, fishingContractTemplateById, getFishingZoneForContract = v1.contractMilestones, v1.fishingContractTemplateById, v1.getFishingZoneForContract
local fish = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish")
local fishDataByName, isFishData = fish.fishDataByName, fish.isFishData
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerFishingContracts, selectPlayerInventory = selectors.selectPlayerFishingContracts, selectors.selectPlayerInventory
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(34, 137, 174)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(19, 79, 127))
})
local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(65, 190, 110)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 125, 75))
})

return {
    default = function() -- FishingContractsWindowManager | line: 29
        -- upvalues: react (copy), useCallback (copy), useMemo (copy), HttpService (copy), default (copy), default2 (copy), default3 (copy), useRootProducer (copy), useRootSelector (copy), functions (copy), localPlayerUserId (copy), abbreviate (copy), contractMilestones (copy), fishingContractTemplateById (copy), getFishingZoneForContract (copy), fishDataByName (copy), isFishData (copy), selectPlayerFishingContracts (copy), selectPlayerInventory (copy), v2 (copy), v3 (copy)
        local v4 = useRootProducer()
        local v5 = useRootSelector(selectPlayerFishingContracts(localPlayerUserId))
        local v6 = useRootSelector(selectPlayerInventory(localPlayerUserId))
        local v7 = useRootSelector(function(p1) -- line: 33
            return p1.leaderboard.weeklyContractScore or {}
        end)
        local v8 = useCallback(function() -- line: 36
            -- upvalues: v4 (copy)
            return v4.windowClosed({})
        end, { v4 })
        local v9 = useMemo(function() -- line: 39
            -- upvalues: v5 (copy), v6 (copy), fishingContractTemplateById (copy), fishDataByName (copy), isFishData (copy)
            if v5 and v6 then
                local t1 = {}

                for _, v10 in v5.dailyContractTemplateIds do
                    local v11 = string.gmatch(v10, utf8.charpattern)
                    local v12 = v11()
                    local v13 = v11()
                    local v14 = fishingContractTemplateById[v12]

                    if v14 then
                        local v15 = tonumber(v13)

                        if v15 ~= nil then
                            local t2 = {}

                            for v16, v17 in v6 do
                                local v18 = fishDataByName[v17.itemName]

                                if v17.itemType == "fish" and v17.exclusiveIndex == nil and v18 ~= nil and isFishData(v18) and v18.rarity == v14.targetRarity then
                                    table.insert(t2, v16)
                                end
                            end

                            table.insert(t1, {
                                matchingItemIds = t2,
                                slot = v15,
                                template = v14
                            })
                        end
                    end
                end

                return t1
            end

            return {}
        end, { v5, v6 })

        local function v19(p2, p3) -- line: 73
            -- upvalues: v4 (copy), HttpService (copy)
            v4.onScreenFeedbackAdded({
                id = HttpService:GenerateGUID(false),
                message = p2,
                type = p3
            })
        end

        if not v5 then
            return nil
        end

        local v20 = react.createElement("uilistlayout", {
            Padding = UDim.new(0.025, 0),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        local v21 = react.createElement(default2, {
            color = Color3.fromRGB(255, 220, 111),
            overrideProps = {
                TextScaled = true,
                Size = UDim2.fromScale(1, 0.1)
            },
            text = ("徽章 %*  ·  本周 %* 分"):format(abbreviate(v5.badgeBalance), (abbreviate(v5.weeklyScore)))
        })
        local v22 = table.create(#v9)

        local function v23(p4) -- line: 97
            -- upvalues: v4 (copy), v5 (copy), v19 (copy), react (copy), HttpService (copy), default2 (copy), default3 (copy), functions (copy), abbreviate (copy), getFishingZoneForContract (copy), v3 (copy)
            local v24 = ("%*-%*"):format(v5.dayKey, p4.slot)
            local v25 = table.find(v5.completedContractIds, v24) ~= nil
            local v26 = #p4.matchingItemIds >= p4.template.quantity
            local matchingItemIds = p4.matchingItemIds
            local t4 = {}
            local n1 = 0

            for v27, v28 in matchingItemIds do
                if v27 - 1 < p4.template.quantity == true then
                    n1 += 1
                    t4[n1] = v28
                end
            end

            return react.createElement("frame", {
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(28, 47, 67),
                key = v24,
                LayoutOrder = p4.slot + 1,
                Size = UDim2.fromScale(1, 0.2)
            }, react.createElement("uicorner", {
                CornerRadius = UDim.new(0.08, 0)
            }), react.createElement(default2, {
                color = Color3.fromRGB(255, 255, 255),
                overrideProps = {
                    TextScaled = true,
                    Position = UDim2.fromScale(0.04, 0.12),
                    Size = UDim2.fromScale(0.58, 0.32),
                    TextXAlignment = Enum.TextXAlignment.Left
                },
                text = ("%* · %* · %*"):format(string.upper(p4.template.tier), string.upper(p4.template.targetRarity), (getFishingZoneForContract(p4.template)))
            }), react.createElement("textlabel", {
                BackgroundTransparency = 1,
                TextScaled = true,
                Position = UDim2.fromScale(0.04, 0.48),
                Size = UDim2.fromScale(0.58, 0.35),
                Text = ("%* · %* 徽章 · %* 分"):format(if v25 then "已完成" else ("交付 %* 条（背包 %*）"):format(p4.template.quantity, #p4.matchingItemIds), p4.template.badgeReward, p4.template.scoreReward),
                TextColor3 = Color3.fromRGB(190, 211, 224),
                TextXAlignment = Enum.TextXAlignment.Left
            }), react.createElement(default3, {
                isStudded = true,
                anchorPoint = Vector2.new(1, 0.5),
                color = v3,
                frameSize = UDim2.fromScale(0.29, 0.58),
                font = Enum.Font.GothamBold,
                label = if v25 then "完成" elseif v26 then "交付" else "继续钓鱼",
                onClick = function() -- onClick | line: 148
                    -- upvalues: v24 (copy), t4 (copy), v25 (copy), v26 (copy), v4 (copy), v19 (copy), HttpService (copy), functions (copy), abbreviate (copy)
                    if v25 or not v26 then
                        return nil
                    end

                    functions.submitFishingContract(v24, t4):andThen(function(p5) -- line: 152
                        -- upvalues: v4 (copy), HttpService (copy), abbreviate (copy)
                        local v32 = if p5 == false then "委托交付失败" else ("委托完成！获得 $%*"):format((abbreviate(p5)))
                        local v33 = p5 == false and "error" or "success"

                        v4.onScreenFeedbackAdded({
                            id = HttpService:GenerateGUID(false),
                            message = v32,
                            type = v33
                        })
                    end):catch(function() -- line: 154
                        -- upvalues: v19 (copy)
                        return v19("委托请求失败", "error")
                    end)
                end,
                popoutColor = Color3.fromRGB(16, 84, 51),
                position = UDim2.fromScale(0.96, 0.5)
            }))
        end

        for v34, v35 in v9 do
            v22[v34] = v23(v35, v34 - 1, v9)
        end

        local t8 = {
            BackgroundTransparency = 1,
            LayoutOrder = 10,
            Size = UDim2.fromScale(1, 0.12)
        }
        local v36 = table.create(#contractMilestones)

        for v37, v38 in contractMilestones do
            local _ = v37 - 1
            local claimedMilestoneIds = v5.claimedMilestoneIds
            local id = v38.id

            if table.find(claimedMilestoneIds, id) ~= nil then
                v36[v37] = "已领"
            else
                v36[v37] = ("%* 单 +%*"):format(v38.requiredCompletedContracts, v38.badgeReward)
            end
        end

        t8.Text = ("每日里程碑：%*"):format((table.concat(v36, "  ·  ")))
        t8.TextColor3 = Color3.fromRGB(255, 214, 111)
        t8.TextScaled = true

        local v39 = react.createElement("textlabel", t8)
        local t9 = {
            BackgroundTransparency = 1,
            LayoutOrder = 11,
            Size = UDim2.fromScale(1, 0.12)
        }
        local t10 = {}

        local function v40(_, p7) -- line: 193
            return p7 < 3
        end

        local n2 = 0

        for v41, v42 in v7 do
            if v41 - 1 < 3 == true then
                n2 += 1
                t10[n2] = v42
            end
        end

        local v43 = table.create(#t10)

        local function v44(p8, p9) -- line: 206
            -- upvalues: abbreviate (copy)
            return (("%*. %* %*"):format(p9 + 1, p8.playerName, (abbreviate(p8.value))))
        end

        for v45, v46 in t10 do
            v43[v45] = ("%*. %* %*"):format(v45 - 1 + 1, v46.playerName, (abbreviate(v46.value)))
        end

        t9.Text = ("本周榜：%*"):format((table.concat(v43, "  ·  ")))
        t9.TextColor3 = Color3.fromRGB(190, 211, 224)
        t9.TextScaled = true

        return react.createElement(default, {
            aspectRatio = 1.35,
            title = "Fishing Contracts",
            bodyBg = Color3.fromRGB(14, 24, 38),
            headerBg = v2,
            onClose = v8,
            size = UDim2.fromScale(0.78, 0.7)
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.55),
            Size = UDim2.fromScale(0.9, 0.76)
        }, v20, v21, v22, v39, react.createElement("textlabel", t9)))
    end
}
