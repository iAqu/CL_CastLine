-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local v1 = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local v2 = TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v3 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local LocalPlayer = Players.LocalPlayer
local v4, connection, Scale, tween
local t1 = {}

local function gui() -- line: 33
    -- upvalues: LocalPlayer (copy), v4 (ref)
    if v4 and v4.Parent then
        return v4
    end

    local v5 = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ShootingStarUI", 30)

    assert(v5 and v5:IsA("ScreenGui"), "PlayerGui.ShootingStarUI is missing")
    v5.Enabled = true
    v4 = v5

    return v5
end

local function child(p1) -- line: 44
    -- upvalues: LocalPlayer (copy), v4 (ref)
    local v7

    if v4 and v4.Parent then
        v7 = v4
    else
        v7 = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ShootingStarUI", 30)
        assert(v7 and v7:IsA("ScreenGui"), "PlayerGui.ShootingStarUI is missing")
        v7.Enabled = true
        v4 = v7
    end

    local v9 = v7:FindFirstChild(p1)

    assert(v9 and v9:IsA("GuiObject"), (("ShootingStarUI.%* is missing"):format(p1)))

    return v9
end

local function setText(p2, p3, p4) -- line: 50
    local v12 = p2:FindFirstChild(p3, true)

    if v12 and v12:IsA("TextLabel") then
        v12.Text = p4
    end
end

local function clock(p5) -- line: 57
    local v14 = math.max(0, (math.floor(p5)))

    return string.format("%d:%02d", v14 // 60, v14 % 60)
end

local function scaleOf(p6) -- line: 62
    local UIScale = p6:FindFirstChildOfClass("UIScale")

    if UIScale then
        return UIScale
    end

    local UIScale2 = Instance.new("UIScale")

    UIScale2.Parent = p6

    return UIScale2
end

function t1.Bars(p7) -- line: 76
    -- upvalues: TweenService (copy), v1 (copy), LocalPlayer (copy), v4 (ref)
    local v15

    if v4 and v4.Parent then
        v15 = v4
    else
        v15 = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ShootingStarUI", 30)
        assert(v15 and v15:IsA("ScreenGui"), "PlayerGui.ShootingStarUI is missing")
        v15.Enabled = true
        v4 = v15
    end

    local TopBar = v15:FindFirstChild("TopBar")

    assert(TopBar and TopBar:IsA("GuiObject"), "ShootingStarUI.TopBar is missing")

    local v18

    if v4 and v4.Parent then
        v18 = v4
    else
        v18 = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ShootingStarUI", 30)
        assert(v18 and v18:IsA("ScreenGui"), "PlayerGui.ShootingStarUI is missing")
        v18.Enabled = true
        v4 = v18
    end

    local BottomBar = v18:FindFirstChild("BottomBar")

    assert(BottomBar and BottomBar:IsA("GuiObject"), "ShootingStarUI.BottomBar is missing")
    TopBar.Visible = true
    BottomBar.Visible = true

    local Scale = TopBar.Size.Y.Scale

    TweenService:Create(TopBar, v1, {
        Position = UDim2.fromScale(0.5, if p7 then 0 else -Scale)
    }):Play()
    TweenService:Create(BottomBar, v1, {
        Position = UDim2.fromScale(0.5, if p7 then 1 else 1 + Scale)
    }):Play()
end

function t1.Caption(p8) -- line: 90
    -- upvalues: TweenService (copy), v2 (copy), v3 (copy), LocalPlayer (copy), v4 (ref)
    local v21

    if v4 and v4.Parent then
        v21 = v4
    else
        v21 = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ShootingStarUI", 30)
        assert(v21 and v21:IsA("ScreenGui"), "PlayerGui.ShootingStarUI is missing")
        v21.Enabled = true
        v4 = v21
    end

    local Caption = v21:FindFirstChild("Caption")

    assert(Caption and Caption:IsA("GuiObject"), "ShootingStarUI.Caption is missing")

    local UIScale = Caption:FindFirstChildOfClass("UIScale")

    if not UIScale then
        UIScale = Instance.new("UIScale")
        UIScale.Parent = Caption
    end

    if p8 then
        Caption.Visible = true
        Caption.GroupTransparency = 1
        UIScale.Scale = 1.25
        TweenService:Create(Caption, v3, {
            GroupTransparency = 0
        }):Play()
        TweenService:Create(UIScale, v2, {
            Scale = 1
        }):Play()
    else
        local tween = TweenService:Create(Caption, v3, {
            GroupTransparency = 1
        })

        tween:Play()
        tween.Completed:Once(function() -- line: 102
            -- upvalues: Caption (copy)
            if Caption.GroupTransparency >= 1 then
                Caption.Visible = false
            end
        end)
    end
end

function t1.Objective(p9) -- line: 110
    -- upvalues: TweenService (copy), v1 (copy), v2 (copy), LocalPlayer (copy), v4 (ref), Scale (ref)
    local v24

    if v4 and v4.Parent then
        v24 = v4
    else
        v24 = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ShootingStarUI", 30)
        assert(v24 and v24:IsA("ScreenGui"), "PlayerGui.ShootingStarUI is missing")
        v24.Enabled = true
        v4 = v24
    end

    local Objective = v24:FindFirstChild("Objective")

    assert(Objective and Objective:IsA("GuiObject"), "ShootingStarUI.Objective is missing")

    if Scale == nil then
        Scale = Objective.Position.Y.Scale
    end

    local Scale2 = Objective.Position.X.Scale

    if p9 then
        Objective.Visible = true
        Objective.Position = UDim2.fromScale(Scale2, -0.25)
        TweenService:Create(Objective, v2, {
            Position = UDim2.fromScale(Scale2, Scale)
        }):Play()
    else
        local tween = TweenService:Create(Objective, v1, {
            Position = UDim2.fromScale(Scale2, -0.25)
        })

        tween:Play()
        tween.Completed:Once(function() -- line: 129
            -- upvalues: Objective (copy)
            Objective.Visible = false
        end)
    end
end

function t1.Progress(p10, p11, p12) -- line: 135
    -- upvalues: TweenService (copy), v2 (copy), LocalPlayer (copy), v4 (ref)
    local v27

    if v4 and v4.Parent then
        v27 = v4
    else
        v27 = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ShootingStarUI", 30)
        assert(v27 and v27:IsA("ScreenGui"), "PlayerGui.ShootingStarUI is missing")
        v27.Enabled = true
        v4 = v27
    end

    local Objective = v27:FindFirstChild("Objective")

    assert(Objective and Objective:IsA("GuiObject"), "ShootingStarUI.Objective is missing")

    local v30 = Objective:FindFirstChild("Bar", true)

    if v30 and v30:IsA("GuiObject") then
        TweenService:Create(v30, v2, {
            Size = UDim2.fromScale(math.clamp(p10, 0.04, 1), v30.Size.Y.Scale)
        }):Play()
    end

    local v31

    if p12 then
        v31 = p12
    else
        local v33 = math.max(0, (math.floor(p11)))

        v31 = ("FIND THE LITTLE STAR  -  %*"):format((string.format("%d:%02d", v33 // 60, v33 % 60)))
    end

    local v34 = Objective:FindFirstChild("Progress", true)

    if v34 and v34:IsA("TextLabel") then
        v34.Text = v31
    end
end

function t1.Border(p13) -- line: 146
    -- upvalues: LocalPlayer (copy), v4 (ref), tween (ref)
    local v35

    if v4 and v4.Parent then
        v35 = v4
    else
        v35 = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ShootingStarUI", 30)
        assert(v35 and v35:IsA("ScreenGui"), "PlayerGui.ShootingStarUI is missing")
        v35.Enabled = true
        v4 = v35
    end

    local HoldBorder = v35:FindFirstChild("HoldBorder")

    assert(HoldBorder and HoldBorder:IsA("GuiObject"), "ShootingStarUI.HoldBorder is missing")

    if tween then
        tween:Cancel()
        tween = nil
    end

    HoldBorder.Visible = p13 > 0.01
    HoldBorder.ImageTransparency = 1 - math.clamp(p13, 0, 1) * 0.35

    local UIGradient = HoldBorder:FindFirstChildOfClass("UIGradient")

    if not UIGradient then
        return
    end

    UIGradient.Offset = Vector2.new(math.sin(os.clock() * 2.2) * 0.12, 0)
end

function t1.BorderFade() -- line: 160
    -- upvalues: TweenService (copy), LocalPlayer (copy), v4 (ref), tween (ref)
    local v39

    if v4 and v4.Parent then
        v39 = v4
    else
        v39 = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ShootingStarUI", 30)
        assert(v39 and v39:IsA("ScreenGui"), "PlayerGui.ShootingStarUI is missing")
        v39.Enabled = true
        v4 = v39
    end

    local HoldBorder = v39:FindFirstChild("HoldBorder")

    assert(HoldBorder and HoldBorder:IsA("GuiObject"), "ShootingStarUI.HoldBorder is missing")

    if tween then
        tween:Cancel()
    end

    local tween2 = TweenService:Create(HoldBorder, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        ImageTransparency = 1
    })

    tween = tween2
    tween2:Play()
    tween2.Completed:Once(function(p14) -- line: 172
        -- upvalues: HoldBorder (copy), tween (ref)
        if p14 == Enum.PlaybackState.Completed then
            HoldBorder.Visible = false
            tween = nil
        end
    end)
end

function t1.Pulse() -- line: 180
    -- upvalues: TweenService (copy), v2 (copy), LocalPlayer (copy), v4 (ref)
    local v42

    if v4 and v4.Parent then
        v42 = v4
    else
        v42 = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ShootingStarUI", 30)
        assert(v42 and v42:IsA("ScreenGui"), "PlayerGui.ShootingStarUI is missing")
        v42.Enabled = true
        v4 = v42
    end

    local Objective = v42:FindFirstChild("Objective")

    assert(Objective and Objective:IsA("GuiObject"), "ShootingStarUI.Objective is missing")

    local UIScale = Objective:FindFirstChildOfClass("UIScale")

    if not UIScale then
        UIScale = Instance.new("UIScale")
        UIScale.Parent = Objective
    end

    UIScale.Scale = 1.12
    TweenService:Create(UIScale, v2, {
        Scale = 1
    }):Play()
end

function t1.Waypoint(p15) -- line: 186
    -- upvalues: RunService (copy), Workspace (copy), LocalPlayer (copy), v4 (ref), connection (ref)
    if connection then
        connection:Disconnect()
        connection = nil
    end

    local v45

    if v4 and v4.Parent then
        v45 = v4
    else
        v45 = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ShootingStarUI", 30)
        assert(v45 and v45:IsA("ScreenGui"), "PlayerGui.ShootingStarUI is missing")
        v45.Enabled = true
        v4 = v45
    end

    local Waypoint = v45:FindFirstChild("Waypoint")

    assert(Waypoint and Waypoint:IsA("GuiObject"), "ShootingStarUI.Waypoint is missing")

    if p15 ~= nil then
        local Arrow = Waypoint:FindFirstChild("Arrow")

        connection = RunService.RenderStepped:Connect(function() -- line: 197
            -- upvalues: p15 (copy), Waypoint (copy), Arrow (copy), Workspace (copy), LocalPlayer (copy)
            local CurrentCamera = Workspace.CurrentCamera
            local v48 = p15()

            if v48 == nil or CurrentCamera == nil or CurrentCamera.CameraType == Enum.CameraType.Scriptable then
                Waypoint.Visible = false

                return
            end

            local v49 = v48 + Vector3.new(0, 11, 0)
            local ViewportSize = CurrentCamera.ViewportSize
            local v50, v51 = CurrentCamera:WorldToViewportPoint(v49)
            local v52 = v50.X / ViewportSize.X
            local v53 = v50.Y / ViewportSize.Y
            local v54 = not v51

            if not v54 then
                v54 = v52 < 0.07 or v52 > 0.9299999999999999 or v53 < 0.07 or v53 > 0.9299999999999999
            end

            if v54 then
                local v55 = Vector2.new(v52 - 0.5, v53 - 0.5)

                if v50.Z < 0 then
                    v55 = -v55
                end

                if v55.Magnitude < 0.001 then
                    v55 = Vector2.new(0, 1)
                end

                local v58 = 0.43 / math.max(math.abs(v55.X), (math.abs(v55.Y)))

                v52 = 0.5 + v55.X * v58
                v53 = 0.5 + v55.Y * v58

                if Arrow then
                    Arrow.Visible = true
                    Arrow.Rotation = math.deg((math.atan2(v55.Y, v55.X))) + 90
                end
            elseif Arrow then
                Arrow.Visible = false
            end

            Waypoint.Position = UDim2.fromScale(v52, v53)
            Waypoint.Visible = true

            local Character = LocalPlayer.Character
            local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

            if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                local v60 = ("%*m"):format((math.floor((HumanoidRootPart.Position - v48).Magnitude)))
                local v61 = Waypoint:FindFirstChild("Distance", true)

                if v61 and v61:IsA("TextLabel") then
                    v61.Text = v60
                end
            end
        end)
    else
        Waypoint.Visible = false
    end
end

function t1.Reward(p16) -- line: 243
    -- upvalues: RunService (copy), TweenService (copy), v3 (copy), LocalPlayer (copy), v4 (ref)
    local v62

    if v4 and v4.Parent then
        v62 = v4
    else
        v62 = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ShootingStarUI", 30)
        assert(v62 and v62:IsA("ScreenGui"), "PlayerGui.ShootingStarUI is missing")
        v62.Enabled = true
        v4 = v62
    end

    local Reward = v62:FindFirstChild("Reward")

    assert(Reward and Reward:IsA("GuiObject"), "ShootingStarUI.Reward is missing")

    local UIScale = Reward:FindFirstChildOfClass("UIScale")

    if not UIScale then
        UIScale = Instance.new("UIScale")
        UIScale.Parent = Reward
    end

    local v65 = if p16 == 1 then "+1 STAR" else ("+%* STARS"):format(p16)
    local v66 = Reward:FindFirstChild("Amount", true)

    if v66 and v66:IsA("TextLabel") then
        v66.Text = v65
    end

    Reward.Visible = true
    Reward.GroupTransparency = 0
    UIScale.Scale = 0.3
    TweenService:Create(UIScale, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play()

    local Burst = Reward:FindFirstChild("Burst")
    local connection = if Burst and Burst:IsA("GuiObject") then RunService.RenderStepped:Connect(function(p17) -- line: 258
        -- upvalues: Burst (copy)
        Burst.Rotation += p17 * 40
    end) else nil

    task.delay(2.6, function() -- line: 262
        -- upvalues: Reward (copy), UIScale (ref), connection (copy), TweenService (copy), v3 (copy)
        local tween = TweenService:Create(Reward, v3, {
            GroupTransparency = 1
        })

        TweenService:Create(UIScale, v3, {
            Scale = 0.85
        }):Play()
        tween:Play()
        tween.Completed:Once(function() -- line: 266
            -- upvalues: Reward (copy), connection (copy)
            Reward.Visible = false

            if connection then
                connection:Disconnect()
            end
        end)
    end)
end

return t1
