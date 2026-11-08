-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local PolicyService = game:GetService("PolicyService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

game:GetService("Workspace")

local t = require(ReplicatedStorage.Packages.t)
local Assets = require(ReplicatedStorage.Data.Assets)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local GUI = require(ReplicatedStorage.Client.GUI)
local Gifting = require(ReplicatedStorage.Client.Gifting)
local Price = require(ReplicatedStorage.Shared.Utils.Marketplace).Price
local HoverCard = require(ReplicatedStorage.Client.HoverCard)
local LimitedEgg = require(ReplicatedStorage.Data.LimitedEgg)
local ShopPreview = require(ReplicatedStorage.Client.ShopPreview)

require(ReplicatedStorage.Data.LimitedEgg.Types.Interface)

local Log = require(ReplicatedStorage.Packages.Log)
local Products = require(ReplicatedStorage.Data.Products)
local Storefront = require(ReplicatedStorage.Client.Functions.Storefront)
local SwapGradient = require(ReplicatedStorage.Shared.Utils.SwapGradient)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Timer = require(ReplicatedStorage.Packages.Timer)
local Trove = require(ReplicatedStorage.Packages.Trove)
local TryCall = require(ReplicatedStorage.Shared.Utils.TryCall)
local TryLock = require(ReplicatedStorage.Shared.Utils.TryLock)

return {
    Start = function() -- Start | line: 84
        -- upvalues: Players (copy), PolicyService (copy), TweenService (copy), t (copy), Assets (copy), ButtonFX (copy), GUI (copy), Gifting (copy), Price (copy), HoverCard (copy), LimitedEgg (copy), ShopPreview (copy), Log (copy), Products (copy), Storefront (copy), SwapGradient (copy), Tabs (copy), Timer (copy), Trove (copy), TryCall (copy), TryLock (copy)
        local v1 = Log.new()
        local v2 = TryLock()
        local v3 = nil
        local LocalPlayer = Players.LocalPlayer
        local ScrollingFrame = GUI.Shop().Frame.ScrollingFrame
        local v4 = true

        local function requireChild(p1, p2, p3, p4) -- line: 100
            local v5 = p1:FindFirstChild(p2)

            assert(v5 ~= nil, (("Shop is missing %*"):format(p4)))
            assert(v5:IsA(p3), (("Shop %* must be a %*"):format(p4, p3)))

            return v5
        end

        local function bindSlot(p5, p6, p7) -- line: 112
            local v10 = ("%*.Spacer.Frame.%*"):format(p5, p7)
            local v11 = p6:FindFirstChild((tostring(p7)))

            assert(v11 ~= nil, (("Shop is missing %*"):format(v10)))
            assert(v11:IsA("GuiObject"), (("Shop %* must be a GuiObject"):format(v10)))

            local Glow = v11:FindFirstChild("Glow")
            local t2 = {
                Frame = v11
            }
            local v15 = ("%*.Icon"):format(v10)
            local Icon = v11:FindFirstChild("Icon")

            assert(Icon ~= nil, (("Shop is missing %*"):format(v15)))
            assert(Icon:IsA("ImageLabel"), (("Shop %* must be a ImageLabel"):format(v15)))
            t2.Icon = Icon

            local v19 = ("%*.Amount"):format(v10)
            local Amount = v11:FindFirstChild("Amount")

            assert(Amount ~= nil, (("Shop is missing %*"):format(v19)))
            assert(Amount:IsA("TextLabel"), (("Shop %* must be a TextLabel"):format(v19)))
            t2.Amount = Amount
            t2.Glow = if Glow == nil or not Glow:IsA("ImageLabel") then nil else Glow

            return t2
        end

        local function bindOfferUi(p8, p9, p10) -- line: 125
            local v23 = ("Buy%*"):format(p10)
            local v24 = ("%*.Spacer.Btns.%*"):format(p8, v23)
            local v25 = p9:FindFirstChild(v23)

            assert(v25 ~= nil, (("Shop is missing %*"):format(v24)))
            assert(v25:IsA("GuiButton"), (("Shop %* must be a GuiButton"):format(v24)))

            local Amount = v25:FindFirstChild("Amount")
            local t3 = {
                Button = v25
            }
            local v29 = ("Gift%*"):format(p10)
            local v30 = ("%*.Spacer.Btns.Gift%*"):format(p8, p10)
            local v31 = p9:FindFirstChild(v29)

            assert(v31 ~= nil, (("Shop is missing %*"):format(v30)))
            assert(v31:IsA("GuiButton"), (("Shop %* must be a GuiButton"):format(v30)))
            t3.Gift = v31

            local v35 = ("%*.Price"):format(v24)
            local Price = v25:FindFirstChild("Price")

            assert(Price ~= nil, (("Shop is missing %*"):format(v35)))
            assert(Price:IsA("TextLabel"), (("Shop %* must be a TextLabel"):format(v35)))
            t3.Price = Price
            t3.Amount = if Amount == nil or not Amount:IsA("TextLabel") then nil else Amount

            return t3
        end

        local function formatCountdown(p11) -- line: 145
            local v40 = math.max(0, (math.ceil(p11)))
            local v41 = v40 // 86400
            local v42 = v40 % 86400 // 3600
            local v43 = v40 % 3600 // 60
            local v44 = v40 % 60

            if v41 > 0 then
                return string.format("%dd %02dh %02dm %02ds", v41, v42, v43, v44)
            end

            if v42 > 0 then
                return string.format("%02dh %02dm %02ds", v42, v43, v44)
            end

            if v43 > 0 then
                return string.format("%02dm %02ds", v43, v44)
            end

            return string.format("%02ds", v44)
        end

        local function formatChance(p12) -- line: 170
            local v45 = if p12 > 0 and p12 < 10 then math.clamp(math.ceil(-math.log10(p12)) + 1, 0, 4) else 0
            local v48 = string.format(("%%.%*f"):format(v45), p12)

            if v45 > 0 then
                v48 = v48:gsub("0+$", ""):gsub("%.$", "")
            end

            return (("%*%%"):format(v48))
        end

        local function formatEggAmount(p13) -- line: 188
            if p13 == 1 then
                return "1 Egg"
            end

            return (("%* Eggs"):format(p13))
        end

        local function mechaLabelFor(p14) -- line: 197
            local v49 = p14.Frame:FindFirstChild("MechanicalVersion") or p14.Frame:FindFirstChild("Icon2")

            return if v49 ~= nil and v49:IsA("ImageLabel") then v49 else nil
        end

        local function bindPanel(p15, p16) -- line: 206
            -- upvalues: ScrollingFrame (copy), bindSlot (copy), bindOfferUi (copy)
            local v50 = ScrollingFrame:FindFirstChild(p15)

            assert(v50 ~= nil, (("Shop is missing %*"):format(p15)))
            assert(v50:IsA("GuiObject"), (("Shop %* must be a GuiObject"):format(p15)))

            local v54 = ("%*.Spacer"):format(p15)
            local Spacer = v50:FindFirstChild("Spacer")

            assert(Spacer ~= nil, (("Shop is missing %*"):format(v54)))
            assert(Spacer:IsA("GuiObject"), (("Shop %* must be a GuiObject"):format(v54)))

            local v58 = ("%*.Spacer.bg"):format(p15)
            local bg = Spacer:FindFirstChild("bg")

            assert(bg ~= nil, (("Shop is missing %*"):format(v58)))
            assert(bg:IsA("ImageLabel"), (("Shop %* must be a ImageLabel"):format(v58)))

            local v62 = ("%*.Spacer.Frame"):format(p15)
            local Frame = Spacer:FindFirstChild("Frame")

            assert(Frame ~= nil, (("Shop is missing %*"):format(v62)))
            assert(Frame:IsA("GuiObject"), (("Shop %* must be a GuiObject"):format(v62)))

            local v66 = ("%*.Spacer.Btns"):format(p15)
            local Btns = Spacer:FindFirstChild("Btns")

            assert(Btns ~= nil, (("Shop is missing %*"):format(v66)))
            assert(Btns:IsA("GuiObject"), (("Shop %* must be a GuiObject"):format(v66)))

            local t4 = {}

            for i = 1, #p16.Entries do
                table.insert(t4, (bindSlot(p15, Frame, i)))
            end

            local v71 = #p16.Entries + 1
            local v72 = Frame:FindFirstChild((tostring(v71)))
            local Icon2 = if v72 == nil then nil else v72:FindFirstChild("Icon2")
            local v73

            if v72 ~= nil then
                if not v72:IsA("GuiObject") or Icon2 == nil then
                    Icon2 = nil
                elseif Icon2:IsA("ImageLabel") then
                    v73 = bindSlot(p15, Frame, v71)
                else
                    Icon2 = nil
                end
            else
                Icon2 = nil
            end

            local t5 = {}

            for i = 1, #p16.Offers do
                table.insert(t5, (bindOfferUi(p15, Btns, i)))
            end

            local t6 = {
                Frame = v50,
                Config = p16
            }
            local v75 = ("%*.Spacer.Title"):format(p15)
            local Title = Spacer:FindFirstChild("Title")

            assert(Title ~= nil, (("Shop is missing %*"):format(v75)))
            assert(Title:IsA("TextLabel"), (("Shop %* must be a TextLabel"):format(v75)))
            t6.EndingTimer = Title

            local v79 = ("%*.Spacer.bg.Icon"):format(p15)
            local Icon = bg:FindFirstChild("Icon")

            assert(Icon ~= nil, (("Shop is missing %*"):format(v79)))
            assert(Icon:IsA("ImageLabel"), (("Shop %* must be a ImageLabel"):format(v79)))
            t6.RegularIcon = Icon

            local v83 = ("%*.Spacer.bg.MechanicalVersion"):format(p15)
            local MechanicalVersion = bg:FindFirstChild("MechanicalVersion")

            assert(MechanicalVersion ~= nil, (("Shop is missing %*"):format(v83)))
            assert(MechanicalVersion:IsA("ImageLabel"), (("Shop %* must be a ImageLabel"):format(v83)))
            t6.MechanicalIcon = MechanicalVersion

            local v87 = ("%*.Spacer.Infos"):format(p15)
            local Infos = Spacer:FindFirstChild("Infos")

            assert(Infos ~= nil, (("Shop is missing %*"):format(v87)))
            assert(Infos:IsA("GuiButton"), (("Shop %* must be a GuiButton"):format(v87)))
            t6.InfoButton = Infos
            t6.Slots = t4
            t6.MechaRerollSlot = v73
            t6.MechaRerollIncoming = Icon2
            t6.OfferUis = t5

            return t6
        end

        local t7 = {
            Luminous = bindPanel("OldLimitedEgg", LimitedEgg.Luminous),
            Extinction = bindPanel("LimitedEgg", LimitedEgg.Extinction),
            Halloween = bindPanel("HalloweenLimitedEgg", LimitedEgg.Halloween)
        }

        local function activePanel() -- line: 273
            -- upvalues: t7 (copy), ShopPreview (copy)
            local v91 = ShopPreview.Config()

            for _, v92 in t7 do
                if v92.Config == v91 then
                    return v92
                end
            end

            return nil
        end

        local function applyVisibility() -- line: 279
            -- upvalues: v4 (ref), t7 (copy), ShopPreview (copy)
            local v93 = ShopPreview.Config()
            local v94 = false
            local v95

            for _, v96 in t7 do
                if v96.Config == v93 then
                    v95 = v96
                    v94 = true
                    break
                end
            end

            if not v94 then
                v95 = nil
            end

            for _, v97 in t7 do
                local Frame = v97.Frame

                if v97 == v95 then
                    Frame.Visible = not v4
                else
                    Frame.Visible = false
                end
            end
        end

        local function bindIconAlternator(p17, p18) -- line: 290
            -- upvalues: TweenService (copy)
            local v98 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

            local function fadeTo(p19, p20) -- line: 296
                -- upvalues: p17 (copy), v98 (copy), TweenService (copy)
                return p17:Add(TweenService:Create(p19, v98, {
                    ImageTransparency = p20
                }))
            end

            local t8 = {}

            local function addSwap(p21, p22) -- line: 308
                -- upvalues: p17 (copy), v98 (copy), t8 (copy), TweenService (copy)
                p21.ImageTransparency = 0
                p22.ImageTransparency = 1
                table.insert(t8, {
                    RegularIn = p17:Add(TweenService:Create(p21, v98, {
                        ImageTransparency = 0
                    })),
                    RegularOut = p17:Add(TweenService:Create(p21, v98, {
                        ImageTransparency = 1
                    })),
                    MechaIn = p17:Add(TweenService:Create(p22, v98, {
                        ImageTransparency = 0
                    })),
                    MechaOut = p17:Add(TweenService:Create(p22, v98, {
                        ImageTransparency = 1
                    }))
                })
            end

            for _, v99 in ipairs(p18.Slots) do
                local v100 = v99.Frame:FindFirstChild("MechanicalVersion") or v99.Frame:FindFirstChild("Icon2")

                if v100 ~= nil and not v100:IsA("ImageLabel") then
                    v100 = nil
                end

                if v100 ~= nil then
                    addSwap(v99.Icon, v100)
                end
            end

            p17:Add(task.spawn(function() -- line: 327
                -- upvalues: t8 (copy)
                while true do
                    task.wait(1)

                    for _, v101 in t8 do
                        v101.RegularOut:Play()
                        v101.MechaIn:Play()
                    end

                    task.wait(4)

                    for _, v102 in t8 do
                        v102.MechaOut:Play()
                        v102.RegularIn:Play()
                    end

                    task.wait(1)
                end
            end))
        end

        local function bindEndingTimer(p23, p24, p25) -- line: 344
            -- upvalues: formatCountdown (copy), ShopPreview (copy), Timer (copy)
            local function update() -- line: 345
                -- upvalues: p24 (copy), p25 (copy), formatCountdown (copy), ShopPreview (copy)
                local v103 = p25 - ShopPreview.Time()

                if v103 <= 0 then
                    p24.EndingTimer.Text = "Leaving Soon"
                else
                    p24.EndingTimer.Text = formatCountdown(v103)
                end
            end

            local v104 = p25 - ShopPreview.Time()

            if v104 <= 0 then
                p24.EndingTimer.Text = "Leaving Soon"
            else
                p24.EndingTimer.Text = formatCountdown(v104)
            end

            p23:Add(Timer.Simple(1, update))
        end

        local function bindRarityGlow(p26, p27, p28) -- line: 359
            -- upvalues: SwapGradient (copy)
            local UIGradient = p27:FindFirstChildWhichIsA("UIGradient")
            local clone = if UIGradient == nil then nil else UIGradient:Clone()

            SwapGradient(p27, p28)
            p26:Add(function() -- line: 367
                -- upvalues: p27 (copy), clone (copy), SwapGradient (copy)
                SwapGradient(p27, clone)

                if clone ~= nil then
                    clone:Destroy()
                end
            end)
        end

        local function bindSlots(p29, p30) -- line: 375
            -- upvalues: v1 (copy), formatChance (copy), bindRarityGlow (copy), Assets (copy)
            local Config = p30.Config
            local n1 = 0

            for _, v105 in ipairs(Config.Entries) do
                assert(v105.Weight > 0, "Limited egg drop weights must be positive")
                n1 += v105.Weight
            end

            local v107 = 1 - (if Config.MechaReroll == nil then 0 else Config.MechaReroll.DisplayChance)

            for v108, v109 in ipairs(Config.Entries) do
                local v110 = p30.Slots[v108]
                local v111 = Assets.Directory[v109.AssetId]

                assert(v111 ~= nil, (("Limited egg drop entry \"%*\" is not in the asset directory"):format(v109.AssetId)))

                local Image = v110.Icon.Image

                v110.Icon.Image = v111.Icon or Image
                p29:Add(function() -- line: 398
                    -- upvalues: v110 (copy), Image (copy)
                    v110.Icon.Image = Image
                end)

                local v114 = Config.MechaReroll and Config.MechaReroll.Entries
                local v115 = v114 and v114[v108]
                local v116 = v115 and Assets.Directory[v115.AssetId]
                local v117 = v110.Frame:FindFirstChild("MechanicalVersion") or v110.Frame:FindFirstChild("Icon2")

                if v117 ~= nil and not v117:IsA("ImageLabel") then
                    v117 = nil
                end

                if v117 ~= nil and v116 ~= nil then
                    local Image = v117.Image

                    v117.Image = v116.Icon or Image

                    local v118 = v117

                    p29:Add(function() -- line: 410
                        -- upvalues: Image (copy), v118 (copy)
                        v118.Image = Image
                    end)
                end

                v110.Amount.Text = formatChance(v107 * (v109.Weight / n1) * 100)

                local Glow = v110.Glow

                if Glow ~= nil then
                    bindRarityGlow(p29, Glow, v111.Rarity.RarityGradient)
                end
            end

            v1:AtTrace():Log("Limited egg slot session opened")
        end

        local function bindMechaRerollSlot(p31, p32) -- line: 427
            -- upvalues: v1 (copy), formatChance (copy), TweenService (copy), Assets (copy)
            local MechaRerollSlot, MechaRerollIncoming = p32.MechaRerollSlot, p32.MechaRerollIncoming
            local MechaReroll = p32.Config.MechaReroll

            if MechaRerollSlot == nil or MechaRerollIncoming == nil or MechaReroll == nil then
                return
            end

            local t10 = {}

            for _, v119 in ipairs(MechaReroll.Entries) do
                local v120 = Assets.Directory[v119.AssetId]

                assert(v120 ~= nil, (("Limited egg mecha entry \"%*\" is not in the asset directory"):format(v119.AssetId)))
                table.insert(t10, v120.Icon)
            end

            if #t10 == 0 then
                return
            end

            local Icon = MechaRerollSlot.Icon
            local Text = MechaRerollSlot.Amount.Text
            local Image = Icon.Image
            local Image2 = MechaRerollIncoming.Image

            p31:Add(function() -- line: 452
                -- upvalues: MechaRerollSlot (copy), MechaRerollIncoming (copy), Icon (copy), Text (copy), Image (copy), Image2 (copy)
                MechaRerollSlot.Amount.Text = Text
                Icon.Image = Image
                Icon.ImageTransparency = 0
                MechaRerollIncoming.Image = Image2
                MechaRerollIncoming.ImageTransparency = 1
            end)
            MechaRerollSlot.Amount.Text = formatChance(MechaReroll.DisplayChance * 100)
            Icon.Image = t10[1]
            Icon.ImageTransparency = 0
            MechaRerollIncoming.ImageTransparency = 1

            local v123 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            local t11 = {
                [Icon] = p31:Add(TweenService:Create(Icon, v123, {
                    ImageTransparency = 0
                })),
                [MechaRerollIncoming] = p31:Add(TweenService:Create(MechaRerollIncoming, v123, {
                    ImageTransparency = 0
                }))
            }
            local t12 = {
                [Icon] = p31:Add(TweenService:Create(Icon, v123, {
                    ImageTransparency = 1
                })),
                [MechaRerollIncoming] = p31:Add(TweenService:Create(MechaRerollIncoming, v123, {
                    ImageTransparency = 1
                }))
            }

            p31:Add(task.spawn(function() -- line: 490
                -- upvalues: MechaRerollIncoming (copy), t10 (copy), Icon (copy), t11 (copy), t12 (copy)
                local v124 = Icon
                local v125 = MechaRerollIncoming
                local n2 = 1

                while true do
                    task.wait(1)
                    n2 = n2 % #t10 + 1
                    v125.Image = t10[n2]
                    t12[v124]:Play()

                    local v126 = t11[v125]

                    v126:Play()
                    v126.Completed:Wait()
                    v124, v125 = v125, v124
                end
            end))
            v1:AtTrace():Log("Limited egg mecha re-roll slot session opened")
        end

        local function bindHoverInfo(p33, p34) -- line: 508
            -- upvalues: v1 (copy), Assets (copy), HoverCard (copy)
            local Config = p34.Config

            for v127, v128 in ipairs(Config.Entries) do
                local v129 = p34.Slots[v127]
                local v130 = Assets.Directory[v128.AssetId]

                p33:Add(HoverCard.Attach(v129.Frame, {
                    {
                        kind = "heading",
                        text = v130.DisplayName
                    },
                    {
                        kind = "tier",
                        rarity = v130.Rarity._id
                    }
                }))
            end

            local MechaRerollSlot = p34.MechaRerollSlot

            if MechaRerollSlot ~= nil then
                p33:Add(HoverCard.Attach(MechaRerollSlot.Frame, {
                    {
                        kind = "heading",
                        text = Config.RerollName
                    }
                }))
            end

            local InfoButton = p34.InfoButton
            local InfoText = Config.InfoText

            if InfoText ~= nil then
                p33:Add(HoverCard.Attach(InfoButton, {
                    {
                        kind = "body",
                        text = InfoText
                    }
                }))
                p33:Add(InfoButton.Activated:Connect(function() -- line: 530
                    -- upvalues: InfoButton (copy), InfoText (copy), HoverCard (copy)
                    HoverCard.Show(InfoButton, {
                        {
                            kind = "body",
                            text = InfoText
                        }
                    })
                end))
            end

            p33:Add(function() -- line: 534
                -- upvalues: HoverCard (copy)
                HoverCard.Dismiss()
            end)
            v1:AtTrace():Log("Limited egg hover info session opened")
        end

        local function applyPaidRandomItemPolicy() -- line: 541
            -- upvalues: LocalPlayer (copy), v4 (ref), t7 (copy), PolicyService (copy), t (copy), ShopPreview (copy), TryCall (copy)
            local v131 = ShopPreview.Config()
            local v132 = false
            local v133

            for _, v134 in t7 do
                if v134.Config == v131 then
                    v133 = v134
                    v132 = true
                    break
                end
            end

            if not v132 then
                v133 = nil
            end

            for _, v135 in t7 do
                local Frame = v135.Frame

                if v135 == v133 then
                    Frame.Visible = not v4
                else
                    Frame.Visible = false
                end
            end

            local v136, v137 = TryCall(function() -- line: 544
                -- upvalues: LocalPlayer (copy), PolicyService (copy)
                return PolicyService:GetPolicyInfoForPlayerAsync(LocalPlayer).ArePaidRandomItemsRestricted
            end)

            if v136 then
                TryCall(function() -- line: 550
                    -- upvalues: v137 (copy), v4 (ref), t7 (copy), t (copy), ShopPreview (copy)
                    t.strict(t.boolean)(v137)
                    v4 = v137

                    local v138 = ShopPreview.Config()
                    local v139 = false
                    local v140

                    for _, v141 in t7 do
                        if v141.Config == v138 then
                            v140 = v141
                            v139 = true
                            break
                        end
                    end

                    if not v139 then
                        v140 = nil
                    end

                    for _, v142 in t7 do
                        local Frame = v142.Frame

                        if v142 == v140 then
                            Frame.Visible = not v4
                        else
                            Frame.Visible = false
                        end
                    end
                end)
            end
        end

        local function bindOffer(p35, p36) -- line: 569
            -- upvalues: v2 (copy), v3 (ref), ButtonFX (copy), Gifting (copy), Price (copy), ShopPreview (copy), Storefront (copy)
            local v143 = ShopPreview.IsActive()

            if not v143 and p36.GiftProductId ~= 0 then
                p35:Add(Gifting.Bind(p36.Ui.Gift, "Product", p36.GiftProductId or p36.ProductId))
            end

            p36.Ui.Gift.Active = not v143 and p36.GiftProductId ~= 0
            p36.Ui.Button.Active = not v143

            local Amount = p36.Ui.Amount

            if Amount ~= nil then
                local Amount2 = p36.Amount

                if Amount2 == 1 then
                    Amount.Text = "1 Egg"
                else
                    Amount.Text = ("%* Eggs"):format(Amount2)
                end
            end

            p35:Add(ButtonFX(p36.Ui.Button, nil, function() -- line: 579
                -- upvalues: p36 (copy), v2 (copy), ShopPreview (copy), Storefront (copy)
                if not ShopPreview.IsActive() then
                    v2(function() -- line: 581
                        -- upvalues: p36 (copy), Storefront (copy)
                        Storefront.Prompt(p36.ProductId, true)
                    end)
                end
            end))
            p35:Add((task.spawn(function() -- line: 586
                -- upvalues: p35 (copy), p36 (copy), v3 (ref), Price (copy)
                local v145 = Price(p36.ProductId, Enum.InfoType.Product)

                if v3 == p35 then
                    if v145 ~= nil then
                        p36.Ui.Price.Text = "" .. tostring(v145)
                    else
                        p36.Ui.Price.Text = "Loading..."
                    end
                end
            end)))
        end

        local function openSession() -- line: 600
            -- upvalues: v1 (copy), v3 (ref), v4 (ref), formatCountdown (copy), t7 (copy), bindIconAlternator (copy), bindSlots (copy), bindMechaRerollSlot (copy), bindHoverInfo (copy), bindOffer (copy), openSession (copy), t (copy), ShopPreview (copy), Products (copy), Timer (copy), Trove (copy), TryCall (copy)
            local v146 = v3

            if v146 ~= nil then
                v3 = nil
                v146:Destroy()
                v1:AtTrace():Log("Limited egg shop session closed")
            end

            local v147 = Trove.new()

            v3 = v147

            local v148 = ShopPreview.Config()
            local v149 = false
            local v150

            for _, v151 in t7 do
                if v151.Config == v148 then
                    v150 = v151
                    v149 = true
                    break
                end
            end

            if not v149 then
                v150 = nil
            end

            local v152 = ShopPreview.Config()
            local v153 = false
            local v154

            for _, v155 in t7 do
                if v155.Config == v152 then
                    v154 = v155
                    v153 = true
                    break
                end
            end

            if not v153 then
                v154 = nil
            end

            for _, v156 in t7 do
                local Frame = v156.Frame

                if v156 == v154 then
                    Frame.Visible = not v4
                else
                    Frame.Visible = false
                end
            end

            if v150 ~= nil then
                local v161 = v150
                local v162, v163 = TryCall(function() -- line: 611
                    -- upvalues: v147 (copy), v161 (copy), formatCountdown (copy), t7 (copy), bindIconAlternator (copy), bindSlots (copy), bindMechaRerollSlot (copy), bindHoverInfo (copy), bindOffer (copy), openSession (copy), t (copy), ShopPreview (copy), Products (copy), Timer (copy)
                    local EndsAt = v161.Config.EndsAt

                    v161.EndingTimer.Visible = EndsAt ~= nil

                    if EndsAt ~= nil then
                        local function update() -- line: 345
                            -- upvalues: EndsAt (copy), v161 (copy), formatCountdown (copy), ShopPreview (copy)
                            local v164 = EndsAt - ShopPreview.Time()

                            if v164 <= 0 then
                                v161.EndingTimer.Text = "Leaving Soon"
                            else
                                v161.EndingTimer.Text = formatCountdown(v164)
                            end
                        end

                        local v165 = EndsAt - ShopPreview.Time()

                        if v165 <= 0 then
                            v161.EndingTimer.Text = "Leaving Soon"
                        else
                            v161.EndingTimer.Text = formatCountdown(v165)
                        end

                        v147:Add(Timer.Simple(1, update))
                    end

                    bindSlots(v147, v161)
                    bindMechaRerollSlot(v147, v161)
                    bindHoverInfo(v147, v161)
                    bindIconAlternator(v147, v161)
                    v147:Add(Timer.Simple(1, function() -- line: 624
                        -- upvalues: v161 (copy), t7 (copy), openSession (copy), ShopPreview (copy)
                        local v166 = ShopPreview.Config()
                        local v167 = false
                        local v168

                        for _, v169 in t7 do
                            if v169.Config == v166 then
                                v168 = v169
                                v167 = true
                                break
                            end
                        end

                        if not v167 then
                            v168 = nil
                        end

                        if v168 ~= v161 then
                            task.defer(openSession)
                        end
                    end))

                    for v170, v171 in ipairs(v161.Config.Offers) do
                        local v172 = Products.Directory[v171.ProductName]
                        local v173 = if v171.GiftProductName then Products.Directory[v171.GiftProductName] else v172

                        if v172 ~= nil then
                            v161.OfferUis[v170].Button.Active = true
                            v161.OfferUis[v170].Gift.Active = true
                            t.strict(t.number)(v172.ProductId)
                            bindOffer(v147, {
                                Ui = v161.OfferUis[v170],
                                Amount = v171.Amount,
                                ProductId = v172.ProductId,
                                GiftProductId = if v173 then v173.ProductId else 0
                            })
                        else
                            local v174 = v161.OfferUis[v170]

                            v174.Price.Text = "Unavailable"
                            v174.Button.Active = false
                            v174.Gift.Active = false
                        end
                    end
                end)

                if not v162 then
                    local v175 = v3

                    if v175 ~= nil then
                        v3 = nil
                        v175:Destroy()
                        v1:AtTrace():Log("Limited egg shop session closed")
                    end

                    error(v163)
                end

                v1:AtTrace():Log("Limited egg shop session opened")
            else
                v147:Add(Timer.Simple(1, function() -- line: 608
                    -- upvalues: t7 (copy), openSession (copy), ShopPreview (copy)
                    local v157 = ShopPreview.Config()
                    local v158 = false
                    local v159

                    for _, v160 in t7 do
                        if v160.Config == v157 then
                            v159 = v160
                            v158 = true
                            break
                        end
                    end

                    if not v158 then
                        v159 = nil
                    end

                    if v159 ~= nil then
                        task.defer(openSession)
                    end
                end))
            end
        end

        ShopPreview.Changed:Connect(function() -- line: 660
            -- upvalues: v4 (ref), t7 (copy), openSession (copy), ShopPreview (copy), Tabs (copy)
            if Tabs.IsActive("Shop") then
                openSession()
            else
                local v176 = ShopPreview.Config()
                local v177 = false
                local v178

                for _, v179 in t7 do
                    if v179.Config == v176 then
                        v178 = v179
                        v177 = true
                        break
                    end
                end

                if not v177 then
                    v178 = nil
                end

                for _, v180 in t7 do
                    local Frame = v180.Frame

                    if v180 == v178 then
                        Frame.Visible = not v4
                    else
                        Frame.Visible = false
                    end
                end
            end
        end)
        task.spawn(applyPaidRandomItemPolicy)
        Tabs.Activated:Connect(function(p37) -- line: 670
            -- upvalues: openSession (copy)
            if p37 == "Shop" then
                openSession()
            end
        end)
        Tabs.Deactivated:Connect(function(p38) -- line: 676
            -- upvalues: v1 (copy), v3 (ref), ShopPreview (copy), Tabs (copy)
            if p38 ~= "Shop" then
                return
            end

            local v181 = v3

            if v181 ~= nil then
                v3 = nil
                v181:Destroy()
                v1:AtTrace():Log("Limited egg shop session closed")
            end

            task.defer(function() -- line: 679
                -- upvalues: ShopPreview (copy), Tabs (copy)
                if not Tabs.IsActive("Shop") and ShopPreview.IsActive() then
                    ShopPreview.Set("off")
                end
            end)
        end)

        if Tabs.Active() == "Shop" then
            openSession()
        end
    end
}
