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
local BeanstalkEvent = require(ReplicatedStorage.Data.BeanstalkEvent)
local CutsceneHelperFunctions = require(script.Parent.Parent.Parent.Parent.CutsceneHelperFunctions)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local LightingController = require(ReplicatedStorage.Controllers.Game.LightingController)
local Tabs = require(ReplicatedStorage.Client.Tabs)

require(ReplicatedStorage.Packages.Trove)

local BulkFade = require(ReplicatedStorage.Client.Modules.BulkFade)
local EndingCutscene = ReplicatedStorage.CutsceneAssets.BeanstalkEventCutsceneAssets.EndingCutscene
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
local EndingCutsceneSeconds, EndingHandBackSeconds = BeanstalkEvent.EndingCutsceneSeconds, BeanstalkEvent.EndingHandBackSeconds
local CurrentCamera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local v1, t3, v2, t4
local t5 = {}

local function restoreCamera() -- line: 59
    -- upvalues: TweenService (copy), CurrentCamera (copy), LocalPlayer (copy)
    TweenService:Create(CurrentCamera, TweenInfo.new(0), {
        FieldOfView = 70
    }):Play()
    CurrentCamera.FieldOfView = 70
    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") or nil
    LocalPlayer.ReplicationFocus = nil
end

local function hideAllUi() -- line: 68
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

    local function v3() -- line: 83
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

local function restoreAllUi() -- line: 93
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

    local function v7() -- line: 106
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

local function hideCutsceneUi() -- line: 118
    -- upvalues: HiddenUIHandler (copy), v1 (ref), hideAllUi (copy)
    if v1 == nil then
        v1 = HiddenUIHandler.Acquire()
    end

    hideAllUi()
end

local function restoreCutsceneUi() -- line: 125
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

local function setTransparency(p1, p2) -- line: 137
    for _, v12 in p1 do
        if v12:IsA("BasePart") then
            if not v12:GetAttribute("OriginalTransparency") then
                v12:SetAttribute("OriginalTransparency", v12.Transparency)
            end

            v12.Transparency = p2 or v12:GetAttribute("OriginalTransparency")
        end
    end
end

local function restoreGuard(p3, p4) -- line: 150
    -- upvalues: t5 (copy)
    t5[p3] = nil

    local Guard = p4:FindFirstChild("Guard")

    if Guard == nil or Guard == p3 then
        p3.Parent = p4
    end
end

local function hideAllGuardsAndNests(p5) -- line: 159
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

        p5:Add(function() -- line: 173
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

local function hideLiveForest(p6) -- line: 184
    -- upvalues: Workspace (copy)
    local World = Workspace:FindFirstChild("World")
    local Build = if World == nil then nil else World:FindFirstChild("Build")

    if Build == nil then
        return
    end

    local t10 = {}
    local v14 = true

    p6:Add(function() -- line: 192
        -- upvalues: Build (copy), t10 (copy), v14 (ref)
        v14 = false

        for v15, v16 in t10 do
            if v16.Parent == Build and v16:FindFirstChild(v15.Name) == nil then
                v15.Parent = v16
            end
        end
    end)

    local function hideProps(p7) -- line: 200
        -- upvalues: Build (copy), t10 (copy), v14 (ref)
        local Parent = p7.Parent

        if not v14
            or t10[p7]
            or p7.Name ~= "Zone13Props"
            or Parent == nil
            or Parent.Name ~= "EnchantedForestZone"
            or Parent.Parent ~= Build then
            return
        end

        t10[p7] = Parent
        p7.Parent = nil
    end

    p6:Connect(Build.DescendantAdded, hideProps)

    local EnchantedForestZone = Build:FindFirstChild("EnchantedForestZone")
    local Zone13Props = if EnchantedForestZone == nil then nil else EnchantedForestZone:FindFirstChild("Zone13Props")

    if Zone13Props ~= nil then
        local Parent = Zone13Props.Parent

        if v14 and not t10[Zone13Props] and Zone13Props.Name == "Zone13Props" and Parent ~= nil and Parent.Name == "EnchantedForestZone" and Parent.Parent == Build then
            t10[Zone13Props] = Parent
            Zone13Props.Parent = nil
        end
    end
end

local function emitBurst(p8) -- line: 221
    for _, descendant in p8:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local EmitCount = descendant:GetAttribute("EmitCount")
            local EmitDuration = descendant:GetAttribute("EmitDuration")

            if type(EmitCount) == "number" and EmitCount ~= 0 then
                descendant:Emit(EmitCount)
            end

            if type(EmitDuration) == "number" and EmitDuration ~= 0 then
                descendant.Enabled = true
                task.delay(EmitDuration, function() -- line: 234
                    -- upvalues: descendant (copy)
                    descendant.Enabled = false
                end)
            end
        end
    end
end

return function(p9) -- line: 243
    -- upvalues: ContentProvider (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), SoundService (copy), TweenService (copy), Workspace (copy), CutsceneHelperFunctions (copy), LightingController (copy), BulkFade (copy), EndingCutscene (copy), t2 (copy), EndingCutsceneSeconds (copy), EndingHandBackSeconds (copy), CurrentCamera (copy), LocalPlayer (copy), restoreCamera (copy), hideCutsceneUi (copy), restoreCutsceneUi (copy), hideAllGuardsAndNests (copy), hideLiveForest (copy), emitBurst (copy)
    local v17 = p9:Extend()
    local v18 = CutsceneHelperFunctions.GetHelperFunctions(v17)
    local SetProperty, TweenProperty, LoadAnimationIntoRig = v18.SetProperty, v18.TweenProperty, v18.LoadAnimationIntoRig
    local CutsceneUI = LocalPlayer.PlayerGui.CutsceneUI
    local Black, Vignette, Letterbox = CutsceneUI.Black, CutsceneUI.Vignette, CutsceneUI.Letterbox
    local clone

    local function tweenLetterbox(p10, p11) -- line: 257
        -- upvalues: Letterbox (copy), TweenService (copy)
        return function() -- line: 258
            -- upvalues: p10 (copy), p11 (copy), Letterbox (copy), TweenService (copy)
            for _, child in Letterbox:GetChildren() do
                if child:IsA("Frame") then
                    TweenService:Create(child, p10, {
                        BackgroundTransparency = p11
                    }):Play()
                end
            end
        end
    end

    local v19 = SetProperty("Workspace.CurrentCamera.CFrame", CFrame.new(6998.7129, 121.5715, -423.1443, -0.9049, -0.299, 0.3027, -0, 0.7114, 0.7028, -0.4255, 0.636, -0.6438))
    local v20 = SetProperty("Workspace.CurrentCamera.FieldOfView", 45)
    local v21 = SetProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", 0)
    local v22 = TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.2, Enum.EasingStyle.Linear), 1)
    local v23 = SetProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", 1)
    local v24 = SetProperty("PlayerGui.CutsceneUI.Vignette.Visible", true)
    local v25 = TweenInfo.new(0)
    local n1 = 1
    local t11 = {}

    t11[0] = {
        v19,
        v20,
        v21,
        v22,
        v23,
        v24,
        function() -- line: 258
            -- upvalues: Letterbox (copy), v25 (copy), n1 (copy), TweenService (copy)
            for _, child in Letterbox:GetChildren() do
                if child:IsA("Frame") then
                    TweenService:Create(child, v25, {
                        BackgroundTransparency = n1
                    }):Play()
                end
            end
        end,
        SetProperty("Lighting.CutsceneBlur.Enabled", true),
        SetProperty("Lighting.CutsceneBlur.Size", 15),
        TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.18333333333333332, Enum.EasingStyle.Linear), 4),
        SetProperty("Lighting.CutsceneDepthOfField.Enabled", true),
        SetProperty("Lighting.CutsceneDepthOfField.FarIntensity", 0.26),
        SetProperty("Lighting.CutsceneDepthOfField.FocusDistance", 0),
        TweenProperty("Lighting.CutsceneDepthOfField.FocusDistance", TweenInfo.new(30.516666666666666, Enum.EasingStyle.Linear), 23.95343),
        SetProperty("Lighting.CutsceneDepthOfField.InFocusRadius", 50),
        SetProperty("Lighting.CutsceneDepthOfField.NearIntensity", 0.75),
        TweenProperty("Lighting.CutsceneDepthOfField.NearIntensity", TweenInfo.new(30.516666666666666, Enum.EasingStyle.Linear), 0.36675)
    }
    t11[47] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.06666666666666667, Enum.EasingStyle.Linear), 15) }
    t11[49] = {
        function() -- line: 293
            -- upvalues: clone (ref), emitBurst (copy)
            emitBurst(clone.EggSlam)
        end
    }
    t11[51] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), 2) }
    t11[698] = {
        function() -- line: 303
            -- upvalues: clone (ref), emitBurst (copy)
            emitBurst(clone.Knock)
        end
    }
    t11[723] = {
        function() -- line: 309
            -- upvalues: clone (ref), emitBurst (copy)
            emitBurst(clone.Knock)
        end
    }
    t11[905] = {
        function() -- line: 315
            -- upvalues: clone (ref), emitBurst (copy)
            emitBurst(clone.Shake)
        end
    }
    t11[1046] = {
        function() -- line: 321
            -- upvalues: clone (ref), emitBurst (copy)
            emitBurst(clone.Shake)
        end
    }
    t11[1096] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(1.6166666666666667, Enum.EasingStyle.Linear), 0) }
    t11[1213] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.08333333333333333, Enum.EasingStyle.Linear), 15) }
    t11[1215] = {
        function() -- line: 335
            -- upvalues: clone (ref), emitBurst (copy)
            emitBurst(clone.EggBreak)
        end
    }
    t11[1218] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.18333333333333332, Enum.EasingStyle.Linear), 4) }
    t11[1277] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.25, Enum.EasingStyle.Linear), 15) }
    t11[1284] = {
        function() -- line: 349
            -- upvalues: clone (ref), emitBurst (copy)
            emitBurst(clone.Smoke)
        end
    }
    t11[1292] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 3) }
    t11[1639] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.8666666666666667, Enum.EasingStyle.Linear), 1) }
    t11[1831] = {
        TweenProperty("Lighting.CutsceneDepthOfField.FocusDistance", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 23.96651),
        TweenProperty("Lighting.CutsceneDepthOfField.InFocusRadius", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 2.06698),
        TweenProperty("Lighting.CutsceneDepthOfField.NearIntensity", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 0.36654)
    }
    t11[1832] = {
        TweenProperty("Lighting.CutsceneDepthOfField.FocusDistance", TweenInfo.new(1.3166666666666667, Enum.EasingStyle.Linear), 25),
        TweenProperty("Lighting.CutsceneDepthOfField.InFocusRadius", TweenInfo.new(1.3166666666666667, Enum.EasingStyle.Linear), 0),
        TweenProperty("Lighting.CutsceneDepthOfField.NearIntensity", TweenInfo.new(1.3166666666666667, Enum.EasingStyle.Linear), 0.35)
    }
    t11[1972] = {
        TweenProperty("Lighting.CutsceneDepthOfField.FocusDistance", TweenInfo.new(0.15, Enum.EasingStyle.Linear), 0),
        TweenProperty("Lighting.CutsceneDepthOfField.InFocusRadius", TweenInfo.new(0.15, Enum.EasingStyle.Linear), 50)
    }

    local v26 = TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear)
    local n2 = 0

    t11[2100] = {
        function() -- line: 258
            -- upvalues: Letterbox (copy), v26 (copy), n2 (copy), TweenService (copy)
            for _, child in Letterbox:GetChildren() do
                if child:IsA("Frame") then
                    TweenService:Create(child, v26, {
                        BackgroundTransparency = n2
                    }):Play()
                end
            end
        end
    }
    t11[2251] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.5333333333333333, Enum.EasingStyle.Linear), 10) }
    t11[2271] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.2, Enum.EasingStyle.Linear), 0) }

    return {
        Run = function() -- Run | line: 395
            -- upvalues: p9 (copy), v17 (copy), LoadAnimationIntoRig (copy), CutsceneUI (copy), Black (copy), Vignette (copy), Letterbox (copy), clone (ref), t11 (copy), ContentProvider (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), SoundService (copy), TweenService (copy), Workspace (copy), LightingController (copy), BulkFade (copy), EndingCutscene (copy), t2 (copy), EndingCutsceneSeconds (copy), EndingHandBackSeconds (copy), CurrentCamera (copy), LocalPlayer (copy), restoreCamera (copy), hideCutsceneUi (copy), restoreCutsceneUi (copy), hideAllGuardsAndNests (copy), hideLiveForest (copy)
            local _warn = warn

            xpcall(hideCutsceneUi, _warn)
            v17:Add(restoreCutsceneUi)

            local AreaEggSlotsClient = Workspace:FindFirstChild("AreaEggSlotsClient")

            if AreaEggSlotsClient ~= nil then
                AreaEggSlotsClient.Parent = ReplicatedStorage
                v17:Add(function() -- line: 402
                    -- upvalues: AreaEggSlotsClient (copy), Workspace (copy)
                    AreaEggSlotsClient.Parent = Workspace
                end)
            end

            hideAllGuardsAndNests(v17)
            hideLiveForest(v17)
            LightingController.Settle()

            for _, v27 in t2 do
                local v28 = Lighting:FindFirstChildOfClass(v27)

                if v28 ~= nil then
                    v28.Parent = nil
                    v17:Add(function() -- line: 417
                        -- upvalues: v28 (copy), Lighting (copy)
                        v28.Parent = Lighting
                    end)
                end
            end

            v17:Add(function() -- line: 421
                -- upvalues: LightingController (copy)
                LightingController.Settle()
            end)

            for _, child in EndingCutscene.LightingAssets:GetChildren() do
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
            Letterbox.Visible = true
            v17:Add(function() -- line: 438
                -- upvalues: Vignette (copy), Letterbox (copy)
                Vignette.Visible = false
                Vignette.ImageTransparency = 1
                Letterbox.Visible = false
            end)
            p9:Add(function() -- line: 444
                -- upvalues: Black (copy)
                Black.BackgroundTransparency = 1
                Black.BackgroundColor3 = Color3.new(0, 0, 0)
                Black.Visible = false
            end)

            local clone2 = EndingCutscene.BeanstalkEndingVFX:Clone()

            clone2.Parent = Workspace
            clone = clone2
            v17:Add(clone2)

            local clone3 = EndingCutscene.BeanstalkEndingWorkspaceAssets:Clone()

            clone3.Parent = Workspace
            v17:Add(clone3)

            local clone4 = EndingCutscene.CutsceneMusic:Clone()

            clone4.Parent = SoundService
            v17:Add(clone4)
            TweenService:Create(Black, TweenInfo.new(0.1), {
                BackgroundTransparency = 0
            }):Play()

            local clone5 = EndingCutscene.BeanstalkEndingRigs:Clone()

            v17:Add(clone5)

            for _, child in clone5:GetChildren() do
                if child:IsA("Model") and child.PrimaryPart then
                    child.PrimaryPart.Anchored = true
                end
            end

            clone5.Parent = Workspace

            local t13 = {}

            for _, child in clone5:GetChildren() do
                table.insert(t13, (child:FindFirstChild("Animation")))
            end

            ContentProvider:PreloadAsync(t13)

            local t14 = {}

            for _, child in clone5:GetChildren() do
                t14[child] = LoadAnimationIntoRig(child, child:FindFirstChild("Animation").AnimationId)
            end

            local v29 = true

            v17:Add(function() -- line: 487
                -- upvalues: v29 (ref), restoreCamera (copy)
                v29 = false
                restoreCamera()
            end)

            for _, v30 in t14 do
                v30:Play(0)
            end

            local v31 = t14[clone5.CamRe]
            local v32 = os.clock() + 2

            while v29 and v31.TimePosition <= 0 and os.clock() < v32 do
                RunService.RenderStepped:Wait()
            end

            clone4:Play()

            local Cam = clone5.CamRe.Cam

            v17:Connect(RunService.RenderStepped, function() -- line: 509
                -- upvalues: v29 (ref), Cam (copy), CurrentCamera (copy), LocalPlayer (copy)
                if not v29 then
                    return
                end

                CurrentCamera.CameraType = Enum.CameraType.Scriptable
                LocalPlayer.ReplicationFocus = Cam
                CurrentCamera.Focus = Cam.CFrame
                CurrentCamera.CFrame = Cam.CFrame
            end)

            local t15 = {}
            local n3 = 0
            local n4 = 0.1
            local connection = v17:Connect(RunService.Heartbeat, function(p12) -- line: 522
                -- upvalues: clone4 (copy), t14 (copy), t15 (copy), n3 (ref), n4 (ref), t11 (copy)
                n3 += p12
                n4 -= 0.1

                if n4 <= 0 then
                    n4 = 0.1

                    for _, v33 in t14 do
                        if v33.IsPlaying then
                            local v35 = n3

                            if math.abs(v35 - v33.TimePosition) >= 0.4 then
                                local function v36() -- line: 534
                                    -- upvalues: v33 (copy), n3 (ref)
                                    v33.TimePosition = n3
                                end

                                local _warn = warn

                                xpcall(v36, _warn)
                            end
                        end
                    end
                end

                if clone4.TimePosition < n3 - 0.001 then
                    clone4.PlaybackSpeed = 1.01
                elseif clone4.TimePosition > n3 + 0.001 then
                    clone4.PlaybackSpeed = 0.99
                else
                    clone4.PlaybackSpeed = 1
                end

                for i = 0, 9 do
                    local v38 = math.floor(n3 * 60 - i)

                    if t11[v38] and not t15[v38] then
                        t15[v38] = true

                        for _, v39 in t11[v38] do
                            task.spawn(v39)
                        end
                    end
                end
            end)

            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(EndingCutsceneSeconds)
            connection:Disconnect()

            local v40 = BulkFade.new(CutsceneUI.Mounts, TweenInfo.new(1))

            v40:FadeOutInstant()
            task.wait()
            v40:FadeIn()
            CutsceneUI.Mounts.Visible = true
            task.spawn(function() -- line: 569
                -- upvalues: CutsceneUI (copy)
                local function toDHMS(p13) -- line: 570
                    return string.format("%02i:%02i:%02i:%02i", p13 / 86400, p13 / 3600 % 24, p13 / 60 % 60, p13 % 60)
                end

                local n5 = 604799

                while CutsceneUI.Mounts.Visible do
                    CutsceneUI.Mounts.TimeRemaining.Text = toDHMS(n5)
                    script.ClockTick:Play()
                    task.wait(1)
                    n5 -= 1
                end
            end)
            task.wait(5)
            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            v40:FadeOut()
            task.delay(1, function() -- line: 595
                -- upvalues: v40 (copy), CutsceneUI (copy)
                CutsceneUI.Mounts.Visible = false
                v40:FadeIn()
            end)
            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(0.5)
            Black.BackgroundTransparency = 0
            v17:Clean()
            TweenService:Create(Black, TweenInfo.new(EndingHandBackSeconds), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(EndingHandBackSeconds)
            Black.Visible = false
        end
    }
end
