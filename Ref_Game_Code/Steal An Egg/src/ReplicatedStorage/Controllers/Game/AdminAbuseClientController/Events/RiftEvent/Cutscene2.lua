-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContentProvider = game:GetService("ContentProvider")

game:GetService("Debris")

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

require(ReplicatedStorage.Client.Modules.BulkFade)

local CutsceneHelperFunctions = require(script.Parent.Parent.Parent.CutsceneHelperFunctions)

require(ReplicatedStorage.Packages.Trove)

local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local Tabs = require(ReplicatedStorage.Client.Tabs)

require(ReplicatedStorage.Shared.Remotes)

local CurrentCamera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local v1, t1, v2, t2
local t3 = {
    Enum.CoreGuiType.Backpack,
    Enum.CoreGuiType.Chat,
    Enum.CoreGuiType.PlayerList,
    Enum.CoreGuiType.Health,
    Enum.CoreGuiType.EmotesMenu
}

local function restoreCamera() -- line: 44
    -- upvalues: TweenService (copy), CurrentCamera (copy), LocalPlayer (copy)
    TweenService:Create(CurrentCamera, TweenInfo.new(0), {
        FieldOfView = 70
    }):Play()
    CurrentCamera.FieldOfView = 70
    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") or nil
    LocalPlayer.ReplicationFocus = nil
end

local function hideAllUi() -- line: 54
    -- upvalues: StarterGui (copy), Tabs (copy), LocalPlayer (copy), t1 (ref), v2 (ref), t2 (ref), t3 (copy)
    if t1 ~= nil then
        return
    end

    local t4 = {}

    v2 = Tabs.Active()

    for _, child in LocalPlayer:WaitForChild("PlayerGui"):GetChildren() do
        if child:IsA("ScreenGui") and child.Name ~= "DragonCinematic" and child.Enabled then
            t4[child] = true
            child.Enabled = false
        end
    end

    t1 = t4

    local function v3() -- line: 69
        -- upvalues: LocalPlayer (copy)
        LocalPlayer.PlayerGui.BottomUI.BottomFrame.Holder.List.Visible = false
    end

    pcall(v3)

    local t5 = {}

    for _, v4 in t3 do
        t5[v4] = StarterGui:GetCoreGuiEnabled(v4)
        StarterGui:SetCoreGuiEnabled(v4, false)
    end

    t2 = t5
end

local function restoreAllUi() -- line: 79
    -- upvalues: StarterGui (copy), LocalPlayer (copy), t1 (ref), v2 (ref), t2 (ref)
    local t6 = t1
    local v5 = v2

    t1 = nil
    v2 = nil

    if t6 ~= nil then
        for v6 in t6 do
            if v6.Parent ~= nil and v6.Name ~= v5 then
                v6.Enabled = true
            end
        end
    end

    local function v7() -- line: 92
        -- upvalues: LocalPlayer (copy)
        LocalPlayer.PlayerGui.BottomUI.BottomFrame.Holder.List.Visible = true
    end

    pcall(v7)

    local t7 = t2

    t2 = nil

    if t7 ~= nil then
        for v8, v9 in t7 do
            StarterGui:SetCoreGuiEnabled(v8, v9)
        end
    end

    return v5
end

local function hideCutsceneUi() -- line: 104
    -- upvalues: HiddenUIHandler (copy), v1 (ref), hideAllUi (copy)
    if v1 == nil then
        v1 = HiddenUIHandler.Acquire()
    end

    hideAllUi()
end

local function restoreCutsceneUi() -- line: 111
    -- upvalues: Tabs (copy), v1 (ref), restoreAllUi (copy)
    local v10 = restoreAllUi()
    local v11 = v1

    v1 = nil

    if v11 ~= nil then
        v11()
    end

    if v10 ~= nil then
        Tabs.Activate(v10, {
            instant = true
        })
    end
end

local function setTransparency(p1, p2) -- line: 123
    for _, v12 in p1 do
        if v12:IsA("BasePart") then
            if not v12:GetAttribute("OriginalTransparency") then
                v12:SetAttribute("OriginalTransparency", v12.Transparency)
            end

            v12.Transparency = p2 or v12:GetAttribute("OriginalTransparency")
        end
    end
end

return function(p3) -- line: 136
    -- upvalues: ContentProvider (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), TweenService (copy), Workspace (copy), CutsceneHelperFunctions (copy), Tabs (copy), CurrentCamera (copy), LocalPlayer (copy), v1 (ref), restoreCamera (copy), restoreAllUi (copy), hideCutsceneUi (copy), setTransparency (copy)
    local v13 = CutsceneHelperFunctions.GetHelperFunctions(p3)
    local SetProperty, TweenProperty, _, LoadAnimationIntoRig = v13.SetProperty, v13.TweenProperty, v13.PlaySequenceAsync, v13.LoadAnimationIntoRig
    local RiftCutscene2 = ReplicatedStorage.CutsceneAssets.RiftCutsceneAssets.RiftCutscene2
    local CutsceneUI = LocalPlayer.PlayerGui.CutsceneUI
    local CutsceneMusic = script.CutsceneMusic
    local Black, Vignette = CutsceneUI.Black, CutsceneUI.Vignette
    local clone
    local t8 = {
        [0] = {
            SetProperty("Workspace.CurrentCamera.CFrame", CFrame.new(4804.1978, 73.1938, -341.0876, -0.8189, -0.0967, 0.5657, 0, 0.9857, 0.1684, -0.5739, 0.1379, -0.8073)),
            TweenProperty("Workspace.CurrentCamera.CFrame", TweenInfo.new(26.65, Enum.EasingStyle.Linear), CFrame.new(4795.2813, 70.9149, -313.1396, -0.9998, -0.0092, -0.0186, -0.0054, 0.9809, -0.1945, 0.0201, -0.1944, -0.9807)),
            SetProperty("Workspace.CurrentCamera.FieldOfView", 70),
            TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.5166666666666667, Enum.EasingStyle.Linear), 45),
            SetProperty("Lighting.CutsceneBlur.Enabled", true),
            SetProperty("Lighting.CutsceneBlur.Size", 25),
            TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.7833333333333333, Enum.EasingStyle.Linear), 2)
        },
        [31] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.4, Enum.EasingStyle.Linear), 35) },
        [55] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.9, Enum.EasingStyle.Linear), 45) },
        [57] = {
            function() -- line: 172
                -- upvalues: clone (ref)
                local Smoke = clone.Smoke

                local function check(p4) -- line: 175
                    return p4 ~= nil and p4 ~= 0
                end

                for _, descendant in pairs(Smoke:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        local EmitCount = descendant:GetAttribute("EmitCount")
                        local EmitDuration = descendant:GetAttribute("EmitDuration")
                        local v14 = descendant:GetAttribute("EmitDelay") or 0

                        local function triggerParticles() -- line: 186
                            -- upvalues: descendant (copy), EmitCount (copy), EmitDuration (copy)
                            if EmitCount ~= nil and EmitCount ~= 0 then
                                descendant:Emit(EmitCount)
                            end

                            if EmitDuration ~= nil and EmitDuration ~= 0 then
                                descendant.Enabled = true
                                task.delay(EmitDuration, function() -- line: 193
                                    -- upvalues: descendant (copy)
                                    descendant.Enabled = false
                                end)
                            end
                        end

                        if v14 ~= nil and v14 ~= 0 then
                            task.delay(v14, triggerParticles)
                        else
                            triggerParticles()
                        end
                    end
                end
            end
        },
        [59] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.11666666666666667, Enum.EasingStyle.Linear), 10) },
        [66] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 4) },
        [103] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.11666666666666667, Enum.EasingStyle.Linear), 10) },
        [105] = {
            function() -- line: 221
                -- upvalues: clone (ref)
                local Smoke2 = clone.Smoke2

                local function check(p5) -- line: 224
                    return p5 ~= nil and p5 ~= 0
                end

                for _, descendant in pairs(Smoke2:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        local EmitCount = descendant:GetAttribute("EmitCount")
                        local EmitDuration = descendant:GetAttribute("EmitDuration")
                        local v15 = descendant:GetAttribute("EmitDelay") or 0

                        local function triggerParticles() -- line: 235
                            -- upvalues: descendant (copy), EmitCount (copy), EmitDuration (copy)
                            if EmitCount ~= nil and EmitCount ~= 0 then
                                descendant:Emit(EmitCount)
                            end

                            if EmitDuration ~= nil and EmitDuration ~= 0 then
                                descendant.Enabled = true
                                task.delay(EmitDuration, function() -- line: 242
                                    -- upvalues: descendant (copy)
                                    descendant.Enabled = false
                                end)
                            end
                        end

                        if v15 ~= nil and v15 ~= 0 then
                            task.delay(v15, triggerParticles)
                        else
                            triggerParticles()
                        end
                    end
                end
            end
        },
        [110] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 4) },
        [137] = {
            function() -- line: 262
                -- upvalues: clone (ref)
                local Smoke3 = clone.Smoke3

                local function check(p6) -- line: 265
                    return p6 ~= nil and p6 ~= 0
                end

                for _, descendant in pairs(Smoke3:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        local EmitCount = descendant:GetAttribute("EmitCount")
                        local EmitDuration = descendant:GetAttribute("EmitDuration")
                        local v16 = descendant:GetAttribute("EmitDelay") or 0

                        local function triggerParticles() -- line: 276
                            -- upvalues: descendant (copy), EmitCount (copy), EmitDuration (copy)
                            if EmitCount ~= nil and EmitCount ~= 0 then
                                descendant:Emit(EmitCount)
                            end

                            if EmitDuration ~= nil and EmitDuration ~= 0 then
                                descendant.Enabled = true
                                task.delay(EmitDuration, function() -- line: 283
                                    -- upvalues: descendant (copy)
                                    descendant.Enabled = false
                                end)
                            end
                        end

                        if v16 ~= nil and v16 ~= 0 then
                            task.delay(v16, triggerParticles)
                        else
                            triggerParticles()
                        end
                    end
                end
            end
        },
        [138] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.11666666666666667, Enum.EasingStyle.Linear), 10) },
        [145] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 4) },
        [155] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.18333333333333332, Enum.EasingStyle.Linear), 9) },
        [166] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.7333333333333333, Enum.EasingStyle.Linear), 2) },
        [890] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.3333333333333333, Enum.EasingStyle.Linear), 8) },
        [892] = {
            function() -- line: 319
                -- upvalues: clone (ref)
                local Roar = clone:WaitForChild("Roar")

                for _, descendant in ipairs(Roar:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = true
                    end
                end
            end
        },
        [910] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.8, Enum.EasingStyle.Linear), 2) },
        [927] = {
            function() -- line: 335
                -- upvalues: clone (ref)
                local Roar = clone:WaitForChild("Roar")

                for _, descendant in ipairs(Roar:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = false
                    end
                end
            end
        },
        [1324] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(2.566666666666667, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 75) },
        [1392] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.3, Enum.EasingStyle.Linear), 10) }
    }

    t8[1420] = {
        function() -- line: 355
            local Charge = workspace:WaitForChild("RiftCutscene2"):WaitForChild("Portal"):WaitForChild("Charge")

            for _, descendant in ipairs(Charge:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = true
                end
            end
        end
    }
    t8[1430] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.45, Enum.EasingStyle.Linear), 2) }
    t8[1599] = {
        TweenProperty("Workspace.CurrentCamera.CFrame", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), CFrame.new(4795.5762, 69.3859, -353.8327, 0.6834, 0, -0.7301, 0.0038, 1, 0.0036, 0.7301, -0.0052, 0.6834)),
        TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 35)
    }
    t8[1600] = { TweenProperty("Workspace.CurrentCamera.CFrame", TweenInfo.new(9.333333333333334, Enum.EasingStyle.Linear), CFrame.new(4791.5317, 69.3774, -356.0904, 0.5039, 0.0021, -0.8638, 0.0106, 0.9999, 0.0086, 0.8637, -0.0135, 0.5038)) }
    t8[1713] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 55) }
    t8[1788] = {
        function() -- line: 384
            local EggSpawn = workspace.RiftCutscene2.Portal.EggSpawn

            local function check(p7) -- line: 387
                return p7 ~= nil and p7 ~= 0
            end

            for _, descendant in pairs(EggSpawn:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    local EmitCount = descendant:GetAttribute("EmitCount")
                    local EmitDuration = descendant:GetAttribute("EmitDuration")
                    local v17 = descendant:GetAttribute("EmitDelay") or 0

                    local function triggerParticles() -- line: 398
                        -- upvalues: descendant (copy), EmitCount (copy), EmitDuration (copy)
                        if EmitCount ~= nil and EmitCount ~= 0 then
                            descendant:Emit(EmitCount)
                        end

                        if EmitDuration ~= nil and EmitDuration ~= 0 then
                            descendant.Enabled = true
                            task.delay(EmitDuration, function() -- line: 405
                                -- upvalues: descendant (copy)
                                descendant.Enabled = false
                            end)
                        end
                    end

                    if v17 ~= nil and v17 ~= 0 then
                        task.delay(v17, triggerParticles)
                    else
                        triggerParticles()
                    end
                end
            end
        end
    }
    t8[1843] = {
        function() -- line: 421
            local Charge = workspace:WaitForChild("RiftCutscene2"):WaitForChild("Portal"):WaitForChild("Charge")

            for _, descendant in ipairs(Charge:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = false
                end
            end
        end
    }
    t8[1896] = {
        function() -- line: 433
            -- upvalues: clone (ref)
            local Smoke4 = clone.Smoke4

            local function check(p8) -- line: 436
                return p8 ~= nil and p8 ~= 0
            end

            for _, descendant in pairs(Smoke4:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    local EmitCount = descendant:GetAttribute("EmitCount")
                    local EmitDuration = descendant:GetAttribute("EmitDuration")
                    local v18 = descendant:GetAttribute("EmitDelay") or 0

                    local function triggerParticles() -- line: 447
                        -- upvalues: descendant (copy), EmitCount (copy), EmitDuration (copy)
                        if EmitCount ~= nil and EmitCount ~= 0 then
                            descendant:Emit(EmitCount)
                        end

                        if EmitDuration ~= nil and EmitDuration ~= 0 then
                            descendant.Enabled = true
                            task.delay(EmitDuration, function() -- line: 454
                                -- upvalues: descendant (copy)
                                descendant.Enabled = false
                            end)
                        end
                    end

                    if v18 ~= nil and v18 ~= 0 then
                        task.delay(v18, triggerParticles)
                    else
                        triggerParticles()
                    end
                end
            end
        end
    }
    t8[1897] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 40) }
    t8[1923] = {
        function() -- line: 474
            -- upvalues: clone (ref)
            local Smoke5 = clone.Smoke5

            local function check(p9) -- line: 477
                return p9 ~= nil and p9 ~= 0
            end

            for _, descendant in pairs(Smoke5:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    local EmitCount = descendant:GetAttribute("EmitCount")
                    local EmitDuration = descendant:GetAttribute("EmitDuration")
                    local v19 = descendant:GetAttribute("EmitDelay") or 0

                    local function triggerParticles() -- line: 488
                        -- upvalues: descendant (copy), EmitCount (copy), EmitDuration (copy)
                        if EmitCount ~= nil and EmitCount ~= 0 then
                            descendant:Emit(EmitCount)
                        end

                        if EmitDuration ~= nil and EmitDuration ~= 0 then
                            descendant.Enabled = true
                            task.delay(EmitDuration, function() -- line: 495
                                -- upvalues: descendant (copy)
                                descendant.Enabled = false
                            end)
                        end
                    end

                    if v19 ~= nil and v19 ~= 0 then
                        task.delay(v19, triggerParticles)
                    else
                        triggerParticles()
                    end
                end
            end
        end
    }
    t8[2115] = {
        function() -- line: 511
            -- upvalues: Black (copy), TweenService (copy)
            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 0
            }):Play()
        end
    }

    return {
        Run = function() -- Run | line: 518
            -- upvalues: p3 (copy), LoadAnimationIntoRig (copy), RiftCutscene2 (copy), CutsceneUI (copy), CutsceneMusic (copy), Black (copy), Vignette (copy), clone (ref), t8 (copy), ContentProvider (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), TweenService (copy), Workspace (copy), Tabs (copy), CurrentCamera (copy), LocalPlayer (copy), v1 (ref), restoreCamera (copy), restoreAllUi (copy), hideCutsceneUi (copy), setTransparency (copy)
            local v20 = false
            local _warn = warn

            xpcall(hideCutsceneUi, _warn)

            local function v21() -- line: 523
                -- upvalues: LocalPlayer (copy)
                LocalPlayer.PlayerGui.BossFightUI.Enabled = false
            end

            pcall(v21)
            p3:Add(function() -- line: 527
                -- upvalues: v20 (ref), ReplicatedStorage (copy), Tabs (copy), LocalPlayer (copy), v1 (ref), restoreAllUi (copy)
                if v20 then
                    return
                end

                local v22 = restoreAllUi()
                local v23 = v1

                v1 = nil

                if v23 ~= nil then
                    v23()
                end

                if v22 ~= nil then
                    Tabs.Activate(v22, {
                        instant = true
                    })
                end

                LocalPlayer.PlayerGui.BossFightUI.Enabled = false
                ReplicatedStorage.Controllers.Game.BossEventClientController.BossArenaMusic.Volume = 0
                v20 = true
            end)

            local AreaEggSlotsClient = Workspace:FindFirstChild("AreaEggSlotsClient")

            local function v24() -- line: 537
                -- upvalues: AreaEggSlotsClient (copy), p3 (copy), ReplicatedStorage (copy), Workspace (copy)
                AreaEggSlotsClient.Parent = ReplicatedStorage
                p3:Add(function() -- line: 539
                    -- upvalues: AreaEggSlotsClient (copy), Workspace (copy)
                    AreaEggSlotsClient.Parent = Workspace
                end)
            end

            pcall(v24)

            local GuardAreas = game.Workspace.World.Areas.GuardAreas
            local t10 = {}

            for _, child in (GuardAreas:GetChildren()) do
                local Guard = child.Guard

                t10[Guard] = child
                Guard.Parent = nil
                p3:Add(function() -- line: 550
                    -- upvalues: child (copy), Guard (copy)
                    Guard.Parent = child
                end)
            end

            local Descendants = game.Workspace.World.Areas.GuardAreas["Titan Temple"].Nests:GetDescendants()

            setTransparency(Descendants, 1)
            p3:Add(function() -- line: 557
                -- upvalues: Descendants (copy), setTransparency (copy)
                setTransparency(Descendants)
            end)

            local function v25() -- line: 561
                -- upvalues: TweenService (copy), Workspace (copy)
                task.spawn(function() -- line: 562
                    -- upvalues: TweenService (copy), Workspace (copy)
                    local DragonEggEventMusic = Workspace:FindFirstChild("DragonEggEventMusic")

                    if DragonEggEventMusic then
                        TweenService:Create(DragonEggEventMusic, TweenInfo.new(1), {
                            Volume = 0
                        }):Play()
                    end
                end)
            end

            pcall(v25)

            local t11 = {}

            for _, child in script.LightingAssets:GetChildren() do
                if not Lighting:FindFirstChild(child.Name) then
                    local clone = child:Clone()

                    clone.Parent = Lighting
                    p3:Add(clone)
                    table.insert(t11, clone)
                end
            end

            CutsceneUI.Enabled = true
            Black.BackgroundTransparency = 1
            Black.Visible = true
            Vignette.Visible = false
            p3:Add(function() -- line: 588
                -- upvalues: Vignette (copy)
                Vignette.Visible = false
                Vignette.ImageTransparency = 1
            end)

            local clone2 = script.CutsceneVFX:Clone()

            clone2.Parent = Workspace
            clone = clone2
            p3:Add(clone2)
            TweenService:Create(Black, TweenInfo.new(0.1), {
                BackgroundTransparency = 0
            }):Play()
            p3:Add(function() -- line: 599
                -- upvalues: Black (copy)
                Black.BackgroundTransparency = 1
                Black.Visible = false
            end)

            local clone3 = RiftCutscene2:Clone()

            for _, child in clone3:GetChildren() do
                if child:IsA("Model") and child.PrimaryPart then
                    child.PrimaryPart.Anchored = true
                end
            end

            clone3.Parent = workspace
            p3:Add(clone3)

            local t12 = {}

            for _, child in clone3:GetChildren() do
                local Animation = child:FindFirstChildOfClass("Animation")

                if Animation then
                    table.insert(t12, Animation)
                end
            end

            ContentProvider:PreloadAsync(t12)

            local t13 = {}

            for _, child in clone3:GetChildren() do
                local Animation = child:FindFirstChildOfClass("Animation")

                if Animation then
                    t13[child] = LoadAnimationIntoRig(child, Animation.AnimationId)
                end
            end

            local v26 = true

            p3:Add(function() -- line: 634
                -- upvalues: v26 (ref)
                v26 = false
            end)
            p3:Add(function() -- line: 635
                -- upvalues: v26 (ref), restoreCamera (copy)
                if v26 then
                    restoreCamera()
                end
            end)

            for _, v27 in t13 do
                v27:Play(0)
            end

            local v28 = t13[clone3["Camera Rig"]]

            assert(v28, "Camera Rig needs an Animation")

            local v29 = os.clock() + 2

            while v26 and v28.TimePosition <= 0 and os.clock() < v29 do
                RunService.RenderStepped:Wait()
            end

            CutsceneMusic:Play()

            local Cam = clone3["Camera Rig"].Cam
            local connection

            connection = RunService.RenderStepped:Connect(function() -- line: 662
                -- upvalues: v26 (ref), Cam (copy), connection (ref), CurrentCamera (copy), LocalPlayer (copy)
                if not v26 then
                    connection:Disconnect()

                    return
                end

                CurrentCamera.CameraType = Enum.CameraType.Scriptable
                LocalPlayer.ReplicationFocus = Cam
                CurrentCamera.Focus = Cam.CFrame
                CurrentCamera.CFrame = Cam.CFrame
            end)

            local t14 = {}
            local n1 = 0
            local n2 = 0.1
            local connection2 = RunService.Heartbeat:Connect(function(p10) -- line: 676
                -- upvalues: t13 (copy), t14 (copy), n1 (ref), n2 (ref), CutsceneMusic (copy), t8 (copy)
                n1 += p10
                n2 -= 0.1

                if n2 <= 0 then
                    n2 = 0.1

                    for _, v30 in t13 do
                        if v30.IsPlaying then
                            local v32 = n1

                            if math.abs(v32 - v30.TimePosition) >= 0.1 then
                                local function v33() -- line: 688
                                    -- upvalues: v30 (copy), n1 (ref)
                                    v30.TimePosition = n1
                                end

                                local _warn = warn

                                xpcall(v33, _warn)
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
                    local v35 = math.floor(n1 * 60 - i)

                    if t8[v35] and not t14[v35] then
                        t14[v35] = true

                        for _, v36 in t8[v35] do
                            task.spawn(v36)
                        end
                    end
                end
            end)

            p3:Add(connection2)
            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(36.5)
            connection2:Disconnect()

            local function v37() -- line: 720
                -- upvalues: clone2 (copy)
                clone2:Destroy()
            end

            local _warn2 = warn

            xpcall(v37, _warn2)
            v26 = false
            Vignette.Visible = false

            local function v38() -- line: 726
                -- upvalues: t11 (copy)
                for _, v39 in t11 do
                    v39:Destroy()
                end
            end

            local _warn3 = warn

            xpcall(v38, _warn3)

            local function v40() -- line: 732
                -- upvalues: clone3 (copy)
                clone3:Destroy()
            end

            local _warn4 = warn

            xpcall(v40, _warn4)

            local function v41() -- line: 734
                -- upvalues: TweenService (copy), Workspace (copy)
                task.spawn(function() -- line: 735
                    -- upvalues: TweenService (copy), Workspace (copy)
                    local DragonEggEventMusic = Workspace:FindFirstChild("DragonEggEventMusic")

                    if DragonEggEventMusic then
                        TweenService:Create(DragonEggEventMusic, TweenInfo.new(1), {
                            Volume = 0.5
                        }):Play()
                    end
                end)
            end

            pcall(v41)

            local _warn5 = warn

            xpcall(restoreCamera, _warn5)
            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(0.5)
            Black.Visible = false
            Vignette.Visible = false

            local function v42() -- line: 753
                -- upvalues: AreaEggSlotsClient (copy), Workspace (copy)
                AreaEggSlotsClient.Parent = Workspace
            end

            pcall(v42)

            local function v43() -- line: 757
                -- upvalues: v20 (ref), ReplicatedStorage (copy), Tabs (copy), LocalPlayer (copy), v1 (ref), restoreAllUi (copy)
                local v44 = restoreAllUi()
                local v45 = v1

                v1 = nil

                if v45 ~= nil then
                    v45()
                end

                if v44 ~= nil then
                    Tabs.Activate(v44, {
                        instant = true
                    })
                end

                LocalPlayer.PlayerGui.BossFightUI.Enabled = false
                ReplicatedStorage.Controllers.Game.BossEventClientController.BossArenaMusic.Volume = 0
                v20 = true
            end

            local _warn6 = warn

            xpcall(v43, _warn6)
            setTransparency(Descendants)

            for v46, v47 in t10 do
                v46.Parent = v47
            end
        end
    }
end
