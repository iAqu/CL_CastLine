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
local BulkFade = require(ReplicatedStorage.Client.Modules.BulkFade)
local CutsceneHelperFunctions = require(script.Parent.Parent.Parent.Parent.CutsceneHelperFunctions)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local MountRace = require(ReplicatedStorage.Data.MountRace)
local MusicDirector = require(ReplicatedStorage.Client.MusicDirector)
local Tabs = require(ReplicatedStorage.Client.Tabs)

require(ReplicatedStorage.Packages.Trove)

local OutroCutscene = ReplicatedStorage.CutsceneAssets.RaceEventCutsceneAssets.OutroCutscene
local t1 = {
    Enum.CoreGuiType.Backpack,
    Enum.CoreGuiType.Chat,
    Enum.CoreGuiType.PlayerList,
    Enum.CoreGuiType.Health,
    Enum.CoreGuiType.EmotesMenu
}
local v1 = Color3.new(1, 0.574242, 0.247059)
local UnixTimestamp = DateTime.fromUniversalTime(2026, 10, 17, 15).UnixTimestamp
local CurrentCamera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local v2, t2, v3, t3

local function onTrack(p1) -- line: 63
    return p1 + Vector3.new(-4009, 0, 9397)
end

local function restoreCamera() -- line: 67
    -- upvalues: TweenService (copy), CurrentCamera (copy), LocalPlayer (copy)
    TweenService:Create(CurrentCamera, TweenInfo.new(0), {
        FieldOfView = 70
    }):Play()
    CurrentCamera.FieldOfView = 70
    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") or nil
    LocalPlayer.ReplicationFocus = nil
end

local function hideAllUi() -- line: 76
    -- upvalues: StarterGui (copy), Tabs (copy), t1 (copy), LocalPlayer (copy), t2 (ref), v3 (ref), t3 (ref)
    if t2 ~= nil then
        return
    end

    local t4 = {}

    v3 = Tabs.Active()

    for _, child in LocalPlayer:WaitForChild("PlayerGui"):GetChildren() do
        if child:IsA("ScreenGui") and child.Name ~= "CutsceneUI" and child.Enabled then
            t4[child] = true
            child.Enabled = false
        end
    end

    t2 = t4

    local function v4() -- line: 91
        -- upvalues: LocalPlayer (copy)
        LocalPlayer.PlayerGui.BottomUI.BottomFrame.Holder.List.Visible = false
    end

    pcall(v4)

    local t5 = {}

    for _, v5 in t1 do
        t5[v5] = StarterGui:GetCoreGuiEnabled(v5)
        StarterGui:SetCoreGuiEnabled(v5, false)
    end

    t3 = t5
end

local function restoreAllUi() -- line: 101
    -- upvalues: StarterGui (copy), LocalPlayer (copy), t2 (ref), v3 (ref), t3 (ref)
    local t6 = t2
    local v6 = v3

    t2 = nil
    v3 = nil

    if t6 ~= nil then
        for v7 in t6 do
            if v7.Parent ~= nil and v7.Name ~= v6 then
                v7.Enabled = true
            end
        end
    end

    local function v8() -- line: 114
        -- upvalues: LocalPlayer (copy)
        LocalPlayer.PlayerGui.BottomUI.BottomFrame.Holder.List.Visible = true
    end

    pcall(v8)

    local t7 = t3

    t3 = nil

    if t7 ~= nil then
        for v9, v10 in t7 do
            StarterGui:SetCoreGuiEnabled(v9, v10)
        end
    end

    return v6
end

local function hideCutsceneUi() -- line: 126
    -- upvalues: HiddenUIHandler (copy), v2 (ref), hideAllUi (copy)
    if v2 == nil then
        v2 = HiddenUIHandler.Acquire()
    end

    hideAllUi()
end

local function restoreCutsceneUi() -- line: 133
    -- upvalues: Tabs (copy), v2 (ref), restoreCamera (copy), restoreAllUi (copy)
    restoreCamera()

    local v11 = restoreAllUi()
    local v12 = v2

    v2 = nil

    if v12 ~= nil then
        v12()
    end

    if v11 ~= nil then
        Tabs.Activate(v11, {
            instant = true
        })
    end
end

local function setEmitting(p2, p3) -- line: 146
    for _, descendant in p2:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
            descendant.Enabled = p3
        end
    end
end

local function emitBurst(p4) -- line: 155
    for _, descendant in p4:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local EmitCount = descendant:GetAttribute("EmitCount")
            local EmitDuration = descendant:GetAttribute("EmitDuration")
            local EmitDelay = descendant:GetAttribute("EmitDelay")
            local delay = task.delay

            if type(EmitDelay) ~= "number" then
                EmitDelay = 0
            end

            delay(EmitDelay, function() -- line: 164
                -- upvalues: descendant (copy), EmitCount (copy), EmitDuration (copy)
                if type(EmitCount) == "number" and EmitCount ~= 0 then
                    descendant:Emit(EmitCount)
                end

                if type(EmitDuration) == "number" and EmitDuration ~= 0 then
                    descendant.Enabled = true
                    task.delay(EmitDuration, function() -- line: 170
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false
                    end)
                end
            end)
        end
    end
end

local function countdown(p5) -- line: 178
    local v14 = math.max(0, (math.floor(p5)))

    return string.format("%02i:%02i:%02i:%02i", v14 // 86400, v14 // 3600 % 24, v14 // 60 % 60, v14 % 60)
end

return function(p6) -- line: 185
    -- upvalues: ContentProvider (copy), Lighting (copy), RunService (copy), SoundService (copy), TweenService (copy), Workspace (copy), BulkFade (copy), CutsceneHelperFunctions (copy), MountRace (copy), MusicDirector (copy), OutroCutscene (copy), v1 (copy), UnixTimestamp (copy), CurrentCamera (copy), LocalPlayer (copy), restoreCamera (copy), hideCutsceneUi (copy), restoreCutsceneUi (copy), setEmitting (copy), emitBurst (copy)
    local v15 = p6:Extend()
    local v16 = CutsceneHelperFunctions.GetHelperFunctions(v15)
    local SetProperty, TweenProperty, LoadAnimationIntoRig = v16.SetProperty, v16.TweenProperty, v16.LoadAnimationIntoRig
    local CutsceneUI = LocalPlayer.PlayerGui.CutsceneUI
    local Black, Vignette = CutsceneUI.Black, CutsceneUI.Vignette
    local clone
    local v17 = CFrame.new(0, 0, 0, 0.0022, -8E-04, 1, -0.0495, 0.9988, 9E-04, -0.9988, -0.0495, 0.0021)

    local function brakes(p7, p8, p9) -- line: 198
        -- upvalues: v17 (copy)
        return CFrame.new(p7, p8, p9) * v17 + Vector3.new(-4009, 0, 9397)
    end

    local v18 = CFrame.new(0, 0, 0, 0.0755, -0.9569, 0.2803, -0.0885, -0.2864, -0.954, 0.9932, 0.0473, -0.1063)

    local function portal(p10, p11, p12) -- line: 202
        -- upvalues: v18 (copy)
        return CFrame.new(p10, p11, p12) * v18 + Vector3.new(-4009, 0, 9397)
    end

    local v19 = CFrame.new(0, 0, 0, 0.9397, -0.342, 0, 0.342, 0.9397, 0, 0, 0, 1)

    local function crack(p13, p14, p15) -- line: 206
        -- upvalues: v19 (copy)
        return CFrame.new(p13, p14, p15) * v19 + Vector3.new(-4009, 0, 9397)
    end

    local v20 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1)

    local function cameraRig(p16, p17, p18) -- line: 210
        -- upvalues: v20 (copy)
        return CFrame.new(p16, p17, p18) * v20 + Vector3.new(-4009, 0, 9397)
    end

    local function backdrop(p19, p20) -- line: 213
        -- upvalues: TweenProperty (copy)
        local t8 = {}

        for _, v21 in { "1", "2", "3", "4" } do
            table.insert(t8, TweenProperty(("Workspace.RaceOutroMap.%*.Transparency"):format(v21), p19, p20))
        end

        return t8
    end

    local t9 = {
        [0] = {
            SetProperty("Workspace.CurrentCamera.FieldOfView", 55),
            TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(1.2333333333333334, Enum.EasingStyle.Linear), 35),
            function() -- line: 225
                -- upvalues: clone (ref), setEmitting (copy)
                setEmitting(clone.Brakes, true)
                setEmitting(clone.Brakes2, true)
            end,
            SetProperty("Workspace.RaceOutroVFX.Brakes2.CFrame", CFrame.new(615.9109, 198.1829, 313.325) * v17 + Vector3.new(-4009, 0, 9397)),
            TweenProperty("Workspace.RaceOutroVFX.Brakes2.CFrame", TweenInfo.new(0.7833333333333333, Enum.EasingStyle.Linear), CFrame.new(616.0109, 195.8869, 267.0224) * v17 + Vector3.new(-4009, 0, 9397)),
            SetProperty("Workspace.RaceOutroVFX.Brakes.CFrame", CFrame.new(601.9868, 198.2261, 314.4173) * v17 + Vector3.new(-4009, 0, 9397)),
            TweenProperty("Workspace.RaceOutroVFX.Brakes.CFrame", TweenInfo.new(0.7833333333333333, Enum.EasingStyle.Linear), CFrame.new(602.0861, 195.9467, 268.4474) * v17 + Vector3.new(-4009, 0, 9397)),
            SetProperty("Lighting.CutsceneBlur.Enabled", true),
            SetProperty("Lighting.CutsceneBlur.Size", 10),
            TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.3, Enum.EasingStyle.Linear), 2),
            SetProperty("Workspace.RaceOutroVFX.blackDome.Transparency", 1),
            SetProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", 1),
            SetProperty("PlayerGui.CutsceneUI.Black.BackgroundColor3", Color3.new(0, 0, 0)),
            TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundColor3", TweenInfo.new(21.033333333333335, Enum.EasingStyle.Linear), v1),
            SetProperty("Lighting.Portal1.Enabled", false),
            SetProperty("Lighting.Portal1.Saturation", -0.3),
            TweenProperty("Lighting.Portal1.Saturation", TweenInfo.new(12.266666666666667, Enum.EasingStyle.Linear), 0),
            SetProperty("Lighting.Portal1.Contrast", 0.3),
            TweenProperty("Lighting.Portal1.Contrast", TweenInfo.new(12.266666666666667, Enum.EasingStyle.Linear), 0),
            SetProperty("Lighting.Portal1.TintColor", Color3.new(1, 0.956863, 0.792157)),
            TweenProperty("Lighting.Portal1.TintColor", TweenInfo.new(12.266666666666667, Enum.EasingStyle.Linear), Color3.new(1, 1, 1)),
            SetProperty("Lighting.Portal1.Brightness", 0),
            SetProperty("Lighting.Portal2.Enabled", false),
            SetProperty("Lighting.Portal2.Saturation", 1),
            TweenProperty("Lighting.Portal2.Saturation", TweenInfo.new(20.4, Enum.EasingStyle.Linear), 0),
            SetProperty("Lighting.Portal2.Contrast", 1),
            TweenProperty("Lighting.Portal2.Contrast", TweenInfo.new(20.4, Enum.EasingStyle.Linear), 0),
            SetProperty("Lighting.Portal2.TintColor", Color3.new(1, 0.737255, 0.368627)),
            TweenProperty("Lighting.Portal2.TintColor", TweenInfo.new(20.4, Enum.EasingStyle.Linear), Color3.new(1, 1, 1)),
            SetProperty("Lighting.Portal2.Brightness", 0),
            SetProperty("PlayerGui.CutsceneUI.Vignette.Visible", true),
            SetProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", 1),
            SetProperty("Workspace.RaceOutroVFX.Portal.CFrame", CFrame.new(1110.4214, -87.4107, 54.751) * v18 + Vector3.new(-4009, 0, 9397)),
            SetProperty("Lighting.CutsceneDepthOfField.Enabled", true),
            SetProperty("Lighting.CutsceneDepthOfField.FarIntensity", 0.55),
            SetProperty("Workspace.RaceOutroVFX.Crack.Cloud.CFrame", CFrame.new(960.9952, -106.5977, 93.9837) * v19 + Vector3.new(-4009, 0, 9397)),
            SetProperty("Workspace.RaceOutroMap.2.Transparency", 0),
            SetProperty("Workspace.RaceOutroMap.1.Transparency", 0),
            SetProperty("Workspace.RaceOutroMap.3.Transparency", 0),
            SetProperty("Workspace.RaceOutroMap.4.Transparency", 0),
            SetProperty("Workspace.RaceOutroVFX.CastleCloudTwmp.CFrame", CFrame.new(526.3013, 1293.6385, -382.0035) + Vector3.new(-4009, 0, 9397)),
            TweenProperty("Workspace.RaceOutroVFX.CastleCloudTwmp.CFrame", TweenInfo.new(26.366666666666667, Enum.EasingStyle.Linear), CFrame.new(517.3013, 1293.6385, -382.0035) + Vector3.new(-4009, 0, 9397)),
            SetProperty("Workspace.RaceOutroVFX.CastleCloudTwmp.Size", (Vector3.new(58, 299, 688))),
            TweenProperty("Workspace.RaceOutroVFX.CastleCloudTwmp.Size", TweenInfo.new(26.366666666666667, Enum.EasingStyle.Linear), (Vector3.new(249.2241, 299, 688)))
        },
        [47] = {
            TweenProperty("Workspace.RaceOutroVFX.Brakes2.CFrame", TweenInfo.new(0.85, Enum.EasingStyle.Linear), CFrame.new(616.1057, 193.7084, 223.0885) * v17 + Vector3.new(-4009, 0, 9397)),
            TweenProperty("Workspace.RaceOutroVFX.Brakes.CFrame", TweenInfo.new(0.85, Enum.EasingStyle.Linear), CFrame.new(602.1823, 193.7351, 223.848) * v17 + Vector3.new(-4009, 0, 9397))
        },
        [98] = {
            TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 45),
            TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 10)
        },
        [99] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.08333333333333333, Enum.EasingStyle.Linear), 2) },
        [130] = {
            function() -- line: 287
                -- upvalues: clone (ref), setEmitting (copy)
                setEmitting(clone.Brakes, false)
                setEmitting(clone.Brakes2, false)
            end
        },
        [150] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 55) },
        [216] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.6666666666666666, Enum.EasingStyle.Linear), 15) },
        [269] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.03333333333333333, Enum.EasingStyle.Linear), 2) },
        [270] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 45) },
        [355] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 15) },
        [358] = {
            function() -- line: 314
                -- upvalues: clone (ref), emitBurst (copy)
                emitBurst(clone.Fall)
            end
        },
        [361] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), 2) },
        [380] = backdrop(TweenInfo.new(0.38333333333333336, Enum.EasingStyle.Linear), 1),
        [407] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.16666666666666666, Enum.EasingStyle.Linear), 12) },
        [416] = {
            function() -- line: 330
                -- upvalues: clone (ref), emitBurst (copy)
                emitBurst(clone.Fall2)
            end
        },
        [417] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.6833333333333333, Enum.EasingStyle.Linear), 2) },
        [471] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.26666666666666666, Enum.EasingStyle.Sine), 35) },
        [487] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.85, Enum.EasingStyle.Sine), 45) },
        [529] = { TweenProperty("Workspace.RaceOutroVFX.Crack.Cloud.CFrame", TweenInfo.new(0.21666666666666667, Enum.EasingStyle.Linear), CFrame.new(807.8547, 314.1525, 93.9837) * v19 + Vector3.new(-4009, 0, 9397)) },
        [637] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.2, Enum.EasingStyle.Sine), 55) },
        [666] = { TweenProperty("Workspace.RaceOutroVFX.blackDome.Transparency", TweenInfo.new(1.0166666666666666, Enum.EasingStyle.Linear), 0) },
        [732] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Sine), 45) },
        [736] = {
            SetProperty("Lighting.Portal1.Enabled", true),
            TweenProperty("Lighting.Portal1.Saturation", TweenInfo.new(2.683333333333333, Enum.EasingStyle.Linear), -0.3),
            TweenProperty("Lighting.Portal1.Contrast", TweenInfo.new(2.683333333333333, Enum.EasingStyle.Linear), 0.3),
            TweenProperty("Lighting.Portal1.TintColor", TweenInfo.new(2.683333333333333, Enum.EasingStyle.Linear), Color3.new(1, 0.956863, 0.792157))
        },
        [756] = {
            function() -- line: 371
                -- upvalues: clone (ref), emitBurst (copy)
                emitBurst(clone.Crack.Cloud.Crack)
            end
        },
        [1157] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(1.1, Enum.EasingStyle.Linear), 0) },
        [1209] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.08333333333333333, Enum.EasingStyle.Linear), 3.54762) },
        [1214] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.6166666666666667, Enum.EasingStyle.Linear), 15) },
        [1224] = {
            SetProperty("Lighting.Portal2.Enabled", true),
            TweenProperty("Lighting.Portal2.Saturation", TweenInfo.new(1, Enum.EasingStyle.Linear), 1),
            TweenProperty("Lighting.Portal2.Contrast", TweenInfo.new(1, Enum.EasingStyle.Linear), 1),
            TweenProperty("Lighting.Portal2.TintColor", TweenInfo.new(1, Enum.EasingStyle.Linear), Color3.new(1, 0.737255, 0.368627)),
            TweenProperty("Lighting.Portal2.Brightness", TweenInfo.new(1, Enum.EasingStyle.Linear), 0.5)
        },
        [1262] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.48333333333333334, Enum.EasingStyle.Linear), 0) },
        [1291] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundColor3", TweenInfo.new(0.38333333333333336, Enum.EasingStyle.Linear), Color3.new(1, 1, 1)) },
        [1305] = { TweenProperty("Workspace.RaceOutroVFX.Portal.CFrame", TweenInfo.new(0.11666666666666667, Enum.EasingStyle.Linear), CFrame.new(993.9536, 309.0101, 98.9344) * v18 + Vector3.new(-4009, 0, 9397)) },
        [1312] = { TweenProperty("Workspace.RaceOutroVFX.Crack.Cloud.CFrame", TweenInfo.new(0.13333333333333333, Enum.EasingStyle.Linear), CFrame.new(960.9952, -106.5977, 93.9837) * v19 + Vector3.new(-4009, 0, 9397)) },
        [1326] = { TweenProperty("Workspace.RaceOutroVFX.Portal.CFrame", TweenInfo.new(3.4166666666666665, Enum.EasingStyle.Linear), CFrame.new(743.2354, 233.9696, 111.3165) * v18 + Vector3.new(-4009, 0, 9397)) },
        [1328] = { SetProperty("Lighting.Portal2.Enabled", false) },
        [1332] = {
            TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(1.4166666666666667, Enum.EasingStyle.Linear), 7),
            TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.65, Enum.EasingStyle.Linear), 1),
            TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundColor3", TweenInfo.new(0.65, Enum.EasingStyle.Linear), Color3.new(0, 0, 0))
        },
        [1371] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundColor3", TweenInfo.new(2, Enum.EasingStyle.Linear), v1) },
        [1417] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(1.7166666666666666, Enum.EasingStyle.Linear), 15) },
        [1454] = backdrop(TweenInfo.new(0.35, Enum.EasingStyle.Linear), 0),
        [1491] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.48333333333333334, Enum.EasingStyle.Linear), 0) },
        [1520] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundColor3", TweenInfo.new(0.38333333333333336, Enum.EasingStyle.Linear), Color3.new(1, 1, 1)) },
        [1561] = {
            TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.65, Enum.EasingStyle.Linear), 1),
            TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundColor3", TweenInfo.new(0.65, Enum.EasingStyle.Linear), Color3.new(0, 0, 0))
        },
        [1562] = {
            TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 2),
            TweenProperty("Lighting.CutsceneDepthOfField.FarIntensity", TweenInfo.new(0.8166666666666667, Enum.EasingStyle.Linear), 0)
        },
        [1563] = {},
        [1582] = {
            TweenProperty("Workspace.RaceOutroVFX.CastleCloudTwmp.CFrame", TweenInfo.new(0.7, Enum.EasingStyle.Linear), CFrame.new(581.3223, 1293.6385, -382.0035) + Vector3.new(-4009, 0, 9397)),
            TweenProperty("Workspace.RaceOutroVFX.CastleCloudTwmp.Size", TweenInfo.new(0.7, Enum.EasingStyle.Linear), (Vector3.new(99.2241, 299, 688)))
        },
        [1957] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(1.3666666666666667, Enum.EasingStyle.Linear), 0) }
    }

    return {
        Run = function() -- Run | line: 469
            -- upvalues: p6 (copy), v15 (copy), LoadAnimationIntoRig (copy), CutsceneUI (copy), Black (copy), Vignette (copy), clone (ref), t9 (copy), ContentProvider (copy), Lighting (copy), RunService (copy), SoundService (copy), TweenService (copy), Workspace (copy), BulkFade (copy), MountRace (copy), MusicDirector (copy), OutroCutscene (copy), UnixTimestamp (copy), CurrentCamera (copy), LocalPlayer (copy), restoreCamera (copy), hideCutsceneUi (copy), restoreCutsceneUi (copy)
            LocalPlayer:SetAttribute(MountRace.CutsceneAttribute, true)
            v15:Add(function() -- line: 472
                -- upvalues: MountRace (copy), LocalPlayer (copy)
                LocalPlayer:SetAttribute(MountRace.CutsceneAttribute, nil)
            end)

            local _warn = warn

            xpcall(hideCutsceneUi, _warn)
            v15:Add(restoreCutsceneUi)
            MusicDirector.SetEventMusic(true)
            v15:Add(function() -- line: 480
                -- upvalues: MusicDirector (copy)
                MusicDirector.SetEventMusic(false)
            end)

            for _, child in OutroCutscene.LightingAssets:GetChildren() do
                if not Lighting:FindFirstChild(child.Name) then
                    local clone = child:Clone()

                    clone.Parent = Lighting
                    v15:Add(clone)
                end
            end

            CutsceneUI.Enabled = true
            Black.BackgroundTransparency = 1
            Black.Visible = true
            Vignette.Visible = false
            v15:Add(function() -- line: 497
                -- upvalues: Vignette (copy)
                Vignette.Visible = false
                Vignette.ImageTransparency = 1
            end)
            p6:Add(function() -- line: 502
                -- upvalues: Black (copy)
                Black.BackgroundTransparency = 1
                Black.BackgroundColor3 = Color3.new(0, 0, 0)
                Black.Visible = false
            end)

            local clone2 = OutroCutscene.RaceOutroVFX:Clone()

            clone2.Parent = Workspace
            clone = clone2
            v15:Add(clone2)

            local clone3 = OutroCutscene.RaceOutroMap:Clone()

            clone3.Parent = Workspace
            v15:Add(clone3)

            local clone4 = OutroCutscene.CutsceneMusic:Clone()

            clone4.Parent = SoundService
            v15:Add(clone4)
            TweenService:Create(Black, TweenInfo.new(0.1), {
                BackgroundTransparency = 0
            }):Play()

            local clone5 = OutroCutscene.RaceOutroRigs:Clone()

            v15:Add(clone5)

            for _, child in clone5:GetChildren() do
                if child:IsA("Model") and child.PrimaryPart then
                    child.PrimaryPart.Anchored = true
                end
            end

            clone5.Parent = Workspace

            local t11 = {}

            for _, child in clone5:GetChildren() do
                table.insert(t11, (child:FindFirstChild("Animation")))
            end

            ContentProvider:PreloadAsync(t11)

            local t12 = {}

            for _, child in clone5:GetChildren() do
                t12[child] = LoadAnimationIntoRig(child, child:FindFirstChild("Animation").AnimationId)
            end

            local v23 = true

            v15:Add(function() -- line: 545
                -- upvalues: v23 (ref), restoreCamera (copy)
                v23 = false
                restoreCamera()
            end)

            for _, v24 in t12 do
                v24:Play(0)
            end

            local v25 = t12[clone5.CameraRig]
            local v26 = os.clock() + 2

            while v23 and v25.TimePosition <= 0 and os.clock() < v26 do
                RunService.RenderStepped:Wait()
            end

            clone4:Play()

            local CamFocus = clone5.CameraRig.CamFocus

            v15:Connect(RunService.RenderStepped, function() -- line: 568
                -- upvalues: v23 (ref), CamFocus (copy), CurrentCamera (copy), LocalPlayer (copy)
                if not v23 then
                    return
                end

                CurrentCamera.CameraType = Enum.CameraType.Scriptable
                LocalPlayer.ReplicationFocus = CamFocus
                CurrentCamera.Focus = CamFocus.CFrame
                CurrentCamera.CFrame = CamFocus.CFrame
            end)

            local t13 = {}
            local n1 = 0
            local n2 = 0.1
            local connection = v15:Connect(RunService.Heartbeat, function(p21) -- line: 581
                -- upvalues: clone4 (copy), t12 (copy), t13 (copy), n1 (ref), n2 (ref), t9 (copy)
                n1 += p21
                n2 -= p21

                for _, v27 in t12 do
                    local v28 = v27.Length - 0.05

                    if v27.Length > 0 and v28 <= n1 and v27.Speed ~= 0 then
                        v27.TimePosition = v28
                        v27:AdjustSpeed(0)
                    end
                end

                if n2 <= 0 then
                    n2 = 0.1

                    for _, v29 in t12 do
                        if v29.IsPlaying and v29.Speed ~= 0 then
                            local v31 = n1

                            if math.abs(v31 - v29.TimePosition) >= 0.4 then
                                local function v32() -- line: 600
                                    -- upvalues: v29 (copy), n1 (ref)
                                    v29.TimePosition = n1
                                end

                                local _warn = warn

                                xpcall(v32, _warn)
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
                    local v34 = math.floor(n1 * 60 - i)

                    if t9[v34] and not t13[v34] then
                        t13[v34] = true

                        for _, v35 in t9[v34] do
                            task.spawn(v35)
                        end
                    end
                end
            end)

            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(34.5)
            connection:Disconnect()
            Black.BackgroundTransparency = 0
            Black.BackgroundColor3 = Color3.new(0, 0, 0)

            local HalloweenTeaser = CutsceneUI:FindFirstChild("HalloweenTeaser")
            local v36 = if not (HalloweenTeaser and HalloweenTeaser:IsA("GuiObject")) then nil else BulkFade.new(HalloweenTeaser, TweenInfo.new(1))

            if HalloweenTeaser and HalloweenTeaser:IsA("GuiObject") and v36 then
                p6:Add(function() -- line: 635
                    -- upvalues: HalloweenTeaser (copy)
                    HalloweenTeaser.Visible = false
                end)
                v36:FadeOutInstant()
                HalloweenTeaser.Visible = true
                v36:FadeIn()

                local Sound = Instance.new("Sound")

                Sound.SoundId = "rbxassetid://119317416196943"
                Sound.Volume = 0.2
                Sound.Parent = SoundService

                local TimeRemaining = HalloweenTeaser:FindFirstChild("TimeRemaining")
                local v37 = os.clock() + 5

                while os.clock() < v37 do
                    if TimeRemaining and TimeRemaining:IsA("TextLabel") then
                        local v40 = math.max(0, (math.floor(UnixTimestamp - Workspace:GetServerTimeNow())))

                        TimeRemaining.Text = string.format("%02i:%02i:%02i:%02i", v40 // 86400, v40 // 3600 % 24, v40 // 60 % 60, v40 % 60)
                    end

                    Sound:Play()
                    task.wait(1)
                end

                Sound:Destroy()
                v36:FadeOut()
                task.delay(1, function() -- line: 656
                    -- upvalues: HalloweenTeaser (copy), v36 (copy)
                    HalloweenTeaser.Visible = false
                    v36:FadeIn()
                end)
            end

            v15:Clean()
            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(0.5)
            Black.Visible = false
        end
    }
end
