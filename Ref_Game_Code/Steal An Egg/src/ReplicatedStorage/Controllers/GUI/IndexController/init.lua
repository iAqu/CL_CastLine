-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local AreaIndexProgressComponent = require(script.AreaIndexProgressComponent)
local Areas = require(ReplicatedStorage.Data.Areas)

require(ReplicatedStorage.Shared.Types.AssetItem)

local AssetItems = require(ReplicatedStorage.Shared.Util.AssetItems)
local AssetOddsDisplay = require(ReplicatedStorage.Client.Util.AssetOddsDisplay)
local Personalities = require(ReplicatedStorage.Data.Assets).Personalities
local Assets = require(ReplicatedStorage.Data.Assets)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local ClaimRewardPanel = require(script.ClaimRewardPanel)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local GUI = require(ReplicatedStorage.Client.GUI)
local Hud = require(ReplicatedStorage.Client.Hud)

require(script.Types.Interface)

local ItemDisplay = require(ReplicatedStorage.Shared.Modules.ItemDisplay)
local EnsureUIScale = require(ReplicatedStorage.Shared.Utils.EnsureUIScale)
local BrainrotEgg = require(ReplicatedStorage.Data.BrainrotEgg)
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local HalloweenIndex = require(ReplicatedStorage.Data.HalloweenIndex)
local Extinction = require(ReplicatedStorage.Data.LimitedEgg).Extinction
local Log = require(ReplicatedStorage.Packages.Log)
local LuminousEgg = require(ReplicatedStorage.Data.LuminousEgg)
local MonsterEgg = require(ReplicatedStorage.Data.MonsterEgg)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Rift = require(ReplicatedStorage.Data.Rift)
local RiftEligibility = require(ReplicatedStorage.Shared.Util.RiftEligibility)
local RiftMachineSchedule = require(ReplicatedStorage.Shared.Util.RiftMachineSchedule)
local ScrambleTradeIn = require(ReplicatedStorage.Data.ScrambleTradeIn)
local Save = require(ReplicatedStorage.Shared.Save)
local SurfaceButton = require(ReplicatedStorage.Client.UI.VFX.SurfaceButton)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Trove = require(ReplicatedStorage.Packages.Trove)
local TryLock = require(ReplicatedStorage.Shared.Utils.TryLock)
local t1 = {}

t1.__index = t1
t1.__class = "IndexController"

local t2 = {
    "World",
    "Limited"
}
local v1 = Color3.fromRGB(255, 55, 55)
local v2 = Color3.fromRGB(255, 255, 255)
local v3 = Color3.fromRGB(0, 0, 0)
local v4 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v5 = TweenInfo.new(0.7, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, -1, true)
local v6 = Color3.fromRGB(104, 111, 122)
local v7 = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function updateLive() -- line: 92
    -- upvalues: Constants (copy)
    return workspace:GetServerTimeNow() >= Constants.UPDATE_LIVE_AT
end

return {
    Start = function() -- Start | line: 98
        -- upvalues: Players (copy), TweenService (copy), AreaIndexProgressComponent (copy), Areas (copy), AssetItems (copy), AssetOddsDisplay (copy), Personalities (copy), Assets (copy), ButtonFX (copy), ClaimRewardPanel (copy), Simple (copy), GUI (copy), Hud (copy), ItemDisplay (copy), EnsureUIScale (copy), BrainrotEgg (copy), Constants (copy), HalloweenIndex (copy), Extinction (copy), Log (copy), LuminousEgg (copy), MonsterEgg (copy), Remotes (copy), Rift (copy), RiftEligibility (copy), RiftMachineSchedule (copy), ScrambleTradeIn (copy), Save (copy), SurfaceButton (copy), Tabs (copy), Trove (copy), TryLock (copy), t1 (copy), t2 (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy)
        local v8 = Log.new()
        local v9 = TryLock()
        local Frame = GUI.Index().Frame
        local IndexButton = Hud.Every("IndexButton")
        local IndexNotificationBadge = Hud.Every("IndexNotificationBadge")
        local ClaimAll = Frame:FindFirstChild("ClaimAll")

        if ClaimAll == nil or not ClaimAll:IsA("GuiObject") then
            ClaimAll = nil
        end

        local NotificationBadge = if ClaimAll == nil then nil else ClaimAll:FindFirstChild("NotificationBadge")

        local function renderNotificationBadge(p1, p2) -- line: 120
            local v10, v11

            if p1 ~= nil then
                if p1:IsA("GuiObject") then
                    v10 = p2 > 0
                    v11 = false
                else
                    v11 = true
                end
            else
                v11 = true
            end

            if v11 then
                return
            end

            p1.Visible = v10

            if p2 ~= 0 then
                for _, descendant in p1:GetDescendants() do
                    if descendant:IsA("TextLabel") then
                        descendant.Text = tostring(p2)
                    end
                end
            end
        end

        local function seesTheRift() -- line: 134
            -- upvalues: Players (copy), RiftEligibility (copy), Save (copy)
            local LocalPlayer = Players.LocalPlayer

            if LocalPlayer == nil then
                return false
            end

            local v12 = Save.Await()
            local v13 = if v12 == nil then 0 else v12.SpeedPower
            local v14 = if v12 == nil then 0 else v12.LastLogout

            return RiftEligibility.IsRevealed(LocalPlayer, v13, v14)
        end

        local ScrollingFrame = Frame.List.ScrollingFrame
        local Section = ScrollingFrame:FindFirstChild("Section")

        assert(Section ~= nil, "Index list is missing its Section template")

        local Viewing = Frame.Side.Viewing
        local Icon, PetName, PetRarity, PetOdds = Viewing.Icon, Viewing.PetName, Viewing.PetRarity, Viewing.PetOdds
        local Rewards = Frame.Side.Rewards
        local Claim = Rewards.Claim
        local Unlocked = Frame.Unlocked
        local Fill, TextLabel = Unlocked.Fill, Unlocked.TextLabel
        local TabButtons = Frame:FindFirstChild("TabButtons")
        local t4 = {}
        local Scale, Scale2, Scale3, Scale4, v16

        for v17, v18 in ipairs(t2) do
            Scale = if TabButtons ~= nil then TabButtons:FindFirstChild(v18) else nil

            if Scale ~= nil and Scale:IsA("GuiButton") then
                Scale.LayoutOrder = v17
                Scale2 = Scale:FindFirstChild("StrokeHolder")
                Scale3 = if Scale2 ~= nil then Scale2:FindFirstChildOfClass("UIStroke") else nil

                local TextLabel = Scale:FindFirstChild("TextLabel")

                Scale4 = Scale:FindFirstChild("Icon")
                v16 = {
                    Button = Scale,
                    Stroke = Scale3
                }

                if TextLabel ~= nil then
                    if TextLabel:IsA("TextLabel") then
                        v16.Label = TextLabel
                    else
                        v16.Label = nil
                    end
                else
                    v16.Label = nil
                end

                if Scale4 ~= nil then
                    if Scale4:IsA("ImageLabel") then
                        v16.Icon = Scale4
                    else
                        v16.Icon = nil
                    end
                else
                    v16.Icon = nil
                end

                v16.Tint = Scale.BackgroundColor3

                if Scale3 ~= nil then
                    v16.StrokeTransparency = Scale3.Transparency
                else
                    v16.StrokeTransparency = 0
                end

                if TextLabel ~= nil then
                    if TextLabel:IsA("TextLabel") then
                        v16.TextTransparency = TextLabel.TextTransparency
                    else
                        v16.TextTransparency = 0
                    end
                else
                    v16.TextTransparency = 0
                end

                if Scale4 ~= nil then
                    if Scale4:IsA("ImageLabel") then
                        v16.IconTransparency = Scale4.ImageTransparency
                    else
                        v16.IconTransparency = 0
                    end
                else
                    v16.IconTransparency = 0
                end

                t4[v18] = v16
            end
        end

        local t5 = {}
        local n1 = 0
        local n2 = 0

        for _, child in Section.Pets:GetChildren() do
            Scale3 = string.match
            Scale4 = child.Name
            Scale2 = tonumber(Scale3(Scale4, "^Clr(%d+)$"))

            if Scale2 ~= nil and child:IsA("ImageLabel") then
                t5[Scale2] = child
                n2 = math.max(n2, Scale2)
                n1 = n2
            end
        end

        assert(n2 > 0, "Index Section.Pets has no Clr cell templates")

        local function variantForRarity(p3) -- line: 205
            -- upvalues: n1 (ref)
            return (math.clamp(p3, 1, n1))
        end

        local function dressWithRarityGradient(p4, p5) -- line: 209
            local UIGradient = p4:FindFirstChildOfClass("UIGradient")

            if UIGradient ~= nil then
                UIGradient:Destroy()
            end

            p4.BackgroundColor3 = Color3.new(1, 1, 1)
            p5:Clone().Parent = p4
        end

        local UIGridLayout = Section.Pets:FindFirstChildOfClass("UIGridLayout")

        assert(UIGridLayout ~= nil, "Index Section.Pets needs a UIGridLayout")
        Scale = Section.Size.Y.Scale
        Scale2 = Section.Pets.Size.Y.Scale
        Scale3 = UIGridLayout.CellSize.Y.Scale
        Scale4 = UIGridLayout.CellPadding.Y.Scale
        v16 = UIGridLayout.CellSize.X.Scale

        local v21 = UIGridLayout.CellPadding.X.Scale
        local v24 = math.max(1, (math.floor((1 + v21) / (v16 + v21))))

        v21 = Scale2 * Scale
        v16 = Scale3 * v21
        Scale3 = Scale4 * v21
        v21 = Section.BgFrame.Position.Y.Scale * Scale
        Scale4 = Section.Unlocked.Position.Y.Scale * Scale
        Scale2 = Section.Unlocked.Size.Y.Scale * Scale

        local t6 = {
            PerRow = v24,
            PetsPosAbs = Section.Pets.Position.Y.Scale * Scale,
            BgPosAbs = v21,
            BarSizeAbs = Scale2,
            BottomAbs = math.max(0, Scale - Scale4 - Scale2),
            CellAbs = v16,
            PadAbs = Scale3
        }

        function t1._build() -- line: 279
            -- upvalues: Trove (copy), t1 (copy)
            local self = setmetatable({}, t1)

            self._trove = Trove.new()
            self._openTrove = nil
            self._sections = {}
            self._sectionsByPage = {}
            self._currentPage = "World"
            self._selectedCategory = nil
            self._isOpen = false
            self._claimAllArmed = false
            self._builtLive = false
            self._builtLaboratory = false
            self._badgePulseTweens = {}
            self:_buildEntries()
            self:_init()

            return self
        end

        function t1._buildEntries(p6) -- line: 303
            -- upvalues: Players (copy), Areas (copy), Personalities (copy), Assets (copy), BrainrotEgg (copy), Constants (copy), HalloweenIndex (copy), Extinction (copy), LuminousEgg (copy), MonsterEgg (copy), Rift (copy), RiftEligibility (copy), RiftMachineSchedule (copy), ScrambleTradeIn (copy), Save (copy), t2 (copy)
            p6._builtLive = workspace:GetServerTimeNow() >= Constants.UPDATE_LIVE_AT
            p6._builtLaboratory = RiftMachineSchedule.IsLaboratoryTime()

            for _, v26 in ipairs(t2) do
                p6._sectionsByPage[v26] = {}
            end

            for v27, v28 in Areas.Directory do
                local t8 = {}

                for _, v29 in v28.DropTable do
                    local v30 = v29[1]
                    local v31 = v29[2]
                    local v32 = Assets.Directory[v30]

                    if not (v31 <= 0) and (v32.DontRoll ~= true or v28.IndexIncludeDontRoll == true) then
                        table.insert(t8, {
                            Category = v30,
                            Config = v32,
                            ItemData = {
                                Scale = 1,
                                HasBeenFirstPlaced = true,
                                Category = v30,
                                Mutations = {},
                                Personality = Personalities.Personalities.Normal
                            }
                        })
                    end
                end

                table.sort(t8, function(p7, p8) -- line: 341
                    local Rank = p7.Config.Rarity.Rank
                    local Rank2 = p8.Config.Rarity.Rank

                    if Rank ~= Rank2 then
                        return Rank < Rank2
                    end

                    if p7.Config.DropWeight == p8.Config.DropWeight then
                        return p7.Category < p8.Category
                    end

                    return p7.Config.DropWeight > p8.Config.DropWeight
                end)

                if #t8 > 0 then
                    table.insert(p6._sectionsByPage.World, {
                        RewardKind = "AreaBat",
                        SectionId = v27,
                        DisplayName = v28.DisplayName,
                        Icon = v28.IndexBackgroundImage or v28.Icon,
                        HeaderGradient = v28.ZoneGradient or v28.Rarity.RarityGradient,
                        SortOrder = Areas.GetProgressionOrder(v28),
                        RewardGearId = v28.IndexBatGearId,
                        Entries = t8
                    })
                end
            end

            local function limitedEntryOrder(p9, p10) -- line: 370
                if p9.Config.Rarity.Rank ~= p10.Config.Rarity.Rank then
                    return p9.Config.Rarity.Rank < p10.Config.Rarity.Rank
                end

                local v33 = p9.Config.EarningRate or 0
                local v34 = p10.Config.EarningRate or 0

                if v33 == v34 then
                    return p9.Category < p10.Category
                end

                return v33 < v34
            end

            local function collectLimitedEntries(p11) -- line: 387
                -- upvalues: limitedEntryOrder (copy), Personalities (copy), Assets (copy)
                local t14 = {}

                for _, v35 in ipairs(p11) do
                    local AssetId = v35.AssetId
                    local v36 = Assets.Directory[AssetId]

                    if v36 ~= nil then
                        table.insert(t14, {
                            Category = AssetId,
                            Config = v36,
                            ItemData = {
                                Scale = 1,
                                HasBeenFirstPlaced = true,
                                Category = AssetId,
                                Mutations = {},
                                Personality = Personalities.Personalities.Normal
                            }
                        })
                    end
                end

                table.sort(t14, limitedEntryOrder)

                return t14
            end

            local v37 = collectLimitedEntries(Extinction.Entries)
            local MechaReroll = Extinction.MechaReroll

            if MechaReroll ~= nil then
                for _, v38 in ipairs((collectLimitedEntries(MechaReroll.Entries))) do
                    table.insert(v37, v38)
                end
            end

            table.sort(v37, limitedEntryOrder)
            table.insert(p6._sectionsByPage.Limited, {
                SectionId = "LimitedEgg",
                HeaderGradient = nil,
                SortOrder = 1E+06,
                RewardKind = "GearClaim",
                RewardGearId = "GravityDisruptor",
                DisplayName = Extinction.DisplayName,
                Icon = p6._builtLive and "rbxassetid://97935712077919" or "rbxassetid://108209625322017",
                Entries = v37
            })

            if p6._builtLive then
                local v39 = collectLimitedEntries(LuminousEgg.Entries)

                for _, v40 in ipairs((collectLimitedEntries(LuminousEgg.MechaEntries))) do
                    table.insert(v39, v40)
                end

                table.sort(v39, limitedEntryOrder)
                table.insert(p6._sectionsByPage.Limited, {
                    SectionId = "LuminousEgg",
                    HeaderGradient = nil,
                    SortOrder = 1500000,
                    RewardKind = "GearClaim",
                    RewardGearId = "GravityDisruptor",
                    DisplayName = LuminousEgg.DisplayName,
                    Icon = LuminousEgg.BackgroundImage,
                    Entries = v39
                })
            end

            local v41 = collectLimitedEntries(BrainrotEgg.Entries)

            table.insert(p6._sectionsByPage.Limited, {
                SectionId = "BrainrotEgg",
                HeaderGradient = nil,
                SortOrder = 1e999,
                RewardKind = "GearClaim",
                RewardGearId = "BeeLauncher",
                DisplayName = BrainrotEgg.DisplayName,
                Icon = BrainrotEgg.BackgroundImage,
                Entries = v41
            })

            local v42 = collectLimitedEntries(MonsterEgg.Entries)

            for _, v43 in ipairs((collectLimitedEntries(MonsterEgg.MechaEntries))) do
                table.insert(v42, v43)
            end

            table.sort(v42, limitedEntryOrder)
            table.insert(p6._sectionsByPage.Limited, {
                SectionId = "MonsterEgg",
                HeaderGradient = nil,
                SortOrder = 3E+06,
                RewardKind = "GearClaim",
                RewardGearId = "BeeLauncher",
                DisplayName = MonsterEgg.DisplayName,
                Icon = MonsterEgg.BackgroundImage,
                Entries = v42
            })

            local v44 = false

            if RiftEligibility.IsFeatureLive() then
                local LocalPlayer = Players.LocalPlayer
                local v45 = false

                if LocalPlayer ~= nil then
                    local v46 = Save.Await()
                    local v47 = if v46 == nil then 0 else v46.SpeedPower
                    local v48 = if v46 == nil then 0 else v46.LastLogout

                    v45 = RiftEligibility.IsRevealed(LocalPlayer, v47, v48)
                end

                v44 = not v45
            end

            if not v44 then
                local t20 = {}

                for _, v49 in ipairs(Rift.Banners) do
                    for _, v50 in ipairs(v49.Pets) do
                        table.insert(t20, v50)
                    end
                end

                local v51 = collectLimitedEntries(t20)

                if #v51 > 0 then
                    table.insert(p6._sectionsByPage.Limited, {
                        SectionId = "Rift",
                        DisplayName = "Rift",
                        Icon = "rbxassetid://137708974138911",
                        HeaderGradient = nil,
                        SortOrder = 2E+06,
                        RewardKind = "Collection",
                        RewardGearId = "",
                        RewardIcon = "",
                        Entries = v51
                    })
                end
            end

            if p6._builtLaboratory then
                local t22 = {}

                for _, v52 in ipairs(ScrambleTradeIn.Banners) do
                    for _, v53 in ipairs(v52.Pets) do
                        table.insert(t22, v53)
                    end
                end

                local v54 = collectLimitedEntries(t22)

                if #v54 > 0 then
                    table.insert(p6._sectionsByPage.Limited, {
                        SectionId = "DrScramble",
                        DisplayName = "Dr. Scramble",
                        Icon = "rbxassetid://86377465284767",
                        HeaderGradient = nil,
                        SortOrder = 5E+05,
                        RewardKind = "GearClaim",
                        RewardGearId = "Scramble Sword",
                        Entries = v54
                    })
                end
            end

            for v55, v56 in ipairs(HalloweenIndex.GetSections()) do
                local v57 = collectLimitedEntries(v56.Entries)

                if #v57 > 0 then
                    table.insert(p6._sectionsByPage.Limited, {
                        HeaderGradient = nil,
                        RewardKind = "Collection",
                        RewardGearId = "",
                        RewardIcon = "",
                        SectionId = v56.Category,
                        DisplayName = v56.DisplayName,
                        Icon = v56.BackgroundImage,
                        SortOrder = 4E+05 + v55,
                        Entries = v57
                    })
                end
            end

            for _, v58 in ipairs(t2) do
                table.sort(p6._sectionsByPage[v58], function(p12, p13) -- line: 553
                    if p12.SortOrder == p13.SortOrder then
                        return p12.SectionId < p13.SectionId
                    end

                    return p12.SortOrder < p13.SortOrder
                end)
            end
        end

        function t1._getSave(_) -- line: 564
            -- upvalues: Save (copy)
            return Save.Await()
        end

        function t1._isDiscovered(p15, p16) -- line: 568
            local v59 = p15:_getSave()

            return v59 ~= nil and v59.Index[p16.Category] == true
        end

        function t1._isClaimed(p17, p18) -- line: 580
            local v60 = p17:_getSave()

            return v60 ~= nil and v60.IndexClaimedCategories[p18.Category] == true
        end

        function t1._isClaimable(p19, p20) -- line: 585
            return p19:_isDiscovered(p20) and not p19:_isClaimed(p20)
        end

        function t1._getEntryDisplayName(_, p22) -- line: 592
            -- upvalues: ItemDisplay (copy)
            return ItemDisplay.GetNameFromItemData(p22.ItemData)
        end

        function t1._getEntryByCategory(p23, p24) -- line: 599
            if p24 == nil then
                return nil
            end

            for _, v61 in ipairs(p23._sectionsByPage[p23._currentPage]) do
                for _, v62 in ipairs(v61.Entries) do
                    if v62.Category == p24 then
                        return v62
                    end
                end
            end

            return nil
        end

        function t1._renderHiddenIcon(_, p26) -- line: 618
            -- upvalues: v3 (copy)
            p26.ImageColor3 = v3
            p26.ImageTransparency = 0.35
        end

        function t1._renderVisibleIcon(_, p28) -- line: 623
            p28.ImageColor3 = Color3.fromRGB(255, 255, 255)
            p28.ImageTransparency = 0
        end

        function t1._renderEntryIcon(p29, p30, p31, p32) -- line: 628
            -- upvalues: Assets (copy)
            p30.Image = Assets.Directory[p31.Category].Icon or ""
            p30.ScaleType = Enum.ScaleType.Fit

            if p32 then
                p29:_renderVisibleIcon(p30)
            else
                p29:_renderHiddenIcon(p30)
            end
        end

        function t1._sizeSection(_, p34, p35) -- line: 647
            -- upvalues: t6 (copy)
            local v65 = math.max(1, (math.ceil(p35 / t6.PerRow)))
            local v66 = v65 * t6.CellAbs + (v65 - 1) * t6.PadAbs
            local v67 = t6.PetsPosAbs + v66 + 0.04
            local v68 = v67 + t6.BarSizeAbs
            local v69 = v68 + t6.BottomAbs
            local v71 = math.max(0, v68 - t6.BgPosAbs)

            p34.Size = UDim2.new(p34.Size.X.Scale, p34.Size.X.Offset, v69, 0)
            p34.BgFrame.Size = UDim2.new(p34.BgFrame.Size.X.Scale, 0, v71 / v69, 0)
            p34.BgFrame.Position = UDim2.new(p34.BgFrame.Position.X.Scale, 0, t6.BgPosAbs / v69, 0)
            p34.Unlocked.Size = UDim2.new(p34.Unlocked.Size.X.Scale, 0, t6.BarSizeAbs / v69, 0)
            p34.Unlocked.Position = UDim2.new(p34.Unlocked.Position.X.Scale, 0, (v67 + t6.BarSizeAbs * p34.Unlocked.AnchorPoint.Y) / v69, 0)
            p34.Pets.Position = UDim2.new(p34.Pets.Position.X.Scale, 0, t6.PetsPosAbs / v69, 0)
            p34.Pets.Size = UDim2.new(p34.Pets.Size.X.Scale, 0, v66 / v69, 0)

            local UIGridLayout = p34.Pets:FindFirstChildOfClass("UIGridLayout")

            if UIGridLayout ~= nil then
                UIGridLayout.CellSize = UDim2.new(UIGridLayout.CellSize.X.Scale, 0, t6.CellAbs / v66, 0)
                UIGridLayout.CellPadding = UDim2.new(UIGridLayout.CellPadding.X.Scale, 0, t6.PadAbs / v66, 0)
            end
        end

        function t1._ensureSectionPool(p36, p37) -- line: 682
            -- upvalues: v9 (copy), ScrollingFrame (copy), Section (copy), AreaIndexProgressComponent (copy)
            if p36._openTrove == nil then
                return
            end

            while #p36._sections < p37 do
                local clone = Section:Clone()

                clone.Name = `IndexArea{ #p36._sections + 1 }`
                clone.Visible = false
                clone.Parent = ScrollingFrame

                local t25 = {
                    Section = nil,
                    Frame = clone,
                    Slots = {},
                    ProgressComponent = AreaIndexProgressComponent.new(clone.Unlocked, function(p38) -- line: 701
                        -- upvalues: p36 (copy), v9 (copy)
                        v9(function() -- line: 702
                            -- upvalues: p38 (copy), p36 (copy)
                            if p38 ~= "LimitedEgg" and p38 ~= "BrainrotEgg" and p38 ~= "MonsterEgg" and p38 ~= "LuminousEgg" and p38 ~= "DrScramble" then
                                p36:_equipAreaBat(p38)
                            else
                                p36:_claimLimitedEggReward(p38)
                            end
                        end)
                    end)
                }

                table.insert(p36._sections, t25)
                p36._openTrove:Add(clone)
                p36._openTrove:Add(function() -- line: 720
                    -- upvalues: t25 (copy)
                    t25.ProgressComponent:Destroy()
                end)
            end
        end

        function t1._ensureSlotPool(p39, p40, p41) -- line: 726
            -- upvalues: n1 (ref), SurfaceButton (copy)
            if p39._openTrove == nil then
                return
            end

            for v72, v73 in ipairs(p41.Entries) do
                local Rarity = v73.Config.Rarity
                local v75 = math.clamp(Rarity.Rank, 1, n1)
                local v76 = ("Clr%*"):format(v75)
                local RarityGradient = if v75 < Rarity.Rank then Rarity.RarityGradient else nil
                local v77 = if RarityGradient == nil then v76 else ("%*:%*"):format(v76, Rarity._id)
                local v78 = p40.Slots[v72]

                if v78 ~= nil and v78.Variant ~= v77 then
                    v78.Teardown()
                    v78.Frame:Destroy()
                    v78 = nil
                end

                if v78 == nil then
                    local v79 = p40.Frame.Pets:FindFirstChild(v76)

                    assert(v79 ~= nil and v79:IsA("ImageLabel"), (("Index section lost its %* template"):format(v76)))

                    local clone = v79:Clone()

                    clone.Name = ("IndexEntry%*"):format(v72)
                    clone.Visible = false
                    clone.LayoutOrder = v72
                    clone.Parent = p40.Frame.Pets

                    if RarityGradient ~= nil then
                        local UIGradient = clone:FindFirstChildOfClass("UIGradient")

                        if UIGradient ~= nil then
                            UIGradient:Destroy()
                        end

                        clone.BackgroundColor3 = Color3.new(1, 1, 1)
                        RarityGradient:Clone().Parent = clone
                    end

                    local t26 = {
                        Entry = nil,
                        Frame = clone,
                        Variant = v77,
                        Teardown = function() -- Teardown | line: 772
                        end
                    }

                    t26.Teardown = SurfaceButton(clone, 1.08, function() -- line: 774
                        -- upvalues: p39 (copy), t26 (copy)
                        local Entry = t26.Entry

                        if Entry ~= nil and p39._selectedCategory ~= Entry.Category then
                            p39:_selectEntry(Entry.Category)
                        end
                    end)
                    p40.Slots[v72] = t26
                    p39._openTrove:Add(function() -- line: 783
                        -- upvalues: t26 (copy)
                        t26.Teardown()
                    end)
                    p39._openTrove:Add(clone)
                end
            end
        end

        function t1._renderSlot(p42, p43, p44) -- line: 791
            -- upvalues: v1 (copy), v2 (copy)
            local Frame = p43.Frame

            p43.Entry = p44

            if p44 ~= nil then
                local v82 = p42:_isDiscovered(p44)
                local v83 = p42:_isClaimed(p44)
                local v84 = p42._selectedCategory == p44.Category

                Frame.Visible = true

                if v82 then
                    Frame.TextLabel.Text = p42:_getEntryDisplayName(p44)
                else
                    Frame.TextLabel.Text = "???"
                end

                p42:_renderEntryIcon(Frame.Icon, p44, v82)

                local UIStroke = Frame:FindFirstChildOfClass("UIStroke")

                if UIStroke ~= nil then
                    local v85 = v82 and not v83

                    if v84 then
                        UIStroke.Color = v2
                    elseif v85 then
                        UIStroke.Color = v1
                    else
                        UIStroke.Color = Color3.fromRGB(0, 0, 0)
                    end
                end
            else
                Frame.Visible = false
            end
        end

        function t1._renderSlots(p45) -- line: 827
            local v86 = p45._sectionsByPage[p45._currentPage]

            p45:_ensureSectionPool(#v86)

            for v87, v88 in ipairs(p45._sections) do
                local v89 = v86[v87]

                v88.Section = v89

                if v89 ~= nil then
                    v88.Frame.Visible = true
                    v88.Frame.Name = v89.SectionId
                    v88.Frame.LayoutOrder = v87
                    v88.Frame.BgFrame.TextLabel.Text = v89.DisplayName
                    v88.Frame.BgFrame.Image = v89.Icon
                    v88.Frame.BgFrame.ScaleType = Enum.ScaleType.Crop

                    local n3 = 0

                    for _, v91 in v89.Entries do
                        if p45:_isDiscovered(v91) then
                            n3 += 1
                        end
                    end

                    local v92 = p45:_getSave()
                    local v93 = v92 ~= nil and (v92.GearInventory[v89.RewardGearId] or 0) > 0

                    if v89.RewardKind == "AreaBat" then
                        local v94 = v92 ~= nil and v92.VisitedGears[v89.RewardGearId] == true

                        v88.ProgressComponent:RenderAreaBat(v89.SectionId, v89.RewardGearId, n3, #v89.Entries, v94, v93)
                    elseif v89.RewardKind == "Collection" then
                        v88.ProgressComponent:RenderCollection(v89.SectionId, v89.RewardIcon or "", n3, #v89.Entries)
                    else
                        v88.ProgressComponent:RenderGearClaim(v89.SectionId, v89.RewardGearId, n3, #v89.Entries, v93)
                    end

                    p45:_sizeSection(v88.Frame, #v89.Entries)
                    p45:_ensureSlotPool(v88, v89)

                    for v95, v96 in ipairs(v88.Slots) do
                        p45:_renderSlot(v96, v89.Entries[v95])
                    end
                else
                    v88.Frame.Visible = false

                    for _, v90 in ipairs(v88.Slots) do
                        p45:_renderSlot(v90, nil)
                    end
                end
            end
        end

        function t1._selectEntry(p46, p47) -- line: 892
            p46._selectedCategory = p47
            p46:_renderSlots()
            p46:_renderInfo()
            p46:_renderRewards()
        end

        function t1._selectDefaultEntry(p48) -- line: 899
            if p48:_getEntryByCategory(p48._selectedCategory) ~= nil then
                return
            end

            for _, v97 in ipairs(p48._sectionsByPage[p48._currentPage]) do
                local v98 = v97.Entries[1]

                if v98 ~= nil then
                    p48._selectedCategory = v98.Category

                    return
                end
            end
        end

        function t1._renderInfo(p49) -- line: 914
            -- upvalues: Viewing (copy), Icon (copy), PetName (copy), PetRarity (copy), PetOdds (copy), AssetItems (copy), AssetOddsDisplay (copy), Simple (copy)
            local v99 = p49:_getEntryByCategory(p49._selectedCategory)

            if v99 == nil then
                return
            end

            local v100 = p49:_isDiscovered(v99)

            p49:_renderEntryIcon(Icon, v99, v100)
            PetRarity.Text = v99.Config.Rarity._id

            local UIGradient = PetOdds:FindFirstChildOfClass("UIGradient")

            if UIGradient then
                UIGradient:Destroy()
            end

            if v99.Config.Rarity.RarityGradient then
                Viewing.BackgroundColor3 = v99.Config.Rarity.Color
                Viewing.UIStroke.Color = v99.Config.Rarity.Color:Lerp(Color3.new(0, 0, 0), 0.5)
            end

            AssetOddsDisplay.DescribeItem(v99.Config, v99.ItemData, false)

            if not v100 then
                PetName.Text = "???"
                PetOdds.Text = "???"

                return
            end

            PetName.Text = p49:_getEntryDisplayName(v99)
            PetOdds.Text = ("$%*/s"):format((Simple.FormatCompact(AssetItems.IndexMoneyReward(v99.Category) / 100, ".#")))
        end

        function t1._renderRewards(p50) -- line: 954
            -- upvalues: Rewards (copy), ClaimRewardPanel (copy)
            local v102 = p50:_getEntryByCategory(p50._selectedCategory)
            local v103 = v102 ~= nil and p50:_isClaimed(v102)
            local v104 = v102 ~= nil and p50:_isClaimable(v102)

            ClaimRewardPanel.Render(Rewards, v102, v103, v104)
        end

        function t1._countUnclaimedByPage(p51, p52) -- line: 961
            local n4 = 0

            for _, v105 in ipairs(p51._sectionsByPage[p52]) do
                for _, v107 in ipairs(v105.Entries) do
                    if p51:_isClaimable(v107) then
                        n4 += 1
                    end
                end
            end

            return n4
        end

        function t1._countDiscoveredByPage(p53, p54) -- line: 974
            local n5 = 0

            for _, v108 in ipairs(p53._sectionsByPage[p54]) do
                for _, v110 in ipairs(v108.Entries) do
                    if p53:_isDiscovered(v110) then
                        n5 += 1
                    end
                end
            end

            return n5
        end

        function t1._countEntriesByPage(p55, p56) -- line: 987
            local n6 = 0

            for _, v111 in ipairs(p55._sectionsByPage[p56]) do
                n6 += #v111.Entries
            end

            return n6
        end

        function t1._startBadgePulse(p57) -- line: 997
            -- upvalues: IndexNotificationBadge (copy), TweenService (copy), EnsureUIScale (copy), v5 (copy)
            if #p57._badgePulseTweens > 0 then
                return
            end

            for _, v112 in ipairs(IndexNotificationBadge) do
                if v112:IsA("GuiObject") then
                    local v113 = EnsureUIScale(v112)

                    v113.Scale = 0.8

                    local tween = TweenService:Create(v113, v5, {
                        Scale = 1.2
                    })

                    table.insert(p57._badgePulseTweens, tween)
                    tween:Play()
                end
            end
        end

        function t1._stopBadgePulse(p58) -- line: 1016
            -- upvalues: IndexNotificationBadge (copy), EnsureUIScale (copy)
            if #p58._badgePulseTweens == 0 then
                return
            end

            for _, v114 in ipairs(p58._badgePulseTweens) do
                v114:Cancel()
                v114:Destroy()
            end

            table.clear(p58._badgePulseTweens)

            for _, v115 in ipairs(IndexNotificationBadge) do
                if v115:IsA("GuiObject") then
                    EnsureUIScale(v115).Scale = 1
                end
            end
        end

        function t1._renderNotificationBadges(p59, p60) -- line: 1033
            -- upvalues: IndexNotificationBadge (copy), renderNotificationBadge (copy), NotificationBadge (copy)
            for _, v116 in ipairs(IndexNotificationBadge) do
                renderNotificationBadge(v116, p60)
            end

            renderNotificationBadge(NotificationBadge, p60)

            if p60 > 0 then
                p59:_startBadgePulse()
            else
                p59:_stopBadgePulse()
            end
        end

        function t1._renderProgress(p61) -- line: 1048
            -- upvalues: ClaimAll (ref), Unlocked (copy), Fill (copy), TextLabel (copy), TweenService (copy), t2 (copy), v4 (copy)
            local v117 = p61:_countEntriesByPage(p61._currentPage)
            local v118 = p61:_countDiscoveredByPage(p61._currentPage)
            local n7 = 0

            for _, v119 in ipairs(t2) do
                n7 += p61:_countUnclaimedByPage(v119)
            end

            p61._claimAllArmed = n7 > 0
            p61:_renderNotificationBadges(n7)

            local v120 = ClaimAll == nil
            local _claimAllArmed

            if v120 then
                Unlocked.Visible = true
                Unlocked.Active = p61._claimAllArmed
                _claimAllArmed = p61._claimAllArmed
            else
                ClaimAll.Visible = p61._claimAllArmed
                Unlocked.Visible = not p61._claimAllArmed
                Unlocked.Active = false
            end

            if (not v120 or _claimAllArmed) and v120 then
                TextLabel.Text = ("CLAIM ALL (%*)!"):format(n7)
                TweenService:Create(Fill, v4, {
                    Size = UDim2.fromScale(1, 1)
                }):Play()

                return
            end

            TextLabel.Text = ("Unlocked: %*/%*"):format(v118, v117)

            local v121 = if v117 == 0 then 0 else math.clamp(v118 / v117, 0, 1)

            TweenService:Create(Fill, v4, {
                Size = UDim2.fromScale(v121, 1)
            }):Play()
        end

        function t1._renderTabs(p62) -- line: 1083
            -- upvalues: t4 (copy), TweenService (copy), v6 (copy), v7 (copy)
            for v123, v124 in t4 do
                local v125 = v123 == p62._currentPage

                TweenService:Create(v124.Button, v7, {
                    BackgroundColor3 = if v125 then v124.Tint else v6
                }):Play()

                if v124.Stroke ~= nil then
                    TweenService:Create(v124.Stroke, v7, {
                        Transparency = if v125 then v124.StrokeTransparency else 1
                    }):Play()
                end

                if v124.Label ~= nil then
                    TweenService:Create(v124.Label, v7, {
                        TextTransparency = if v125 then v124.TextTransparency else 0.3
                    }):Play()
                end

                if v124.Icon ~= nil then
                    TweenService:Create(v124.Icon, v7, {
                        ImageTransparency = if v125 then v124.IconTransparency else 0.8
                    }):Play()
                end
            end
        end

        function t1._selectPage(p63, p64) -- line: 1113
            -- upvalues: ScrollingFrame (copy)
            if p63._currentPage == p64 or p63._sectionsByPage[p64] == nil then
                return
            end

            p63._currentPage = p64
            p63._selectedCategory = nil
            ScrollingFrame.CanvasPosition = Vector2.zero
            p63:_render()
        end

        function t1._render(p65) -- line: 1124
            -- upvalues: Constants (copy), RiftMachineSchedule (copy)
            if p65._builtLive ~= (workspace:GetServerTimeNow() >= Constants.UPDATE_LIVE_AT) or p65._builtLaboratory ~= RiftMachineSchedule.IsLaboratoryTime() then
                p65:_buildEntries()
                p65._selectedCategory = nil
            end

            if p65._isOpen then
                p65:_renderTabs()
                p65:_selectDefaultEntry()
                p65:_renderSlots()
                p65:_renderInfo()
                p65:_renderRewards()
            end

            p65:_renderProgress()
        end

        function t1._open(p66) -- line: 1145
            -- upvalues: Trove (copy)
            if p66._isOpen then
                return
            end

            p66._isOpen = true
            p66._currentPage = "World"
            p66._selectedCategory = nil
            p66._openTrove = Trove.new()
            p66:_buildEntries()
            p66:_render()
        end

        function t1._close(p67) -- line: 1158
            p67._isOpen = false
            p67._currentPage = "World"
            p67._selectedCategory = nil

            if p67._openTrove ~= nil then
                p67._openTrove:Destroy()
                p67._openTrove = nil
            end

            table.clear(p67._sections)
            p67:_render()
        end

        function t1._processClaimResults(_, p69) -- line: 1170
            -- upvalues: Save (copy)
            if p69 == nil then
                return
            end

            for _, v126 in ipairs(p69) do
                Save.Amend("IndexClaimedCategories", function(p70) -- line: 1179
                    -- upvalues: v126 (copy)
                    p70[v126.Category] = true
                end)
            end
        end

        function t1._claimSelected(p71) -- line: 1185
            -- upvalues: v8 (copy), Remotes (copy)
            local v127 = p71:_getEntryByCategory(p71._selectedCategory)

            if v127 ~= nil and p71:_isClaimable(v127) then
                local v128, v129, v130 = Remotes.Codex.AskRedeem:InvokeServer(v127.Category)

                if v128 then
                    p71:_processClaimResults(v130)
                    p71:Refresh()
                else
                    v8:AtWarning():Log((("[Index] Claim failed: %*"):format(v129)))
                end
            end
        end

        function t1._claimAll(p72) -- line: 1201
            -- upvalues: v8 (copy), Remotes (copy)
            local v131, v132, v133 = Remotes.Codex.AskRedeemAll:InvokeServer()

            if v131 then
                p72:_processClaimResults(v133)
                p72:Refresh()
            else
                v8:AtWarning():Log((("[Index] Claim all failed: %*"):format(v132)))
            end
        end

        function t1._equipAreaBat(p73, p74) -- line: 1212
            -- upvalues: v8 (copy), Remotes (copy)
            local v134, v135 = Remotes.Codex.AskWearFieldBat:InvokeServer(p74)

            if v134 then
                p73:Refresh()
            else
                v8:AtWarning():Log((("[Index] Equip area bat failed: %*"):format(v135)))
            end
        end

        function t1._claimLimitedEggReward(p75, p76) -- line: 1222
            -- upvalues: v8 (copy), Remotes (copy)
            local v136, v137 = Remotes.Codex.AskRedeemLimitedEgg:InvokeServer(p76)

            if v136 then
                p75:Refresh()
            else
                v8:AtWarning():Log((("[Index] Limited Egg reward claim failed: %*"):format(v137)))
            end
        end

        function t1.Refresh(p77) -- line: 1236
            p77:_render()
        end

        function t1._init(p78) -- line: 1244
            -- upvalues: v9 (copy), IndexButton (copy), ClaimAll (ref), Section (copy), Claim (copy), Unlocked (copy), t4 (copy), t5 (copy), ButtonFX (copy), Save (copy), SurfaceButton (copy), Tabs (copy)
            Section.Visible = false

            for _, v138 in t5 do
                v138.Visible = false
            end

            for _, v139 in IndexButton do
                p78._trove:Add(ButtonFX(v139, 1.08, function() -- line: 1250
                    -- upvalues: Tabs (copy)
                    Tabs.Toggle("Index")
                end))
            end

            for v140, v141 in t4 do
                p78._trove:Add(ButtonFX(v141.Button, 1.06, function() -- line: 1255
                    -- upvalues: p78 (copy), v140 (copy)
                    p78:_selectPage(v140)
                end))
            end

            p78._trove:Add(ButtonFX(Claim, nil, function() -- line: 1259
                -- upvalues: p78 (copy), v9 (copy)
                v9(function() -- line: 1260
                    -- upvalues: p78 (copy)
                    p78:_claimSelected()
                end)
            end))

            local function v142() -- line: 1264
                -- upvalues: p78 (copy), v9 (copy)
                if p78._claimAllArmed then
                    v9(function() -- line: 1266
                        -- upvalues: p78 (copy)
                        p78:_claimAll()
                    end)
                end
            end

            p78._trove:Add(SurfaceButton(Unlocked, 1.04, v142))

            if ClaimAll ~= nil then
                p78._trove:Add(if ClaimAll:IsA("GuiButton") then ButtonFX(ClaimAll, 1.04, v142) else SurfaceButton(ClaimAll, 1.04, v142))
            end

            p78._trove:Add(Save.WatchFields({
                "Index",
                "IndexClaimedCategories",
                "VisitedGears",
                "GearInventory"
            }, function() -- line: 1283
                -- upvalues: p78 (copy)
                p78:Refresh()
            end))
            p78._trove:Connect(Tabs.Activated, function(p79) -- line: 1288
                -- upvalues: p78 (copy)
                if p79 == "Index" then
                    p78:_open()
                end
            end)
            p78._trove:Connect(Tabs.Deactivated, function(p80) -- line: 1293
                -- upvalues: p78 (copy)
                if p80 == "Index" then
                    p78:_close()
                end
            end)
            p78:_render()
        end

        return t1._build()
    end
}
