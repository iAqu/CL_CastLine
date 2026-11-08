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
local Tabs = require(ReplicatedStorage.Client.Tabs)

require(ReplicatedStorage.Packages.Trove)

local BulkFade = require(ReplicatedStorage.Client.Modules.BulkFade)
local OutroCutscene2 = ReplicatedStorage.CutsceneAssets.ScrambleBossCutsceneAssets.OutroCutscene2
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
local t4 = {}

local function restoreCamera() -- line: 48
    -- upvalues: TweenService (copy), CurrentCamera (copy), LocalPlayer (copy)
    TweenService:Create(CurrentCamera, TweenInfo.new(0), {
        FieldOfView = 70
    }):Play()
    CurrentCamera.FieldOfView = 70
    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") or nil
    LocalPlayer.ReplicationFocus = nil
end

local function hideAllUi() -- line: 58
    -- upvalues: StarterGui (copy), Tabs (copy), t1 (copy), LocalPlayer (copy), t2 (ref), v2 (ref), t3 (ref)
    if t2 ~= nil then
        return
    end

    local t5 = {}

    v2 = Tabs.Active()

    for _, child in LocalPlayer:WaitForChild("PlayerGui"):GetChildren() do
        if child:IsA("ScreenGui") and child.Name ~= "CutsceneUI" and child.Enabled then
            t5[child] = true
            child.Enabled = false
        end
    end

    t2 = t5

    local function v3() -- line: 73
        -- upvalues: LocalPlayer (copy)
        LocalPlayer.PlayerGui.BottomUI.BottomFrame.Holder.List.Visible = false
    end

    pcall(v3)

    local t6 = {}

    for _, v4 in t1 do
        t6[v4] = StarterGui:GetCoreGuiEnabled(v4)
        StarterGui:SetCoreGuiEnabled(v4, false)
    end

    t3 = t6
end

local function restoreAllUi() -- line: 83
    -- upvalues: StarterGui (copy), LocalPlayer (copy), t2 (ref), v2 (ref), t3 (ref)
    local t7 = t2
    local v5 = v2

    t2 = nil
    v2 = nil

    if t7 ~= nil then
        for v6 in t7 do
            if v6.Parent ~= nil and v6.Name ~= v5 then
                v6.Enabled = true
            end
        end
    end

    local function v7() -- line: 96
        -- upvalues: LocalPlayer (copy)
        LocalPlayer.PlayerGui.BottomUI.BottomFrame.Holder.List.Visible = true
    end

    pcall(v7)

    local t8 = t3

    t3 = nil

    if t8 ~= nil then
        for v8, v9 in t8 do
            StarterGui:SetCoreGuiEnabled(v8, v9)
        end
    end

    return v5
end

local function hideCutsceneUi() -- line: 108
    -- upvalues: HiddenUIHandler (copy), v1 (ref), hideAllUi (copy)
    if v1 == nil then
        v1 = HiddenUIHandler.Acquire()
    end

    hideAllUi()
end

local function restoreCutsceneUi() -- line: 115
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

local function setTransparency(p1, p2) -- line: 127
    for _, v12 in p1 do
        if v12:IsA("BasePart") then
            if not v12:GetAttribute("OriginalTransparency") then
                v12:SetAttribute("OriginalTransparency", v12.Transparency)
            end

            v12.Transparency = p2 or v12:GetAttribute("OriginalTransparency")
        end
    end
end

local function restoreGuard(p3, p4) -- line: 140
    -- upvalues: t4 (copy)
    t4[p3] = nil

    local Guard = p4:FindFirstChild("Guard")

    if Guard == nil or Guard == p3 then
        p3.Parent = p4
    end
end

local function hideAllGuardsAndNests(p5) -- line: 149
    -- upvalues: t4 (copy), setTransparency (copy)
    for _, child in (game.Workspace.World.Areas.GuardAreas:GetChildren()) do
        local Guard = child.Guard

        t4[Guard] = child
        Guard.Parent = nil

        local Nests = child:FindFirstChild("Nests")
        local v13 = Nests and Nests:GetDescendants()

        if v13 then
            setTransparency(v13, 1)
        end

        p5:Add(function() -- line: 163
            -- upvalues: child (copy), Guard (copy), Nests (copy), v13 (copy), t4 (copy), setTransparency (copy)
            t4[Guard] = nil

            local Guard2 = child:FindFirstChild("Guard")

            if Guard2 == nil or Guard2 == Guard then
                Guard.Parent = child
            end

            if Nests then
                setTransparency(v13)
            end
        end)
    end
end

local function restoreAllGuardsAndNests() -- line: 172
    -- upvalues: t4 (copy), setTransparency (copy)
    for v14, v15 in t4 do
        t4[v14] = nil

        local Guard = v15:FindFirstChild("Guard")

        if Guard == nil or Guard == v14 then
            v14.Parent = v15
        end

        local Nests = v15:FindFirstChild("Nests")
        local v16 = Nests and Nests:GetDescendants()

        if v16 then
            setTransparency(v16)
        end
    end
end

local function setEmitting(p6, p7) -- line: 184
    for _, descendant in p6:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
            descendant.Enabled = p7
        end
    end
end

local function emitBurst(p8) -- line: 192
    for _, descendant in p8:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local EmitCount = descendant:GetAttribute("EmitCount")
            local EmitDuration = descendant:GetAttribute("EmitDuration")

            if type(EmitCount) == "number" and EmitCount ~= 0 then
                descendant:Emit(EmitCount)
            end

            if type(EmitDuration) == "number" and EmitDuration ~= 0 then
                descendant.Enabled = true
                task.delay(EmitDuration, function() -- line: 205
                    -- upvalues: descendant (copy)
                    descendant.Enabled = false
                end)
            end
        end
    end
end

return function(p9) -- line: 214
    -- upvalues: ContentProvider (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), SoundService (copy), TweenService (copy), Workspace (copy), CutsceneHelperFunctions (copy), Tabs (copy), BulkFade (copy), OutroCutscene2 (copy), CurrentCamera (copy), LocalPlayer (copy), v1 (ref), restoreCamera (copy), restoreAllUi (copy), hideCutsceneUi (copy), hideAllGuardsAndNests (copy), restoreAllGuardsAndNests (copy), setEmitting (copy), emitBurst (copy)
    local v17 = CutsceneHelperFunctions.GetHelperFunctions(p9)
    local SetProperty, TweenProperty, LoadAnimationIntoRig = v17.SetProperty, v17.TweenProperty, v17.LoadAnimationIntoRig
    local CutsceneUI = LocalPlayer.PlayerGui.CutsceneUI
    local Black, Vignette = CutsceneUI.Black, CutsceneUI.Vignette
    local clone
    local t9 = {
        [0] = {
            SetProperty("Workspace.CurrentCamera.CFrame", CFrame.new(-5252.8594, -234.99, 2545.4341, 0.791, 0.1643, -0.5893, -0, 0.9633, 0.2685, 0.6118, -0.2124, 0.762)),
            SetProperty("Workspace.CurrentCamera.FieldOfView", 25),
            function() -- line: 230
                -- upvalues: clone (ref), setEmitting (copy)
                setEmitting(clone.Dizzy, false)
            end,
            SetProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", 0),
            TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.48333333333333334, Enum.EasingStyle.Linear), 1),
            SetProperty("PlayerGui.CutsceneUI.Vignette.Visible", true),
            SetProperty("Workspace.ScrambleBossOutro2Rigs.BenRigWithHandles.Highlight.Enabled", false),
            SetProperty("Workspace.ScrambleBossOutro2Rigs.BenRigWithHandles.Highlight.FillTransparency", 0.3),
            TweenProperty("Workspace.ScrambleBossOutro2Rigs.BenRigWithHandles.Highlight.FillTransparency", TweenInfo.new(1.3, Enum.EasingStyle.Linear), 0.2),
            SetProperty("Workspace.ScrambleBossOutro2Rigs.BenRigWithHandles.Highlight.OutlineTransparency", 0.3),
            TweenProperty("Workspace.ScrambleBossOutro2Rigs.BenRigWithHandles.Highlight.OutlineTransparency", TweenInfo.new(1.3, Enum.EasingStyle.Linear), 0.2),
            SetProperty("Workspace.ScrambleBossOutro2Rigs.BrockkodileHeadRig.Highlight.Enabled", false),
            SetProperty("Workspace.ScrambleBossOutro2Rigs.BrockkodileHeadRig.Highlight.FillTransparency", 0.3),
            TweenProperty("Workspace.ScrambleBossOutro2Rigs.BrockkodileHeadRig.Highlight.FillTransparency", TweenInfo.new(1.3, Enum.EasingStyle.Linear), 0.2),
            SetProperty("Workspace.ScrambleBossOutro2Rigs.BrockkodileHeadRig.Highlight.OutlineTransparency", 0.3),
            TweenProperty("Workspace.ScrambleBossOutro2Rigs.BrockkodileHeadRig.Highlight.OutlineTransparency", TweenInfo.new(1.3, Enum.EasingStyle.Linear), 0.2),
            SetProperty("Workspace.ScrambleBossOutro2VFX.Portal.Leap-In.Light.PointLight.Enabled", false),
            SetProperty("Workspace.ScrambleBossOutro2VFX.Portal.Leap-In.Light.PointLight.Brightness", 0),
            SetProperty("Lighting.BlackGreen.Enabled", false),
            SetProperty("Lighting.WhiteGreen.Enabled", false),
            SetProperty("Lighting.CutsceneBlur.Enabled", true),
            SetProperty("Lighting.CutsceneBlur.Size", 15),
            TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.8666666666666667, Enum.EasingStyle.Linear), 4),
            SetProperty("Lighting.DepthOfField.Enabled", true),
            SetProperty("Lighting.DepthOfField.FarIntensity", 0.71),
            SetProperty("Lighting.DepthOfField.FocusDistance", 0),
            SetProperty("Lighting.DepthOfField.InFocusRadius", 27),
            SetProperty("Lighting.DepthOfField.NearIntensity", 0.66),
            SetProperty("Lighting.ColorCorrection.Saturation", 0.1),
            SetProperty("Lighting.ColorCorrection.Contrast", 0.2),
            SetProperty("Workspace.ScrambleBossOutro2VFX.Sparkle.CFrame", CFrame.new(6522.7588, 300.0606, -388.7413, 0.9942, 0.0027, 0.1077, 0, 0.9997, -0.0246, -0.1077, 0.0245, 0.9939)),
            TweenProperty("Workspace.ScrambleBossOutro2VFX.Sparkle.CFrame", TweenInfo.new(7.266666666666667, Enum.EasingStyle.Linear), CFrame.new(6520.9277, 300.0616, -388.5854, 0.9964, 0.0027, 0.0848, -6E-04, 0.9997, -0.0246, -0.0848, 0.0245, 0.9961))
        },
        [64] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.23333333333333334, Enum.EasingStyle.Linear), 10) },
        [77] = { SetProperty("Lighting.WhiteGreen.Enabled", true) },
        [78] = {
            function() -- line: 273
                -- upvalues: clone (ref), emitBurst (copy)
                emitBurst(clone.Portal)
            end,
            SetProperty("Workspace.ScrambleBossOutro2Rigs.BenRigWithHandles.Highlight.Enabled", true),
            TweenProperty("Workspace.ScrambleBossOutro2Rigs.BenRigWithHandles.Highlight.FillTransparency", TweenInfo.new(0.48333333333333334, Enum.EasingStyle.Linear), 1),
            TweenProperty("Workspace.ScrambleBossOutro2Rigs.BenRigWithHandles.Highlight.OutlineTransparency", TweenInfo.new(0.48333333333333334, Enum.EasingStyle.Linear), 1),
            SetProperty("Workspace.ScrambleBossOutro2Rigs.BrockkodileHeadRig.Highlight.Enabled", true),
            TweenProperty("Workspace.ScrambleBossOutro2Rigs.BrockkodileHeadRig.Highlight.FillTransparency", TweenInfo.new(0.48333333333333334, Enum.EasingStyle.Linear), 1),
            TweenProperty("Workspace.ScrambleBossOutro2Rigs.BrockkodileHeadRig.Highlight.OutlineTransparency", TweenInfo.new(0.48333333333333334, Enum.EasingStyle.Linear), 1),
            SetProperty("Workspace.ScrambleBossOutro2VFX.Portal.Leap-In.Light.PointLight.Enabled", true),
            TweenProperty("Workspace.ScrambleBossOutro2VFX.Portal.Leap-In.Light.PointLight.Brightness", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 1.5),
            TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 15)
        },
        [79] = {
            SetProperty("Lighting.BlackGreen.Enabled", true),
            SetProperty("Lighting.WhiteGreen.Enabled", false)
        },
        [81] = {
            SetProperty("Lighting.BlackGreen.Enabled", false),
            SetProperty("Lighting.WhiteGreen.Enabled", true)
        },
        [83] = { SetProperty("Lighting.WhiteGreen.Enabled", false) },
        [84] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.21666666666666667, Enum.EasingStyle.Linear), 4) },
        [89] = { TweenProperty("Workspace.ScrambleBossOutro2VFX.Portal.Leap-In.Light.PointLight.Brightness", TweenInfo.new(0.48333333333333334, Enum.EasingStyle.Linear), 0) },
        [110] = {
            function() -- line: 310
                -- upvalues: clone (ref), emitBurst (copy)
                emitBurst(clone.Smoke)
            end
        },
        [113] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.13333333333333333, Enum.EasingStyle.Linear), 15) },
        [121] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.18333333333333332, Enum.EasingStyle.Linear), 6) },
        [132] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.16666666666666666, Enum.EasingStyle.Linear), 10) },
        [137] = {
            function() -- line: 328
                -- upvalues: clone (ref), setEmitting (copy)
                setEmitting(clone.Dizzy, true)
            end
        },
        [142] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.5666666666666667, Enum.EasingStyle.Linear), 4) },
        [225] = { TweenProperty("Lighting.DepthOfField.FarIntensity", TweenInfo.new(0.2, Enum.EasingStyle.Linear), 0) },
        [252] = { TweenProperty("Lighting.DepthOfField.FarIntensity", TweenInfo.new(1.7166666666666666, Enum.EasingStyle.Linear), 0.71) },
        [355] = {
            TweenProperty("Lighting.DepthOfField.FarIntensity", TweenInfo.new(1.8333333333333333, Enum.EasingStyle.Linear), 0),
            TweenProperty("Lighting.DepthOfField.FocusDistance", TweenInfo.new(1.8333333333333333, Enum.EasingStyle.Linear), 42),
            TweenProperty("Lighting.DepthOfField.InFocusRadius", TweenInfo.new(1.8333333333333333, Enum.EasingStyle.Linear), 0),
            TweenProperty("Lighting.DepthOfField.NearIntensity", TweenInfo.new(1.2, Enum.EasingStyle.Linear), 0.3)
        },
        [427] = { TweenProperty("Lighting.DepthOfField.NearIntensity", TweenInfo.new(0.6166666666666667, Enum.EasingStyle.Linear), 1) },
        [436] = {
            TweenProperty("Lighting.ColorCorrection.Saturation", TweenInfo.new(0.23333333333333334, Enum.EasingStyle.Linear), 0.3),
            TweenProperty("Lighting.ColorCorrection.Contrast", TweenInfo.new(0.23333333333333334, Enum.EasingStyle.Linear), 1),
            TweenProperty("Workspace.ScrambleBossOutro2VFX.Sparkle.CFrame", TweenInfo.new(0.5833333333333334, Enum.EasingStyle.Linear), CFrame.new(6528.7046, 294.0695, -377.7816, 0.9883, 0.0222, 0.1506, 0.0094, 0.9785, -0.206, -0.152, 0.205, 0.9669))
        },
        [450] = { TweenProperty("Lighting.ColorCorrection.Saturation", TweenInfo.new(3.283333333333333, Enum.EasingStyle.Linear), 0.3) },
        [471] = { TweenProperty("Workspace.ScrambleBossOutro2VFX.Sparkle.CFrame", TweenInfo.new(0.43333333333333335, Enum.EasingStyle.Linear), CFrame.new(6531.3262, 288.7675, -367.9813, 0.9804, 0.0305, 0.1947, 0.0262, 0.959, -0.2823, -0.1953, 0.2818, 0.9394)) },
        [497] = { TweenProperty("Workspace.ScrambleBossOutro2VFX.Sparkle.CFrame", TweenInfo.new(0.4666666666666667, Enum.EasingStyle.Linear), CFrame.new(6538.063, 287.3963, -358.272, 0.9749, 0.0287, 0.221, 0.0316, 0.9638, -0.2647, -0.2206, 0.265, 0.9387)) },
        [525] = { TweenProperty("Workspace.ScrambleBossOutro2VFX.Sparkle.CFrame", TweenInfo.new(2.05, Enum.EasingStyle.Linear), CFrame.new(6565.7505, 275.9485, -317.0448, 0.985, -0.0108, 0.1721, 0.039, 0.9862, -0.1609, -0.168, 0.1652, 0.9719)) },
        [647] = {
            TweenProperty("Lighting.ColorCorrection.Saturation", TweenInfo.new(0.11666666666666667, Enum.EasingStyle.Linear), 0.1),
            TweenProperty("Lighting.ColorCorrection.Contrast", TweenInfo.new(0.11666666666666667, Enum.EasingStyle.Linear), 0.2)
        },
        [653] = {
            TweenProperty("Lighting.DepthOfField.FarIntensity", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 0.71),
            TweenProperty("Lighting.DepthOfField.FocusDistance", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 0),
            TweenProperty("Lighting.DepthOfField.InFocusRadius", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 27),
            TweenProperty("Lighting.DepthOfField.NearIntensity", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 0.66)
        },
        [766] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.36666666666666664, Enum.EasingStyle.Linear), 0) }
    }

    return {
        Run = function() -- Run | line: 396
            -- upvalues: p9 (copy), LoadAnimationIntoRig (copy), CutsceneUI (copy), Black (copy), Vignette (copy), clone (ref), t9 (copy), ContentProvider (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), SoundService (copy), TweenService (copy), Workspace (copy), Tabs (copy), BulkFade (copy), OutroCutscene2 (copy), CurrentCamera (copy), LocalPlayer (copy), v1 (ref), restoreCamera (copy), restoreAllUi (copy), hideCutsceneUi (copy), hideAllGuardsAndNests (copy), restoreAllGuardsAndNests (copy)
            local v18 = false
            local _warn = warn

            xpcall(hideCutsceneUi, _warn)
            p9:Add(function() -- line: 401
                -- upvalues: v18 (ref), Tabs (copy), v1 (ref), restoreAllUi (copy)
                if v18 then
                    return
                end

                local v19 = restoreAllUi()
                local v20 = v1

                v1 = nil

                if v20 ~= nil then
                    v20()
                end

                if v19 ~= nil then
                    Tabs.Activate(v19, {
                        instant = true
                    })
                end

                v18 = true
            end)

            local AreaEggSlotsClient = Workspace:FindFirstChild("AreaEggSlotsClient")

            local function v21() -- line: 409
                -- upvalues: AreaEggSlotsClient (copy), p9 (copy), ReplicatedStorage (copy), Workspace (copy)
                AreaEggSlotsClient.Parent = ReplicatedStorage
                p9:Add(function() -- line: 411
                    -- upvalues: AreaEggSlotsClient (copy), Workspace (copy)
                    AreaEggSlotsClient.Parent = Workspace
                end)
            end

            pcall(v21)
            hideAllGuardsAndNests(p9)

            local t11 = {}

            for _, child in OutroCutscene2.LightingAssets:GetChildren() do
                if not Lighting:FindFirstChild(child.Name) then
                    local clone = child:Clone()

                    clone.Parent = Lighting
                    p9:Add(clone)
                    table.insert(t11, clone)
                end
            end

            CutsceneUI.Enabled = true
            Black.BackgroundTransparency = 1
            Black.Visible = true
            Vignette.Visible = false
            p9:Add(function() -- line: 435
                -- upvalues: Vignette (copy)
                Vignette.Visible = false
                Vignette.ImageTransparency = 1
            end)

            local clone2 = OutroCutscene2.ScrambleBossOutro2VFX:Clone()

            clone2.Parent = Workspace
            clone = clone2
            p9:Add(clone2)

            local clone3 = OutroCutscene2.ScrambleBossOutro2WorkspaceAssets:Clone()

            clone3.Parent = Workspace
            p9:Add(clone3)

            local clone4 = OutroCutscene2.CutsceneMusic:Clone()

            clone4.Parent = SoundService
            p9:Add(clone4)
            TweenService:Create(Black, TweenInfo.new(0.1), {
                BackgroundTransparency = 0
            }):Play()
            p9:Add(function() -- line: 454
                -- upvalues: Black (copy)
                Black.BackgroundTransparency = 1
                Black.BackgroundColor3 = Color3.new(0, 0, 0)
                Black.Visible = false
            end)

            local clone5 = OutroCutscene2.ScrambleBossOutro2Rigs:Clone()

            for _, child in clone5:GetChildren() do
                if child:IsA("Model") and child.PrimaryPart then
                    child.PrimaryPart.Anchored = true
                end
            end

            clone5.Parent = Workspace
            p9:Add(clone5)

            local t12 = {}

            for _, child in clone5:GetChildren() do
                local Animation = child:FindFirstChildOfClass("Animation")

                if Animation then
                    table.insert(t12, Animation)
                end
            end

            ContentProvider:PreloadAsync(t12)

            local t13 = {}

            for _, child in clone5:GetChildren() do
                local Animation = child:FindFirstChildOfClass("Animation")

                if Animation then
                    t13[child] = LoadAnimationIntoRig(child, Animation.AnimationId)
                end
            end

            local v22 = true

            p9:Add(function() -- line: 490
                -- upvalues: v22 (ref)
                v22 = false
            end)
            p9:Add(function() -- line: 491
                -- upvalues: v22 (ref), restoreCamera (copy)
                if v22 then
                    restoreCamera()
                end
            end)

            for _, v23 in t13 do
                v23:Play(0)
            end

            local v24 = t13[clone5.HumanoidCameraRig]

            assert(v24, "HumanoidCameraRig needs an Animation")

            local v25 = os.clock() + 2

            while v22 and v24.TimePosition <= 0 and os.clock() < v25 do
                RunService.RenderStepped:Wait()
            end

            clone4:Play()

            local Torso = clone5.HumanoidCameraRig.Torso
            local connection

            connection = RunService.RenderStepped:Connect(function() -- line: 517
                -- upvalues: v22 (ref), Torso (copy), connection (ref), CurrentCamera (copy), LocalPlayer (copy)
                if not v22 then
                    connection:Disconnect()

                    return
                end

                CurrentCamera.CameraType = Enum.CameraType.Scriptable
                LocalPlayer.ReplicationFocus = Torso
                CurrentCamera.Focus = Torso.CFrame
                CurrentCamera.CFrame = Torso.CFrame
            end)

            local t14 = {}
            local n1 = 0
            local n2 = 0.1
            local connection2 = RunService.Heartbeat:Connect(function(p10) -- line: 531
                -- upvalues: clone4 (copy), t13 (copy), t14 (copy), n1 (ref), n2 (ref), t9 (copy)
                n1 += p10
                n2 -= 0.1

                if n2 <= 0 then
                    n2 = 0.1

                    for _, v26 in t13 do
                        if v26.IsPlaying then
                            local v28 = n1

                            if math.abs(v28 - v26.TimePosition) >= 0.4 then
                                local function v29() -- line: 543
                                    -- upvalues: v26 (copy), n1 (ref)
                                    v26.TimePosition = n1
                                end

                                local _warn = warn

                                xpcall(v29, _warn)
                            end
                        end
                    end
                end

                if clone4.TimePosition < n1 - 0.001 then
                    clone4.PlaybackSpeed = 1.01
                elseif clone4.TimePosition > n1 + 0.001 then
                    clone4.PlaybackSpeed = 0.99
                else
                    clone4.PlaybackSpeed = 1
                end

                for i = 0, 9 do
                    local v31 = math.floor(n1 * 60 - i)

                    if t9[v31] and not t14[v31] then
                        t14[v31] = true

                        for _, v32 in t9[v31] do
                            task.spawn(v32)
                        end
                    end
                end
            end)

            p9:Add(connection2)
            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(13.616666666666667)
            connection2:Disconnect()

            local function v33() -- line: 575
                -- upvalues: clone2 (copy)
                clone2:Destroy()
            end

            local _warn2 = warn

            xpcall(v33, _warn2)

            local function v34() -- line: 576
                -- upvalues: clone3 (copy)
                clone3:Destroy()
            end

            local _warn3 = warn

            xpcall(v34, _warn3)

            local function v35() -- line: 577
                -- upvalues: clone4 (copy)
                clone4:Destroy()
            end

            local _warn4 = warn

            xpcall(v35, _warn4)
            v22 = false
            Vignette.Visible = false

            local function v36() -- line: 583
                -- upvalues: t11 (copy)
                for _, v37 in t11 do
                    v37:Destroy()
                end
            end

            local _warn5 = warn

            xpcall(v36, _warn5)

            local function v38() -- line: 589
                -- upvalues: clone5 (copy)
                clone5:Destroy()
            end

            local _warn6 = warn

            xpcall(v38, _warn6)

            local _warn7 = warn

            xpcall(restoreCamera, _warn7)

            local v39 = BulkFade.new(CutsceneUI.NewBiome, TweenInfo.new(1))

            v39:FadeOutInstant()
            task.wait()
            v39:FadeIn()
            CutsceneUI.NewBiome.Visible = true
            task.spawn(function() -- line: 599
                -- upvalues: CutsceneUI (copy)
                local function toDHMS(p11) -- line: 600
                    return string.format("%02i:%02i:%02i:%02i", p11 / 86400, p11 / 3600 % 24, p11 / 60 % 60, p11 % 60)
                end

                local n3 = 604799

                while CutsceneUI.NewBiome.Visible do
                    CutsceneUI.NewBiome.TimeRemaining.Text = toDHMS(n3)
                    script.ClockTick:Play()
                    task.wait(1)
                    n3 -= 1
                end
            end)
            task.wait(5)
            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            v39:FadeOut()
            task.delay(1, function() -- line: 625
                -- upvalues: v39 (copy), CutsceneUI (copy)
                CutsceneUI.NewBiome.Visible = false
                v39:FadeIn()
            end)
            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(0.5)
            Black.Visible = false
            Vignette.Visible = false

            local function v40() -- line: 637
                -- upvalues: AreaEggSlotsClient (copy), Workspace (copy)
                AreaEggSlotsClient.Parent = Workspace
            end

            pcall(v40)

            local function v41() -- line: 641
                -- upvalues: v18 (ref), Tabs (copy), v1 (ref), restoreAllUi (copy)
                local v42 = restoreAllUi()
                local v43 = v1

                v1 = nil

                if v43 ~= nil then
                    v43()
                end

                if v42 ~= nil then
                    Tabs.Activate(v42, {
                        instant = true
                    })
                end

                v18 = true
            end

            local _warn8 = warn

            xpcall(v41, _warn8)
            restoreAllGuardsAndNests()
        end
    }
end
