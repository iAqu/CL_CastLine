-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContentProvider = game:GetService("ContentProvider")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local CutsceneHelperFunctions = require(script.Parent.Parent.Parent.CutsceneHelperFunctions)

require(ReplicatedStorage.Packages.Trove)

local CurrentCamera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local function restoreCamera() -- line: 24
    -- upvalues: TweenService (copy), CurrentCamera (copy), LocalPlayer (copy)
    TweenService:Create(CurrentCamera, TweenInfo.new(0), {
        FieldOfView = 70
    }):Play()
    CurrentCamera.FieldOfView = 70
    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") or nil
    LocalPlayer.ReplicationFocus = nil
end

local function cloneCharacterRig(p1) -- line: 35
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if Character == nil or Humanoid == nil or Character.PrimaryPart == nil then
        return nil
    end

    local Archivable = Character.Archivable

    Character.Archivable = true

    local clone = Character:Clone()

    Character.Archivable = Archivable
    clone.Name = p1.Name

    for _, child in ipairs(clone:GetChildren()) do
        if child:IsA("LocalScript") then
            child:Destroy()
        elseif child:IsA("Script") then
            child:Destroy()
        elseif child:IsA("Tool") then
            child:Destroy()
        end
    end

    local Humanoid2 = clone:FindFirstChildOfClass("Humanoid")

    assert(Humanoid2, "Cloned character lost its Humanoid")
    Humanoid2.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

    if Humanoid2:FindFirstChildOfClass("Animator") == nil then
        Instance.new("Animator").Parent = Humanoid2
    end

    for _, descendant in ipairs(clone:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Anchored = descendant == clone.PrimaryPart
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
            descendant.LocalTransparencyModifier = 0
        end
    end

    local Animation = p1:FindFirstChildOfClass("Animation")

    assert(Animation, (("%* needs an Animation child"):format(p1.Name)))
    Animation:Clone().Parent = clone
    clone:PivotTo(p1:GetPivot())

    return clone
end

local function hideCharacter(p2) -- line: 74
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character

    if Character == nil then
        return function() -- line: 77
        end
    end

    local t1 = {}

    for _, descendant in ipairs(Character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            t1[descendant] = descendant.LocalTransparencyModifier
            descendant.LocalTransparencyModifier = 1
        elseif descendant:IsA("Decal") then
            t1[descendant] = descendant.Transparency
            descendant.Transparency = 1
        end
    end

    local function restore() -- line: 89
        -- upvalues: t1 (copy)
        for v2, v3 in t1 do
            if v2.Parent then
                if v2:IsA("BasePart") then
                    v2.LocalTransparencyModifier = v3
                elseif v2:IsA("Decal") then
                    v2.Transparency = v3
                end
            end
        end
    end

    p2:Add(restore)

    return restore
end

return function(p3) -- line: 106
    -- upvalues: ContentProvider (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), TweenService (copy), Workspace (copy), CutsceneHelperFunctions (copy), CurrentCamera (copy), LocalPlayer (copy), restoreCamera (copy), hideCharacter (copy)
    local v4 = CutsceneHelperFunctions.GetHelperFunctions(p3)
    local SetProperty, TweenProperty, _, LoadAnimationIntoRig = v4.SetProperty, v4.TweenProperty, v4.PlaySequenceAsync, v4.LoadAnimationIntoRig
    local DragonEggEventCutscene1 = ReplicatedStorage.CutsceneAssets.DragonEggEvent.DragonEggEventCutscene1
    local CutsceneUI = LocalPlayer.PlayerGui.CutsceneUI
    local CutsceneMusic = script.CutsceneMusic
    local Black = CutsceneUI.Black
    local clone
    local t2 = {
        [0] = {
            SetProperty("Workspace.CurrentCamera.FieldOfView", 35),
            TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(1.2666666666666666, Enum.EasingStyle.Linear), 80.84581),
            SetProperty("Workspace.World.Build.AAEventProps.DragonCave.Door.LeftDoor.Meshes/untitled2_Walls102.CFrame", CFrame.new(3526.5938, 86.4341, -373.0499, 0, 0, 1, 0, 1, -0, -1, 0, 0)),
            TweenProperty("Workspace.World.Build.AAEventProps.DragonCave.Door.LeftDoor.Meshes/untitled2_Walls102.CFrame", TweenInfo.new(5.35, Enum.EasingStyle.Linear), CFrame.new(3514.3865, 86.4341, -383.3008, 0.9781, 0, 0.2079, 0, 1, 0, -0.2079, 0, 0.9781)),
            SetProperty("Workspace.World.Build.AAEventProps.DragonCave.Door.LeftDoor.Meshes/untitled_Walls100 (2).CFrame", CFrame.new(3527.27, 90.0758, -374.963, -0, 0, 1, 0, 1, 0, -1, 0, -0)),
            TweenProperty("Workspace.World.Build.AAEventProps.DragonCave.Door.LeftDoor.Meshes/untitled_Walls100 (2).CFrame", TweenInfo.new(5.35, Enum.EasingStyle.Linear), CFrame.new(3516.3984, 90.0758, -383.037, 0.9781, 0, 0.2079, 0, 1, 0, -0.2079, 0, 0.9781)),
            SetProperty("Workspace.World.Build.AAEventProps.DragonCave.Door.LeftDoor.Meshes/untitled_Walls103.CFrame", CFrame.new(3526.6228, 84.8732, -373.5785, -0, 0, 1, 0, 1, 0, -1, 0, -0)),
            TweenProperty("Workspace.World.Build.AAEventProps.DragonCave.Door.LeftDoor.Meshes/untitled_Walls103.CFrame", TweenInfo.new(5.35, Enum.EasingStyle.Linear), CFrame.new(3514.9097, 84.8732, -383.3822, 0.9781, 0, 0.2079, 0, 1, 0, -0.2079, 0, 0.9781)),
            SetProperty("Workspace.World.Build.AAEventProps.DragonCave.Door.LeftDoor.Meshes/untitled_Walls104.CFrame", CFrame.new(3526.4937, 86.4515, -369.8316, -0, 0, 1, 0, 1, 0, -1, 0, -0)),
            TweenProperty("Workspace.World.Build.AAEventProps.DragonCave.Door.LeftDoor.Meshes/untitled_Walls104.CFrame", TweenInfo.new(5.35, Enum.EasingStyle.Linear), CFrame.new(3511.2178, 86.4515, -382.7296, 0.9781, 0, 0.2079, 0, 1, 0, -0.2079, 0, 0.9781)),
            SetProperty("Workspace.World.Build.AAEventProps.DragonCave.Door.LeftDoor.Meshes/untitled_Walls105.CFrame", CFrame.new(3526.3276, 86.4762, -364.6917, -0, 0, 1, 0, 1, 0, -1, 0, -0)),
            TweenProperty("Workspace.World.Build.AAEventProps.DragonCave.Door.LeftDoor.Meshes/untitled_Walls105.CFrame", TweenInfo.new(5.35, Enum.EasingStyle.Linear), CFrame.new(3506.1558, 86.4762, -381.8233, 0.9781, 0, 0.2079, 0, 1, 0, -0.2079, 0, 0.9781)),
            SetProperty("Workspace.World.Build.AAEventProps.DragonCave.Door.LeftDoor.Meshes/untitled_Walls106.CFrame", CFrame.new(3526.365, 88.1662, -374.3624, -0, 0, 1, 0, 1, 0, -1, 0, -0)),
            TweenProperty("Workspace.World.Build.AAEventProps.DragonCave.Door.LeftDoor.Meshes/untitled_Walls106.CFrame", TweenInfo.new(5.35, Enum.EasingStyle.Linear), CFrame.new(3515.6228, 88.1662, -383.7974, 0.9781, 0, 0.2079, 0, 1, 0, -0.2079, 0, 0.9781)),
            SetProperty("Workspace.World.Build.AAEventProps.DragonCave.Door.LeftDoor.Meshes/untitled_Walls107.CFrame", CFrame.new(3526.3193, 89.4656, -369.1417, -0, 0, 1, 0, 1, 0, -1, 0, -0)),
            TweenProperty("Workspace.World.Build.AAEventProps.DragonCave.Door.LeftDoor.Meshes/untitled_Walls107.CFrame", TweenInfo.new(5.35, Enum.EasingStyle.Linear), CFrame.new(3510.5066, 89.4656, -382.7566, 0.9781, 0, 0.2079, 0, 1, 0, -0.2079, 0, 0.9781)),
            SetProperty("Workspace.World.Build.AAEventProps.DragonCave.Door.RightDoor.right1.CFrame", CFrame.new(3526.5938, 86.4341, -355.3767, 0, 0, 1, 0, 1, -0, -1, 0, 0)),
            TweenProperty("Workspace.World.Build.AAEventProps.DragonCave.Door.RightDoor.right1.CFrame", TweenInfo.new(5.35, Enum.EasingStyle.Linear), CFrame.new(3514.4778, 86.4341, -345.5578, -0.9703, 0, 0.2419, 0, 1, 0, -0.2419, 0, -0.9703)),
            SetProperty("Workspace.World.Build.AAEventProps.DragonCave.Door.RightDoor.right2.CFrame", CFrame.new(3527.27, 90.0758, -353.463, -0, 0, 1, 0, 1, 0, -1, 0, -0)),
            TweenProperty("Workspace.World.Build.AAEventProps.DragonCave.Door.RightDoor.right2.CFrame", TweenInfo.new(5.35, Enum.EasingStyle.Linear), CFrame.new(3516.4983, 90.0758, -345.751, -0.9703, 0, 0.2419, 0, 1, 0, -0.2419, 0, -0.9703)),
            SetProperty("Workspace.World.Build.AAEventProps.DragonCave.Door.RightDoor.right3.CFrame", CFrame.new(3526.6228, 84.8732, -354.8475, -0, 0, 1, 0, 1, 0, -1, 0, -0)),
            TweenProperty("Workspace.World.Build.AAEventProps.DragonCave.Door.RightDoor.right3.CFrame", TweenInfo.new(5.35, Enum.EasingStyle.Linear), CFrame.new(3514.9985, 84.8732, -345.458, -0.9703, 0, 0.2419, 0, 1, 0, -0.2419, 0, -0.9703)),
            SetProperty("Workspace.World.Build.AAEventProps.DragonCave.Door.RightDoor.right4.CFrame", CFrame.new(3526.4937, 86.4515, -358.5941, -0, 0, 1, 0, 1, 0, -1, 0, -0)),
            TweenProperty("Workspace.World.Build.AAEventProps.DragonCave.Door.RightDoor.right4.CFrame", TweenInfo.new(5.35, Enum.EasingStyle.Linear), CFrame.new(3511.3318, 86.4515, -346.2393, -0.9703, 0, 0.2419, 0, 1, 0, -0.2419, 0, -0.9703)),
            SetProperty("Workspace.World.Build.AAEventProps.DragonCave.Door.RightDoor.right5.CFrame", CFrame.new(3526.3276, 86.4762, -363.7342, -0, 0, 1, 0, 1, 0, -1, 0, -0)),
            TweenProperty("Workspace.World.Build.AAEventProps.DragonCave.Door.RightDoor.right5.CFrame", TweenInfo.new(5.35, Enum.EasingStyle.Linear), CFrame.new(3506.3042, 86.4762, -347.3215, -0.9703, 0, 0.2419, 0, 1, 0, -0.2419, 0, -0.9703)),
            SetProperty("Workspace.World.Build.AAEventProps.DragonCave.Door.RightDoor.right6.CFrame", CFrame.new(3526.365, 88.1662, -354.0636, -0, 0, 1, 0, 1, 0, -1, 0, -0)),
            TweenProperty("Workspace.World.Build.AAEventProps.DragonCave.Door.RightDoor.right6.CFrame", TweenInfo.new(5.35, Enum.EasingStyle.Linear), CFrame.new(3515.6965, 88.1662, -345.0182, -0.9703, 0, 0.2419, 0, 1, 0, -0.2419, 0, -0.9703)),
            SetProperty("Workspace.World.Build.AAEventProps.DragonCave.Door.RightDoor.right7.CFrame", CFrame.new(3526.3193, 89.4657, -359.2843, -0, 0, 1, 0, 1, 0, -1, 0, -0)),
            TweenProperty("Workspace.World.Build.AAEventProps.DragonCave.Door.RightDoor.right7.CFrame", TweenInfo.new(5.35, Enum.EasingStyle.Linear), CFrame.new(3510.6201, 89.4657, -346.237, -0.9703, 0, 0.2419, 0, 1, 0, -0.2419, 0, -0.9703)),
            function() -- line: 256
                -- upvalues: clone (ref)
                local DoorOpenSmoke = clone.DoorOpenSmoke

                local function check(p4) -- line: 259
                    return p4 ~= nil and p4 ~= 0
                end

                for _, descendant in DoorOpenSmoke:GetDescendants() do
                    if descendant:IsA("ParticleEmitter") then
                        local EmitCount = descendant:GetAttribute("EmitCount")
                        local EmitDuration = descendant:GetAttribute("EmitDuration")

                        if EmitCount ~= nil and EmitCount ~= 0 then
                            descendant:Emit(EmitCount)
                        end

                        if EmitDuration ~= nil and EmitDuration ~= 0 then
                            descendant.Enabled = true
                            task.delay(EmitDuration, function() -- line: 274
                                -- upvalues: descendant (copy)
                                descendant.Enabled = false
                            end)
                        end
                    end
                end
            end,
            SetProperty("Lighting.dragondepth.Enabled", false),
            SetProperty("Lighting.dragondepth.InFocusRadius", 20),
            SetProperty("Workspace.DragonEggEventCutscene1.cutscene1egg.Highlight.Enabled", false),
            SetProperty("Workspace.DragonEggEventCutscene1.cutscene1egg.Highlight.FillTransparency", 0.5),
            TweenProperty("Workspace.DragonEggEventCutscene1.cutscene1egg.Highlight.FillTransparency", TweenInfo.new(7.583333333333333, Enum.EasingStyle.Linear), 1),
            SetProperty("Workspace.DragonEggEventCutscene1.cutscene1egg.Highlight.OutlineTransparency", 0),
            TweenProperty("Workspace.DragonEggEventCutscene1.cutscene1egg.Highlight.OutlineTransparency", TweenInfo.new(7.583333333333333, Enum.EasingStyle.Linear), 1),
            SetProperty("Lighting.ThirdPoV.Enabled", false),
            SetProperty("Lighting.ThirdPoV.InFocusRadius", 50),
            SetProperty("Lighting.ThirdPoV.FocusDistance", 200),
            SetProperty("Lighting.1.Enabled", true),
            SetProperty("Lighting.1.InFocusRadius", 50),
            SetProperty("Lighting.1.FocusDistance", 25),
            SetProperty("Workspace.CutsceneVFX.Fly.CFrame", CFrame.new(3632.9419, 20.3041, -371.646, -0.1736, 0, 0.9848, 0, 1, 0, -0.9848, 0, -0.1736)),
            SetProperty("Workspace.CutsceneVFX.Charge.CFrame", CFrame.new(3407.4592, 101.738, -375.0436, 1, 0, 0, 0, 1, 0, 0, 0, 1)),
            SetProperty("Workspace.CutsceneVFX.Wave.CFrame", CFrame.new(3395.644, -3.5316, -364.8042, 1, 0, 0, 0, 1, 0, 0, 0, 1)),
            SetProperty("Lighting.CutsceneBlur.Enabled", true),
            SetProperty("Lighting.CutsceneBlur.Size", 2),
            SetProperty("Lighting.BLACK.Enabled", false),
            SetProperty("Lighting.WHITE.Enabled", false),
            SetProperty("Lighting.Black+White.Enabled", false),
            SetProperty("Lighting.White+Black.Enabled", false),
            SetProperty("Lighting.red.Enabled", false),
            SetProperty("Lighting.Whitered.Enabled", false),
            SetProperty("Lighting.Whitered.Saturation", -1.1),
            TweenProperty("Lighting.Whitered.Saturation", TweenInfo.new(49.38333333333333, Enum.EasingStyle.Linear), 0),
            SetProperty("Lighting.Whitered.Contrast", -1E+06),
            TweenProperty("Lighting.Whitered.Contrast", TweenInfo.new(49.38333333333333, Enum.EasingStyle.Linear), 0),
            SetProperty("Lighting.Whitered.TintColor", Color3.new(1, 1, 1)),
            SetProperty("Lighting.Whitered.Brightness", 0)
        },
        [76] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 80.64736) },
        [82] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 80.46038) },
        [88] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 80.22632) },
        [94] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 79.80621) },
        [100] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 78.99367) },
        [106] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 77.62277) },
        [112] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 75.68993) },
        [118] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 73.3545) },
        [124] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 70.81742) },
        [130] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 68.21306) },
        [136] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 65.59524) },
        [142] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(1.2, Enum.EasingStyle.Linear), 34.16667) },
        [214] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 31.56664) },
        [220] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 29.09974) },
        [226] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 27.03225) },
        [232] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 25.63041) },
        [238] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.05, Enum.EasingStyle.Linear), 25.26233) },
        [241] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 24.72586) },
        [247] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 24.47468) },
        [253] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.05, Enum.EasingStyle.Linear), 24.3586) },
        [256] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.05, Enum.EasingStyle.Linear), 24.26451) },
        [259] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 24.07752) },
        [265] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 23.94988) },
        [271] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 23.84164) },
        [277] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 23.7417) },
        [283] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.13333333333333333, Enum.EasingStyle.Linear), 23.61215) },
        [291] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 23.50904) },
        [297] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.05, Enum.EasingStyle.Linear), 23.45451) },
        [300] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.05, Enum.EasingStyle.Linear), 23.39405) },
        [303] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 23.16991) },
        [309] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 22.78801) },
        [315] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 22.7113) },
        [316] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.05, Enum.EasingStyle.Linear), 22.47363) },
        [319] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 21.96249) },
        [325] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.06666666666666667, Enum.EasingStyle.Linear), 21.60656) },
        [329] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.3, Enum.EasingStyle.Linear), 20) },
        [365] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(1.4166666666666667, Enum.EasingStyle.Back, Enum.EasingDirection.In), 15.9003) },
        [450] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.In), 13.47454) },
        [455] = {
            SetProperty("Workspace.DragonEggEventCutscene1.cutscene1egg.Highlight.Enabled", true),
            TweenProperty("Workspace.DragonEggEventCutscene1.cutscene1egg.Highlight.FillTransparency", TweenInfo.new(0.15, Enum.EasingStyle.Linear), 0.4),
            TweenProperty("Workspace.DragonEggEventCutscene1.cutscene1egg.Highlight.OutlineTransparency", TweenInfo.new(0.15, Enum.EasingStyle.Linear), 0)
        },
        [456] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.05, Enum.EasingStyle.Back, Enum.EasingDirection.In), 12.3416) },
        [459] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.05, Enum.EasingStyle.Back, Enum.EasingDirection.In), 11.20867) },
        [462] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.05, Enum.EasingStyle.Back, Enum.EasingDirection.In), 10.54439) },
        [464] = {
            function() -- line: 681
                -- upvalues: clone (ref)
                local Shimmer = clone.Shimmer

                local function check(p5) -- line: 684
                    return p5 ~= nil and p5 ~= 0
                end

                for _, descendant in Shimmer:GetDescendants() do
                    if descendant:IsA("ParticleEmitter") then
                        local EmitCount = descendant:GetAttribute("EmitCount")
                        local EmitDuration = descendant:GetAttribute("EmitDuration")

                        if EmitCount ~= nil and EmitCount ~= 0 then
                            descendant:Emit(EmitCount)
                        end

                        if EmitDuration ~= nil and EmitDuration ~= 0 then
                            descendant.Enabled = true
                            task.delay(EmitDuration, function() -- line: 699
                                -- upvalues: descendant (copy)
                                descendant.Enabled = false
                            end)
                        end
                    end
                end
            end,
            TweenProperty("Workspace.DragonEggEventCutscene1.cutscene1egg.Highlight.FillTransparency", TweenInfo.new(0.21666666666666667, Enum.EasingStyle.Linear), 1),
            TweenProperty("Workspace.DragonEggEventCutscene1.cutscene1egg.Highlight.OutlineTransparency", TweenInfo.new(0.21666666666666667, Enum.EasingStyle.Linear), 1)
        },
        [465] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.In), 9.65424) },
        [471] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.05, Enum.EasingStyle.Back, Enum.EasingDirection.In), 9.47588) },
        [474] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.In), 9.19042) },
        [477] = { SetProperty("Workspace.DragonEggEventCutscene1.cutscene1egg.Highlight.Enabled", false) },
        [480] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.In), 9) },
        [486] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In), 8) },
        [522] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Back, Enum.EasingDirection.In), 40) },
        [523] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(2.216666666666667, Enum.EasingStyle.Back, Enum.EasingDirection.In), 45) },
        [670] = {
            function() -- line: 776
                -- upvalues: clone (ref)
                local ZZZ = clone:WaitForChild("ZZZ")

                for _, child in ipairs(ZZZ:GetChildren()) do
                    if child:IsA("ParticleEmitter") then
                        child.Enabled = true
                    end
                end
            end
        },
        [721] = { SetProperty("Lighting.ThirdPoV.Enabled", true) },
        [780] = { TweenProperty("Lighting.ThirdPoV.FocusDistance", TweenInfo.new(0.38333333333333336, Enum.EasingStyle.Linear), 0) },
        [858] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Back, Enum.EasingDirection.In), 25) },
        [859] = { SetProperty("Lighting.ThirdPoV.Enabled", false) },
        [1264] = {
            SetProperty("Lighting.dragondepth.Enabled", true),
            SetProperty("Lighting.1.Enabled", false)
        },
        [1376] = { TweenProperty("Lighting.dragondepth.InFocusRadius", TweenInfo.new(2.033333333333333, Enum.EasingStyle.Linear), 13) },
        [1571] = {
            function() -- line: 825
                -- upvalues: clone (ref)
                local Mud = clone.Mud

                local function check(p6) -- line: 828
                    return p6 ~= nil and p6 ~= 0
                end

                for _, descendant in Mud:GetDescendants() do
                    if descendant:IsA("ParticleEmitter") then
                        local EmitCount = descendant:GetAttribute("EmitCount")
                        local EmitDuration = descendant:GetAttribute("EmitDuration")

                        if EmitCount ~= nil and EmitCount ~= 0 then
                            descendant:Emit(EmitCount)
                        end

                        if EmitDuration ~= nil and EmitDuration ~= 0 then
                            descendant.Enabled = true
                            task.delay(EmitDuration, function() -- line: 843
                                -- upvalues: descendant (copy)
                                descendant.Enabled = false
                            end)
                        end
                    end
                end
            end
        },
        [1573] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.9666666666666667, Enum.EasingStyle.Linear), 0.5) },
        [1576] = {
            function() -- line: 858
                -- upvalues: clone (ref)
                local ZZZ = clone:WaitForChild("ZZZ")

                for _, child in ipairs(ZZZ:GetChildren()) do
                    if child:IsA("ParticleEmitter") then
                        child.Enabled = false
                    end
                end
            end
        },
        [1590] = { TweenProperty("Lighting.dragondepth.InFocusRadius", TweenInfo.new(0.7166666666666667, Enum.EasingStyle.Linear), 50) },
        [1686] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(3.533333333333333, Enum.EasingStyle.Back, Enum.EasingDirection.In), 40) },
        [1807] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(1.5333333333333334, Enum.EasingStyle.Linear), 0) },
        [1898] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Back, Enum.EasingDirection.In), 15) },
        [1899] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(4.05, Enum.EasingStyle.Back, Enum.EasingDirection.In), 25) },
        [1929] = {
            function() -- line: 910
                -- upvalues: clone (ref)
                local Takeoff = clone.Takeoff

                local function check(p7) -- line: 913
                    return p7 ~= nil and p7 ~= 0
                end

                for _, descendant in Takeoff:GetDescendants() do
                    if descendant:IsA("ParticleEmitter") then
                        local EmitCount = descendant:GetAttribute("EmitCount")
                        local EmitDuration = descendant:GetAttribute("EmitDuration")

                        if EmitCount ~= nil and EmitCount ~= 0 then
                            descendant:Emit(EmitCount)
                        end

                        if EmitDuration ~= nil and EmitDuration ~= 0 then
                            descendant.Enabled = true
                            task.delay(EmitDuration, function() -- line: 928
                                -- upvalues: descendant (copy)
                                descendant.Enabled = false
                            end)
                        end
                    end
                end
            end
        },
        [2120] = {
            function() -- line: 935
                -- upvalues: clone (ref)
                local Fly = clone:WaitForChild("Fly")

                for _, descendant in ipairs(Fly:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = true
                    end
                end
            end
        },
        [2130] = { TweenProperty("Workspace.CutsceneVFX.Fly.CFrame", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), CFrame.new(3632.9526, 76.9216, -371.6479, -0.1736, 0, 0.9848, 0, 1, 0, -0.9848, 0, -0.1736)) },
        [2131] = { TweenProperty("Workspace.CutsceneVFX.Fly.CFrame", TweenInfo.new(0.06666666666666667, Enum.EasingStyle.Linear), CFrame.new(3610.0322, 76.9216, -367.6064, -0.1736, 0, 0.9848, 0, 1, 0, -0.9848, 0, -0.1736)) },
        [2135] = {
            TweenProperty("Workspace.CutsceneVFX.Fly.CFrame", TweenInfo.new(0.05, Enum.EasingStyle.Linear), CFrame.new(3582.1382, 76.9216, -364.7979, -0.1736, 0, 0.9848, 0, 1, 0, -0.9848, 0, -0.1736)),
            SetProperty("Lighting.White+Black.Enabled", true)
        },
        [2137] = {
            SetProperty("Lighting.Black+White.Enabled", true),
            SetProperty("Lighting.White+Black.Enabled", false)
        },
        [2138] = { TweenProperty("Workspace.CutsceneVFX.Fly.CFrame", TweenInfo.new(0.05, Enum.EasingStyle.Linear), CFrame.new(3554.259, 76.9216, -363.7752, -0.0367, 0, 0.9993, 0, 1, 0, -0.9993, 0, -0.0367)) },
        [2139] = {
            SetProperty("Lighting.Black+White.Enabled", false),
            SetProperty("Lighting.red.Enabled", true)
        },
        [2141] = {
            TweenProperty("Workspace.CutsceneVFX.Fly.CFrame", TweenInfo.new(0.15, Enum.EasingStyle.Linear), CFrame.new(3535.5564, 76.9216, -363.0892, -0.0367, 0, 0.9993, 0, 1, 0, -0.9993, 0, -0.0367)),
            SetProperty("Lighting.red.Enabled", false)
        },
        [2142] = {
            TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(2.466666666666667, Enum.EasingStyle.Back, Enum.EasingDirection.In), 22),
            function() -- line: 1005
                -- upvalues: clone (ref)
                local Fly = clone:WaitForChild("Fly")

                for _, descendant in ipairs(Fly:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = false
                    end
                end
            end
        },
        [2181] = {
            function() -- line: 1017
                -- upvalues: clone (ref)
                local EggDrop = clone.EggDrop

                local function check(p8) -- line: 1020
                    return p8 ~= nil and p8 ~= 0
                end

                for _, descendant in EggDrop:GetDescendants() do
                    if descendant:IsA("ParticleEmitter") then
                        local EmitCount = descendant:GetAttribute("EmitCount")
                        local EmitDuration = descendant:GetAttribute("EmitDuration")

                        if EmitCount ~= nil and EmitCount ~= 0 then
                            descendant:Emit(EmitCount)
                        end

                        if EmitDuration ~= nil and EmitDuration ~= 0 then
                            descendant.Enabled = true
                            task.delay(EmitDuration, function() -- line: 1035
                                -- upvalues: descendant (copy)
                                descendant.Enabled = false
                            end)
                        end
                    end
                end
            end
        },
        [2290] = { TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(9.933333333333334, Enum.EasingStyle.Back, Enum.EasingDirection.In), 28) },
        [2344] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.75, Enum.EasingStyle.Linear), 0.4) },
        [2357] = { TweenProperty("Lighting.dragondepth.InFocusRadius", TweenInfo.new(1, Enum.EasingStyle.Linear), 250) },
        [2389] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(5.933333333333334, Enum.EasingStyle.Linear), 0.4) },
        [2417] = { TweenProperty("Lighting.dragondepth.InFocusRadius", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 20) },
        [2568] = { TweenProperty("Lighting.dragondepth.InFocusRadius", TweenInfo.new(1.2333333333333334, Enum.EasingStyle.Linear), 300) },
        [2635] = { SetProperty("Lighting.White+Black.Enabled", true) },
        [2637] = {
            function() -- line: 1094
                -- upvalues: clone (ref)
                local Charge = clone:WaitForChild("Charge")

                for _, descendant in ipairs(Charge:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = true
                    end
                end
            end,
            SetProperty("Lighting.Black+White.Enabled", true),
            SetProperty("Lighting.White+Black.Enabled", false)
        },
        [2639] = {
            SetProperty("Lighting.Black+White.Enabled", false),
            SetProperty("Lighting.White+Black.Enabled", true)
        },
        [2641] = {
            SetProperty("Lighting.White+Black.Enabled", false),
            SetProperty("Lighting.red.Enabled", true)
        },
        [2643] = { SetProperty("Lighting.red.Enabled", false) },
        [2647] = { TweenProperty("Workspace.CutsceneVFX.Charge.CFrame", TweenInfo.new(1.9666666666666666, Enum.EasingStyle.Linear), CFrame.new(3403.1526, 101.738, -375.0436, 1, 0, 0, 0, 1, 0, 0, 0, 1)) },
        [2745] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(1.4333333333333333, Enum.EasingStyle.Linear), 1) },
        [2766] = { TweenProperty("Workspace.CutsceneVFX.Wave.CFrame", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), CFrame.new(3395.645, 87.3247, -364.8042, 1, 0, 0, 0, 1, 0, 0, 0, 1)) },
        [2767] = { TweenProperty("Workspace.CutsceneVFX.Wave.CFrame", TweenInfo.new(1.9833333333333334, Enum.EasingStyle.Linear), CFrame.new(3305.9136, 87.3247, -364.8042, 1, 0, 0, 0, 1, 0, 0, 0, 1)) },
        [2886] = {
            function() -- line: 1154
                -- upvalues: clone (ref)
                local Charge = clone:WaitForChild("Charge")

                for _, descendant in ipairs(Charge:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = false
                    end
                end
            end,
            TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 0.5),
            TweenProperty("Workspace.CutsceneVFX.Wave.CFrame", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), CFrame.new(3459.4167, 87.3247, -358.4828, 1, 0, 0, 0, 1, 0, 0, 0, 1)),
            TweenProperty("Workspace.CurrentCamera.FieldOfView", TweenInfo.new(5.983333333333333, Enum.EasingStyle.Back, Enum.EasingDirection.In), 15)
        },
        [2887] = { TweenProperty("Workspace.CutsceneVFX.Wave.CFrame", TweenInfo.new(1.5, Enum.EasingStyle.Linear), CFrame.new(3375.6699, 87.3247, -358.4828, 1, 0, 0, 0, 1, 0, 0, 0, 1)) },
        [2948] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.48333333333333334, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), 10) },
        [2963] = {
            SetProperty("Lighting.Whitered.Enabled", true),
            TweenProperty("Lighting.Whitered.Saturation", TweenInfo.new(0.23333333333333334, Enum.EasingStyle.Linear), -1.1),
            TweenProperty("Lighting.Whitered.Contrast", TweenInfo.new(0.23333333333333334, Enum.EasingStyle.Linear), 25),
            TweenProperty("Lighting.Whitered.TintColor", TweenInfo.new(0.23333333333333334, Enum.EasingStyle.Linear), Color3.new(1, 0.173412, 0.0980392)),
            TweenProperty("Lighting.Whitered.Brightness", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 2)
        },
        [2969] = { TweenProperty("Lighting.Whitered.Brightness", TweenInfo.new(0.13333333333333333, Enum.EasingStyle.Linear), 15) },
        [2977] = {
            TweenProperty("Workspace.CutsceneVFX.Wave.CFrame", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), CFrame.new(2920.835, 87.3247, -358.4828, 1, 0, 0, 0, 1, 0, 0, 0, 1)),
            TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), 2),
            TweenProperty("Lighting.Whitered.Saturation", TweenInfo.new(1.8, Enum.EasingStyle.Linear), 0),
            TweenProperty("Lighting.Whitered.Contrast", TweenInfo.new(1.8, Enum.EasingStyle.Linear), 0),
            TweenProperty("Lighting.Whitered.TintColor", TweenInfo.new(1.8, Enum.EasingStyle.Linear), Color3.new(1, 1, 1)),
            TweenProperty("Lighting.Whitered.Brightness", TweenInfo.new(1.8, Enum.EasingStyle.Linear), 0)
        },
        [2978] = {
            TweenProperty("Workspace.CutsceneVFX.Wave.CFrame", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), CFrame.new(2920.835, 87.3247, -369.4669, 1, 0, 0, 0, 1, 0, 0, 0, 1)),
            SetProperty("Lighting.Whitered.Enabled", false)
        },
        [2979] = { TweenProperty("Workspace.CutsceneVFX.Wave.CFrame", TweenInfo.new(2, Enum.EasingStyle.Linear), CFrame.new(2570.1248, 87.3247, -369.4669, 1, 0, 0, 0, 1, 0, 0, 0, 1)) },
        [3071] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.4666666666666667, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), 10) },
        [3085] = {
            SetProperty("Lighting.Whitered.Enabled", true),
            TweenProperty("Lighting.Whitered.Saturation", TweenInfo.new(0.23333333333333334, Enum.EasingStyle.Linear), -1.1),
            TweenProperty("Lighting.Whitered.Contrast", TweenInfo.new(0.23333333333333334, Enum.EasingStyle.Linear), 25),
            TweenProperty("Lighting.Whitered.TintColor", TweenInfo.new(0.23333333333333334, Enum.EasingStyle.Linear), Color3.new(1, 0.173412, 0.0980392)),
            TweenProperty("Lighting.Whitered.Brightness", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 2)
        },
        [3091] = { TweenProperty("Lighting.Whitered.Brightness", TweenInfo.new(0.13333333333333333, Enum.EasingStyle.Linear), 15) },
        [3099] = {
            TweenProperty("Workspace.CutsceneVFX.Wave.CFrame", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), CFrame.new(2512.0125, 87.3247, -369.4669, 1, 0, 0, 0, 1, 0, 0, 0, 1)),
            TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), 2),
            TweenProperty("Lighting.Whitered.Saturation", TweenInfo.new(2.1666666666666665, Enum.EasingStyle.Linear), 0),
            TweenProperty("Lighting.Whitered.Contrast", TweenInfo.new(2.1666666666666665, Enum.EasingStyle.Linear), 0),
            TweenProperty("Lighting.Whitered.TintColor", TweenInfo.new(2.1666666666666665, Enum.EasingStyle.Linear), Color3.new(1, 1, 1)),
            TweenProperty("Lighting.Whitered.Brightness", TweenInfo.new(2.1666666666666665, Enum.EasingStyle.Linear), 0)
        },
        [3100] = {
            TweenProperty("Workspace.CutsceneVFX.Wave.CFrame", TweenInfo.new(2.4, Enum.EasingStyle.Linear), CFrame.new(2172.207, 87.3247, -364.1021, 1, 0, 0, 0, 1, 0, 0, 0, 1)),
            SetProperty("Lighting.Whitered.Enabled", false)
        },
        [3106] = { TweenProperty("Lighting.dragondepth.InFocusRadius", TweenInfo.new(1.9333333333333333, Enum.EasingStyle.Linear), 13) }
    }

    t2[3200] = {
        function() -- line: 1369
            -- upvalues: Black (copy), TweenService (copy)
            Black.Visible = true
            Black.BackgroundTransparency = 1
            TweenService:Create(Black, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
                BackgroundTransparency = 0
            }):Play()
            task.delay(2, function() -- line: 1377
                -- upvalues: Black (copy), TweenService (copy)
                TweenService:Create(Black, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
                    BackgroundTransparency = 1
                }):Play()
                task.wait(0.5)
                Black.Visible = false
            end)
        end
    }
    t2[3229] = {
        SetProperty("Lighting.Whitered.Enabled", true),
        TweenProperty("Lighting.Whitered.Saturation", TweenInfo.new(0.23333333333333334, Enum.EasingStyle.Linear), -1.1),
        TweenProperty("Lighting.Whitered.Contrast", TweenInfo.new(0.23333333333333334, Enum.EasingStyle.Linear), 25),
        TweenProperty("Lighting.Whitered.TintColor", TweenInfo.new(0.23333333333333334, Enum.EasingStyle.Linear), Color3.new(1, 0.173412, 0.0980392)),
        TweenProperty("Lighting.Whitered.Brightness", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 2)
    }
    t2[3234] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.13333333333333333, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), 30) }
    t2[3235] = { TweenProperty("Lighting.Whitered.Brightness", TweenInfo.new(0.13333333333333333, Enum.EasingStyle.Linear), 15) }

    return {
        Run = function() -- Run | line: 1431
            -- upvalues: p3 (copy), LoadAnimationIntoRig (copy), DragonEggEventCutscene1 (copy), CutsceneUI (copy), CutsceneMusic (copy), Black (copy), clone (ref), t2 (copy), ContentProvider (copy), Lighting (copy), RunService (copy), TweenService (copy), Workspace (copy), CurrentCamera (copy), LocalPlayer (copy), restoreCamera (copy), hideCharacter (copy)
            Workspace.World.Build:WaitForChild("AAEventProps")

            local t4 = {}

            for _, child in script.LightingAssets:GetChildren() do
                if not Lighting:FindFirstChild(child.Name) then
                    local clone = child:Clone()

                    clone.Parent = Lighting
                    p3:Add(clone)
                    table.insert(t4, clone)
                end
            end

            CutsceneUI.Enabled = true
            Black.BackgroundTransparency = 1
            Black.Visible = true

            local clone2 = script.CutsceneVFX:Clone()

            clone2.Parent = Workspace
            clone = clone2
            p3:Add(clone2)
            TweenService:Create(Black, TweenInfo.new(0.1), {
                BackgroundTransparency = 0
            }):Play()
            p3:Add(function() -- line: 1456
                -- upvalues: Black (copy)
                Black.BackgroundTransparency = 1
                Black.Visible = false
            end)

            local clone3 = DragonEggEventCutscene1:Clone()

            for _, child in clone3:GetChildren() do
                if child:IsA("Model") and child.PrimaryPart then
                    child.PrimaryPart.Anchored = true
                end
            end

            local v5 = hideCharacter(p3)

            clone3.Parent = workspace
            p3:Add(clone3)

            local t5 = {}

            for _, child in clone3:GetChildren() do
                local Animation = child:FindFirstChildOfClass("Animation")

                if Animation then
                    table.insert(t5, Animation)
                end
            end

            ContentProvider:PreloadAsync(t5)

            local t6 = {}

            for _, child in clone3:GetChildren() do
                local Animation = child:FindFirstChildOfClass("Animation")

                if Animation then
                    t6[child] = LoadAnimationIntoRig(child, Animation.AnimationId)
                end
            end

            local v6 = true

            p3:Add(function() -- line: 1496
                -- upvalues: v6 (ref)
                v6 = false
            end)
            p3:Add(function() -- line: 1497
                -- upvalues: v6 (ref), restoreCamera (copy)
                if v6 then
                    restoreCamera()
                end
            end)

            for _, v7 in t6 do
                v7:Play(0)
            end

            local v8 = t6[clone3["Camera Rig"]]

            assert(v8, "Camera Rig needs an Animation")

            local v9 = os.clock() + 2

            while v6 and v8.TimePosition <= 0 and os.clock() < v9 do
                RunService.RenderStepped:Wait()
            end

            local Vignette = CutsceneUI.Vignette

            Vignette.Visible = true
            Vignette.ImageTransparency = 0.1
            TweenService:Create(Vignette, TweenInfo.new(10, Enum.EasingStyle.Linear), {
                ImageTransparency = 1
            }):Play()
            task.delay(10, function() -- line: 1523
            end)
            p3:Add(function() -- line: 1527
                -- upvalues: Vignette (copy)
                Vignette.Visible = false
                Vignette.ImageTransparency = 1
            end)
            TweenService:Create(Black, TweenInfo.new(0.3), {
                BackgroundTransparency = 1
            }):Play()
            task.delay(0.3, function() -- line: 1533
                -- upvalues: Black (copy)
                Black.Visible = false
            end)
            CutsceneMusic:Play()

            local Cam = clone3["Camera Rig"].Cam
            local connection

            connection = RunService.RenderStepped:Connect(function() -- line: 1542
                -- upvalues: v6 (ref), Cam (copy), connection (ref), CurrentCamera (copy), LocalPlayer (copy)
                if not v6 then
                    connection:Disconnect()

                    return
                end

                CurrentCamera.CameraType = Enum.CameraType.Scriptable
                LocalPlayer.ReplicationFocus = Cam
                CurrentCamera.Focus = Cam.CFrame
                CurrentCamera.CFrame = Cam.CFrame
            end)

            local t7 = {}
            local n1 = 0
            local n2 = 0.1
            local connection2 = RunService.Heartbeat:Connect(function(p9) -- line: 1556
                -- upvalues: t6 (copy), t7 (copy), n1 (ref), n2 (ref), CutsceneMusic (copy), t2 (copy)
                n1 += p9
                n2 -= 0.1

                if n2 <= 0 then
                    n2 = 0.1

                    for _, v10 in t6 do
                        if v10.IsPlaying then
                            local v12 = n1

                            if math.abs(v12 - v10.TimePosition) >= 0.1 then
                                local function v13() -- line: 1568
                                    -- upvalues: v10 (copy), n1 (ref)
                                    v10.TimePosition = n1
                                end

                                local _warn = warn

                                xpcall(v13, _warn)
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
                    local v15 = math.floor(n1 * 60 - i)

                    if t2[v15] and not t7[v15] then
                        t7[v15] = true

                        for _, v16 in t2[v15] do
                            task.spawn(v16)
                        end
                    end
                end
            end)

            p3:Add(connection2)
            task.wait(55.083333333333336)
            connection2:Disconnect()

            local function v17() -- line: 1598
                -- upvalues: clone2 (copy)
                clone2:Destroy()
            end

            local _warn = warn

            xpcall(v17, _warn)
            v6 = false
            Vignette.Visible = false

            local function v18() -- line: 1604
                -- upvalues: t4 (copy)
                for _, v19 in t4 do
                    v19:Destroy()
                end
            end

            local _warn2 = warn

            xpcall(v18, _warn2)

            local function v20() -- line: 1610
                -- upvalues: clone3 (copy)
                clone3:Destroy()
            end

            local _warn3 = warn

            xpcall(v20, _warn3)

            local _warn4 = warn

            xpcall(restoreCamera, _warn4)
            v5()

            local function v21() -- line: 1614
                -- upvalues: TweenService (copy), Workspace (copy)
                task.spawn(function() -- line: 1615
                    -- upvalues: TweenService (copy), Workspace (copy)
                    TweenService:Create(Workspace:WaitForChild("DragonEggEventMusic", 15), TweenInfo.new(1), {
                        Volume = 0.5
                    }):Play()
                end)
            end

            pcall(v21)
        end
    }
end
