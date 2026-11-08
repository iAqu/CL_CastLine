-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CameraShaker = require(ReplicatedStorage.Packages.CameraShaker)
local CameraShakerDriver = require(ReplicatedStorage.Client.CameraShakerDriver)
local Fx = require(script.Parent.Fx)
local Herd = require(script.Parent.Herd)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local Hud = require(script.Parent.Hud)
local TrexRunHerd = require(ReplicatedStorage.Shared.Modules.TrexRunHerd)
local t1 = {}

local function easeInOutCubic(p1) -- line: 44
    if p1 < 0.5 then
        return p1 * 4 * p1 * p1
    end

    return 1 - (p1 * -2 + 2) ^ 3 / 2
end

local function easeOutQuint(p2) -- line: 48
    return 1 - (1 - p2) ^ 5
end

local function phase(p3, p4, p5) -- line: 52
    return (math.clamp((p3 - p4) / (p5 - p4), 0, 1))
end

function t1.Play(p6, p7, p8, p9) -- line: 60
    -- upvalues: GuiService (copy), RunService (copy), Workspace (copy), CameraShaker (copy), CameraShakerDriver (copy), Fx (copy), Herd (copy), HiddenUIHandler (copy), Hud (copy), TrexRunHerd (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local Course = p6.Course
    local v2 = TrexRunHerd.Forward(Course)
    local v3 = TrexRunHerd.Across(Course)
    local t2 = {
        CFrame = CurrentCamera.CFrame,
        FieldOfView = CurrentCamera.FieldOfView,
        CameraType = CurrentCamera.CameraType,
        CameraSubject = CurrentCamera.CameraSubject
    }
    local v4 = CameraShaker.new()
    local v5 = HiddenUIHandler.Acquire()
    local elapsed = os.clock()
    local v6 = TrexRunHerd.Locate(Course, p9)
    local v7 = Course.Near + 40
    local v10 = math.max(v6 - 140, v7 + 200)
    local v11 = p6.Size.Y * 1.25
    local v12 = Course.LaneWidth * 0.5
    local v13 = Herd.AlphaHead(p6) or TrexRunHerd.Point(Course, Course.Far, 0)
    local v14 = false
    local v15 = false
    local v16 = false
    local v17 = false
    local t3 = {
        Done = false,
        Stop = function() -- Stop | line: 89
        end
    }

    Hud.SetBoardShown(p7, false)
    Hud.Letterbox(p7, true)
    CurrentCamera.CameraType = Enum.CameraType.Scriptable
    Fx.Sound({ "Sounds", "CinematicRiser" }, nil, 2.2)
    Fx.Sound({ "Sounds", "ScrambleBoss", "Rumble" }, nil, 1.4, 0.8)

    if not GuiService.ReducedMotionEnabled then
        v4:ShakeSustain(CameraShaker.Presets.Earthquake)
    end

    local function stop() -- line: 101
        -- upvalues: p7 (copy), CurrentCamera (copy), t2 (copy), v4 (copy), v5 (copy), t3 (copy), RunService (copy), Hud (copy)
        if t3.Done then
            return
        end

        t3.Done = true

        local UnbindFromRenderStep = RunService.UnbindFromRenderStep

        pcall(UnbindFromRenderStep, RunService, "TrexRunCutscene")
        v4:StopSustained(0.2)
        CurrentCamera.CFrame = t2.CFrame
        CurrentCamera.FieldOfView = t2.FieldOfView
        CurrentCamera.CameraType = t2.CameraType

        if t2.CameraSubject ~= nil and t2.CameraSubject.Parent ~= nil then
            CurrentCamera.CameraSubject = t2.CameraSubject
        end

        Hud.Letterbox(p7, false)
        Hud.SetBoardShown(p7, true)
        v5()
    end

    t3.Stop = stop

    local function flyShot(p10) -- line: 124
        -- upvalues: p6 (copy), Course (copy), v7 (copy), v10 (copy), v11 (copy), v12 (copy), TrexRunHerd (copy)
        local v19 = math.clamp((p10 - 0) / 3.6, 0, 1)
        local v20 = if v19 < 0.5 then v19 * 4 * v19 * v19 else 1 - (v19 * -2 + 2) ^ 3 / 2
        local v21 = v7 + (v10 - v7) * v20
        local v23 = math.sin(p10 * 1.7) * Course.LaneWidth * 0.35
        local v24 = TrexRunHerd.Point(Course, v21, v12 + v23) + Vector3.new(0, v11, 0)
        local v27 = TrexRunHerd.Point(Course, v21 + 260, v12 * 0.3) + Vector3.new(0, p6.Size.Y * 0.35, 0)

        return CFrame.lookAt(v24, v27), 68
    end

    local function eggShot(p11) -- line: 135
        -- upvalues: p9 (copy), v2 (copy), v3 (copy)
        local v29 = math.clamp((p11 - 3.6) / 1.6, 0, 1)
        local v31 = math.rad(v29 * 50 + -35)
        local v32 = 46 - v29 * 12
        local v36 = p9 + (v2 * -math.cos(v31) + v3 * math.sin(v31)) * v32 + Vector3.new(0, 14 - v29 * 4, 0)

        return CFrame.lookAt(v36, p9 + Vector3.new(0, 3, 0)), 42
    end

    local function alphaShot(p12) -- line: 145
        -- upvalues: p6 (copy), v2 (copy), v3 (copy), v13 (copy)
        local v38 = math.clamp((p12 - 5.2) / 1.8999999999999995, 0, 1)
        local v42 = v13 - v2 * (p6.Size.Z * (4.2 - v38 * 0.9)) - Vector3.new(0, p6.Size.Y * (1.1 - v38 * 0.2), 0) + v3 * (p6.Size.X * 0.8)

        return CFrame.lookAt(v42, v13), 50
    end

    RunService:BindToRenderStep("TrexRunCutscene", Enum.RenderPriority.Camera.Value + 1, function(p13) -- line: 159
        -- upvalues: p6 (copy), p7 (copy), p8 (copy), CurrentCamera (copy), t2 (copy), v4 (copy), elapsed (copy), v14 (ref), v15 (ref), v16 (ref), v17 (ref), stop (copy), flyShot (copy), eggShot (copy), alphaShot (copy), Workspace (copy), CameraShakerDriver (copy), Fx (copy), Herd (copy), Hud (copy)
        local function v44() -- line: 160
            -- upvalues: p13 (copy), p6 (copy), p7 (copy), p8 (copy), CurrentCamera (copy), t2 (copy), v4 (copy), elapsed (copy), v14 (ref), v15 (ref), v16 (ref), v17 (ref), stop (copy), flyShot (copy), eggShot (copy), alphaShot (copy), Workspace (copy), CameraShakerDriver (copy), Fx (copy), Herd (copy), Hud (copy)
            local v45 = Workspace:GetServerTimeNow() - p8
            local v46, v47

            if v45 < 3.6 then
                v46, v47 = flyShot(v45)
            elseif v45 < 5.2 then
                v46, v47 = eggShot(v45)

                local v49 = math.clamp((v45 - 3.6) / 0.3500000000000001, 0, 1)

                if v49 < 1 then
                    local v50, v51 = flyShot(3.6)

                    v46 = v50:Lerp(v46, 1 - (1 - v49) ^ 5)
                    v47 = v51 + (v47 - v51) * v49
                end
            else
                v46, v47 = alphaShot(v45)

                local v53 = math.clamp((v45 - 5.2) / 0.34999999999999964, 0, 1)

                if v53 < 1 then
                    local v54, v55 = eggShot(5.2)

                    v46 = v54:Lerp(v46, 1 - (1 - v53) ^ 5)
                    v47 = v55 + (v47 - v55) * v53
                end
            end

            if v45 >= 3.6 and not v15 then
                v15 = true
                v4:StopSustained(0.5)
            end

            if v45 >= 5.75 and not v14 then
                v14 = true
                Herd.Roar(p6, 1.4)
                v4:ShakeOnce(7, 12, 0, 1.6)
                Fx.Sound({ "Sounds", "ScrambleBoss", "HeavyLand" }, nil, 1.4)
            end

            if v45 >= 7.1 and not v16 then
                v16 = true
                Hud.SetBoardShown(p7, true)
                Fx.Sound({ "Sounds", "ScrambleBoss", "Swoosh" }, nil, 1.4, 0.8)
            end

            local v57 = 1 - (1 - math.clamp((os.clock() - elapsed) / 0.9, 0, 1)) ^ 5
            local v58 = t2.CFrame:Lerp(v46, v57)
            local v59 = t2.FieldOfView + (v47 - t2.FieldOfView) * v57
            local v60, v61

            if v45 >= 7.1 then
                if not v17 then
                    v17 = true
                    Hud.Letterbox(p7, false)
                end

                local v63 = math.clamp((v45 - 7.1) / 1.3000000000000007, 0, 1)
                local v64 = if v63 < 0.5 then v63 * 4 * v63 * v63 else 1 - (v63 * -2 + 2) ^ 3 / 2
                local v65, v66 = alphaShot(7.1)

                v60 = v65:Lerp(t2.CFrame, v64)
                v61 = v66 + (t2.FieldOfView - v66) * v64

                if v64 >= 1 then
                    task.defer(stop)
                end
            else
                v60 = v58
                v61 = v59
            end

            CurrentCamera.CameraType = Enum.CameraType.Scriptable
            CurrentCamera.FieldOfView = v61
            CurrentCamera.CFrame = v60 * CameraShakerDriver.Advance(v4, p13)
        end

        local ok, result = pcall(v44)

        if not ok then
            warn((("[TrexRun] cutscene frame failed: %*"):format(result)))
            task.defer(stop)
        end
    end)

    return t3
end

return table.freeze(t1)
