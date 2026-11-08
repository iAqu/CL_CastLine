-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Areas = require(ReplicatedStorage.Data.Areas)
local Assets = require(ReplicatedStorage.Data.Assets)
local AssetEarnings = require(ReplicatedStorage.Shared.Util.AssetEarnings)
local EggRecords = require(ReplicatedStorage.Shared.Util.EggRecords)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local GUI = require(ReplicatedStorage.Client.GUI)
local Hud = require(ReplicatedStorage.Client.Hud)
local HoverCard = require(ReplicatedStorage.Client.HoverCard)
local EnsureUIScale = require(ReplicatedStorage.Shared.Utils.EnsureUIScale)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local Products = require(ReplicatedStorage.Data.Products)
local Storefront = require(ReplicatedStorage.Client.Functions.Storefront)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local ScrambleTradeIn = require(ReplicatedStorage.Data.ScrambleTradeIn)
local ScrambleTradeInRecipes = require(ReplicatedStorage.Shared.Modules.ScrambleTradeInRecipes)
local ScrambleLeaveTimer = require(ReplicatedStorage.Shared.Util.ScrambleLeaveTimer)
local DrScrambleSequence = require(script.Parent.DrScrambleSequence)
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
local v7 = Color3.fromRGB(164, 255, 61)
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
    Start = function() -- Start | line: 79
        -- upvalues: MarketplaceService (copy), TweenService (copy), Areas (copy), Assets (copy), AssetEarnings (copy), EggRecords (copy), ButtonFX (copy), Simple (copy), GUI (copy), Hud (copy), HoverCard (copy), EnsureUIScale (copy), Toast (copy), Products (copy), Storefront (copy), Remotes (copy), ScrambleTradeIn (copy), ScrambleTradeInRecipes (copy), ScrambleLeaveTimer (copy), DrScrambleSequence (copy), Save (copy), Tabs (copy), Trove (copy), t1 (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy), v12 (copy), v13 (copy), t2 (copy), v14 (copy), v15 (copy), t3 (copy)
        local v16 = GUI.DrScrambleTradeIn()
        local DrScrambleTradeInMain = v16:WaitForChild("DrScrambleTradeInMain")
        local DrScrambleTradeInInventory = v16:WaitForChild("DrScrambleTradeInInventory")
        local CurrentEggInfoHolder = DrScrambleTradeInMain:WaitForChild("CurrentEggInfoHolder")
        local EggIcon = CurrentEggInfoHolder:WaitForChild("EggIcon")
        local EggName = CurrentEggInfoHolder:WaitForChild("EggName")
        local RotateTimer = CurrentEggInfoHolder:WaitForChild("RotateTimer")
        local LeaveTimer = DrScrambleTradeInMain:WaitForChild("Header"):FindFirstChild("LeaveTimer")
        local ScrollingFrame = CurrentEggInfoHolder:WaitForChild("ScrollingFrame")
        local EggChancesHolder = DrScrambleTradeInMain:WaitForChild("EggChancesHolder")
        local RewardHolder = EggChancesHolder:WaitForChild("RewardHolder")
        local Title = EggChancesHolder:WaitForChild("Title")
        local v17 = EggChancesHolder:FindFirstChild("PityHolder") or DrScrambleTradeInMain:WaitForChild("PityHolder")
        local PityLabel = v17:WaitForChild("PityLabel")
        local ProgressBar = v17:WaitForChild("ProgressBar")
        local Icon = v17:WaitForChild("Icon")
        local SacrificeInputs = DrScrambleTradeInMain:WaitForChild("SacrificeInputs")
        local Sacrifice = DrScrambleTradeInMain:WaitForChild("Sacrifice")
        local Price = Sacrifice:WaitForChild("Price")
        local DesignBars = DrScrambleTradeInMain:WaitForChild("DesignBars")
        local Output = DrScrambleTradeInMain:WaitForChild("SacrificeOutput"):WaitForChild("Output")
        local Fill = Output:WaitForChild("Fill")
        local OutputEgg = Output:WaitForChild("OutputEgg")
        local ScrollingFrame2 = DrScrambleTradeInInventory:WaitForChild("ScrollingFrame")
        local Close = DrScrambleTradeInInventory:WaitForChild("Close")
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

        assert(v24, "DrScrambleTradeInInventory has no Pet template")

        local v25 = v24

        v24.Visible = false
        v24.BackgroundColor3 = Color3.fromRGB(30, 49, 22)
        v24.BackgroundTransparency = 0.1

        local UIStroke = v24:FindFirstChildOfClass("UIStroke")

        if UIStroke then
            UIStroke.Enabled = false
        end

        v24.BorderColor3 = Color3.fromRGB(137, 207, 73)
        v24.BorderSizePixel = 2
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

        UIScale.Name = "LaboratoryProgressScale"
        UIScale.Parent = OutputEgg
        OutputEgg.ZIndex = Fill.ZIndex + 1

        local v31, tween
        local v32 = false

        local function setBarFilled(p1, p2, p3) -- line: 195
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
            tween.Completed:Connect(function(p4) -- line: 218
                -- upvalues: p1 (copy), v33 (copy), t8 (copy)
                if p4 == Enum.PlaybackState.Completed then
                    v33.Visible = t8[p1]
                end
            end)
            tween:Play()
        end

        local function setOutputProgress(p5, p6) -- line: 226
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
                    tween2.Completed:Connect(function(p7) -- line: 256
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

        local function setNowBadge(p8, p9) -- line: 325
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

        local function currentBannerId() -- line: 348
            -- upvalues: result (ref), ScrambleTradeIn (copy)
            if result and result.BannerId then
                return result.BannerId
            end

            return (ScrambleTradeIn.CurrentBannerId())
        end

        local function viewedBannerId() -- line: 352
            -- upvalues: result (ref), v22 (ref), ScrambleTradeIn (copy)
            local v50 = v22

            if v50 ~= nil then
                for _, v51 in ScrambleTradeIn.BannerIds() do
                    if v51 == v50 then
                        return v50
                    end
                end

                v22 = nil
            end

            if result and result.BannerId then
                return result.BannerId
            end

            return (ScrambleTradeIn.CurrentBannerId())
        end

        local function paintRow(p10, p11, _) -- line: 367
            -- upvalues: v23 (ref), t11 (copy), TweenService (copy), v14 (copy)
            local v52 = t11[p10]

            if v52 ~= nil then
                TweenService:Create(v52, v14, {
                    BackgroundTransparency = not (not p11 and v23 == p10) and 1 or 0.9
                }):Play()
            end
        end

        local function configFor(p13) -- line: 376
            -- upvalues: Assets (copy)
            return Assets.Directory[p13]
        end

        local function pct(p14, p15) -- line: 380
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

        local function petTitles(p16) -- line: 393
            local t14 = {}

            for _, child in p16:GetChildren() do
                if child:IsA("TextLabel") and child.Name == "Title" then
                    table.insert(t14, child)
                end
            end

            table.sort(t14, function(p17, p18) -- line: 400
                return p17.Position.Y.Scale < p18.Position.Y.Scale
            end)

            return t14[1], t14[2]
        end

        local function foundInText(p19) -- line: 409
            -- upvalues: Areas (copy), ScrambleTradeInRecipes (copy)
            local v55 = if p19 == nil then nil else select(2, ScrambleTradeInRecipes.SpawnChanceOf(p19))
            local v56 = if v55 == nil then nil else Areas.Directory[v55]

            if v56 == nil then
                return "Found In [???]"
            end

            return (("Found In <font color=\"#%*\">[%*]</font>"):format(v56.Color:ToHex(), v56.DisplayName))
        end

        local function filledCount() -- line: 418
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

        local function renderBannerPanel() -- line: 428
            -- upvalues: EggIcon (copy), EggName (copy), result (ref), v22 (ref), t10 (copy), setNowBadge (copy), paintRow (copy), pct (copy), ScrambleTradeIn (copy), v9 (copy), t3 (copy)
            local v58 = if not (result and result.BannerId) then ScrambleTradeIn.CurrentBannerId() else result.BannerId
            local v59 = v22
            local v60, v61, v62, v63, v64, ImageLabel, ChanceLabel, EggName2, v65, v66, v67, v68, v69, v70, v71

            if v59 ~= nil then
                for _, v72 in ScrambleTradeIn.BannerIds() do
                    if v72 == v59 then
                        v60 = ScrambleTradeIn.GetBannerEggIcon(v58)

                        if v60 ~= nil then
                            v61 = Color3.new(1, 1, 1)
                        else
                            v61 = t3[v58]
                            v61 = v61 or Color3.new(1, 1, 1)
                        end

                        EggName.Text = ("%* Banner"):format((ScrambleTradeIn.GetBannerDisplayName(v58)))

                        if v60 ~= nil then
                            EggIcon.Image = v60
                        end

                        EggIcon.ImageColor3 = v61
                        v62 = ScrambleTradeIn.BannerIds()
                        v63 = 0

                        for _, v73 in v62 do
                            v63 += ScrambleTradeIn.GetBannerWeight(v73)
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
                                    v65 = ScrambleTradeIn.GetBannerEggIcon(v64)

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
                                    ChanceLabel.Text = pct(ScrambleTradeIn.GetBannerWeight(v64), v63)
                                    ChanceLabel.TextTransparency = v71
                                end

                                if EggName2 then
                                    v67 = ScrambleTradeIn.GetBannerDisplayName(v64)

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

            v59 = if not (result and result.BannerId) then ScrambleTradeIn.CurrentBannerId() else result.BannerId
            v60 = ScrambleTradeIn.GetBannerEggIcon(v58)

            if v60 ~= nil then
                v61 = Color3.new(1, 1, 1)
            else
                v61 = t3[v58]
                v61 = v61 or Color3.new(1, 1, 1)
            end

            EggName.Text = ("%* Banner"):format((ScrambleTradeIn.GetBannerDisplayName(v58)))

            if v60 ~= nil then
                EggIcon.Image = v60
            end

            EggIcon.ImageColor3 = v61
            v62 = ScrambleTradeIn.BannerIds()
            v63 = 0

            for _, v76 in v62 do
                v63 += ScrambleTradeIn.GetBannerWeight(v76)
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
                        v65 = ScrambleTradeIn.GetBannerEggIcon(v64)

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
                        ChanceLabel.Text = pct(ScrambleTradeIn.GetBannerWeight(v64), v63)
                        ChanceLabel.TextTransparency = v71
                    end

                    if EggName2 then
                        v67 = ScrambleTradeIn.GetBannerDisplayName(v64)

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

        local function renderTimer() -- line: 484
            -- upvalues: RotateTimer (copy), LeaveTimer (copy), ScrambleTradeIn (copy), ScrambleLeaveTimer (copy)
            local v81 = math.max(math.floor((ScrambleTradeIn.SecondsUntilRotation())), 0)
            local v82 = if v81 >= 3600 then string.format("%dh %02dm", v81 // 3600, v81 % 3600 // 60) elseif v81 >= 60 then string.format("%dm %02ds", v81 // 60, v81 % 60) else string.format("%ds", v81)

            RotateTimer.RichText = true
            RotateTimer.Text = ("Rotates in: <font color=\"#FFBB10\">%*</font>"):format(v82)

            if not LeaveTimer then
                return
            end

            local v83 = ScrambleLeaveTimer.SecondsLeft()

            LeaveTimer.Visible = v83 > 0
            LeaveTimer.Text = ScrambleLeaveTimer.Text(v83)
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

        local function themeForRow(p20) -- line: 524
            -- upvalues: t10 (copy)
            local v85 = t10[p20]

            if v85 == nil then
                return nil
            end

            local BackgroundColor3 = v85.BackgroundColor3
            local CanvasGroup = v85:FindFirstChildOfClass("CanvasGroup")

            if CanvasGroup ~= nil then
                for _, child in CanvasGroup:GetChildren() do
                    if child:IsA("UIStroke") and child.Color ~= Color3.new(0, 0, 0) then
                        BackgroundColor3 = child.Color
                        break
                    end
                end
            end

            return {
                Base = v85.BackgroundColor3,
                Accent = BackgroundColor3
            }
        end

        local function chancesArtNameFor(p21) -- line: 542
            -- upvalues: ScrambleTradeIn (copy), t2 (copy)
            local v86 = table.clone(ScrambleTradeIn.BannerIds())

            table.sort(v86, function(p22, p23) -- line: 544
                -- upvalues: ScrambleTradeIn (copy)
                local v87 = ScrambleTradeIn.GetBannerWeight(p22)
                local v88 = ScrambleTradeIn.GetBannerWeight(p23)

                if v87 == v88 then
                    return p22 < p23
                end

                return v88 < v87
            end)

            return t2[math.min(table.find(v86, p21) or #v86, #t2)]
        end

        local function applyChancesTheme(p24) -- line: 555
            -- upvalues: EggChancesHolder (copy), RewardHolder (copy), Title (copy), v17 (copy), ImageLabel (copy), child (ref), child2 (ref), UIGradient (ref), themeForRow (copy), chancesArtNameFor (copy), TweenService (copy), ScrambleTradeIn (copy), v13 (copy)
            local v91 = table.find(ScrambleTradeIn.BannerIds(), p24)
            local v92 = if v91 == nil then nil else themeForRow(v91)

            if v92 == nil then
                return
            end

            local v93 = Color3.new(0, 0, 0)
            local v94 = Color3.new(1, 1, 1)

            TweenService:Create(EggChancesHolder, v13, {
                BackgroundColor3 = v92.Base:Lerp(v93, 0.8)
            }):Play()

            if ImageLabel ~= nil then
                local Attribute = ImageLabel:GetAttribute((chancesArtNameFor(p24)))

                if typeof(Attribute) == "string" and Attribute ~= "" then
                    ImageLabel.Image = Attribute
                end
            end

            local v96 = v92.Base:Lerp(v93, 0.72)

            for _, child in RewardHolder:GetChildren() do
                if child:IsA("Frame") then
                    TweenService:Create(child, v13, {
                        BackgroundColor3 = v96
                    }):Play()
                end
            end

            if child ~= nil then
                TweenService:Create(child, v13, {
                    BackgroundColor3 = v92.Base:Lerp(v93, 0.88)
                }):Play()
            end

            TweenService:Create(v17, v13, {
                BackgroundColor3 = v92.Base:Lerp(v93, 0.68)
            }):Play()

            if child2 ~= nil then
                TweenService:Create(child2, v13, {
                    Color = v92.Accent:Lerp(v93, 0.35)
                }):Play()
            end

            TweenService:Create(Title, v13, {
                TextColor3 = v92.Accent:Lerp(v94, 0.45)
            }):Play()

            if UIGradient ~= nil then
                local UIGradient2 = UIGradient

                UIGradient2.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, v94),
                    ColorSequenceKeypoint.new(0.38, v92.Accent),
                    ColorSequenceKeypoint.new(0.54, v92.Accent:Lerp(v94, 0.75)),
                    ColorSequenceKeypoint.new(0.75, v92.Accent:Lerp(v94, 0.3)),
                    ColorSequenceKeypoint.new(1, v92.Accent:Lerp(v93, 0.4))
                })
            end
        end

        local function ratePerSecondFor(p25) -- line: 596
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

            local v97 = Assets.Directory[p25]

            return v97 and v97.EarningRate or 0
        end

        local function chancesTitleFor(p26) -- line: 612
            -- upvalues: ScrambleTradeIn (copy)
            return (("-- %* Chances --"):format((ScrambleTradeIn.GetBannerDisplayName(p26))))
        end

        local function renderPetOdds() -- line: 616
            -- upvalues: RewardHolder (copy), Title (copy), v20 (copy), result (ref), v22 (ref), pct (copy), applyChancesTheme (copy), ratePerSecondFor (copy), Assets (copy), Simple (copy), HoverCard (copy), ScrambleTradeIn (copy)
            local v98 = v22
            local v99, v100, sort, v101, v102, v103, AssetId, v104, Icon, Icon2, Amount, Cash, Attach, t16, t17, t18

            if v98 ~= nil then
                for _, v105 in ScrambleTradeIn.BannerIds() do
                    if v105 == v98 then
                        Title.Text = ("-- %* Chances --"):format((ScrambleTradeIn.GetBannerDisplayName(v98)))
                        applyChancesTheme(v98)
                        v99 = ScrambleTradeIn.GetBanner(v98)

                        if v99 ~= nil then
                            v100 = table.clone(v99.Pets)
                            sort = table.sort

                            local v106 = v98

                            v101 = 0
                            sort(v100, function(p27, p28) -- line: 626
                                -- upvalues: ScrambleTradeIn (copy), v106 (copy)
                                return ScrambleTradeIn.GetPetWeight(v106, p27.AssetId) > ScrambleTradeIn.GetPetWeight(v106, p28.AssetId)
                            end)

                            for _, v107 in v100 do
                                v101 += ScrambleTradeIn.GetPetWeight(v98, v107.AssetId)
                            end

                            v20:Clean()

                            for i = 1, 6 do
                                v102 = RewardHolder:FindFirstChild((tostring(i)))

                                if v102 ~= nil then
                                    v103 = v100[i]
                                    v102.Visible = v103 ~= nil

                                    if v103 ~= nil then
                                        AssetId = v103.AssetId
                                        v104 = Assets.Directory[AssetId]
                                        Icon = v102:FindFirstChild("Icon")
                                        Icon2 = v102:FindFirstChild("Icon2")
                                        Amount = v102:FindFirstChild("Amount")

                                        if Icon and v104 then
                                            Icon.Image = v104.Icon or ""
                                        end

                                        if Icon2 and v104 then
                                            Icon2.Image = v104.Icon or ""
                                        end

                                        if Amount then
                                            Amount.Text = pct(ScrambleTradeIn.GetPetWeight(v98, v103.AssetId), v101)
                                        end

                                        Cash = v102:FindFirstChild("Cash")

                                        if Cash then
                                            if ratePerSecondFor(v103.AssetId) > 0 then
                                                Cash.Text = ("$%*/s"):format((Simple.FormatCompact((ratePerSecondFor(v103.AssetId)))))
                                            else
                                                Cash.Text = "TBD"
                                            end
                                        end

                                        if v104 and v102:IsA("GuiObject") then
                                            Attach = HoverCard.Attach
                                            t16 = {}
                                            t17 = {
                                                kind = "heading"
                                            }

                                            if v104.DisplayName == "" then
                                                t17.text = v103.AssetId
                                            else
                                                t17.text = v104.DisplayName
                                            end

                                            t18 = {
                                                kind = "tier"
                                            }
                                            t18.rarity = v104.Rarity._id
                                            t16[1] = t17
                                            t16[2] = t18
                                            v20:Add(Attach(v102, t16))
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

            v98 = if not (result and result.BannerId) then ScrambleTradeIn.CurrentBannerId() else result.BannerId
            Title.Text = ("-- %* Chances --"):format((ScrambleTradeIn.GetBannerDisplayName(v98)))
            applyChancesTheme(v98)
            v99 = ScrambleTradeIn.GetBanner(v98)

            if v99 == nil then
                return
            end

            v100 = table.clone(v99.Pets)
            sort = table.sort
            v101 = 0
            sort(v100, function(p29, p30) -- line: 626
                -- upvalues: v98 (ref), ScrambleTradeIn (copy)
                return ScrambleTradeIn.GetPetWeight(v98, p29.AssetId) > ScrambleTradeIn.GetPetWeight(v98, p30.AssetId)
            end)

            for _, v108 in v100 do
                v101 += ScrambleTradeIn.GetPetWeight(v98, v108.AssetId)
            end

            v20:Clean()

            for i = 1, 6 do
                v102 = RewardHolder:FindFirstChild((tostring(i)))

                if v102 ~= nil then
                    v103 = v100[i]
                    v102.Visible = v103 ~= nil

                    if v103 ~= nil then
                        AssetId = v103.AssetId
                        v104 = Assets.Directory[AssetId]
                        Icon = v102:FindFirstChild("Icon")
                        Icon2 = v102:FindFirstChild("Icon2")
                        Amount = v102:FindFirstChild("Amount")

                        if Icon and v104 then
                            Icon.Image = v104.Icon or ""
                        end

                        if Icon2 and v104 then
                            Icon2.Image = v104.Icon or ""
                        end

                        if Amount then
                            Amount.Text = pct(ScrambleTradeIn.GetPetWeight(v98, v103.AssetId), v101)
                        end

                        Cash = v102:FindFirstChild("Cash")

                        if Cash then
                            if ratePerSecondFor(v103.AssetId) > 0 then
                                Cash.Text = ("$%*/s"):format((Simple.FormatCompact((ratePerSecondFor(v103.AssetId)))))
                            else
                                Cash.Text = "TBD"
                            end
                        end

                        if v104 and v102:IsA("GuiObject") then
                            Attach = HoverCard.Attach
                            t16 = {}
                            t17 = {
                                kind = "heading"
                            }

                            if v104.DisplayName == "" then
                                t17.text = v103.AssetId
                            else
                                t17.text = v104.DisplayName
                            end

                            t18 = {
                                kind = "tier"
                            }
                            t18.rarity = v104.Rarity._id
                            t16[1] = t17
                            t16[2] = t18
                            v20:Add(Attach(v102, t16))
                        end
                    end
                end
            end
        end

        local function renderPity() -- line: 671
            -- upvalues: PityLabel (copy), ProgressBar (copy), Icon (copy), result (ref), TweenService (copy), Assets (copy), ScrambleTradeIn (copy), v5 (copy)
            local v109 = result and result.PityCount or 0
            local v110 = result and result.PityThreshold or 200
            local v111 = ScrambleTradeIn.ChasePetId(if not (result and result.BannerId) then ScrambleTradeIn.CurrentBannerId() else result.BannerId)
            local v112 = if v111 then Assets.Directory[v111] else nil

            Icon.Image = v112 and v112.Icon or ""
            PityLabel.Text = ("%*/%*"):format(v109, v110)

            local v113 = if v110 > 0 then math.clamp(v109 / v110, 0, 1) else 0

            TweenService:Create(ProgressBar, v5, {
                Size = UDim2.new(v113, 0, 1, 0)
            }):Play()
        end

        local function renderSlots() -- line: 682
            -- upvalues: SacrificeInputs (copy), Price (copy), result (ref), t5 (copy), v32 (ref), setBarFilled (copy), setOutputProgress (copy), foundInText (copy), Assets (copy)
            local Requirements = if result then result.Requirements else nil

            for i = 1, 3 do
                local v115 = SacrificeInputs:FindFirstChild((("Input%*"):format(i)))
                local Full, Empty, v116

                if v115 ~= nil then
                    Full = v115:FindFirstChild("Full")
                    Empty = v115:FindFirstChild("Empty")

                    if Full and Empty then
                        v116 = Requirements and Requirements[i]

                        local v117 = t5[i]

                        if v117 and v116 and v117.Category ~= v116 then
                            v117 = nil
                            t5[i] = nil
                        end

                        local v118 = v116 and Assets.Directory[v116]

                        Full.Visible = v117 ~= nil
                        Empty.Visible = v117 == nil

                        local FoundInWorld = v115:FindFirstChild("FoundInWorld")

                        if FoundInWorld then
                            FoundInWorld.RichText = true
                            FoundInWorld.Text = foundInText(v116)
                            FoundInWorld.Visible = v116 ~= nil
                        end

                        local Rarity, Pet, Amount, v119

                        if v117 then
                            if v118 then
                                v119 = true
                            else
                                local Name = Empty:FindFirstChild("Name")

                                Rarity = Empty:FindFirstChild("Rarity")
                                Pet = Empty:FindFirstChild("Pet")
                                Amount = Empty:FindFirstChild("Amount")

                                if Name then
                                    Name.Text = "???"
                                end

                                v119 = false
                            end
                        else
                            local Name = Empty:FindFirstChild("Name")

                            Rarity = Empty:FindFirstChild("Rarity")
                            Pet = Empty:FindFirstChild("Pet")
                            Amount = Empty:FindFirstChild("Amount")

                            if Name then
                                if v118 then
                                    Name.Text = ("%* Egg"):format(v118.DisplayName ~= "" and v118.DisplayName or v116)
                                else
                                    Name.Text = "???"
                                end
                            end

                            v119 = false
                        end

                        if v119 then
                            local Name = Full:FindFirstChild("Name")
                            local Rarity = Full:FindFirstChild("Rarity")
                            local Pet = Full:FindFirstChild("Pet")

                            if Name then
                                Name.Text = ("%* Egg"):format(v118.DisplayName ~= "" and v118.DisplayName or v117.Category)
                            end

                            if Rarity then
                                Rarity.Text = v118.Rarity.DisplayName
                                Rarity.TextColor3 = v118.Rarity.Color or Rarity.TextColor3
                            end

                            if Pet then
                                Pet.Image = v118.Egg.Icon or ""
                                Pet.ImageTransparency = 0
                            end
                        else
                            if Rarity then
                                if v118 then
                                    Rarity.Text = v118.Rarity.DisplayName
                                else
                                    Rarity.Text = ""
                                end

                                if v118 and v118.Rarity.Color then
                                    Rarity.TextColor3 = v118.Rarity.Color
                                end
                            end

                            if Pet then
                                Pet.Image = v118 and v118.Egg.Icon or ""
                                Pet.ImageTransparency = 0.4
                            end

                            if Amount then
                                Amount.Text = "0/1"
                            end
                        end
                    end
                end
            end

            local v120 = if t5[1] then 0 + 1 else 0

            if t5[2] then
                v120 += 1
            end

            if t5[3] then
                v120 += 1
            end

            local v121 = 3 - v120

            Price.Text = if v121 == 0 then "SACRIFICE" elseif v121 == 1 then "1 Egg Left" else ("%* Eggs Left"):format(v121)

            local v123 = v32

            v32 = true
            setBarFilled(1, t5[1] ~= nil, v123)
            setBarFilled(2, t5[2] ~= nil, v123)
            setBarFilled(3, t5[3] ~= nil, v123)

            local v124 = if t5[1] then 0 + 1 else 0

            if t5[2] then
                v124 += 1
            end

            if t5[3] then
                v124 += 1
            end

            setOutputProgress(v124, v123)
        end

        local TextLabel

        local function renderRefresh() -- line: 767
            -- upvalues: result (ref), PriceInRobux (ref), TextLabel (ref), v15 (copy)
            if result ~= nil then
                local v125 = result.FreeRefreshesRemaining or 0

                if v125 > 0 then
                    local TextLabel2 = TextLabel

                    TextLabel2.Text = ("REROLL (%* free)"):format(v125)
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

        local function renderAll() -- line: 782
            -- upvalues: result (ref), PriceInRobux (ref), renderBannerPanel (copy), renderTimer (copy), renderPetOdds (copy), renderPity (copy), renderSlots (copy), TextLabel (ref), v15 (copy)
            renderBannerPanel()
            renderTimer()
            renderPetOdds()
            renderPity()
            renderSlots()

            if result ~= nil then
                local v126 = result.FreeRefreshesRemaining or 0

                if v126 > 0 then
                    local TextLabel2 = TextLabel

                    TextLabel2.Text = ("REROLL (%* free)"):format(v126)
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

        local function fetchState() -- line: 791
            -- upvalues: result (ref), PriceInRobux (ref), renderBannerPanel (copy), renderTimer (copy), renderPetOdds (copy), renderPity (copy), renderSlots (copy), TextLabel (ref), Remotes (copy), v15 (copy)
            task.spawn(function() -- line: 792
                -- upvalues: result (ref), PriceInRobux (ref), renderBannerPanel (copy), renderTimer (copy), renderPetOdds (copy), renderPity (copy), renderSlots (copy), TextLabel (ref), Remotes (copy), v15 (copy)
                local function v127() -- line: 793
                    -- upvalues: Remotes (copy)
                    return Remotes.ScrambleTradeIn.AskState:InvokeServer()
                end

                local ok, result2 = pcall(v127)

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
                    local v128 = result.FreeRefreshesRemaining or 0

                    if v128 > 0 then
                        TextLabel.Text = ("REROLL (%* free)"):format(v128)
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

        local function showMain() -- line: 803
            -- upvalues: DrScrambleTradeInMain (copy), DrScrambleTradeInInventory (copy)
            DrScrambleTradeInInventory.Visible = false
            DrScrambleTradeInMain.Visible = true
        end

        local function openPicker(p31) -- line: 808
            -- upvalues: DrScrambleTradeInMain (copy), DrScrambleTradeInInventory (copy), ScrollingFrame2 (copy), v19 (copy), result (ref), t5 (copy), v25 (copy), petTitles (copy), renderSlots (copy), Assets (copy), EggRecords (copy), ButtonFX (copy), Toast (copy), Save (copy), v6 (copy)
            local v129 = result and result.Requirements
            local v130 = v129 and v129[p31]
            local v131 = Save.Await()

            if v130 == nil or v131 == nil then
                return
            end

            local v132 = Assets.Directory[v130]
            local v133 = if not v132 then v130 elseif v132.DisplayName == "" then v130 else v132.DisplayName
            local t19 = {}
            local v134 = t5[1]

            if v134 then
                t19[v134.Uid] = true
            end

            local v135 = t5[2]

            if v135 then
                t19[v135.Uid] = true
            end

            local v136 = t5[3]

            if v136 then
                t19[v136.Uid] = true
            end

            local t20 = {}

            for v137, v138 in v131.EggInventory do
                if not t19[v137] and v138.AssetCategory == v130 and v138.Placement == nil then
                    local Decode = EggRecords.Decode
                    local ok, result = pcall(Decode, v138)

                    if ok then
                        table.insert(t20, {
                            Uid = v137,
                            Icon = EggRecords.EggIcon(result)
                        })
                    end
                end
            end

            if #t20 == 0 then
                Toast.Show({
                    Seconds = 3,
                    SingleLine = true,
                    Text = ("You need an unplaced %* egg"):format(v133),
                    Color = v6
                })
            else
                table.sort(t20, function(p32, p33) -- line: 846
                    return p32.Uid < p33.Uid
                end)
                v19:Clean()

                for v139, v140 in t20 do
                    local clone = v25:Clone()

                    clone.Name = ("Egg_%*"):format(v140.Uid)
                    clone.LayoutOrder = v139
                    clone.Visible = true
                    v19:Add(clone)

                    local PetDecal = clone:FindFirstChild("PetDecal")

                    if PetDecal then
                        PetDecal.Image = v140.Icon
                    end

                    local v141, v142 = petTitles(clone)

                    if v141 then
                        v141.Text = ("%* Egg"):format(v133)
                    end

                    if v142 then
                        v142.Text = "Unplaced"
                    end

                    v19:Add(ButtonFX(clone, 1.06, function() -- line: 870
                        -- upvalues: p31 (copy), v130 (copy), v140 (copy), DrScrambleTradeInMain (copy), DrScrambleTradeInInventory (copy), t5 (copy), renderSlots (copy)
                        t5[p31] = {
                            Uid = v140.Uid,
                            Category = v130
                        }
                        DrScrambleTradeInInventory.Visible = false
                        DrScrambleTradeInMain.Visible = true
                        renderSlots()
                    end))
                    clone.Parent = ScrollingFrame2
                end

                DrScrambleTradeInMain.Visible = false
                DrScrambleTradeInInventory.Visible = true
            end
        end

        local function onSacrifice() -- line: 882
            -- upvalues: Price (copy), result (ref), t5 (copy), v21 (ref), PriceInRobux (ref), renderBannerPanel (copy), renderTimer (copy), renderPetOdds (copy), renderPity (copy), renderSlots (copy), TextLabel (ref), EggRecords (copy), Toast (copy), Remotes (copy), DrScrambleSequence (copy), Save (copy), Tabs (copy), v6 (copy), v7 (copy), v15 (copy)
            if v21 then
                return
            end

            local v143 = result and result.Requirements

            if v143 == nil or #v143 < 3 then
                return
            end

            local v144 = if t5[1] then 0 + 1 else 0

            if t5[2] then
                v144 += 1
            end

            if t5[3] then
                v144 += 1
            end

            if v144 < 3 then
                local Show = Toast.Show
                local t22 = {
                    Seconds = 2,
                    SingleLine = true
                }
                local v145 = if t5[1] then 0 + 1 else 0

                if t5[2] then
                    v145 += 1
                end

                if t5[3] then
                    v145 += 1
                end

                t22.Text = `Choose { 3 - v145 } more requested eggs`
                t22.Color = v6
                Show(t22)
            else
                local v146 = Save.Await()

                if v146 ~= nil then
                    local t23 = {}
                    local t24 = {}

                    for i = 1, 3 do
                        local v147 = t5[i]
                        local v148 = v146.EggInventory[v147.Uid]

                        if v148 == nil or v148.Placement ~= nil or v148.AssetCategory ~= v147.Category then
                            t5[i] = nil
                            renderSlots()

                            return
                        end

                        table.insert(t23, v147.Uid)

                        local Decode = EggRecords.Decode
                        local ok, result = pcall(Decode, v148)

                        if ok then
                            table.insert(t24, result)
                        end
                    end

                    v21 = true
                    Price.Text = "..."

                    local function v149() -- line: 923
                        -- upvalues: t23 (copy), Remotes (copy)
                        return Remotes.ScrambleTradeIn.AskTradeIn:InvokeServer(t23)
                    end

                    local v150, v151, v152, v153 = pcall(v149)

                    v21 = false

                    if v150 then
                        if v151 == true then
                            t5[1] = nil
                            t5[2] = nil
                            t5[3] = nil
                            Tabs.Deactivate()
                            task.spawn(function() -- line: 792
                                -- upvalues: result (ref), PriceInRobux (ref), renderBannerPanel (copy), renderTimer (copy), renderPetOdds (copy), renderPity (copy), renderSlots (copy), TextLabel (ref), Remotes (copy), v15 (copy)
                                local function v154() -- line: 793
                                    -- upvalues: Remotes (copy)
                                    return Remotes.ScrambleTradeIn.AskState:InvokeServer()
                                end

                                local ok, result2 = pcall(v154)

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
                                    local v155 = result.FreeRefreshesRemaining or 0

                                    if v155 > 0 then
                                        TextLabel.Text = ("REROLL (%* free)"):format(v155)
                                    elseif PriceInRobux then
                                        TextLabel.Text = ("REROLL %*%*"):format(v15, PriceInRobux)
                                    else
                                        TextLabel.Text = "REROLL"
                                    end
                                else
                                    TextLabel.Text = "REROLL"
                                end
                            end)
                            DrScrambleSequence.Play(t24, function() -- line: 945
                                -- upvalues: Toast (copy), Remotes (copy), v7 (copy)
                                local function v156() -- line: 946
                                    -- upvalues: Remotes (copy)
                                    Remotes.ScrambleTradeIn.AskFinishReveal:InvokeServer()
                                end

                                pcall(v156)
                                Toast.Show({
                                    Text = "A laboratory egg joins your eggs!",
                                    Seconds = 3.5,
                                    SingleLine = true,
                                    Color = v7
                                })
                            end, if v153 then v153.Egg else nil)

                            return
                        end
                    else
                        v152 = "Something went wrong, please try again"
                    end

                    Toast.Show({
                        Seconds = 3,
                        SingleLine = true,
                        Text = tostring(v152 or "The laboratory refused the trade"),
                        Color = v6
                    })
                    renderSlots()
                end
            end
        end

        local function onRefresh() -- line: 958
            -- upvalues: result (ref), v21 (ref), PriceInRobux (ref), renderBannerPanel (copy), renderTimer (copy), renderPetOdds (copy), renderPity (copy), renderSlots (copy), TextLabel (ref), Toast (copy), Products (copy), Storefront (copy), Remotes (copy), v6 (copy), v15 (copy)
            if v21 then
                return
            end

            local v158 = result and result.FreeRefreshesRemaining or 0

            if not (v158 > 0) then
                Storefront.Prompt(Products.Directory.RiftRefresh.ProductId, true)

                return
            end

            v21 = true

            local function v159() -- line: 965
                -- upvalues: Remotes (copy)
                return Remotes.ScrambleTradeIn.AskRefresh:InvokeServer()
            end

            local v160, v161, v162, v163 = pcall(v159)

            v21 = false

            if v160 and v161 == true then
                if result and typeof(v163) == "table" then
                    result.Requirements = v163

                    local result2 = result

                    result2.FreeRefreshesRemaining = math.max(v158 - 1, 0)
                end

                renderSlots()

                if result ~= nil then
                    local v165 = result.FreeRefreshesRemaining or 0

                    if v165 > 0 then
                        local TextLabel2 = TextLabel

                        TextLabel2.Text = ("REROLL (%* free)"):format(v165)
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
                local t26 = {
                    Seconds = 2.5,
                    SingleLine = true
                }

                if not v160 then
                    v162 = "Refresh failed, try again"
                end

                t26.Text = tostring(v162)
                t26.Color = v6
                Show(t26)
                task.spawn(function() -- line: 792
                    -- upvalues: result (ref), PriceInRobux (ref), renderBannerPanel (copy), renderTimer (copy), renderPetOdds (copy), renderPity (copy), renderSlots (copy), TextLabel (ref), Remotes (copy), v15 (copy)
                    local function v166() -- line: 793
                        -- upvalues: Remotes (copy)
                        return Remotes.ScrambleTradeIn.AskState:InvokeServer()
                    end

                    local ok, result2 = pcall(v166)

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
                        local v167 = result.FreeRefreshesRemaining or 0

                        if v167 > 0 then
                            TextLabel.Text = ("REROLL (%* free)"):format(v167)
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
        local v168 = Input1 and Input1:FindFirstChild("Full")

        Input1 = v168 and v168:FindFirstChild("Return")

        local v169 = Input1 and Input1:IsA("ImageButton")

        assert(v169, "DrScrambleTradeIn Input1 has no Return button to clone")

        local clone = Input1:Clone()

        clone.Name = "Refresh"
        clone.AnchorPoint = Vector2.new(0, 0)
        clone.Position = UDim2.fromScale(1.0309, 0.839)
        clone.Size = UDim2.fromScale(0.3962, 0.062)

        local TextLabel2 = clone:FindFirstChildWhichIsA("TextLabel")

        assert(TextLabel2, "Refresh clone lost its label")
        TextLabel = TextLabel2
        TextLabel.Text = "REROLL"
        clone.Parent = DrScrambleTradeInMain

        local Full

        for i = 1, 3 do
            v169 = SacrificeInputs:FindFirstChild((("Input%*"):format(i)))

            if v169 ~= nil then
                local Empty = v169:FindFirstChild("Empty")

                Full = v169:FindFirstChild("Full")

                local Add = Empty and Empty:FindFirstChild("Add")

                Empty = Full and Full:FindFirstChild("Return")

                if Add and Add:IsA("GuiButton") then
                    v18:Add(ButtonFX(Add, 1.08, function() -- line: 1017
                        -- upvalues: openPicker (copy), i (copy)
                        openPicker(i)
                    end))
                end

                if Empty and Empty:IsA("GuiButton") then
                    v18:Add(ButtonFX(Empty, 1.08, function() -- line: 1022
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

        local function selectBanner(p34) -- line: 1033
            -- upvalues: result (ref), v22 (ref), renderBannerPanel (copy), renderPetOdds (copy), ScrambleTradeIn (copy)
            local v170 = ScrambleTradeIn.BannerIds()[p34]

            if v170 == nil then
                return
            end

            if v170 == (if not (result and result.BannerId) then ScrambleTradeIn.CurrentBannerId() else result.BannerId) then
                v170 = nil
            end

            v22 = v170
            renderBannerPanel()
            renderPetOdds()
        end

        for v171, v172 in t10 do
            Full = Instance.new("TextButton")
            Full.Name = "SelectHit"
            Full.BackgroundTransparency = 1
            Full.Text = ""
            Full.AutoButtonColor = false
            Full.AnchorPoint = Vector2.new(0.5, 0.5)
            Full.Position = UDim2.fromScale(0.5, 0.5)
            Full.Size = UDim2.fromScale(1, 1)
            Full.ZIndex = 20
            Full.Parent = v172
            v18:Add(Full)
            v18:Add(Full.MouseEnter:Connect(function() -- line: 1055
                -- upvalues: result (ref), v22 (ref), v23 (ref), paintRow (copy), v171 (copy), ScrambleTradeIn (copy)
                v23 = v171

                local v174 = ScrambleTradeIn.BannerIds()[v171]
                local v175 = v22
                local v176, v177, v178, result2, result3, result4, BannerId, v179

                if v175 ~= nil then
                    for _, v180 in ScrambleTradeIn.BannerIds() do
                        if v180 == v175 then
                            v179 = v174 == v175
                            v176 = ScrambleTradeIn.BannerIds()
                            v177 = v171
                            v178 = v176[v177]
                            result2 = result

                            if result2 then
                                result3 = result

                                if result3.BannerId then
                                    result4 = result
                                    BannerId = result4.BannerId
                                else
                                    BannerId = ScrambleTradeIn.CurrentBannerId()
                                end
                            else
                                BannerId = ScrambleTradeIn.CurrentBannerId()
                            end

                            paintRow(v171, v179, v178 == BannerId)

                            return
                        end
                    end

                    v22 = nil
                end

                v175 = if not (result and result.BannerId) then ScrambleTradeIn.CurrentBannerId() else result.BannerId
                v179 = v174 == v175
                v178 = ScrambleTradeIn.BannerIds()[v171]
                result2 = result

                if result2 then
                    result3 = result

                    if result3.BannerId then
                        result4 = result
                        BannerId = result4.BannerId
                    else
                        BannerId = ScrambleTradeIn.CurrentBannerId()
                    end
                else
                    BannerId = ScrambleTradeIn.CurrentBannerId()
                end

                paintRow(v171, v179, v178 == BannerId)
            end))
            v18:Add(Full.MouseLeave:Connect(function() -- line: 1059
                -- upvalues: result (ref), v22 (ref), v23 (ref), paintRow (copy), v171 (copy), ScrambleTradeIn (copy)
                if v23 == v171 then
                    v23 = nil
                end

                local v181 = ScrambleTradeIn.BannerIds()[v171]
                local v182 = v22
                local v183, v184, v185, result2, result3, result4, BannerId, v186

                if v182 ~= nil then
                    for _, v187 in ScrambleTradeIn.BannerIds() do
                        if v187 == v182 then
                            v186 = v181 == v182
                            v183 = ScrambleTradeIn.BannerIds()
                            v184 = v171
                            v185 = v183[v184]
                            result2 = result

                            if result2 then
                                result3 = result

                                if result3.BannerId then
                                    result4 = result
                                    BannerId = result4.BannerId
                                else
                                    BannerId = ScrambleTradeIn.CurrentBannerId()
                                end
                            else
                                BannerId = ScrambleTradeIn.CurrentBannerId()
                            end

                            paintRow(v171, v186, v185 == BannerId)

                            return
                        end
                    end

                    v22 = nil
                    v182 = if not result then ScrambleTradeIn.CurrentBannerId() elseif result.BannerId then result.BannerId else ScrambleTradeIn.CurrentBannerId()
                else
                    local result2 = result
                    local BannerId = if result2 then result.BannerId else nil

                    v182 = if not result2 or not BannerId then ScrambleTradeIn.CurrentBannerId() else result.BannerId
                end

                v186 = v181 == v182
                v185 = ScrambleTradeIn.BannerIds()[v171]
                result2 = result

                if result2 then
                    result3 = result

                    if result3.BannerId then
                        result4 = result
                        BannerId = result4.BannerId
                    else
                        BannerId = ScrambleTradeIn.CurrentBannerId()
                    end
                else
                    BannerId = ScrambleTradeIn.CurrentBannerId()
                end

                paintRow(v171, v186, v185 == BannerId)
            end))
            v18:Add(ButtonFX(Full, 1, function() -- line: 1065
                -- upvalues: result (ref), v22 (ref), renderBannerPanel (copy), renderPetOdds (copy), v171 (copy), ScrambleTradeIn (copy)
                local v188 = ScrambleTradeIn.BannerIds()[v171]

                if v188 == nil then
                    return
                end

                if v188 == (if not (result and result.BannerId) then ScrambleTradeIn.CurrentBannerId() else result.BannerId) then
                    v188 = nil
                end

                v22 = v188
                renderBannerPanel()
                renderPetOdds()
            end))
        end

        Title.TextScaled = true
        Title.TextWrapped = true
        v18:Add(Tabs.Activated:Connect(function(p35) -- line: 1073
            -- upvalues: DrScrambleTradeInMain (copy), DrScrambleTradeInInventory (copy), result (ref), PriceInRobux (ref), v22 (ref), v23 (ref), renderBannerPanel (copy), renderTimer (copy), renderPetOdds (copy), renderPity (copy), renderSlots (copy), TextLabel (ref), Remotes (copy), ScrambleLeaveTimer (copy), Tabs (copy), v15 (copy)
            if p35 ~= "DrScrambleTradeIn" then
                return
            end

            if ScrambleLeaveTimer.IsExpired() then
                Tabs.Deactivate({
                    instant = true
                })
            else
                v22 = nil
                v23 = nil
                DrScrambleTradeInInventory.Visible = false
                DrScrambleTradeInMain.Visible = true
                task.spawn(function() -- line: 792
                    -- upvalues: result (ref), PriceInRobux (ref), renderBannerPanel (copy), renderTimer (copy), renderPetOdds (copy), renderPity (copy), renderSlots (copy), TextLabel (ref), Remotes (copy), v15 (copy)
                    local function v189() -- line: 793
                        -- upvalues: Remotes (copy)
                        return Remotes.ScrambleTradeIn.AskState:InvokeServer()
                    end

                    local ok, result2 = pcall(v189)

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
                        local v190 = result.FreeRefreshesRemaining or 0

                        if v190 > 0 then
                            TextLabel.Text = ("REROLL (%* free)"):format(v190)
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
        end))
        v18:Add(Tabs.Deactivated:Connect(function(p36) -- line: 1085
            -- upvalues: DrScrambleTradeInMain (copy), DrScrambleTradeInInventory (copy)
            if p36 == "DrScrambleTradeIn" then
                DrScrambleTradeInInventory.Visible = false
                DrScrambleTradeInMain.Visible = true
            end
        end))
        Remotes.ScrambleTradeIn.BannerRotated.OnClientEvent:Connect(function() -- line: 1091
            -- upvalues: result (ref), PriceInRobux (ref), renderBannerPanel (copy), renderTimer (copy), renderPetOdds (copy), renderPity (copy), renderSlots (copy), TextLabel (ref), Remotes (copy), v15 (copy)
            task.spawn(function() -- line: 792
                -- upvalues: result (ref), PriceInRobux (ref), renderBannerPanel (copy), renderTimer (copy), renderPetOdds (copy), renderPity (copy), renderSlots (copy), TextLabel (ref), Remotes (copy), v15 (copy)
                local function v191() -- line: 793
                    -- upvalues: Remotes (copy)
                    return Remotes.ScrambleTradeIn.AskState:InvokeServer()
                end

                local ok, result2 = pcall(v191)

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
                    local v192 = result.FreeRefreshesRemaining or 0

                    if v192 > 0 then
                        TextLabel.Text = ("REROLL (%* free)"):format(v192)
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
        MarketplaceService.PromptProductPurchaseFinished:Connect(function(_, p38, p39) -- line: 1095
            -- upvalues: fetchState (copy), Products (copy)
            if p39 and p38 == Products.Directory.RiftRefresh.ProductId then
                task.delay(1, fetchState)
            end
        end)
        task.spawn(function() -- line: 1101
            -- upvalues: result (ref), PriceInRobux (ref), TextLabel (ref), MarketplaceService (copy), Products (copy), v15 (copy)
            local function v193() -- line: 1102
                -- upvalues: MarketplaceService (copy), Products (copy)
                return MarketplaceService:GetProductInfo(Products.Directory.RiftRefresh.ProductId, Enum.InfoType.Product)
            end

            local ok, result2 = pcall(v193)

            if not (ok and result2 and result2.PriceInRobux) then
                return
            end

            PriceInRobux = result2.PriceInRobux

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
        task.spawn(function() -- line: 1111
            -- upvalues: v16 (copy), result (ref), PriceInRobux (ref), renderBannerPanel (copy), renderTimer (copy), renderPetOdds (copy), renderPity (copy), renderSlots (copy), TextLabel (ref), Remotes (copy), ScrambleTradeIn (copy), ScrambleLeaveTimer (copy), Tabs (copy), v15 (copy)
            while true do
                task.wait(1)

                if ScrambleLeaveTimer.IsExpired() and Tabs.IsActive("DrScrambleTradeIn") then
                    Tabs.Deactivate({
                        instant = true
                    })
                end

                if v16.Enabled then
                    renderTimer()

                    local v195 = ScrambleTradeIn.CurrentBannerId()

                    if result and result.BannerId ~= v195 then
                        task.spawn(function() -- line: 792
                            -- upvalues: result (ref), PriceInRobux (ref), renderBannerPanel (copy), renderTimer (copy), renderPetOdds (copy), renderPity (copy), renderSlots (copy), TextLabel (ref), Remotes (copy), v15 (copy)
                            local function v196() -- line: 793
                                -- upvalues: Remotes (copy)
                                return Remotes.ScrambleTradeIn.AskState:InvokeServer()
                            end

                            local ok, result2 = pcall(v196)

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
                                local v197 = result.FreeRefreshesRemaining or 0

                                if v197 > 0 then
                                    TextLabel.Text = ("REROLL (%* free)"):format(v197)
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

        v168 = function() -- line: 1128
            -- upvalues: v18 (copy), fetchState (copy), Save (copy)
            v18:Add(Save.WatchFields("Rift", fetchState))
        end

        pcall(v168)
        task.spawn(function() -- line: 792
            -- upvalues: result (ref), PriceInRobux (ref), renderBannerPanel (copy), renderTimer (copy), renderPetOdds (copy), renderPity (copy), renderSlots (copy), TextLabel (ref), Remotes (copy), v15 (copy)
            local function v198() -- line: 793
                -- upvalues: Remotes (copy)
                return Remotes.ScrambleTradeIn.AskState:InvokeServer()
            end

            local ok, result2 = pcall(v198)

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
                local v199 = result.FreeRefreshesRemaining or 0

                if v199 > 0 then
                    TextLabel.Text = ("REROLL (%* free)"):format(v199)
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
