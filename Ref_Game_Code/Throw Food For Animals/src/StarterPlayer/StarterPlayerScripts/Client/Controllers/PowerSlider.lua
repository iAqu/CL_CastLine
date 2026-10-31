-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UITheme = require(ReplicatedStorage.Config.UITheme)
local LevelConfig = require(ReplicatedStorage.Config.LevelConfig)
local AreasConfig = require(ReplicatedStorage.Config.AreasConfig)
local AreaUtil = require(ReplicatedStorage.Shared.AreaUtil)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Parent = script.Parent
local DataController = require(Parent.DataController)
local UIKit = require(Parent.UIKit)
local UIScaler = require(Parent.UIScaler)
local Sounds = require(Parent.Sounds)
local HUDController = require(Parent.HUDController)
local ClientState = require(Parent.ClientState)
local t1 = {}
local Colors = UITheme.Colors
local _ = Players.LocalPlayer
local v1, UIScale, TextButton, v2, v3, UIScale2, v4, v5, v6, v7, v8
local v9 = false
local v10 = false
local n1 = 0
local v11, v12
local n2 = 0

local function range() -- line: 49
    -- upvalues: LevelConfig (copy), DataController (copy)
    local v13 = DataController:Get("Level") or 1
    local v14 = LevelConfig.ThrowPowerForLevel(v13)

    return math.min(LevelConfig.MinThrowPower, v14), v14
end

local function areaFor(p1) -- line: 56
    -- upvalues: AreasConfig (copy), AreaUtil (copy)
    local _, v15 = AreaUtil.ComputeLanding(p1, 0)

    return AreasConfig.Get(v15), v15
end

local function render() -- line: 61
    -- upvalues: LevelConfig (copy), AreasConfig (copy), AreaUtil (copy), DataController (copy), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), v7 (ref), n1 (ref)
    local v16 = DataController:Get("Level") or 1
    local v17 = LevelConfig.ThrowPowerForLevel(v16)
    local v18 = math.min(LevelConfig.MinThrowPower, v17)
    local v19 = v18 < v17 and math.clamp((n1 - v18) / (v17 - v18), 0, 1) or 1
    local v21 = v2

    v21.Size = UDim2.fromScale(v19, 1)

    local v22 = v3

    v22.Position = UDim2.fromScale(v19, 0.5)

    if v17 <= n1 then
        local v23 = v4

        v23.Text = "<font color=\"#50C8FF\">" .. v17 .. "</font>  <font color=\"#8CFF3C\">MAX</font>"
    else
        local v24 = v4

        v24.Text = "<font color=\"#50C8FF\">" .. n1 .. "</font><font color=\"#9AA0B4\"> / " .. v17 .. "</font>"
    end

    local v25 = n1
    local _, v26 = AreaUtil.ComputeLanding(v25, 0)
    local v27 = AreasConfig.Get(v26)

    if v27 then
        local v28 = v27.Color:ToHex()
        local v29 = v5

        v29.Text = "Lands in: <font color=\"#" .. v28 .. "\">" .. string.upper(v27.Name) .. "</font>"
    end

    local v30 = v6

    v30.Visible = v17 <= v18

    local v31 = v7

    v31.Visible = n1 < v17
end

local function buildTicks() -- line: 80
    -- upvalues: LevelConfig (copy), AreasConfig (copy), AreaUtil (copy), DataController (copy), UIKit (copy), v8 (ref)
    v8:ClearAllChildren()

    local v32 = DataController:Get("Level") or 1
    local v33 = LevelConfig.ThrowPowerForLevel(v32)
    local v34 = math.min(LevelConfig.MinThrowPower, v33)

    if v33 <= v34 then
        return
    end

    local Z = AreaUtil.GetLaunchPosition().Z

    for i = 2, AreaUtil.Count() do
        local v35 = Z - AreaUtil.Get(i).ZStart

        if v34 < v35 and v35 < v33 then
            local v36 = AreasConfig.Get(i)
            local v37 = UIKit.Frame({
                ZIndex = 9,
                Parent = v8,
                Name = "Tick" .. i,
                Size = UDim2.new(0, 3, 0.7, 0),
                Position = UDim2.fromScale((v35 - v34) / (v33 - v34), 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Color = v36 and v36.Color or Color3.new(1, 1, 1)
            })

            UIKit.Corner(v37, 2)
        end
    end
end

local function setValue(p2, p3) -- line: 96
    -- upvalues: LevelConfig (copy), DataController (copy), Sounds (copy), n1 (ref), v12 (ref), n2 (ref), render (copy)
    local v38 = DataController:Get("Level") or 1
    local v39 = LevelConfig.ThrowPowerForLevel(v38)
    local v40 = math.min(LevelConfig.MinThrowPower, v39)
    local v43 = math.clamp(math.floor(p2 + 0.5), v40, v39)

    if v43 == n1 then
        return
    end

    n1 = v43
    render()

    if p3 then
        local PowerPerLevel = LevelConfig.PowerPerLevel
        local v46 = math.floor(n1 / PowerPerLevel)
        local v44

        if v46 ~= v12 and os.clock() - n2 > 0.035 then
            v12 = v46
            n2 = os.clock()
            v44 = v40 < v39 and (n1 - v40) / (v39 - v40) or 1
            Sounds.Play("ThrowMeterTick", {
                Volume = 0.18,
                Pitch = 0.8 + v44 * 0.7
            })
        end
    end
end

local function commit() -- line: 115
    -- upvalues: LevelConfig (copy), Remotes (copy), DataController (copy), n1 (ref), v11 (ref)
    local v47 = DataController:Get("Level") or 1
    local v48 = LevelConfig.ThrowPowerForLevel(v47)

    math.min(LevelConfig.MinThrowPower, v48)

    local v49 = if v48 <= n1 then 0 else n1

    if v49 == v11 then
        return
    end

    v11 = v49
    task.spawn(function() -- line: 120
        -- upvalues: v49 (copy), Remotes (copy), v11 (ref)
        if not Remotes.Invoke("Player_SetThrowPower", v49).Ok then
            v11 = nil
        end
    end)
end

local function valueFromScreenX(p4) -- line: 126
    -- upvalues: LevelConfig (copy), DataController (copy), TextButton (ref)
    local v50 = DataController:Get("Level") or 1
    local v51 = LevelConfig.ThrowPowerForLevel(v50)
    local v52 = math.min(LevelConfig.MinThrowPower, v51)
    local v55 = math.clamp((p4 - TextButton.AbsolutePosition.X) / math.max(TextButton.AbsoluteSize.X, 1), 0, 1)

    if v55 >= 0.985 then
        return v51
    end

    return v52 + v55 * (v51 - v52)
end

local function placePanel() -- line: 133
    -- upvalues: HUDController (copy), v1 (ref)
    local v56 = HUDController.GetStatsContainer()

    if v56 and v1 then
        v1.Position = UDim2.fromOffset(v56.AbsolutePosition.X, v56.AbsolutePosition.Y - 10)
    end
end

function t1.Open() -- line: 139
    -- upvalues: TweenService (copy), LevelConfig (copy), DataController (copy), Sounds (copy), HUDController (copy), ClientState (copy), v1 (ref), UIScale (ref), v9 (ref), n1 (ref), v11 (ref), render (copy), buildTicks (copy)
    local v58 = true

    if v9 or ClientState.Busy then
    elseif v1 then
        v9 = true

        local v59 = DataController:Get("Level") or 1

        n1 = LevelConfig.EffectiveThrowPower(v59, DataController:Get("ThrowPower"))
        v11 = DataController:Get("ThrowPower") or 0
        buildTicks()
        render()

        local v60 = HUDController.GetStatsContainer()

        if v60 and v1 then
            v1.Position = UDim2.fromOffset(v60.AbsolutePosition.X, v60.AbsolutePosition.Y - 10)
        end

        v58 = false
    end

    if v58 then
        return
    end

    v1.Visible = true
    UIScale.Scale = 0.7
    TweenService:Create(UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play()
    Sounds.Play("Slide")
end

function t1.Close() -- line: 154
    -- upvalues: TweenService (copy), LevelConfig (copy), Remotes (copy), DataController (copy), Sounds (copy), v1 (ref), UIScale (ref), v9 (ref), v10 (ref), n1 (ref), v11 (ref)
    if not v9 then
        return
    end

    v9 = false

    if v10 then
        v10 = false

        local v62 = DataController:Get("Level") or 1
        local v63 = LevelConfig.ThrowPowerForLevel(v62)

        math.min(LevelConfig.MinThrowPower, v63)

        local v64 = if v63 <= n1 then 0 else n1

        if v64 ~= v11 then
            v11 = v64
            task.spawn(function() -- line: 120
                -- upvalues: v64 (copy), Remotes (copy), v11 (ref)
                if not Remotes.Invoke("Player_SetThrowPower", v64).Ok then
                    v11 = nil
                end
            end)
        end
    end

    Sounds.Play("Slide", {
        Volume = 0.2
    })

    local tween = TweenService:Create(UIScale, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Scale = 0.7
    })

    tween.Completed:Once(function() -- line: 163
        -- upvalues: v1 (ref), v9 (ref)
        if not v9 then
            v1.Visible = false
        end
    end)
    tween:Play()
end

function t1.IsOpen() -- line: 169
    -- upvalues: v9 (ref)
    return v9
end

function t1.Toggle() -- line: 173
    -- upvalues: t1 (copy), v9 (ref)
    if v9 then
        t1.Close()
    else
        t1.Open()
    end
end

local function build() -- line: 177
    -- upvalues: UserInputService (copy), TweenService (copy), UITheme (copy), LevelConfig (copy), Remotes (copy), DataController (copy), UIKit (copy), UIScaler (copy), Sounds (copy), HUDController (copy), t1 (copy), Colors (copy), v1 (ref), UIScale (ref), TextButton (ref), v2 (ref), v3 (ref), UIScale2 (ref), v4 (ref), v5 (ref), v6 (ref), v7 (ref), v8 (ref), v9 (ref), v10 (ref), n1 (ref), v11 (ref), render (copy), setValue (copy)
    local v65 = HUDController.GetGui()
    local v66 = UIScaler.TouchBoost()

    v1 = UIKit.Frame({
        Name = "PowerSlider",
        Transparency = 1,
        ZIndex = 30,
        Parent = v65,
        Size = UDim2.fromScale(0.58 * v66, 0.215 * v66),
        AnchorPoint = Vector2.new(0, 1)
    })

    local v67 = v1

    v67.SizeConstraint = Enum.SizeConstraint.RelativeYY
    v1.Visible = false
    UIScale = Instance.new("UIScale")
    UIScale.Parent = v1
    UIKit.Shadow(v1, 5, 16)

    local v68 = UIKit.Frame({
        Name = "Body",
        Corner = 16,
        Stroke = 4,
        ZIndex = 31,
        Parent = v1,
        Color = Colors.Panel,
        StrokeColor = Colors.PanelStroke,
        Gradient = {
            Colors.PanelGradientA,
            Colors.PanelGradientB,
            90
        }
    })

    UIKit.Stripes(v68, 20, 0.95, 16)

    local TextButton2 = Instance.new("TextButton")

    TextButton2.Name = "InputSink"
    TextButton2.Text = ""
    TextButton2.AutoButtonColor = false
    TextButton2.BackgroundTransparency = 1
    TextButton2.Size = UDim2.fromScale(1, 1)
    TextButton2.ZIndex = 32
    TextButton2.Parent = v68

    local v69 = UIKit.Frame({
        Name = "Tail",
        Stroke = 4,
        ZIndex = 30,
        Parent = v1,
        Size = UDim2.fromScale(0.05, 0.12),
        Position = UDim2.fromScale(0.12, 1),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Colors.PanelGradientB,
        StrokeColor = Colors.PanelStroke
    })

    v69.SizeConstraint = Enum.SizeConstraint.RelativeYY
    v69.Rotation = 45

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Icon"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = UITheme.Icons.Power
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.Size = UDim2.fromScale(0.26, 0.26)
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
    ImageLabel.Position = UDim2.fromScale(0.03, 0.06)
    ImageLabel.ZIndex = 33
    ImageLabel.Parent = v68
    UIKit.Text({
        Name = "Title",
        Text = "THROW POWER",
        ZIndex = 33,
        Stroke = 3,
        Parent = v68,
        Size = UDim2.fromScale(0.42, 0.2),
        Position = UDim2.fromScale(0.13, 0.09),
        XAlign = Enum.TextXAlignment.Left
    })
    v4 = UIKit.Text({
        Name = "Value",
        Text = "",
        ZIndex = 33,
        Stroke = 3,
        Rich = true,
        Parent = v68,
        Size = UDim2.fromScale(0.3, 0.2),
        Position = UDim2.fromScale(0.86, 0.09),
        AnchorPoint = Vector2.new(1, 0),
        XAlign = Enum.TextXAlignment.Right
    })
    UIKit.Button({
        Name = "Close",
        Text = "X",
        Ratio = 1,
        ZIndex = 34,
        Parent = v68,
        Size = UDim2.fromScale(0.08, 0.24),
        Position = UDim2.fromScale(0.975, 0.07),
        AnchorPoint = Vector2.new(1, 0),
        Colors = {
            Colors.RedA,
            Colors.RedB
        },
        OnClick = function() -- OnClick | line: 214
            -- upvalues: t1 (copy)
            t1.Close()
        end
    })
    TextButton = Instance.new("TextButton")
    TextButton.Name = "Track"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false

    local TextButton3 = TextButton

    TextButton3.Size = UDim2.fromScale(0.86, 0.17)

    local TextButton4 = TextButton

    TextButton4.Position = UDim2.fromScale(0.07, 0.42)

    local TextButton5 = TextButton

    TextButton5.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
    TextButton.BorderSizePixel = 0
    TextButton.ZIndex = 33

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = TextButton
    UIKit.Stroke(TextButton, 3, Color3.new(0, 0, 0))
    TextButton.Parent = v68
    v2 = UIKit.Frame({
        Name = "Fill",
        ZIndex = 34,
        Parent = TextButton,
        Size = UDim2.fromScale(0.5, 1),
        Color = Colors.BlueA,
        Gradient = {
            Colors.BlueA,
            Colors.BlueB,
            90
        }
    })

    local UICorner2 = Instance.new("UICorner")

    UICorner2.CornerRadius = UDim.new(0.5, 0)
    UICorner2.Parent = v2

    local v70 = UIKit.Frame({
        Name = "Shine",
        Transparency = 0.7,
        ZIndex = 35,
        Parent = v2,
        Size = UDim2.fromScale(1, 0.4),
        Position = UDim2.fromScale(0, 0.1),
        Color = Color3.new(1, 1, 1)
    })
    local UICorner3 = Instance.new("UICorner")

    UICorner3.CornerRadius = UDim.new(0.5, 0)
    UICorner3.Parent = v70
    v8 = UIKit.Frame({
        Name = "Ticks",
        Transparency = 1,
        ZIndex = 36,
        Parent = TextButton
    })
    v3 = UIKit.Frame({
        Name = "Knob",
        Stroke = 3,
        ZIndex = 38,
        Parent = TextButton,
        Size = UDim2.fromScale(1.7, 1.7),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Color3.new(1, 1, 1)
    })

    local v71 = v3

    v71.SizeConstraint = Enum.SizeConstraint.RelativeYY

    local UICorner4 = Instance.new("UICorner")

    UICorner4.CornerRadius = UDim.new(0.5, 0)
    UICorner4.Parent = v3
    UIKit.Gradient(v3, Color3.new(1, 1, 1), Color3.fromRGB(200, 210, 225), 90)

    local v72 = UIKit.Frame({
        Name = "Dot",
        ZIndex = 39,
        Parent = v3,
        Size = UDim2.fromScale(0.42, 0.42),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Colors.BlueB
    })
    local UICorner5 = Instance.new("UICorner")

    UICorner5.CornerRadius = UDim.new(0.5, 0)
    UICorner5.Parent = v72
    UIScale2 = Instance.new("UIScale")
    UIScale2.Parent = v3
    UIKit.Text({
        Name = "Min",
        Text = "MIN",
        ZIndex = 33,
        Stroke = 2,
        Parent = v68,
        Size = UDim2.fromScale(0.1, 0.1),
        Position = UDim2.fromScale(0.07, 0.62),
        Color = Color3.fromRGB(170, 176, 192),
        XAlign = Enum.TextXAlignment.Left
    })
    UIKit.Text({
        Name = "MaxText",
        Text = "MAX",
        ZIndex = 33,
        Stroke = 2,
        Parent = v68,
        Size = UDim2.fromScale(0.1, 0.1),
        Position = UDim2.fromScale(0.93, 0.62),
        AnchorPoint = Vector2.new(1, 0),
        Color = Color3.fromRGB(170, 176, 192),
        XAlign = Enum.TextXAlignment.Right
    })
    v5 = UIKit.Text({
        Name = "Area",
        Text = "",
        ZIndex = 33,
        Stroke = 3,
        Rich = true,
        Parent = v68,
        Size = UDim2.fromScale(0.6, 0.17),
        Position = UDim2.fromScale(0.07, 0.76),
        XAlign = Enum.TextXAlignment.Left
    })
    v6 = UIKit.Text({
        Name = "Hint",
        Text = "Train to get more power!",
        ZIndex = 40,
        Stroke = 3,
        Parent = v68,
        Size = UDim2.fromScale(0.6, 0.13),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Colors.YellowA
    })
    v7 = UIKit.Button({
        Name = "MaxButton",
        Text = "MAX",
        ZIndex = 34,
        Parent = v68,
        Size = UDim2.fromScale(0.2, 0.19),
        Position = UDim2.fromScale(0.93, 0.95),
        AnchorPoint = Vector2.new(1, 1),
        Colors = {
            Colors.GreenA,
            Colors.GreenB
        },
        OnClick = function() -- OnClick | line: 257
            -- upvalues: LevelConfig (copy), Remotes (copy), DataController (copy), UIKit (copy), v3 (ref), n1 (ref), v11 (ref), render (copy)
            local v73 = DataController:Get("Level") or 1
            local v74 = LevelConfig.ThrowPowerForLevel(v73)

            math.min(LevelConfig.MinThrowPower, v74)

            local v75 = DataController:Get("Level") or 1
            local v76 = LevelConfig.ThrowPowerForLevel(v75)
            local v77 = math.min(LevelConfig.MinThrowPower, v76)
            local v80 = math.clamp(math.floor(v74 + 0.5), v77, v76)

            if v80 ~= n1 then
                n1 = v80
                render()
            end

            local v81 = DataController:Get("Level") or 1
            local v82 = LevelConfig.ThrowPowerForLevel(v81)

            math.min(LevelConfig.MinThrowPower, v82)

            local v83 = if v82 <= n1 then 0 else n1

            if v83 ~= v11 then
                v11 = v83
                task.spawn(function() -- line: 120
                    -- upvalues: v83 (copy), Remotes (copy), v11 (ref)
                    if not Remotes.Invoke("Player_SetThrowPower", v83).Ok then
                        v11 = nil
                    end
                end)
            end

            UIKit.Punch(v3, 0.3, 0.4)
        end
    })

    local function startDrag(p5) -- line: 265
        -- upvalues: TweenService (copy), LevelConfig (copy), DataController (copy), TextButton (ref), UIScale2 (ref), v9 (ref), v10 (ref), setValue (copy)
        if not v9 then
            return
        end

        v10 = true
        TweenService:Create(UIScale2, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1.2
        }):Play()

        local X = p5.Position.X
        local v84 = DataController:Get("Level") or 1
        local v85 = LevelConfig.ThrowPowerForLevel(v84)
        local v86 = math.min(LevelConfig.MinThrowPower, v85)
        local v89 = math.clamp((X - TextButton.AbsolutePosition.X) / math.max(TextButton.AbsoluteSize.X, 1), 0, 1)

        if not (v89 >= 0.985) then
            v85 = v86 + v89 * (v85 - v86)
        end

        setValue(v85, true)
    end

    TextButton.InputBegan:Connect(function(p6) -- line: 271
        -- upvalues: startDrag (copy)
        if p6.UserInputType == Enum.UserInputType.MouseButton1 or p6.UserInputType == Enum.UserInputType.Touch then
            startDrag(p6)
        end
    end)
    v3.InputBegan:Connect(function(p7) -- line: 276
        -- upvalues: startDrag (copy)
        if p7.UserInputType == Enum.UserInputType.MouseButton1 or p7.UserInputType == Enum.UserInputType.Touch then
            startDrag(p7)
        end
    end)
    UserInputService.InputChanged:Connect(function(p8) -- line: 281
        -- upvalues: LevelConfig (copy), DataController (copy), TextButton (ref), v10 (ref), setValue (copy)
        if not v10 or p8.UserInputType ~= Enum.UserInputType.MouseMovement and p8.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local X = p8.Position.X
        local v90 = DataController:Get("Level") or 1
        local v91 = LevelConfig.ThrowPowerForLevel(v90)
        local v92 = math.min(LevelConfig.MinThrowPower, v91)
        local v95 = math.clamp((X - TextButton.AbsolutePosition.X) / math.max(TextButton.AbsoluteSize.X, 1), 0, 1)

        if not (v95 >= 0.985) then
            v91 = v92 + v95 * (v91 - v92)
        end

        setValue(v91, true)
    end)
    UserInputService.InputEnded:Connect(function(p9) -- line: 286
        -- upvalues: TweenService (copy), LevelConfig (copy), Remotes (copy), DataController (copy), Sounds (copy), UIScale2 (ref), v10 (ref), n1 (ref), v11 (ref)
        if not v10 or p9.UserInputType ~= Enum.UserInputType.MouseButton1 and p9.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        v10 = false
        TweenService:Create(UIScale2, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
            Scale = 1
        }):Play()
        Sounds.Play("ButtonClick", {
            Volume = 0.35
        })

        local v96 = DataController:Get("Level") or 1
        local v97 = LevelConfig.ThrowPowerForLevel(v96)

        math.min(LevelConfig.MinThrowPower, v97)

        local v98 = if v97 <= n1 then 0 else n1

        if v98 == v11 then
            return
        end

        v11 = v98
        task.spawn(function() -- line: 120
            -- upvalues: v98 (copy), Remotes (copy), v11 (ref)
            if not Remotes.Invoke("Player_SetThrowPower", v98).Ok then
                v11 = nil
            end
        end)
    end)
    v3.MouseEnter:Connect(function() -- line: 294
        -- upvalues: TweenService (copy), UIScale2 (ref), v10 (ref)
        if not v10 then
            TweenService:Create(UIScale2, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Scale = 1.12
            }):Play()
        end
    end)
    v3.MouseLeave:Connect(function() -- line: 297
        -- upvalues: TweenService (copy), UIScale2 (ref), v10 (ref)
        if not v10 then
            TweenService:Create(UIScale2, TweenInfo.new(0.12), {
                Scale = 1
            }):Play()
        end
    end)
    UserInputService.InputBegan:Connect(function(p10, p11) -- line: 301
        -- upvalues: t1 (copy), v1 (ref), v9 (ref), v10 (ref)
        if not v9 or p11 or v10 or p10.UserInputType ~= Enum.UserInputType.MouseButton1 and p10.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local X, Y = p10.Position.X, p10.Position.Y
        local AbsolutePosition, AbsoluteSize = v1.AbsolutePosition, v1.AbsoluteSize

        if X < AbsolutePosition.X or AbsolutePosition.X + AbsoluteSize.X < X or Y < AbsolutePosition.Y or AbsolutePosition.Y + AbsoluteSize.Y < Y then
            t1.Close()
        end
    end)
end

function t1.Init() -- line: 314
    -- upvalues: RunService (copy), LevelConfig (copy), DataController (copy), HUDController (copy), ClientState (copy), t1 (copy), v9 (ref), v10 (ref), n1 (ref), render (copy), buildTicks (copy), placePanel (copy), build (copy)
    build()
    HUDController.PowerSettingsRequested:Connect(t1.Toggle)
    HUDController.StatsReady:Connect(placePanel)
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(placePanel)
    DataController:Observe("Level", function() -- line: 319
        -- upvalues: LevelConfig (copy), DataController (copy), v9 (ref), v10 (ref), n1 (ref), render (copy), buildTicks (copy)
        if not v9 or v10 then
            return
        end

        local v101 = DataController:Get("Level") or 1

        n1 = LevelConfig.EffectiveThrowPower(v101, DataController:Get("ThrowPower"))
        buildTicks()
        render()
    end)
    RunService.Heartbeat:Connect(function() -- line: 327
        -- upvalues: ClientState (copy), t1 (copy), v9 (ref)
        if v9 and ClientState.Busy then
            t1.Close()
        end
    end)
end

return t1
