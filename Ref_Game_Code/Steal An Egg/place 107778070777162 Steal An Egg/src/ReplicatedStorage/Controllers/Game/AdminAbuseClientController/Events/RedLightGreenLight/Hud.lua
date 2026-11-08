-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Giant = require(script.Parent.Giant)
local v1 = UDim2.fromScale(0.5, 0.085)
local v2 = UDim2.fromScale(0.5, -0.45)
local v3 = Color3.fromRGB(80, 255, 120)
local v4 = Color3.fromRGB(255, 60, 70)
local v5 = Color3.fromRGB(255, 214, 89)
local v6 = Color3.fromRGB(255, 60, 80)
local v7 = Color3.fromRGB(70, 70, 82)
local t1 = {
    Green = {
        Title = "GREEN LIGHT!",
        State = "TURNED AWAY",
        Vignette = 0.55,
        Color = v3
    },
    Red = {
        Title = "RED LIGHT!",
        State = "WATCHING",
        Vignette = 0.12,
        Color = v4
    },
    Rise = {
        Title = "RED LIGHT, GREEN LIGHT",
        State = "GET READY",
        Vignette = 1,
        Color = v5
    },
    Wait = {
        Title = "RED LIGHT, GREEN LIGHT",
        State = "STARTS AT SUNRISE",
        Vignette = 1,
        Color = v5
    }
}
local t2 = {}

local function tween(p1, p2, p3, p4) -- line: 86
    -- upvalues: TweenService (copy)
    local tween = TweenService:Create(p1, TweenInfo.new(p2, p4 or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), p3)

    tween:Play()

    return tween
end

local function cloneGui(p5) -- line: 103
    -- upvalues: Players (copy)
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local v8 = PlayerGui:FindFirstChild(p5)

    if v8 ~= nil and v8:IsA("ScreenGui") then
        return v8
    end

    local v9 = game:GetService("StarterGui"):FindFirstChild(p5)

    if v9 == nil or not v9:IsA("ScreenGui") then
        warn((("[RedLightGreenLight] StarterGui.%* is missing"):format(p5)))

        return nil
    end

    local clone = v9:Clone()

    clone.Parent = PlayerGui

    return clone
end

local function buildViewportRig(p6, p7) -- line: 125
    p7.Archivable = true

    local clone = p7:Clone()
    local v10 = clone:FindFirstChild("HumanoidRootPart", true)
    local Head = clone:FindFirstChild("Head")

    if v10 == nil or not v10:IsA("BasePart") or Head == nil or not Head:IsA("BasePart") then
        clone:Destroy()

        return
    end

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = descendant == v10
            descendant.Massless = descendant ~= v10
        elseif descendant:IsA("Script") then
            descendant:Destroy()
        elseif descendant:IsA("LocalScript") then
            descendant:Destroy()
        elseif descendant:IsA("Animator") then
            descendant:Destroy()
        end
    end

    local Humanoid = clone:FindFirstChildOfClass("Humanoid")

    if Humanoid ~= nil then
        Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        Humanoid.PlatformStand = true
    end

    clone.PrimaryPart = v10
    clone:PivotTo(CFrame.new())

    local WorldModel = p6.Viewport:FindFirstChildOfClass("WorldModel")

    if WorldModel == nil then
        WorldModel = Instance.new("WorldModel")
        WorldModel.Parent = p6.Viewport
    end

    clone.Parent = WorldModel

    local v11 = p6.Viewport.CurrentCamera or Instance.new("Camera")
    local v13 = Head.Position - Vector3.new(0, Head.Size.Y * 0.55, 0)
    local v14 = Head.Size.Y * 3.6

    v11.FieldOfView = 38
    v11.CFrame = CFrame.lookAt(v13 + Vector3.new(0, Head.Size.Y * 0.25, -v14), v13)
    v11.Parent = p6.Viewport
    p6.Viewport.CurrentCamera = v11

    local Neck = Head:FindFirstChild("Neck")

    p6.Rig = clone
    p6.RigRoot = v10
    p6.RigNeck = if Neck == nil or not Neck:IsA("Motor6D") then nil else Neck
end

local function rebuildHearts(p8, p9) -- line: 185
    for _, v17 in p8.HeartLabels do
        v17:Destroy()
    end

    table.clear(p8.HeartLabels)

    for i = 1, p9 do
        local clone = p8.HeartTemplate:Clone()

        clone.Name = ("Heart%*"):format(i)
        clone.Visible = true
        clone.LayoutOrder = i
        clone.Parent = p8.Hearts
        table.insert(p8.HeartLabels, clone)
    end
end

function t2.Mount(p10) -- line: 207
    -- upvalues: v2 (copy), cloneGui (copy), buildViewportRig (copy)
    local RedLightGreenLightUI = cloneGui("RedLightGreenLightUI")
    local RedLightGreenLightOverlay = cloneGui("RedLightGreenLightOverlay")
    local RedLightGreenLightCinematic = cloneGui("RedLightGreenLightCinematic")

    if RedLightGreenLightUI == nil or RedLightGreenLightOverlay == nil or RedLightGreenLightCinematic == nil then
        return nil
    end

    local Board = RedLightGreenLightUI:FindFirstChild("Board")
    local Portrait = Board:FindFirstChild("Portrait")
    local Hearts = Board:FindFirstChild("Hearts")
    local Heart = Hearts:FindFirstChild("Heart")

    Heart.Visible = false

    local t3 = {
        Rig = nil,
        RigRoot = nil,
        RigNeck = nil,
        Light = "Rise",
        Lives = 0,
        Clock = 0,
        Shown = false,
        Gui = RedLightGreenLightUI,
        Overlay = RedLightGreenLightOverlay,
        Cinematic = RedLightGreenLightCinematic,
        Board = Board,
        Title = Board:FindFirstChild("Title"),
        Subtitle = Board:FindFirstChild("Subtitle"),
        Portrait = Portrait,
        PortraitStroke = Portrait:FindFirstChildOfClass("UIStroke"),
        State = Board:FindFirstChild("State"),
        Hearts = Hearts,
        HeartTemplate = Heart,
        HeartLabels = {},
        Viewport = Portrait:FindFirstChild("Viewport"),
        Vignette = RedLightGreenLightOverlay:FindFirstChild("Vignette"),
        Top = RedLightGreenLightCinematic:FindFirstChild("Top"),
        Bottom = RedLightGreenLightCinematic:FindFirstChild("Bottom"),
        Cover = RedLightGreenLightCinematic:FindFirstChild("Cover")
    }

    if p10 ~= nil then
        buildViewportRig(t3, p10)
    end

    Board.Position = v2
    t3.Vignette.ImageTransparency = 1
    t3.Cover.BackgroundTransparency = 1
    t3.Top.Position = UDim2.fromScale(0, -0.11)
    t3.Bottom.Position = UDim2.fromScale(0, 1)
    RedLightGreenLightUI.Enabled = true
    RedLightGreenLightOverlay.Enabled = true
    RedLightGreenLightCinematic.Enabled = true

    return t3
end

function t2.SetBoardShown(p11, p12) -- line: 266
    -- upvalues: TweenService (copy), v1 (copy), v2 (copy)
    if p11.Shown == p12 then
        return
    end

    p11.Shown = p12

    local v18 = if p12 then v1 else v2
    local Board = p11.Board
    local v19 = if p12 then 0.45 else 0.25
    local t4 = {
        Position = v18
    }
    local v20 = if p12 then Enum.EasingStyle.Back else Enum.EasingStyle.Quad

    TweenService:Create(Board, TweenInfo.new(v19, v20 or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), t4):Play()
end

function t2.SetLight(p13, p14) -- line: 283
    -- upvalues: GuiService (copy), TweenService (copy), t1 (copy)
    local v21 = t1[p14] or t1.Rise

    p13.Light = p14
    p13.Title.Text = v21.Title
    p13.State.Text = v21.State

    local Title = p13.Title
    local t5 = {
        TextColor3 = v21.Color
    }

    TweenService:Create(Title, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), t5):Play()

    if p13.PortraitStroke ~= nil then
        local PortraitStroke = p13.PortraitStroke
        local t6 = {
            Color = v21.Color
        }

        TweenService:Create(PortraitStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), t6):Play()
    end

    local Vignette = p13.Vignette
    local t7 = {
        ImageColor3 = v21.Color,
        ImageTransparency = v21.Vignette
    }

    TweenService:Create(Vignette, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), t7):Play()

    local UIScale = p13.Title:FindFirstChildOfClass("UIScale")

    if UIScale == nil or GuiService.ReducedMotionEnabled then
        return
    end

    UIScale.Scale = 1.25

    local t8 = {
        Scale = 1
    }
    local Back = Enum.EasingStyle.Back

    TweenService:Create(UIScale, TweenInfo.new(0.35, Back or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), t8):Play()
end

function t2.SetLives(p15, p16, p17) -- line: 305
    -- upvalues: GuiService (copy), TweenService (copy), v6 (copy), v7 (copy), rebuildHearts (copy)
    if #p15.HeartLabels ~= p17 then
        rebuildHearts(p15, p17)
    end

    local v23 = p16 < p15.Lives

    p15.Lives = p16

    for v24, v25 in p15.HeartLabels do
        local v26 = v24 <= p16

        if v26 then
            v25.ImageColor3 = v6
        else
            v25.ImageColor3 = v7
        end

        v25.ImageTransparency = v26 and 0 or 0.25

        local UIScale = v25:FindFirstChildOfClass("UIScale")

        if v23 and v24 == p16 + 1 and UIScale ~= nil and not GuiService.ReducedMotionEnabled then
            UIScale.Scale = 1.6
            v25.Rotation = 18

            local t9 = {
                Scale = 1
            }
            local Back = Enum.EasingStyle.Back

            TweenService:Create(UIScale, TweenInfo.new(0.5, Back or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), t9):Play()

            local t10 = {
                Rotation = 0
            }
            local Elastic = Enum.EasingStyle.Elastic

            TweenService:Create(v25, TweenInfo.new(0.5, Elastic or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), t10):Play()
        end
    end
end

function t2.Letterbox(p18, p19) -- line: 331
    -- upvalues: TweenService (copy)
    local Top = p18.Top
    local t11 = {
        Position = if p19 then UDim2.fromScale(0, 0) else UDim2.fromScale(0, -0.11)
    }

    TweenService:Create(Top, TweenInfo.new(0.9, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), t11):Play()

    local Bottom = p18.Bottom
    local t12 = {
        Position = if p19 then UDim2.fromScale(0, 0.89) else UDim2.fromScale(0, 1)
    }

    TweenService:Create(Bottom, TweenInfo.new(0.9, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), t12):Play()
end

function t2.Cover(p20, p21) -- line: 342
    -- upvalues: TweenService (copy)
    local Cover = p20.Cover
    local t13 = {
        BackgroundTransparency = 0
    }
    local Quad = Enum.EasingStyle.Quad

    TweenService:Create(Cover, TweenInfo.new(p21, Quad or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), t13):Play()
    task.delay(p21 + 0.35, function() -- line: 345
        -- upvalues: p20 (copy), TweenService (copy)
        if p20.Cover.Parent == nil then
            return
        end

        local Cover = p20.Cover
        local t14 = {
            BackgroundTransparency = 1
        }
        local Quad = Enum.EasingStyle.Quad

        TweenService:Create(Cover, TweenInfo.new(0.6, Quad or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), t14):Play()
    end)
end

function t2.Update(p22, p23, p24) -- line: 352
    -- upvalues: GuiService (copy), Giant (copy)
    p22.Clock += p23

    if p22.Light == "Red" and not GuiService.ReducedMotionEnabled then
        local v29 = (math.sin(p22.Clock * 3.141592653589793 * 2 * 1.4) + 1) * 0.5

        p22.Vignette.ImageTransparency = v29 * 0.2 + 0.04
    end

    local RigRoot = p22.RigRoot

    if p24 == nil or RigRoot == nil then
        return
    end

    RigRoot.CFrame = CFrame.Angles(0, Giant.BodyYaw(p24), 0)

    local RigNeck = p22.RigNeck

    if RigNeck ~= nil then
        RigNeck.Transform = CFrame.Angles(0, Giant.HeadYaw(p24) - Giant.BodyYaw(p24), 0)
    end
end

function t2.Unmount(p25) -- line: 376
    -- upvalues: TweenService (copy), t2 (copy)
    t2.SetBoardShown(p25, false)

    local Vignette = p25.Vignette
    local t15 = {
        ImageTransparency = 1
    }

    TweenService:Create(Vignette, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), t15):Play()
    t2.Letterbox(p25, false)
    task.delay(0.6, function() -- line: 381
        -- upvalues: p25 (copy)
        p25.Gui:Destroy()
        p25.Overlay:Destroy()
        p25.Cinematic:Destroy()
    end)
end

return t2
