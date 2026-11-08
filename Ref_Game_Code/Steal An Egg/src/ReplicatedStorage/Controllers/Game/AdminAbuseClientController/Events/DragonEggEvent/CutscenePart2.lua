-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContentProvider = game:GetService("ContentProvider")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local BulkFade = require(ReplicatedStorage.Client.Modules.BulkFade)
local CutsceneHelperFunctions = require(script.Parent.Parent.Parent.CutsceneHelperFunctions)

require(ReplicatedStorage.Packages.Trove)

local CurrentCamera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local function restoreCamera() -- line: 26
    -- upvalues: TweenService (copy), CurrentCamera (copy), LocalPlayer (copy)
    TweenService:Create(CurrentCamera, TweenInfo.new(0), {
        FieldOfView = 70
    }):Play()
    CurrentCamera.FieldOfView = 70
    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") or nil
    LocalPlayer.ReplicationFocus = nil
end

return function(p1) -- line: 38
    -- upvalues: ContentProvider (copy), Debris (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), TweenService (copy), Workspace (copy), BulkFade (copy), CutsceneHelperFunctions (copy), CurrentCamera (copy), LocalPlayer (copy), restoreCamera (copy)
    local v1 = CutsceneHelperFunctions.GetHelperFunctions(p1)
    local SetProperty, TweenProperty, _, LoadAnimationIntoRig = v1.SetProperty, v1.TweenProperty, v1.PlaySequenceAsync, v1.LoadAnimationIntoRig
    local DragonEggEventCutscene2 = ReplicatedStorage.CutsceneAssets.DragonEggEvent.DragonEggEventCutscene2
    local CutsceneUI = LocalPlayer.PlayerGui.CutsceneUI
    local CutsceneMusic = script.CutsceneMusic
    local Black = CutsceneUI.Black
    local clone
    local t1 = {
        [0] = {
            SetProperty("Workspace.CurrentCamera.FieldOfView", 25),
            SetProperty("Workspace.World.Build.1.BOTTOMS.Footprint.Meshes/untitled2 (1).CFrame", CFrame.new(3438.9807, 35.8888, -354.9071, -0.3907, 0, 0.9205, 0, 1, 0, -0.9205, 0, -0.3907)),
            SetProperty("Workspace.World.Build.1.BOTTOMS.Footprint.FogMesh.CFrame", CFrame.new(3438.9807, 35.6132, -354.9067, 0.5446, 0, -0.8387, 0, 1, 0, 0.8387, 0, 0.5446)),
            SetProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", 0),
            TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.8333333333333334, Enum.EasingStyle.Linear), 1),
            SetProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", 1),
            SetProperty("Lighting.CutsceneBlur.Enabled", true),
            SetProperty("Lighting.CutsceneBlur.Size", 2)
        },
        [326] = {
            function() -- line: 76
                -- upvalues: clone (ref)
                for _, descendant in clone.Charge.Orb:GetDescendants() do
                    if descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = true
                    end
                end
            end
        },
        [457] = {
            function() -- line: 88
                -- upvalues: clone (ref)
                for _, descendant in clone.Charge.Ball:GetDescendants() do
                    if descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = true
                    end
                end
            end
        },
        [484] = {
            function() -- line: 100
                -- upvalues: clone (ref)
                for _, descendant in clone.Charge.Orb:GetDescendants() do
                    if descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = false
                    end
                end
            end
        },
        [622] = {
            function() -- line: 112
                -- upvalues: clone (ref)
                for _, descendant in clone.Charge.Ball:GetDescendants() do
                    if descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = false
                    end
                end
            end
        },
        [821] = {
            TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(1.3333333333333333, Enum.EasingStyle.Linear), 0),
            TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 20)
        },
        [822] = {
            TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(1.9833333333333334, Enum.EasingStyle.Linear), 30),
            TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(1.2, Enum.EasingStyle.Linear), 4)
        },
        [917] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.26666666666666666, Enum.EasingStyle.Linear), 0.5) },
        [930] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.15, Enum.EasingStyle.Linear), 15) },
        [933] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.23333333333333334, Enum.EasingStyle.Linear), 1) },
        [939] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.4, Enum.EasingStyle.Linear), 2) },
        [941] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.7833333333333333, Enum.EasingStyle.Linear), 25) },
        [943] = {
            TweenProperty("Workspace.World.Build.1.BOTTOMS.Footprint.Meshes/untitled2 (1).CFrame", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), CFrame.new(3438.9807, 69.4803, -354.9071, -0.3907, 0, 0.9205, 0, 1, 0, -0.9205, 0, -0.3907)),
            TweenProperty("Workspace.World.Build.1.BOTTOMS.Footprint.FogMesh.CFrame", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), CFrame.new(3438.9807, 69.2047, -354.9067, 0.5446, 0, -0.8387, 0, 1, 0, 0.8387, 0, 0.5446)),
            SetProperty("Workspace.World.Build.1.BOTTOMS.Floor.Transparency", 1)
        },
        [946] = {
            function() -- line: 204
                -- upvalues: clone (ref)
                local Stomp = clone.Stomp

                local function check(p2) -- line: 207
                    return p2 ~= nil and p2 ~= 0
                end

                for _, descendant in Stomp:GetDescendants() do
                    if descendant:IsA("ParticleEmitter") then
                        local EmitCount = descendant:GetAttribute("EmitCount")
                        local EmitDuration = descendant:GetAttribute("EmitDuration")

                        if EmitCount ~= nil and EmitCount ~= 0 then
                            descendant:Emit(EmitCount)
                        end

                        if EmitDuration ~= nil and EmitDuration ~= 0 then
                            descendant.Enabled = true
                            task.delay(EmitDuration, function() -- line: 222
                                -- upvalues: descendant (copy)
                                descendant.Enabled = false
                            end)
                        end
                    end
                end
            end,
            function() -- line: 227
                -- upvalues: clone (ref)
                for _, descendant in clone.Decay:GetDescendants() do
                    if descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = true
                    end
                end
            end
        },
        [957] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(1.3833333333333333, Enum.EasingStyle.Linear), 1) },
        [1200] = {},
        [1380] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(1.6833333333333333, Enum.EasingStyle.Linear), 50) },
        [1410] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.5, Enum.EasingStyle.Linear), 1) }
    }

    return {
        Run = function() -- Run | line: 283
            -- upvalues: p1 (copy), SetProperty (copy), LoadAnimationIntoRig (copy), DragonEggEventCutscene2 (copy), CutsceneUI (copy), CutsceneMusic (copy), Black (copy), clone (ref), t1 (copy), ContentProvider (copy), Debris (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), TweenService (copy), Workspace (copy), BulkFade (copy), CurrentCamera (copy), LocalPlayer (copy), restoreCamera (copy)
            Workspace.World.Build:WaitForChild("AAEventProps")
            task.wait()

            local function v2() -- line: 288
                -- upvalues: TweenService (copy), Workspace (copy)
                task.spawn(function() -- line: 289
                    -- upvalues: TweenService (copy), Workspace (copy)
                    local DragonEggEventMusic = Workspace:FindFirstChild("DragonEggEventMusic")

                    if DragonEggEventMusic then
                        TweenService:Create(DragonEggEventMusic, TweenInfo.new(1), {
                            Volume = 0
                        }):Play()
                    end
                end)
            end

            pcall(v2)

            local t3 = {}

            for _, child in script.LightingAssets:GetChildren() do
                if not Lighting:FindFirstChild(child.Name) then
                    local clone = child:Clone()

                    clone.Parent = Lighting
                    p1:Add(clone)
                    table.insert(t3, clone)
                end
            end

            CutsceneUI.Enabled = true
            Black.BackgroundTransparency = 1
            Black.Visible = true

            local clone2 = script.CutsceneVFX:Clone()

            clone2.Parent = Workspace
            clone = clone2
            p1:Add(clone2)
            TweenService:Create(Black, TweenInfo.new(0.1), {
                BackgroundTransparency = 0
            }):Play()
            p1:Add(function() -- line: 320
                -- upvalues: Black (copy)
                Black.BackgroundTransparency = 1
                Black.Visible = false
            end)

            local clone3 = DragonEggEventCutscene2:Clone()

            for _, child in clone3:GetChildren() do
                if child:IsA("Model") and child.PrimaryPart then
                    child.PrimaryPart.Anchored = true
                end
            end

            clone3.Parent = workspace
            p1:Add(clone3)

            local t4 = {}

            for _, child in clone3:GetChildren() do
                local Animation = child:FindFirstChildOfClass("Animation")

                if Animation then
                    table.insert(t4, Animation)
                end
            end

            ContentProvider:PreloadAsync(t4)

            local t5 = {}

            for _, child in clone3:GetChildren() do
                local Animation = child:FindFirstChildOfClass("Animation")

                if Animation then
                    t5[child] = LoadAnimationIntoRig(child, Animation.AnimationId)
                end
            end

            local v3 = true

            p1:Add(function() -- line: 355
                -- upvalues: v3 (ref)
                v3 = false
            end)
            p1:Add(function() -- line: 356
                -- upvalues: v3 (ref), restoreCamera (copy)
                if v3 then
                    restoreCamera()
                end
            end)

            for _, v4 in t5 do
                v4:Play(0)
            end

            local v5 = t5[clone3["Camera Rig"]]

            assert(v5, "Camera Rig needs an Animation")

            local v6 = os.clock() + 2

            while v3 and v5.TimePosition <= 0 and os.clock() < v6 do
                RunService.RenderStepped:Wait()
            end

            local Vignette = CutsceneUI.Vignette

            p1:Add(function() -- line: 377
                -- upvalues: Vignette (copy)
                Vignette.Visible = false
                Vignette.ImageTransparency = 1
            end)
            CutsceneMusic:Play()

            local Cam = clone3["Camera Rig"].Cam
            local connection

            connection = RunService.RenderStepped:Connect(function() -- line: 389
                -- upvalues: v3 (ref), Cam (copy), connection (ref), CurrentCamera (copy), LocalPlayer (copy)
                if not v3 then
                    connection:Disconnect()

                    return
                end

                CurrentCamera.CameraType = Enum.CameraType.Scriptable
                LocalPlayer.ReplicationFocus = Cam
                CurrentCamera.Focus = Cam.CFrame
                CurrentCamera.CFrame = Cam.CFrame
            end)

            local t6 = {}
            local n1 = 0
            local n2 = 0.1
            local connection2 = RunService.Heartbeat:Connect(function(p3) -- line: 403
                -- upvalues: t5 (copy), t6 (copy), n1 (ref), n2 (ref), CutsceneMusic (copy), t1 (copy)
                n1 += p3
                n2 -= 0.1

                if n2 <= 0 then
                    n2 = 0.1

                    for _, v7 in t5 do
                        if v7.IsPlaying then
                            local v9 = n1

                            if math.abs(v9 - v7.TimePosition) >= 0.1 then
                                local function v10() -- line: 415
                                    -- upvalues: v7 (copy), n1 (ref)
                                    v7.TimePosition = n1
                                end

                                local _warn = warn

                                xpcall(v10, _warn)
                            end
                        end
                    end
                end

                if CutsceneMusic.TimePosition < n1 - 0.001 then
                    CutsceneMusic.PlaybackSpeed = 1.01
                elseif CutsceneMusic.TimePosition > n1 + 0.001 then
                    CutsceneMusic.PlaybackSpeed = 0.99
                else
                    CutsceneMusic.PlaybackSpeed = 1
                end

                for i = 0, 9 do
                    local v12 = math.floor(n1 * 60 - i)

                    if t1[v12] and not t6[v12] then
                        t6[v12] = true

                        for _, v13 in t1[v12] do
                            task.spawn(v13)
                        end
                    end
                end
            end)

            p1:Add(connection2)
            task.wait(24.666666666666668)
            connection2:Disconnect()

            local function v14() -- line: 445
                -- upvalues: clone2 (copy)
                clone2:Destroy()
            end

            local _warn = warn

            xpcall(v14, _warn)
            v3 = false
            Vignette.Visible = false

            local function v15() -- line: 451
                -- upvalues: t3 (copy)
                for _, v16 in t3 do
                    v16:Destroy()
                end
            end

            local _warn2 = warn

            xpcall(v15, _warn2)

            local function v17() -- line: 457
                -- upvalues: clone3 (copy)
                clone3:Destroy()
            end

            local _warn3 = warn

            xpcall(v17, _warn3)

            local function v18() -- line: 459
                -- upvalues: TweenService (copy), Workspace (copy)
                task.spawn(function() -- line: 460
                    -- upvalues: TweenService (copy), Workspace (copy)
                    local DragonEggEventMusic = Workspace:FindFirstChild("DragonEggEventMusic")

                    if DragonEggEventMusic then
                        TweenService:Create(DragonEggEventMusic, TweenInfo.new(1), {
                            Volume = 0.5
                        }):Play()
                    end
                end)
            end

            pcall(v18)

            local v19 = BulkFade.new(CutsceneUI.MonstersAreComing, TweenInfo.new(1))

            v19:FadeOutInstant()
            task.wait()
            v19:FadeIn()
            CutsceneUI.MonstersAreComing.Visible = true
            task.spawn(function() -- line: 477
                -- upvalues: CutsceneUI (copy)
                local function toDHMS(p4) -- line: 478
                    return string.format("%02i:%02i:%02i:%02i", p4 / 86400, p4 / 3600 % 24, p4 / 60 % 60, p4 % 60)
                end

                script.Roar:Play()

                local n3 = 604799

                while CutsceneUI.MonstersAreComing.Visible do
                    CutsceneUI.MonstersAreComing.TimeRemaining.Text = toDHMS(n3)
                    script.ClockTick:Play()
                    task.wait(1)
                    n3 -= 1
                end
            end)
            task.wait(5)

            local clone4 = ReplicatedStorage.CutsceneAssets.DragonEggEvent.DragonEggEventRareEgg:Clone()

            for _, descendant in clone4:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.Anchored = true
                end
            end

            p1:Add(clone4)
            Debris:AddItem(clone4, 20)
            clone4.Parent = Workspace
            CurrentCamera.CameraType = Enum.CameraType.Scriptable
            CurrentCamera.CFrame = CFrame.lookAt(Vector3.new(3307, 100, -341), clone4:GetPivot().Position)
            CurrentCamera.FieldOfView = 40
            TweenService:Create(Black, TweenInfo.new(1), {
                BackgroundTransparency = 1
            }):Play()
            v19:FadeOut()

            local function v20() -- line: 518
                -- upvalues: Workspace (copy)
                Workspace.World.Build["1"].BOTTOMS.Floor.Transparency = 0
                Workspace.World.Build["1"].BOTTOMS.Footprint["Meshes/untitled2 (1)"].Position = Vector3.new(0, 0, 0)
                Workspace.World.Build["1"].BOTTOMS.Footprint.FogMesh.Position = Vector3.new(0, 0, 0)
            end

            pcall(v20)

            local function v21() -- line: 527
                -- upvalues: SetProperty (copy)
                SetProperty("Workspace.World.Build.1.BOTTOMS.Footprint.Meshes/untitled2 (1).Position", (Vector3.new(0, 0, 0)))()
                SetProperty("Workspace.World.Build.1.BOTTOMS.Footprint.FogMesh.Position", (Vector3.new(0, 0, 0)))()
            end

            pcall(v21)
            TweenService:Create(CurrentCamera, TweenInfo.new(4.5), {
                FieldOfView = 35
            }):Play()
            task.wait(1)
            Black.Visible = false
            CutsceneUI.MonstersAreComing.Visible = false
            task.wait(5)

            local Character = LocalPlayer.Character

            if Character then
                Character:FindFirstChild("HumanoidRootPart")
            end

            TweenService:Create(CurrentCamera, TweenInfo.new(5), {
                FieldOfView = 70,
                CFrame = CFrame.lookAt(Vector3.new(485, 100.5, -365), (Vector3.new(515, 80.5, -365)))
            }):Play()
            task.wait(5)

            local _warn4 = warn

            xpcall(restoreCamera, _warn4)

            local function v22() -- line: 560
                -- upvalues: Workspace (copy)
                Workspace.World.Build["1"].BOTTOMS.Floor.Transparency = 0
            end

            local _warn5 = warn

            xpcall(v22, _warn5)

            local function v23() -- line: 561
                -- upvalues: clone4 (copy)
                clone4:Destroy()
            end

            pcall(v23)
        end
    }
end
