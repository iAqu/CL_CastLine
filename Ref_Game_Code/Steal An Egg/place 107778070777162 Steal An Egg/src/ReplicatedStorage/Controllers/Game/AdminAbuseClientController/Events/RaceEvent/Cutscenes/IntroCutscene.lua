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
local MountRace = require(ReplicatedStorage.Data.MountRace)
local MusicDirector = require(ReplicatedStorage.Client.MusicDirector)
local Tabs = require(ReplicatedStorage.Client.Tabs)

require(ReplicatedStorage.Packages.Trove)

local IntroCutscene = ReplicatedStorage.CutsceneAssets.RaceEventCutsceneAssets.IntroCutscene
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

local function onTrack(p1) -- line: 60
    return p1 + Vector3.new(-4009, 0, 9397)
end

local function restoreCamera() -- line: 64
    -- upvalues: TweenService (copy), CurrentCamera (copy), LocalPlayer (copy)
    TweenService:Create(CurrentCamera, TweenInfo.new(0), {
        FieldOfView = 70
    }):Play()
    CurrentCamera.FieldOfView = 70
    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") or nil
    LocalPlayer.ReplicationFocus = nil
end

local function hideAllUi() -- line: 73
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

    local function v3() -- line: 88
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

local function restoreAllUi() -- line: 98
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

    local function v7() -- line: 111
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

local function hideCutsceneUi() -- line: 123
    -- upvalues: HiddenUIHandler (copy), v1 (ref), hideAllUi (copy)
    if v1 == nil then
        v1 = HiddenUIHandler.Acquire()
    end

    hideAllUi()
end

local function restoreCutsceneUi() -- line: 130
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

local function hideRacers(p2) -- line: 144
    -- upvalues: Players (copy), RunService (copy), Workspace (copy)
    local t8 = {}
    local t9 = {}

    local function collect(p3) -- line: 147
        -- upvalues: t8 (copy), t9 (copy)
        for _, descendant in p3:GetDescendants() do
            if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                t8[descendant] = true
            elseif (descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") or descendant:IsA("BillboardGui") or descendant:IsA("Highlight")) and t9[descendant] == nil then
                t9[descendant] = descendant.Enabled
                descendant.Enabled = false
            end
        end
    end

    local n1 = 0

    RunService:BindToRenderStep("RaceIntroHideRacers", Enum.RenderPriority.Camera.Value + 2, function() -- line: 163
        -- upvalues: t8 (copy), collect (copy), n1 (ref), Players (copy), Workspace (copy)
        if os.clock() >= n1 then
            n1 = os.clock() + 0.25

            for _, player in Players:GetPlayers() do
                local Character = player.Character

                if Character ~= nil then
                    collect(Character)
                end
            end

            local RaceBots = Workspace:FindFirstChild("RaceBots")

            if RaceBots ~= nil then
                collect(RaceBots)
            end
        end

        for v13 in t8 do
            v13.LocalTransparencyModifier = 1
        end
    end)
    p2:Add(function() -- line: 181
        -- upvalues: t8 (copy), t9 (copy), RunService (copy)
        RunService:UnbindFromRenderStep("RaceIntroHideRacers")

        for v14 in t8 do
            v14.LocalTransparencyModifier = 0
        end

        for v15, v16 in t9 do
            v15.Enabled = v16
        end
    end)
end

local function setEmitting(p4, p5) -- line: 192
    for _, descendant in p4:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
            descendant.Enabled = p5
        end
    end
end

local function emitBurst(p6) -- line: 201
    for _, descendant in p6:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local EmitCount = descendant:GetAttribute("EmitCount")
            local EmitDuration = descendant:GetAttribute("EmitDuration")
            local EmitDelay = descendant:GetAttribute("EmitDelay")
            local delay = task.delay

            if type(EmitDelay) ~= "number" then
                EmitDelay = 0
            end

            delay(EmitDelay, function() -- line: 210
                -- upvalues: descendant (copy), EmitCount (copy), EmitDuration (copy)
                if type(EmitCount) == "number" and EmitCount ~= 0 then
                    descendant:Emit(EmitCount)
                end

                if type(EmitDuration) == "number" and EmitDuration ~= 0 then
                    descendant.Enabled = true
                    task.delay(EmitDuration, function() -- line: 216
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false
                    end)
                end
            end)
        end
    end
end

return function(p7) -- line: 226
    -- upvalues: ContentProvider (copy), Lighting (copy), RunService (copy), SoundService (copy), TweenService (copy), Workspace (copy), CutsceneHelperFunctions (copy), MountRace (copy), MusicDirector (copy), IntroCutscene (copy), CurrentCamera (copy), LocalPlayer (copy), restoreCamera (copy), hideCutsceneUi (copy), restoreCutsceneUi (copy), hideRacers (copy), setEmitting (copy), emitBurst (copy)
    local v17 = p7:Extend()
    local v18 = CutsceneHelperFunctions.GetHelperFunctions(v17)
    local SetProperty, TweenProperty, LoadAnimationIntoRig = v18.SetProperty, v18.TweenProperty, v18.LoadAnimationIntoRig
    local CutsceneUI = LocalPlayer.PlayerGui.CutsceneUI
    local Black, Vignette = CutsceneUI.Black, CutsceneUI.Vignette
    local clone
    local v19 = CFrame.new(0, 0, 0, 0.9999, 0.0102, 1E-04, -0.0102, 0.9982, 0.059, 5E-04, -0.059, 0.9983)
    local v20 = CFrame.new(0, 0, 0, 0.9999, 0.0102, -4E-04, -0.0102, 0.9999, 0.0092, 5E-04, -0.0092, 1)
    local v21 = CFrame.new(0, 0, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0)

    local function brakes(p8, p9, p10, p11) -- line: 241
        return CFrame.new(p8, p9, p10) * p11 + Vector3.new(-4009, 0, 9397)
    end

    local function speedBuff(p12, p13, p14) -- line: 244
        -- upvalues: v21 (copy)
        return CFrame.new(p12, p13, p14) * v21 + Vector3.new(-4009, 0, 9397)
    end

    local t10 = {
        [0] = {
            SetProperty("Workspace.CurrentCamera.FieldOfView", 50),
            SetProperty("Lighting.CutsceneBlur.Size", 15),
            SetProperty("Workspace.RaceIntroRigs.CROCANIMS.SpeedBuff.CFrame", CFrame.new(600.513, 172.0128, 53.7681) * v21 + Vector3.new(-4009, 0, 9397)),
            TweenProperty("Workspace.RaceIntroRigs.CROCANIMS.SpeedBuff.CFrame", TweenInfo.new(7.233333333333333, Enum.EasingStyle.Linear), CFrame.new(600.513, 134.862, 53.7681) * v21 + Vector3.new(-4009, 0, 9397)),
            SetProperty("Workspace.RaceIntroVFX.Brakes.CFrame", CFrame.new(597.338, 205.8216, 450.1992) * v19 + Vector3.new(-4009, 0, 9397)),
            TweenProperty("Workspace.RaceIntroVFX.Brakes.CFrame", TweenInfo.new(11.1, Enum.EasingStyle.Linear), CFrame.new(597.3363, 205.1604, 439.0122) * v19 + Vector3.new(-4009, 0, 9397)),
            SetProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", 0),
            SetProperty("PlayerGui.CutsceneUI.Black.BackgroundColor3", Color3.new(0, 0, 0)),
            SetProperty("PlayerGui.CutsceneUI.Vignette.Visible", true),
            SetProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", 1),
            TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.5, Enum.EasingStyle.Linear), 1),
            SetProperty("Lighting.Croc.Enabled", false),
            SetProperty("Lighting.Croc.Saturation", 0.3),
            SetProperty("Lighting.Croc.Contrast", 0.4),
            SetProperty("Lighting.Croc.TintColor", Color3.new(0.929412, 1, 0.941177)),
            SetProperty("Lighting.Croc.Brightness", 0.3)
        },
        [22] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(1.05, Enum.EasingStyle.Linear), 2) },
        [434] = { TweenProperty("Workspace.RaceIntroRigs.CROCANIMS.SpeedBuff.CFrame", TweenInfo.new(0.2, Enum.EasingStyle.Linear), CFrame.new(600.963, 187.1631, -40.1157) * v21 + Vector3.new(-4009, 0, 9397)) },
        [446] = { TweenProperty("Workspace.RaceIntroRigs.CROCANIMS.SpeedBuff.CFrame", TweenInfo.new(0.23333333333333334, Enum.EasingStyle.Linear), CFrame.new(600.7661, 187.9726, -0.1618) * v21 + Vector3.new(-4009, 0, 9397)) },
        [460] = { TweenProperty("Workspace.RaceIntroRigs.CROCANIMS.SpeedBuff.CFrame", TweenInfo.new(0.15, Enum.EasingStyle.Linear), CFrame.new(600.6395, 188.8895, 27.5817) * v21 + Vector3.new(-4009, 0, 9397)) },
        [469] = { TweenProperty("Workspace.RaceIntroRigs.CROCANIMS.SpeedBuff.CFrame", TweenInfo.new(0.15, Enum.EasingStyle.Linear), CFrame.new(600.513, 190.52, 53.7681) * v21 + Vector3.new(-4009, 0, 9397)) },
        [471] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.6166666666666667, Enum.EasingStyle.Linear), 0.5) },
        [478] = { TweenProperty("Workspace.RaceIntroRigs.CROCANIMS.SpeedBuff.CFrame", TweenInfo.new(0.3, Enum.EasingStyle.Linear), CFrame.new(600.513, 191.9059, 109.858) * v21 + Vector3.new(-4009, 0, 9397)) },
        [496] = { TweenProperty("Workspace.RaceIntroRigs.CROCANIMS.SpeedBuff.CFrame", TweenInfo.new(0.26666666666666666, Enum.EasingStyle.Linear), CFrame.new(600.513, 194.1781, 158.7036) * v21 + Vector3.new(-4009, 0, 9397)) },
        [512] = { TweenProperty("Workspace.RaceIntroRigs.CROCANIMS.SpeedBuff.CFrame", TweenInfo.new(0.38333333333333336, Enum.EasingStyle.Linear), CFrame.new(600.513, 197.7077, 228.384) * v21 + Vector3.new(-4009, 0, 9397)) },
        [517] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.5333333333333333, Enum.EasingStyle.Linear), 1) },
        [535] = { TweenProperty("Workspace.RaceIntroRigs.CROCANIMS.SpeedBuff.CFrame", TweenInfo.new(0.55, Enum.EasingStyle.Linear), CFrame.new(600.513, 200.8587, 282.8826) * v21 + Vector3.new(-4009, 0, 9397)) },
        [568] = { TweenProperty("Workspace.RaceIntroRigs.CROCANIMS.SpeedBuff.CFrame", TweenInfo.new(0.3333333333333333, Enum.EasingStyle.Linear), CFrame.new(598.5856, 202.3643, 285.6259) * v21 + Vector3.new(-4009, 0, 9397)) },
        [585] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 0) },
        [586] = { SetProperty("Lighting.Croc.Enabled", true) },
        [588] = { TweenProperty("Workspace.RaceIntroRigs.CROCANIMS.SpeedBuff.CFrame", TweenInfo.new(0.25, Enum.EasingStyle.Linear), CFrame.new(598.6507, 202.7567, 314.9995) * v21 + Vector3.new(-4009, 0, 9397)) },
        [603] = { TweenProperty("Workspace.RaceIntroRigs.CROCANIMS.SpeedBuff.CFrame", TweenInfo.new(0.6833333333333333, Enum.EasingStyle.Linear), CFrame.new(598.024, 206.5802, 394.2784) * v21 + Vector3.new(-4009, 0, 9397)) },
        [614] = {
            function() -- line: 333
                -- upvalues: clone (ref), setEmitting (copy)
                setEmitting(clone.Brakes, true)
            end
        },
        [625] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.55, Enum.EasingStyle.Linear), 1) },
        [626] = {
            TweenProperty("Lighting.Croc.Saturation", TweenInfo.new(0.5333333333333333, Enum.EasingStyle.Linear), 0),
            TweenProperty("Lighting.Croc.Contrast", TweenInfo.new(0.5333333333333333, Enum.EasingStyle.Linear), 0),
            TweenProperty("Lighting.Croc.TintColor", TweenInfo.new(0.5333333333333333, Enum.EasingStyle.Linear), Color3.new(1, 1, 1)),
            TweenProperty("Lighting.Croc.Brightness", TweenInfo.new(0.5333333333333333, Enum.EasingStyle.Linear), 0)
        },
        [644] = { TweenProperty("Workspace.RaceIntroRigs.CROCANIMS.SpeedBuff.CFrame", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), CFrame.new(597.9403, 207.7471, 426.6629) * v21 + Vector3.new(-4009, 0, 9397)) },
        [661] = { TweenProperty("Workspace.RaceIntroRigs.CROCANIMS.SpeedBuff.CFrame", TweenInfo.new(0.06666666666666667, Enum.EasingStyle.Linear), CFrame.new(597.9403, 207.7471, 435.8149) * v21 + Vector3.new(-4009, 0, 9397)) },
        [665] = { TweenProperty("Workspace.RaceIntroRigs.CROCANIMS.SpeedBuff.CFrame", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), CFrame.new(597.9403, 174.5771, 435.8149) * v21 + Vector3.new(-4009, 0, 9397)) },
        [666] = { TweenProperty("Workspace.RaceIntroVFX.Brakes.CFrame", TweenInfo.new(0.1, Enum.EasingStyle.Linear), CFrame.new(597.338, 205.8216, 450.1992) * v19 + Vector3.new(-4009, 0, 9397)) },
        [672] = { TweenProperty("Workspace.RaceIntroVFX.Brakes.CFrame", TweenInfo.new(0.16666666666666666, Enum.EasingStyle.Linear), CFrame.new(597.7242, 206.6158, 463.7007) * v19 + Vector3.new(-4009, 0, 9397)) },
        [682] = { TweenProperty("Workspace.RaceIntroVFX.Brakes.CFrame", TweenInfo.new(0.16666666666666666, Enum.EasingStyle.Linear), CFrame.new(597.7205, 206.8149, 476.3184) * v19 + Vector3.new(-4009, 0, 9397)) },
        [692] = { TweenProperty("Workspace.RaceIntroVFX.Brakes.CFrame", TweenInfo.new(0.18333333333333332, Enum.EasingStyle.Linear), CFrame.new(597.7206, 207.6047, 493.7596) * v19 + Vector3.new(-4009, 0, 9397)) },
        [703] = { TweenProperty("Workspace.RaceIntroVFX.Brakes.CFrame", TweenInfo.new(0.23333333333333334, Enum.EasingStyle.Linear), CFrame.new(597.7156, 207.7132, 507.1371) * v20 + Vector3.new(-4009, 0, 9397)) },
        [717] = { TweenProperty("Workspace.RaceIntroVFX.Brakes.CFrame", TweenInfo.new(0.95, Enum.EasingStyle.Linear), CFrame.new(597.7064, 207.947, 532.5401) * v20 + Vector3.new(-4009, 0, 9397)) },
        [740] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.7666666666666667, Enum.EasingStyle.Linear), 0.5) },
        [748] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.5833333333333334, Enum.EasingStyle.Linear), 10) },
        [783] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.11666666666666667, Enum.EasingStyle.Linear), 13) },
        [790] = {
            TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 2),
            TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 1)
        },
        [791] = {
            function() -- line: 403
                -- upvalues: clone (ref), setEmitting (copy)
                setEmitting(clone.Brakes, false)
            end
        },
        [1899] = {
            function() -- line: 409
                -- upvalues: clone (ref), setEmitting (copy)
                setEmitting(clone.AreaVFX, true)
            end
        },
        [1924] = {
            function() -- line: 415
                -- upvalues: clone (ref), emitBurst (copy)
                emitBurst(clone.Fireworks)
            end
        },
        [2089] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.25, Enum.EasingStyle.Linear), 15) },
        [2134] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.3333333333333333, Enum.EasingStyle.Linear), 0) },
        [2154] = {
            function() -- line: 429
                -- upvalues: clone (ref), setEmitting (copy)
                setEmitting(clone.AreaVFX, false)
            end
        }
    }

    return {
        Run = function() -- Run | line: 436
            -- upvalues: p7 (copy), v17 (copy), LoadAnimationIntoRig (copy), CutsceneUI (copy), Black (copy), Vignette (copy), clone (ref), t10 (copy), ContentProvider (copy), Lighting (copy), RunService (copy), SoundService (copy), TweenService (copy), Workspace (copy), MountRace (copy), MusicDirector (copy), IntroCutscene (copy), CurrentCamera (copy), LocalPlayer (copy), restoreCamera (copy), hideCutsceneUi (copy), restoreCutsceneUi (copy), hideRacers (copy)
            LocalPlayer:SetAttribute(MountRace.CutsceneAttribute, true)
            v17:Add(function() -- line: 439
                -- upvalues: MountRace (copy), LocalPlayer (copy)
                LocalPlayer:SetAttribute(MountRace.CutsceneAttribute, nil)
            end)

            local _warn = warn

            xpcall(hideCutsceneUi, _warn)
            v17:Add(restoreCutsceneUi)
            hideRacers(v17)
            MusicDirector.SetEventMusic(true)
            v17:Add(function() -- line: 448
                -- upvalues: MusicDirector (copy)
                MusicDirector.SetEventMusic(false)
            end)

            for _, child in IntroCutscene.LightingAssets:GetChildren() do
                if not Lighting:FindFirstChild(child.Name) then
                    local clone = child:Clone()

                    clone.Parent = Lighting
                    v17:Add(clone)
                end
            end

            CutsceneUI.Enabled = true
            Black.BackgroundTransparency = 1
            Black.Visible = true
            Vignette.Visible = false
            v17:Add(function() -- line: 465
                -- upvalues: Vignette (copy)
                Vignette.Visible = false
                Vignette.ImageTransparency = 1
            end)
            p7:Add(function() -- line: 470
                -- upvalues: Black (copy)
                Black.BackgroundTransparency = 1
                Black.BackgroundColor3 = Color3.new(0, 0, 0)
                Black.Visible = false
            end)

            local clone2 = IntroCutscene.RaceIntroVFX:Clone()

            clone2.Parent = Workspace
            clone = clone2
            v17:Add(clone2)

            local clone3 = IntroCutscene.CutsceneMusic:Clone()

            clone3.Parent = SoundService
            v17:Add(clone3)
            TweenService:Create(Black, TweenInfo.new(0.1), {
                BackgroundTransparency = 0
            }):Play()

            local clone4 = IntroCutscene.RaceIntroRigs:Clone()

            v17:Add(clone4)

            for _, child in clone4:GetChildren() do
                if child:IsA("Model") and child.PrimaryPart then
                    child.PrimaryPart.Anchored = true
                end
            end

            clone4.CROCANIMS.SpeedBuff:FindFirstChild("SPEED").Part1 = clone2.SPEED
            clone2.SPEED.Anchored = false
            clone4.Parent = Workspace

            local t12 = {}

            for _, child in clone4:GetChildren() do
                table.insert(t12, (child:FindFirstChild("Animation")))
            end

            ContentProvider:PreloadAsync(t12)

            local t13 = {}

            for _, child in clone4:GetChildren() do
                t13[child] = LoadAnimationIntoRig(child, child:FindFirstChild("Animation").AnimationId)
            end

            local v22 = true

            v17:Add(function() -- line: 513
                -- upvalues: v22 (ref), restoreCamera (copy)
                v22 = false
                restoreCamera()
            end)

            for _, v23 in t13 do
                v23:Play(0)
            end

            local v24 = t13[clone4.CameraRig]
            local v25 = os.clock() + 2

            while v22 and v24.TimePosition <= 0 and os.clock() < v25 do
                RunService.RenderStepped:Wait()
            end

            clone3:Play()

            local Head = clone4.CameraRig.Head

            v17:Connect(RunService.RenderStepped, function() -- line: 535
                -- upvalues: v22 (ref), Head (copy), CurrentCamera (copy), LocalPlayer (copy)
                if not v22 then
                    return
                end

                CurrentCamera.CameraType = Enum.CameraType.Scriptable
                LocalPlayer.ReplicationFocus = Head
                CurrentCamera.Focus = Head.CFrame
                CurrentCamera.CFrame = Head.CFrame
            end)

            local t14 = {}
            local n2 = 0
            local n3 = 0.1
            local connection = v17:Connect(RunService.Heartbeat, function(p15) -- line: 548
                -- upvalues: clone3 (copy), t13 (copy), t14 (copy), n2 (ref), n3 (ref), t10 (copy)
                n2 += p15
                n3 -= p15

                for _, v26 in t13 do
                    local v27 = v26.Length - 0.05

                    if v26.Length > 0 and v27 <= n2 and v26.Speed ~= 0 then
                        v26.TimePosition = v27
                        v26:AdjustSpeed(0)
                    end
                end

                if n3 <= 0 then
                    n3 = 0.1

                    for _, v28 in t13 do
                        if v28.IsPlaying and v28.Speed ~= 0 then
                            local v30 = n2

                            if math.abs(v30 - v28.TimePosition) >= 0.4 then
                                local function v31() -- line: 567
                                    -- upvalues: v28 (copy), n2 (ref)
                                    v28.TimePosition = n2
                                end

                                local _warn = warn

                                xpcall(v31, _warn)
                            end
                        end
                    end
                end

                if clone3.TimePosition < n2 - 0.001 then
                    clone3.PlaybackSpeed = 1.01
                elseif clone3.TimePosition > n2 + 0.001 then
                    clone3.PlaybackSpeed = 0.99
                else
                    clone3.PlaybackSpeed = 1
                end

                for i = 0, 9 do
                    local v33 = math.floor(n2 * 60 - i)

                    if t10[v33] and not t14[v33] then
                        t14[v33] = true

                        for _, v34 in t10[v33] do
                            task.spawn(v34)
                        end
                    end
                end
            end)

            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(36.4)
            connection:Disconnect()
            Black.BackgroundTransparency = 0
            v17:Clean()
            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(0.5)
            Black.Visible = false
        end
    }
end
