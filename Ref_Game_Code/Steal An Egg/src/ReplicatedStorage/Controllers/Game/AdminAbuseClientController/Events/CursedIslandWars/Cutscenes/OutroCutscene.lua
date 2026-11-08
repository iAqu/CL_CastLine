-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContentProvider = game:GetService("ContentProvider")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local CutsceneHelperFunctions = require(script.Parent.Parent.Parent.Parent.CutsceneHelperFunctions)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local LightingController = require(ReplicatedStorage.Controllers.Game.LightingController)
local MusicDirector = require(ReplicatedStorage.Client.MusicDirector)
local Tabs = require(ReplicatedStorage.Client.Tabs)

require(ReplicatedStorage.Packages.Trove)

local OutroCutscene = ReplicatedStorage.CutsceneAssets.CursedIslandWarsCutsceneAssets.OutroCutscene
local t1 = {
    Enum.CoreGuiType.Backpack,
    Enum.CoreGuiType.Chat,
    Enum.CoreGuiType.PlayerList,
    Enum.CoreGuiType.Health,
    Enum.CoreGuiType.EmotesMenu
}
local CurrentCamera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local v1, t2, v2, t3

local function onMap(p1) -- line: 61
    return p1 + Vector3.new(-5849.1543, -207.86574, -6767.256)
end

local function restoreCamera() -- line: 65
    -- upvalues: TweenService (copy), CurrentCamera (copy), LocalPlayer (copy)
    TweenService:Create(CurrentCamera, TweenInfo.new(0), {
        FieldOfView = 70
    }):Play()
    CurrentCamera.FieldOfView = 70
    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") or nil
    LocalPlayer.ReplicationFocus = nil
end

local function hideAllUi() -- line: 74
    -- upvalues: StarterGui (copy), Tabs (copy), t1 (copy), LocalPlayer (copy), t2 (ref), v2 (ref), t3 (ref)
    if t2 ~= nil then
        return
    end

    local t4 = {}

    v2 = Tabs.Active()

    for _, child in LocalPlayer:WaitForChild("PlayerGui"):GetChildren() do
        if child:IsA("ScreenGui") and child.Name ~= "CutsceneUI" and child.Enabled then
            t4[child] = true
            child.Enabled = false
        end
    end

    t2 = t4

    local function v3() -- line: 89
        -- upvalues: LocalPlayer (copy)
        LocalPlayer.PlayerGui.BottomUI.BottomFrame.Holder.List.Visible = false
    end

    pcall(v3)

    local t5 = {}

    for _, v4 in t1 do
        t5[v4] = StarterGui:GetCoreGuiEnabled(v4)
        StarterGui:SetCoreGuiEnabled(v4, false)
    end

    t3 = t5
end

local function restoreAllUi() -- line: 99
    -- upvalues: StarterGui (copy), LocalPlayer (copy), t2 (ref), v2 (ref), t3 (ref)
    local t6 = t2
    local v5 = v2

    t2 = nil
    v2 = nil

    if t6 ~= nil then
        for v6 in t6 do
            if v6.Parent ~= nil and v6.Name ~= v5 then
                v6.Enabled = true
            end
        end
    end

    local function v7() -- line: 112
        -- upvalues: LocalPlayer (copy)
        LocalPlayer.PlayerGui.BottomUI.BottomFrame.Holder.List.Visible = true
    end

    pcall(v7)

    local t7 = t3

    t3 = nil

    if t7 ~= nil then
        for v8, v9 in t7 do
            StarterGui:SetCoreGuiEnabled(v8, v9)
        end
    end

    return v5
end

local function hideCutsceneUi() -- line: 124
    -- upvalues: HiddenUIHandler (copy), v1 (ref), hideAllUi (copy)
    if v1 == nil then
        v1 = HiddenUIHandler.Acquire()
    end

    hideAllUi()
end

local function restoreCutsceneUi() -- line: 131
    -- upvalues: Tabs (copy), v1 (ref), restoreCamera (copy), restoreAllUi (copy)
    restoreCamera()

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

local function setEmitting(p2, p3) -- line: 144
    for _, descendant in p2:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
            descendant.Enabled = p3
        end
    end
end

local function emitBurst(p4) -- line: 153
    for _, descendant in p4:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local EmitCount = descendant:GetAttribute("EmitCount")
            local EmitDuration = descendant:GetAttribute("EmitDuration")
            local EmitDelay = descendant:GetAttribute("EmitDelay")
            local delay = task.delay

            if type(EmitDelay) ~= "number" then
                EmitDelay = 0
            end

            delay(EmitDelay, function() -- line: 162
                -- upvalues: descendant (copy), EmitCount (copy), EmitDuration (copy)
                if type(EmitCount) == "number" and EmitCount ~= 0 then
                    descendant:Emit(EmitCount)
                end

                if type(EmitDuration) == "number" and EmitDuration ~= 0 then
                    descendant.Enabled = true
                    task.delay(EmitDuration, function() -- line: 168
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false
                    end)
                end
            end)
        end
    end
end

return function(p5) -- line: 178
    -- upvalues: ContentProvider (copy), Lighting (copy), RunService (copy), SoundService (copy), TweenService (copy), Workspace (copy), CutsceneHelperFunctions (copy), LightingController (copy), MusicDirector (copy), OutroCutscene (copy), CurrentCamera (copy), LocalPlayer (copy), restoreCamera (copy), hideCutsceneUi (copy), restoreCutsceneUi (copy), setEmitting (copy), emitBurst (copy)
    local v12 = p5:Extend()
    local v13 = CutsceneHelperFunctions.GetHelperFunctions(v12)
    local SetProperty, TweenProperty, LoadAnimationIntoRig = v13.SetProperty, v13.TweenProperty, v13.LoadAnimationIntoRig
    local CutsceneUI = LocalPlayer.PlayerGui.CutsceneUI
    local Black, Vignette = CutsceneUI.Black, CutsceneUI.Vignette
    local clone

    local function breakage(p6) -- line: 191
        return CFrame.new(18.447, p6, -578.4) + Vector3.new(-5849.1543, -207.86574, -6767.256)
    end

    local function linear(p7, p8) -- line: 194
        return TweenInfo.new((p8 - p7) / 60, Enum.EasingStyle.Linear)
    end

    local function sine(p9, p10) -- line: 197
        return TweenInfo.new((p10 - p9) / 60, Enum.EasingStyle.Sine)
    end

    local t8 = {
        [0] = {
            SetProperty("Workspace.CurrentCamera.FieldOfView", 45),
            function() -- line: 204
                -- upvalues: clone (ref), setEmitting (copy)
                setEmitting(clone.Breakage, true)
            end,
            SetProperty("PlayerGui.CutsceneUI.Vignette.Visible", true),
            SetProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", 1),
            SetProperty("Workspace.CursedOutroVFX.Breakage.CFrame", CFrame.new(18.447, 233.985, -578.4) + Vector3.new(-5849.1543, -207.86574, -6767.256)),
            TweenProperty("Workspace.CursedOutroVFX.Breakage.CFrame", TweenInfo.new(1.5166666666666666, Enum.EasingStyle.Linear), CFrame.new(18.447, 190.9959, -578.4) + Vector3.new(-5849.1543, -207.86574, -6767.256)),
            SetProperty("Lighting.CutsceneBlur.Enabled", true),
            SetProperty("Lighting.CutsceneBlur.Size", 15),
            SetProperty("Lighting.DepthOfField.Enabled", true),
            SetProperty("Lighting.DepthOfField.InFocusRadius", 50),
            SetProperty("Lighting.DepthOfField.FocusDistance", 0.05),
            SetProperty("Lighting.DepthOfField.FarIntensity", 0.75),
            SetProperty("Lighting.Contrast.Enabled", false),
            SetProperty("Lighting.Contrast.Saturation", 0.3),
            TweenProperty("Lighting.Contrast.Saturation", TweenInfo.new(14.966666666666667, Enum.EasingStyle.Linear), 0),
            SetProperty("Lighting.Contrast.Contrast", 0.2),
            TweenProperty("Lighting.Contrast.Contrast", TweenInfo.new(14.966666666666667, Enum.EasingStyle.Linear), 0),
            SetProperty("Lighting.Contrast.TintColor", Color3.new(1, 0.890196, 0.792157)),
            TweenProperty("Lighting.Contrast.TintColor", TweenInfo.new(14.966666666666667, Enum.EasingStyle.Linear), Color3.new(1, 1, 1)),
            SetProperty("Lighting.Contrast.Brightness", 0.075),
            TweenProperty("Lighting.Contrast.Brightness", TweenInfo.new(14.966666666666667, Enum.EasingStyle.Linear), 0),
            SetProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", 1)
        },
        [21] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.48333333333333334, Enum.EasingStyle.Linear), 2) },
        [37] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(1.0166666666666666, Enum.EasingStyle.Linear), 0) },
        [91] = { TweenProperty("Workspace.CursedOutroVFX.Breakage.CFrame", TweenInfo.new(1.5333333333333334, Enum.EasingStyle.Linear), CFrame.new(18.447, 159.254, -578.4) + Vector3.new(-5849.1543, -207.86574, -6767.256)) },
        [183] = { TweenProperty("Workspace.CursedOutroVFX.Breakage.CFrame", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), CFrame.new(18.447, 131.169, -578.4) + Vector3.new(-5849.1543, -207.86574, -6767.256)) },
        [184] = { TweenProperty("Workspace.CursedOutroVFX.Breakage.CFrame", TweenInfo.new(1.4166666666666667, Enum.EasingStyle.Linear), CFrame.new(18.447, 81.3715, -578.4) + Vector3.new(-5849.1543, -207.86574, -6767.256)) },
        [269] = { TweenProperty("Workspace.CursedOutroVFX.Breakage.CFrame", TweenInfo.new(0.3333333333333333, Enum.EasingStyle.Linear), CFrame.new(18.447, 56.3333, -578.4) + Vector3.new(-5849.1543, -207.86574, -6767.256)) },
        [270] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 35) },
        [293] = {
            function() -- line: 258
                -- upvalues: clone (ref), emitBurst (copy)
                emitBurst(clone.RockFall)
            end
        },
        [294] = {
            TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.06666666666666667, Enum.EasingStyle.Linear), 32),
            function() -- line: 265
                -- upvalues: clone (ref), emitBurst (copy)
                emitBurst(clone.Fall)
            end
        },
        [295] = {
            function() -- line: 271
                -- upvalues: clone (ref), emitBurst (copy)
                emitBurst(clone.RockFall2)
            end
        },
        [296] = {
            function() -- line: 277
                -- upvalues: clone (ref), setEmitting (copy)
                setEmitting(clone.Breakage, false)
            end
        },
        [298] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.11666666666666667, Enum.EasingStyle.Linear), 35) },
        [317] = {
            function() -- line: 287
                -- upvalues: clone (ref), emitBurst (copy)
                emitBurst(clone.RockFall3)
            end
        },
        [318] = {
            function() -- line: 293
                -- upvalues: clone (ref), emitBurst (copy)
                emitBurst(clone.Fall2)
            end
        },
        [504] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Sine), 28) },
        [505] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.15, Enum.EasingStyle.Sine), 25) },
        [603] = { TweenProperty("Lighting.DepthOfField.FarIntensity", TweenInfo.new(1.4333333333333333, Enum.EasingStyle.Linear), 0.25) },
        [666] = { TweenProperty("Lighting.DepthOfField.InFocusRadius", TweenInfo.new(0.7166666666666667, Enum.EasingStyle.Linear), 200) },
        [720] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.6166666666666667, Enum.EasingStyle.Linear), 7) },
        [811] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.65, Enum.EasingStyle.Linear), 15) },
        [821] = {
            function() -- line: 323
                -- upvalues: clone (ref), emitBurst (copy)
                emitBurst(clone.Bats)
            end
        },
        [850] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(1.3, Enum.EasingStyle.Linear), 2) },
        [898] = {
            SetProperty("Lighting.Contrast.Enabled", true),
            TweenProperty("Lighting.Contrast.Saturation", TweenInfo.new(1.4, Enum.EasingStyle.Linear), 0.3),
            TweenProperty("Lighting.Contrast.Contrast", TweenInfo.new(1.4, Enum.EasingStyle.Linear), 0.2),
            TweenProperty("Lighting.Contrast.TintColor", TweenInfo.new(1.4, Enum.EasingStyle.Linear), Color3.new(1, 0.890196, 0.792157)),
            TweenProperty("Lighting.Contrast.Brightness", TweenInfo.new(1.4, Enum.EasingStyle.Linear), 0.075)
        },
        [923] = { TweenProperty("Lighting.DepthOfField.InFocusRadius", TweenInfo.new(1.0833333333333333, Enum.EasingStyle.Linear), 800) },
        [1019] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.26666666666666666, Enum.EasingStyle.Linear), 0) }
    }

    return {
        Run = function() -- Run | line: 350
            -- upvalues: p5 (copy), v12 (copy), LoadAnimationIntoRig (copy), CutsceneUI (copy), Black (copy), Vignette (copy), clone (ref), t8 (copy), ContentProvider (copy), Lighting (copy), RunService (copy), SoundService (copy), TweenService (copy), Workspace (copy), LightingController (copy), MusicDirector (copy), OutroCutscene (copy), CurrentCamera (copy), LocalPlayer (copy), restoreCamera (copy), hideCutsceneUi (copy), restoreCutsceneUi (copy)
            local _warn = warn

            xpcall(hideCutsceneUi, _warn)
            v12:Add(restoreCutsceneUi)
            MusicDirector.SetEventMusic(true)
            v12:Add(function() -- line: 355
                -- upvalues: MusicDirector (copy)
                MusicDirector.SetEventMusic(false)
            end)
            LightingController.SetAuthoredLayer("CursedIslandWarsCutscene", OutroCutscene.SceneLighting, 999, 0)
            v12:Add(function() -- line: 361
                -- upvalues: LightingController (copy)
                LightingController.ClearLayer("CursedIslandWarsCutscene", 0)
            end)

            for _, child in OutroCutscene.LightingAssets:GetChildren() do
                if not Lighting:FindFirstChild(child.Name) then
                    local clone = child:Clone()

                    clone.Parent = Lighting
                    v12:Add(clone)
                end
            end

            CutsceneUI.Enabled = true
            Black.BackgroundTransparency = 1
            Black.Visible = true
            Vignette.Visible = false
            v12:Add(function() -- line: 377
                -- upvalues: Vignette (copy)
                Vignette.Visible = false
                Vignette.ImageTransparency = 1
            end)
            p5:Add(function() -- line: 382
                -- upvalues: Black (copy)
                Black.BackgroundTransparency = 1
                Black.BackgroundColor3 = Color3.new(0, 0, 0)
                Black.Visible = false
            end)
            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 0
            }):Play()
            task.wait(0.5)

            local clone2 = OutroCutscene.CursedOutroVFX:Clone()

            clone2.Parent = Workspace
            clone = clone2
            v12:Add(clone2)

            local clone3 = OutroCutscene.CutsceneMusic:Clone()

            clone3.Parent = SoundService
            v12:Add(clone3)

            local clone4 = OutroCutscene.CursedOutroRigs:Clone()

            v12:Add(clone4)

            for _, child in clone4:GetChildren() do
                if child:IsA("Model") and child.PrimaryPart then
                    child.PrimaryPart.Anchored = true
                end
            end

            clone4.Parent = Workspace

            local t10 = {}

            for _, child in clone4:GetChildren() do
                table.insert(t10, (child:FindFirstChild("Animation")))
            end

            ContentProvider:PreloadAsync(t10)

            local t11 = {}

            for _, child in clone4:GetChildren() do
                t11[child] = LoadAnimationIntoRig(child, child:FindFirstChild("Animation").AnimationId)
            end

            local v14 = true

            v12:Add(function() -- line: 427
                -- upvalues: v14 (ref), restoreCamera (copy)
                v14 = false
                restoreCamera()
            end)

            for _, v15 in t11 do
                v15:Play(0)
            end

            local v16 = t11[clone4.CameraRig]
            local v17 = os.clock() + 2

            while v14 and v16.TimePosition <= 0 and os.clock() < v17 do
                RunService.RenderStepped:Wait()
            end

            clone3:Play()

            local Cam = clone4.CameraRig.Cam

            v12:Connect(RunService.RenderStepped, function() -- line: 449
                -- upvalues: v14 (ref), Cam (copy), CurrentCamera (copy), LocalPlayer (copy)
                if not v14 then
                    return
                end

                CurrentCamera.CameraType = Enum.CameraType.Scriptable
                LocalPlayer.ReplicationFocus = Cam
                CurrentCamera.Focus = Cam.CFrame
                CurrentCamera.CFrame = Cam.CFrame
            end)

            local t12 = {}
            local n1 = 0
            local n2 = 0.1
            local connection = v12:Connect(RunService.Heartbeat, function(p11) -- line: 462
                -- upvalues: clone3 (copy), t11 (copy), t12 (copy), n1 (ref), n2 (ref), t8 (copy)
                n1 += p11
                n2 -= p11

                for _, v18 in t11 do
                    local v19 = v18.Length - 0.05

                    if v18.Length > 0 and v19 <= n1 and v18.Speed ~= 0 then
                        v18.TimePosition = v19
                        v18:AdjustSpeed(0)
                    end
                end

                if n2 <= 0 then
                    n2 = 0.1

                    for _, v20 in t11 do
                        if v20.IsPlaying and v20.Speed ~= 0 then
                            local v22 = n1

                            if math.abs(v22 - v20.TimePosition) >= 0.4 then
                                local function v23() -- line: 481
                                    -- upvalues: v20 (copy), n1 (ref)
                                    v20.TimePosition = n1
                                end

                                local _warn = warn

                                xpcall(v23, _warn)
                            end
                        end
                    end
                end

                if clone3.TimePosition < n1 - 0.001 then
                    clone3.PlaybackSpeed = 1.01
                elseif clone3.TimePosition > n1 + 0.001 then
                    clone3.PlaybackSpeed = 0.99
                else
                    clone3.PlaybackSpeed = 1
                end

                for i = 0, 9 do
                    local v25 = math.floor(n1 * 60 - i)

                    if t8[v25] and not t12[v25] then
                        t12[v25] = true

                        for _, v26 in t8[v25] do
                            task.spawn(v26)
                        end
                    end
                end
            end)

            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(17.75)
            connection:Disconnect()
            Black.BackgroundTransparency = 0
            v12:Clean()
            task.delay(1.5, function() -- line: 513
                -- upvalues: Black (copy), TweenService (copy)
                TweenService:Create(Black, TweenInfo.new(0.8), {
                    BackgroundTransparency = 1
                }):Play()
                task.wait(0.8)
                Black.Visible = false
            end)
        end
    }
end
