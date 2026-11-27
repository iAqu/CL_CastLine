-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Baits = require(Shared.Data.Baits)
local Rarities = require(Shared.Data.Rarities)
local NumberFormat = require(Shared.NumberFormat)
local UIKit = require(script.Parent.UIKit)
local DataClient = require(script.Parent.DataClient)
local ModelView = require(script.Parent.ModelView)
local t1 = {}
local Colors = UIKit.Colors
local n1 = 1
local t2 = {}
local ScrollingFrame
local n2 = 0
local t3 = {
    worm = Vector3.new(0.2, 0.3, -1),
    squid_strip = Vector3.new(0.3, 0.1, -1),
    golden_lure = Vector3.new(0.35, 0.1, -1),
    star_bait = Vector3.new(0.3, 0.15, -1),
    minnow_bait = Vector3.new(1, 0.25, -0.5),
    shrimp = Vector3.new(1, 0.25, -0.35),
    cricket = Vector3.new(1, 0.35, -0.6),
    crab_meat = Vector3.new(1, 0.4, -0.5),
    glow_grub = Vector3.new(0.3, 0.35, -1),
    void_leech = Vector3.new(0.2, 0.3, -1)
}

local function call(p1, ...) -- line: 31
    -- upvalues: Remotes (copy)
    local v1 = table.pack(...)

    task.spawn(function() -- line: 33
        -- upvalues: p1 (copy), v1 (copy), Remotes (copy)
        local function v2() -- line: 34
            -- upvalues: p1 (copy), v1 (copy), Remotes (copy)
            return Remotes[p1]:InvokeServer(table.unpack(v1, 1, v1.n))
        end

        pcall(v2)
    end)
end

local function luckText(p2) -- line: 40
    local v4 = string.format("%.2f", p2)
    local v5 = string.gsub(v4, "0+$", "")

    return "x" .. string.gsub(v5, "%.$", "") .. " Luck"
end

local function buildCard(p3) -- line: 47
    -- upvalues: ReplicatedStorage (copy), Rarities (copy), UIKit (copy), DataClient (copy), ModelView (copy), Colors (copy), t2 (copy), ScrollingFrame (ref), t3 (copy), call (copy)
    local v6 = Rarities.ById[p3.rarity] or Rarities.ById.Common
    local v7 = UIKit.frame(ScrollingFrame, {
        Corner = 14,
        ZIndex = 12,
        Name = p3.id,
        Size = UDim2.fromOffset(238, 352),
        Color = v6.Color,
        Color2 = v6.Color2
    })

    v7.LayoutOrder = p3.order
    v7.ClipsDescendants = true

    local v8 = UIKit.stroke(v7, 4)

    for i = 0, 5 do
        UIKit.frame(v7, {
            Name = "Stripe",
            Transparency = 0.9,
            ZIndex = 12,
            Size = UDim2.new(0, 20, 1, 0),
            Position = UDim2.fromOffset(i * 40 + 8, 0),
            Color = Colors.White
        })
    end

    local v9 = UIKit.text(v7, {
        Name = "BaitName",
        Stroke = 4,
        ZIndex = 14,
        Text = p3.name,
        Size = UDim2.new(1, -16, 0, 40),
        Position = UDim2.fromOffset(8, 8)
    })
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = 34
    UITextSizeConstraint.Parent = v9
    UIKit.text(v7, {
        Name = "Rarity",
        TextSize = 20,
        Stroke = 3,
        ZIndex = 14,
        Text = v6.name or p3.rarity,
        Size = UDim2.new(1, -16, 0, 22),
        Position = UDim2.fromOffset(8, 46)
    })

    local v10 = UIKit.frame(v7, {
        Name = "Picture",
        Transparency = 1,
        ZIndex = 13,
        Size = UDim2.fromOffset(190, 150),
        Position = UDim2.new(0.5, 0, 0, 70),
        AnchorPoint = Vector2.new(0.5, 0)
    })
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local Baits = Assets and Assets:FindFirstChild("Baits")
    local v11 = Baits and Baits:FindFirstChild(p3.id)

    if v11 then
        ModelView.Queue("BaitShop", p3.order, v10, v11, t3[p3.id], 0.72)
    end

    local text2 = UIKit.text
    local t5 = {
        Name = "Luck",
        TextSize = 22,
        Stroke = 3,
        ZIndex = 14
    }
    local luck = p3.luck
    local v12 = string.format("%.2f", luck)
    local v13 = string.gsub(v12, "0+$", "")

    t5.Text = "x" .. string.gsub(v13, "%.$", "") .. " Luck"
    t5.Size = UDim2.new(1, -16, 0, 24)
    t5.Position = UDim2.fromOffset(8, 220)

    local v14 = text2(v7, t5)
    local v15 = UIKit.frame(v7, {
        Name = "Tier",
        Transparency = 0.25,
        Corner = 8,
        Stroke = 3,
        ZIndex = 13,
        Size = UDim2.new(1, -28, 0, 40),
        Position = UDim2.new(0.5, 0, 0, 248),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = Color3.fromRGB(40, 40, 52)
    })

    UIKit.text(v15, {
        Name = "Label",
        Stroke = 3,
        ZIndex = 14,
        Text = if p3.exclusive then "+" .. math.floor((p3.boost - 1) * 100 + 0.5) .. "% best bait" else "Tier " .. p3.tier,
        TextSize = p3.exclusive and 24 or 28,
        Color = Colors.Gold
    })

    local v18, v19 = UIKit.button(v7, {
        Name = "Action",
        Text = "",
        Corner = 8,
        Stroke = 4,
        ZIndex = 13,
        Size = UDim2.new(1, -28, 0, 48),
        Position = UDim2.new(0.5, 0, 1, -10),
        AnchorPoint = Vector2.new(0.5, 1),
        Color = Colors.Red,
        Color2 = Colors.RedDark,
        OnClick = function() -- OnClick | line: 77
            -- upvalues: p3 (copy), DataClient (copy), call (copy)
            local v17 = DataClient.Get("BaitsOwned") or {}

            if DataClient.Get("EquippedBait") ~= p3.id then
                if v17[p3.id] then
                    call("EquipBait", p3.id)
                else
                    call("BuyBait", p3.id)
                end
            end
        end
    })

    t2[p3.id] = {
        frame = v7,
        stroke = v8,
        button = v18,
        label = v19,
        def = p3,
        luck = v14
    }
end

local function canvasWidth() -- line: 90
    -- upvalues: Baits (copy), n1 (ref), n2 (ref)
    return ((#Baits.List + n2) * 250 + 8) * n1
end

local function refresh() -- line: 94
    -- upvalues: Baits (copy), NumberFormat (copy), UIKit (copy), DataClient (copy), Colors (copy), n1 (ref), t2 (copy), ScrollingFrame (ref), n2 (ref)
    local v20 = DataClient.Get("BaitsOwned") or {}
    local EquippedBait = DataClient.Get("EquippedBait")
    local v21 = DataClient.Get("Cash") or 0
    local n3 = 0

    for _, v22 in ipairs(Baits.Exclusive) do
        local v23 = t2[v22.id]

        if v23 then
            v23.frame.Visible = v20[v22.id] == true

            local luck = v23.luck
            local v24 = Baits.LuckOf(v22.id, v20)
            local v25 = string.format("%.2f", v24)
            local v26 = string.gsub(v25, "0+$", "")

            luck.Text = "x" .. string.gsub(v26, "%.$", "") .. " Luck"

            if v23.frame.Visible then
                n3 += 1
            end
        end
    end

    if n3 ~= n2 and ScrollingFrame then
        n2 = n3

        local ScrollingFrame2 = ScrollingFrame

        ScrollingFrame2.CanvasSize = UDim2.fromOffset(((#Baits.List + n2) * 250 + 8) * n1, 0)
    end

    for v27, v28 in pairs(t2) do
        local def = v28.def
        local v29 = "locked"

        if def.exclusive then
            if v20[v27] then
                if EquippedBait == v27 then
                    v28.label.Text = "EQUIPPED"
                    v29 = "equipped"
                    UIKit.setButtonColor(v28.button, Colors.GreyDark, Color3.fromRGB(64, 66, 80))
                elseif v20[v27] then
                    v28.label.Text = "EQUIP"
                    v29 = "owned"
                    UIKit.setButtonColor(v28.button, Colors.Green, Colors.GreenDark)
                elseif def.price <= v21 then
                    v28.label.Text = NumberFormat.money(def.price)
                    v29 = "afford"
                    UIKit.setButtonColor(v28.button, Colors.Orange, Colors.OrangeDark)
                else
                    v28.label.Text = NumberFormat.money(def.price)
                    v29 = "locked"
                    UIKit.setButtonColor(v28.button, Colors.Red, Colors.RedDark)
                end
            else
                v29 = "hidden"
            end
        elseif EquippedBait == v27 then
            v28.label.Text = "EQUIPPED"
            v29 = "equipped"
            UIKit.setButtonColor(v28.button, Colors.GreyDark, Color3.fromRGB(64, 66, 80))
        elseif v20[v27] then
            v28.label.Text = "EQUIP"
            v29 = "owned"
            UIKit.setButtonColor(v28.button, Colors.Green, Colors.GreenDark)
        elseif def.price <= v21 then
            v28.label.Text = NumberFormat.money(def.price)
            v29 = "afford"
            UIKit.setButtonColor(v28.button, Colors.Orange, Colors.OrangeDark)
        else
            v28.label.Text = NumberFormat.money(def.price)
            UIKit.setButtonColor(v28.button, Colors.Red, Colors.RedDark)
        end

        if v28.state ~= v29 then
            if v28.state ~= nil and (v29 == "equipped" or v28.state ~= "afford" and v28.state ~= "locked") then
                UIKit.pop(v28.frame, 1.06)
            end

            v28.state = v29
        end

        local stroke = v28.stroke

        if v29 == "equipped" then
            stroke.Color = Color3.fromRGB(150, 255, 110)
        else
            stroke.Color = Colors.Outline
        end

        v28.stroke.Thickness = v29 == "equipped" and 6 or 4
    end
end

function t1.ScrollTo(p4) -- line: 147
    -- upvalues: n1 (ref), t2 (copy), ScrollingFrame (ref), n2 (ref)
    local v30 = p4 and t2[p4]

    if v30 and ScrollingFrame then
        local v32 = math.max(0, (math.max(v30.def.order, 1) - 1 + (if v30.def.exclusive then 0 else n2)) * 250 * n1 - (992 - n1 * 238) / 2)

        ScrollingFrame.CanvasPosition = Vector2.new(v32 * (ScrollingFrame.AbsoluteSize.X / 992), 0)
    end
end

local v33

function t1.Open(p5) -- line: 160
    -- upvalues: RunService (copy), UIKit (copy), DataClient (copy), t1 (copy), v33 (ref)
    local BaitShop = UIKit.Windows.BaitShop

    v33 = p5
    BaitShop.Open()

    local v34 = p5 or DataClient.Get("EquippedBait")

    task.spawn(function() -- line: 165
        -- upvalues: BaitShop (copy), v34 (copy), RunService (copy), t1 (copy)
        local elapsed = os.clock()

        while BaitShop.IsOpen and os.clock() - elapsed < 0.5 do
            t1.ScrollTo(v34)
            RunService.Heartbeat:Wait()
        end
    end)
end

function t1.Init() -- line: 174
    -- upvalues: Players (copy), RunService (copy), Baits (copy), UIKit (copy), DataClient (copy), ModelView (copy), t1 (copy), Colors (copy), n1 (ref), t2 (copy), ScrollingFrame (ref), n2 (ref), buildCard (copy), refresh (copy), v33 (ref)
    local BaitShop = UIKit.Windows.BaitShop
    local Content = BaitShop.Content

    ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "Cards"
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Size = UDim2.fromScale(1, 1)
    ScrollingFrame.ScrollBarThickness = 8
    ScrollingFrame.ScrollBarImageColor3 = Colors.Grey
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
    ScrollingFrame.CanvasSize = UDim2.fromOffset(((#Baits.List + n2) * 250 + 8) * n1, 0)
    ScrollingFrame.ZIndex = 11
    ScrollingFrame.Parent = Content

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 12)
    UIListLayout.Parent = ScrollingFrame

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingLeft = UDim.new(0, 4)
    UIPadding.PaddingTop = UDim.new(0, 4)
    UIPadding.Parent = ScrollingFrame

    BaitShop.FitHeight = function(p6) -- line: 197
        -- upvalues: BaitShop (copy), UIListLayout (copy), Baits (copy), n1 (ref), ScrollingFrame (ref), n2 (ref)
        local v35 = if require(script.Parent.HUD).IsTouch() then math.clamp(p6, 470, 660) else 470

        BaitShop.Frame.Size = UDim2.fromOffset(BaitShop.Frame.Size.X.Offset, v35)
        n1 = (v35 - 110) / 360

        for _, child in ScrollingFrame:GetChildren() do
            if child:IsA("GuiObject") then
                local v36 = child:FindFirstChild("PhoneScale") or Instance.new("UIScale")

                v36.Name = "PhoneScale"
                v36.Scale = n1
                v36.Parent = child
            end
        end

        UIListLayout.Padding = UDim.new(0, n1 * 12)
        ScrollingFrame.CanvasSize = UDim2.fromOffset(((#Baits.List + n2) * 250 + 8) * n1, 0)
    end

    for _, v37 in ipairs(Baits.List) do
        buildCard(v37)
    end

    for _, v38 in ipairs(Baits.Exclusive) do
        buildCard(v38)
    end

    refresh()
    DataClient.Observe("BaitsOwned", refresh)
    DataClient.Observe("EquippedBait", refresh)
    DataClient.Observe("Cash", function() -- line: 222
        -- upvalues: BaitShop (copy), refresh (copy)
        if BaitShop.IsOpen then
            refresh()
        end
    end)

    BaitShop.OnOpen = function() -- line: 227
        -- upvalues: DataClient (copy), ModelView (copy), t2 (copy), refresh (copy), v33 (ref)
        refresh()

        local v40 = t2[v33 or DataClient.Get("EquippedBait") or ""]

        v33 = nil
        ModelView.Flush("BaitShop", if v40 then v40.def.order else 1)
    end

    local v41 = false
    local n4 = 0

    RunService.Heartbeat:Connect(function(p7) -- line: 238
        -- upvalues: BaitShop (copy), v41 (ref), n4 (ref), Players (copy), t1 (copy)
        n4 += p7

        if n4 < 0.15 then
            return
        end

        n4 = 0

        local Character = Players.LocalPlayer.Character
        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
        local World = workspace:FindFirstChild("World")

        World = World and World:FindFirstChild("Stalls") and World.Stalls:FindFirstChild("BaitShop")

        local ShopPad = World and World:FindFirstChild("ShopPad")
        local v42 = false

        if HumanoidRootPart and ShopPad then
            local v43 = ShopPad.CFrame:PointToObjectSpace(HumanoidRootPart.Position)

            if math.abs(v43.X) < ShopPad.Size.X / 2 and math.abs(v43.Z) < ShopPad.Size.Z / 2 and v43.Y > -2 then
                v42 = v43.Y < 9
            end
        end

        if not v42 or v41 then
            if not v42 and v41 then
                v41 = false
                BaitShop.Close()
            end
        else
            v41 = true
            t1.Open()
        end
    end)
end

return t1
