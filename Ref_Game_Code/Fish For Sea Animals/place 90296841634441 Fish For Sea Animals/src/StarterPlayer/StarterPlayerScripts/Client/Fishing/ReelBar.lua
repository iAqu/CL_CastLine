-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimalModel = require(ReplicatedStorage.Shared.AnimalModel)
local Config = require(ReplicatedStorage.Shared.Config)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Viewport = require(script.Parent.Parent.UI.Viewport)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local LocalPlayer = Players.LocalPlayer
local v1 = Color3.new(1, 1, 1)
local t1 = {}

t1.GREEN = Color3.fromRGB(90, 235, 110)
t1.RED = Color3.fromRGB(255, 70, 80)
t1.GOLD = Color3.fromRGB(255, 215, 70)
t1.WIDTH = 600

local GREEN, RED, GOLD, WIDTH = t1.GREEN, t1.RED, t1.GOLD, t1.WIDTH
local self = setmetatable({}, {
    __mode = "k"
})

local function new(p1, p2, p3) -- line: 28
    local v3 = Instance.new(p1)

    for v4, v5 in p3 do
        v3[v4] = v5
    end

    v3.Parent = p2

    return v3
end

local function build(p4) -- line: 38
    -- upvalues: UIUtil (copy), Kit (copy), LocalPlayer (copy), v1 (copy), GREEN (copy), RED (copy), GOLD (copy), WIDTH (copy), self (copy)
    local v6 = Kit.frame(p4, {
        Name = "Reel",
        BackgroundTransparency = 1,
        Visible = false,
        ZIndex = 6,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromScale(0.5, 0.88),
        Size = UDim2.fromOffset(WIDTH + 300, 190)
    })
    local t4 = {
        Name = "ReelScale"
    }
    local UIScale = Instance.new("UIScale")

    for v7, v8 in t4 do
        UIScale[v7] = v8
    end

    UIScale.Parent = v6
    UIUtil.onScale(function(p5) -- line: 50
        -- upvalues: UIScale (copy), UIUtil (copy)
        UIScale.Scale = p5 * UIUtil.smallScreenBoost(p5, 1.4)
    end)

    local v9 = (WIDTH + 300) / 2
    local v10 = Kit.frame(v6, {
        Name = "Bar",
        ZIndex = 6,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(v9, 125),
        Size = UDim2.fromOffset(WIDTH, 40),
        BackgroundColor3 = Kit.DARK
    })

    Kit.corner(v10, 20)
    Kit.stroke(v10, 4)

    local v11 = Kit.frame(v10, {
        Name = "Mine",
        ZIndex = 7,
        Size = UDim2.fromScale(0.5, 1),
        BackgroundColor3 = GREEN
    })

    Kit.corner(v11, 20)
    Kit.shade(v11, 0.7)

    local v12 = Kit.frame(v10, {
        Name = "Theirs",
        ZIndex = 7,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.fromScale(1, 0),
        Size = UDim2.fromScale(0.5, 1),
        BackgroundColor3 = RED
    })

    Kit.corner(v12, 20)
    Kit.shade(v12, 0.7)

    local v13 = Kit.frame(v10, {
        Name = "Clash",
        ZIndex = 9,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(58, 58),
        BackgroundColor3 = v1
    })

    Kit.corner(v13, 29)
    Kit.stroke(v13, 4, GOLD)

    local v14 = Kit.frame(v13, {
        Rotation = 45,
        ZIndex = 10,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.5, 0.5),
        BackgroundColor3 = GOLD
    })

    Kit.corner(v14, 4)

    local function card(p6, p7, p8) -- line: 70
        -- upvalues: v6 (copy), Kit (copy), v1 (copy)
        local v15 = Kit.frame(v6, {
            ZIndex = 8,
            Name = p6,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(p7, 125),
            Size = UDim2.fromOffset(130, 130),
            BackgroundColor3 = p8
        })

        Kit.corner(v15, 65)
        Kit.stroke(v15, 5, v1)
        Kit.shade(v15, 0.6)

        return v15
    end

    local v16 = card("Player", 65, Color3.fromRGB(80, 170, 255))
    local t5 = {
        BackgroundTransparency = 1,
        ZIndex = 9,
        Size = UDim2.fromScale(1, 1),
        Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=150&h=150"):format(LocalPlayer.UserId)
    }
    local ImageLabel = Instance.new("ImageLabel")

    for v17, v18 in t5 do
        ImageLabel[v17] = v18
    end

    ImageLabel.Parent = v16
    Kit.corner(ImageLabel, 65)

    local v19 = card("Fish", WIDTH + 235, Color3.fromRGB(30, 70, 120))
    local t6 = {
        BackgroundTransparency = 1,
        ZIndex = 9,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.55),
        Size = UDim2.fromScale(0.9, 0.9),
        ImageColor3 = Color3.new(0, 0, 0)
    }
    local ViewportFrame = Instance.new("ViewportFrame")

    for v20, v21 in t6 do
        ViewportFrame[v20] = v21
    end

    ViewportFrame.Parent = v19
    self[p4] = {
        gui = p4,
        root = v6,
        bar = v10,
        mine = v11,
        theirs = v12,
        clash = v13,
        spark = v14,
        me = v16,
        fish = v19,
        view = ViewportFrame,
        mystery = Kit.text(v19, "?", {
            ZIndex = 10,
            StrokeThickness = 4,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.55, 0.55)
        }),
        warn = Kit.text(v19, "!", {
            Visible = false,
            ZIndex = 11,
            StrokeThickness = 4,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(1, -8, 0, 8),
            Size = UDim2.fromOffset(56, 66),
            TextColor3 = RED
        }),
        prompt = Kit.text(v6, "", {
            ZIndex = 9,
            StrokeThickness = 4,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromOffset(v9, 0),
            Size = UDim2.fromOffset(560, 50)
        }),
        combo = Kit.text(v6, "", {
            Visible = false,
            ZIndex = 9,
            StrokeThickness = 4,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromOffset(65, 56),
            Size = UDim2.fromOffset(170, 46),
            TextColor3 = GOLD
        }),
        hand = Kit.text(v6, "👆", {
            Visible = false,
            ZIndex = 12,
            StrokeThickness = 0,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromOffset(v9, 150),
            Size = UDim2.fromOffset(70, 70)
        })
    }
end

function t1.get(p9) -- line: 92
    -- upvalues: self (copy), build (copy)
    local v27 = self[p9]

    if not (v27 and v27.root.Parent) then
        build(p9)
    end

    return self[p9]
end

function t1.reset(p10, p11, p12, p13, p14) -- line: 102
    -- upvalues: AnimalModel (copy), Viewport (copy), t1 (copy), GREEN (copy), WIDTH (copy)
    local v28 = p14 or p12 and AnimalModel.clone(p12, 6, p13)

    if v28 then
        Viewport.show(p10.view, v28, 90, 1.05)
    end

    local view = p10.view

    if p14 then
        view.ImageColor3 = Color3.new(1, 1, 1)
    else
        view.ImageColor3 = Color3.new(0, 0, 0)
    end

    p10.mystery.Visible = p14 == nil
    t1.place(p10, p11)
    p10.combo.Visible = false
    p10.warn.Visible = false
    p10.fish.Rotation = 0
    p10.fish.Position = UDim2.fromOffset(WIDTH + 235, 125)
    p10.mine.BackgroundColor3 = GREEN
    p10.prompt.Text = ""
end

function t1.place(p15, p16, p17, p18) -- line: 119
    local v29 = 58 + (p17 or 0) * 14

    p15.mine.Size = UDim2.fromScale(p16, 1)
    p15.theirs.Size = UDim2.fromScale(1 - p16, 1)
    p15.clash.Position = UDim2.new(p16, 0, 0.5, math.sin((p18 or 0) * 40) * 1.5)
    p15.clash.Size = UDim2.fromOffset(v29, v29)
end

function t1.prompt(p19, p20, p21) -- line: 127
    -- upvalues: UIUtil (copy)
    if p19.prompt.Text == p20 then
        return
    end

    p19.prompt.Text = p20
    p19.prompt.TextColor3 = p21
    UIUtil.pop(p19.prompt, 1.3)
end

local function escapeInfo(p22) -- line: 136
    -- upvalues: Config (copy), v1 (copy)
    local EscapeInfo = p22:FindFirstChild("EscapeInfo")

    if not EscapeInfo then
        local t7 = {
            Name = "EscapeInfo",
            BackgroundTransparency = 1,
            RichText = true,
            TextScaled = true,
            Visible = false,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 1, 4),
            Size = UDim2.new(1, 0, 0, 54),
            FontFace = Config.Font,
            TextColor3 = v1
        }

        EscapeInfo = Instance.new("TextLabel")

        for v31, v32 in t7 do
            EscapeInfo[v31] = v32
        end

        EscapeInfo.Parent = p22

        local t8 = {
            Thickness = 3,
            Color = Color3.fromRGB(20, 20, 30)
        }
        local UIStroke = Instance.new("UIStroke")

        for v33, v34 in t8 do
            UIStroke[v33] = v34
        end

        UIStroke.Parent = EscapeInfo
    end

    return EscapeInfo
end

local function slam(p23) -- line: 156
    -- upvalues: UIUtil (copy)
    local UIStroke = p23:FindFirstChildOfClass("UIStroke")
    local Scale = p23:FindFirstChild("Scale")

    p23.TextTransparency = 0
    p23.Visible = true

    if UIStroke then
        UIStroke.Transparency = 0
    end

    if Scale then
        Scale.Scale = UIUtil.scale * 2.4
        UIUtil.tween(Scale, 0.35, {
            Scale = UIUtil.scale
        }, Enum.EasingStyle.Back)
    end
end

function t1.caught(p24, p25) -- line: 169
    -- upvalues: UIUtil (copy), escapeInfo (copy), slam (copy)
    local Hooked = p24:FindFirstChild("Hooked")

    if not Hooked then
        return
    end

    local UIStroke = Hooked:FindFirstChildOfClass("UIStroke")
    local v35 = escapeInfo(Hooked)

    if p25 then
        local UIGradient = Hooked:FindFirstChildOfClass("UIGradient")

        if UIGradient then
            UIGradient.Enabled = true
        end

        Hooked.TextColor3 = Hooked:GetAttribute("BaseColor") or Hooked.TextColor3
        Hooked.Text = "CAUGHT!"
        v35.Visible = false
        slam(Hooked)
    else
        UIUtil.tween(Hooked, 0.22, {
            TextTransparency = 1
        })
        UIUtil.tween(v35, 0.22, {
            TextTransparency = 1
        })

        if UIStroke then
            UIUtil.tween(UIStroke, 0.22, {
                Transparency = 1
            })
        end
    end
end

function t1.escaped(p26, p27, p28) -- line: 196
    -- upvalues: UIUtil (copy), RED (copy), escapeInfo (copy), slam (copy)
    local Hooked = p26:FindFirstChild("Hooked")

    if not Hooked then
        return
    end

    local UIGradient = Hooked:FindFirstChildOfClass("UIGradient")

    if UIGradient then
        UIGradient.Enabled = false
    end

    if Hooked:GetAttribute("BaseColor") == nil then
        Hooked:SetAttribute("BaseColor", Hooked.TextColor3)
    end

    Hooked.TextColor3 = RED
    Hooked.Text = p27
    slam(Hooked)

    local v36 = escapeInfo(Hooked)

    v36.Text = p28 and "Get a stronger rod!" or "Tap faster!"
    v36.TextTransparency = 0
    v36.Visible = false
    task.delay(0.3, function() -- line: 216
        -- upvalues: p27 (copy), Hooked (copy), v36 (copy), UIUtil (copy)
        if Hooked.Text == p27 then
            v36.Visible = true
            UIUtil.pop(v36, 0.3)
        end
    end)
end

function t1.hideCaught(p29) -- line: 225
    -- upvalues: escapeInfo (copy)
    local Hooked = p29:FindFirstChild("Hooked")

    if Hooked then
        Hooked.Visible = false
        escapeInfo(Hooked).Visible = false
    end
end

return t1
