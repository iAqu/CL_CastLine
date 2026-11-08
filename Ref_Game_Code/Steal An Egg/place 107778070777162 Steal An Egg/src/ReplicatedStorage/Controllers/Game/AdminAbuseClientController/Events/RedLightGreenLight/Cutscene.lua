-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CameraShaker = require(ReplicatedStorage.Packages.CameraShaker)
local CameraShakerDriver = require(ReplicatedStorage.Client.CameraShakerDriver)
local Fx = require(script.Parent.Fx)
local Giant = require(script.Parent.Giant)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local Hud = require(script.Parent.Hud)
local t1 = {
    "Particles",
    "ScrambleBossVFX",
    "MechBoss",
    "Slam"
}
local t2 = {}

local function easeOutQuint(p1) -- line: 43
    return 1 - (1 - p1) ^ 5
end

local function easeInOutCubic(p2) -- line: 47
    if p2 < 0.5 then
        return p2 * 4 * p2 * p2
    end

    return 1 - (p2 * -2 + 2) ^ 3 / 2
end

local function easeOutBack(p3) -- line: 51
    return (p3 - 1) ^ 3 * 2.2 + 1 + (p3 - 1) ^ 2 * 1.2
end

local function dust(p4) -- line: 58
    -- upvalues: Fx (copy), t1 (copy)
    local v1 = Fx.Resolve(t1)

    if v1 == nil then
        return
    end

    local clone = v1:Clone()
    local v2 = p4.Height * 0.12
    local v5 = Vector3.new((math.random() - 0.5) * v2, 0, (math.random() - 0.5) * v2)

    if clone:IsA("BasePart") then
        clone.Anchored = true
        clone.CanCollide = false
        clone.CanQuery = false
        clone.CanTouch = false
        clone.Transparency = 1
        clone.CFrame = p4.Ground + v5
    end

    Fx.Scale(clone, p4.Height / 60)
    clone.Parent = Fx.Folder()
    Fx.Burst(clone, 0.6)
    task.delay(4, function() -- line: 81
        -- upvalues: clone (copy)
        clone:Destroy()
    end)
end

function t2.Play(p5, p6, p7) -- line: 90
    -- upvalues: GuiService (copy), RunService (copy), Workspace (copy), CameraShaker (copy), CameraShakerDriver (copy), Fx (copy), Giant (copy), HiddenUIHandler (copy), Hud (copy), dust (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local t3 = {
        CFrame = CurrentCamera.CFrame,
        FieldOfView = CurrentCamera.FieldOfView,
        CameraType = CurrentCamera.CameraType,
        CameraSubject = CurrentCamera.CameraSubject
    }
    local v6 = CameraShaker.new()
    local v7 = HiddenUIHandler.Acquire()
    local elapsed = os.clock()
    local LookVector = p5.Ground.LookVector
    local n1 = (-1e999)
    local v8 = false
    local v9 = false
    local v10 = false
    local t4 = {
        Done = false,
        Stop = function() -- Stop | line: 106
        end
    }

    p5.Rise = 0
    Giant.Face(p5, true, true)
    Giant.SetEyes(p5, 0, true)
    Hud.SetBoardShown(p6, false)
    Hud.Letterbox(p6, true)
    CurrentCamera.CameraType = Enum.CameraType.Scriptable
    Fx.Sound({ "Sounds", "CinematicRiser" }, nil, 2.4)
    Fx.Sound({ "Sounds", "ScrambleBoss", "Rumble" }, nil, 1.2)

    if not GuiService.ReducedMotionEnabled then
        v6:ShakeSustain(CameraShaker.Presets.Earthquake)
    end

    local function stop() -- line: 120
        -- upvalues: p5 (copy), p6 (copy), CurrentCamera (copy), t3 (copy), v6 (copy), v7 (copy), t4 (copy), RunService (copy), Hud (copy)
        if t4.Done then
            return
        end

        t4.Done = true

        local UnbindFromRenderStep = RunService.UnbindFromRenderStep

        pcall(UnbindFromRenderStep, RunService, "RedLightGreenLightCutscene")
        v6:StopSustained(0.2)
        p5.Rise = 1
        CurrentCamera.CFrame = t3.CFrame
        CurrentCamera.FieldOfView = t3.FieldOfView
        CurrentCamera.CameraType = t3.CameraType

        if t3.CameraSubject ~= nil and t3.CameraSubject.Parent ~= nil then
            CurrentCamera.CameraSubject = t3.CameraSubject
        end

        Hud.Letterbox(p6, false)
        Hud.SetBoardShown(p6, true)
        v7()
    end

    t4.Stop = stop
    RunService:BindToRenderStep("RedLightGreenLightCutscene", Enum.RenderPriority.Camera.Value + 1, function(p8) -- line: 147
        -- upvalues: p5 (copy), p6 (copy), p7 (copy), CurrentCamera (copy), t3 (copy), v6 (copy), elapsed (copy), LookVector (copy), n1 (ref), v8 (ref), v9 (ref), v10 (ref), stop (copy), Workspace (copy), CameraShakerDriver (copy), Fx (copy), Giant (copy), Hud (copy), dust (copy)
        local function v12() -- line: 148
            -- upvalues: p8 (copy), p5 (copy), p6 (copy), p7 (copy), CurrentCamera (copy), t3 (copy), v6 (copy), elapsed (copy), LookVector (copy), n1 (ref), v8 (ref), v9 (ref), v10 (ref), stop (copy), Workspace (copy), CameraShakerDriver (copy), Fx (copy), Giant (copy), Hud (copy), dust (copy)
            local v13 = Workspace:GetServerTimeNow() - p7
            local v14 = os.clock() - elapsed
            local Height = p5.Height
            local v16 = math.clamp(v13 / 4.6, 0, 1)

            p5.Rise = (v16 - 1) ^ 3 * 2.2 + 1 + (v16 - 1) ^ 2 * 1.2

            if v13 >= 0 and v13 < 4.6 and v13 - n1 >= 0.55 then
                n1 = v13
                dust(p5)
            end

            if v13 >= 4.6 and not v8 then
                v8 = true
                v6:StopSustained(0.6)
                v6:ShakeOnce(6, 10, 0, 1.4)
                Fx.Sound({ "Sounds", "ScrambleBoss", "HeavyLand" }, nil, 1.6)
                Fx.Sound({ "Sounds", "MonsterParasite", "Roar" }, nil, 0.9, 0.7)
            end

            if v13 >= 5.45 and p5.EyeTarget < 1 and not v9 then
                Giant.SetEyes(p5, 1.6)
                Fx.Sound({ "Sounds", "ScrambleBoss", "Charge" }, nil, 1.1)
            end

            if v13 >= 6.1 and not v9 then
                v9 = true
                Giant.Face(p5, false)
                Giant.SetEyes(p5, 0)
                Fx.Sound({ "Sounds", "ScrambleBoss", "Swoosh" }, nil, 1.4, 0.8)
                v6:ShakeOnce(2.5, 14, 0, 0.6)
            end

            local GroundPosition = p5.Ground.Position
            local v18 = GroundPosition + Vector3.new(0, Height * (0.25 + 0.4 * p5.Rise), 0)
            local v22 = GroundPosition + LookVector * (Height * (2.7 - math.clamp(v13 / 5.2, 0, 1) * 0.35)) + Vector3.new(0, Height * 0.32, 0)
            local v23 = CFrame.lookAt(v22, v18)
            local v24 = Giant.HeadPosition(p5)
            local v27 = v24 + LookVector * (Height * 0.42) - Vector3.new(0, Height * 0.06, 0)
            local v28 = CFrame.lookAt(v27, v24)
            local v29, v30

            if v13 >= 5.2 then
                local v32 = math.clamp((v13 - 5.2) / 0.45, 0, 1)
                local v33 = if v32 < 0.5 then v32 * 4 * v32 * v32 else 1 - (v32 * -2 + 2) ^ 3 / 2

                v29 = v23:Lerp(v28, v33)
                v30 = v33 * -21 + 55
            else
                v29 = v23
                v30 = 55
            end

            local v35 = 1 - (1 - math.clamp(v14 / 1, 0, 1)) ^ 5
            local v36 = t3.CFrame:Lerp(v29, v35)
            local v37 = t3.FieldOfView + (v30 - t3.FieldOfView) * v35
            local v38, v39

            if v13 >= 7.5 then
                if not v10 then
                    v10 = true
                    Hud.Letterbox(p6, false)
                end

                local v41 = math.clamp((v13 - 7.5) / 1.2, 0, 1)
                local v42 = if v41 < 0.5 then v41 * 4 * v41 * v41 else 1 - (v41 * -2 + 2) ^ 3 / 2

                v38 = v28:Lerp(t3.CFrame, v42)
                v39 = 34 + (t3.FieldOfView - 34) * v42

                if v42 >= 1 then
                    task.defer(stop)
                end
            else
                v39 = v37
                v38 = v36
            end

            CurrentCamera.CameraType = Enum.CameraType.Scriptable
            CurrentCamera.FieldOfView = v39
            CurrentCamera.CFrame = v38 * CameraShakerDriver.Advance(v6, p8)
        end

        local ok, result = pcall(v12)

        if not ok then
            warn((("[RedLightGreenLight] cutscene frame failed: %*"):format(result)))
            task.defer(stop)
        end
    end)

    return t4
end

return t2
