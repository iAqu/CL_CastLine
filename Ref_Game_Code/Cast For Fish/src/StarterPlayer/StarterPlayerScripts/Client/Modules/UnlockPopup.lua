-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Baits = require(Shared.Data.Baits)
local Dumbbells = require(Shared.Data.Dumbbells)
local NumberFormat = require(Shared.NumberFormat)
local UIKit = require(script.Parent.UIKit)
local DataClient = require(script.Parent.DataClient)
local HUD = require(script.Parent.HUD)
local Toasts = require(script.Parent.Toasts)
local ModelView = require(script.Parent.ModelView)
local Notifications = require(script.Parent.Notifications)
local t1 = {
    Showing = nil,
    OnShop = nil,
    Suppressed = nil
}
local Colors = UIKit.Colors
local Left = Enum.TextXAlignment.Left
local v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11
local t2 = {}
local n1 = 0
local n2 = 0
local v12
local n3 = 0
local v13

local function build() -- line: 35
    -- upvalues: Remotes (copy), UIKit (copy), t1 (copy), Colors (copy), Left (copy), v1 (ref), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), v7 (ref), v8 (ref), v9 (ref), v10 (ref), v11 (ref), v12 (ref)
    v1 = UIKit.screenGui("Popups", 15)
    v2 = UIKit.frame(v1, {
        Name = "Unlock",
        Corner = 18,
        Stroke = 6,
        Size = UDim2.fromOffset(620, 196),
        Position = UDim2.new(0.5, 0, 0, 14),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = Colors.Dark
    })
    v2.Visible = false
    v3 = UIKit.frame(v2, {
        Name = "Header",
        Corner = 16,
        Size = UDim2.new(1, 0, 0, 56),
        Color = Colors.Magenta,
        Color2 = Colors.MagentaDark
    })
    UIKit.stroke(v3, 5)
    v4 = UIKit.text(v2, {
        Name = "Title",
        Text = "",
        TextSize = 34,
        Stroke = 4,
        ZIndex = 3,
        Size = UDim2.new(1, -90, 0, 56),
        Position = UDim2.fromOffset(20, 0),
        XAlign = Left
    })
    UIKit.button(v2, {
        Name = "Close",
        Text = "X",
        Corner = 10,
        Stroke = 4,
        ZIndex = 3,
        Size = UDim2.fromOffset(42, 42),
        Position = UDim2.new(1, -10, 0, 7),
        AnchorPoint = Vector2.new(1, 0),
        Color = Colors.Red,
        Color2 = Colors.RedDark,
        OnClick = function() -- OnClick | line: 42
            -- upvalues: t1 (copy)
            t1.Hide()
        end
    })

    local v14 = UIKit.frame(v2, {
        Name = "Tile",
        Corner = 12,
        Stroke = 4,
        ZIndex = 2,
        Size = UDim2.fromOffset(116, 116),
        Position = UDim2.fromOffset(16, 68),
        Color = Color3.fromRGB(235, 235, 245),
        Color2 = Color3.fromRGB(170, 175, 195)
    })

    v5 = UIKit.frame(v14, {
        Name = "Picture",
        Transparency = 1,
        ZIndex = 2,
        Size = UDim2.new(1, -8, 1, -8),
        Position = UDim2.fromOffset(4, 4)
    })
    UIKit.text(v2, {
        Name = "Hint",
        Text = "YOU CAN NOW BUY",
        TextSize = 22,
        Stroke = 3,
        ZIndex = 2,
        Size = UDim2.fromOffset(300, 24),
        Position = UDim2.fromOffset(148, 68),
        XAlign = Left,
        Color = Color3.fromRGB(215, 218, 230)
    })
    v6 = UIKit.text(v2, {
        Name = "ItemName",
        Text = "",
        TextSize = 40,
        Stroke = 4,
        ZIndex = 2,
        Size = UDim2.fromOffset(456, 32),
        Position = UDim2.fromOffset(148, 92),
        XAlign = Left
    })
    v6.TextScaled = true

    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = 40
    UITextSizeConstraint.MinTextSize = 14
    UITextSizeConstraint.Parent = v6
    v6.TextWrapped = false
    v7 = UIKit.text(v2, {
        Name = "Price",
        Text = "",
        TextSize = 30,
        Stroke = 4,
        ZIndex = 2,
        Size = UDim2.fromOffset(140, 34),
        Position = UDim2.fromOffset(148, 144),
        XAlign = Left,
        Color = Colors.Cash,
        StrokeColor = Colors.CashStroke
    })
    v8 = UIKit.text(v2, {
        Name = "Extra",
        Text = "",
        TextSize = 26,
        Stroke = 4,
        ZIndex = 2,
        Size = UDim2.fromOffset(180, 34),
        Position = UDim2.fromOffset(250, 144),
        XAlign = Left,
        Color = Colors.Power,
        StrokeColor = Colors.PowerStroke
    })
    v9, v10 = UIKit.button(v2, {
        Name = "Action",
        Text = "SHOP",
        Corner = 10,
        Stroke = 4,
        ZIndex = 3,
        Size = UDim2.fromOffset(170, 52),
        Position = UDim2.new(1, -16, 1, -18),
        AnchorPoint = Vector2.new(1, 1),
        Color = Colors.Green,
        Color2 = Colors.GreenDark,
        OnClick = function() -- OnClick | line: 59
            -- upvalues: Remotes (copy), t1 (copy), v12 (ref)
            local v15 = v12

            t1.Hide()

            if not v15 then
                return
            end

            local v16 = v15.kind == "bait"
            local OnShop

            if v16 then
                OnShop = t1.OnShop
            else
                task.spawn(function() -- line: 70
                    -- upvalues: Remotes (copy)
                    local function v17() -- line: 71
                        -- upvalues: Remotes (copy)
                        Remotes.BuyDumbbell:InvokeServer()
                    end

                    pcall(v17)
                end)
            end

            if (not v16 or OnShop) and v16 then
                t1.OnShop(v15.def.id)
            end
        end
    })
    v11 = UIKit.frame(v2, {
        Name = "Timer",
        Corner = 3,
        ZIndex = 2,
        Size = UDim2.new(1, -40, 0, 5),
        Position = UDim2.new(0, 20, 1, -8),
        Color = Colors.Gold
    })
end

function t1.Hide() -- line: 81
    -- upvalues: UIKit (copy), Toasts (copy), t1 (copy), v2 (ref), n2 (ref), v12 (ref), n3 (ref), v13 (ref)
    if v13 then
        local v18 = v13

        v13 = nil
        v18:Done()
    end

    if t1.Showing then
        t1.Showing = nil
        v12 = nil
        n2 = os.clock()
        n3 += 1

        local v19 = n3

        Toasts.SetTop(nil)
        UIKit.tween(v2, 0.18, {
            Position = UDim2.new(0.5, 0, 0, -230)
        }, Enum.EasingStyle.Quad, Enum.EasingDirection.In).Completed:Once(function() -- line: 97
            -- upvalues: v19 (copy), v2 (ref), n3 (ref)
            if n3 == v19 then
                v2.Visible = false
            end
        end)
    end
end

local function show(p1) -- line: 104
    -- upvalues: ReplicatedStorage (copy), Remotes (copy), NumberFormat (copy), UIKit (copy), Toasts (copy), ModelView (copy), t1 (copy), Colors (copy), v1 (ref), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), v7 (ref), v8 (ref), v10 (ref), v11 (ref), t2 (copy), n1 (ref), v12 (ref), n3 (ref)
    n3 += 1
    v12 = p1
    t1.Showing = p1.key
    n1 = os.clock()
    t2[p1.key] = true
    Remotes.PopupSeen:FireServer(p1.key)
    v5:ClearAllChildren()

    local Assets = ReplicatedStorage:FindFirstChild("Assets")

    if p1.kind == "bait" then
        v3:FindFirstChildOfClass("UIGradient").Color = ColorSequence.new(Colors.Magenta, Colors.MagentaDark)
        v4.Text = "NEW BAIT UNLOCKED!"
        v8.Text = ""
        v10.Text = "SHOP"

        local Baits = Assets and Assets:FindFirstChild("Baits")
        local v20 = Baits and Baits:FindFirstChild(p1.def.id)

        if v20 then
            ModelView.Show(v5, v20, nil, 0.74)
        end
    else
        v3:FindFirstChildOfClass("UIGradient").Color = ColorSequence.new(Colors.Blue, Colors.BlueDark)
        v4.Text = "NEW EQUIPMENT!"

        local v21 = v8

        v21.Text = "+" .. p1.def.xp .. " XP / rep"

        local v22 = v10

        v22.Text = p1.def.tier == 1 and "BUY" or "UPGRADE"

        local Dumbbells = Assets and Assets:FindFirstChild("Dumbbells")
        local v23 = Dumbbells and Dumbbells:FindFirstChild(p1.def.id)
        local Held = v23 and v23:FindFirstChild("Held")

        if Held then
            ModelView.Show(v5, Held, Vector3.new(0.5, 0.35, -1), 0.74)
        end
    end

    local v24 = v6

    v24.Text = string.upper(p1.def.name)

    local v25 = v7

    v25.Text = NumberFormat.money(p1.def.price)

    local v26 = v8

    v26.Position = UDim2.fromOffset(148 + v7.TextBounds.X / math.max(v1.FitScale.Scale, 0.01) + 16, 144)

    local v27 = v2

    v27.Position = UDim2.new(0.5, 0, 0, -230)
    v2.Visible = true
    UIKit.tween(v2, 0.35, {
        Position = UDim2.new(0.5, 0, 0, 14)
    }, Enum.EasingStyle.Back)

    local v28 = v11

    v28.Size = UDim2.new(1, -40, 0, 5)
    UIKit.tween(v11, 10, {
        Size = UDim2.new(0, 0, 0, 5)
    }, Enum.EasingStyle.Linear)
    Toasts.SetTop(226)
    UIKit.sound("Unlock")
end

local function nextItem() -- line: 150
    -- upvalues: Baits (copy), Dumbbells (copy), DataClient (copy), t2 (copy)
    local v29 = DataClient.Get("Cash") or 0
    local v30 = DataClient.Get("PopupsSeen") or {}
    local v31 = DataClient.Get("DumbbellTier") or 0
    local v32 = Dumbbells.List[v31 + 1]

    if v32 and v32.price <= v29 then
        local v33 = "dumbbell:" .. v32.id

        if not v30[v33] and not t2[v33] then
            return {
                kind = "dumbbell",
                def = v32,
                key = v33
            }
        end
    end

    local v34 = DataClient.Get("BaitsOwned") or {}

    for _, v35 in ipairs(Baits.List) do
        if not v34[v35.id] then
            break
        end
    end

    return nil
end

function t1.Init() -- line: 176
    -- upvalues: RunService (copy), UIKit (copy), DataClient (copy), HUD (copy), Notifications (copy), t1 (copy), n1 (ref), n2 (ref), v12 (ref), v13 (ref), build (copy), show (copy), nextItem (copy)
    build()

    local n4 = 0

    RunService.Heartbeat:Connect(function(p2) -- line: 179
        -- upvalues: n4 (ref), UIKit (copy), DataClient (copy), HUD (copy), Notifications (copy), t1 (copy), n1 (ref), n2 (ref), v12 (ref), v13 (ref), show (copy), nextItem (copy)
        n4 += p2

        if not (n4 < 0.5) then
            n4 = 0

            if DataClient.IsReady() then
                if t1.Showing then
                    local v36 = v12

                    if not not ((if v36 and v36.kind == "bait" then (DataClient.Get("BaitsOwned") or {})[v36.def.id] == true else v36 and (DataClient.Get("DumbbellTier") or 0) >= v36.def.tier) or os.clock() - n1 > 10 or HUD.GetMode() == "cutscene") or UIKit.anyWindowOpen() then
                        t1.Hide()
                    end
                elseif not (t1.Suppressed and t1.Suppressed()) and HUD.GetMode() == "normal" and not (UIKit.anyWindowOpen() or os.clock() - n2 < 1.5) then
                    local v37 = nextItem()

                    if v37 and not v13 then
                        v13 = Notifications.Shared:Push({
                            priority = Notifications.EQUIPMENT,
                            key = "unlock:" .. v37.key,
                            show = function(p3) -- show | line: 214
                                -- upvalues: UIKit (copy), HUD (copy), v13 (ref), show (copy), nextItem (copy)
                                if v13 == p3 then
                                    local v38 = nextItem()

                                    if v38 and HUD.GetMode() == "normal" and not UIKit.anyWindowOpen() then
                                        show(v38)

                                        return
                                    end

                                    v13 = nil
                                end

                                p3:Done()
                            end
                        })
                    end
                end
            end
        end
    end)
end

return t1
