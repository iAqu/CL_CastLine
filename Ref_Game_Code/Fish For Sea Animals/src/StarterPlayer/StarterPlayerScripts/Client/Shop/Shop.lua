-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local Animals = require(ReplicatedStorage.Shared.Animals)
local Config = require(ReplicatedStorage.Shared.Config)
local Products = require(ReplicatedStorage.Shared.Products)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local RodBuilder = require(ReplicatedStorage.Shared.RodBuilder)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Robux = require(script.Parent.Robux)
local Style = require(script.Parent.Style)
local Fx = require(script.Parent.Fx)
local Featured = require(script.Parent.Featured)
local Boosts = require(script.Parent.Boosts)
local Cash = require(script.Parent.Cash)
local Timers = require(script.Parent.Timers)
local StarterPack = require(script.Parent.StarterPack)
local Gift = require(script.Parent.Gift)
local Tabs = require(script.Parent.Tabs)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local W = Tabs.W
local v1 = 22 + W + 26
local v2 = v1 + Style.WIDTH + 34
local ScreenGui, v3
local t2 = {}
local ScrollingFrame
local t3 = {}
local v4 = {}
local v5 = {}
local v6
local v7 = false

local function refreshAll() -- line: 55
    -- upvalues: t2 (copy)
    for _, v8 in t2 do
        task.spawn(v8)
    end
end

local function onRefresh(p1) -- line: 61
    -- upvalues: t2 (copy)
    table.insert(t2, p1)
end

local t4 = {
    {
        Name = "Featured",
        Title = "FEATURED",
        Emoji = "⭐",
        Color = Style.CORAL,
        Build = Featured.build
    },
    {
        Name = "Passes",
        Title = "GAME PASSES",
        Emoji = "👑",
        Color = Style.GOLD,
        Build = Boosts.buildPasses
    },
    {
        Name = "Boosts",
        Title = "BOOSTS",
        Color = Style.SEAFOAM,
        Image = Config.Icons.Luck,
        Build = Boosts.buildBoosts
    },
    {
        Name = "Cash",
        Title = "CASH",
        Color = Style.KELP,
        Image = Config.Icons.Cash,
        Build = Cash.buildCash
    },
    {
        Name = "Strength",
        Title = "STRENGTH",
        Color = Style.OCEAN,
        Image = Config.Icons.Strength,
        Build = Cash.buildStrength
    }
}

local function cardsInView() -- line: 74
    -- upvalues: ScrollingFrame (ref)
    local t5 = {}

    for _, child in ScrollingFrame:GetChildren() do
        if child:IsA("GuiObject") and child.Visible and child.Name:sub(1, 3) == "Row" then
            table.insert(t5, child)
        end
    end

    table.sort(t5, function(p2, p3) -- line: 81
        return p2.LayoutOrder < p3.LayoutOrder
    end)

    local v9 = ScrollingFrame.AbsolutePosition.Y + ScrollingFrame.AbsoluteWindowSize.Y
    local t6 = {}

    for _, v10 in t5 do
        if v10.AbsolutePosition.Y < v9 and v10.AbsolutePosition.Y + v10.AbsoluteSize.Y > ScrollingFrame.AbsolutePosition.Y then
            for _, child in v10:GetChildren() do
                if child:IsA("GuiObject") and child.Visible then
                    table.insert(t6, child)
                end
            end
        end
    end

    return t6
end

local function light(p4) -- line: 99
    -- upvalues: UIUtil (copy), Kit (copy), Style (copy), v4 (ref), v5 (ref), v6 (ref), t4 (copy)
    if v6 == p4 then
        return
    end

    v6 = p4

    for _, v11 in t4 do
        local v12 = v11.Name == p4
        local v14 = v4
        local v13 = v14[v11.Name]

        if v12 then
            v13.BackgroundColor3 = v11.Color
        else
            v13.BackgroundColor3 = v11.Color:Lerp(Style.DEEP, 0.55)
        end

        local UIStroke = v13.UIStroke

        if v12 then
            UIStroke.Color = Color3.new(1, 1, 1)
        else
            UIStroke.Color = Kit.INK
        end

        v13.Notch.Visible = v12
        v13.Notch.BackgroundColor3 = v13.BackgroundColor3

        local tween = UIUtil.tween
        local v15 = v5

        tween(v13, 0.18, {
            Position = v15[v11.Name] + UDim2.fromOffset(v12 and 14 or 0, 0)
        })
    end
end

local function offsetOf(p5) -- line: 116
    -- upvalues: ScrollingFrame (ref), t3 (copy)
    return t3[p5].AbsolutePosition.Y - ScrollingFrame.AbsolutePosition.Y + ScrollingFrame.CanvasPosition.Y
end

local function maxScroll() -- line: 121
    -- upvalues: ScrollingFrame (ref)
    return (math.max(0, ScrollingFrame.AbsoluteCanvasSize.Y - ScrollingFrame.AbsoluteWindowSize.Y))
end

local function jump(p6, p7) -- line: 126
    -- upvalues: UIUtil (copy), ScrollingFrame (ref), t3 (copy), v7 (ref), light (copy)
    if t3[p6] then
        light(p6)

        local v20 = Vector2.new(0, (math.clamp(t3[p6].AbsolutePosition.Y - ScrollingFrame.AbsolutePosition.Y + ScrollingFrame.CanvasPosition.Y, 0, (math.max(0, ScrollingFrame.AbsoluteCanvasSize.Y - ScrollingFrame.AbsoluteWindowSize.Y)))))

        if p7 then
            ScrollingFrame.CanvasPosition = v20
        else
            v7 = true
            UIUtil.tween(ScrollingFrame, 0.45, {
                CanvasPosition = v20
            }, Enum.EasingStyle.Quint).Completed:Once(function() -- line: 138
                -- upvalues: v7 (ref)
                v7 = false
            end)
        end
    end
end

local function follow() -- line: 144
    -- upvalues: ScrollingFrame (ref), t3 (copy), v7 (ref), t4 (copy), light (copy)
    if v7 then
        return
    end

    if ScrollingFrame.CanvasPosition.Y >= math.max(0, ScrollingFrame.AbsoluteCanvasSize.Y - ScrollingFrame.AbsoluteWindowSize.Y) - 2 then
        light(t4[#t4].Name)
    else
        local v22 = ScrollingFrame.AbsolutePosition.Y + ScrollingFrame.AbsoluteWindowSize.Y * 0.3
        local Name = t4[1].Name

        for _, v23 in t4 do
            if t3[v23.Name].AbsolutePosition.Y <= v22 then
                Name = v23.Name
            end
        end

        light(Name)
    end
end

function t1.isOpen() -- line: 162
    -- upvalues: ScreenGui (ref)
    return ScreenGui ~= nil and ScreenGui.Enabled
end

function t1.open(p8) -- line: 167
    -- upvalues: UIUtil (copy), Fx (copy), Cash (copy), Gift (copy), t1 (copy), ScreenGui (ref), t2 (copy), ScrollingFrame (ref), t3 (copy), v6 (ref), t4 (copy), cardsInView (copy), light (copy), jump (copy)
    if t1.isOpen() then
        jump(p8 or v6 or "Featured")
    else
        for _, v24 in t2 do
            task.spawn(v24)
        end

        UIUtil.sound("ShopBell", 0.8)
        Fx.start()
        ScrollingFrame.CanvasPosition = Vector2.zero
        v6 = nil
        light(t4[1].Name)
        UIUtil.openPanel(ScreenGui)
        task.delay(0.3, function() -- line: 180
            -- upvalues: p8 (copy), Fx (copy), t1 (copy), ScrollingFrame (ref), t3 (copy), cardsInView (copy), light (copy)
            if not t1.isOpen() then
                return
            end

            if p8 and t3[p8] then
                light(p8)

                local v28 = Vector2.new(0, (math.clamp(t3[p8].AbsolutePosition.Y - ScrollingFrame.AbsolutePosition.Y + ScrollingFrame.CanvasPosition.Y, 0, (math.max(0, ScrollingFrame.AbsoluteCanvasSize.Y - ScrollingFrame.AbsoluteWindowSize.Y)))))

                ScrollingFrame.CanvasPosition = v28
            end

            Fx.stagger((cardsInView()))
        end)
        task.spawn(function() -- line: 189
            -- upvalues: Fx (copy), Cash (copy), Gift (copy), t1 (copy), t2 (copy)
            while t1.isOpen() do
                task.wait(0.5)

                for _, v29 in t2 do
                    task.spawn(v29)
                end
            end

            Fx.stop()
            Cash.setNeed(nil)
            Gift.close()
        end)
    end
end

function t1.close() -- line: 200
    -- upvalues: UIUtil (copy), ScreenGui (ref)
    UIUtil.closePanel(ScreenGui)
end

local function buildBanner() -- line: 205
    -- upvalues: Kit (copy), Style (copy), Fx (copy), t1 (copy), W (copy), v3 (ref)
    local v30 = Kit.frame(v3, {
        Name = "Banner",
        Rotation = -3,
        ZIndex = 20,
        BackgroundColor3 = Color3.new(1, 1, 1),
        Position = UDim2.fromOffset(14, -46),
        Size = UDim2.fromOffset(W + 70, 104)
    })

    Kit.corner(v30, 22)
    Kit.stroke(v30, 6)
    Style.gradient(v30, ColorSequence.new(Style.TEAL, Style.OCEAN))
    Kit.studs(v30, 0.6, 40, 22).ZIndex = 20
    Fx.shine(v30, 4.5, 0.3, 0.35)

    local v31 = Style.bubble(v30, "🐚", {
        ZIndex = 21,
        Position = UDim2.fromOffset(10, 8),
        Size = UDim2.fromOffset(88, 88)
    })

    Fx.wiggle(v31, 10, 3.2)

    local v32 = Kit.text(v30, "SHOP", {
        ZIndex = 22,
        StrokeThickness = 7,
        Position = UDim2.fromOffset(100, 8),
        Size = UDim2.new(1, -112, 1, -16)
    })

    Style.gradient(v32, ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(190, 245, 255)))
    Kit.button(v3, "X", Color3.fromRGB(235, 70, 70), {
        Name = "Close",
        ZIndex = 20,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(1, -18, 0, 18),
        Size = UDim2.fromOffset(92, 92)
    }, function() -- line: 234
        -- upvalues: t1 (copy)
        task.spawn(t1.close)
    end).Label.ZIndex = 21
end

local function buildBody() -- line: 245
    -- upvalues: Style (copy), Fx (copy), v1 (copy), v3 (ref), ScrollingFrame (ref), t3 (copy), onRefresh (copy), t4 (copy), follow (copy)
    ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "Body"
    ScrollingFrame:SetAttribute("ShopPage", "Body")
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0

    local ScrollingFrame2 = ScrollingFrame

    ScrollingFrame2.Position = UDim2.fromOffset(v1, 22)

    local ScrollingFrame3 = ScrollingFrame

    ScrollingFrame3.Size = UDim2.new(1, -v1 - 10, 1, -40)

    local ScrollingFrame4 = ScrollingFrame

    ScrollingFrame4.CanvasSize = UDim2.new()

    local ScrollingFrame5 = ScrollingFrame

    ScrollingFrame5.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.ScrollBarThickness = 12

    local ScrollingFrame6 = ScrollingFrame

    ScrollingFrame6.ScrollBarImageColor3 = Style.TEAL

    local ScrollingFrame7 = ScrollingFrame

    ScrollingFrame7.ScrollingDirection = Enum.ScrollingDirection.Y
    ScrollingFrame.ClipsDescendants = true
    ScrollingFrame.ZIndex = 2

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.Padding = UDim.new(0, 16)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ScrollingFrame

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingTop = UDim.new(0, 4)
    UIPadding.PaddingBottom = UDim.new(0, 30)
    UIPadding.PaddingLeft = UDim.new(0, 4)
    UIPadding.Parent = ScrollingFrame
    ScrollingFrame.Parent = v3

    local n1 = 1

    for _, v33 in t4 do
        t3[v33.Name] = Style.title(ScrollingFrame, v33.Title, v33.Color:Lerp(Color3.new(1, 1, 1), 0.3), n1)
        n1 = v33.Build(ScrollingFrame, n1 + 1, onRefresh)
    end

    Fx.setPage(ScrollingFrame)
    ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(follow)
end

local function build() -- line: 279
    -- upvalues: Kit (copy), Style (copy), Fx (copy), Gift (copy), Tabs (copy), LocalPlayer (copy), v1 (copy), v2 (copy), ScreenGui (ref), v3 (ref), v4 (ref), v5 (ref), onRefresh (copy), t4 (copy), jump (copy), buildBanner (copy), buildBody (copy)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Shop"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true

    local ScreenGui2 = ScreenGui

    ScreenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 6
    ScreenGui.Enabled = false
    v3 = Kit.frame(ScreenGui, {
        Name = "Panel",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 16),
        Size = UDim2.fromOffset(v2, 860),
        BackgroundColor3 = Color3.new(1, 1, 1)
    })
    Kit.corner(v3, 26)
    Kit.stroke(v3, 6)
    Style.gradient(v3, ColorSequence.new(Style.NAVY, Style.DEEP))
    Kit.studs(v3, 0.85, 44, 26)
    Fx.bubbles(v3, 16)

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "Scale"
    UIScale.Parent = v3

    local v34 = Kit.frame(v3, {
        Name = "Well",
        BackgroundTransparency = 0.6,
        ZIndex = 1,
        BackgroundColor3 = Color3.new(0, 0, 0),
        Position = UDim2.fromOffset(v1 - 12, 12),
        Size = UDim2.new(1, -v1, 1, -24)
    })

    Kit.corner(v34, 20)
    buildBanner()

    local v35, v36 = Tabs.build(v3, 22, 74, t4, onRefresh, jump)

    v4 = v35
    v5 = v36
    buildBody()
    Gift.init(v3)

    local ScreenGui3 = ScreenGui

    ScreenGui3.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local function vipChatTag() -- line: 322
    -- upvalues: Players (copy), TextChatService (copy)
    TextChatService.OnIncomingMessage = function(p9) -- line: 323
        -- upvalues: Players (copy)
        local TextChatMessageProperties = Instance.new("TextChatMessageProperties")
        local TextSource = p9.TextSource
        local v37 = TextSource and Players:GetPlayerByUserId(TextSource.UserId)

        if v37 and v37:GetAttribute("VIP") then
            TextChatMessageProperties.PrefixText = ("<font color=\"#FFD23F\">[VIP]</font> %*"):format(p9.PrefixText)
        end

        return TextChatMessageProperties
    end
end

function t1.init() -- line: 334
    -- upvalues: Players (copy), RunService (copy), TextChatService (copy), Animals (copy), Products (copy), Remotes (copy), RodBuilder (copy), UIUtil (copy), Robux (copy), Fx (copy), Cash (copy), Timers (copy), StarterPack (copy), Gift (copy), LocalPlayer (copy), t1 (copy), v3 (ref), t2 (copy), build (copy)
    local function megaBase() -- line: 336
        -- upvalues: Animals (copy), LocalPlayer (copy)
        Animals.megaBase = LocalPlayer:GetAttribute("MegaBase") or 0
    end

    Animals.megaBase = LocalPlayer:GetAttribute("MegaBase") or 0
    LocalPlayer:GetAttributeChangedSignal("MegaBase"):Connect(megaBase)
    Robux.init()
    Remotes.PromptRobux.OnClientEvent:Connect(function(p10) -- line: 344
        -- upvalues: Products (copy), Robux (copy), StarterPack (copy)
        if type(p10) == "string" and Products.get(p10) and not StarterPack.need() then
            Robux.buy(p10)
        end
    end)

    local n2 = (-1e999)

    Remotes.NeedCash.OnClientEvent:Connect(function(p11, p12) -- line: 351
        -- upvalues: n2 (ref), Cash (copy), t1 (copy), t2 (copy)
        if type(p11) ~= "number" or type(p12) ~= "string" or os.clock() - n2 < 20 then
            return
        end

        n2 = os.clock()
        Cash.setNeed(p11, p12)
        t1.open("Cash")

        for _, v38 in t2 do
            task.spawn(v38)
        end
    end)
    build()
    Timers.init()

    TextChatService.OnIncomingMessage = function(p13) -- line: 323
        -- upvalues: Players (copy)
        local TextChatMessageProperties = Instance.new("TextChatMessageProperties")
        local TextSource = p13.TextSource
        local v39 = TextSource and Players:GetPlayerByUserId(TextSource.UserId)

        if v39 and v39:GetAttribute("VIP") then
            TextChatMessageProperties.PrefixText = ("<font color=\"#FFD23F\">[VIP]</font> %*"):format(p13.PrefixText)
        end

        return TextChatMessageProperties
    end

    RodBuilder.animateRgb()
    Robux.onGranted(function(p14) -- line: 364
        -- upvalues: Products (copy), UIUtil (copy), Fx (copy), t1 (copy), v3 (ref), t2 (copy)
        for _, v40 in t2 do
            task.spawn(v40)
        end

        if Products.isPass(p14) then
            UIUtil.sound("Reveal", 0.5)
        end

        if t1.isOpen() then
            Fx.celebrate(v3)
        end
    end)

    for _, v41 in { "Income", "StrengthRate", "RodsOwned", "BarbellTier", "PenLevel", "PacksBought" } do
        LocalPlayer:GetAttributeChangedSignal(v41):Connect(function() -- line: 374
            -- upvalues: t1 (copy), t2 (copy)
            if not t1.isOpen() then
                return
            end

            for _, v42 in t2 do
                task.spawn(v42)
            end
        end)
    end

    for _, v43 in t2 do
        task.spawn(v43)
    end

    if RunService:IsStudio() then
        LocalPlayer:GetAttributeChangedSignal("ShopTab"):Connect(function() -- line: 384
            -- upvalues: Gift (copy), LocalPlayer (copy), t1 (copy)
            local ShopTab = LocalPlayer:GetAttribute("ShopTab")

            if ShopTab == "" then
                t1.close()
            elseif type(ShopTab) ~= "string" or ShopTab:sub(1, 5) ~= "Gift:" then
                if ShopTab then
                    t1.open(ShopTab)
                end
            else
                t1.open("Passes")
                Gift.open(ShopTab:sub(6))
            end
        end)
    end
end

return t1
