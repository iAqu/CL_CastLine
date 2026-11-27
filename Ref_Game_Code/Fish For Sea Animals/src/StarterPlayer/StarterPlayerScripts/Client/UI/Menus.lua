-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(ReplicatedStorage.Shared.Config)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.UIUtil)
local AnimalsPanel = require(script.Parent.AnimalsPanel)
local IndexPanel = require(script.Parent.IndexPanel)
local RebirthPanel = require(script.Parent.RebirthPanel)
local PlaytimePanel = require(script.Parent.PlaytimePanel)
local FeedbackPanel = require(script.Parent.FeedbackPanel)
local SurveyPanel = require(script.Parent.SurveyPanel)
local SettingsPanel = require(script.Parent.SettingsPanel)
local PowerPanel = require(script.Parent.PowerPanel)
local UpdateLog = require(script.Parent.UpdateLog)
local TradePanel = require(script.Parent.TradePanel)
local TradeRequest = require(script.Parent.TradeRequest)
local Shop = require(script.Parent.Parent.Shop.Shop)
local t1 = {}
local v1 = Color3.fromRGB(20, 20, 30)
local v2 = Color3.fromRGB(235, 50, 60)

local function makeBadge(p1) -- line: 33
    -- upvalues: Config (copy), v1 (copy), v2 (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = "NewBadge"
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.new(1, -16, 0, 18)
    Frame.Size = UDim2.fromOffset(44, 44)
    Frame.BackgroundColor3 = v2
    Frame.ZIndex = 5
    Frame.Visible = false

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = Frame

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 3
    UIStroke.Color = v1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Frame

    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.fromScale(1, 1)
    TextLabel.FontFace = Config.Font
    TextLabel.Text = "!"
    TextLabel.TextScaled = true
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.ZIndex = 6

    local UIPadding = Instance.new("UIPadding")
    local v3 = UDim.new(0, 6)
    local v4 = UDim.new(0, 6)

    UIPadding.PaddingTop = v3
    UIPadding.PaddingBottom = v4
    UIPadding.Parent = TextLabel

    local UIStroke2 = Instance.new("UIStroke")

    UIStroke2.Thickness = 2
    UIStroke2.Color = v1
    UIStroke2.Parent = TextLabel
    TextLabel.Parent = Frame

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "Pulse"
    UIScale.Parent = Frame
    Frame.Parent = p1

    return Frame, UIScale
end

local function indexBadge(p2) -- line: 74
    -- upvalues: RunService (copy), IndexPanel (copy), makeBadge (copy)
    local v5, v6 = makeBadge(p2)
    local n1 = 0

    RunService.RenderStepped:Connect(function() -- line: 77
        -- upvalues: v5 (copy), v6 (copy), n1 (ref), IndexPanel (copy)
        if os.clock() >= n1 then
            n1 = os.clock() + 0.5
            v5.Visible = not IndexPanel.isOpen() and IndexPanel.claimable() > 0
        end

        if v5.Visible then
            v6.Scale = math.abs((math.sin(os.clock() * 5))) * 0.18 + 1
        end
    end)
end

local function shopBadge(p3) -- line: 89
    -- upvalues: Players (copy), RunService (copy), Config (copy), Remotes (copy), Shop (copy), makeBadge (copy)
    local LocalPlayer = Players.LocalPlayer
    local v10, v11 = makeBadge(p3)
    local v12 = false

    RunService.RenderStepped:Connect(function() -- line: 93
        -- upvalues: LocalPlayer (copy), v10 (copy), v11 (copy), v12 (ref), Config (copy), Remotes (copy), Shop (copy)
        if Shop.isOpen() then
            if not v12 then
                v12 = true
                Remotes.Tutorial:FireServer("ShopOpened")
            end

            v10.Visible = false
        else
            local v13 = not v12 and LocalPlayer:GetAttribute("ShopOpened") == false
            local v14 = (LocalPlayer:GetAttribute("Tutorial") or 0) >= Config.TutorialDone and workspace:GetServerTimeNow() >= (LocalPlayer:GetAttribute("FreeGiftReady") or 1e999)

            v10.Visible = v13 or v14

            if v10.Visible then
                v11.Scale = math.abs((math.sin(os.clock() * 5))) * 0.18 + 1
            end
        end
    end)
end

local function shopWiggle(p4) -- line: 114
    -- upvalues: UIUtil (copy)
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Icon"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.Image = p4.Image
    ImageLabel.ScaleType = p4.ScaleType
    ImageLabel.Parent = p4
    p4.ImageTransparency = 1

    local UIScale = Instance.new("UIScale")

    UIScale.Parent = ImageLabel
    task.spawn(function() -- line: 127
        -- upvalues: ImageLabel (copy), UIScale (copy), UIUtil (copy)
        while true do
            task.wait(4)
            UIUtil.tween(UIScale, 0.12, {
                Scale = 1.18
            }, Enum.EasingStyle.Quad)

            for _, v17 in { -14, 12, -9, 6, -3, 0 } do
                UIUtil.tween(ImageLabel, 0.07, {
                    Rotation = v17
                })
                task.wait(0.07)
            end

            UIUtil.tween(UIScale, 0.25, {
                Scale = 1
            }, Enum.EasingStyle.Back)
        end
    end)
end

local function plusButton(p5, p6) -- line: 142
    -- upvalues: UIUtil (copy), t1 (copy)
    UIUtil.bindButton(p5:WaitForChild("Plus"), function() -- line: 143
        -- upvalues: p6 (copy), t1 (copy)
        t1.open("Shop", p6)
    end)
end

local t2 = {
    Animals = AnimalsPanel,
    Index = IndexPanel,
    Rebirth = RebirthPanel,
    Shop = Shop,
    Playtime = PlaytimePanel,
    Feedback = FeedbackPanel,
    Survey = SurveyPanel,
    Settings = SettingsPanel,
    Power = PowerPanel,
    UpdateLog = UpdateLog,
    Trade = TradePanel
}

function t1.closeAll(p7) -- line: 162
    -- upvalues: t2 (copy)
    for v18, v19 in t2 do
        if v18 ~= p7 and v19.isOpen() then
            task.spawn(v19.close)
        end
    end
end

function t1.toggle(p8) -- line: 170
    -- upvalues: t1 (copy), t2 (copy)
    local v20 = t2[p8]

    if v20.isOpen() then
        task.spawn(v20.close)
    else
        t1.closeAll(p8)
        v20.open()
    end
end

function t1.open(p9, ...) -- line: 181
    -- upvalues: t1 (copy), t2 (copy)
    t1.closeAll(p9)
    t2[p9].open(...)
end

local function topButton(p10, p11, p12, p13, p14) -- line: 187
    local v21 = (p14 or p10.Parent):FindFirstChild(p11)

    if v21 then
        return v21
    end

    local clone = p10:Clone()

    clone.Name = p11
    clone.LayoutOrder = p10.LayoutOrder + p13

    for _, child in clone:GetChildren() do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Icon"
    TextLabel.BackgroundTransparency = 1
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    TextLabel.Position = UDim2.fromScale(0.5, 0.5)
    TextLabel.Size = UDim2.fromScale(0.62, 0.62)
    TextLabel.TextScaled = true
    TextLabel.Text = p12
    TextLabel.Parent = clone
    clone.Parent = p14 or p10.Parent

    return clone
end

local function tradeButton(p15) -- line: 217
    local Trade = p15:FindFirstChild("Trade")

    if Trade then
        return Trade
    end

    local clone = p15:FindFirstChild("Index"):Clone()

    clone.Name = "Trade"

    for _, child in clone:GetChildren() do
        if child:IsA("GuiObject") and child.Name:find("Badge") then
            child:Destroy()
        end
    end

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("TextLabel") then
            descendant.Text = "TRADE"
        end
    end

    if clone:IsA("ImageButton") then
        clone.Image = "rbxassetid://90065015215342"
    end

    local n2 = 0

    for _, child in p15:GetChildren() do
        if child:IsA("GuiObject") then
            n2 = math.max(n2, child.LayoutOrder)
        end
    end

    clone.LayoutOrder = n2 + 1
    clone.Parent = p15

    return clone
end

local function gridColumn(p16) -- line: 264
    if p16:FindFirstChildOfClass("UIGridLayout") then
        return
    end

    local t3 = {}

    for _, child in p16:GetChildren() do
        if child:IsA("GuiButton") then
            table.insert(t3, child)
        end
    end

    local UIListLayout = p16:FindFirstChildOfClass("UIListLayout")
    local v22 = if UIListLayout then UIListLayout.Padding.Offset else 10
    local Size = t3[1].Size
    local v23 = if Size.X.Offset > 0 then Size.X.Offset else p16.Size.X.Offset * Size.X.Scale
    local v24 = if Size.Y.Offset > 0 then Size.Y.Offset else (p16.Size.Y.Offset - v22 * (#t3 - 2)) / (#t3 - 1)
    local v25 = UDim2.fromOffset(v23, v24)

    if UIListLayout then
        UIListLayout:Destroy()
    end

    local UIGridLayout = Instance.new("UIGridLayout")

    UIGridLayout.CellSize = UDim2.fromOffset(v25.X.Offset, v25.Y.Offset)
    UIGridLayout.CellPadding = UDim2.fromOffset(v22, v22)
    UIGridLayout.FillDirection = Enum.FillDirection.Horizontal
    UIGridLayout.FillDirectionMaxCells = 2
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    UIGridLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    UIGridLayout.Parent = p16

    local v27 = math.ceil(#t3 / 2)

    p16.Size = UDim2.fromOffset(v25.X.Offset * 2 + v22, v25.Y.Offset * v27 + v22 * (v27 - 1))
end

function t1.init() -- line: 297
    -- upvalues: Players (copy), RunService (copy), Config (copy), Remotes (copy), UIUtil (copy), AnimalsPanel (copy), IndexPanel (copy), RebirthPanel (copy), PlaytimePanel (copy), FeedbackPanel (copy), SurveyPanel (copy), SettingsPanel (copy), PowerPanel (copy), UpdateLog (copy), TradePanel (copy), TradeRequest (copy), Shop (copy), t1 (copy), makeBadge (copy), shopWiggle (copy), topButton (copy), tradeButton (copy), gridColumn (copy)
    AnimalsPanel.init()
    IndexPanel.init()
    RebirthPanel.init()
    SurveyPanel.init()
    SettingsPanel.init()
    TradePanel.init()
    TradeRequest.init()

    TradePanel.onOpen = function() -- line: 305
        -- upvalues: t1 (copy)
        t1.open("Trade")
    end

    Shop.init()

    local HUD = UIUtil.gui("HUD")
    local SideLeft = HUD:WaitForChild("SideLeft")
    local SideRight = HUD:WaitForChild("SideRight")

    tradeButton(SideLeft)
    gridColumn(SideLeft)

    for _, v28 in { "Index", "Rebirth", "Shop", "Trade" } do
        UIUtil.bindButton(SideLeft[v28], function() -- line: 314
            -- upvalues: v28 (copy), t1 (copy)
            t1.toggle(v28)
        end)
    end

    UIUtil.bindButton(SideRight.Animals, function() -- line: 318
        -- upvalues: t1 (copy)
        t1.toggle("Animals")
    end)
    shopWiggle(SideLeft.Shop)

    local Shop2 = SideLeft.Shop
    local LocalPlayer = Players.LocalPlayer
    local v29, v30 = makeBadge(Shop2)
    local v31 = false

    RunService.RenderStepped:Connect(function() -- line: 93
        -- upvalues: LocalPlayer (copy), v29 (copy), v30 (copy), v31 (ref), Config (copy), Remotes (copy), Shop (copy)
        if Shop.isOpen() then
            if not v31 then
                v31 = true
                Remotes.Tutorial:FireServer("ShopOpened")
            end

            v29.Visible = false
        else
            local v32 = not v31 and LocalPlayer:GetAttribute("ShopOpened") == false
            local v33 = (LocalPlayer:GetAttribute("Tutorial") or 0) >= Config.TutorialDone and workspace:GetServerTimeNow() >= (LocalPlayer:GetAttribute("FreeGiftReady") or 1e999)

            v29.Visible = v32 or v33

            if v29.Visible then
                v30.Scale = math.abs((math.sin(os.clock() * 5))) * 0.18 + 1
            end
        end
    end)

    local v36, v37 = makeBadge(SideLeft.Index)
    local n3 = 0

    RunService.RenderStepped:Connect(function() -- line: 77
        -- upvalues: v36 (copy), v37 (copy), n3 (ref), IndexPanel (copy)
        if os.clock() >= n3 then
            n3 = os.clock() + 0.5
            v36.Visible = not IndexPanel.isOpen() and IndexPanel.claimable() > 0
        end

        if v36.Visible then
            v37.Scale = math.abs((math.sin(os.clock() * 5))) * 0.18 + 1
        end
    end)

    local Stats = HUD:WaitForChild("Stats")
    local Icon = Stats:WaitForChild("Money"):WaitForChild("Icon")
    local bindButton = UIUtil.bindButton
    local Plus = Icon:WaitForChild("Plus")
    local v41 = "Cash"

    bindButton(Plus, function() -- line: 143
        -- upvalues: v41 (copy), t1 (copy)
        t1.open("Shop", v41)
    end)

    local Icon2 = Stats:WaitForChild("Strength"):WaitForChild("Icon")
    local bindButton2 = UIUtil.bindButton
    local Plus2 = Icon2:WaitForChild("Plus")
    local v42 = "Strength"

    bindButton2(Plus2, function() -- line: 143
        -- upvalues: v42 (copy), t1 (copy)
        t1.open("Shop", v42)
    end)
    PowerPanel.init(Stats:WaitForChild("Strength"), function() -- line: 328
        -- upvalues: t1 (copy)
        t1.toggle("Power")
    end)

    local DailyRewards = HUD:WaitForChild("TopRightButtons"):WaitForChild("DailyRewards")
    local v43 = topButton(DailyRewards, "Feedback", "✉️", -1)
    local v44 = topButton(DailyRewards, "UpdateLog", "📜", -2)
    local v45 = topButton(DailyRewards, "Settings", "⚙️", 2, HUD:WaitForChild("TopLeftButtons"))

    UpdateLog.init()
    UIUtil.bindButton(v44, function() -- line: 339
        -- upvalues: t1 (copy)
        t1.toggle("UpdateLog")
    end)
    UIUtil.bindButton(v45, function() -- line: 342
        -- upvalues: t1 (copy)
        t1.toggle("Settings")
    end)
    FeedbackPanel.init(function(p17) -- line: 345
        -- upvalues: t1 (copy)
        t1.open("Feedback", p17)
    end)
    UIUtil.bindButton(v43, function() -- line: 348
        -- upvalues: t1 (copy)
        t1.toggle("Feedback")
    end)
    PlaytimePanel.init(DailyRewards)
    UIUtil.bindButton(DailyRewards, function() -- line: 352
        -- upvalues: t1 (copy)
        t1.toggle("Playtime")
    end)
end

return t1
