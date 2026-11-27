-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Economy = require(ReplicatedStorage.Shared.Economy)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local SubArena = require(ReplicatedStorage.Shared.SubArena)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Style = require(script.Parent.Parent.Shop.Style)
local Controls = require(script.Parent.Parent.Character.Controls)
local Poses = require(script.Parent.Parent.Character.Poses)
local BossJuice = require(script.Parent.Parent.Boss.BossJuice)
local t1 = {}
local LocalPlayer = Players.LocalPlayer
local v1 = false
local HumanoidRootPart, Humanoid, Attachment, LinearVelocity, AlignOrientation
local t2 = {}

t2[1] = Vector3.new(0, 0, 0)

local n1 = 0
local n2 = 0
local n3 = -100
local n4 = 0
local v2 = Vector3.new(0, 0, 0)
local n5 = 0
local t3 = {
    up = false,
    down = false
}
local t4, ScreenGui, result, v3, v4

local function yawOf(p1) -- line: 56
    return (math.atan2(-p1.X, -p1.Z))
end

local function angleTo(p2, p3, p4) -- line: 60
    return p2 + math.clamp((p3 - p2 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793, -p4, p4)
end

function t1.isOn() -- line: 65
    -- upvalues: v1 (ref)
    return v1
end

function t1.bind(p5, p6) -- line: 70
    -- upvalues: v3 (ref), v4 (ref)
    v3 = p5
    v4 = p6
end

function t1.boost() -- line: 74
    -- upvalues: Economy (copy), Remotes (copy), UIUtil (copy), BossJuice (copy), v1 (ref), HumanoidRootPart (ref), Humanoid (ref), n3 (ref), n4 (ref), v2 (ref), t3 (copy)
    local v9

    if not v1 or os.clock() - n3 < Economy.SubBoss.BoostCooldown then
        return
    else
        n3 = os.clock()
        v9 = if Humanoid then Humanoid.MoveDirection else Vector3.new(0, 0, 0)
    end

    if v9.Magnitude < 0.1 and HumanoidRootPart then
        v9 = HumanoidRootPart.CFrame.LookVector
    end

    local v11 = (if t3.up then 1 else 0) - (if t3.down then 1 else 0)
    local v13 = Vector3.new(v9.X, v11 * 0.6, v9.Z)

    v2 = if v13.Magnitude > 0.01 then v13.Unit else Vector3.new(0, 0, -1)
    n4 = os.clock() + 0.35
    Remotes.SubBoss:FireServer("Boost")
    UIUtil.sound("Whoosh", 0.7, 0.8)
    UIUtil.sound("BubbleSwell", 0.4, 1.4)
    BossJuice.fovPunch(-6, 0.4)
end

function t1.knock(p7) -- line: 94
    -- upvalues: HumanoidRootPart (ref), t2 (copy), n5 (ref)
    if not HumanoidRootPart then
        return
    end

    local v14 = if p7 then HumanoidRootPart.Position - p7 else Vector3.new(math.random() - 0.5, 0, math.random() - 0.5)
    local v17 = Vector3.new(v14.X, 0, v14.Z)

    t2[1] = (if v17.Magnitude > 0.01 then v17.Unit else Vector3.new(1, 0, 0)) * 70 + Vector3.new(0, 22, 0)
    n5 = 1
end

function t1.start(p8) -- line: 106
    -- upvalues: UserInputService (copy), Controls (copy), Poses (copy), LocalPlayer (copy), v1 (ref), HumanoidRootPart (ref), Humanoid (ref), Attachment (ref), LinearVelocity (ref), AlignOrientation (ref), t2 (copy), n1 (ref), n2 (ref), n5 (ref), t4 (ref), ScreenGui (ref)
    local Character = LocalPlayer.Character

    HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if not HumanoidRootPart or not Humanoid or v1 then
        return
    end

    v1 = true
    Controls.lock("SubBoss", nil, true)
    Humanoid.PlatformStand = true
    HumanoidRootPart.Anchored = false
    HumanoidRootPart.CFrame = p8
    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    t2[1] = Vector3.new(0, 0, 0)

    local LookVector = p8.LookVector

    n1 = math.atan2(-LookVector.X, -LookVector.Z)
    n2 = 0
    n5 = 0

    local Attachment2 = Instance.new("Attachment")

    Attachment2.Name = "SubPilot"
    Attachment2.Parent = HumanoidRootPart

    local LinearVelocity2 = Instance.new("LinearVelocity")

    LinearVelocity2.Name = "SubPilotMove"
    LinearVelocity2.Attachment0 = Attachment2
    LinearVelocity2.RelativeTo = Enum.ActuatorRelativeTo.World
    LinearVelocity2.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
    LinearVelocity2.MaxForce = 1e999
    LinearVelocity2.VectorVelocity = Vector3.new(0, 0, 0)
    LinearVelocity2.Parent = HumanoidRootPart

    local AlignOrientation2 = Instance.new("AlignOrientation")

    AlignOrientation2.Name = "SubPilotTurn"
    AlignOrientation2.Mode = Enum.OrientationAlignmentMode.OneAttachment
    AlignOrientation2.Attachment0 = Attachment2
    AlignOrientation2.MaxTorque = 1e999
    AlignOrientation2.Responsiveness = 40
    AlignOrientation2.CFrame = p8.Rotation
    AlignOrientation2.Parent = HumanoidRootPart
    Attachment = Attachment2
    LinearVelocity = LinearVelocity2
    AlignOrientation = AlignOrientation2
    Poses.play("Drive")
    t4 = {
        LocalPlayer.CameraMinZoomDistance,
        LocalPlayer.CameraMaxZoomDistance
    }

    local v21 = t4[2]

    LocalPlayer.CameraMaxZoomDistance = math.max(v21, 110)
    LocalPlayer.CameraMinZoomDistance = 40

    local CurrentCamera = workspace.CurrentCamera

    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.CameraSubject = Humanoid
    ScreenGui.Enabled = UserInputService.TouchEnabled
end

function t1.stop() -- line: 152
    -- upvalues: Controls (copy), Poses (copy), LocalPlayer (copy), v1 (ref), HumanoidRootPart (ref), Humanoid (ref), Attachment (ref), LinearVelocity (ref), AlignOrientation (ref), t3 (copy), t4 (ref), ScreenGui (ref)
    if not v1 then
        return
    end

    v1 = false
    ScreenGui.Enabled = false
    t3.up = false
    t3.down = false

    for _, v22 in { Attachment, LinearVelocity, AlignOrientation } do
        if v22 then
            v22:Destroy()
        end
    end

    Attachment = nil
    LinearVelocity = nil
    AlignOrientation = nil

    if Humanoid and Humanoid.Parent then
        Humanoid.PlatformStand = false
        Humanoid.CameraOffset = Vector3.new(0, 0, 0)
    end

    if t4 then
        LocalPlayer.CameraMinZoomDistance = t4[1]
        LocalPlayer.CameraMaxZoomDistance = t4[2]
        t4 = nil
    end

    Poses.clear()
    Controls.unlock("SubBoss")
    HumanoidRootPart = nil
    Humanoid = nil
end

function t1.update(p9) -- line: 179
    -- upvalues: UserInputService (copy), SubArena (copy), v1 (ref), HumanoidRootPart (ref), Humanoid (ref), LinearVelocity (ref), AlignOrientation (ref), t2 (copy), n1 (ref), n2 (ref), n4 (ref), v2 (ref), n5 (ref), t3 (copy), result (ref), v3 (ref), v4 (ref)
    if v1 and HumanoidRootPart and Humanoid and HumanoidRootPart.Parent and LinearVelocity and AlignOrientation then
        local v23 = math.min(p9, 0.05)

        if SubArena.flat(HumanoidRootPart.Position, SubArena.CENTER) > SubArena.RADIUS + 150 then
            LinearVelocity.VectorVelocity = Vector3.new(0, 0, 0)
        else
            local MoveDirection = Humanoid.MoveDirection

            if MoveDirection.Magnitude < 0.01 and result then
                local MoveVector = result:GetMoveVector()

                if MoveVector.Magnitude > 0.01 then
                    local CFrame = workspace.CurrentCamera.CFrame
                    local v24 = Vector3.new(CFrame.LookVector.X, 0, CFrame.LookVector.Z)
                    local v25 = Vector3.new(CFrame.RightVector.X, 0, CFrame.RightVector.Z)

                    if v24.Magnitude > 0.01 and v25.Magnitude > 0.01 then
                        MoveDirection = v25.Unit * MoveVector.X - v24.Unit * MoveVector.Z
                    end
                end
            end

            local v26 = Vector3.new(MoveDirection.X, 0, MoveDirection.Z)

            if v26.Magnitude > 1 then
                v26 = v26.Unit
            end

            local v27 = UserInputService:GetFocusedTextBox() ~= nil
            local up = t3.up
            local v28, v29

            if up then
                v28 = up
                v29 = true
            else
                local Jump = Humanoid.Jump

                if Jump then
                    v28 = Jump
                    v29 = true
                elseif v27 then
                    v29 = false
                else
                    local v30 = UserInputService:IsKeyDown(Enum.KeyCode.Space)

                    if v30 then
                        v28 = v30
                        v29 = true
                    else
                        v29 = false
                    end
                end
            end

            if not v29 then
                v28 = UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
            end

            local down = t3.down
            local v31, v32

            if down then
                v31 = down
                v32 = true
            elseif v27 then
                v32 = false
            else
                local v33 = UserInputService:IsKeyDown(Enum.KeyCode.C)

                if v33 then
                    v31 = v33
                    v32 = true
                else
                    local v34 = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)

                    if v34 then
                        v31 = v34
                        v32 = true
                    else
                        v32 = false
                    end
                end
            end

            if not v32 then
                v31 = UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonB)
            end

            local v35 = (if v28 then 1 else 0) - (if v31 then 1 else 0)
            local v38 = v26 * 42 + Vector3.new(0, v35 * 26, 0)

            t2[1] = t2[1]:Lerp(v38, (math.min(1, v23 * 4)))

            if os.clock() < n4 then
                t2[1] = v2 * 125
            end

            local v41 = if v3 then v3(HumanoidRootPart.Position) else Vector3.new(0, 0, 0)
            local v42 = t2[1] + v41
            local Position = HumanoidRootPart.Position
            local v43 = (SubArena.clamp(Position + v42 * v23, if v4 then v4() else nil) - Position) / v23

            if v43.Magnitude > 220 then
                v43 = v43.Unit * 220
            end

            if (v43 - v42).Magnitude > 0.5 then
                t2[1] = t2[1]:Lerp(v43 - v41, 0.5)
            end

            LinearVelocity.VectorVelocity = v43

            local v44 = Vector3.new(v43.X, 0, v43.Z)
            local v45 = n1

            if v44.Magnitude > 4 and os.clock() >= n4 then
                local v46 = n1
                local v49 = math.atan2(-v44.X, -v44.Z)
                local v50 = v23 * 3.2

                n1 = v46 + math.clamp((v49 - v46 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793, -v50, v50)
            end

            local v53 = ((n1 - v45 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) / math.max(v23, 0.001)

            n2 += (math.clamp(-v53 * 0.18, -0.4, 0.4) - n2) * math.min(1, v23 * 4)

            local v59 = math.clamp(v43.Y / 26, -1, 1) * 0.22
            local v61 = n5

            n5 = math.max(0, v61 - v23 * 1.6)

            local v63 = math.sin(os.clock() * 14) * 0.5 * n5

            AlignOrientation.CFrame = CFrame.Angles(0, n1, 0) * CFrame.Angles(v59, 0, n2 + v63)
        end
    end
end

local function holdButton(p10, p11, p12, p13) -- line: 246
    -- upvalues: Kit (copy), Style (copy), t3 (copy)
    local v64 = Kit.button(p10, p11, Style.OCEAN, {
        Position = p13,
        Size = UDim2.fromOffset(110, 90)
    }, function() -- line: 247
    end)

    v64.MouseButton1Down:Connect(function() -- line: 248
        -- upvalues: p12 (copy), t3 (copy)
        t3[p12] = true
    end)
    v64.MouseButton1Up:Connect(function() -- line: 251
        -- upvalues: p12 (copy), t3 (copy)
        t3[p12] = false
    end)
    v64.MouseLeave:Connect(function() -- line: 254
        -- upvalues: p12 (copy), t3 (copy)
        t3[p12] = false
    end)

    return v64
end

function t1.init() -- line: 260
    -- upvalues: UIUtil (copy), Kit (copy), Style (copy), t1 (copy), LocalPlayer (copy), ScreenGui (ref), result (ref), holdButton (copy)
    task.spawn(function() -- line: 261
        -- upvalues: LocalPlayer (copy), result (ref)
        local v65 = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule", 10)

        if not v65 then
            return
        end

        local function v66() -- line: 264
            -- upvalues: v65 (copy)
            return require(v65):GetControls()
        end

        local ok, result2 = pcall(v66)

        if not ok then
            result2 = nil
        end

        result = result2
    end)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SubPilot"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Enabled = false
    ScreenGui.DisplayOrder = 5
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local v67 = Kit.frame(ScreenGui, {
        Name = "Holder",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -20, 1, -150),
        Size = UDim2.fromOffset(360, 200)
    })
    local UIScale = Instance.new("UIScale")

    UIScale.Parent = v67
    UIUtil.onScale(function(p14) -- line: 279
        -- upvalues: UIScale (copy)
        UIScale.Scale = p14 * 1.3
    end)
    holdButton(v67, "▲", "up", UDim2.fromOffset(0, 0))
    holdButton(v67, "▼", "down", UDim2.fromOffset(0, 104))
    Kit.button(v67, "BOOST", Style.BUY, {
        Position = UDim2.fromOffset(122, 50),
        Size = UDim2.fromOffset(200, 100)
    }, function() -- line: 284
        -- upvalues: t1 (copy)
        t1.boost()
    end)
end

return t1
