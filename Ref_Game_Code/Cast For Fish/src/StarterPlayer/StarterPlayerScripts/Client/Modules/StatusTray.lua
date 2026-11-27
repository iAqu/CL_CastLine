-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local Parent = script.Parent
local Events = require(Shared.Data.Events)
local Buffs = require(Shared.Data.Buffs)
local UIKit = require(Parent.UIKit)
local HUD = require(Parent.HUD)
local BuffHud = require(Parent.BuffHud)
local fromRGB = Color3.fromRGB
local Colors = UIKit.Colors
local v1 = Vector2.new(0.5, 0.5)
local Left = Enum.TextXAlignment.Left
local LocalPlayer = Players.LocalPlayer
local v2 = fromRGB(14, 14, 22)
local v3 = fromRGB(255, 205, 110)
local v4 = fromRGB(215, 220, 240)
local v5 = fromRGB(30, 34, 70)
local v6 = fromRGB(14, 16, 34)
local t1 = {
    rain = "rbxassetid://84746260301820",
    snow = "rbxassetid://138856786646233",
    storm = "rbxassetid://76488847471319",
    aurora = "rbxassetid://110899755022368",
    meteor = "rbxassetid://80907956844363",
    bloodmoon = "rbxassetid://121433018841128",
    eclipse = "rbxassetid://109049497203882",
    cosmic = "rbxassetid://73618828484988"
}
local t2 = {
    luck = "Doubles your luck.",
    cash = "Doubles your cash earnings.",
    strength = "Doubles the strength you gain from training.",
    cosmic = "Doubles your luck, cash earnings, and strength gained from training."
}
local v7, v8
local t3 = {}
local t4 = {}
local t5 = {}
local key = nil
local key2 = nil
local n1 = 0

local function clock(p1) -- line: 91
    local v10 = math.max(0, (math.ceil(p1)))

    return string.format("%d:%02d", v10 // 60, v10 % 60)
end

local function readable(p2) -- line: 96
    -- upvalues: Colors (copy)
    local _, _, v11 = p2:ToHSV()

    return p2:Lerp(Colors.White, if v11 < 0.6 then 0.6 else 0.15)
end

local function hidden() -- line: 101
    -- upvalues: HUD (copy), BuffHud (copy)
    if HUD.GetMode() == "cutscene" then
        return true
    end

    return BuffHud.Hidden ~= nil and BuffHud.Hidden() == true
end

local function jumpRight() -- line: 105
    -- upvalues: LocalPlayer (copy), v7 (ref), v8 (ref)
    if not (v8 and v7) then
        return 24
    end

    local TouchGui = LocalPlayer.PlayerGui:FindFirstChild("TouchGui")
    local v12 = TouchGui and TouchGui:FindFirstChild("JumpButton", true)
    local v13

    if not v12 or not v12:IsA("GuiObject") or not v12.Visible or v12.AbsoluteSize.X <= 0 then
        return 24
    else
        local UIScale = v7:FindFirstChildOfClass("UIScale")

        v13 = if UIScale and UIScale.Scale > 0 then UIScale.Scale else 1
    end

    return math.ceil((v7.AbsoluteSize.X - v12.AbsolutePosition.X) / v13) + 10
end

local function weatherEntry() -- line: 119
    -- upvalues: Events (copy)
    local v16 = Events.ById[workspace:GetAttribute("EventId") or ""]

    if not v16 then
        return nil
    end

    local EventEnds = workspace:GetAttribute("EventEnds")
    local v17 = if type(EventEnds) == "number" then EventEnds - workspace:GetServerTimeNow() else nil

    return if not v17 or not (v17 <= 0) then {
        key = "weather",
        kind = "weather",
        endsLabel = "Weather ends in ",
        name = v16.name,
        color = v16.Color,
        text = ("Every 10 seconds, each fish in your pen has a small chance to become %s (×%d income)."):format(v16.mutation, v16.mult),
        left = v17,
        ends = if type(EventEnds) ~= "number" then nil else EventEnds,
        def = v16,
        panel = v16.panel
    } else nil
end

local function potionEntries() -- line: 143
    -- upvalues: Buffs (copy), LocalPlayer (copy), t2 (copy)
    local t7 = {}

    for _, v18 in Buffs.List do
        local v19 = Buffs.Left(LocalPlayer, v18.id)

        if v19 > 0 then
            table.insert(t7, {
                kind = "potion",
                endsLabel = "Potion ends in ",
                key = "potion_" .. v18.id,
                name = v18.name,
                color = v18.Color,
                text = t2[v18.id] or "",
                left = v19,
                def = v18
            })
        end
    end

    return t7
end

local function buildTip() -- line: 163
    -- upvalues: UIKit (copy), Colors (copy), Left (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), t5 (copy)
    local v20 = UIKit.screenGui("StatusTip", 31)
    local v21 = UIKit.frame(v20, {
        Name = "Card",
        Corner = 14,
        Stroke = 4,
        ZIndex = 2,
        Size = UDim2.fromOffset(340, 128),
        AnchorPoint = Vector2.new(0.5, 1),
        Color = v5,
        Color2 = v6
    })

    v21.Visible = false

    local v22 = UIKit.dress(v21, 14, Colors.White, 2)

    t5.gui = v20
    t5.card = v21
    t5.gradient = v21:FindFirstChildOfClass("UIGradient")
    t5.rim = v22:FindFirstChildOfClass("UIStroke")
    t5.title = UIKit.text(v21, {
        Name = "Title",
        Text = "",
        Stroke = 3,
        ZIndex = 4,
        Size = UDim2.new(1, -24, 0, 30),
        Position = UDim2.fromOffset(12, 10),
        XAlign = Left
    })

    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = 28
    UITextSizeConstraint.Parent = t5.title
    t5.body = UIKit.text(v21, {
        Name = "Body",
        Text = "",
        Stroke = 2,
        ZIndex = 4,
        Size = UDim2.new(1, -24, 0, 50),
        Position = UDim2.fromOffset(12, 42),
        XAlign = Left,
        YAlign = Enum.TextYAlignment.Top,
        Color = v4
    })
    t5.body.TextWrapped = true

    local UITextSizeConstraint2 = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint2.MaxTextSize = 19
    UITextSizeConstraint2.MinTextSize = 11
    UITextSizeConstraint2.Parent = t5.body
    t5.time = UIKit.text(v21, {
        Name = "Time",
        Text = "",
        TextSize = 20,
        Stroke = 3,
        ZIndex = 4,
        Size = UDim2.new(1, -24, 0, 24),
        Position = UDim2.new(0, 12, 1, -32),
        XAlign = Left,
        Color = v3
    })
end

local function showTip(p3) -- line: 185
    -- upvalues: Colors (copy), v5 (copy), v6 (copy), v8 (ref), t3 (copy), t4 (copy), t5 (copy)
    if t5.card then
        local v23, v24

        if p3 then
            v23 = t4[p3]
            v24 = t3[p3]
        end

        if not v23 or not v24 or not v24.frame.Visible or not v8 or not v8.Visible then
            t5.card.Visible = false

            return
        end

        t5.title.Text = v23.name

        local title = t5.title

        if v23.panel then
            title.TextColor3 = v23.panel.title
        else
            local color = v23.color
            local _, _, v25 = color:ToHSV()

            title.TextColor3 = color:Lerp(Colors.White, v25 < 0.6 and 0.6 or 0.15)
        end

        t5.body.Text = v23.text

        local time = t5.time

        if v23.left then
            local endsLabel = v23.endsLabel
            local v27 = math.max(0, (math.ceil(v23.left)))

            time.Text = endsLabel .. string.format("%d:%02d", v27 // 60, v27 % 60)
        else
            time.Text = ""
        end

        local gradient = t5.gradient

        if v23.panel then
            gradient.Color = ColorSequence.new(v23.panel.top, v23.panel.bottom)
        else
            gradient.Color = ColorSequence.new(v23.color:Lerp(v5, 0.75), v23.color:Lerp(v6, 0.88))
        end

        t5.rim.Color = v23.color:Lerp(Colors.White, 0.4)

        local UIScale = t5.gui:FindFirstChildOfClass("UIScale")
        local v28 = if not (UIScale and UIScale.Scale > 0) then 1 else UIScale.Scale
        local v29 = t5.gui.AbsoluteSize.X / v28
        local frame = v24.frame
        local v30 = (frame.AbsolutePosition.X + frame.AbsoluteSize.X / 2) / v28
        local v31 = if t5.gui.IgnoreGuiInset then game:GetService("GuiService"):GetGuiInset().Y else 0
        local v32 = (frame.AbsolutePosition.Y + v31) / v28 - 10
        local v35 = math.clamp(v30, 182, (math.max(182, v29 - 170 - 12)))

        t5.card.Position = UDim2.fromOffset(v35, (math.max(v32, 140)))
        t5.card.Visible = true
    end
end

local function makeSlot(p4) -- line: 213
    -- upvalues: UserInputService (copy), UIKit (copy), BuffHud (copy), v1 (copy), v2 (copy), t1 (copy), v8 (ref), key (ref), key2 (ref), showTip (copy)
    local TextButton = Instance.new("TextButton")

    TextButton.Name = p4.key
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BackgroundColor3 = v2
    TextButton.BackgroundTransparency = 0.3
    TextButton.BorderSizePixel = 0
    TextButton.AnchorPoint = Vector2.new(1, 1)
    TextButton.Size = UDim2.fromOffset(68, 68)
    TextButton.ZIndex = 2
    UIKit.corner(TextButton, 34)
    UIKit.stroke(TextButton, 2)
    TextButton.Parent = v8

    local def = p4.def

    if p4.kind == "potion" then
        local v36 = BuffHud.Bottle(TextButton, def, 52, 3)

        v36.AnchorPoint = v1
        v36.Position = UDim2.fromScale(0.5, 0.5)
    elseif t1[def.id] then
        UIKit.image(TextButton, t1[def.id], {
            ZIndex = 3,
            Size = UDim2.fromOffset(52, 52),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = v1
        })
    else
        UIKit.text(TextButton, {
            Name = "Glyph",
            TextSize = 34,
            Stroke = 0,
            ZIndex = 3,
            Text = def.icon or "?",
            Size = UDim2.fromScale(1, 1)
        })
    end

    local v37 = UIKit.text(TextButton, {
        Name = "Timer",
        Text = "",
        TextSize = 16,
        Stroke = 2,
        ZIndex = 3,
        Size = UDim2.fromOffset(84, 20),
        Position = UDim2.new(0.5, 0, 1, 4),
        AnchorPoint = Vector2.new(0.5, 0)
    })
    local key3 = p4.key

    TextButton.MouseEnter:Connect(function() -- line: 239
        -- upvalues: key3 (copy), UserInputService (copy), key (ref), showTip (copy)
        if UserInputService.MouseEnabled then
            key = key3
            showTip(key3)
        end
    end)
    TextButton.MouseLeave:Connect(function() -- line: 245
        -- upvalues: key3 (copy), key (ref), key2 (ref), showTip (copy)
        if key == key3 then
            key = nil
            showTip(key2)
        end
    end)
    TextButton.Activated:Connect(function() -- line: 251
        -- upvalues: key3 (copy), key (ref), key2 (ref), showTip (copy)
        if key2 == key3 then
            key2 = nil
            key = nil
        else
            key2 = key3
        end

        showTip(key or key2)
    end)
    TextButton.SelectionGained:Connect(function() -- line: 260
        -- upvalues: key3 (copy), key (ref), showTip (copy)
        key = key3
        showTip(key3)
    end)
    TextButton.SelectionLost:Connect(function() -- line: 264
        -- upvalues: key3 (copy), key (ref), key2 (ref), showTip (copy)
        if key == key3 then
            key = nil
            showTip(key2)
        end
    end)

    return {
        shown = false,
        frame = TextButton,
        timer = v37
    }
end

local function layout(p5) -- line: 273
    -- upvalues: t3 (copy)
    for v38, v39 in p5 do
        local v40 = t3[v39.key]
        local v41 = v38 - 1
        local v42 = v41 % 5
        local v43 = v41 // 5

        v40.frame.Position = UDim2.new(1, -v42 * 80, 1, -24 - v43 * 108)
    end
end

local function update() -- line: 283
    -- upvalues: UIKit (copy), HUD (copy), BuffHud (copy), Colors (copy), v3 (copy), v8 (ref), t3 (copy), t4 (copy), key (ref), key2 (ref), jumpRight (copy), weatherEntry (copy), potionEntries (copy), showTip (copy), makeSlot (copy), layout (copy)
    if not v8 then
        return
    end

    local t9 = {}
    local v44 = weatherEntry()

    if v44 then
        table.insert(t9, v44)
    end

    for _, v45 in potionEntries() do
        table.insert(t9, v45)
    end

    local t10 = {}

    for _, v46 in t9 do
        t10[v46.key] = true

        local v47 = t3[v46.key]
        local v48 = t4[v46.key]

        if v47 and v48 and v48.def ~= v46.def then
            v47.frame:Destroy()
            v47 = nil
            t3[v46.key] = nil
        end

        if not v47 then
            v47 = makeSlot(v46)
            t3[v46.key] = v47
        end

        if v47 and v48 and v48.ends ~= v46.ends then
            v47.shown = false
        end

        t4[v46.key] = v46
        v47.frame.Visible = true

        if not v47.shown then
            v47.shown = true
            UIKit.pop(v47.frame, 1.15)
        end

        if v46.left then
            local timer = v47.timer
            local v50 = math.max(0, (math.ceil(v46.left)))

            timer.Text = string.format("%d:%02d", v50 // 60, v50 % 60)

            local v51 = if math.ceil(v46.left) < 10 then math.sin(os.clock() * 3.141592653589793 * 2) * 0.5 + 0.5 else 0

            v47.timer.TextColor3 = Colors.White:Lerp(v3, v51)
            continue
        end

        v47.timer.Text = ""
    end

    for v53, v54 in t3 do
        if not t10[v53] then
            v54.frame:Destroy()
            t3[v53] = nil
            t4[v53] = nil

            if key2 == v53 then
                key2 = nil
            end

            if key == v53 then
                key = nil
            end
        end
    end

    layout(t9)

    local v55 = v8

    v55.Visible = not (HUD.GetMode() == "cutscene" or BuffHud.Hidden ~= nil and BuffHud.Hidden() == true)

    local v56 = jumpRight()

    if v8.Position.X.Offset ~= -v56 then
        local v57 = v8

        v57.Position = UDim2.new(1, -v56, 1, -24)
    end

    showTip(key or key2)
end

return {
    Count = function() -- Count | line: 351
        -- upvalues: t3 (copy)
        local n2 = 0

        for _ in t3 do
            n2 += 1
        end

        return n2
    end,
    Has = function(p6) -- Has | line: 359
        -- upvalues: t3 (copy)
        return t3[p6] ~= nil and t3[p6].frame.Visible
    end,
    Init = function() -- Init | line: 363
        -- upvalues: RunService (copy), UIKit (copy), v7 (ref), v8 (ref), n1 (ref), buildTip (copy), update (copy)
        if v7 then
            return
        end

        v7 = UIKit.screenGui("StatusTray", 6)
        v8 = UIKit.frame(v7, {
            Name = "Tray",
            Transparency = 1,
            Size = UDim2.fromOffset(400, 216),
            Position = UDim2.new(1, -24, 1, -24),
            AnchorPoint = Vector2.new(1, 1)
        })
        buildTip()
        RunService.Heartbeat:Connect(function(p7) -- line: 370
            -- upvalues: n1 (ref), update (copy)
            n1 += p7

            if not (n1 < 0.1) then
                n1 = 0
                update()
            end
        end)
        update()
    end
}
