-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContextActionService = game:GetService("ContextActionService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Directory = require(ReplicatedStorage.Data.Assets).Directory
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local ButtonHintStrip = require(ReplicatedStorage.Client.ButtonHintStrip)

require(ReplicatedStorage.Shared.Globals.Constants)

local EggRecords = require(ReplicatedStorage.Shared.Util.EggRecords)

require(ReplicatedStorage.Shared.Types.Eggs)

local GUI = require(ReplicatedStorage.Client.GUI)
local TryLock = require(ReplicatedStorage.Shared.Utils.TryLock)
local Log = require(ReplicatedStorage.Packages.Log)
local Message = require(ReplicatedStorage.Client.Message)
local Mutations = require(ReplicatedStorage.Shared.Modules.Mutations)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local PlatformController = require(ReplicatedStorage.Client.PlatformController)
local Products = require(ReplicatedStorage.Data.Products)
local Storefront = require(ReplicatedStorage.Client.Functions.Storefront)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Sakura = require(ReplicatedStorage.Data.Sakura)
local SakuraBloomPolicy = require(ReplicatedStorage.Client.Modules.SakuraBloomPolicy)
local SakuraSignals = require(ReplicatedStorage.Client.SakuraSignals)
local Sakura2 = require(ReplicatedStorage.Shared.Types.Sakura)
local Save = require(ReplicatedStorage.Shared.Save)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = utf8.char(57346)
local v2 = Color3.fromRGB(255, 0, 0)
local v3 = Log.new()
local v4 = TryLock()
local _ = Players.LocalPlayer

return {
    Start = function() -- Start | line: 65
        -- upvalues: ContextActionService (copy), MarketplaceService (copy), Players (copy), ReplicatedStorage (copy), TweenService (copy), UserInputService (copy), Directory (copy), ButtonFX (copy), ButtonHintStrip (copy), EggRecords (copy), GUI (copy), Message (copy), Mutations (copy), Toast (copy), PlatformController (copy), Products (copy), Storefront (copy), Remotes (copy), Sakura (copy), SakuraBloomPolicy (copy), SakuraSignals (copy), Sakura2 (copy), Save (copy), Simple (copy), Tabs (copy), Trove (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy)
        local SakuraEggCharge = GUI.SakuraEggCharge().SakuraEggCharge

        assert(SakuraEggCharge:IsA("Frame"), "SakuraEggCharge.SakuraEggCharge must be a Frame")

        local Content = SakuraEggCharge.Content

        assert(Content:IsA("Frame"), "SakuraEggCharge.Content must be a Frame")

        local EggIconHolder = Content.EggIconHolder
        local Icon = EggIconHolder.Icon

        assert(Icon:IsA("ImageLabel"), "SakuraEggCharge EggIconHolder.Icon must be an ImageLabel")

        local Title = Icon.Title

        assert(Title:IsA("TextLabel"), "SakuraEggCharge EggIconHolder.Icon.Title must be a TextLabel")

        local Mutate = Content.Mutate

        assert(Mutate:IsA("ImageButton"), "SakuraEggCharge.Content.Mutate must be an ImageButton")

        local Deposit = Content.Deposit

        assert(Deposit:IsA("ImageButton"), "SakuraEggCharge.Content.Deposit must be an ImageButton")

        local function optionalGui(p1, p2, p3) -- line: 80
            local v5 = p1:FindFirstChild(p2, true)

            return if v5 and v5:IsA(p3) then v5 else nil
        end

        local v6 = SakuraEggCharge:FindFirstChild("RemoveEgg", true)

        if not (v6 and v6:IsA("GuiButton")) then
            v6 = nil
        end

        local v7 = SakuraEggCharge:FindFirstChild("Help", true)

        if not (v7 and v7:IsA("GuiButton")) then
            v7 = nil
        end

        local v8 = SakuraEggCharge:FindFirstChild("CostLabel", true)

        if not (v8 and v8:IsA("TextLabel")) then
            v8 = nil
        end

        local v9 = SakuraEggCharge:FindFirstChild("CrystalBalance", true)

        if not (v9 and v9:IsA("TextLabel")) then
            v9 = nil
        end

        local SliderBar = Content.SliderBar
        local Fill = SliderBar.Progress.Fill

        assert(Fill:IsA("Frame"), "SakuraEggCharge SliderBar.Progress.Fill must be a Frame")

        local SliderButton = SliderBar.SliderButton

        assert(SliderButton:IsA("ImageButton"), "SakuraEggCharge SliderBar.SliderButton must be an ImageButton")

        local ProgressBar = Content.ProgressBar
        local ImageLabel2 = ProgressBar.Frame1.ImageLabel

        assert(ImageLabel2:IsA("ImageLabel"), "SakuraEggCharge ProgressBar.Frame1.ImageLabel must be an ImageLabel")

        local UIGradient = ImageLabel2.UIGradient

        assert(UIGradient:IsA("UIGradient"), "SakuraEggCharge ProgressBar.Frame1.ImageLabel.UIGradient must be a UIGradient")

        local ImageLabel4 = ProgressBar.Frame2.ImageLabel

        assert(ImageLabel4:IsA("ImageLabel"), "SakuraEggCharge ProgressBar.Frame2.ImageLabel must be an ImageLabel")

        local UIGradient3 = ImageLabel4.UIGradient

        assert(UIGradient3:IsA("UIGradient"), "SakuraEggCharge ProgressBar.Frame2.ImageLabel.UIGradient must be a UIGradient")
        UIGradient.Enabled = true
        UIGradient3.Enabled = true

        local SliderButton2 = ProgressBar.SliderButton

        assert(SliderButton2:IsA("ImageButton"), "SakuraEggCharge ProgressBar.SliderButton must be an ImageButton")

        local CurrentChargeLabel = Content.CurrentChargeHolder.CurrentChargeLabel

        assert(CurrentChargeLabel:IsA("TextLabel"), "SakuraEggCharge CurrentChargeLabel must be a TextLabel")

        local SidePopUp = SakuraEggCharge.SidePopUp
        local MutationList = SidePopUp.MutationList

        assert(MutationList:IsA("ScrollingFrame"), "SakuraEggCharge SidePopUp.MutationList must be a ScrollingFrame")

        local BuyLuck = SidePopUp.BuyLuck

        assert(BuyLuck:IsA("ImageButton"), "SakuraEggCharge SidePopUp.BuyLuck must be an ImageButton")

        local Price = BuyLuck.Price

        assert(Price:IsA("TextLabel"), "SakuraEggCharge BuyLuck.Price must be a TextLabel")

        local TextLabel3 = BuyLuck.TextLabel

        assert(TextLabel3:IsA("TextLabel"), "SakuraEggCharge BuyLuck.TextLabel must be a TextLabel")

        local EggPicker = SakuraEggCharge.EggPicker

        assert(EggPicker:IsA("Frame"), "SakuraEggCharge.EggPicker must be a Frame")

        local Eggs = EggPicker.Eggs

        assert(Eggs:IsA("ScrollingFrame"), "SakuraEggCharge EggPicker.Eggs must be a ScrollingFrame")

        local InventoryTemplate = ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("GUI"):WaitForChild("BackpackController"):WaitForChild("Main"):WaitForChild("InventoryTemplate")

        assert(InventoryTemplate:IsA("GuiButton"), "BackpackController.Main.InventoryTemplate must be a GuiButton")

        local child, child2
        local child3 = nil
        local v10 = nil

        for _, child4 in ipairs(Deposit:GetChildren()) do
            if child4:IsA("TextLabel") then
                if child4.Text:find("Deposit") then
                    child3 = child4
                    child = child4
                else
                    v10 = child4
                    child2 = child4
                end
            end
        end

        assert(child3 and v10, "SakuraEggCharge Deposit button needs its two TextLabels")

        local LockedOverlay = Mutate.LockedOverlay

        assert(LockedOverlay:IsA("Frame"), "SakuraEggCharge Mutate.LockedOverlay must be a Frame")

        local TextLabel5 = Mutate:FindFirstChildOfClass("TextLabel")

        assert(TextLabel5, "SakuraEggCharge Mutate button needs its ready TextLabel")

        local child4
        local v11 = nil

        for _, child in ipairs(LockedOverlay:GetChildren()) do
            if child:IsA("TextLabel") and child.Text ~= "Mutate" then
                v11 = child
                child4 = child
            end
        end

        assert(v11, "SakuraEggCharge Mutate.LockedOverlay needs its unlock TextLabel")

        local t2 = {}

        for _, child in ipairs(MutationList:GetChildren()) do
            if child:IsA("Frame") and child:FindFirstChild("MutationName") then
                table.insert(t2, child)
            end
        end

        table.sort(t2, function(p4, p5) -- line: 192
            return p4.AbsolutePosition.Y < p5.AbsolutePosition.Y
        end)
        assert(#t2 >= 2, "SakuraEggCharge MutationList needs two mutation rows")

        local ImageColor3 = Icon.ImageColor3
        local ImageLabel6 = Instance.new("ImageLabel")

        ImageLabel6.Name = "ClickIndicator"
        ImageLabel6.Image = "rbxassetid://96606025304766"
        ImageLabel6.BackgroundTransparency = 1
        ImageLabel6.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel6.Position = UDim2.fromScale(0.8, 0.8)
        ImageLabel6.Size = UDim2.fromScale(0.45, 0.45)
        ImageLabel6.ZIndex = Icon.ZIndex + 2
        ImageLabel6.Visible = false
        Instance.new("UIAspectRatioConstraint").Parent = ImageLabel6

        local UIScale = Instance.new("UIScale")

        UIScale.Parent = ImageLabel6
        ImageLabel6.Parent = Icon

        local tween = TweenService:Create(UIScale, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -1, true), {
            Scale = 1.3
        })

        local function setClickIndicator(p6) -- line: 222
            -- upvalues: ImageLabel6 (copy), UIScale (copy), tween (copy)
            if ImageLabel6.Visible ~= p6 then
                ImageLabel6.Visible = p6

                if p6 then
                    UIScale.Scale = 1
                    tween:Play()
                else
                    tween:Cancel()
                end
            end
        end

        local BackgroundColor3 = Mutate.BackgroundColor3
        local v13 = BackgroundColor3:Lerp(Color3.new(0, 0, 0), 0.45)
        local BackgroundColor3_2 = Deposit.BackgroundColor3
        local v14 = BackgroundColor3_2:Lerp(Color3.new(0, 0, 0), 0.45)
        local v15 = Trove.new()
        local n1 = 1
        local v16 = false
        local v17 = false
        local v18 = true
        local t3 = {}

        local function notifyError(p7) -- line: 250
            -- upvalues: Toast (copy), v2 (copy)
            Toast.Show({
                Seconds = 3,
                Text = p7,
                Color = v2
            })
        end

        local function getState() -- line: 258
            -- upvalues: Save (copy)
            local v19 = Save.Await()

            if v19 == nil then
                return nil, 0
            end

            return v19.Sakura, v19.SakuraCrystals
        end

        local function isUnlocked() -- line: 266
            -- upvalues: SakuraBloomPolicy (copy), Save (copy)
            local v20 = Save.IsLoaded()
            local v21 = if v20 then Save.Peek() else nil

            return SakuraBloomPolicy.HasBloomUnlocked(v20, v21)
        end

        local function getRarityNumber(p8) -- line: 272
            -- upvalues: Directory (copy)
            local v22 = Directory[p8]

            assert(v22 ~= nil, (("Missing asset config %*"):format(p8)))

            return v22.Rarity.Rank
        end

        local function getRequired(p9) -- line: 278
            -- upvalues: Sakura (copy)
            if p9.Egg == false then
                return 0
            end

            return Sakura.GetRequiredCrystals()
        end

        local function getDepositCapacity(p10, p11) -- line: 285
            -- upvalues: Sakura (copy)
            local v25 = if p10.Egg == false then 0 else Sakura.GetRequiredCrystals()

            if v25 <= 0 then
                return 0
            end

            return (math.max(0, (math.min(p11, Sakura.GetFreeChargeCap(v25) - p10.Deposited))))
        end

        local function getSliderAmount(p12, p13) -- line: 293
            -- upvalues: n1 (ref), Sakura (copy)
            local v28 = if p12.Egg == false then 0 else Sakura.GetRequiredCrystals()
            local v29 = if v28 <= 0 then 0 else math.max(0, (math.min(p13, Sakura.GetFreeChargeCap(v28) - p12.Deposited)))

            if v29 <= 0 then
                return 0
            end

            return (math.max(1, (math.floor(v29 * n1 + 0.5))))
        end

        local v34 = NumberSequence.new(1)
        local v35 = NumberSequence.new(0)

        local function applyArcCut(p14, p15, p16, p17) -- line: 305
            -- upvalues: v34 (copy), v35 (copy)
            local AbsoluteSize = p15.AbsoluteSize
            local v39 = Vector2.new(math.cos((math.rad(p17))), (math.sin((math.rad(p17)))))
            local v41 = AbsoluteSize.X * math.abs(v39.X) + AbsoluteSize.Y * math.abs(v39.Y)

            if v41 <= 0 then
                return
            end

            local v42 = 0.5 + (p16 - (p15.AbsolutePosition + AbsoluteSize / 2)):Dot(v39) / v41

            p14.Rotation = p17

            if v42 <= 0.001 then
                p14.Transparency = v34
            elseif v42 >= 1 then
                p14.Transparency = v35
            else
                p14.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(v42 - 0.001, 0),
                    NumberSequenceKeypoint.new(v42, 1),
                    NumberSequenceKeypoint.new(1, 1)
                })
            end
        end

        local function setArc(p18) -- line: 333
            -- upvalues: ProgressBar (copy), ImageLabel2 (copy), UIGradient (copy), ImageLabel4 (copy), UIGradient3 (copy), SliderButton2 (copy), v34 (copy), v35 (copy), applyArcCut (copy), Sakura (copy)
            local v44 = math.clamp(p18 / Sakura.Incubator.MaxChargePercent, 0, 1)
            local v45 = 3.4173546754048973 - v44 * 3.693116697220001

            SliderButton2.Position = UDim2.fromScale(math.cos(v45) * 0.473 + 0.5, 0.7587 - math.sin(v45) * 0.7207)

            local AbsoluteSize = ProgressBar.AbsoluteSize
            local v49 = math.deg((math.atan2(0.7207 * AbsoluteSize.Y * math.sin(v45), 0.473 * AbsoluteSize.X * math.cos(v45))))

            if v49 < -90 then
                v49 += 360
            end

            local v50 = 90 - v49
            local v51 = ProgressBar.AbsolutePosition + Vector2.new(0.5 * AbsoluteSize.X, 0.7587 * AbsoluteSize.Y)

            if v44 <= 0 then
                UIGradient.Transparency = v34
            else
                applyArcCut(UIGradient, ImageLabel2, v51, (math.clamp(v50, -180, 0)))
            end

            if v44 >= 1 then
                UIGradient3.Transparency = v35
            else
                applyArcCut(UIGradient3, ImageLabel4, v51, (math.clamp(v50, 0, 180)))
            end
        end

        local NumberValue = Instance.new("NumberValue")
        local tween2

        NumberValue.Changed:Connect(function(p19) -- line: 365
            -- upvalues: CurrentChargeLabel (copy), setArc (copy)
            setArc(p19)
            CurrentChargeLabel.Text = ("%*%%"):format((math.floor(p19 + 0.5)))
        end)

        local function showCharge(p20, p21) -- line: 370
            -- upvalues: CurrentChargeLabel (copy), setArc (copy), NumberValue (copy), tween2 (ref), TweenService (copy)
            if tween2 then
                tween2:Cancel()
                tween2 = nil
            end

            if not p21 and not (math.abs(NumberValue.Value - p20) < 0.01) then
                local tween = TweenService:Create(NumberValue, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Value = p20
                })

                tween2 = tween
                tween:Play()

                return
            end

            NumberValue.Value = p20
            setArc(p20)
            CurrentChargeLabel.Text = ("%*%%"):format((math.floor(p20 + 0.5)))
        end

        local function setSlider(p22) -- line: 390
            -- upvalues: Fill (copy), SliderButton (copy), n1 (ref)
            n1 = math.clamp(p22, 0, 1)
            Fill.Size = UDim2.fromScale(n1, 1)
            SliderButton.Position = UDim2.fromScale(n1, SliderButton.Position.Y.Scale)
        end

        local scheduleRender

        local function getProductPrice(p23) -- line: 398
            -- upvalues: t3 (copy), scheduleRender (ref), MarketplaceService (copy), Products (copy)
            local v55 = Products.Directory[p23]
            local v56 = t3[v55.ProductId]

            if v56 then
                return v56
            end

            task.spawn(function() -- line: 404
                -- upvalues: v55 (copy), t3 (copy), scheduleRender (ref), MarketplaceService (copy)
                local GetProductInfo = MarketplaceService.GetProductInfo
                local ProductId = v55.ProductId
                local Product = Enum.InfoType.Product
                local ok, result = pcall(GetProductInfo, MarketplaceService, ProductId, Product)

                if not (ok and result and result.PriceInRobux) then
                    return
                end

                t3[v55.ProductId] = result.PriceInRobux
                scheduleRender()
            end)

            return nil
        end

        local function renderEggIcon(p24) -- line: 419
            -- upvalues: Icon (copy), Title (copy), ImageColor3 (copy), ImageLabel6 (copy), UIScale (copy), tween (copy), Directory (copy)
            local Egg = p24.Egg

            if Egg == false then
                Icon.Image = "rbxassetid://111633736515788"
                Icon.ImageColor3 = ImageColor3
                Title.Visible = true

                if ImageLabel6.Visible ~= true then
                    ImageLabel6.Visible = true
                    UIScale.Scale = 1
                    tween:Play()
                end
            else
                local v57 = Directory[Egg.Egg.AssetCategory]

                assert(v57 ~= nil, (("Missing asset config %*"):format(Egg.Egg.AssetCategory)))
                Icon.Image = v57.Egg.Icon
                Icon.ImageColor3 = Color3.new(1, 1, 1)
                Title.Visible = false

                if ImageLabel6.Visible ~= false then
                    ImageLabel6.Visible = false
                    tween:Cancel()
                end
            end
        end

        local function renderMutationRows(p25, p26) -- line: 436
            -- upvalues: t2 (copy), Mutations (copy), Sakura (copy)
            local t4 = {
                {
                    Name = Sakura.MutationName,
                    Chance = Sakura.GetEffectiveMutationChance(p25, p26)
                },
                {
                    Name = Sakura.SpecialMutationName,
                    Chance = Sakura.GetSpecialChance(p25, p26)
                }
            }

            for v60, v61 in ipairs(t4) do
                local v62 = t2[v60]
                local MutationName, ChanceLabel = v62.MutationName, v62.ChanceLabel

                assert(MutationName:IsA("TextLabel") and ChanceLabel:IsA("TextLabel"), "Mutation row needs MutationName and ChanceLabel")

                local v64 = Mutations.Get(v61.Name)

                MutationName.Text = Mutations.LabelOf(v61.Name)

                if v64 then
                    MutationName.TextColor3 = v64.Tint
                end

                ChanceLabel.Text = string.format("%.1f%%", v61.Chance):gsub("%.0%%", "%%")
            end
        end

        local function renderCost() -- line: 464
            -- upvalues: v8 (ref), Sakura (copy), Simple (copy)
            local v65 = ("Mutation Cost: <font color=\"#FF69B4\">%* crystals</font>"):format((Simple.FormatCompact(Sakura.GetRequiredCrystals())))

            if v8 then
                v8.Text = v65
            end
        end

        local function render() -- line: 473
            -- upvalues: Mutate (copy), Deposit (copy), v6 (ref), v8 (ref), v9 (ref), SliderBar (copy), BuyLuck (copy), Price (copy), TextLabel3 (copy), child (ref), child2 (ref), LockedOverlay (copy), TextLabel5 (copy), child4 (ref), BackgroundColor3 (copy), v13 (copy), BackgroundColor3_2 (copy), v14 (copy), n1 (ref), v18 (ref), t3 (copy), showCharge (copy), scheduleRender (ref), renderEggIcon (copy), renderMutationRows (copy), MarketplaceService (copy), Products (copy), Sakura (copy), Save (copy), Simple (copy), v1 (copy)
            local v66 = Save.Await()
            local Sakura2, v67

            if v66 ~= nil then
                Sakura2 = v66.Sakura
                v67 = v66.SakuraCrystals
            else
                v67 = 0
            end

            if Sakura2 == nil then
                return
            end

            local Egg = Sakura2.Egg
            local v68 = if Sakura2.Egg == false then 0 else Sakura.GetRequiredCrystals()
            local v69 = Sakura.GetChargePercent(Sakura2.Deposited, v68)
            local v70 = Egg ~= false
            local v71 = v69 >= 100
            local v72 = if Sakura2.Egg == false then 0 else Sakura.GetRequiredCrystals()
            local v73 = if v72 <= 0 then 0 else math.max(0, (math.min(v67, Sakura.GetFreeChargeCap(v72) - Sakura2.Deposited)))
            local v76 = v70 and Sakura2.Deposited >= Sakura.GetFreeChargeCap(v68)

            renderEggIcon(Sakura2)
            showCharge(v69, v18)
            v18 = false

            if v9 then
                v9.Text = ("You have <font color=\"#FF69B4\">%*</font> crystals"):format((Simple.FormatCompact(v67)))
            end

            if v6 then
                v6.Visible = v70
            end

            local v77 = ("Mutation Cost: <font color=\"#FF69B4\">%* crystals</font>"):format((Simple.FormatCompact(Sakura.GetRequiredCrystals())))

            if v8 then
                v8.Text = v77
            end

            renderMutationRows(v69, Sakura2.LuckBoost)

            local v78 = if Sakura2.Egg == false then 0 else Sakura.GetRequiredCrystals()
            local v79 = if v78 <= 0 then 0 else math.max(0, (math.min(v67, Sakura.GetFreeChargeCap(v78) - Sakura2.Deposited)))
            local v82 = if v79 <= 0 then 0 else math.max(1, (math.floor(v79 * n1 + 0.5)))

            SliderBar.Visible = v70 and v73 > 0

            if v70 and v82 > 0 then
                Deposit.Active = true
                Deposit.BackgroundColor3 = BackgroundColor3_2

                local child3 = child

                child3.Text = ("Deposit %*"):format((Simple.FormatCompact(v82)))

                local child4 = child2

                child4.Text = ("+%*%% Charge"):format((math.floor(v82 / v68 * 100 + 0.5)))
            elseif v70 then
                Deposit.Active = false
                Deposit.BackgroundColor3 = v14

                local child3 = child

                child3.Text = v76 and "Fully Charged" or "No Crystals"
                child2.Text = ""
            else
                Deposit.Active = true
                Deposit.BackgroundColor3 = BackgroundColor3_2
                child.Text = "Place Egg"
                child2.Text = "Choose an egg to mutate"
            end

            Mutate.Active = v71
            Mutate.BackgroundColor3 = if v71 then BackgroundColor3 else v13
            LockedOverlay.Visible = not v71
            TextLabel5.Visible = v71
            child4.Text = "(Unlocks at 100%)"

            local MaxLuckBoosts = Sakura.Incubator.MaxLuckBoosts

            BuyLuck.Visible = v70 and Sakura2.LuckBoost < MaxLuckBoosts
            TextLabel3.Text = ("<font color=\"#FF69B4\">%*x</font> Great Bloom Odds (%*/%*)"):format(Sakura.GetLuckMultiplier(Sakura2.LuckBoost + 1), Sakura2.LuckBoost, MaxLuckBoosts)

            local v87 = Sakura.Incubator.LuckBoostProductNames[Sakura2.LuckBoost + 1]
            local v88

            if v87 then
                local v89 = Products.Directory[v87]

                v88 = t3[v89.ProductId]

                if not v88 then
                    v88 = nil
                    task.spawn(function() -- line: 404
                        -- upvalues: v89 (copy), t3 (copy), scheduleRender (ref), MarketplaceService (copy)
                        local GetProductInfo = MarketplaceService.GetProductInfo
                        local ProductId = v89.ProductId
                        local Product = Enum.InfoType.Product
                        local ok, result = pcall(GetProductInfo, MarketplaceService, ProductId, Product)

                        if not (ok and result and result.PriceInRobux) then
                            return
                        end

                        t3[v89.ProductId] = result.PriceInRobux
                        scheduleRender()
                    end)
                end
            end

            Price.Text = if v88 then ("%*%*"):format(v1, v88) else ""
        end

        function scheduleRender() -- line: 535
            -- upvalues: v17 (ref), render (copy)
            if not v17 then
                v17 = true
                task.defer(function() -- line: 540
                    -- upvalues: v17 (ref), render (copy)
                    v17 = false
                    render()
                end)
            end
        end

        local function closePicker() -- line: 546
            -- upvalues: EggPicker (copy), v15 (copy)
            v15:Clean()
            EggPicker.Visible = false
        end

        local function requestInsert(p27) -- line: 551
            -- upvalues: Fill (copy), SliderButton (copy), EggPicker (copy), v15 (copy), n1 (ref), scheduleRender (ref), Toast (copy), Remotes (copy), v2 (copy), v4 (copy)
            v4(function() -- line: 552
                -- upvalues: p27 (copy), Fill (copy), SliderButton (copy), EggPicker (copy), v15 (copy), n1 (ref), scheduleRender (ref), Toast (copy), Remotes (copy), v2 (copy)
                local v91, v92 = Remotes.Bloomery.AskLoadEgg:InvokeServer(p27)

                if v91 then
                    v15:Clean()
                    EggPicker.Visible = false
                    n1 = 1
                    Fill.Size = UDim2.fromScale(n1, 1)
                    SliderButton.Position = UDim2.fromScale(n1, SliderButton.Position.Y.Scale)
                    scheduleRender()
                else
                    if typeof(v92) ~= "string" then
                        v92 = "Failed to place egg"
                    end

                    Toast.Show({
                        Seconds = 3,
                        Text = v92,
                        Color = v2
                    })
                end
            end)
        end

        local function buildPickerRow(p28, p29, p30) -- line: 564
            -- upvalues: Fill (copy), SliderButton (copy), EggPicker (copy), Eggs (copy), InventoryTemplate (copy), v15 (copy), n1 (ref), scheduleRender (ref), Directory (copy), ButtonFX (copy), EggRecords (copy), Toast (copy), Remotes (copy), v2 (copy), v4 (copy)
            local v93 = EggRecords.Decode(p29)
            local v94 = Directory[v93.AssetCategory]

            assert(v94 ~= nil, (("Missing asset config %*"):format(v93.AssetCategory)))

            local clone = InventoryTemplate:Clone()

            clone.Name = ("SakuraEgg.%*"):format(p28)
            clone.LayoutOrder = p30
            clone.Active = true
            clone.AutoButtonColor = false
            clone.BackgroundColor3 = Color3.new(0, 0, 0)
            clone.BackgroundTransparency = 0.5
            clone.Visible = true

            local UIStroke = clone:FindFirstChild("UIStroke")

            if UIStroke and UIStroke:IsA("UIStroke") then
                UIStroke.Thickness = 0
            end

            local Icon = clone.Icon

            assert(Icon:IsA("ImageLabel"), "Inventory row Icon must be an ImageLabel")
            Icon.Image = v94.Egg.Icon
            Icon.ImageColor3 = Color3.new(1, 1, 1)

            local ToolName = clone.ToolName

            assert(ToolName:IsA("TextLabel"), "Inventory row ToolName must be a TextLabel")

            for _, child in ipairs(ToolName:GetChildren()) do
                if child:IsA("UIGradient") then
                    child:Destroy()
                end
            end

            v94.Rarity.RarityGradient:Clone().Parent = ToolName
            ToolName.Text = EggRecords.DisplayNameWithWeight(v93)
            ToolName.Visible = true

            for _, v97 in ipairs({ "FavIcon", "Weight", "Shadow", "Shadow_2" }) do
                local v98 = clone:FindFirstChild(v97)

                if v98 and v98:IsA("GuiObject") then
                    v98.Visible = false
                end
            end

            local BaseTemplate = clone:FindFirstChild("BaseTemplate")

            if BaseTemplate then
                for _, child in ipairs(BaseTemplate:GetChildren()) do
                    if child:IsA("GuiObject") then
                        child.Visible = false
                    end
                end
            end

            clone.Parent = Eggs
            v15:Add(clone)
            v15:Add(clone.Activated:Connect(function() -- line: 615
                -- upvalues: p28 (copy), Fill (copy), SliderButton (copy), EggPicker (copy), v15 (copy), n1 (ref), scheduleRender (ref), Toast (copy), Remotes (copy), v2 (copy), v4 (copy)
                v4(function() -- line: 552
                    -- upvalues: p28 (copy), Fill (copy), SliderButton (copy), EggPicker (copy), v15 (copy), n1 (ref), scheduleRender (ref), Toast (copy), Remotes (copy), v2 (copy)
                    local v99, v100 = Remotes.Bloomery.AskLoadEgg:InvokeServer(p28)

                    if v99 then
                        v15:Clean()
                        EggPicker.Visible = false
                        n1 = 1
                        Fill.Size = UDim2.fromScale(n1, 1)
                        SliderButton.Position = UDim2.fromScale(n1, SliderButton.Position.Y.Scale)
                        scheduleRender()
                    else
                        if typeof(v100) ~= "string" then
                            v100 = "Failed to place egg"
                        end

                        Toast.Show({
                            Seconds = 3,
                            Text = v100,
                            Color = v2
                        })
                    end
                end)
            end))
            ButtonFX(clone)
        end

        local function openPicker() -- line: 619
            -- upvalues: EggPicker (copy), Eggs (copy), v15 (copy), buildPickerRow (copy), Directory (copy), Toast (copy), Sakura (copy), Save (copy), v2 (copy)
            local v101 = Save.Await()
            local v102 = Save.Await()
            local Sakura2

            if v102 ~= nil then
                Sakura2 = v102.Sakura

                local _ = v102.SakuraCrystals
            end

            if v101 ~= nil and Sakura2 ~= nil then
                if Sakura2.Unlocked then
                    if Sakura2.Egg == false then
                        v15:Clean()

                        local t5 = {}

                        for v103, v104 in pairs(v101.EggInventory) do
                            if v104.Placement == nil and not Sakura.HasSakuraMutation(v104.Mutations) then
                                table.insert(t5, v103)
                            end
                        end

                        if #t5 == 0 then
                            local n2 = 0

                            for _, v105 in pairs(v101.EggInventory) do
                                if v105.Placement ~= nil then
                                    n2 += 1
                                end
                            end

                            if n2 > 0 then
                                Toast.Show({
                                    Text = "All your eggs are placed - pick one up from your pen first!",
                                    Seconds = 3,
                                    Color = v2
                                })
                            else
                                Toast.Show({
                                    Text = "You have no eggs to mutate - steal or hatch one first!",
                                    Seconds = 3,
                                    Color = v2
                                })
                            end
                        else
                            table.sort(t5, function(p31, p32) -- line: 654
                                -- upvalues: v101 (copy), Directory (copy)
                                local AssetCategory = v101.EggInventory[p31].AssetCategory
                                local v106 = Directory[AssetCategory]

                                assert(v106 ~= nil, (("Missing asset config %*"):format(AssetCategory)))

                                local Rank = v106.Rarity.Rank
                                local AssetCategory2 = v101.EggInventory[p32].AssetCategory
                                local v109 = Directory[AssetCategory2]

                                assert(v109 ~= nil, (("Missing asset config %*"):format(AssetCategory2)))

                                local Rank2 = v109.Rarity.Rank

                                if Rank == Rank2 then
                                    return p31 < p32
                                end

                                return Rank2 < Rank
                            end)

                            for v112, v113 in ipairs(t5) do
                                buildPickerRow(v113, v101.EggInventory[v113], v112)
                            end

                            Eggs.CanvasPosition = Vector2.zero
                            EggPicker.Visible = true
                        end
                    end
                else
                    Toast.Show({
                        Text = "The Sakura Incubator is still sealed",
                        Seconds = 3,
                        Color = v2
                    })
                end
            end
        end

        local function playDepositFlyIn() -- line: 669
            -- upvalues: Content (copy), EggIconHolder (copy), Deposit (copy), TweenService (copy)
            for i = 1, 6 do
                task.delay((i - 1) * 0.05, function() -- line: 672
                    -- upvalues: Content (copy), EggIconHolder (copy), Deposit (copy), TweenService (copy)
                    local ImageLabel = Instance.new("ImageLabel")

                    ImageLabel.BackgroundTransparency = 1
                    ImageLabel.Image = "rbxassetid://71612969542341"
                    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                    ImageLabel.Size = UDim2.fromScale(0.05, 0.08)
                    ImageLabel.Position = UDim2.fromScale(Deposit.Position.X.Scale + (math.random() - 0.5) * 0.1, Deposit.Position.Y.Scale)
                    ImageLabel.ZIndex = 20
                    ImageLabel.Parent = Content

                    local tween = TweenService:Create(ImageLabel, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        Position = UDim2.fromScale(EggIconHolder.Position.X.Scale, EggIconHolder.Position.Y.Scale),
                        Size = UDim2.fromScale(0.02, 0.03)
                    })

                    tween.Completed:Once(function() -- line: 692
                        -- upvalues: ImageLabel (copy)
                        ImageLabel:Destroy()
                    end)
                    tween:Play()
                end)
            end

            task.wait(0.75)
        end

        local function requestDeposit() -- line: 699
            -- upvalues: n1 (ref), scheduleRender (ref), openPicker (copy), playDepositFlyIn (copy), Toast (copy), Remotes (copy), Sakura (copy), Save (copy), v2 (copy), v4 (copy)
            local v114 = Save.Await()
            local Sakura2

            if v114 ~= nil then
                Sakura2 = v114.Sakura

                local _ = v114.SakuraCrystals
            end

            if Sakura2 == nil or Sakura2.Egg ~= false then
                v4(function() -- line: 705
                    -- upvalues: n1 (ref), scheduleRender (ref), playDepositFlyIn (copy), Toast (copy), Remotes (copy), Sakura (copy), Save (copy), v2 (copy)
                    local v115 = Save.Await()
                    local Sakura2, v116

                    if v115 ~= nil then
                        Sakura2 = v115.Sakura
                        v116 = v115.SakuraCrystals
                    else
                        v116 = 0
                    end

                    if Sakura2 == nil or Sakura2.Egg == false then
                        return
                    end

                    local v117 = if Sakura2.Egg == false then 0 else Sakura.GetRequiredCrystals()
                    local v118 = if v117 <= 0 then 0 else math.max(0, (math.min(v116, Sakura.GetFreeChargeCap(v117) - Sakura2.Deposited)))
                    local v121 = if v118 <= 0 then 0 else math.max(1, (math.floor(v118 * n1 + 0.5)))

                    if v121 <= 0 then
                        Toast.Show({
                            Text = "You have no Sakura Crystals to deposit",
                            Seconds = 3,
                            Color = v2
                        })
                    else
                        playDepositFlyIn()

                        local v124, v125 = Remotes.Bloomery.AskHandoff:InvokeServer(v121)

                        if v124 then
                            scheduleRender()
                        else
                            local v126 = if typeof(v125) == "string" then v125 else "Failed to deposit"

                            Toast.Show({
                                Seconds = 3,
                                Text = v126,
                                Color = v2
                            })
                        end
                    end
                end)
            else
                openPicker()
            end
        end

        local function requestRemove() -- line: 725
            -- upvalues: scheduleRender (ref), Message (copy), Toast (copy), Remotes (copy), Save (copy), v2 (copy), v4 (copy)
            local v127 = Save.Await()
            local Sakura

            if v127 ~= nil then
                Sakura = v127.Sakura

                local _ = v127.SakuraCrystals
            end

            if Sakura ~= nil and Sakura.Egg ~= false then
                if (Sakura.Deposited > 0 or Sakura.LuckBoost > 0) and not Message.Confirm("Remove this egg? Its charge and luck will be lost.") then
                    return
                end

                v4(function() -- line: 735
                    -- upvalues: scheduleRender (ref), Toast (copy), Remotes (copy), v2 (copy)
                    local v128, v129 = Remotes.Bloomery.AskEjectEgg:InvokeServer()

                    if v128 then
                        scheduleRender()
                    else
                        if typeof(v129) ~= "string" then
                            v129 = "Failed to remove egg"
                        end

                        Toast.Show({
                            Seconds = 3,
                            Text = v129,
                            Color = v2
                        })
                    end
                end)
            end
        end

        local function requestMutate() -- line: 745
            -- upvalues: scheduleRender (ref), Toast (copy), Remotes (copy), SakuraSignals (copy), Sakura2 (copy), v2 (copy), v3 (copy), v4 (copy)
            v4(function() -- line: 746
                -- upvalues: scheduleRender (ref), Toast (copy), Remotes (copy), SakuraSignals (copy), Sakura2 (copy), v2 (copy), v3 (copy)
                local v130, v131, v132 = Remotes.Bloomery.AskMutate:InvokeServer()

                if v130 then
                    if Sakura2.MutateResult(v132) then
                        SakuraSignals.Reveal:Fire(v132)
                        scheduleRender()
                    else
                        v3:AtError():Log("Sakura mutate returned an invalid result")
                    end
                else
                    if typeof(v131) ~= "string" then
                        v131 = "Failed to mutate"
                    end

                    Toast.Show({
                        Seconds = 3,
                        Text = v131,
                        Color = v2
                    })
                end
            end)
        end

        local function requestLuck() -- line: 761
            -- upvalues: Products (copy), Storefront (copy), Sakura (copy), Save (copy)
            local v133 = Save.Await()
            local v134 = v133 and Sakura.Incubator.LuckBoostProductNames[v133.Sakura.LuckBoost + 1]

            if v134 then
                Storefront.Prompt(Products.Directory[v134].ProductId, true)
            end
        end

        local function updateSliderFromInput(p33) -- line: 771
            -- upvalues: SliderBar (copy), Fill (copy), SliderButton (copy), n1 (ref), render (copy)
            local X = SliderBar.AbsolutePosition.X
            local X2 = SliderBar.AbsoluteSize.X

            if X2 <= 0 then
                return
            end

            n1 = math.clamp((p33.X - X) / X2, 0, 1)
            Fill.Size = UDim2.fromScale(n1, 1)
            SliderButton.Position = UDim2.fromScale(n1, SliderButton.Position.Y.Scale)
            render()
        end

        EggPicker.Visible = false
        n1 = 1
        Fill.Size = UDim2.fromScale(n1, 1)
        SliderButton.Position = UDim2.fromScale(n1, SliderButton.Position.Y.Scale)
        GUI.OnActivated(Deposit, requestDeposit)
        ButtonFX(Deposit)
        GUI.OnActivated(Mutate, requestMutate)
        ButtonFX(Mutate)

        if v6 then
            v6.Visible = false
            GUI.OnActivated(v6, requestRemove)
            ButtonFX(v6)
        end

        GUI.OnActivated(BuyLuck, requestLuck)
        ButtonFX(BuyLuck)
        Icon.Active = true
        Icon.InputBegan:Connect(function(p34) -- line: 800
            -- upvalues: openPicker (copy)
            if p34.UserInputType == Enum.UserInputType.MouseButton1 or p34.UserInputType == Enum.UserInputType.Touch then
                openPicker()
            end
        end)
        SliderButton.InputBegan:Connect(function(p35) -- line: 809
            -- upvalues: v16 (ref)
            if p35.UserInputType == Enum.UserInputType.MouseButton1 or p35.UserInputType == Enum.UserInputType.Touch then
                v16 = true
            end
        end)
        SliderBar.InputBegan:Connect(function(p36) -- line: 817
            -- upvalues: SliderBar (copy), Fill (copy), SliderButton (copy), n1 (ref), v16 (ref), render (copy)
            if p36.UserInputType ~= Enum.UserInputType.MouseButton1 and p36.UserInputType ~= Enum.UserInputType.Touch then
                return
            end

            v16 = true

            local v136 = Vector2.new(p36.Position.X, p36.Position.Y)
            local X = SliderBar.AbsolutePosition.X
            local X2 = SliderBar.AbsoluteSize.X

            if X2 <= 0 then
                return
            end

            n1 = math.clamp((v136.X - X) / X2, 0, 1)
            Fill.Size = UDim2.fromScale(n1, 1)
            SliderButton.Position = UDim2.fromScale(n1, SliderButton.Position.Y.Scale)
            render()
        end)
        UserInputService.InputChanged:Connect(function(p37) -- line: 826
            -- upvalues: SliderBar (copy), Fill (copy), SliderButton (copy), n1 (ref), v16 (ref), render (copy)
            if v16 and (p37.UserInputType == Enum.UserInputType.MouseMovement or p37.UserInputType == Enum.UserInputType.Touch) then
                local v138 = Vector2.new(p37.Position.X, p37.Position.Y)
                local X = SliderBar.AbsolutePosition.X
                local X2 = SliderBar.AbsoluteSize.X

                if X2 <= 0 then
                    return
                end

                n1 = math.clamp((v138.X - X) / X2, 0, 1)
                Fill.Size = UDim2.fromScale(n1, 1)
                SliderButton.Position = UDim2.fromScale(n1, SliderButton.Position.Y.Scale)
                render()
            end
        end)
        UserInputService.InputEnded:Connect(function(p38) -- line: 837
            -- upvalues: v16 (ref)
            if p38.UserInputType == Enum.UserInputType.MouseButton1 or p38.UserInputType == Enum.UserInputType.Touch then
                v16 = false
            end
        end)
        Save.WatchFields({ "Sakura", "SakuraCrystals", "EggInventory" }, function() -- line: 846
            -- upvalues: scheduleRender (ref), SakuraBloomPolicy (copy), Save (copy), Tabs (copy)
            if not Tabs.IsActive("SakuraEggCharge") then
                return
            end

            local v140 = Save.IsLoaded()
            local v141 = if v140 then Save.Peek() else nil

            if SakuraBloomPolicy.HasBloomUnlocked(v140, v141) then
                scheduleRender()
            else
                Tabs.Deactivate({
                    instant = true
                })
            end
        end)

        local function bindGamepadSlider() -- line: 855
            -- upvalues: Fill (copy), SliderButton (copy), n1 (ref), render (copy), ContextActionService (copy)
            ContextActionService:BindActionAtPriority("SakuraDepositSlider", function(_, p40, p41) -- line: 858
                -- upvalues: Fill (copy), SliderButton (copy), n1 (ref), render (copy)
                if p40 ~= Enum.UserInputState.Begin then
                    return Enum.ContextActionResult.Pass
                end

                local v142 = if p41.KeyCode == Enum.KeyCode.ButtonR1 then 0.1 else -0.1

                n1 = math.clamp(n1 + v142, 0, 1)
                Fill.Size = UDim2.fromScale(n1, 1)
                SliderButton.Position = UDim2.fromScale(n1, SliderButton.Position.Y.Scale)
                render()

                return Enum.ContextActionResult.Sink
            end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
        end

        local function unbindGamepadSlider() -- line: 876
            -- upvalues: ContextActionService (copy)
            ContextActionService:UnbindAction("SakuraDepositSlider")
        end

        if v7 then
            GUI.OnActivated(v7, function() -- line: 879
                -- upvalues: SakuraBloomPolicy (copy), SakuraSignals (copy), Save (copy), Tabs (copy)
                local v144 = Save.IsLoaded()
                local v145 = if v144 then Save.Peek() else nil

                if SakuraBloomPolicy.HasBloomUnlocked(v144, v145) then
                    Tabs.Deactivate({
                        instant = true
                    })
                    SakuraSignals.ShowTutorial:Fire()
                end
            end)
            ButtonFX(v7)
        end

        Tabs.Activated:Connect(function(p42) -- line: 889
            -- upvalues: Fill (copy), SliderButton (copy), n1 (ref), v18 (ref), scheduleRender (ref), render (copy), ContextActionService (copy), Players (copy), ButtonHintStrip (copy), PlatformController (copy), SakuraBloomPolicy (copy), SakuraSignals (copy), Save (copy), Tabs (copy)
            if p42 ~= "SakuraEggCharge" then
                return
            end

            local v146 = Save.IsLoaded()
            local v147 = if v146 then Save.Peek() else nil

            if not SakuraBloomPolicy.HasBloomUnlocked(v146, v147) then
                Tabs.Deactivate({
                    instant = true
                })
            else
                local v148 = Save.Await()

                if not Players.LocalPlayer:GetAttribute("SakuraTutorialSkip") and v148 ~= nil and not v148.Sakura.TutorialSeen then
                    Tabs.Deactivate({
                        instant = true
                    })
                    SakuraSignals.ShowTutorial:Fire()
                else
                    n1 = 1
                    Fill.Size = UDim2.fromScale(n1, 1)
                    SliderButton.Position = UDim2.fromScale(n1, SliderButton.Position.Y.Scale)
                    v18 = true
                    scheduleRender()
                    ContextActionService:BindActionAtPriority("SakuraDepositSlider", function(_, p44, p45) -- line: 858
                        -- upvalues: Fill (copy), SliderButton (copy), n1 (ref), render (copy)
                        if p44 ~= Enum.UserInputState.Begin then
                            return Enum.ContextActionResult.Pass
                        end

                        local v149 = if p45.KeyCode == Enum.KeyCode.ButtonR1 then 0.1 else -0.1

                        n1 = math.clamp(n1 + v149, 0, 1)
                        Fill.Size = UDim2.fromScale(n1, 1)
                        SliderButton.Position = UDim2.fromScale(n1, SliderButton.Position.Y.Scale)
                        render()

                        return Enum.ContextActionResult.Sink
                    end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)

                    if PlatformController.IsConsole() then
                        ButtonHintStrip.Present("SakuraDepositSlider", Enum.KeyCode.ButtonR1, "Deposit Amount")
                    end
                end
            end
        end)
        Tabs.Deactivated:Connect(function(p46) -- line: 916
            -- upvalues: EggPicker (copy), v15 (copy), ContextActionService (copy), ButtonHintStrip (copy)
            if p46 ~= "SakuraEggCharge" then
                return
            end

            v15:Clean()
            EggPicker.Visible = false
            ContextActionService:UnbindAction("SakuraDepositSlider")
            ButtonHintStrip.Retract("SakuraDepositSlider")
        end)
        render()
    end
}
