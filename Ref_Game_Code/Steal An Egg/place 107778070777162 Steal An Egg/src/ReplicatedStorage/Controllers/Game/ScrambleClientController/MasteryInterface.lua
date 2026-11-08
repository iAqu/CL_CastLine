-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")
local GUI = require(ReplicatedStorage.Client.GUI)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local GamepadBindings = require(ReplicatedStorage.Client.GamepadBindings)
local Trove = require(ReplicatedStorage.Packages.Trove)
local AddCommas = require(ReplicatedStorage.Shared.Utils.Numbers).AddCommas
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local ScrambleMastery = require(ReplicatedStorage.Data.ScrambleMastery)
local Assets = require(ReplicatedStorage.Data.Assets)
local ScrambleBossFlags = require(ReplicatedStorage.Shared.Flags.ScrambleBossFlags)
local MilestoneCard = require(ReplicatedStorage.Controllers.GUI.BossMasteryController.MilestoneCard)
local v1 = Color3.fromRGB(80, 255, 120)
local v2 = Color3.fromRGB(255, 64, 64)
local v3 = table.freeze({
    [10] = "10KillsSkin",
    [25] = "25KillsSkin",
    [50] = "50KillsSkin",
    [75] = "75KillsSkin",
    [100] = "100KillsSkin"
})
local t1 = {}

local function toast(p1, p2, p3) -- line: 29
    -- upvalues: Toast (copy)
    Toast.Show({
        Seconds = 3,
        SingleLine = true,
        Unique = true,
        Text = p1,
        Color = p2,
        Image = p3
    })
end

local function rewardOf(p4) -- line: 32
    -- upvalues: ScrambleMastery (copy)
    local v4 = ScrambleMastery.GetMilestone(p4)

    if v4 then
        return v4.Reward
    end

    return ScrambleMastery.InfiniteReward
end

function t1.new(p5, p6) -- line: 36
    -- upvalues: GuiService (copy), TweenService (copy), GUI (copy), Tabs (copy), ButtonFX (copy), GamepadBindings (copy), Trove (copy), AddCommas (copy), Toast (copy), ScrambleMastery (copy), Assets (copy), ScrambleBossFlags (copy), MilestoneCard (copy), v1 (copy), v2 (copy), v3 (copy)
    local t2 = {}
    local v5 = Trove.new()
    local v6 = v5:Add(Trove.new())
    local ScrambleBossMastery = GUI.Get("ScrambleBossMastery")
    local Frame = ScrambleBossMastery.Frame
    local BossShopButton = Frame.Header.BossShopButton
    local Amount = Frame.Header.CurrencyHolder.Amount
    local InfoHolder = Frame.InfoHolder
    local NotMax, Max = InfoHolder.NextRewardInfoHolder.NotMax, InfoHolder.NextRewardInfoHolder.Max
    local ScrollingFrame = Frame.ScrollingFrame
    local Template = ScrollingFrame.Template
    local NextRewardIcon = Frame.NextRewardIcon
    local ButtonParent
    local Icon = NextRewardIcon.Icon
    local t3 = {}
    local t4 = {}
    local v7
    local v8 = true
    local v9 = false

    local function available() -- line: 56
        -- upvalues: v7 (ref)
        if v7 ~= nil and v7.Ready == true and v7.Enabled == true and v7.WorldReady == true then
            return workspace:GetServerTimeNow() < (v7.EventEndsAt or 0)
        end

        return false
    end

    local function refreshNextReward() -- line: 64
        -- upvalues: v6 (copy), ScrambleBossMastery (copy), Frame (copy), ScrollingFrame (copy), NextRewardIcon (copy), ButtonParent (ref), Icon (copy), t3 (copy), v7 (ref), v8 (ref), ScrambleMastery (copy), Assets (copy)
        NextRewardIcon.Visible = false
        ButtonParent = nil

        if v8 and v7 ~= nil and v7.Ready == true and v7.Enabled == true and v7.WorldReady == true and workspace:GetServerTimeNow() < (v7.EventEndsAt or 0) and ScrambleBossMastery.Enabled and Frame.Visible and ScrollingFrame.Visible then
            local State = v7.State

            if State then
                for _, v10 in ScrambleMastery.Milestones do
                    if v10.Reward.Kind == "Pet" and State.ClaimedMilestoneIds[v10.Id] ~= true and not (State.Mastery >= v10.Kills) then
                        local ButtonParent2 = t3[v10.Id].Button.Parent
                        local AbsolutePosition, AbsoluteSize = ButtonParent2.AbsolutePosition, ButtonParent2.AbsoluteSize
                        local AbsolutePosition2, AbsoluteWindowSize = ScrollingFrame.AbsolutePosition, ScrollingFrame.AbsoluteWindowSize

                        if ButtonParent2.Visible and not (AbsoluteSize.X <= 0) and not (AbsoluteSize.Y <= 0) and not (AbsoluteWindowSize.X <= 0) and not (AbsoluteWindowSize.Y <= 0) then
                            local v11 = AbsolutePosition.X >= AbsolutePosition2.X + AbsoluteWindowSize.X
                            local v12 = ScrollingFrame.CanvasPosition.X + AbsoluteWindowSize.X < ScrollingFrame.AbsoluteCanvasSize.X - 1

                            Icon.Image = Assets.Directory[v10.Reward.Category].Icon
                            NextRewardIcon.Visible = v11 and v12

                            if not NextRewardIcon.Visible then
                                ButtonParent2 = nil
                            end

                            ButtonParent = ButtonParent2

                            return
                        end

                        return
                    end
                end
            end

            return
        end

        v6:Clean()
    end

    local function scrollToNextReward() -- line: 96
        -- upvalues: v6 (copy), ScrollingFrame (copy), ButtonParent (ref), refreshNextReward (copy), TweenService (copy)
        refreshNextReward()

        local ButtonParent2 = ButtonParent

        if ButtonParent2 == nil then
            return
        end

        v6:Clean()

        local X = ScrollingFrame.AbsoluteWindowSize.X
        local v13 = ScrollingFrame.CanvasPosition.X + ButtonParent2.AbsolutePosition.X - ScrollingFrame.AbsolutePosition.X - (X - ButtonParent2.AbsoluteSize.X) / 2
        local v15 = math.max(0, ScrollingFrame.AbsoluteCanvasSize.X - X)
        local tween = TweenService:Create(ScrollingFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            CanvasPosition = Vector2.new(math.clamp(v13, 0, v15), ScrollingFrame.CanvasPosition.Y)
        })

        v6:Add(function() -- line: 110
            -- upvalues: tween (copy)
            tween:Cancel()
            tween:Destroy()
        end)
        tween:Play()
    end

    local function refreshCanvas() -- line: 116
        -- upvalues: ScrollingFrame (copy), refreshNextReward (copy)
        local UIListLayout = ScrollingFrame.UIListLayout
        local v16 = UIListLayout.Padding.Scale * ScrollingFrame.AbsoluteSize.X + UIListLayout.Padding.Offset

        ScrollingFrame.CanvasSize = UDim2.fromOffset(math.ceil(UIListLayout.AbsoluteContentSize.X + v16), 0)
        refreshNextReward()
    end

    local function writeChip(p7, p8) -- line: 122
        -- upvalues: ScrambleMastery (copy)
        local v18 = ScrambleMastery.Presentation(p8)

        p7.Visible = true
        p7.Icon.Image = v18.Icon
        p7.Amount.Text = v18.Amount
        p7.CompletedCheckmark.Visible = false
    end

    local function refresh() -- line: 129
        -- upvalues: Amount (copy), InfoHolder (copy), NotMax (copy), Max (copy), t3 (copy), v7 (ref), v8 (ref), refreshNextReward (copy), AddCommas (copy), ScrambleMastery (copy)
        local v19 = v7 and v7.State

        if not (v8 and v19) then
            return
        end

        Amount.Text = AddCommas(v19.Samples)
        InfoHolder.MasteryLabel.Text = AddCommas(v19.Mastery)

        local v20

        for v21, v22 in ScrambleMastery.Milestones do
            local v23 = v19.ClaimedMilestoneIds[v22.Id] == true
            local v24 = if v23 then "Claimed" elseif v19.Mastery >= v22.Kills then "Claimable" else "Locked"

            t3[v22.Id].Refresh(v22.Kills, ScrambleMastery.Presentation(v22.Reward), v24, v21)

            if v20 == nil and not v23 then
                v20 = v22
            end
        end

        local v25 = ScrambleMastery.FinalMilestone()
        local v26 = v19.ClaimedMilestoneIds[v25.Id] == true
        local v27 = ScrambleMastery.ClaimableInfiniteCount(v19)
        local v28 = t3[ScrambleMastery.InfiniteMilestoneId]

        v28.SetVisible(v26)
        v28.Refresh(v25.Kills + (v19.InfiniteRewardsClaimed + 1) * ScrambleMastery.InfiniteEveryKills, ScrambleMastery.Presentation(ScrambleMastery.InfiniteReward), not (v26 and v27 > 0) and "Locked" or "Claimable", #ScrambleMastery.Milestones + 1)

        local v29 = v20 ~= nil
        local v30 = v20 == nil

        NotMax.Visible = v29
        Max.Visible = v30

        if v20 then
            local v32 = math.max(v20.Kills - v19.Mastery, 0)
            local MasteryGoal = NotMax.MasteryGoal

            if v32 == 0 then
                MasteryGoal.Text = "Reward ready"
            else
                MasteryGoal.Text = ("%* more"):format((AddCommas(v32)))
            end

            local Chip = NotMax.RewardHolder.Chip
            local Reward = v20.Reward
            local v33 = ScrambleMastery.Presentation(Reward)

            Chip.Visible = true
            Chip.Icon.Image = v33.Icon
            Chip.Amount.Text = v33.Amount
            Chip.CompletedCheckmark.Visible = false
        else
            local v35 = math.max(v19.Mastery - v25.Kills, 0)
            local v36 = if v27 > 0 then 0 else ScrambleMastery.InfiniteEveryKills - v35 % ScrambleMastery.InfiniteEveryKills
            local MasteryGoal = Max.MasteryGoal

            if v36 == 0 then
                MasteryGoal.Text = "Reward ready"
            else
                MasteryGoal.Text = ("%* more"):format((AddCommas(v36)))
            end

            local Chip = Max.RewardHolder.Chip
            local InfiniteReward = ScrambleMastery.InfiniteReward
            local v37 = ScrambleMastery.Presentation(InfiniteReward)

            Chip.Visible = true
            Chip.Icon.Image = v37.Icon
            Chip.Amount.Text = v37.Amount
            Chip.CompletedCheckmark.Visible = false
        end

        refreshNextReward()
    end

    local function notifyReady() -- line: 172
        -- upvalues: t4 (copy), v7 (ref), Tabs (copy), Toast (copy), ScrambleMastery (copy), ScrambleBossFlags (copy), v1 (copy)
        if not ScrambleBossFlags.ContentEnabled:Get() then
            return
        end

        local v38 = v7 and v7.State

        if not v38 then
            return
        end

        local t5 = {}

        for _, v39 in ScrambleMastery.Milestones do
            if v38.Mastery >= v39.Kills and not v38.ClaimedMilestoneIds[v39.Id] then
                table.insert(t5, v39.Id)
            end
        end

        local v40 = v38.InfiniteRewardsClaimed + 1

        for i = v40, v40 + ScrambleMastery.ClaimableInfiniteCount(v38) - 1 do
            table.insert(t5, (("%*:%*"):format(ScrambleMastery.InfiniteMilestoneId, i)))
        end

        local v42

        for _, v43 in t5 do
            if not t4[v43] then
                t4[v43] = true
                v42 = v42 or v43
            end
        end

        if v42 and not Tabs.IsActive("ScrambleBossMastery") then
            local v45 = string.split(v42, ":")[1]
            local v46 = ScrambleMastery.GetMilestone(v45)
            local v44 = if v46 then v46.Reward else ScrambleMastery.InfiniteReward
            local v47 = if #t5 == 1 then "You have a Scramble Mastery reward ready to claim!" else ("You have %* Scramble Mastery rewards ready to claim!"):format(#t5)
            local Icon = ScrambleMastery.Presentation(v44).Icon

            Toast.Show({
                Seconds = 3,
                SingleLine = true,
                Unique = true,
                Text = v47,
                Color = v1,
                Image = Icon
            })
        end
    end

    local function claim(p9, p10) -- line: 206
        -- upvalues: p5 (copy), v7 (ref), v8 (ref), v9 (ref), refresh (copy), Toast (copy), ScrambleMastery (copy), v1 (copy), v2 (copy)
        if v9
            or v7 == nil
            or v7.Ready ~= true
            or v7.Enabled ~= true
            or v7.WorldReady ~= true
            or not (workspace:GetServerTimeNow() < (v7.EventEndsAt or 0)) then
            return
        end

        v9 = true
        p10.SetPending(true)

        local ok, result = pcall(p5, "Milestone", p9)

        v9 = false

        if v8 then
            p10.SetPending(false)

            local Presentation = ScrambleMastery.Presentation
            local v48 = ScrambleMastery.GetMilestone(p9)
            local Icon = Presentation(if v48 then v48.Reward else ScrambleMastery.InfiniteReward).Icon

            if not ok or not result then
                Toast.Show({
                    Text = "Could not confirm the claim. Try again.",
                    Seconds = 3,
                    SingleLine = true,
                    Unique = true,
                    Color = v2,
                    Image = Icon
                })
            elseif result.Ok then
                Toast.Show({
                    Text = "Scramble Mastery reward claimed!",
                    Seconds = 3,
                    SingleLine = true,
                    Unique = true,
                    Color = v1,
                    Image = Icon
                })
            elseif result.Reason == "Busy" or result.Reason == "ProfileUnavailable" then
                Toast.Show({
                    Text = "Please wait a moment and try again.",
                    Seconds = 3,
                    SingleLine = true,
                    Unique = true,
                    Color = v2,
                    Image = Icon
                })
            end

            refresh()
        end
    end

    Template.Visible = false
    NextRewardIcon.Visible = false

    for _, v49 in v3 do
        ScrollingFrame[v49].Visible = false
    end

    for _, v50 in ScrambleMastery.Milestones do
        local v51 = v3[v50.Kills]
        local v52 = if v51 then ScrollingFrame[v51] else Template

        t3[v50.Id] = MilestoneCard.New(v52, ScrollingFrame, v50.Id, claim, v51 ~= nil)

        if v50.Reward.Kind == "Pet" then
            local ButtonParent = t3[v50.Id].Button.Parent

            v5:Connect(ButtonParent:GetPropertyChangedSignal("AbsolutePosition"), refreshNextReward)
            v5:Connect(ButtonParent:GetPropertyChangedSignal("AbsoluteSize"), refreshNextReward)
        end
    end

    t3[ScrambleMastery.InfiniteMilestoneId] = MilestoneCard.New(Template, ScrollingFrame, ScrambleMastery.InfiniteMilestoneId, claim)

    for _, v53 in t3 do
        v5:Add(v53.Destroy)
    end

    v5:Connect(ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"), refreshNextReward)
    v5:Connect(ScrollingFrame:GetPropertyChangedSignal("AbsoluteWindowSize"), refreshCanvas)
    v5:Connect(ScrollingFrame:GetPropertyChangedSignal("AbsolutePosition"), refreshNextReward)
    v5:Connect(ScrollingFrame:GetPropertyChangedSignal("Visible"), refreshNextReward)
    v5:Connect(ScrollingFrame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), refreshCanvas)

    local UIListLayout = ScrollingFrame.UIListLayout
    local v54 = UIListLayout.Padding.Scale * ScrollingFrame.AbsoluteSize.X + UIListLayout.Padding.Offset

    ScrollingFrame.CanvasSize = UDim2.fromOffset(math.ceil(UIListLayout.AbsoluteContentSize.X + v54), 0)
    refreshNextReward()
    v5:Connect(ScrambleBossMastery:GetPropertyChangedSignal("Enabled"), refreshCanvas)
    v5:Connect(Frame:GetPropertyChangedSignal("Visible"), refreshNextReward)

    local ConsoleButton = BossShopButton.ConsoleButton

    ConsoleButton:SetAttribute("GamepadKey", "ButtonX")
    GamepadBindings.Inspect(ConsoleButton)
    v5:Add(ButtonFX(BossShopButton, 1.08, p6))
    v5:Add(ButtonFX(NextRewardIcon, 1.05, scrollToNextReward))
    v5:Add(Tabs.Activated:Connect(function(p11) -- line: 262
        -- upvalues: ScrollingFrame (copy), refreshNextReward (copy), refresh (copy), notifyReady (copy)
        if p11 ~= "ScrambleBossMastery" then
            return
        end

        local UIListLayout = ScrollingFrame.UIListLayout
        local v56 = UIListLayout.Padding.Scale * ScrollingFrame.AbsoluteSize.X + UIListLayout.Padding.Offset

        ScrollingFrame.CanvasSize = UDim2.fromOffset(math.ceil(UIListLayout.AbsoluteContentSize.X + v56), 0)
        refreshNextReward()
        refresh()
        notifyReady()
    end))

    local function refreshShopButtonPosition() -- line: 271
        -- upvalues: BossShopButton (copy), GuiService (copy)
        if BossShopButton.AbsolutePosition.Y < GuiService:GetInsetArea(Enum.ScreenInsets.CoreUISafeInsets).Min.Y then
            BossShopButton.Position = UDim2.new(0, 0, 0, 0)
            BossShopButton.AnchorPoint = Vector2.new(1, 0)
        else
            BossShopButton.Position = UDim2.new(0, 0, -0.275, 0)
            BossShopButton.AnchorPoint = Vector2.new(0, 1)
        end
    end

    v5:Add(Frame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 280
        -- upvalues: refreshShopButtonPosition (copy)
        refreshShopButtonPosition()
    end))
    refreshShopButtonPosition()

    function t2.Update(p12) -- line: 286
        -- upvalues: t2 (copy), v7 (ref), refresh (copy), notifyReady (copy)
        v7 = p12

        if v7 == nil or v7.Ready ~= true or v7.Enabled ~= true or v7.WorldReady ~= true or not (workspace:GetServerTimeNow() < (v7.EventEndsAt or 0)) then
            t2.Close()
        end

        refresh()
        notifyReady()
    end

    function t2.Toggle() -- line: 294
        -- upvalues: t2 (copy), v7 (ref), refresh (copy), Tabs (copy)
        if Tabs.IsActive("ScrambleBossMastery") then
            t2.Close()
        elseif v7 ~= nil and v7.Ready == true and v7.Enabled == true and v7.WorldReady == true and workspace:GetServerTimeNow() < (v7.EventEndsAt or 0) and v7.State then
            refresh()
            Tabs.Activate("ScrambleBossMastery")
        end
    end

    function t2.Close() -- line: 302
        -- upvalues: v6 (copy), Tabs (copy)
        v6:Clean()

        if Tabs.IsActive("ScrambleBossMastery") then
            Tabs.Deactivate()
        end
    end

    function t2.Destroy() -- line: 308
        -- upvalues: v5 (copy), NextRewardIcon (copy), v8 (ref)
        v8 = false
        NextRewardIcon.Visible = false
        v5:Destroy()
    end

    return t2
end

return t1
