-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local MountRaceFlags = require(ReplicatedStorage.Shared.Flags.MountRaceFlags)
local InputIconsConfig = require(ReplicatedStorage.Client.InputIconsConfig)

require(script.Parent.MountController)
require(ReplicatedStorage.Data.MountRace)

local PowerUpVisuals = require(script.Parent.PowerUpVisuals)

require(script.Parent.RaceCamera)

local RacePowerUps = require(ReplicatedStorage.Data.RacePowerUps)

require(ReplicatedStorage.Shared.Modules.RaceTrackPath)

local Remotes = require(ReplicatedStorage.Shared.Remotes)

require(ReplicatedStorage.Packages.Trove)

local LocalPlayer = Players.LocalPlayer
local Attributes, Tuning, Items = RacePowerUps.Attributes, RacePowerUps.Tuning, RacePowerUps.Items
local v1 = UDim2.fromScale(0.5, 0.4)
local v2 = UDim2.fromScale(0.915, 0.6)
local v3 = Vector2.new(0.86, 0.16)
local v4 = Color3.fromRGB(120, 120, 135)
local t1 = {
    Spike = {
        "BONK!",
        Color3.fromRGB(255, 170, 70)
    },
    Pod = {
        "KABOOM!",
        Color3.fromRGB(255, 80, 70)
    },
    Drilla = {
        "AMBUSHED!",
        Color3.fromRGB(255, 205, 70)
    },
    Egg = {
        "SPLAT!",
        Color3.fromRGB(255, 225, 60)
    },
    Kraken = {
        "SMASHED!",
        Color3.fromRGB(255, 80, 70)
    }
}
local t2 = {}

local function now() -- line: 47
    -- upvalues: Workspace (copy)
    return Workspace:GetServerTimeNow()
end

local function tween(p1, p2, p3, p4, p5) -- line: 51
    -- upvalues: TweenService (copy)
    local tween = TweenService:Create(p1, TweenInfo.new(p2, p4 or Enum.EasingStyle.Quad, p5 or Enum.EasingDirection.Out), p3)

    tween:Play()

    return tween
end

local function flatten(p6, p7) -- line: 67
    local v5 = p6 - p7 * p6:Dot(p7)

    if v5.Magnitude > 0.001 then
        return v5.Unit
    end

    return (Vector3.new(0, 0, 1))
end

local function bezier(p8, p9, p10, p11) -- line: 72
    local v6 = 1 - p11

    return p8 * v6 * v6 + p9 * 2 * v6 * p11 + p10 * p11 * p11
end

local function shuffled() -- line: 77
    -- upvalues: RacePowerUps (copy)
    local v7 = table.clone(RacePowerUps.Order)

    for i = #v7, 2, -1 do
        local v8 = math.random(1, i)
        local v9 = v7[v8]
        local v10 = v7[i]

        v7[i] = v9
        v7[v8] = v10
    end

    return v7
end

function t2.Run(p12, p13, p14, p15, p16) -- line: 86
    -- upvalues: ContextActionService (copy), GuiService (copy), RunService (copy), TweenService (copy), UserInputService (copy), Workspace (copy), MountRaceFlags (copy), InputIconsConfig (copy), PowerUpVisuals (copy), RacePowerUps (copy), Remotes (copy), LocalPlayer (copy), Attributes (copy), Tuning (copy), Items (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), t1 (copy), shuffled (copy)
    local RacePowerUpUI = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("RacePowerUpUI")
    local v11 = PowerUpVisuals.Run(p12, p13, p16)
    local Root = p14.Rig.Root
    local Vignette, Tint, Flash = RacePowerUpUI.Vignette, RacePowerUpUI.Tint, RacePowerUpUI.Flash

    local function coverScreen() -- line: 102
        -- upvalues: RacePowerUpUI (copy), Vignette (copy), Tint (copy), Flash (copy), GuiService (copy), Workspace (copy)
        local CurrentCamera = Workspace.CurrentCamera
        local AbsoluteSize = RacePowerUpUI.AbsoluteSize

        if CurrentCamera == nil or AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
            return
        end

        local ViewportSize = CurrentCamera.ViewportSize
        local AbsolutePosition = RacePowerUpUI.AbsolutePosition
        local GuiInset = GuiService:GetGuiInset()

        for _, v12 in { Vignette, Tint, Flash } do
            v12.AnchorPoint = Vector2.zero
            v12.Position = UDim2.fromScale((-GuiInset.X - AbsolutePosition.X) / AbsoluteSize.X, (-GuiInset.Y - AbsolutePosition.Y) / AbsoluteSize.Y)
            v12.Size = UDim2.fromScale(ViewportSize.X / AbsoluteSize.X, ViewportSize.Y / AbsoluteSize.Y)
        end
    end

    coverScreen()
    p12:Connect(RacePowerUpUI:GetPropertyChangedSignal("AbsoluteSize"), coverScreen)
    p12:Connect(RacePowerUpUI:GetPropertyChangedSignal("AbsolutePosition"), coverScreen)

    local Roll = RacePowerUpUI.Roll
    local Pop, Rays, Ring, Sparkle = Roll.Pop, Roll.Rays, Roll.Ring, Roll.Sparkle
    local Title = Roll.Title
    local UIStroke = Title:FindFirstChildOfClass("UIStroke")
    local Icon, Next = Roll.Window.Icon, Roll.Window.Next
    local Slot = RacePowerUpUI.Slot
    local Pop2, Glow, Icon2, Count = Slot.Pop, Slot.Glow, Slot.Icon, Slot.Count
    local KeyHint = Slot.KeyHint
    local Key, UIStroke2, ConsoleIcon = Slot.KeyHint.Key, Slot.KeyHint.UIStroke, Slot.KeyHint.ConsoleIcon
    local Tap = Slot.Tap
    local Effect = RacePowerUpUI.Effect
    local Pop3, Icon3 = Effect.Pop, Effect.Icon
    local Fill = Effect.Bar.Fill
    local Time = Effect.Time
    local Fly = RacePowerUpUI.Fly
    local Trail = Fly.Trail
    local Banner = RacePowerUpUI.Banner
    local Pop4 = Banner.Pop
    local UIStroke3 = Banner:FindFirstChildOfClass("UIStroke")

    local function resetUi() -- line: 154
        -- upvalues: Vignette (copy), Tint (copy), Flash (copy), Roll (copy), Slot (copy), Effect (copy), Fly (copy), Banner (copy), UIStroke3 (copy)
        Vignette.GroupTransparency = 1
        Tint.GroupTransparency = 1
        Flash.BackgroundTransparency = 1
        Roll.Visible = false
        Slot.Visible = false
        Effect.Visible = false
        Fly.Visible = false
        Banner.TextTransparency = 1
        UIStroke3.Transparency = 1
    end

    Vignette.GroupTransparency = 1
    Tint.GroupTransparency = 1
    Flash.BackgroundTransparency = 1
    Roll.Visible = false
    Slot.Visible = false
    Effect.Visible = false
    Fly.Visible = false
    Banner.TextTransparency = 1
    UIStroke3.Transparency = 1
    p12:Add(resetUi)

    local t3 = {
        RollToken = 0,
        RollKey = "",
        Rolling = false,
        Rainbow = false,
        Flying = false,
        Effect = nil,
        EffectEndsAt = 0,
        EffectSeconds = 1,
        Stunned = false,
        TintColor = nil,
        TintFloor = 1,
        Warning = 0,
        BannerToken = 0,
        Gamepad = UserInputService:GetLastInputType().Name:find("Gamepad") ~= nil
    }

    local function effectActive() -- line: 185
        -- upvalues: Workspace (copy), LocalPlayer (copy), Attributes (copy)
        local Attribute = LocalPlayer:GetAttribute(Attributes.Effect)
        local Attribute2 = LocalPlayer:GetAttribute(Attributes.EffectEndsAt)

        return if type(Attribute) == "string" and type(Attribute2) == "number" and Workspace:GetServerTimeNow() < Attribute2 then Attribute else nil
    end

    local function rolling() -- line: 194
        -- upvalues: t3 (copy), Workspace (copy), LocalPlayer (copy), Attributes (copy)
        local Attribute = LocalPlayer:GetAttribute(Attributes.RollEndsAt)
        local Rolling = t3.Rolling

        if not Rolling then
            Rolling = t3.Flying

            if not Rolling then
                Rolling = type(Attribute) == "number" and Workspace:GetServerTimeNow() < Attribute
            end
        end

        return Rolling
    end

    local function showBanner(p17, p18, p19) -- line: 199
        -- upvalues: Banner (copy), Pop4 (copy), UIStroke3 (copy), t3 (copy), TweenService (copy)
        t3.BannerToken += 1

        local BannerToken = t3.BannerToken

        Banner.Text = p17
        Banner.TextColor3 = p18
        Banner.TextTransparency = 0
        UIStroke3.Transparency = 0
        Pop4.Scale = 1.7

        local t4 = {
            Scale = 1
        }
        local Back = Enum.EasingStyle.Back

        TweenService:Create(Pop4, TweenInfo.new(0.35, Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t4):Play()
        task.delay(p19, function() -- line: 208
            -- upvalues: BannerToken (copy), Banner (copy), UIStroke3 (copy), t3 (copy), TweenService (copy)
            if BannerToken ~= t3.BannerToken then
                return
            end

            local t5 = {
                TextTransparency = 1
            }

            TweenService:Create(Banner, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t5):Play()

            local t6 = {
                Transparency = 1
            }

            TweenService:Create(UIStroke3, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t6):Play()
        end)
    end

    local function flashScreen(p20, p21) -- line: 216
        -- upvalues: Flash (copy), TweenService (copy)
        Flash.BackgroundTransparency = 1 - p20

        local t7 = {
            BackgroundTransparency = 1
        }

        TweenService:Create(Flash, TweenInfo.new(p21, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t7):Play()
    end

    local function pulseTint(p22, p23, p24) -- line: 221
        -- upvalues: Tint (copy), t3 (copy), TweenService (copy)
        Tint.GroupColor3 = p22
        Tint.GroupTransparency = 1 - p23

        local t8 = {
            GroupTransparency = t3.TintFloor
        }

        TweenService:Create(Tint, TweenInfo.new(p24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t8):Play()
    end

    local t9 = {}

    local function setIcon(p25, p26) -- line: 228
        -- upvalues: t9 (copy), RacePowerUps (copy)
        local Model = p25:FindFirstChild("Model")
        local Model2 = p26.Model

        if Model2 == nil or Model == nil then
            p25.Image = p26.Icon

            if Model ~= nil then
                Model.Visible = false
            end
        else
            p25.Image = ""
            Model.Visible = true

            if t9[Model] ~= Model2 then
                t9[Model] = Model2

                local WorldModel = Model:FindFirstChildOfClass("WorldModel")

                WorldModel:ClearAllChildren()

                local clone = RacePowerUps.Assets.Icons[Model2]:Clone()

                clone:PivotTo(CFrame.identity)
                clone.Parent = WorldModel

                local BoundingBox, BoundingBox2 = clone:GetBoundingBox()
                local v13 = BoundingBox2.Magnitude * 0.5
                local Camera = Model:FindFirstChildOfClass("Camera")

                if Camera == nil then
                    Camera = Instance.new("Camera")
                    Camera.FieldOfView = 30
                    Camera.Parent = Model
                end

                Model.CurrentCamera = Camera
                Camera.CFrame = CFrame.lookAt(BoundingBox.Position + (Vector3.new(0.55, 0.6, 1)).Unit * v13 * 3.6, BoundingBox.Position)
            end
        end
    end

    local function refreshKey() -- line: 262
        -- upvalues: KeyHint (copy), Key (copy), UIStroke2 (copy), ConsoleIcon (copy), Tap (copy), t3 (copy), UserInputService (copy), InputIconsConfig (copy)
        local v14 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

        KeyHint.Visible = not v14
        Tap.Visible = v14

        local v15 = if t3.Gamepad then InputIconsConfig.Image(Enum.KeyCode.ButtonX) else nil

        ConsoleIcon.Image = v15 or ""
        ConsoleIcon.Visible = v15 ~= nil
        Key.Visible = v15 == nil
        UIStroke2.Enabled = v15 == nil
        Key.Text = t3.Gamepad and "X" or "E"
    end

    local function refreshSlot(p27) -- line: 275
        -- upvalues: Slot (copy), Pop2 (copy), Glow (copy), Icon2 (copy), Count (copy), t3 (copy), setIcon (copy), refreshKey (copy), TweenService (copy), Workspace (copy), LocalPlayer (copy), Attributes (copy), Items (copy)
        local Attribute = LocalPlayer:GetAttribute(Attributes.Item)
        local v16 = if type(Attribute) == "string" then Items[Attribute] else nil

        if v16 ~= nil then
            local Attribute = LocalPlayer:GetAttribute(Attributes.RollEndsAt)
            local Rolling = t3.Rolling

            if not Rolling then
                Rolling = t3.Flying

                if not Rolling then
                    Rolling = type(Attribute) == "number" and Workspace:GetServerTimeNow() < Attribute
                end
            end

            if not Rolling then
                local Attribute = LocalPlayer:GetAttribute(Attributes.Uses)

                setIcon(Icon2, v16)
                Glow.ImageColor3 = v16.Color
                Count.Visible = type(Attribute) == "number" and v16.Uses > 1

                if type(Attribute) ~= "number" then
                    Attribute = 1
                end

                Count.Text = ("x%*"):format(Attribute)
                refreshKey()

                local Pop, t10, Back, TweenService2, new, v18

                if p27 then
                    Slot.Visible = true
                    Pop2.Scale = 1.45
                    Pop = Pop2
                    t10 = {
                        Scale = 1
                    }
                    Back = Enum.EasingStyle.Back
                    TweenService2 = TweenService
                    new = TweenInfo.new
                    Back = Back or Enum.EasingStyle.Quad
                    v18 = false
                elseif Slot.Visible then
                    v18 = true
                else
                    Slot.Visible = true
                    Pop2.Scale = 1.45
                    Pop = Pop2
                    t10 = {
                        Scale = 1
                    }
                    Back = Enum.EasingStyle.Back
                    TweenService2 = TweenService
                    new = TweenInfo.new
                    Back = Back or Enum.EasingStyle.Quad
                    v18 = false
                end

                if not v18 then
                    TweenService2:Create(Pop, new(0.4, Back, Enum.EasingDirection.Out), t10):Play()
                end

                return
            end
        end

        if v16 ~= nil or not Slot.Visible then
            return
        end

        local t11 = {
            Scale = 0
        }
        local Back = Enum.EasingStyle.Back
        local In = Enum.EasingDirection.In
        local tween = TweenService:Create(Pop2, TweenInfo.new(0.18, Back or Enum.EasingStyle.Quad, In or Enum.EasingDirection.Out), t11)

        tween:Play()
        tween.Completed:Once(function() -- line: 281
            -- upvalues: Slot (copy), LocalPlayer (copy), Attributes (copy)
            if LocalPlayer:GetAttribute(Attributes.Item) == nil then
                Slot.Visible = false
            end
        end)
    end

    local function setReel(p28, p29, p30) -- line: 303
        -- upvalues: Icon (copy), Next (copy), setIcon (copy), TweenService (copy)
        setIcon(Next, p28)
        Next.Position = UDim2.fromScale(0.5, -0.55)
        Icon.Position = UDim2.fromScale(0.5, 0.5)

        local v20 = p30 + 0.9

        Next.Size = UDim2.fromScale(0.9, v20)
        Icon.Size = UDim2.fromScale(0.9, v20)

        local t12 = {
            Position = UDim2.fromScale(0.5, 1.55)
        }
        local Quad = Enum.EasingStyle.Quad
        local In = Enum.EasingDirection.In

        TweenService:Create(Icon, TweenInfo.new(p29, Quad or Enum.EasingStyle.Quad, In or Enum.EasingDirection.Out), t12):Play()

        local t13 = {
            Position = UDim2.fromScale(0.5, 0.5)
        }
        local Quad2 = Enum.EasingStyle.Quad
        local Out = Enum.EasingDirection.Out
        local tween = TweenService:Create(Next, TweenInfo.new(p29, Quad2 or Enum.EasingStyle.Quad, Out or Enum.EasingDirection.Out), t13)

        tween:Play()
        tween.Completed:Once(function() -- line: 323
            -- upvalues: p28 (copy), Icon (copy), Next (copy), setIcon (copy)
            setIcon(Icon, p28)
            Icon.Position = UDim2.fromScale(0.5, 0.5)
            Icon.Size = UDim2.fromScale(0.9, 0.9)
            Next.Position = UDim2.fromScale(0.5, -0.55)
        end)
    end

    local function flyToSlot(p31, p32) -- line: 331
        -- upvalues: Roll (copy), Glow (copy), Fly (copy), Trail (copy), t3 (copy), setIcon (copy), refreshSlot (copy), RunService (copy), TweenService (copy), PowerUpVisuals (copy), v1 (copy), v2 (copy), v3 (copy)
        t3.Flying = true
        setIcon(Fly, p31)
        Trail.ImageColor3 = p31.Color
        Fly.Position = v1
        Fly.Size = UDim2.fromScale(0.22, 0.22)
        Fly.Rotation = 0
        Fly.Visible = true
        Roll.Visible = false

        local v21 = Vector2.new(v1.X.Scale, v1.Y.Scale)
        local v22 = Vector2.new(v2.X.Scale, v2.Y.Scale)
        local elapsed = os.clock()

        while p32 == t3.RollToken do
            local v24 = math.min((os.clock() - elapsed) / 0.42, 1)
            local Value = TweenService:GetValue(v24, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            local v25 = 1 - Value
            local v26 = v21 * v25 * v25 + v3 * 2 * v25 * Value + v22 * Value * Value

            Fly.Position = UDim2.fromScale(v26.X, v26.Y)

            local v27 = 0.22 + -0.11 * Value

            Fly.Size = UDim2.fromScale(v27, v27)
            Fly.Rotation = math.sin(v24 * 3.141592653589793) * -22
            Trail.ImageTransparency = v24 * 0.5 + 0.35

            if v24 >= 1 then
                break
            end

            RunService.RenderStepped:Wait()
        end

        Fly.Visible = false
        t3.Flying = false

        if p32 ~= t3.RollToken then
            return
        end

        PowerUpVisuals.Sound("Ready", nil)
        refreshSlot(true)
        Glow.ImageTransparency = 0

        local t14 = {
            ImageTransparency = 0.5
        }

        TweenService:Create(Glow, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t14):Play()
    end

    local function land(p33, p34) -- line: 368
        -- upvalues: p15 (copy), Vignette (copy), Flash (copy), Pop (copy), Rays (copy), Ring (copy), Sparkle (copy), Title (copy), UIStroke (copy), Icon (copy), Next (copy), t3 (copy), setIcon (copy), flyToSlot (copy), TweenService (copy), PowerUpVisuals (copy)
        setIcon(Icon, p33)
        Icon.Position = UDim2.fromScale(0.5, 0.5)
        Icon.Size = UDim2.fromScale(0.9, 0.9)
        Next.Position = UDim2.fromScale(0.5, -0.55)
        Pop.Scale = 1.55

        local t15 = {
            Scale = 1
        }
        local Elastic = Enum.EasingStyle.Elastic

        TweenService:Create(Pop, TweenInfo.new(0.55, Elastic or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t15):Play()
        Ring.ImageColor3 = p33.Color
        Ring.Size = UDim2.fromScale(1, 1)
        Ring.ImageTransparency = 0

        local t16 = {
            ImageTransparency = 1,
            Size = UDim2.fromScale(2.8, 2.8)
        }

        TweenService:Create(Ring, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t16):Play()
        Rays.ImageColor3 = p33.Color
        Rays.ImageTransparency = 0.05

        local t17 = {
            ImageTransparency = 0.65
        }

        TweenService:Create(Rays, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t17):Play()
        Sparkle.ImageTransparency = 0
        Sparkle.Size = UDim2.fromScale(0.9, 0.9)

        local t18 = {
            ImageTransparency = 1,
            Size = UDim2.fromScale(0.3, 0.3)
        }

        TweenService:Create(Sparkle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t18):Play()
        t3.Rainbow = false

        for _, child in Vignette:GetChildren() do
            if child:IsA("Frame") then
                child.BackgroundColor3 = p33.Color
            end
        end

        Vignette.GroupTransparency = 0

        local t19 = {
            GroupTransparency = 1
        }

        TweenService:Create(Vignette, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t19):Play()
        Flash.BackgroundTransparency = 0.55

        local t20 = {
            BackgroundTransparency = 1
        }

        TweenService:Create(Flash, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t20):Play()
        Title.Text = string.upper(p33.Name)
        Title.TextColor3 = Color3.new(1, 1, 1)
        Title.TextTransparency = 0
        UIStroke.Transparency = 0
        Title.Position = UDim2.fromScale(0.5, 1.22)

        local t21 = {
            Position = UDim2.fromScale(0.5, 1.1)
        }
        local Back = Enum.EasingStyle.Back

        TweenService:Create(Title, TweenInfo.new(0.35, Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t21):Play()
        PowerUpVisuals.Sound("Land", nil)
        p15:PunchFov(24)
        p15:Shake(1.6)
        task.wait(0.55)

        if p34 ~= t3.RollToken then
            return
        end

        local t22 = {
            TextTransparency = 1
        }

        TweenService:Create(Title, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t22):Play()

        local t23 = {
            Transparency = 1
        }

        TweenService:Create(UIStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t23):Play()
        t3.Rolling = false
        flyToSlot(p33, p34)
    end

    local function startRoll(p35, p36) -- line: 413
        -- upvalues: Vignette (copy), Roll (copy), Pop (copy), Rays (copy), Ring (copy), Sparkle (copy), Title (copy), UIStroke (copy), Icon (copy), Slot (copy), t3 (copy), setIcon (copy), setReel (copy), land (copy), TweenService (copy), Workspace (copy), PowerUpVisuals (copy), Items (copy), shuffled (copy)
        t3.RollToken += 1

        local RollToken = t3.RollToken

        t3.Rolling = true

        local v29 = Items[p35]

        Slot.Visible = false
        Roll.Visible = true
        Pop.Scale = 0.2

        local t24 = {
            Scale = 1
        }
        local Back = Enum.EasingStyle.Back

        TweenService:Create(Pop, TweenInfo.new(0.3, Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t24):Play()
        Title.TextTransparency = 1
        UIStroke.Transparency = 1
        Ring.ImageTransparency = 1
        Sparkle.ImageTransparency = 1
        Rays.ImageColor3 = Color3.new(1, 1, 1)
        Rays.ImageTransparency = 0.8
        t3.Rainbow = true
        Vignette.GroupTransparency = 1

        local t25 = {
            GroupTransparency = 0.1
        }

        TweenService:Create(Vignette, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t25):Play()

        local v30 = shuffled()
        local n1 = 1
        local v32 = math.max(p36 - Workspace:GetServerTimeNow(), 0.4)

        setIcon(Icon, Items[v30[1]])
        task.spawn(function() -- line: 435
            -- upvalues: p35 (copy), p36 (copy), RollToken (copy), v29 (copy), v30 (copy), n1 (ref), v32 (copy), Pop (copy), t3 (copy), setReel (copy), land (copy), TweenService (copy), Workspace (copy), PowerUpVisuals (copy), Items (copy)
            while RollToken == t3.RollToken do
                local v33 = p36 - Workspace:GetServerTimeNow()
                local v35 = math.clamp(1 - v33 / v32, 0, 1)
                local v36 = v35 ^ 2.2 * 0.27 + 0.045

                if v33 <= v36 * 0.6 then
                    break
                end

                n1 = n1 % #v30 + 1

                if v30[n1] == p35 and v36 * 2.5 < v33 then
                    n1 = n1 % #v30 + 1
                end

                setReel(if v33 <= v36 * 1.6 then v29 else Items[v30[n1]], math.min(v36 * 0.85, 0.14), (1 - v35) * 0.3)
                PowerUpVisuals.Sound("Tick", nil, v35 * 0.6 + 0.85)
                Pop.Scale = 1.08

                local t26 = {
                    Scale = 1
                }

                TweenService:Create(Pop, TweenInfo.new(v36, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t26):Play()
                task.wait(v36)
            end

            if RollToken == t3.RollToken then
                land(v29, RollToken)
            end
        end)
    end

    local function refreshItem() -- line: 460
        -- upvalues: Roll (copy), t3 (copy), refreshSlot (copy), startRoll (copy), Workspace (copy), LocalPlayer (copy), Attributes (copy), Items (copy)
        local Attribute = LocalPlayer:GetAttribute(Attributes.Item)
        local Attribute2 = LocalPlayer:GetAttribute(Attributes.RollEndsAt)

        if type(Attribute) == "string" and Items[Attribute] ~= nil and type(Attribute2) == "number" and Workspace:GetServerTimeNow() < Attribute2 then
            local v41 = ("%*@%*"):format(Attribute, Attribute2)

            if not t3.Rolling or t3.RollKey ~= v41 then
                t3.RollKey = v41
                startRoll(Attribute, Attribute2)
            end

            return
        end

        if Attribute == nil then
            t3.RollToken += 1
            t3.Rolling = false
            Roll.Visible = false
        end

        if not t3.Rolling and not t3.Flying then
            refreshSlot(false)
        end
    end

    local function deny() -- line: 481
        -- upvalues: Slot (copy), RunService (copy), PowerUpVisuals (copy)
        PowerUpVisuals.Sound("Deny", nil)

        local elapsed = os.clock()

        task.spawn(function() -- line: 484
            -- upvalues: elapsed (copy), Slot (copy), RunService (copy)
            while os.clock() - elapsed < 0.3 do
                Slot.Rotation = math.sin((os.clock() - elapsed) * 60) * 10 * (1 - (os.clock() - elapsed) / 0.3)
                RunService.RenderStepped:Wait()
            end

            Slot.Rotation = 0
        end)
    end

    local function use() -- line: 493
        -- upvalues: p14 (copy), p15 (copy), Root (copy), Slot (copy), Pop2 (copy), t3 (copy), RunService (copy), TweenService (copy), Workspace (copy), PowerUpVisuals (copy), Remotes (copy), LocalPlayer (copy), Attributes (copy)
        if type((LocalPlayer:GetAttribute(Attributes.Item))) ~= "string" then
            return
        end

        local Attribute2 = LocalPlayer:GetAttribute(Attributes.RollEndsAt)
        local Rolling = t3.Rolling

        if not Rolling then
            Rolling = t3.Flying

            if not Rolling then
                Rolling = type(Attribute2) == "number" and Workspace:GetServerTimeNow() < Attribute2
            end
        end

        if Rolling then
            return
        end

        local Attribute3 = LocalPlayer:GetAttribute(Attributes.Effect)
        local Attribute4 = LocalPlayer:GetAttribute(Attributes.EffectEndsAt)

        if type(Attribute3) ~= "string" or type(Attribute4) ~= "number" or not (Workspace:GetServerTimeNow() < Attribute4) then
            Attribute3 = nil
        end

        local Pop, t27, TweenService2, new, v43

        if Attribute3 ~= nil or t3.Stunned then
            PowerUpVisuals.Sound("Deny", nil)

            local elapsed = os.clock()

            task.spawn(function() -- line: 484
                -- upvalues: elapsed (copy), Slot (copy), RunService (copy)
                while os.clock() - elapsed < 0.3 do
                    Slot.Rotation = math.sin((os.clock() - elapsed) * 60) * 10 * (1 - (os.clock() - elapsed) / 0.3)
                    RunService.RenderStepped:Wait()
                end

                Slot.Rotation = 0
            end)
        else
            Pop2.Scale = 0.75
            Pop = Pop2
            t27 = {
                Scale = 1
            }

            local Back = Enum.EasingStyle.Back

            TweenService2 = TweenService
            new = TweenInfo.new
            v43 = Back or Enum.EasingStyle.Quad
            TweenService2:Create(Pop, new(0.3, v43, Enum.EasingDirection.Out), t27):Play()
            p15:PunchFov(6)
            Remotes.MountRace.PowerUp:FireServer("Use", Root.Position, p14.Heading)
        end
    end

    ContextActionService:BindActionAtPriority("RacePowerUpUse", function(_, p38, p39) -- line: 508
        -- upvalues: t3 (copy), use (copy)
        if p38 ~= Enum.UserInputState.Begin then
            return Enum.ContextActionResult.Sink
        end

        t3.Gamepad = p39.KeyCode == Enum.KeyCode.ButtonX
        use()

        return Enum.ContextActionResult.Sink
    end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.E, Enum.KeyCode.ButtonX)
    p12:Add(function() -- line: 515
        -- upvalues: ContextActionService (copy)
        ContextActionService:UnbindAction("RacePowerUpUse")
    end)
    p12:Connect(Slot.Activated, use)
    p12:Connect(UserInputService.LastInputTypeChanged, function(p40) -- line: 519
        -- upvalues: t3 (copy), refreshKey (copy)
        t3.Gamepad = p40.Name:find("Gamepad") ~= nil
        refreshKey()
    end)
    p12:Connect(InputIconsConfig.Changed, refreshKey)

    local v47

    local function endWhale() -- line: 527
        -- upvalues: p14 (copy), p15 (copy), p16 (copy), Root (copy), v47 (ref), MountRaceFlags (copy)
        if p14.Override == nil then
            return
        end

        p14.Override = nil

        local v48 = v47

        v47 = nil

        local v49 = if v48 == nil then Root.CFrame else p16:FrameAt(v48)
        local UpVector = v49.UpVector
        local v50 = v49.LookVector - UpVector * v49.LookVector:Dot(UpVector)
        local v51 = if v50.Magnitude > 0.001 then v50.Unit else p14.Heading
        local v52 = MountRaceFlags.TopSpeed:Get()

        Root.AssemblyLinearVelocity = v51 * v52
        Root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        Root.CFrame = CFrame.lookAt(Root.Position, Root.Position + v51, UpVector)
        p14.Align.CFrame = CFrame.lookAt(Vector3.new(0, 0, 0), v51, UpVector)
        p14.Push.Force = Vector3.new(0, 0, 0)
        p14.Up = UpVector
        p14.Heading = v51
        p14.TravelDirection = v51
        p14.Speed = v52
        p14.Grounded = false
        p14.Launched = false
        p14.IgnoreGroundUntil = 0
        p15:PunchFov(8)
    end

    local function startWhale(p41) -- line: 554
        -- upvalues: p14 (copy), p15 (copy), p16 (copy), Root (copy), Flash (copy), v47 (ref), endWhale (copy), TweenService (copy), Workspace (copy), MountRaceFlags (copy), LocalPlayer (copy), Attributes (copy), Tuning (copy)
        local v53 = MountRaceFlags.TopSpeed:Get()
        local v54 = p16:Project(Root.Position, 0, p16.Length, p16.Length)
        local v55 = v54
        local v56 = p16:FrameAt(v54)
        local X = v56:PointToObjectSpace(Root.Position).X
        local elapsed = os.clock()
        local n2 = 0
        local v57 = v56.LookVector
        local v58 = Root.CFrame.LookVector
        local v60 = math.clamp((Root.Position - v56.Position):Dot(v56.UpVector), 0, Tuning.SkywhaleHeight)

        v47 = v54
        p15:PunchFov(30)
        p15:Shake(2)
        Flash.BackgroundTransparency = 0.4

        local t28 = {
            BackgroundTransparency = 1
        }

        TweenService:Create(Flash, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t28):Play()

        p14.Override = function(p42, p43) -- line: 568
            -- upvalues: p41 (copy), v53 (copy), v55 (ref), X (copy), elapsed (copy), n2 (ref), v57 (ref), v58 (ref), v60 (copy), p15 (copy), p16 (copy), Root (copy), v47 (ref), Workspace (copy), Tuning (copy)
            local v61 = os.clock() - elapsed
            local v63 = math.clamp((p41 - Workspace:GetServerTimeNow()) / 0.7, 0, 1)
            local v64 = 1 - v63 * v63 * (3 - v63 * 2)
            local v67 = v53 * Tuning.SkywhaleScale * math.min(1, 0.45 + v61 * 1.2)
            local v68 = v67 + (v53 - v67) * v64

            v55 += v68 * p43
            v47 = v55

            local v70 = p16:FrameAt(v55)
            local v71 = p16:FrameAt(v55 + 20)
            local UpVector = v70.UpVector
            local v73 = X * math.max(0, 1 - v61 / 0.9)
            local v77 = Tuning.SkywhaleHeight * math.min(1, v61 / 0.45) + math.sin(v61 * 3.2) * 0.7
            local v78 = v77 + (v60 - v77) * v64
            local v79 = v70.Position + v70.RightVector * v73 + UpVector * v78
            local v80 = v71.Position + UpVector * v78 - v79
            local v81 = if v80.Magnitude > 0.001 then v80.Unit else v70.LookVector
            local v82 = v81 * v68 + (v79 - Root.Position) * 9

            Root.AssemblyLinearVelocity = v82

            local v83 = v82 - UpVector * v82:Dot(UpVector) * 0.85
            local v84 = if v83.Magnitude > 0.001 then v83.Unit else v81

            v58 = v58:Lerp(v84, (math.min(1, p43 * 14)))

            if v58.Magnitude > 0.001 then
                v81 = v58.Unit
            end

            v58 = v81

            local v87 = v58

            Root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            p42.Drive.Enabled = false
            p42.Push.Force = Vector3.new(0, 1, 0) * Root.AssemblyMass * Workspace.Gravity

            local v88 = v57:Cross(v87):Dot(UpVector) / math.max(p43, 0.001)

            v57 = v87
            n2 += (math.clamp(-v88 * 0.35, -0.55, 0.55) - n2) * math.min(1, p43 * 5)
            p42.Align.CFrame = CFrame.lookAt(Vector3.new(0, 0, 0), v87, UpVector) * CFrame.Angles(math.sin(v61 * 2.4) * 0.05, 0, n2)
            Root.CFrame = CFrame.new(Root.Position) * p42.Align.CFrame
            p42.Up = p42.Up:Lerp(UpVector, (math.min(1, p43 * 6))).Unit
            p42.Heading = v87
            p42.TravelDirection = v87
            p42.Speed = v68
            p42.Grounded = false
            p42.AirSeconds = 0
            p42.Launched = true
            p15:PunchFov(10)
        end

        task.delay(math.max(p41 - Workspace:GetServerTimeNow(), 0), function() -- line: 610
            -- upvalues: p14 (copy), endWhale (copy), LocalPlayer (copy), Attributes (copy)
            if p14.Override ~= nil and LocalPlayer:GetAttribute(Attributes.Effect) ~= "Skywhale" then
                endWhale()
            end
        end)
    end

    local function startStun(p44, p45) -- line: 617
        -- upvalues: p14 (copy), p15 (copy), Root (copy), Tint (copy), Flash (copy), t3 (copy), showBanner (copy), refreshSlot (copy), TweenService (copy), Workspace (copy), MountRaceFlags (copy), LocalPlayer (copy), Attributes (copy), Tuning (copy), t1 (copy)
        if p14.Override ~= nil then
            return
        end

        t3.Stunned = true
        refreshSlot(false)

        local elapsed = os.clock()
        local Heading, TravelDirection = p14.Heading, p14.TravelDirection
        local v97 = math.max(p14.Speed, 0)
        local v98 = if p44 == "Drilla" then 2 else 1
        local v99 = if p44 == "Egg" then Tuning.EggSpinSeconds else 0.75
        local v100 = if p44 == "Drilla" then 62
            elseif p44 == "Pod" then 42
            elseif p44 == "Spike" then 24
            else 0

        if v100 > 0 then
            p14:Launch(Root.AssemblyLinearVelocity * 0.3 + p14.Up * v100)
        end

        local v101 = t1[p44]

        if v101 ~= nil then
            showBanner(v101[1], v101[2], 0.9)
        end

        Flash.BackgroundTransparency = 1 - (p44 == "Egg" and 0.35 or 0.55)

        local t29 = {
            BackgroundTransparency = 1
        }

        TweenService:Create(Flash, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t29):Play()
        Tint.GroupColor3 = if p44 == "Egg" then Color3.fromRGB(255, 210, 40) else Color3.fromRGB(255, 50, 40)
        Tint.GroupTransparency = 0.15000000000000002

        local t30 = {
            GroupTransparency = t3.TintFloor
        }

        TweenService:Create(Tint, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t30):Play()
        p15:Shake(if p44 == "Drilla" then 7 elseif p44 == "Pod" then 6 else 4)

        p14.Override = function(p46, p47) -- line: 640
            -- upvalues: p44 (copy), elapsed (copy), Heading (copy), TravelDirection (copy), v97 (copy), v98 (copy), v99 (copy), Root (copy), TweenService (copy), Workspace (copy)
            local v105 = os.clock() - elapsed
            local Up = p46.Up
            local v106

            if os.clock() >= p46.IgnoreGroundUntil then
                v106, Up = p46:ProbeGround()
            else
                v106 = false
            end

            if v106 and not p46.Grounded then
                p46.Landed:Fire()
            end

            p46.Grounded = v106

            if v106 then
                p46.AirSeconds = 0
            else
                p46.AirSeconds += p47
            end

            p46.Launched = not v106

            local Up2 = p46.Up

            if not v106 then
                Up = Vector3.new(0, 1, 0)
            end

            p46.Up = Up2:Lerp(Up, (math.min(1, p47 * 10))).Unit

            local Up3 = p46.Up
            local v108 = Heading - Up3 * Heading:Dot(Up3)
            local v109 = if v108.Magnitude > 0.001 then v108.Unit else Vector3.new(0, 0, 1)
            local v110 = v109:Cross(Up3)
            local v112 = v97 * math.max(0, 1 - v105 / 0.5) ^ 2
            local v113 = TravelDirection - Up3 * TravelDirection:Dot(Up3)
            local v114 = (if v113.Magnitude > 0.001 then v113.Unit else Vector3.new(0, 0, 1)) * v112

            p46.Drive.Enabled = v106
            p46.Drive.PrimaryTangentAxis = v109
            p46.Drive.SecondaryTangentAxis = v110
            p46.Drive.PlaneVelocity = Vector2.new(v114:Dot(v109), v114:Dot(v110))

            local Push = p46.Push

            if v106 then
                Push.Force = -Up3 * Root.AssemblyMass * Workspace.Gravity * 0.4
            else
                Push.Force = Vector3.new(0, 0, 0)
            end

            local v116 = math.min(v105 / v99, 1)
            local v117 = TweenService:GetValue(v116, Enum.EasingStyle.Quint, Enum.EasingDirection.Out) * 3.141592653589793 * 2 * v98
            local v118 = if v116 >= 1 then math.sin(v105 * 10) * 0.14 * math.max(0, 1 - (v105 - v99) / 1.2) else 0
            local v122 = if p44 == "Egg" then 0 else math.sin(v116 * 3.141592653589793) * 0.5

            p46.Align.CFrame = CFrame.lookAt(Vector3.new(0, 0, 0), v109, Up3) * CFrame.Angles(0, v117 + v118, v122)
            p46.Speed = v112
        end

        local v124 = os.clock() + p45

        task.spawn(function() -- line: 674
            -- upvalues: Heading (copy), v124 (ref), p14 (copy), t3 (copy), refreshSlot (copy), Workspace (copy), MountRaceFlags (copy), LocalPlayer (copy), Attributes (copy)
            while os.clock() < v124 do
                local Attribute = LocalPlayer:GetAttribute(Attributes.StunEndsAt)

                if type(Attribute) == "number" then
                    local v125 = v124

                    v124 = math.max(v125, os.clock() + (Attribute - Workspace:GetServerTimeNow()))
                end

                task.wait(0.05)
            end

            if p14.Override ~= nil and t3.Stunned then
                p14.Override = nil
                p14.Heading = Heading
                p14.TravelDirection = Heading
                p14.Speed = MountRaceFlags.TopSpeed:Get() * 0.2
            end

            t3.Stunned = false
            refreshSlot(false)
        end)
    end

    local function refreshEffect() -- line: 693
        -- upvalues: p14 (copy), p15 (copy), Tint (copy), Flash (copy), Effect (copy), Pop3 (copy), Icon3 (copy), Fill (copy), t3 (copy), setIcon (copy), refreshSlot (copy), endWhale (copy), startWhale (copy), TweenService (copy), Workspace (copy), MountRaceFlags (copy), LocalPlayer (copy), Attributes (copy), Tuning (copy), Items (copy)
        local Attribute = LocalPlayer:GetAttribute(Attributes.Effect)
        local Attribute2 = LocalPlayer:GetAttribute(Attributes.EffectEndsAt)

        if type(Attribute) ~= "string" or type(Attribute2) ~= "number" or not (Workspace:GetServerTimeNow() < Attribute2) then
            Attribute = nil
        end

        local Attribute3 = LocalPlayer:GetAttribute(Attributes.EffectEndsAt)
        local Effect2 = t3.Effect

        if Attribute == Effect2 then
            return
        end

        t3.Effect = Attribute

        if Effect2 == "Serum" then
            p14:SetSpeedScale("RacePowerUpSerum", nil)
        elseif Effect2 == "Skywhale" then
            endWhale()
        end

        if Attribute ~= nil then
            local v127 = Items[Attribute]

            t3.EffectEndsAt = Attribute3
            t3.EffectSeconds = v127.Seconds or 1
            setIcon(Icon3, v127)
            Fill.BackgroundColor3 = v127.Color
            Effect.Visible = true
            Pop3.Scale = 0.2

            local t33 = {
                Scale = 1
            }
            local Back = Enum.EasingStyle.Back

            TweenService:Create(Pop3, TweenInfo.new(0.35, Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t33):Play()
            t3.TintColor = v127.Color
            t3.TintFloor = 0.72
            Tint.GroupColor3 = v127.Color
            Tint.GroupTransparency = 0.4

            local t34 = {
                GroupTransparency = t3.TintFloor
            }

            TweenService:Create(Tint, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t34):Play()

            if Attribute == "Serum" then
                p14:SetSpeedScale("RacePowerUpSerum", Tuning.SerumScale)

                if p14.Speed > -1 then
                    p14.Speed = math.max(p14.Speed, MountRaceFlags.TopSpeed:Get() * 1.85)
                end

                p15:PunchFov(26)
                p15:Shake(1.4)
                Flash.BackgroundTransparency = 0.65

                local t35 = {
                    BackgroundTransparency = 1
                }

                TweenService:Create(Flash, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t35):Play()
            elseif Attribute == "Shield" then
                p15:PunchFov(12)
                Flash.BackgroundTransparency = 0.7

                local t36 = {
                    BackgroundTransparency = 1
                }

                TweenService:Create(Flash, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t36):Play()
            elseif Attribute == "Skywhale" then
                startWhale(Attribute3)
            end
        else
            t3.TintFloor = 1

            local t31 = {
                GroupTransparency = 1
            }

            TweenService:Create(Tint, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t31):Play()

            local t32 = {
                Scale = 0
            }
            local Back = Enum.EasingStyle.Back
            local In = Enum.EasingDirection.In
            local tween = TweenService:Create(Pop3, TweenInfo.new(0.2, Back or Enum.EasingStyle.Quad, In or Enum.EasingDirection.Out), t32)

            tween:Play()
            tween.Completed:Once(function() -- line: 710
                -- upvalues: Effect (copy), t3 (copy)
                if t3.Effect == nil then
                    Effect.Visible = false
                end
            end)
        end

        refreshSlot(false)
    end

    p12:Add(function() -- line: 747
        -- upvalues: p14 (copy)
        p14:SetSpeedScale("RacePowerUpSerum", nil)
        p14.Override = nil
    end)
    p12:Connect(LocalPlayer:GetAttributeChangedSignal(Attributes.Item), refreshItem)
    p12:Connect(LocalPlayer:GetAttributeChangedSignal(Attributes.RollEndsAt), refreshItem)
    p12:Connect(LocalPlayer:GetAttributeChangedSignal(Attributes.Uses), function() -- line: 754
        -- upvalues: Slot (copy), Count (copy), refreshSlot (copy), TweenService (copy)
        if Slot.Visible then
            refreshSlot(false)
            Count.TextColor3 = Color3.fromRGB(255, 230, 90)

            local t37 = {
                TextColor3 = Color3.new(1, 1, 1)
            }

            TweenService:Create(Count, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t37):Play()
        end
    end)
    p12:Connect(LocalPlayer:GetAttributeChangedSignal(Attributes.Effect), refreshEffect)
    p12:Connect(LocalPlayer:GetAttributeChangedSignal(Attributes.EffectEndsAt), refreshEffect)
    refreshItem()
    refreshEffect()
    p12:Connect(Remotes.MountRace.PowerUpMoment.OnClientEvent, function(p48, ...) -- line: 766
        -- upvalues: p15 (copy), Tint (copy), Flash (copy), t3 (copy), showBanner (copy), startStun (copy), TweenService (copy), LocalPlayer (copy)
        local t38 = { ... }

        if p48 == "Hit" and t38[1] == LocalPlayer then
            startStun(t38[2], t38[3])
        elseif p48 == "Blocked" and t38[1] == LocalPlayer then
            showBanner("BLOCKED!", Color3.fromRGB(110, 225, 255), 0.8)
            Flash.BackgroundTransparency = 0.65

            local t39 = {
                BackgroundTransparency = 1
            }

            TweenService:Create(Flash, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t39):Play()
            Tint.GroupColor3 = Color3.fromRGB(90, 210, 255)
            Tint.GroupTransparency = 0.30000000000000004

            local t40 = {
                GroupTransparency = t3.TintFloor
            }

            TweenService:Create(Tint, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t40):Play()
            p15:Shake(2)
        elseif p48 == "PodLock" and t38[2] == LocalPlayer then
            showBanner("INCOMING!", Color3.fromRGB(255, 70, 60), 1.4)
            Tint.GroupColor3 = Color3.fromRGB(255, 40, 40)
            Tint.GroupTransparency = 0.25

            local t41 = {
                GroupTransparency = t3.TintFloor
            }

            TweenService:Create(Tint, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t41):Play()
        elseif p48 == "Drilla" and t38[5] == LocalPlayer then
            showBanner("DRILLA INCOMING!", Color3.fromRGB(255, 200, 60), 1.2)
        elseif p48 ~= "DrillaWarn" or t38[2] ~= LocalPlayer then
            if p48 == "Use" and t38[1] == LocalPlayer then
                local v131 = t38[2]

                if v131 == "Spike" or v131 == "Egg" or v131 == "Pod" or v131 == "Drilla" then
                    p15:Shake(0.8)
                end
            end
        else
            showBanner("MOVE!", Color3.fromRGB(255, 70, 60), 0.8)
            Tint.GroupColor3 = Color3.fromRGB(255, 40, 40)
            Tint.GroupTransparency = 0.15000000000000002

            local t42 = {
                GroupTransparency = t3.TintFloor
            }

            TweenService:Create(Tint, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t42):Play()
            p15:Shake(3)
        end
    end)
    p12:Connect(RunService.RenderStepped, function(p49) -- line: 792
        -- upvalues: p15 (copy), Vignette (copy), Tint (copy), Roll (copy), Rays (copy), Slot (copy), Glow (copy), Icon2 (copy), KeyHint (copy), Key (copy), ConsoleIcon (copy), Tap (copy), Effect (copy), Fill (copy), Time (copy), t3 (copy), Workspace (copy), LocalPlayer (copy), Attributes (copy), v4 (copy)
        if t3.Rolling then
            if t3.Rainbow then
                for v133, child in Vignette:GetChildren() do
                    if child:IsA("Frame") then
                        child.BackgroundColor3 = Color3.fromHSV((os.clock() * 0.9 + v133 * 0.25) % 1, 0.75, 1)
                    end
                end
            end

            Rays.Rotation = (Rays.Rotation + p49 * 90) % 360
        elseif Roll.Visible then
            Rays.Rotation = (Rays.Rotation + p49 * 40) % 360
        end

        if Slot.Visible then
            local elapsed = os.clock()
            local Attribute = LocalPlayer:GetAttribute(Attributes.Effect)
            local Attribute2 = LocalPlayer:GetAttribute(Attributes.EffectEndsAt)

            if type(Attribute) ~= "string" or type(Attribute2) ~= "number" or not (Workspace:GetServerTimeNow() < Attribute2) then
                Attribute = nil
            end

            local v134 = Attribute ~= nil or t3.Stunned

            Icon2.ImageColor3 = if v134 then v4 else Color3.new(1, 1, 1)

            local Model = Icon2:FindFirstChild("Model")

            if Model ~= nil and Model:IsA("ViewportFrame") then
                Model.ImageColor3 = Icon2.ImageColor3
            end

            KeyHint.BackgroundTransparency = if ConsoleIcon.Visible then 1 elseif v134 then 0.5 else 0
            Key.TextTransparency = v134 and 0.5 or 0
            ConsoleIcon.ImageTransparency = v134 and 0.5 or 0
            Glow.ImageTransparency = if v134 then 0.9 else math.sin(elapsed * 4) * 0.15 + 0.5
            Glow.Rotation = elapsed * 30 % 360
            Icon2.Rotation = if v134 then 0 else math.sin(elapsed * 2.2) * 4
            Tap.TextTransparency = if v134 then 0.6 else math.sin(elapsed * 6) * 0.15 + 0.15
        end

        if Effect.Visible and t3.Effect ~= nil then
            local v144 = math.max(t3.EffectEndsAt - Workspace:GetServerTimeNow(), 0)

            Fill.Size = UDim2.fromScale(math.clamp(v144 / t3.EffectSeconds, 0, 1), 1)
            Time.Text = string.format("%.1f", v144)

            if t3.TintColor ~= nil and Tint.GroupTransparency >= t3.TintFloor - 0.01 then
                Tint.GroupColor3 = t3.TintColor
                Tint.GroupTransparency = t3.TintFloor + math.sin(os.clock() * 5) * 0.06
            end

            if t3.Effect == "Serum" then
                p15:PunchFov(12)
            end
        end
    end)

    return v11
end

return t2
