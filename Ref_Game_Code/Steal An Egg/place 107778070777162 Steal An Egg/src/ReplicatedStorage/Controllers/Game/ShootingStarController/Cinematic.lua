-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Fx = require(script.Parent.Fx)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local Hud = require(script.Parent.Hud)
local LightingController = require(ReplicatedStorage.Controllers.Game.LightingController)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t1 = {
    ClockTime = 0.4,
    Brightness = 1.2,
    ExposureCompensation = -0.2,
    Ambient = Color3.fromRGB(70, 70, 120),
    OutdoorAmbient = Color3.fromRGB(55, 62, 120),
    ColorShift_Top = Color3.fromRGB(120, 140, 255),
    ColorShift_Bottom = Color3.fromRGB(30, 30, 80),
    Bloom = {
        Intensity = 1.4,
        Threshold = 0.85,
        Size = 36,
        Enabled = true
    }
}
local LocalPlayer = Players.LocalPlayer
local Controls = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls()
local t2 = {}

local function smooth(p1) -- line: 66
    local v1 = math.clamp(p1, 0, 1)

    return v1 * v1 * (3 - v1 * 2)
end

local function bezier(p2, p3, p4, p5) -- line: 71
    return p2:Lerp(p3, p5):Lerp(p3:Lerp(p4, p5), p5)
end

local function clearPosition(p6, p7, p8) -- line: 75
    -- upvalues: Workspace (copy)
    local v2 = p7 - p6

    if v2.Magnitude < 0.001 then
        return p7
    end

    local v3 = Workspace:Spherecast(p6, 1.5, v2, p8)

    if not v3 then
        return p7
    end

    return p6 + v2.Unit * math.max(v3.Distance - 0.35, 0)
end

local function playerFocus() -- line: 87
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    return if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart.Position else nil
end

function t2.Seconds() -- line: 97
    return 4.2
end

function t2.Path(p9) -- line: 101
    local Position, RightVector = p9.Position, p9.RightVector
    local v5 = -p9.LookVector
    local v6 = Position + (RightVector * 0.8 + v5 * 0.6).Unit * 620 + Vector3.new(0, 560, 0)

    return v6, Position:Lerp(v6, 0.45) + Vector3.new(0, 90, 0), Position + Vector3.new(0, 2, 0)
end

function t2.StarAt(p10, p11) -- line: 112
    -- upvalues: t2 (copy), bezier (copy)
    local v7, v8, v9 = t2.Path(p10)

    return bezier(v7, v8, v9, p11 ^ 1.7)
end

function t2.Play(p12, p13, p14) -- line: 117
    -- upvalues: Players (copy), RunService (copy), Workspace (copy), Fx (copy), HiddenUIHandler (copy), Hud (copy), LightingController (copy), Trove (copy), t1 (copy), LocalPlayer (copy), Controls (copy), t2 (copy)
    local Landing = p12.Landing
    local v10 = p12.FallAt + 1
    local LandAt = p12.LandAt
    local LandingPosition = Landing.Position
    local CurrentCamera = Workspace.CurrentCamera
    local v11 = Trove.new()
    local v12 = false
    local v13 = false
    local v14 = false
    local v15 = false
    local FieldOfView = CurrentCamera.FieldOfView
    local v16 = Fx.ReducedMotion()

    v11:Add(HiddenUIHandler.Acquire())
    Controls:Disable()
    v11:Add(function() -- line: 133
        -- upvalues: Controls (copy)
        Controls:Enable()
    end)
    LightingController.SetLayer("ShootingStarCinematic", t1, 250, 0.9)
    v11:Add(function() -- line: 137
        -- upvalues: LightingController (copy)
        LightingController.ClearLayer("ShootingStarCinematic", 2.2)
    end)
    Hud.Bars(true)
    v11:Add(function() -- line: 141
        -- upvalues: Hud (copy)
        Hud.Bars(false)
        Hud.Caption(false)
    end)
    task.spawn(function() -- line: 145
        -- upvalues: LandingPosition (copy), LocalPlayer (copy)
        local function v17() -- line: 146
            -- upvalues: LandingPosition (copy), LocalPlayer (copy)
            LocalPlayer:RequestStreamAroundAsync(LandingPosition, 4)
        end

        pcall(v17)
    end)

    local Unit = (-Landing.LookVector * Vector3.new(1, 0, 1)).Unit
    local RightVector = Landing.RightVector
    local v18 = LandingPosition + Unit * 115 + Vector3.new(0, 18, 0)
    local v19 = RightVector * 8 + Unit * 30
    local v20 = LandingPosition + v19 + Vector3.new(0, 9, 0)
    local v21 = math.atan2(v19.Z, v19.X)
    local Magnitude = v19.Magnitude
    local v22 = LandingPosition + Vector3.new(0, 4, 0)
    local v23 = RaycastParams.new()

    v23.FilterType = Enum.RaycastFilterType.Exclude
    v23.RespectCanCollide = true
    v23.IgnoreWater = true

    local t3 = {}
    local ShootingStarClient = Workspace:FindFirstChild("ShootingStarClient")

    if ShootingStarClient then
        table.insert(t3, ShootingStarClient)
    end

    for _, player in Players:GetPlayers() do
        if player.Character then
            table.insert(t3, player.Character)
        end
    end

    v23.FilterDescendantsInstances = t3

    local v24
    local v25 = false
    local v26 = t2.StarAt(Landing, 0.15)
    local v27 = LandAt + 4.2

    Fx.Dip(0.28, 0.44800000000000006)
    v11:Connect(RunService.RenderStepped, function(p15) -- line: 182
        -- upvalues: p12 (copy), p13 (copy), p14 (copy), Landing (copy), v10 (copy), LandAt (copy), LandingPosition (copy), CurrentCamera (copy), v11 (copy), v12 (ref), v13 (ref), v14 (ref), v15 (ref), FieldOfView (copy), v16 (copy), v18 (copy), v20 (copy), v21 (copy), Magnitude (copy), v22 (copy), v23 (copy), v24 (ref), v25 (ref), v26 (copy), v27 (copy), Workspace (copy), Fx (copy), Hud (copy), t2 (copy)
        local v28 = p13()

        if not v25 and p12.FallAt + 0.28 <= v28 then
            v25 = true
            CurrentCamera.CameraType = Enum.CameraType.Scriptable
        end

        if not v25 then
            return
        end

        local v30 = math.clamp((v28 - v10) / (LandAt - v10), 0, 1)
        local v31 = t2.StarAt(Landing, v30)
        local v32 = LandingPosition + Vector3.new(0, 2.6, 0)
        local v33, v34

        if v16 then
            v33 = v20

            local v35 = math.clamp(v30, 0, 1)

            v32 = v31:Lerp(v32, v35 * v35 * (3 - v35 * 2))
            v34 = 62
        elseif v28 < LandAt then
            local v37 = math.clamp((v28 - LandAt + 1.8) / 1.8, 0, 1)
            local v38 = v37 * v37 * (3 - v37 * 2)
            local v40 = math.clamp((v28 - v10 + 0.4) / 1.2, 0, 1)
            local v41 = v26:Lerp(v31, v40 * v40 * (3 - v40 * 2))
            local v43 = math.clamp((v28 - p12.FallAt) / (LandAt - p12.FallAt), 0, 1)

            v33 = (v18 + Vector3.new(0, -v43 * 6, 0)):Lerp(v20, v38)
            v32 = v41:Lerp(v32, v38)

            local v45 = math.clamp(v43, 0, 1)

            v34 = (68 - v45 * v45 * (3 - v45 * 2) * 18) * (1 - v38) + v38 * 62
        elseif v28 < LandAt + 0.45 then
            v33 = v20
            v34 = 62
        else
            local v47 = math.clamp((v28 - LandAt - 0.45) / 3.75, 0, 1)
            local v48 = v47 * v47 * (3 - v47 * 2)
            local v49 = v21 + v48 * 0.9599310885968813
            local v50 = Magnitude + (18 - Magnitude) * v48
            local v51 = v48 * -3 + 9

            v33 = LandingPosition + Vector3.new(math.cos(v49) * v50, v51, math.sin(v49) * v50)
            v34 = 62 - v48 * 10
        end

        local v54 = v33 - v22

        if not (v54.Magnitude < 0.001) then
            local v55 = Workspace:Spherecast(v22, 1.5, v54, v23)

            if v55 then
                v33 = v22 + v54.Unit * math.max(v55.Distance - 0.35, 0)
            end
        end

        local v57 = v24

        if v57 and not v16 then
            v33 = v57:Lerp(v33, 1 - math.exp(p15 * -12))

            local v59 = v33 - v22

            if not (v59.Magnitude < 0.001) then
                local v60 = Workspace:Spherecast(v22, 1.5, v59, v23)

                if v60 then
                    v33 = v22 + v59.Unit * math.max(v60.Distance - 0.35, 0)
                end
            end
        end

        v24 = v33
        CurrentCamera.CFrame = CFrame.lookAt(v33, v32)
        CurrentCamera.FieldOfView = v34

        local Shake, v62

        if not v13 and LandAt <= v28 then
            v13 = true
            p14.Land()
            Fx.Flash(Color3.fromRGB(255, 240, 200), 0.8, 0.55)
            Fx.Grade(Color3.fromRGB(255, 200, 90), 1, 0.9)
            Shake = Fx.Shake
            v62 = if v16 then 0.4 else 1.6
            Shake(0.9, v62, LandingPosition)
        end

        if not v15 and LandAt + 0.55 <= v28 then
            v15 = true
            Hud.Caption(true)
        end

        if not v14 and LandAt + 0.55 + 0.3 <= v28 then
            v14 = true
            p14.Rise()
        end

        if v12 or not (v27 <= v28) then
            return
        end

        v12 = true
        Fx.Dip(0.28, 0.44800000000000006)
        task.delay(0.28, function() -- line: 257
            -- upvalues: CurrentCamera (copy), v11 (copy), FieldOfView (copy)
            CurrentCamera.CameraType = Enum.CameraType.Custom
            CurrentCamera.FieldOfView = FieldOfView
            v11:Destroy()
        end)
    end)

    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    local Position = if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then nil else HumanoidRootPart.Position

    if Position then
        CurrentCamera.Focus = CFrame.new(Position)
    end
end

return t2
