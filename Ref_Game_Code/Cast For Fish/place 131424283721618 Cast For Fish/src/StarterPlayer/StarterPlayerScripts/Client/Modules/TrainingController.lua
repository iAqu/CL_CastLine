-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

game:GetService("TweenService")

local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local GameConfig = require(Shared.GameConfig)
local PlotFrame = require(Shared:WaitForChild("PlotFrame"))
local Dumbbells = require(Shared.Data.Dumbbells)
local NumberFormat = require(Shared.NumberFormat)
local UIKit = require(script.Parent.UIKit)
local DataClient = require(script.Parent.DataClient)
local HUD = require(script.Parent.HUD)
local Toasts = require(script.Parent.Toasts)
local t1 = {
    Active = false,
    CanStart = nil,
    Quiet = nil
}
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = workspace.CurrentCamera
local Colors = UIKit.Colors
local new = Vector3.new
local v1, v2, v3, v4, v5, v6, v7, v8, v9
local n1 = 0
local v10 = false
local v11 = false
local n2 = 0
local v12 = false
local n3 = 0
local n4 = 0
local t2 = {}
local t3 = {}
local v13, v14
local n5 = 0
local v15

local function circleCenter() -- line: 50
    -- upvalues: PlotFrame (copy), LocalPlayer (copy), new (copy)
    local PlotId = LocalPlayer:GetAttribute("PlotId")

    if type(PlotId) ~= "number" then
        return nil
    end

    local v16 = PlotFrame.Plot(PlotId)
    local TrainingSpot = v16 and v16:FindFirstChild("TrainingSpot")
    local Center = TrainingSpot and TrainingSpot:FindFirstChild("Center")

    if not Center then
        return PlotFrame.Of(v16) * Vector3.new(10, 0, -12)
    end

    return (new(Center.Position.X, 0, Center.Position.Z))
end

local function circleFacing() -- line: 64
    -- upvalues: PlotFrame (copy), LocalPlayer (copy)
    local PlotId = LocalPlayer:GetAttribute("PlotId")
    local v17 = if type(PlotId) == "number" then PlotFrame.Plot(PlotId) else nil
    local TrainingSpot = v17 and v17:FindFirstChild("TrainingSpot")

    if TrainingSpot and TrainingSpot:IsA("PVInstance") then
        return TrainingSpot:GetPivot().Rotation
    end

    return CFrame.identity
end

local function getChar() -- line: 74
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local v18, v19

    if Character then
        v18 = Character:FindFirstChild("HumanoidRootPart")
        v19 = Character:FindFirstChildOfClass("Humanoid")
    else
        v19 = Character
        v18 = Character
    end

    if v18 and v19 and v19.Health > 0 then
        return Character, v18, v19
    end

    return nil, nil, nil
end

local function station() -- line: 84
    -- upvalues: LocalPlayer (copy)
    local PlotId = LocalPlayer:GetAttribute("PlotId")
    local World = workspace:FindFirstChild("World")
    local Plots = World and World:FindFirstChild("Plots")
    local v20 = Plots and Plots:FindFirstChild("Plot" .. tostring(PlotId))
    local TrainingSpot = v20 and v20:FindFirstChild("TrainingSpot")

    return TrainingSpot and TrainingSpot:FindFirstChild("Station")
end

local function buildGui() -- line: 94
    -- upvalues: UIKit (copy), t1 (copy), Colors (copy), v1 (ref), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), v7 (ref), v8 (ref), v9 (ref)
    v1 = UIKit.screenGui("Training", 6)
    v1.Enabled = false
    v2 = UIKit.frame(v1, {
        Name = "LevelBar",
        Corner = 16,
        Stroke = 6,
        Size = UDim2.fromOffset(900, 62),
        Position = UDim2.new(0.5, 0, 1, -22),
        AnchorPoint = Vector2.new(0.5, 1),
        Color = Colors.Dark
    })

    local v21 = UIKit.frame(v2, {
        Class = "CanvasGroup",
        Name = "Clip",
        Corner = 12,
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.fromOffset(5, 5),
        Color = Color3.fromRGB(30, 60, 36)
    })

    v3 = UIKit.frame(v21, {
        Name = "Fill",
        Size = UDim2.fromScale(0, 1),
        Color = Color3.fromRGB(90, 175, 255),
        Color2 = Color3.fromRGB(40, 110, 235)
    })
    UIKit.frame(v3, {
        Name = "Shine",
        Transparency = 0.7,
        Size = UDim2.new(1, 0, 0, 8),
        Position = UDim2.fromOffset(0, 5),
        Color = Colors.White
    })
    v4 = UIKit.text(v2, {
        Name = "Level",
        Text = "Level 1",
        TextSize = 36,
        Stroke = 4,
        ZIndex = 3,
        Size = UDim2.fromOffset(400, 44),
        Position = UDim2.new(0, 22, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        XAlign = Enum.TextXAlignment.Left
    })
    v5 = UIKit.text(v2, {
        Name = "XP",
        Text = "0/5",
        TextSize = 36,
        Stroke = 4,
        ZIndex = 3,
        Size = UDim2.fromOffset(300, 44),
        Position = UDim2.new(1, -22, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        XAlign = Enum.TextXAlignment.Right
    })
    v6 = UIKit.button(v1, {
        Name = "Stop",
        Text = "STOP",
        Corner = 14,
        Stroke = 6,
        TextStroke = 4,
        Size = UDim2.fromOffset(210, 74),
        Position = UDim2.new(0.5, 0, 1, -100),
        AnchorPoint = Vector2.new(0.5, 1),
        Color = Colors.Red,
        Color2 = Colors.RedDark,
        OnClick = function() -- OnClick | line: 106
            -- upvalues: t1 (copy)
            t1.Stop()
        end
    })
    v7 = UIKit.frame(v1, {
        Name = "Floaters",
        Transparency = 1
    })
    v9 = UIKit.frame(v1, {
        Name = "Flash",
        Transparency = 1,
        ZIndex = 0,
        Size = UDim2.fromScale(4, 4),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Color3.fromRGB(255, 240, 170)
    })
    v8 = UIKit.frame(v1, {
        Name = "LevelUp",
        Transparency = 1,
        Size = UDim2.fromOffset(900, 170),
        Position = UDim2.new(0.5, 0, 0, 156),
        AnchorPoint = Vector2.new(0.5, 0)
    })

    local v22 = UIKit.text(v8, {
        Name = "Title",
        Text = "LEVEL UP!",
        TextSize = 96,
        Stroke = 8,
        Size = UDim2.new(1, 0, 0, 100),
        StrokeColor = Color3.fromRGB(110, 60, 0)
    })

    v22.TextColor3 = Colors.White
    UIKit.gradient(v22, Color3.fromRGB(255, 240, 110), Color3.fromRGB(255, 170, 30))
    UIKit.text(v8, {
        Name = "Sub",
        Text = "Cast Power +5",
        TextSize = 50,
        Stroke = 6,
        Size = UDim2.new(1, 0, 0, 56),
        Position = UDim2.fromOffset(0, 104),
        Color = Colors.Power,
        StrokeColor = Colors.PowerStroke
    })
    v8.Visible = false
    require(script.Parent.BannerDodge).new(v8)
end

local v23

local function refreshBar(p1) -- line: 124
    -- upvalues: GameConfig (copy), NumberFormat (copy), UIKit (copy), DataClient (copy), v3 (ref), v4 (ref), v5 (ref), v23 (ref)
    local v24 = DataClient.Get("Level") or 1
    local v25 = DataClient.Get("XP") or 0
    local v26 = GameConfig.xpNeeded(v24)
    local v27 = v4

    v27.Text = "Level " .. NumberFormat.commas(v24)

    local v28 = v5

    v28.Text = NumberFormat.abbr((math.floor(v25))) .. "/" .. NumberFormat.abbr(v26)

    local v30 = UDim2.fromScale(math.clamp(v25 / v26, 0, 1), 1)

    if v23 ~= v24 or not p1 then
        local v31 = v3

        if v23 ~= nil then
            local v32 = v23

            if v32 == v24 then
                v31.Size = v30
            else
                v31.Size = UDim2.fromScale(0, 1)
            end
        else
            v31.Size = v30
        end

        if v23 ~= nil and v23 ~= v24 then
            UIKit.pop(v4, 1.3)
        end
    end

    v23 = v24
    UIKit.tween(v3, 0.18, {
        Size = v30
    })
end

local function floatXP(p2) -- line: 141
    -- upvalues: NumberFormat (copy), UIKit (copy), LocalPlayer (copy), CurrentCamera (copy), Colors (copy), v1 (ref), v7 (ref), v8 (ref)
    local Character = LocalPlayer.Character
    local v33 = Character

    if Character then
        v33 = Character:FindFirstChild("HumanoidRootPart")
        Character = Character:FindFirstChildOfClass("Humanoid")
    end

    if not (v33 and Character and Character.Health > 0) then
        v33 = nil
    end

    if v33 then
        local v34, v35 = CurrentCamera:WorldToViewportPoint(v33.Position + Vector3.new(0, 2.6, 0))

        if v35 then
            local Scale = v1.FitScale.Scale
            local v36 = v34.X / Scale + math.random(-150, 150)
            local v39 = math.max(v34.Y / Scale + math.random(-50, 30), v8.Position.Y.Offset + v8.Size.Y.Offset + 25 + 120 + 25)
            local v40 = UIKit.text(v7, {
                Name = "XP",
                TextSize = 44,
                Stroke = 5,
                Text = "+" .. NumberFormat.abbr(p2) .. " XP",
                Size = UDim2.fromOffset(260, 50),
                Position = UDim2.fromOffset(v36, v39),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Color = Colors.Power,
                StrokeColor = Colors.PowerStroke
            })

            v40.Rotation = math.random(-10, 10)
            UIKit.pop(v40, 1.5)

            local UIStroke = v40:FindFirstChildOfClass("UIStroke")

            UIKit.tween(v40, 0.75, {
                Position = UDim2.fromOffset(v36, v39 - 120)
            }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            task.delay(0.4, function() -- line: 160
                -- upvalues: v40 (copy), UIStroke (copy), UIKit (copy)
                UIKit.tween(v40, 0.35, {
                    TextTransparency = 1
                })

                if UIStroke then
                    UIKit.tween(UIStroke, 0.35, {
                        Transparency = 1
                    })
                end
            end)
            game:GetService("Debris"):AddItem(v40, 0.9)
        end
    end
end

local n6 = 0

local function showLevelUp(p3) -- line: 170
    -- upvalues: NumberFormat (copy), UIKit (copy), v8 (ref), v9 (ref), n1 (ref), n5 (ref), n6 (ref)
    n6 += 1

    local v41 = n6

    v8.Sub.Text = "Cast Power +" .. NumberFormat.abbr(p3)

    local Visible = v8.Visible

    v8.Visible = true

    for _, v42 in ipairs({
            v8.Title,
            v8.Sub
        }) do
        v42.TextTransparency = 0
        v42:FindFirstChildOfClass("UIStroke").Transparency = 0
    end

    if Visible then
        UIKit.pop(v8.Sub, 1.15)
    else
        UIKit.pop(v8, 1.6)
        v9.BackgroundTransparency = 0.35
        UIKit.tween(v9, 0.45, {
            BackgroundTransparency = 1
        })
        n1 = 0.3
        n5 = 5
    end

    UIKit.sound("LevelUp")
    task.delay(1.1, function() -- line: 190
        -- upvalues: v41 (copy), UIKit (copy), v8 (ref), n6 (ref)
        if v41 ~= n6 then
            return
        end

        for _, v43 in ipairs({
                v8.Title,
                v8.Sub
            }) do
            UIKit.tween(v43, 0.4, {
                TextTransparency = 1
            })
            UIKit.tween(v43:FindFirstChildOfClass("UIStroke"), 0.4, {
                Transparency = 1
            })
        end

        task.wait(0.45)

        if v41 == n6 then
            v8.Visible = false
        end
    end)
end

local function findJoints(p4) -- line: 207
    local t4 = {}

    local function r15(p5) -- line: 209
        -- upvalues: p4 (copy), t4 (copy)
        local v44 = p4:FindFirstChild(p5 .. "UpperArm")
        local v45 = p4:FindFirstChild(p5 .. "LowerArm")
        local v46 = v44 and v44:FindFirstChild(p5 .. "Shoulder")
        local v47 = v45 and v45:FindFirstChild(p5 .. "Elbow")

        if v46 then
            table.insert(t4, {
                kind = "shoulder",
                joint = v46
            })
        end

        if v47 then
            table.insert(t4, {
                kind = "elbow",
                joint = v47
            })
        end

        return v46 ~= nil
    end

    if not (r15("Right") and r15("Left")) then
        local Torso = p4:FindFirstChild("Torso")
        local v48 = Torso and Torso:FindFirstChild("Right Shoulder")
        local v49 = Torso and Torso:FindFirstChild("Left Shoulder")

        if v48 then
            table.insert(t4, {
                kind = "r6",
                sign = 1,
                joint = v48
            })
        end

        if v49 then
            table.insert(t4, {
                kind = "r6",
                sign = -1,
                joint = v49
            })
        end
    end

    return t4
end

local function hands(p6) -- line: 234
    return p6:FindFirstChild("RightHand") or p6:FindFirstChild("Right Arm"), p6:FindFirstChild("LeftHand") or p6:FindFirstChild("Left Arm")
end

local function boosted() -- line: 241
    local _require = require
    local TrainBonus = script.Parent.TrainBonus
    local ok, result = pcall(_require, TrainBonus)

    if ok then
        ok = result.IsActive ~= nil and result.IsActive()
    end

    return ok
end

local function curlAmount() -- line: 246
    -- upvalues: GameConfig (copy), n3 (ref)
    local _require = require
    local TrainBonus = script.Parent.TrainBonus
    local ok, result = pcall(_require, TrainBonus)

    if ok then
        ok = result.IsActive ~= nil and result.IsActive()
    end

    local v50 = if ok then 2 else 1

    return math.cos(math.min((os.clock() - n3) / GameConfig.REP_INTERVAL * v50, v50 + 0.5) * 3.141592653589793 * 2) * 0.5 + 0.5
end

local t9 = {}

t9.__index = t9
t9.FILL = Color3.fromRGB(255, 150, 30)
t9.OUTLINE = Color3.fromRGB(255, 225, 70)

function t9.new() -- line: 257
    -- upvalues: t9 (copy)
    return (setmetatable({
        Highlight = nil
    }, t9))
end

function t9.Set(p7, p8, p9) -- line: 261
    if p9 and p8 then
        local Highlight = p7.Highlight

        if Highlight then
            if not Highlight.Parent or Highlight.Parent ~= p8 then
                Highlight:Destroy()
                Highlight = Instance.new("Highlight")
                Highlight.Name = "TrainBoost"
                Highlight.FillColor = p7.FILL
                Highlight.OutlineColor = p7.OUTLINE
                Highlight.FillTransparency = 0.45
                Highlight.OutlineTransparency = 0.1
                Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
                Highlight.Parent = p8
                p7.Highlight = Highlight
            end
        else
            Highlight = Instance.new("Highlight")
            Highlight.Name = "TrainBoost"
            Highlight.FillColor = p7.FILL
            Highlight.OutlineColor = p7.OUTLINE
            Highlight.FillTransparency = 0.45
            Highlight.OutlineTransparency = 0.1
            Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
            Highlight.Parent = p8
            p7.Highlight = Highlight
        end

        Highlight.FillTransparency = math.sin(os.clock() * 10) * 0.12 + 0.4
    elseif p7.Highlight then
        p7.Highlight:Destroy()
        p7.Highlight = nil
    end
end

local v55 = t9.new()
local MoveLock = require(script.Parent.MoveLock)
local AutoRotate, Rotation, Position, v56

local function setControls(p10) -- line: 294
    -- upvalues: LocalPlayer (copy), v15 (ref), MoveLock (copy), AutoRotate (ref), Rotation (ref), Position (ref)
    local Character = LocalPlayer.Character
    local v57 = Character

    if Character then
        v57 = Character:FindFirstChild("HumanoidRootPart")
        Character = Character:FindFirstChildOfClass("Humanoid")
    end

    if not (v57 and Character and Character.Health > 0) then
        Character = nil
    end

    if p10 then
        if v15 then
            v15 = nil
            MoveLock.Free("train")

            if Character and AutoRotate ~= nil then
                Character.AutoRotate = AutoRotate
            end

            AutoRotate = nil
            Rotation = nil
            Position = nil
        end
    elseif Character and not v15 then
        v15 = true
        MoveLock.Hold("train")
        AutoRotate = Character.AutoRotate
        Character.AutoRotate = false
    end
end

local v58, connection
local v59 = nil

local function clearProps() -- line: 318
    -- upvalues: t2 (copy), t3 (copy), connection (ref)
    for _, v60 in ipairs(t2) do
        v60:Destroy()
    end

    table.clear(t2)

    for _, v61 in ipairs(t3) do
        if v61.Parent then
            v61.LocalTransparencyModifier = 0
        end
    end

    table.clear(t3)

    if connection then
        connection:Disconnect()
        connection = nil
    end
end

local function setOwnerTag(p11) -- line: 335
    -- upvalues: station (copy)
    local v62 = station()

    v62 = v62 and v62.Parent and v62.Parent.Parent

    local OwnerTag = v62 and v62:FindFirstChild("OwnerTag")
    local BillboardGui = OwnerTag and OwnerTag:FindFirstChildOfClass("BillboardGui")

    if BillboardGui then
        BillboardGui.Enabled = p11
    end
end

local function buildProps() -- line: 345
    -- upvalues: ReplicatedStorage (copy), Dumbbells (copy), DataClient (copy), t1 (copy), t2 (copy), t3 (copy), station (copy), v58 (ref), connection (ref), v59 (ref), clearProps (copy)
    clearProps()
    v59 = DataClient.Get("DumbbellTier") or 0

    local v63 = Dumbbells.List[DataClient.Get("DumbbellTier") or 0]
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local Dumbbells2 = Assets and Assets:FindFirstChild("Dumbbells")
    local v64 = v63 and Dumbbells2 and Dumbbells2:FindFirstChild(v63.id)
    local Held = v64 and v64:FindFirstChild("Held")

    if Held then
        for _ = 1, 2 do
            local clone = Held:Clone()

            clone:ScaleTo(0.62)

            for _, descendant in ipairs(clone:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    descendant.CastShadow = false
                end
            end

            clone.Parent = workspace
            table.insert(t2, clone)
        end
    end

    local v65 = station()

    v58 = v65

    if connection then
        connection:Disconnect()
        connection = nil
    end

    if v65 then
        for _, descendant in ipairs(v65:GetDescendants()) do
            if descendant:IsA("BasePart") and descendant:GetAttribute("Rest") then
                descendant.LocalTransparencyModifier = 1
                table.insert(t3, descendant)
            end
        end

        connection = v65.DescendantAdded:Connect(function(p12) -- line: 380
            -- upvalues: t1 (copy), t3 (copy)
            if t1.Active and p12:IsA("BasePart") and p12:GetAttribute("Rest") then
                p12.LocalTransparencyModifier = 1
                table.insert(t3, p12)
            end
        end)
    end
end

local function showBody(p13) -- line: 389
    for _, descendant in ipairs(p13:GetDescendants()) do
        if (descendant:IsA("BasePart") or descendant:IsA("Decal")) and descendant.LocalTransparencyModifier ~= 0 then
            descendant.LocalTransparencyModifier = 0
        end
    end
end

local function enter() -- line: 398
    -- upvalues: ContextActionService (copy), Remotes (copy), UIKit (copy), HUD (copy), t1 (copy), LocalPlayer (copy), CurrentCamera (copy), new (copy), v1 (ref), v2 (ref), v6 (ref), v11 (ref), n3 (ref), n4 (ref), v13 (ref), v14 (ref), v15 (ref), circleCenter (copy), circleFacing (copy), station (copy), v23 (ref), refreshBar (copy), findJoints (copy), MoveLock (copy), AutoRotate (ref), Rotation (ref), Position (ref), buildProps (copy)
    if t1.Active then
        return
    end

    local Character = LocalPlayer.Character
    local v66, v67

    if Character then
        v66 = Character:FindFirstChild("HumanoidRootPart")
        v67 = Character:FindFirstChildOfClass("Humanoid")
    else
        v67 = Character
        v66 = Character
    end

    if not (v66 and v67 and v67.Health > 0) then
        Character = nil
        v66 = nil
        v67 = nil
    end

    local v68 = circleCenter()

    if not Character or not v68 then
        Remotes.Train:FireServer(false)

        return
    end

    t1.Active = true
    v11 = false
    n4 = 0
    n3 = os.clock()
    UIKit.closeAllWindows()
    HUD.SetMode("training")
    v1.Enabled = true
    v23 = nil
    refreshBar(false)
    UIKit.pop(v2, 0.7)
    UIKit.pop(v6, 0.6)

    local Character2 = LocalPlayer.Character
    local HumanoidRootPart = Character2 and Character2:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character2 and Character2:FindFirstChildOfClass("Humanoid")

    if not (HumanoidRootPart and Humanoid and Humanoid.Health > 0) then
        Humanoid = nil
    end

    if Humanoid and not v15 then
        v15 = true
        MoveLock.Hold("train")
        AutoRotate = Humanoid.AutoRotate
        Humanoid.AutoRotate = false
    end

    v67:Move((Vector3.new(0, 0, 0)))

    local Y = v66.Position.Y

    v66.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    Character:PivotTo(CFrame.new(v68.X, Y, v68.Z) * circleFacing() * CFrame.new(0, 0, -0.4))
    Rotation = v66.CFrame.Rotation
    Position = v66.Position
    v13 = findJoints(Character)
    buildProps()

    local v70 = new(v68.X, Y + 0.6, v68.Z)
    local v71 = circleFacing()

    v14 = CFrame.lookAt(v70 + v71 * Vector3.new(5.6, 3.9, -7), v70 + v71 * Vector3.new(0, 0.3, 1.5))

    local v72 = station()

    v72 = v72 and v72.Parent and v72.Parent.Parent

    local OwnerTag = v72 and v72:FindFirstChild("OwnerTag")
    local BillboardGui = OwnerTag and OwnerTag:FindFirstChildOfClass("BillboardGui")

    if BillboardGui then
        BillboardGui.Enabled = false
    end

    CurrentCamera.CameraType = Enum.CameraType.Scriptable
    UIKit.sound("TrainStart")
    ContextActionService:BindAction("StopTraining", function(_, p15) -- line: 439
        -- upvalues: t1 (copy)
        if p15 == Enum.UserInputState.Begin then
            t1.Stop()
        end

        return Enum.ContextActionResult.Sink
    end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.X)
end

local function exit(p16) -- line: 447
    -- upvalues: ContextActionService (copy), HUD (copy), t1 (copy), LocalPlayer (copy), CurrentCamera (copy), v1 (ref), v7 (ref), n1 (ref), v10 (ref), v13 (ref), v14 (ref), v15 (ref), station (copy), v55 (copy), MoveLock (copy), AutoRotate (ref), Rotation (ref), Position (ref), clearProps (copy)
    if t1.Active then
        t1.Active = false
        v10 = not p16
        ContextActionService:UnbindAction("StopTraining")
        clearProps()
        v13 = nil
        v14 = nil
        v1.Enabled = false
        v7:ClearAllChildren()
        v55:Set(nil, false)
        n1 = 0
        CurrentCamera.CameraType = Enum.CameraType.Custom
        CurrentCamera.FieldOfView = 70

        local v73 = station()

        v73 = v73 and v73.Parent and v73.Parent.Parent

        local OwnerTag = v73 and v73:FindFirstChild("OwnerTag")
        local BillboardGui = OwnerTag and OwnerTag:FindFirstChildOfClass("BillboardGui")

        if BillboardGui then
            BillboardGui.Enabled = true
        end

        local Character = LocalPlayer.Character
        local v74 = Character

        if Character then
            v74 = Character:FindFirstChild("HumanoidRootPart")
            Character = Character:FindFirstChildOfClass("Humanoid")
        end

        if not (v74 and Character and Character.Health > 0) then
            Character = nil
        end

        if v15 then
            v15 = nil
            MoveLock.Free("train")

            if Character and AutoRotate ~= nil then
                Character.AutoRotate = AutoRotate
            end

            AutoRotate = nil
            Rotation = nil
            Position = nil
        end

        HUD.SetMode("normal")
    end
end

function t1.Stop() -- line: 468
    -- upvalues: Remotes (copy), t1 (copy), exit (copy)
    if t1.Active then
        Remotes.Train:FireServer(false)
        exit()
    end
end

function t1.State() -- line: 475
    -- upvalues: t1 (copy), v10 (ref), n4 (ref)
    return (if t1.Active then "training" else "idle") .. "|reps:" .. n4 .. "|mustLeave:" .. tostring(v10)
end

function t1.Init() -- line: 479
    -- upvalues: RunService (copy), Remotes (copy), GameConfig (copy), UIKit (copy), DataClient (copy), HUD (copy), Toasts (copy), t1 (copy), LocalPlayer (copy), CurrentCamera (copy), n1 (ref), v10 (ref), v11 (ref), n2 (ref), v12 (ref), n3 (ref), n4 (ref), t2 (copy), v13 (ref), v14 (ref), n5 (ref), circleCenter (copy), station (copy), buildGui (copy), refreshBar (copy), floatXP (copy), showLevelUp (copy), v55 (copy), Rotation (ref), Position (ref), v56 (ref), v58 (ref), v59 (ref), buildProps (copy), showBody (copy), enter (copy), exit (copy)
    buildGui()
    Remotes.TrainState.OnClientEvent:Connect(function(p17) -- line: 482
        -- upvalues: v11 (ref), enter (copy), exit (copy)
        if p17 then
            enter()
            v11 = true
        else
            exit(not v11)
        end
    end)
    Remotes.TrainRep.OnClientEvent:Connect(function(p18, p19, p20) -- line: 491
        -- upvalues: GameConfig (copy), UIKit (copy), t1 (copy), n3 (ref), n4 (ref), n5 (ref), floatXP (copy), showLevelUp (copy)
        if t1.Active then
            n4 += 1
            n3 = os.clock()
            n5 = 1
            floatXP(p18)
            UIKit.sound(n4 % 2 == 0 and "Rep2" or "Rep1")

            if p19 and p19 > 0 then
                showLevelUp(p20 or p19 * GameConfig.POWER_PER_LEVEL)
            end
        end
    end)
    DataClient.Observe("XP", function() -- line: 505
        -- upvalues: t1 (copy), refreshBar (copy)
        if t1.Active then
            refreshBar(true)
        end
    end)
    DataClient.Observe("Level", function() -- line: 510
        -- upvalues: t1 (copy), refreshBar (copy)
        if t1.Active then
            refreshBar(true)
        end
    end)
    LocalPlayer.CharacterAdded:Connect(function() -- line: 516
        -- upvalues: Remotes (copy), t1 (copy), exit (copy)
        if t1.Active then
            Remotes.Train:FireServer(false)
            exit()
        end
    end)
    RunService.Stepped:Connect(function() -- line: 524
        -- upvalues: GameConfig (copy), t1 (copy), n3 (ref), v13 (ref)
        if not (t1.Active and v13) then
            return
        end

        local _require = require
        local TrainBonus = script.Parent.TrainBonus
        local ok, result = pcall(_require, TrainBonus)

        if ok then
            ok = result.IsActive ~= nil and result.IsActive()
        end

        local v79 = if ok then 2 else 1
        local v83 = math.cos(math.min((os.clock() - n3) / GameConfig.REP_INTERVAL * v79, v79 + 0.5) * 3.141592653589793 * 2) * 0.5 + 0.5

        for _, v84 in ipairs(v13) do
            if v84.joint.Parent then
                if v84.kind == "shoulder" then
                    v84.joint.Transform = CFrame.Angles(math.rad(v83 * 16 + 6), 0, 0)
                elseif v84.kind == "elbow" then
                    v84.joint.Transform = CFrame.Angles(math.rad(v83 * 108 + 12), 0, 0)
                else
                    v84.joint.Transform = CFrame.Angles(0, 0, v84.sign * math.rad(v83 * 95 + 20))
                end
            end
        end
    end)

    local n7 = 0

    RunService.RenderStepped:Connect(function(p21) -- line: 543
        -- upvalues: n7 (ref), Remotes (copy), UIKit (copy), DataClient (copy), HUD (copy), Toasts (copy), t1 (copy), LocalPlayer (copy), CurrentCamera (copy), n1 (ref), v10 (ref), n2 (ref), v12 (ref), t2 (copy), v14 (ref), n5 (ref), circleCenter (copy), station (copy), v55 (copy), Rotation (ref), Position (ref), v56 (ref), v58 (ref), v59 (ref), buildProps (copy), showBody (copy), enter (copy)
        local Character = LocalPlayer.Character
        local v88, v89

        if Character then
            v88 = Character:FindFirstChild("HumanoidRootPart")
            v89 = Character:FindFirstChildOfClass("Humanoid")
        else
            v89 = Character
            v88 = Character
        end

        if not (v88 and v89 and v89.Health > 0) then
            Character = nil
            v88 = nil
        end

        if t1.Active then
            if Character then
                if v14 then
                    CurrentCamera.CameraType = Enum.CameraType.Scriptable
                    CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(v14, 1 - math.exp(-p21 * 7))

                    local v93 = n5

                    n5 = math.max(0, v93 - p21 * 6)
                    CurrentCamera.FieldOfView = 62 - n5 * 1.6

                    if n1 > 0 then
                        n1 = math.max(0, n1 - p21)

                        local v95 = n1 / 0.3 * 0.25

                        CurrentCamera.CFrame *= CFrame.new((math.random() - 0.5) * v95, (math.random() - 0.5) * v95, 0)
                    end
                end

                showBody(Character)

                local _require = require
                local TrainBonus = script.Parent.TrainBonus
                local ok, result = pcall(_require, TrainBonus)

                if ok then
                    ok = result.IsActive ~= nil and result.IsActive()
                end

                v55:Set(Character, ok)

                if Position and v88 and Vector2.new(v88.Position.X - Position.X, v88.Position.Z - Position.Z).Magnitude > 0.5 then
                    v88.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    v88.CFrame = CFrame.new(Position.X, v88.Position.Y, Position.Z) * (Rotation or v88.CFrame.Rotation)
                end

                if Rotation and v88 and v88.CFrame.LookVector:Dot(Rotation.LookVector) < 0.999 then
                    v88.CFrame = CFrame.new(v88.Position) * Rotation
                end

                local v96 = station() == v58

                v96 = v96 and v59 == (DataClient.Get("DumbbellTier") or 0)

                if not v96 then
                    buildProps()
                end

                local v98 = Character:FindFirstChild("RightHand") or Character:FindFirstChild("Right Arm")
                local v99 = Character:FindFirstChild("LeftHand") or Character:FindFirstChild("Left Arm")
                local v100 = CFrame.new(0, -0.2, 0)

                if t2[1] and v98 then
                    t2[1]:PivotTo(v98.CFrame * (if v98.Name == "RightHand" then v100 else CFrame.new(0, -1.2, 0)))
                end

                if t2[2] and v99 then
                    t2[2]:PivotTo(v99.CFrame * (if v99.Name == "LeftHand" then v100 else CFrame.new(0, -1.2, 0)))
                end
            else
                t1.Stop()
            end
        else
            n7 += p21

            if not (n7 < 0.12) then
                n7 = 0

                local v103 = circleCenter()

                if v88 and v103 and DataClient.IsReady() then
                    local v104 = Vector2.new(v88.Position.X - v103.X, v88.Position.Z - v103.Z)
                    local v105 = if v56 and (v104 - v56).Magnitude < 20 then v56 else v104

                    v56 = v104

                    local v106 = v104 - v105

                    if (v105 + v106 * (if v106.Magnitude > 0 then math.clamp(-v105:Dot(v106) / v106:Dot(v106), 0, 1) else 1)).Magnitude <= 4.3 and math.abs(v88.Position.Y - v103.Y) < 12 then
                        if not v10 and HUD.GetMode() == "normal" and not UIKit.anyWindowOpen() and (not t1.CanStart or t1.CanStart()) then
                            if (DataClient.Get("DumbbellTier") or 0) < 1 then
                                if not v12 and (not t1.Quiet or not t1.Quiet()) then
                                    v12 = true
                                    Toasts.Show("error", "Buy a dumbbell first! Use the yellow pad.")
                                end
                            elseif os.clock() - n2 > 1 then
                                n2 = os.clock()
                                Remotes.Train:FireServer(true)
                                enter()
                            end
                        end
                    else
                        v10 = false
                        v12 = false
                    end
                else
                    v56 = nil
                end
            end
        end
    end)
end

return t1
