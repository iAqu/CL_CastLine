-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local Format = require(ReplicatedStorage.Shared.Format)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.UIUtil)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local StarterPack = require(script.Parent.Parent.Shop.StarterPack)
local Style = require(script.Parent.Parent.Shop.Style)
local ArrowBeam = require(script.Parent.Parent.Tutorial.ArrowBeam)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1 = Color3.fromRGB(40, 170, 230)
local v2 = Color3.fromRGB(50, 90, 220)
local v3 = Color3.fromRGB(14, 14, 20)
local v4 = Color3.fromRGB(80, 215, 90)
local v5 = Color3.fromRGB(225, 65, 75)
local v6 = Color3.fromRGB(150, 75, 235)
local v7 = Color3.fromRGB(60, 140, 240)
local v8 = Color3.fromRGB(228, 228, 242)
local v9 = false
local v10 = false

local function myPlot() -- line: 39
    -- upvalues: Config (copy), LocalPlayer (copy)
    return Config.plotOf(LocalPlayer.UserId, Config.playerWorld(LocalPlayer))
end

local function boardSpot() -- line: 44
    -- upvalues: Config (copy), LocalPlayer (copy)
    local v11 = Config.plotOf(LocalPlayer.UserId, Config.playerWorld(LocalPlayer))
    local PenUpgrade = v11 and v11:FindFirstChild("PenUpgrade")
    local Board = PenUpgrade and PenUpgrade:FindFirstChild("Board")
    local Floor = v11 and v11:FindFirstChild("Floor")

    return if Board and Floor then Vector3.new(Board.Position.X, Floor.Position.Y + Floor.Size.Y / 2, Board.Position.Z - 2.5) else nil
end

local function pointAtBoard() -- line: 56
    -- upvalues: Config (copy), ArrowBeam (copy), LocalPlayer (copy), v10 (ref), boardSpot (copy)
    local Tutorial = LocalPlayer:GetAttribute("Tutorial")

    if v10 or Tutorial and Tutorial < Config.TutorialDone then
        return
    end

    v10 = true

    local PenLevel = LocalPlayer:GetAttribute("PenLevel")
    local elapsed = os.clock()

    ArrowBeam.show(function() -- line: 64
        -- upvalues: PenLevel (copy), elapsed (copy), ArrowBeam (copy), LocalPlayer (copy), boardSpot (copy)
        local v14 = boardSpot()
        local v15 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local v16 = v14 and v15 and (v15.Position - v14) * Vector3.new(1, 0, 1)

        if not (not v14 or v16 and v16.Magnitude <= 9) and not (os.clock() - elapsed > 40) and LocalPlayer:GetAttribute("PenLevel") == PenLevel then
            return v14
        end

        ArrowBeam.hide()

        return nil
    end)
end

local function caption(p1, p2, p3, p4, p5) -- line: 76
    -- upvalues: Kit (copy), v8 (copy)
    return Kit.text(p1, p2, {
        ZIndex = 2,
        StrokeThickness = 4,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, p3),
        Size = UDim2.new(1, -60, 0, p4),
        TextColor3 = p5 or v8
    })
end

local function show(p6) -- line: 88
    -- upvalues: Format (copy), Remotes (copy), UIUtil (copy), Kit (copy), StarterPack (copy), Style (copy), LocalPlayer (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v9 (ref), pointAtBoard (copy), caption (copy)
    v9 = true

    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "TankFull"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ScreenInsets = Enum.ScreenInsets.None
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 45

    local v17 = Kit.frame(ScreenGui, {
        Name = "Dim",
        BackgroundTransparency = 1,
        BackgroundColor3 = Color3.new(0, 0, 0),
        Size = UDim2.fromScale(1, 1)
    })

    UIUtil.tween(v17, 0.25, {
        BackgroundTransparency = 0.5
    })

    local v18 = Kit.frame(ScreenGui, {
        Name = "Holder",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(720, 0)
    })
    local UIScale = Instance.new("UIScale")

    UIScale.Name = "Scale"
    UIScale.Parent = v18

    local v19 = Kit.frame(v18, {
        Name = "Card",
        BackgroundColor3 = v3,
        Size = UDim2.fromScale(1, 1)
    })

    Kit.corner(v19, 28)
    Kit.stroke(v19, 7, Color3.fromRGB(42, 42, 54))

    local CanvasGroup = Instance.new("CanvasGroup")

    CanvasGroup.Name = "Clip"
    CanvasGroup.BackgroundTransparency = 1
    CanvasGroup.Size = UDim2.fromScale(1, 1)
    CanvasGroup.Parent = v19
    Kit.corner(CanvasGroup, 28)

    local v20 = Kit.frame(CanvasGroup, {
        Name = "Header",
        BackgroundColor3 = Color3.new(1, 1, 1),
        Size = UDim2.new(1, 0, 0, 110)
    })
    local UIGradient = Instance.new("UIGradient")

    UIGradient.Color = ColorSequence.new(v1, v2)
    UIGradient.Parent = v20
    Kit.text(v19, "Tank Full!", {
        Name = "Title",
        ZIndex = 2,
        StrokeThickness = 7,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0, 57),
        Size = UDim2.new(0.7, 0, 0, 78)
    })

    local v21 = false

    local function close(p7) -- line: 134
        -- upvalues: p6 (copy), ScreenGui (copy), v17 (copy), UIScale (copy), v21 (ref), UIUtil (copy), StarterPack (copy), v9 (ref), pointAtBoard (copy)
        if v21 then
            return
        end

        v21 = true
        UIUtil.tween(UIScale, 0.16, {
            Scale = UIScale.Scale * 0.7
        }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        UIUtil.tween(v17, 0.18, {
            BackgroundTransparency = 1
        })
        task.delay(0.18, function() -- line: 141
            -- upvalues: ScreenGui (copy), v9 (ref)
            ScreenGui:Destroy()
            v9 = false
        end)

        if not p7 and p6.NextPrice then
            pointAtBoard()
            StarterPack.need()
        end
    end

    Kit.button(v19, "X", Color3.fromRGB(225, 70, 70), {
        Name = "Close",
        ZIndex = 4,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(1, -8, 0, 8),
        Size = UDim2.fromOffset(60, 60)
    }, function() -- line: 156
        -- upvalues: close (copy)
        close(false)
    end).Label.ZIndex = 5
    caption(v19, ("%*/%* animals! No room for your %*"):format(p6.Capacity, p6.Capacity, p6.Name), 128, 44)

    local v22 = 128 + 66

    if p6.NextPrice then
        caption(v19, ("Upgrade your tank: room for %* animals"):format(p6.NextCapacity), v22, 36, Color3.fromRGB(150, 225, 255))

        local v23 = v22 + 50
        local v24 = (LocalPlayer:GetAttribute("Money") or 0) >= p6.NextPrice

        Kit.button(v19, ("Upgrade %*"):format((Format.money(p6.NextPrice))), if v24 then v4 else v5, {
            Name = "Upgrade",
            ZIndex = 3,
            Position = UDim2.fromOffset(40, v23),
            Size = UDim2.fromOffset(404, 96)
        }, function() -- line: 174
            -- upvalues: close (copy), Remotes (copy)
            close(true)
            Remotes.UpgradePen:FireServer()
        end).Label.ZIndex = 4
        Style.price(v19, "NextPen", {
            Name = "Robux",
            BackgroundColor3 = v6,
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -40, 0, v23),
            Size = UDim2.fromOffset(216, 96)
        })
        v19.Robux.Activated:Connect(function() -- line: 187
            -- upvalues: close (copy)
            close(true)
        end)
        v22 = v23 + 118
    end

    local Swap = p6.Swap

    if Swap then
        caption(v19, ("Or swap out your %* for +%*/s"):format(Swap.Name, (Format.money(Swap.To - Swap.From))), v22, 36)

        local v25 = v22 + 50

        Kit.button(v19, ("Swap in %*"):format(p6.Name), v7, {
            Name = "Swap",
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, v25),
            Size = UDim2.fromOffset(640, 88)
        }, function() -- line: 203
            -- upvalues: close (copy), Swap (copy), Remotes (copy)
            close(true)
            Remotes.SwapAnimal:FireServer(Swap.Uid)
        end).Label.ZIndex = 4
        v22 = v25 + 108
    end

    if not (p6.NextPrice or Swap) then
        caption(v19, "Your tank is maxed out! Sell an animal or pick one up to make room.", v22, 80)
        v22 += 100
    end

    v18.Size = UDim2.fromOffset(720, v22 + 12)
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    UIUtil.pop(v18, 0.6)
    UIUtil.sound("Reveal", 0.5, 0.9)
end

function t1.isShowing() -- line: 222
    -- upvalues: v9 (ref)
    return v9
end

function t1.init() -- line: 226
    -- upvalues: Remotes (copy), v9 (ref), show (copy)
    Remotes.TankFull.OnClientEvent:Connect(function(p8) -- line: 227
        -- upvalues: v9 (ref), show (copy)
        if not v9 and type(p8) == "table" and type(p8.Capacity) == "number" then
            show(p8)
        end
    end)
end

return t1
