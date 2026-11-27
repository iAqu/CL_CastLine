-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local NumberFormat = require(Shared.NumberFormat)
local Roll = require(Shared.Roll)
local UIKit = require(script.Parent.UIKit)
local FishIcons = require(script.Parent.FishIcons)
local FishTooltip = require(script.Parent.FishTooltip)
local DataClient = require(script.Parent.DataClient)
local Pad = require(script.Parent.Pad)
local Notifications = require(script.Parent.Notifications)
local BoostBar = require(script.Parent.BoostBar)
local t1 = {
    BUTTON_SCALE = 0.9,
    BUTTON_GAP = 166,
    TOUCH_STAT_SCALE = 0.62,
    TOUCH_BOOST_SCALE = 0.86,
    TOUCH_LEFT_SCALE = 0.62
}

function t1.ScaleGroup(p1, p2) -- line: 28
    -- upvalues: t1 (copy)
    local v1 = p1:FindFirstChild("HudScale") or Instance.new("UIScale")

    v1.Name = "HudScale"
    v1.Scale = p2 or t1.BUTTON_SCALE
    v1.Parent = p1

    return v1
end

local UserInputService = game:GetService("UserInputService")

t1.ForceTouch = nil
t1.LeftTopExtra = nil
t1.LEFT_TOP_RESERVE = 184

function t1.IsTouch() -- line: 42
    -- upvalues: t1 (copy), UserInputService (copy)
    if t1.ForceTouch ~= nil then
        return t1.ForceTouch
    end

    if not UserInputService.TouchEnabled then
        return false
    end

    if UserInputService.KeyboardEnabled then
        return UserInputService:GetLastInputType() == Enum.UserInputType.Touch
    end

    return true
end

local BindableEvent = Instance.new("BindableEvent")

t1.TouchChanged = BindableEvent.Event

local v2
local t2 = {}
local v3, v4, v5
local v6 = false
local v7 = "normal"
local t3 = {
    normal = {
        Left = true,
        Right = true,
        Power = true,
        Cash = true,
        Hotbar = true,
        Lucky = true,
        Boosts = true,
        Goal = true,
        LuckBar = true
    },
    cast = {
        Power = true,
        Boosts = true,
        LuckBar = true
    },
    cutscene = {},
    training = {
        Left = true,
        Right = true,
        Power = true,
        Cash = true,
        Lucky = true,
        Boosts = true,
        Goal = true,
        LuckBar = true
    }
}

t1.TutorialHides = nil
t1.TUTORIAL_KEEPS = {
    Power = true,
    Cash = true
}

local function shows(p3, p4) -- line: 76
    -- upvalues: t1 (copy)
    if p4[p3] then
        return not (t1.TutorialHides and t1.TutorialHides() and not t1.TUTORIAL_KEEPS[p3])
    end

    return false
end

local function addGroup(p5, p6, p7) -- line: 86
    -- upvalues: t2 (copy)
    local Position = p6.Position

    t2[p5] = {
        frame = p6,
        shown = Position,
        hidden = Position + UDim2.fromOffset(p7.X, p7.Y)
    }
end

local function setPlace(p8, p9, p10) -- line: 92
    -- upvalues: t1 (copy), t2 (copy), v7 (ref), t3 (copy)
    local v8 = t2[p8]

    if not v8 or v8.shown == p9 and (p10 == nil or v8.frame.AnchorPoint == p10) then
        return
    end

    local v9 = p9 + (v8.hidden - v8.shown)

    v8.shown = p9
    v8.hidden = v9

    if p10 then
        v8.frame.AnchorPoint = p10
    end

    local v10 = t3[v7] or t3.normal
    local frame = v8.frame

    if v10[p8] and not not not (t1.TutorialHides and t1.TutorialHides() and not t1.TUTORIAL_KEEPS[p8]) then
        frame.Position = v8.shown
    else
        frame.Position = v8.hidden
    end
end

local t4 = {}

t4.__index = t4
t4.GROUPS = {
    Goal = true,
    LuckBar = true
}
t4.COVERS = {
    { "Popups", "Unlock" },
    { "BaitOffer", "Bar" }
}

function t4.new() -- line: 114
    -- upvalues: t4 (copy)
    return (setmetatable({
        Covered = false
    }, t4))
end

local function rectsOverlap(p11, p12) -- line: 118
    local AbsolutePosition, AbsoluteSize = p11.AbsolutePosition, p11.AbsoluteSize
    local AbsolutePosition2, AbsoluteSize2 = p12.AbsolutePosition, p12.AbsoluteSize

    if AbsolutePosition.X < AbsolutePosition2.X + AbsoluteSize2.X and AbsolutePosition2.X < AbsolutePosition.X + AbsoluteSize.X and AbsolutePosition.Y < AbsolutePosition2.Y + AbsoluteSize2.Y then
        return AbsolutePosition2.Y < AbsolutePosition.Y + AbsoluteSize.Y
    end

    return false
end

function t4.Check(_) -- line: 123
    -- upvalues: UIKit (copy), t2 (copy), t4 (copy)
    if UIKit.anyWindowOpen() then
        return true
    end

    local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui

    for _, v11 in ipairs(t4.COVERS) do
        local v12 = PlayerGui:FindFirstChild(v11[1])

        v12 = v12 and v12.Enabled and v12:FindFirstChild(v11[2])

        if v12 and v12.Visible then
            for v13 in pairs(t4.GROUPS) do
                local v14 = t2[v13]

                if v14 then
                    local frame = v14.frame
                    local AbsolutePosition, AbsoluteSize = v12.AbsolutePosition, v12.AbsoluteSize
                    local AbsolutePosition2, AbsoluteSize2 = frame.AbsolutePosition, frame.AbsoluteSize

                    if AbsolutePosition.X < AbsolutePosition2.X + AbsoluteSize2.X and AbsolutePosition2.X < AbsolutePosition.X + AbsoluteSize.X and AbsolutePosition.Y < AbsolutePosition2.Y + AbsoluteSize2.Y and AbsolutePosition2.Y < AbsolutePosition.Y + AbsoluteSize.Y then
                        return true
                    end
                end
            end
        end
    end

    return false
end

function t4.Hides(p14, p15) -- line: 143
    -- upvalues: t4 (copy)
    return p14.Covered and t4.GROUPS[p15] == true
end

local v15 = t4.new()

function t1.AddGroup(p16, p17, p18) -- line: 149
    -- upvalues: t1 (copy), t2 (copy), v7 (ref), t3 (copy), v15 (copy)
    local Position = p17.Position

    t2[p16] = {
        frame = p17,
        shown = Position,
        hidden = Position + UDim2.fromOffset(p18.X, p18.Y)
    }

    local v16 = t3[v7] or t3.normal
    local v17 = t2[p16]

    if not not not (v16[p16] and (not t1.TutorialHides or not t1.TutorialHides() or t1.TUTORIAL_KEEPS[p16])) or v15:Hides(p16) then
        p17.Position = v17.hidden
    else
        p17.Position = v17.shown
    end
end

function t1.SetMode(p19) -- line: 156
    -- upvalues: TweenService (copy), t1 (copy), t2 (copy), v7 (ref), t3 (copy), v15 (copy)
    v7 = p19

    local v18 = t3[p19] or t3.normal

    for v19, v20 in pairs(t2) do
        local hidden = if not v18[v19] or t1.TutorialHides and t1.TutorialHides() and not t1.TUTORIAL_KEEPS[v19] then v20.hidden elseif v15:Hides(v19) then v20.hidden else v20.shown

        TweenService:Create(v20.frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = hidden
        }):Play()
    end
end

function t1.GetMode() -- line: 165
    -- upvalues: v7 (ref)
    return v7
end

function t1.RefreshPrompts() -- line: 173
    -- upvalues: t1 (copy)
    local v21 = not not (t1.HeldFishUid and t1.HeldFishUid() ~= nil) or t1.HeldEggKey and t1.HeldEggKey() ~= nil

    game:GetService("ProximityPromptService").Enabled = not v21
end

local function showBubble(p20) -- line: 179
    -- upvalues: UIKit (copy), v3 (ref), v4 (ref), v6 (ref)
    v6 = p20

    if not v4 then
        return
    end

    local Visible = v4.Visible
    local v22 = v4

    if p20 then
        if v3.Text == "" then
            v22.Visible = false
        else
            v22.Visible = not UIKit.anyWindowOpen()
        end
    else
        v22.Visible = p20
    end

    if v4.Visible and not Visible then
        UIKit.pop(v4, 1.2)
    end
end

function t1.SetInstruction(p21) -- line: 190
    -- upvalues: UIKit (copy), Notifications (copy), v3 (ref), v4 (ref), v5 (ref), v6 (ref)
    if not v3 then
        return
    end

    if not p21 or p21 == "" then
        v3.Text = ""
        v6 = false

        if v4 then
            local Visible = v4.Visible

            v4.Visible = false

            if v4.Visible and not Visible then
                UIKit.pop(v4, 1.2)
            end
        end

        if v5 then
            local v26 = v5

            v5 = nil
            v26:Done()
        end
    else
        local v23 = v3.Text ~= p21

        v3.Text = p21

        if v5 then
            if v23 and v6 then
                UIKit.pop(v4, 1.2)
            end
        else
            v5 = Notifications.Shared:Push({
                key = "tip",
                sticky = true,
                priority = Notifications.TIP,
                show = function() -- show | line: 202
                    -- upvalues: UIKit (copy), v3 (ref), v4 (ref), v6 (ref)
                    v6 = true

                    if not v4 then
                        return
                    end

                    local Visible = v4.Visible
                    local v25 = v4

                    if v3.Text == "" then
                        v25.Visible = false
                    else
                        v25.Visible = not UIKit.anyWindowOpen()
                    end

                    if v4.Visible and not Visible then
                        UIKit.pop(v4, 1.2)
                    end
                end,
                hide = function() -- hide | line: 205
                    -- upvalues: UIKit (copy), v4 (ref), v6 (ref)
                    v6 = false

                    if not v4 then
                        return
                    end

                    local Visible = v4.Visible

                    v4.Visible = false

                    if v4.Visible and not Visible then
                        UIKit.pop(v4, 1.2)
                    end
                end
            })
        end
    end
end

function t1.InstructionVisible() -- line: 223
    -- upvalues: v4 (ref)
    return v4 ~= nil and v4.Visible
end

local function counter(p22, p23) -- line: 228
    -- upvalues: TweenService (copy), UIKit (copy)
    local NumberValue = Instance.new("NumberValue")
    local v27, v28

    NumberValue.Changed:Connect(function(p24) -- line: 232
        -- upvalues: p22 (copy), p23 (copy)
        p22.Text = p23(p24)
    end)

    return function(p25) -- line: 235
        -- upvalues: p22 (copy), p23 (copy), NumberValue (copy), v27 (ref), v28 (ref), TweenService (copy), UIKit (copy)
        if v27 ~= nil then
            if p25 ~= v27 then
                if v28 then
                    v28:Cancel()
                end

                v28 = TweenService:Create(NumberValue, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Value = p25
                })
                v28:Play()

                local v29 = p25 < v27 or math.abs(p25 - v27) > math.max(1, (math.abs(v27))) * 0.04

                UIKit.pop(p22, v29 and 1.22 or 1.07)
            end
        else
            NumberValue.Value = p25
            p22.Text = p23(p25)
        end

        v27 = p25
    end
end

local function statRow(p26, p27, p28, p29, p30, p31) -- line: 252
    -- upvalues: UIKit (copy)
    local v34 = UIKit.frame(p26, {
        Transparency = 1,
        Name = p27,
        Size = UDim2.fromOffset(560, 100),
        Position = UDim2.new(0, 26, 1, p29),
        AnchorPoint = Vector2.new(0, 1)
    })

    UIKit.icon(v34, p28, {
        Size = UDim2.fromOffset(100, 100)
    })

    return v34, (UIKit.text(v34, {
        Name = "Value",
        Text = "0",
        TextSize = 76,
        Stroke = 7,
        Size = UDim2.new(1, -124, 1, 0),
        Position = UDim2.fromOffset(124, 0),
        XAlign = Enum.TextXAlignment.Left,
        Color = p30,
        StrokeColor = p31
    }))
end

function t1.Init() -- line: 259
    -- upvalues: GuiService (copy), ReplicatedStorage (copy), NumberFormat (copy), Roll (copy), UIKit (copy), FishIcons (copy), FishTooltip (copy), DataClient (copy), Pad (copy), BoostBar (copy), t1 (copy), UserInputService (copy), BindableEvent (copy), v2 (ref), t2 (copy), v3 (ref), v4 (ref), v6 (ref), v7 (ref), t3 (copy), setPlace (copy), v15 (copy), counter (copy), statRow (copy)
    v2 = UIKit.screenGui("HUD", 5)

    local Position = t1.BUTTON_GAP
    local v35 = UIKit.frame(v2, {
        Name = "Left",
        Transparency = 1,
        Size = UDim2.fromOffset(150, Position * 2 + 150),
        Position = UDim2.new(0, 18, 0.5, -10),
        AnchorPoint = Vector2.new(0, 0.5)
    })
    local v36 = UIKit.hudButton(v35, "Index", "Index", nil, function() -- line: 265
        -- upvalues: UIKit (copy)
        local Index = UIKit.Windows.Index

        if Index then
            Index.Toggle()
        end
    end)
    local v37 = UIKit.hudButton(v35, "Shop", "Shop", nil, function() -- line: 271
        -- upvalues: UIKit (copy)
        local Shop = UIKit.Windows.Shop

        if Shop then
            Shop.Toggle()
        end
    end)

    v37.Position = UDim2.fromOffset(0, Position)
    Position = v37:FindFirstChild("Body") and v37.Body:FindFirstChild("Inner")

    if Position then
        UIKit.gleam(Position, {
            Corner = 19,
            Period = 4,
            Sweep = 0.8,
            Strength = 0.6,
            Width = 0.11,
            ZIndex = Position.ZIndex
        })
    end

    t1.ScaleGroup(v35)
    t1.Left = v35

    local v38 = Vector2.new(-420, 0)

    Position = v35.Position
    t2.Left = {
        frame = v35,
        shown = Position,
        hidden = Position + UDim2.fromOffset(v38.X, v38.Y)
    }
    v38 = UIKit.frame(v2, {
        Name = "Right",
        Transparency = 1,
        Size = UDim2.fromOffset(150, 150),
        Position = UDim2.new(1, -18, 0.5, 6),
        AnchorPoint = Vector2.new(1, 0.5)
    })
    UIKit.hudButton(v38, "Fish", "Fish", UIKit.Colors.Orange, function() -- line: 289
        -- upvalues: UIKit (copy)
        local MyFish = UIKit.Windows.MyFish

        if MyFish then
            MyFish.Toggle()
        end
    end)
    t1.ScaleGroup(v38)
    t1.Right = v38

    local v39 = Vector2.new(300, 0)
    local Position2 = v38.Position

    t2.Right = {
        frame = v38,
        shown = Position2,
        hidden = Position2 + UDim2.fromOffset(v39.X, v39.Y)
    }
    v38 = BoostBar.HEIGHT + 14

    local v40

    v39, v40 = statRow(v2, "Power", "Power", -136 - v38, UIKit.Colors.Power, UIKit.Colors.PowerStroke)

    local v41, v42 = statRow(v2, "Cash", "Cash", -24 - v38, UIKit.Colors.Cash, UIKit.Colors.CashStroke)
    local v43 = BoostBar.new(v2, UDim2.new(0, 26, 1, -16))

    t1.Boosts = v43

    local t6 = {}
    local v44

    for _, v45 in ipairs({ v39, v41 }) do
        v44 = Instance.new("UIScale")
        v44.Name = "TouchScale"
        v44.Scale = 1
        v44.Parent = v45
        table.insert(t6, v44)
    end

    local v46 = Vector2.new(-1400, 0)
    local Position3 = v39.Position

    t2.Power = {
        frame = v39,
        shown = Position3,
        hidden = Position3 + UDim2.fromOffset(v46.X, v46.Y)
    }
    t1.PowerRow = v39
    t1.PowerLabel = v40
    v46 = Vector2.new(-1400, 0)
    Position3 = v41.Position
    t2.Cash = {
        frame = v41,
        shown = Position3,
        hidden = Position3 + UDim2.fromOffset(v46.X, v46.Y)
    }
    DataClient.Observe("CastPower", (counter(v40, function(p32) -- line: 317
        -- upvalues: NumberFormat (copy)
        return NumberFormat.abbr((math.floor(p32 + 0.5)))
    end)))
    DataClient.Observe("Cash", (counter(v42, function(p33) -- line: 320
        -- upvalues: NumberFormat (copy)
        return NumberFormat.money(p33)
    end)))

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "Lucky"
    TextButton.Text = ""
    TextButton.BackgroundTransparency = 1
    TextButton.Size = UDim2.fromOffset(330, 62)
    TextButton.AnchorPoint = Vector2.new(0, 1)
    TextButton.Position = UDim2.new(0, 26, 1, -250 - v38)
    TextButton.Parent = v2

    local v48 = UIKit.frame(TextButton, {
        Name = "Body",
        Corner = 31,
        Stroke = 5,
        Color = Color3.fromRGB(70, 200, 90),
        Color2 = Color3.fromRGB(30, 130, 60)
    })
    local v49 = UIKit.text(v48, {
        Name = "Label",
        Text = "",
        TextSize = 34,
        Stroke = 4,
        ZIndex = 2,
        Size = UDim2.new(1, -78, 1, 0),
        Position = UDim2.fromOffset(66, 0),
        XAlign = Enum.TextXAlignment.Left
    })

    UIKit.clover(v48, 48, {
        ZIndex = 2,
        Position = UDim2.new(0, 10, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5)
    })

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "TouchScale"
    UIScale.Scale = 1
    UIScale.Parent = TextButton
    table.insert(t6, UIScale)
    UIKit.bindPress(TextButton, function() -- line: 343
        -- upvalues: UIKit (copy)
        local Shop = UIKit.Windows.Shop

        if Shop then
            Shop.Open()
        end
    end)
    UIScale = Vector2.new(-1400, 0)

    local Row = TextButton.Position

    t2.Lucky = {
        frame = TextButton,
        shown = Row,
        hidden = Row + UDim2.fromOffset(UIScale.X, UIScale.Y)
    }
    UIScale = Instance.new("UIScale")
    UIScale.Name = "TouchScale"
    UIScale.Scale = 1
    UIScale.Parent = v43.Row
    UIScale:SetAttribute("TouchSize", t1.TOUCH_BOOST_SCALE)
    table.insert(t6, UIScale)
    Row = v43.Row
    v44 = Vector2.new(-1400, 0)
    UIScale = Row.Position
    t2.Boosts = {
        frame = Row,
        shown = UIScale,
        hidden = UIScale + UDim2.fromOffset(v44.X, v44.Y)
    }

    local TOUCH_STAT_SCALE = t1.TOUCH_STAT_SCALE

    v44 = -14 - math.floor(v38 * t1.TOUCH_BOOST_SCALE)

    local v52 = v44 - math.floor(100 * TOUCH_STAT_SCALE) - 4
    local v50 = v52 - math.floor(100 * TOUCH_STAT_SCALE) - 6
    local v54 = UDim2.new(0, 26, 1, -136 - v38)
    local t7 = {
        Power = {
            v39,
            v54,
            UDim2.new(0, 22, 1, v52)
        },
        Cash = {
            v41,
            UDim2.new(0, 26, 1, -24 - v38),
            UDim2.new(0, 22, 1, v44)
        },
        Lucky = {
            TextButton,
            UDim2.new(0, 26, 1, -250 - v38),
            UDim2.new(0, 22, 1, v50)
        },
        Boosts = {
            v43.Row,
            UDim2.new(0, 26, 1, -16),
            UDim2.new(0, 22, 1, -10)
        }
    }
    local v55
    local n1 = 0

    local function placeStack() -- line: 372
        -- upvalues: t7 (copy), v55 (ref), n1 (ref), t1 (copy), t2 (copy), v7 (ref), t3 (copy)
        local v56 = t3[v7] or t3.normal

        for v57, v58 in pairs(t7) do
            local v59 = t2[v57]
            local v60 = v59.hidden - v59.shown

            if v55 then
                v59.shown = v58[3] + UDim2.fromOffset(0, -n1)
            else
                v59.shown = v58[2]
            end

            v59.hidden = v59.shown + v60

            local v61 = v58[1]

            if v56[v57] and (not t1.TutorialHides or not t1.TutorialHides() or t1.TUTORIAL_KEEPS[v57]) then
                v61.Position = v59.shown
            else
                v61.Position = v59.hidden
            end
        end
    end

    local function liftForThumbstick() -- line: 382
        -- upvalues: t7 (copy), v55 (ref), n1 (ref), placeStack (copy), UIKit (copy), v2 (ref)
        if not v55 then
            return
        end

        local FitScale = v2:FindFirstChild("FitScale")
        local v62 = if not (FitScale and FitScale.Scale > 0) then 1 else FitScale.Scale
        local v63 = v2.AbsoluteSize.Y / v62
        local v64 = UIKit.topInset() / v62
        local n2 = 0

        for _, v65 in pairs(t7) do
            local v66 = v65[1]

            if v66.Visible then
                local TouchScale = v66:FindFirstChild("TouchScale")

                n2 = math.max(n2, -v65[3].Y.Offset + v66.Size.Y.Offset * (if TouchScale then TouchScale.Scale else 1))
            end
        end

        local v70 = math.max(0, (math.floor(v63 - (v64 + 10) - n2)))

        if v70 ~= n1 then
            n1 = v70
            placeStack()
        end
    end

    t1.LiftForThumbstick = liftForThumbstick

    local function applyTouch() -- line: 405
        -- upvalues: t6 (copy), TOUCH_STAT_SCALE (copy), v55 (ref), placeStack (copy), t1 (copy), BindableEvent (copy)
        local v71 = t1.IsTouch()

        if v71 == v55 then
            return
        end

        v55 = v71
        placeStack()

        for _, v72 in ipairs(t6) do
            if v71 then
                v72.Scale = v72:GetAttribute("TouchSize") or TOUCH_STAT_SCALE
            else
                v72.Scale = 1
            end
        end

        BindableEvent:Fire(v71)
    end

    applyTouch()
    UserInputService.LastInputTypeChanged:Connect(applyTouch)
    UserInputService:GetPropertyChangedSignal("KeyboardEnabled"):Connect(applyTouch)
    UserInputService:GetPropertyChangedSignal("TouchEnabled"):Connect(applyTouch)
    TextButton.Visible = false

    local v73

    DataClient.Observe("LuckyCasts", function(p34) -- line: 423
        -- upvalues: TextButton (copy), v48 (copy), v49 (copy), v73 (ref), UIKit (copy)
        p34 = p34 or 0
        TextButton.Visible = false
        v49.Text = "Lucky Casts x" .. p34

        if v73 and p34 ~= v73 and p34 > 0 then
            UIKit.pop(v48, 1.25)
        end

        v73 = p34
    end)

    local UserInputService2 = game:GetService("UserInputService")
    local v75 = UIKit.frame(v2, {
        Name = "Hotbar",
        Transparency = 1,
        Size = UDim2.fromOffset(1050, 96),
        Position = UDim2.new(0.5, 0, 1, -22),
        AnchorPoint = Vector2.new(0.5, 1)
    })
    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.Parent = v75

    local UIScale2 = Instance.new("UIScale")

    UIScale2.Name = "RoomScale"
    UIScale2.Parent = v75

    local v76 = UDim2.new(0.5, 0, 1, -22)
    local v77

    local function findJump() -- line: 459
        -- upvalues: v77 (ref)
        if not (v77 and v77.Parent) then
            local TouchGui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("TouchGui")

            v77 = TouchGui and TouchGui:FindFirstChild("JumpButton", true)
        end

        return v77
    end

    local function moveHotbar(p35, p36) -- line: 468
        -- upvalues: v75 (copy), UIScale2 (copy), t2 (copy), setPlace (copy)
        UIScale2.Scale = p36

        if t2.Hotbar then
            setPlace("Hotbar", p35, Vector2.new(0.5, 1))
        else
            v75.AnchorPoint = Vector2.new(0.5, 1)
            v75.Position = p35
        end
    end

    local function placeHotbar() -- line: 477
        -- upvalues: v40 (ref), v42 (copy), v75 (copy), UIScale2 (copy), v76 (copy), v77 (ref), t1 (copy), v2 (ref), t2 (copy), setPlace (copy)
        local FitScale = v2:FindFirstChild("FitScale")
        local v78 = if not (FitScale and FitScale.Scale > 0) then 1 else FitScale.Scale
        local X = v2.AbsolutePosition.X
        local v79 = v2.AbsoluteSize.X / v78
        local v80 = t1.IsTouch()

        if v80 then
            if not (v77 and v77.Parent) then
                local TouchGui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("TouchGui")

                v77 = TouchGui and TouchGui:FindFirstChild("JumpButton", true)
            end

            v80 = v77
        end

        local v81 = v80

        if v80 and (not v80.Visible or v80.AbsoluteSize.X < 1) then
            v81 = nil
        end

        local v83 = if v81 then (v81.AbsolutePosition.X - X) / v78 - 14 else v79 - 26
        local n3 = 0

        for _, v84 in ipairs({ v40, v42 }) do
            n3 = math.max(n3, (v84.AbsolutePosition.X + v84.TextBounds.X - X) / v78 + 16)
        end

        local Offset = v75.Size.X.Offset
        local v87 = math.clamp((v83 - n3) / Offset, 0.62, 1)
        local v88 = Offset * v87
        local v93 = math.min(math.max(if v81 then (n3 + v83) / 2 else v79 / 2, n3 + v88 / 2), v83 - v88 / 2)

        if not v81 and v87 == 1 and math.abs(v93 - v79 / 2) < 1 then
            UIScale2.Scale = 1

            if t2.Hotbar then
                setPlace("Hotbar", v76, Vector2.new(0.5, 1))
            else
                v75.AnchorPoint = Vector2.new(0.5, 1)
                v75.Position = v76
            end

            return
        end

        local v96 = UDim2.new(0, math.floor(v93 / 4 + 0.5) * 4, 1, -22)

        UIScale2.Scale = math.floor(v87 * 50 + 0.5) / 50

        if t2.Hotbar then
            setPlace("Hotbar", v96, Vector2.new(0.5, 1))
        else
            v75.AnchorPoint = Vector2.new(0.5, 1)
            v75.Position = v96
        end
    end

    local function placeLeft() -- line: 507
        -- upvalues: v35 (copy), t7 (copy), v55 (ref), n1 (ref), UIKit (copy), t1 (copy), v2 (ref), t2 (copy), setPlace (copy)
        local HudScale = v35:FindFirstChild("HudScale")

        if v55 and HudScale and HudScale.Scale ~= t1.TOUCH_LEFT_SCALE then
            HudScale.Scale = t1.TOUCH_LEFT_SCALE
        end

        local FitScale = v2:FindFirstChild("FitScale")
        local v99 = if not (FitScale and FitScale.Scale > 0) then 1 else FitScale.Scale
        local v100 = v2.AbsoluteSize.Y / v99

        if v55 then
            local v101 = v100 - 10 - n1
            local v102 = (t1.BUTTON_GAP * 2 + 150) * t1.TOUCH_LEFT_SCALE / 2

            setPlace("Left", UDim2.new(0, 18, 0.5, (math.floor(v101 + 14 + v102 - v100 / 2))))
        else
            local v104 = v100

            for v105, v106 in pairs(t7) do
                local v107 = v106[1]

                if v107.Visible then
                    local v108 = if t2[v105] then t2[v105].shown else v107.Position
                    local TouchScale = v107:FindFirstChild("TouchScale")
                    local v109 = v107.Size.Y.Offset * (if TouchScale then TouchScale.Scale else 1)

                    v104 = math.min(v104, v108.Y.Scale * v100 + v108.Y.Offset - v109)
                end
            end

            local v111 = UIKit.topInset() / v99
            local v112 = if t1.LeftTopExtra then t1.LeftTopExtra() elseif game:GetService("Players").LocalPlayer:GetAttribute("CratesAllowed") == false then 0 else t1.LEFT_TOP_RESERVE
            local v113 = t1.BUTTON_GAP * 2 + 150 + v112
            local v115 = math.clamp((v104 - 16 - (v111 + 8)) / v113, 0.5, t1.BUTTON_SCALE)

            if HudScale and math.abs(HudScale.Scale - v115) > 0.005 then
                HudScale.Scale = v115
            end

            local v117 = v113 * v115 / 2
            local v121 = math.max(math.min(-10, v104 - 16 - v117 - v100 / 2), v111 + 8 + v117 - v100 / 2) + v112 * v115 / 2

            setPlace("Left", UDim2.new(0, 18, 0.5, math.floor(v121 / 4 + 0.5) * 4))
        end
    end

    local function placeCorner() -- line: 545
        -- upvalues: v55 (ref), t1 (copy), v2 (ref), setPlace (copy)
        local FitScale = v2:FindFirstChild("FitScale")
        local v123 = if not (FitScale and FitScale.Scale > 0) then 1 else FitScale.Scale
        local v124 = v2:FindFirstChild("Goal", true)
        local v125 = v2:FindFirstChild("LuckBar", true)
        local v126, v127

        if v55 then
            local TopBar = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("TopBar")
            local Row = TopBar and TopBar:FindFirstChild("Row")
            local v128, v129

            if Row and Row:IsA("GuiObject") and Row.AbsoluteSize.Y > 0 then
                v128 = math.floor((Row.AbsolutePosition.Y - v2.AbsolutePosition.Y) / v123 + 0.5)
                v127 = v128

                if v124 and v124:IsA("GuiObject") and v124.AbsoluteSize.X > 0 then
                    local HudScale = v124:FindFirstChild("HudScale")

                    v129 = if HudScale and HudScale.Scale > 0 then HudScale.Scale else 1

                    local v131 = v124.AbsoluteSize.X / v129
                    local v132 = v2.AbsolutePosition.X + v2.AbsoluteSize.X - 18 * v123 - (Row.AbsolutePosition.X + Row.AbsoluteSize.X + 8)

                    if v132 < v131 then
                        if v131 * 0.6 <= v132 then
                            v126 = v132 / v131
                        else
                            v127 = math.floor((Row.AbsolutePosition.Y + Row.AbsoluteSize.Y - v2.AbsolutePosition.Y) / v123 + 10.5)
                            v126 = 1
                        end
                    else
                        v126 = 1
                    end
                else
                    v126 = 1
                end
            else
                v127 = 70
                v126 = 1
            end
        else
            v127 = 70
            v126 = 1
        end

        if v124 and v124:IsA("GuiObject") then
            t1.ScaleGroup(v124, v126)
        end

        if v125 and v125:IsA("GuiObject") then
            t1.ScaleGroup(v125, v126)
        end

        setPlace("Goal", UDim2.new(1, -18, 0, v127))
        setPlace("LuckBar", UDim2.new(1, -18, 0, v127 + math.floor(v126 * 110 + 0.5)))
    end

    t1.PlaceCorner = placeCorner
    t1.PlaceHotbar = placeHotbar
    task.spawn(function() -- line: 583
        -- upvalues: liftForThumbstick (copy), applyTouch (copy), placeHotbar (copy), placeLeft (copy), placeCorner (copy), UIKit (copy), t1 (copy), v2 (ref), v3 (ref), v4 (ref), v6 (ref), v7 (ref), v15 (copy)
        while v2.Parent do
            applyTouch()
            liftForThumbstick()

            local v135 = v15:Check()
            local Visible, v136, v137

            if v135 ~= v15.Covered then
                v15.Covered = v135
                t1.SetMode(v7)

                if v4 then
                    local v138 = v6

                    v6 = v138

                    if v4 then
                        Visible = v4.Visible
                        v136 = v4
                        v137 = v138 and v3.Text ~= "" and not UIKit.anyWindowOpen()
                        v136.Visible = v137

                        if v4.Visible and not Visible then
                            UIKit.pop(v4, 1.2)
                        end
                    end
                end
            end

            placeHotbar()
            placeLeft()
            placeCorner()
            task.wait(0.5)
        end
    end)
    t1.TouchChanged:Connect(placeHotbar)
    t1.TouchChanged:Connect(placeLeft)
    t1.TouchChanged:Connect(placeCorner)

    local t8 = {}
    local uid
    local v139 = false

    local function refreshGlow() -- line: 606
        -- upvalues: t8 (copy), uid (ref), v139 (ref)
        for _, v140 in ipairs(t8) do
            v140.stroke.Transparency = v139 and v140.rec and v140.rec.uid == uid and 0 or 1
        end
    end

    function t1.HotbarGlow(p37) -- line: 613
        -- upvalues: v139 (ref), refreshGlow (copy)
        v139 = p37
        refreshGlow()
    end

    local function useSlot(p38) -- line: 617
        -- upvalues: t8 (copy), uid (ref), refreshGlow (copy), ReplicatedStorage (copy), UIKit (copy), t1 (copy)
        local v141 = t8[p38]

        if not (v141 and v141.egg) then
            local v142 = v141 and v141.rec

            if v142 then
                UIKit.sound("Click")
                UIKit.pop(v141.frame, 0.85)
                uid = v142.uid

                if t1.OnHotbar then
                    t1.OnHotbar(v142)
                    refreshGlow()
                else
                    local uid = v142.uid

                    task.spawn(function() -- line: 647
                        -- upvalues: uid (copy), ReplicatedStorage (copy)
                        local function v143() -- line: 648
                            -- upvalues: uid (copy), ReplicatedStorage (copy)
                            ReplicatedStorage:WaitForChild("Remotes").PlaceFish:InvokeServer(uid)
                        end

                        pcall(v143)
                    end)
                end
            end
        else
            UIKit.sound("Click")
            UIKit.pop(v141.frame, 0.85)

            local egg = v141.egg

            if t1.OnHotbarEgg then
                t1.OnHotbarEgg(egg)
            else
                task.spawn(function() -- line: 627
                    -- upvalues: egg (copy), ReplicatedStorage (copy)
                    local function v144() -- line: 628
                        -- upvalues: egg (copy), ReplicatedStorage (copy)
                        ReplicatedStorage:WaitForChild("Remotes").PlaceEgg:InvokeServer(egg)
                    end

                    pcall(v144)
                end)
            end
        end
    end

    local UIStroke, v145, TextButton2, v146

    for i = 1, 10 do
        local v147 = UIKit.frame(v75, {
            Transparency = 0.42,
            Corner = 12,
            Name = "Slot" .. i,
            Size = UDim2.fromOffset(96, 96),
            Color = Color3.fromRGB(26, 26, 32)
        })

        v147.LayoutOrder = i
        v147.Visible = false
        UIStroke = Instance.new("UIStroke")
        UIStroke.Name = "Selected"
        UIStroke.Thickness = 4
        UIStroke.Color = UIKit.Colors.White
        UIStroke.Transparency = 1
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        UIStroke.Parent = v147
        v145 = UIKit.frame(v147, {
            Name = "Picture",
            Transparency = 1,
            ZIndex = 1,
            Size = UDim2.fromOffset(84, 70),
            Position = UDim2.fromScale(0.5, 0.45),
            AnchorPoint = Vector2.new(0.5, 0.5)
        })
        TextButton2 = Instance.new("TextButton")
        TextButton2.Name = "Place"
        TextButton2.Text = ""
        TextButton2.BackgroundTransparency = 1
        TextButton2.Size = UDim2.fromScale(1, 1)
        TextButton2.ZIndex = 5
        TextButton2.Parent = v147
        TextButton2.Activated:Connect(function() -- line: 673
            -- upvalues: useSlot (copy), i (copy)
            useSlot(i)
        end)
        FishTooltip.Bind(TextButton2, function() -- line: 676
            -- upvalues: v75 (copy), t8 (copy), i (copy), v147 (copy)
            local v148 = t8[i]

            return if v148 and v148.rec and v147.Visible and v75.Visible then v148.rec else nil
        end)

        local Bind = UIKit.text

        v146 = {
            Name = "Key",
            TextSize = 20,
            Stroke = 3,
            ZIndex = 3
        }

        if UserInputService2.KeyboardEnabled then
            v146.Text = tostring(i % 10)
        else
            v146.Text = ""
        end

        v146.Size = UDim2.fromOffset(22, 22)
        v146.Position = UDim2.fromOffset(7, 5)
        v146.XAlign = Enum.TextXAlignment.Left
        v146.YAlign = Enum.TextYAlignment.Top
        Bind(v147, v146)
        TextButton2 = UIKit.text(v147, {
            Name = "Rate",
            Text = "",
            TextSize = 20,
            Stroke = 4,
            ZIndex = 3,
            Size = UDim2.fromOffset(90, 24),
            Position = UDim2.new(0.5, 0, 1, -3),
            AnchorPoint = Vector2.new(0.5, 1),
            Color = UIKit.Colors.Cash,
            StrokeColor = UIKit.Colors.CashStroke
        })
        Bind = Instance.new("UITextSizeConstraint")
        Bind.MaxTextSize = 20
        Bind.MinTextSize = 10
        Bind.Parent = TextButton2
        TextButton2.TextScaled = true
        t8[i] = {
            rec = nil,
            key = nil,
            frame = v147,
            pic = v145,
            rate = TextButton2,
            stroke = UIStroke
        }
    end

    local v150 = UIKit.text(v75, {
        Name = "More",
        Text = "",
        TextSize = 30,
        Stroke = 4,
        Size = UDim2.fromOffset(70, 96)
    })

    v150.LayoutOrder = 11
    v150.Visible = false

    local t9 = {
        [Enum.KeyCode.One] = 1,
        [Enum.KeyCode.Two] = 2,
        [Enum.KeyCode.Three] = 3,
        [Enum.KeyCode.Four] = 4,
        [Enum.KeyCode.Five] = 5,
        [Enum.KeyCode.Six] = 6,
        [Enum.KeyCode.Seven] = 7,
        [Enum.KeyCode.Eight] = 8,
        [Enum.KeyCode.Nine] = 9,
        [Enum.KeyCode.Zero] = 10,
        [Enum.KeyCode.KeypadOne] = 1,
        [Enum.KeyCode.KeypadTwo] = 2,
        [Enum.KeyCode.KeypadThree] = 3,
        [Enum.KeyCode.KeypadFour] = 4,
        [Enum.KeyCode.KeypadFive] = 5,
        [Enum.KeyCode.KeypadSix] = 6,
        [Enum.KeyCode.KeypadSeven] = 7,
        [Enum.KeyCode.KeypadEight] = 8,
        [Enum.KeyCode.KeypadNine] = 9,
        [Enum.KeyCode.KeypadZero] = 10
    }

    UserInputService2.InputBegan:Connect(function(p39, p40) -- line: 700
        -- upvalues: v75 (copy), useSlot (copy), t9 (copy), v7 (ref)
        local v151 = t9[p39.KeyCode]

        if v151 and not p40 and v75.Visible and v7 == "normal" then
            useSlot(v151)
        end
    end)

    local function heldSlot() -- line: 708
        -- upvalues: t8 (copy), t1 (copy)
        local v152 = t1.HeldFishUid and t1.HeldFishUid()
        local v153 = t1.HeldEggKey and t1.HeldEggKey()

        for v154, v155 in ipairs(t8) do
            if v155.frame.Visible and (v155.rec and v152 and v155.rec.uid == v152 or v155.egg and v153 == v155.egg) then
                return v154
            end
        end

        return 0
    end

    local function cycle(p41) -- line: 718
        -- upvalues: t8 (copy), useSlot (copy), heldSlot (copy)
        local n4 = 0

        for _, v156 in ipairs(t8) do
            if v156.frame.Visible then
                n4 += 1
            end
        end

        if n4 == 0 then
            return
        end

        local v157 = heldSlot()
        local v158 = (v157 + p41) % (n4 + 1)
        local v159 = v158 == 0
        local v160

        if v159 then
            v160 = v157 > 0
        else
            useSlot(v158)
        end

        if (not v159 or v160) and v159 then
            useSlot(v157)
        end
    end

    t1.CycleHotbar = cycle
    t1.HeldSlot = heldSlot
    UserInputService2.InputBegan:Connect(function(p42, p43) -- line: 740
        -- upvalues: v75 (copy), cycle (copy), GuiService (copy), v7 (ref)
        local v161 = if p42.KeyCode == Enum.KeyCode.ButtonR1 then 1 elseif p42.KeyCode == Enum.KeyCode.ButtonL1 then -1 else 0

        if v161 ~= 0 and not p43 and v75.Visible and v7 == "normal" and GuiService.SelectedObject == nil then
            cycle(v161)
        end
    end)

    local t10 = {}

    for v162, v163 in ipairs({
            Enum.KeyCode.ButtonL1,
            Enum.KeyCode.ButtonR1
        }) do
        v146 = UIKit.frame(v75, {
            Transparency = 1,
            Name = "Pad" .. v163.Name,
            Size = UDim2.fromOffset(52, 96)
        })
        v146.LayoutOrder = v162 == 1 and 0 or 12
        Pad.Icon(v146, v163, {
            ZIndex = 3,
            Size = UDim2.fromOffset(52, 52),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5)
        })
        v146.Visible = Pad.Using()
        t10[v162] = v146
    end

    Pad.Changed:Connect(function(p44) -- line: 754
        -- upvalues: t10 (copy)
        for _, v164 in ipairs(t10) do
            v164.Visible = p44
        end
    end)
    UIStroke = Vector2.new(0, 220)
    v145 = v75.Position
    t2.Hotbar = {
        frame = v75,
        shown = v145,
        hidden = v145 + UDim2.fromOffset(UIStroke.X, UIStroke.Y)
    }
    v75.Visible = false

    local function eggPicture(p45, p46) -- line: 763
        -- upvalues: UIKit (copy)
        if UIKit.eggPicture(p45, p46, {
            ZIndex = 2,
            Size = UDim2.fromScale(1.12, 1.18)
        }) then
            return
        end

        local fromRGB = Color3.fromRGB

        if p46 == "RainbowCrate" then
            local v165 = UIKit.frame(p45, {
                Name = "Chest",
                Corner = 5,
                Stroke = 3,
                Size = UDim2.fromOffset(66, 36),
                Position = UDim2.new(0.5, 0, 1, -4),
                AnchorPoint = Vector2.new(0.5, 1),
                Color = fromRGB(255, 205, 70)
            })

            for v166, v167 in ipairs({
                    fromRGB(255, 80, 80),
                    fromRGB(255, 160, 60),
                    fromRGB(255, 225, 70),
                    fromRGB(110, 225, 100),
                    fromRGB(80, 170, 255),
                    fromRGB(150, 110, 255)
                }) do
                UIKit.frame(v165, {
                    Name = "Stripe",
                    Corner = 1,
                    Size = UDim2.new(0, 8, 1, -8),
                    Position = UDim2.fromOffset(4 + v166 * 8, 4),
                    Color = v167
                })
            end

            UIKit.frame(p45, {
                Name = "Lid",
                Corner = 6,
                Stroke = 3,
                Size = UDim2.fromOffset(72, 18),
                Position = UDim2.new(0.5, 0, 1, -40),
                AnchorPoint = Vector2.new(0.5, 1),
                Color = fromRGB(255, 180, 50)
            })
        else
            local v168 = UIKit.frame(p45, {
                Name = "Egg",
                Corner = 23,
                Stroke = 3,
                Size = UDim2.fromOffset(46, 60),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Color = fromRGB(225, 60, 60)
            })

            UIKit.frame(v168, {
                Name = "Band",
                Corner = 2,
                Size = UDim2.new(1, -4, 0, 7),
                Position = UDim2.new(0, 2, 0.3, 0),
                Color = fromRGB(255, 215, 70)
            })
            UIKit.frame(v168, {
                Name = "Band",
                Corner = 2,
                Size = UDim2.new(1, -4, 0, 7),
                Position = UDim2.new(0, 2, 0.62, 0),
                Color = fromRGB(255, 215, 70)
            })
        end
    end

    local function refreshHotbar() -- line: 780
        -- upvalues: v75 (copy), t8 (copy), refreshGlow (copy), v150 (copy), eggPicture (copy), NumberFormat (copy), Roll (copy), UIKit (copy), FishIcons (copy), DataClient (copy)
        local Backpack = DataClient.Get("Backpack")
        local t11 = {}
        local t12 = {}

        for _, v169 in ipairs(DataClient.Get("Eggs") or {}) do
            if not t11[v169] then
                t11[v169] = 0
                table.insert(t12, v169)
            end

            t11[v169] += 1
        end

        local v170 = (Backpack and #Backpack or 0) + #t12
        local Visible = v75.Visible

        v75.Visible = v170 > 0

        local t13 = {}

        for _, v171 in ipairs(Backpack or {}) do
            table.insert(t13, {
                rec = v171,
                income = Roll.incomeOf(v171)
            })
        end

        table.sort(t13, function(p47, p48) -- line: 797
            if p47.income == p48.income then
                return p47.rec.uid < p48.rec.uid
            end

            return p47.income > p48.income
        end)

        for v172, v173 in ipairs(t12) do
            table.insert(t13, v172, {
                egg = v173,
                count = t11[v173]
            })
        end

        for v174, v175 in ipairs(t8) do
            local v176 = t13[v174]

            v175.rec = v176 and v176.rec or nil
            v175.egg = v176 and v176.egg or nil
            v175.frame.Visible = v176 ~= nil

            if v176 then
                if v176.egg then
                    local v177 = "egg/" .. v176.egg

                    if v177 ~= v175.key then
                        v175.key = v177
                        v175.pic:ClearAllChildren()
                        eggPicture(v175.pic, v176.egg)
                    end

                    v175.rate.Text = "x" .. v176.count
                    v175.rate.TextColor3 = UIKit.Colors.Gold
                else
                    v175.rate.TextColor3 = UIKit.Colors.Cash

                    local v178 = v176.rec.id .. "/" .. tostring(v176.rec.v)

                    if v178 ~= v175.key then
                        v175.key = v178
                        v175.pic:ClearAllChildren()
                        FishIcons.Picture(v175.pic, v176.rec.id, v176.rec.v, 1.2)
                    end

                    v175.rate.Text = NumberFormat.rate(v176.income)
                end
            else
                v175.key = nil
                v175.pic:ClearAllChildren()
            end
        end

        v150.Visible = v170 > 10
        v150.Text = "+" .. v170 - 10
        refreshGlow()

        if v170 > 0 and not Visible then
            UIKit.pop(v75, 1.3)
        end
    end

    DataClient.Observe("Backpack", refreshHotbar)
    DataClient.Observe("Eggs", refreshHotbar)
    v4 = UIKit.frame(v2, {
        Name = "TipBubble",
        Transparency = 0.18,
        Corner = 22,
        Stroke = 4,
        Size = UDim2.fromOffset(0, 108),
        Position = UDim2.new(0.5, 0, 0, 88),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = Color3.fromRGB(14, 18, 34),
        StrokeColor = Color3.fromRGB(255, 221, 40)
    })
    TextButton2 = v4
    TextButton2.AutomaticSize = Enum.AutomaticSize.X
    v145 = Instance.new("UIPadding")
    v145.PaddingLeft = UDim.new(0, 30)
    v145.PaddingRight = UDim.new(0, 30)
    v145.Parent = v4
    v145 = UIKit.frame(v4, {
        Name = "Tail",
        Transparency = 0.18,
        Size = UDim2.fromOffset(24, 24),
        Position = UDim2.new(0.5, 0, 1, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Color3.fromRGB(14, 18, 34)
    })
    v145.Rotation = 45
    v145.ZIndex = 0
    v3 = UIKit.text(v4, {
        Name = "Instruction",
        Text = "",
        TextSize = 66,
        Stroke = 5,
        ZIndex = 2,
        Size = UDim2.fromOffset(0, 108)
    })
    TextButton2 = v3
    TextButton2.AutomaticSize = Enum.AutomaticSize.X
    TextButton2 = v3
    TextButton2.Position = UDim2.fromOffset(0, 0)
    TextButton2 = v3
    TextButton2.AnchorPoint = Vector2.zero
    v4.Visible = false
    t1.Gui = v2
    t1.IndexButton = v36
    t1.ShopButton = v37
    t1.Hotbar = v75
    t1.Lucky = TextButton
end

return t1
