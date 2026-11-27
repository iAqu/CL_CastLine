-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Rods = require(Shared.Data.Rods)
local Zones = require(Shared.Data.Zones)
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

local function call(p1, ...) -- line: 27
    -- upvalues: Remotes (copy)
    local v1 = table.pack(...)

    task.spawn(function() -- line: 29
        -- upvalues: p1 (copy), v1 (copy), Remotes (copy)
        local function v2() -- line: 30
            -- upvalues: p1 (copy), v1 (copy), Remotes (copy)
            return Remotes[p1]:InvokeServer(table.unpack(v1, 1, v1.n))
        end

        pcall(v2)
    end)
end

local function speedText(p2) -- line: 36
    local v4 = string.format("%.2f", p2)
    local v5 = string.gsub(v4, "0+$", "")

    return "x" .. string.gsub(v5, "%.$", "") .. " Speed"
end

local function buildCard(p3) -- line: 43
    -- upvalues: ReplicatedStorage (copy), Zones (copy), Rarities (copy), UIKit (copy), DataClient (copy), ModelView (copy), Colors (copy), t2 (copy), ScrollingFrame (ref), call (copy)
    local v6 = Rarities.ById[p3.rarity] or Rarities.ById.Common
    local v7 = Zones.ById[p3.zone]
    local v8 = UIKit.frame(ScrollingFrame, {
        Corner = 14,
        ZIndex = 12,
        Name = p3.id,
        Size = UDim2.fromOffset(238, 352),
        Color = v6.Color,
        Color2 = v6.Color2
    })

    v8.LayoutOrder = p3.order
    v8.ClipsDescendants = true

    local v9 = UIKit.stroke(v8, 4)

    for i = 0, 5 do
        UIKit.frame(v8, {
            Name = "Stripe",
            Transparency = 0.9,
            ZIndex = 12,
            Size = UDim2.new(0, 20, 1, 0),
            Position = UDim2.fromOffset(i * 40 + 8, 0),
            Color = Colors.White
        })
    end

    local v10 = UIKit.text(v8, {
        Name = "RodName",
        Stroke = 4,
        ZIndex = 14,
        Text = p3.name,
        Size = UDim2.new(1, -16, 0, 40),
        Position = UDim2.fromOffset(8, 8)
    })
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = 34
    UITextSizeConstraint.Parent = v10
    UIKit.text(v8, {
        Name = "Zone",
        TextSize = 20,
        Stroke = 3,
        ZIndex = 14,
        Text = if v7 then v7.icon .. " " .. v7.name elseif p3.source then p3.source else v6.name or p3.rarity,
        Size = UDim2.new(1, -16, 0, 22),
        Position = UDim2.fromOffset(8, 46)
    })

    local v11 = UIKit.frame(v8, {
        Name = "Picture",
        Transparency = 1,
        ZIndex = 13,
        Size = UDim2.fromOffset(200, 150),
        Position = UDim2.new(0.5, 0, 0, 70),
        AnchorPoint = Vector2.new(0.5, 0)
    })
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local Rods = Assets and Assets:FindFirstChild("Rods")
    local v12 = Rods and Rods:FindFirstChild(p3.id)

    if v12 then
        ModelView.Queue("RodShop", p3.order, v11, v12, Vector3.new(0.15, 0.1, -1), 0.62)
    end

    local v14 = math.floor(((p3.strength or 1) - 1) * 100 + 0.5)

    UIKit.text(v8, {
        Name = "Speed",
        TextSize = 22,
        Stroke = 3,
        ZIndex = 14,
        Text = p3.Glow and "Glowing tip" or "Classic finish",
        Size = UDim2.new(1, -16, 0, 24),
        Position = UDim2.fromOffset(8, 220)
    })

    local v15 = UIKit.frame(v8, {
        Name = "Time",
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
        TextSize = 24,
        Stroke = 3,
        ZIndex = 14,
        Text = if v14 > 0 then ("+%d%% Strength"):format(v14) else "No bonus",
        Color = if v14 > 0 then Colors.Power else Colors.Grey,
        StrokeColor = if v14 > 0 then Colors.PowerStroke else nil
    })

    local v17, v18 = UIKit.button(v8, {
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
        OnClick = function() -- OnClick | line: 73
            -- upvalues: p3 (copy), DataClient (copy), call (copy)
            local v16 = DataClient.Get("RodsOwned") or {}

            if DataClient.Get("EquippedRod") ~= p3.id then
                if v16[p3.id] then
                    call("EquipRod", p3.id)
                else
                    call("BuyRod", p3.id)
                end
            end
        end
    })

    t2[p3.id] = {
        frame = v8,
        stroke = v9,
        button = v17,
        label = v18,
        def = p3
    }
end

local function canvasWidth() -- line: 86
    -- upvalues: Rods (copy), n1 (ref), n2 (ref)
    return ((#Rods.List + n2) * 250 + 8) * n1
end

local function refresh() -- line: 90
    -- upvalues: Rods (copy), NumberFormat (copy), UIKit (copy), DataClient (copy), Colors (copy), n1 (ref), t2 (copy), ScrollingFrame (ref), n2 (ref)
    local v19 = DataClient.Get("RodsOwned") or {}
    local v20 = DataClient.Get("EquippedRod") or Rods.List[1].id
    local v21 = DataClient.Get("Cash") or 0
    local n3 = 0

    for _, v22 in ipairs(Rods.Exclusive) do
        local v23 = t2[v22.id]

        if v23 then
            v23.frame.Visible = v19[v22.id] == true

            if v23.frame.Visible then
                n3 += 1
            end
        end
    end

    if n3 ~= n2 and ScrollingFrame then
        n2 = n3

        local ScrollingFrame2 = ScrollingFrame

        ScrollingFrame2.CanvasSize = UDim2.fromOffset(((#Rods.List + n2) * 250 + 8) * n1, 0)
    end

    for v24, v25 in pairs(t2) do
        local def = v25.def
        local v26 = "locked"

        if def.exclusive then
            if v19[v24] then
                if v20 == v24 then
                    v25.label.Text = "EQUIPPED"
                    v26 = "equipped"
                    UIKit.setButtonColor(v25.button, Colors.GreyDark, Color3.fromRGB(64, 66, 80))
                elseif v19[v24] or def.price <= 0 then
                    v25.label.Text = "EQUIP"
                    v26 = "owned"
                    UIKit.setButtonColor(v25.button, Colors.Green, Colors.GreenDark)
                elseif def.price <= v21 then
                    v25.label.Text = NumberFormat.money(def.price)
                    v26 = "afford"
                    UIKit.setButtonColor(v25.button, Colors.Orange, Colors.OrangeDark)
                else
                    v25.label.Text = NumberFormat.money(def.price)
                    v26 = "locked"
                    UIKit.setButtonColor(v25.button, Colors.Red, Colors.RedDark)
                end
            else
                v26 = "hidden"
            end
        elseif v20 == v24 then
            v25.label.Text = "EQUIPPED"
            v26 = "equipped"
            UIKit.setButtonColor(v25.button, Colors.GreyDark, Color3.fromRGB(64, 66, 80))
        elseif v19[v24] or def.price <= 0 then
            v25.label.Text = "EQUIP"
            v26 = "owned"
            UIKit.setButtonColor(v25.button, Colors.Green, Colors.GreenDark)
        elseif def.price <= v21 then
            v25.label.Text = NumberFormat.money(def.price)
            v26 = "afford"
            UIKit.setButtonColor(v25.button, Colors.Orange, Colors.OrangeDark)
        else
            v25.label.Text = NumberFormat.money(def.price)
            UIKit.setButtonColor(v25.button, Colors.Red, Colors.RedDark)
        end

        if v25.state ~= v26 then
            if v25.state ~= nil and (v26 == "equipped" or v25.state ~= "afford" and v25.state ~= "locked") then
                UIKit.pop(v25.frame, 1.06)
            end

            v25.state = v26
        end

        local stroke = v25.stroke

        if v26 == "equipped" then
            stroke.Color = Color3.fromRGB(150, 255, 110)
        else
            stroke.Color = Colors.Outline
        end

        v25.stroke.Thickness = v26 == "equipped" and 6 or 4
    end
end

function t1.ScrollTo(p4) -- line: 141
    -- upvalues: n1 (ref), t2 (copy), ScrollingFrame (ref), n2 (ref)
    local v27 = p4 and t2[p4]

    if v27 and ScrollingFrame then
        local v29 = math.max(0, (math.max(v27.def.order, 1) - 1 + (if v27.def.exclusive then 0 else n2)) * 250 * n1 - (992 - n1 * 238) / 2)

        ScrollingFrame.CanvasPosition = Vector2.new(v29 * (ScrollingFrame.AbsoluteSize.X / 992), 0)
    end
end

local v30

function t1.Open(p5) -- line: 153
    -- upvalues: RunService (copy), UIKit (copy), DataClient (copy), t1 (copy), v30 (ref)
    local RodShop = UIKit.Windows.RodShop

    v30 = p5
    RodShop.Open()

    local v31 = p5 or DataClient.Get("EquippedRod")

    task.spawn(function() -- line: 158
        -- upvalues: RodShop (copy), v31 (copy), RunService (copy), t1 (copy)
        local elapsed = os.clock()

        while RodShop.IsOpen and os.clock() - elapsed < 0.5 do
            t1.ScrollTo(v31)
            RunService.Heartbeat:Wait()
        end
    end)
end

function t1.Init() -- line: 167
    -- upvalues: Players (copy), RunService (copy), Rods (copy), UIKit (copy), DataClient (copy), ModelView (copy), t1 (copy), Colors (copy), n1 (ref), t2 (copy), ScrollingFrame (ref), n2 (ref), buildCard (copy), refresh (copy), v30 (ref)
    local RodShop = UIKit.Windows.RodShop
    local Content = RodShop.Content

    ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "Cards"
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Size = UDim2.fromScale(1, 1)
    ScrollingFrame.ScrollBarThickness = 8
    ScrollingFrame.ScrollBarImageColor3 = Colors.Grey
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
    ScrollingFrame.CanvasSize = UDim2.fromOffset(((#Rods.List + n2) * 250 + 8) * n1, 0)
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

    RodShop.FitHeight = function(p6) -- line: 190
        -- upvalues: RodShop (copy), UIListLayout (copy), Rods (copy), n1 (ref), ScrollingFrame (ref), n2 (ref)
        local v32 = if require(script.Parent.HUD).IsTouch() then math.clamp(p6, 470, 660) else 470

        RodShop.Frame.Size = UDim2.fromOffset(RodShop.Frame.Size.X.Offset, v32)
        n1 = (v32 - 110) / 360

        for _, child in ScrollingFrame:GetChildren() do
            if child:IsA("GuiObject") then
                local v33 = child:FindFirstChild("PhoneScale") or Instance.new("UIScale")

                v33.Name = "PhoneScale"
                v33.Scale = n1
                v33.Parent = child
            end
        end

        UIListLayout.Padding = UDim.new(0, n1 * 12)
        ScrollingFrame.CanvasSize = UDim2.fromOffset(((#Rods.List + n2) * 250 + 8) * n1, 0)
    end

    for _, v34 in ipairs(Rods.List) do
        buildCard(v34)
    end

    for _, v35 in ipairs(Rods.Exclusive) do
        buildCard(v35)
    end

    refresh()
    DataClient.Observe("RodsOwned", refresh)
    DataClient.Observe("EquippedRod", refresh)
    DataClient.Observe("Cash", function() -- line: 215
        -- upvalues: RodShop (copy), refresh (copy)
        if RodShop.IsOpen then
            refresh()
        end
    end)

    RodShop.OnOpen = function() -- line: 220
        -- upvalues: DataClient (copy), ModelView (copy), t2 (copy), refresh (copy), v30 (ref)
        refresh()

        local v37 = t2[v30 or DataClient.Get("EquippedRod") or ""]

        v30 = nil
        ModelView.Flush("RodShop", if v37 then v37.def.order else 1)
    end

    local v38 = false
    local n4 = 0

    RunService.Heartbeat:Connect(function(p7) -- line: 231
        -- upvalues: RodShop (copy), v38 (ref), n4 (ref), Players (copy), t1 (copy)
        n4 += p7

        if n4 < 0.15 then
            return
        end

        n4 = 0

        local Character = Players.LocalPlayer.Character
        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
        local World = workspace:FindFirstChild("World")

        World = World and World:FindFirstChild("Stalls") and World.Stalls:FindFirstChild("RodShop")

        local ShopPad = World and World:FindFirstChild("ShopPad")
        local v39 = false

        if HumanoidRootPart and ShopPad then
            local v40 = ShopPad.CFrame:PointToObjectSpace(HumanoidRootPart.Position)

            if math.abs(v40.X) < ShopPad.Size.X / 2 and math.abs(v40.Z) < ShopPad.Size.Z / 2 and v40.Y > -2 then
                v39 = v40.Y < 9
            end
        end

        if not v39 or v38 then
            if not v39 and v38 then
                v38 = false
                RodShop.Close()
            end
        else
            v38 = true
            t1.Open()
        end
    end)
end

return t1
