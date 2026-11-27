-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local Economy = require(ReplicatedStorage.Shared.Economy)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Poses = require(script.Parent.Parent.Character.Poses)
local BossFx = require(script.Parent.BossFx)
local BossHud = require(script.Parent.BossHud)
local BossReel = require(script.Parent.BossReel)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local Boss = Economy.Boss
local v1 = Color3.fromRGB(110, 255, 120)
local v2 = Color3.fromRGB(255, 60, 60)
local v3 = Color3.new(1, 1, 1)
local v4 = "idle"
local v5 = false
local n1 = 0
local Part = nil
local Beam, Part2, v6

local function arena() -- line: 42
    return workspace:FindFirstChild("BossArena")
end

local function waterY() -- line: 46
    local BossArena = workspace:FindFirstChild("BossArena")

    return BossArena and BossArena:GetAttribute("WaterY") or 0
end

local function boss() -- line: 51
    local BossArena = workspace:FindFirstChild("BossArena")

    return BossArena and BossArena:FindFirstChild("LochNessBoss")
end

local function root() -- line: 56
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character

    return Character and Character:FindFirstChild("HumanoidRootPart")
end

local function rodTip() -- line: 61
    -- upvalues: LocalPlayer (copy)
    local v7 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("RodModel")
    local v8 = v7 and v7:FindFirstChild("Tip", true)

    return v8 and v8:FindFirstChild("RodTip")
end

local function waterPoint(p1) -- line: 68
    -- upvalues: LocalPlayer (copy), Boss (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return nil
    end

    local v9 = workspace.CurrentCamera:ViewportPointToRay(p1.X, p1.Y)
    local BossArena = workspace:FindFirstChild("BossArena")
    local WaterY = BossArena and BossArena:GetAttribute("WaterY") or 0
    local v10

    if v9.Direction.Y < -0.01 then
        v10 = v9.Origin + v9.Direction * ((WaterY - v9.Origin.Y) / v9.Direction.Y)
    else
        local v11 = v9.Origin + Vector3.new(v9.Direction.X, 0, v9.Direction.Z).Unit * Boss.CastRange

        v10 = Vector3.new(v11.X, WaterY, v11.Z)
    end

    local v14 = Vector3.new(v10.X - HumanoidRootPart.Position.X, 0, v10.Z - HumanoidRootPart.Position.Z)

    if v14.Magnitude > Boss.CastRange then
        v14 = v14.Unit * Boss.CastRange
    end

    return Vector3.new(HumanoidRootPart.Position.X, WaterY, HumanoidRootPart.Position.Z) + v14
end

local function nearMonster(p2) -- line: 90
    -- upvalues: Boss (copy)
    local BossArena = workspace:FindFirstChild("BossArena")
    local LochNessBoss = BossArena and BossArena:FindFirstChild("LochNessBoss")

    if LochNessBoss then
        for _, descendant in LochNessBoss:GetDescendants() do
            if descendant:IsA("BasePart") and Vector3.new(descendant.Position.X - p2.X, 0, descendant.Position.Z - p2.Z).Magnitude <= Boss.LatchRadius then
                return true
            end
        end
    end

    return false
end

local function floatText(p3, p4, p5) -- line: 106
    -- upvalues: Debris (copy), UIUtil (copy), Kit (copy)
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(1, 1, 1)
    Part.CFrame = CFrame.new(p3)
    Part.Parent = workspace

    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Size = UDim2.fromScale(16, 4)
    BillboardGui.LightInfluence = 0
    BillboardGui.Adornee = Part
    BillboardGui.Parent = Part

    local v17 = Kit.text(BillboardGui, p4, {
        StrokeThickness = 3,
        Size = UDim2.fromScale(1, 1),
        TextColor3 = p5
    })

    UIUtil.tween(BillboardGui, 1, {
        StudsOffsetWorldSpace = Vector3.new(0, 7, 0)
    })
    UIUtil.tween(v17, 1, {
        TextTransparency = 1
    }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    Debris:AddItem(Part, 1.1)
end

local function castTo(p6) -- line: 160
    -- upvalues: RunService (copy), Remotes (copy), UIUtil (copy), Poses (copy), BossFx (copy), BossReel (copy), LocalPlayer (copy), v4 (ref), n1 (ref), Part (ref), Beam (ref)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return
    end

    v4 = "flying"
    n1 = os.clock()
    HumanoidRootPart.CFrame = CFrame.lookAt(HumanoidRootPart.Position, (Vector3.new(p6.X, HumanoidRootPart.Position.Y, p6.Z)))
    Poses.play("Flick")
    UIUtil.sound("CastSwing", 0.6)
    task.delay(0.16, function() -- line: 171
        -- upvalues: p6 (copy), HumanoidRootPart (copy), RunService (copy), Remotes (copy), UIUtil (copy), Poses (copy), BossFx (copy), BossReel (copy), LocalPlayer (copy), v4 (ref), Part (ref), Beam (ref)
        if v4 ~= "flying" then
            return
        end

        UIUtil.sound("CastLine", 0.6)

        local v18 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("RodModel")
        local v19 = v18 and v18:FindFirstChild("Tip", true)
        local RodTip = v19 and v19:FindFirstChild("RodTip")
        local v20 = if RodTip then RodTip.WorldPosition else HumanoidRootPart.Position + Vector3.new(0, 4, 0)
        local Part2 = Instance.new("Part")

        Part2.Name = "BossBobber"
        Part2.Shape = Enum.PartType.Ball
        Part2.Size = Vector3.new(1.1, 1.1, 1.1)
        Part2.Color = Color3.fromRGB(235, 50, 50)
        Part2.Material = Enum.Material.SmoothPlastic
        Part2.Anchored = true
        Part2.CanCollide = false
        Part2.CanQuery = false
        Part2.CanTouch = false
        Part2.CFrame = CFrame.new(v20)
        Part2.Parent = workspace
        Part = Part2

        local Attachment = Instance.new("Attachment")

        Attachment.Parent = Part2

        if RodTip then
            local Beam2 = Instance.new("Beam")

            Beam2.Color = ColorSequence.new(Color3.fromRGB(235, 240, 250))
            Beam2.Width0 = 0.12
            Beam2.Width1 = 0.4
            Beam2.FaceCamera = true
            Beam2.LightInfluence = 0
            Beam2.Attachment0 = RodTip
            Beam2.Attachment1 = Attachment
            Beam2.Parent = Part2
            Beam = Beam2
        end

        local Magnitude = (Vector3.new(p6.X, 0, p6.Z) - Vector3.new(v20.X, 0, v20.Z)).Magnitude
        local v23 = math.clamp(Magnitude / 150, 0.35, 0.9)
        local v25 = math.max(8, Magnitude * 0.22)
        local elapsed = os.clock()
        local connection

        connection = RunService.RenderStepped:Connect(function() -- line: 205
            -- upvalues: Part2 (copy), v20 (copy), v23 (copy), v25 (copy), elapsed (copy), connection (ref), p6 (copy), Remotes (copy), UIUtil (copy), Poses (copy), BossFx (copy), BossReel (copy), v4 (ref), Part (ref), Beam (ref)
            if Part ~= Part2 then
                connection:Disconnect()

                return
            end

            local v27 = math.min(1, (os.clock() - elapsed) / v23)

            Part2.CFrame = CFrame.new(v20:Lerp(p6, v27) + Vector3.new(0, math.sin(v27 * 3.141592653589793) * v25, 0))

            if v27 >= 1 then
                connection:Disconnect()
                v4 = "waiting"
                BossFx.splash(p6 + Vector3.new(0, 0.5, 0), 3)
                UIUtil.sound("Splash", 0.5, 1.2)
                Remotes.Boss:FireServer("Cast", p6)
                task.delay(2, function() -- line: 219
                    -- upvalues: Part2 (copy), Poses (copy), BossReel (copy), v4 (ref), Part (ref), Beam (ref)
                    if v4 ~= "waiting" or Part ~= Part2 then
                        return
                    end

                    v4 = "idle"

                    if Beam then
                        Beam:Destroy()
                        Beam = nil
                    end

                    if Part then
                        Part:Destroy()
                        Part = nil
                    end

                    BossReel.hide()
                    Poses.clear()
                end)
            end
        end)
    end)
end

function t1.press(p7) -- line: 230
    -- upvalues: BossReel (copy), Boss (copy), v4 (ref), v5 (ref), n1 (ref), waterPoint (copy), castTo (copy)
    if v5 then
        if v4 == "hooked" then
            BossReel.tap()
        elseif v4 == "idle" and os.clock() - n1 >= Boss.CastGap then
            local v31 = waterPoint(p7)

            if v31 then
                castTo(v31)
            end
        end
    end
end

function t1.onServer(p8, p9) -- line: 245
    -- upvalues: Poses (copy), BossHud (copy), BossReel (copy), v2 (copy), v4 (ref), Part (ref), Beam (ref), floatText (copy)
    if p8 == "Hooked" then
        if v4 == "waiting" or v4 == "flying" then
            v4 = "hooked"

            if Beam then
                Beam:Destroy()
                Beam = nil
            end

            if Part then
                Part:Destroy()
                Part = nil
            end

            BossReel.start()
        end
    elseif p8 == "Missed" then
        if v4 == "waiting" and Part then
            floatText(Part.Position + Vector3.new(0, 2, 0), "MISSED! Cast closer to it", Color3.fromRGB(255, 200, 120))

            local Part2 = Part

            task.delay(0.35, function() -- line: 254
                -- upvalues: Part2 (copy), Poses (copy), BossReel (copy), v4 (ref), Part (ref), Beam (ref)
                if Part ~= Part2 then
                    return
                end

                v4 = "idle"

                if Beam then
                    Beam:Destroy()
                    Beam = nil
                end

                if Part then
                    Part:Destroy()
                    Part = nil
                end

                BossReel.hide()
                Poses.clear()
            end)
        end
    elseif p8 == "Unhooked" then
        local v32 = type(p9) == "table" and p9.Why

        if v4 == "hooked" then
            v4 = "idle"

            if Beam then
                Beam:Destroy()
                Beam = nil
            end

            if Part then
                Part:Destroy()
                Part = nil
            end

            BossReel.hide()
            Poses.clear()

            if v32 == "Hit" then
                BossHud.announce({ { "IT KNOCKED YOUR HOOK LOOSE!", v2, 60 } }, 1.4)
            end
        end
    end
end

function t1.isHooked() -- line: 271
    -- upvalues: v4 (ref)
    return v4 == "hooked"
end

function t1.setActive(p10) -- line: 276
    -- upvalues: Poses (copy), BossReel (copy), v4 (ref), v5 (ref), Part (ref), Beam (ref), Part2 (ref), v6 (ref)
    if p10 == v5 then
        return
    end

    v5 = p10

    if not p10 then
        v4 = "idle"

        if Beam then
            Beam:Destroy()
            Beam = nil
        end

        if Part then
            Part:Destroy()
            Part = nil
        end

        BossReel.hide()
        Poses.clear()
        Part2.Parent = nil
        v6 = nil
    end
end

local function touch() -- line: 288
    -- upvalues: UserInputService (copy)
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

function t1.init() -- line: 292
    -- upvalues: RunService (copy), UserInputService (copy), Poses (copy), BossReel (copy), LocalPlayer (copy), v1 (copy), v3 (copy), v4 (ref), v5 (ref), Part (ref), Beam (ref), Part2 (ref), v6 (ref), waterPoint (copy), nearMonster (copy)
    Part2 = Instance.new("Part")
    Part2.Name = "BossAim"
    Part2.Shape = Enum.PartType.Cylinder
    Part2.Size = Vector3.new(0.15, 6, 6)
    Part2.Material = Enum.Material.Neon

    local Part5 = Part2
    local Part6 = Part2
    local Part7 = Part2
    local Part8 = Part2
    local Part9 = Part2

    Part5.Anchored = true
    Part6.CanCollide = false
    Part7.CanQuery = false
    Part8.CanTouch = false
    Part9.CastShadow = false

    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "BossReel"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Enabled = false
    ScreenGui.DisplayOrder = 5
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    BossReel.init(ScreenGui)
    RunService.RenderStepped:Connect(function(p11) -- line: 310
        -- upvalues: UserInputService (copy), Poses (copy), BossReel (copy), v1 (copy), v3 (copy), v4 (ref), v5 (ref), Part (ref), Beam (ref), Part2 (ref), v6 (ref), waterPoint (copy), nearMonster (copy)
        if v5 then
            if v4 == "hooked" then
                Part2.Parent = nil

                if BossReel.update(p11) then
                    v4 = "idle"

                    if Beam then
                        Beam:Destroy()
                        Beam = nil
                    end

                    if Part then
                        Part:Destroy()
                        Part = nil
                    end

                    Poses.clear()
                end
            else
                local v33 = if UserInputService:GetLastInputType() == Enum.UserInputType.Gamepad1 then workspace.CurrentCamera.ViewportSize / 2 else UserInputService:GetMouseLocation()

                v6 = if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then nil else waterPoint(v33)

                if v6 and v4 == "idle" then
                    local v34 = nearMonster(v6)
                    local v35 = if v34 then math.sin(os.clock() * 10) * 1 + 7 else 5

                    Part2.Size = Vector3.new(0.15, v35, v35)

                    local Part3 = Part2

                    if v34 then
                        Part3.Color = v1
                    else
                        Part3.Color = v3
                    end

                    Part2.Transparency = v34 and 0.15 or 0.45
                    Part2.CFrame = CFrame.new(v6 + Vector3.new(0, 0.25, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
                    Part2.Parent = workspace
                else
                    Part2.Parent = nil
                end
            end
        end
    end)
end

return t1
