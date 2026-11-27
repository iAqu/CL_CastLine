-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(ReplicatedStorage.Shared.Config)
local Format = require(ReplicatedStorage.Shared.Format)
local Playtime = require(ReplicatedStorage.Shared.Playtime)
local Products = require(ReplicatedStorage.Shared.Products)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.UIUtil)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Style = require(script.Parent.Parent.Shop.Style)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local t2 = {
    Cash = Style.KELP,
    Strength = Style.CORAL,
    Potion = Style.ABYSS
}
local ScreenGui, v1, v2
local t3 = {}
local v3

local function potionImage(p1) -- line: 34
    -- upvalues: Products (copy)
    for _, v4 in Products.Potions do
        if v4.Stat == p1 then
            return v4.Image
        end
    end

    return ""
end

local function claimed() -- line: 43
    -- upvalues: LocalPlayer (copy)
    local t4 = {}

    for match in string.gmatch(LocalPlayer:GetAttribute("PlayClaimed") or "", "%d+") do
        t4[tonumber(match)] = true
    end

    return t4
end

local function ready() -- line: 52
    -- upvalues: Playtime (copy), LocalPlayer (copy), claimed (copy)
    local v5 = LocalPlayer:GetAttribute("PlaySeconds") or 0
    local v6 = claimed()
    local n1 = 0

    for v7, v8 in Playtime.Rewards do
        if not v6[v7] and v8.At * 60 <= v5 then
            n1 += 1
        end
    end

    return n1
end

local function amountText(p2) -- line: 62
    -- upvalues: Format (copy), Playtime (copy), LocalPlayer (copy)
    local v9 = Playtime.amount(p2, LocalPlayer:GetAttribute("Income") or 0, LocalPlayer:GetAttribute("StrengthRate") or 0)

    if p2.Kind == "Cash" then
        return Format.money(v9)
    end

    if p2.Kind == "Strength" then
        return (("+%* XP"):format((Format.short(v9))))
    end

    return (("2x %* · %*m"):format(p2.Stat, v9 // 60))
end

local function refresh() -- line: 72
    -- upvalues: Playtime (copy), Style (copy), LocalPlayer (copy), v1 (ref), v2 (ref), t3 (copy), claimed (copy), amountText (copy)
    local v10 = LocalPlayer:GetAttribute("PlaySeconds") or 0
    local v11 = claimed()
    local v12 = v1

    v12.Text = ("Played today: <font color=\"#FFE25A\">%*</font>"):format((Style.clock(v10)))

    local v13 = v2

    v13.Text = "Resets in " .. Style.clock(Playtime.DAY - workspace:GetServerTimeNow() % Playtime.DAY)

    for v14, v15 in Playtime.Rewards do
        local v16 = t3[v14]
        local v17 = v11[v14] == true
        local v18 = not v17 and v15.At * 60 <= v10

        v16.claim.Visible = v18
        v16.done.Visible = v17
        v16.locked.Visible = not v17 and not v18
        v16.locked.Label.Text = "⏱ " .. Style.clock(v15.At * 60 - v10)
        v16.amount.Text = amountText(v15)
        v16.card.BackgroundTransparency = v17 and 0.35 or 0
    end
end

local function refreshBadge() -- line: 89
    -- upvalues: v3 (ref), ready (copy)
    local v19 = ready()

    v3.Visible = v19 > 0
    v3.Label.Text = tostring(v19)
end

local function tile(p3, p4, p5) -- line: 95
    -- upvalues: Config (copy), Products (copy), Remotes (copy), UIUtil (copy), Kit (copy), Style (copy), t2 (copy), t3 (copy)
    local v21 = (p4 - 1) % 4
    local v22 = (p4 - 1) // 4
    local v23 = Style.card(p3, t2[p5.Kind], {
        Name = "Reward" .. p4,
        Position = UDim2.fromOffset(v21 * 238, v22 * 268),
        Size = UDim2.fromOffset(220, 250)
    })

    Style.tag(v23, ("%* MIN"):format(p5.At), Style.DEEP, {
        Rotation = -3,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0, 4),
        Size = UDim2.fromOffset(120, 40)
    })

    local v24 = Style.bubble(v23, "", {
        ZIndex = 2,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 34),
        Size = UDim2.fromOffset(104, 104)
    })
    local icon = Style.icon
    local v25

    if p5.Kind == "Cash" then
        v25 = Config.Icons.Cash
    elseif p5.Kind == "Strength" then
        v25 = Config.Icons.Strength
    else
        local Stat = p5.Stat
        local v26 = false

        for _, v27 in Products.Potions do
            if v27.Stat == Stat then
                v25 = v27.Image
                v26 = true
                break
            end
        end

        if not v26 then
            v25 = ""
        end
    end

    icon(v24, v25)

    local v28 = Style.text(v23, "", {
        Name = "Amount",
        StrokeThickness = 4,
        ZIndex = 2,
        Position = UDim2.fromOffset(12, 142),
        Size = UDim2.new(1, -24, 0, 38)
    })

    Style.gradient(v28, ColorSequence.new(Color3.new(1, 1, 1), Style.MINT))

    local t5 = {
        ZIndex = 3,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -14),
        Size = UDim2.new(1, -36, 0, 52)
    }
    local v29 = Kit.button(v23, "CLAIM!", Style.BUY, t5, function() -- line: 120
        -- upvalues: p4 (copy), v23 (copy), Remotes (copy), UIUtil (copy), Kit (copy), Style (copy)
        Remotes.ClaimPlaytime:FireServer(p4)
        UIUtil.sound("Reveal", 0.5, 1.2)
        Kit.burst(v23, Vector2.new(110, 125), Style.YELLOW, 18)
    end)

    v29.Name = "Claim"
    v29.Label.ZIndex = 4

    local v30 = Kit.frame(v23, {
        Name = "Locked",
        BackgroundTransparency = 0.3,
        ZIndex = 3,
        BackgroundColor3 = Style.DEEP,
        AnchorPoint = t5.AnchorPoint,
        Position = t5.Position,
        Size = t5.Size
    })

    Kit.corner(v30, 12)
    Kit.text(v30, "", {
        Name = "Label",
        ZIndex = 4,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.52),
        Size = UDim2.fromScale(0.86, 0.62)
    })
    t3[p4] = {
        card = v23,
        claim = v29,
        locked = v30,
        done = Kit.text(v23, "CLAIMED ✔", {
            Name = "Done",
            ZIndex = 3,
            AnchorPoint = t5.AnchorPoint,
            Position = t5.Position,
            Size = UDim2.new(1, -36, 0, 40),
            TextColor3 = Style.MINT
        }),
        amount = v28
    }
end

local function build() -- line: 149
    -- upvalues: Playtime (copy), Kit (copy), Style (copy), LocalPlayer (copy), t1 (copy), ScreenGui (ref), v1 (ref), v2 (ref), tile (copy)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PlaytimeRewards"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true

    local ScreenGui2 = ScreenGui

    ScreenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 6
    ScreenGui.Enabled = false

    local v32 = Kit.frame(ScreenGui, {
        Name = "Panel",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(986, 698),
        BackgroundColor3 = Color3.new(1, 1, 1)
    })

    Kit.corner(v32, 24)
    Kit.stroke(v32, 6)
    Style.gradient(v32, ColorSequence.new(Style.NAVY, Style.DEEP))
    Kit.studs(v32, 0.75, 44, 24)

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "Scale"
    UIScale.Parent = v32

    local v33 = Kit.frame(v32, {
        Name = "Header",
        ZIndex = 2,
        BackgroundColor3 = Color3.new(1, 1, 1),
        Size = UDim2.new(1, 0, 0, 118)
    })

    Kit.corner(v33, 22)
    Kit.stroke(v33, 5)
    Style.gradient(v33, ColorSequence.new(Style.GOLD, Style.CORAL), 0)
    Kit.studs(v33, 0.5, 48, 22)
    Style.bubble(v33, "🎁", {
        ZIndex = 3,
        Position = UDim2.fromOffset(16, 10),
        Size = UDim2.fromOffset(98, 98)
    })

    local v34 = Kit.text(v33, "PLAYTIME REWARDS", {
        ZIndex = 3,
        StrokeThickness = 6,
        Position = UDim2.fromOffset(126, 10),
        Size = UDim2.fromOffset(560, 62),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    Style.gradient(v34, ColorSequence.new(Color3.new(1, 1, 1), Style.YELLOW))
    v1 = Style.text(v33, "", {
        Name = "Played",
        ZIndex = 3,
        Position = UDim2.fromOffset(128, 72),
        Size = UDim2.fromOffset(330, 34),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    v2 = Style.text(v33, "", {
        Name = "Resets",
        ZIndex = 3,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -130, 0, 72),
        Size = UDim2.fromOffset(300, 34),
        TextXAlignment = Enum.TextXAlignment.Right,
        TextColor3 = Style.SAND
    })
    Kit.button(v33, "X", Color3.fromRGB(235, 70, 70), {
        Name = "Close",
        ZIndex = 3,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -18, 0.5, 0),
        Size = UDim2.fromOffset(86, 86)
    }, function() -- line: 213
        -- upvalues: t1 (copy)
        task.spawn(t1.close)
    end).Label.ZIndex = 4

    local v35 = Kit.frame(v32, {
        Name = "Body",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(26, 150),
        Size = UDim2.new(1, -52, 1, -170)
    })

    for v36, v37 in Playtime.Rewards do
        tile(v35, v36, v37)
    end

    local ScreenGui3 = ScreenGui

    ScreenGui3.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local function buildBadge(p6) -- line: 231
    -- upvalues: RunService (copy), Kit (copy), v3 (ref)
    v3 = Kit.frame(p6, {
        Name = "Badge",
        ZIndex = 5,
        Visible = false,
        BackgroundColor3 = Color3.fromRGB(235, 50, 60),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(1, -4, 0, 4),
        Size = UDim2.fromOffset(22, 22)
    })

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = v3
    Kit.stroke(v3, 2, Color3.new(1, 1, 1))
    Kit.text(v3, "", {
        Name = "Label",
        ZIndex = 6,
        StrokeThickness = 2,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.7, 0.7)
    })
    RunService.Heartbeat:Connect(function() -- line: 247
        -- upvalues: v3 (ref)
        if v3.Visible then
            v3.Rotation = math.sin(os.clock() * 6) * 10
        end
    end)
end

function t1.isOpen() -- line: 254
    -- upvalues: ScreenGui (ref)
    return ScreenGui ~= nil and ScreenGui.Enabled
end

function t1.open() -- line: 258
    -- upvalues: UIUtil (copy), t1 (copy), ScreenGui (ref), t3 (copy), refresh (copy)
    if t1.isOpen() then
        return
    end

    refresh()
    UIUtil.openPanel(ScreenGui)
    task.spawn(function() -- line: 264
        -- upvalues: t1 (copy), t3 (copy), refresh (copy)
        while t1.isOpen() do
            refresh()

            local v41 = math.sin(os.clock() * 5) * 3

            for _, v42 in t3 do
                v42.claim.Rotation = v41
            end

            task.wait(0.1)
        end
    end)
end

function t1.close() -- line: 277
    -- upvalues: UIUtil (copy), ScreenGui (ref)
    UIUtil.closePanel(ScreenGui)
end

function t1.init(p7) -- line: 282
    -- upvalues: LocalPlayer (copy), t1 (copy), v3 (ref), ready (copy), refresh (copy), refreshBadge (copy), build (copy), buildBadge (copy)
    build()
    buildBadge(p7)

    for _, v43 in { "PlaySeconds", "PlayClaimed" } do
        LocalPlayer:GetAttributeChangedSignal(v43):Connect(refreshBadge)
    end

    LocalPlayer:GetAttributeChangedSignal("PlayClaimed"):Connect(function() -- line: 288
        -- upvalues: t1 (copy), refresh (copy)
        if t1.isOpen() then
            refresh()
        end
    end)

    local v44 = ready()

    v3.Visible = v44 > 0
    v3.Label.Text = tostring(v44)
end

return t1
