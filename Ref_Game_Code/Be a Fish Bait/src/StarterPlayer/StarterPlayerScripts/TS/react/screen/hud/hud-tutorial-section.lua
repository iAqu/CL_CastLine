-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local CollectionService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").CollectionService
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelector
local selectTutorialStep = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "tutorial.selectors").selectTutorialStep
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerStat, selectPlayerAquarium = selectors.selectPlayerStat, selectors.selectPlayerAquarium
local mountFishPreviewItemNameAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "mount-fish-preview-atom").mountFishPreviewItemNameAtom
local tutorialSteps = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "tutorial-utils").tutorialSteps
local fishDataByName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish").fishDataByName
local getLevelUpCost = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "aquarium-utils").getLevelUpCost
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "tutorial", "tutorial-text").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "tutorial", "tutorial-beam").default
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId

local function getPlotAttachment() -- line: 21
    -- upvalues: CollectionService (copy), localPlayerUserId (copy)
    for _, v1 in CollectionService:GetTagged("Plot") do
        if v1:GetAttribute("ownerUserId") == localPlayerUserId then
            local InteractableAreaPos = v1:FindFirstChild("InteractableAreaPos")

            if InteractableAreaPos ~= nil and InteractableAreaPos:IsA("Attachment") then
                return InteractableAreaPos
            end
        end
    end

    return nil
end

local function getMoneyCollectionAreaAttachment() -- line: 32
    -- upvalues: CollectionService (copy), localPlayerUserId (copy)
    for _, v2 in CollectionService:GetTagged("PlotMoneyCollectionArea") do
        if v2:GetAttribute("ownerUserId") == localPlayerUserId and v2:IsA("Model") then
            local MoneyEarnedDisplay = v2:FindFirstChild("MoneyEarnedDisplay")

            if MoneyEarnedDisplay ~= nil and MoneyEarnedDisplay:IsA("BasePart") then
                local TutorialBeamAnchor = MoneyEarnedDisplay:FindFirstChild("TutorialBeamAnchor")

                if TutorialBeamAnchor ~= nil and TutorialBeamAnchor:IsA("Attachment") then
                    return TutorialBeamAnchor
                end

                local Attachment = Instance.new("Attachment")

                Attachment.Name = "TutorialBeamAnchor"
                Attachment.Parent = MoneyEarnedDisplay

                return Attachment
            end
        end
    end

    return nil
end

local function getBeamTargetAttachment(p1, p2) -- line: 50
    -- upvalues: CollectionService (copy), tutorialSteps (copy), getPlotAttachment (copy), getMoneyCollectionAreaAttachment (copy)
    if p1 ~= tutorialSteps.walkToDock and p1 ~= tutorialSteps.catchAFish and p1 ~= tutorialSteps.goToWeightsShop then
        if p1 == tutorialSteps.addFishToAquarium or p1 == tutorialSteps.equipBestFish or p1 == tutorialSteps.levelUpFish or p2 then
            return (getPlotAttachment())
        end

        return if p1 == tutorialSteps.collectMoney then getMoneyCollectionAreaAttachment() else nil
    end

    local v3 = if p1 == tutorialSteps.goToWeightsShop then "weightsShop" else "dock"

    for _, v4 in CollectionService:GetTagged("TutorialBeamTarget") do
        if v4:GetAttribute("targetId") == v3 and v4:IsA("Attachment") then
            return v4
        end
    end

    return nil
end

return {
    default = function(p3) -- HudTutorialSection | line: 65
        -- upvalues: subscribe (copy), react (copy), useEffect (copy), useState (copy), CollectionService (copy), useRootSelector (copy), selectTutorialStep (copy), selectPlayerStat (copy), selectPlayerAquarium (copy), mountFishPreviewItemNameAtom (copy), tutorialSteps (copy), fishDataByName (copy), getLevelUpCost (copy), default (copy), default2 (copy), localPlayerUserId (copy), getBeamTargetAttachment (copy)
        local hideText = p3.hideText

        if hideText == nil then
            hideText = false
        end

        local v5 = useRootSelector(selectTutorialStep)
        local v6 = tutorialSteps.completed <= v5
        local v7 = useRootSelector(selectPlayerStat(localPlayerUserId, "money"))

        if v7 == nil then
            v7 = 0
        end

        local v8 = useRootSelector(selectPlayerAquarium(localPlayerUserId))
        local v9, v10 = useState(mountFishPreviewItemNameAtom())

        useEffect(function() -- line: 79
            -- upvalues: v10 (copy), subscribe (copy), mountFishPreviewItemNameAtom (copy)
            return subscribe(mountFishPreviewItemNameAtom, v10)
        end, {})

        local v11 = v9 ~= nil
        local v12 = 0

        if v5 == tutorialSteps.collectMoney then
            if v8 ~= nil then
                for _, v13 in v8.fishItems do
                    local v14 = fishDataByName[v13.fishSpecies]

                    v12 = if v14 == nil or v14.moneyPerSecond == nil then 0 else getLevelUpCost(v14.moneyPerSecond, v13.level)
                    break
                end
            end
        end

        local v15 = v5 == tutorialSteps.collectMoney and v12 > 0 and v12 <= v7
        local v16, v17 = useState(nil)

        useEffect(function() -- line: 96
            -- upvalues: v5 (copy), v17 (copy), v15 (copy), v11 (copy), CollectionService (copy), tutorialSteps (copy), getBeamTargetAttachment (copy)
            local v18 = v5 == tutorialSteps.addFishToAquarium or v5 == tutorialSteps.equipBestFish or v5 == tutorialSteps.levelUpFish or v15
            local v19 = v5 == tutorialSteps.collectMoney and not v15
            local v20 = v5 == tutorialSteps.walkToDock or v5 == tutorialSteps.catchAFish or v5 == tutorialSteps.goToWeightsShop

            if not v18 and not v19 and not v20 or v11 then
                v17(nil)

                return nil
            end

            local v21 = getBeamTargetAttachment(v5, v15)

            v17(v21)

            if v21 ~= nil then
                return nil
            end

            local v22 = if v18 then "Plot" elseif v19 then "PlotMoneyCollectionArea" else "TutorialBeamTarget"
            local connection

            connection = CollectionService:GetInstanceAddedSignal(v22):Connect(function() -- line: 124
                -- upvalues: connection (ref), v5 (copy), v17 (copy), v15 (copy), getBeamTargetAttachment (copy)
                local v23 = getBeamTargetAttachment(v5, v15)

                if v23 == nil then
                    return
                end

                v17(v23)
                connection:Disconnect()
            end)

            return function() -- line: 131
                -- upvalues: connection (ref)
                return connection:Disconnect()
            end
        end, { v5, v15, v11 })

        if v6 then
            return nil
        end

        return react.createElement(react.Fragment, nil, not hideText and react.createElement(default), v16 ~= nil and react.createElement(default2, {
            targetAttachment = v16
        }))
    end
}
