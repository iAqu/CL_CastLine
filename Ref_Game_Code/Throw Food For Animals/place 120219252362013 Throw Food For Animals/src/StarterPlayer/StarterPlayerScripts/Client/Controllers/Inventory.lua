-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UITheme = require(ReplicatedStorage.Config.UITheme)
local EggsConfig = require(ReplicatedStorage.Config.EggsConfig)
local AnimalUtil = require(ReplicatedStorage.Shared.AnimalUtil)
local AnimalTemplates = require(ReplicatedStorage.Shared.AnimalTemplates)
local Mutations = require(ReplicatedStorage.Shared.Mutations)
local EggModels = require(ReplicatedStorage.Shared.EggModels)
local NumberFormat = require(ReplicatedStorage.Shared.NumberFormat)
local Parent = script.Parent
local UIKit = require(Parent.UIKit)
local Sounds = require(Parent.Sounds)
local ClientState = require(Parent.ClientState)
local HUDController = require(Parent.HUDController)
local UIScaler = require(Parent.UIScaler)
local t1 = {}
local Colors = UITheme.Colors
local LocalPlayer = Players.LocalPlayer
local t2 = {
    [Enum.KeyCode.One] = 1,
    [Enum.KeyCode.Two] = 2,
    [Enum.KeyCode.Three] = 3,
    [Enum.KeyCode.Four] = 4,
    [Enum.KeyCode.Five] = 5,
    [Enum.KeyCode.Six] = 6,
    [Enum.KeyCode.Seven] = 7,
    [Enum.KeyCode.Eight] = 8,
    [Enum.KeyCode.Nine] = 9,
    [Enum.KeyCode.Zero] = 10
}
local v1 = Color3.fromRGB(18, 18, 21)
local v2 = Color3.fromRGB(26, 28, 34)
local t3 = {
    "ShopOpen",
    "SellOpen",
    "IndexOpen",
    "ExclusiveShopOpen",
    "OfflineOpen"
}
local t4 = {
    "ShopOpen",
    "SellOpen",
    "IndexOpen",
    "ExclusiveShopOpen",
    "AnimalsOpen",
    "OfflineOpen"
}
local t5 = {
    { "ShopController", "ShopOpen" },
    { "SellShop", "SellOpen" },
    { "IndexController", "IndexOpen" },
    { "ExclusiveShopController", "ExclusiveShopOpen" },
    { "AnimalsPanel", "AnimalsOpen" }
}
local v3, v4, v5, ScrollingFrame, TextBox, v6, v7, v8, v9, v10, ScreenGui, TextButton
local n1 = 10
local t6 = {}
local t7 = {}
local t8 = {}
local t9 = {}
local v11 = false
local v12 = false
local v13
local v14 = false
local t10 = {
    Slot = 56,
    Gap = 5,
    Margin = 8
}
local Backpack, Character, v15
local t11 = {}

local function itemKey(p1) -- line: 112
    local AnimalId = p1:GetAttribute("AnimalId")

    if AnimalId then
        return "a:" .. AnimalId
    end

    local EggKey = p1:GetAttribute("EggKey")

    if EggKey then
        return "e:" .. EggKey
    end

    return "n:" .. p1.Name
end

local function displayName(p2) -- line: 120
    -- upvalues: EggsConfig (copy)
    local EggKey = p2:GetAttribute("EggKey")
    local v16 = EggKey and EggsConfig.Get(EggKey)

    return v16 and v16.Name or p2.Name
end

local function isHeld(p3) -- line: 126
    -- upvalues: Character (ref)
    return Character ~= nil and p3.Parent == Character
end

local function iconModel(p4) -- line: 138
    -- upvalues: AnimalUtil (copy), Mutations (copy), EggModels (copy)
    local AnimalName = p4:GetAttribute("AnimalName")

    if AnimalName then
        local v17 = AnimalUtil.Create(AnimalName)

        if v17 then
            Mutations.Apply(v17, p4:GetAttribute("Mutation"), {
                Particles = false
            })
        end

        return v17
    end

    local EggKey = p4:GetAttribute("EggKey")

    if EggKey then
        return EggModels.Make(EggKey, 3)
    end

    return nil
end

local function refreshIncome(p5) -- line: 152
    -- upvalues: NumberFormat (copy), LocalPlayer (copy)
    local Income = p5.Tool:GetAttribute("Income")

    if p5.Income then
        local OfBest = p5.Tool:GetAttribute("OfBest")

        if OfBest then
            p5.Income.RichText = true
            p5.Income.Text = NumberFormat.OfBest(OfBest)
            p5.Income.Visible = true
        elseif Income then
            p5.Income.Text = NumberFormat.PerSecond(Income * (LocalPlayer:GetAttribute("CashMultiplier") or 1))
            p5.Income.Visible = true
        else
            p5.Income.Visible = false
        end
    end
end

local function refreshCount(p6) -- line: 168
    local v18 = p6.Tool:GetAttribute("Count") or 1

    p6.Count.Text = "x" .. v18
    p6.Count.Visible = v18 > 1
end

local function makeVisual(p7) -- line: 175
    -- upvalues: EggsConfig (copy), UIKit (copy), Colors (copy), iconModel (copy), refreshIncome (copy)
    local Tool = p7.Tool
    local Frame = Instance.new("Frame")

    Frame.Name = "Item"
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.ZIndex = 2

    local v19 = iconModel(Tool)

    if v19 then
        p7.Viewport = UIKit.Viewport({
            ZIndex = 2,
            Yaw = -0.6108652381980153,
            Pitch = -0.20943951023931956,
            Padding = 1,
            Parent = Frame,
            Size = UDim2.fromScale(0.8, 0.74),
            Position = UDim2.fromScale(0.5, 0.6),
            AnchorPoint = Vector2.new(0.5, 0.5)
        })
        p7.Viewport:SetModel(v19)
    else
        local Text = UIKit.Text
        local t12 = {
            Name = "Fallback",
            ZIndex = 3,
            Stroke = 2,
            Parent = Frame
        }
        local EggKey = Tool:GetAttribute("EggKey")
        local v20 = EggKey and EggsConfig.Get(EggKey)

        t12.Text = v20 and v20.Name or Tool.Name
        t12.Size = UDim2.fromScale(0.86, 0.5)
        t12.Position = UDim2.fromScale(0.5, 0.5)
        t12.AnchorPoint = Vector2.new(0.5, 0.5)
        Text(t12)
    end

    p7.Income = UIKit.Text({
        Name = "Income",
        Text = "",
        ZIndex = 4,
        Stroke = 2,
        Parent = Frame,
        Size = UDim2.fromScale(0.92, 0.26),
        Position = UDim2.fromScale(0.5, 0.04),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = Colors.Money
    })
    refreshIncome(p7)
    p7.Count = UIKit.Text({
        Name = "Count",
        Text = "",
        ZIndex = 4,
        Stroke = 2,
        Parent = Frame,
        Size = UDim2.fromScale(0.6, 0.3),
        Position = UDim2.fromScale(0.95, 0.86),
        AnchorPoint = Vector2.new(1, 1),
        XAlign = Enum.TextXAlignment.Right
    })

    local v21 = p7.Tool:GetAttribute("Count") or 1

    p7.Count.Text = "x" .. v21
    p7.Count.Visible = v21 > 1
    p7.Visual = Frame
end

local function humanoid() -- line: 202
    -- upvalues: Character (ref)
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    return if Humanoid and Humanoid.Health > 0 then Humanoid else nil
end

local function toggleEquip(p8) -- line: 208
    -- upvalues: ClientState (copy), Character (ref)
    local Humanoid

    if not p8 or ClientState.Busy or ClientState.OfflineOpen then
        return
    else
        Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    end

    if not (Humanoid and Humanoid.Health > 0) then
        Humanoid = nil
    end

    if Humanoid then
        if Character ~= nil and p8.Parent == Character then
            Humanoid:UnequipTools()
        else
            Humanoid:EquipTool(p8)
        end
    end
end

local render

local function queueRender() -- line: 225
    -- upvalues: v14 (ref), render (ref)
    if not v14 then
        v14 = true
        task.defer(function() -- line: 228
            -- upvalues: render (ref)
            render()
        end)
    end
end

local function computeMetrics() -- line: 231
    -- upvalues: ClientState (copy), HUDController (copy), UIScaler (copy), v3 (ref), n1 (ref), t10 (copy)
    local AbsoluteSize = v3.AbsoluteSize
    local X, Y = AbsoluteSize.X, AbsoluteSize.Y
    local v23 = UIScaler.Factor()
    local v26 = math.max(4, (math.round(8 * v23)))
    local v27 = if UIScaler.IsPhone() then Y * 0.15 elseif UIScaler.IsTouch() then Y * 0.11 else 56 * v23
    local v28 = HUDController.GetStatsContainer()
    local v29 = v26

    if v28 then
        local v30 = v28:FindFirstAncestorWhichIsA("ScreenGui")

        if v30 and v30.Enabled and v28.Visible then
            v29 = math.max(v26, v28.AbsolutePosition.X + v28.AbsoluteSize.X - v3.AbsolutePosition.X + v26)
        end
    end

    local v32 = X / 2 - v29
    local v33 = v32

    if ClientState.AnimalsOpen then
        local v34 = v3.Parent and v3.Parent:FindFirstChild("AnimalsPanelGui")
        local AnimalsPanel = v34 and v34:FindFirstChild("AnimalsPanel")

        if AnimalsPanel and AnimalsPanel.Visible then
            v33 = math.min(v32, AnimalsPanel.AbsolutePosition.X - v3.AbsolutePosition.X - v26 - X / 2)
        end
    end

    local v37 = v33 * 2
    local v38 = n1
    local v41 = math.floor((math.max(math.min(v27, v37 / (v38 + (n1 - 1) * 0.09)), 30)))

    t10.Slot = v41
    t10.Gap = math.max(3, (math.floor(v41 * 0.09)))
    t10.Margin = v26
    t10.Width = X
    t10.Height = Y
end

local function setSlotLook(p9, p10) -- line: 273
    -- upvalues: Character (ref)
    local v44 = p10 ~= nil and Character ~= nil and p10.Parent == Character
    local Outline = p9:FindFirstChild("Outline")

    if Outline then
        Outline.Color = v44 and Color3.new(1, 1, 1) or Color3.new(0, 0, 0)
        Outline.Transparency = v44 and 0 or 0.55
        Outline.Thickness = v44 and 3 or 1.5
    end

    p9.BackgroundTransparency = v44 and 0.12 or 0.3
end

local function isDragged(p11) -- line: 284
    -- upvalues: v13 (ref)
    return v13 ~= nil and v13.Active and v13.Item == p11
end

local function inventoryOrder(p12, p13) -- line: 289
    -- upvalues: EggsConfig (copy)
    local EggKey = p12.Tool:GetAttribute("EggKey")
    local EggKey2 = p13.Tool:GetAttribute("EggKey")

    if EggKey ~= nil ~= (EggKey2 ~= nil) then
        return EggKey ~= nil
    end

    local v45 = p12.Tool:GetAttribute("Income") or 0
    local v46 = p13.Tool:GetAttribute("Income") or 0

    if v45 ~= v46 then
        return v46 < v45
    end

    local Tool = p12.Tool
    local EggKey3 = Tool:GetAttribute("EggKey")
    local v47 = EggKey3 and EggsConfig.Get(EggKey3)
    local Name = v47 and v47.Name or Tool.Name
    local Tool2 = p13.Tool
    local EggKey4 = Tool2:GetAttribute("EggKey")
    local v48 = EggKey4 and EggsConfig.Get(EggKey4)

    return Name < (v48 and v48.Name or Tool2.Name)
end

local makeInventoryButton

function render() -- line: 299
    -- upvalues: EggsConfig (copy), UIScaler (copy), v1 (copy), v3 (ref), v4 (ref), v5 (ref), ScrollingFrame (ref), TextBox (ref), v6 (ref), TextButton (ref), n1 (ref), t6 (copy), t7 (copy), t8 (copy), v11 (ref), v12 (ref), v13 (ref), v14 (ref), t10 (copy), v15 (ref), computeMetrics (copy), setSlotLook (copy), inventoryOrder (copy), makeInventoryButton (ref)
    v14 = false

    if not v3 then
        return
    end

    computeMetrics()

    local Slot, Gap, Margin = t10.Slot, t10.Gap, t10.Margin
    local v49 = not UIScaler.IsTouch()
    local t13 = {}

    for i = 1, n1 do
        if v11 or t6[i] then
            table.insert(t13, i)
        end
    end

    local v53 = #t13 * Slot + math.max(0, #t13 - 1) * Gap

    v4.Size = UDim2.fromOffset(math.max(v53, 1), Slot)
    v4.Visible = #t13 > 0

    if not v15 or v15.PlaybackState ~= Enum.PlaybackState.Playing then
        v4.Position = v12 and UDim2.new(0.5, 0, 1, Slot + Margin * 4) or UDim2.new(0.5, 0, 1, -Margin)
    end

    for _, v57 in ipairs(t7) do
        v57.Visible = false
    end

    for v58, v59 in ipairs(t13) do
        local v60 = t7[v59]

        v60.Visible = true
        v60.Size = UDim2.fromOffset(Slot, Slot)
        v60.Position = UDim2.fromOffset((v58 - 1) * (Slot + Gap), 0)
        v60.Number.Visible = v49

        local v61 = t6[v59]
        local v62 = v61 and t8[v61]

        if v62 and (v13 == nil or not v13.Active or v13.Item ~= v62) then
            v62.Visual.Parent = v60

            if v62.InvButton then
                v62.InvButton:Destroy()
                v62.InvButton = nil
            end
        end

        setSlotLook(v60, v61)
    end

    local t14 = {}

    for v63, v64 in pairs(t8) do
        local v65 = n1
        local v66

        for j = 1, v65 do
            if t6[j] == v63 then
                v66 = j
                break
            end
        end

        if not v66 then
            table.insert(t14, v64)
        end
    end

    table.sort(t14, inventoryOrder)

    local v67 = string.lower(TextBox.Text or "")
    local n2 = 0

    for v68, v69 in ipairs(t14) do
        local v70 = v69.InvButton or makeInventoryButton(v69)

        v70.LayoutOrder = v68

        local v71

        if v67 == "" then
            v71 = true
        else
            local find, lower = string.find, string.lower
            local Tool = v69.Tool
            local EggKey = Tool:GetAttribute("EggKey")
            local v72 = EggKey and EggsConfig.Get(EggKey)

            v71 = find(lower(v72 and v72.Name or Tool.Name), v67, 1, true) ~= nil
        end

        v70.Visible = v71

        if v71 then
            n2 += 1
        end

        if v13 == nil or not v13.Active or v13.Item ~= v69 then
            v69.Visual.Parent = v70
        end

        setSlotLook(v70, v69.Tool)
    end

    v6.Visible = n2 == 0
    v6.Text = #t14 == 0 and "No other items" or "Nothing found"

    if v11 then
        local v75 = UIScaler.IsPhone()
        local v80 = math.min(math.max(v53 + Gap * 4, t10.Width * (if v75 then 0.72 else 0.46)), t10.Width - Margin * 2)
        local v81 = t10.Height - (Slot + Margin + Gap * 3) - Margin
        local v83 = math.min(t10.Height * (if v75 then 0.62 else 0.42), v81)

        v5.Size = UDim2.fromOffset(v80, v83)
        v5.Position = UDim2.new(0.5, 0, 1, -(Slot + Margin + Gap * 3))

        local UIGridLayout = ScrollingFrame:FindFirstChildOfClass("UIGridLayout")

        UIGridLayout.CellSize = UDim2.fromOffset(Slot, Slot)
        UIGridLayout.CellPadding = UDim2.fromOffset(Gap, Gap)
    end

    v5.Visible = v11

    if not TextButton then
        return
    end

    TextButton.BackgroundTransparency = v11 and 0.05 or 0.12
    TextButton.BackgroundColor3 = v11 and Color3.fromRGB(235, 238, 245) or v1

    local Icon = TextButton:FindFirstChild("Icon")

    if Icon then
        Icon.ImageColor3 = v11 and Color3.fromRGB(18, 18, 21) or Color3.new(1, 1, 1)
    end
end

local function showTooltip(p14, p15) -- line: 381
    -- upvalues: EggsConfig (copy), UIScaler (copy), v3 (ref), v7 (ref), v8 (ref), v9 (ref), v13 (ref), t10 (copy)
    if not UIScaler.IsTouch() and p15 and (not v13 or not v13.Active) then
        local v86 = UIScaler.Factor()
        local v87 = v8
        local EggKey = p15:GetAttribute("EggKey")
        local v88 = EggKey and EggsConfig.Get(EggKey)

        v87.Text = v88 and v88.Name or p15.Name

        local v89 = v8

        v89.TextSize = math.max(12, (math.round(18 * v86)))

        local v92 = v9

        v92.Text = p15.ToolTip or ""

        local v93 = v9

        v93.TextSize = math.max(10, (math.round(14 * v86)))

        local v96 = v9

        v96.Visible = v9.Text ~= ""

        local v97 = v7

        v97.Size = UDim2.fromOffset(math.round(280 * v86), 0)

        local v99 = p14.AbsolutePosition - v3.AbsolutePosition
        local v100 = v7

        v100.Position = UDim2.fromOffset(v99.X + p14.AbsoluteSize.X / 2, v99.Y - t10.Gap * 2)
        v7.Visible = true
    end
end

local function hideTooltip() -- line: 395
    -- upvalues: v7 (ref)
    v7.Visible = false
end

local function inside(p16, p17) -- line: 403
    if p16 and p16.Visible then
        local AbsolutePosition, AbsoluteSize = p16.AbsolutePosition, p16.AbsoluteSize

        if p17.X >= AbsolutePosition.X and p17.X <= AbsolutePosition.X + AbsoluteSize.X and p17.Y >= AbsolutePosition.Y then
            return p17.Y <= AbsolutePosition.Y + AbsoluteSize.Y
        end

        return false
    end

    return false
end

local function endDrag(p18) -- line: 410
    -- upvalues: ScrollingFrame (ref)
    if not p18 then
        return
    end

    if p18.Ghost then
        if p18.Item.Visual.Parent == p18.Ghost then
            p18.Item.Visual.Parent = nil
        end

        p18.Ghost:Destroy()
        p18.Ghost = nil
    end

    ScrollingFrame.ScrollingEnabled = true
end

local function moveGhost(p19) -- line: 420
    -- upvalues: v3 (ref), v13 (ref)
    local v101 = v13 and v13.Ghost

    if v101 then
        local AbsolutePosition = v3.AbsolutePosition

        v101.Position = UDim2.fromOffset(p19.X - AbsolutePosition.X, p19.Y - AbsolutePosition.Y)
    end
end

local function startDrag(p20) -- line: 427
    -- upvalues: Sounds (copy), v2 (copy), v3 (ref), ScrollingFrame (ref), v7 (ref), v10 (ref), v13 (ref), t10 (copy), render (ref)
    local v102 = v13

    v102.Active = true
    v7.Visible = false

    local Frame = Instance.new("Frame")

    Frame.Name = "Ghost"
    Frame.Size = UDim2.fromOffset(t10.Slot, t10.Slot)
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundColor3 = v2
    Frame.BackgroundTransparency = 0.15
    Frame.ZIndex = 50

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0.16, 0)
    UICorner.Parent = Frame

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = Color3.new(1, 1, 1)
    UIStroke.Thickness = 2
    UIStroke.Parent = Frame

    local UIScale = Instance.new("UIScale")

    UIScale.Scale = 1.12
    UIScale.Parent = Frame
    Frame.Parent = v10
    v102.Item.Visual.Parent = Frame
    v102.Ghost = Frame
    ScrollingFrame.ScrollingEnabled = false

    local v103 = v13 and v13.Ghost

    if v103 then
        local AbsolutePosition = v3.AbsolutePosition

        v103.Position = UDim2.fromOffset(p20.X - AbsolutePosition.X, p20.Y - AbsolutePosition.Y)
    end

    Sounds.Play("Pop", {
        Volume = 0.25,
        Pitch = 1.3
    })
    render()
end

local function drop(p21, p22) -- line: 457
    -- upvalues: Sounds (copy), v5 (ref), ScrollingFrame (ref), n1 (ref), t6 (copy), t7 (copy), render (ref)
    if p21 then
        if p21.Ghost then
            if p21.Item.Visual.Parent == p21.Ghost then
                p21.Item.Visual.Parent = nil
            end

            p21.Ghost:Destroy()
            p21.Ghost = nil
        end

        ScrollingFrame.ScrollingEnabled = true
    end

    local Tool = p21.Item.Tool
    local v104 = n1
    local v105 = false
    local v106

    for i = 1, v104 do
        if t6[i] == Tool then
            v106 = i
            v105 = true
            break
        end
    end

    if not v105 then
        v106 = nil
    end

    local v107 = n1
    local v108

    for i = 1, v107 do
        local v109 = t7[i]

        if v109 and v109.Visible then
            local AbsolutePosition, AbsoluteSize = v109.AbsolutePosition, v109.AbsoluteSize

            if p22.X >= AbsolutePosition.X and p22.X <= AbsolutePosition.X + AbsoluteSize.X and p22.Y >= AbsolutePosition.Y and p22.Y <= AbsolutePosition.Y + AbsoluteSize.Y then
                v108 = i
                break
            end
        end

        v108 = nil
    end

    if not v108 or v108 == v106 then
        if not v108 and v106 then
            local v113 = v5

            if v113 and v113.Visible then
                local AbsolutePosition, AbsoluteSize = v113.AbsolutePosition, v113.AbsoluteSize

                if p22.X >= AbsolutePosition.X and p22.X <= AbsolutePosition.X + AbsoluteSize.X and p22.Y >= AbsolutePosition.Y and p22.Y <= AbsolutePosition.Y + AbsoluteSize.Y then
                    t6[v106] = nil
                    Sounds.Play("Pop", {
                        Volume = 0.3,
                        Pitch = 0.9
                    })
                end
            end
        end
    else
        local v111 = t6[v108]

        if v106 then
            t6[v106] = v111
        end

        t6[v108] = Tool
        Sounds.Play("Pop", {
            Volume = 0.3
        })
    end

    render()
end

local function pointerDown(p23, p24) -- line: 479
    -- upvalues: v13 (ref)
    v13 = v13 or {
        Active = false,
        Item = p23,
        Input = p24,
        Start = Vector2.new(p24.Position.X, p24.Position.Y),
        Button = p23.Visual.Parent
    }
end

local function onInputChanged(p25) -- line: 484
    -- upvalues: v3 (ref), v11 (ref), v13 (ref), startDrag (copy)
    local v114 = v13

    if v114 and (p25.UserInputType == Enum.UserInputType.MouseMovement or p25.UserInputType == Enum.UserInputType.Touch and p25 == v114.Input) then
        local v115 = Vector2.new(p25.Position.X, p25.Position.Y)

        if v114.Active then
            local v116 = v13 and v13.Ghost

            if not v116 then
                return
            end

            local AbsolutePosition = v3.AbsolutePosition

            v116.Position = UDim2.fromOffset(v115.X - AbsolutePosition.X, v115.Y - AbsolutePosition.Y)
        elseif v11 and (v115 - v114.Start).Magnitude > 8 then
            startDrag(v115)
        end
    end
end

local function onInputEnded(p26) -- line: 498
    -- upvalues: ClientState (copy), v13 (ref), Character (ref), drop (copy)
    local v117 = v13

    if not (v117 and (p26.UserInputType == Enum.UserInputType.MouseButton1 or p26.UserInputType == Enum.UserInputType.Touch and p26 == v117.Input)) then
        return
    end

    v13 = nil

    local v118 = Vector2.new(p26.Position.X, p26.Position.Y)

    if v117.Active then
        drop(v117, v118)
    elseif v117.Button then
        local Button = v117.Button

        if Button and Button.Visible then
            local AbsolutePosition, AbsoluteSize = Button.AbsolutePosition, Button.AbsoluteSize

            if v118.X >= AbsolutePosition.X and v118.X <= AbsolutePosition.X + AbsoluteSize.X and v118.Y >= AbsolutePosition.Y and v118.Y <= AbsolutePosition.Y + AbsoluteSize.Y then
                local Tool = v117.Item.Tool

                if Tool and not ClientState.Busy then
                    if ClientState.OfflineOpen then
                        return
                    end

                    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

                    if not (Humanoid and Humanoid.Health > 0) then
                        return
                    end

                    if Character ~= nil and Tool.Parent == Character then
                        Humanoid:UnequipTools()
                    else
                        Humanoid:EquipTool(Tool)
                    end
                end
            end
        end
    end
end

local function hookSlotInput(p27, p28) -- line: 513
    -- upvalues: v13 (ref), showTooltip (copy), hideTooltip (copy)
    p27.InputBegan:Connect(function(p29) -- line: 514
        -- upvalues: p28 (copy), v13 (ref)
        if p29.UserInputType == Enum.UserInputType.MouseButton1 or p29.UserInputType == Enum.UserInputType.Touch then
            local v119 = p28()

            if v119 then
                if v13 then
                    return
                end

                v13 = {
                    Active = false,
                    Item = v119,
                    Input = p29,
                    Start = Vector2.new(p29.Position.X, p29.Position.Y),
                    Button = v119.Visual.Parent
                }
            end
        end
    end)
    p27.MouseEnter:Connect(function() -- line: 519
        -- upvalues: p27 (copy), p28 (copy), showTooltip (copy)
        local v120 = p28()

        if v120 then
            showTooltip(p27, v120.Tool)
        end
    end)
    p27.MouseLeave:Connect(hideTooltip)
end

local function slotBase(p30) -- line: 530
    -- upvalues: v2 (copy)
    local TextButton = Instance.new("TextButton")

    TextButton.Name = p30
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BackgroundColor3 = v2
    TextButton.BackgroundTransparency = 0.3
    TextButton.BorderSizePixel = 0
    TextButton.Selectable = false
    TextButton.ZIndex = 1

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0.16, 0)
    UICorner.Parent = TextButton

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Name = "Outline"
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Thickness = 1.5
    UIStroke.Transparency = 0.55
    UIStroke.Parent = TextButton

    return TextButton
end

function makeInventoryButton(p31) -- line: 552
    -- upvalues: ScrollingFrame (ref), hookSlotInput (copy), slotBase (copy)
    local Item = slotBase("Item")

    Item.Parent = ScrollingFrame
    p31.InvButton = Item
    hookSlotInput(Item, function() -- line: 556
        -- upvalues: p31 (copy)
        return p31
    end)

    return Item
end

local function buildTopButton() -- line: 560
    -- upvalues: GuiService (copy), t1 (copy), LocalPlayer (copy), v1 (copy), ScreenGui (ref), TextButton (ref), v11 (ref)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "InventoryButton"
    ScreenGui.ResetOnSpawn = false

    local ScreenGui2 = ScreenGui

    ScreenGui2.ScreenInsets = Enum.ScreenInsets.TopbarSafeInsets
    ScreenGui.ClipToDeviceSafeArea = false
    ScreenGui.DisplayOrder = 5

    local ScreenGui3 = ScreenGui

    ScreenGui3.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui:SetAttribute("UIScaleIgnore", true)

    local ScreenGui4 = ScreenGui

    ScreenGui4.Parent = LocalPlayer:WaitForChild("PlayerGui")
    TextButton = Instance.new("TextButton")
    TextButton.Name = "Backpack"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BackgroundColor3 = v1
    TextButton.BackgroundTransparency = 0.12
    TextButton.BorderSizePixel = 0

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = TextButton

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Icon"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://135273755533681"
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.Size = UDim2.fromScale(0.72, 0.72)
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.ZIndex = 2
    ImageLabel.Parent = TextButton
    TextButton.Parent = ScreenGui

    local function place() -- line: 598
        -- upvalues: ScreenGui (ref), TextButton (ref)
        local Y = ScreenGui.AbsoluteSize.Y

        if Y > 0 then
            local v122 = math.floor(Y * 0.76 + 0.5)
            local TextButton2 = TextButton

            TextButton2.Size = UDim2.fromOffset(v122, v122)

            local TextButton3 = TextButton

            TextButton3.Position = UDim2.fromOffset(8, (math.max(0, Y - v122 - 2)))
        else
            local TextButton2 = TextButton

            TextButton2.Size = UDim2.fromOffset(44, 44)

            local TextButton3 = TextButton

            TextButton3.Position = UDim2.fromOffset(8, 2)
        end
    end

    place()
    ScreenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(place)

    local function v124() -- line: 612
        -- upvalues: place (copy), GuiService (copy)
        GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(place)
    end

    pcall(v124)
    TextButton.MouseEnter:Connect(function() -- line: 613
        -- upvalues: TextButton (ref), v11 (ref)
        if not v11 then
            TextButton.BackgroundTransparency = 0
        end
    end)
    TextButton.MouseLeave:Connect(function() -- line: 616
        -- upvalues: TextButton (ref), v11 (ref)
        if not v11 then
            TextButton.BackgroundTransparency = 0.12
        end
    end)
    TextButton.Activated:Connect(function() -- line: 619
        -- upvalues: t1 (copy)
        t1.Toggle()
    end)
end

local function build() -- line: 622
    -- upvalues: UITheme (copy), UIKit (copy), t1 (copy), Colors (copy), v3 (ref), v4 (ref), v5 (ref), ScrollingFrame (ref), TextBox (ref), v6 (ref), v7 (ref), v8 (ref), v9 (ref), v10 (ref), t6 (copy), t7 (copy), t8 (copy), queueRender (copy), hookSlotInput (copy), slotBase (copy), buildTopButton (copy)
    v3 = UIKit.ScreenGui("Inventory", 5, false)
    v10 = UIKit.Frame({
        Name = "DragLayer",
        Transparency = 1,
        ZIndex = 40,
        Parent = v3,
        Size = UDim2.fromScale(1, 1)
    })
    v4 = UIKit.Frame({
        Name = "Hotbar",
        Transparency = 1,
        ZIndex = 2,
        Parent = v3,
        Size = UDim2.fromOffset(10, 10),
        Position = UDim2.new(0.5, 0, 1, -8),
        AnchorPoint = Vector2.new(0.5, 1)
    })

    for i = 1, 10 do
        local v125 = slotBase("Slot" .. i)

        v125.Visible = false
        UIKit.Text({
            Name = "Number",
            ZIndex = 5,
            Stroke = 2,
            Parent = v125,
            Text = tostring(i % 10),
            Size = UDim2.fromScale(0.26, 0.26),
            Position = UDim2.fromScale(0.07, 0.95),
            AnchorPoint = Vector2.new(0, 1),
            XAlign = Enum.TextXAlignment.Left
        }).Visible = false
        v125.Parent = v4
        t7[i] = v125
        hookSlotInput(v125, function() -- line: 634
            -- upvalues: i (copy), t6 (copy), t8 (copy)
            local v127 = t6[i]

            return v127 and t8[v127]
        end)
    end

    v5 = UIKit.Frame({
        Name = "InventoryPanel",
        Transparency = 0.2,
        Corner = 14,
        ZIndex = 3,
        Parent = v3,
        Size = UDim2.fromOffset(400, 250),
        AnchorPoint = Vector2.new(0.5, 1),
        Color = Color3.fromRGB(20, 22, 27)
    })
    v5.Visible = false
    UIKit.Stroke(v5, 2, Color3.new(0, 0, 0)).Transparency = 0.4

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "InputSink"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BackgroundTransparency = 1
    TextButton.Size = UDim2.fromScale(1, 1)
    TextButton.ZIndex = 1
    TextButton.Parent = v5
    UIKit.Text({
        Name = "Title",
        Text = "Inventory",
        ZIndex = 4,
        Stroke = 2,
        Parent = v5,
        Size = UDim2.fromScale(0.3, 0.11),
        Position = UDim2.fromScale(0.03, 0.045),
        XAlign = Enum.TextXAlignment.Left
    })

    local v128 = UIKit.Frame({
        Name = "Search",
        Transparency = 0.1,
        Corner = 8,
        ZIndex = 4,
        Parent = v5,
        Size = UDim2.fromScale(0.42, 0.12),
        Position = UDim2.fromScale(0.86, 0.04),
        AnchorPoint = Vector2.new(1, 0),
        Color = Color3.fromRGB(46, 49, 58)
    })

    TextBox = Instance.new("TextBox")
    TextBox.Name = "Box"
    TextBox.BackgroundTransparency = 1

    local TextBox2 = TextBox

    TextBox2.Size = UDim2.fromScale(0.9, 0.7)

    local TextBox3 = TextBox

    TextBox3.Position = UDim2.fromScale(0.5, 0.5)

    local TextBox4 = TextBox

    TextBox4.AnchorPoint = Vector2.new(0.5, 0.5)

    local TextBox5 = TextBox

    TextBox5.FontFace = UITheme.Font
    TextBox.TextScaled = true

    local TextBox6 = TextBox

    TextBox6.TextColor3 = Color3.new(1, 1, 1)
    TextBox.PlaceholderText = "Search"

    local TextBox7 = TextBox

    TextBox7.PlaceholderColor3 = Color3.fromRGB(150, 155, 168)
    TextBox.Text = ""
    TextBox.ClearTextOnFocus = false

    local TextBox8 = TextBox

    TextBox8.TextXAlignment = Enum.TextXAlignment.Left
    TextBox.ZIndex = 5
    TextBox.Parent = v128
    TextBox:GetPropertyChangedSignal("Text"):Connect(queueRender)
    UIKit.Button({
        Name = "Close",
        Text = "X",
        Ratio = 1,
        ZIndex = 5,
        Parent = v5,
        Size = UDim2.fromScale(0.07, 0.12),
        Position = UDim2.fromScale(0.975, 0.04),
        AnchorPoint = Vector2.new(1, 0),
        Colors = {
            Colors.RedA,
            Colors.RedB
        },
        OnClick = function() -- OnClick | line: 672
            -- upvalues: t1 (copy)
            t1.Close()
        end
    })
    ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "Grid"

    local ScrollingFrame2 = ScrollingFrame

    ScrollingFrame2.Size = UDim2.fromScale(0.95, 0.78)

    local ScrollingFrame3 = ScrollingFrame

    ScrollingFrame3.Position = UDim2.fromScale(0.5, 0.97)

    local ScrollingFrame4 = ScrollingFrame

    ScrollingFrame4.AnchorPoint = Vector2.new(0.5, 1)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarThickness = 5

    local ScrollingFrame5 = ScrollingFrame

    ScrollingFrame5.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 210)

    local ScrollingFrame6 = ScrollingFrame

    ScrollingFrame6.VerticalScrollBarInset = Enum.ScrollBarInset.Always

    local ScrollingFrame7 = ScrollingFrame

    ScrollingFrame7.ScrollingDirection = Enum.ScrollingDirection.Y

    local ScrollingFrame8 = ScrollingFrame

    ScrollingFrame8.CanvasSize = UDim2.new()

    local ScrollingFrame9 = ScrollingFrame

    ScrollingFrame9.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.ZIndex = 4
    ScrollingFrame.Parent = v5

    local UIGridLayout = Instance.new("UIGridLayout")

    UIGridLayout.CellSize = UDim2.fromOffset(56, 56)
    UIGridLayout.CellPadding = UDim2.fromOffset(5, 5)
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIGridLayout.Parent = ScrollingFrame

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingTop = UDim.new(0, 4)
    UIPadding.PaddingLeft = UDim.new(0, 4)
    UIPadding.Parent = ScrollingFrame
    v6 = UIKit.Text({
        Name = "Empty",
        Text = "No other items",
        ZIndex = 4,
        Stroke = 2,
        Parent = v5,
        Size = UDim2.fromScale(0.6, 0.12),
        Position = UDim2.fromScale(0.5, 0.55),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Color3.fromRGB(170, 175, 188)
    })
    v7 = UIKit.Frame({
        Name = "Tooltip",
        Transparency = 0.1,
        Corner = 8,
        ZIndex = 30,
        Parent = v3,
        Size = UDim2.fromOffset(280, 0),
        AnchorPoint = Vector2.new(0.5, 1),
        Color = Color3.fromRGB(20, 22, 27)
    })

    local v129 = v7

    v129.AutomaticSize = Enum.AutomaticSize.Y
    v7.Visible = false

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.Padding = UDim.new(0, 2)
    UIListLayout.Parent = v7

    local UIPadding2 = Instance.new("UIPadding")

    for _, v130 in ipairs({ "PaddingTop", "PaddingBottom", "PaddingLeft", "PaddingRight" }) do
        UIPadding2[v130] = UDim.new(0, 6)
    end

    UIPadding2.Parent = v7

    local function tipText(p32, p33, p34) -- line: 712
        -- upvalues: UITheme (copy), v7 (ref)
        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = p32
        TextLabel.BackgroundTransparency = 1
        TextLabel.Size = UDim2.fromScale(1, 0)
        TextLabel.AutomaticSize = Enum.AutomaticSize.Y
        TextLabel.FontFace = UITheme.Font
        TextLabel.TextWrapped = true
        TextLabel.TextColor3 = p33
        TextLabel.TextSize = 16
        TextLabel.LayoutOrder = p34
        TextLabel.ZIndex = 31
        TextLabel.Parent = v7

        return TextLabel
    end

    v8 = tipText("Name", Color3.new(1, 1, 1), 1)
    v9 = tipText("Tip", Color3.fromRGB(190, 195, 208), 2)
    buildTopButton()
end

local function keptSlot(p35) -- line: 738
    -- upvalues: t9 (copy)
    local elapsed = os.clock()

    for _, v131 in pairs(t9) do
        if v131.Slot == p35 and elapsed < v131.Until then
            return true
        end
    end

    return false
end

local function freeSlot() -- line: 747
    -- upvalues: n1 (ref), t6 (copy), keptSlot (copy)
    local v132 = n1

    for i = 1, v132 do
        if not t6[i] and not keptSlot(i) then
            return i
        end
    end

    return nil
end

local function addTool(p36) -- line: 754
    -- upvalues: n1 (ref), t6 (copy), t8 (copy), t9 (copy), v14 (ref), refreshIncome (copy), makeVisual (copy), render (ref), freeSlot (copy)
    if not t8[p36] then
        local t16 = {
            Tool = p36
        }
        local AnimalId = p36:GetAttribute("AnimalId")
        local v133

        if AnimalId then
            v133 = "a:" .. AnimalId
        else
            local EggKey = p36:GetAttribute("EggKey")

            v133 = if EggKey then "e:" .. EggKey else "n:" .. p36.Name
        end

        t16.Key = v133
        t8[p36] = t16
        makeVisual(t16)

        local elapsed = os.clock()

        for v134, v135 in pairs(t9) do
            if v135.Until <= elapsed then
                t9[v134] = nil
            end
        end

        local v136 = t9[t16.Key]

        t9[t16.Key] = nil

        local v137 = if not v136 then freeSlot() elseif v136.Slot then v136.Slot <= n1 and not t6[v136.Slot] and v136.Slot or freeSlot() else nil

        if v137 then
            t6[v137] = p36
        end

        t16.Conns = {
            p36:GetAttributeChangedSignal("Count"):Connect(function() -- line: 776
                -- upvalues: t16 (copy)
                local v138 = t16.Tool:GetAttribute("Count") or 1

                t16.Count.Text = "x" .. v138
                t16.Count.Visible = v138 > 1
            end),
            p36:GetAttributeChangedSignal("Income"):Connect(function() -- line: 777
                -- upvalues: t16 (copy), refreshIncome (copy)
                refreshIncome(t16)
            end)
        }
    end

    if not v14 then
        v14 = true
        task.defer(function() -- line: 228
            -- upvalues: render (ref)
            render()
        end)
    end
end

local function refreshIcons() -- line: 784
    -- upvalues: t8 (copy), v13 (ref), v14 (ref), makeVisual (copy), render (ref)
    for _, v139 in pairs(t8) do
        if v139.Tool:GetAttribute("AnimalName") and (not v13 or v13.Item ~= v139) then
            local Visual = v139.Visual

            makeVisual(v139)

            if Visual then
                Visual:Destroy()
            end
        end
    end

    if not v14 then
        v14 = true
        task.defer(function() -- line: 228
            -- upvalues: render (ref)
            render()
        end)
    end
end

local function removeTool(p37, p38) -- line: 795
    -- upvalues: ScrollingFrame (ref), n1 (ref), t6 (copy), t8 (copy), t9 (copy), v13 (ref), v14 (ref), render (ref)
    local v140 = t8[p37]

    if not v140 then
        return
    end

    t8[p37] = nil

    local v141 = n1
    local v142 = false
    local v143

    for i = 1, v141 do
        if t6[i] == p37 then
            v143 = i
            v142 = true
            break
        end
    end

    if not v142 then
        v143 = nil
    end

    if v143 then
        t6[v143] = nil
    end

    if p38 then
        t9[v140.Key] = {
            Slot = v143 or false,
            Until = os.clock() + 15
        }
    end

    for _, v144 in ipairs(v140.Conns or {}) do
        v144:Disconnect()
    end

    if v13 and v13.Item == v140 then
        local v145 = v13

        if v145 then
            if v145.Ghost then
                if v145.Item.Visual.Parent == v145.Ghost then
                    v145.Item.Visual.Parent = nil
                end

                v145.Ghost:Destroy()
                v145.Ghost = nil
            end

            ScrollingFrame.ScrollingEnabled = true
        end

        v13 = nil
    end

    if v140.InvButton then
        v140.InvButton:Destroy()
    end

    v140.Visual:Destroy()

    if not v14 then
        v14 = true
        task.defer(function() -- line: 228
            -- upvalues: render (ref)
            render()
        end)
    end
end

local function containerGone(p39) -- line: 815
    -- upvalues: LocalPlayer (copy)
    if p39:IsA("Backpack") then
        return p39.Parent ~= LocalPlayer
    end

    if p39.Parent == nil then
        return true
    end

    return LocalPlayer.Character ~= p39
end

local function checkTool(p40, p41) -- line: 821
    -- upvalues: LocalPlayer (copy), v14 (ref), Backpack (ref), Character (ref), render (ref), removeTool (copy)
    local Parent = p40.Parent

    if Parent ~= nil and (Parent == Backpack or Parent == Character) then
        if not v14 then
            v14 = true
            task.defer(function() -- line: 228
                -- upvalues: render (ref)
                render()
            end)
        end
    else
        removeTool(p40, if p41:IsA("Backpack") then p41.Parent ~= LocalPlayer else p41.Parent == nil or LocalPlayer.Character ~= p41)
    end
end

local function watch(p42) -- line: 830
    -- upvalues: t11 (ref), addTool (copy), checkTool (copy)
    for _, child in ipairs(p42:GetChildren()) do
        if child:IsA("Tool") then
            addTool(child)
        end
    end

    local t17 = t11

    table.insert(t17, p42.ChildAdded:Connect(function(p43) -- line: 834
        -- upvalues: addTool (copy)
        if p43:IsA("Tool") then
            addTool(p43)
        end
    end))

    local t18 = t11

    table.insert(t18, p42.ChildRemoved:Connect(function(p44) -- line: 837
        -- upvalues: p42 (copy), checkTool (copy)
        if p44:IsA("Tool") then
            task.defer(checkTool, p44, p42)
        end
    end))
end

local function rewatch() -- line: 842
    -- upvalues: LocalPlayer (copy), t8 (copy), v14 (ref), Backpack (ref), Character (ref), t11 (ref), render (ref), removeTool (copy), watch (copy)
    for _, v149 in ipairs(t11) do
        v149:Disconnect()
    end

    t11 = {}
    Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    Character = LocalPlayer.Character

    for v150 in pairs(t8) do
        if v150.Parent == nil or v150.Parent ~= Backpack and v150.Parent ~= Character then
            removeTool(v150, true)
        end
    end

    if Backpack then
        watch(Backpack)
    end

    if Character then
        watch(Character)
    end

    if not v14 then
        v14 = true
        task.defer(function() -- line: 228
            -- upvalues: render (ref)
            render()
        end)
    end
end

local function anyOpen(p45) -- line: 860
    -- upvalues: ClientState (copy)
    for _, v151 in ipairs(p45) do
        if ClientState[v151] then
            return true
        end
    end

    return false
end

local function bigWindowOpen() -- line: 867
    -- upvalues: ClientState (copy), t3 (copy)
    for _, v152 in ipairs(t3) do
        if ClientState[v152] then
            return true
        end
    end

    return false
end

function t1.Open() -- line: 871
    -- upvalues: Parent (copy), UIKit (copy), Sounds (copy), ClientState (copy), t5 (copy), v3 (ref), v5 (ref), v11 (ref), v12 (ref), render (ref)
    if not v11 and v3 and not ClientState.Busy and not ClientState.OfflineOpen then
        for _, v153 in ipairs(t5) do
            if ClientState[v153[2]] then
                local _require = require
                local v154 = Parent[v153[1]]
                local ok, result = pcall(_require, v154)

                if ok and result.Close then
                    result.Close()
                end
            end
        end

        v11 = true
        ClientState.InventoryOpen = true
        v12 = false
        render()
        UIKit.PopIn(v5, 0.25, 0.85)
        Sounds.Play("Slide", {
            Volume = 0.5
        })
    end
end

function t1.Close() -- line: 888
    -- upvalues: Sounds (copy), ClientState (copy), ScrollingFrame (ref), TextBox (ref), v7 (ref), v11 (ref), v13 (ref), render (ref)
    if not v11 then
        return
    end

    v11 = false
    ClientState.InventoryOpen = false

    if TextBox:IsFocused() then
        TextBox:ReleaseFocus()
    end

    if v13 then
        local v155 = v13

        if v155 then
            if v155.Ghost then
                if v155.Item.Visual.Parent == v155.Ghost then
                    v155.Item.Visual.Parent = nil
                end

                v155.Ghost:Destroy()
                v155.Ghost = nil
            end

            ScrollingFrame.ScrollingEnabled = true
        end

        v13 = nil
    end

    v7.Visible = false
    Sounds.Play("Slide", {
        Volume = 0.2
    })
    render()
end

function t1.Toggle() -- line: 902
    -- upvalues: t1 (copy), v11 (ref)
    if v11 then
        t1.Close()
    else
        t1.Open()
    end
end

function t1.IsOpen() -- line: 906
    -- upvalues: v11 (ref)
    return v11
end

function t1.GetAnimalSlot() -- line: 911
    -- upvalues: n1 (ref), t6 (copy), t7 (copy), v12 (ref)
    for i = 1, n1 do
        local v157 = t6[i]

        if v157 and v157:GetAttribute("AnimalId") and t7[i].Visible and not v12 then
            return t7[i]
        end
    end

    return nil
end

function t1.GetButton() -- line: 922
    -- upvalues: TextButton (ref)
    return TextButton
end

function t1.Init() -- line: 930
    -- upvalues: UserInputService (copy), RunService (copy), StarterGui (copy), TweenService (copy), AnimalTemplates (copy), ClientState (copy), HUDController (copy), UIScaler (copy), t1 (copy), LocalPlayer (copy), t2 (copy), t3 (copy), t4 (copy), v3 (ref), v4 (ref), v7 (ref), n1 (ref), t6 (copy), t8 (copy), v11 (ref), v12 (ref), v14 (ref), t10 (copy), Character (ref), v15 (ref), refreshIncome (copy), render (ref), queueRender (copy), onInputChanged (copy), onInputEnded (copy), build (copy), refreshIcons (copy), rewatch (copy)
    task.spawn(function() -- line: 932
        -- upvalues: StarterGui (copy)
        for _ = 1, 20 do
            local function v158() -- line: 934
                -- upvalues: StarterGui (copy)
                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
            end

            if pcall(v158) then
                break
            end

            task.wait(0.5)
        end
    end)
    n1 = UIScaler.IsTouch() and 7 or 10
    build()
    LocalPlayer.CharacterAdded:Connect(function() -- line: 941
        -- upvalues: rewatch (copy)
        task.defer(rewatch)
    end)
    LocalPlayer.ChildAdded:Connect(function(p46) -- line: 942
        -- upvalues: rewatch (copy)
        if p46:IsA("Backpack") then
            task.defer(rewatch)
        end
    end)
    rewatch()
    UserInputService.InputBegan:Connect(function(p47, p48) -- line: 947
        -- upvalues: ClientState (copy), t1 (copy), t2 (copy), n1 (ref), t6 (copy), v12 (ref), Character (ref)
        if p48 then
            return
        end

        if p47.KeyCode == Enum.KeyCode.Backquote then
            t1.Toggle()
        else
            local v159 = t2[p47.KeyCode]

            if v159 and v159 <= n1 and not v12 then
                local v160 = t6[v159]

                if v160 and not ClientState.Busy then
                    if ClientState.OfflineOpen then
                        return
                    end

                    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

                    if not (Humanoid and Humanoid.Health > 0) then
                        return
                    end

                    if Character ~= nil and v160.Parent == Character then
                        Humanoid:UnequipTools()
                    else
                        Humanoid:EquipTool(v160)
                    end
                end
            end
        end
    end)
    UserInputService.InputChanged:Connect(onInputChanged)
    UserInputService.InputEnded:Connect(onInputEnded)
    AnimalTemplates.Changed:Connect(refreshIcons)
    v3:GetPropertyChangedSignal("AbsoluteSize"):Connect(queueRender)
    UIScaler.Changed:Connect(queueRender)
    LocalPlayer:GetAttributeChangedSignal("CashMultiplier"):Connect(function() -- line: 964
        -- upvalues: t8 (copy), refreshIncome (copy)
        for _, v161 in pairs(t8) do
            refreshIncome(v161)
        end
    end)

    local function followStats(p49) -- line: 967
        -- upvalues: v14 (ref), render (ref), queueRender (copy)
        p49:GetPropertyChangedSignal("AbsoluteSize"):Connect(queueRender)

        if not v14 then
            v14 = true
            task.defer(function() -- line: 228
                -- upvalues: render (ref)
                render()
            end)
        end
    end

    HUDController.StatsReady:Connect(followStats)

    if HUDController.GetStatsContainer() then
        HUDController.GetStatsContainer():GetPropertyChangedSignal("AbsoluteSize"):Connect(queueRender)

        if not v14 then
            v14 = true
            task.defer(function() -- line: 228
                -- upvalues: render (ref)
                render()
            end)
        end
    end

    local v162 = false

    RunService.Heartbeat:Connect(function() -- line: 976
        -- upvalues: v162 (ref), TweenService (copy), ClientState (copy), t1 (copy), t3 (copy), t4 (copy), v4 (ref), v7 (ref), v11 (ref), v12 (ref), v14 (ref), t10 (copy), v15 (ref), render (ref), queueRender (copy)
        local v163 = false
        local v164

        for _, v165 in ipairs(t3) do
            if ClientState[v165] then
                v164 = true
                v163 = true
                break
            end
        end

        if not v163 then
            v164 = false
        end

        if v11 then
            local v166 = false
            local v167

            for _, v168 in ipairs(t4) do
                if ClientState[v168] then
                    v167 = true
                    v166 = true
                    break
                end
            end

            if not v166 then
                v167 = false
            end

            if v167 or ClientState.Busy then
                t1.Close()
            end
        end

        if ClientState.AnimalsOpen == true ~= v162 then
            v162 = ClientState.AnimalsOpen == true

            if not v14 then
                v14 = true
                task.defer(function() -- line: 228
                    -- upvalues: render (ref)
                    render()
                end)
            end

            task.delay(0.45, queueRender)
        end

        if v164 == v12 then
            return
        end

        v12 = v164
        v7.Visible = false

        local v169 = v12 and UDim2.new(0.5, 0, 1, t10.Slot + t10.Margin * 4) or UDim2.new(0.5, 0, 1, -t10.Margin)

        v15 = TweenService:Create(v4, TweenInfo.new(0.25, Enum.EasingStyle.Quad, v12 and Enum.EasingDirection.In or Enum.EasingDirection.Out), {
            Position = v169
        })
        v15:Play()
        task.delay(0.26, queueRender)
    end)
end

return t1
