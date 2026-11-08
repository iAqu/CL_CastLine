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
local BulkFade = require(ReplicatedStorage.Client.Modules.BulkFade)
local CutsceneHelperFunctions = require(script.Parent.Parent.Parent.Parent.CutsceneHelperFunctions)

require(ReplicatedStorage.Packages.Trove)

local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local Tabs = require(ReplicatedStorage.Client.Tabs)

require(ReplicatedStorage.Shared.Remotes)

local CurrentCamera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local LightVsDarkCutsceneEndRigs = ReplicatedStorage.CutsceneAssets.LightVSDarkness.LightVsDarkCutsceneEndRigs
local v1, t1, v2, t2
local t3 = {
    Enum.CoreGuiType.Backpack,
    Enum.CoreGuiType.Chat,
    Enum.CoreGuiType.PlayerList,
    Enum.CoreGuiType.Health,
    Enum.CoreGuiType.EmotesMenu
}
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

    local function v3() -- line: 73
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

local function restoreAllUi() -- line: 83
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

    local function v7() -- line: 96
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

local Zone12Props, Board, LightDarkZone

local function hideZone12(p6) -- line: 187
    -- upvalues: Zone12Props (ref), Board (ref), LightDarkZone (ref)
    local Zone12Props2 = game.Workspace.World.Build.Props:FindFirstChild("Zone12Props")

    if Zone12Props2 then
        Zone12Props2.Parent = nil
        Zone12Props = Zone12Props2
        p6:Add(function() -- line: 192
            -- upvalues: Zone12Props2 (copy)
            Zone12Props2.Parent = game.Workspace.World.Build.Props
        end)
    end

    local Board2 = game.Workspace.World.Areas.LightDark:FindFirstChild("Board")

    if Board2 then
        Board2.Parent = nil
        Board = Board2
        p6:Add(function() -- line: 201
            -- upvalues: Zone12Props2 (copy)
            Zone12Props2.Parent = game.Workspace.World.Areas.LightDark
        end)
    end

    local LightDarkZone2 = game.Workspace.World.Build:FindFirstChild("LightDarkZone")

    if not LightDarkZone2 then
        return
    end

    LightDarkZone2.Parent = nil
    LightDarkZone = LightDarkZone2
    p6:Add(function() -- line: 210
        -- upvalues: LightDarkZone2 (copy)
        LightDarkZone2.Parent = game.Workspace.World.Build
    end)
end

local function restoreZone12() -- line: 216
    -- upvalues: Zone12Props (ref), Board (ref), LightDarkZone (ref)
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
end

return function(p7) -- line: 232
    -- upvalues: ContentProvider (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), TweenService (copy), Workspace (copy), BulkFade (copy), CutsceneHelperFunctions (copy), Tabs (copy), CurrentCamera (copy), LocalPlayer (copy), LightVsDarkCutsceneEndRigs (copy), v1 (ref), restoreCamera (copy), restoreAllUi (copy), hideCutsceneUi (copy), hideAllGuardsAndNests (copy), restoreAllGuardsAndNests (copy), Zone12Props (ref), Board (ref), LightDarkZone (ref), hideZone12 (copy)
    local v17 = CutsceneHelperFunctions.GetHelperFunctions(p7)
    local SetProperty, TweenProperty, _, LoadAnimationIntoRig = v17.SetProperty, v17.TweenProperty, v17.PlaySequenceAsync, v17.LoadAnimationIntoRig
    local CutsceneUI = LocalPlayer.PlayerGui.CutsceneUI
    local CutsceneMusic = script.CutsceneMusic
    local Black, Vignette = CutsceneUI.Black, CutsceneUI.Vignette
    local clone
    local t9 = {
        [0] = {
            SetProperty("Workspace.CurrentCamera.FieldOfView", 45),
            SetProperty("Workspace.CurrentCamera.CFrame", CFrame.new(4909.7358, 210.7663, -452.3103, -0.146, 0.5681, -0.8099, -0.0122, 0.8176, 0.5757, 0.9892, 0.0939, -0.1124)),
            TweenProperty("Workspace.CurrentCamera.CFrame", TweenInfo.new(5, Enum.EasingStyle.Linear), CFrame.new(5495.7603, 71.3227, -358.1957, -0.4007, -0.0489, -0.9149, -0.155, 0.9878, 0.0151, 0.903, 0.1478, -0.4034)),
            function() -- line: 251
                -- upvalues: clone (ref)
                local FloorSammy = clone.VFX.LightWin.FloorSammy

                for _, descendant in pairs(FloorSammy:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                        descendant.Enabled = false
                    end
                end
            end,
            SetProperty("Workspace.LightVSDarkCutsceneEnd.VFX.LightWin.Aura.Halo.CFrame", CFrame.new(5529.939, 122.3857, -1293.6287, 1, 0, 0, 0, 1, 0, 0, 0, 1)),
            SetProperty("Workspace.LightVSDarkCutsceneEnd.VFX.LightWin.Aura.Floor.CFrame", CFrame.new(5496.7144, 68.4898, -1293.3365, 1, 0, 0, 0, 1, 0, 0, 0, 1)),
            SetProperty("Lighting.GoldWhite.Enabled", false),
            SetProperty("Lighting.GoldBlack.Enabled", false),
            SetProperty("Lighting.White.Enabled", false),
            SetProperty("Lighting.Black.Enabled", false),
            SetProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", 0),
            TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.2833333333333333, Enum.EasingStyle.Linear), 1),
            SetProperty("Lighting.CutsceneBlur.Enabled", true),
            SetProperty("Lighting.CutsceneBlur.Size", 20),
            TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.55, Enum.EasingStyle.Linear), 2),
            SetProperty("PlayerGui.CutsceneUI.Vignette.ImageColor3", Color3.new(0, 0, 0)),
            TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageColor3", TweenInfo.new(5.25, Enum.EasingStyle.Linear), Color3.new(1, 0.642831, 0.258824)),
            SetProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", 1),
            TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(5.25, Enum.EasingStyle.Linear), 0),
            SetProperty("PlayerGui.CutsceneUI.Vignette.Visible", true)
        },
        [40] = {
            function() -- line: 276
                -- upvalues: clone (ref)
                local Hearts = clone.VFX.LightWin.Hearts

                for _, descendant in pairs(Hearts:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                        descendant.Enabled = false
                    end
                end
            end
        },
        [104] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.05, Enum.EasingStyle.Linear), 15) },
        [105] = {
            function() -- line: 289
                -- upvalues: clone (ref)
                local Stab = clone.VFX.LightWin.Stab

                local function check(p8) -- line: 292
                    return p8 ~= nil and p8 ~= 0
                end

                for _, descendant in pairs(Stab:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        local EmitCount = descendant:GetAttribute("EmitCount")
                        local EmitDuration = descendant:GetAttribute("EmitDuration")

                        if EmitCount ~= nil and EmitCount ~= 0 then
                            descendant:Emit(EmitCount)
                        end

                        if EmitDuration ~= nil and EmitDuration ~= 0 then
                            descendant.Enabled = true
                            task.delay(EmitDuration, function() -- line: 307
                                -- upvalues: descendant (copy)
                                descendant.Enabled = false
                            end)
                        end
                    end
                end
            end
        },
        [107] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.31666666666666665, Enum.EasingStyle.Linear), 2) },
        [203] = {
            function() -- line: 320
                -- upvalues: clone (ref)
                local Smoke = clone.VFX.LightWin.Smoke

                local function check(p9) -- line: 323
                    return p9 ~= nil and p9 ~= 0
                end

                for _, descendant in pairs(Smoke:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        local EmitCount = descendant:GetAttribute("EmitCount")
                        local EmitDuration = descendant:GetAttribute("EmitDuration")

                        if EmitCount ~= nil and EmitCount ~= 0 then
                            descendant:Emit(EmitCount)
                        end

                        if EmitDuration ~= nil and EmitDuration ~= 0 then
                            descendant.Enabled = true
                            task.delay(EmitDuration, function() -- line: 338
                                -- upvalues: descendant (copy)
                                descendant.Enabled = false
                            end)
                        end
                    end
                end
            end
        },
        [217] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.13333333333333333, Enum.EasingStyle.Linear), 15) },
        [224] = {
            function() -- line: 351
                -- upvalues: clone (ref)
                local Smoke2 = clone.VFX.LightWin.Smoke2

                local function check(p10) -- line: 354
                    return p10 ~= nil and p10 ~= 0
                end

                for _, descendant in pairs(Smoke2:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        local EmitCount = descendant:GetAttribute("EmitCount")
                        local EmitDuration = descendant:GetAttribute("EmitDuration")

                        if EmitCount ~= nil and EmitCount ~= 0 then
                            descendant:Emit(EmitCount)
                        end

                        if EmitDuration ~= nil and EmitDuration ~= 0 then
                            descendant.Enabled = true
                            task.delay(EmitDuration, function() -- line: 369
                                -- upvalues: descendant (copy)
                                descendant.Enabled = false
                            end)
                        end
                    end
                end
            end
        },
        [225] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 10) },
        [231] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.13333333333333333, Enum.EasingStyle.Linear), 7) },
        [239] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.13333333333333333, Enum.EasingStyle.Linear), 15) },
        [247] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.8166666666666667, Enum.EasingStyle.Linear), 2) },
        [278] = {
            function() -- line: 394
                -- upvalues: clone (ref)
                local Aura = clone.VFX.LightWin.Aura

                for _, descendant in pairs(Aura:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                        descendant.Enabled = true
                    end
                end
            end
        },
        [300] = {
            TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Sine), 75),
            TweenProperty("Workspace.CurrentCamera.CFrame", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), CFrame.new(5442.0625, 110.1231, 508.3064, 0.0085, -0.0872, -0.9962, -0, 0.9962, -0.0872, 1, 7E-04, 0.0085)),
            TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 15)
        },
        [301] = {
            TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.26666666666666666, Enum.EasingStyle.Sine), 50),
            TweenProperty("Workspace.CurrentCamera.CFrame", TweenInfo.new(8.666666666666666, Enum.EasingStyle.Linear), CFrame.new(5626.7803, 75.4134, 505.1515, -0.226, -0.3605, -0.905, -0.2128, 0.9248, -0.3152, 0.9506, 0.1214, -0.2857)),
            TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.23333333333333334, Enum.EasingStyle.Linear), 2)
        },
        [315] = {
            SetProperty("Lighting.White.Enabled", true),
            TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(4.75, Enum.EasingStyle.Linear), 0.24633)
        },
        [317] = {
            SetProperty("Lighting.GoldBlack.Enabled", true),
            SetProperty("Lighting.White.Enabled", false)
        },
        [319] = {
            SetProperty("Lighting.GoldWhite.Enabled", true),
            SetProperty("Lighting.GoldBlack.Enabled", false)
        },
        [321] = {
            SetProperty("Lighting.GoldWhite.Enabled", false),
            SetProperty("Lighting.Black.Enabled", true)
        },
        [323] = {
            SetProperty("Lighting.GoldWhite.Enabled", true),
            SetProperty("Lighting.Black.Enabled", false)
        },
        [325] = {
            SetProperty("Lighting.GoldWhite.Enabled", false),
            SetProperty("Lighting.GoldBlack.Enabled", true)
        },
        [327] = { SetProperty("Lighting.GoldBlack.Enabled", false) },
        [340] = {
            SetProperty("Lighting.White.Enabled", false),
            SetProperty("Lighting.GoldBlack.Enabled", false),
            SetProperty("Lighting.GoldWhite.Enabled", false),
            SetProperty("Lighting.Black.Enabled", false),
            SetProperty("Lighting.GoldWhite.Enabled", false),
            SetProperty("Lighting.GoldBlack.Enabled", false)
        },
        [350] = {
            SetProperty("Lighting.White.Enabled", false),
            SetProperty("Lighting.GoldBlack.Enabled", false),
            SetProperty("Lighting.GoldWhite.Enabled", false),
            SetProperty("Lighting.Black.Enabled", false),
            SetProperty("Lighting.GoldWhite.Enabled", false),
            SetProperty("Lighting.GoldBlack.Enabled", false)
        },
        [600] = {
            function() -- line: 467
                -- upvalues: clone (ref)
                local Aura = clone.VFX.LightWin.Aura

                for _, descendant in pairs(Aura:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                        descendant.Enabled = false
                    end
                end
            end,
            TweenProperty("Workspace.LightVSDarkCutsceneEnd.VFX.LightWin.Aura.Halo.CFrame", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), CFrame.new(5529.939, -123.0639, -1293.6287, 1, 0, 0, 0, 1, 0, 0, 0, 1)),
            TweenProperty("Workspace.LightVSDarkCutsceneEnd.VFX.LightWin.Aura.Floor.CFrame", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), CFrame.new(5496.7144, -136.264, -1293.3365, 1, 0, 0, 0, 1, 0, 0, 0, 1)),
            TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageColor3", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), Color3.new(0.752809, 0.483929, 0.194845)),
            TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 1)
        },
        [601] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageColor3", TweenInfo.new(14.516666666666667, Enum.EasingStyle.Linear), Color3.new(0, 0, 0)) },
        [821] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.25, Enum.EasingStyle.Sine), 35) },
        [872] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.35, Enum.EasingStyle.Sine), 45) },
        [892] = {
            function() -- line: 492
                -- upvalues: clone (ref)
                local SammyHit = clone.VFX.LightWin.SammyHit

                local function check(p11) -- line: 495
                    return p11 ~= nil and p11 ~= 0
                end

                for _, descendant in pairs(SammyHit:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        local EmitCount = descendant:GetAttribute("EmitCount")
                        local EmitDuration = descendant:GetAttribute("EmitDuration")

                        if EmitCount ~= nil and EmitCount ~= 0 then
                            descendant:Emit(EmitCount)
                        end

                        if EmitDuration ~= nil and EmitDuration ~= 0 then
                            descendant.Enabled = true
                            task.delay(EmitDuration, function() -- line: 510
                                -- upvalues: descendant (copy)
                                descendant.Enabled = false
                            end)
                        end
                    end
                end
            end
        },
        [956] = {
            function() -- line: 519
                -- upvalues: clone (ref)
                local Smoke3 = clone.VFX.LightWin.Smoke3

                local function check(p12) -- line: 522
                    return p12 ~= nil and p12 ~= 0
                end

                for _, descendant in pairs(Smoke3:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        local EmitCount = descendant:GetAttribute("EmitCount")
                        local EmitDuration = descendant:GetAttribute("EmitDuration")

                        if EmitCount ~= nil and EmitCount ~= 0 then
                            descendant:Emit(EmitCount)
                        end

                        if EmitDuration ~= nil and EmitDuration ~= 0 then
                            descendant.Enabled = true
                            task.delay(EmitDuration, function() -- line: 537
                                -- upvalues: descendant (copy)
                                descendant.Enabled = false
                            end)
                        end
                    end
                end
            end
        },
        [976] = {
            function() -- line: 546
                -- upvalues: clone (ref)
                local Smoke4 = clone.VFX.LightWin.Smoke4

                local function check(p13) -- line: 549
                    return p13 ~= nil and p13 ~= 0
                end

                for _, descendant in pairs(Smoke4:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        local EmitCount = descendant:GetAttribute("EmitCount")
                        local EmitDuration = descendant:GetAttribute("EmitDuration")

                        if EmitCount ~= nil and EmitCount ~= 0 then
                            descendant:Emit(EmitCount)
                        end

                        if EmitDuration ~= nil and EmitDuration ~= 0 then
                            descendant.Enabled = true
                            task.delay(EmitDuration, function() -- line: 564
                                -- upvalues: descendant (copy)
                                descendant.Enabled = false
                            end)
                        end
                    end
                end
            end
        },
        [1234] = {
            function() -- line: 573
                -- upvalues: clone (ref)
                local Hearts = clone.VFX.LightWin.Hearts

                for _, descendant in pairs(Hearts:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                        descendant.Enabled = true
                    end
                end
            end
        },
        [1305] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 15) },
        [1306] = {
            function() -- line: 586
                -- upvalues: clone (ref)
                local FloorSammy = clone.VFX.LightWin.FloorSammy

                for _, descendant in pairs(FloorSammy:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                        descendant.Enabled = true
                    end
                end
            end,
            TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.31666666666666665, Enum.EasingStyle.Linear), 2)
        },
        [1377] = {
            function() -- line: 596
                -- upvalues: clone (ref)
                local Hearts = clone.VFX.LightWin.Hearts

                for _, descendant in pairs(Hearts:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                        descendant.Enabled = false
                    end
                end
            end
        },
        [1471] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Sine), 70) },
        [1472] = {
            TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.25, Enum.EasingStyle.Sine), 40),
            TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageColor3", TweenInfo.new(0.25, Enum.EasingStyle.Linear), Color3.new(0.72549, 0, 0)),
            TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.25, Enum.EasingStyle.Linear), 0)
        },
        [1570] = {
            TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.3), 0),
            TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.3, Enum.EasingStyle.Linear), 1)
        }
    }

    return {
        Run = function() -- Run | line: 620
            -- upvalues: p7 (copy), LoadAnimationIntoRig (copy), CutsceneUI (copy), CutsceneMusic (copy), Black (copy), Vignette (copy), clone (ref), t9 (copy), ContentProvider (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), TweenService (copy), Workspace (copy), BulkFade (copy), Tabs (copy), CurrentCamera (copy), LocalPlayer (copy), LightVsDarkCutsceneEndRigs (copy), v1 (ref), restoreCamera (copy), restoreAllUi (copy), hideCutsceneUi (copy), hideAllGuardsAndNests (copy), restoreAllGuardsAndNests (copy), Zone12Props (ref), Board (ref), LightDarkZone (ref), hideZone12 (copy)
            local v18 = false
            local _warn = warn

            xpcall(hideCutsceneUi, _warn)
            p7:Add(function() -- line: 625
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

            local function v21() -- line: 633
                -- upvalues: AreaEggSlotsClient (copy), p7 (copy), ReplicatedStorage (copy), Workspace (copy)
                AreaEggSlotsClient.Parent = ReplicatedStorage
                p7:Add(function() -- line: 635
                    -- upvalues: AreaEggSlotsClient (copy), Workspace (copy)
                    AreaEggSlotsClient.Parent = Workspace
                end)
            end

            pcall(v21)
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
            p7:Add(function() -- line: 660
                -- upvalues: Vignette (copy)
                Vignette.Visible = false
                Vignette.ImageTransparency = 1
            end)

            local clone2 = ReplicatedStorage.CutsceneAssets.LightVSDarkness.LightVSDarkCutsceneEnd:Clone()

            clone2.Parent = Workspace
            clone = clone2
            p7:Add(clone2)
            TweenService:Create(Black, TweenInfo.new(0.1), {
                BackgroundTransparency = 0
            }):Play()
            p7:Add(function() -- line: 671
                -- upvalues: Black (copy)
                Black.BackgroundTransparency = 1
                Black.Visible = false
            end)

            local clone3 = LightVsDarkCutsceneEndRigs:Clone()

            for _, child in clone3:GetChildren() do
                if child:IsA("Model") and child.PrimaryPart then
                    child.PrimaryPart.Anchored = true
                end
            end

            clone3.Parent = workspace
            p7:Add(clone3)

            local t12 = {}

            for _, child in clone3:GetChildren() do
                local LightWinAnimation = child:FindFirstChild("LightWinAnimation")

                if LightWinAnimation then
                    table.insert(t12, LightWinAnimation)
                end
            end

            ContentProvider:PreloadAsync(t12)

            local t13 = {}

            for _, child in clone3:GetChildren() do
                local LightWinAnimation = child:FindFirstChild("LightWinAnimation")

                if LightWinAnimation then
                    t13[child] = LoadAnimationIntoRig(child, LightWinAnimation.AnimationId)
                end
            end

            local v22 = true

            p7:Add(function() -- line: 706
                -- upvalues: v22 (ref)
                v22 = false
            end)
            p7:Add(function() -- line: 707
                -- upvalues: v22 (ref), restoreCamera (copy)
                if v22 then
                    restoreCamera()
                end
            end)

            for _, v23 in t13 do
                v23:Play(0)
            end

            local v24 = t13[clone3["Camera Rig"]]

            assert(v24, "Camera Rig needs an Animation")

            local v25 = os.clock() + 2

            while v22 and v24.TimePosition <= 0 and os.clock() < v25 do
                RunService.RenderStepped:Wait()
            end

            CutsceneMusic:Play()

            local Cam = clone3["Camera Rig"].Cam
            local connection

            connection = RunService.RenderStepped:Connect(function() -- line: 734
                -- upvalues: v22 (ref), Cam (copy), connection (ref), CurrentCamera (copy), LocalPlayer (copy)
                if not v22 then
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
            local connection2 = RunService.Heartbeat:Connect(function(p14) -- line: 748
                -- upvalues: t13 (copy), t14 (copy), n1 (ref), n2 (ref), CutsceneMusic (copy), t9 (copy)
                n1 += p14
                n2 -= 0.1

                if n2 <= 0 then
                    n2 = 0.1

                    for _, v26 in t13 do
                        if v26.IsPlaying then
                            local v28 = n1

                            if math.abs(v28 - v26.TimePosition) >= 0.1 then
                                local function v29() -- line: 760
                                    -- upvalues: v26 (copy), n1 (ref)
                                    v26.TimePosition = n1
                                end

                                local _warn = warn

                                xpcall(v29, _warn)
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
                    local v31 = math.floor(n1 * 60 - i)

                    if t9[v31] and not t14[v31] then
                        t14[v31] = true

                        for _, v32 in t9[v31] do
                            task.spawn(v32)
                        end
                    end
                end
            end)

            p7:Add(connection2)
            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(26.983333333333334)
            connection2:Disconnect()

            local function v33() -- line: 792
                -- upvalues: clone2 (copy)
                clone2:Destroy()
            end

            local _warn2 = warn

            xpcall(v33, _warn2)
            v22 = false
            Vignette.Visible = false

            local function v34() -- line: 798
                -- upvalues: t11 (copy)
                for _, v35 in t11 do
                    v35:Destroy()
                end
            end

            local _warn3 = warn

            xpcall(v34, _warn3)

            local function v36() -- line: 804
                -- upvalues: clone3 (copy)
                clone3:Destroy()
            end

            local _warn4 = warn

            xpcall(v36, _warn4)

            local _warn5 = warn

            xpcall(restoreCamera, _warn5)

            local v37 = BulkFade.new(CutsceneUI.SammyIsComing, TweenInfo.new(1))

            v37:FadeOutInstant()
            task.wait()
            v37:FadeIn()
            CutsceneUI.SammyIsComing.Visible = true
            task.spawn(function() -- line: 814
                -- upvalues: CutsceneUI (copy)
                local function toDHMS(p15) -- line: 815
                    return string.format("%02i:%02i:%02i:%02i", p15 / 86400, p15 / 3600 % 24, p15 / 60 % 60, p15 % 60)
                end

                local n3 = 604799

                while CutsceneUI.SammyIsComing.Visible do
                    CutsceneUI.SammyIsComing.TimeRemaining.Text = toDHMS(n3)
                    script.ClockTick:Play()
                    task.wait(1)
                    n3 -= 1
                end
            end)
            task.wait(5)
            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            v37:FadeOut()
            task.delay(1, function() -- line: 840
                -- upvalues: v37 (copy), CutsceneUI (copy)
                CutsceneUI.SammyIsComing.Visible = false
                v37:FadeIn()
            end)
            task.wait(0.5)
            Black.Visible = false
            Vignette.Visible = false

            local function v38() -- line: 850
                -- upvalues: AreaEggSlotsClient (copy), Workspace (copy)
                AreaEggSlotsClient.Parent = Workspace
            end

            pcall(v38)

            local function v39() -- line: 854
                -- upvalues: v18 (ref), Tabs (copy), v1 (ref), restoreAllUi (copy)
                local v40 = restoreAllUi()
                local v41 = v1

                v1 = nil

                if v41 ~= nil then
                    v41()
                end

                if v40 ~= nil then
                    Tabs.Activate(v40, {
                        instant = true
                    })
                end

                v18 = true
            end

            local _warn6 = warn

            xpcall(v39, _warn6)
            restoreAllGuardsAndNests()

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
        end
    }
end
