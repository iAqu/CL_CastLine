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

local CutsceneHelperFunctions = require(script.Parent.Parent.Parent.Parent.CutsceneHelperFunctions)

require(ReplicatedStorage.Packages.Trove)

local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local Tabs = require(ReplicatedStorage.Client.Tabs)

require(ReplicatedStorage.Shared.Remotes)

local LightingController = require(ReplicatedStorage.Controllers.Game.LightingController)
local CurrentCamera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local LightVSDarkCutscene1Rigs = ReplicatedStorage.CutsceneAssets.LightVSDarkness.LightVSDarkCutscene1Rigs
local v1, t1, v2, t2
local t3 = {
    Enum.CoreGuiType.Backpack,
    Enum.CoreGuiType.Chat,
    Enum.CoreGuiType.PlayerList,
    Enum.CoreGuiType.Health,
    Enum.CoreGuiType.EmotesMenu
}
local t4 = {}

local function restoreCamera() -- line: 49
    -- upvalues: TweenService (copy), CurrentCamera (copy), LocalPlayer (copy)
    TweenService:Create(CurrentCamera, TweenInfo.new(0), {
        FieldOfView = 70
    }):Play()
    CurrentCamera.FieldOfView = 70
    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") or nil
    LocalPlayer.ReplicationFocus = nil
end

local function hideAllUi() -- line: 59
    -- upvalues: StarterGui (copy), Tabs (copy), LocalPlayer (copy), t1 (ref), v2 (ref), t2 (ref), t3 (copy)
    if t1 ~= nil then
        return
    end

    local t5 = {}

    v2 = Tabs.Active()

    for _, child in LocalPlayer:WaitForChild("PlayerGui"):GetChildren() do
        if child:IsA("ScreenGui") and child.Name ~= "UI_NAME" and child.Enabled then
            t5[child] = true
            child.Enabled = false
        end
    end

    t1 = t5

    local function v3() -- line: 74
        -- upvalues: LocalPlayer (copy)
        LocalPlayer.PlayerGui.BottomUI.BottomFrame.Holder.List.Visible = false
    end

    pcall(v3)

    local t6 = {}

    for _, v4 in t3 do
        t6[v4] = StarterGui:GetCoreGuiEnabled(v4)
        StarterGui:SetCoreGuiEnabled(v4, false)
    end

    t2 = t6
end

local function restoreAllUi() -- line: 84
    -- upvalues: StarterGui (copy), LocalPlayer (copy), t1 (ref), v2 (ref), t2 (ref)
    local t7 = t1
    local v5 = v2

    t1 = nil
    v2 = nil

    if t7 ~= nil then
        for v6 in t7 do
            if v6.Parent ~= nil and v6.Name ~= v5 then
                v6.Enabled = true
            end
        end
    end

    local function v7() -- line: 97
        -- upvalues: LocalPlayer (copy)
        LocalPlayer.PlayerGui.BottomUI.BottomFrame.Holder.List.Visible = true
    end

    pcall(v7)

    local t8 = t2

    t2 = nil

    if t8 ~= nil then
        for v8, v9 in t8 do
            StarterGui:SetCoreGuiEnabled(v8, v9)
        end
    end

    return v5
end

local function hideCutsceneUi() -- line: 109
    -- upvalues: HiddenUIHandler (copy), v1 (ref), hideAllUi (copy)
    if v1 == nil then
        v1 = HiddenUIHandler.Acquire()
    end

    hideAllUi()
end

local function restoreCutsceneUi() -- line: 116
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

local function setTransparency(p1, p2) -- line: 128
    for _, v12 in p1 do
        if v12:IsA("BasePart") then
            if not v12:GetAttribute("OriginalTransparency") then
                v12:SetAttribute("OriginalTransparency", v12.Transparency)
            end

            v12.Transparency = p2 or v12:GetAttribute("OriginalTransparency")
        end
    end
end

local function restoreGuard(p3, p4) -- line: 141
    -- upvalues: t4 (copy)
    t4[p3] = nil

    local Guard = p4:FindFirstChild("Guard")

    if Guard == nil or Guard == p3 then
        p3.Parent = p4
    end
end

local function hideAllGuardsAndNests(p5) -- line: 150
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

        p5:Add(function() -- line: 164
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

local function restoreAllGuardsAndNests() -- line: 173
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

local Zone12Props, Board, LightDarkZone, FakeLightDarkWall, Parent

local function hideZone12(p6) -- line: 190
    -- upvalues: Zone12Props (ref), Board (ref), LightDarkZone (ref), FakeLightDarkWall (ref), Parent (ref)
    local Zone12Props2 = game.Workspace.World.Build.Props:FindFirstChild("Zone12Props")

    if Zone12Props2 then
        Zone12Props2.Parent = nil
        Zone12Props = Zone12Props2
        p6:Add(function() -- line: 195
            -- upvalues: Zone12Props2 (copy)
            Zone12Props2.Parent = game.Workspace.World.Build.Props
        end)
    end

    local Board2 = game.Workspace.World.Areas.LightDark:FindFirstChild("Board")

    if Board2 then
        Board2.Parent = nil
        Board = Board2
        p6:Add(function() -- line: 204
            -- upvalues: Zone12Props2 (copy)
            Zone12Props2.Parent = game.Workspace.World.Areas.LightDark
        end)
    end

    local LightDarkZone2 = game.Workspace.World.Build:FindFirstChild("LightDarkZone")

    if LightDarkZone2 then
        LightDarkZone2.Parent = nil
        LightDarkZone = LightDarkZone2
        p6:Add(function() -- line: 213
            -- upvalues: LightDarkZone2 (copy)
            LightDarkZone2.Parent = game.Workspace.World.Build
        end)
    end

    local FakeLightDarkWall2 = game.Workspace:FindFirstChild("FakeLightDarkWall")

    if not FakeLightDarkWall2 then
        return
    end

    FakeLightDarkWall = FakeLightDarkWall2
    Parent = FakeLightDarkWall2.Parent
    FakeLightDarkWall2.Parent = nil
    p6:Add(function() -- line: 224
        -- upvalues: FakeLightDarkWall2 (copy), Parent (ref)
        FakeLightDarkWall2.Parent = Parent
    end)
end

local function restoreZone12() -- line: 230
    -- upvalues: Zone12Props (ref), Board (ref), LightDarkZone (ref), FakeLightDarkWall (ref), Parent (ref)
    if Zone12Props then
        local Zone12Props2 = Zone12Props

        Zone12Props2.Parent = game.Workspace.World.Build.Props
    end

    if Board then
        local Board2 = Board

        Board2.Parent = game.Workspace.World.Areas.LightDark
    end

    if LightDarkZone then
        local LightDarkZone2 = LightDarkZone

        LightDarkZone2.Parent = game.Workspace.World.Build
    end

    if FakeLightDarkWall then
        FakeLightDarkWall.Parent = Parent
    end
end

return function(p7) -- line: 250
    -- upvalues: ContentProvider (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), TweenService (copy), Workspace (copy), CutsceneHelperFunctions (copy), Tabs (copy), LightingController (copy), CurrentCamera (copy), LocalPlayer (copy), LightVSDarkCutscene1Rigs (copy), v1 (ref), restoreCamera (copy), restoreAllUi (copy), hideCutsceneUi (copy), hideAllGuardsAndNests (copy), Zone12Props (ref), Board (ref), LightDarkZone (ref), FakeLightDarkWall (ref), Parent (ref), hideZone12 (copy)
    local v17 = CutsceneHelperFunctions.GetHelperFunctions(p7)
    local SetProperty, TweenProperty, _, LoadAnimationIntoRig = v17.SetProperty, v17.TweenProperty, v17.PlaySequenceAsync, v17.LoadAnimationIntoRig
    local CutsceneUI = LocalPlayer.PlayerGui.CutsceneUI
    local CutsceneMusic = script.CutsceneMusic
    local Black, Vignette = CutsceneUI.Black, CutsceneUI.Vignette
    local clone, clone2
    local t9 = {}

    t9[0] = {
        SetProperty("Workspace.CurrentCamera.CFrame", CFrame.new(5012.6948, 73.4391, -369.3411, -0.9624, -0.1056, 0.2503, -0, 0.9214, 0.3888, -0.2716, 0.3742, -0.8868)),
        TweenProperty("Workspace.CurrentCamera.CFrame", TweenInfo.new(22.516666666666666, Enum.EasingStyle.Linear), CFrame.new(4959.1108, 69.6647, -357.4677, -0.9912, -0.0969, -0.0901, 0.0391, 0.4358, -0.8992, 0.1264, -0.8948, -0.4282)),
        SetProperty("Workspace.CurrentCamera.FieldOfView", 45),
        function() -- line: 270
            local Asteroid = workspace.LightVSDarkCutscene1.ZoneExtras.Asteroid

            for _, descendant in pairs(Asteroid:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                    descendant.Enabled = true
                end
            end

            local Aura = workspace.LightVSDarkCutscene1.VFX.Aura

            for _, descendant in pairs(Aura:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                    descendant.Enabled = false
                end
            end
        end,
        SetProperty("Workspace.LightVSDarkCutscene1.VFX.Plates.HeavenSide.CFrame", CFrame.new(5306.4995, 67.7776, -378.3783, 1, 0, 0, 0, 1, 0, 0, 0, 1)),
        SetProperty("Workspace.LightVSDarkCutscene1.VFX.Plates.HellSide.CFrame", CFrame.new(5314.0996, 67.7776, -349.8495, 1, 0, 0, 0, 1, 0, 0, 0, 1)),
        SetProperty("Lighting.White.Enabled", false),
        SetProperty("Lighting.Black.Enabled", false),
        SetProperty("Lighting.RedBlack.Enabled", false),
        SetProperty("Lighting.RedWhite.Enabled", false),
        SetProperty("Lighting.GoldWhite.Enabled", false),
        SetProperty("Lighting.GoldBlack.Enabled", false),
        SetProperty("Lighting.CutsceneBlur.Enabled", true),
        SetProperty("Lighting.CutsceneBlur.Size", 2),
        SetProperty("Player.PlayerGui.CutsceneUI.Black.BackgroundTransparency", 1),
        SetProperty("Player.PlayerGui.CutsceneUI.Black.BackgroundColor3", Color3.new(0, 0, 0)),
        TweenProperty("Player.PlayerGui.CutsceneUI.Black.BackgroundColor3", TweenInfo.new(22.216666666666665, Enum.EasingStyle.Linear), Color3.new(1, 1, 1)),
        SetProperty("Lighting.Cut.Enabled", true),
        SetProperty("Lighting.Cut.FarIntensity", 0.37),
        SetProperty("Player.PlayerGui.CutsceneUI.Vignette.ImageColor3", Color3.new(0, 0, 0)),
        SetProperty("Player.PlayerGui.CutsceneUI.Vignette.ImageTransparency", 1),
        SetProperty("Player.PlayerGui.CutsceneUI.Vignette.Visible", true),
        SetProperty("Lighting.Contrast.Enabled", true),
        SetProperty("Lighting.Contrast.Saturation", 0),
        SetProperty("Lighting.Contrast.Contrast", 0)
    }
    t9[63] = { TweenProperty("Lighting.Cut.FarIntensity", TweenInfo.new(0.8, Enum.EasingStyle.Linear), 0) }
    t9[112] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.25, Enum.EasingStyle.Linear), 15) }
    t9[125] = {
        function() -- line: 313
            local MeteorImpact = workspace.LightVSDarkCutscene1.VFX.MeteorImpact

            local function check(p8) -- line: 316
                return p8 ~= nil and p8 ~= 0
            end

            for _, descendant in pairs(MeteorImpact:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    local EmitCount = descendant:GetAttribute("EmitCount")
                    local EmitDuration = descendant:GetAttribute("EmitDuration")
                    local v18 = descendant:GetAttribute("EmitDelay") or 0

                    local function triggerParticles() -- line: 327
                        -- upvalues: descendant (copy), EmitCount (copy), EmitDuration (copy)
                        if EmitCount ~= nil and EmitCount ~= 0 then
                            descendant:Emit(EmitCount)
                        end

                        if EmitDuration ~= nil and EmitDuration ~= 0 then
                            descendant.Enabled = true
                            task.delay(EmitDuration, function() -- line: 334
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
    t9[126] = {
        function() -- line: 350
            local Asteroid = workspace.LightVSDarkCutscene1.ZoneExtras.Asteroid

            for _, descendant in pairs(Asteroid:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                    descendant.Enabled = false
                end
            end

            local Smoke = workspace.LightVSDarkCutscene1.VFX.Smoke

            local function check(p9) -- line: 358
                return p9 ~= nil and p9 ~= 0
            end

            for _, descendant in pairs(Smoke:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    local EmitCount = descendant:GetAttribute("EmitCount")
                    local EmitDuration = descendant:GetAttribute("EmitDuration")
                    local v19 = descendant:GetAttribute("EmitDelay") or 0

                    local function triggerParticles() -- line: 369
                        -- upvalues: descendant (copy), EmitCount (copy), EmitDuration (copy)
                        if EmitCount ~= nil and EmitCount ~= 0 then
                            descendant:Emit(EmitCount)
                        end

                        if EmitDuration ~= nil and EmitDuration ~= 0 then
                            descendant.Enabled = true
                            task.delay(EmitDuration, function() -- line: 376
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
    t9[127] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.16666666666666666, Enum.EasingStyle.Linear), 14.91385) }
    t9[137] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(1.7666666666666666, Enum.EasingStyle.Linear), 2) }
    t9[307] = { TweenProperty("Lighting.Cut.FarIntensity", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 0.37) }
    t9[486] = { TweenProperty("Player.PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(1.0666666666666667, Enum.EasingStyle.Linear), 0.5) }
    t9[540] = {
        function() -- line: 408
            -- upvalues: clone2 (ref)
            clone2.ChatBubble.Text.SurfaceGui.SPEECHBUBBLE.Text = "MINE!"
        end
    }
    t9[689] = { TweenProperty("Player.PlayerGui.CutsceneUI.Vignette.ImageColor3", TweenInfo.new(0.35, Enum.EasingStyle.Linear), Color3.new(1, 0.0431373, 0.0431373)) }
    t9[720] = {
        function() -- line: 418
            -- upvalues: clone2 (ref)
            clone2.ChatBubble.Text.SurfaceGui.SPEECHBUBBLE.Text = "Uh oh..."
        end
    }
    t9[730] = { TweenProperty("Player.PlayerGui.CutsceneUI.Vignette.ImageColor3", TweenInfo.new(0.3, Enum.EasingStyle.Linear), Color3.new(1, 0.823366, 0.176471)) }
    t9[755] = { TweenProperty("Player.PlayerGui.CutsceneUI.Vignette.ImageColor3", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), Color3.new(0, 0, 0)) }
    t9[786] = {
        function() -- line: 432
            local Split = workspace.LightVSDarkCutscene1.VFX.Split

            local function check(p10) -- line: 435
                return p10 ~= nil and p10 ~= 0
            end

            for _, descendant in pairs(Split:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    local EmitCount = descendant:GetAttribute("EmitCount")
                    local EmitDuration = descendant:GetAttribute("EmitDuration")
                    local v20 = descendant:GetAttribute("EmitDelay") or 0

                    local function triggerParticles() -- line: 446
                        -- upvalues: descendant (copy), EmitCount (copy), EmitDuration (copy)
                        if EmitCount ~= nil and EmitCount ~= 0 then
                            descendant:Emit(EmitCount)
                        end

                        if EmitDuration ~= nil and EmitDuration ~= 0 then
                            descendant.Enabled = true
                            task.delay(EmitDuration, function() -- line: 453
                                -- upvalues: descendant (copy)
                                descendant.Enabled = false
                            end)
                        end
                    end

                    if v20 ~= nil and v20 ~= 0 then
                        task.delay(v20, triggerParticles)
                    else
                        triggerParticles()
                    end
                end
            end
        end
    }
    t9[807] = { TweenProperty("Player.PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.45, Enum.EasingStyle.Linear), 1) }
    t9[808] = { SetProperty("Lighting.GoldWhite.Enabled", true) }
    t9[810] = {
        SetProperty("Lighting.RedBlack.Enabled", true),
        SetProperty("Lighting.GoldWhite.Enabled", false)
    }
    t9[812] = {
        SetProperty("Lighting.White.Enabled", true),
        SetProperty("Lighting.RedBlack.Enabled", false)
    }
    t9[814] = {
        SetProperty("Lighting.White.Enabled", false),
        SetProperty("Lighting.GoldBlack.Enabled", true)
    }
    t9[816] = {
        SetProperty("Lighting.RedWhite.Enabled", true),
        SetProperty("Lighting.GoldBlack.Enabled", false)
    }
    t9[818] = {
        SetProperty("Lighting.Black.Enabled", true),
        SetProperty("Lighting.RedWhite.Enabled", false)
    }
    t9[820] = { SetProperty("Lighting.Black.Enabled", false) }
    t9[822] = {
        SetProperty("Lighting.GoldWhite.Enabled", false),
        SetProperty("Lighting.RedBlack.Enabled", false),
        SetProperty("Lighting.White.Enabled", false),
        SetProperty("Lighting.GoldBlack.Enabled", false),
        SetProperty("Lighting.RedWhite.Enabled", false),
        SetProperty("Lighting.Black.Enabled", false)
    }
    t9[830] = {
        SetProperty("Lighting.GoldWhite.Enabled", false),
        SetProperty("Lighting.RedBlack.Enabled", false),
        SetProperty("Lighting.White.Enabled", false),
        SetProperty("Lighting.GoldBlack.Enabled", false),
        SetProperty("Lighting.RedWhite.Enabled", false),
        SetProperty("Lighting.Black.Enabled", false)
    }
    t9[840] = {
        SetProperty("Lighting.GoldWhite.Enabled", false),
        SetProperty("Lighting.RedBlack.Enabled", false),
        SetProperty("Lighting.White.Enabled", false),
        SetProperty("Lighting.GoldBlack.Enabled", false),
        SetProperty("Lighting.RedWhite.Enabled", false),
        SetProperty("Lighting.Black.Enabled", false)
    }
    t9[850] = {
        SetProperty("Lighting.GoldWhite.Enabled", false),
        SetProperty("Lighting.RedBlack.Enabled", false),
        SetProperty("Lighting.White.Enabled", false),
        SetProperty("Lighting.GoldBlack.Enabled", false),
        SetProperty("Lighting.RedWhite.Enabled", false),
        SetProperty("Lighting.Black.Enabled", false)
    }
    t9[1085] = {
        function() -- line: 542
            local Radiate1 = workspace.LightVSDarkCutscene1Rigs.Ben:WaitForChild("DarkCrystal"):WaitForChild("DGem"):WaitForChild("Radiate1")

            for _, descendant in ipairs(Radiate1:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = true
                end
            end
        end
    }
    t9[1120] = {
        function() -- line: 554
            local Radiate2 = workspace.LightVSDarkCutscene1Rigs.Ben:WaitForChild("LightCrystal"):WaitForChild("LGem"):WaitForChild("Radiate2")

            for _, descendant in ipairs(Radiate2:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = true
                end
            end
        end
    }
    t9[1150] = {
        function() -- line: 566
            local Aura = workspace.LightVSDarkCutscene1.VFX.Aura

            for _, descendant in pairs(Aura:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                    descendant.Enabled = true
                end
            end
        end
    }
    t9[1265] = {
        function() -- line: 575
            local Radiate1 = workspace.LightVSDarkCutscene1Rigs.Ben:WaitForChild("DarkCrystal"):WaitForChild("DGem"):WaitForChild("Radiate1")

            for _, descendant in ipairs(Radiate1:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = false
                end
            end

            local Radiate2 = workspace.LightVSDarkCutscene1Rigs.Ben:WaitForChild("LightCrystal"):WaitForChild("LGem"):WaitForChild("Radiate2")

            for _, descendant in ipairs(Radiate2:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = false
                end
            end
        end
    }
    t9[1277] = {
        TweenProperty("Lighting.Contrast.Saturation", TweenInfo.new(1.2333333333333334, Enum.EasingStyle.Linear), -0.1),
        TweenProperty("Lighting.Contrast.Contrast", TweenInfo.new(1.2333333333333334, Enum.EasingStyle.Linear), 2)
    }
    t9[1333] = { TweenProperty("Player.PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.3, Enum.EasingStyle.Linear), 0) }
    t9[1351] = {
        TweenProperty("Workspace.CurrentCamera.CFrame", TweenInfo.new(4.733333333333333, Enum.EasingStyle.Linear), CFrame.new(5044.5688, 77.7031, -364.1059, 0.0085, 0.0175, -0.9998, -1E-04, 0.9998, 0.0175, 1, 0, 0.0085)),
        TweenProperty("Player.PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.13333333333333333, Enum.EasingStyle.Linear), 0.0202),
        TweenProperty("Lighting.Contrast.Saturation", TweenInfo.new(0.9166666666666666, Enum.EasingStyle.Linear), 0),
        TweenProperty("Lighting.Contrast.Contrast", TweenInfo.new(0.9166666666666666, Enum.EasingStyle.Linear), 0)
    }
    t9[1350] = {
        function() -- line: 611
            -- upvalues: p7 (copy), LightingController (copy)
            LightingController.SetLayer("LightVsDarknessCutscene", "LightDarkness", 999, 0.05)
            p7:Add(function() -- line: 614
                -- upvalues: LightingController (copy)
                LightingController.ClearLayer("LightVsDarknessCutscene")
            end)
        end
    }
    t9[1359] = {
        TweenProperty("Player.PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), 1),
        SetProperty("Lighting.Cut.Enabled", false)
    }
    t9[1367] = { TweenProperty("Player.PlayerGui.CutsceneUI.Black.BackgroundColor3", TweenInfo.new(0.25, Enum.EasingStyle.Linear), Color3.new(0, 0, 0)) }
    t9[1382] = { TweenProperty("Player.PlayerGui.CutsceneUI.Black.BackgroundColor3", TweenInfo.new(4.4, Enum.EasingStyle.Linear), Color3.new(1, 1, 1)) }
    t9[1428] = {
        function() -- line: 634
            local Aura = workspace.LightVSDarkCutscene1.VFX.Aura

            for _, descendant in pairs(Aura:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                    descendant.Enabled = false
                end
            end
        end
    }
    t9[1500] = {
        function() -- line: 643
            local Plates = workspace.LightVSDarkCutscene1.VFX.Plates

            for _, descendant in pairs(Plates:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                    descendant.Enabled = true
                end
            end
        end
    }
    t9[1531] = {
        TweenProperty("Workspace.LightVSDarkCutscene1.VFX.Plates.HeavenSide.CFrame", TweenInfo.new(1.8666666666666667, Enum.EasingStyle.Linear), CFrame.new(5306.4995, 67.7776, -370.2783, 1, 0, 0, 0, 1, 0, 0, 0, 1)),
        TweenProperty("Workspace.LightVSDarkCutscene1.VFX.Plates.HellSide.CFrame", TweenInfo.new(1.8666666666666667, Enum.EasingStyle.Linear), CFrame.new(5314.0996, 67.7776, -361.8634, 1, 0, 0, 0, 1, 0, 0, 0, 1))
    }
    t9[1612] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.6166666666666667, Enum.EasingStyle.Linear), 35) }
    t9[1635] = { TweenProperty("Player.PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.18333333333333332, Enum.EasingStyle.Linear), 0) }
    t9[1645] = {
        function() -- line: 665
            local Plates = workspace.LightVSDarkCutscene1.VFX.Plates

            for _, descendant in pairs(Plates:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                    descendant.Enabled = false
                end
            end
        end
    }
    t9[1646] = {
        TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 25),
        TweenProperty("Player.PlayerGui.CutsceneUI.Black.BackgroundColor3", TweenInfo.new(0.03333333333333333, Enum.EasingStyle.Linear), Color3.new(0, 0, 0))
    }
    t9[1649] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(2.35, Enum.EasingStyle.Linear), 4) }
    t9[1726] = { TweenProperty("Player.PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(1.0666666666666667, Enum.EasingStyle.Linear), 1) }
    t9[1770] = {
        TweenProperty("Workspace.CurrentCamera.CFrame", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), CFrame.new(5126.2271, 70.3521, -364.1059, 0.0083, -0.1908, -0.9816, -2E-04, 0.9816, -0.1908, 1, 0.0017, 0.0081)),
        TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 35)
    }
    t9[1771] = { TweenProperty("Workspace.CurrentCamera.CFrame", TweenInfo.new(4.483333333333333, Enum.EasingStyle.Linear), CFrame.new(5127.7866, 70.5555, -364.106, 0.0084, -0.1564, -0.9877, -2E-04, 0.9877, -0.1564, 1, 0.0015, 0.0082)) }
    t9[2000] = { TweenProperty("Player.PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.6, Enum.EasingStyle.Linear), 0) }

    return {
        Run = function() -- Run | line: 701
            -- upvalues: p7 (copy), LoadAnimationIntoRig (copy), CutsceneUI (copy), CutsceneMusic (copy), Black (copy), Vignette (copy), clone (ref), clone2 (ref), t9 (copy), ContentProvider (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), TweenService (copy), Workspace (copy), Tabs (copy), CurrentCamera (copy), LocalPlayer (copy), LightVSDarkCutscene1Rigs (copy), v1 (ref), restoreCamera (copy), restoreAllUi (copy), hideCutsceneUi (copy), hideAllGuardsAndNests (copy), Zone12Props (ref), Board (ref), LightDarkZone (ref), FakeLightDarkWall (ref), Parent (ref), hideZone12 (copy)
            local v21 = false
            local _warn = warn

            xpcall(hideCutsceneUi, _warn)
            p7:Add(function() -- line: 706
                -- upvalues: v21 (ref), Tabs (copy), v1 (ref), restoreAllUi (copy)
                if v21 then
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

                v21 = true
            end)

            local AreaEggSlotsClient = Workspace:FindFirstChild("AreaEggSlotsClient")

            local function v24() -- line: 714
                -- upvalues: AreaEggSlotsClient (copy), p7 (copy), ReplicatedStorage (copy), Workspace (copy)
                AreaEggSlotsClient.Parent = ReplicatedStorage
                p7:Add(function() -- line: 716
                    -- upvalues: AreaEggSlotsClient (copy), Workspace (copy)
                    AreaEggSlotsClient.Parent = Workspace
                end)
            end

            pcall(v24)
            hideAllGuardsAndNests(p7)
            hideZone12(p7)

            local t11 = {}

            for _, child in script.LightingAssets:GetChildren() do
                if not Lighting:FindFirstChild(child.Name) then
                    local clone = child:Clone()

                    clone.Parent = Lighting
                    p7:Add(clone)
                    table.insert(t11, clone)
                end
            end

            CutsceneUI.Enabled = true
            Black.BackgroundTransparency = 1
            Black.Visible = true
            Vignette.Visible = false
            p7:Add(function() -- line: 741
                -- upvalues: Vignette (copy)
                Vignette.Visible = false
                Vignette.ImageTransparency = 1
            end)

            local clone3 = ReplicatedStorage.CutsceneAssets.LightVSDarkness.LightVSDarkCutscene1:Clone()

            clone3.Parent = Workspace
            clone = clone3
            p7:Add(clone3)
            TweenService:Create(Black, TweenInfo.new(0.1), {
                BackgroundTransparency = 0
            }):Play()
            p7:Add(function() -- line: 752
                -- upvalues: Black (copy)
                Black.BackgroundTransparency = 1
                Black.Visible = false
            end)
            clone2 = LightVSDarkCutscene1Rigs:Clone()

            for _, child in clone2:GetChildren() do
                if child:IsA("Model") and child.PrimaryPart then
                    child.PrimaryPart.Anchored = true
                end
            end

            local clone4 = clone2

            clone4.Parent = workspace

            local clone5 = clone2

            p7:Add(clone5)

            local t12 = {}

            for _, child in clone2:GetChildren() do
                local Animation = child:FindFirstChildOfClass("Animation")

                if Animation then
                    table.insert(t12, Animation)
                end
            end

            ContentProvider:PreloadAsync(t12)

            local t13 = {}

            for _, child in clone2:GetChildren() do
                local Animation = child:FindFirstChildOfClass("Animation")

                if Animation then
                    t13[child] = LoadAnimationIntoRig(child, Animation.AnimationId)
                end
            end

            for _, child in clone:GetChildren() do
                local Animation = child:FindFirstChildOfClass("Animation")

                if Animation then
                    t13[child] = LoadAnimationIntoRig(child, Animation.AnimationId)
                end
            end

            local v25 = true

            p7:Add(function() -- line: 796
                -- upvalues: v25 (ref)
                v25 = false
            end)
            p7:Add(function() -- line: 797
                -- upvalues: v25 (ref), restoreCamera (copy)
                if v25 then
                    restoreCamera()
                end
            end)

            for _, v26 in t13 do
                v26:Play(0)
            end

            local v27 = t13[clone2["Camera Rig"]]

            assert(v27, "Camera Rig needs an Animation")

            local v28 = os.clock() + 2

            while v25 and v27.TimePosition <= 0 and os.clock() < v28 do
                RunService.RenderStepped:Wait()
            end

            CutsceneMusic:Play()

            local Cam = clone2["Camera Rig"].Cam
            local connection

            connection = RunService.RenderStepped:Connect(function() -- line: 824
                -- upvalues: v25 (ref), Cam (copy), connection (ref), CurrentCamera (copy), LocalPlayer (copy)
                if not v25 then
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
            local connection2 = RunService.Heartbeat:Connect(function(p11) -- line: 838
                -- upvalues: t13 (copy), t14 (copy), n1 (ref), n2 (ref), CutsceneMusic (copy), t9 (copy)
                n1 += p11
                n2 -= 0.1

                if n2 <= 0 then
                    n2 = 0.1

                    for _, v29 in t13 do
                        if v29.IsPlaying then
                            local v31 = n1

                            if math.abs(v31 - v29.TimePosition) >= 0.1 then
                                local function v32() -- line: 850
                                    -- upvalues: v29 (copy), n1 (ref)
                                    v29.TimePosition = n1
                                end

                                local _warn = warn

                                xpcall(v32, _warn)
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
                    local v34 = math.floor(n1 * 60 - i)

                    if t9[v34] and not t14[v34] then
                        t14[v34] = true

                        for _, v35 in t9[v34] do
                            task.spawn(v35)
                        end
                    end
                end
            end)

            p7:Add(connection2)
            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(34.5)
            connection2:Disconnect()

            local function v36() -- line: 882
                -- upvalues: clone3 (copy)
                clone3:Destroy()
            end

            local _warn2 = warn

            xpcall(v36, _warn2)
            v25 = false
            Vignette.Visible = false

            local function v37() -- line: 888
                -- upvalues: t11 (copy)
                for _, v38 in t11 do
                    v38:Destroy()
                end
            end

            local _warn3 = warn

            xpcall(v37, _warn3)

            local function v39() -- line: 894
                -- upvalues: clone2 (ref)
                clone2:Destroy()
            end

            local _warn4 = warn

            xpcall(v39, _warn4)

            local _warn5 = warn

            xpcall(restoreCamera, _warn5)
            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(0.5)
            Black.Visible = false
            Vignette.Visible = false

            local function v40() -- line: 905
                -- upvalues: AreaEggSlotsClient (copy), Workspace (copy)
                AreaEggSlotsClient.Parent = Workspace
            end

            pcall(v40)

            local function v41() -- line: 909
                -- upvalues: v21 (ref), Tabs (copy), v1 (ref), restoreAllUi (copy)
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

                v21 = true
            end

            local _warn6 = warn

            xpcall(v41, _warn6)

            if Zone12Props then
                local Zone12Props2 = Zone12Props

                Zone12Props2.Parent = game.Workspace.World.Build.Props
            end

            if Board then
                local Board2 = Board

                Board2.Parent = game.Workspace.World.Areas.LightDark
            end

            if LightDarkZone then
                local LightDarkZone2 = LightDarkZone

                LightDarkZone2.Parent = game.Workspace.World.Build
            end

            if FakeLightDarkWall then
                FakeLightDarkWall.Parent = Parent
            end
        end
    }
end
