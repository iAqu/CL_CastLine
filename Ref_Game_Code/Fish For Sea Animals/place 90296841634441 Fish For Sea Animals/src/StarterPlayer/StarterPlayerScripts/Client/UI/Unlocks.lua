-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local Format = require(ReplicatedStorage.Shared.Format)
local RodBuilder = require(ReplicatedStorage.Shared.RodBuilder)
local UIUtil = require(script.Parent.UIUtil)
local Viewport = require(script.Parent.Viewport)
local RodShop = require(script.Parent.RodShop)
local Menus = require(script.Parent.Menus)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1 = Color3.fromRGB(22, 22, 30)
local v2 = Color3.fromRGB(32, 36, 58)
local v3 = Color3.fromRGB(110, 225, 60)
local v4 = Color3.fromRGB(255, 220, 80)
local Frame
local n1 = 0
local t2 = {}
local t3 = {}

local function v5() -- line: 38
    return false
end

local function myPlot() -- line: 43
    -- upvalues: Config (copy), LocalPlayer (copy)
    return Config.plotOf(LocalPlayer.UserId, Config.playerWorld(LocalPlayer))
end

local function teleport(p1, p2) -- line: 48
    -- upvalues: Config (copy), LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local v6, v7

    if Character then
        v6 = Character:FindFirstChildOfClass("Humanoid")
        v7 = Character:FindFirstChild("HumanoidRootPart")
    else
        v7 = Character
        v6 = Character
    end

    local v8 = Config.plotOf(LocalPlayer.UserId, Config.playerWorld(LocalPlayer))
    local Floor = v8 and v8:FindFirstChild("Floor")

    if not (v6 and v7 and Floor) then
        return
    end

    local v9 = Floor.Position.Y + Floor.Size.Y / 2 + v6.HipHeight + v7.Size.Y / 2
    local v10 = Vector3.new(p1.X, v9, p1.Z)

    v7.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

    local v11 = CFrame.lookAt(v10, (Vector3.new(p2.X, v9, p2.Z)))

    Character:PivotTo(v11)
    workspace.CurrentCamera.CFrame = CFrame.lookAt(v10 - v11.LookVector * 14 + Vector3.new(0, 6, 0), v10 + v11.LookVector * 4)
end

local function ownedRods() -- line: 67
    -- upvalues: LocalPlayer (copy)
    local n2 = 1

    for match in string.gmatch(LocalPlayer:GetAttribute("RodsOwned") or "1", "%d+") do
        n2 = math.max(n2, tonumber(match) or 1)
    end

    return n2
end

local t4 = {
    Rod = function() -- Rod | line: 77
        -- upvalues: Config (copy), RodBuilder (copy), Viewport (copy), RodShop (copy), Menus (copy), LocalPlayer (copy), teleport (copy), ownedRods (copy)
        local v13 = ownedRods() + 1
        local v14 = Config.Rods[v13]

        return if v14 then {
            button = "BUY",
            level = v13,
            price = Config.rodPrice(v13, LocalPlayer:GetAttribute("LegacyPrices") == true),
            name = v14.Name,
            color = Config.RarityByName[v14.Rarity].Color,
            picture = function(p3) -- picture | line: 89
                -- upvalues: v13 (copy), RodBuilder (copy), Viewport (copy)
                local v15 = RodBuilder.build(v13)

                v15:PivotTo(CFrame.Angles(0.7853981633974483, 0, 0))
                Viewport.show(p3, v15, 90, 0.45)
            end,
            go = function() -- go | line: 94
                -- upvalues: Config (copy), RodShop (copy), Menus (copy), LocalPlayer (copy), teleport (copy)
                local v16 = Config.plotOf(LocalPlayer.UserId, Config.playerWorld(LocalPlayer))
                local RodStand = v16 and v16:FindFirstChild("RodStand")
                local v17 = RodStand and RodStand:FindFirstChild("Inner", true)

                if v17 then
                    teleport(v17.Position, RodStand:GetPivot().Position)
                end

                Menus.closeAll()
                RodShop.open()
            end
        } else nil
    end,
    Barbell = function() -- Barbell | line: 106
        -- upvalues: ReplicatedStorage (copy), Config (copy), Viewport (copy), LocalPlayer (copy), teleport (copy)
        local v18 = (LocalPlayer:GetAttribute("BarbellTier") or 1) + 1
        local v19 = Config.Barbells[v18]

        return if v19 then {
            button = "UPGRADE",
            level = v18,
            price = Config.barbellPrice(v18, LocalPlayer:GetAttribute("LegacyPrices") == true),
            name = ("Barbell Tier %*"):format(v18),
            color = Color3.fromRGB(235, 80, 70),
            picture = function(p4) -- picture | line: 118
                -- upvalues: v19 (copy), ReplicatedStorage (copy), Viewport (copy)
                local v20 = ReplicatedStorage.Assets.Barbells:FindFirstChild(v19.Model)

                if not v20 then
                    return
                end

                local clone = v20:Clone()

                clone:PivotTo(CFrame.new())
                Viewport.show(p4, clone, 20, 0.8)
            end,
            go = function() -- go | line: 126
                -- upvalues: Config (copy), LocalPlayer (copy), teleport (copy)
                local v21 = Config.plotOf(LocalPlayer.UserId, Config.playerWorld(LocalPlayer))
                local BarbellUpgrade = v21 and v21:FindFirstChild("BarbellUpgrade")
                local Button = BarbellUpgrade and BarbellUpgrade:FindFirstChild("Button")
                local LiftZone = v21 and v21:FindFirstChild("LiftZone")
                local Center = LiftZone and LiftZone:FindFirstChild("Center")

                if not Button then
                    return
                end

                local v22 = if Center then Button.Position - Center.Position else Vector3.new(0, 0, -1)
                local v23 = Vector3.new(v22.X, 0, v22.Z)
                local v24 = if v23.Magnitude > 0 then v23.Unit else Vector3.new(0, 0, -1)

                teleport(Button.Position + v24 * ((Button:GetAttribute("Radius") or 3.4) + 3.5), Button.Position)
            end
        } else nil
    end
}
local t7 = {
    "Rod",
    "Barbell"
}

local function stroke(p5, p6) -- line: 145
    -- upvalues: v1 (copy)
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = p6
    UIStroke.Color = v1
    UIStroke.LineJoinMode = Enum.LineJoinMode.Round

    if p5:IsA("TextLabel") or p5:IsA("TextButton") then
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    else
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    end

    UIStroke.Parent = p5

    return UIStroke
end

local function corner(p7, p8) -- line: 155
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0, p8)
    UICorner.Parent = p7
end

local function text(p9, p10, p11) -- line: 161
    -- upvalues: Config (copy), stroke (copy)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.FontFace = Config.Font
    TextLabel.TextScaled = true
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Text = p10

    for v25, v26 in p11 do
        TextLabel[v25] = v26
    end

    stroke(TextLabel, 3)
    TextLabel.Parent = p9

    return TextLabel
end

local function remove(p12) -- line: 177
    -- upvalues: UIUtil (copy), t2 (copy)
    local v27 = t2[p12]

    if not v27 then
        return
    end

    t2[p12] = nil

    local frame = v27.frame

    UIUtil.tween(frame.Body, 0.25, {
        Position = UDim2.fromScale(0, -2.5)
    }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    task.delay(0.25, function() -- line: 185
        -- upvalues: frame (copy)
        frame:Destroy()
    end)
end

local function build(p13, p14) -- line: 190
    -- upvalues: Config (copy), Format (copy), UIUtil (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), Frame (ref), n1 (ref), v5 (ref), stroke (copy), text (copy), remove (copy)
    local Frame2 = Instance.new("Frame")

    Frame2.Name = p13
    Frame2.BackgroundTransparency = 1
    Frame2.Size = UDim2.fromOffset(300, 92)
    n1 += 1
    Frame2.LayoutOrder = n1

    local Frame3 = Instance.new("Frame")

    Frame3.Name = "Body"
    Frame3.BackgroundColor3 = v2
    Frame3.Size = UDim2.fromScale(1, 1)
    Frame3.Position = UDim2.fromScale(0, -2.5)
    Frame3.ClipsDescendants = false

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0, 16)
    UICorner.Parent = Frame3
    stroke(Frame3, 4)

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Studs"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.Image = Config.Icons.Studs
    ImageLabel.ImageTransparency = 0.25
    ImageLabel.ScaleType = Enum.ScaleType.Tile
    ImageLabel.TileSize = UDim2.fromOffset(256, 256)
    ImageLabel.Interactable = false

    local UICorner2 = Instance.new("UICorner")

    UICorner2.CornerRadius = UDim.new(0, 16)
    UICorner2.Parent = ImageLabel
    ImageLabel.Parent = Frame3

    local Frame4 = Instance.new("Frame")

    Frame4.Name = "Picture"
    Frame4.BackgroundColor3 = p14.color
    Frame4.Position = UDim2.fromOffset(9, 9)
    Frame4.Size = UDim2.fromOffset(74, 74)

    local UICorner3 = Instance.new("UICorner")

    UICorner3.CornerRadius = UDim.new(0, 12)
    UICorner3.Parent = Frame4
    stroke(Frame4, 3)

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 90
    UIGradient.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(150, 150, 150))
    UIGradient.Parent = Frame4

    if p14.picture then
        local ViewportFrame = Instance.new("ViewportFrame")

        ViewportFrame.BackgroundTransparency = 1
        ViewportFrame.Size = UDim2.fromScale(1, 1)
        ViewportFrame.Ambient = Color3.fromRGB(200, 200, 200)
        ViewportFrame.LightDirection = Vector3.new(-1, -1, -0.5)
        ViewportFrame.Parent = Frame4
        p14.picture(ViewportFrame)
    else
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.BackgroundTransparency = 1
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
        ImageLabel.Size = UDim2.fromScale(0.75, 0.75)
        ImageLabel.Image = p14.image
        ImageLabel.ScaleType = Enum.ScaleType.Fit
        ImageLabel.Parent = Frame4
    end

    Frame4.Parent = Frame3
    text(Frame3, "UNLOCKED!", {
        Name = "Title",
        Position = UDim2.fromOffset(94, 6),
        Size = UDim2.fromOffset(150, 22),
        TextColor3 = v4
    })
    text(Frame3, p14.name, {
        Name = "ItemName",
        Position = UDim2.fromOffset(94, 29),
        Size = UDim2.fromOffset(194, 20)
    })

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "Go"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BackgroundColor3 = v3
    TextButton.Position = UDim2.fromOffset(94, 53)
    TextButton.Size = UDim2.fromOffset(196, 31)

    local UICorner4 = Instance.new("UICorner")

    UICorner4.CornerRadius = UDim.new(0, 10)
    UICorner4.Parent = TextButton
    stroke(TextButton, 3)

    local clone = UIGradient:Clone()

    clone.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(190, 190, 190))
    clone.Parent = TextButton
    text(TextButton, ("%*  %*"):format(p14.button, (Format.money(p14.price))), {
        Name = "Label",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.52),
        Size = UDim2.fromScale(0.86, 0.66),
        TextXAlignment = Enum.TextXAlignment.Center
    })
    TextButton.Parent = Frame3
    UIUtil.bindButton(TextButton, function() -- line: 273
        -- upvalues: p13 (copy), p14 (copy), v5 (ref), remove (copy)
        if not v5() then
            remove(p13)
            p14.go()
        end
    end)

    local TextButton2 = Instance.new("TextButton")

    TextButton2.Name = "Close"
    TextButton2.Text = ""
    TextButton2.AutoButtonColor = false
    TextButton2.BackgroundColor3 = Color3.fromRGB(225, 70, 70)
    TextButton2.AnchorPoint = Vector2.new(0.5, 0.5)
    TextButton2.Position = UDim2.new(1, -18, 0, 18)
    TextButton2.Size = UDim2.fromOffset(24, 24)
    TextButton2.ZIndex = 3

    local UICorner5 = Instance.new("UICorner")

    UICorner5.CornerRadius = UDim.new(0, 15)
    UICorner5.Parent = TextButton2
    stroke(TextButton2, 3)
    text(TextButton2, "X", {
        ZIndex = 3,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.6, 0.6),
        TextXAlignment = Enum.TextXAlignment.Center
    })
    TextButton2.Parent = Frame3
    UIUtil.bindButton(TextButton2, function() -- line: 300
        -- upvalues: p13 (copy), remove (copy)
        remove(p13)
    end)

    local Frame5 = Instance.new("Frame")

    Frame5.Name = "Glint"
    Frame5.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame5.BackgroundTransparency = 0.55
    Frame5.BorderSizePixel = 0
    Frame5.Rotation = 20
    Frame5.Position = UDim2.new(0, -60, 0, -20)
    Frame5.Size = UDim2.new(0, 26, 1, 40)
    Frame5.Interactable = false
    Frame5.ZIndex = 2
    Frame3.ClipsDescendants = true
    Frame5.Parent = Frame3

    local Frame6 = Instance.new("Frame")

    Frame6.Name = "Timer"
    Frame6.BackgroundColor3 = v1
    Frame6.BackgroundTransparency = 0.3
    Frame6.BorderSizePixel = 0
    Frame6.AnchorPoint = Vector2.new(0.5, 1)
    Frame6.Position = UDim2.new(0.5, 0, 1, -3)
    Frame6.Size = UDim2.new(1, -24, 0, 4)
    Frame6.ZIndex = 2

    local UICorner6 = Instance.new("UICorner")

    UICorner6.CornerRadius = UDim.new(0, 4)
    UICorner6.Parent = Frame6
    Frame6.Parent = Frame3

    local Frame7 = Instance.new("Frame")

    Frame7.Name = "Fill"
    Frame7.BackgroundColor3 = v4
    Frame7.BorderSizePixel = 0
    Frame7.Size = UDim2.fromScale(1, 1)
    Frame7.ZIndex = 2

    local UICorner7 = Instance.new("UICorner")

    UICorner7.CornerRadius = UDim.new(0, 4)
    UICorner7.Parent = Frame7
    Frame7.Parent = Frame6
    Frame3.Parent = Frame2
    Frame2.Parent = Frame
    UIUtil.tween(Frame3, 0.35, {
        Position = UDim2.fromScale(0, 0)
    }, Enum.EasingStyle.Back)
    task.delay(0.35, function() -- line: 342
        -- upvalues: Frame5 (copy), UIUtil (copy)
        UIUtil.tween(Frame5, 0.5, {
            Position = UDim2.new(1, 40, 0, -20)
        }, Enum.EasingStyle.Sine)
        task.wait(0.5)
        Frame5:Destroy()
    end)
    UIUtil.sound("GoodCast", 0.4, 1.1)

    return Frame2
end

local function canShow() -- line: 351
    -- upvalues: UIUtil (copy), v5 (ref)
    return not v5() and not UIUtil.panelMode()
end

local function check() -- line: 356
    -- upvalues: UIUtil (copy), LocalPlayer (copy), t2 (copy), t3 (copy), v5 (ref), t4 (copy), t7 (copy), remove (copy), build (copy)
    local v28 = LocalPlayer:GetAttribute("Money") or 0

    for _, v29 in t7 do
        local v30 = t4[v29]()
        local v31 = t2[v29]

        if v31 and (not v30 or v30.level ~= v31.level or v28 < v30.price) then
            remove(v29)
        end

        if v30 and v30.price <= v28 and t3[v29] ~= v30.level and not v5() and not UIUtil.panelMode() then
            local n3 = 0

            for _ in t2 do
                n3 += 1
            end

            if n3 < 1 then
                t3[v29] = v30.level
                t2[v29] = {
                    shownFor = 0,
                    frame = build(v29, v30),
                    level = v30.level
                }
            end
        end
    end
end

function t1.setBusyCheck(p15) -- line: 378
    -- upvalues: v5 (ref)
    v5 = p15
end

function t1.init() -- line: 382
    -- upvalues: ContentProvider (copy), ReplicatedStorage (copy), UIUtil (copy), LocalPlayer (copy), Frame (ref), t2 (copy), v5 (ref), remove (copy), check (copy)
    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "Unlocks"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 5

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Cards"
    Frame2.BackgroundTransparency = 1
    Frame2.AnchorPoint = Vector2.new(0.5, 0)
    Frame2.Position = UDim2.new(0.5, 0, 0, 112)
    Frame2.Size = UDim2.fromOffset(420, 140)

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "Scale"
    UIScale.Parent = Frame2
    Frame = Instance.new("Frame")
    Frame.Name = "Stack"
    Frame.BackgroundTransparency = 1
    Frame.AnchorPoint = Vector2.new(0.5, 0)
    Frame.Position = UDim2.fromScale(0.5, 0)
    Frame.Size = UDim2.fromOffset(300, 100)

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.Parent = Frame

    local UIScale2 = Instance.new("UIScale")

    UIScale2.Name = "Zoom"
    UIScale2.Scale = 1.4
    UIScale2.Parent = Frame
    Frame.Parent = Frame2
    Frame2.Parent = ScreenGui
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    UIUtil.onScale(function(p16) -- line: 417
        -- upvalues: Frame2 (copy)
        Frame2.Position = UDim2.new(0.5, 0, 0, (math.round(112 * p16)))
    end)
    task.spawn(function() -- line: 421
        -- upvalues: ContentProvider (copy), ReplicatedStorage (copy)
        local PreloadAsync = ContentProvider.PreloadAsync
        local t8 = {
            ReplicatedStorage.Assets.Barbells
        }

        pcall(PreloadAsync, ContentProvider, t8)
    end)

    for _, v33 in { "Money", "RodsOwned", "BarbellTier" } do
        LocalPlayer:GetAttributeChangedSignal(v33):Connect(check)
    end

    task.spawn(function() -- line: 429
        -- upvalues: UIUtil (copy), Frame (ref), t2 (copy), v5 (ref), remove (copy), check (copy)
        while true do
            local v34 = not v5() and not UIUtil.panelMode()

            Frame.Visible = v34

            if v34 then
                for v35, v36 in t2 do
                    v36.shownFor += 0.25

                    if v36.shownFor >= 12 then
                        remove(v35)
                    else
                        local v37 = v36.frame:FindFirstChild("Fill", true)

                        if v37 then
                            UIUtil.tween(v37, 0.25, {
                                Size = UDim2.fromScale(1 - v36.shownFor / 12, 1)
                            }, Enum.EasingStyle.Linear)
                        end
                    end
                end
            end

            check()
            task.wait(0.25)
        end
    end)
end

return t1
