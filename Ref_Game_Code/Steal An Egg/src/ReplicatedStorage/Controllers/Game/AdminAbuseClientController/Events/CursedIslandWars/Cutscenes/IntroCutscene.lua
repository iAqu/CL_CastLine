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
local CursedIslandWars = require(ReplicatedStorage.Data.CursedIslandWars)
local CutsceneHelperFunctions = require(script.Parent.Parent.Parent.Parent.CutsceneHelperFunctions)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local LightingController = require(ReplicatedStorage.Controllers.Game.LightingController)
local MusicDirector = require(ReplicatedStorage.Client.MusicDirector)
local State = require(script.Parent.Parent.State)
local Tabs = require(ReplicatedStorage.Client.Tabs)

require(ReplicatedStorage.Packages.Trove)

local IntroCutscene = ReplicatedStorage.CutsceneAssets.CursedIslandWarsCutsceneAssets.IntroCutscene
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

local function onTrack(p1) -- line: 61
    return p1 + Vector3.new(-4008.8997, 0.021377563, 9396.922)
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
    -- upvalues: ContentProvider (copy), Lighting (copy), RunService (copy), SoundService (copy), TweenService (copy), Workspace (copy), CursedIslandWars (copy), CutsceneHelperFunctions (copy), LightingController (copy), MusicDirector (copy), State (copy), IntroCutscene (copy), CurrentCamera (copy), LocalPlayer (copy), restoreCamera (copy), hideCutsceneUi (copy), restoreCutsceneUi (copy), setEmitting (copy), emitBurst (copy)
    local v12 = p5:Extend()
    local v13 = CutsceneHelperFunctions.GetHelperFunctions(v12)
    local SetProperty, TweenProperty, LoadAnimationIntoRig = v13.SetProperty, v13.TweenProperty, v13.LoadAnimationIntoRig
    local CutsceneUI = LocalPlayer.PlayerGui.CutsceneUI
    local Black, Vignette, Letterbox = CutsceneUI.Black, CutsceneUI.Vignette, CutsceneUI.Letterbox
    local clone
    local v14 = CFrame.new(0, 0, 0, 0.0022, -8E-04, 1, -0.0495, 0.9988, 9E-04, -0.9988, -0.0495, 0.0021)

    local function drag(p6, p7, p8) -- line: 192
        -- upvalues: v14 (copy)
        return CFrame.new(p6, p7, p8) * v14 + Vector3.new(-4008.8997, 0.021377563, 9396.922)
    end

    local v15 = CFrame.new(0, 0, 0, 0.0468, -0.9805, 0.191, 0.0082, -0.1909, -0.9816, 0.9989, 0.0475, -9E-04)

    local function portalRift(p9, p10, p11) -- line: 196
        -- upvalues: v15 (copy)
        return CFrame.new(p9, p10, p11) * v15 + Vector3.new(-4008.8997, 0.021377563, 9396.922)
    end

    local function tweenLetterbox(p12, p13) -- line: 200
        -- upvalues: Letterbox (copy), TweenService (copy)
        return function() -- line: 201
            -- upvalues: p12 (copy), p13 (copy), Letterbox (copy), TweenService (copy)
            for _, child in Letterbox:GetChildren() do
                if child:IsA("Frame") then
                    TweenService:Create(child, p12, {
                        BackgroundTransparency = p13
                    }):Play()
                end
            end
        end
    end

    local function linear(p14, p15) -- line: 209
        return TweenInfo.new((p15 - p14) / 60, Enum.EasingStyle.Linear)
    end

    local t8 = {}
    local v16 = SetProperty("Workspace.CurrentCamera.FieldOfView", 50)

    local function v17() -- line: 216
        -- upvalues: clone (ref), setEmitting (copy)
        setEmitting(clone.Drag, false)
        setEmitting(clone.RiftSuck, false)
    end

    local v18 = SetProperty("PlayerGui.CutsceneUI.Vignette.Visible", true)
    local v19 = SetProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", 0.5)
    local v20 = SetProperty("Workspace.CursedIntroVFX.Drag.CFrame", CFrame.new(610.7825, 186.3109, 64.6345) * v14 + Vector3.new(-4008.8997, 0.021377563, 9396.922))
    local v21 = SetProperty("Workspace.CursedIntroVFX.PortalRift.CFrame", CFrame.new(783.3271, -359.9731, 61.5337) * v15 + Vector3.new(-4008.8997, 0.021377563, 9396.922))
    local v22 = TweenInfo.new(0)
    local n1 = 1

    t8[0] = {
        v16,
        v17,
        v18,
        v19,
        v20,
        v21,
        function() -- line: 201
            -- upvalues: Letterbox (copy), v22 (copy), n1 (copy), TweenService (copy)
            for _, child in Letterbox:GetChildren() do
                if child:IsA("Frame") then
                    TweenService:Create(child, v22, {
                        BackgroundTransparency = n1
                    }):Play()
                end
            end
        end,
        SetProperty("Lighting.CutsceneBlur.Enabled", true),
        SetProperty("Lighting.CutsceneBlur.Size", 20),
        TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(1.0833333333333333, Enum.EasingStyle.Linear), 2),
        SetProperty("Lighting.Cut.Enabled", false),
        SetProperty("Lighting.Cut.InFocusRadius", 0),
        SetProperty("Lighting.Cut.FarIntensity", 1),
        SetProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", 1),
        SetProperty("Lighting.Portal.Enabled", false),
        SetProperty("Lighting.Portal.Saturation", 1),
        SetProperty("Lighting.Portal.Contrast", 1),
        SetProperty("Lighting.Portal.TintColor", Color3.new(1, 0.701961, 0.341176)),
        TweenProperty("Lighting.Portal.TintColor", TweenInfo.new(41.016666666666666, Enum.EasingStyle.Linear), Color3.new(1, 1, 1)),
        SetProperty("Lighting.Portal.Brightness", 0.5),
        TweenProperty("Lighting.Portal.Brightness", TweenInfo.new(41.016666666666666, Enum.EasingStyle.Linear), 0)
    }
    t8[121] = { SetProperty("Lighting.Cut.Enabled", true) }
    t8[178] = { TweenProperty("Lighting.Cut.InFocusRadius", TweenInfo.new(0.48333333333333334, Enum.EasingStyle.Linear), 15) }
    t8[785] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.26666666666666666, Enum.EasingStyle.Linear), 15) }
    t8[796] = {
        function() -- line: 254
            -- upvalues: clone (ref), emitBurst (copy)
            emitBurst(clone.Rock)
        end
    }
    t8[801] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.65, Enum.EasingStyle.Linear), 2) }
    t8[849] = {
        function() -- line: 264
            -- upvalues: clone (ref), emitBurst (copy)
            emitBurst(clone.Fall)
        end
    }
    t8[1219] = { SetProperty("Lighting.Cut.Enabled", false) }
    t8[1288] = {
        function() -- line: 274
            -- upvalues: clone (ref), emitBurst (copy)
            emitBurst(clone.Explosion)
        end
    }
    t8[1318] = { SetProperty("Lighting.Cut.Enabled", true) }
    t8[1389] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.26666666666666666, Enum.EasingStyle.Linear), 15) }
    t8[1401] = {
        function() -- line: 288
            -- upvalues: clone (ref), emitBurst (copy)
            emitBurst(clone.Trophy)
        end
    }
    t8[1405] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.65, Enum.EasingStyle.Linear), 2) }
    t8[1498] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.06666666666666667, Enum.EasingStyle.Linear), 10) }
    t8[1500] = {
        function() -- line: 302
            -- upvalues: clone (ref), emitBurst (copy)
            emitBurst(clone.Trophy2)
        end
    }
    t8[1543] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.7166666666666667, Enum.EasingStyle.Linear), 2) }
    t8[1588] = {
        function() -- line: 312
            -- upvalues: clone (ref), setEmitting (copy)
            setEmitting(clone.Drag, true)
        end,
        TweenProperty("Workspace.CursedIntroVFX.Drag.CFrame", TweenInfo.new(0.13333333333333333, Enum.EasingStyle.Linear), CFrame.new(609.4865, 186.356, 65.5653) * v14 + Vector3.new(-4008.8997, 0.021377563, 9396.922))
    }
    t8[1596] = { TweenProperty("Workspace.CursedIntroVFX.Drag.CFrame", TweenInfo.new(0.13333333333333333, Enum.EasingStyle.Linear), CFrame.new(608.1913, 186.3826, 66.1231) * v14 + Vector3.new(-4008.8997, 0.021377563, 9396.922)) }
    t8[1604] = { TweenProperty("Workspace.CursedIntroVFX.Drag.CFrame", TweenInfo.new(0.21666666666666667, Enum.EasingStyle.Linear), CFrame.new(605.6266, 186.3639, 65.7866) * v14 + Vector3.new(-4008.8997, 0.021377563, 9396.922)) }
    t8[1617] = { TweenProperty("Workspace.CursedIntroVFX.Drag.CFrame", TweenInfo.new(0.16666666666666666, Enum.EasingStyle.Linear), CFrame.new(604.2318, 186.3022, 64.5627) * v14 + Vector3.new(-4008.8997, 0.021377563, 9396.922)) }
    t8[1627] = { TweenProperty("Workspace.CursedIntroVFX.Drag.CFrame", TweenInfo.new(0.23333333333333334, Enum.EasingStyle.Linear), CFrame.new(603.7445, 186.1794, 62.0949) * v14 + Vector3.new(-4008.8997, 0.021377563, 9396.922)) }
    t8[1641] = { TweenProperty("Workspace.CursedIntroVFX.Drag.CFrame", TweenInfo.new(0.23333333333333334, Enum.EasingStyle.Linear), CFrame.new(604.8831, 186.0538, 59.5438) * v14 + Vector3.new(-4008.8997, 0.021377563, 9396.922)) }
    t8[1655] = { TweenProperty("Workspace.CursedIntroVFX.Drag.CFrame", TweenInfo.new(0.26666666666666666, Enum.EasingStyle.Linear), CFrame.new(607.7219, 186.0271, 58.9605) * v14 + Vector3.new(-4008.8997, 0.021377563, 9396.922)) }
    t8[1671] = { TweenProperty("Workspace.CursedIntroVFX.Drag.CFrame", TweenInfo.new(0.21666666666666667, Enum.EasingStyle.Linear), CFrame.new(609.9418, 186.0977, 60.3489) * v14 + Vector3.new(-4008.8997, 0.021377563, 9396.922)) }
    t8[1684] = { TweenProperty("Workspace.CursedIntroVFX.Drag.CFrame", TweenInfo.new(0.26666666666666666, Enum.EasingStyle.Linear), CFrame.new(611.1519, 186.2253, 62.9039) * v14 + Vector3.new(-4008.8997, 0.021377563, 9396.922)) }
    t8[1700] = { TweenProperty("Workspace.CursedIntroVFX.Drag.CFrame", TweenInfo.new(0.26666666666666666, Enum.EasingStyle.Linear), CFrame.new(608.8846, 186.3498, 65.4508) * v14 + Vector3.new(-4008.8997, 0.021377563, 9396.922)) }
    t8[1716] = { TweenProperty("Workspace.CursedIntroVFX.Drag.CFrame", TweenInfo.new(0.26666666666666666, Enum.EasingStyle.Linear), CFrame.new(606.3488, 186.3731, 65.9603) * v14 + Vector3.new(-4008.8997, 0.021377563, 9396.922)) }
    t8[1732] = { TweenProperty("Workspace.CursedIntroVFX.Drag.CFrame", TweenInfo.new(0.3, Enum.EasingStyle.Linear), CFrame.new(603.7178, 186.2299, 63.1155) * v14 + Vector3.new(-4008.8997, 0.021377563, 9396.922)) }
    t8[1840] = {
        function() -- line: 363
            -- upvalues: clone (ref), setEmitting (copy)
            setEmitting(clone.Drag, false)
        end
    }
    t8[1857] = {
        function() -- line: 369
            -- upvalues: clone (ref), emitBurst (copy)
            emitBurst(clone.Crack.Cloud.Crack.EYES)
        end
    }
    t8[1860] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 10) }
    t8[1861] = {
        TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.8833333333333333, Enum.EasingStyle.Linear), 4),
        SetProperty("Lighting.Cut.Enabled", false)
    }
    t8[1863] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(1.0833333333333333, Enum.EasingStyle.Linear), 0) }
    t8[1887] = {
        function() -- line: 388
            -- upvalues: clone (ref), emitBurst (copy)
            emitBurst(clone.Crack.Cloud.Crack.EYES2)
        end
    }
    t8[1946] = {
        function() -- line: 394
            -- upvalues: clone (ref), setEmitting (copy)
            setEmitting(clone.RiftSuck, true)
        end
    }

    local v23 = TweenInfo.new(0.13333333333333333, Enum.EasingStyle.Linear)
    local n2 = 0

    t8[1993] = {
        function() -- line: 201
            -- upvalues: Letterbox (copy), v23 (copy), n2 (copy), TweenService (copy)
            for _, child in Letterbox:GetChildren() do
                if child:IsA("Frame") then
                    TweenService:Create(child, v23, {
                        BackgroundTransparency = n2
                    }):Play()
                end
            end
        end
    }
    t8[2279] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(1.8, Enum.EasingStyle.Linear), 15) }
    t8[2387] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.25, Enum.EasingStyle.Linear), 5) }
    t8[2407] = {
        function() -- line: 412
            -- upvalues: clone (ref), setEmitting (copy)
            setEmitting(clone.RiftSuck, false)
        end,
        TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.11666666666666667, Enum.EasingStyle.Linear), 20),
        TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.11666666666666667, Enum.EasingStyle.Linear), 0)
    }
    t8[2414] = {
        TweenProperty("Workspace.CursedIntroVFX.PortalRift.CFrame", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), CFrame.new(669.1818, 226.5289, 62.072) * v15 + Vector3.new(-4008.8997, 0.021377563, 9396.922)),
        TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.65, Enum.EasingStyle.Linear), 9)
    }
    t8[2415] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(1.3833333333333333, Enum.EasingStyle.Linear), 20) }
    t8[2417] = {
        TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.25, Enum.EasingStyle.Linear), 1),
        SetProperty("Lighting.Portal.Enabled", true),
        TweenProperty("Lighting.Portal.Saturation", TweenInfo.new(0.25, Enum.EasingStyle.Linear), 0.2),
        TweenProperty("Lighting.Portal.Contrast", TweenInfo.new(0.25, Enum.EasingStyle.Linear), 0)
    }
    t8[2432] = { TweenProperty("Lighting.Portal.Saturation", TweenInfo.new(0.48333333333333334, Enum.EasingStyle.Linear), 0) }
    t8[2461] = {
        TweenProperty("Lighting.Portal.Saturation", TweenInfo.new(0.3333333333333333, Enum.EasingStyle.Linear), 1),
        TweenProperty("Lighting.Portal.Contrast", TweenInfo.new(0.3333333333333333, Enum.EasingStyle.Linear), 1),
        TweenProperty("Lighting.Portal.TintColor", TweenInfo.new(0.3333333333333333, Enum.EasingStyle.Linear), Color3.new(1, 0.701961, 0.341176)),
        TweenProperty("Lighting.Portal.Brightness", TweenInfo.new(0.3333333333333333, Enum.EasingStyle.Linear), 0.5)
    }
    t8[2481] = { TweenProperty("Lighting.Portal.Brightness", TweenInfo.new(0.16666666666666666, Enum.EasingStyle.Linear), 5) }
    t8[2484] = {
        TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.26666666666666666, Enum.EasingStyle.Linear), 20),
        TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.26666666666666666, Enum.EasingStyle.Linear), 0)
    }

    return {
        Run = function() -- Run | line: 457
            -- upvalues: p5 (copy), v12 (copy), LoadAnimationIntoRig (copy), CutsceneUI (copy), Black (copy), Vignette (copy), Letterbox (copy), clone (ref), t8 (copy), ContentProvider (copy), Lighting (copy), RunService (copy), SoundService (copy), TweenService (copy), Workspace (copy), CursedIslandWars (copy), LightingController (copy), MusicDirector (copy), State (copy), IntroCutscene (copy), CurrentCamera (copy), LocalPlayer (copy), restoreCamera (copy), hideCutsceneUi (copy), restoreCutsceneUi (copy)
            local elapsed = os.clock()
            local v24 = false

            p5:Add(function() -- line: 460
                -- upvalues: v24 (ref)
                v24 = true
            end)

            local _warn = warn

            xpcall(hideCutsceneUi, _warn)
            v12:Add(restoreCutsceneUi)
            MusicDirector.SetEventMusic(true)
            v12:Add(function() -- line: 468
                -- upvalues: MusicDirector (copy)
                MusicDirector.SetEventMusic(false)
            end)
            LightingController.SetAuthoredLayer("CursedIslandWarsCutscene", IntroCutscene.SceneLighting, 999, 0)
            v12:Add(function() -- line: 473
                -- upvalues: LightingController (copy)
                LightingController.ClearLayer("CursedIslandWarsCutscene", 0)
            end)

            for _, child in IntroCutscene.LightingAssets:GetChildren() do
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
            Letterbox.Visible = true
            v12:Add(function() -- line: 490
                -- upvalues: Vignette (copy), Letterbox (copy)
                Vignette.Visible = false
                Vignette.ImageTransparency = 1
                Letterbox.Visible = false
            end)
            p5:Add(function() -- line: 496
                -- upvalues: Black (copy)
                Black.BackgroundTransparency = 1
                Black.BackgroundColor3 = Color3.new(0, 0, 0)
                Black.Visible = false
            end)

            local clone2 = IntroCutscene.CursedIntroVFX:Clone()

            clone2.Parent = Workspace
            clone = clone2
            v12:Add(clone2)

            local clone3 = IntroCutscene.CutsceneMusic:Clone()

            clone3.Parent = SoundService
            v12:Add(clone3)
            TweenService:Create(Black, TweenInfo.new(0.1), {
                BackgroundTransparency = 0
            }):Play()

            local clone4 = IntroCutscene.CursedIntroRigs:Clone()

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

            local v25 = true

            v12:Add(function() -- line: 535
                -- upvalues: v25 (ref), restoreCamera (copy)
                v25 = false
                restoreCamera()
            end)

            for _, v26 in t11 do
                v26:Play(0)
            end

            local v27 = t11[clone4.CameraRig]
            local v28 = os.clock() + 2

            while v25 and v27.TimePosition <= 0 and os.clock() < v28 do
                RunService.RenderStepped:Wait()
            end

            clone3:Play()

            local Head = clone4.CameraRig.Head

            v12:Connect(RunService.RenderStepped, function() -- line: 557
                -- upvalues: v25 (ref), Head (copy), CurrentCamera (copy), LocalPlayer (copy)
                if not v25 then
                    return
                end

                CurrentCamera.CameraType = Enum.CameraType.Scriptable
                LocalPlayer.ReplicationFocus = Head
                CurrentCamera.Focus = Head.CFrame
                CurrentCamera.CFrame = Head.CFrame
            end)

            local t12 = {}
            local n3 = 0
            local n4 = 0.1
            local connection = v12:Connect(RunService.Heartbeat, function(p16) -- line: 570
                -- upvalues: clone3 (copy), t11 (copy), t12 (copy), n3 (ref), n4 (ref), t8 (copy)
                n3 += p16
                n4 -= p16

                for _, v29 in t11 do
                    local v30 = v29.Length - 0.05

                    if v29.Length > 0 and v30 <= n3 and v29.Speed ~= 0 then
                        v29.TimePosition = v30
                        v29:AdjustSpeed(0)
                    end
                end

                if n4 <= 0 then
                    n4 = 0.1

                    for _, v31 in t11 do
                        if v31.IsPlaying and v31.Speed ~= 0 then
                            local v33 = n3

                            if math.abs(v33 - v31.TimePosition) >= 0.4 then
                                local function v34() -- line: 589
                                    -- upvalues: v31 (copy), n3 (ref)
                                    v31.TimePosition = n3
                                end

                                local _warn = warn

                                xpcall(v34, _warn)
                            end
                        end
                    end
                end

                if clone3.TimePosition < n3 - 0.001 then
                    clone3.PlaybackSpeed = 1.01
                elseif clone3.TimePosition > n3 + 0.001 then
                    clone3.PlaybackSpeed = 0.99
                else
                    clone3.PlaybackSpeed = 1
                end

                for i = 0, 9 do
                    local v36 = math.floor(n3 * 60 - i)

                    if t8[v36] and not t12[v36] then
                        t12[v36] = true

                        for _, v37 in t8[v36] do
                            task.spawn(v37)
                        end
                    end
                end
            end)

            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(42.166666666666664)
            connection:Disconnect()
            Black.BackgroundTransparency = 0
            v12:Clean()

            local v38 = elapsed + CursedIslandWars.Timing.Intro + 10

            while not v24 and State.Phase() ~= "Reveal" and os.clock() < v38 do
                task.wait(0.1)
            end

            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(0.5)
            Black.Visible = false
        end
    }
end
