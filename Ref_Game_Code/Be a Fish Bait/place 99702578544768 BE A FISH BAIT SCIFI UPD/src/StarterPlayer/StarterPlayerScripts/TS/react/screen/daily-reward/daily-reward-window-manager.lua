-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useMemo, useState = react.useEffect, react.useMemo, react.useState
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local HttpService, ReplicatedStorage, Workspace = services.HttpService, services.ReplicatedStorage, services.Workspace
local cameraShakeEnabledAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "haptics").cameraShakeEnabledAtom
local shake = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxutil", "shake")
local dailyRewardConfettiTriggerAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "daily-reward-confetti-atom").dailyRewardConfettiTriggerAtom
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "reward-screen").default
local default2 = RuntimeLib.import(script, script.Parent, "daily-reward-window").default
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerAquariumMoneyPerSecond, selectPlayerAquariumOwnedSkins, selectPlayerRewards, selectDayLastClaimedDailyReward = selectors.selectPlayerAquariumMoneyPerSecond, selectors.selectPlayerAquariumOwnedSkins, selectors.selectPlayerRewards, selectors.selectDayLastClaimedDailyReward
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "daily-rewards-utils")
local dailyRewards, dailyRewardCooldownSeconds, getDailyRewardDisplayText, getDay2Reward = v1.dailyRewards, v1.dailyRewardCooldownSeconds, v1.getDailyRewardDisplayText, v1.getDay2Reward
local formatDurationSeconds = v1.formatDurationSeconds
local analyticsDailyRewardFunnelSteps = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "analytics-constants").analyticsDailyRewardFunnelSteps
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local clientProducer = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "producer").clientProducer
local allFishData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish").allFishData
local getAquariumSkinData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-skins").getAquariumSkinData
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images

local function getRewardScreenText(p1, p2) -- line: 38
    -- upvalues: getDailyRewardDisplayText (copy), formatDurationSeconds (copy)
    local v2, v3

    if p1.rewardType == "money" and p1.rewardMoneyDurationSeconds ~= nil then
        v2 = formatDurationSeconds(p1.rewardMoneyDurationSeconds)
        v3 = if p2 ~= nil then p2 else 0

        return (("%* Time Skip\n%*"):format(v2, (getDailyRewardDisplayText(p1, v3))))
    end

    return getDailyRewardDisplayText(p1, if p2 == nil then 0 else p2)
end

local function getRewardScreenIcon(p3) -- line: 55
    -- upvalues: getAquariumSkinData (copy)
    local v5

    if p3.rewardType ~= "aquariumSkin" or p3.rewardSkinName == nil then
        return p3.rewardIcon
    else
        v5 = getAquariumSkinData(p3.rewardSkinName)

        if v5 ~= nil then
            v5 = v5.imageId
        end
    end

    if v5 == nil then
        v5 = p3.rewardIcon
    end

    return v5
end

local function getRewardScreenBadgeText(p4) -- line: 69
    return if p4.rewardId == "daily-7" then "125% STRONGER" else nil
end

local function formatTimeRemaining(p5) -- line: 75
    if p5 >= 3600 then
        local v8 = math.floor(p5 / 3600)

        return (("%* hour%*"):format(v8, if v8 == 1 then "" else "s"))
    end

    if p5 >= 60 then
        local v10 = math.floor(p5 / 60)

        return (("%* min%*"):format(v10, if v10 == 1 then "" else "s"))
    end

    return (("%*s"):format(p5))
end

return {
    default = function() -- DailyRewardWindowManager | line: 86
        -- upvalues: RuntimeLib (copy), react (copy), useEffect (copy), useMemo (copy), useState (copy), HttpService (copy), ReplicatedStorage (copy), Workspace (copy), cameraShakeEnabledAtom (copy), shake (copy), dailyRewardConfettiTriggerAtom (copy), default (copy), default2 (copy), useRootProducer (copy), useRootSelector (copy), selectPlayerAquariumMoneyPerSecond (copy), selectPlayerAquariumOwnedSkins (copy), selectPlayerRewards (copy), selectDayLastClaimedDailyReward (copy), localPlayerUserId (copy), dailyRewards (copy), dailyRewardCooldownSeconds (copy), getDay2Reward (copy), analyticsDailyRewardFunnelSteps (copy), functions (copy), clientProducer (copy), allFishData (copy), getAquariumSkinData (copy), images (copy), getRewardScreenText (copy)
        local v11 = useRootProducer()
        local v12 = useRootSelector(selectPlayerRewards(localPlayerUserId))
        local v13 = useRootSelector(selectDayLastClaimedDailyReward(localPlayerUserId))
        local v14 = useRootSelector(selectPlayerAquariumMoneyPerSecond(localPlayerUserId))
        local v15 = useRootSelector(selectPlayerAquariumOwnedSkins(localPlayerUserId))
        local v16, v17 = useState(nil)
        local v18, v19 = useState(nil)
        local v20 = useMemo(function() -- line: 94
            -- upvalues: v12 (copy), dailyRewards (copy)
            local t1 = {}

            for _, v21 in dailyRewards do
                local v22 = v12

                if v12 ~= nil then
                    v22 = v12[v21.rewardId]
                end

                local v23 = v22 == true

                t1[v21.rewardId] = v23
            end

            return t1
        end, { v12 })
        local v24

        if v13 then
            v24 = tonumber(v13.dailyRewardIndex)

            if v24 == nil then
                v24 = 1
            end
        else
            v24 = 1
        end

        local v25

        if not v13 or v13.day == 0 then
            v25 = true
        else
            local v26 = DateTime.fromUniversalTime(v13.year, v13.month, v13.day, 0, 0, 0)

            v25 = DateTime.now().UnixTimestamp - v26.UnixTimestamp >= dailyRewardCooldownSeconds
        end

        if v15 ~= nil then
            v15 = table.find(v15, "Fossil") ~= nil
        end

        local v27 = v15 == true

        useEffect(function() -- line: 142
            -- upvalues: v24 (ref), v25 (ref), analyticsDailyRewardFunnelSteps (copy), functions (copy)
            if v25 and not (v24 < 1) and not (v24 > 14) then
                local v29 = analyticsDailyRewardFunnelSteps[("uiSeenDay%*"):format(v24)]

                if v29 then
                    functions.logDailyRewardFunnelStep(v29.stepName)
                end

                return
            end

            return nil
        end, { v25, v24 })

        local function v30() -- line: 152
            -- upvalues: ReplicatedStorage (copy), Workspace (copy), cameraShakeEnabledAtom (copy), shake (copy), dailyRewardConfettiTriggerAtom (copy)
            dailyRewardConfettiTriggerAtom(function(p6) -- line: 153
                return p6 + 1
            end)

            local Sounds = ReplicatedStorage:FindFirstChild("Sounds")

            if Sounds ~= nil then
                Sounds = Sounds:FindFirstChild("sfx")

                if Sounds ~= nil then
                    Sounds = Sounds:FindFirstChild("ButtonSuccess")
                end
            end

            if if Sounds == nil then Sounds else Sounds:IsA("Sound") then
                Sounds:Play()
            end

            local CurrentCamera = Workspace.CurrentCamera

            if CurrentCamera and cameraShakeEnabledAtom() then
                local v31 = shake.new()

                v31.Amplitude = 1.5
                v31.Frequency = 0.15
                v31.FadeInTime = 0
                v31.FadeOutTime = 0.6
                v31.SustainTime = 0.05
                v31.PositionInfluence = Vector3.new(0.3, 0.3, 0.3)
                v31.RotationInfluence = Vector3.new(0.1, 0.1, 0.1)
                v31:Start()
                v31:BindToRenderStep(shake.NextRenderName(), Enum.RenderPriority.Last.Value, function(p7, p8) -- line: 182
                    -- upvalues: CurrentCamera (copy)
                    local _CFrame = CurrentCamera.CFrame
                    local v32 = CFrame.new(p7)
                    local v33 = CFrame.fromEulerAnglesXYZ(p8.X, p8.Y, p8.Z)

                    CurrentCamera.CFrame = _CFrame * v32 * v33
                end)
            end
        end

        local function v34(p9) -- line: 190
            -- upvalues: v17 (copy), v19 (copy), v27 (copy), v30 (copy), RuntimeLib (copy), HttpService (copy), dailyRewards (copy), getDay2Reward (copy), functions (copy), clientProducer (copy)
            task.spawn(RuntimeLib.async(function() -- line: 191
                -- upvalues: p9 (copy), v17 (copy), v19 (copy), v27 (copy), v30 (copy), RuntimeLib (copy), HttpService (copy), dailyRewards (copy), getDay2Reward (copy), functions (copy), clientProducer (copy)
                local v35 = dailyRewards[p9]

                if v35 then
                    if p9 == 2 then
                        v35 = getDay2Reward(v27)
                    end
                else
                    v35 = nil
                end

                local v36 = RuntimeLib.await(functions.claimDailyReward(p9))
                local v37 = HttpService:GenerateGUID(false)

                if v36 == true then
                    v17(p9)
                    v19(v35)
                    v30()
                    clientProducer.onScreenFeedbackAdded({
                        type = "success",
                        id = v37,
                        message = ("Day %* reward claimed!"):format(p9)
                    })
                elseif type(v36) == "number" and v36 > 0 then
                    local v38

                    if v36 >= 3600 then
                        local v40 = math.floor(v36 / 3600)

                        v38 = ("%* hour%*"):format(v40, if v40 == 1 then "" else "s")
                    elseif v36 >= 60 then
                        local v42 = math.floor(v36 / 60)

                        v38 = ("%* min%*"):format(v42, if v42 == 1 then "" else "s")
                    else
                        v38 = ("%*s"):format(v36)
                    end

                    clientProducer.onScreenFeedbackAdded({
                        type = "error",
                        id = v37,
                        message = ("Not available, return in %* to claim!"):format(v38)
                    })
                elseif v36 == "backpackFull" then
                    clientProducer.onScreenFeedbackAdded({
                        message = "Your backpack is full! Make space to claim this reward.",
                        type = "error",
                        id = v37
                    })
                else
                    clientProducer.onScreenFeedbackAdded({
                        message = "Could not claim reward.",
                        type = "error",
                        id = v37
                    })
                end
            end))
        end

        local v43 = if v18 == nil then v18 else v18.rewardType
        local v44

        if v43 == "fish" and v18.rewardFishName ~= nil then
            for v45, v46 in allFishData do
                local _ = v45 - 1

                if v46.name == v18.rewardFishName == true then
                    v44 = v46
                    break
                end

                v44 = nil
            end
        end

        local v47

        if v18 ~= nil then
            local v48 = false

            if v18.rewardType ~= "aquariumSkin" or v18.rewardSkinName == nil then
                v48 = true
            else
                v47 = getAquariumSkinData(v18.rewardSkinName)

                if v47 ~= nil then
                    v47 = v47.imageId
                end
            end

            if v48 or v47 == nil then
                v47 = v18.rewardIcon
            end
        end

        local v49 = if v18 == nil or v44 ~= nil then nil else getRewardScreenText(v18, v14)
        local v50 = react.createElement(default2, {
            canClaim = v25,
            claimableDayIndex = v24,
            claimedDayIndex = v16,
            claimedRewards = v20,
            onClaim = v34,
            onClose = function() -- onClose | line: 261
                -- upvalues: v11 (copy)
                return v11.windowClosed({})
            end
        })
        local v51 = v18 ~= nil

        if v51 then
            local t3 = {
                fish = v44
            }

            t3.iconImage = if v47 == nil then images.giftBox else v47

            t3.onFinished = function() -- line: 275
                -- upvalues: v19 (copy)
                return v19(nil)
            end

            t3.rewardBadgeText = if v18.rewardId == "daily-7" then "125% STRONGER" else nil
            t3.rewardText = v49
            t3.title = "DAILY REWARD!"
            t3.uiScale = 0.9
            t3.zIndex = 200
            v51 = react.createElement(default, t3)
        end

        return react.createElement(react.Fragment, nil, v50, v51)
    end
}
