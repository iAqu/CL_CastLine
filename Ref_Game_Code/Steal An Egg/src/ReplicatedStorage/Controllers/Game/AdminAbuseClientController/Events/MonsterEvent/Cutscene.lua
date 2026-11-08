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
local Remotes = require(ReplicatedStorage.Shared.Remotes)
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
    -- upvalues: ContentProvider (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), TweenService (copy), Workspace (copy), CutsceneHelperFunctions (copy), Tabs (copy), Remotes (copy), CurrentCamera (copy), LocalPlayer (copy), v1 (ref), restoreCamera (copy), restoreAllUi (copy), hideCutsceneUi (copy), setTransparency (copy)
    local v13 = CutsceneHelperFunctions.GetHelperFunctions(p3)
    local SetProperty, TweenProperty, _, LoadAnimationIntoRig = v13.SetProperty, v13.TweenProperty, v13.PlaySequenceAsync, v13.LoadAnimationIntoRig
    local MonsterEventCutscene = ReplicatedStorage.CutsceneAssets.MonsterEventCutscene
    local CutsceneUI = LocalPlayer.PlayerGui.CutsceneUI
    local CutsceneMusic = script.CutsceneMusic
    local Black, Vignette = CutsceneUI.Black, CutsceneUI.Vignette
    local clone
    local t8 = {
        [0] = {
            SetProperty("Workspace.CurrentCamera.FieldOfView", 45),
            function() -- line: 155
                -- upvalues: clone (ref)
                local ZZZ = clone:WaitForChild("ZZZ")

                for _, descendant in ipairs(ZZZ:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = true
                    end
                end
            end,
            SetProperty("Player.PlayerGui.CutsceneUI.Vignette.ImageColor3", Color3.new(0, 0, 0)),
            TweenProperty("Player.PlayerGui.CutsceneUI.Vignette.ImageColor3", TweenInfo.new(0.9666666666666667, Enum.EasingStyle.Linear), Color3.new(0.419608, 0.733246, 1)),
            SetProperty("Player.PlayerGui.CutsceneUI.Vignette.ImageTransparency", 0),
            SetProperty("Lighting.Blizzard.Enabled", true),
            SetProperty("Lighting.Blizzard.Saturation", 0.1),
            SetProperty("Lighting.Blizzard.Contrast", -0.1),
            SetProperty("Lighting.Blizzard.TintColor", Color3.new(0.811765, 0.94902, 0.988235)),
            SetProperty("Lighting.Blizzard.Brightness", 0.05),
            SetProperty("Lighting.CutsceneBlur.Enabled", true),
            SetProperty("Lighting.CutsceneBlur.Size", 25),
            SetProperty("Player.PlayerGui.CutsceneUI.Black.BackgroundTransparency", 0),
            TweenProperty("Player.PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.9666666666666667, Enum.EasingStyle.Linear), 1),
            SetProperty("Lighting.EndDepth.Enabled", false),
            SetProperty("Lighting.General.Enabled", true),
            SetProperty("Lighting.Orange.Enabled", false),
            SetProperty("Lighting.BlackOrange.Enabled", false),
            SetProperty("Lighting.Purple.Enabled", false),
            SetProperty("Lighting.BlackPurple.Enabled", false),
            SetProperty("Lighting.Black+White.Enabled", false),
            SetProperty("Lighting.White+Black.Enabled", false)
        },
        [23] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.7666666666666667, Enum.EasingStyle.Linear), 2) },
        [297] = {
            function() -- line: 191
                -- upvalues: clone (ref)
                local ZZZ = clone:WaitForChild("ZZZ")

                for _, descendant in ipairs(ZZZ:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = false
                    end
                end
            end
        },
        [300] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.31666666666666665, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), 12) },
        [311] = {
            function() -- line: 207
                -- upvalues: clone (ref)
                local Exclaim = clone.Exclaim

                local function check(p4) -- line: 210
                    return p4 ~= nil and p4 ~= 0
                end

                for _, descendant in Exclaim:GetDescendants() do
                    if descendant:IsA("ParticleEmitter") then
                        local EmitCount = descendant:GetAttribute("EmitCount")
                        local EmitDuration = descendant:GetAttribute("EmitDuration")

                        if EmitCount ~= nil and EmitCount ~= 0 then
                            descendant:Emit(EmitCount)
                        end

                        if EmitDuration ~= nil and EmitDuration ~= 0 then
                            descendant.Enabled = true
                            task.delay(EmitDuration, function() -- line: 225
                                -- upvalues: descendant (copy)
                                descendant.Enabled = false
                            end)
                        end
                    end
                end
            end
        },
        [319] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), 2) },
        [455] = { TweenProperty("Player.PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 1) },
        [596] = {
            TweenProperty("Player.PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 0),
            TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), 20)
        },
        [597] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), 2) },
        [627] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.08333333333333333, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), 15) },
        [631] = {
            function() -- line: 255
                -- upvalues: clone (ref)
                local Land = clone.Land

                local function check(p5) -- line: 258
                    return p5 ~= nil and p5 ~= 0
                end

                for _, descendant in pairs(Land:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        local EmitCount = descendant:GetAttribute("EmitCount")
                        local EmitDuration = descendant:GetAttribute("EmitDuration")

                        if EmitCount ~= nil and EmitCount ~= 0 then
                            descendant:Emit(EmitCount)
                        end

                        if EmitDuration ~= nil and EmitDuration ~= 0 then
                            descendant.Enabled = true
                            task.delay(EmitDuration, function() -- line: 273
                                -- upvalues: descendant (copy)
                                descendant.Enabled = false
                            end)
                        end
                    end
                end
            end
        },
        [645] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(1.0666666666666667, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), 5) },
        [781] = {
            function() -- line: 286
                -- upvalues: clone (ref)
                local Roar = clone:WaitForChild("Roar")

                for _, descendant in ipairs(Roar:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = true
                    end
                end
            end
        },
        [783] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.23333333333333334, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), 10) },
        [815] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.06666666666666667, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), 4) },
        [819] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.23333333333333334, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), 5) },
        [825] = {
            function() -- line: 310
                -- upvalues: clone (ref)
                local Roar = clone:WaitForChild("Roar")

                for _, descendant in ipairs(Roar:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = false
                    end
                end
            end
        },
        [827] = {
            function() -- line: 322
                -- upvalues: clone (ref)
                local Scream = clone:WaitForChild("Scream")

                for _, descendant in ipairs(Scream:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = true
                    end
                end
            end
        },
        [915] = {
            function() -- line: 334
                -- upvalues: clone (ref)
                local Scream = clone:WaitForChild("Scream")

                for _, descendant in ipairs(Scream:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = false
                    end
                end
            end,
            TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), 15)
        },
        [916] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(1.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), 5) },
        [1362] = {
            function() -- line: 351
                -- upvalues: clone (ref)
                local Roar2 = clone:WaitForChild("Roar2")

                for _, descendant in ipairs(Roar2:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = true
                    end
                end
            end
        },
        [1411] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.11666666666666667, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), 9) },
        [1413] = {
            function() -- line: 367
                -- upvalues: clone (ref)
                local Roar2 = clone:WaitForChild("Roar2")

                for _, descendant in ipairs(Roar2:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = false
                    end
                end
            end
        },
        [1414] = {
            function() -- line: 379
                -- upvalues: clone (ref)
                local TweenService = game:GetService("TweenService")
                local clone2 = clone

                if not clone2 then
                    warn("cutsceneVFX folder not found!")

                    return
                end

                local v14 = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

                local function halfTimeScale(p6) -- line: 397
                    -- upvalues: TweenService (copy), v14 (copy)
                    TweenService:Create(p6, v14, {
                        TimeScale = p6.TimeScale / 3
                    }):Play()
                end

                for _, descendant in ipairs(clone2:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        TweenService:Create(descendant, v14, {
                            TimeScale = descendant.TimeScale / 3
                        }):Play()
                    end
                end
            end
        },
        [1415] = {
            function() -- line: 416
                -- upvalues: clone (ref)
                local FirstPunch = clone.Punches.FirstPunch

                local function check(p7) -- line: 419
                    return p7 ~= nil and p7 ~= 0
                end

                for _, descendant in pairs(FirstPunch:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        local EmitCount = descendant:GetAttribute("EmitCount")
                        local EmitDuration = descendant:GetAttribute("EmitDuration")

                        if EmitCount ~= nil and EmitCount ~= 0 then
                            descendant:Emit(EmitCount)
                        end

                        if EmitDuration ~= nil and EmitDuration ~= 0 then
                            descendant.Enabled = true
                            task.delay(EmitDuration, function() -- line: 434
                                -- upvalues: descendant (copy)
                                descendant.Enabled = false
                            end)
                        end
                    end
                end
            end
        },
        [1418] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.9666666666666667, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), 5) },
        [1478] = { SetProperty("Lighting.General.Enabled", false) },
        [1479] = {
            function() -- line: 451
                -- upvalues: clone (ref)
                local TweenService = game:GetService("TweenService")
                local clone2 = clone

                if not clone2 then
                    warn("cutsceneVFX folder not found!")

                    return
                end

                local v16 = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

                local function doubleTimeScale(p8) -- line: 469
                    -- upvalues: TweenService (copy), v16 (copy)
                    TweenService:Create(p8, v16, {
                        TimeScale = p8.TimeScale * 3
                    }):Play()
                end

                for _, descendant in ipairs(clone2:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        TweenService:Create(descendant, v16, {
                            TimeScale = descendant.TimeScale * 3
                        }):Play()
                    end
                end
            end
        },
        [1483] = { SetProperty("Lighting.EndDepth.Enabled", true) },
        [1488] = {
            function() -- line: 492
                -- upvalues: clone (ref)
                local Smash = clone.Smash

                local function check(p9) -- line: 495
                    return p9 ~= nil and p9 ~= 0
                end

                for _, descendant in pairs(Smash:GetDescendants()) do
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
        [1489] = {
            function() -- line: 519
                -- upvalues: clone (ref)
                local Dust = clone.Dust

                local function check(p10) -- line: 522
                    return p10 ~= nil and p10 ~= 0
                end

                for _, descendant in pairs(Dust:GetDescendants()) do
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
        [1505] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.4666666666666667, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), 11) },
        [1533] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), 5) },
        [1683] = {
            TweenProperty("Lighting.Blizzard.Saturation", TweenInfo.new(1.65, Enum.EasingStyle.Linear), 0),
            TweenProperty("Lighting.Blizzard.Contrast", TweenInfo.new(1.65, Enum.EasingStyle.Linear), 0),
            TweenProperty("Lighting.Blizzard.TintColor", TweenInfo.new(1.65, Enum.EasingStyle.Linear), Color3.new(0.988235, 0.988235, 0.988235)),
            TweenProperty("Lighting.Blizzard.Brightness", TweenInfo.new(1.65, Enum.EasingStyle.Linear), 0)
        },
        [1693] = { TweenProperty("Player.PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(1.5666666666666667, Enum.EasingStyle.Linear), 1) },
        [1738] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.8833333333333333, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), 2) },
        [1782] = { SetProperty("Lighting.Blizzard.Enabled", false) },
        [1814] = { SetProperty("Lighting.White+Black.Enabled", true) },
        [1816] = {
            function() -- line: 577
                -- upvalues: clone (ref)
                local Punch1 = clone.Punches.Punch1

                local function check(p11) -- line: 580
                    return p11 ~= nil and p11 ~= 0
                end

                for _, descendant in pairs(Punch1:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        local EmitCount = descendant:GetAttribute("EmitCount")
                        local EmitDuration = descendant:GetAttribute("EmitDuration")

                        if EmitCount ~= nil and EmitCount ~= 0 then
                            descendant:Emit(EmitCount)
                        end

                        if EmitDuration ~= nil and EmitDuration ~= 0 then
                            descendant.Enabled = true
                            task.delay(EmitDuration, function() -- line: 595
                                -- upvalues: descendant (copy)
                                descendant.Enabled = false
                            end)
                        end
                    end
                end
            end,
            SetProperty("Lighting.BlackOrange.Enabled", true),
            SetProperty("Lighting.White+Black.Enabled", false)
        },
        [1818] = {
            function() -- line: 606
                -- upvalues: clone (ref)
                local Smoke = clone.Smoke

                local function check(p12) -- line: 609
                    return p12 ~= nil and p12 ~= 0
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
                            task.delay(EmitDuration, function() -- line: 624
                                -- upvalues: descendant (copy)
                                descendant.Enabled = false
                            end)
                        end
                    end
                end
            end,
            SetProperty("Lighting.Orange.Enabled", true),
            SetProperty("Lighting.BlackOrange.Enabled", false)
        },
        [1820] = { SetProperty("Lighting.Orange.Enabled", false) },
        [1854] = {
            function() -- line: 639
                -- upvalues: clone (ref)
                local Smoke2 = clone.Smoke2

                local function check(p13) -- line: 642
                    return p13 ~= nil and p13 ~= 0
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
                            task.delay(EmitDuration, function() -- line: 657
                                -- upvalues: descendant (copy)
                                descendant.Enabled = false
                            end)
                        end
                    end
                end
            end
        },
        [2033] = { SetProperty("Lighting.White+Black.Enabled", true) },
        [2034] = {
            function() -- line: 670
                -- upvalues: clone (ref)
                local Punch2 = clone.Punches.Punch2

                local function check(p14) -- line: 673
                    return p14 ~= nil and p14 ~= 0
                end

                for _, descendant in pairs(Punch2:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        local EmitCount = descendant:GetAttribute("EmitCount")
                        local EmitDuration = descendant:GetAttribute("EmitDuration")

                        if EmitCount ~= nil and EmitCount ~= 0 then
                            descendant:Emit(EmitCount)
                        end

                        if EmitDuration ~= nil and EmitDuration ~= 0 then
                            descendant.Enabled = true
                            task.delay(EmitDuration, function() -- line: 688
                                -- upvalues: descendant (copy)
                                descendant.Enabled = false
                            end)
                        end
                    end
                end
            end
        },
        [2035] = {
            SetProperty("Lighting.BlackPurple.Enabled", true),
            SetProperty("Lighting.White+Black.Enabled", false)
        },
        [2037] = {
            SetProperty("Lighting.Purple.Enabled", true),
            SetProperty("Lighting.BlackPurple.Enabled", false)
        },
        [2039] = { SetProperty("Lighting.Purple.Enabled", false) },
        [2041] = { SetProperty("Lighting.Black+White.Enabled", true) },
        [2043] = { SetProperty("Lighting.Black+White.Enabled", false) },
        [2052] = {
            function() -- line: 719
                -- upvalues: clone (ref)
                local Smoke3 = clone.Smoke3

                local function check(p15) -- line: 722
                    return p15 ~= nil and p15 ~= 0
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
                            task.delay(EmitDuration, function() -- line: 737
                                -- upvalues: descendant (copy)
                                descendant.Enabled = false
                            end)
                        end
                    end
                end
            end
        },
        [2160] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.08333333333333333, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), 10) },
        [2161] = { SetProperty("Lighting.White+Black.Enabled", true) },
        [2163] = {
            SetProperty("Lighting.Black+White.Enabled", true),
            SetProperty("Lighting.White+Black.Enabled", false)
        },
        [2165] = { SetProperty("Lighting.Black+White.Enabled", false) },
        [2166] = {
            function() -- line: 763
                -- upvalues: clone (ref)
                local Punch3 = clone.Punches.Punch3

                local function check(p16) -- line: 766
                    return p16 ~= nil and p16 ~= 0
                end

                for _, descendant in pairs(Punch3:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        local EmitCount = descendant:GetAttribute("EmitCount")
                        local EmitDuration = descendant:GetAttribute("EmitDuration")

                        if EmitCount ~= nil and EmitCount ~= 0 then
                            descendant:Emit(EmitCount)
                        end

                        if EmitDuration ~= nil and EmitDuration ~= 0 then
                            descendant.Enabled = true
                            task.delay(EmitDuration, function() -- line: 781
                                -- upvalues: descendant (copy)
                                descendant.Enabled = false
                            end)
                        end
                    end
                end
            end
        },
        [2167] = {
            function() -- line: 790
                -- upvalues: clone (ref)
                local Stomp = clone.Punches.Stomp

                local function check(p17) -- line: 793
                    return p17 ~= nil and p17 ~= 0
                end

                for _, descendant in pairs(Stomp:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        local EmitCount = descendant:GetAttribute("EmitCount")
                        local EmitDuration = descendant:GetAttribute("EmitDuration")

                        if EmitCount ~= nil and EmitCount ~= 0 then
                            descendant:Emit(EmitCount)
                        end

                        if EmitDuration ~= nil and EmitDuration ~= 0 then
                            descendant.Enabled = true
                            task.delay(EmitDuration, function() -- line: 808
                                -- upvalues: descendant (copy)
                                descendant.Enabled = false
                            end)
                        end
                    end
                end
            end,
            SetProperty("Lighting.Orange.Enabled", true)
        },
        [2169] = {
            SetProperty("Lighting.Orange.Enabled", false),
            SetProperty("Lighting.BlackOrange.Enabled", true)
        },
        [2171] = {
            SetProperty("Lighting.BlackOrange.Enabled", false),
            SetProperty("Lighting.White+Black.Enabled", true)
        },
        [2173] = { SetProperty("Lighting.White+Black.Enabled", false) },
        [2175] = { SetProperty("Lighting.BlackOrange.Enabled", true) },
        [2177] = { SetProperty("Lighting.BlackOrange.Enabled", false) },
        [2180] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.48333333333333334, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), 2) },
        [2183] = {
            function() -- line: 844
                -- upvalues: clone (ref)
                local Smoke4 = clone.Smoke4

                local function check(p18) -- line: 847
                    return p18 ~= nil and p18 ~= 0
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
                            task.delay(EmitDuration, function() -- line: 862
                                -- upvalues: descendant (copy)
                                descendant.Enabled = false
                            end)
                        end
                    end
                end
            end,
            TweenProperty("Player.PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.8333333333333334, Enum.EasingStyle.Linear), 0)
        }
    }

    return {
        Run = function() -- Run | line: 874
            -- upvalues: p3 (copy), LoadAnimationIntoRig (copy), MonsterEventCutscene (copy), CutsceneUI (copy), CutsceneMusic (copy), Black (copy), Vignette (copy), clone (ref), t8 (copy), ContentProvider (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), TweenService (copy), Workspace (copy), Tabs (copy), Remotes (copy), CurrentCamera (copy), LocalPlayer (copy), v1 (ref), restoreCamera (copy), restoreAllUi (copy), hideCutsceneUi (copy), setTransparency (copy)
            local v18 = false
            local _warn = warn

            xpcall(hideCutsceneUi, _warn)

            local MonsterEventMap = Workspace:FindFirstChild("MonsterEventMap")

            if MonsterEventMap then
                MonsterEventMap.WallStartVisual2.Transparency = 1
            end

            p3:Add(function() -- line: 884
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

            local function v21() -- line: 892
                -- upvalues: AreaEggSlotsClient (copy), p3 (copy), ReplicatedStorage (copy), Workspace (copy)
                AreaEggSlotsClient.Parent = ReplicatedStorage
                p3:Add(function() -- line: 894
                    -- upvalues: AreaEggSlotsClient (copy), Workspace (copy)
                    AreaEggSlotsClient.Parent = Workspace
                end)
            end

            pcall(v21)

            local Descendants = game.Workspace.World.Areas.GuardAreas.Snow.Nests:GetDescendants()

            setTransparency(Descendants, 1)
            p3:Add(function() -- line: 901
                -- upvalues: Descendants (copy), setTransparency (copy)
                setTransparency(Descendants)
            end)

            local function v22() -- line: 905
                -- upvalues: TweenService (copy), Workspace (copy)
                task.spawn(function() -- line: 906
                    -- upvalues: TweenService (copy), Workspace (copy)
                    local DragonEggEventMusic = Workspace:FindFirstChild("DragonEggEventMusic")

                    if DragonEggEventMusic then
                        TweenService:Create(DragonEggEventMusic, TweenInfo.new(1), {
                            Volume = 0
                        }):Play()
                    end
                end)
            end

            pcall(v22)

            local t10 = {}

            for _, child in script.LightingAssets:GetChildren() do
                if not Lighting:FindFirstChild(child.Name) then
                    local clone = child:Clone()

                    clone.Parent = Lighting
                    p3:Add(clone)
                    table.insert(t10, clone)
                end
            end

            CutsceneUI.Enabled = true
            Black.BackgroundTransparency = 1
            Black.Visible = true
            Vignette.Visible = true
            p3:Add(function() -- line: 932
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
            p3:Add(function() -- line: 943
                -- upvalues: Black (copy)
                Black.BackgroundTransparency = 1
                Black.Visible = false
            end)

            local clone3 = MonsterEventCutscene:Clone()

            for _, child in clone3:GetChildren() do
                if child:IsA("Model") and child.PrimaryPart then
                    child.PrimaryPart.Anchored = true
                end
            end

            clone3.Parent = workspace
            p3:Add(clone3)

            local t11 = {}

            for _, child in clone3:GetChildren() do
                local Animation = child:FindFirstChildOfClass("Animation")

                if Animation then
                    table.insert(t11, Animation)
                end
            end

            ContentProvider:PreloadAsync(t11)

            local t12 = {}

            for _, child in clone3:GetChildren() do
                local Animation = child:FindFirstChildOfClass("Animation")

                if Animation then
                    t12[child] = LoadAnimationIntoRig(child, Animation.AnimationId)
                end
            end

            local v23 = true

            p3:Add(function() -- line: 978
                -- upvalues: v23 (ref)
                v23 = false
            end)
            p3:Add(function() -- line: 979
                -- upvalues: v23 (ref), restoreCamera (copy)
                if v23 then
                    restoreCamera()
                end
            end)

            for _, v24 in t12 do
                v24:Play(0)
            end

            local v25 = t12[clone3["Camera Rig"]]

            assert(v25, "Camera Rig needs an Animation")

            local v26 = os.clock() + 2

            while v23 and v25.TimePosition <= 0 and os.clock() < v26 do
                RunService.RenderStepped:Wait()
            end

            CutsceneMusic:Play()

            local Cam = clone3["Camera Rig"].Cam
            local connection

            connection = RunService.RenderStepped:Connect(function() -- line: 1006
                -- upvalues: v23 (ref), Cam (copy), connection (ref), CurrentCamera (copy), LocalPlayer (copy)
                if not v23 then
                    connection:Disconnect()

                    return
                end

                CurrentCamera.CameraType = Enum.CameraType.Scriptable
                LocalPlayer.ReplicationFocus = Cam
                CurrentCamera.Focus = Cam.CFrame
                CurrentCamera.CFrame = Cam.CFrame
            end)

            local t13 = {}
            local n1 = 0
            local n2 = 0.1
            local connection2 = RunService.Heartbeat:Connect(function(p19) -- line: 1020
                -- upvalues: t12 (copy), t13 (copy), n1 (ref), n2 (ref), CutsceneMusic (copy), t8 (copy)
                n1 += p19
                n2 -= 0.1

                if n2 <= 0 then
                    n2 = 0.1

                    for _, v27 in t12 do
                        if v27.IsPlaying then
                            local v29 = n1

                            if math.abs(v29 - v27.TimePosition) >= 0.1 then
                                local function v30() -- line: 1032
                                    -- upvalues: v27 (copy), n1 (ref)
                                    v27.TimePosition = n1
                                end

                                local _warn = warn

                                xpcall(v30, _warn)
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
                    local v32 = math.floor(n1 * 60 - i)

                    if t8[v32] and not t13[v32] then
                        t13[v32] = true

                        for _, v33 in t8[v32] do
                            task.spawn(v33)
                        end
                    end
                end
            end)

            p3:Add(connection2)
            task.wait(37.516666666666666)
            connection2:Disconnect()

            local function v34() -- line: 1062
                -- upvalues: clone2 (copy)
                clone2:Destroy()
            end

            local _warn2 = warn

            xpcall(v34, _warn2)
            v23 = false
            Vignette.Visible = false

            local function v35() -- line: 1068
                -- upvalues: t10 (copy)
                for _, v36 in t10 do
                    v36:Destroy()
                end
            end

            local _warn3 = warn

            xpcall(v35, _warn3)

            local function v37() -- line: 1074
                -- upvalues: clone3 (copy)
                clone3:Destroy()
            end

            local _warn4 = warn

            xpcall(v37, _warn4)

            local function v38() -- line: 1076
                -- upvalues: TweenService (copy), Workspace (copy)
                task.spawn(function() -- line: 1077
                    -- upvalues: TweenService (copy), Workspace (copy)
                    local DragonEggEventMusic = Workspace:FindFirstChild("DragonEggEventMusic")

                    if DragonEggEventMusic then
                        TweenService:Create(DragonEggEventMusic, TweenInfo.new(1), {
                            Volume = 0.5
                        }):Play()
                    end
                end)
            end

            pcall(v38)

            local _warn5 = warn

            xpcall(restoreCamera, _warn5)

            local v39 = false

            task.spawn(function() -- line: 1089
                -- upvalues: v39 (ref), Remotes (copy)
                Remotes.MonsterEvent.RequestTeleport:InvokeServer()
                v39 = true
            end)

            local n3 = 0

            while not v39 and n3 < 5 do
                n3 += task.wait()
            end

            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()

            local MonsterEventMap2 = Workspace:FindFirstChild("MonsterEventMap")

            if MonsterEventMap2 then
                MonsterEventMap2.WallStartVisual2.Transparency = 0
            end

            task.wait(0.5)
            Black.Visible = false
            Vignette.Visible = false

            local function v40() -- line: 1110
                -- upvalues: AreaEggSlotsClient (copy), Workspace (copy)
                AreaEggSlotsClient.Parent = Workspace
            end

            pcall(v40)

            local function v41() -- line: 1114
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

            local _warn6 = warn

            xpcall(v41, _warn6)
            setTransparency(Descendants)
        end
    }
end
