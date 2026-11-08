-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Areas = require(ReplicatedStorage.Data.Areas)
local Assets = require(ReplicatedStorage.Data.Assets)
local AssetEarnings = require(ReplicatedStorage.Shared.Util.AssetEarnings)
local AssetItems = require(ReplicatedStorage.Shared.Util.AssetItems)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local FuseKernel = require(ReplicatedStorage.Shared.Util.FuseKernel)
local GUI = require(ReplicatedStorage.Client.GUI)
local Hud = require(ReplicatedStorage.Client.Hud)
local HoverCard = require(ReplicatedStorage.Client.HoverCard)
local EnsureUIScale = require(ReplicatedStorage.Shared.Utils.EnsureUIScale)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local Products = require(ReplicatedStorage.Data.Products)
local Storefront = require(ReplicatedStorage.Client.Functions.Storefront)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Rift = require(ReplicatedStorage.Data.Rift)
local RiftRecipes = require(ReplicatedStorage.Shared.Modules.RiftRecipes)
local RiftSequence = require(script.RiftSequence)
local Save = require(ReplicatedStorage.Shared.Save)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t1 = {
    "LeftBar",
    "MiddleBar",
    "RightBar"
}
local v1 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v2 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v3 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v4 = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
local v5 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v6 = Color3.fromRGB(255, 64, 64)
local v7 = Color3.fromRGB(196, 130, 255)
local v8 = Color3.fromRGB(166, 255, 228)
local v9 = Color3.new(0.25, 0.25, 0.3)
local v10 = UDim2.fromScale(0.012, 0.14)
local v11 = UDim2.fromScale(0.1, 0.55)
local v12 = TweenInfo.new(0.7, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, -1, true)
local v13 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local t2 = {
    "Purple",
    "Red",
    "Yellow"
}
local v14 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v15 = utf8.char(57346)
local t3 = {
    Verdant = Color3.fromRGB(126, 217, 130),
    Umbral = Color3.fromRGB(168, 122, 255),
    Radiant = Color3.fromRGB(255, 205, 84)
}

return {
    Start = function() -- Start | line: 80
        -- upvalues: MarketplaceService (copy), TweenService (copy), Areas (copy), Assets (copy), AssetEarnings (copy), AssetItems (copy), ButtonFX (copy), Simple (copy), FuseKernel (copy), GUI (copy), Hud (copy), HoverCard (copy), EnsureUIScale (copy), Toast (copy), Products (copy), Storefront (copy), Remotes (copy), Rift (copy), RiftRecipes (copy), RiftSequence (copy), Save (copy), Tabs (copy), Trove (copy), t1 (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy), v12 (copy), v13 (copy), t2 (copy), v14 (copy), v15 (copy), t3 (copy)
        local v16 = GUI.RiftTradeIn()
        local RiftTradeInMain = v16:WaitForChild("RiftTradeInMain")
        local RiftTradeInInventory = v16:WaitForChild("RiftTradeInInventory")
        local CurrentEggInfoHolder = RiftTradeInMain:WaitForChild("CurrentEggInfoHolder")
        local EggIcon = CurrentEggInfoHolder:WaitForChild("EggIcon")
        local EggName = CurrentEggInfoHolder:WaitForChild("EggName")
        local RotateTimer = CurrentEggInfoHolder:WaitForChild("RotateTimer")
        local ScrollingFrame = CurrentEggInfoHolder:WaitForChild("ScrollingFrame")
        local EggChancesHolder = RiftTradeInMain:WaitForChild("EggChancesHolder")
        local RewardHolder = EggChancesHolder:WaitForChild("RewardHolder")
        local Title = EggChancesHolder:WaitForChild("Title")
        local v17 = EggChancesHolder:FindFirstChild("PityHolder") or RiftTradeInMain:WaitForChild("PityHolder")
        local PityLabel = v17:WaitForChild("PityLabel")
        local ProgressBar = v17:WaitForChild("ProgressBar")
        local SacrificeInputs = RiftTradeInMain:WaitForChild("SacrificeInputs")
        local Sacrifice = RiftTradeInMain:WaitForChild("Sacrifice")
        local Price = Sacrifice:WaitForChild("Price")
        local DesignBars = RiftTradeInMain:WaitForChild("DesignBars")
        local Output = RiftTradeInMain:WaitForChild("SacrificeOutput"):WaitForChild("Output")
        local Fill = Output:WaitForChild("Fill")
        local OutputEgg = Output:WaitForChild("OutputEgg")
        local ScrollingFrame2 = RiftTradeInInventory:WaitForChild("ScrollingFrame")
        local Close = RiftTradeInInventory:WaitForChild("Close")
        local v18 = Trove.new()
        local v19 = Trove.new()

        v18:Add(v19)

        local v20 = Trove.new()

        v18:Add(v20)

        local result
        local t5 = {}
        local v21 = false
        local PriceInRobux, v22
        local v23 = nil
        local v24

        for _, child in ScrollingFrame2:GetChildren() do
            if child.Name == "Pet" and child:IsA("ImageButton") then
                if v24 then
                    child:Destroy()
                else
                    v24 = child
                end
            end
        end

        assert(v24, "RiftTradeInInventory has no Pet template")

        local v25 = v24

        v24.Visible = false
        v24.BackgroundTransparency = 1
        v24 = v24:FindFirstChild("PetDecal")

        if v24 and v24:IsA("ImageLabel") then
            v24.BackgroundTransparency = 1
            v24.ScaleType = Enum.ScaleType.Fit
        end

        local t6 = {}
        local t7 = {}
        local t8 = {}
        local t9 = {}

        for v26, v27 in t1 do
            local v28 = DesignBars:FindFirstChild(v27)
            local Fill = v28 and v28:FindFirstChild("Fill")

            if Fill and Fill:IsA("ImageLabel") then
                t6[v26] = Fill
                t7[v26] = Fill.ImageTransparency
                t8[v26] = false
                Fill.ImageTransparency = 1
                Fill.Visible = false
            end
        end

        local Size, FillPosition = Fill.Size, Fill.Position
        local Y = Fill.AnchorPoint.Y
        local v29 = FillPosition.Y.Scale + (1 - Y) * Size.Y.Scale
        local v30 = FillPosition.Y.Offset + (1 - Y) * Size.Y.Offset
        local UIScale = Instance.new("UIScale")

        UIScale.Name = "RiftProgressScale"
        UIScale.Parent = OutputEgg
        OutputEgg.ZIndex = Fill.ZIndex + 1
        Fill.BackgroundTransparency = 0.45
        Fill.BackgroundColor3 = v7

        local v31, tween
        local v32 = false

        local function setBarFilled(p1, p2, p3) -- line: 189
            -- upvalues: t6 (copy), t7 (copy), t8 (copy), t9 (copy), TweenService (copy), v1 (copy)
            local v33 = t6[p1]

            if v33 == nil or t8[p1] == p2 then
                return
            end

            t8[p1] = p2

            local v34 = t9[p1]

            if v34 then
                v34:Cancel()
                t9[p1] = nil
            end

            local v35 = if p2 then t7[p1] else 1

            if not p3 then
                v33.ImageTransparency = v35
                v33.Visible = p2

                return
            end

            if p2 and not v33.Visible then
                v33.ImageTransparency = 1
            end

            v33.Visible = true

            local tween = TweenService:Create(v33, v1, {
                ImageTransparency = v35
            })

            t9[p1] = tween
            tween.Completed:Connect(function(p4) -- line: 212
                -- upvalues: p1 (copy), v33 (copy), t8 (copy)
                if p4 == Enum.PlaybackState.Completed then
                    v33.Visible = t8[p1]
                end
            end)
            tween:Play()
        end

        local function setOutputProgress(p5, p6) -- line: 220
            -- upvalues: Fill (copy), OutputEgg (copy), Size (copy), FillPosition (copy), Y (copy), v29 (copy), v30 (copy), UIScale (copy), v31 (ref), tween (ref), TweenService (copy), v2 (copy), v3 (copy), v4 (copy)
            local v36 = p5 / 3
            local v37 = UDim2.new(Size.X.Scale, Size.X.Offset, v36, 0)
            local v38 = UDim2.new(FillPosition.X.Scale, FillPosition.X.Offset, v29 - (1 - Y) * v36, v30)

            if p6 then
                TweenService:Create(Fill, v2, {
                    Size = v37,
                    Position = v38
                }):Play()
            else
                Fill.Size = v37
                Fill.Position = v38
            end

            local v39 = p5 >= 3
            local v40 = v31

            v31 = v39

            if tween then
                tween:Cancel()
                tween = nil
            end

            if v39 then
                OutputEgg.ImageTransparency = 0
                OutputEgg.ImageColor3 = Color3.new(1, 1, 1)

                local v41 = if p6 then v40 == true else nil

                if not p6 or v41 then
                    UIScale.Scale = 1
                else
                    UIScale.Scale = 0.8

                    local tween2 = TweenService:Create(UIScale, v3, {
                        Scale = 1.2
                    })

                    tween = tween2
                    tween2.Completed:Connect(function(p7) -- line: 250
                        -- upvalues: UIScale (copy), v31 (ref), tween (ref), TweenService (copy), v4 (copy)
                        if p7 == Enum.PlaybackState.Completed and v31 == true then
                            local tween2 = TweenService:Create(UIScale, v4, {
                                Scale = 1
                            })

                            tween = tween2
                            tween2:Play()
                        end
                    end)
                    tween2:Play()
                end
            else
                OutputEgg.ImageTransparency = 0.1
                OutputEgg.ImageColor3 = Color3.new(0, 0, 0)
                UIScale.Scale = 1
            end
        end

        local t10 = {}

        for _, child in ScrollingFrame:GetChildren() do
            if child.Name == "Template" and child:IsA("Frame") then
                table.insert(t10, child)
            end
        end

        local t11 = {}

        for v42, v43 in t10 do
            local Frame = Instance.new("Frame")

            Frame.Name = "SelectFill"
            Frame.BackgroundColor3 = v8
            Frame.BackgroundTransparency = 1
            Frame.BorderSizePixel = 0
            Frame.Size = UDim2.fromScale(1, 1)
            Frame.ZIndex = 0

            local UICorner = v43:FindFirstChildOfClass("UICorner")

            if UICorner then
                UICorner:Clone().Parent = Frame
            end

            Frame.Parent = v43
            v18:Add(Frame)
            t11[v42] = Frame
        end

        local t12 = {}
        local t13 = {}
        local v44 = Hud.Every("IndexNotificationBadge")[1]

        if v44 ~= nil and v44:IsA("GuiObject") then
            ScrollingFrame.ClipsDescendants = false

            for v45, v46 in t10 do
                local clone = v44:Clone()

                clone.Name = "NowBadge"

                for _, descendant in clone:GetDescendants() do
                    if descendant:IsA("TextLabel") then
                        descendant.Text = "!"
                    end
                end

                clone.AnchorPoint = Vector2.new(0.5, 0.5)
                clone.Position = v10
                clone.Size = v11
                clone.ZIndex = 25
                clone.Visible = false
                clone.Parent = v46
                v18:Add(clone)
                t12[v45] = clone
            end
        end

        local function setNowBadge(p8, p9) -- line: 319
            -- upvalues: t12 (copy), t13 (copy), TweenService (copy), EnsureUIScale (copy), v12 (copy)
            local v47 = t12[p8]

            if v47 == nil then
                return
            end

            v47.Visible = p9

            local v48 = t13[p8]

            if p9 then
                if v48 == nil then
                    local v49 = EnsureUIScale(v47)

                    v49.Scale = 0.8

                    local tween = TweenService:Create(v49, v12, {
                        Scale = 1.2
                    })

                    t13[p8] = tween
                    tween:Play()
                end
            elseif v48 ~= nil then
                v48:Cancel()
                v48:Destroy()
                t13[p8] = nil
                EnsureUIScale(v47).Scale = 1
            end
        end

        local function currentBannerId() -- line: 342
            -- upvalues: result (ref), Rift (copy)
            if result and result.BannerId then
                return result.BannerId
            end

            return (Rift.CurrentBannerId())
        end

        local function viewedBannerId() -- line: 346
            -- upvalues: result (ref), v22 (ref), Rift (copy)
            local v50 = v22

            if v50 ~= nil then
                for _, v51 in Rift.BannerIds() do
                    if v51 == v50 then
                        return v50
                    end
                end

                v22 = nil
            end

            if result and result.BannerId then
                return result.BannerId
            end

            return (Rift.CurrentBannerId())
        end

        local function paintRow(p10, p11, _) -- line: 361
            -- upvalues: v23 (ref), t11 (copy), TweenService (copy), v14 (copy)
            local v52 = t11[p10]

            if v52 ~= nil then
                TweenService:Create(v52, v14, {
                    BackgroundTransparency = not (not p11 and v23 == p10) and 1 or 0.9
                }):Play()
            end
        end

        local function configFor(p13) -- line: 370
            -- upvalues: Assets (copy)
            return Assets.Directory[p13]
        end

        local function pct(p14, p15) -- line: 374
            if p15 <= 0 then
                return "?"
            end

            local v54 = p14 / p15 * 100

            if v54 >= 1 then
                return string.format("%.0f%%", v54)
            end

            if v54 >= 0.05 then
                return string.format("%.1f%%", v54)
            end

            return string.format("%.3f%%", v54)
        end

        local function petTitles(p16) -- line: 387
            local t14 = {}

            for _, child in p16:GetChildren() do
                if child:IsA("TextLabel") and child.Name == "Title" then
                    table.insert(t14, child)
                end
            end

            table.sort(t14, function(p17, p18) -- line: 394
                return p17.Position.Y.Scale < p18.Position.Y.Scale
            end)

            return t14[1], t14[2]
        end

        local function foundInText(p19) -- line: 403
            -- upvalues: Areas (copy), RiftRecipes (copy)
            local v55 = if p19 == nil then nil else select(2, RiftRecipes.SpawnChanceOf(p19))
            local v56 = if v55 == nil then nil else Areas.Directory[v55]

            if v56 == nil then
                return "Found In [???]"
            end

            return (("Found In <font color=\"#%*\">[%*]</font>"):format(v56.Color:ToHex(), v56.DisplayName))
        end

        local function filledCount() -- line: 412
            -- upvalues: t5 (copy)
            local v57 = if t5[1] then 0 + 1 else 0

            if t5[2] then
                v57 += 1
            end

            if t5[3] then
                v57 += 1
            end

            return v57
        end

        local function renderBannerPanel() -- line: 422
            -- upvalues: EggIcon (copy), EggName (copy), result (ref), v22 (ref), t10 (copy), setNowBadge (copy), paintRow (copy), pct (copy), Rift (copy), v9 (copy), t3 (copy)
            local v58 = if not (result and result.BannerId) then Rift.CurrentBannerId() else result.BannerId
            local v59 = v22
            local v60, v61, v62, v63, v64, ImageLabel, ChanceLabel, EggName2, v65, v66, v67, v68, v69, v70, v71

            if v59 ~= nil then
                for _, v72 in Rift.BannerIds() do
                    if v72 == v59 then
                        v60 = Rift.GetBannerEggIcon(v58)

                        if v60 ~= nil then
                            v61 = Color3.new(1, 1, 1)
                        else
                            v61 = t3[v58]
                            v61 = v61 or Color3.new(1, 1, 1)
                        end

                        EggName.Text = ("%* Banner"):format((Rift.GetBannerDisplayName(v58)))

                        if v60 ~= nil then
                            EggIcon.Image = v60
                        end

                        EggIcon.ImageColor3 = v61
                        v62 = Rift.BannerIds()
                        v63 = 0

                        for _, v73 in v62 do
                            v63 += Rift.GetBannerWeight(v73)
                        end

                        for v74, v75 in t10 do
                            v64 = v62[v74]

                            if v64 ~= nil then
                                v75.Visible = true
                                ImageLabel = v75:FindFirstChild("ImageLabel")
                                ChanceLabel = v75:FindFirstChild("ChanceLabel")
                                EggName2 = v75:FindFirstChild("EggName")
                                v68 = v64 == v59
                                v69 = v64 == v58
                                v70 = if v68 then 0 elseif v69 then 0.2 else 0.55
                                v71 = if v68 then 0 elseif v69 then 0.12 else 0.35

                                if ImageLabel then
                                    v65 = Rift.GetBannerEggIcon(v64)

                                    if v65 ~= nil then
                                        ImageLabel.Image = v65
                                    end

                                    if v65 ~= nil then
                                        v66 = Color3.new(1, 1, 1)
                                    else
                                        v66 = t3[v64]
                                        v66 = v66 or Color3.new(1, 1, 1)
                                    end

                                    ImageLabel.ImageColor3 = v66:Lerp(v9, v70)
                                end

                                if ChanceLabel then
                                    ChanceLabel.Text = pct(Rift.GetBannerWeight(v64), v63)
                                    ChanceLabel.TextTransparency = v71
                                end

                                if EggName2 then
                                    v67 = Rift.GetBannerDisplayName(v64)

                                    if v69 then
                                        v67 = ("%* (Now)"):format(v67)
                                    end

                                    EggName2.Text = v67
                                    EggName2.TextTransparency = v71
                                end

                                paintRow(v74, v68, v69)
                                setNowBadge(v74, v69)
                            else
                                v75.Visible = false
                            end
                        end

                        return
                    end
                end

                v22 = nil
            end

            v59 = if not (result and result.BannerId) then Rift.CurrentBannerId() else result.BannerId
            v60 = Rift.GetBannerEggIcon(v58)

            if v60 ~= nil then
                v61 = Color3.new(1, 1, 1)
            else
                v61 = t3[v58]
                v61 = v61 or Color3.new(1, 1, 1)
            end

            EggName.Text = ("%* Banner"):format((Rift.GetBannerDisplayName(v58)))

            if v60 ~= nil then
                EggIcon.Image = v60
            end

            EggIcon.ImageColor3 = v61
            v62 = Rift.BannerIds()
            v63 = 0

            for _, v76 in v62 do
                v63 += Rift.GetBannerWeight(v76)
            end

            for v77, v78 in t10 do
                v64 = v62[v77]

                if v64 ~= nil then
                    v78.Visible = true
                    ImageLabel = v78:FindFirstChild("ImageLabel")
                    ChanceLabel = v78:FindFirstChild("ChanceLabel")
                    EggName2 = v78:FindFirstChild("EggName")
                    v68 = v64 == v59
                    v69 = v64 == v58
                    v70 = if v68 then 0 elseif v69 then 0.2 else 0.55
                    v71 = if v68 then 0 elseif v69 then 0.12 else 0.35

                    if ImageLabel then
                        v65 = Rift.GetBannerEggIcon(v64)

                        if v65 ~= nil then
                            ImageLabel.Image = v65
                        end

                        if v65 ~= nil then
                            v66 = Color3.new(1, 1, 1)
                        else
                            v66 = t3[v64]
                            v66 = v66 or Color3.new(1, 1, 1)
                        end

                        ImageLabel.ImageColor3 = v66:Lerp(v9, v70)
                    end

                    if ChanceLabel then
                        ChanceLabel.Text = pct(Rift.GetBannerWeight(v64), v63)
                        ChanceLabel.TextTransparency = v71
                    end

                    if EggName2 then
                        v67 = Rift.GetBannerDisplayName(v64)

                        if v69 then
                            v67 = ("%* (Now)"):format(v67)
                        end

                        EggName2.Text = v67
                        EggName2.TextTransparency = v71
                    end

                    paintRow(v77, v68, v69)
                    setNowBadge(v77, v69)
                else
                    v78.Visible = false
                end
            end
        end

        local function renderTimer() -- line: 478
            -- upvalues: RotateTimer (copy), Rift (copy)
            local v81 = math.max(math.floor((Rift.SecondsUntilRotation())), 0)
            local v82 = if v81 >= 3600 then string.format("%dh %02dm", v81 // 3600, v81 % 3600 // 60) elseif v81 >= 60 then string.format("%dm %02ds", v81 // 60, v81 % 60) else string.format("%ds", v81)

            RotateTimer.RichText = true
            RotateTimer.Text = ("Rotates in: <font color=\"#FFBB10\">%*</font>"):format(v82)
        end

        local ImageLabel = EggChancesHolder:FindFirstChildWhichIsA("ImageLabel")
        local child, child2, UIGradient

        for _, child3 in EggChancesHolder:GetChildren() do
            if child3:IsA("Frame") and child3.Name == "Frame" then
                child = child3
            elseif child3:IsA("UIStroke") then
                local UIGradient2 = child3:FindFirstChildOfClass("UIGradient")

                if UIGradient2 ~= nil then
                    UIGradient = UIGradient2
                elseif child3.Color ~= Color3.new(0, 0, 0) then
                    child2 = child3
                end
            end
        end

        local function themeForRow(p20) -- line: 513
            -- upvalues: t10 (copy)
            local v83 = t10[p20]

            if v83 == nil then
                return nil
            end

            local BackgroundColor3 = v83.BackgroundColor3
            local CanvasGroup = v83:FindFirstChildOfClass("CanvasGroup")

            if CanvasGroup ~= nil then
                for _, child in CanvasGroup:GetChildren() do
                    if child:IsA("UIStroke") and child.Color ~= Color3.new(0, 0, 0) then
                        BackgroundColor3 = child.Color
                        break
                    end
                end
            end

            return {
                Base = v83.BackgroundColor3,
                Accent = BackgroundColor3
            }
        end

        local function chancesArtNameFor(p21) -- line: 531
            -- upvalues: Rift (copy), t2 (copy)
            local v84 = table.clone(Rift.BannerIds())

            table.sort(v84, function(p22, p23) -- line: 533
                -- upvalues: Rift (copy)
                local v85 = Rift.GetBannerWeight(p22)
                local v86 = Rift.GetBannerWeight(p23)

                if v85 == v86 then
                    return p22 < p23
                end

                return v86 < v85
            end)

            return t2[math.min(table.find(v84, p21) or #v84, #t2)]
        end

        local function applyChancesTheme(p24) -- line: 544
            -- upvalues: EggChancesHolder (copy), RewardHolder (copy), Title (copy), v17 (copy), ImageLabel (copy), child (ref), child2 (ref), UIGradient (ref), themeForRow (copy), chancesArtNameFor (copy), TweenService (copy), Rift (copy), v13 (copy)
            local v89 = table.find(Rift.BannerIds(), p24)
            local v90 = if v89 == nil then nil else themeForRow(v89)

            if v90 == nil then
                return
            end

            local v91 = Color3.new(0, 0, 0)
            local v92 = Color3.new(1, 1, 1)

            TweenService:Create(EggChancesHolder, v13, {
                BackgroundColor3 = v90.Base:Lerp(v91, 0.8)
            }):Play()

            if ImageLabel ~= nil then
                local Attribute = ImageLabel:GetAttribute((chancesArtNameFor(p24)))

                if typeof(Attribute) == "string" and Attribute ~= "" then
                    ImageLabel.Image = Attribute
                end
            end

            local v94 = v90.Base:Lerp(v91, 0.72)

            for _, child in RewardHolder:GetChildren() do
                if child:IsA("Frame") then
                    TweenService:Create(child, v13, {
                        BackgroundColor3 = v94
                    }):Play()
                end
            end

            if child ~= nil then
                TweenService:Create(child, v13, {
                    BackgroundColor3 = v90.Base:Lerp(v91, 0.88)
                }):Play()
            end

            TweenService:Create(v17, v13, {
                BackgroundColor3 = v90.Base:Lerp(v91, 0.68)
            }):Play()

            if child2 ~= nil then
                TweenService:Create(child2, v13, {
                    Color = v90.Accent:Lerp(v91, 0.35)
                }):Play()
            end

            TweenService:Create(Title, v13, {
                TextColor3 = v90.Accent:Lerp(v92, 0.45)
            }):Play()

            if UIGradient ~= nil then
                local UIGradient2 = UIGradient

                UIGradient2.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, v92),
                    ColorSequenceKeypoint.new(0.38, v90.Accent),
                    ColorSequenceKeypoint.new(0.54, v90.Accent:Lerp(v92, 0.75)),
                    ColorSequenceKeypoint.new(0.75, v90.Accent:Lerp(v92, 0.3)),
                    ColorSequenceKeypoint.new(1, v90.Accent:Lerp(v91, 0.4))
                })
            end
        end

        local function ratePerSecondFor(p25) -- line: 585
            -- upvalues: Assets (copy), AssetEarnings (copy)
            local CatalogRatePerSecond = AssetEarnings.CatalogRatePerSecond
            local t15 = {
                BaseMutation = nil,
                Scale = 1,
                HasBeenFirstPlaced = true,
                Category = p25,
                Mutations = {},
                Personality = Assets.Personalities.Personalities.Normal
            }
            local ok, result = pcall(CatalogRatePerSecond, t15)

            if ok and typeof(result) == "number" then
                return (math.round(result))
            end

            local v95 = Assets.Directory[p25]

            return v95 and v95.EarningRate or 0
        end

        local function chancesTitleFor(p26) -- line: 601
            -- upvalues: Rift (copy)
            return (("-- %* Chances --"):format((Rift.GetBannerDisplayName(p26))))
        end

        local function renderPetOdds() -- line: 605
            -- upvalues: RewardHolder (copy), Title (copy), v20 (copy), result (ref), v22 (ref), pct (copy), applyChancesTheme (copy), ratePerSecondFor (copy), Assets (copy), Simple (copy), HoverCard (copy), Rift (copy)
            local v96 = v22
            local v97, v98, sort, v99, v100, v101, AssetId, v102, Icon, Icon2, Amount, Cash, Attach, t16, t17, t18

            if v96 ~= nil then
                for _, v103 in Rift.BannerIds() do
                    if v103 == v96 then
                        Title.Text = ("-- %* Chances --"):format((Rift.GetBannerDisplayName(v96)))
                        applyChancesTheme(v96)
                        v97 = Rift.GetBanner(v96)

                        if v97 ~= nil then
                            v98 = table.clone(v97.Pets)
                            sort = table.sort

                            local v104 = v96

                            v99 = 0
                            sort(v98, function(p27, p28) -- line: 615
                                -- upvalues: Rift (copy), v104 (copy)
                                return Rift.GetPetWeight(v104, p27.AssetId) > Rift.GetPetWeight(v104, p28.AssetId)
                            end)

                            for _, v105 in v98 do
                                v99 += Rift.GetPetWeight(v96, v105.AssetId)
                            end

                            v20:Clean()

                            for i = 1, 6 do
                                v100 = RewardHolder:FindFirstChild((tostring(i)))

                                if v100 ~= nil then
                                    v101 = v98[i]
                                    v100.Visible = v101 ~= nil

                                    if v101 ~= nil then
                                        AssetId = v101.AssetId
                                        v102 = Assets.Directory[AssetId]
                                        Icon = v100:FindFirstChild("Icon")
                                        Icon2 = v100:FindFirstChild("Icon2")
                                        Amount = v100:FindFirstChild("Amount")

                                        if Icon and v102 then
                                            Icon.Image = v102.Icon or ""
                                        end

                                        if Icon2 and v102 then
                                            Icon2.Image = v102.Icon or ""
                                        end

                                        if Amount then
                                            Amount.Text = pct(Rift.GetPetWeight(v96, v101.AssetId), v99)
                                        end

                                        Cash = v100:FindFirstChild("Cash")

                                        if Cash then
                                            Cash.Text = ("$%*/s"):format((Simple.FormatCompact((ratePerSecondFor(v101.AssetId)))))
                                        end

                                        if v102 and v100:IsA("GuiObject") then
                                            Attach = HoverCard.Attach
                                            t16 = {}
                                            t17 = {
                                                kind = "heading"
                                            }

                                            if v102.DisplayName == "" then
                                                t17.text = v101.AssetId
                                            else
                                                t17.text = v102.DisplayName
                                            end

                                            t18 = {
                                                kind = "tier"
                                            }
                                            t18.rarity = v102.Rarity._id
                                            t16[1] = t17
                                            t16[2] = t18
                                            v20:Add(Attach(v100, t16))
                                        end
                                    end
                                end
                            end
                        end

                        return
                    end
                end

                v22 = nil
            end

            v96 = if not (result and result.BannerId) then Rift.CurrentBannerId() else result.BannerId
            Title.Text = ("-- %* Chances --"):format((Rift.GetBannerDisplayName(v96)))
            applyChancesTheme(v96)
            v97 = Rift.GetBanner(v96)

            if v97 == nil then
                return
            end

            v98 = table.clone(v97.Pets)
            sort = table.sort
            v99 = 0
            sort(v98, function(p29, p30) -- line: 615
                -- upvalues: v96 (ref), Rift (copy)
                return Rift.GetPetWeight(v96, p29.AssetId) > Rift.GetPetWeight(v96, p30.AssetId)
            end)

            for _, v106 in v98 do
                v99 += Rift.GetPetWeight(v96, v106.AssetId)
            end

            v20:Clean()

            for i = 1, 6 do
                v100 = RewardHolder:FindFirstChild((tostring(i)))

                if v100 ~= nil then
                    v101 = v98[i]
                    v100.Visible = v101 ~= nil

                    if v101 ~= nil then
                        AssetId = v101.AssetId
                        v102 = Assets.Directory[AssetId]
                        Icon = v100:FindFirstChild("Icon")
                        Icon2 = v100:FindFirstChild("Icon2")
                        Amount = v100:FindFirstChild("Amount")

                        if Icon and v102 then
                            Icon.Image = v102.Icon or ""
                        end

                        if Icon2 and v102 then
                            Icon2.Image = v102.Icon or ""
                        end

                        if Amount then
                            Amount.Text = pct(Rift.GetPetWeight(v96, v101.AssetId), v99)
                        end

                        Cash = v100:FindFirstChild("Cash")

                        if Cash then
                            Cash.Text = ("$%*/s"):format((Simple.FormatCompact((ratePerSecondFor(v101.AssetId)))))
                        end

                        if v102 and v100:IsA("GuiObject") then
                            Attach = HoverCard.Attach
                            t16 = {}
                            t17 = {
                                kind = "heading"
                            }

                            if v102.DisplayName == "" then
                                t17.text = v101.AssetId
                            else
                                t17.text = v102.DisplayName
                            end

                            t18 = {
                                kind = "tier"
                            }
                            t18.rarity = v102.Rarity._id
                            t16[1] = t17
                            t16[2] = t18
                            v20:Add(Attach(v100, t16))
                        end
                    end
                end
            end
        end

        local function renderPity() -- line: 660
            -- upvalues: PityLabel (copy), ProgressBar (copy), result (ref), TweenService (copy), v5 (copy)
            local v107 = result and result.PityCount or 0
            local v108 = result and result.PityThreshold or 50

            PityLabel.Text = ("%*/%*"):format(v107, v108)

            local v109 = if v108 > 0 then math.clamp(v107 / v108, 0, 1) else 0

            TweenService:Create(ProgressBar, v5, {
                Size = UDim2.new(math.max(v109 * 0.73, 0.012), 0, 1, 0)
            }):Play()
        end

        local function renderSlots() -- line: 668
            -- upvalues: SacrificeInputs (copy), Price (copy), result (ref), t5 (copy), v32 (ref), setBarFilled (copy), setOutputProgress (copy), foundInText (copy), Assets (copy)
            local Requirements = if result then result.Requirements else nil

            for i = 1, 3 do
                local v112 = SacrificeInputs:FindFirstChild((("Input%*"):format(i)))
                local Full, Empty, v113

                if v112 ~= nil then
                    Full = v112:FindFirstChild("Full")
                    Empty = v112:FindFirstChild("Empty")

                    if Full and Empty then
                        v113 = Requirements and Requirements[i]

                        local v114 = t5[i]

                        if v114 and v113 and v114.Category ~= v113 then
                            v114 = nil
                            t5[i] = nil
                        end

                        local v115 = v113 and Assets.Directory[v113]

                        Full.Visible = v114 ~= nil
                        Empty.Visible = v114 == nil

                        local FoundInWorld = v112:FindFirstChild("FoundInWorld")

                        if FoundInWorld then
                            FoundInWorld.RichText = true
                            FoundInWorld.Text = foundInText(v113)
                            FoundInWorld.Visible = v113 ~= nil
                        end

                        local Rarity, Pet, Amount, v116

                        if v114 then
                            if v115 then
                                v116 = true
                            else
                                local Name = Empty:FindFirstChild("Name")

                                Rarity = Empty:FindFirstChild("Rarity")
                                Pet = Empty:FindFirstChild("Pet")
                                Amount = Empty:FindFirstChild("Amount")

                                if Name then
                                    Name.Text = "???"
                                end

                                v116 = false
                            end
                        else
                            local Name = Empty:FindFirstChild("Name")

                            Rarity = Empty:FindFirstChild("Rarity")
                            Pet = Empty:FindFirstChild("Pet")
                            Amount = Empty:FindFirstChild("Amount")

                            if Name then
                                if v115 then
                                    Name.Text = v115.DisplayName ~= "" and v115.DisplayName or v113
                                else
                                    Name.Text = "???"
                                end
                            end

                            v116 = false
                        end

                        if v116 then
                            local Name = Full:FindFirstChild("Name")
                            local Rarity = Full:FindFirstChild("Rarity")
                            local Pet = Full:FindFirstChild("Pet")

                            if Name then
                                Name.Text = v115.DisplayName ~= "" and v115.DisplayName or v114.Category
                            end

                            if Rarity then
                                Rarity.Text = v115.Rarity.DisplayName
                                Rarity.TextColor3 = v115.Rarity.Color or Rarity.TextColor3
                            end

                            if Pet then
                                Pet.Image = v115.Icon or ""
                                Pet.ImageTransparency = 0
                            end
                        else
                            if Rarity then
                                if v115 then
                                    Rarity.Text = v115.Rarity.DisplayName
                                else
                                    Rarity.Text = ""
                                end

                                if v115 and v115.Rarity.Color then
                                    Rarity.TextColor3 = v115.Rarity.Color
                                end
                            end

                            if Pet then
                                Pet.Image = v115 and v115.Icon or ""
                                Pet.ImageTransparency = 0.4
                            end

                            if Amount then
                                Amount.Text = "0/1"
                            end
                        end
                    end
                end
            end

            local v117 = if t5[1] then 0 + 1 else 0

            if t5[2] then
                v117 += 1
            end

            if t5[3] then
                v117 += 1
            end

            local v118 = 3 - v117

            Price.Text = if v118 == 0 then "SACRIFICE" elseif v118 == 1 then "1 Pet Left" else ("%* Pets Left"):format(v118)

            local v120 = v32

            v32 = true
            setBarFilled(1, t5[1] ~= nil, v120)
            setBarFilled(2, t5[2] ~= nil, v120)
            setBarFilled(3, t5[3] ~= nil, v120)

            local v121 = if t5[1] then 0 + 1 else 0

            if t5[2] then
                v121 += 1
            end

            if t5[3] then
                v121 += 1
            end

            setOutputProgress(v121, v120)
        end

        local TextLabel

        local function renderRefresh() -- line: 753
            -- upvalues: result (ref), PriceInRobux (ref), TextLabel (ref), v15 (copy)
            if result ~= nil then
                local v122 = result.FreeRefreshesRemaining or 0

                if v122 > 0 then
                    local TextLabel2 = TextLabel

                    TextLabel2.Text = ("REROLL (%* free)"):format(v122)
                elseif PriceInRobux then
                    local TextLabel2 = TextLabel

                    TextLabel2.Text = ("REROLL %*%*"):format(v15, PriceInRobux)
                else
                    TextLabel.Text = "REROLL"
                end
            else
                TextLabel.Text = "REROLL"
            end
        end

        local function renderAll() -- line: 768
            -- upvalues: result (ref), PriceInRobux (ref), renderBannerPanel (copy), renderTimer (copy), renderPetOdds (copy), renderPity (copy), renderSlots (copy), TextLabel (ref), v15 (copy)
            renderBannerPanel()
            renderTimer()
            renderPetOdds()
            renderPity()
            renderSlots()

            if result ~= nil then
                local v123 = result.FreeRefreshesRemaining or 0

                if v123 > 0 then
                    local TextLabel2 = TextLabel

                    TextLabel2.Text = ("REROLL (%* free)"):format(v123)
                elseif PriceInRobux then
                    local TextLabel2 = TextLabel

                    TextLabel2.Text = ("REROLL %*%*"):format(v15, PriceInRobux)
                else
                    TextLabel.Text = "REROLL"
                end
            else
                TextLabel.Text = "REROLL"
            end
        end

        local function fetchState() -- line: 777
            -- upvalues: result (ref), PriceInRobux (ref), renderBannerPanel (copy), renderTimer (copy), renderPetOdds (copy), renderPity (copy), renderSlots (copy), TextLabel (ref), Remotes (copy), v15 (copy)
            task.spawn(function() -- line: 778
                -- upvalues: result (ref), PriceInRobux (ref), renderBannerPanel (copy), renderTimer (copy), renderPetOdds (copy), renderPity (copy), renderSlots (copy), TextLabel (ref), Remotes (copy), v15 (copy)
                local function v124() -- line: 779
                    -- upvalues: Remotes (copy)
                    return Remotes.Rift.AskState:InvokeServer()
                end

                local ok, result2 = pcall(v124)

                if not ok or typeof(result2) ~= "table" then
                    return
                end

                result = result2
                renderBannerPanel()
                renderTimer()
                renderPetOdds()
                renderPity()
                renderSlots()

                if result ~= nil then
                    local v125 = result.FreeRefreshesRemaining or 0

                    if v125 > 0 then
                        TextLabel.Text = ("REROLL (%* free)"):format(v125)
                    elseif PriceInRobux then
                        TextLabel.Text = ("REROLL %*%*"):format(v15, PriceInRobux)
                    else
                        TextLabel.Text = "REROLL"
                    end
                else
                    TextLabel.Text = "REROLL"
                end
            end)
        end

        local function showMain() -- line: 789
            -- upvalues: RiftTradeInMain (copy), RiftTradeInInventory (copy)
            RiftTradeInInventory.Visible = false
            RiftTradeInMain.Visible = true
        end

        local function openPicker(p31) -- line: 794
            -- upvalues: RiftTradeInMain (copy), RiftTradeInInventory (copy), ScrollingFrame2 (copy), v19 (copy), result (ref), t5 (copy), v25 (copy), petTitles (copy), renderSlots (copy), Assets (copy), AssetItems (copy), ButtonFX (copy), FuseKernel (copy), Toast (copy), Save (copy), v6 (copy)
            local v126 = result and result.Requirements
            local v127 = v126 and v126[p31]
            local v128 = Save.Await()

            if v127 == nil or v128 == nil then
                return
            end

            local v129 = Assets.Directory[v127]
            local v130 = if not v129 then v127 elseif v129.DisplayName == "" then v127 else v129.DisplayName
            local t20 = {}
            local v131 = t5[1]

            if v131 then
                t20[v131.Uid] = true
            end

            local v132 = t5[2]

            if v132 then
                t20[v132.Uid] = true
            end

            local v133 = t5[3]

            if v133 then
                t20[v133.Uid] = true
            end

            local t21 = {}

            for _, v134 in v128.EquippedAssets do
                t21[v134] = true
            end

            local t22 = {}

            for v135, v136 in v128.Inventory do
                if not t20[v135] and not t21[v135] and v136.Category == v127 then
                    local MayEnterRift = FuseKernel.MayEnterRift
                    local ok, result = pcall(MayEnterRift, v135, v136)

                    if ok and result == true then
                        local Decode = AssetItems.Decode
                        local ok, result = pcall(Decode, v136)

                        if ok then
                            table.insert(t22, {
                                Uid = v135,
                                Weight = AssetItems.WeightKg(result),
                                Label = AssetItems.WeightLabel(result)
                            })
                        end
                    end
                end
            end

            if #t22 == 0 then
                Toast.Show({
                    Seconds = 2.5,
                    SingleLine = true,
                    Text = ("You have no spare %* to offer"):format(v130),
                    Color = v6
                })
            else
                table.sort(t22, function(p32, p33) -- line: 849
                    return p32.Weight < p33.Weight
                end)
                v19:Clean()

                for v137, v138 in t22 do
                    local clone = v25:Clone()

                    clone.Name = ("Pet_%*"):format(v138.Uid)
                    clone.LayoutOrder = v137
                    clone.Visible = true
                    v19:Add(clone)

                    local PetDecal = clone:FindFirstChild("PetDecal")

                    if PetDecal and v129 then
                        PetDecal.Image = v129.Icon or ""
                    end

                    local v139, v140 = petTitles(clone)

                    if v139 then
                        v139.Text = v130
                    end

                    if v140 then
                        v140.Text = ("(%*)"):format(v138.Label)
                    end

                    v19:Add(ButtonFX(clone, 1.06, function() -- line: 873
                        -- upvalues: p31 (copy), v127 (copy), v138 (copy), RiftTradeInMain (copy), RiftTradeInInventory (copy), t5 (copy), renderSlots (copy)
                        t5[p31] = {
                            Uid = v138.Uid,
                            Category = v127
                        }
                        RiftTradeInInventory.Visible = false
                        RiftTradeInMain.Visible = true
                        renderSlots()
                    end))
                    clone.Parent = ScrollingFrame2
                end

                RiftTradeInMain.Visible = false
                RiftTradeInInventory.Visible = true
            end
        end

        local function onSacrifice() -- line: 885
            -- upvalues: Price (copy), result (ref), t5 (copy), v21 (ref), PriceInRobux (ref), renderBannerPanel (copy), renderTimer (copy), renderPetOdds (copy), renderPity (copy), renderSlots (copy), TextLabel (ref), AssetItems (copy), Toast (copy), Remotes (copy), RiftSequence (copy), Save (copy), Tabs (copy), v6 (copy), v7 (copy), v15 (copy)
            if v21 then
                return
            end

            local v141 = result and result.Requirements

            if v141 == nil or #v141 < 3 then
                return
            end

            local v142 = if t5[1] then 0 + 1 else 0

            if t5[2] then
                v142 += 1
            end

            if t5[3] then
                v142 += 1
            end

            if v142 < 3 then
                local Show = Toast.Show
                local t24 = {
                    Seconds = 2,
                    SingleLine = true
                }
                local v143 = if t5[1] then 0 + 1 else 0

                if t5[2] then
                    v143 += 1
                end

                if t5[3] then
                    v143 += 1
                end

                t24.Text = `The Rift demands { 3 - v143 } more`
                t24.Color = v6
                Show(t24)
            else
                local v144 = Save.Await()

                if v144 ~= nil then
                    local t25 = {}
                    local t26 = {}

                    for i = 1, 3 do
                        local v145 = t5[i]
                        local v146 = v144.Inventory[v145.Uid]

                        if v146 == nil then
                            t5[i] = nil
                            renderSlots()

                            return
                        end

                        table.insert(t25, v145.Uid)

                        local Decode = AssetItems.Decode
                        local ok, result = pcall(Decode, v146)

                        if ok then
                            table.insert(t26, result)
                        end
                    end

                    v21 = true
                    Price.Text = "..."

                    local function v147() -- line: 926
                        -- upvalues: t25 (copy), Remotes (copy)
                        return Remotes.Rift.AskTradeIn:InvokeServer(t25)
                    end

                    local v148, v149, v150 = pcall(v147)

                    v21 = false

                    if not v148 or v149 ~= true then
                        if not v148 then
                            v150 = "Something went wrong, please try again"
                        end

                        Toast.Show({
                            Seconds = 3,
                            SingleLine = true,
                            Text = tostring(v150 or "The Rift refused the trade"),
                            Color = v6
                        })
                        renderSlots()
                    else
                        t5[1] = nil
                        t5[2] = nil
                        t5[3] = nil
                        Tabs.Deactivate()
                        task.spawn(function() -- line: 778
                            -- upvalues: result (ref), PriceInRobux (ref), renderBannerPanel (copy), renderTimer (copy), renderPetOdds (copy), renderPity (copy), renderSlots (copy), TextLabel (ref), Remotes (copy), v15 (copy)
                            local function v152() -- line: 779
                                -- upvalues: Remotes (copy)
                                return Remotes.Rift.AskState:InvokeServer()
                            end

                            local ok, result2 = pcall(v152)

                            if not ok or typeof(result2) ~= "table" then
                                return
                            end

                            result = result2
                            renderBannerPanel()
                            renderTimer()
                            renderPetOdds()
                            renderPity()
                            renderSlots()

                            if result ~= nil then
                                local v153 = result.FreeRefreshesRemaining or 0

                                if v153 > 0 then
                                    TextLabel.Text = ("REROLL (%* free)"):format(v153)
                                elseif PriceInRobux then
                                    TextLabel.Text = ("REROLL %*%*"):format(v15, PriceInRobux)
                                else
                                    TextLabel.Text = "REROLL"
                                end
                            else
                                TextLabel.Text = "REROLL"
                            end
                        end)
                        RiftSequence.Play(t26, function() -- line: 948
                            -- upvalues: Toast (copy), Remotes (copy), v7 (copy)
                            local function v154() -- line: 949
                                -- upvalues: Remotes (copy)
                                Remotes.Rift.AskFinishReveal:InvokeServer()
                            end

                            pcall(v154)
                            Toast.Show({
                                Text = "A Rift Egg joins your eggs!",
                                Seconds = 3.5,
                                SingleLine = true,
                                Color = v7
                            })
                        end)
                    end
                end
            end
        end

        local function onRefresh() -- line: 961
            -- upvalues: result (ref), v21 (ref), PriceInRobux (ref), renderBannerPanel (copy), renderTimer (copy), renderPetOdds (copy), renderPity (copy), renderSlots (copy), TextLabel (ref), Toast (copy), Products (copy), Storefront (copy), Remotes (copy), v6 (copy), v15 (copy)
            if v21 then
                return
            end

            local v155 = result and result.FreeRefreshesRemaining or 0

            if not (v155 > 0) then
                Storefront.Prompt(Products.Directory.RiftRefresh.ProductId, true)

                return
            end

            v21 = true

            local function v156() -- line: 968
                -- upvalues: Remotes (copy)
                return Remotes.Rift.AskRefresh:InvokeServer()
            end

            local v157, v158, v159, v160 = pcall(v156)

            v21 = false

            if v157 and v158 == true then
                if result and typeof(v160) == "table" then
                    result.Requirements = v160

                    local result2 = result

                    result2.FreeRefreshesRemaining = math.max(v155 - 1, 0)
                end

                renderSlots()

                if result ~= nil then
                    local v162 = result.FreeRefreshesRemaining or 0

                    if v162 > 0 then
                        local TextLabel2 = TextLabel

                        TextLabel2.Text = ("REROLL (%* free)"):format(v162)
                    elseif PriceInRobux then
                        local TextLabel2 = TextLabel

                        TextLabel2.Text = ("REROLL %*%*"):format(v15, PriceInRobux)
                    else
                        TextLabel.Text = "REROLL"
                    end
                else
                    TextLabel.Text = "REROLL"
                end
            else
                local Show = Toast.Show
                local t28 = {
                    Seconds = 2.5,
                    SingleLine = true
                }

                if not v157 then
                    v159 = "Refresh failed, try again"
                end

                t28.Text = tostring(v159)
                t28.Color = v6
                Show(t28)
                task.spawn(function() -- line: 778
                    -- upvalues: result (ref), PriceInRobux (ref), renderBannerPanel (copy), renderTimer (copy), renderPetOdds (copy), renderPity (copy), renderSlots (copy), TextLabel (ref), Remotes (copy), v15 (copy)
                    local function v163() -- line: 779
                        -- upvalues: Remotes (copy)
                        return Remotes.Rift.AskState:InvokeServer()
                    end

                    local ok, result2 = pcall(v163)

                    if not ok or typeof(result2) ~= "table" then
                        return
                    end

                    result = result2
                    renderBannerPanel()
                    renderTimer()
                    renderPetOdds()
                    renderPity()
                    renderSlots()

                    if result ~= nil then
                        local v164 = result.FreeRefreshesRemaining or 0

                        if v164 > 0 then
                            TextLabel.Text = ("REROLL (%* free)"):format(v164)
                        elseif PriceInRobux then
                            TextLabel.Text = ("REROLL %*%*"):format(v15, PriceInRobux)
                        else
                            TextLabel.Text = "REROLL"
                        end
                    else
                        TextLabel.Text = "REROLL"
                    end
                end)
            end
        end

        local Input1 = SacrificeInputs:FindFirstChild("Input1")
        local v165 = Input1 and Input1:FindFirstChild("Full")

        Input1 = v165 and v165:FindFirstChild("Return")

        local v166 = Input1 and Input1:IsA("ImageButton")

        assert(v166, "RiftTradeIn Input1 has no Return button to clone")

        local clone = Input1:Clone()

        clone.Name = "Refresh"
        clone.AnchorPoint = Vector2.new(0, 0)
        clone.Position = UDim2.fromScale(1.0307, 0.75)
        clone.Size = UDim2.fromScale(0.3962, 0.062)

        local TextLabel2 = clone:FindFirstChildWhichIsA("TextLabel")

        assert(TextLabel2, "Refresh clone lost its label")
        TextLabel = TextLabel2
        TextLabel.Text = "REROLL"
        clone.Parent = RiftTradeInMain

        local Full

        for i = 1, 3 do
            v166 = SacrificeInputs:FindFirstChild((("Input%*"):format(i)))

            if v166 ~= nil then
                local Empty = v166:FindFirstChild("Empty")

                Full = v166:FindFirstChild("Full")

                local Add = Empty and Empty:FindFirstChild("Add")

                Empty = Full and Full:FindFirstChild("Return")

                if Add and Add:IsA("GuiButton") then
                    v18:Add(ButtonFX(Add, 1.08, function() -- line: 1020
                        -- upvalues: openPicker (copy), i (copy)
                        openPicker(i)
                    end))
                end

                if Empty and Empty:IsA("GuiButton") then
                    v18:Add(ButtonFX(Empty, 1.08, function() -- line: 1025
                        -- upvalues: t5 (copy), renderSlots (copy), i (copy)
                        t5[i] = nil
                        renderSlots()
                    end))
                end
            end
        end

        v18:Add(ButtonFX(Sacrifice, 1.05, onSacrifice))
        v18:Add(ButtonFX(clone, 1.08, onRefresh))
        v18:Add(ButtonFX(Close, 1.08, showMain))

        local function selectBanner(p34) -- line: 1036
            -- upvalues: result (ref), v22 (ref), renderBannerPanel (copy), renderPetOdds (copy), Rift (copy)
            local v167 = Rift.BannerIds()[p34]

            if v167 == nil then
                return
            end

            if v167 == (if not (result and result.BannerId) then Rift.CurrentBannerId() else result.BannerId) then
                v167 = nil
            end

            v22 = v167
            renderBannerPanel()
            renderPetOdds()
        end

        for v168, v169 in t10 do
            Full = Instance.new("TextButton")
            Full.Name = "SelectHit"
            Full.BackgroundTransparency = 1
            Full.Text = ""
            Full.AutoButtonColor = false
            Full.AnchorPoint = Vector2.new(0.5, 0.5)
            Full.Position = UDim2.fromScale(0.5, 0.5)
            Full.Size = UDim2.fromScale(1, 1)
            Full.ZIndex = 20
            Full.Parent = v169
            v18:Add(Full)
            v18:Add(Full.MouseEnter:Connect(function() -- line: 1058
                -- upvalues: result (ref), v22 (ref), v23 (ref), paintRow (copy), v168 (copy), Rift (copy)
                v23 = v168

                local v171 = Rift.BannerIds()[v168]
                local v172 = v22
                local v173, v174, v175, result2, result3, result4, BannerId, v176

                if v172 ~= nil then
                    for _, v177 in Rift.BannerIds() do
                        if v177 == v172 then
                            v176 = v171 == v172
                            v173 = Rift.BannerIds()
                            v174 = v168
                            v175 = v173[v174]
                            result2 = result

                            if result2 then
                                result3 = result

                                if result3.BannerId then
                                    result4 = result
                                    BannerId = result4.BannerId
                                else
                                    BannerId = Rift.CurrentBannerId()
                                end
                            else
                                BannerId = Rift.CurrentBannerId()
                            end

                            paintRow(v168, v176, v175 == BannerId)

                            return
                        end
                    end

                    v22 = nil
                end

                v172 = if not (result and result.BannerId) then Rift.CurrentBannerId() else result.BannerId
                v176 = v171 == v172
                v175 = Rift.BannerIds()[v168]
                result2 = result

                if result2 then
                    result3 = result

                    if result3.BannerId then
                        result4 = result
                        BannerId = result4.BannerId
                    else
                        BannerId = Rift.CurrentBannerId()
                    end
                else
                    BannerId = Rift.CurrentBannerId()
                end

                paintRow(v168, v176, v175 == BannerId)
            end))
            v18:Add(Full.MouseLeave:Connect(function() -- line: 1062
                -- upvalues: result (ref), v22 (ref), v23 (ref), paintRow (copy), v168 (copy), Rift (copy)
                if v23 == v168 then
                    v23 = nil
                end

                local v178 = Rift.BannerIds()[v168]
                local v179 = v22
                local v180, v181, v182, result2, result3, result4, BannerId, v183

                if v179 ~= nil then
                    for _, v184 in Rift.BannerIds() do
                        if v184 == v179 then
                            v183 = v178 == v179
                            v180 = Rift.BannerIds()
                            v181 = v168
                            v182 = v180[v181]
                            result2 = result

                            if result2 then
                                result3 = result

                                if result3.BannerId then
                                    result4 = result
                                    BannerId = result4.BannerId
                                else
                                    BannerId = Rift.CurrentBannerId()
                                end
                            else
                                BannerId = Rift.CurrentBannerId()
                            end

                            paintRow(v168, v183, v182 == BannerId)

                            return
                        end
                    end

                    v22 = nil
                    v179 = if not result then Rift.CurrentBannerId() elseif result.BannerId then result.BannerId else Rift.CurrentBannerId()
                else
                    local result2 = result
                    local BannerId = if result2 then result.BannerId else nil

                    v179 = if not result2 or not BannerId then Rift.CurrentBannerId() else result.BannerId
                end

                v183 = v178 == v179
                v182 = Rift.BannerIds()[v168]
                result2 = result

                if result2 then
                    result3 = result

                    if result3.BannerId then
                        result4 = result
                        BannerId = result4.BannerId
                    else
                        BannerId = Rift.CurrentBannerId()
                    end
                else
                    BannerId = Rift.CurrentBannerId()
                end

                paintRow(v168, v183, v182 == BannerId)
            end))
            v18:Add(ButtonFX(Full, 1, function() -- line: 1068
                -- upvalues: result (ref), v22 (ref), renderBannerPanel (copy), renderPetOdds (copy), v168 (copy), Rift (copy)
                local v185 = Rift.BannerIds()[v168]

                if v185 == nil then
                    return
                end

                if v185 == (if not (result and result.BannerId) then Rift.CurrentBannerId() else result.BannerId) then
                    v185 = nil
                end

                v22 = v185
                renderBannerPanel()
                renderPetOdds()
            end))
        end

        Title.TextScaled = true
        Title.TextWrapped = true
        v18:Add(Tabs.Activated:Connect(function(p35) -- line: 1076
            -- upvalues: RiftTradeInMain (copy), RiftTradeInInventory (copy), result (ref), PriceInRobux (ref), v22 (ref), v23 (ref), renderBannerPanel (copy), renderTimer (copy), renderPetOdds (copy), renderPity (copy), renderSlots (copy), TextLabel (ref), Remotes (copy), v15 (copy)
            if p35 ~= "RiftTradeIn" then
                return
            end

            v22 = nil
            v23 = nil
            RiftTradeInInventory.Visible = false
            RiftTradeInMain.Visible = true
            task.spawn(function() -- line: 778
                -- upvalues: result (ref), PriceInRobux (ref), renderBannerPanel (copy), renderTimer (copy), renderPetOdds (copy), renderPity (copy), renderSlots (copy), TextLabel (ref), Remotes (copy), v15 (copy)
                local function v186() -- line: 779
                    -- upvalues: Remotes (copy)
                    return Remotes.Rift.AskState:InvokeServer()
                end

                local ok, result2 = pcall(v186)

                if not ok or typeof(result2) ~= "table" then
                    return
                end

                result = result2
                renderBannerPanel()
                renderTimer()
                renderPetOdds()
                renderPity()
                renderSlots()

                if result ~= nil then
                    local v187 = result.FreeRefreshesRemaining or 0

                    if v187 > 0 then
                        TextLabel.Text = ("REROLL (%* free)"):format(v187)
                    elseif PriceInRobux then
                        TextLabel.Text = ("REROLL %*%*"):format(v15, PriceInRobux)
                    else
                        TextLabel.Text = "REROLL"
                    end
                else
                    TextLabel.Text = "REROLL"
                end
            end)
        end))
        v18:Add(Tabs.Deactivated:Connect(function(p36) -- line: 1084
            -- upvalues: RiftTradeInMain (copy), RiftTradeInInventory (copy)
            if p36 == "RiftTradeIn" then
                RiftTradeInInventory.Visible = false
                RiftTradeInMain.Visible = true
            end
        end))
        Remotes.Rift.BannerRotated.OnClientEvent:Connect(function() -- line: 1090
            -- upvalues: result (ref), PriceInRobux (ref), renderBannerPanel (copy), renderTimer (copy), renderPetOdds (copy), renderPity (copy), renderSlots (copy), TextLabel (ref), Remotes (copy), v15 (copy)
            task.spawn(function() -- line: 778
                -- upvalues: result (ref), PriceInRobux (ref), renderBannerPanel (copy), renderTimer (copy), renderPetOdds (copy), renderPity (copy), renderSlots (copy), TextLabel (ref), Remotes (copy), v15 (copy)
                local function v188() -- line: 779
                    -- upvalues: Remotes (copy)
                    return Remotes.Rift.AskState:InvokeServer()
                end

                local ok, result2 = pcall(v188)

                if not ok or typeof(result2) ~= "table" then
                    return
                end

                result = result2
                renderBannerPanel()
                renderTimer()
                renderPetOdds()
                renderPity()
                renderSlots()

                if result ~= nil then
                    local v189 = result.FreeRefreshesRemaining or 0

                    if v189 > 0 then
                        TextLabel.Text = ("REROLL (%* free)"):format(v189)
                    elseif PriceInRobux then
                        TextLabel.Text = ("REROLL %*%*"):format(v15, PriceInRobux)
                    else
                        TextLabel.Text = "REROLL"
                    end
                else
                    TextLabel.Text = "REROLL"
                end
            end)
        end)
        MarketplaceService.PromptProductPurchaseFinished:Connect(function(_, p38, p39) -- line: 1094
            -- upvalues: fetchState (copy), Products (copy)
            if p39 and p38 == Products.Directory.RiftRefresh.ProductId then
                task.delay(1, fetchState)
            end
        end)
        task.spawn(function() -- line: 1100
            -- upvalues: result (ref), PriceInRobux (ref), TextLabel (ref), MarketplaceService (copy), Products (copy), v15 (copy)
            local function v190() -- line: 1101
                -- upvalues: MarketplaceService (copy), Products (copy)
                return MarketplaceService:GetProductInfo(Products.Directory.RiftRefresh.ProductId, Enum.InfoType.Product)
            end

            local ok, result2 = pcall(v190)

            if not (ok and result2 and result2.PriceInRobux) then
                return
            end

            PriceInRobux = result2.PriceInRobux

            if result ~= nil then
                local v191 = result.FreeRefreshesRemaining or 0

                if v191 > 0 then
                    TextLabel.Text = ("REROLL (%* free)"):format(v191)
                elseif PriceInRobux then
                    TextLabel.Text = ("REROLL %*%*"):format(v15, PriceInRobux)
                else
                    TextLabel.Text = "REROLL"
                end
            else
                TextLabel.Text = "REROLL"
            end
        end)
        task.spawn(function() -- line: 1110
            -- upvalues: v16 (copy), result (ref), PriceInRobux (ref), renderBannerPanel (copy), renderTimer (copy), renderPetOdds (copy), renderPity (copy), renderSlots (copy), TextLabel (ref), Remotes (copy), Rift (copy), v15 (copy)
            while true do
                task.wait(1)

                if v16.Enabled then
                    renderTimer()

                    local v192 = Rift.CurrentBannerId()

                    if result and result.BannerId ~= v192 then
                        task.spawn(function() -- line: 778
                            -- upvalues: result (ref), PriceInRobux (ref), renderBannerPanel (copy), renderTimer (copy), renderPetOdds (copy), renderPity (copy), renderSlots (copy), TextLabel (ref), Remotes (copy), v15 (copy)
                            local function v193() -- line: 779
                                -- upvalues: Remotes (copy)
                                return Remotes.Rift.AskState:InvokeServer()
                            end

                            local ok, result2 = pcall(v193)

                            if not ok or typeof(result2) ~= "table" then
                                return
                            end

                            result = result2
                            renderBannerPanel()
                            renderTimer()
                            renderPetOdds()
                            renderPity()
                            renderSlots()

                            if result ~= nil then
                                local v194 = result.FreeRefreshesRemaining or 0

                                if v194 > 0 then
                                    TextLabel.Text = ("REROLL (%* free)"):format(v194)
                                elseif PriceInRobux then
                                    TextLabel.Text = ("REROLL %*%*"):format(v15, PriceInRobux)
                                else
                                    TextLabel.Text = "REROLL"
                                end
                            else
                                TextLabel.Text = "REROLL"
                            end
                        end)
                    end
                end
            end
        end)
        Save.Await()

        v165 = function() -- line: 1124
            -- upvalues: v18 (copy), fetchState (copy), Save (copy)
            v18:Add(Save.WatchFields("Rift", fetchState))
        end

        pcall(v165)
        task.spawn(function() -- line: 778
            -- upvalues: result (ref), PriceInRobux (ref), renderBannerPanel (copy), renderTimer (copy), renderPetOdds (copy), renderPity (copy), renderSlots (copy), TextLabel (ref), Remotes (copy), v15 (copy)
            local function v195() -- line: 779
                -- upvalues: Remotes (copy)
                return Remotes.Rift.AskState:InvokeServer()
            end

            local ok, result2 = pcall(v195)

            if not ok or typeof(result2) ~= "table" then
                return
            end

            result = result2
            renderBannerPanel()
            renderTimer()
            renderPetOdds()
            renderPity()
            renderSlots()

            if result ~= nil then
                local v196 = result.FreeRefreshesRemaining or 0

                if v196 > 0 then
                    TextLabel.Text = ("REROLL (%* free)"):format(v196)
                elseif PriceInRobux then
                    TextLabel.Text = ("REROLL %*%*"):format(v15, PriceInRobux)
                else
                    TextLabel.Text = "REROLL"
                end
            else
                TextLabel.Text = "REROLL"
            end
        end)

        return v18
    end
}
