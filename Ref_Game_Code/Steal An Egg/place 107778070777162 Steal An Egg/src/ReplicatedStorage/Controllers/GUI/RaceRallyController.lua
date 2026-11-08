-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local RaceRallyFlags = require(ReplicatedStorage.Shared.Flags.RaceRallyFlags)
local GUI = require(ReplicatedStorage.Client.GUI)
local Hud = require(ReplicatedStorage.Client.Hud)
local Marketplace = require(ReplicatedStorage.Shared.Utils.Marketplace)
local MilestoneCard = require(ReplicatedStorage.Controllers.GUI.BossMasteryController.MilestoneCard)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local Numbers = require(ReplicatedStorage.Shared.Utils.Numbers)
local RaceRally = require(ReplicatedStorage.Data.RaceRally)
local RaceRallyEligibility = require(ReplicatedStorage.Shared.Util.RaceRallyEligibility)
local RaceRallyRewards = require(ReplicatedStorage.Shared.Modules.RaceRallyRewards)
local RaceRally2 = require(ReplicatedStorage.Shared.Types.RaceRally)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Storefront = require(ReplicatedStorage.Client.Functions.Storefront)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = Color3.fromRGB(126, 255, 92)
local v2 = Color3.fromRGB(255, 80, 80)
local v3 = Color3.new(1, 1, 1)
local v4 = ColorSequence.new(Color3.fromRGB(161, 161, 161), Color3.fromRGB(91, 91, 91))
local v5 = ColorSequence.new(Color3.fromHex("ff2aff"), Color3.fromHex("b300ff"))
local v6 = ColorSequence.new(Color3.fromHex("d569ff"))
local UnixTimestamp = DateTime.fromUniversalTime(2026, 10, 17, 15).UnixTimestamp

local function countdown(p1) -- line: 38
    local v7 = p1 // 86400
    local v8 = p1 // 3600 % 24
    local v9 = p1 // 60 % 60

    if v7 > 0 then
        return (("%*d %*hr"):format(v7, v8))
    end

    if v8 > 0 then
        return (("%*hr %*m"):format(v8, v9))
    end

    return (("%*m %*s"):format(v9, p1 % 60))
end

local function blank() -- line: 48
    -- upvalues: RaceRally2 (copy)
    return RaceRally2.Blank()
end

local function hideSamples(p2, p3) -- line: 53
    for _, child in p2:GetChildren() do
        if child.Name == p3 and child:IsA("GuiObject") then
            child.Visible = false
        end
    end
end

local function rewardsPresentation(p4) -- line: 62
    -- upvalues: RaceRallyRewards (copy)
    local t1 = {}
    local t2 = {}
    local v10

    for _, v11 in p4 do
        local v12 = RaceRallyRewards.Present(v11)

        table.insert(t1, v12.Title)
        table.insert(t2, v12.Icon)
        v10 = v10 or v12.Rarity
    end

    return {
        HoverTitle = "Rewards",
        Title = table.concat(t1, " + "),
        Rarity = v10,
        Icon = t2[1],
        CycleIcons = t2,
        Amount = RaceRallyRewards.Present(p4[1]).Amount,
        HoverDescription = table.concat(t1, "\n")
    }
end

local function rewardsSummary(p5) -- line: 84
    -- upvalues: Numbers (copy), RaceRallyRewards (copy)
    local t3 = {}

    for _, v13 in p5 do
        local Title = RaceRallyRewards.Present(v13).Title

        if v13.Kind == "Tokens" then
            Title = ("%* %*"):format(Numbers.AddCommas(v13.Amount), Title)
        end

        table.insert(t3, Title)
    end

    return table.concat(t3, " + ")
end

local function claimRewards(p6) -- line: 96
    -- upvalues: RaceRally (copy)
    if p6 == RaceRally.RepeatId then
        return RaceRally.Repeat.Rewards
    end

    return RaceRally.Milestones[p6].Rewards
end

local function hasRacer(p7) -- line: 102
    for _, v14 in p7.Rewards do
        if v14.Kind == "Racer" then
            return true
        end
    end

    return false
end

local function racerUnlocks() -- line: 112
    -- upvalues: RaceRally (copy)
    local t4 = {}

    for _, v15 in RaceRally.Milestones do
        for _, v16 in v15.Rewards do
            if v16.Kind == "Racer" then
                local v17 = t4[v16.Racer]
                local Racer = v16.Racer

                if v17 ~= nil then
                    t4[Racer] = math.min(v17, v15.Wins)
                else
                    t4[Racer] = v15.Wins
                end
            end
        end
    end

    return t4
end

return {
    Start = function() -- Start | line: 129
        -- upvalues: Workspace (copy), ButtonFX (copy), RaceRallyFlags (copy), GUI (copy), Hud (copy), Marketplace (copy), MilestoneCard (copy), Toast (copy), Numbers (copy), RaceRally (copy), RaceRallyEligibility (copy), RaceRallyRewards (copy), RaceRally2 (copy), Remotes (copy), Save (copy), Storefront (copy), Tabs (copy), Trove (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), UnixTimestamp (copy), hideSamples (copy), rewardsPresentation (copy), rewardsSummary (copy), racerUnlocks (copy)
        local Main = GUI.RaceRally().Main
        local QuantityLabel = Main.CurrencyHolder.QuantityLabel
        local v18 = Trove.new()
        local v19 = RaceRally2.Blank()
        local v20 = false

        Main.CurrencyHolder.CurrencyIcon.Image = RaceRally.CurrencyIcon

        local function show(p8, p9, p10) -- line: 139
            -- upvalues: Toast (copy), v1 (copy), v2 (copy)
            Toast.Show({
                Seconds = 2.5,
                SingleLine = true,
                Text = p8,
                Color = if p9 then v1 else v2,
                Image = p10
            })
        end

        local function request(p11, p12, p13, p14, p15) -- line: 150
            -- upvalues: v20 (ref), Toast (copy), v1 (copy), v2 (copy)
            if v20 then
                return
            end

            v20 = true

            local function v21() -- line: 161
                -- upvalues: p11 (copy), p12 (copy)
                return p11:InvokeServer(p12)
            end

            local v22, v23, v24 = pcall(v21)

            v20 = false

            if p15 ~= nil then
                p15()
            end

            if v22 then
                if v23 then
                    Toast.Show({
                        Seconds = 2.5,
                        SingleLine = true,
                        Text = p13,
                        Color = v1,
                        Image = p14
                    })
                elseif v24 ~= nil then
                    Toast.Show({
                        Seconds = 2.5,
                        Image = nil,
                        SingleLine = true,
                        Text = v24,
                        Color = v2
                    })
                end
            else
                Toast.Show({
                    Text = "Something went wrong, please try again.",
                    Seconds = 2.5,
                    Image = nil,
                    SingleLine = true,
                    Color = v2
                })
            end
        end

        local ScrollingFrame = Main.ShopTab.ScrollingFrame
        local ShopItem = ScrollingFrame.ShopItem

        hideSamples(ScrollingFrame, ShopItem.Name)

        local Color = ShopItem.Card.Buy.UIGradient.Color
        local t7 = {}

        for v25, v26 in RaceRally.OrderedOffers() do
            local v27 = RaceRallyRewards.Present(v26.Config.Reward)
            local clone = ShopItem:Clone()

            clone.Name = v26.Id
            clone.LayoutOrder = v25

            local Card = clone.Card

            Card.EggName.Text = v27.Title
            Card.ItemIcon.Image = v27.Icon
            Card.ItemIcon.QuantityLabel.Visible = false
            Card.Quantity.Visible = true
            Card.Buy.PriceHolder.Icon.Image = RaceRally.CurrencyIcon
            clone.Visible = true
            clone.Parent = ScrollingFrame
            t7[v26.Id] = Card
            v18:Add(ButtonFX(Card.Buy, nil, function() -- line: 197
                -- upvalues: request (copy), v26 (copy), v27 (copy), Remotes (copy)
                request(Remotes.RaceRally.AskBuy, v26.Id, ("Bought %*!"):format(v27.Title), v27.Icon)
            end))
        end

        local v28 = RaceRally.DoubleTrophiesProductId()
        local clone = ShopItem:Clone()

        clone.Name = RaceRally.DoubleTrophies.Key
        clone.LayoutOrder = #RaceRally.OrderedOffers() + 1

        local Card = clone.Card

        Card.EggName.Text = "2x Trophies"
        Card.ItemIcon.Image = RaceRally.DoubleTrophies.Icon
        Card.ItemIcon.QuantityLabel.Visible = false
        Card.Quantity.Visible = false
        Card.Buy.PriceHolder.Icon.Image = "rbxassetid://106998913980785"
        Card.Buy.PriceHolder.Price.Text = ""
        Card.Buy.UIGradient.Color = v5
        Card.Buy.UIStrokeClr.UIGradient.Color = v6
        Card.SoldOut.Title.Text = "Owned"
        clone.Visible = true
        clone.Parent = ScrollingFrame
        v18:Add(ButtonFX(Card.Buy, nil, function() -- line: 223
            -- upvalues: v28 (copy), Storefront (copy)
            Storefront.Prompt(v28, true)
        end))
        v18:Add(task.spawn(function() -- line: 226
            -- upvalues: v28 (copy), Card (copy), Marketplace (copy), Numbers (copy)
            local v29 = Marketplace.Price(v28, Enum.InfoType.Product)

            if v29 ~= nil then
                Card.Buy.PriceHolder.Price.Text = Numbers.AddCommas(v29)
            end
        end))

        local function refreshDoubleTrophies() -- line: 233
            -- upvalues: Card (copy), RaceRally (copy), Save (copy)
            local v30 = Save.Peek()
            local v31 = RaceRally.OwnsDoubleTrophies(if v30 == nil then nil else v30.Products)

            Card.SoldOut.Visible = v31
            Card.Buy.Visible = not v31
        end

        local function refreshShop() -- line: 241
            -- upvalues: v19 (ref), Color (copy), t7 (copy), Workspace (copy), Numbers (copy), RaceRally (copy), RaceRallyRewards (copy), v2 (copy), v3 (copy), v4 (copy)
            local ServerTimeNow = Workspace:GetServerTimeNow()

            for v32, v33 in t7 do
                local v34 = RaceRally.Shop[v32]
                local v35 = RaceRally.PurchasedCount(v19.Purchases[v32], v34, ServerTimeNow)
                local v36 = v34.Limit > 0 and v34.Limit <= v35
                local v37 = v19.Tokens >= v34.Price

                v33.SoldOut.Visible = v36
                v33.Buy.Visible = not v36

                local UIGradient = v33.Buy.UIGradient

                if v37 then
                    UIGradient.Color = Color
                else
                    UIGradient.Color = v4
                end

                v33.Buy.PriceHolder.Price.Text = Numbers.AddCommas(v34.Price)

                local Price = v33.Buy.PriceHolder.Price

                if v37 then
                    Price.TextColor3 = v3
                else
                    Price.TextColor3 = v2
                end

                local QuantityLabel = v33.Quantity.QuantityLabel

                if v34.Limit > 0 then
                    QuantityLabel.Text = ("%*/%* LEFT"):format(math.max(v34.Limit - v35, 0), v34.Limit)
                else
                    QuantityLabel.Text = RaceRallyRewards.Present(v34.Reward).Amount
                end
            end
        end

        local EggName = Main.MileStoneTab
        local ScrollingFrame2 = EggName.ScrollingFrame
        local t8 = {
            ScrollingFrame2.MasteryRow,
            ScrollingFrame2.MasteryRow_Purple,
            ScrollingFrame2.MasteryRow_Gold,
            ScrollingFrame2.MasteryRow_Red,
            ScrollingFrame2.MasteryRow_Rainbow
        }

        for _, v39 in t8 do
            v39.Visible = false
        end

        local MasteryLabel = EggName.InfoHolder.MasteryLabel
        local NotMax = EggName.InfoHolder.NextRewardInfoHolder.NotMax
        local MasteryGoal = NotMax.MasteryGoal
        local Chip = NotMax.RewardHolder.Chip
        local Max = EggName.InfoHolder.NextRewardInfoHolder.Max
        local MasteryGoal2 = Max.MasteryGoal
        local Chip2 = Max.RewardHolder.Chip
        local t9 = {}

        local function claim(p16, p17) -- line: 282
            -- upvalues: request (copy), RaceRally (copy), Remotes (copy), rewardsPresentation (copy), rewardsSummary (copy)
            p17.SetPending(true)

            local Rewards = if p16 == RaceRally.RepeatId then RaceRally.Repeat.Rewards else RaceRally.Milestones[p16].Rewards
            local Icon = rewardsPresentation(Rewards).Icon

            request(Remotes.RaceRally.AskClaimMilestone, p16, ("Claimed %*!"):format((rewardsSummary(Rewards))), Icon, function() -- line: 291
                -- upvalues: p17 (copy)
                p17.SetPending(false)
            end)
        end

        local v41 = RaceRally.OrderedMilestones()
        local n1 = 0
        local v42

        for v43, v44 in v41 do
            if v43 == 1 then
                n1 = math.min(n1 + 1, #t8)
            else
                local v46 = false

                for _, v47 in v44.Config.Rewards do
                    if v47.Kind == "Racer" then
                        v42 = true
                        v46 = true
                        break
                    end
                end

                if not v46 then
                    v42 = false
                end

                if v42 then
                    n1 = math.min(n1 + 1, #t8)
                end
            end

            local v49 = MilestoneCard.New(t8[n1], ScrollingFrame2, v44.Id, claim, true)

            t9[v44.Id] = {
                Card = v49,
                Order = v43
            }
            v18:Add(v49.Destroy)
        end

        local v50 = MilestoneCard.New(t8[#t8], ScrollingFrame2, RaceRally.RepeatId, claim, true)

        v18:Add(v50.Destroy)

        local function writeChip(p18, p19) -- line: 311
            p18.Icon.Image = p19.Icon
            p18.Amount.Text = p19.Amount
        end

        local function refreshMilestones() -- line: 316
            -- upvalues: v19 (ref), MasteryLabel (copy), NotMax (copy), MasteryGoal (copy), Chip (copy), Max (copy), MasteryGoal2 (copy), Chip2 (copy), t9 (copy), v41 (copy), v50 (copy), Numbers (copy), RaceRally (copy), rewardsPresentation (copy)
            local v51

            for v52, v53 in t9 do
                local v54 = RaceRally.Milestones[v52]
                local v55 = if v19.Milestones[v52] == true then "Claimed" elseif v19.Wins >= v54.Wins then "Claimable" else "Locked"

                v53.Card.Refresh(v54.Wins, rewardsPresentation(v54.Rewards), v55, v53.Order)

                if v55 == "Locked" and (v51 == nil or v54.Wins < v51.Wins) then
                    v51 = v54
                end
            end

            local Repeat = RaceRally.Repeat
            local v56 = RaceRally.RepeatsEarned(v19.Wins) > v19.Repeats
            local v57 = RaceRally.RepeatWins(v19.Repeats + 1)
            local v58 = rewardsPresentation(Repeat.Rewards)

            v50.Refresh(v57, v58, v56 and "Claimable" or "Locked", #v41 + 1)
            MasteryLabel.Text = Numbers.AddCommas(v19.Wins)

            local v59 = v51 == nil and v19.Wins >= Repeat.After

            NotMax.Visible = not v59
            Max.Visible = v59

            if v59 then
                MasteryGoal2.Text = ("%* / %*"):format(if v56 then Repeat.Every else (v19.Wins - Repeat.After) % Repeat.Every, Repeat.Every)
                Chip2.Visible = true
                Chip2.Icon.Image = v58.Icon
                Chip2.Amount.Text = v58.Amount
            else
                local AddCommas = Numbers.AddCommas

                if v51 ~= nil then
                    v57 = v51.Wins
                end

                MasteryGoal.Text = ("At %*"):format((AddCommas(v57)))

                if v51 ~= nil then
                    v58 = rewardsPresentation(v51.Rewards)
                end

                Chip.Icon.Image = v58.Icon
                Chip.Amount.Text = v58.Amount
            end
        end

        ScrollingFrame2 = Main.PetTab.ScrollingFrame

        local PetItem = ScrollingFrame2.PetItem

        hideSamples(ScrollingFrame2, PetItem.Name)

        local LockedText = PetItem:GetAttribute("LockedText")
        local DimTransparency = PetItem:GetAttribute("DimTransparency")

        assert(type(LockedText) == "string" and type(DimTransparency) == "number", (("%* needs LockedText and DimTransparency"):format((PetItem:GetFullName()))))

        local ImageTransparency = PetItem.Card.ItemIcon.ImageTransparency
        local Color2 = PetItem.Card.Equipped.UIGradient.Color
        local t10 = {}
        local v62 = racerUnlocks()

        local function isUnlocked(p20) -- line: 385
            -- upvalues: v19 (ref), RaceRally (copy)
            if p20 == RaceRally.DefaultRacer then
                return true
            end

            return v19.Racers[p20] == true
        end

        local v63

        for v64, v65 in RaceRally.OrderedRacers() do
            local v66 = RaceRallyRewards.Present({
                Kind = "Racer",
                Racer = v65.Id
            })

            v63 = PetItem:Clone()
            v63.Name = v65.Id
            v63.LayoutOrder = v64

            local Card = v63.Card

            Card.EggName.Text = v65.Config.DisplayName
            Card.ItemIcon.Image = v66.Icon
            v63.Visible = true
            v63.Parent = ScrollingFrame2
            t10[v65.Id] = Card
            v18:Add(ButtonFX(Card.Equipped, nil, function() -- line: 400
                -- upvalues: v19 (ref), request (copy), v62 (copy), v65 (copy), v66 (copy), Toast (copy), RaceRally (copy), Remotes (copy), v2 (copy)
                local Id = v65.Id

                if Id == RaceRally.DefaultRacer or v19.Racers[Id] == true then
                    if RaceRally.ResolveRacer(v19.EquippedRacer, v19.Racers) ~= v65.Id then
                        request(Remotes.RaceRally.AskEquipRacer, v65.Id, ("%* equipped!"):format(v65.Config.DisplayName), v66.Icon)
                    end
                else
                    local v67 = v62[v65.Id]
                    local v68 = if v67 == nil then "Unlock this racer from the win milestones first!" else ("Win %* races to unlock the %*!"):format(v67, v65.Config.DisplayName)

                    Toast.Show({
                        Seconds = 2.5,
                        Image = nil,
                        SingleLine = true,
                        Text = v68,
                        Color = v2
                    })
                end
            end))
        end

        local function refreshRacers() -- line: 423
            -- upvalues: v19 (ref), Color (copy), LockedText (copy), DimTransparency (copy), ImageTransparency (copy), Color2 (copy), t10 (copy), RaceRally (copy)
            local v69 = RaceRally.ResolveRacer(v19.EquippedRacer, v19.Racers)

            for v70, v71 in t10 do
                local v72 = v70 == RaceRally.DefaultRacer or v19.Racers[v70] == true
                local v73 = v70 == v69
                local ItemIcon = v71.ItemIcon

                if v72 then
                    ItemIcon.ImageTransparency = ImageTransparency
                else
                    ItemIcon.ImageTransparency = DimTransparency
                end

                local Title = v71.Equipped.Title

                if v72 then
                    if v73 then
                        Title.Text = "Equipped"
                    else
                        Title.Text = "Equip"
                    end
                else
                    Title.Text = LockedText
                end

                local UIGradient = v71.Equipped.UIGradient

                if not v72 or v73 then
                    UIGradient.Color = Color2
                else
                    UIGradient.Color = Color
                end
            end
        end

        ScrollingFrame2 = Main.TabButtonsHolder

        local t11 = {
            Shop = {
                Page = Main.ShopTab,
                Button = ScrollingFrame2.ShopSlot.Shop
            },
            Milestones = {
                Page = Main.MileStoneTab,
                Button = ScrollingFrame2.Milestones.Milestones
            },
            Racers = {
                Page = Main.PetTab,
                Button = ScrollingFrame2.Racers.Racers
            }
        }

        local function select(p21) -- line: 446
            -- upvalues: t11 (copy)
            for v74, v75 in t11 do
                local v76 = v74 == p21

                v75.Page.Visible = v76
                v75.Button.BlackOverlay.Visible = not v76
            end
        end

        for v77, v78 in t11 do
            v18:Add(ButtonFX(v78.Button, 1.06, function() -- line: 454
                -- upvalues: t11 (copy), v77 (copy)
                for v79, v80 in t11 do
                    local v81 = v79 == v77

                    v80.Page.Visible = v81
                    v80.Button.BlackOverlay.Visible = not v81
                end
            end))
        end

        local RaceRallyButton = Hud.Every("RaceRallyButton")

        local function refresh() -- line: 460
            -- upvalues: QuantityLabel (copy), v19 (ref), Card (copy), refreshShop (copy), refreshMilestones (copy), refreshRacers (copy), RaceRallyButton (copy), Numbers (copy), RaceRally (copy), RaceRally2 (copy), Save (copy)
            local v82 = Save.Peek()
            local v83 = if v82 == nil then nil else v82.RaceRally

            if v83 == nil then
                v83 = RaceRally2.Blank()
            end

            v19 = v83
            QuantityLabel.Text = Numbers.AddCommas(v19.Tokens)
            refreshShop()

            local v84 = Save.Peek()
            local v85 = RaceRally.OwnsDoubleTrophies(if v84 == nil then nil else v84.Products)

            Card.SoldOut.Visible = v85
            Card.Buy.Visible = not v85
            refreshMilestones()
            refreshRacers()

            local v86 = RaceRally.RepeatsEarned(v19.Wins) > v19.Repeats

            for v87, v88 in RaceRally.Milestones do
                if v19.Milestones[v87] ~= true and v19.Wins >= v88.Wins then
                    v86 = true
                end
            end

            for _, v89 in RaceRallyButton do
                local Badge = v89:FindFirstChild("Badge")

                if Badge ~= nil and Badge:IsA("GuiObject") then
                    Badge.Visible = v86
                end
            end
        end

        local function showHudButtons() -- line: 484
            -- upvalues: RaceRallyButton (copy), RaceRallyFlags (copy), RaceRallyEligibility (copy), Save (copy)
            local v90 = Save.Peek()
            local v91 = RaceRallyFlags.ContentEnabled:Get() and v90 ~= nil and RaceRallyEligibility.IsEligible(v90.SpeedPower)

            for _, v92 in RaceRallyButton do
                v92.Visible = v91
            end
        end

        for _, v93 in RaceRallyButton do
            v18:Add(ButtonFX(v93, 1.08, function() -- line: 495
                -- upvalues: Tabs (copy)
                Tabs.Toggle("RaceRally")
            end))
        end

        v18:Add(Save.WatchFields("RaceRally", refresh))
        v18:Add(Save.WatchFields("Products", refreshDoubleTrophies))
        v18:Add(Tabs.Activated:Connect(function(p22) -- line: 501
            -- upvalues: refresh (copy)
            if p22 == "RaceRally" then
                refresh()
            end
        end))
        v18:Add(RaceRallyFlags.ContentEnabled.Changed:Connect(showHudButtons))
        v18:Add(Save.WatchFields("SpeedPower", showHudButtons))
        v18:Add(RaceRallyEligibility.Changed:Connect(showHudButtons))

        local GoesAwayTimer = Main:FindFirstChild("GoesAwayTimer")

        local function refreshGoesAway() -- line: 511
            -- upvalues: GoesAwayTimer (copy), Workspace (copy), UnixTimestamp (copy)
            local v94, GoesAwayTimer2, v95, v96

            if GoesAwayTimer ~= nil then
                if GoesAwayTimer:IsA("TextLabel") then
                    v94 = math.floor(UnixTimestamp - Workspace:GetServerTimeNow())
                    GoesAwayTimer2 = GoesAwayTimer
                    v95 = v94 > 0
                    v96 = false
                else
                    v96 = true
                end
            else
                v96 = true
            end

            if v96 then
                return
            end

            GoesAwayTimer2.Visible = v95

            if not (v94 > 0) then
                return
            end

            local v98 = v94 // 86400
            local v99 = v94 // 3600 % 24
            local v100 = v94 // 60 % 60

            GoesAwayTimer.Text = ("Goes Away In: %*"):format(if v98 > 0 then ("%*d %*hr"):format(v98, v99) elseif v99 > 0 then ("%*hr %*m"):format(v99, v100) else ("%*m %*s"):format(v100, v94 % 60))
        end

        v18:Add(task.spawn(function() -- line: 521
            -- upvalues: refreshGoesAway (copy)
            while true do
                refreshGoesAway()
                task.wait(1)
            end
        end))

        for v102, v103 in t11 do
            local v104 = v102 == "Shop"

            v103.Page.Visible = v104
            v103.Button.BlackOverlay.Visible = not v104
        end

        local v105 = Save.Peek()

        v63 = RaceRallyFlags.ContentEnabled:Get()

        if v63 then
            v63 = v105 ~= nil and RaceRallyEligibility.IsEligible(v105.SpeedPower)
        end

        for _, v106 in RaceRallyButton do
            v106.Visible = v63
        end

        refresh()
        v18:Add(task.spawn(function() -- line: 532
            -- upvalues: RaceRallyButton (copy), refresh (copy), RaceRallyFlags (copy), RaceRallyEligibility (copy), Save (copy)
            Save.Await()

            local v107 = Save.Peek()
            local v108 = RaceRallyFlags.ContentEnabled:Get() and v107 ~= nil and RaceRallyEligibility.IsEligible(v107.SpeedPower)

            for _, v109 in RaceRallyButton do
                v109.Visible = v108
            end

            refresh()
        end))

        return v18
    end
}
