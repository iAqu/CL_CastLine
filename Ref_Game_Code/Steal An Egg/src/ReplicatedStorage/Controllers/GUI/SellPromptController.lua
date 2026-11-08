-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Assets = require(ReplicatedStorage.Data.Assets)
local AssetEarnings = require(ReplicatedStorage.Shared.Util.AssetEarnings)

require(ReplicatedStorage.Shared.Types.AssetItem)

local AssetIconShape = require(ReplicatedStorage.Client.UI.AssetIconShape)
local AssetItems = require(ReplicatedStorage.Shared.Util.AssetItems)
local Audio = require(ReplicatedStorage.Shared.Audio)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local EggRecords = require(ReplicatedStorage.Shared.Util.EggRecords)
local GUI = require(ReplicatedStorage.Client.GUI)
local Message = require(ReplicatedStorage.Client.Message)
local Numbers = require(ReplicatedStorage.Shared.Utils.Numbers)
local PlatformController = require(ReplicatedStorage.Client.PlatformController)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local SellPayout = require(ReplicatedStorage.Client.UI.VFX.SellPayout)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Timer = require(ReplicatedStorage.Packages.Timer)
local ToolGameplayGuard = require(ReplicatedStorage.Client.ToolGameplayGuard)
local Trove = require(ReplicatedStorage.Packages.Trove)
local TryCall = require(ReplicatedStorage.Shared.Utils.TryCall)

return {
    Start = function() -- Start | line: 37
        -- upvalues: Players (copy), RunService (copy), TextService (copy), TweenService (copy), UserInputService (copy), Workspace (copy), Assets (copy), AssetEarnings (copy), AssetIconShape (copy), AssetItems (copy), Audio (copy), ButtonFX (copy), EggRecords (copy), GUI (copy), Message (copy), Numbers (copy), PlatformController (copy), Remotes (copy), Save (copy), SellPayout (copy), Simple (copy), Tabs (copy), Timer (copy), ToolGameplayGuard (copy), Trove (copy), TryCall (copy)
        local t2 = {
            Calculate = function(p1, p2, p3, p4, p5, p6, p7, p8) -- Calculate | line: 52
                local v2 = math.max(1, p4 + p6)
                local v4 = math.max(1, p5 + p7)
                local v7 = math.max(1, (math.floor((p2 + p6) / v2)))
                local v10 = math.max(0, math.ceil(p1 / v7) * v4 - p7)
                local v13 = math.clamp(p8, 0, (math.max(0, v10 - p3)))
                local v15 = math.floor(v13 / v4)
                local v18 = math.max(v15, math.ceil((v13 + p3) / v4) - 1)

                return {
                    Columns = v7,
                    First = if p1 == 0 then 1 else math.max(0, v15 - 1) * v7 + 1,
                    Last = math.min(p1, (v18 + 2) * v7),
                    VisibleFirst = v15 * v7 + 1,
                    VisibleLast = math.min(p1, (v18 + 1) * v7),
                    CanvasHeight = v10,
                    ScrollY = v13
                }
            end
        }
        local v22 = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local v23 = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        local v24 = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local v25 = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        local v26 = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local v27 = TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local v28 = UDim2.fromScale(0.72, 0.85)
        local v29 = UDim2.fromScale(0.31, 0.54)
        local v30 = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local v31 = TweenInfo.new(0.098, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local v32 = TweenInfo.new(0.18200000000000002, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
        local v33 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local v34 = Color3.fromRGB(190, 255, 180)
        local v35 = Color3.fromRGB(120, 120, 140)
        local v36 = Color3.fromRGB(4, 4, 4)
        local v37 = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 255, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(136, 255, 0))
        })
        local v38 = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(96, 96, 116)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(64, 64, 82))
        })
        local t4 = {
            Eggs = "Sell Eggs",
            Pets = "Sell Pets"
        }
        local v39 = Color3.fromRGB(255, 170, 0):ToHex()
        local v40 = Color3.fromRGB(0, 255, 8):ToHex()
        local t5 = {
            Eggs = "rbxassetid://103094823152347",
            Pets = "rbxassetid://83736894896123"
        }
        local LocalPlayer = Players.LocalPlayer
        local v41 = GUI.SellPrompt()
        local Frame = v41:FindFirstChild("Frame")

        assert(Frame, "SellPrompt.Frame is missing")

        local Header, ScrollingFrame = Frame.Header, Frame.ScrollingFrame
        local UIGridLayout = ScrollingFrame:FindFirstChildOfClass("UIGridLayout")
        local TemplateHolder = ScrollingFrame.TemplateHolder
        local SortByHolder, SellInfoHolder, TabButtonHolder = Frame.SortByHolder, Frame.SellInfoHolder, Frame.TabButtonHolder
        local Backdrop = v41:FindFirstChild("Backdrop")
        local Sell = SellInfoHolder.Sell
        local Weight, Value, SelectAll, Clear = SortByHolder.Weight, SortByHolder.Value, SortByHolder.SelectAll, SortByHolder.Clear
        local PetsTab, EggsTab = TabButtonHolder.PetsTab, TabButtonHolder.EggsTab
        local v42 = Trove.new()
        local v43 = Trove.new()
        local v44 = Trove.new()
        local t6 = {}
        local t7 = {}
        local t8 = {}
        local t9 = {}
        local v45 = "Pets"
        local v46 = "Value"
        local v47 = true
        local v48 = {}
        local t10 = {}
        local t11 = {}
        local t12 = {}
        local v49 = false
        local n1 = 0
        local v50 = false
        local n2 = 0
        local tween = nil
        local NumberValue
        local t13 = {
            Selling = false,
            Confirming = false
        }
        local n3 = 0
        local n4 = 0
        local n5 = 0
        local v51 = false
        local VisibleLast
        local t14 = {}
        local v52 = false
        local n6 = 0
        local v53 = false
        local n7 = 0
        local Size = Frame.Size
        local CellSize = UIGridLayout.CellSize
        local t15 = {}
        local Frame2 = Instance.new("Frame")

        Frame2.Name = "VisibleCards"
        Frame2.BackgroundTransparency = 1
        Frame2.BorderSizePixel = 0
        Frame2.ClipsDescendants = false
        Frame2.Parent = ScrollingFrame
        UIGridLayout.Parent = nil
        ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.None
        ScrollingFrame.ClipsDescendants = true
        v42:Add(UIGridLayout)
        v42:Add(Frame2)

        local function money(p9) -- line: 257
            -- upvalues: Numbers (copy), Simple (copy)
            if p9 > 99999 then
                return "$" .. Simple.FormatCompact(math.round(p9), ".#")
            end

            return "$" .. Numbers.AddCommas((math.round(p9)))
        end

        local function captionOf(p10) -- line: 264
            return p10:FindFirstChildWhichIsA("TextLabel")
        end

        local function namedScale(p11, p12) -- line: 268
            local v54 = p11:FindFirstChild(p12)

            if v54 and v54:IsA("UIScale") then
                return v54
            end

            local UIScale = Instance.new("UIScale")

            UIScale.Name = p12
            UIScale.Parent = p11

            return UIScale
        end

        local function captureFade(p13, p14) -- line: 280
            local t16 = {}
            local t17 = {}

            for _, v55 in ipairs(p14 or {}) do
                t17[v55] = true
            end

            local function add(p15, p16) -- line: 287
                -- upvalues: t16 (copy)
                local v56 = p15[p16]

                if typeof(v56) == "number" then
                    table.insert(t16, {
                        Host = p15,
                        Property = p16,
                        Base = v56
                    })
                end
            end

            local function walk(p17) -- line: 294
                -- upvalues: p13 (copy), t16 (copy), t17 (copy), walk (copy)
                if p17 ~= p13 and t17[p17] then
                    return
                end

                if p17:IsA("CanvasGroup") then
                    local GroupTransparency = p17.GroupTransparency

                    if typeof(GroupTransparency) == "number" then
                        table.insert(t16, {
                            Property = "GroupTransparency",
                            Host = p17,
                            Base = GroupTransparency
                        })
                    end
                else
                    if p17:IsA("GuiObject") then
                        local BackgroundTransparency = p17.BackgroundTransparency

                        if typeof(BackgroundTransparency) == "number" then
                            table.insert(t16, {
                                Property = "BackgroundTransparency",
                                Host = p17,
                                Base = BackgroundTransparency
                            })
                        end

                        if p17:IsA("TextLabel") or p17:IsA("TextButton") or p17:IsA("TextBox") then
                            local TextTransparency = p17.TextTransparency

                            if typeof(TextTransparency) == "number" then
                                table.insert(t16, {
                                    Property = "TextTransparency",
                                    Host = p17,
                                    Base = TextTransparency
                                })
                            end

                            local TextStrokeTransparency = p17.TextStrokeTransparency

                            if typeof(TextStrokeTransparency) == "number" then
                                table.insert(t16, {
                                    Property = "TextStrokeTransparency",
                                    Host = p17,
                                    Base = TextStrokeTransparency
                                })
                            end
                        end

                        if p17:IsA("ImageLabel") or p17:IsA("ImageButton") then
                            local ImageTransparency = p17.ImageTransparency

                            if typeof(ImageTransparency) == "number" then
                                table.insert(t16, {
                                    Property = "ImageTransparency",
                                    Host = p17,
                                    Base = ImageTransparency
                                })
                            end
                        end
                    elseif not p17:IsA("LuaSourceContainer") then
                        local function v57() -- line: 318
                            -- upvalues: p17 (copy)
                            return p17.Transparency
                        end

                        local ok, result = pcall(v57)

                        if ok and typeof(result) == "number" then
                            local Transparency = p17.Transparency

                            if typeof(Transparency) == "number" then
                                table.insert(t16, {
                                    Property = "Transparency",
                                    Host = p17,
                                    Base = Transparency
                                })
                            end
                        end
                    end

                    for _, child in ipairs(p17:GetChildren()) do
                        walk(child)
                    end
                end
            end

            walk(p13)

            return t16
        end

        local function setFade(p18, p19) -- line: 333
            local v58 = 1 - math.clamp(p19, 0, 1)

            for _, v59 in ipairs(p18) do
                v59.Host[v59.Property] = v59.Base + (1 - v59.Base) * v58
            end
        end

        local function fadeIn(p20, p21, p22, p23) -- line: 340
            -- upvalues: setFade (copy), TweenService (copy)
            setFade(p20, 0)

            local NumberValue = Instance.new("NumberValue")
            local connection = NumberValue.Changed:Connect(function(p24) -- line: 344
                -- upvalues: p20 (copy), setFade (copy)
                setFade(p20, p24)
            end)
            local tween = TweenService:Create(NumberValue, TweenInfo.new(p21.Time, p21.EasingStyle, p21.EasingDirection, p21.RepeatCount, p21.Reverses, p21.DelayTime + (p22 or 0)), {
                Value = 1
            })

            tween:Play()

            local connection2 = tween.Completed:Once(function() -- line: 354
                -- upvalues: p20 (copy), NumberValue (copy), connection (copy), setFade (copy)
                connection:Disconnect()
                setFade(p20, 1)
                NumberValue:Destroy()
            end)

            if p23 then
                p23:Add(function() -- line: 360
                    -- upvalues: p20 (copy), NumberValue (copy), connection (copy), tween (copy), connection2 (copy), setFade (copy)
                    connection2:Disconnect()
                    connection:Disconnect()
                    tween:Cancel()
                    tween:Destroy()
                    setFade(p20, 1)
                    NumberValue:Destroy()
                end)
            end

            return tween
        end

        local function fadeOut(p25, p26, p27, p28) -- line: 372
            -- upvalues: setFade (copy), TweenService (copy)
            local NumberValue = Instance.new("NumberValue")

            NumberValue.Value = 1

            local connection = NumberValue.Changed:Connect(function(p29) -- line: 375
                -- upvalues: p25 (copy), setFade (copy)
                setFade(p25, p29)
            end)
            local tween = TweenService:Create(NumberValue, TweenInfo.new(p26.Time, p26.EasingStyle, p26.EasingDirection, p26.RepeatCount, p26.Reverses, p26.DelayTime + (p27 or 0)), {
                Value = 0
            })

            tween:Play()

            if p28 then
                p28:Add(function() -- line: 386
                    -- upvalues: NumberValue (copy), connection (copy), tween (copy)
                    connection:Disconnect()
                    tween:Cancel()
                    tween:Destroy()
                    NumberValue:Destroy()
                end)
            end

            tween.Completed:Once(function() -- line: 393
                -- upvalues: NumberValue (copy), connection (copy)
                connection:Disconnect()
                NumberValue:Destroy()
            end)

            return tween
        end

        local function paintButton(p30, p31) -- line: 400
            -- upvalues: v24 (copy), v34 (copy), v35 (copy), v36 (copy), v37 (copy), v38 (copy), TweenService (copy)
            local UIGradient = p30:FindFirstChildOfClass("UIGradient")

            if UIGradient then
                if p31 then
                    UIGradient.Color = v37
                else
                    UIGradient.Color = v38
                end
            end

            local UIStrokeClr = p30:FindFirstChild("UIStrokeClr")

            if UIStrokeClr and UIStrokeClr:IsA("UIStroke") then
                TweenService:Create(UIStrokeClr, v24, {
                    Color = if p31 then v34 else v35
                }):Play()
            end

            local UIStroke = p30:FindFirstChild("UIStroke")

            if UIStroke and UIStroke:IsA("UIStroke") then
                local RimRestColor = UIStroke:GetAttribute("RimRestColor")

                if typeof(RimRestColor) ~= "Color3" then
                    RimRestColor = UIStroke.Color
                    UIStroke:SetAttribute("RimRestColor", RimRestColor)
                end

                if not p31 then
                    RimRestColor = v36
                end

                TweenService:Create(UIStroke, v24, {
                    Color = RimRestColor
                }):Play()
            end
        end

        local function twitch(p32, p33) -- line: 422
            -- upvalues: v30 (copy), v31 (copy), v32 (copy), TweenService (copy)
            if p32 == nil then
                return
            end

            local Twitch = p32:FindFirstChild("Twitch")

            if not (Twitch and Twitch:IsA("UIScale")) then
                Twitch = Instance.new("UIScale")
                Twitch.Name = "Twitch"
                Twitch.Parent = p32
            end

            local TwitchRotation = p32:GetAttribute("TwitchRotation")

            if typeof(TwitchRotation) ~= "number" then
                TwitchRotation = p32.Rotation
                p32:SetAttribute("TwitchRotation", TwitchRotation)
            end

            Twitch.Scale = 1.22
            p32.Rotation = TwitchRotation + p33
            TweenService:Create(Twitch, v30, {
                Scale = 1
            }):Play()

            local tween = TweenService:Create(p32, v31, {
                Rotation = TwitchRotation - p33 * 0.45
            })

            tween:Play()
            tween.Completed:Once(function(p34) -- line: 442
                -- upvalues: p32 (copy), TwitchRotation (ref), v32 (copy), TweenService (copy)
                if p34 == Enum.PlaybackState.Completed then
                    TweenService:Create(p32, v32, {
                        Rotation = TwitchRotation
                    }):Play()
                end
            end)
        end

        local function paintTab(p35, p36) -- line: 450
            -- upvalues: v24 (copy), paintButton (copy), TweenService (copy)
            paintButton(p35, p36)

            local TabSelect = p35:FindFirstChild("TabSelect")

            if not (TabSelect and TabSelect:IsA("UIScale")) then
                TabSelect = Instance.new("UIScale")
                TabSelect.Name = "TabSelect"
                TabSelect.Parent = p35
            end

            TweenService:Create(TabSelect, v24, {
                Scale = p36 and 1.05 or 1
            }):Play()
        end

        local function collectionCheckpoint(p37, p38) -- line: 459
            -- upvalues: v41 (copy), n5 (ref)
            local v60 = p38

            if p38 <= os.clock() then
                task.wait()
                v60 = os.clock() + 0.002
            end

            return p37 == n5 and v41.Enabled, v60
        end

        local function petValue(p39) -- line: 467
            -- upvalues: LocalPlayer (copy), AssetItems (copy)
            local v61 = AssetItems.SalePrice(p39)

            if LocalPlayer:GetAttribute("VIP") then
                v61 *= 2
            end

            return v61
        end

        local function collectPets(p40) -- line: 475
            -- upvalues: LocalPlayer (copy), v41 (copy), n5 (ref), Assets (copy), AssetEarnings (copy), AssetItems (copy), Save (copy), TryCall (copy)
            local t28 = {}
            local v62 = Save.Await()

            if p40 ~= n5 or not v41.Enabled then
                return nil
            end

            if v62 ~= nil then
                local Inventory = v62.Inventory

                if Inventory ~= nil then
                    local t29 = {}

                    for _, v63 in ipairs(v62.EquippedAssets) do
                        t29[v63] = true
                    end

                    local v64 = os.clock() + 0.002

                    for v65, v66 in pairs(Inventory) do
                        if v64 <= os.clock() then
                            task.wait()
                            v64 = os.clock() + 0.002
                        end

                        if p40 ~= n5 or not v41.Enabled then
                            return nil
                        end

                        local v67, v68 = TryCall(AssetItems.Decode, v66)

                        if v67 and v68.IsFavorite ~= true and v68.InFuse ~= true and not t29[v65] and Assets.AssetNameExists(v68.Category) then
                            local t30 = {
                                Kind = "Pets",
                                Icon = Assets.Directory[v68.Category].Icon or "",
                                ItemData = v68,
                                Rate = AssetEarnings.RatePerSecond(v68),
                                Uid = v65
                            }
                            local v69 = AssetItems.SalePrice(v68)

                            if LocalPlayer:GetAttribute("VIP") then
                                v69 *= 2
                            end

                            t30.Value = v69
                            t30.Weight = AssetItems.WeightKg(v68)
                            t30.WeightLabel = AssetItems.WeightLabel(v68)
                            table.insert(t28, t30)
                        end
                    end
                end
            end

            return t28
        end

        local function collectEggs(p41) -- line: 525
            -- upvalues: v41 (copy), n5 (ref), Assets (copy), AssetEarnings (copy), EggRecords (copy), Save (copy), TryCall (copy)
            local t31 = {}
            local v70 = Save.Await()

            if p41 ~= n5 or not v41.Enabled then
                return nil
            end

            local v71 = v70 and v70.EggInventory

            if v71 ~= nil then
                local v72 = os.clock() + 0.002

                for v73, v74 in pairs(v71) do
                    if v72 <= os.clock() then
                        task.wait()
                        v72 = os.clock() + 0.002
                    end

                    if p41 ~= n5 or not v41.Enabled then
                        return nil
                    end

                    if v74.Placement == nil then
                        local v75, v76 = TryCall(EggRecords.Decode, v74)

                        if v75 then
                            local v77 = Assets.Directory[v76.AssetCategory]

                            if v77 ~= nil then
                                table.insert(t31, {
                                    Kind = "Eggs",
                                    Icon = v77.Egg and v77.Egg.Icon or v77.Icon or "",
                                    Rate = AssetEarnings.RatePerSecond(EggRecords.ToAssetItemData(v76)),
                                    Uid = v73,
                                    Value = EggRecords.SellPrice(v76),
                                    Weight = EggRecords.WeightKg(v76),
                                    WeightLabel = EggRecords.WeightLabel(v76)
                                })
                            end
                        end
                    end
                end
            end

            return t31
        end

        local function sortEntries() -- line: 571
            -- upvalues: v46 (ref), v47 (ref), v48 (ref)
            table.sort(v48, function(p42, p43) -- line: 572
                -- upvalues: v46 (ref), v47 (ref)
                local v78 = if v46 == "Weight" then p42.Weight else p42.Value
                local v79 = if v46 == "Weight" then p43.Weight else p43.Value

                if v78 == v79 then
                    return p42.Uid < p43.Uid
                end

                if v47 then
                    return v79 < v78
                end

                return v78 < v79
            end)
        end

        local function selectionCount() -- line: 582
            -- upvalues: t10 (copy)
            local n8 = 0

            for _ in pairs(t10) do
                n8 += 1
            end

            return n8
        end

        local function popCard(p44, p45) -- line: 590
            -- upvalues: v27 (copy), TweenService (copy)
            local Template = p44:FindFirstChild("Template")

            if Template == nil then
                return
            end

            local SelectPop = Template:FindFirstChild("SelectPop")

            if not (SelectPop and SelectPop:IsA("UIScale")) then
                SelectPop = Instance.new("UIScale")
                SelectPop.Name = "SelectPop"
                SelectPop.Parent = Template
            end

            SelectPop.Scale = p45 and 0.88 or 1.06
            TweenService:Create(SelectPop, v27, {
                Scale = 1
            }):Play()
        end

        local function paintCard(p46, p47, p48) -- line: 601
            -- upvalues: popCard (copy)
            local SelectedOverlay = p46:FindFirstChild("SelectedOverlay")
            local SelectedIcon = p46:FindFirstChild("SelectedIcon")

            if SelectedOverlay and SelectedOverlay:IsA("GuiObject") then
                SelectedOverlay.Visible = p47
            end

            if SelectedIcon and SelectedIcon:IsA("GuiObject") then
                SelectedIcon.Visible = p47
            end

            if p48 then
                popCard(p46, p47)
            end
        end

        local function totalLabel() -- line: 615
            -- upvalues: SellInfoHolder (copy)
            local Value = SellInfoHolder:FindFirstChild("Value")

            return if Value and Value:IsA("TextLabel") then Value else nil
        end

        local function writeTotal(p49) -- line: 623
            -- upvalues: SellInfoHolder (copy), Numbers (copy), Simple (copy)
            local Value = SellInfoHolder:FindFirstChild("Value")

            if not (Value and Value:IsA("TextLabel")) then
                Value = nil
            end

            if Value then
                if p49 > 99999 then
                    Value.Text = "$" .. Simple.FormatCompact(math.round(p49), ".#")
                else
                    Value.Text = "$" .. Numbers.AddCommas((math.round(p49)))
                end
            end
        end

        local function showTotal(p50, p51) -- line: 641
            -- upvalues: v25 (copy), SellInfoHolder (copy), n2 (ref), tween (ref), NumberValue (ref), writeTotal (copy), TweenService (copy), Numbers (copy), Simple (copy)
            if p51 then
                if tween then
                    tween:Cancel()
                    tween = nil
                end

                if NumberValue then
                    NumberValue:Destroy()
                    NumberValue = nil
                end

                n2 = p50

                local Value = SellInfoHolder:FindFirstChild("Value")

                if not (Value and Value:IsA("TextLabel")) then
                    Value = nil
                end

                if Value then
                    if p50 > 99999 then
                        Value.Text = "$" .. Simple.FormatCompact(math.round(p50), ".#")
                    else
                        Value.Text = "$" .. Numbers.AddCommas((math.round(p50)))
                    end
                end
            elseif math.round(p50) ~= math.round(n2) then
                local v82 = if NumberValue then NumberValue.Value else n2

                if tween then
                    tween:Cancel()
                    tween = nil
                end

                if NumberValue then
                    NumberValue:Destroy()
                    NumberValue = nil
                end

                n2 = p50

                local NumberValue2 = Instance.new("NumberValue")

                NumberValue2.Value = v82
                NumberValue = NumberValue2

                local Value = SellInfoHolder:FindFirstChild("Value")

                if not (Value and Value:IsA("TextLabel")) then
                    Value = nil
                end

                if Value then
                    if v82 > 99999 then
                        Value.Text = "$" .. Simple.FormatCompact(math.round(v82), ".#")
                    else
                        Value.Text = "$" .. Numbers.AddCommas((math.round(v82)))
                    end
                end

                NumberValue2.Changed:Connect(writeTotal)

                local tween2 = TweenService:Create(NumberValue2, v25, {
                    Value = p50
                })

                tween2:Play()
                tween = tween2
                tween2.Completed:Once(function(p52) -- line: 666
                    -- upvalues: p50 (copy), NumberValue2 (copy), tween2 (copy), SellInfoHolder (copy), tween (ref), NumberValue (ref), Numbers (copy), Simple (copy)
                    if tween ~= tween2 then
                        return
                    end

                    tween = nil
                    NumberValue = nil

                    if p52 == Enum.PlaybackState.Completed then
                        local Value = SellInfoHolder:FindFirstChild("Value")

                        if not Value or not Value:IsA("TextLabel") then
                            Value = nil
                        end

                        if Value then
                            if p50 > 99999 then
                                Value.Text = "$" .. Simple.FormatCompact(math.round(p50), ".#")
                            else
                                Value.Text = "$" .. Numbers.AddCommas((math.round(p50)))
                            end
                        end
                    end

                    NumberValue2:Destroy()
                end)
            end
        end

        local function setSellEnabled(p53) -- line: 679
            -- upvalues: Sell (copy), paintButton (copy)
            Sell.Active = p53
            Sell.AutoButtonColor = p53
            paintButton(Sell, p53)
        end

        local function refreshFooter() -- line: 685
            -- upvalues: Sell (copy), SelectAll (copy), Clear (copy), v48 (ref), t10 (copy), v50 (ref), t13 (copy), paintButton (copy), showTotal (copy)
            local n9 = 0
            local n10 = 0

            for _, v83 in ipairs(v48) do
                if t10[v83.Uid] then
                    n9 += 1
                    n10 += v83.Value
                end
            end

            local v84 = #v48 > 0 and n9 == #v48
            local TextLabel = Sell:FindFirstChildWhichIsA("TextLabel")

            if TextLabel then
                if n9 == 0 then
                    TextLabel.Text = "Sell"
                elseif v84 then
                    TextLabel.Text = "Sell All"
                else
                    TextLabel.Text = ("Sell (%*)"):format(n9)
                end
            end

            local v85 = n9 > 0 and not v50 and not t13.Selling

            Sell.Active = v85
            Sell.AutoButtonColor = v85
            paintButton(Sell, v85)
            showTotal(n10)
            SelectAll.Visible = not v84
            Clear.Visible = v84
        end

        local function setEverySelected(p54) -- line: 712
            -- upvalues: t6 (copy), v48 (ref), t10 (copy), t11 (copy), v50 (ref), t13 (copy), paintCard (copy), refreshFooter (copy)
            if #v48 ~= 0 and not v50 and not t13.Selling and not t13.Confirming then
                local n11 = 0

                for _, v86 in ipairs(v48) do
                    t10[v86.Uid] = if p54 then true else nil

                    local v88 = t11[v86.Uid]

                    if v88 ~= nil then
                        local v89 = t6[v86.Uid]

                        n11 += 1
                        v89:Add(task.delay((n11 - 1) * 0.012, function() -- line: 727
                            -- upvalues: v86 (copy), v88 (copy), t10 (copy), paintCard (copy)
                            if v88.Parent then
                                paintCard(v88, t10[v86.Uid] == true, true)
                            end
                        end))
                    end
                end

                refreshFooter()
            end
        end

        local function revealPanel() -- line: 737
            -- upvalues: v26 (copy), Frame (copy), ScrollingFrame (copy), v43 (copy), captureFade (copy), fadeIn (copy)
            v43:Clean()
            fadeIn(captureFade(Frame, { ScrollingFrame }), v26, nil, v43)
        end

        local function showBackdrop(p55) -- line: 742
            -- upvalues: Backdrop (copy)
            if Backdrop ~= nil then
                Backdrop.BackgroundTransparency = 1
                Backdrop.Visible = p55
            end
        end

        local function labelScale(p56) -- line: 752
            -- upvalues: v41 (copy)
            local v92 = 1
            local Parent = p56.Parent

            while Parent and Parent ~= v41 do
                local UIScale = Parent:FindFirstChildOfClass("UIScale")

                v92 = if UIScale then v92 * UIScale.Scale else v92
                Parent = Parent.Parent
            end

            if v92 > 0 then
                return v92
            end

            return 1
        end

        local function widthPerPoint(p57, p58) -- line: 765
            -- upvalues: t14 (copy), v53 (ref), TextService (copy)
            local FontFace = p57.FontFace
            local v93 = ("%*|%*|%*|%*|%*"):format(FontFace.Family, FontFace.Weight.Name, FontFace.Style.Name, p57.RichText, p58)
            local v94 = t14[v93]

            if v94 then
                return v94
            end

            local GetTextBoundsParams = Instance.new("GetTextBoundsParams")

            GetTextBoundsParams.Text = p58
            GetTextBoundsParams.Font = FontFace
            GetTextBoundsParams.Size = 100
            GetTextBoundsParams.RichText = p57.RichText

            local function v95() -- line: 779
                -- upvalues: GetTextBoundsParams (copy), TextService (copy)
                return TextService:GetTextBoundsAsync(GetTextBoundsParams)
            end

            local ok, result = pcall(v95)

            GetTextBoundsParams:Destroy()

            if ok and result ~= nil and not (result.X <= 0) then
                local v96 = result.X / 100

                t14[v93] = v96

                return v96
            end

            v53 = true

            return 0.55 * (utf8.len(p58) or #p58)
        end

        local function fitSize(p59) -- line: 793
            -- upvalues: labelScale (copy), widthPerPoint (copy)
            table.sort(p59, function(p60, p61) -- line: 794
                return #p60.Text > #p61.Text
            end)

            local n12 = 1e999
            local n13 = 0

            for _, v97 in ipairs(p59) do
                local Label = v97.Label

                if Label.Parent ~= nil then
                    local v98 = Label.AbsoluteSize / labelScale(Label)

                    if not (v98.X <= 0 or v98.Y <= 0) then
                        n12 = math.min(n12, v98.Y)

                        if n13 < 3 then
                            local v99 = widthPerPoint(Label, v97.Text)

                            if v99 > 0 then
                                n13 += 1
                                n12 = math.min(n12, v98.X / v99)
                            end
                        end
                    end
                end
            end

            if n12 == 1e999 then
                return 0
            end

            return n12
        end

        local function refitLabels(p62) -- line: 826
            -- upvalues: v41 (copy), Weight (copy), Value (copy), SelectAll (copy), Clear (copy), n5 (ref), t15 (copy), fitSize (copy)
            if v41.Enabled then
                local t33 = {
                    Sort = {}
                }

                for _, v101 in ipairs({ Weight, Value, SelectAll, Clear }) do
                    local TextLabel = v101:FindFirstChildWhichIsA("TextLabel")

                    if TextLabel then
                        table.insert(t33.Sort, {
                            Label = TextLabel,
                            Text = TextLabel.Text
                        })
                    end
                end

                for _, v102 in pairs(t15) do
                    for _, v103 in ipairs(v102) do
                        local v104 = t33[v103.Role]

                        if v104 == nil then
                            v104 = {}
                            t33[v103.Role] = v104
                        end

                        table.insert(v104, {
                            Label = v103.Label,
                            Text = v103.Text
                        })
                    end
                end

                for _, v105 in pairs(t33) do
                    local v107 = math.floor((fitSize(v105)))

                    if p62 ~= n5 or not v41.Enabled then
                        return
                    end

                    if not (v107 <= 0) then
                        local v108 = math.max(v107, 6)

                        for _, v109 in ipairs(v105) do
                            local Label = v109.Label

                            if Label.Parent ~= nil then
                                local FitLimit = Label:FindFirstChild("FitLimit")

                                if FitLimit == nil or not FitLimit:IsA("UITextSizeConstraint") then
                                    FitLimit = Instance.new("UITextSizeConstraint")
                                    FitLimit.Name = "FitLimit"
                                    FitLimit.Parent = Label
                                end

                                FitLimit.MaxTextSize = v108
                                Label.TextWrapped = false
                                Label.TextScaled = true
                            end
                        end
                    end
                end
            end
        end

        local function queueRefit() -- line: 882
            -- upvalues: v41 (copy), n5 (ref), v52 (ref), n6 (ref), v53 (ref), n7 (ref), refitLabels (copy), queueRefit (copy), RunService (copy)
            n6 += 1

            if not v52 then
                v52 = true
                task.defer(function() -- line: 889
                    -- upvalues: v41 (copy), n5 (ref), v52 (ref), n6 (ref), v53 (ref), n7 (ref), refitLabels (copy), queueRefit (copy), RunService (copy)
                    RunService.PreRender:Wait()

                    local v110 = n5
                    local v111 = n6

                    v53 = false
                    refitLabels(v110)
                    v52 = false

                    if v110 ~= n5 or not v41.Enabled then
                        return
                    end

                    if v111 ~= n6 then
                        queueRefit()
                    end

                    if not (v53 and n7 < 5) then
                        return
                    end

                    n7 += 1
                    task.delay(0.4, function() -- line: 904
                        -- upvalues: v110 (copy), v41 (copy), n5 (ref), queueRefit (copy)
                        if v110 == n5 and v41.Enabled then
                            queueRefit()
                        end
                    end)
                end)
            end
        end

        local function isPhone() -- line: 913
            -- upvalues: v41 (copy), UserInputService (copy), Workspace (copy), PlatformController (copy)
            local v112 = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

            if not PlatformController.IsMobile() and not v112 then
                return false
            end

            local AbsoluteSize = v41.AbsoluteSize

            if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
                local CurrentCamera = Workspace.CurrentCamera

                if CurrentCamera then
                    AbsoluteSize = CurrentCamera.ViewportSize
                end
            end

            local v113 = math.min(AbsoluteSize.X, AbsoluteSize.Y)

            if v113 <= 0 then
                return false
            end

            if v113 <= 550 then
                return true
            end

            return math.max(AbsoluteSize.X, AbsoluteSize.Y) / v113 >= 1.7
        end

        local function applyPlatformLayout() -- line: 935
            -- upvalues: v28 (copy), v29 (copy), v41 (copy), Frame (copy), UIGridLayout (copy), n5 (ref), v52 (ref), n6 (ref), v53 (ref), n7 (ref), Size (copy), CellSize (copy), refitLabels (copy), queueRefit (copy), isPhone (copy), RunService (copy)
            local v114 = isPhone()

            Frame.Size = if v114 then v28 else Size
            UIGridLayout.CellSize = if v114 then v29 else CellSize
            n6 += 1

            if not v52 then
                v52 = true
                task.defer(function() -- line: 889
                    -- upvalues: v41 (copy), n5 (ref), v52 (ref), n6 (ref), v53 (ref), n7 (ref), refitLabels (copy), queueRefit (copy), RunService (copy)
                    RunService.PreRender:Wait()

                    local v117 = n5
                    local v118 = n6

                    v53 = false
                    refitLabels(v117)
                    v52 = false

                    if v117 ~= n5 or not v41.Enabled then
                        return
                    end

                    if v118 ~= n6 then
                        queueRefit()
                    end

                    if not (v53 and n7 < 5) then
                        return
                    end

                    n7 += 1
                    task.delay(0.4, function() -- line: 904
                        -- upvalues: v41 (copy), n5 (ref), queueRefit (copy), v117 (copy)
                        if v117 == n5 and v41.Enabled then
                            queueRefit()
                        end
                    end)
                end)
            end
        end

        local function rollLabel(p63, p64, p65, p66, p67, p68) -- line: 942
            -- upvalues: v23 (copy), TweenService (copy)
            local NumberValue = Instance.new("NumberValue")

            NumberValue.Value = 0
            p63.Text = p65(0)

            local connection = NumberValue.Changed:Connect(function(p69) -- line: 954
                -- upvalues: p63 (copy), p65 (copy)
                p63.Text = p65(p69)
            end)

            p68:Add(connection)
            p68:Add(NumberValue)

            local tween = TweenService:Create(NumberValue, TweenInfo.new(v23.Time, v23.EasingStyle, v23.EasingDirection, 0, false, p67), {
                Value = p64
            })

            tween:Play()
            p68:Add(function() -- line: 966
                -- upvalues: tween (copy)
                tween:Cancel()
                tween:Destroy()
            end)
            p68:Add(tween.Completed:Once(function(p70) -- line: 967
                -- upvalues: p63 (copy), p66 (copy), NumberValue (copy), connection (copy)
                connection:Disconnect()

                if p70 == Enum.PlaybackState.Completed then
                    p63.Text = p66
                end

                NumberValue:Destroy()
            end))
        end

        local function weightText(p71) -- line: 976
            -- upvalues: Numbers (copy)
            return (("(%*Kg)"):format((Numbers.AddCommas(p71))))
        end

        local function buildCard(p72, p73, p74) -- line: 980
            -- upvalues: v22 (copy), TemplateHolder (copy), t6 (copy), t7 (copy), t8 (copy), t9 (copy), t10 (copy), t11 (copy), t12 (copy), v50 (ref), t13 (copy), n3 (ref), n4 (ref), t15 (copy), Frame2 (copy), money (copy), captureFade (copy), fadeIn (copy), paintCard (copy), refreshFooter (copy), rollLabel (copy), weightText (copy), TweenService (copy), AssetIconShape (copy), Audio (copy), ButtonFX (copy), Numbers (copy), Simple (copy), Trove (copy)
            local v119 = Trove.new()

            t6[p72.Uid] = v119

            local v120 = Trove.new()

            v119:Add(v120)

            if p74 then
                t7[p72.Uid] = v120
            end

            local t36 = {}

            t15[p72.Uid] = t36

            local v121 = table.remove(t8) or TemplateHolder:Clone()

            v121.Name = p72.Uid
            v121.LayoutOrder = p73
            v121.Visible = true

            local RevealScale = v121:FindFirstChild("RevealScale")

            if RevealScale and RevealScale:IsA("UIScale") then
                RevealScale.Scale = 1
            end

            local v123 = math.min((p73 - 1) * 0.03, 0.7)
            local v125 = n3
            local v126 = math.min(v125 + (p73 - 1) * 0.03, 0.7)
            local Template = v121:FindFirstChild("Template")

            if Template then
                local Icon = Template:FindFirstChild("Icon")

                if Icon and Icon:IsA("ImageLabel") then
                    Icon.Image = p72.Icon

                    if p72.ItemData ~= nil then
                        AssetIconShape.Paint(Icon, p72.ItemData)
                    else
                        AssetIconShape.Strip(Icon)
                    end
                end

                local Weight = Template:FindFirstChild("Weight")

                if Weight and Weight:IsA("TextLabel") then
                    local v127 = ("(%*)"):format(p72.WeightLabel)

                    table.insert(t36, {
                        Role = "Weight",
                        Label = Weight,
                        Text = v127
                    })

                    if p74 then
                        rollLabel(Weight, p72.Weight, weightText, v127, v123, v120)
                    else
                        Weight.Text = v127
                    end
                end

                local Amount = Template:FindFirstChild("Amount")

                if Amount and Amount:IsA("TextLabel") then
                    local Rate = p72.Rate
                    local v128 = ("%*/s"):format(if Rate > 99999 then "$" .. Simple.FormatCompact(math.round(Rate), ".#") else "$" .. Numbers.AddCommas((math.round(Rate))))

                    table.insert(t36, {
                        Role = "Amount",
                        Label = Amount,
                        Text = v128
                    })

                    if p74 then
                        rollLabel(Amount, p72.Rate, function(p75) -- line: 1034
                            -- upvalues: Numbers (copy), Simple (copy)
                            return (("%*/s"):format(if p75 > 99999 then "$" .. Simple.FormatCompact(math.round(p75), ".#") else "$" .. Numbers.AddCommas((math.round(p75)))))
                        end, v128, v123, v120)
                    else
                        Amount.Text = v128
                    end
                end

                local ValueHolder = Template:FindFirstChild("ValueHolder")
                local Value = ValueHolder and ValueHolder:FindFirstChild("Value")

                if Value and Value:IsA("TextLabel") then
                    local Value2 = p72.Value
                    local v129 = if Value2 > 99999 then "$" .. Simple.FormatCompact(math.round(Value2), ".#") else "$" .. Numbers.AddCommas((math.round(Value2)))

                    table.insert(t36, {
                        Role = "Value",
                        Label = Value,
                        Text = v129
                    })

                    if p74 then
                        rollLabel(Value, p72.Value, money, v129, v123, v120)
                    else
                        Value.Text = v129
                    end
                end
            end

            local v130 = t10[p72.Uid] == true
            local SelectedOverlay = v121:FindFirstChild("SelectedOverlay")
            local SelectedIcon = v121:FindFirstChild("SelectedIcon")

            if SelectedOverlay and SelectedOverlay:IsA("GuiObject") then
                SelectedOverlay.Visible = v130
            end

            if SelectedIcon and SelectedIcon:IsA("GuiObject") then
                SelectedIcon.Visible = v130
            end

            if t9[v121] == nil then
                local TextButton = Instance.new("TextButton")

                TextButton.BackgroundTransparency = 1
                TextButton.Text = ""
                TextButton.Name = "Hitbox"
                TextButton.Size = UDim2.fromScale(1, 1)
                TextButton.ZIndex = 100
                TextButton.Parent = v121
                t9[v121] = ButtonFX(TextButton, 1.06, function() -- line: 1071
                    -- upvalues: v121 (copy), t10 (copy), v50 (ref), t13 (copy), Frame2 (copy), paintCard (copy), refreshFooter (copy)
                    local Name, t40, v131, v132

                    if v50 or t13.Selling or t13.Confirming then
                        v132 = true
                    elseif v121.Parent == Frame2 then
                        Name = v121.Name
                        t40 = t10

                        if not t10[Name] then
                            v131 = true
                        end

                        v132 = false
                    else
                        v132 = true
                    end

                    if v132 then
                        return
                    end

                    t40[Name] = v131
                    paintCard(v121, t10[Name] == true, true)
                    refreshFooter()
                end)
            end

            v121.Parent = Frame2
            t11[p72.Uid] = v121
            t12[p72.Uid] = p72

            if p74 then
                local RevealScale = v121:FindFirstChild("RevealScale")

                if not RevealScale or not RevealScale:IsA("UIScale") then
                    RevealScale = Instance.new("UIScale")
                    RevealScale.Name = "RevealScale"
                    RevealScale.Parent = v121
                end

                RevealScale.Scale = 0.55

                local tween = TweenService:Create(RevealScale, TweenInfo.new(v22.Time, v22.EasingStyle, v22.EasingDirection, 0, false, v126), {
                    Scale = 1
                })

                tween:Play()
                v120:Add(function() -- line: 1094
                    -- upvalues: tween (copy)
                    tween:Cancel()
                    tween:Destroy()
                end)
                fadeIn(captureFade(v121), v22, v126, v120)
            end

            if p74 and n4 < 8 then
                n4 += 1
                v120:Add(task.delay(v126, function() -- line: 1100
                    -- upvalues: v121 (copy), Audio (copy)
                    if v121.Parent ~= nil then
                        Audio.Play("rbxassetid://139800881181209", script, {
                            PlaybackSpeed = 1.55,
                            Volume = 0.11199999999999999
                        })
                    end
                end))
            end

            return v121
        end

        local v133 = false

        local function finishOpeningReveal() -- line: 1115
            -- upvalues: t7 (copy), t11 (copy), v51 (ref), t15 (copy)
            v51 = false

            for v134, v135 in pairs(t7) do
                v135:Clean()

                local v136 = t11[v134]

                if v136 then
                    local RevealScale = v136:FindFirstChild("RevealScale")

                    if not (RevealScale and RevealScale:IsA("UIScale")) then
                        RevealScale = Instance.new("UIScale")
                        RevealScale.Name = "RevealScale"
                        RevealScale.Parent = v136
                    end

                    RevealScale.Scale = 1
                end

                for _, v137 in ipairs(t15[v134] or {}) do
                    v137.Label.Text = v137.Text
                end

                t7[v134] = nil
            end
        end

        local function destroyCard(p76) -- line: 1130
            -- upvalues: t9 (copy)
            local v138 = t9[p76]

            if v138 then
                v138()
                t9[p76] = nil
            end

            p76:Destroy()
        end

        local function removeCard(p77, p78) -- line: 1139
            -- upvalues: t6 (copy), t7 (copy), t8 (copy), t9 (copy), t11 (copy), t12 (copy), t15 (copy)
            local v139 = t11[p77]
            local v140 = t6[p77]

            if v140 then
                v140:Destroy()
                t6[p77] = nil
            end

            if v139 then
                t11[p77] = nil

                if p78 and #t8 < 24 then
                    v139.Parent = nil

                    local Template = v139:FindFirstChild("Template")
                    local SelectPop = Template and Template:FindFirstChild("SelectPop")

                    if SelectPop then
                        SelectPop:Destroy()
                    end

                    table.insert(t8, v139)
                else
                    local v141 = t9[v139]

                    if v141 then
                        v141()
                        t9[v139] = nil
                    end

                    v139:Destroy()
                end
            end

            t15[p77] = nil
            t7[p77] = nil
            t12[p77] = nil
        end

        local function clearCards() -- line: 1164
            -- upvalues: t6 (copy), t7 (copy), t8 (copy), t9 (copy), t11 (copy), t12 (copy), t15 (copy)
            for v142 in pairs(t11) do
                local v143 = t11[v142]
                local v144 = t6[v142]

                if v144 then
                    v144:Destroy()
                    t6[v142] = nil
                end

                if v143 then
                    t11[v142] = nil

                    local v145 = t9[v143]

                    if v145 then
                        v145()
                        t9[v143] = nil
                    end

                    v143:Destroy()
                end

                t15[v142] = nil
                t7[v142] = nil
                t12[v142] = nil
            end

            for _, v146 in ipairs(t8) do
                local v147 = t9[v146]

                if v147 then
                    v147()
                    t9[v146] = nil
                end

                v146:Destroy()
            end

            table.clear(t8)
        end

        local function renderWindow() -- line: 1174
            -- upvalues: t2 (copy), v41 (copy), ScrollingFrame (copy), UIGridLayout (copy), v48 (ref), t11 (copy), v50 (ref), t13 (copy), n3 (ref), n5 (ref), v51 (ref), VisibleLast (ref), v52 (ref), n6 (ref), v53 (ref), n7 (ref), Frame2 (copy), labelScale (copy), refitLabels (copy), queueRefit (copy), buildCard (copy), v133 (ref), removeCard (copy), RunService (copy)
            if v133 and (not v50 or #v48 ~= 0) and not t13.Selling and v41.Enabled then
                local v148 = labelScale(ScrollingFrame)
                local v149 = ScrollingFrame.AbsoluteSize / v148
                local v150 = ScrollingFrame.AbsoluteWindowSize / v148

                if v149.X <= 0 or v149.Y <= 0 or v150.Y <= 0 then
                    return
                end

                local CellSize, CellPadding = UIGridLayout.CellSize, UIGridLayout.CellPadding
                local v151 = v149.X * CellSize.X.Scale + CellSize.X.Offset
                local v152 = v149.Y * CellSize.Y.Scale + CellSize.Y.Offset
                local v153 = v149.X * CellPadding.X.Scale + CellPadding.X.Offset
                local v154 = v149.Y * CellPadding.Y.Scale + CellPadding.Y.Offset
                local v155 = t2.Calculate(#v48, v150.X, v150.Y, v151, v152, v153, v154, ScrollingFrame.CanvasPosition.Y / v148)
                local v156 = UDim2.fromOffset(v149.X, v149.Y)
                local v157 = Frame2.Size ~= v156

                Frame2.Size = v156
                ScrollingFrame.CanvasSize = UDim2.fromOffset(0, v155.CanvasHeight)

                if v51 and VisibleLast == nil then
                    VisibleLast = v155.VisibleLast
                end

                for v158, v159 in pairs(t11) do
                    local LayoutOrder = v159.LayoutOrder

                    if LayoutOrder < v155.First or v155.Last < LayoutOrder then
                        removeCard(v158, true)
                        v157 = true
                    end
                end

                v133 = false

                local v160 = os.clock() + 0.002
                local n14 = 0

                local function mountRange(p79, p80, p81) -- line: 1215
                    -- upvalues: v151 (copy), v152 (copy), v153 (copy), v154 (copy), v155 (copy), v157 (ref), v160 (copy), n14 (ref), v48 (ref), t11 (copy), v51 (ref), VisibleLast (ref), buildCard (copy), v133 (ref)
                    for i = p79, p80 do
                        local v161 = v48[i]
                        local v162 = t11[v161.Uid]
                        local v163, v164

                        if v162 then
                            v163 = v162
                            v164 = false
                        elseif p81 then
                            local v165 = v51 and i <= 24 and i <= (VisibleLast or 0) and p81

                            v163 = buildCard(v161, i, v165)

                            local v166 = n14

                            n14 = v166 + 1
                            v157 = true
                            v164 = false
                        elseif n14 >= 4 or os.clock() >= v160 then
                            v164 = true
                        else
                            local v167 = v51 and i <= 24 and i <= (VisibleLast or 0) and p81

                            v163 = buildCard(v161, i, v167)

                            local v168 = n14

                            n14 = v168 + 1
                            v157 = true
                            v164 = false
                        end

                        if v164 then
                            v133 = true
                        else
                            local v169 = i - 1

                            v163.Size = UDim2.fromOffset(v151, v152)
                            v163.Position = UDim2.fromOffset(v169 % v155.Columns * (v151 + v153), math.floor(v169 / v155.Columns) * (v152 + v154))
                        end
                    end
                end

                mountRange(v155.VisibleFirst, v155.VisibleLast, true)
                mountRange(v155.First, v155.VisibleFirst - 1, false)
                mountRange(v155.VisibleLast + 1, v155.Last, false)

                if not v133 then
                    v51 = false
                    n3 = 0
                end

                if v157 then
                    n6 += 1

                    if not v52 then
                        v52 = true
                        task.defer(function() -- line: 889
                            -- upvalues: v41 (copy), n5 (ref), v52 (ref), n6 (ref), v53 (ref), n7 (ref), refitLabels (copy), queueRefit (copy), RunService (copy)
                            RunService.PreRender:Wait()

                            local v172 = n5
                            local v173 = n6

                            v53 = false
                            refitLabels(v172)
                            v52 = false

                            if v172 ~= n5 or not v41.Enabled then
                                return
                            end

                            if v173 ~= n6 then
                                queueRefit()
                            end

                            if not (v53 and n7 < 5) then
                                return
                            end

                            n7 += 1
                            task.delay(0.4, function() -- line: 904
                                -- upvalues: v41 (copy), n5 (ref), queueRefit (copy), v172 (copy)
                                if v172 == n5 and v41.Enabled then
                                    queueRefit()
                                end
                            end)
                        end)
                    end
                end
            end
        end

        local function sameCardContent(p82, p83) -- line: 1253
            -- upvalues: AssetIconShape (copy)
            if p82.Icon ~= p83.Icon
                or p82.Kind ~= p83.Kind
                or p82.Value ~= p83.Value
                or p82.Rate ~= p83.Rate
                or p82.Weight ~= p83.Weight
                or p82.WeightLabel ~= p83.WeightLabel then
                return false
            end

            local ItemData = p82.ItemData
            local ItemData2 = p83.ItemData

            if ItemData == nil or ItemData2 == nil then
                return ItemData == ItemData2
            end

            local v174 = AssetIconShape.ResolveImages(ItemData)
            local v175 = AssetIconShape.ResolveImages(ItemData2)

            if v174.Icon == v175.Icon then
                return v174.RainbowOverlay == v175.RainbowOverlay
            end

            return false
        end

        local function rebuild(p84, p85) -- line: 1269
            -- upvalues: v41 (copy), ScrollingFrame (copy), v45 (ref), v46 (ref), v47 (ref), v48 (ref), t10 (copy), t11 (copy), t12 (copy), v49 (ref), n1 (ref), v50 (ref), n4 (ref), n5 (ref), v51 (ref), VisibleLast (ref), n7 (ref), collectPets (copy), collectEggs (copy), refreshFooter (copy), v133 (ref), finishOpeningReveal (copy), removeCard (copy), clearCards (copy), sameCardContent (copy)
            n5 += 1
            n1 += 1
            v49 = false

            local v176 = n5

            v51 = p84 == true
            VisibleLast = nil
            v50 = true

            if p85 then
                finishOpeningReveal()
            else
                clearCards()
                v48 = {}
            end

            n4 = 0
            n7 = 0

            if not p85 then
                ScrollingFrame.CanvasPosition = Vector2.zero
            end

            refreshFooter()
            task.defer(function() -- line: 1291
                -- upvalues: v176 (copy), v41 (copy), v45 (ref), v46 (ref), v47 (ref), v48 (ref), t10 (copy), t11 (copy), t12 (copy), v50 (ref), n5 (ref), collectPets (copy), collectEggs (copy), refreshFooter (copy), v133 (ref), removeCard (copy), sameCardContent (copy)
                task.wait()

                if v176 ~= n5 or not v41.Enabled then
                    return
                end

                local v177 = if v45 == "Eggs" then collectEggs(v176) else collectPets(v176)

                if v177 == nil or v176 ~= n5 or not v41.Enabled then
                    return
                end

                v48 = v177
                table.sort(v48, function(p86, p87) -- line: 572
                    -- upvalues: v46 (ref), v47 (ref)
                    local v178 = if v46 == "Weight" then p86.Weight else p86.Value
                    local v179 = if v46 == "Weight" then p87.Weight else p87.Value

                    if v178 == v179 then
                        return p86.Uid < p87.Uid
                    end

                    if v47 then
                        return v179 < v178
                    end

                    return v178 < v179
                end)

                local t41 = {}

                for v180, v181 in ipairs(v48) do
                    local Uid = v181.Uid

                    t41[Uid] = true

                    local v182 = t11[Uid]

                    if v182 then
                        local v183 = t12[Uid]

                        if v183 and sameCardContent(v183, v181) then
                            v182.LayoutOrder = v180
                            t12[Uid] = v181
                        else
                            removeCard(Uid, true)
                        end
                    end
                end

                for v184 in pairs(t11) do
                    if not t41[v184] then
                        removeCard(v184, true)
                    end
                end

                for v185 in pairs(t10) do
                    if not t41[v185] then
                        t10[v185] = nil
                    end
                end

                v50 = false
                v133 = true
                refreshFooter()
            end)
        end

        local function queueRebuild() -- line: 1337
            -- upvalues: v41 (copy), v45 (ref), v46 (ref), v47 (ref), v48 (ref), t10 (copy), t11 (copy), t12 (copy), v49 (ref), n1 (ref), v50 (ref), t13 (copy), n4 (ref), n5 (ref), v51 (ref), VisibleLast (ref), n7 (ref), collectPets (copy), collectEggs (copy), refreshFooter (copy), v133 (ref), finishOpeningReveal (copy), removeCard (copy), sameCardContent (copy)
            if v49 or t13.Selling or t13.Confirming or not v41.Enabled then
                return
            end

            v49 = true
            n1 += 1

            local v186 = n1

            task.delay(0.35, function() -- line: 1344
                -- upvalues: v186 (copy), v41 (copy), v45 (ref), v46 (ref), v47 (ref), v48 (ref), t10 (copy), t11 (copy), t12 (copy), v49 (ref), n1 (ref), v50 (ref), t13 (copy), n4 (ref), n5 (ref), v51 (ref), VisibleLast (ref), n7 (ref), collectPets (copy), collectEggs (copy), refreshFooter (copy), v133 (ref), finishOpeningReveal (copy), removeCard (copy), sameCardContent (copy)
                if v186 ~= n1 then
                    return
                end

                v49 = false

                if v41.Enabled and not t13.Selling and not t13.Confirming then
                    n5 += 1
                    n1 += 1
                    v49 = false

                    local v187 = n5

                    v51 = false
                    VisibleLast = nil
                    v50 = true
                    finishOpeningReveal()
                    n4 = 0
                    n7 = 0
                    refreshFooter()
                    task.defer(function() -- line: 1291
                        -- upvalues: v187 (copy), v41 (copy), v45 (ref), v46 (ref), v47 (ref), v48 (ref), t10 (copy), t11 (copy), t12 (copy), v50 (ref), n5 (ref), collectPets (copy), collectEggs (copy), refreshFooter (copy), v133 (ref), removeCard (copy), sameCardContent (copy)
                        task.wait()

                        if v187 ~= n5 or not v41.Enabled then
                            return
                        end

                        local v188 = if v45 == "Eggs" then collectEggs(v187) else collectPets(v187)

                        if v188 == nil or v187 ~= n5 or not v41.Enabled then
                            return
                        end

                        v48 = v188
                        table.sort(v48, function(p88, p89) -- line: 572
                            -- upvalues: v46 (ref), v47 (ref)
                            local v189 = if v46 == "Weight" then p88.Weight else p88.Value
                            local v190 = if v46 == "Weight" then p89.Weight else p89.Value

                            if v189 == v190 then
                                return p88.Uid < p89.Uid
                            end

                            if v47 then
                                return v190 < v189
                            end

                            return v189 < v190
                        end)

                        local t42 = {}

                        for v191, v192 in ipairs(v48) do
                            local Uid = v192.Uid

                            t42[Uid] = true

                            local v193 = t11[Uid]

                            if v193 then
                                local v194 = t12[Uid]

                                if v194 and sameCardContent(v194, v192) then
                                    v193.LayoutOrder = v191
                                    t12[Uid] = v192
                                else
                                    removeCard(Uid, true)
                                end
                            end
                        end

                        for v195 in pairs(t11) do
                            if not t42[v195] then
                                removeCard(v195, true)
                            end
                        end

                        for v196 in pairs(t10) do
                            if not t42[v196] then
                                t10[v196] = nil
                            end
                        end

                        v50 = false
                        v133 = true
                        refreshFooter()
                    end)
                end
            end)
        end

        local function setCategory(p90, p91) -- line: 1355
            -- upvalues: t4 (copy), t5 (copy), v41 (copy), Header (copy), PetsTab (copy), EggsTab (copy), v45 (ref), t10 (copy), t13 (copy), twitch (copy), paintTab (copy), rebuild (copy)
            if t13.Selling or t13.Confirming or v45 == p90 then
                return
            end

            v45 = p90
            table.clear(t10)

            local Title = Header:FindFirstChild("Title")
            local Title2Stroke = Header:FindFirstChild("Title2Stroke")

            if Title and Title:IsA("TextLabel") then
                Title.Text = t4[p90]
            end

            if Title2Stroke and Title2Stroke:IsA("TextLabel") then
                Title2Stroke.Text = t4[p90]
            end

            local Icon = Header:FindFirstChild("Icon")

            if Icon and Icon:IsA("ImageLabel") then
                Icon.Image = t5[p90]
            end

            paintTab(PetsTab, p90 == "Pets")
            paintTab(EggsTab, p90 == "Eggs")

            if p91 then
                twitch(if Icon and Icon:IsA("ImageLabel") then Icon else nil, 10)
                twitch((if p90 == "Pets" then PetsTab else EggsTab):FindFirstChildWhichIsA("ImageLabel"), -12)
            end

            if v41.Enabled then
                rebuild()
            end
        end

        local function paintSortButtons() -- line: 1390
            -- upvalues: Weight (copy), Value (copy), v46 (ref), v47 (ref), paintButton (copy)
            for _, v198 in ipairs({ Weight, Value }) do
                local v199 = v198 == Weight == (v46 == "Weight")

                paintButton(v198, v199)

                local Icon = v198:FindFirstChild("Icon")

                if Icon and Icon:IsA("ImageLabel") then
                    if not v199 or v47 then
                        Icon.Rotation = 90
                    else
                        Icon.Rotation = -90
                    end
                end
            end
        end

        local function setSort(p92) -- line: 1401
            -- upvalues: v46 (ref), v47 (ref), t13 (copy), rebuild (copy), paintSortButtons (copy)
            if t13.Selling or t13.Confirming then
                return
            end

            if v46 == p92 then
                v47 = not v47
            else
                v46 = p92
                v47 = true
            end

            paintSortButtons()
            rebuild()
        end

        local function flyPayout(p93) -- line: 1416
            -- upvalues: Save (copy), SellPayout (copy)
            local v200 = Save.Await()

            if v200 == nil then
                return
            end

            local Money = v200.Money
            local v201 = false
            local connection

            connection = Save.Changed:Connect(function(p94) -- line: 1426
                -- upvalues: p93 (copy), Money (copy), v201 (ref), connection (ref), Save (copy), SellPayout (copy)
                local v202, v203

                if p94 ~= "Money" or v201 then
                    v203 = true
                else
                    local v204 = Save.Await()

                    v202 = if v204 then v204.Money - Money else 0
                    v203 = false
                end

                if v203 or v202 <= 0 then
                    return
                end

                v201 = true

                if connection then
                    connection:Disconnect()
                end

                SellPayout.Award(v202, p93)
            end)
            task.delay(4, function() -- line: 1445
                -- upvalues: v201 (ref), connection (ref)
                if not v201 and connection then
                    connection:Disconnect()
                end
            end)
        end

        local function sell() -- line: 1452
            -- upvalues: v33 (copy), v39 (copy), v40 (copy), v41 (copy), SellInfoHolder (copy), v44 (copy), v45 (ref), v46 (ref), v47 (ref), v48 (ref), t10 (copy), t11 (copy), t12 (copy), v49 (ref), n1 (ref), v50 (ref), t13 (copy), n4 (ref), n5 (ref), v51 (ref), VisibleLast (ref), n7 (ref), captureFade (copy), setFade (copy), fadeOut (copy), collectPets (copy), collectEggs (copy), refreshFooter (copy), v133 (ref), finishOpeningReveal (copy), removeCard (copy), sameCardContent (copy), flyPayout (copy), TweenService (copy), Audio (copy), Message (copy), Numbers (copy), Remotes (copy), Simple (copy)
            if v50 or t13.Selling or t13.Confirming then
                return
            end

            local v205 = n5
            local t43 = {}
            local t44 = {}
            local n15 = 0

            for _ in pairs(t10) do
                n15 += 1
            end

            if n15 == 0 then
                return
            end

            local n16 = 0

            for _, v206 in ipairs(v48) do
                if t10[v206.Uid] then
                    n16 += v206.Value

                    if v206.Kind == "Eggs" then
                        table.insert(t44, v206.Uid)
                    else
                        table.insert(t43, v206.Uid)
                    end
                end
            end

            local v207 = #t43 + #t44

            if v207 ~= 0 then
                if v207 == #v48 then
                    local v208 = if v45 == "Eggs" then "eggs" else "pets"

                    t13.Confirming = true

                    local v210 = Message.Confirm(string.format("Would you like to sell <font color='#%s'>%d %s</font> for <font color='#%s'>%s</font>?", v39, v207, v208, v40, if n16 > 99999 then "$" .. Simple.FormatCompact(math.round(n16), ".#") else "$" .. Numbers.AddCommas((math.round(n16)))))

                    t13.Confirming = false

                    if not v210 then
                        if not v49 and not t13.Selling and not t13.Confirming then
                            if not v41.Enabled then
                                return
                            end

                            v49 = true
                            n1 += 1

                            local v211 = n1

                            task.delay(0.35, function() -- line: 1344
                                -- upvalues: v211 (copy), v41 (copy), v45 (ref), v46 (ref), v47 (ref), v48 (ref), t10 (copy), t11 (copy), t12 (copy), v49 (ref), n1 (ref), v50 (ref), t13 (copy), n4 (ref), n5 (ref), v51 (ref), VisibleLast (ref), n7 (ref), collectPets (copy), collectEggs (copy), refreshFooter (copy), v133 (ref), finishOpeningReveal (copy), removeCard (copy), sameCardContent (copy)
                                if v211 ~= n1 then
                                    return
                                end

                                v49 = false

                                if v41.Enabled and not t13.Selling and not t13.Confirming then
                                    n5 += 1
                                    n1 += 1
                                    v49 = false

                                    local v212 = n5

                                    v51 = false
                                    VisibleLast = nil
                                    v50 = true
                                    finishOpeningReveal()
                                    n4 = 0
                                    n7 = 0
                                    refreshFooter()
                                    task.defer(function() -- line: 1291
                                        -- upvalues: v41 (copy), v45 (ref), v46 (ref), v47 (ref), v48 (ref), t10 (copy), t11 (copy), t12 (copy), v50 (ref), n5 (ref), collectPets (copy), collectEggs (copy), refreshFooter (copy), v133 (ref), removeCard (copy), sameCardContent (copy), v212 (copy)
                                        task.wait()

                                        if v212 ~= n5 or not v41.Enabled then
                                            return
                                        end

                                        local v213 = if v45 == "Eggs" then collectEggs(v212) else collectPets(v212)

                                        if v213 == nil or v212 ~= n5 or not v41.Enabled then
                                            return
                                        end

                                        v48 = v213
                                        table.sort(v48, function(p95, p96) -- line: 572
                                            -- upvalues: v46 (ref), v47 (ref)
                                            local v214 = if v46 == "Weight" then p95.Weight else p95.Value
                                            local v215 = if v46 == "Weight" then p96.Weight else p96.Value

                                            if v214 == v215 then
                                                return p95.Uid < p96.Uid
                                            end

                                            if v47 then
                                                return v215 < v214
                                            end

                                            return v214 < v215
                                        end)

                                        local t45 = {}

                                        for v216, v217 in ipairs(v48) do
                                            local Uid = v217.Uid

                                            t45[Uid] = true

                                            local v218 = t11[Uid]

                                            if v218 then
                                                local v219 = t12[Uid]

                                                if v219 and sameCardContent(v219, v217) then
                                                    v218.LayoutOrder = v216
                                                    t12[Uid] = v217
                                                else
                                                    removeCard(Uid, true)
                                                end
                                            end
                                        end

                                        for v220 in pairs(t11) do
                                            if not t45[v220] then
                                                removeCard(v220, true)
                                            end
                                        end

                                        for v221 in pairs(t10) do
                                            if not t45[v221] then
                                                t10[v221] = nil
                                            end
                                        end

                                        v50 = false
                                        v133 = true
                                        refreshFooter()
                                    end)
                                end
                            end)
                        end

                        return
                    end

                    if v205 ~= n5 or v50 or t13.Selling then
                        return
                    end
                end

                local t46 = {}
                local t47 = {}

                for _, v222 in ipairs(v48) do
                    local v223 = t11[v222.Uid]

                    if v223 ~= nil and t10[v222.Uid] then
                        table.insert(t47, v223)
                        table.insert(t46, v223.AbsolutePosition + v223.AbsoluteSize / 2)
                    end
                end

                if #t46 == 0 then
                    local Icon = SellInfoHolder:FindFirstChild("Icon")

                    if not Icon then
                        Icon = SellInfoHolder:FindFirstChild("Value")

                        if not Icon or not Icon:IsA("TextLabel") then
                            Icon = SellInfoHolder
                        end
                    end

                    table.insert(t46, Icon.AbsolutePosition + Icon.AbsoluteSize / 2)
                end

                flyPayout(t46)
                finishOpeningReveal()
                t13.Selling = true
                v44:Clean()

                for v226, v227 in ipairs(t47) do
                    local v229 = math.min((v226 - 1) * 0.02, 0.2)
                    local RevealScale = v227:FindFirstChild("RevealScale")

                    if not (RevealScale and RevealScale:IsA("UIScale")) then
                        RevealScale = Instance.new("UIScale")
                        RevealScale.Name = "RevealScale"
                        RevealScale.Parent = v227
                    end

                    local v230 = captureFade(v227)
                    local tween = TweenService:Create(RevealScale, TweenInfo.new(v33.Time, v33.EasingStyle, v33.EasingDirection, 0, false, v229), {
                        Scale = 0.6
                    })

                    tween:Play()
                    v44:Add(function() -- line: 1538
                        -- upvalues: tween (copy)
                        tween:Cancel()
                        tween:Destroy()
                    end)
                    fadeOut(v230, v33, v229, v44)
                    v44:Add(function() -- line: 1540
                        -- upvalues: RevealScale (ref), v230 (copy), setFade (copy)
                        RevealScale.Scale = 1
                        setFade(v230, 1)
                    end)
                end

                task.delay(0.28, function() -- line: 1548
                    -- upvalues: v205 (copy), v41 (copy), v44 (copy), v45 (ref), v46 (ref), v47 (ref), v48 (ref), t10 (copy), t11 (copy), t12 (copy), v49 (ref), n1 (ref), v50 (ref), t13 (copy), n4 (ref), n5 (ref), v51 (ref), VisibleLast (ref), n7 (ref), collectPets (copy), collectEggs (copy), refreshFooter (copy), v133 (ref), finishOpeningReveal (copy), removeCard (copy), sameCardContent (copy)
                    if v205 ~= n5 then
                        return
                    end

                    v44:Clean()
                    t13.Selling = false

                    if v41.Enabled then
                        n5 += 1
                        n1 += 1
                        v49 = false

                        local v231 = n5

                        v51 = false
                        VisibleLast = nil
                        v50 = true
                        finishOpeningReveal()
                        n4 = 0
                        n7 = 0
                        refreshFooter()
                        task.defer(function() -- line: 1291
                            -- upvalues: v231 (copy), v41 (copy), v45 (ref), v46 (ref), v47 (ref), v48 (ref), t10 (copy), t11 (copy), t12 (copy), v50 (ref), n5 (ref), collectPets (copy), collectEggs (copy), refreshFooter (copy), v133 (ref), removeCard (copy), sameCardContent (copy)
                            task.wait()

                            if v231 ~= n5 or not v41.Enabled then
                                return
                            end

                            local v232 = if v45 == "Eggs" then collectEggs(v231) else collectPets(v231)

                            if v232 == nil or v231 ~= n5 or not v41.Enabled then
                                return
                            end

                            v48 = v232
                            table.sort(v48, function(p97, p98) -- line: 572
                                -- upvalues: v46 (ref), v47 (ref)
                                local v233 = if v46 == "Weight" then p97.Weight else p97.Value
                                local v234 = if v46 == "Weight" then p98.Weight else p98.Value

                                if v233 == v234 then
                                    return p97.Uid < p98.Uid
                                end

                                if v47 then
                                    return v234 < v233
                                end

                                return v233 < v234
                            end)

                            local t48 = {}

                            for v235, v236 in ipairs(v48) do
                                local Uid = v236.Uid

                                t48[Uid] = true

                                local v237 = t11[Uid]

                                if v237 then
                                    local v238 = t12[Uid]

                                    if v238 and sameCardContent(v238, v236) then
                                        v237.LayoutOrder = v235
                                        t12[Uid] = v236
                                    else
                                        removeCard(Uid, true)
                                    end
                                end
                            end

                            for v239 in pairs(t11) do
                                if not t48[v239] then
                                    removeCard(v239, true)
                                end
                            end

                            for v240 in pairs(t10) do
                                if not t48[v240] then
                                    t10[v240] = nil
                                end
                            end

                            v50 = false
                            v133 = true
                            refreshFooter()
                        end)
                    end
                end)

                local function sendBatches(p99, p100) -- line: 1561
                    -- upvalues: Remotes (copy)
                    for i = 1, #p99, 512 do
                        local t49 = {}
                        local move = table.move
                        local v241 = #p99

                        move(p99, i, math.min(i + 511, v241), 1, t49)

                        local SellSelection = Remotes.PetSatchel.SellSelection
                        local t50 = {}

                        if p100 then
                            t50.Assets = {}
                        else
                            t50.Assets = t49
                            t49 = {}
                        end

                        t50.Eggs = t49
                        SellSelection:FireServer(t50)
                    end
                end

                sendBatches(t43, false)
                sendBatches(t44, true)
                Audio.Chime("Prompt")
                table.clear(t10)
                refreshFooter()
            end
        end

        local function guardArena() -- line: 1578
            -- upvalues: Tabs (copy), ToolGameplayGuard (copy)
            if ToolGameplayGuard.IsLocalInsideArena() and Tabs.IsActive("SellPrompt") then
                Tabs.Deactivate()
            end
        end

        v41.Enabled = false
        TemplateHolder.Visible = false

        if Backdrop then
            Backdrop.Visible = false
        end

        v42:Add(ButtonFX(PetsTab, 1.06, function() -- line: 1594
            -- upvalues: setCategory (copy)
            setCategory("Pets", true)
        end))
        v42:Add(ButtonFX(EggsTab, 1.06, function() -- line: 1595
            -- upvalues: setCategory (copy)
            setCategory("Eggs", true)
        end))
        v42:Add(ButtonFX(Weight, 1.06, function() -- line: 1596
            -- upvalues: v46 (ref), v47 (ref), t13 (copy), rebuild (copy), paintSortButtons (copy)
            if t13.Selling or t13.Confirming then
                return
            end

            if v46 == "Weight" then
                v47 = not v47
            else
                v46 = "Weight"
                v47 = true
            end

            paintSortButtons()
            rebuild()
        end))
        v42:Add(ButtonFX(Value, 1.06, function() -- line: 1597
            -- upvalues: v46 (ref), v47 (ref), t13 (copy), rebuild (copy), paintSortButtons (copy)
            if t13.Selling or t13.Confirming then
                return
            end

            if v46 == "Value" then
                v47 = not v47
            else
                v46 = "Value"
                v47 = true
            end

            paintSortButtons()
            rebuild()
        end))
        v42:Add(ButtonFX(Sell, 1.08, sell))
        setCategory("Eggs")
        setCategory("Pets")
        paintSortButtons()
        v42:Add(ButtonFX(SelectAll, 1.06, function() -- line: 1604
            -- upvalues: setEverySelected (copy)
            setEverySelected(true)
        end))
        v42:Add(ButtonFX(Clear, 1.06, function() -- line: 1605
            -- upvalues: setEverySelected (copy)
            setEverySelected(false)
        end))
        v42:Add(v41:GetPropertyChangedSignal("AbsoluteSize"):Connect(applyPlatformLayout))
        v42:Add(PlatformController.Changed:Connect(applyPlatformLayout))
        v42:Add(ScrollingFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 1608
            -- upvalues: v133 (ref)
            v133 = true
        end))
        v42:Add(ScrollingFrame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() -- line: 1609
            -- upvalues: v133 (ref)
            v133 = true
        end))
        v42:Add(ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- line: 1610
            -- upvalues: ScrollingFrame (copy), v133 (ref), finishOpeningReveal (copy)
            if ScrollingFrame.CanvasPosition.Y ~= 0 then
                finishOpeningReveal()
            end

            v133 = true
        end))
        v42:Add(UIGridLayout:GetPropertyChangedSignal("CellSize"):Connect(function() -- line: 1617
            -- upvalues: v133 (ref)
            v133 = true
        end))
        v42:Add(RunService.Heartbeat:Connect(renderWindow))
        v42:Add(v43)
        v42:Add(v44)
        v42:Add(function() -- line: 1621
            -- upvalues: n1 (ref), n5 (ref), v133 (ref), clearCards (copy)
            n5 += 1
            n1 += 1
            v133 = false
            clearCards()
        end)

        local v242 = isPhone()

        Frame.Size = if v242 then v28 else Size
        v242 = if v242 then v29 else CellSize
        UIGridLayout.CellSize = v242
        n6 += 1

        if not v52 then
            v52 = true
            task.defer(function() -- line: 889
                -- upvalues: v41 (copy), n5 (ref), v52 (ref), n6 (ref), v53 (ref), n7 (ref), refitLabels (copy), queueRefit (copy), RunService (copy)
                RunService.PreRender:Wait()

                local v244 = n5
                local v245 = n6

                v53 = false
                refitLabels(v244)
                v52 = false

                if v244 ~= n5 or not v41.Enabled then
                    return
                end

                if v245 ~= n6 then
                    queueRefit()
                end

                if not (v53 and n7 < 5) then
                    return
                end

                n7 += 1
                task.delay(0.4, function() -- line: 904
                    -- upvalues: v41 (copy), n5 (ref), queueRefit (copy), v244 (copy)
                    if v244 == n5 and v41.Enabled then
                        queueRefit()
                    end
                end)
            end)
        end

        if Backdrop then
            v42:Add(Backdrop.Activated:Connect(function() -- line: 1630
                -- upvalues: Tabs (copy)
                Tabs.Deactivate()
            end))
        end

        v42:Add(Tabs.Activated:Connect(function(p101) -- line: 1633
            -- upvalues: v26 (copy), v41 (copy), Frame (copy), ScrollingFrame (copy), SellInfoHolder (copy), Backdrop (copy), v43 (copy), t10 (copy), n2 (ref), tween (ref), NumberValue (ref), t13 (copy), n3 (ref), n5 (ref), v52 (ref), n6 (ref), v53 (ref), n7 (ref), captureFade (copy), fadeIn (copy), refitLabels (copy), queueRefit (copy), rebuild (copy), RunService (copy), Numbers (copy)
            if p101 ~= "SellPrompt" then
                return
            end

            if Backdrop ~= nil then
                Backdrop.BackgroundTransparency = 1
                Backdrop.Visible = true
            end

            if t13.Confirming then
                n6 += 1

                if not v52 then
                    v52 = true
                    task.defer(function() -- line: 889
                        -- upvalues: v41 (copy), n5 (ref), v52 (ref), n6 (ref), v53 (ref), n7 (ref), refitLabels (copy), queueRefit (copy), RunService (copy)
                        RunService.PreRender:Wait()

                        local v246 = n5
                        local v247 = n6

                        v53 = false
                        refitLabels(v246)
                        v52 = false

                        if v246 ~= n5 or not v41.Enabled then
                            return
                        end

                        if v247 ~= n6 then
                            queueRefit()
                        end

                        if not (v53 and n7 < 5) then
                            return
                        end

                        n7 += 1
                        task.delay(0.4, function() -- line: 904
                            -- upvalues: v41 (copy), n5 (ref), queueRefit (copy), v246 (copy)
                            if v246 == n5 and v41.Enabled then
                                queueRefit()
                            end
                        end)
                    end)
                end
            else
                table.clear(t10)
                t13.Selling = false

                if tween then
                    tween:Cancel()
                    tween = nil
                end

                if NumberValue then
                    NumberValue:Destroy()
                    NumberValue = nil
                end

                n2 = 0

                local Value = SellInfoHolder:FindFirstChild("Value")

                if not (Value and Value:IsA("TextLabel")) then
                    Value = nil
                end

                if Value then
                    Value.Text = "$" .. Numbers.AddCommas(0)
                end

                n6 += 1

                if not v52 then
                    v52 = true
                    task.defer(function() -- line: 889
                        -- upvalues: v41 (copy), n5 (ref), v52 (ref), n6 (ref), v53 (ref), n7 (ref), refitLabels (copy), queueRefit (copy), RunService (copy)
                        RunService.PreRender:Wait()

                        local v248 = n5
                        local v249 = n6

                        v53 = false
                        refitLabels(v248)
                        v52 = false

                        if v248 ~= n5 or not v41.Enabled then
                            return
                        end

                        if v249 ~= n6 then
                            queueRefit()
                        end

                        if not (v53 and n7 < 5) then
                            return
                        end

                        n7 += 1
                        task.delay(0.4, function() -- line: 904
                            -- upvalues: v41 (copy), n5 (ref), queueRefit (copy), v248 (copy)
                            if v248 == n5 and v41.Enabled then
                                queueRefit()
                            end
                        end)
                    end)
                end

                v43:Clean()
                fadeIn(captureFade(Frame, { ScrollingFrame }), v26, nil, v43)
                n3 = 0.08
                rebuild(true)
            end
        end))
        v42:Add(Tabs.Deactivated:Connect(function(p102, p103) -- line: 1652
            -- upvalues: Backdrop (copy), v43 (copy), v44 (copy), v49 (ref), n1 (ref), v50 (ref), t13 (copy), n5 (ref), t14 (copy), v133 (ref), finishOpeningReveal (copy), clearCards (copy)
            if p102 ~= "SellPrompt" then
                return
            end

            if Backdrop ~= nil then
                Backdrop.BackgroundTransparency = 1
                Backdrop.Visible = false
            end

            if t13.Confirming and p103.replacedBy == "Message" then
                finishOpeningReveal()
            else
                n5 += 1
                n1 += 1
                v49 = false
                v50 = false
                t13.Selling = false
                v133 = false
                v43:Clean()
                v44:Clean()
                clearCards()
                table.clear(t14)
            end
        end))
        v42:Add(Save.WatchFields({
            "Inventory",
            "EggInventory",
            "EquippedAssets"
        }, queueRebuild))
        v42:Add(Timer.Simple(0.1, guardArena, true))
        v42:AttachToInstance(script)

        if ToolGameplayGuard.IsLocalInsideArena() and Tabs.IsActive("SellPrompt") then
            Tabs.Deactivate()
        end
    end
}
