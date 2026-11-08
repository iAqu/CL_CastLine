-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local BossEventFlags = require(ReplicatedStorage.Shared.Flags.BossEventFlags)
local BossMastery = require(ReplicatedStorage.Data.BossMastery)
local BossMasteryFlags = require(ReplicatedStorage.Shared.Flags.BossMasteryFlags)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local GUI = require(ReplicatedStorage.Client.GUI)
local GamepadBindings = require(ReplicatedStorage.Client.GamepadBindings)
local MenuNavigation = require(ReplicatedStorage.Client.MenuNavigation)
local MilestoneCard = require(script.MilestoneCard)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local Numbers = require(ReplicatedStorage.Shared.Utils.Numbers)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v2 = Color3.fromRGB(255, 64, 64)
local v3 = Color3.fromRGB(80, 255, 120)

return {
    Start = function() -- Start | line: 32
        -- upvalues: GuiService (copy), TweenService (copy), BossEventFlags (copy), BossMastery (copy), BossMasteryFlags (copy), ButtonFX (copy), Simple (copy), GUI (copy), GamepadBindings (copy), MenuNavigation (copy), MilestoneCard (copy), Toast (copy), Numbers (copy), Remotes (copy), Save (copy), Tabs (copy), Trove (copy), v1 (copy), v2 (copy), v3 (copy)
        local Frame = GUI.BossMastery().Frame
        local Close, Header = Frame.Close, Frame.Header
        local BossShopButton = Header.BossShopButton
        local GamepadGlyph = BossShopButton.GamepadGlyph
        local Amount = Header.CurrencyHolder.Amount
        local InfoHolder = Frame.InfoHolder
        local MasteryLabel, NextRewardInfoHolder = InfoHolder.MasteryLabel, InfoHolder.NextRewardInfoHolder
        local NotMax, Max = NextRewardInfoHolder.NotMax, NextRewardInfoHolder.Max
        local ScrollingFrame = Frame.ScrollingFrame
        local Template = ScrollingFrame.Template
        local v4 = Trove.new()
        local v5 = Trove.new()
        local t2 = {}
        local t3 = {}
        local t4 = {}
        local BossTokens, NumberValue, v6

        v4:Add(v5)
        ScrollingFrame.Selectable = false
        GamepadGlyph:SetAttribute("GamepadKey", "ButtonX")
        GamepadBindings.Inspect(GamepadGlyph)
        v4:Add(ButtonFX(BossShopButton, 1.08, function() -- line: 67
            -- upvalues: Tabs (copy)
            Tabs.Activate("BossShop")
        end))

        local function rewardPresentation(p1, p2, p3) -- line: 70
            -- upvalues: BossMastery (copy)
            return BossMastery.GetRewardPresentation(p1, p2, p3)
        end

        local function milestonePresentation(p4, p5) -- line: 78
            -- upvalues: BossMastery (copy)
            return BossMastery.GetMilestonePresentation(p4, p5)
        end

        local function nextInfinitePresentation(p6, p7, p8) -- line: 85
            -- upvalues: rewardPresentation (copy), BossMastery (copy)
            return rewardPresentation(BossMastery.GetInfiniteReward(), p7[BossMastery.InfiniteRevealKey(p6 + 1)], p8)
        end

        local function revealsOf(p9) -- line: 99
            return p9.RevealedRewards or {}
        end

        local function writeRewardCell(p10, p11, p12) -- line: 105
            local Icon, Amount, CompletedCheckmark = p10.Icon, p10.Amount, p10.CompletedCheckmark

            Icon.Image = p11.Icon
            Amount.Text = p11.Amount
            CompletedCheckmark.Visible = p12
        end

        local function orderedMilestones() -- line: 118
            -- upvalues: BossMastery (copy)
            local v7 = table.clone(BossMastery.Milestones)

            table.sort(v7, function(p13, p14) -- line: 122
                -- upvalues: BossMastery (copy)
                local v8 = BossMastery.GetMilestoneKills(p13)
                local v9 = BossMastery.GetMilestoneKills(p14)

                if v8 == v9 then
                    return p13.Id < p14.Id
                end

                return v8 < v9
            end)

            return v7
        end

        local function formatTokens(p15) -- line: 137
            -- upvalues: Simple (copy), Numbers (copy)
            if math.abs(p15) > 99999 then
                return Simple.FormatCompact(math.round(p15), ".#")
            end

            return Numbers.AddCommas((math.round(p15)))
        end

        local function rememberMilestone(p16) -- line: 144
            -- upvalues: Close (copy), BossShopButton (copy), v6 (ref)
            v6 = p16
            BossShopButton.NextSelectionDown = p16
            Close.NextSelectionDown = p16
        end

        local function refreshNavigation(p17, p18) -- line: 150
            -- upvalues: Close (copy), BossShopButton (copy), t2 (copy), v6 (ref), GuiService (copy), BossMastery (copy), MenuNavigation (copy), Tabs (copy)
            local t5 = {}

            for _, v10 in p17 do
                table.insert(t5, t2[v10.Id].Button)
            end

            local Button = t2[BossMastery.InfiniteMilestoneId].Button

            if p18 then
                table.insert(t5, Button)
            end

            for v11, v12 in t5 do
                v12:SetAttribute("DefaultFocus", v11 == 1)
                v12.NextSelectionLeft = t5[v11 - 1] or BossShopButton
                v12.NextSelectionRight = t5[v11 + 1] or Close
                v12.NextSelectionUp = BossShopButton
                v12.NextSelectionDown = v12
            end

            local v13 = v6

            if v13 == nil or table.find(t5, v13) == nil then
                v13 = if v6 == Button then t5[#t5] else t5[1]
            end

            if v13 then
                v6 = v13
                BossShopButton.NextSelectionDown = v13
                Close.NextSelectionDown = v13
            end

            BossShopButton.NextSelectionLeft = BossShopButton
            BossShopButton.NextSelectionRight = Close
            BossShopButton.NextSelectionUp = BossShopButton
            Close.NextSelectionLeft = BossShopButton
            Close.NextSelectionRight = Close
            Close.NextSelectionUp = Close

            if not p18 and GuiService.SelectedObject == Button and Tabs.IsActive("BossMastery") and not MenuNavigation.IsCursorActive() and not MenuNavigation.IsSuspended() then
                GuiService.SelectedObject = v13
            end
        end

        local function setTokenText(p19) -- line: 199
            -- upvalues: Amount (copy), Simple (copy), Numbers (copy)
            Amount.Text = if math.abs(p19) > 99999 then Simple.FormatCompact(math.round(p19), ".#") else Numbers.AddCommas((math.round(p19)))
        end

        local function refreshTokenBalance(p20) -- line: 203
            -- upvalues: Amount (copy), v5 (copy), BossTokens (ref), NumberValue (ref), setTokenText (copy), TweenService (copy), Simple (copy), Numbers (copy), Save (copy), v1 (copy)
            local v15 = Save.Await()

            if v15 == nil then
                return
            end

            local BossTokens2 = v15.BossTokens
            local v16 = if NumberValue then NumberValue.Value else BossTokens

            BossTokens = BossTokens2
            v5:Clean()
            NumberValue = nil

            if not (p20 or v16 == nil or v16 == BossTokens2) then
                local NumberValue2 = Instance.new("NumberValue")

                NumberValue2.Value = v16
                NumberValue = NumberValue2
                v5:Add(NumberValue2)
                v5:Connect(NumberValue2.Changed, setTokenText)
                Amount.Text = if math.abs(v16) > 99999 then Simple.FormatCompact(math.round(v16), ".#") else Numbers.AddCommas((math.round(v16)))

                local tween = TweenService:Create(NumberValue2, v1, {
                    Value = BossTokens2
                })

                v5:Add(tween)
                tween:Play()
            else
                Amount.Text = if math.abs(BossTokens2) > 99999 then Simple.FormatCompact(math.round(BossTokens2), ".#") else Numbers.AddCommas((math.round(BossTokens2)))
            end
        end

        local function refresh() -- line: 233
            -- upvalues: MasteryLabel (copy), NotMax (copy), Max (copy), t2 (copy), refreshNavigation (copy), BossEventFlags (copy), BossMastery (copy), BossMasteryFlags (copy), Numbers (copy), Save (copy)
            if not BossEventFlags.ContentEnabled:Get() then
                return
            end

            local v19 = Save.Await()

            if v19 ~= nil then
                local BossMastery2 = v19.BossMastery
                local v20 = BossMastery2.RevealedRewards or {}
                local v21 = table.clone(BossMastery.Milestones)

                table.sort(v21, function(p21, p22) -- line: 122
                    -- upvalues: BossMastery (copy)
                    local v22 = BossMastery.GetMilestoneKills(p21)
                    local v23 = BossMastery.GetMilestoneKills(p22)

                    if v22 == v23 then
                        return p21.Id < p22.Id
                    end

                    return v22 < v23
                end)

                local v24 = BossMastery.FinalMilestone()
                local v25 = BossMastery2.ClaimedMilestoneIds[v24.Id] == true

                MasteryLabel.Text = Numbers.AddCommas((math.round(BossMastery2.Mastery)))

                local v26, v27

                for v28, v29 in v21 do
                    local v30 = BossMastery.GetMilestoneKills(v29)
                    local v31 = BossMastery2.ClaimedMilestoneIds[v29.Id] == true
                    local v34 = assert(t2[v29.Id], (("Missing Boss Mastery card %*"):format(v29.Id)))
                    local v35 = if v31 then "Claimed" elseif v30 <= BossMastery2.Mastery then "Claimable" else "Locked"
                    local Refresh = v34.Refresh
                    local v36 = v20[v29.Id]

                    Refresh(v30, BossMastery.GetMilestonePresentation(v29, v36), v35, v28)

                    if v31 then
                        if BossMastery2.Mastery < v30 and v27 == nil then
                            v27 = v29
                        end
                    elseif v30 <= BossMastery2.Mastery and v26 == nil then
                        v26 = v29
                    elseif BossMastery2.Mastery < v30 and v27 == nil then
                        v27 = v29
                    end
                end

                local v37 = BossMasteryFlags.InfiniteRewardEveryKills:Get()
                local v38 = BossMastery.GetMilestoneKills(v24)
                local v39 = BossMastery.ClaimableInfiniteCount(BossMastery2)
                local v40 = v38 + (BossMastery2.InfiniteRewardsClaimed + 1) * v37
                local v42 = assert(t2[BossMastery.InfiniteMilestoneId], "Missing infinite Boss Mastery card")
                local v43 = if not (v25 and v39 > 0) then "Locked" else "Claimable"
                local InfiniteRewardsClaimed = BossMastery2.InfiniteRewardsClaimed
                local v44 = BossMastery.GetInfiniteReward()
                local v45 = v20[BossMastery.InfiniteRevealKey(InfiniteRewardsClaimed + 1)]
                local v46 = BossMastery.GetRewardPresentation(v44, v45, 1)

                refreshNavigation(v21, v25)
                v42.SetVisible(v25)
                v42.Refresh(v40, v46, v43, #v21 + 1)

                local v47 = v26 or v27

                if v47 ~= nil then
                    local MasteryGoal = NotMax.MasteryGoal
                    local v53 = math.max(BossMastery.GetMilestoneKills(v47) - BossMastery2.Mastery, 0)

                    NotMax.Visible = true
                    Max.Visible = false

                    if v53 == 0 then
                        MasteryGoal.Text = "Reward ready"
                    else
                        MasteryGoal.Text = ("%* more"):format((Numbers.AddCommas(v53)))
                    end

                    local Template = NotMax.Template
                    local v54 = v20[v47.Id]
                    local v55 = BossMastery.GetMilestonePresentation(v47, v54)
                    local v56 = BossMastery2.ClaimedMilestoneIds[v47.Id] == true
                    local Icon, Amount, CompletedCheckmark = Template.Icon, Template.Amount, Template.CompletedCheckmark

                    Icon.Image = v55.Icon
                    Amount.Text = v55.Amount
                    CompletedCheckmark.Visible = v56
                else
                    local v49 = math.max(BossMastery2.Mastery - v38, 0)
                    local v50 = if v39 > 0 then v37 else v49 % v37
                    local v51 = if v39 > 0 then 0 else v37 - v50
                    local MasteryGoal = Max.MasteryGoal

                    NotMax.Visible = false
                    Max.Visible = true

                    if v51 == 0 then
                        MasteryGoal.Text = "Reward ready"
                    else
                        MasteryGoal.Text = ("%* more"):format((Numbers.AddCommas(v51)))
                    end

                    local Template = Max.Template
                    local Icon, Amount, CompletedCheckmark = Template.Icon, Template.Amount, Template.CompletedCheckmark

                    Icon.Image = v46.Icon
                    Amount.Text = v46.Amount
                    CompletedCheckmark.Visible = false
                end
            end
        end

        local function readyRewards() -- line: 335
            -- upvalues: BossMastery (copy), Save (copy)
            local v57 = Save.Await()

            if v57 == nil then
                return {}
            end

            local BossMastery2 = v57.BossMastery
            local v58 = BossMastery2.RevealedRewards or {}
            local t6 = {}

            for _, v59 in BossMastery.Milestones do
                if BossMastery2.Mastery >= BossMastery.GetMilestoneKills(v59) and not BossMastery2.ClaimedMilestoneIds[v59.Id] then
                    local t7 = {
                        Key = v59.Id
                    }
                    local v60 = v58[v59.Id]

                    t7.Icon = BossMastery.GetMilestonePresentation(v59, v60).Icon
                    table.insert(t6, t7)
                end
            end

            local v61 = BossMastery.ClaimableInfiniteCount(BossMastery2)

            for i = BossMastery2.InfiniteRewardsClaimed + 1, BossMastery2.InfiniteRewardsClaimed + v61 do
                local t8 = {
                    Key = ("%*:%*"):format(BossMastery.InfiniteMilestoneId, i)
                }
                local v62 = BossMastery.GetInfiniteReward()
                local v63 = v58[BossMastery.InfiniteRevealKey(i)]

                t8.Icon = BossMastery.GetRewardPresentation(v62, v63, nil).Icon
                table.insert(t6, t8)
            end

            return t6
        end

        local function updateReadyRewardNotification() -- line: 375
            -- upvalues: t4 (copy), readyRewards (copy), BossEventFlags (copy), Toast (copy), Tabs (copy), v3 (copy)
            if not BossEventFlags.ContentEnabled:Get() then
                return
            end

            local v64 = readyRewards()

            if Tabs.IsActive("BossMastery") then
                for _, v65 in v64 do
                    t4[v65.Key] = true
                end
            else
                local t9 = {}

                for _, v66 in v64 do
                    if not t4[v66.Key] then
                        t4[v66.Key] = true
                        table.insert(t9, v66)
                    end
                end

                if #t9 ~= 0 then
                    local v67 = #v64

                    Toast.Show({
                        Seconds = 3,
                        SingleLine = true,
                        Text = if v67 == 1 then "You have a Boss Mastery reward ready to claim!" else ("You have %* Boss Mastery rewards ready to claim!"):format(v67),
                        Color = v3,
                        Image = t9[1].Icon
                    })
                end
            end
        end

        local function showClaimResult(p23, p24, p25, p26) -- line: 409
            -- upvalues: BossMastery (copy), Toast (copy), Save (copy), v2 (copy), v3 (copy)
            local v68 = Save.Await()
            local BossMastery2 = if v68 then v68.BossMastery else nil
            local v69 = BossMastery2 and BossMastery2.RevealedRewards or {}
            local v70 = BossMastery.GetMilestone(p23)
            local v71

            if v70 ~= nil then
                local v75 = v69[v70.Id]

                v71 = BossMastery.GetMilestonePresentation(v70, v75)
            else
                local v72 = p26 or (if BossMastery2 then BossMastery2.InfiniteRewardsClaimed + 1 else 1)
                local v73 = BossMastery.GetInfiniteReward()
                local v74 = v69[BossMastery.InfiniteRevealKey(v72)]

                v71 = BossMastery.GetRewardPresentation(v73, v74, nil)
            end

            local Show = Toast.Show
            local t11 = {
                Seconds = 2.5,
                SingleLine = true
            }

            if p24 then
                t11.Text = "Boss Mastery reward claimed!"
                t11.Color = v3
            else
                t11.Text = p25 or "Claim failed"
                t11.Color = v2
            end

            t11.Image = v71.Icon
            Show(t11)
        end

        local function requestClaim(p27, p28) -- line: 442
            -- upvalues: t3 (copy), refresh (copy), showClaimResult (copy), BossMastery (copy), Remotes (copy), Save (copy)
            if t3[p27] then
                return
            end

            local v76 = Save.Await()

            if v76 ~= nil then
                local BossMastery2 = v76.BossMastery
                local v77 = BossMastery.GetMilestone(p27)

                if v77 then
                    if BossMastery2.ClaimedMilestoneIds[p27] or BossMastery2.Mastery < BossMastery.GetMilestoneKills(v77) then
                        return
                    end
                elseif p27 ~= BossMastery.InfiniteMilestoneId or not BossMastery2.ClaimedMilestoneIds[BossMastery.FinalMilestone().Id] or BossMastery.ClaimableInfiniteCount(BossMastery2) <= 0 then
                    return
                end

                local v78 = if p27 == BossMastery.InfiniteMilestoneId then v76.BossMastery.InfiniteRewardsClaimed + 1 else nil

                t3[p27] = {
                    Controller = p28,
                    RewardIndex = v78
                }
                p28.SetPending(true)

                local function v79() -- line: 484
                    -- upvalues: p27 (copy), Remotes (copy)
                    return Remotes.BossMastery.AskClaimMilestone:InvokeServer(p27)
                end

                local v80, v81, v82 = pcall(v79)

                t3[p27] = nil
                p28.SetPending(false)

                if not v80 or not v81 then
                    if v80 then
                        showClaimResult(p27, false, v82, v78)
                    else
                        showClaimResult(p27, false, "Something went wrong, please try again.", v78)
                    end
                else
                    refresh()
                    showClaimResult(p27, true, v82, v78)
                end
            end
        end

        Template.Visible = false

        for _, v83 in BossMastery.Milestones do
            local v84 = MilestoneCard.New(Template, ScrollingFrame, v83.Id, requestClaim)

            t2[v83.Id] = v84
            v4:Add(v84.Button.SelectionGained:Connect(function() -- line: 514
                -- upvalues: Close (copy), BossShopButton (copy), v6 (ref), v84 (copy), MenuNavigation (copy)
                if MenuNavigation.IsCursorActive() then
                    return
                end

                local Button = v84.Button

                v6 = Button
                BossShopButton.NextSelectionDown = Button
                Close.NextSelectionDown = Button
            end))
            v4:Add(v84.Destroy)
        end

        local v85 = MilestoneCard.New(Template, ScrollingFrame, BossMastery.InfiniteMilestoneId, requestClaim)

        t2[BossMastery.InfiniteMilestoneId] = v85
        v4:Add(v85.Button.SelectionGained:Connect(function() -- line: 529
            -- upvalues: Close (copy), BossShopButton (copy), v6 (ref), v85 (copy), MenuNavigation (copy)
            if MenuNavigation.IsCursorActive() then
                return
            end

            local Button = v85.Button

            v6 = Button
            BossShopButton.NextSelectionDown = Button
            Close.NextSelectionDown = Button
        end))
        v4:Add(v85.Destroy)
        Save.Await()

        local function onCatalogChanged() -- line: 538
            -- upvalues: refresh (copy), updateReadyRewardNotification (copy)
            refresh()
            updateReadyRewardNotification()
        end

        refresh()

        local v86 = Save.Await()

        if v86 ~= nil then
            local BossTokens2 = v86.BossTokens

            if NumberValue then
                local _ = NumberValue.Value
            end

            BossTokens = BossTokens2
            v5:Clean()
            NumberValue = nil
            Amount.Text = if math.abs(BossTokens2) > 99999 then Simple.FormatCompact(math.round(BossTokens2), ".#") else Numbers.AddCommas((math.round(BossTokens2)))
        end

        updateReadyRewardNotification()
        v4:Add(Save.WatchFields("BossMastery", function() -- line: 546
            -- upvalues: refresh (copy), updateReadyRewardNotification (copy)
            refresh()
            updateReadyRewardNotification()
        end))
        v4:Add(Save.WatchFields("BossTokens", function() -- line: 550
            -- upvalues: refreshTokenBalance (copy)
            refreshTokenBalance()
        end))
        v4:Add(BossMasteryFlags.MilestoneKillOverrides.Changed:Connect(onCatalogChanged))
        v4:Add(BossMasteryFlags.MilestoneRewardIdOverrides.Changed:Connect(onCatalogChanged))
        v4:Add(BossMasteryFlags.TokenBoostPercentOverrides.Changed:Connect(onCatalogChanged))
        v4:Add(BossMasteryFlags.InfiniteRewardEveryKills.Changed:Connect(onCatalogChanged))
        v4:Add(BossMasteryFlags.InfiniteRewardId.Changed:Connect(onCatalogChanged))
        v4:Add(BossMasteryFlags.InfiniteBannerWeights.Changed:Connect(onCatalogChanged))
        v4:Add(Tabs.Activated:Connect(function(p29) -- line: 575
            -- upvalues: Amount (copy), v5 (copy), BossTokens (ref), NumberValue (ref), refresh (copy), updateReadyRewardNotification (copy), Simple (copy), Numbers (copy), Save (copy)
            if p29 ~= "BossMastery" then
                return
            end

            refresh()

            local v88 = Save.Await()

            if v88 ~= nil then
                local BossTokens2 = v88.BossTokens

                if NumberValue then
                    local _ = NumberValue.Value
                end

                BossTokens = BossTokens2
                v5:Clean()
                NumberValue = nil
                Amount.Text = if math.abs(BossTokens2) > 99999 then Simple.FormatCompact(math.round(BossTokens2), ".#") else Numbers.AddCommas((math.round(BossTokens2)))
            end

            updateReadyRewardNotification()
        end))

        return v4
    end
}
