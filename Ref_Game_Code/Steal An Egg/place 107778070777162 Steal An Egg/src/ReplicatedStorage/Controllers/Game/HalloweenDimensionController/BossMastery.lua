-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = require(ReplicatedStorage.Data.Assets)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local GUI = require(ReplicatedStorage.Client.GUI)
local HalloweenDimension = require(ReplicatedStorage.Shared.Util.HalloweenDimension)

require(ReplicatedStorage.Shared.Types.HalloweenDimension)

local HeadlessHorseman = require(script.Parent.HeadlessHorseman)
local Hud = require(ReplicatedStorage.Client.Hud)
local HalloweenBossMastery = require(ReplicatedStorage.Data.HalloweenBossMastery)
local MilestoneCard = require(ReplicatedStorage.Controllers.GUI.BossMasteryController.MilestoneCard)
local Numbers = require(ReplicatedStorage.Shared.Utils.Numbers)
local PumpkinBossFlags = require(ReplicatedStorage.Shared.Flags.PumpkinBossFlags)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)

require(ReplicatedStorage.Packages.Trove)

local LocalPlayer = Players.LocalPlayer
local Inside = HalloweenDimension.PlayerAttributes.Inside
local v1 = Color3.fromRGB(80, 255, 120)
local v2 = Color3.fromRGB(255, 64, 64)
local v3 = table.freeze({
    [3] = "MasteryRow_Purple",
    [10] = "MasteryRow_Purple",
    [17] = "MasteryRow_Gold",
    [30] = "MasteryRow_Gold",
    [45] = "MasteryRow_Gold",
    [52] = "MasteryRow_Gold",
    [65] = "MasteryRow_Rainbow"
})
local t1 = {}

local function toast(p1, p2, p3) -- line: 50
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

local function rewardOf(p4) -- line: 54
    -- upvalues: HalloweenBossMastery (copy)
    return assert(HalloweenBossMastery.GetMilestone(p4), (("Unknown milestone %*"):format(p4))).Reward
end

local function available() -- line: 58
    -- upvalues: PumpkinBossFlags (copy), LocalPlayer (copy), Inside (copy)
    return PumpkinBossFlags.ContentEnabled:Get() and LocalPlayer:GetAttribute(Inside) == true
end

local function savedState() -- line: 62
    -- upvalues: Save (copy)
    local v6 = Save.Peek()

    return if v6 ~= nil then v6.HalloweenDimension.BossMastery else nil
end

local function readyKeys(p5) -- line: 68
    -- upvalues: HalloweenBossMastery (copy)
    local t2 = {}

    for _, v7 in HalloweenBossMastery.Milestones do
        if p5.Mastery >= v7.Kills and not p5.ClaimedMilestoneIds[v7.Id] then
            table.insert(t2, v7.Id)
        end
    end

    return t2
end

function t1.Start(p6) -- line: 82
    -- upvalues: Assets (copy), ButtonFX (copy), GUI (copy), HeadlessHorseman (copy), Hud (copy), HalloweenBossMastery (copy), MilestoneCard (copy), Numbers (copy), PumpkinBossFlags (copy), Remotes (copy), Save (copy), Tabs (copy), Toast (copy), LocalPlayer (copy), Inside (copy), v1 (copy), v2 (copy), v3 (copy), readyKeys (copy)
    local HalloweenBossMastery2 = GUI.Get("HalloweenBossMastery")
    local Frame = HalloweenBossMastery2.Frame
    local Main = GUI.Get("HalloweenDimensionEggUI").Main
    local Main2 = GUI.Get(HeadlessHorseman.TabName).Main
    local t3 = {
        Main.TabButtonsHolder.Mastery,
        Main2.TabButtonsHolder.Mastery
    }
    local t4 = {
        {
            Tab = "HalloweenDimensionEggUI",
            Button = Frame.TabButtonsHolder.ShopSlot.Shop
        },
        {
            Tab = "HalloweenBossMastery",
            Button = Frame.TabButtonsHolder.Mastery.Mastery
        },
        {
            Tab = "HalloweenDimensionEggUI",
            Button = Main.TabButtonsHolder.ShopSlot.Shop
        },
        {
            Tab = "HalloweenBossMastery",
            Button = Main.TabButtonsHolder.Mastery.Mastery
        },
        {
            Tab = "HalloweenDimensionEggUI",
            Button = Main2.TabButtonsHolder.ShopSlot.Shop
        },
        {
            Tab = "HalloweenBossMastery",
            Button = Main2.TabButtonsHolder.Mastery.Mastery
        }
    }
    local Amount = Frame.Header.CurrencyHolder.Amount
    local InfoHolder = Frame.InfoHolder
    local NotMax, Max = InfoHolder.NextRewardInfoHolder.NotMax, InfoHolder.NextRewardInfoHolder.Max
    local ScrollingFrame, NextRewardIcon = Frame.ScrollingFrame, Frame.NextRewardIcon
    local Icon = Frame.NextRewardIcon.Icon
    local HalloweenMasteryButton = Hud.Every("HalloweenMasteryButton")
    local t5 = {}
    local t6 = {}
    local v8 = false

    local function refreshNextReward() -- line: 107
        -- upvalues: HalloweenBossMastery2 (copy), Frame (copy), ScrollingFrame (copy), NextRewardIcon (copy), Icon (copy), t5 (copy), Assets (copy), HalloweenBossMastery (copy), PumpkinBossFlags (copy), Save (copy), LocalPlayer (copy), Inside (copy)
        NextRewardIcon.Visible = false

        local v9 = Save.Peek()
        local BossMastery = if v9 == nil then nil else v9.HalloweenDimension.BossMastery

        if BossMastery ~= nil and PumpkinBossFlags.ContentEnabled:Get() and LocalPlayer:GetAttribute(Inside) == true and HalloweenBossMastery2.Enabled and Frame.Visible and ScrollingFrame.Visible then
            for _, v10 in HalloweenBossMastery.Milestones do
                if v10.Reward.Kind == "Pet" and BossMastery.ClaimedMilestoneIds[v10.Id] ~= true and not (BossMastery.Mastery >= v10.Kills) then
                    local ButtonParent = t5[v10.Id].Button.Parent
                    local AbsolutePosition, AbsoluteSize = ButtonParent.AbsolutePosition, ButtonParent.AbsoluteSize
                    local AbsolutePosition2, AbsoluteWindowSize = ScrollingFrame.AbsolutePosition, ScrollingFrame.AbsoluteWindowSize

                    if ButtonParent.Visible and not (AbsoluteSize.X <= 0) and not (AbsoluteSize.Y <= 0) and not (AbsoluteWindowSize.X <= 0) and not (AbsoluteWindowSize.Y <= 0) then
                        local v11 = AbsolutePosition.X >= AbsolutePosition2.X + AbsoluteWindowSize.X
                        local v12 = ScrollingFrame.CanvasPosition.X + AbsoluteWindowSize.X < ScrollingFrame.AbsoluteCanvasSize.X - 1

                        Icon.Image = Assets.Directory[v10.Reward.Category].Icon
                        NextRewardIcon.Visible = v11 and v12

                        return
                    end

                    return
                end
            end
        end
    end

    local function refreshCanvas() -- line: 135
        -- upvalues: ScrollingFrame (copy), refreshNextReward (copy)
        local UIListLayout = ScrollingFrame.UIListLayout
        local v13 = UIListLayout.Padding.Scale * ScrollingFrame.AbsoluteSize.X + UIListLayout.Padding.Offset

        ScrollingFrame.CanvasSize = UDim2.fromOffset(math.ceil(UIListLayout.AbsoluteContentSize.X + v13), 0)
        refreshNextReward()
    end

    local function writeChip(p7, p8) -- line: 142
        -- upvalues: HalloweenBossMastery (copy)
        local v15 = HalloweenBossMastery.Presentation(p8)

        p7.Visible = true
        p7.Icon.Image = v15.Icon
        p7.Amount.Text = v15.Amount
        p7.CompletedCheckmark.Visible = false
    end

    local function refreshHud(p9) -- line: 150
        -- upvalues: t3 (copy), HalloweenMasteryButton (copy), HeadlessHorseman (copy), PumpkinBossFlags (copy), LocalPlayer (copy), Inside (copy), readyKeys (copy)
        local v16 = PumpkinBossFlags.ContentEnabled:Get() and LocalPlayer:GetAttribute(Inside) == true
        local v17, v18

        if v16 then
            if p9 ~= nil then
                if #readyKeys(p9) > 0 then
                    v17 = true
                    v18 = true
                else
                    v18 = false
                end
            else
                v18 = false
            end
        else
            v17 = v16
            v18 = true
        end

        if not v18 then
            v17 = HeadlessHorseman.IsClaimable()
        end

        for _, v19 in t3 do
            v19.Visible = v16
        end

        for _, v20 in HalloweenMasteryButton do
            v20.Visible = v16

            local Badge = v20:FindFirstChild("Badge")

            if Badge ~= nil then
                Badge.Visible = v17
            end
        end
    end

    local function refresh() -- line: 166
        -- upvalues: Amount (copy), InfoHolder (copy), NotMax (copy), Max (copy), t5 (copy), refreshNextReward (copy), HalloweenBossMastery (copy), Numbers (copy), Save (copy)
        local v21 = Save.Peek()
        local BossMastery = if v21 == nil then nil else v21.HalloweenDimension.BossMastery
        local v22 = Save.Peek()

        Amount.Text = Numbers.AddCommas(if v22 == nil then 0 else v22.HalloweenTokens)

        if BossMastery == nil then
            return
        end

        InfoHolder.MasteryLabel.Text = Numbers.AddCommas(BossMastery.Mastery)

        local v24

        for v25, v26 in HalloweenBossMastery.Milestones do
            local v27 = BossMastery.ClaimedMilestoneIds[v26.Id] == true
            local v28 = if v27 then "Claimed" elseif BossMastery.Mastery >= v26.Kills then "Claimable" else "Locked"

            t5[v26.Id].Refresh(v26.Kills, HalloweenBossMastery.Presentation(v26.Reward), v28, v25)

            if v24 == nil and not v27 then
                v24 = v26
            end
        end

        local v29 = v24 == nil
        local v30 = v24 or HalloweenBossMastery.Milestones[#HalloweenBossMastery.Milestones]
        local v32 = math.max(v30.Kills - BossMastery.Mastery, 0)

        NotMax.Visible = true
        Max.Visible = false

        local MasteryGoal = NotMax.MasteryGoal

        if v29 then
            MasteryGoal.Text = "All claimed"
        elseif v32 == 0 then
            MasteryGoal.Text = "Reward ready"
        else
            MasteryGoal.Text = ("%* more"):format((Numbers.AddCommas(v32)))
        end

        local Chip = NotMax.RewardHolder.Chip
        local Reward = v30.Reward
        local v33 = HalloweenBossMastery.Presentation(Reward)

        Chip.Visible = true
        Chip.Icon.Image = v33.Icon
        Chip.Amount.Text = v33.Amount
        Chip.CompletedCheckmark.Visible = false
        NotMax.RewardHolder.Chip.CompletedCheckmark.Visible = v29
        refreshNextReward()
    end

    local function notifyReady(p10) -- line: 200
        -- upvalues: t6 (copy), HalloweenBossMastery (copy), PumpkinBossFlags (copy), Tabs (copy), Toast (copy), LocalPlayer (copy), Inside (copy), v1 (copy), readyKeys (copy)
        if p10 ~= nil and PumpkinBossFlags.ContentEnabled:Get() and LocalPlayer:GetAttribute(Inside) == true then
            local v34 = readyKeys(p10)
            local v35

            for _, v36 in v34 do
                if not t6[v36] then
                    t6[v36] = true
                    v35 = v35 or v36
                end
            end

            local Reward, v37

            if v35 and not Tabs.IsActive("HalloweenBossMastery") then
                Reward = assert(HalloweenBossMastery.GetMilestone(v35), (("Unknown milestone %*"):format(v35))).Reward
                v37 = if #v34 == 1 then "You have a Pumpkin King Mastery reward ready to claim!" else ("You have %* Pumpkin King Mastery rewards ready to claim!"):format(#v34)

                local Icon = HalloweenBossMastery.Presentation(Reward).Icon

                Toast.Show({
                    Seconds = 3,
                    SingleLine = true,
                    Unique = true,
                    Text = v37,
                    Color = v1,
                    Image = Icon
                })
            end
        end
    end

    local function sync() -- line: 224
        -- upvalues: refreshHud (copy), refresh (copy), notifyReady (copy), PumpkinBossFlags (copy), Save (copy), Tabs (copy), LocalPlayer (copy), Inside (copy)
        local v40 = Save.Peek()
        local BossMastery = if v40 == nil then nil else v40.HalloweenDimension.BossMastery

        if (not PumpkinBossFlags.ContentEnabled:Get() or LocalPlayer:GetAttribute(Inside) ~= true) and Tabs.IsActive("HalloweenBossMastery") then
            Tabs.Deactivate()
        end

        refreshHud(BossMastery)
        refresh()
        notifyReady(BossMastery)
    end

    local function claim(p11, p12) -- line: 234
        -- upvalues: v8 (ref), refresh (copy), HalloweenBossMastery (copy), PumpkinBossFlags (copy), Remotes (copy), Toast (copy), LocalPlayer (copy), Inside (copy), v1 (copy), v2 (copy)
        if v8 or not PumpkinBossFlags.ContentEnabled:Get() or LocalPlayer:GetAttribute(Inside) ~= true then
            return
        end

        v8 = true
        p12.SetPending(true)

        local function v41() -- line: 240
            -- upvalues: p11 (copy), Remotes (copy)
            return Remotes.HalloweenDimension.AskClaimMastery:InvokeServer(p11)
        end

        local v42, v43, v44 = pcall(v41)

        v8 = false
        p12.SetPending(false)

        local Icon = HalloweenBossMastery.Presentation(assert(HalloweenBossMastery.GetMilestone(p11), (("Unknown milestone %*"):format(p11))).Reward).Icon

        if v42 then
            if v43 == true then
                Toast.Show({
                    Text = "Pumpkin King Mastery reward claimed!",
                    Seconds = 3,
                    SingleLine = true,
                    Unique = true,
                    Color = v1,
                    Image = Icon
                })
            else
                if typeof(v44) ~= "string" then
                    v44 = "Could not confirm the claim. Try again."
                end

                Toast.Show({
                    Seconds = 3,
                    SingleLine = true,
                    Unique = true,
                    Text = v44,
                    Color = v2,
                    Image = Icon
                })
            end
        else
            v44 = "Could not confirm the claim. Try again."
            Toast.Show({
                Seconds = 3,
                SingleLine = true,
                Unique = true,
                Text = v44,
                Color = v2,
                Image = Icon
            })
        end

        refresh()
    end

    for _, child in ScrollingFrame:GetChildren() do
        if child:IsA("GuiObject") and string.find(child.Name, "MasteryRow", 1, true) == 1 then
            child.Visible = false
        end
    end

    for _, v47 in HalloweenBossMastery.Milestones do
        local v48 = v3[v47.Kills]
        local v49 = ScrollingFrame[v48 or "MasteryRow"]
        local v50 = MilestoneCard.New(v49, ScrollingFrame, v47.Id, claim, v48 ~= nil)

        t5[v47.Id] = v50

        if v47.Reward.Kind == "Pet" then
            local ButtonParent = v50.Button.Parent

            p6:Connect(ButtonParent:GetPropertyChangedSignal("AbsolutePosition"), refreshNextReward)
            p6:Connect(ButtonParent:GetPropertyChangedSignal("AbsoluteSize"), refreshNextReward)
        end
    end

    for _, v51 in t5 do
        p6:Add(v51.Destroy)
    end

    NextRewardIcon.Visible = false
    p6:Connect(ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"), refreshNextReward)
    p6:Connect(ScrollingFrame:GetPropertyChangedSignal("AbsoluteWindowSize"), refreshCanvas)
    p6:Connect(ScrollingFrame:GetPropertyChangedSignal("AbsolutePosition"), refreshNextReward)
    p6:Connect(ScrollingFrame:GetPropertyChangedSignal("Visible"), refreshNextReward)
    p6:Connect(ScrollingFrame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), refreshCanvas)
    p6:Connect(HalloweenBossMastery2:GetPropertyChangedSignal("Enabled"), refreshCanvas)
    p6:Connect(Frame:GetPropertyChangedSignal("Visible"), refreshNextReward)

    local UIListLayout = ScrollingFrame.UIListLayout
    local v52 = UIListLayout.Padding.Scale * ScrollingFrame.AbsoluteSize.X + UIListLayout.Padding.Offset

    ScrollingFrame.CanvasSize = UDim2.fromOffset(math.ceil(UIListLayout.AbsoluteContentSize.X + v52), 0)
    refreshNextReward()

    for _, v54 in t4 do
        p6:Add(ButtonFX(v54.Button, 1.06, function() -- line: 289
            -- upvalues: refresh (copy), v54 (copy), PumpkinBossFlags (copy), Save (copy), Tabs (copy), LocalPlayer (copy), Inside (copy)
            if v54.Tab == "HalloweenDimensionEggUI" then
                Tabs.Activate("HalloweenDimensionEggUI", {
                    instant = true
                })
            elseif PumpkinBossFlags.ContentEnabled:Get() and LocalPlayer:GetAttribute(Inside) == true then
                local v55 = Save.Peek()

                if (if v55 == nil then nil else v55.HalloweenDimension.BossMastery) ~= nil then
                    refresh()
                    Tabs.Activate("HalloweenBossMastery", {
                        instant = true
                    })
                end
            end
        end))
    end

    for _, v56 in HalloweenMasteryButton do
        local RemovalTimer = v56:FindFirstChild("RemovalTimer")

        if RemovalTimer ~= nil then
            RemovalTimer.Visible = false
        end

        p6:Add(ButtonFX(v56, 1.08, function() -- line: 304
            -- upvalues: refresh (copy), HeadlessHorseman (copy), PumpkinBossFlags (copy), Save (copy), Tabs (copy), LocalPlayer (copy), Inside (copy)
            if Tabs.IsActive("HalloweenBossMastery") or Tabs.IsActive(HeadlessHorseman.TabName) then
                Tabs.Deactivate()
            elseif HeadlessHorseman.IsClaimable() then
                Tabs.Activate(HeadlessHorseman.TabName)
            elseif PumpkinBossFlags.ContentEnabled:Get() and LocalPlayer:GetAttribute(Inside) == true then
                local v57 = Save.Peek()

                if (if v57 == nil then nil else v57.HalloweenDimension.BossMastery) ~= nil then
                    refresh()
                    Tabs.Activate("HalloweenBossMastery")
                end
            end
        end))
    end

    p6:Connect(Tabs.Activated, function(p13) -- line: 316
        -- upvalues: ScrollingFrame (copy), refreshNextReward (copy), refresh (copy), notifyReady (copy), Save (copy)
        if p13 ~= "HalloweenBossMastery" then
            return
        end

        local UIListLayout = ScrollingFrame.UIListLayout
        local v58 = UIListLayout.Padding.Scale * ScrollingFrame.AbsoluteSize.X + UIListLayout.Padding.Offset

        ScrollingFrame.CanvasSize = UDim2.fromOffset(math.ceil(UIListLayout.AbsoluteContentSize.X + v58), 0)
        refreshNextReward()
        refresh()

        local v60 = Save.Peek()

        notifyReady(if v60 == nil then nil else v60.HalloweenDimension.BossMastery)
    end)
    p6:Add(Save.WatchFields({
        "HalloweenDimension",
        "HalloweenTokens"
    }, sync))
    p6:Connect(LocalPlayer:GetAttributeChangedSignal(Inside), sync)
    p6:Add(PumpkinBossFlags.ContentEnabled.Changed:Connect(sync))
    p6:Add(HeadlessHorseman.Changed:Connect(sync))
    sync()
end

return table.freeze(t1)
