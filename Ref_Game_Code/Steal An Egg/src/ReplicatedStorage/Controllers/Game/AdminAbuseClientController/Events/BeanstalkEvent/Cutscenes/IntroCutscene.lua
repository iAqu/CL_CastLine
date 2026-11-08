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
local Tabs = require(ReplicatedStorage.Client.Tabs)

require(ReplicatedStorage.Packages.Trove)

local IntroCutscene = ReplicatedStorage.CutsceneAssets.BeanstalkEventCutsceneAssets.IntroCutscene
local t1 = {
    Enum.CoreGuiType.Backpack,
    Enum.CoreGuiType.Chat,
    Enum.CoreGuiType.PlayerList,
    Enum.CoreGuiType.Health,
    Enum.CoreGuiType.EmotesMenu
}
local t2 = {
    "Sky",
    "Atmosphere"
}
local CurrentCamera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local v1, t3, v2, t4
local t5 = {}

local function restoreCamera() -- line: 56
    -- upvalues: TweenService (copy), CurrentCamera (copy), LocalPlayer (copy)
    TweenService:Create(CurrentCamera, TweenInfo.new(0), {
        FieldOfView = 70
    }):Play()
    CurrentCamera.FieldOfView = 70
    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") or nil
    LocalPlayer.ReplicationFocus = nil
end

local function hideAllUi() -- line: 65
    -- upvalues: StarterGui (copy), Tabs (copy), t1 (copy), LocalPlayer (copy), t3 (ref), v2 (ref), t4 (ref)
    if t3 ~= nil then
        return
    end

    local t6 = {}

    v2 = Tabs.Active()

    for _, child in LocalPlayer:WaitForChild("PlayerGui"):GetChildren() do
        if child:IsA("ScreenGui") and child.Name ~= "CutsceneUI" and child.Enabled then
            t6[child] = true
            child.Enabled = false
        end
    end

    t3 = t6

    local function v3() -- line: 80
        -- upvalues: LocalPlayer (copy)
        LocalPlayer.PlayerGui.BottomUI.BottomFrame.Holder.List.Visible = false
    end

    pcall(v3)

    local t7 = {}

    for _, v4 in t1 do
        t7[v4] = StarterGui:GetCoreGuiEnabled(v4)
        StarterGui:SetCoreGuiEnabled(v4, false)
    end

    t4 = t7
end

local function restoreAllUi() -- line: 90
    -- upvalues: StarterGui (copy), LocalPlayer (copy), t3 (ref), v2 (ref), t4 (ref)
    local t8 = t3
    local v5 = v2

    t3 = nil
    v2 = nil

    if t8 ~= nil then
        for v6 in t8 do
            if v6.Parent ~= nil and v6.Name ~= v5 then
                v6.Enabled = true
            end
        end
    end

    local function v7() -- line: 103
        -- upvalues: LocalPlayer (copy)
        LocalPlayer.PlayerGui.BottomUI.BottomFrame.Holder.List.Visible = true
    end

    pcall(v7)

    local t9 = t4

    t4 = nil

    if t9 ~= nil then
        for v8, v9 in t9 do
            StarterGui:SetCoreGuiEnabled(v8, v9)
        end
    end

    return v5
end

local function hideCutsceneUi() -- line: 115
    -- upvalues: HiddenUIHandler (copy), v1 (ref), hideAllUi (copy)
    if v1 == nil then
        v1 = HiddenUIHandler.Acquire()
    end

    hideAllUi()
end

local function restoreCutsceneUi() -- line: 122
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

local function setTransparency(p1, p2) -- line: 134
    for _, v12 in p1 do
        if v12:IsA("BasePart") then
            if not v12:GetAttribute("OriginalTransparency") then
                v12:SetAttribute("OriginalTransparency", v12.Transparency)
            end

            v12.Transparency = p2 or v12:GetAttribute("OriginalTransparency")
        end
    end
end

local function restoreGuard(p3, p4) -- line: 147
    -- upvalues: t5 (copy)
    t5[p3] = nil

    local Guard = p4:FindFirstChild("Guard")

    if Guard == nil or Guard == p3 then
        p3.Parent = p4
    end
end

local function hideAllGuardsAndNests(p5) -- line: 156
    -- upvalues: t5 (copy), setTransparency (copy)
    for _, child in (game.Workspace.World.Areas.GuardAreas:GetChildren()) do
        local Guard = child.Guard

        t5[Guard] = child
        Guard.Parent = nil

        local Nests = child:FindFirstChild("Nests")
        local v13 = Nests and Nests:GetDescendants()

        if v13 then
            setTransparency(v13, 1)
        end

        p5:Add(function() -- line: 170
            -- upvalues: child (copy), Guard (copy), Nests (copy), v13 (copy), t5 (copy), setTransparency (copy)
            t5[Guard] = nil

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

local function setEmitting(p6, p7) -- line: 179
    for _, descendant in p6:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
            descendant.Enabled = p7
        end
    end
end

local function emitBurst(p8) -- line: 188
    for _, descendant in p8:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local EmitCount = descendant:GetAttribute("EmitCount")
            local EmitDuration = descendant:GetAttribute("EmitDuration")
            local EmitDelay = descendant:GetAttribute("EmitDelay")
            local delay = task.delay

            if type(EmitDelay) ~= "number" then
                EmitDelay = 0
            end

            delay(EmitDelay, function() -- line: 197
                -- upvalues: descendant (copy), EmitCount (copy), EmitDuration (copy)
                if type(EmitCount) == "number" and EmitCount ~= 0 then
                    descendant:Emit(EmitCount)
                end

                if type(EmitDuration) == "number" and EmitDuration ~= 0 then
                    descendant.Enabled = true
                    task.delay(EmitDuration, function() -- line: 203
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false
                    end)
                end
            end)
        end
    end
end

return function(p9) -- line: 213
    -- upvalues: ContentProvider (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), SoundService (copy), TweenService (copy), Workspace (copy), CutsceneHelperFunctions (copy), LightingController (copy), IntroCutscene (copy), t2 (copy), CurrentCamera (copy), LocalPlayer (copy), restoreCamera (copy), hideCutsceneUi (copy), restoreCutsceneUi (copy), hideAllGuardsAndNests (copy), setEmitting (copy), emitBurst (copy)
    local v14 = p9:Extend()
    local v15 = CutsceneHelperFunctions.GetHelperFunctions(v14)
    local SetProperty, TweenProperty, LoadAnimationIntoRig = v15.SetProperty, v15.TweenProperty, v15.LoadAnimationIntoRig
    local CutsceneUI = LocalPlayer.PlayerGui.CutsceneUI
    local Black, Vignette = CutsceneUI.Black, CutsceneUI.Vignette
    local clone
    local t10 = {
        [0] = {
            SetProperty("Workspace.CurrentCamera.FieldOfView", 45),
            SetProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", 0),
            TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.25, Enum.EasingStyle.Linear), 1),
            SetProperty("Lighting.CutsceneBlur.Enabled", true),
            SetProperty("Lighting.CutsceneBlur.Size", 15),
            TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.65, Enum.EasingStyle.Linear), 2),
            SetProperty("PlayerGui.CutsceneUI.Vignette.Visible", true),
            SetProperty("PlayerGui.CutsceneUI.Vignette.ImageColor3", Color3.new(0, 0, 0)),
            TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageColor3", TweenInfo.new(4.8, Enum.EasingStyle.Linear), Color3.new(1, 0.702146, 0.282353)),
            SetProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", 1),
            SetProperty("Lighting.ColorCorrection.TintColor", Color3.new(1, 0.913726, 0.917647)),
            SetProperty("Lighting.ColorCorrection.Brightness", 0.05),
            SetProperty("Lighting.ColorCorrection.Saturation", 0.3),
            SetProperty("Lighting.ColorCorrection.Contrast", 0.3),
            SetProperty("Lighting.Close.Enabled", false),
            SetProperty("Lighting.Close.FarIntensity", 0.75),
            TweenProperty("Lighting.Close.FarIntensity", TweenInfo.new(24.016666666666666, Enum.EasingStyle.Linear), 0.63),
            SetProperty("Lighting.Close.FocusDistance", 14),
            TweenProperty("Lighting.Close.FocusDistance", TweenInfo.new(24.016666666666666, Enum.EasingStyle.Linear), 0),
            SetProperty("Lighting.Close.InFocusRadius", 0),
            TweenProperty("Lighting.Close.InFocusRadius", TweenInfo.new(24.016666666666666, Enum.EasingStyle.Linear), 13.5),
            SetProperty("Lighting.Close.NearIntensity", 0),
            SetProperty("Workspace.BeanstalkIntroVFX.Water.CFrame", CFrame.new(6956.6724, 53.7656, 1633.7804, 1, 0, 0, 0, 1, 0, 0, 0, 1))
        },
        [57] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.4166666666666667, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 25) },
        [58] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.18333333333333332, Enum.EasingStyle.Linear), 12) },
        [69] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.18333333333333332, Enum.EasingStyle.Linear), 2) },
        [288] = {
            TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageColor3", TweenInfo.new(0.15, Enum.EasingStyle.Linear), Color3.new(1, 0.808247, 0.47451)),
            TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.15, Enum.EasingStyle.Linear), 0.2),
            TweenProperty("Lighting.ColorCorrection.TintColor", TweenInfo.new(0.16666666666666666, Enum.EasingStyle.Linear), Color3.new(1, 0.976241, 0.705882)),
            TweenProperty("Lighting.ColorCorrection.Saturation", TweenInfo.new(0.16666666666666666, Enum.EasingStyle.Linear), 0.5),
            TweenProperty("Lighting.ColorCorrection.Contrast", TweenInfo.new(0.16666666666666666, Enum.EasingStyle.Linear), 1)
        },
        [297] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(1.3166666666666667, Enum.EasingStyle.Linear), 0.2) },
        [376] = {
            TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 35),
            TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 1),
            TweenProperty("Lighting.ColorCorrection.TintColor", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), Color3.new(1, 0.913726, 0.917647)),
            TweenProperty("Lighting.ColorCorrection.Saturation", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 0.3),
            TweenProperty("Lighting.ColorCorrection.Contrast", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 0.3)
        },
        [669] = {
            TweenProperty("Lighting.ColorCorrection.TintColor", TweenInfo.new(0.3333333333333333, Enum.EasingStyle.Linear), Color3.new(1, 0.639216, 0.922617)),
            TweenProperty("Lighting.ColorCorrection.Brightness", TweenInfo.new(0.3333333333333333, Enum.EasingStyle.Linear), 0.2),
            TweenProperty("Lighting.ColorCorrection.Saturation", TweenInfo.new(0.3333333333333333, Enum.EasingStyle.Linear), 0.4),
            TweenProperty("Lighting.ColorCorrection.Contrast", TweenInfo.new(0.3333333333333333, Enum.EasingStyle.Linear), 0.8)
        },
        [726] = {
            TweenProperty("Lighting.ColorCorrection.TintColor", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), Color3.new(1, 0.913726, 0.917647)),
            TweenProperty("Lighting.ColorCorrection.Brightness", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), 0.05),
            TweenProperty("Lighting.ColorCorrection.Saturation", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), 0.3),
            TweenProperty("Lighting.ColorCorrection.Contrast", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), 0.3)
        },
        [884] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 30) },
        [885] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(1.75, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 31.52174) },
        [990] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Sine), 20) },
        [991] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.36666666666666664, Enum.EasingStyle.Sine), 35) },
        [1002] = {
            function() -- line: 315
                -- upvalues: clone (ref), emitBurst (copy)
                emitBurst(clone.GroundCrack)
            end
        },
        [1090] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Sine), 45) },
        [1107] = {
            function() -- line: 325
                -- upvalues: clone (ref), emitBurst (copy)
                emitBurst(clone.GroundCrack3)
            end
        },
        [1219] = {
            function() -- line: 331
                -- upvalues: clone (ref), emitBurst (copy)
                emitBurst(clone.GroundCrack2)
            end
        },
        [1230] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Sine), 30) },
        [1241] = {
            function() -- line: 341
                -- upvalues: clone (ref), setEmitting (copy)
                setEmitting(clone.Water, true)
            end
        },
        [1269] = {
            function() -- line: 347
                -- upvalues: clone (ref), emitBurst (copy)
                emitBurst(clone.GroundCrack4)
            end,
            TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.11666666666666667, Enum.EasingStyle.Linear), 10),
            TweenProperty("Workspace.BeanstalkIntroVFX.Water.CFrame", TweenInfo.new(0.21666666666666667, Enum.EasingStyle.Linear), CFrame.new(6956.6724, 77.0232, 1632.0439, 1, 0, 0, 0, 1, 0, 0, 0, 1))
        },
        [1274] = {
            function() -- line: 355
                -- upvalues: clone (ref), emitBurst (copy)
                emitBurst(clone.Break)
            end
        },
        [1276] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(1.2833333333333334, Enum.EasingStyle.Linear), 4) },
        [1282] = { TweenProperty("Workspace.BeanstalkIntroVFX.Water.CFrame", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), CFrame.new(6956.6724, 96.4883, 1632.0439, 1, 0, 0, 0, 1, 0, 0, 0, 1)) },
        [1299] = { TweenProperty("Workspace.BeanstalkIntroVFX.Water.CFrame", TweenInfo.new(1.1666666666666667, Enum.EasingStyle.Linear), CFrame.new(6956.6724, 174.3108, 1632.0439, 1, 0, 0, 0, 1, 0, 0, 0, 1)) },
        [1369] = {
            function() -- line: 373
                -- upvalues: clone (ref), setEmitting (copy)
                setEmitting(clone.Water, false)
            end
        },
        [1440] = {
            TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Sine), 50),
            TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 2)
        },
        [1441] = { SetProperty("Lighting.Close.Enabled", true) },
        [1457] = { TweenProperty("Lighting.Close.InFocusRadius", TweenInfo.new(0.45, Enum.EasingStyle.Linear), 10) },
        [1484] = { TweenProperty("Lighting.Close.InFocusRadius", TweenInfo.new(0.43333333333333335, Enum.EasingStyle.Linear), 75) },
        [1605] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.25, Enum.EasingStyle.Linear), 0) }
    }

    return {
        Run = function() -- Run | line: 401
            -- upvalues: p9 (copy), v14 (copy), LoadAnimationIntoRig (copy), CutsceneUI (copy), Black (copy), Vignette (copy), clone (ref), t10 (copy), ContentProvider (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), SoundService (copy), TweenService (copy), Workspace (copy), LightingController (copy), IntroCutscene (copy), t2 (copy), CurrentCamera (copy), LocalPlayer (copy), restoreCamera (copy), hideCutsceneUi (copy), restoreCutsceneUi (copy), hideAllGuardsAndNests (copy)
            local _warn = warn

            xpcall(hideCutsceneUi, _warn)
            v14:Add(restoreCutsceneUi)

            local AreaEggSlotsClient = Workspace:FindFirstChild("AreaEggSlotsClient")

            if AreaEggSlotsClient ~= nil then
                AreaEggSlotsClient.Parent = ReplicatedStorage
                v14:Add(function() -- line: 408
                    -- upvalues: AreaEggSlotsClient (copy), Workspace (copy)
                    AreaEggSlotsClient.Parent = Workspace
                end)
            end

            hideAllGuardsAndNests(v14)
            LightingController.Settle()

            for _, v16 in t2 do
                local v17 = Lighting:FindFirstChildOfClass(v16)

                if v17 ~= nil then
                    v17.Parent = nil
                    v14:Add(function() -- line: 422
                        -- upvalues: v17 (copy), Lighting (copy)
                        v17.Parent = Lighting
                    end)
                end
            end

            v14:Add(function() -- line: 426
                -- upvalues: LightingController (copy)
                LightingController.Settle()
            end)

            for _, child in IntroCutscene.LightingAssets:GetChildren() do
                if not Lighting:FindFirstChild(child.Name) then
                    local clone = child:Clone()

                    clone.Parent = Lighting
                    v14:Add(clone)
                end
            end

            CutsceneUI.Enabled = true
            Black.BackgroundTransparency = 1
            Black.Visible = true
            Vignette.Visible = false
            v14:Add(function() -- line: 442
                -- upvalues: Vignette (copy)
                Vignette.Visible = false
                Vignette.ImageTransparency = 1
                Vignette.ImageColor3 = Color3.new(0, 0, 0)
            end)
            p9:Add(function() -- line: 448
                -- upvalues: Black (copy)
                Black.BackgroundTransparency = 1
                Black.BackgroundColor3 = Color3.new(0, 0, 0)
                Black.Visible = false
            end)

            local clone2 = IntroCutscene.BeanstalkIntroVFX:Clone()

            clone2.Parent = Workspace
            clone = clone2
            v14:Add(clone2)

            local clone3 = IntroCutscene.BeanstalkIntroWorkspaceAssets:Clone()

            clone3.Parent = Workspace
            v14:Add(clone3)

            local clone4 = IntroCutscene.CutsceneMusic:Clone()

            clone4.Parent = SoundService
            v14:Add(clone4)
            TweenService:Create(Black, TweenInfo.new(0.1), {
                BackgroundTransparency = 0
            }):Play()

            local clone5 = IntroCutscene.BeanstalkIntroRigs:Clone()

            v14:Add(clone5)

            for _, child in clone5:GetChildren() do
                if child:IsA("Model") and child.PrimaryPart then
                    child.PrimaryPart.Anchored = true
                end
            end

            clone5.Parent = Workspace

            local t12 = {}

            for _, child in clone5:GetChildren() do
                table.insert(t12, (child:FindFirstChild("Animation")))
            end

            ContentProvider:PreloadAsync(t12)

            local t13 = {}

            for _, child in clone5:GetChildren() do
                t13[child] = LoadAnimationIntoRig(child, child:FindFirstChild("Animation").AnimationId)
            end

            local v18 = true

            v14:Add(function() -- line: 492
                -- upvalues: v18 (ref), restoreCamera (copy)
                v18 = false
                restoreCamera()
            end)

            for _, v19 in t13 do
                v19:Play(0)
            end

            local v20 = t13[clone5.CameraRig]
            local v21 = os.clock() + 2

            while v18 and v20.TimePosition <= 0 and os.clock() < v21 do
                RunService.RenderStepped:Wait()
            end

            clone4:Play()

            local Cam = clone5.CameraRig.Cam

            v14:Connect(RunService.RenderStepped, function() -- line: 514
                -- upvalues: v18 (ref), Cam (copy), CurrentCamera (copy), LocalPlayer (copy)
                if not v18 then
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
            local connection = v14:Connect(RunService.Heartbeat, function(p10) -- line: 527
                -- upvalues: clone4 (copy), t13 (copy), t14 (copy), n1 (ref), n2 (ref), t10 (copy)
                n1 += p10
                n2 -= 0.1

                if n2 <= 0 then
                    n2 = 0.1

                    for _, v22 in t13 do
                        if v22.IsPlaying then
                            local v24 = n1

                            if math.abs(v24 - v22.TimePosition) >= 0.4 then
                                local function v25() -- line: 539
                                    -- upvalues: v22 (copy), n1 (ref)
                                    v22.TimePosition = n1
                                end

                                local _warn = warn

                                xpcall(v25, _warn)
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
                    local v27 = math.floor(n1 * 60 - i)

                    if t10[v27] and not t14[v27] then
                        t14[v27] = true

                        for _, v28 in t10[v27] do
                            task.spawn(v28)
                        end
                    end
                end
            end)

            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(27.5)
            connection:Disconnect()
            Black.BackgroundTransparency = 0
            v14:Clean()
            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(0.5)
            Black.Visible = false
        end
    }
end
